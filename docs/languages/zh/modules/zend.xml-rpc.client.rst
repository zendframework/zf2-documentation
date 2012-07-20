.. _zend.xmlrpc.client:

Zend_XmlRpc_Client
==================

.. _zend.xmlrpc.client.introduction:

介绍
--

Zend Framework 通过 *Zend_XmlRpc_Client* 作为客户端提供了调用远程 XML-RPC
服务的功能。主要功能包括在 PHP 和 XML-RPC 之间进行类型的自动转换， 服务代理对象（a
server proxy object），和访问服务器的自省功能 （introspection capabilities）。

.. _zend.xmlrpc.client.method-calls:

方法调用
----

*Zend_XmlRpc_Client* 的构造函数接受 XML-RPC 服务器端 URL
地址作为第一个参数。返回新的实例可以用来调用这个服务器端任意数量的远程方法。

使用 XML-RPC 客户端调用远程方法，需要实例化它并且使用 *call()*
实力方法。下面的代码演示了调用 Zend Framework 网站上的 XML-RPC 服务。
你可以使用它测试和学习 *Zend_XmlRpc* 组件。

.. _zend.xmlrpc.client.method-calls.example-1:

.. rubric:: XML-RPC 方法调用

.. code-block::
   :linenos:

   require_once 'Zend/XmlRpc/Client.php';

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   echo $client->call('test.sayHello');

   // hello


从远程调用返回的 XML-RPC 值将会自动编排和转换为等价的 PHP 原始类型。
在上面的例子中，一个 PHP *string* 会返回并即刻可以使用。

*call()* 方法接受远程调用的名字作为第一个参数。如果远程调用需要其他参数，
可以通过 *call()* 的第二个可选参数使用 *array* 的形式传递到远程方法。

.. _zend.xmlrpc.client.method-calls.example-2:

.. rubric:: XML-RPC 带参数的方法调用

.. code-block::
   :linenos:

   require_once 'Zend/XmlRpc/Client.php';

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   $arg1 = 1.1;
   $arg2 = 'foo';

   $result = $client->call('test.sayHello', array($arg1, $arg2));

   // $result is a native PHP type


如果远程方法不需要任何参数，这个可选参数可以留空或者传递一个空的 *array()*
过去。远程方法的参数数组可以包含原始的 PHP 类型， *Zend_XmlRpc_Value*
对象，或者两种的混合。

*call()* 方法会自动转换 XML-PRC 响应并返回等价的 PHP 原始类型。 返回值的
*Zend_XmlRpc_Response* 对象也可以在调用之后使用 *getLastResponse()* 方法获得。

.. _zend.xmlrpc.value.parameters:

类型及转换
-----

一些远程方法调用时需要参数。它们作为数组传递到 *Zend_XmlRpc_Client* 的 *call()*
方法的第二个参数。每个参数，不论是原始的 PHP 类型， 还是一个对象表示的特定的
XML-RPC 类型（一个 *Zend_XmlRpc_Value* 对象）都会自动转换。

.. _zend.xmlrpc.value.parameters.php-native:

PHP 原始类型作为参数
^^^^^^^^^^^^

原始 PHP 变量如 *string*\ ， *integer*\ ， *float*\ ， *boolean*\ ， *array* 或者 *object*
都可以作为参数传递到 *call()*\ 。 在这种情况下，每个 PHP
原始类型将会自动检测和转换到一个 XML-RPC 类型， 如下表所示：

.. _zend.xmlrpc.value.parameters.php-native.table-1:

.. table:: PHP 与 XML-RPC 的类型转换

   +-----------------+----------+
   |PHP 原始类型         |XML-RPC 类型|
   +=================+==========+
   |integer          |int       |
   +-----------------+----------+
   |double           |double    |
   +-----------------+----------+
   |boolean          |boolean   |
   +-----------------+----------+
   |string           |string    |
   +-----------------+----------+
   |array            |array     |
   +-----------------+----------+
   |associative array|struct    |
   +-----------------+----------+
   |object           |array     |
   +-----------------+----------+

.. note::

   **一个空的数组会如何转换？**

   传递空数组到 XML-RPC 方法，由于它既可表示为一个数组也可表示为一个结构，
   所以会产生问题。 *Zend_XmlRpc_Client* 会监测这种情况并向服务器进行一个
   *system.methodSignature* 请求来决定实际将要转换到的 XML-RPC 类型。

   不过，这样做本身就可能导致问题出现。首先，服务器不支持 *system.methodSignature*
   将会产生一个失败请求，同时 *Zend_XmlRpc_Client* 会强制转换这个值为 XML-RPC
   数组类型。此外，这意味着任何数组参数都可能导致对远端服务器的一次额外请求。

   可以在 XML-RPC 调用前调用 *setSkipSystemLookup()* 方法，以便完全屏蔽这个查询：

   .. code-block::
      :linenos:

      $client->setSkipSystemLookup(true);
      $result = $client->call('foo.bar', array(array()));


.. _zend.xmlrpc.value.parameters.xmlrpc-value:

Zend_XmlRpc_Value 对象作为参数
^^^^^^^^^^^^^^^^^^^^^^^^

也可以创建 *Zend_XmlRpc_Value* 实例作为参数，以表示特定的 XML-RPC
类型。这样做的主要原因如下：

   - 当希望确定的参数类型被传递传递时（例如，方法需要一个整型，
     而可能从数据库获得的是一个字符串）。

   - 当方法需要 *base64* 或者 *dateTime.iso8601* 类型时（这些在 PHP 原始类型中不存在）。

   - 当自动转换失败时（例如，你希望传递一个空的 XML-RPC 结构作为参数。空的结构在
     PHP 中应当是一个空的数组， 但是如果传递一个空数组作为参数，它将被自动转换为
     XML-RPC 数组，虽然它同数组没有联系）。



有两种方法创建 *Zend_XmlRpc_Value* 对象：直接实例化某个 *Zend_XmlRpc_Value*
的子类；或者使用静态工厂方法 *Zend_XmlRpc_Value::getXmlRpcValue()*\ 。

.. _zend.xmlrpc.value.parameters.xmlrpc-value.table-1:

.. table:: Zend_XmlRpc_Value 对象作为 XML-RPC 类型

   +----------------+---------------------------------------+--------------------------+
   |XML-RPC 类型      |Zend_XmlRpc_Value 常量                   |Zend_XmlRpc_Value 对象      |
   +================+=======================================+==========================+
   |int             |Zend_XmlRpc_Value::XMLRPC_TYPE_INTEGER |Zend_XmlRpc_Value_Integer |
   +----------------+---------------------------------------+--------------------------+
   |double          |Zend_XmlRpc_Value::XMLRPC_TYPE_DOUBLE  |Zend_XmlRpc_Value_Double  |
   +----------------+---------------------------------------+--------------------------+
   |boolean         |Zend_XmlRpc_Value::XMLRPC_TYPE_BOOLEAN |Zend_XmlRpc_Value_Boolean |
   +----------------+---------------------------------------+--------------------------+
   |string          |Zend_XmlRpc_Value::XMLRPC_TYPE_STRING  |Zend_XmlRpc_Value_String  |
   +----------------+---------------------------------------+--------------------------+
   |base64          |Zend_XmlRpc_Value::XMLRPC_TYPE_BASE64  |Zend_XmlRpc_Value_Base64  |
   +----------------+---------------------------------------+--------------------------+
   |dateTime.iso8601|Zend_XmlRpc_Value::XMLRPC_TYPE_DATETIME|Zend_XmlRpc_Value_DateTime|
   +----------------+---------------------------------------+--------------------------+
   |array           |Zend_XmlRpc_Value::XMLRPC_TYPE_ARRAY   |Zend_XmlRpc_Value_Array   |
   +----------------+---------------------------------------+--------------------------+
   |struct          |Zend_XmlRpc_Value::XMLRPC_TYPE_STRUCT  |Zend_XmlRpc_Value_Struct  |
   +----------------+---------------------------------------+--------------------------+

.. note::

   **自动转换**

   当创建新的 *Zend_XmlRpc_Value* 对象时，它的值通过 PHP 类型设置。PHP 类型将会通过 PHP
   类型转换到指定的类型。例如， 如果给 *Zend_XmlRpc_Value_Integer*
   对象提供一个字符串，它将由 *(int)$value* 转换。

.. _zend.xmlrpc.client.requests-and-responses:

服务代理对象
------

另一个使用 XML-RPC 客户端调用远程方法的途径是使用服务代理。这是一个 PHP
对象代理远程 XML-RPC 名字空间，使其工作方式尽可能的贴近原始的 PHP 对象。

调用 *Zend_XmlRpc_Client* 实例的 *getProxy()* 方法实例化一个服务器代理。该方法将返回一个
*Zend_XmlRpc_Client_ServerProxy*
实例。对服务器代理方法的任何调用将会传递到远程，而参数的传递就如同其他任何 PHP
方法一样。

.. _zend.xmlrpc.client.requests-and-responses.example-1:

.. rubric:: 代理默认命名空间

.. code-block::
   :linenos:

   require_once 'Zend/XmlRpc/Client.php';

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   $server = $client->getProxy();           // Proxy the default namespace

   $hello = $server->test->sayHello(1, 2);  // test.Hello(1, 2) returns "hello"


*getProxy()* 方法接受一个可选参数作为将要代理的远端服务器的命名空间。
如果没有指定这个命名空间，默认的命名空间会被代理。在下面的例子中，命名空间
*test* 将会被代理。

.. _zend.xmlrpc.client.requests-and-responses.example-2:

.. rubric:: 代理任意命名空间

.. code-block::
   :linenos:

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   $test  = $client->getProxy('test');     // Proxy the "test" namespace

   $hello = $test->sayHello(1, 2);         // test.Hello(1,2) returns "hello"


若远端服务器支持任意深度嵌套的命名空间，仍然可以通过服务器代理使用。例如，
如果上面的例子有一个方法 *test.foo.bar()*\ ，则可以使用 *$test->foo->bar()* 来调用。

