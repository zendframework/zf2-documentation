.. _zend.filter.inflector:

Zend_Filter_Inflector
=====================

``Zend_Filter_Inflector`` は、指定したターゲットに対して
ルールにもとづいた文字列変換を行うための汎用的なツールです。

たとえば、MixedCase あるいは camelCase
形式の単語をパス形式に変換したりするような作業を行います。 読みやすさや OS
のポリシーなどの理由で、小文字への変換を行ったりダッシュ ('-')
で単語を区切ったりといったこともあるでしょう。
インフレクタは、このような作業を行うことができます。

``Zend_Filter_Inflector`` は ``Zend_Filter_Interface`` を実装しています。
インフレクションを実行するには、オブジェクトのインスタンスで ``filter()``
をコールします。

.. _zend.filter.inflector.camel_case_example:

.. rubric:: MixedCase あるいは camelCase のテキストを別形式に変換する

.. code-block:: php
   :linenos:

   $inflector = new Zend_Filter_Inflector('pages/:page.:suffix');
   $inflector->setRules(array(
       ':page'  => array('Word_CamelCaseToDash', 'StringToLower'),
       'suffix' => 'html'
   ));

   $string   = 'camelCasedWords';
   $filtered = $inflector->filter(array('page' => $string));
   // pages/camel-cased-words.html

   $string   = 'this_is_not_camel_cased';
   $filtered = $inflector->filter(array('page' => $string));
   // pages/this_is_not_camel_cased.html

.. _zend.filter.inflector.operation:

操作
--

インフレクタには、ひとつの **ターゲット** とひとつあるいは複数の **ルール**
が必要です。
ターゲットは基本的に文字列であり、置き換えを行うプレースホルダを定義します。
プレースホルダは、先頭に ':' をつけて **:script** のように定義します。

``filter()`` をコールするときに、 ターゲット内の変数に対応する キー/値
のペアを配列で渡します。

ターゲット内の個々の変数に対して、ゼロ個以上のルールを関連づけることができます。
ルールとして指定できるのは、 **静的な** ルールか ``Zend_Filter``
クラスです。静的なルールは、 指定されたテキストで置き換えを行います。
それ以外の場合は、ルールで指定されたクラスを使用してテキストを変換します。
クラスを指定する際には、共通のプレフィックスを除いた短いクラス名を使用します。

たとえば ``Zend_Filter`` の具象実装クラスなら何でも使用可能です。
しかし、これを使用する際には 'Zend_Filter_Alpha' あるいは 'Zend_Filter_StringToLower'
とするのではなく単に 'Alpha' あるいは 'StringToLower' だけで指定するということです。

.. _zend.filter.inflector.paths:

その他のフィルタ向けのパスの設定
----------------

``Zend_Filter_Inflector`` は、 ``Zend_Loader_PluginLoader``
を使用してインフレクションに使用するフィルタの読み込みを行います。
デフォルトでは、 ``Zend_Filter`` で始まる任意のフィルタを使用できます。
このプレフィックスで始まるけれどももっと深い階層にあるフィルタ、たとえば Word
系のフィルタなどを使用したい場合は、プレフィックス ``Zend_Filter``
を除いた名前を指定します。

.. code-block:: php
   :linenos:

   // ルールとして Zend_Filter_Word_CamelCaseToDash を使用します
   $inflector->addRules(array('script' => 'Word_CamelCaseToDash'));

別のパスを使用するには、プラグインローダへのプロキシとして ``Zend_Filter_Inflector``
のユーティリティメソッド ``addFilterPrefixPath()`` を使用します。

.. code-block:: php
   :linenos:

   $inflector->addFilterPrefixPath('My_Filter', 'My/Filter/');

あるいは、プラグインローダをインフレクタから取得して、
それを直接操作することもできます。

.. code-block:: php
   :linenos:

   $loader = $inflector->getPluginLoader();
   $loader->addPrefixPath('My_Filter', 'My/Filter/');

フィルタのパスを変更するための詳細なオプションは、 :ref:`PluginLoader
のドキュメント <zend.loader.pluginloader>` を参照ください。

.. _zend.filter.inflector.targets:

インフレクタのターゲットの設定
---------------

インフレクタのターゲットは、変数用のプレースホルダを含む文字列となります。
プレースホルダは、先頭に識別子をつけて表します。 デフォルトの識別子はコロン
(':') です。 そしてその後に変数名を続け、たとえば ':script' や ':path'
のようになります。 ``filter()``
メソッドは、識別子の後に続く変数を探して置換します。

識別子を変更するには ``setTargetReplacementIdentifier()`` メソッドを使用するか、
コンストラクタの 3 番目の引数で指定します。

.. code-block:: php
   :linenos:

   // コンストラクタ経由
   $inflector = new Zend_Filter_Inflector('#foo/#bar.#sfx', null, '#');

   // アクセサ経由
   $inflector->setTargetReplacementIdentifier('#');

