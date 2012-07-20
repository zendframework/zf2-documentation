.. _zend.layout.advanced:

Zend_Layout の高度な使用法
===================

``Zend_Layout`` には、高度な使用法がいろいろあります。
たとえばさまざまなビューの実装やファイルシステム上のレイアウトに対応させたりといったことです。

主な拡張ポイントは次のとおりです。

- **ビューオブジェクトのカスタマイズ**\ 。 ``Zend_Layout`` は、 ``Zend_View_Interface``
  を実装した任意のクラスを使用できます。

- **フロントコントローラプラグインのカスタマイズ**\ 。 ``Zend_Layout``
  に標準で含まれているフロントコントローラプラグインは、
  レイアウトを自動的にレンダリングしてからレスポンスを返します。
  これを独自のプラグインで置き換えることができます。

- **アクションヘルパーのカスタマイズ**\ 。 ``Zend_Layout``
  に標準で含まれているアクションヘルパーは、
  ほとんどの場合にそのまま使えるでしょう。
  これは、レイアウトオブジェクト自信へのプロキシとなっています。

- **レイアウトスクリプトのパス解決方法のカスタマイズ**\ 。 ``Zend_Layout``
  では、独自の :ref:`インフレクタ <zend.filter.inflector>`
  を使用してレイアウトスクリプトのパス解決方法を行うことができます。
  あるいは、標準のインフレクタを設定して独自のルールを指定することもできます。

.. _zend.layout.advanced.view:

ビューオブジェクトのカスタマイズ
----------------

``Zend_Layout`` では、 ``Zend_View_Interface`` を実装した任意のクラスや ``Zend_View_Abstract``
を継承した任意のクラスを用いて レイアウトスクリプトをレンダリングできます。
独自のビューオブジェクトを単純に コンストラクタ/``startMvc()``
のパラメータとして渡すか、 あるいはアクセサ ``setView()`` で設定します。

.. code-block:: php
   :linenos:

   $view = new My_Custom_View();
   $layout->setView($view);

.. note::

   **Zend_View の実装がすべて同じというわけではない**

   ``Zend_Layout`` では ``Zend_View_Interface`` を実装した任意のクラスを使用できますが、
   その中で様々な ``Zend_View`` ヘルパー (特にレイアウトヘルパーや
   :ref:`プレースホルダ <zend.view.helpers.initial.placeholder>` ヘルパー)
   が使用できなければ問題となることもあるでしょう。 これは、 ``Zend_Layout``
   がオブジェクトの中の変数を自分自身と :ref:`プレースホルダ
   <zend.view.helpers.initial.placeholder>` で使えるようにしているからです。

   これらのヘルパーをサポートしていない ``Zend_View``
   の実装を使用する場合は、レイアウト変数をビューに取り込む方法を見つける必要があります。
   たとえば ``Zend_Layout`` オブジェクトを継承して ``render()``
   メソッドにビューへの変数を渡すようにするか、
   あるいは独自のプラグインクラスを作成して
   レイアウトのレンダリングの前に変数を渡すようにするといった方法があります。

   あるいは、もしあなたの使用するビュー実装が何らかのプラグイン機構をサポートしているのなら、
   'Zend_Layout' プレースホルダ経由で :ref:`プレースホルダヘルパー
   <zend.view.helpers.initial.placeholder>` を使用して変数にアクセスできます。

   .. code-block:: php
      :linenos:

      $placeholders = new Zend_View_Helper_Placeholder();
      $layoutVars   = $placeholders->placeholder('Zend_Layout')->getArrayCopy();

.. _zend.layout.advanced.plugin:

フロントコントローラプラグインのカスタマイズ
----------------------

*MVC* コンポーネントと組み合わせて使用するときに、 ``Zend_Layout``
はフロントコントローラプラグインを登録します。
このプラグインは、ディスパッチループを抜ける前の最後のアクションで
レイアウトをレンダリングします。
ほとんどの場合はデフォルトのプラグインで十分でしょうが、
もし独自のプラグインを作成したい場合は、 作成したプラグインクラスの名前を
``startMvc()`` メソッドの ``pluginClass`` オプションで指定します。

ここで使用するプラグインクラスは ``Zend_Controller_Plugin_Abstract``
を継承したものでなければなりません。また、コンストラクタの引数で
レイアウトオブジェクトのインスタンスを受け取れるようにする必要があります。
それ以外の実装内容については自由に決めることができます。

デフォルトのプラグインは ``Zend_Layout_Controller_Plugin_Layout`` です。

.. _zend.layout.advanced.helper:

