.. _zend.form.forms:

Zend_Form によるフォームの作成
====================

``Zend_Form`` クラスは、フォームの要素や
表示グループ、そしてサブフォームの集約を行います。
そして、その要素に対して次のような操作を行います。

- 入力の検証、エラーコードやメッセージの取得

- 値の集約 (すべての項目についてのフィルタリング前/
  フィルタリング後の値の取得など)

- すべての項目についての反復処理。
  登録した順、あるいは各項目から取得した順序ヒントに従った順での処理

- フォーム全体のレンダリング。デコレータでレンダリング方法をカスタマイズしたり、
  フォームの各項目を順次処理したりなど

``Zend_Form`` で作成したフォームが複雑なものになることもありますが、
シンプルなフォームで使用するのがもっともよくある使用例でしょう。
手早いアプリケーション開発 (RAD) やプロトタイピングでの使用に最適です。

もっとも基本的な使用法は、単にフォームオブジェクトを作成するものです。

.. code-block:: php
   :linenos:

   // 汎用的なフォームオブジェクト
   $form = new Zend_Form();

   // 独自のフォームオブジェクト
   $form = new My_Form()

``Zend_Config`` のインスタンスあるいは配列で設定を渡すことができます。
これを使用すると、オブジェクトの状態を設定したり新しい要素を作成したりできます。

.. code-block:: php
   :linenos:

   // 設定オプションを渡します
   $form = new Zend_Form($config);

``Zend_Form`` は順次処理が可能です。
各要素や表示グループ、サブフォームごとに処理できます。
処理順は、登録した順番および各項目に設定されている順番となります。
これは、各要素のレンダリングを適切な順で行いたいときに便利です。

``Zend_Form`` は、要素や表示グループのファクトリとして使用できると同時に
デコレータで自分自身をレンダリングすることもできます。

.. _zend.form.forms.plugins:

プラグインローダー
---------

``Zend_Form`` では、 ``Zend_Loader_PluginLoader`` を使用することで
別の要素やデコレータの位置を指定できます。
それぞれにプラグインローダーを関連づけることができ、
汎用的なアクセサを使用してそれを取得したり変更したりします。

使用できるローダーの型は 'element' と 'decorator'
です。さまざまなプラグインローダーメソッドが用意されています。
型の名前は大文字小文字を区別しません。

プラグインローダーで使用できるメソッドは、次のとおりです。

- ``setPluginLoader($loader, $type)``: $loader はプラグインローダーオブジェクトで、type
  は先ほど説明した型のいずれかです。 これは、指定した型のプラグインローダーを
  指定したローダーオブジェクトに設定します。

- ``getPluginLoader($type)``: $type に関連づけられたプラグインローダーを取得します。

- ``addPrefixPath($prefix, $path, $type = null)``: プレフィックスとパスの関連づけを、$type
  で指定したローダーに指定します。 $type が ``NULL``
  の場合はそのパスをすべてのローダーに追加します。この場合、
  プレフィックスの後に "\_Element" および "\_Decorator" を追加し、パスに "Element/" および
  "Decorator/"
  を追加します。追加のフォーム要素クラス群をすべて同じ階層に配置した場合は、
  このメソッドを使用すると簡単に基底プレフィックスを設定できます。

- ``addPrefixPaths(array $spec)``:
  複数のパスを、ひとつあるは複数のプラグインローダーに一度に追加します。
  配列の各要素は、キー 'path'、'prefix' および 'type' を持つ配列となります。

さらに、 ``Zend_Form``
のインスタンスで作成したすべての要素や表示グループ用のプレフィックスパスを設定するには
次のメソッドを使用します。

- ``addElementPrefixPath($prefix, $path, $type = null)``: ``addPrefixPath()`` と同じですが、
  クラスのプレフィックスとパスを指定しなければなりません。 *$type*
  を指定する場合は、それは ``Zend_Form_Element``
  で指定したプラグインローダーの型のひとつでなければなりません。 *$type*
  にどんな値が指定できるのかについては :ref:`要素のプラグインのセクション
  <zend.form.elements.loaders>` を参照ください。 *$type* を省略した場合は、
  すべての型で用いる全般的なプレフィックスとみなします。

- ``addDisplayGroupPrefixPath($prefix, $path)``: ``addPrefixPath()`` と似ていますが、
  クラスのプレフィックスとパスを指定しなければなりません。
  しかし、表示グループではプラグインとして対応しているのはデコレータだけなので、
  *$type* は不要です。

独自の要素やデコレータを使用すると、 複数フォーム間で機能を共有したり
独自の機能をカプセル化したりできるようになります。
独自の要素を既存の標準クラスに置き換えて使用する例については、
要素のドキュメントの中の :ref:`独自のラベルを作る例 <zend.form.elements.loaders.customLabel>`
を参照ください。

.. _zend.form.forms.elements:

要素
--

``Zend_Form`` では、フォームに要素を追加したり
フォームから要素を削除したりするためのアクセサを提供しています。
これらは要素オブジェクトのインスタンスを受け取ることもできますし、
ファクトリとして要素オブジェクトのインスタンスを作成させることもできます。

要素を追加するもっとも基本的なメソッドが ``addElement()`` です。 このメソッドは、
``Zend_Form_Element`` 型 (あるいは ``Zend_Form_Element`` を継承したクラス) のオブジェクト
あるいは新しい要素を作成するための引数 (要素の型や名前、設定オプション)
を受け取ります。

例を示します。

.. code-block:: php
   :linenos:

   // 要素のインスタンスを使用します
   $element = new Zend_Form_Element_Text('foo');
   $form->addElement($element);

   // ファクトリを使用します
   //
   // Zend_Form_Element_Text 型で
   // 'foo' という名前の要素を作成します
   $form->addElement('text', 'foo');

   // 要素の label オプションを渡します
   $form->addElement('text', 'foo', array('label' => 'Foo:'));

