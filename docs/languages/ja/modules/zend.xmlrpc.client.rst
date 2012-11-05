.. EN-Revision: none
.. _zend.xmlrpc.client:

Zend\XmlRpc\Client
==================

.. _zend.xmlrpc.client.introduction:

導入
--

Zend Framework では、クライアントとしてリモートの *XML-RPC*
サービスを使用することもサポートしています。そのためには ``Zend\XmlRpc\Client``
パッケージを使用します。 主な機能には、 *PHP* と *XML-RPC*
の間の型変換やサーバのプロキシオブジェクト、
そしてサーバが提供する機能を調べることなどがあります。

.. _zend.xmlrpc.client.method-calls:

メソッドのコール
--------

``Zend\XmlRpc\Client`` のコンストラクタは、 リモート *XML-RPC* サーバの *URL*
を最初の引数として受け取ります。 返されたインスタンスを使用して、
その場所からさまざまなリモートメソッドを実行します。

リモートメソッドを *XML-RPC* クライアントからコールするには、
インスタンスを作成した後で ``call()`` メソッドをコールします。 以下の例では Zend
Framework のウェブサイト上にあるデモ用の *XML-RPC* サーバを使用します。 ``Zend_XmlRpc``
のテストや調査のために、このサーバを使用できます。

.. _zend.xmlrpc.client.method-calls.example-1:

.. rubric:: XML-RPC メソッドのコール

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   echo $client->call('test.sayHello');

   // hello

リモートメソッドのコールによって返される *XML-RPC* の値は、 自動的に *PHP*
のネイティブ型に変換されます。 上の例では *PHP* の ``String`` が返されるので、
それをそのまま使用できます。

``call()`` メソッドの最初のパラメータは、 コールするリモートメソッドの名前です。
そのリモートメソッドが何らかのパラメータを要求する場合は、それを ``call()``
の二番目のオプションのパラメータで指定します。
このパラメータには、リモートメソッドに渡す値を配列で指定します。

.. _zend.xmlrpc.client.method-calls.example-2:

.. rubric:: パラメータを指定した XML-RPC メソッドのコール

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   $arg1 = 1.1;
   $arg2 = 'foo';

   $result = $client->call('test.sayHello', array($arg1, $arg2));

   // $result はネイティブな PHP の型になります

リモートメソッドがパラメータを要求していない場合は、
このパラメータには何も指定しません。あるいは空の ``array()``
を渡します。リモートメソッドに渡すパラメータの配列には、 ネイティブの *PHP*
型と ``Zend\XmlRpc\Value``
オブジェクトの両方を使用できます。それらを混用することも可能です。

``call()`` メソッドは自動的に *XML-RPC* のレスポンスを変換し、 同等な *PHP*
ネイティブ型にして返します。返り値を ``Zend\XmlRpc\Response``
オブジェクトとして取得するには、 このメソッドの後で ``getLastResponse()``
をコールします。

.. _zend.xmlrpc.value.parameters:

型およびその変換
--------

リモートメソッドの中にはパラメータが必要なものがあります。
必要なパラメータは、 ``Zend\XmlRpc\Client`` の ``call()``
メソッドの二番目のパラメータとして配列で指定します。 パラメータを渡す方法は 2
通りあります。 *PHP* のネイティブ型 (これは自動的に変換されます) で渡すか、
対応する *XML-RPC* 型 (``Zend\XmlRpc\Value`` オブジェクトのひとつ)
で渡すかのいずれかです。

.. _zend.xmlrpc.value.parameters.php-native:

PHP ネイティブ変数をパラメータとして渡す
^^^^^^^^^^^^^^^^^^^^^^

``call()`` のパラメータをネイティブの *PHP* 型で渡します。つまり ``String``\ 、
``Integer``\ 、 ``Float``\ 、 ``Boolean``\ 、 ``Array`` あるいは ``Object``
で渡すということです。 このとき、 *PHP* のネイティブ型は自動的に検出され、
以下の表にしたがって *XML-RPC* 型に変換されます。

.. _zend.xmlrpc.value.parameters.php-native.table-1:

.. table:: PHP と XML-RPC の間の型変換

   +--------------------------+----------------+
   |PHP ネイティブ型                |XML-RPC 型       |
   +==========================+================+
   |integer                   |int             |
   +--------------------------+----------------+
   |Zend\Crypt_Math\BigInteger|i8              |
   +--------------------------+----------------+
   |double                    |double          |
   +--------------------------+----------------+
   |boolean                   |boolean         |
   +--------------------------+----------------+
   |string                    |string          |
   +--------------------------+----------------+
   |null                      |nil             |
   +--------------------------+----------------+
   |array                     |array           |
   +--------------------------+----------------+
   |associative array         |struct          |
   +--------------------------+----------------+
   |object                    |array           |
   +--------------------------+----------------+
   |Zend_Date                 |dateTime.iso8601|
   +--------------------------+----------------+
   |DateTime                  |dateTime.iso8601|
   +--------------------------+----------------+

