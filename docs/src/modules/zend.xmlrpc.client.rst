.. _zend.xmlrpc.client:

Zend\\XmlRpc\\Client
====================

.. _zend.xmlrpc.client.introduction:

Introduction
------------

Zend Framework provides support for consuming remote *XML-RPC* services as a client in the ``Zend\XmlRpc\Client``
package. Its major features include automatic type conversion between *PHP* and *XML-RPC*, a server proxy object,
and access to server introspection capabilities.

.. _zend.xmlrpc.client.method-calls:

Method Calls
------------

The constructor of ``Zend\XmlRpc\Client`` receives the *URL* of the remote *XML-RPC* server endpoint as its first
parameter. The new instance returned may be used to call any number of remote methods at that endpoint.

To call a remote method with the *XML-RPC* client, instantiate it and use the ``call()`` instance method. The code
sample below uses a demonstration *XML-RPC* server on the Zend Framework website. You can use it for testing or
exploring the ``Zend\XmlRpc`` components.

.. _zend.xmlrpc.client.method-calls.example-1:

.. rubric:: XML-RPC Method Call

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   echo $client->call('test.sayHello');

   // hello

The *XML-RPC* value returned from the remote method call will be automatically unmarshaled and cast to the
equivalent *PHP* native type. In the example above, a *PHP* ``String`` is returned and is immediately ready to be
used.

The first parameter of the ``call()`` method receives the name of the remote method to call. If the remote method
requires any parameters, these can be sent by supplying a second, optional parameter to ``call()`` with an
``Array`` of values to pass to the remote method:

.. _zend.xmlrpc.client.method-calls.example-2:

.. rubric:: XML-RPC Method Call with Parameters

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   $arg1 = 1.1;
   $arg2 = 'foo';

   $result = $client->call('test.sayHello', array($arg1, $arg2));

   // $result is a native PHP type

If the remote method doesn't require parameters, this optional parameter may either be left out or an empty
``array()`` passed to it. The array of parameters for the remote method can contain native *PHP* types,
``Zend\XmlRpc\Value`` objects, or a mix of each.

The ``call()`` method will automatically convert the *XML-RPC* response and return its equivalent *PHP* native
type. A ``Zend\XmlRpc\Response`` object for the return value will also be available by calling the
``getLastResponse()`` method after the call.

.. _zend.xmlrpc.value.parameters:

Types and Conversions
---------------------

Some remote method calls require parameters. These are given to the ``call()`` method of ``Zend\XmlRpc\Client`` as
an array in the second parameter. Each parameter may be given as either a native *PHP* type which will be
automatically converted, or as an object representing a specific *XML-RPC* type (one of the ``Zend\XmlRpc\Value``
objects).

.. _zend.xmlrpc.value.parameters.php-native:

PHP Native Types as Parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Parameters may be passed to ``call()`` as native *PHP* variables, meaning as a ``String``, ``Integer``, ``Float``,
``Boolean``, ``Array``, or an ``Object``. In this case, each *PHP* native type will be auto-detected and converted
into one of the *XML-RPC* types according to this table:

.. _zend.xmlrpc.value.parameters.php-native.table-1:

.. table:: PHP and XML-RPC Type Conversions

   +----------------------------------+----------------+
   |PHP Native Type                   |XML-RPC Type    |
   +==================================+================+
   |integer                           |int             |
   +----------------------------------+----------------+
   |Zend\\Math\\BigInteger\\BigInteger|i8              |
   +----------------------------------+----------------+
   |double                            |double          |
   +----------------------------------+----------------+
   |boolean                           |boolean         |
   +----------------------------------+----------------+
   |string                            |string          |
   +----------------------------------+----------------+
   |null                              |nil             |
   +----------------------------------+----------------+
   |array                             |array           |
   +----------------------------------+----------------+
   |associative array                 |struct          |
   +----------------------------------+----------------+
   |object                            |array           |
   +----------------------------------+----------------+
   |DateTime                          |dateTime.iso8601|
   +----------------------------------+----------------+
   |DateTime                          |dateTime.iso8601|
   +----------------------------------+----------------+