.. note::

   **addElement() における「流れるようなインターフェイス」の実装**

   ``addElement()`` は「流れるようなインターフェイス」
   を実装しています。つまり、このメソッドは要素ではなく ``Zend_Form``
   オブジェクトを返すということです。 これによって、複数の addElement()
   メソッドやその他のフォームメソッド (``Zend_Form``
   のすべてのセッターは流れるようなインターフェイスを実装しています)
   を連結させることができます。

   単に要素を返してほしい場合は、 ``createElement()`` を使いましょう。
   概要は以下で説明します。しかし、 ``createElement()``
   は要素をフォームにアタッチしないことに注意しましょう。

   内部的には、 ``addElement()`` は実際には ``createElement()``
   をコールして作成した要素をフォームにアタッチしています。

要素をフォームに追加したら、名前を指定してそれを取得できます。 取得するには、
``getElement()`` メソッドを使用するか
オブジェクトのプロパティとして要素にアクセスします。 property:

.. code-block:: php
   :linenos:

   // getElement():
   $foo = $form->getElement('foo');

   // オブジェクトのプロパティとして
   $foo = $form->foo;

時には、フォームにアタッチせずに要素を作成したいこともあるでしょう
(フォームに登録されているさまざまなプラグインパスを使いたいけれど、
そのオブジェクトは後でサブフォームにアタッチしたい場合など)。 そんな場合は
``createElement()`` メソッドを使用します。

.. code-block:: php
   :linenos:

   // $username は Zend_Form_Element_Text オブジェクトとなります
   $username = $form->createElement('text', 'username');

.. _zend.form.forms.elements.values:

値の設定と取得
^^^^^^^

フォームの検証をすませたら、通常は値を取得することになるでしょう。
その値を用いてデータベースの更新なりウェブサービスの操作なりといった作業を行います。
すべての要素の値を取得するには ``getValues()`` を使用します。 ``getValue($name)``
を使用すると、 要素名を指定して特定の要素の値を取得できます。

.. code-block:: php
   :linenos:

   // すべての値を取得します
   $values = $form->getValues();

   // 'foo' 要素の値のみを取得します
   $value = $form->getValue('foo');

レンダリング前に、フォームに特定の値を設定したいこともあるでしょう。
これを行うには ``setDefaults()`` メソッドあるいは ``populate()`` メソッドを使用します。

.. code-block:: php
   :linenos:

   $form->setDefaults($data);
   $form->populate($data);

逆に、値を設定したり検証したりした後でフォームをクリアしたいこともあるでしょう。
これを行うには ``reset()`` メソッドを使用します。

.. code-block:: php
   :linenos:

   $form->reset();

.. _zend.form.forms.elements.global:

グローバルな操作
^^^^^^^^

時には、すべての要素に対して何らかの操作を行いたくなることもあります。
ありがちな例としては、すべての要素に対してプラグインのプレフィックスを設定したり
デコレータを設定したり、フィルタを設定したりといったものがあります。
以下に例を示します。

.. _zend.form.forms.elements.global.allpaths:

.. rubric:: すべての要素に対するプレフィックスパスの設定

型を指定してすべての要素に対するプレフィックスパスを設定したり、
グローバルプレフィックスを使用したりする例です。

.. code-block:: php
   :linenos:

   // グローバルプレフィックスパスの設定:
   // プレフィックス My_Foo_Filter、My_Foo_Validate、
   // My_Foo_Decorator のパスを作成します。
   $form->addElementPrefixPath('My_Foo', 'My/Foo/');

   // フィルタのパスのみ:
   $form->addElementPrefixPath('My_Foo_Filter',
                               'My/Foo/Filter',
                               'filter');

   // バリデータのパスのみ:
   $form->addElementPrefixPath('My_Foo_Validate',
                               'My/Foo/Validate',
                               'validate');

   // デコレータのパスのみ:
   $form->addElementPrefixPath('My_Foo_Decorator',
                               'My/Foo/Decorator',
                               'decorator');

.. _zend.form.forms.elements.global.decorators:

.. rubric:: すべての要素に対するデコレータの設定

すべての要素に対するデコレータを設定できます。 ``setElementDecorators()`` に
``setDecorators()`` と同じようなデコレータの配列を渡すと、
各要素にそれまで設定されていたすべてのデコレータを上書きします。
この例では、単純に ViewHelper デコレータと Label デコレータを設定します。

.. code-block:: php
   :linenos:

   $form->setElementDecorators(array(
       'ViewHelper',
       'Label'
   ));

.. _zend.form.forms.elements.global.decoratorsFilter:

.. rubric:: いくつかの要素に対するデコレータの設定

設定したい要素、あるいは設定したくない要素を指定することで、
一部の要素にだけデコレータを設定することもできます。 ``setElementDecorators()`` の 2
番目の引数に要素名の配列を指定します。
デフォルトでは、ここで指定した要素にのみデコレータが設定されます。 3
番目の引数を渡すこともできます。
これは、設定「したい」要素なのか設定「したくない」
要素なのかを表すフラグとなります。 ``FALSE`` を渡すと、指定した **以外の**
すべての要素にデコレータを設定します。 このメソッドの標準的な使用法と同様、
各要素にそれまで設定されていたすべてのデコレータを上書きします。

次の例は、 ViewHelper デコレータと Label デコレータを 要素 'foo' および 'bar'
に対してのみ使用するものです。

.. code-block:: php
   :linenos:

   $form->setElementDecorators(
       array(
           'ViewHelper',
           'Label'
       ),
       array(
           'foo',
           'bar'
       )
   );