アクションヘルパーのカスタマイズ
----------------

*MVC* コンポーネントと組み合わせて使用するときに、 ``Zend_Layout``
はアクションコントローラヘルパーを
ヘルパーブローカに登録します。デフォルトのヘルパーである
``Zend_Layout_Controller_Action_Helper_Layout``
は、レイアウトオブジェクトのインスタンス自身に対する (何もしない)
プロキシとしてはたらきます。 たいていの場合はこれで十分でしょう。

独自の機能を書きたい場合は、 ``Zend_Controller_Action_Helper_Abstract``
を継承したアクションヘルパークラスを作成します。 そして、そのクラス名を
``startMvc()`` メソッドの ``helperClass`` オプションに指定します。
実装の詳細は自由に決められます。

.. _zend.layout.advanced.inflector:

レイアウトスクリプトのパス解決方法のカスタマイズ: インフレクタの使用法
------------------------------------

``Zend_Layout`` は、 ``Zend_Filter_Inflector`` を使用して確立したフィルタチェインで
レイアウト名からレイアウトスクリプトのパスへの変換を行います。
デフォルトで使用するルールは、まず 'Word_CamelCaseToDash'、 その後に
'StringToLower'、そして最後にサフィックス 'phtml'
を追加してパスを作成します。たとえば次のようになります。

- 'foo' は 'foo.phtml' に変換されます。

- 'FooBarBaz' は 'foo-bar-baz.phtml' に変換されます。

これを変更するには三通りの手段があります。
インフレクションのターゲットやビューのサフィックスを ``Zend_Layout``
のアクセサで変更すること、 ``Zend_Layout`` のインスタンスに関連づけられている
インフレクタのルールを変更すること、
あるいは独自のインフレクタのインスタンスを作成してそれを
``Zend_Layout::setInflector()`` で渡すことです。

.. _zend.layout.advanced.inflector.accessors:

.. rubric:: Zend_Layout のアクセサでインフレクタを変更する

デフォルトの ``Zend_Layout`` のインフレクタは、
ターゲットやビュースクリプトのサフィックスに静的な参照を用い、
それらの値を設定するためのアクセサを提供しています。

.. code-block:: php
   :linenos:

   // インフレクタのターゲットを設定します
   $layout->setInflectorTarget('layouts/:script.:suffix');

   // レイアウトビュースクリプトのサフィックスを設定します
   $layout->setViewSuffix('php');

.. _zend.layout.advanced.inflector.directmodification:

.. rubric:: Zend_Layout のインフレクタを直接変更する

インフレクタは、ターゲットと (ひとつあるいは複数の) ルールを持っています。
``Zend_Layout`` が使用するデフォルトのターゲットは ':script.:suffix' です。':script'
には登録されているレイアウト名、そして ':suffix'
にはインフレクタの静的なルールが渡されます。

たとえば、レイアウトスクリプトのサフィックスを 'html' に変更して、MixedCase および
camelCase 形式の名前をダッシュではなくアンダースコアで区切るようにし、
かつ小文字への変換もやめてみましょう。 さらに、スクリプトの格納先を 'layouts'
サブディレクトリに変更します。

.. code-block:: php
   :linenos:

   $layout->getInflector()->setTarget('layouts/:script.:suffix')
                          ->setStaticRule('suffix', 'html')
                          ->setFilterRule(array('Word_CamelCaseToUnderscore'));

.. _zend.layout.advanced.inflector.custom:

.. rubric:: インフレクタのカスタマイズ

ほとんどの場合は、既存のインフレクタを修正するだけで十分でしょう。
しかし、さまざまな場所で別の形式のオブジェクトを使い分けたいこともあります。
``Zend_Layout`` はそんな場合にも対応しています。

.. code-block:: php
   :linenos:

   $inflector = new Zend_Filter_Inflector('layouts/:script.:suffix');
   $inflector->addRules(array(
       ':script' => array('Word_CamelCaseToUnderscore'),
       'suffix'  => 'html'
   ));
   $layout->setInflector($inflector);

.. note::

   **インフレクションを無効にできます**

   インフレクションを無効にしたり有効にしたりするには、 ``Zend_Layout``
   オブジェクトのアクセサを使用します。
   これは、たとえばレイアウトビュースクリプトを絶対パスで指定したい場合などに便利です。
   また、レイアウトスクリプトを指定するためのインフレクションが特に不要な場合にも便利です。
   有効にしたり無効にしたりするには、単純に ``enableInflection()`` メソッドおよび
   ``disableInflection()`` メソッドを使用します。


