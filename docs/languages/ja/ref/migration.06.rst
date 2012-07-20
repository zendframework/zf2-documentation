.. _migration.06:

Zend Framework 0.6
==================

以前のバージョンから Zend Framework 0.6 またはそれ以降に更新する際は、
下記の移行上の注意点に注意すべきです。

.. _migration.06.zend.controller:

Zend_Controller
---------------

*MVC* コンポーネントの基本的な部分は変わっていません。
次のいずれの方法も使用可能です。

.. code-block:: php
   :linenos:

   Zend_Controller_Front::run('/path/to/controllers');

.. code-block:: php
   :linenos:

   /* -- ルータを作成します -- */
   $router = new Zend_Controller_RewriteRouter();
   $router->addRoute('user',
                     'user/:username',
                     array('controller' => 'user', 'action' => 'info')
   );

   /* -- ルータをコントローラに設定します -- */
   $ctrl = Zend_Controller_Front::getInstance();
   $ctrl->setRouter($router);

   /* -- コントローラのディレクトリを設定し、ディスパッチします -- */
   $ctrl->setControllerDirectory('/path/to/controllers');
   $ctrl->dispatch();

レスポンスオブジェクトを使用して、コンテンツとヘッダを取得することを推奨します。
これにより、アプリケーション内で より柔軟な出力書式の切り替え (たとえば *XHTML*
ではなく *JSON* や *XML* を使用するなど) ができるようになります。 デフォルトでは、
``dispatch()`` はレスポンスのレンダリングを行い、
ヘッダとレンダリングされた内容の両方を送信します。 フロントコントローラから
``returnResponse()``
を使用してレスポンスを返し、レスポンスのレンダリングを独自に行うこともできます。
将来のバージョンのフロントコントローラでは、
レスポンスオブジェクトに出力バッファリングを使用する予定です。

これまでの *API* に加え、多くの機能が追加されています。
追加された機能についてはドキュメントを参照ください。

最大の変更点は、多くのコンポーネントで
サブクラス化による拡張が可能になったことです。以下にポイントを整理します。

- ``Zend_Controller_Front::dispatch()``
  は、デフォルトでレスポンスオブジェクトの例外をトラップします。
  例外の内容はレンダリングしません。これにより、
  システムについての機密情報がレンダリングされてしまうことを防ぎます。
  この挙動を変更するにはいくつかの方法があります。

  - フロントコントローラで ``throwExceptions()`` を設定します。

    .. code-block:: php
       :linenos:

       $front->throwExceptions(true);

  - レスポンスオブジェクトで ``renderExceptions()`` を設定します。

    .. code-block:: php
       :linenos:

       $response->renderExceptions(true);
       $front->setResponse($response);
       $front->dispatch();

       // あるいは
       $front->returnResponse(true);
       $response = $front->dispatch();
       $response->renderExceptions(true);
       echo $response;

- ``Zend_Controller_Dispatcher_Interface::dispatch()`` は、ディスパッチャトークンではなく
  :ref:`リクエストオブジェクト <zend.controller.request>` を使用するようになりました。

- ``Zend_Controller_Router_Interface::route()`` は、ディスパッチャトークンではなく
  :ref:`リクエストオブジェクト <zend.controller.request>` を使用するようになりました。

- ``Zend_Controller_Action`` の変更点は以下のようになります。

  - コンストラクタが受け付ける引数は ``Zend_Controller_Request_Abstract`` ``$request``\ 、
    ``Zend_Controller_Response_Abstract`` ``$response`` および ``array`` ``$params`` (オプション)
    の三つになりました。 ``Zend_Controller_Action::__construct()``
    は、これらを使用してリクエストやレスポンス、 そしてオブジェクトの invokeArgs
    プロパティを指定します。 コンストラクタをオーバーライドすることで、
    この挙動をお望みのように変更できます。 さらによいことに、 ``init()``
    メソッドを使用してインスタンスの設定を自由に行うことができます。
    このメソッドは、コンストラクタでの処理の最後にコールされます。

  - ``run()`` は final メソッドではなくなりました。
    しかし、このメソッドはもはやフロントコントローラでは使用されません。
    これは、クラスをページコントローラとして使用する場合にのみ使用します。
    オプションの引数 ``Zend_Controller_Request_Abstract`` ``$request`` および
    ``Zend_Controller_Response_Abstract`` ``$response`` を受け取ります。

  - ``indexAction()`` を定義する必要はなくなりました。
    しかし、デフォルトのアクションとして定義しておくことを推奨します。
    これにより、RewriteRouter とアクションコントローラで
    デフォルトのアクションメソッドを別々に指定できるようになります。

  - ``__call()`` をオーバーライドして、
    未定義のアクションが自動的に処理されるようにする必要があります。

  - ``_redirect()`` にはオプションで二番目、三番目の引数が追加されました。
    二番目の引数はリダイレクト時に返す *HTTP* コードです。 三番目の引数
    ``$prependBase`` を使用すると、リクエストオブジェクトに登録したベース *URL* を *URL*
    の前に連結することを指示できます。

  - プロパティ ``$_action`` は設定されなくなりました。 このプロパティの内容は
    ``Zend_Controller_Dispatcher_Token``
    でしたが、これは現在のバージョンにはもう存在しません。
    トークンの唯一の目的は、要求されたコントローラやアクション、 URL
    パラメータについての情報を提供することでした。
    これらは現在はリクエストオブジェクトから次のようにして取得できるようになっています。

    .. code-block:: php
       :linenos:

       // 要求されたコントローラ名を取得します。
       // その際には $this->_action->getControllerName() を使用します。
       // 以下の例では getRequest() を使用していますが、直接 $_request プロパティに
       // アクセスしてもかまいません。ただ getRequest() を使用することを推奨します。
       // とういのは、親クラスがこのメソッドをオーバーライドして挙動を変更しているかもしれないからです。
       $controller = $this->getRequest()->getControllerName();

       // 要求されたアクション名を取得します。
       // その際には $this->_action->getActionName() を使用します。
       $action = $this->getRequest()->getActionName();

       // リクエストパラメータを取得します。
       // これは変わっていません。_getParams() メソッドおよび _getParam() メソッドは
       // 現在は単なるリクエストオブジェクトへのプロキシです。
       $params = $this->_getParams();
       // パラメータ 'foo' を取得します。見つからなかった場合はデフォルト値 'default' を設定します
       $foo = $this->_getParam('foo', 'default');

  - ``noRouteAction()`` は削除されました。 存在しないアクションメソッドを扱うには、
    ``__call()`` を使用してデフォルトのアクションに誘導します。

    .. code-block:: php
       :linenos:

       public function __call($method, $args)
       {
           // 存在しない 'Action' メソッドが要求された場合に、
           // それをデフォルトのアクションに渡します。
           if ('Action' == substr($method, -6)) {
               return $this->defaultAction();
           }

           throw new Zend_Controller_Exception('無効なメソッド呼び出しです');
       }

- ``Zend_Controller_RewriteRouter::setRewriteBase()`` は削除されました。かわりに
  ``Zend_Controller_Front::setBaseUrl()`` を使用してください
  (あるいは、リクエストクラスを使用している場合は
  ``Zend_Controller_Request_Http::setBaseUrl()`` を使用します)。

- ``Zend_Controller_Plugin_Interface`` は ``Zend_Controller_Plugin_Abstract`` に置き換えられました。
  すべてのメソッドは、ディスパッチャトークンではなく
  :ref:`リクエストオブジェクト <zend.controller.request>`
  をやり取りするようになりました。