一方、この例では、ViewHelper デコレータと Label デコレータを 'foo' と 'bar'**以外の**
すべての要素に対して使用します。

.. code-block:: php
   :linenos:

   $form->setElementDecorators(
       array(
           'ViewHelper',
           'Label'
       ),
       array(
           'foo',
           'bar'
       ),
       false
   );

.. note::

   **要素によっては不適切なデコレータもある**

   ``setElementDecorators()``
   はよい方法に見えますが、時には予期せぬ結果を引き起こすこともあります。
   たとえば、ボタン系の要素 (Submit, Button, Reset)
   では現在ラベルをボタンの値として使用しています。 そして ViewHelper デコレータや
   DtDdWrapper デコレータは、
   余計なラベルやエラー、ヒントをレンダリングしないためにのみ用います。
   上の例ではいくつかのラベルが重複してしまいます。

   先ほどの例に示したように、設定したい要素/したくない要素
   を配列で指定するようにすれば、この問題を回避できます。

   したがって、このメソッドは注意して使うようにしましょう。
   場合によっては、いくつかの要素を除外するか、
   そののデコレータを変更して予期せぬ結果を防ぐ必要があります。

.. _zend.form.forms.elements.global.filters:

.. rubric:: すべての要素に対するフィルタの設定

すべての要素に対して同じフィルタを適用したくなることもよくあります。
たとえば、すべての値を ``trim()`` するなどです。

.. code-block:: php
   :linenos:

   $form->setElementFilters(array('StringTrim'));

.. _zend.form.forms.elements.methods:

要素を操作するためのメソッド
^^^^^^^^^^^^^^

次のメソッドを使用して、要素を操作します。

- ``createElement($element, $name = null, $options = null)``

- ``addElement($element, $name = null, $options = null)``

- ``addElements(array $elements)``

- ``setElements(array $elements)``

- ``getElement($name)``

- ``getElements()``

- ``removeElement($name)``

- ``clearElements()``

- ``setDefaults(array $defaults)``

- ``setDefault($name, $value)``

- ``getValue($name)``

- ``getValues()``

- ``getUnfilteredValue($name)``

- ``getUnfilteredValues()``

- ``setElementFilters(array $filters)``

- ``setElementDecorators(array $decorators)``

- ``addElementPrefixPath($prefix, $path, $type = null)``

- ``addElementPrefixPaths(array $spec)``

.. _zend.form.forms.displaygroups:

表示グループ
------

表示グループを使用すると、複数の要素を仮想的にグループ化して
表示させることができます。
フォーム内の各要素に対しては名前を指定してアクセスできますが、
フォームの要素を順次処理したりレンダリングしたりするときは
表示グループは一括して扱われます。 表示グループのもっとも一般的な使用例は、
フィールドセット内の要素をグループ化することです。

表示グループの基底クラスは ``Zend_Form_DisplayGroup`` です。
このクラスのインスタンスを直接作成することもできますが、 一般的には ``Zend_Form``
の ``addDisplayGroup()`` メソッドでインスタンスを作成することになります。
このメソッドの最初の引数には要素の配列を渡し、 表示グループの名前を 2
番目の引数で指定します。 オプションの 3 番目の引数で、設定の配列や ``Zend_Config``
オブジェクトを渡すこともできます。

'username' と 'password' という要素がすでにフォームに登録済みである場合に、
次のコードを使用するとそれらを表示グループ 'login' にまとめることができます。

.. code-block:: php
   :linenos:

   $form->addDisplayGroup(array('username', 'password'), 'login');

表示グループにアクセスするには、 ``getDisplayGroup()`` メソッドを使用するか
あるいは表示グループ名を指定します。

.. code-block:: php
   :linenos:

   // getDisplayGroup() の使用
   $login = $form->getDisplayGroup('login');

   // オーバーロードの使用
   $login = $form->login;

.. note::

   **読み込み不要なデフォルトのデコレータ**

   デフォルトのデコレータは、
   オブジェクトの初期化時に読み込まれるようになっています。
   この機能を無効にするには、表示グループの作成時にオプション
   'disableLoadDefaultDecorators' を指定します。

   .. code-block:: php
      :linenos:

      $form->addDisplayGroup(
          array('foo', 'bar'),
          'foobar',
          array('disableLoadDefaultDecorators' => true)
      );

   このオプションは、他のオプションと混用することもできます。
   その場合はオプションの配列や ``Zend_Config`` オブジェクトを使用します。

.. _zend.form.forms.displaygroups.global:

グローバルな操作
^^^^^^^^

要素と同様、表示グループに対しても全体に共通の操作があるでしょう。
デコレータを設定したり、デコレータを探すプラグインパスを設定したりといったものです。

.. _zend.form.forms.displaygroups.global.paths:

.. rubric:: すべての表示グループに対するデコレータプレフィックスパスの設定

デフォルトでは、表示グループはフォームが使用しているデコレータパスを継承します。
別の場所を探すようにしたい場合は ``addDisplayGroupPrefixPath()`` メソッドを使用します。

.. code-block:: php
   :linenos:

   $form->addDisplayGroupPrefixPath('My_Foo_Decorator', 'My/Foo/Decorator');

.. _zend.form.forms.displaygroups.global.decorators:

.. rubric:: すべての表示グループに対するデコレータの設定

すべての表示グループに対するデコレータを設定できます。 ``setDisplayGroupDecorators()``
に ``setDecorators()`` と同じようなデコレータの配列を渡すと、
各表示グループにそれまで設定されていたすべてのデコレータを上書きします。
この例では、単純に fieldset デコレータ (FormElements
デコレータは、要素を順次処理するために必須です) を設定します。