.. note::

   **空の配列はどの型に変換されるの?**

   空の配列を *XML-RPC* メソッドに渡すことには問題があります。 それが array と struct
   のどちらにでもとれるからです。 ``Zend\XmlRpc\Client``
   は、このような状況を検出した場合にはサーバの ``system.methodSignature``
   メソッドにリクエストを送り、どの *XML-RPC* 型に変換すべきかを判断します。

   しかし、このやりかた自体にも別の問題があります。 まず、サーバが
   ``system.methodSignature`` をサポートしていない場合には「リクエストに失敗した」
   記録がサーバに残ってしまいます。この場合、 ``Zend\XmlRpc\Client`` は値を *XML-RPC* の
   array 型に変換します。 さらに、このやりかたを使用すると
   「配列形式の引数を指定してコールすると、
   毎回リモートサーバへの余計な呼び出しが発生する」 ということになります。

   この仕組みを無効にするには、 *XML-RPC* コールの前に ``setSkipSystemLookup()``
   メソッドをコールします。

   .. code-block:: php
      :linenos:

      $client->setSkipSystemLookup(true);
      $result = $client->call('foo.bar', array(array()));

.. _zend.xmlrpc.value.parameters.xmlrpc-value:

Zend\XmlRpc\Value オブジェクトをパラメータとして渡す
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

パラメータを表す ``Zend\XmlRpc\Value`` のインスタンスを作成し、 *XML-RPC*
の型を指定することもできます。
このようにする理由には次のようなものがあります。



   - プロシージャに正しい型で渡されることを確実にしたいことがある
     (例えば、integer を要求しているプロシージャに対して
     データベースから取得した文字列を渡したい場合など)。

   - プロシージャが ``base64`` 型や ``dateTime.iso8601`` 型を要求していることがある
     (これらは *PHP* のネイティブ型には存在しません)。

   - 自動変換が失敗する場合 (例えば、空の *XML-RPC*
     構造体をパラメータとして渡すことを考えましょう。 これは、 *PHP*
     では空の配列に対応します。しかし、
     空の配列をパラメータとして渡すと、それが自動変換されたときに *XML-RPC* の array
     になってしまいます。なぜなら、 空の配列は連想配列ではないからです)。



``Zend\XmlRpc\Value`` オブジェクトを作成する方法は 二通りあります。 ``Zend\XmlRpc\Value``
のサブクラスのインスタンスを直接作成するか、 あるいは静的ファクトリメソッド
``Zend\XmlRpc\Value::getXmlRpcValue()`` を使用します。

.. _zend.xmlrpc.value.parameters.xmlrpc-value.table-1:

.. table:: Zend\XmlRpc\Value オブジェクトと対応する XML-RPC 型

   +----------------+----------------------------------------+------------------------------------+
   |XML-RPC 型       |対応する Zend\XmlRpc\Value 定数               |Zend\XmlRpc\Value オブジェクト            |
   +================+========================================+====================================+
   |int             |Zend\XmlRpc\Value::XMLRPC_TYPE_INTEGER  |Zend\XmlRpc_Value\Integer           |
   +----------------+----------------------------------------+------------------------------------+
   |i8              |Zend\XmlRpc\Value::XMLRPC_TYPE_I8       |Zend\XmlRpc_Value\BigInteger        |
   +----------------+----------------------------------------+------------------------------------+
   |ex:i8           |Zend\XmlRpc\Value::XMLRPC_TYPE_APACHEI8 |Zend\XmlRpc_Value\BigInteger        |
   +----------------+----------------------------------------+------------------------------------+
   |double          |Zend\XmlRpc\Value::XMLRPC_TYPE_DOUBLE   |Zend\XmlRpc_Value\Double            |
   +----------------+----------------------------------------+------------------------------------+
   |boolean         |Zend\XmlRpc\Value::XMLRPC_TYPE_BOOLEAN  |Zend\XmlRpc_Value\Boolean           |
   +----------------+----------------------------------------+------------------------------------+
   |string          |Zend\XmlRpc\Value::XMLRPC_TYPE_STRING   |Zend\XmlRpc_Value\String            |
   +----------------+----------------------------------------+------------------------------------+
   |nil             |Zend\XmlRpc\Value::XMLRPC_TYPE_NIL      |Zend\XmlRpc_Value\Nil               |
   +----------------+----------------------------------------+------------------------------------+
   |ex:nil          |Zend\XmlRpc\Value::XMLRPC_TYPE_APACHENIL|Zend\XmlRpc_Value\Nil               |
   +----------------+----------------------------------------+------------------------------------+
   |base64          |Zend\XmlRpc\Value::XMLRPC_TYPE_BASE64   |Zend\XmlRpc_Value\Base64            |
   +----------------+----------------------------------------+------------------------------------+
   |dateTime.iso8601|Zend\XmlRpc\Value::XMLRPC_TYPE_DATETIME |Zend\XmlRpc_Value\DateTime          |
   +----------------+----------------------------------------+------------------------------------+
   |array           |Zend\XmlRpc\Value::XMLRPC_TYPE_ARRAY    |Zend\XmlRpc_Value\Array             |
   +----------------+----------------------------------------+------------------------------------+
   |struct          |Zend\XmlRpc\Value::XMLRPC_TYPE_STRUCT   |Zend\XmlRpc_Value\Struct            |
   +----------------+----------------------------------------+------------------------------------+

