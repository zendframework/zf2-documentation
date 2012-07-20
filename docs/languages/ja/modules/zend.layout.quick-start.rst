.. _zend.layout.quickstart:

Zend_Layout クイックスタート
====================

``Zend_Layout`` の使用法は大きくふたつに分けられます。 Zend Framework の *MVC*
を使用する方法とそれ以外の方法です。

.. _zend.layout.quickstart.layouts:

レイアウトスクリプト
----------

どちらにしても、まずはレイアウトスクリプトを作成しなければなりません。
レイアウトスクリプトは、単純に ``Zend_View``
(あるいはその他のあなたが使用しているビュー実装) を用いて作成します。
レイアウト変数の登録には ``Zend_Layout`` の :ref:`プレースホルダ
<zend.view.helpers.initial.placeholder>` を使用します。プレースホルダへのアクセスは、
プレースホルダヘルパーを使用するか、
あるいはレイアウトヘルパーのレイアウトオブジェクトのプロパティを使用します。

たとえばこのようになります。

.. code-block:: php
   :linenos:

   <!DOCTYPE html
       PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
   <html>
   <head>
       <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
       <title>私のサイト</title>
   </head>
   <body>
   <?php
       // レイアウトヘルパーで使用するコンテンツのキーを取得します
       echo $this->layout()->content;

       // プレースホルダヘルパーで 'foo' キーを取得します
       echo $this->placeholder('Zend_Layout')->foo;

       // レイアウトオブジェクトを取得し、そこから変数のキーを取得します
       $layout = $this->layout();
       echo $layout->bar;
       echo $layout->baz;
   ?>
   </body>
   </html>

``Zend_Layout`` は ``Zend_View`` を用いてレンダリングをしているので、
登録されているビューヘルパーはすべて使用できます。
またビューに登録されている変数も使用できます。 特に便利なのは、さまざまな
:ref:`プレースホルダヘルパー <zend.view.helpers.initial.placeholder>`
を使用できることでしょう。 これらを用いると、たとえば <head>
セクションやナビゲーション部などのコンテンツを取得できます。

.. code-block:: php
   :linenos:

   <!DOCTYPE html
       PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
   <html>
   <head>
       <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
       <?php echo $this->headTitle() ?>
       <?php echo $this->headScript() ?>
       <?php echo $this->headStyle() ?>
   </head>
   <body>
       <?php echo $this->render('header.phtml') ?>

       <div id="nav"><?php echo $this->placeholder('nav') ?></div>

       <div id="content"><?php echo $this->layout()->content ?></div>

       <?php echo $this->render('footer.phtml') ?>
   </body>
   </html>

.. _zend.layout.quickstart.mvc:

Zend_Layout を Zend Framework の MVC で使用する方法
------------------------------------------

``Zend_Controller`` には拡張用の機能が豊富に用意されています。 これは
:ref:`フロントコントローラ プラグイン <zend.controller.plugins>` や
:ref:`アクションコントローラ ヘルパー <zend.controller.actionhelpers>`
によって実現されているものです。 ``Zend_View`` にも :ref:`ヘルパー <zend.view.helpers>`
は存在します。 ``Zend_Layout`` を *MVC* コンポーネントとともに使用すると、
これらのさまざまな拡張ポイントの恩恵を受けることになります。

``Zend_Layout::startMvc()`` は、オプションの設定項目を指定して ``Zend_Layout``
のインスタンスを作成します。 そして、フロントコントローラプラグインを登録し、
ディスパッチループの終了後にレイアウトの中身をレンダリングするようにします。
また、アクションヘルパーを登録して、
アクションコントローラからレイアウトオブジェクトにアクセスできるようにします。
さらに、ビュースクリプトからレイアウトのインスタンスを取得するには ``Layout``
ビューヘルパーを使用します。

まずは、 *MVC* と組み合わせるための ``Zend_Layout``
のインスタンスの作成方法を見てみましょう。

.. code-block:: php
   :linenos:

   // 起動ファイル内で
   Zend_Layout::startMvc();

``startMvc()`` には、オプションの配列あるいは ``Zend_Config``
オブジェクトを渡すことができます。
これによってインスタンスをカスタマイズします。 オプションの詳細については
:ref:` <zend.layout.options>` を参照ください。

アクションコントローラからは、
アクションヘルパーでレイアウトのインスタンスにアクセスします。

