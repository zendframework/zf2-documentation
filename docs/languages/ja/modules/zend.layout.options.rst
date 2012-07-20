.. _zend.layout.options:

Zend_Layout の設定オプション
====================

``Zend_Layout`` にはさまざまな設定オプションがあります。
オプションを設定する方法には次のようなものがあります。
まずアクセサメソッドをコールすること、 次に配列や ``Zend_Config``
オブジェクトをコンストラクタあるいは ``startMvc()`` に渡すこと、
オプションの配列を ``setOptions()`` に渡すこと、 そして ``Zend_Config`` オブジェクトを
``setConfig()`` に渡すことです。

- **layout**: 使用するレイアウト。現在のインフレクタを使用して名前を解決し、
  適切なレイアウトビュースクリプトを使用します。デフォルトでは、この値は
  'layout' で、'layout.phtml' に解決されます。 アクセサは ``setLayout()`` と ``getLayout()``
  です。

- **layoutPath**: レイアウトビュースクリプトの基底パス。 アクセサは ``setLayoutPath()`` と
  ``getLayoutPath()`` です。

- **contentKey**: デフォルトのコンテンツに使用するレイアウト変数 (*MVC*
  と組み合わせて使用する場合のみ)。 デフォルト値は 'content' です。 アクセサは
  ``setContentKey()`` と ``getContentKey()`` です。

- **mvcSuccessfulActionOnly**: *MVC* とともに使用します。このフラグを ``TRUE`` にすると、
  アクションが例外をスローした際にレイアウトをレンダリングしません
  (これにより、 :ref:`ErrorHandler プラグイン <zend.controller.plugins.standard.errorhandler>`
  を使用している際の二重レンダリング問題を回避します)。
  デフォルトでは、このフラグは ``TRUE`` です。 アクセサは ``setMvcSuccessfulActionOnly()``
  と ``getMvcSuccessfulActionOnly()`` です。

- **view**: レンダリングの際に使用するビューオブジェクト。 *MVC*
  と組み合わせて使用した場合、 ビューオブジェクトを明示しなければ ``Zend_Layout``
  は :ref:`ViewRenderer <zend.controller.actionhelpers.viewrenderer>`
  で登録されたビューオブジェクトを使用します。 アクセサは ``setView()`` と
  ``getView()`` です。

- **helperClass**: ``Zend_Layout`` を *MVC*
  コンポーネントを組み合わせて使用する際のアクションヘルパークラス。
  デフォルトでは、これは ``Zend_Layout_Controller_Action_Helper_Layout`` です。 アクセサは
  ``setHelperClass()`` と ``getHelperClass()`` です。

- **pluginClass**: ``Zend_Layout`` を *MVC*
  コンポーネントを組み合わせて使用する際のフロントコントローラプラグインクラス。
  デフォルトでは、これは ``Zend_Layout_Controller_Plugin_Layout`` です。 アクセサは
  ``setPluginClass()`` と ``getPluginClass()`` です。

- **inflector**:
  レイアウト名をレイアウトビュースクリプトのパスに解決する際に使用するインフレクタ。
  詳細は :ref:`Zend_Layout インフレクタのドキュメント <zend.layout.advanced.inflector>`
  を参照ください。 アクセサは ``setInflector()`` と ``getInflector()`` です。

.. note::

   **helperClass と pluginClass は startMvc() で渡す必要がある**

   *helperClass* と *pluginClass* の設定を有効にするには、 ``startMvc()``
   のオプションで指定する必要があります。
   それ以降で指定しても効果はありません。

.. _zend.layout.options.examples:

例
-

以下の例では、次のような *$options* 配列と *$config*
オブジェクトを前提としています。

.. code-block:: php
   :linenos:

   $options = array(
       'layout'     => 'foo',
       'layoutPath' => '/path/to/layouts',
       'contentKey' => 'CONTENT',           // MVC を使わない場合は無視されます
   );

.. code-block:: php
   :linenos:

   /**
   [layout]
   layout = "foo"
   layoutPath = "/path/to/layouts"
   contentKey = "CONTENT"
   */
   $config = new Zend_Config_Ini('/path/to/layout.ini', 'layout');

.. _zend.layout.options.examples.constructor:

.. rubric:: オプションをコンストラクタあるいは startMvc() で渡す

コンストラクタおよび静的メソッド ``startMvc()`` は、どちらもオプションの配列か
``Zend_Config`` オブジェクトを受け取ることができます。 受け取った内容をもとに
``Zend_Layout`` インスタンスの設定を行います。

まず、配列を渡す方法を見てみましょう。

.. code-block:: php
   :linenos:

   // コンストラクタを使用します
   $layout = new Zend_Layout($options);

   // startMvc() を使用します
   $layout = Zend_Layout::startMvc($options);

次に config オブジェクトを使用する方法です。

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini('/path/to/layout.ini', 'layout');

   // コンストラクタを使用します
   $layout = new Zend_Layout($config);

   // startMvc() を使用します
   $layout = Zend_Layout::startMvc($config);

基本的に、これは ``Zend_Layout``
インスタンスをカスタマイズするためのもっとも簡単な方法となります。

.. _zend.layout.options.examples.setoptionsconfig:

.. rubric:: setOption() および setConfig() の使用

時には、インスタンスを作成した後で ``Zend_Layout``
を設定したくなることもあるでしょう。そんな場合は ``setOptions()`` や ``setConfig()``
を使用します。

.. code-block:: php
   :linenos:

   // オプションの配列を使用します
   $layout->setOptions($options);

   // Zend_Config オブジェクトを使用します
   $layout->setConfig($options);

しかし、ここで注意すべき点があります。 *pluginClass* や *helperClass*
のように、オプションによってはこのメソッドで指定しても無意味なものもあるのです。
これらは、コンストラクタあるいは ``startMvc()`` メソッドで指定する必要があります。

.. _zend.layout.options.examples.accessors:

.. rubric:: アクセサの使用

最後に、 ``Zend_Layout`` のインスタンスをアクセサで設定することもできます。
すべてのアクセサは流れるようなインターフェイスを実装しており、
メソッドコールを連結して行えます。

.. code-block:: php
   :linenos:

   $layout->setLayout('foo')
          ->setLayoutPath('/path/to/layouts')
          ->setContentKey('CONTENT');