.. code-block:: php
   :linenos:

   $form->setDisplayGroupDecorators(array(
       'FormElements',
       'Fieldset'
   ));

.. _zend.form.forms.displaygroups.customClasses:

独自の表示グループクラスの使用
^^^^^^^^^^^^^^^

デフォルトでは、 ``Zend_Form`` は 表示グループ用に ``Zend_Form_DisplayGroup``
クラスを使用します。
このクラスを継承すれば、独自の機能を持つクラスを作成できます。 ``addDisplayGroup()``
には具象インスタンスを渡すことはできませんが、
どのクラスを使用するのかをオプションで指定できます。 このときに使用するキーは
'displayGroupClass' です。

.. code-block:: php
   :linenos:

   // 'My_DisplayGroup' クラスを使用します
   $form->addDisplayGroup(
       array('username', 'password'),
       'user',
       array('displayGroupClass' => 'My_DisplayGroup')
   );

そのクラスがまだ読み込まれていない場合は、 ``Zend_Form`` は ``Zend_Loader``
を使ってクラスを読み込みます。

デフォルトの表示グループクラスを指定し、
そのフォームオブジェクトで作成するすべての表示グループで
同じクラスを使わせることもできます。

.. code-block:: php
   :linenos:

   // すべての表示グループで 'My_DisplayGroup' クラスを使用します
   $form->setDefaultDisplayGroupClass('My_DisplayGroup');

これは、設定項目 'defaultDisplayGroupClass' で指定することもできます。
そうすれば、事前にこのクラスが読み込まれて
すべての表示グループでこのクラスを使うようになります。

.. _zend.form.forms.displaygroups.interactionmethods:

表示グループを操作するためのメソッド
^^^^^^^^^^^^^^^^^^

次のメソッドを使用して、表示グループを操作します。

- ``addDisplayGroup(array $elements, $name, $options = null)``

- ``addDisplayGroups(array $groups)``

- ``setDisplayGroups(array $groups)``

- ``getDisplayGroup($name)``

- ``getDisplayGroups()``

- ``removeDisplayGroup($name)``

- ``clearDisplayGroups()``

- ``setDisplayGroupDecorators(array $decorators)``

- ``addDisplayGroupPrefixPath($prefix, $path)``

- ``setDefaultDisplayGroupClass($class)``

- ``getDefaultDisplayGroupClass($class)``

.. _zend.form.forms.displaygroups.methods:

Zend_Form_DisplayGroup のメソッド
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Form_DisplayGroup`` には次のようなメソッドがあります。 タイプ別にまとめます。

- 設定

  - ``setOptions(array $options)``

  - ``setConfig(Zend_Config $config)``

- メタデータ

  - ``setAttrib($key, $value)``

  - ``addAttribs(array $attribs)``

  - ``setAttribs(array $attribs)``

  - ``getAttrib($key)``

  - ``getAttribs()``

  - ``removeAttrib($key)``

  - ``clearAttribs()``

  - ``setName($name)``

  - ``getName()``

  - ``setDescription($value)``

  - ``getDescription()``

  - ``setLegend($legend)``

  - ``getLegend()``

  - ``setOrder($order)``

  - ``getOrder()``

- 要素

  - ``createElement($type, $name, array $options = array())``

  - ``addElement($typeOrElement, $name, array $options = array())``

  - ``addElements(array $elements)``

  - ``setElements(array $elements)``

  - ``getElement($name)``

  - ``getElements()``

  - ``removeElement($name)``

  - ``clearElements()``

- プラグインローダー

  - ``setPluginLoader(Zend_Loader_PluginLoader $loader)``

  - ``getPluginLoader()``

  - ``addPrefixPath($prefix, $path)``

  - ``addPrefixPaths(array $spec)``

- デコレータ

  - ``addDecorator($decorator, $options = null)``

  - ``addDecorators(array $decorators)``

  - ``setDecorators(array $decorators)``

  - ``getDecorator($name)``

  - ``getDecorators()``

  - ``removeDecorator($name)``

  - ``clearDecorators()``

- レンダリング

  - ``setView(Zend_View_Interface $view = null)``

  - ``getView()``

  - ``render(Zend_View_Interface $view = null)``

- I18n

  - ``setTranslator(Zend_Translator_Adapter $translator = null)``

  - ``getTranslator()``

  - ``setDisableTranslator($flag)``

  - ``translatorIsDisabled()``

.. _zend.form.forms.subforms:

サブフォーム
------

サブフォームの役割は、次のようなものです。

- 論理的な要素グループの作成。 サブフォームは単なるフォームであり、
  サブフォームを独立したエンティティとして検証できます。

- 複数ページにまたがるフォームの作成。 サブフォームは単なるフォームなので、
  ページごとに別々のサブフォームを表示させて複数ページのフォームを作成し、
  各ページで独自のバリデーションを行うことができます。
  すべてのサブフォームの検証に成功した時点ではじめて
  フォームの検証が完了したことになります。

- 表示のグループ化。 表示グループと同様、サブフォームについても
  フォーム内でのレンダリングの際にはひとつの要素として扱われます。
  しかし注意しましょう。
  親フォームからはサブフォームの要素にはアクセスできません。

サブフォームは ``Zend_Form`` のオブジェクトです。一般的には ``Zend_Form_SubForm``
のオブジェクトとなります。
後者のクラスには、大きなフォームに含めるのに適したデコレータが含まれています
(HTML の form タグをレンダリングせず、要素をグループ化するものです)。
サブフォームをアタッチするには、単にそれを要素に追加して名前を指定するだけです。

.. code-block:: php
   :linenos:

   $form->addSubForm($subForm, 'subform');

サブフォームを取得するには、 ``getSubForm($name)``
を使用するかあるいはサブフォームの名前を使用します。

