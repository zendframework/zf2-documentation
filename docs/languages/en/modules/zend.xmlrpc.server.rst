.. _zend.xmlrpc.server:

Zend\\XmlRpc\\Server
====================

.. _zend.xmlrpc.server.introduction:

Introduction
------------

``Zend\XmlRpc\Server`` is intended as a fully-featured *XML-RPC* server, following `the specifications outlined at
www.xmlrpc.com`_. Additionally, it implements the ``system.multicall()`` method, allowing boxcarring of requests.

.. _zend.xmlrpc.server.usage:

Basic Usage
-----------

An example of the most basic use case:

.. code-block:: php
   :linenos:

   $server = new Zend\XmlRpc\Server();
   $server->setClass('My\Service\Class');
   echo $server->handle();

.. _zend.xmlrpc.server.structure:

Server Structure
----------------

``Zend\XmlRpc\Server`` is composed of a variety of components, ranging from the server itself to request, response,
and fault objects.

To bootstrap ``Zend\XmlRpc\Server``, the developer must attach one or more classes or functions to the server, via
the ``setClass()`` and ``addFunction()`` methods.

Once done, you may either pass a ``Zend\XmlRpc\Request`` object to ``Zend\XmlRpc\Server::handle()``, or it will
instantiate a ``Zend\XmlRpc\Request\Http`` object if none is provided -- thus grabbing the request from
``php://input``.

``Zend\XmlRpc\Server::handle()`` then attempts to dispatch to the appropriate handler based on the method
requested. It then returns either a ``Zend\XmlRpc\Response``-based object or a ``Zend\XmlRpc\Server\Fault``\
object. These objects both have ``__toString()`` methods that create valid *XML-RPC* *XML* responses, allowing them
to be directly echoed.

.. _zend.xmlrpc.server.anatomy:

Anatomy of a webservice
-----------------------

.. _zend.xmlrpc.server.anatomy.general:

General considerations
^^^^^^^^^^^^^^^^^^^^^^

For maximum performance it is recommended to use a simple bootstrap file for the server component. Using
``Zend\XmlRpc\Server`` inside a :ref:`Zend\\Controller <zend.controller>` is strongly discouraged to avoid the
overhead.

Services change over time and while webservices are generally less change intense as code-native *APIs*, it is
recommended to version your service. Do so to lay grounds to provide compatibility for clients using older versions
of your service and manage your service lifecycle including deprecation timeframes. To do so just include a version
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

Conventions
-----------

``Zend\XmlRpc\Server`` allows the developer to attach functions and class method calls as dispatchable *XML-RPC*
methods. Via ``Zend\Server\Reflection``, it does introspection on all attached methods, using the function and
method docblocks to determine the method help text and method signatures.

*XML-RPC* types do not necessarily map one-to-one to *PHP* types. However, the code will do its best to guess the
appropriate type based on the values listed in @param and @return lines. Some *XML-RPC* types have no immediate
*PHP* equivalent, however, and should be hinted using the *XML-RPC* type in the PHPDoc. These include:

- **dateTime.iso8601**, a string formatted as '``YYYYMMDDTHH:mm:ss``'

- **base64**, base64 encoded data

- **struct**, any associative array

An example of how to hint follows:

.. code-block:: php
   :linenos:

   /**
   * This is a sample function
   *
   * @param base64 $val1 Base64-encoded data
   * @param dateTime.iso8601 $val2 An ISO date
   * @param struct $val3 An associative array
   * @return struct
   */
   function myFunc($val1, $val2, $val3)
   {
   }

PhpDocumentor does no validation of the types specified for params or return values, so this will have no impact on
your *API* documentation. Providing the hinting is necessary, however, when the server is validating the parameters
provided to the method call.

It is perfectly valid to specify multiple types for both params and return values; the *XML-RPC* specification even
suggests that system.methodSignature should return an array of all possible method signatures (i.e., all possible
combinations of param and return values). You may do so just as you normally would with PhpDocumentor, using the
'\|' operator:

.. code-block:: php
   :linenos:

   /**
   * This is a sample function
   *
   * @param string|base64 $val1 String or base64-encoded data
   * @param string|dateTime.iso8601 $val2 String or an ISO date
   * @param array|struct $val3 Normal indexed array or an associative array
   * @return boolean|struct
   */
   function myFunc($val1, $val2, $val3)
   {
   }