普通はコンストラクタでターゲットを指定することになるでしょう。
しかし、あとでターゲットを設定しなおしたくなることもあるかもしれません
(たとえば、 ``ViewRenderer`` や ``Zend_Layout``
といったコアコンポーネントのデフォルトのインフレクタを変更したい場合など)。
この際に使用できるのが ``setTarget()`` です。

.. code-block:: php
   :linenos:

   $inflector = $layout->getInflector();
   $inflector->setTarget('layouts/:script.phtml');

さらに、クラスのメンバーを用意して
インフレクタのターゲットを変更できるようにしたくなるかもしれません。
毎回直接ターゲットを変更する必要がなくなる (メソッドコールを少なくできる)
からです。 そのためには ``setTargetReference()`` を使用します。

.. code-block:: php
   :linenos:

   class Foo
   {
       /**
        * @var string インフレクタのターゲット
        */
       protected $_target = 'foo/:bar/:baz.:suffix';

       /**
        * コンストラクタ
        * @return void
        */
       public function __construct()
       {
           $this->_inflector = new Zend_Filter_Inflector();
           $this->_inflector->setTargetReference($this->_target);
       }

       /**
        * ターゲットを設定してインフレクタのターゲットを更新します
        *
        * @param  string $target
        * @return Foo
        */
       public function setTarget($target)
       {
           $this->_target = $target;
           return $this;
       }
   }

.. _zend.filter.inflector.rules:

インフレクションのルール
------------

先ほど説明したように、静的なルールとフィルタを使用したルールのふたつがあります。

.. note::

   インフレクタにメソッドを追加するときに
   ひとつずつ追加したとしても一度に追加したとしても、
   その順番が重要となることに注意しましょう。
   より細かい名前、あるいは他のルール名を含む名前などを先に追加するようにしなければなりません。
   たとえば、ふたつのフール 'moduleDir' と 'module' があった場合、'moduleDir' のほうが
   module より前になければなりません。 というのも 'module' は 'moduleDir'
   の中に含まれるからです。 'module' を 'moduleDir' より前に追加すると 'module' が
   'moduleDir' の一部にもマッチしてしまい、 'Dir'
   の部分はインフレクションの対象から外れてしまいます。

.. _zend.filter.inflector.rules.static:

静的なルール
^^^^^^

静的なルールは、単なる文字列の置換を行います。 これは、ターゲットの中の、
ほぼ固定であるが開発者が変更できるようにさせたい部分などに使用します。
``setStaticRule()`` メソッドを使用して、ルールの設定や変更を行います。

.. code-block:: php
   :linenos:

   $inflector = new Zend_Filter_Inflector(':script.:suffix');
   $inflector->setStaticRule('suffix', 'phtml');

   // あとで変更します
   $inflector->setStaticRule('suffix', 'php');

ターゲットと同様、静的ルールも参照で指定できます。
これにより、メソッドコールをせずに変数を更新するだけでルールを変更できるようになります。
これは、クラスの中で内部的にインフレクタを使用している場合に便利です。
ユーザにいちいちインフレクタを取得させる必要がなくなります。
これを実現するために使用するのが ``setStaticRuleReference()`` メソッドです。

.. code-block:: php
   :linenos:

   class Foo
   {
       /**
        * @var string サフィックス
        */
       protected $_suffix = 'phtml';

       /**
        * コンストラクタ
        * @return void
        */
       public function __construct()
       {
           $this->_inflector = new Zend_Filter_Inflector(':script.:suffix');
           $this->_inflector->setStaticRuleReference('suffix', $this->_suffix);
       }

       /**
        * サフィックスを設定し、インフレクタの静的ルールを更新します
        *
        * @param  string $suffix
        * @return Foo
        */
       public function setSuffix($suffix)
       {
           $this->_suffix = $suffix;
           return $this;
       }
   }

.. _zend.filter.inflector.rules.filters:

Filter Inflector ルール
^^^^^^^^^^^^^^^^^^^^

``Zend_Filter`` のフィルタ群も、インフレクタのルールとして使用できます。
静的なルールと同様、こちらもターゲットの変数にバインドされます。
静的なルールとは異なり、複数のフィルタによるインフレクションを行うこともあります。
これらのフィルタは順番に処理されるので、
最終的にほしいデータを考慮してフィルタの登録順を決めるようにしましょう。

ルールを追加するには、 ``setFilterRule()``
(その変数に対する既存のルールをすべて上書きします) あるいは ``addFilterRule()``
(その変数に対する既存のルールを保持し、 新たなルールを最後に追加します)
を使用します。 フィルタは、以下のいずれかの形式で指定します。

- **文字列**\ 。 フィルタのクラス名、あるいはクラス名からプレフィックス
  (インフレクタのプラグインローダーで登録されたもの。 デフォルトは 'Zend_Filter')
  を取り除いた部分となります。