.. code-block:: php
   :linenos:

   class FooController extends Zend_Controller_Action
   {
       public function barAction()
       {
           // このアクションではレイアウトを無効にします
           $this->_helper->layout->disableLayout();
       }

       public function bazAction()
       {
           // このアクションでは別のレイアウトスクリプトを使用します
           $this->_helper->layout->setLayout('foobaz');
       };
   }

ビュースクリプトでは、 ``Layout``
ビューヘルパーを用いてレイアウトオブジェクトにアクセスします。
このビューヘルパーは、他のヘルパーとは異なり引数を受け取りません。
そして文字列ではなくオブジェクトを返します。
これにより、レイアウトオブジェクトのメソッドをすぐにコールできるようになります。

.. code-block:: php
   :linenos:

   <?php $this->layout()->setLayout('foo'); // 別のレイアウトを設定します ?>

*MVC* に登録した ``Zend_Layout`` のインスタンスを取得するには、静的メソッド
``getMvcInstance()`` を使用します。

.. code-block:: php
   :linenos:

   // startMvc() がまだコールされていない場合は null を返します
   $layout = Zend_Layout::getMvcInstance();

最後に、 ``Zend_Layout`` のフロントコントローラプラグインが持つ、
レイアウトのレンダリング以外の重要な機能をひとつ紹介します。
レスポンスオブジェクトから名前つきセグメントをすべて取得し、
それをレイアウトの変数に代入するというものです。 このとき 'default' セグメントは
'content' という名前の変数に代入します。
これにより、アプリケーションのコンテンツにアクセスして
それをビュースクリプト内でレンダリングできるようになります。

たとえば、こんな例を考えてみましょう。あなたの書いたコードがまず
``FooController::indexAction()`` を実行し、
デフォルトのレスポンスセグメントに何らかのコンテンツをレンダリングしてから
``NavController::menuAction()`` に転送します。
ここでは、レンダリングしたコンテンツをレスポンスセグメント 'nav'
に格納します。最後に ``CommentController::fetchAction()``
に転送してコメントを取得しますが、その内容はデフォルトのレスポンスセグメントに
(追記する方式で) レンダリングします。
そして、ビュースクリプト側ではそれを個別にレンダリングします。

.. code-block:: php
   :linenos:

   <body>
       <!-- /nav/menu のレンダリング -->
       <div id="nav"><?php echo $this->layout()->nav ?></div>

       <!-- /foo/index + /comment/fetch のレンダリング -->
       <div id="content"><?php echo $this->layout()->content ?></div>
   </body>

この機能は、ActionStack :ref:`アクションヘルパー <zend.controller.actionhelpers.actionstack>` や
:ref:`プラグイン <zend.controller.plugins.standard.actionstack>`
と組み合わせて使うと非常に便利です。
アクションのスタックを作成してそれをループさせ、
ウィジェット形式のページを作成するというわけです。

.. _zend.layout.quickstart.standalone:

Zend_Layout を単体のコンポーネントとして使用する方法
--------------------------------

単体のコンポーネントとして使用した場合は、 ``Zend_Layout`` を *MVC*
に組み込んだ場合に使用できる機能のほとんどが使えなくなります。
しかし、それでも次のふたつのメリットがあります。

- レイアウト変数のスコープの管理。

- レイアウトビュースクリプトとその他のビュースクリプトの分離。

単体のコンポーネントとして使用するには、
単純にレイアウトオブジェクトのインスタンスを作成して
各種アクセサで状態を設定し、 オブジェクトのプロパティに変数を設定してから
レイアウトをレンダリングします。

.. code-block:: php
   :linenos:

   $layout = new Zend_Layout();

   // レイアウトスクリプトのパスを設定します
   $layout->setLayoutPath('/path/to/layouts');

   // 変数を設定します
   $layout->content = $content;
   $layout->nav     = $nav;

   // 別のレイアウトスクリプトを選択します
   $layout->setLayout('foo');

   // 最終的なレイアウトをレンダリングします
   echo $layout->render();

.. _zend.layout.quickstart.example:

サンプルレイアウト
---------

一枚の絵のほうがが千の言葉よりも雄弁なこともあります。
これは、サンプルのレイアウトスクリプトをすべてまとめたときに
どのように表示されるのかを示すものです。

.. image:: ../images/zend.layout.quickstart.example.png
   :align: center

実際の要素の並び順は、使用する *CSS* によってさまざまに異なります。
たとえば、絶対位置指定を用いれば、
ナビゲーション部を本文よりも後に表示させても上部に表示させることができるでしょう。
同じことが、サイドバーやヘッダにもいえます。
しかし、そのコンテンツを作り出すもとの仕組みは同じです。


