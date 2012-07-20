.. _zend.xmlrpc.server:

Zend_XmlRpc_Server
==================

.. _zend.xmlrpc.server.introduction:

導入
--

``Zend_XmlRpc_Server`` は、完全な機能を有した *XML-RPC* サーバです。 `www.xmlrpc.com
で提示されている仕様`_ に準拠しています。 さらに ``system.multicall()``
メソッドを実装しており、 リクエストをまとめる (boxcarring of requests)
ことができます。

.. _zend.xmlrpc.server.usage:

基本的な使用法
-------

もっとも基本的な使用例は次のとおりです。

.. code-block:: php
   :linenos:

   $server = new Zend_XmlRpc_Server();
   $server->setClass('My_Service_Class');
   echo $server->handle();

.. _zend.xmlrpc.server.structure:

サーバの構造
------

``Zend_XmlRpc_Server`` はさまざまなコンポーネントで構成されています。
サーバ自身からリクエスト、レスポンス、fault
オブジェクトなど広範囲に広がっています。

``Zend_XmlRpc_Server`` を起動するには、
まずサーバにひとつ以上のクラスか関数をアタッチする必要があります。
アタッチするには ``setClass()`` メソッドおよび ``addFunction()`` メソッドを使用します。

起動させたら、次に ``Zend_XmlRpc_Request`` オブジェクトを ``Zend_XmlRpc_Server::handle()``
に渡します。 もし渡さなかった場合は、 ``Zend_XmlRpc_Request_Http``
のインスタンスを作成して ``php://input`` からの入力を受け取ります。

``Zend_XmlRpc_Server::handle()`` は、
リクエストメソッドに応じて適切なハンドラに処理を振り分けます。 そして、
``Zend_XmlRpc_Response`` を継承したオブジェクトか ``Zend_XmlRpc_Server_Fault``
オブジェクトを返します。 これらのオブジェクトはどちらも ``__toString()``
メソッドを実装しており、妥当な *XML-RPC* *XML* レスポンスを直接出力できます。

.. _zend.xmlrpc.server.anatomy:

Anatomy of a webservice
-----------------------

.. _zend.xmlrpc.server.anatomy.general:

General considerations
^^^^^^^^^^^^^^^^^^^^^^

For maximum performance it is recommended to use a simple bootstrap file for the server component. Using
``Zend_XmlRpc_Server`` inside a :ref:`Zend_Controller <zend.controller>` is strongly discouraged to avoid the
overhead.

Services change over time and while webservices are generally less change intense as code-native *APIs*, it is
recommended to version your service. Do so to lay grounds to provide compatibility for clients using older versions
of your service and manage your service lifecycle including deprecation timeframes.To do so just include a version
number into your *URI*. It is also recommended to include the remote protocol name in the *URI* to allow easy
integration of upcoming remoting technologies. http://myservice.ws/**1.0/XMLRPC/**.

.. _zend.xmlrpc.server.anatomy.expose:

What to expose?
^^^^^^^^^^^^^^^

Most of the time it is not sensible to expose business objects directly. Business objects are usually small and
under heavy change, because change is cheap in this layer of your application. Once deployed and adopted, web
services are hard to change. Another concern is *I/O* and latency: the best webservice calls are those not
happening. Therefore service calls need to be more coarse-grained than usual business logic is. Often an additional
layer in front of your business objects makes sense. This layer is sometimes referred to as `Remote Facade`_. Such
a service layer adds a coarse grained interface on top of your business logic and groups verbose operations into
smaller ones.

.. _zend.xmlrpc.server.conventions:

規約
--

``Zend_XmlRpc_Server`` では、開発者が関数やクラスメソッドを *XML-RPC*
メソッドとしてアタッチできるようになっています。
アタッチされるメソッドの情報は ``Zend_Server_Reflection``
を使用して取得し、関数やメソッドのコメントブロックから
メソッドのヘルプ文とシグネチャを取得します。

*XML-RPC* の型は必ずしも *PHP* の型と一対一対応しているわけではありません。
しかし、@param や @return の行をもとに、できるだけ適切な型を推測しようとします。
*XML-RPC* の型の中には、直接対応する *PHP* の型がないものもありますが、 その場合は
PHPDoc の中で *XML-RPC* の型のヒントを指定します。
たとえば次のような型が該当します。

