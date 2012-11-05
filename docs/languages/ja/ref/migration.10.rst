.. EN-Revision: none
.. _migration.10:

Zend Framework 1.0
==================

以前のバージョンから Zend Framework 1.0 またはそれ以降に更新する際は、
下記の移行上の注意点に注意すべきです。

.. _migration.10.zend.controller:

Zend_Controller
---------------

1.0.0RC1 での最大の変更点は、 :ref:`ErrorHandler <zend.controller.plugins.standard.errorhandler>`
プラグインと :ref:`ViewRenderer <zend.controller.actionhelpers.viewrenderer>`
アクションヘルパーが追加され、デフォルトで有効となったことです。
それぞれのドキュメントを熟読し、どのように動作するのかや
既存のアプリケーションに与える影響について確認しておきましょう。

``ErrorHandler`` プラグインは ``postDispatch()`` で動作するもので、
例外をチェックして指定したエラーハンドラコントローラに転送します。
そのため、アプリケーション内にエラー処理用コントローラを含める必要があります。
このプラグインを無効にするには、フロントコントローラのパラメータ ``noErrorHandler``
を設定します。

.. code-block:: php
   :linenos:

   $front->setParam('noErrorHandler', true);

``ViewRenderer`` アクションヘルパーは、
アクションコントローラへのビューの注入を自動的に行います。
また、現在のアクションにもとづいたビュースクリプトを自動的にレンダリングします。
ビュースクリプトをレンダリングせず、かつ転送やリダイレクトも行わないアクションがあった場合、
これは問題になるでしょう。というのも、 ``ViewRenderer``
はそんなアクションであっても
アクション名をもとに自動的にビュースクリプトをレンダリングしようとするからです。

もし既存のコードにそのようなものがあった場合の対応方法はいくつか考えられます。
一番手っ取り早いのは、フロントコントローラの起動時に ``ViewRenderer``
を無効にしてからディスパッチを行うことです。

.. code-block:: php
   :linenos:

   // $front は Zend\Controller\Front のインスタンスであるとします
   $front->setParam('noViewRenderer', true);

しかし、長い目で見ればこれはあまりよい作戦ではありません。
今後も新しいコードを書き続けるならなおさらです。

``ViewRenderer`` の機能を把握したら、コントローラのコードを見てみましょう。
まず、アクションメソッド (名前が 'Action' で終わっているメソッド)
を探し、その中でどんな処理をしているかを確認しましょう。
もし次に挙げるいずれの内容も行っていない場合は、コードに手を加える必要があります。

- ``$this->render();`` のコール

- ``$this->_forward();`` のコール

- ``$this->_redirect();`` のコール

- ``Redirector`` アクションヘルパーのコール

一番簡単なのは、そのメソッド内で自動レンダリングを無効にすることです。

.. code-block:: php
   :linenos:

   $this->_helper->viewRenderer->setNoRender();

レンダリング、転送あるいはリダイレクトを行っているアクションメソッドがひとつもない場合は、
上で示したコードを ``preDispatch()`` メソッドあるいは ``init()``
メソッド内に書くといいでしょう。

.. code-block:: php
   :linenos:

   public function preDispatch()
   {
       // ビュースクリプトの自動レンダリングを無効にします
       $this->_helper->viewRenderer->setNoRender()
       // .. 何かほかのことをします...
   }

もしメソッド内で ``render()`` をコールしていて、 :ref:`規約どおりのディレクトリ構造
<zend.controller.modular>`
を使用しているのなら、自動レンダリングを使用するようにコードを書き換えましょう。

- ひとつのアクションで複数のビュースクリプトをレンダリングしている場合は、
  なにも変更する必要はありません。

- 何も引数を指定せずに ``render()`` をコールしている場合は、 その行を削除します。

- 引数つきで ``render()`` をコールしていて、
  その後に何か処理をしたり複数のビュースクリプトを実行したりしていない場合は、
  その行を ``$this->_helper->viewRenderer();`` のように変更します。