.. note::

   **自動変換**

   新しい ``Zend\XmlRpc\Value`` オブジェクトを作成する際には、 その値は *PHP*
   の型として設定されます。この *PHP* の型は、 *PHP*
   のキャスト機能によって変換されます。 たとえば、 ``Zend\XmlRpc_Value\Integer``
   に文字列を渡すと、 ``(int)$value`` のように変換されます。

.. _zend.xmlrpc.client.requests-and-responses:

サーバプロキシオブジェクト
-------------

リモートメソッドを *XML-RPC* クライアントからコールするもうひとつの方法は、
サーバプロキシを使用することです。 サーバプロキシとはリモートの *XML-RPC*
名前空間のプロキシとなる *PHP* オブジェクトで、ネイティブな *PHP*
オブジェクトと可能な限り同じように扱えるようにしたものです。

サーバプロキシのインスタンスを作成するには、 ``Zend\XmlRpc\Client``
のインスタンスメソッド ``getProxy()`` をコールします。これは
``Zend\XmlRpc_Client\ServerProxy`` のインスタンスを返します。
サーバプロキシに対するあらゆるメソッドコールはリモートに転送され、
パラメータも通常の *PHP* メソッドと同じように渡せます。

.. _zend.xmlrpc.client.requests-and-responses.example-1:

.. rubric:: デフォルト名前空間のプロキシ

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   $service = $client->getProxy();           // デフォルトの名前空間のプロキシを作成します

   $hello = $service->test->sayHello(1, 2);  // test.Hello(1, 2) は "hello" を返します

``getProxy()`` のオプションの引数で、
リモートサーバのどの名前空間をプロキシするかを指定できます。
名前空間を指定しなかった場合は、デフォルトの名前空間をプロキシします。
次の例では、 'test' 名前空間がプロキシの対象となります。

.. _zend.xmlrpc.client.requests-and-responses.example-2:

.. rubric:: 任意の名前空間のプロキシ

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   $test  = $client->getProxy('test');     // "test" 名前空間のプロキシを作成します

   $hello = $test->sayHello(1, 2);         // test.Hello(1,2) は "hello" を返します

リモートサーバが入れ子状の名前空間をサポートしている場合は、
サーバプロキシでもそれを使用できます。たとえば、 上の例のサーバがメソッド
``test.foo.bar()`` を保持している場合は、 ``$test->foo->bar()`` のようにコールします。

.. _zend.xmlrpc.client.error-handling:

エラー処理
-----

*XML-RPC* のメソッドコールで発生する可能性のあるエラーには、二種類あります。
*HTTP* のエラーと *XML-RPC* の fault です。 ``Zend\XmlRpc\Client``
はこれらの両方を理解するので、それぞれ独立して検出と処理が可能です。

.. _zend.xmlrpc.client.error-handling.http:

HTTP エラー
^^^^^^^^

*HTTP* エラーが発生した場合、 つまり、たとえばリモート *HTTP* サーバが **404 Not Found**
を返したような場合に ``Zend\XmlRpc_Client\HttpException`` がスローされます。

.. _zend.xmlrpc.client.error-handling.http.example-1:

.. rubric:: HTTP エラーの処理

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://foo/404');

   try {

       $client->call('bar', array($arg1, $arg2));

   } catch (Zend\XmlRpc_Client\HttpException $e) {

       // $e->getCode() は 404 を返します
       // $e->getMessage() は "Not Found" を返します

   }