- **dateTime.iso8601**... '``YYYYMMDDTHH:mm:ss``' 形式の文字列

- **base64**... base64 エンコードされたデータ

- **struct**... 任意の連想配列

ヒントを指定するには、次のようにします。

.. code-block:: php
   :linenos:

   /**
   * これはサンプル関数です
   *
   * @param base64 $val1 Base64 エンコードされたデータ
   * @param dateTime.iso8601 $val2 ISO 日付
   * @param struct $val3 連想配列
   * @return struct
   */
   function myFunc($val1, $val2, $val3)
   {
   }

PhpDocumentor はパラメータや返り値の型を検証しません。 そのため、これが *API*
ドキュメントに影響を及ぼすことはありません。
しかし、このヒントは必須です。メソッドがコールされた際に、
この情報をもとにサーバで検証を行うからです。

パラメータや返り値で複数の型を指定してもかまいません。 *XML-RPC*
の仕様では、system.methodSignature は すべてのメソッドシグネチャ
(すなわちパラメータと返り値の組み合わせ) の配列を返すことになっています。
複数指定する方法は、通常の PhpDocumentor の場合と同様に '\|' 演算子を使用します。

.. code-block:: php
   :linenos:

   /**
   * This is a sample function
   *
   * @param string|base64 $val1 文字列あるいは base64 エンコードされたデータ
   * @param string|dateTime.iso8601 $val2 文字列あるいは ISO 日付
   * @param array|struct $val3 Normal 数値添字配列あるいは連想配列
   * @return boolean|struct
   */
   function myFunc($val1, $val2, $val3)
   {
   }

.. note::

   複数のシグネチャを定義すると、それを利用する開発者を混乱させてしまいます。
   物事を簡単にするために、 *XML-RPC*
   サービスのメソッドは単純なシグネチャだけを持つべきでしょう。

.. _zend.xmlrpc.server.namespaces:

名前空間の活用
-------

*XML-RPC* には名前空間の概念があります。基本的に、これは 複数の *XML-RPC*
メソッドをドット区切りの名前空間でまとめるものです。
これにより、さまざまなクラスで提供されるメソッド名の衝突を避けることができます。
例として、 *XML-RPC* サーバは 'system'
名前空間でこれらのメソッドを提供することが期待されています。

- system.listMethods

- system.methodHelp

- system.methodSignature

内部的には、これらは ``Zend_XmlRpc_Server`` の同名のメソッドに対応しています。

自分が提供するメソッドに名前空間を追加したい場合は、
関数やクラスをアタッチする際のメソッドで名前空間を指定します。

.. code-block:: php
   :linenos:

   // My_Service_Class のパブリックメソッドは、すべて
   // myservice.メソッド名 でアクセスできるようになります
   $server->setClass('My_Service_Class', 'myservice');

   // 関数 'somefunc' は funcs.somefunc としてアクセスするようにします
   $server->addFunction('somefunc', 'funcs');

.. _zend.xmlrpc.server.request:

独自のリクエストオブジェクト
--------------

ほとんどの場合は、 ``Zend_XmlRpc_Server`` や ``Zend_XmlRpc_Request_Http``
に含まれるデフォルトのリクエスト型を使用するでしょう。 しかし、 *XML-RPC* を *CLI*
や *GUI* 環境などで動かしたい場合もあるでしょうし、
リクエストの内容をログに記録したい場合もあるでしょう。 そのような場合には、
``Zend_XmlRpc_Request`` を継承した独自のリクエストオブジェクトを作成します。
注意すべき点は、 ``getMethod()`` メソッドと ``getParams()``
メソッドを必ず実装しなければならないということです。 これらは、 *XML-RPC*
サーバがリクエストを処理する際に必要となります。

.. _zend.xmlrpc.server.response:

独自のレスポンス
--------

リクエストオブジェクトと同様、 ``Zend_XmlRpc_Server``
は独自のレスポンスオブジェクトを返すこともできます。 デフォルトでは
``Zend_XmlRpc_Response_Http`` オブジェクトが返されます。 これは、 *XML-RPC*
で使用される適切な Content-Type *HTTP*
ヘッダを送信します。独自のオブジェクトを使用する場面としては、
レスポンスをログに記録したり、
あるいはレスポンスを標準出力に返したりといったことが考えられます。

