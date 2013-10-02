.. EN-Revision: none
.. _zend.xmlrpc.client:

Zend\XmlRpc\Client
==================

.. _zend.xmlrpc.client.introduction:

Introdución
-----------

Zend Framework provee soporte para consumo remoto para servicios *XML-RPC* como un cliente en el paquete
``Zend\XmlRpc\Client``. Su mejor característica es la conversión automática de tipos entre *PHP* y *XML-RPC*, un
servidor de objeto proxy, y acceso a capacidades de introspección del servidor.

.. _zend.xmlrpc.client.method-calls:

Method Calls
------------

El constructor de ``Zend\XmlRpc\Client`` recibe la *URL* del servidor *XML-RPC* como su primer parámetro. La nueva
instancia devuelta puede ser usada para llamar cualquier número de métodos remotos en el punto final.

Para llamar un método remoto con el cliente *XML-RPC*, instáncealo y usa el método de instancia ``call()``. El
código de ejemplo a continuación utiliza una demostración en el servidor *XML-RPC* en el sitio web de Zend
Framework . Puede utilizarlo para probar o explorar los componentes ``Zend_XmlRpc``.

.. _zend.xmlrpc.client.method-calls.example-1:

.. rubric:: XML-RPC Method Call

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   echo $client->call('test.sayHello');

   // hello

El valor *XML-RPC* devuelto desde la llamada al método remoto automáticamente será convertida al tipo nativo
*PHP* equivalente . En el ejemplo anterior, es devuelto un ``string`` *PHP* y está listo para ser usado
inmediatamente.

El primer parámetro del método ``call()`` recibe el nombre del método remoto que llamar. Si el método remoto
requiere algún parámetro, éste puede ser enviado por el suministro de un segundo, parámetro opcional a
``call()`` con un ``array`` de valores para pasar el método remoto:

.. _zend.xmlrpc.client.method-calls.example-2:

.. rubric:: XML-RPC Method Call with Parameters

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   $arg1 = 1.1;
   $arg2 = 'foo';

   $result = $client->call('test.sayHello', array($arg1, $arg2));

   // $result es un tipo nativo PHP

si el método remoto no requiere parámetros, este parámetro opcional podrá ser excluido o se puede pasar un
``array()`` vacío. El array de parámeters para el método repoto puede contener tipos nativos *PHP* s, objetos
``Zend\XmlRpc\Value``, o una combinación de estos.

El método ``call()`` convertirá automáticamente la respuesta *XML-RPC* y devolverá su tipo nativo *PHP*
equivalente. Un objeto ``Zend\XmlRpc\Response`` para el valor devuelto también estará disponible para llamar el
método ``getLastResponse()`` después de la llamada.

.. _zend.xmlrpc.value.parameters:

Tipos y Conversiones
--------------------

Algunas llamadas a métodos remoto requieren parámetros. Éstos son dados al método ``call()`` de
``Zend\XmlRpc\Client`` como un array en el segundo parámetro. Cada parámetro puede ser dado como un tipo nativo
*PHP*, que será convertido automáticamente, o como un objeto que representa un tipo específico de *XML-RPC* (uno
de los objetos ``Zend\XmlRpc\Value``).

.. _zend.xmlrpc.value.parameters.php-native:

Tipos Nativos PHP como Parámetro
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Los parámetros pueden ser pasados a ``call()`` como variables *PHP* nativas, ya sea un ``string``, ``integer``,
``float``, ``boolean``, ``array``, o un ``object``. En este caso, cada tipo *PHP* nativo será autodetectado y
convertido en uno de los tipos *XML-RPC* de acuerdo con esta tabla:

.. _zend.xmlrpc.value.parameters.php-native.table-1:

.. table:: Tipos de Conversión entre PHP y XML-RPC

   +--------------------------+----------------+
   |Tipo Nativo PHP           |Tipo XML-RPC    |
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
   |array asociativo          |struct          |
   +--------------------------+----------------+
   |object                    |array           |
   +--------------------------+----------------+
   |Zend_Date                 |dateTime.iso8601|
   +--------------------------+----------------+
   |DateTime                  |dateTime.iso8601|
   +--------------------------+----------------+

.. note::

   **¿A qué tipo se convierten los arrays Vacios?**

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

Zend\XmlRpc\Value Objects as Parameters
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
subclasses directly, or use the static factory method ``Zend\XmlRpc\Value::getXmlRpcValue()``.

.. _zend.xmlrpc.value.parameters.xmlrpc-value.table-1:

.. table:: Zend\XmlRpc\Value Objects for XML-RPC Types

   +----------------+----------------------------------------+----------------------------+
   |XML-RPC Type    |Zend\XmlRpc\Value Constant              |Zend\XmlRpc\Value Object    |
   +================+========================================+============================+
   |int             |Zend\XmlRpc\Value::XMLRPC_TYPE_INTEGER  |Zend\XmlRpc_Value\Integer   |
   +----------------+----------------------------------------+----------------------------+
   |i8              |Zend\XmlRpc\Value::XMLRPC_TYPE_I8       |Zend\XmlRpc_Value\BigInteger|
   +----------------+----------------------------------------+----------------------------+
   |ex:i8           |Zend\XmlRpc\Value::XMLRPC_TYPE_APACHEI8 |Zend\XmlRpc_Value\BigInteger|
   +----------------+----------------------------------------+----------------------------+
   |double          |Zend\XmlRpc\Value::XMLRPC_TYPE_DOUBLE   |Zend\XmlRpc_Value\Double    |
   +----------------+----------------------------------------+----------------------------+
   |boolean         |Zend\XmlRpc\Value::XMLRPC_TYPE_BOOLEAN  |Zend\XmlRpc_Value\Boolean   |
   +----------------+----------------------------------------+----------------------------+
   |string          |Zend\XmlRpc\Value::XMLRPC_TYPE_STRING   |Zend\XmlRpc_Value\String    |
   +----------------+----------------------------------------+----------------------------+
   |nil             |Zend\XmlRpc\Value::XMLRPC_TYPE_NIL      |Zend\XmlRpc_Value\Nil       |
   +----------------+----------------------------------------+----------------------------+
   |ex:nil          |Zend\XmlRpc\Value::XMLRPC_TYPE_APACHENIL|Zend\XmlRpc_Value\Nil       |
   +----------------+----------------------------------------+----------------------------+
   |base64          |Zend\XmlRpc\Value::XMLRPC_TYPE_BASE64   |Zend\XmlRpc_Value\Base64    |
   +----------------+----------------------------------------+----------------------------+
   |dateTime.iso8601|Zend\XmlRpc\Value::XMLRPC_TYPE_DATETIME |Zend\XmlRpc_Value\DateTime  |
   +----------------+----------------------------------------+----------------------------+
   |array           |Zend\XmlRpc\Value::XMLRPC_TYPE_ARRAY    |Zend\XmlRpc_Value\Array     |
   +----------------+----------------------------------------+----------------------------+
   |struct          |Zend\XmlRpc\Value::XMLRPC_TYPE_STRUCT   |Zend\XmlRpc_Value\Struct    |
   +----------------+----------------------------------------+----------------------------+

.. note::

   **Automatic Conversion**

   When building a new ``Zend\XmlRpc\Value`` object, its value is set by a *PHP* type. The *PHP* type will be
   converted to the specified type using *PHP* casting. For example, if a string is given as a value to the
   ``Zend\XmlRpc_Value\Integer`` object, it will be converted using ``(int) $value``.

.. _zend.xmlrpc.client.requests-and-responses:

Server Proxy Object
-------------------

Another way to call remote methods with the *XML-RPC* client is to use the server proxy. This is a *PHP* object
that proxies a remote *XML-RPC* namespace, making it work as close to a native *PHP* object as possible.

To instantiate a server proxy, call the ``getProxy()`` instance method of ``Zend\XmlRpc\Client``. This will return
an instance of ``Zend\XmlRpc_Client\ServerProxy``. Any method call on the server proxy object will be forwarded to
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
``Zend\XmlRpc_Client\HttpException`` will be thrown.

.. _zend.xmlrpc.client.error-handling.http.example-1:

.. rubric:: Handling HTTP Errors

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://foo/404');

   try {

       $client->call('bar', array($arg1, $arg2));

   } catch (Zend\XmlRpc_Client\HttpException $e) {

       // $e->getCode() returns 404
       // $e->getMessage() returns "Not Found"

   }

Regardless of how the *XML-RPC* client is used, the ``Zend\XmlRpc_Client\HttpException`` will be thrown whenever an
*HTTP* error occurs.

.. _zend.xmlrpc.client.error-handling.faults:

XML-RPC Faults
^^^^^^^^^^^^^^

An *XML-RPC* fault is analogous to a *PHP* exception. It is a special type returned from an *XML-RPC* method call
that has both an error code and an error message. *XML-RPC* faults are handled differently depending on the context
of how the ``Zend\XmlRpc\Client`` is used.

When the ``call()`` method or the server proxy object is used, an *XML-RPC* fault will result in a
``Zend\XmlRpc_Client\FaultException`` being thrown. The code and message of the exception will map directly to
their respective values in the original *XML-RPC* fault response.

.. _zend.xmlrpc.client.error-handling.faults.example-1:

.. rubric:: Handling XML-RPC Faults

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   try {

       $client->call('badMethod');

   } catch (Zend\XmlRpc_Client\FaultException $e) {

       // $e->getCode() returns 1
       // $e->getMessage() returns "Unknown method"

   }

Cuando el método ``call()`` es usado para realizar la petición, ``Zend\XmlRpc_Client\FaultException`` será
lanzado como error. Un objeto ``Zend\XmlRpc\Response`` conteniendo el error estará disponible llamando a
``getLastResponse()``.

Cuando el método ``doRequest()`` sea usado para realizar una petición, no lanzará una excepción. En vez de eso,
devolverá un objeto ``Zend\XmlRpc\Response`` que contendrá el error. Esto puede comprobarse con ``isFault()``
método instancia de ``Zend\XmlRpc\Response``.

.. _zend.xmlrpc.client.introspection:

Server Introspection
--------------------

Some *XML-RPC* servers support the de facto introspection methods under the *XML-RPC* **system.** namespace.
``Zend\XmlRpc\Client`` provides special support for servers with these capabilities.

A ``Zend\XmlRpc_Client\ServerIntrospection`` instance may be retrieved by calling the ``getIntrospector()`` method
of ``Zend_XmlRpcClient``. It can then be used to perform introspection operations on the server.

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