.. code-block:: php
   :linenos:

   // getSubForm() の使用
   $subForm = $form->getSubForm('subform');

   // オーバーロードの使用
   $subForm = $form->subform;

サブフォームは、親フォームの要素のひとつとして順次処理できます。
サブフォーム内の要素は処理できません。

.. _zend.form.forms.subforms.global:

グローバルな操作
^^^^^^^^

要素や表示グループと同様、サブフォームに対しても全体に共通の操作があるでしょう。
しかし、表示グループや要素とは異なり、
サブフォームは親フォームのほとんどの機能を継承しています。
グローバルな操作として本当に必要なのは、サブフォーム用のデコレータの設定くらいです。
そんな場合には ``setSubFormDecorators()``
メソッドを使用します。次の例では、すべてのサブフォームに対して 単純に fieldset
デコレータを設定します (FormElements
デコレータは、要素を順次処理するために必須です)。

.. code-block:: php
   :linenos:

   $form->setSubFormDecorators(array(
       'FormElements',
       'Fieldset'
   ));

.. _zend.form.forms.subforms.methods:

サブフォームを操作するためのメソッド
^^^^^^^^^^^^^^^^^^

次のメソッドを使用して、サブフォームを操作します。

- ``addSubForm(Zend_Form $form, $name, $order = null)``

- ``addSubForms(array $subForms)``

- ``setSubForms(array $subForms)``

- ``getSubForm($name)``

- ``getSubForms()``

- ``removeSubForm($name)``

- ``clearSubForms()``

- ``setSubFormDecorators(array $decorators)``

.. _zend.form.forms.metadata:

メタデータおよび属性
----------

フォームで一番大切なのはフォームが含む要素ですが、
フォームにはそれ以外のメタデータも含まれます。たとえばフォームの名前
(この名前は、HTML のマークアップ時に ID として用いられます)
やアクション、そしてメソッドなどです。
要素や表示グループ、サブフォームの数も含まれます。
それ以外にも任意のメタデータを含めることができます (通常は、form タグで指定する
HTML 属性などをここに含めます)。

フォームの名前を設定したり取得したりするには name アクセサを使用します。

.. code-block:: php
   :linenos:

   // 名前を設定します
   $form->setName('registration');

   // 名前を取得します
   $name = $form->getName();

アクション (フォームを送信したときに進む URL) やメソッド (送信する方法。たとえば
'POST' あるいは 'GET') を設定するには、それぞれ action アクセサおよび method
アクセサを使用します。

.. code-block:: php
   :linenos:

   // アクションとメソッドを設定します
   $form->setAction('/user/login')
        ->setMethod('post');

フォームのエンコード形式を設定するには enctype アクセサを使用します。 ``Zend_Form``
では 2 つの定数 ``Zend_Form::ENCTYPE_URLENCODED`` と ``Zend_Form::ENCTYPE_MULTIPART``
を定義しており、 これらはそれぞれ 'application/x-www-form-urlencoded' と 'multipart/form-data'
に対応します。 しかし、これ以外にも任意のエンコード形式を指定できます。

.. code-block:: php
   :linenos:

   // アクションとメソッド、そして enctype を設定します
   $form->setAction('/user/login')
        ->setMethod('post')
        ->setEnctype(Zend_Form::ENCTYPE_MULTIPART);

.. note::

   メソッドやアクション、enctype
   はレンダリングの際に内部的に使われるものであり、
   バリデーション用のものではありません。

``Zend_Form`` は *Countable* インターフェイスを実装しており、count
関数の引数として使用できます。

.. code-block:: php
   :linenos:

   $numItems = count($form);

任意のメタデータを設定するには attribs アクセサを使用します。 ``Zend_Form``
ではオーバーロードを使用して
要素や表示グループそしてサブフォームにアクセスしているので、
これがメタデータにアクセスするための唯一の方法となります。

.. code-block:: php
   :linenos:

   // 属性を設定します
   $form->setAttrib('class', 'zend-form')
        ->addAttribs(array(
            'id'       => 'registration',
            'onSubmit' => 'validate(this)',
        ));

   // 属性を取得します
   $class = $form->getAttrib('class');
   $attribs = $form->getAttribs();

   // 属性を削除します
   $form->removeAttrib('onSubmit');

   // すべての属性を削除します
   $form->clearAttribs();

.. _zend.form.forms.decorators:

デコレータ
-----

フォームのマークアップを作成するのは手間のかかる作業です。
特に、検証エラーの表示や値の送信などの決まりきった処理を何度も行うのは大変なことです。
この問題に対する ``Zend_Form`` からの回答が **デコレータ** です。

``Zend_Form`` オブジェクトのデコレータを使用して、 フォームをレンダリングします。
FormElements デコレータは、フォームのすべての項目
(要素、表示グループ、サブフォーム)
を順次処理し、それらをレンダリングした結果を返します。
それ以外のデコレータを使用して、コンテンツをラップしたり
前後に何かを追加したりできます。

``Zend_Form`` のデフォルトのデコレータは、FormElements と HtmlTag
(定義リストによるラッピングをします)、そして Form です。
以下のコードと同様です。

.. code-block:: php
   :linenos:

   $form->setDecorators(array(
       'FormElements',
       array('HtmlTag', array('tag' => 'dl')),
       'Form'
   ));

これは、次のような出力をします。

.. code-block:: html
   :linenos:

   <form action="/form/action" method="post">
   <dl>
   ...
   </dl>
   </form>

フォームオブジェクトに設定した任意の属性は、 HTML の *<form>*
タグの属性となります。