独自のレスポンスクラスを使用するには、 ``handle()`` をコールする前に
``Zend_XmlRpc_Server::setResponseClass()`` を使用します。

.. _zend.xmlrpc.server.fault:

Fault による例外の処理
--------------

``Zend_XmlRpc_Server`` は、配送先のメソッドで発生した例外を捕捉します。
例外を捕捉した場合は、 *XML-RPC* の fault レスポンスを生成します。
しかし、デフォルトでは、例外メッセージとコードは fault
レスポンスで用いられません。これは、
あなたのコードを守るための判断によるものです。
たいていの例外は、コードや環境に関する情報を必要以上にさらけ出してしまいます
(わかりやすい例だと、データベースの抽象化レイヤの例外を想像してみてください)。

しかし、例外クラスをホワイトリストに登録することで、 fault
レスポンス内で例外を使用することもできます。 そうするには、
``Zend_XmlRpc_Server_Fault::attachFaultException()``
を使用して例外クラスをホワイトリストに渡します。

.. code-block:: php
   :linenos:

   Zend_XmlRpc_Server_Fault::attachFaultException('My_Project_Exception');

他のプロジェクトの例外を継承した例外クラスを利用するのなら、
一連のクラス群を一度にホワイトリストに登録することもできます。
``Zend_XmlRpc_Server_Exceptions`` は常にホワイトリストに登録されており、
固有の内部エラー (メソッドが未定義であるなど) を報告できます。

ホワイトリストに登録されていない例外が発生した場合は、 コード '404'、メッセージ
'Unknown error' の falut レスポンスを生成します。

.. _zend.xmlrpc.server.caching:

リクエスト間でのサーバ定義のキャッシュ
-------------------

たくさんのクラスを *XML-RPC* サーバインスタンスにアタッチすると、
リソースを大量に消費してしまいます。各クラスを調べるために リフレクション *API*
を (``Zend_Server_Reflection`` 経由で) 使用する必要があり、
使用できるすべてのメソッドのシグネチャをサーバクラスに提供します。

使用するリソースの量を軽減するために、 ``Zend_XmlRpc_Server_Cache``
を用いてリクエスト間でサーバ定義をキャッシュできます。 ``__autoload()``
と組み合わせることで、これはパフォーマンスを劇的に向上させます。

使用例は次のようになります。

.. code-block:: php
   :linenos:

   function __autoload($class)
   {
       Zend_Loader::loadClass($class);
   }

   $cacheFile = dirname(__FILE__) . '/xmlrpc.cache';
   $server = new Zend_XmlRpc_Server();

   if (!Zend_XmlRpc_Server_Cache::get($cacheFile, $server)) {
       require_once 'My/Services/Glue.php';
       require_once 'My/Services/Paste.php';
       require_once 'My/Services/Tape.php';

       $server->setClass('My_Services_Glue', 'glue');   // glue. 名前空間
       $server->setClass('My_Services_Paste', 'paste'); // paste. 名前空間
       $server->setClass('My_Services_Tape', 'tape');   // tape. 名前空間

       Zend_XmlRpc_Server_Cache::save($cacheFile, $server);
   }

   echo $server->handle();

この例では、スクリプトと同じディレクトリにある ``xmlrpc.cache``
からサーバの定義を取得しようとします。取得できなかった場合は、
必要なサービスクラスを読み込み、 それをサーバのインスタンスにアタッチし、
そしてその定義を新しいキャッシュファイルに記録します。

.. _zend.xmlrpc.server.use:

使用例
---

以下のいくつかの使用例で、開発者が使用できるオプションを説明します。
各使用例は、それまでに紹介した例に追加していく形式になります。

.. _zend.xmlrpc.server.use.attach-function:

.. rubric:: 基本的な使用法

次の例は関数を *XML-RPC* メソッドとしてアタッチし、
受け取ったコールを処理します。

.. code-block:: php
   :linenos:

   /**
    * 値の MD5 合計を返します
    *
    * @param string $value md5sum を計算する値
    * @return string 値の MD5 合計
    */
   function md5Value($value)
   {
       return md5($value);
   }

   $server = new Zend_XmlRpc_Server();
   $server->addFunction('md5Value');
   echo $server->handle();

.. _zend.xmlrpc.server.use.attach-class:

.. rubric:: クラスのアタッチ