.. note::

   Allowing multiple signatures can lead to confusion for developers using the services; to keep things simple, a
   *XML-RPC* service method should only have a single signature.

.. _zend.xmlrpc.server.namespaces:

Utilizing Namespaces
--------------------

*XML-RPC* has a concept of namespacing; basically, it allows grouping *XML-RPC* methods by dot-delimited
namespaces. This helps prevent naming collisions between methods served by different classes. As an example, the
*XML-RPC* server is expected to server several methods in the 'system' namespace:

- system.listMethods

- system.methodHelp

- system.methodSignature

Internally, these map to the methods of the same name in ``Zend\XmlRpc\Server``.

If you want to add namespaces to the methods you serve, simply provide a namespace to the appropriate method when
attaching a function or class:

.. code-block:: php
   :linenos:

   // All public methods in My_Service_Class will be accessible as
   // myservice.METHODNAME
   $server->setClass('My\Service\Class', 'myservice');

   // Function 'somefunc' will be accessible as funcs.somefunc
   $server->addFunction('somefunc', 'funcs');

.. _zend.xmlrpc.server.request:

Custom Request Objects
----------------------

Most of the time, you'll simply use the default request type included with ``Zend\XmlRpc\Server``,
``Zend\XmlRpc\Request\Http``. However, there may be times when you need *XML-RPC* to be available via the *CLI*, a
*GUI*, or other environment, or want to log incoming requests. To do so, you may create a custom request object
that extends ``Zend\XmlRpc\Request``. The most important thing to remember is to ensure that the ``getMethod()``
and ``getParams()`` methods are implemented so that the *XML-RPC* server can retrieve that information in order to
dispatch the request.

.. _zend.xmlrpc.server.response:

Custom Responses
----------------

Similar to request objects, ``Zend\XmlRpc\Server`` can return custom response objects; by default, a
``Zend\XmlRpc\Response\Http`` object is returned, which sends an appropriate Content-Type *HTTP* header for use
with *XML-RPC*. Possible uses of a custom object would be to log responses, or to send responses back to
``STDOUT``.

To use a custom response class, use ``Zend\XmlRpc\Server::setResponseClass()`` prior to calling ``handle()``.

.. _zend.xmlrpc.server.fault:

Handling Exceptions via Faults
------------------------------

``Zend\XmlRpc\Server`` catches Exceptions generated by a dispatched method, and generates an *XML-RPC* fault
response when such an exception is caught. By default, however, the exception messages and codes are not used in a
fault response. This is an intentional decision to protect your code; many exceptions expose more information about
the code or environment than a developer would necessarily intend (a prime example includes database abstraction or
access layer exceptions).

Exception classes can be whitelisted to be used as fault responses, however. To do so, simply utilize
``Zend\XmlRpc\Server\Fault::attachFaultException()`` to pass an exception class to whitelist:

.. code-block:: php
   :linenos:

   Zend\XmlRpc\Server\Fault::attachFaultException('My\Project\Exception');

If you utilize an exception class that your other project exceptions inherit, you can then whitelist a whole family
of exceptions at a time. ``Zend\XmlRpc\Server\Exception``\ s are always whitelisted, to allow reporting specific
internal errors (undefined methods, etc.).

Any exception not specifically whitelisted will generate a fault response with a code of '404' and a message of
'Unknown error'.

.. _zend.xmlrpc.server.caching:

Caching Server Definitions Between Requests
-------------------------------------------

Attaching many classes to an *XML-RPC* server instance can utilize a lot of resources; each class must introspect
using the Reflection *API* (via ``Zend\Server\Reflection``), which in turn generates a list of all possible method
signatures to provide to the server class.

To reduce this performance hit somewhat, ``Zend\XmlRpc\Server\Cache`` can be used to cache the server definition
between requests. When combined with ``__autoload()``, this can greatly increase performance.

An sample usage follows:

.. code-block:: php
   :linenos:

   use Zend\XmlRpc\Server as XmlRpcServer;

   // Register the "My\Services" namespace
   $loader = new Zend\Loader\StandardAutoloader();
   $loader->registerNamespace('My\Services', 'path to My/Services');
   $loader->register();

   $cacheFile = dirname(__FILE__) . '/xmlrpc.cache';
   $server = new XmlRpcServer();

   if (!XmlRpcServer\Cache::get($cacheFile, $server)) {

       $server->setClass('My\Services\Glue', 'glue');   // glue. namespace
       $server->setClass('My\Services\Paste', 'paste'); // paste. namespace
       $server->setClass('My\Services\Tape', 'tape');   // tape. namespace

       XmlRpcServer\Cache::save($cacheFile, $server);
   }

   echo $server->handle();