独自のディレクトリ構造を使用している場合は、
ビューの基底パスやスクリプトのパスをメソッドで設定してから ``ViewRenderer``
を使用します。これらのメソッドについての詳細は :ref:`ViewRenderer のドキュメント
<zend.controller.actionhelpers.viewrenderer>` を参照ください。

ビューオブジェクトをレジストリから取得していたり
ビューオブジェクトをカスタマイズしていたり、
あるいはデフォルトとは異なるビューを使用している場合は、 そのオブジェクトを
``ViewRenderer`` に注入するために次のようにします。
これはいつでも好きなときに行えます。

- フロントコントローラのインスタンスをディスパッチする前なら

  .. code-block:: php
     :linenos:

     // $view はすでに定義されているものとします
     $viewRenderer = new Zend\Controller\Action\Helper\ViewRenderer($view);
     Zend\Controller_Action\HelperBroker::addHelper($viewRenderer);

- 起動処理の中ならどこでも

  .. code-block:: php
     :linenos:

     $viewRenderer =
         Zend\Controller_Action\HelperBroker::getStaticHelper('viewRenderer');
     $viewRenderer->setView($view);
``ViewRenderer`` を変更するにはさまざまな方法があります。
たとえばレンダリングするビュースクリプトを別のものに変更したり
ビュースクリプトパスの置換可能な要素（サフィックスを含む）
を置換する内容を指定したり、使用するレスポンスセグメントを選択したりなどのことができます。
規約どおりのディレクトリ構造以外を使用する場合は、 ``ViewRenderer``
でのパスの決定方法を変更することもできます。

``ErrorHandler`` および ``ViewRenderer`` は今やコア機能として組み込まれているので、
既存のコードについてもできるだけこれに適合するようにすることをお勧めします。

.. _migration.10.zend.currency:

Zend_Currency
-------------

``Zend_Currency`` のオブジェクトを、 よりシンプルに作成できるようになりました。
script パラメータを指定したり ``NULL`` に設定したりする必要がなくなったのです。
script パラメータはオプションとなり、後で ``setFormat()``
メソッドで指定できるようになりました。

.. code-block:: php
   :linenos:

   $currency = new Zend\Currency\Currency($currency, $locale);

``setFormat()`` メソッドには、オプションの配列を渡せるようになりました。
このオプションはそれ以降もずっと有効で、
それまでに設定されていた値を上書きします。 また、新たなオプション 'precision'
が組み込まれました。 現在使用できるオプションは次のとおりです。

- **position**: 以前の 'rules' パラメータを置き換えるものです。

- **script**: 以前の 'script' パラメータを置き換えるものです。

- **format**: 以前の 'locale' パラメータを置き換えるものです。
  これは新しい通貨を設定するのではなく、 数値フォーマットのみを設定します。

- **display**: 以前の 'rules' パラメータを置き換えるものです。

- **precision**: 新しいパラメータです。

- **name**: 以前の 'rules' パラメータを置き換えるものです。
  完全な通貨名を指定します。

- **currency**: 新しいパラメータです。

- **symbol**: 新しいパラメータです。

.. code-block:: php
   :linenos:

   $currency->setFormat(array $options);

``toCurrency()`` メソッドは、オプションのパラメータ 'script' および 'locale'
をサポートしなくなりました。
その代わりにオプションの配列を受け付けるようになります。
この配列に含めることのできるキーは ``setFormat()`` メソッドと同じです。

.. code-block:: php
   :linenos:

   $currency->toCurrency($value, array $options);

``getSymbol()`` や ``getShortName()``\ 、 ``getName()``\ 、 ``getRegionList()`` そして ``getCurrencyList()``
メソッドはスタティックではなくなりました。 オブジェクトから呼び出せます。
パラメータを設定しなかった場合は、
これらのメソッドはそのオブジェクトに設定されている値を返します。