次の例は、クラスのパブリックメソッドを *XML-RPC* メソッドとしてアタッチします。

.. code-block:: php
   :linenos:

   require_once 'Services/Comb.php';

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb');
   echo $server->handle();

.. _zend.xmlrpc.server.use.attach-class-with-arguments:

.. rubric:: Attaching a class with arguments

The following example illustrates how to attach a class' public methods and passing arguments to its methods. This
can be used to specify certain defaults when registering service classes.

.. code-block:: php
   :linenos:

   class Services_PricingService
   {
       /**
        * Calculate current price of product with $productId
        *
        * @param ProductRepository $productRepository
        * @param PurchaseRepository $purchaseRepository
        * @param integer $productId
        */
       public function calculate(ProductRepository $productRepository,
                                 PurchaseRepository $purchaseRepository,
                                 $productId)
       {
           ...
       }
   }

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_PricingService',
                     'pricing',
                     new ProductRepository(),
                     new PurchaseRepository());

The arguments passed at ``setClass()`` at server construction time are injected into the method call
``pricing.calculate()`` on remote invokation. In the example above, only the argument *$purchaseId* is expected
from the client.

.. _zend.xmlrpc.server.use.attach-class-with-arguments-constructor:

.. rubric:: Passing arguments only to constructor

``Zend_XmlRpc_Server`` allows to restrict argument passing to constructors only. This can be used for constructor
dependency injection. To limit injection to constructors, call ``sendArgumentsToAllMethods`` and pass ``FALSE`` as
an argument. This disables the default behavior of all arguments being injected into the remote method. In the
example below the instance of ``ProductRepository`` and ``PurchaseRepository`` is only injected into the
constructor of ``Services_PricingService2``.

.. code-block:: php
   :linenos:

   class Services_PricingService2
   {
       /**
        * @param ProductRepository $productRepository
        * @param PurchaseRepository $purchaseRepository
        */
       public function __construct(ProductRepository $productRepository,
                                   PurchaseRepository $purchaseRepository)
       {
           ...
       }

       /**
        * Calculate current price of product with $productId
        *
        * @param integer $productId
        * @return double
        */
       public function calculate($productId)
       {
           ...
       }
   }

   $server = new Zend_XmlRpc_Server();
   $server->sendArgumentsToAllMethods(false);
   $server->setClass('Services_PricingService2',
                     'pricing',
                     new ProductRepository(),
                     new PurchaseRepository());

.. _zend.xmlrpc.server.use.attach-instance:

.. rubric:: Attaching a class instance

``setClass()`` allows to register a previously instantiated object at the server. Just pass an instance instead of
the class name. Obviously passing arguments to the constructor is not possible with pre-instantiated objects.

.. _zend.xmlrpc.server.use.attach-several-classes-namespaces:

.. rubric:: 名前空間を用いた複数のクラスのアタッチ

次の例は、複数のクラスをそれぞれの名前空間でアタッチします。

.. code-block:: php
   :linenos:

   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb', 'comb');   // メソッドをコールするには comb.* とします
   $server->setClass('Services_Brush', 'brush'); // メソッドをコールするには brush.* とします
   $server->setClass('Services_Pick', 'pick');   // メソッドをコールするには pick.* とします
   echo $server->handle();

.. _zend.xmlrpc.server.use.exceptions-faults:

.. rubric:: fault レスポンス用に使用する例外の指定

次の例は、 ``Services_Exception`` の派生クラスに対して そのコードとメッセージを falut
レスポンスで報告させるようにします。

.. code-block:: php
   :linenos:

   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Services_Exceptions を fault レスポンスで報告させるようにします
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb', 'comb');   // メソッドをコールするには comb.* とします
   $server->setClass('Services_Brush', 'brush'); // メソッドをコールするには brush.* とします
   $server->setClass('Services_Pick', 'pick');   // メソッドをコールするには pick.* とします
   echo $server->handle();

.. _zend.xmlrpc.server.use.custom-request-object:

.. rubric:: 独自のリクエスト及びレスポンスオブジェクトの利用

Some use cases require to utilize a custom request object. For example, *XML/RPC* is not bound to *HTTP* as a
transfer protocol. It is possible to use other transfer protocols like *SSH* or telnet to send the request and
response data over the wire. Another use case is authentication and authorization. In case of a different transfer
protocol, one need to change the implementation to read request data.