The above example attempts to retrieve a server definition from ``xmlrpc.cache`` in the same directory as the
script. If unsuccessful, it loads the service classes it needs, attaches them to the server instance, and then
attempts to create a new cache file with the server definition.

.. _zend.xmlrpc.server.use:

Usage Examples
--------------

Below are several usage examples, showing the full spectrum of options available to developers. Usage examples will
each build on the previous example provided.

.. _zend.xmlrpc.server.use.attach-function:

.. rubric:: Basic Usage

The example below attaches a function as a dispatchable *XML-RPC* method and handles incoming calls.

.. code-block:: php
   :linenos:

   /**
    * Return the MD5 sum of a value
    *
    * @param string $value Value to md5sum
    * @return string MD5 sum of value
    */
   function md5Value($value)
   {
       return md5($value);
   }

   $server = new Zend\XmlRpc\Server();
   $server->addFunction('md5Value');
   echo $server->handle();

.. _zend.xmlrpc.server.use.attach-class:

.. rubric:: Attaching a class

The example below illustrates attaching a class' public methods as dispatchable *XML-RPC* methods.

.. code-block:: php
   :linenos:

   require_once 'Services/Comb.php';

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services\Comb');
   echo $server->handle();

.. _zend.xmlrpc.server.use.attach-class-with-arguments:

.. rubric:: Attaching a class with arguments

The following example illustrates how to attach a class' public methods and passing arguments to its methods. This
can be used to specify certain defaults when registering service classes.

.. code-block:: php
   :linenos:

   namespace Services;

   class PricingService
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

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services\PricingService',
                     'pricing',
                     new ProductRepository(),
                     new PurchaseRepository());

The arguments passed at ``setClass()`` at server construction time are injected into the method call
``pricing.calculate()`` on remote invokation. In the example above, only the argument ``$purchaseId`` is expected
from the client.

.. _zend.xmlrpc.server.use.attach-class-with-arguments-constructor:

.. rubric:: Passing arguments only to constructor

``Zend\XmlRpc\Server`` allows to restrict argument passing to constructors only. This can be used for constructor
dependency injection. To limit injection to constructors, call ``sendArgumentsToAllMethods`` and pass ``FALSE`` as
an argument. This disables the default behavior of all arguments being injected into the remote method. In the
example below the instance of ``ProductRepository`` and ``PurchaseRepository`` is only injected into the
constructor of ``Services_PricingService2``.

.. code-block:: php
   :linenos:

   class Services\PricingService2
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

   $server = new Zend\XmlRpc\Server();
   $server->sendArgumentsToAllMethods(false);
   $server->setClass('Services\PricingService2',
                     'pricing',
                     new ProductRepository(),
                     new PurchaseRepository());

.. _zend.xmlrpc.server.use.attach-instance:

.. rubric:: Attaching a class instance

``setClass()`` allows to register a previously instantiated class at the server. Just pass an instance instead of
the class name. Obviously passing arguments to the constructor is not possible with pre-instantiated classes.

.. _zend.xmlrpc.server.use.attach-several-classes-namespaces:

.. rubric:: Attaching several classes using namespaces

The example below illustrates attaching several classes, each with their own namespace.

.. code-block:: php
   :linenos:

   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services\Comb', 'comb');   // methods called as comb.*
   $server->setClass('Services\Brush', 'brush'); // methods called as brush.*
   $server->setClass('Services\Pick', 'pick');   // methods called as pick.*
   echo $server->handle();

.. _zend.xmlrpc.server.use.exceptions-faults:

.. rubric:: Specifying exceptions to use as valid fault responses

The example below allows any ``Services\Exception``-derived class to report its code and message in the fault
response.

.. code-block:: php
   :linenos:

   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Allow Services_Exceptions to report as fault responses
   Zend\XmlRpc\Server\Fault::attachFaultException('Services\Exception');

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services\Comb', 'comb');   // methods called as comb.*
   $server->setClass('Services\Brush', 'brush'); // methods called as brush.*
   $server->setClass('Services\Pick', 'pick');   // methods called as pick.*
   echo $server->handle();