*XML-RPC* クライアントの使用法にかかわらず、 *HTTP* エラーが発生すると必ず
``Zend\XmlRpc_Client\HttpException`` がスローされます。

.. _zend.xmlrpc.client.error-handling.faults:

XML-RPC Fault
^^^^^^^^^^^^^

*XML-RPC* の fault は、 *PHP* の例外と似たものです。これは *XML-RPC*
メソッドのコールから返される特別な型で、
エラーコードとエラーメッセージを含みます。 *XML-RPC* の fault は、 ``Zend\XmlRpc\Client``
の使用場面によって処理方法が異なります。

``call()`` メソッドや サーバプロキシオブジェクトを使用している場合には、 *XML-RPC*
の fault が発生すると ``Zend\XmlRpc_Client\FaultException`` がスローされます。
この例外のコードとメッセージは、もとの *XML-RPC* の fault
レスポンスの値に対応するものとなります。

.. _zend.xmlrpc.client.error-handling.faults.example-1:

.. rubric:: XML-RPC Fault の処理

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   try {

       $client->call('badMethod');

   } catch (Zend\XmlRpc_Client\FaultException $e) {

       // $e->getCode() は 1 を返します
       // $e->getMessage() は "Unknown method" を返します

   }

``call()`` メソッドを使用してリクエストを作成した場合は、 fault の際に
``Zend\XmlRpc_Client\FaultException`` がスローされます。fault を含む ``Zend\XmlRpc\Response``
オブジェクトを取得するには ``getLastResponse()`` をコールします。

``doRequest()`` メソッドでリクエストを作成した場合は、
例外はスローされません。そのかわりに、falut を含む ``Zend\XmlRpc\Response``
オブジェクトを返します。 これを調べるには、 ``Zend\XmlRpc\Response``
のインスタンスメソッド ``isFault()`` を使用します。

.. _zend.xmlrpc.client.introspection:

サーバのイントロスペクション
--------------

*XML-RPC* サーバの中には、 *XML-RPC* の **system.** 名前空間で
デファクトのイントロスペクションメソッドをサポートしているものもあります。
``Zend\XmlRpc\Client`` は、この機能を持つサーバもサポートしています。

``Zend_XmlRpcClient`` の ``getIntrospector()`` メソッドをコールすると、
``Zend\XmlRpc_Client\ServerIntrospection`` のインスタンスを取得できます。
これを使用してサーバのイントロスペクションを行います。

.. _zend.xmlrpc.client.request-to-response:

リクエストからレスポンスへ
-------------

``Zend\XmlRpc\Client`` のインスタンスメソッド ``call()`` 中で行われていることは、
まずリクエストオブジェクト (``Zend\XmlRpc\Request``) を作成し、 それを別のメソッド
``doRequest()`` で送信し、 その結果返されるレスポンスオブジェクト
(``Zend\XmlRpc\Response``) を取得するということです。

``doRequest()`` メソッドは、それ単体で直接使用することもできます。

.. _zend.xmlrpc.client.request-to-response.example-1:

.. rubric:: リクエストからレスポンスへの処理

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   $request = new Zend\XmlRpc\Request();
   $request->setMethod('test.sayHello');
   $request->setParams(array('foo', 'bar'));

   $client->doRequest($request);

   // $client->getLastRequest() は Zend\XmlRpc\Request のインスタンスを返します
   // $client->getLastResponse() は Zend\XmlRpc\Response のインスタンスを返します

クライアントから *XML-RPC* メソッドのコールが (``call()`` メソッド、 ``doRequest()``
メソッドあるいはサーバプロキシによって)
行われた場合は、最後のリクエストオブジェクトおよびその応答が常に
``getLastRequest()`` および ``getLastResponse()`` で取得できます。

.. _zend.xmlrpc.client.http-client:

HTTP クライアントのテスト
---------------

これまでのすべての例では、 *HTTP* クライアントの設定を行いませんでした。
このような場合、 ``Zend\Http\Client``
の新しいインスタンスがデフォルトのオプションで作成され、それを自動的に
``Zend\XmlRpc\Client`` で使用します。

*HTTP* クライアントは、いつでも ``getHttpClient()`` メソッドで取得できます。
たいていの場合はデフォルトの *HTTP* クライアントで用が足りるでしょう。 しかし、
``setHttpClient()`` を使用することで、 別の *HTTP*
クライアントのインスタンスを使うこともできます。

``setHttpClient()`` は、特に単体テストの際に有用です。 ``Zend\Http\Client\Adapter\Test``
と組み合わせることで、 テスト用のリモートサービスのモックを作成できます。
この方法を調べるには、 ``Zend\XmlRpc\Client`` 自体の単体テストを参照ください。