次の例は、独自のリクエストオブジェクトを作成し、
それをサーバに渡して処理します。

.. code-block:: php
   :linenos:

   require_once 'Services/Request.php';
   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Services_Exceptions を fault レスポンスで報告させるようにします
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb', 'comb');   // メソッドをコールするには comb.* とします
   $server->setClass('Services_Brush', 'brush'); // メソッドをコールするには brush.* とします
   $server->setClass('Services_Pick', 'pick');   // メソッドをコールするには pick.* とします

   // リクエストオブジェクトを作成します
   $request = new Services_Request();

   echo $server->handle($request);

.. _zend.xmlrpc.server.use.custom-response-object:

.. rubric:: 独自のレスポンスクラスの指定

次の例は、独自のレスポンスクラスを作成し、 それをレスポンスとして返します。

.. code-block:: php
   :linenos:

   require_once 'Services/Request.php';
   require_once 'Services/Response.php';
   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Services_Exceptions を fault レスポンスで報告させるようにします
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb', 'comb');   // メソッドをコールするには comb.* とします
   $server->setClass('Services_Brush', 'brush'); // メソッドをコールするには brush.* とします
   $server->setClass('Services_Pick', 'pick');   // メソッドをコールするには pick.* とします

   // リクエストオブジェクトを作成します
   $request = new Services_Request();

   // 独自のレスポンスを使用します
   $server->setResponseClass('Services_Response');

   echo $server->handle($request);

.. _zend.xmlrpc.server.performance:

パフォーマンスの最適化
-----------

.. _zend.xmlrpc.server.performance.caching:

.. rubric:: リクエスト間でのサーバ定義のキャッシュ

次の例は、リクエスト間でサーバ定義をキャッシュします。

.. code-block:: php
   :linenos:

   // キャッシュファイルを指定します
   $cacheFile = dirname(__FILE__) . '/xmlrpc.cache';

   // Services_Exceptions を fault レスポンスで報告させるようにします
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();

   // サーバ定義をキャッシュから取得しようとします
   if (!Zend_XmlRpc_Server_Cache::get($cacheFile, $server)) {
       $server->setClass('Services_Comb', 'comb');   // メソッドをコールするには comb.* とします
       $server->setClass('Services_Brush', 'brush'); // メソッドをコールするには brush.* とします
       $server->setClass('Services_Pick', 'pick');   // メソッドをコールするには pick.* とします

       // キャッシュに保存します
       Zend_XmlRpc_Server_Cache::save($cacheFile, $server);
   }

   // リクエストオブジェクトを作成します
   $request = new Services_Request();

   // 独自のレスポンスを使用します
   $server->setResponseClass('Services_Response');

   echo $server->handle($request);

.. note::

   The server cache file should be located outside the document root.

.. _zend.xmlrpc.server.performance.xmlgen:

.. rubric:: Optimizing XML generation

``Zend_XmlRpc_Server`` uses ``DOMDocument`` of *PHP* extension *ext/dom* to generate it's *XML* output. While
*ext/dom* is available on a lot of hosts it is not exactly the fastest. Benchmarks have shown, that ``XmlWriter``
from *ext/xmlwriter* performs better.

If *ext/xmlwriter* is available on your host, you can select a the ``XmlWriter``-based generator to leaverage the
performance differences.

.. code-block:: php
   :linenos:

   require_once 'Zend/XmlRpc/Server.php';
   require_once 'Zend/XmlRpc/Generator/XmlWriter.php';

   Zend_XmlRpc_Value::setGenerator(new Zend_XmlRpc_Generator_XmlWriter());

   $server = new Zend_XmlRpc_Server();
   ...

.. note::

   **Benchmark your application**

   Performance is determined by a lot of parameters and benchmarks only apply for the specific test case.
   Differences come from *PHP* version, installed extensions, webserver and operating system just to name a few.
   Please make sure to benchmark your application on your own and decide which generator to use based on **your**
   numbers.

.. note::

   **Benchmark your client**

   This optimization makes sense for the client side too. Just select the alternate *XML* generator before doing
   any work with ``Zend_XmlRpc_Client``.



.. _`www.xmlrpc.com で提示されている仕様`: http://www.xmlrpc.com/spec
.. _`Remote Facade`: http://martinfowler.com/eaaCatalog/remoteFacade.html