.. note::

   **What type do empty arrays get cast to?**

   Passing an empty array to an *XML-RPC* method is problematic, as it could represent either an array or a struct.
   ``Zend\XmlRpc\Client`` detects such conditions and makes a request to the server's ``system.methodSignature``
   method to determine the appropriate *XML-RPC* type to cast to.

   However, this in itself can lead to issues. First off, servers that do not support ``system.methodSignature``
   will log failed requests, and ``Zend\XmlRpc\Client`` will resort to casting the value to an *XML-RPC* array
   type. Additionally, this means that any call with array arguments will result in an additional call to the
   remote server.

   To disable the lookup entirely, you can call the ``setSkipSystemLookup()`` method prior to making your *XML-RPC*
   call:

   .. code-block:: php
      :linenos:

      $client->setSkipSystemLookup(true);
      $result = $client->call('foo.bar', array(array()));

.. _zend.xmlrpc.value.parameters.xmlrpc-value:

Zend\\XmlRpc\\Value Objects as Parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Parameters may also be created as ``Zend\XmlRpc\Value`` instances to specify an exact *XML-RPC* type. The primary
reasons for doing this are:



   - When you want to make sure the correct parameter type is passed to the procedure (i.e. the procedure requires
     an integer and you may get it from a database as a string)

   - When the procedure requires ``base64`` or ``dateTime.iso8601`` type (which doesn't exists as a *PHP* native
     type)

   - When auto-conversion may fail (i.e. you want to pass an empty *XML-RPC* struct as a parameter. Empty structs
     are represented as empty arrays in *PHP* but, if you give an empty array as a parameter it will be
     auto-converted to an *XML-RPC* array since it's not an associative array)



There are two ways to create a ``Zend\XmlRpc\Value`` object: instantiate one of the ``Zend\XmlRpc\Value``
subclasses directly, or use the static factory method ``Zend\XmlRpc\AbstractValue::getXmlRpcValue()``.

.. _zend.xmlrpc.value.parameters.xmlrpc-value.table-1:

.. table:: Zend\\XmlRpc\\Value Objects for XML-RPC Types

   +----------------+--------------------------------------------------+-------------------------------+
   |XML-RPC Type    |Zend\\XmlRpc\\AbstractValue Constant              |Zend\\XmlRpc\\Value Object     |
   +================+==================================================+===============================+
   |int             |Zend\\XmlRpc\\AbstractValue::XMLRPC_TYPE_INTEGER  |Zend\\XmlRpc\\Value\\Integer   |
   +----------------+--------------------------------------------------+-------------------------------+
   |i4              |Zend\\XmlRpc\\AbstractValue::XMLRPC_TYPE_I4       |Zend\\XmlRpc\\Value\\Integer   |
   +----------------+--------------------------------------------------+-------------------------------+
   |i8              |Zend\\XmlRpc\\AbstractValue::XMLRPC_TYPE_I8       |Zend\\XmlRpc\\Value\\BigInteger|
   +----------------+--------------------------------------------------+-------------------------------+
   |ex:i8           |Zend\\XmlRpc\\AbstractValue::XMLRPC_TYPE_APACHEI8 |Zend\\XmlRpc\\Value\\BigInteger|
   +----------------+--------------------------------------------------+-------------------------------+
   |double          |Zend\\XmlRpc\\AbstractValue::XMLRPC_TYPE_DOUBLE   |Zend\\XmlRpc\\Value\Double     |
   +----------------+--------------------------------------------------+-------------------------------+
   |boolean         |Zend\\XmlRpc\\AbstractValue::XMLRPC_TYPE_BOOLEAN  |Zend\\XmlRpc\\Value\\Boolean   |
   +----------------+--------------------------------------------------+-------------------------------+
   |string          |Zend\\XmlRpc\\AbstractValue::XMLRPC_TYPE_STRING   |Zend\\XmlRpc\\Value\\String    |
   +----------------+--------------------------------------------------+-------------------------------+
   |nil             |Zend\\XmlRpc\\AbstractValue::XMLRPC_TYPE_NIL      |Zend\\XmlRpc\\Value\\Nil       |
   +----------------+--------------------------------------------------+-------------------------------+
   |ex:nil          |Zend\\XmlRpc\\AbstractValue::XMLRPC_TYPE_APACHENIL|Zend\\XmlRpc\\Value\\Nil       |
   +----------------+--------------------------------------------------+-------------------------------+
   |base64          |Zend\\XmlRpc\\AbstractValue::XMLRPC_TYPE_BASE64   |Zend\\XmlRpc\\Value\\Base64    |
   +----------------+--------------------------------------------------+-------------------------------+
   |dateTime.iso8601|Zend\\XmlRpc\\AbstractValue::XMLRPC_TYPE_DATETIME |Zend\\XmlRpc\\Value\\DateTime  |
   +----------------+--------------------------------------------------+-------------------------------+
   |array           |Zend\\XmlRpc\\AbstractValue::XMLRPC_TYPE_ARRAY    |Zend\\XmlRpc\\Value\\Array     |
   +----------------+--------------------------------------------------+-------------------------------+
   |struct          |Zend\\XmlRpc\\AbstractValue::XMLRPC_TYPE_STRUCT   |Zend\\XmlRpc\\Value\\Struct    |
   +----------------+--------------------------------------------------+-------------------------------+

.. note::

   **Automatic Conversion**

   When building a new ``Zend\XmlRpc\Value`` object, its value is set by a *PHP* type. The *PHP* type will be
   converted to the specified type using *PHP* casting. For example, if a string is given as a value to the
   ``Zend\XmlRpc\Value\Integer`` object, it will be converted using ``(int) $value``.

.. _zend.xmlrpc.client.requests-and-responses:

Server Proxy Object
-------------------

Another way to call remote methods with the *XML-RPC* client is to use the server proxy. This is a *PHP* object
that proxies a remote *XML-RPC* namespace, making it work as close to a native *PHP* object as possible.

To instantiate a server proxy, call the ``getProxy()`` instance method of ``Zend\XmlRpc\Client``. This will return
an instance of ``Zend\XmlRpc\Client\ServerProxy``. Any method call on the server proxy object will be forwarded to
the remote, and parameters may be passed like any other *PHP* method.

.. _zend.xmlrpc.client.requests-and-responses.example-1:

.. rubric:: Proxy the Default Namespace

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   $service = $client->getProxy();           // Proxy the default namespace

   $hello = $service->test->sayHello(1, 2);  // test.Hello(1, 2) returns "hello"

The ``getProxy()`` method receives an optional argument specifying which namespace of the remote server to proxy.
If it does not receive a namespace, the default namespace will be proxied. In the next example, the 'test'
namespace will be proxied:

.. _zend.xmlrpc.client.requests-and-responses.example-2:

.. rubric:: Proxy Any Namespace

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   $test  = $client->getProxy('test');     // Proxy the "test" namespace

   $hello = $test->sayHello(1, 2);         // test.Hello(1,2) returns "hello"

If the remote server supports nested namespaces of any depth, these can also be used through the server proxy. For
example, if the server in the example above had a method ``test.foo.bar()``, it could be called as
``$test->foo->bar()``.

.. _zend.xmlrpc.client.error-handling:

Error Handling
--------------

Two kinds of errors can occur during an *XML-RPC* method call: *HTTP* errors and *XML-RPC* faults. The
``Zend\XmlRpc\Client`` recognizes each and provides the ability to detect and trap them independently.

.. _zend.xmlrpc.client.error-handling.http:

HTTP Errors
^^^^^^^^^^^

If any *HTTP* error occurs, such as the remote *HTTP* server returns a **404 Not Found**, a
``Zend\XmlRpc\Client\Exception\HttpException`` will be thrown.

.. _zend.xmlrpc.client.error-handling.http.example-1:

.. rubric:: Handling HTTP Errors

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://foo/404');

   try {

       $client->call('bar', array($arg1, $arg2));

   } catch (Zend\XmlRpc\Client\Exception\HttpException $e) {

       // $e->getCode() returns 404
       // $e->getMessage() returns "Not Found"

   }

Regardless of how the *XML-RPC* client is used, the ``Zend\XmlRpc\Client\Exception\HttpException`` will be thrown
whenever an *HTTP* error occurs.

.. _zend.xmlrpc.client.error-handling.faults:

XML-RPC Faults
^^^^^^^^^^^^^^

An *XML-RPC* fault is analogous to a *PHP* exception. It is a special type returned from an *XML-RPC* method call
that has both an error code and an error message. *XML-RPC* faults are handled differently depending on the context
of how the ``Zend\XmlRpc\Client`` is used.

When the ``call()`` method or the server proxy object is used, an *XML-RPC* fault will result in a
``Zend\XmlRpc\Client\Exception\FaultException`` being thrown. The code and message of the exception will map
directly to their respective values in the original *XML-RPC* fault response.

.. _zend.xmlrpc.client.error-handling.faults.example-1:

.. rubric:: Handling XML-RPC Faults

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   try {

       $client->call('badMethod');

   } catch (Zend\XmlRpc\Client\Exception\FaultException $e) {

       // $e->getCode() returns 1
       // $e->getMessage() returns "Unknown method"

   }

When the ``call()`` method is used to make the request, the ``Zend\XmlRpc\Client\Exception\FaultException`` will be
thrown on fault. A ``Zend\XmlRpc\Response`` object containing the fault will also be available by calling
``getLastResponse()``.

When the ``doRequest()`` method is used to make the request, it will not throw the exception. Instead, it will
return a ``Zend\XmlRpc\Response`` object returned will containing the fault. This can be checked with ``isFault()``
instance method of ``Zend\XmlRpc\Response``.

.. _zend.xmlrpc.client.introspection:

Server Introspection
--------------------

Some *XML-RPC* servers support the de facto introspection methods under the *XML-RPC* **system.** namespace.
``Zend\XmlRpc\Client`` provides special support for servers with these capabilities.

A ``Zend\XmlRpc\Client\ServerIntrospection`` instance may be retrieved by calling the ``getIntrospector()`` method
of ``Zend\XmlRpc\Client``. It can then be used to perform introspection operations on the server.

.. code-block:: php
    :linenos:

    $client = new Zend\XmlRpc\Client('http://example.com/xmlrpcserver.php');
    $introspector = $client->getIntrospector();
    foreach ($introspector->listMethods() as $method) {
        echo "Method: " . $method . "\n";
    }

The following methods are available for introspection:

- ``getSignatureForEachMethod``: Returns the signature for each method on the server

- ``getSignatureForEachMethodByMulticall($methods=null)``: Attempt to get the method signatures in one request via
  system.multicall(). Optionally pass an array of method names.

- ``getSignatureForEachMethodByLooping($methods=null)``: Get the method signatures for every method by successively
  calling system.methodSignature. Optionally pass an array of method names
  
- ``getMethodSignature($method)``: Get the method's signature for $method

- ``listMethods``: List all methods on the server

.. _zend.xmlrpc.client.request-to-response:

From Request to Response
------------------------

Under the hood, the ``call()`` instance method of ``Zend\XmlRpc\Client`` builds a request object
(``Zend\XmlRpc\Request``) and sends it to another method, ``doRequest()``, that returns a response object
(``Zend\XmlRpc\Response``).

The ``doRequest()`` method is also available for use directly:

.. _zend.xmlrpc.client.request-to-response.example-1:

.. rubric:: Processing Request to Response

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   $request = new Zend\XmlRpc\Request();
   $request->setMethod('test.sayHello');
   $request->setParams(array('foo', 'bar'));

   $client->doRequest($request);

   // $client->getLastRequest() returns instanceof Zend\XmlRpc\Request
   // $client->getLastResponse() returns instanceof Zend\XmlRpc\Response

Whenever an *XML-RPC* method call is made by the client through any means, either the ``call()`` method,
``doRequest()`` method, or server proxy, the last request object and its resultant response object will always be
available through the methods ``getLastRequest()`` and ``getLastResponse()`` respectively.

.. _zend.xmlrpc.client.http-client:

HTTP Client and Testing
-----------------------

In all of the prior examples, an *HTTP* client was never specified. When this is the case, a new instance of
``Zend\Http\Client`` will be created with its default options and used by ``Zend\XmlRpc\Client`` automatically.

The *HTTP* client can be retrieved at any time with the ``getHttpClient()`` method. For most cases, the default
*HTTP* client will be sufficient. However, the ``setHttpClient()`` method allows for a different *HTTP* client
instance to be injected.

The ``setHttpClient()`` is particularly useful for unit testing. When combined with the
``Zend\Http\Client\Adapter\Test``, remote services can be mocked out for testing. See the unit tests for
``Zend\XmlRpc\Client`` for examples of how to do this.