.. _zend.xmlrpc.client.error-handling:

错误处理
----

在 XML-RPC 方法中可能出现两种错误：HTTP 错误和 XML-RPC 失败。 *Zend_XmlRpc_Client*
可以识别并分别检测并捕获它们。

.. _zend.xmlrpc.client.error-handling.http:

HTTP 错误
^^^^^^^

当 HTTP 错误发生时，例如远端 HTTP 服务器返回 *404 Not Found*\ ，将会抛出一个
*Zend_XmlRpc_Client_HttpException* 异常。

.. _zend.xmlrpc.client.error-handling.http.example-1:

.. rubric:: 处理 HTTP 错误

.. code-block::
   :linenos:

   $client = new Zend_XmlRpc_Client('http://foo/404');

   try {

       $client->call('bar', array($arg1, $arg2));

   } catch (Zend_XmlRpc_Client_HttpException $e) {

       // $e->getCode() returns 404
       // $e->getMessage() returns "Not Found"

   }


不论是如何使用 XML-RPC 客户端的，当 HTTP 错误发生时，都会抛出
*Zend_XmlRpc_Client_HttpException* 异常。

.. _zend.xmlrpc.client.error-handling.faults:

XML-RPC 失败
^^^^^^^^^^

XML-RPC 失败类似于 PHP 异常。它是从 XML-RPC 方法调用返回的，有着指定的类型，
同时具有错误代码和错误消息。XML-RPC 失败的处理方式随着 *Zend_XmlRpc_Client*
使用方式不同而不同。

当 *call()* 方法或者服务器代理对象被使用时，XML-RPC 失败会抛出一个
*Zend_XmlRpc_Client_FaultException* 异常。异常代码和消息会直接映射到原始的 XML-RPC
失败相应的内容上去。

.. _zend.xmlrpc.client.error-handling.faults.example-1:

.. rubric:: 处理 XML-RPC 失败

.. code-block::
   :linenos:

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   try {

       $client->call('badMethod');

   } catch (Zend_XmlRpc_Client_FaultException $e) {

       // $e->getCode() returns 1
       // $e->getMessage() returns "Unknown method"

   }


当请求时使用 *call()* 方法，会在失败的时候抛出 *Zend_XmlRpc_Client_FaultException*
异常。可以调用 *getLastResponse()* 获得包含在 *Zend_XmlRpc_Response* 对象中的异常。

当请求时使用 *doRequest()* 方法，则不会抛出异常。将返回一个包含错误信息的
*Zend_XmlRpc_Response* 对象。可以使用 *Zend_XmlRpc_Response* 示例的 *isFault()* 方法检查。

.. _zend.xmlrpc.client.introspection:

服务器自省（introspection）
--------------------

一些 XML-RPC 服务器支持 *system.* 命名空间下的自省。 *Zend_XmlRpc_Client*
对这些服务器的这种功能特别进行了支持。

调用 *Zend_XmlRpcClient* 的 *getIntrospector()* 方法可以获得 *Zend_XmlRpc_Client_ServerIntrospection*
实例。 通过它可以使用服务器的自省功能。

.. _zend.xmlrpc.client.request-to-response:

从请求作出回应
-------

本质上说， *Zend_XmlRpc_Client* 实例的 *call()* 方法创建了请求对象（ *Zend_XmlRpc_Request*\
）并将其传递给另一个方法 *doRequest()*\ ， *doRequest()* 方法返回响应对象（
*Zend_XmlRpc_Response*\ ）。

*doRequest()* 方法也可直接调用。

.. _zend.xmlrpc.client.request-to-response.example-1:

.. rubric:: 处理请求作出回应

.. code-block::
   :linenos:

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   $request = new Zend_XmlRpc_Request();
   $request->setMethod('test.sayHello');
   $request->setParams(array('foo', 'bar'));

   $client->doRequest($request);

   // $server->getLastRequest() returns instanceof Zend_XmlRpc_Request
   // $server->getLastResponse() returns instanceof Zend_XmlRpc_Response


无论客户端通过任何方法调用 XML-RPC 方法，如 *call()* 方法、 *doRequest()*
方法或者服务器代理，最后一个请求对象以及对应的响应对象总是可以分别调用
*getLastRequest()* 和 *getLastResponse()* 获得。

.. _zend.xmlrpc.client.http-client:

HTTP 客户端和测试
-----------

在前面所有的例子中，从未指定 HTTP 客户端。这是因为在使用 *Zend_XmlRpc_Client*
时会使用默认配置自动创建一个 *Zend_Http_Client* 实例。

可以在任何时候使用 *getHttpClient()* 方法获得 HTTP 客户端。 多数情况下默认的 HTTP
客户端已经足够使用。不过仍然可以使用 *setHttpClient()* 方法设置新的 HTTP 客户端实例。

*setHttpClient()* 在单元测试时特别有用。在 *Zend_Http_Client_Adapter_Test*
中测试时可以欺骗远程服务器。阅读 *Zend_XmlRpc_Client* 的单元测试了解如何这样做。