.. _zend.xmlrpc.server.use.custom-request-object:

.. rubric:: Utilizing custom request and response objects

Some use cases require to utilize a custom request object. For example, *XML/RPC* is not bound to *HTTP* as a
transfer protocol. It is possible to use other transfer protocols like *SSH* or telnet to send the request and
response data over the wire. Another use case is authentication and authorization. In case of a different transfer
protocol, one need to change the implementation to read request data.

The example below instantiates a custom request class and passes it to the server to handle.

.. code-block:: php
   :linenos:

   require_once 'Services/Request.php';
   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Allow Services_Exceptions to report as fault responses
   Zend\XmlRpc\Server\Fault::attachFaultException('Services\Exception');

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services\Comb', 'comb');   // methods called as comb.*
   $server->setClass('Services\Brush', 'brush'); // methods called as brush.*
   $server->setClass('Services\Pick', 'pick');   // methods called as pick.*

   // Create a request object
   $request = new Services\Request();

   echo $server->handle($request);

.. _zend.xmlrpc.server.use.custom-response-object:

.. rubric:: Specifying a custom response class

The example below illustrates specifying a custom response class for the returned response.

.. code-block:: php
   :linenos:

   require_once 'Services/Request.php';
   require_once 'Services/Response.php';
   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Allow Services_Exceptions to report as fault responses
   Zend\XmlRpc\Server\Fault::attachFaultException('Services\Exception');

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services\Comb', 'comb');   // methods called as comb.*
   $server->setClass('Services\Brush', 'brush'); // methods called as brush.*
   $server->setClass('Services\Pick', 'pick');   // methods called as pick.*

   // Create a request object
   $request = new Services\Request();

   // Utilize a custom response
   $server->setResponseClass('Services\Response');

   echo $server->handle($request);

.. _zend.xmlrpc.server.performance:

Performance optimization
------------------------

.. _zend.xmlrpc.server.performance.caching:

.. rubric:: Cache server definitions between requests

The example below illustrates caching server definitions between requests.

.. code-block:: php
   :linenos:

   use Zend\XmlRpc\Server as XmlRpcServer;

   // Register the "Services" namespace
   $loader = new Zend\Loader\StandardAutoloader();
   $loader->registerNamespace('Services', 'path to Services');
   $loader->register();

   // Specify a cache file
   $cacheFile = dirname(__FILE__) . '/xmlrpc.cache';

   // Allow Services\Exceptions to report as fault responses
   XmlRpcServer\Fault::attachFaultException('Services\Exception');

   $server = new XmlRpcServer();

   // Attempt to retrieve server definition from cache
   if (!XmlRpcServer\Cache::get($cacheFile, $server)) {
       $server->setClass('Services\Comb', 'comb');   // methods called as comb.*
       $server->setClass('Services\Brush', 'brush'); // methods called as brush.*
       $server->setClass('Services\Pick', 'pick');   // methods called as pick.*

       // Save cache
       XmlRpcServer\Cache::save($cacheFile, $server);
   }

   // Create a request object
   $request = new Services\Request();

   // Utilize a custom response
   $server->setResponseClass('Services\Response');

   echo $server->handle($request);

.. note::

   The server cache file should be located outside the document root.

.. _zend.xmlrpc.server.performance.xmlgen:

.. rubric:: Optimizing XML generation

``Zend\XmlRpc\Server`` uses ``DOMDocument`` of *PHP* extension **ext/dom** to generate it's *XML* output. While
**ext/dom** is available on a lot of hosts it is not exactly the fastest. Benchmarks have shown, that ``XmlWriter``
from **ext/xmlwriter** performs better.

If **ext/xmlwriter** is available on your host, you can select a the ``XmlWriter``-based generator to leverage the
performance differences.

.. code-block:: php
   :linenos:

   use Zend\XmlRpc;

   XmlRpc\AbstractValue::setGenerator(new XmlRpc\Generator\XmlWriter());

   $server = new XmlRpc\Server();
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
   any work with ``Zend\XmlRpc\Client``.



.. _`the specifications outlined at www.xmlrpc.com`: http://www.xmlrpc.com/spec
.. _`Remote Facade`: http://martinfowler.com/eaaCatalog/remoteFacade.html