.. note::

   **読み込み不要なデフォルトのデコレータ**

   デフォルトのデコレータは、
   オブジェクトの初期化時に読み込まれるようになっています。
   この機能を無効にするには、コンストラクタでオプション 'disableLoadDefaultDecorators'
   を指定します。

   .. code-block:: php
      :linenos:

      $form = new Zend_Form(array('disableLoadDefaultDecorators' => true));

   このオプションは、他のオプションと混用することもできます。
   その場合はオプションの配列や ``Zend_Config`` オブジェクトを使用します。

.. note::

   **同じ型の複数のデコレータの使用法**

   内部的には、 ``Zend_Form``
   はデコレータのクラスをもとにデコレータを取得しています。
   その結果、同じ型のデコレータを複数使うことができなくなります。
   同じ型のデコレータを複数指定すると、
   後から指定したものが先に指定したものを上書きします。

   これを回避するにはエイリアスを使用します。 デコレータやデコレータ名を
   ``addDecorator()``
   の最初の引数として渡すのではなく、ひとつの要素からなる配列を渡します。
   この配列には、デコレータオブジェクトあるいはデコレータ名を指すエイリアスを指定します。

   .. code-block:: php
      :linenos:

      // 'FooBar' へのエイリアス
      $form->addDecorator(array('FooBar' => 'HtmlTag'), array('tag' => 'div'));

      // 後で、このように取得できます
      $form = $element->getDecorator('FooBar');

   ``addDecorators()`` メソッドおよび ``setDecorators()`` メソッドでは、
   デコレータを表す配列を 'decorator' オプションに渡す必要があります。

   .. code-block:: php
      :linenos:

      // ふたつの 'HtmlTag' デコレータを使用するため、片方に 'FooBar' というエイリアスを指定します
      $form->addDecorators(
          array('HtmlTag', array('tag' => 'div')),
          array(
              'decorator' => array('FooBar' => 'HtmlTag'),
              'options' => array('tag' => 'dd')
          ),
      );

      // 後で、このように取得できます
      $htmlTag = $form->getDecorator('HtmlTag');
      $fooBar  = $form->getDecorator('FooBar');

独自のデコレータを使用してフォームを作成することもできます。
一般的な使用例としては、作成したい HTML
が厳密に決まっている場合などがあります。 デコレータでそれとまったく同じ HTML
を作成し、単純にそれを返せばいいのです。
個々の要素や表示グループに対してもそれぞれデコレータを使用できます。

デコレータ関連のメソッドを以下にまとめます。

- ``addDecorator($decorator, $options = null)``

- ``addDecorators(array $decorators)``

- ``setDecorators(array $decorators)``

- ``getDecorator($name)``

- ``getDecorators()``

- ``removeDecorator($name)``

- ``clearDecorators()``

``Zend_Form`` は、
オーバーロードを使用して特定のデコレータをレンダリングすることもできます。
'render' で始まる名前のメソッドを ``__call()``
で捕捉し、メソッド名の残りの部分にもとづいてデコレータを探します。
見つかった場合は、そのデコレータ **だけ** をレンダリングします。
引数を渡すと、それがデコレータの ``render()``
メソッドにコンテンツとして渡されます。次の例を参照ください。

.. code-block:: php
   :linenos:

   // FormElements デコレータのみをレンダリングします
   echo $form->renderFormElements();

   // fieldset デコレータのみ、コンテンツを渡してレンダリングします
   echo $form->renderFieldset("<p>This is fieldset content</p>");

デコレータが存在しない場合は、例外が発生します。

.. _zend.form.forms.validation:

バリデーション
-------

フォームの主な使用法は、送信されたデータを検証することです。 ``Zend_Form``
は、フォーム全体あるいはその一部を一度に検証したり、 XmlHttpRequests (AJAX)
のレスポンスを自動的に検証したりできます。 送信されたデータが無効な場合は、
要素やサブフォームについて
検証エラーのコードやメッセージを取得するメソッドが用意されています。

フォーム全体のバリデーションを行うには ``isValid()`` メソッドを使用します。

.. code-block:: php
   :linenos:

   if (!$form->isValid($_POST)) {
       // 検証に失敗しました
   }

``isValid()`` はすべての必須要素の検証を行います。
また非必須要素の中で値が送信された要素についても検証します。

時には一部のデータだけを検証したいこともあるでしょう。そんな場合には
``isValidPartial($data)`` を使用します。

.. code-block:: php
   :linenos:

   if (!$form->isValidPartial($data)) {
       // 検証に失敗しました
   }

``isValidPartial()`` は、 data の項目にマッチする要素についてのみ検証を行います。
マッチする要素がなかった場合は処理をスキップします。

*AJAX* リクエストの要素や要素グループを検証する際は、
通常はフォームの一部を検証してその結果を *JSON* で返すことになります。
``processAjax()`` が、まさにその作業を行うメソッドです。

.. code-block:: php
   :linenos:

   $json = $form->processAjax($data);

こうすれば、単純に *JSON* レスポンスをクライアントに返すことができます。
フォームの検証に成功した場合は、この結果は ``TRUE`` となります。
失敗した場合は、キーとメッセージのペアを含む javascript
オブジェクトを返します。個々の 'message'
が検証エラーメッセージの配列となります。

フォームの検証に失敗した場合は、エラーコードとエラーメッセージをそれぞれ
``getErrors()`` と ``getMessages()`` で取得できます。

.. code-block:: php
   :linenos:

   $codes = $form->getErrors();
   $messages = $form->getMessages();

.. note::

   ``getMessages()`` が返すメッセージは エラーコード/エラーメッセージ の配列なので、
   ``getErrors()`` は通常は不要です。

個々の要素のコードとエラーメッセージを取得するには、
それぞれのメソッドに要素名を渡します。