- **Filter オブジェクト**\ 。 ``Zend_Filter_Interface``
  を実装した任意のオブジェクトのインスタンスをフィルタとして渡せます。

- **配列**\ 。 上で説明した文字列やフィルタオブジェクトを配列にしたものです。

.. code-block:: php
   :linenos:

   $inflector = new Zend_Filter_Inflector(':script.:suffix');

   // ルールとして Zend_Filter_Word_CamelCaseToDash フィルタを使用するように設定します
   $inflector->setFilterRule('script', 'Word_CamelCaseToDash');

   // 文字列を小文字変換するルールを追加します
   $inflector->addFilterRule('script', new Zend_Filter_StringToLower());

   // 複数のルールを一括して指定します
   $inflector->setFilterRule('script', array(
       'Word_CamelCaseToDash',
       new Zend_Filter_StringToLower()
   ));

.. _zend.filter.inflector.rules.multiple:

多くのルールを一度に設定する
^^^^^^^^^^^^^^

一般に、各変数に対して個別にインフレクタルールを設定するよりも、
一括してルールを設定できたほうが楽でしょう。 ``Zend_Filter_Inflector`` の ``addRules()``
メソッドや ``setRules()`` メソッドを使用すると、 一括設定できます。

それぞれのメソッドには、変数/ルール のペアの配列を指定します。
ルールには、(文字列、フィルタオブジェクトあるいはその配列などの)
いずれの形式でも指定できます。変数名には特別な記法を用い、
それによって静的ルールとフィルタルールを切り替えます。
使用する記法は次のとおりです。

- **':' プレフィックス**: フィルタルール。

- **プレフィックスなし**: 静的ルール。

.. _zend.filter.inflector.rules.multiple.example:

.. rubric:: 複数のルールの一括設定

.. code-block:: php
   :linenos:

   // Could also use setRules() with this notation:
   $inflector->addRules(array(
       // フィルタルール
       ':controller' => array('CamelCaseToUnderscore','StringToLower'),
       ':action'     => array('CamelCaseToUnderscore','StringToLower'),

       // 静的なルール
       'suffix'      => 'phtml'
   ));

.. _zend.filter.inflector.utility:

ユーティリティメソッド
-----------

``Zend_Filter_Inflector`` のユーティリティメソッド群には、
プラグインローダーの取得や設定、 ルールの操作や取得、
例外をスローするかどうかやその時期の設定といったことを行えるものがあります。

- ``setPluginLoader()`` は、 独自のプラグインローダーを設定してそれを
  ``Zend_Filter_Inflector`` で使いたい場合に使用します。 ``getPluginLoader()`` は、
  現在設定されているプラグインローダーを取得します。

- ``setThrowTargetExceptionsOn()`` は、
  指定した置換識別子がターゲットで見つからなかった場合に ``filter()``
  が例外をスローするかどうかを設定します。
  デフォルトでは、例外は一切スローされません。 ``isThrowTargetExceptionsOn()`` は、
  現在の設定状態を返します。

- ``getRules($spec = null)`` は、
  すべての変数に登録されているすべてのルールを返します。
  あるいは、指定した変数について登録されているルールだけを返します。

- ``getRule($spec, $index)`` は、 指定した変数のひとつのルールを取得します。
  これは、ある変数に対するルールを定義したフィルタチェインから
  特定のフィルタを取り出したい場合に便利です。 ``$index`` は必須です。

- ``clearRules()`` は、 現在登録されているルールをすべてクリアします。

.. _zend.filter.inflector.config:

Zend_Filter_Inflector での Zend_Config の使用法
-----------------------------------------

``Zend_Config`` を使用してルールを設定したり、
フィルタのプレフィックスのパスやその他のインフレクタの状態を設定できます。
そのためには、 ``Zend_Config`` オブジェクトをコンストラクタあるいは ``setOptions()``
に渡します。 設定可能な項目は以下のとおりです。

- ``target`` は、インフレクションのターゲットを指定します。

- ``filterPrefixPath`` は、 インフレクタが使用するフィルタの プレフィックス/パス
  のペアを指定します。

- ``throwTargetExceptionsOn`` は、
  インフレクション処理の後にまだ置換識別子が残っていた場合に
  例外をスローするかどうかを boolean 値で指定します。

- ``targetReplacementIdentifier`` は、
  ターゲット文字列内で置換変数を表すために使用する文字を指定します。

- ``rules`` は、インフレクションルールの配列を指定します。
  値、あるいは値の配列をキーに指定し、 ``addRules()`` と同じ形式となります。

.. _zend.filter.inflector.config.example:

.. rubric:: Zend_Filter_Inflector での Zend_Config の使用法

.. code-block:: php
   :linenos:

   // コンストラクタで
   $config    = new Zend_Config($options);
   $inflector = new Zend_Filter_Inflector($config);

   // あるいは setOptions() で
   $inflector = new Zend_Filter_Inflector();
   $inflector->setOptions($config);