.. code-block:: php
   :linenos:

   $codes = $form->getErrors('username');
   $messages = $form->getMessages('username');

.. note::

   注意: 要素を検証する際、 ``Zend_Form`` は各要素の ``isValid()`` メソッドに 2
   番目の引数を渡します。 これは検証対象のデータの配列です。
   これを使用すると、他の要素の入力内容をもとにした検証を
   各要素で行うことができます。
   例としては、「パスワード」欄と「パスワード（確認）」
   があるユーザ登録フォームがあります。「パスワード」
   要素の検証には「パスワード（確認）」の入力内容を使用することになるでしょう。

.. _zend.form.forms.validation.errors:

独自のエラーメッセージ
^^^^^^^^^^^

時には、要素にアタッチされたバリデータが生成するエラーメッセージではなく
独自のエラーメッセージを指定したくなることもあるでしょう。
さらに、時には自分自身でフォームを無効だとマークしたいこともあるでしょう。
次のメソッドでこの機能を使用できます。

- ``addErrorMessage($message)``:
  フォームの検証エラーの際に表示するエラーメッセージを追加します。
  複数回コールすると、新しいメッセージはスタックに追加されます。

- ``addErrorMessages(array $messages)``:
  フォームの検証エラーの際に表示する複数のエラーメッセージを追加します。

- ``setErrorMessages(array $messages)``:
  フォームの検証エラーの際に表示する複数のエラーメッセージを追加します。
  それまでに設定されていたすべてのメッセージを上書きします。

- ``getErrorMessages()``: 定義済みのカスタムエラーメッセージの一覧を取得します。

- ``clearErrorMessages()``: 定義済みのカスタムエラーメッセージをすべて削除します。

- ``markAsError()``: 検証に失敗したものとしてフォームにマークします。

- ``addError($message)``:
  エラーメッセージをカスタムエラーメッセージスタックに追加し、
  フォームを無効とマークします。

- ``addErrors(array $messages)``:
  複数のエラーメッセージをカスタムエラーメッセージスタックに追加し、
  フォームを無効とマークします。

- ``setErrors(array $messages)``:
  指定したメッセージでカスタムエラーメッセージスタックを上書きし、
  フォームを無効とマークします。

この方式で設定したすべてのエラーは翻訳されることになります。

.. _zend.form.forms.validation.values:

Retrieving Valid Values Only
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are scenarios when you want to allow your user to work on a valid form in several steps. Meanwhile you allow
the user to save the form with any set of values inbetween. Then if all the data is specified you can transfer the
model from the building or prototying stage to a valid stage.

You can retrieve all the valid values that match the submitted data by calling:

.. code-block:: php
   :linenos:

   $validValues = $form->getValidValues($_POST);

.. _zend.form.forms.methods:

メソッド
----

以下の一覧は、 ``Zend_Form`` のメソッドをタイプ別にまとめたものです。

- 設定

  - ``setOptions(array $options)``

  - ``setConfig(Zend_Config $config)``

- プラグインローダーおよびパス

  - ``setPluginLoader(Zend_Loader_PluginLoader_Interface $loader, $type = null)``

  - ``getPluginLoader($type = null)``

  - ``addPrefixPath($prefix, $path, $type = null)``

  - ``addPrefixPaths(array $spec)``

  - ``addElementPrefixPath($prefix, $path, $type = null)``

  - ``addElementPrefixPaths(array $spec)``

  - ``addDisplayGroupPrefixPath($prefix, $path)``

- メタデータ

  - ``setAttrib($key, $value)``

  - ``addAttribs(array $attribs)``

  - ``setAttribs(array $attribs)``

  - ``getAttrib($key)``

  - ``getAttribs()``

  - ``removeAttrib($key)``

  - ``clearAttribs()``

  - ``setAction($action)``

  - ``getAction()``

  - ``setMethod($method)``

  - ``getMethod()``

  - ``setName($name)``

  - ``getName()``

- 要素

  - ``addElement($element, $name = null, $options = null)``

  - ``addElements(array $elements)``

  - ``setElements(array $elements)``

  - ``getElement($name)``

  - ``getElements()``

  - ``removeElement($name)``

  - ``clearElements()``

  - ``setDefaults(array $defaults)``

  - ``setDefault($name, $value)``

  - ``getValue($name)``

  - ``getValues()``

  - ``getUnfilteredValue($name)``

  - ``getUnfilteredValues()``

  - ``setElementFilters(array $filters)``

  - ``setElementDecorators(array $decorators)``

- サブフォーム

  - ``addSubForm(Zend_Form $form, $name, $order = null)``

  - ``addSubForms(array $subForms)``

  - ``setSubForms(array $subForms)``

  - ``getSubForm($name)``

  - ``getSubForms()``

  - ``removeSubForm($name)``

  - ``clearSubForms()``

  - ``setSubFormDecorators(array $decorators)``

- 表示グループ

  - ``addDisplayGroup(array $elements, $name, $options = null)``

  - ``addDisplayGroups(array $groups)``

  - ``setDisplayGroups(array $groups)``

  - ``getDisplayGroup($name)``

  - ``getDisplayGroups()``

  - ``removeDisplayGroup($name)``

  - ``clearDisplayGroups()``

  - ``setDisplayGroupDecorators(array $decorators)``

- 検証

  - ``populate(array $values)``

  - ``isValid(array $data)``

  - ``isValidPartial(array $data)``

  - ``processAjax(array $data)``

  - ``persistData()``

  - ``getErrors($name = null)``

  - ``getMessages($name = null)``

- レンダリング

  - ``setView(Zend_View_Interface $view = null)``

  - ``getView()``

  - ``addDecorator($decorator, $options = null)``

  - ``addDecorators(array $decorators)``

  - ``setDecorators(array $decorators)``

  - ``getDecorator($name)``

  - ``getDecorators()``

  - ``removeDecorator($name)``

  - ``clearDecorators()``

  - ``render(Zend_View_Interface $view = null)``

- I18n

  - ``setTranslator(Zend_Translator_Adapter $translator = null)``

  - ``getTranslator()``

  - ``setDisableTranslator($flag)``

  - ``translatorIsDisabled()``

.. _zend.form.forms.config:

設定
--

``Zend_Form`` は、 ``setOptions()`` や ``setConfig()`` を用いて
(あるいはコンストラクタでオプションや ``Zend_Config`` オブジェクトを渡して)
さまざまに設定できます。
これらのメソッドを使用して、フォームの要素や表示グループ、デコレータ、
そしてメタデータを設定できます。

全般的なルールとして、もし 'set' + オプションのキー という名前のメソッドが
``Zend_Form`` にあった場合は、そのメソッドを使用するとオプションを設定できます。
アクセサが存在しない場合は キーが属性への参照とみなされ、 ``setAttrib()``
に渡されます。

このルールには、次のような例外があります。

- *prefixPaths* は ``addPrefixPaths()`` に渡されます。

- *elementPrefixPaths* は ``addElementPrefixPaths()`` に渡されます。

- *displayGroupPrefixPaths* は ``addDisplayGroupPrefixPaths()`` に渡されます。

- 以下のセッターはこの方式では設定できません。

  - *setAttrib (ただし、setAttribs は動作します)*

  - *setConfig*

  - *setDefault*

  - *setOptions*

  - *setPluginLoader*

  - *setSubForms*

  - *setTranslator*

  - *setView*

例として、すべての型の設定データを渡すファイルを見てみましょう。

.. code-block:: ini
   :linenos:

   [element]
   name = "registration"
   action = "/user/register"
   method = "post"
   attribs.class = "zend_form"
   attribs.onclick = "validate(this)"

   disableTranslator = 0

   prefixPath.element.prefix = "My_Element"
   prefixPath.element.path = "My/Element/"
   elementPrefixPath.validate.prefix = "My_Validate"
   elementPrefixPath.validate.path = "My/Validate/"
   displayGroupPrefixPath.prefix = "My_Group"
   displayGroupPrefixPath.path = "My/Group/"

   elements.username.type = "text"
   elements.username.options.label = "Username"
   elements.username.options.validators.alpha.validator = "Alpha"
   elements.username.options.filters.lcase = "StringToLower"
   ; more elements, of course...

   elementFilters.trim = "StringTrim"
   ;elementDecorators.trim = "StringTrim"

   displayGroups.login.elements.username = "username"
   displayGroups.login.elements.password = "password"
   displayGroupDecorators.elements.decorator = "FormElements"
   displayGroupDecorators.fieldset.decorator = "Fieldset"

   decorators.elements.decorator = "FormElements"
   decorators.fieldset.decorator = "FieldSet"
   decorators.fieldset.decorator.options.class = "zend_form"
   decorators.form.decorator = "Form"

これは、 *XML* や *PHP*
の配列形式の設定ファイルにも簡単に置き換えることができます。

.. _zend.form.forms.custom:

カスタムフォーム
--------

独自の設定のフォームを使用するもうひとつの方法は、 ``Zend_Form``
のサブクラスを作成することです。 これには次のような利点があります。

- フォームのユニットテストを容易に行うことができ、
  検証やレンダリングが期待通りのものかを確認しやすくなる。

- 個々の要素に対する決め細やかな制御ができる。

- フォームオブジェクトの再利用がしやすくなり、移植性が高まる
  (設定ファイルの内容を気にする必要がなくなる)。

- 独自の機能を実装できる。

一般的な使用法としては、 ``init()`` メソッドでフォーム要素などの設定を行います。

.. code-block:: php
   :linenos:

   class My_Form_Login extends Zend_Form
   {
       public function init()
       {
           $username = new Zend_Form_Element_Text('username');
           $username->class = 'formtext';
           $username->setLabel('Username:')
                    ->setDecorators(array(
                        array('ViewHelper',
                              array('helper' => 'formText')),
                        array('Label',
                              array('class' => 'label'))
                    ));

           $password = new Zend_Form_Element_Password('password');
           $password->class = 'formtext';
           $password->setLabel('Username:')
                    ->setDecorators(array(
                        array('ViewHelper',
                              array('helper' => 'formPassword')),
                        array('Label',
                              array('class' => 'label'))
                    ));

           $submit = new Zend_Form_Element_Submit('login');
           $submit->class = 'formsubmit';
           $submit->setValue('Login')
                  ->setDecorators(array(
                      array('ViewHelper',
                      array('helper' => 'formSubmit'))
                  ));

           $this->addElements(array(
               $username,
               $password,
               $submit
           ));

           $this->setDecorators(array(
               'FormElements',
               'Fieldset',
               'Form'
           ));
       }
   }

このフォームのインスタンスを作成するのは、次のように簡単です。

.. code-block:: php
   :linenos:

   $form = new My_Form_Login();

そして、すべての機能はすでに準備済みの状態で、 設定ファイルは不要です
(この例はかなり単純化していることに注意しましょう。
バリデーションや要素のフィルタなどは省略しています)。

独自のフォームを作成する理由としてもうひとつよくあるのが、
デフォルトのデコレータを定義したいというものです。 この場合は
``loadDefaultDecorators()`` メソッドを上書きします。

.. code-block:: php
   :linenos:

   class My_Form_Login extends Zend_Form
   {
       public function loadDefaultDecorators()
       {
           $this->setDecorators(array(
               'FormElements',
               'Fieldset',
               'Form'
           ));
       }
   }


