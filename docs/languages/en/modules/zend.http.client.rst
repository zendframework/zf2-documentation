.. _zend.http.client:

HTTP Client - Overview
======================

.. _zend.http.client.intro:

Overview
--------

``Zend\Http\Client`` provides an easy interface for performing Hyper-Text Transfer Protocol (HTTP) requests.
``Zend\Http\Client`` supports the most simple features expected from an *HTTP* client, as well as some more complex
features such as *HTTP* authentication and file uploads. Successful requests (and most unsuccessful ones too)
return a ``Zend\Http\Response`` object, which provides access to the response's headers and body (see :ref:`this
section <zend.http.response>`).

.. _zend.http.client.quick-start:

Quick Start
-----------

The class constructor optionally accepts a URL as its first parameter (can be either a string or a
``Zend\Uri\Http`` object), and an array or ``Zend\Config\Config`` object containing configuration options. Both can
be left out, and set later using the setUri() and setConfig() methods.

.. code-block:: php
   :linenos:

   use Zend\Http\Client;
   $client = new Client('http://example.org', array(
       'maxredirects' => 0,
       'timeout'      => 30
   ));

   // This is actually exactly the same:
   $client = new Client();
   $client->setUri('http://example.org');
   $client->setOptions(array(
       'maxredirects' => 0,
       'timeout'      => 30
   ));

   // You can also pass a Zend\Config\Config object to set the client's configuration
   $config = Zend\Config\Factory::fromFile('httpclient.ini');
   $client->setOptions($config);

.. note::

   ``Zend\Http\Client`` uses ``Zend\Uri\Http`` to validate URLs.  See the :ref:`Zend\\Uri manual page<zend.uri>`
   for more information on the validation process.

.. _zend.http.client.options:

Configuration Options
---------------------

The constructor and setOptions() method accept an associative array of configuration parameters, or a
``Zend\Config\Config`` object. Setting these parameters is optional, as they all have default values.



      .. _zend.http.client.configuration.table:

      .. table:: Zend\\Http\\Client configuration parameters

         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+-------------------------------------+
         |Parameter      |Description                                                                                                                                                                         |Expected Values|Default Value                        |
         +===============+====================================================================================================================================================================================+===============+=====================================+
         |maxredirects   |Maximum number of redirections to follow (0 = none)                                                                                                                                 |integer        |5                                    |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+-------------------------------------+
         |strictredirects|Whether to strictly follow the RFC when redirecting (see this section)                                                                                                              |boolean        |FALSE                                |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+-------------------------------------+
         |useragent      |User agent identifier string (sent in request headers)                                                                                                                              |string         |'Zend\\Http\\Client'                 |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+-------------------------------------+
         |timeout        |Connection timeout (seconds)                                                                                                                                                        |integer        |10                                   |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+-------------------------------------+
         |httpversion    |HTTP protocol version (usually '1.1' or '1.0')                                                                                                                                      |string         |'1.1'                                |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+-------------------------------------+
         |adapter        |Connection adapter class to use (see this section)                                                                                                                                  |mixed          |'Zend\\Http\\Client\\Adapter\\Socket'|
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+-------------------------------------+
         |keepalive      |Whether to enable keep-alive connections with the server. Useful and might improve performance if several consecutive requests to the same server are performed.                    |boolean        |FALSE                                |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+-------------------------------------+
         |storeresponse  |Whether to store last response for later retrieval with getLastResponse(). If set to FALSE, getLastResponse() will return NULL.                                                     |boolean        |TRUE                                 |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+-------------------------------------+
         |encodecookies  |Whether to pass the cookie value through urlencode/urldecode. Enabling this breaks support with some web servers. Disabling this limits the range of values the cookies can contain.|boolean        |TRUE                                 |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+-------------------------------------+
         |outputstream   |Destination for streaming of received data (options: string (filename), true for temp file, false/null to disable streaming)                                                        |boolean        |FALSE                                |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+-------------------------------------+
         |rfc3986strict  |Whether to strictly adhere to RFC 3986 (in practice, this means replacing '+' with '%20')                                                                                           |boolean        |FALSE                                |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+-------------------------------------+

.. _zend.http.client.methods:

Available Methods
-----------------

.. _zend.http.client.methods.__construct:

**__construct**
   ``__construct(string $uri, array|Traversable $config)``

   Constructor



   Returns void

.. _zend.http.client.methods.set-options:

**setOptions**
   ``setOptions(array|Traversable $config = array ())``

   Set configuration parameters for this HTTP client

   Returns Zend\\Http\\Client

.. _zend.http.client.methods.set-adapter:

**setAdapter**
   ``setAdapter(Zend\Http\Client\Adapter|string $adapter)``

   Load the connection adapter

   While this method is not called more than once for a client, it is separated from ->send() to preserve logic
   and readability

   Returns Zend\\Http\\Client

.. _zend.http.client.methods.get-adapter:

**getAdapter**
   ``getAdapter()``

   Retrieve the connection adapter

   Returns Zend\\Http\\Client\\Adapter\\AdapterInterface

.. _zend.http.client.methods.set-request:

**setRequest**
   ``setRequest(Zend\Http\Request $request)``

   Set request object

   Returns void

.. _zend.http.client.methods.get-request:

**getRequest**
   ``getRequest()``

   Get Request object

   Returns Zend\\Http\\Request

.. _zend.http.client.methods.get-last-raw-request:

**getLastRawRequest**
   ``getLastRawRequest()``

   Get the last request (as a string)

   Returns string

.. _zend.http.client.methods.set-response:

**setResponse**
   ``setResponse(Zend\Http\Response $response)``

   Set response

   Returns Zend\\Http\\Client

.. _zend.http.client.methods.get-response:

**getResponse**
   ``getResponse()``

   Get Response object

   Returns Zend\\Http\\Response

.. _zend.http.client.methods.get-last-raw-response:

**getLastRawResponse**
   ``getLastRawResponse()``

   Get the last response (as a string)

   Returns string

.. _zend.http.client.methods.get-redirections-count:

**getRedirectionsCount**
   ``getRedirectionsCount()``

   Get the redirections count

   Returns integer

.. _zend.http.client.methods.set-uri:

**setUri**
   ``setUri(string|Zend\Http\Zend\Uri\Http $uri)``

   Set Uri (to the request)

   Returns Zend\\Http\\Client

.. _zend.http.client.methods.get-uri:

**getUri**
   ``getUri()``

   Get uri (from the request)

   Returns Zend\\Uri\\Http

.. _zend.http.client.methods.set-method:

**setMethod**
   ``setMethod(string $method)``

   Set the HTTP method (to the request)

   Returns Zend\\Http\\Client

.. _zend.http.client.methods.get-method:

**getMethod**
   ``getMethod()``

   Get the HTTP method

   Returns string

.. _zend.http.client.methods.set-enc-type:

**setEncType**
   ``setEncType(string $encType, string $boundary)``

   Set the encoding type and the boundary (if any)

   Returns void

.. _zend.http.client.methods.get-enc-type:

**getEncType**
   ``getEncType()``

   Get the encoding type

   Returns type

.. _zend.http.client.methods.set-raw-body:

**setRawBody**
   ``setRawBody(string $body)``

   Set raw body (for advanced use cases)

   Returns Zend\\Http\\Client

.. _zend.http.client.methods.set-parameter-post:

**setParameterPost**
   ``setParameterPost(array $post)``

   Set the POST parameters

   Returns Zend\\Http\\Client

.. _zend.http.client.methods.set-parameter-get:

**setParameterGet**
   ``setParameterGet(array $query)``

   Set the GET parameters

   Returns Zend\\Http\\Client

.. _zend.http.client.methods.get-cookies:

**getCookies**
   ``getCookies()``

   Return the current cookies

   Returns array

.. _zend.http.client.methods.add-cookie:

**addCookie**
   ``addCookie(ArrayIterator|SetCookie|string $cookie, string $value = null, string $expire = null, string $path = null, string $domain = null, boolean $secure = false, boolean $httponly = true, string $maxAge = null, string $version = null)``

   Add a cookie

   Returns Zend\\Http\\Client

.. _zend.http.client.methods.set-cookies:

**setCookies**
   ``setCookies(array $cookies)``

   Set an array of cookies



   Returns Zend\\Http\\Client

.. _zend.http.client.methods.clear-cookies:

**clearCookies**
   ``clearCookies()``

   Clear all the cookies



   Returns void

.. _zend.http.client.methods.set-headers:

**setHeaders**
   ``setHeaders(Zend\Http\Headers|array $headers)``

   Set the headers (for the request)



   Returns Zend\\Http\\Client

.. _zend.http.client.methods.has-header:

**hasHeader**
   ``hasHeader(string $name)``

   Check if exists the header type specified



   Returns boolean

.. _zend.http.client.methods.get-header:

**getHeader**
   ``getHeader(string $name)``

   Get the header value of the request



   Returns string|boolean

.. _zend.http.client.methods.set-stream:

**setStream**
   ``setStream(string|boolean $streamfile = true)``

   Set streaming for received data



   Returns Zend\\Http\\Client

.. _zend.http.client.methods.get-stream:

**getStream**
   ``getStream()``

   Get status of streaming for received data



   Returns boolean|string

.. _zend.http.client.methods.set-auth:

**setAuth**
   ``setAuth(string $user, string $password, string $type = 'basic')``

   Create a HTTP authentication "Authorization:" header according to the specified user, password and
   authentication method.



   Returns Zend\\Http\\Client

.. _zend.http.client.methods.reset-parameters:

**resetParameters**
   ``resetParameters()``

   Reset all the HTTP parameters (auth,cookies,request, response, etc)



   Returns void

.. _zend.http.client.methods.dispatch:

**dispatch**
   ``dispatch(Zend\Stdlib\RequestInterface $request, Zend\Stdlib\ResponseInterface $response= null)``

   Dispatch HTTP request



   Returns Response


.. _zend.http.client.methods.send:

**send**
   ``send(Zend\Http\Request $request)``

   Send HTTP request



   Returns Response

.. _zend.http.client.methods.set-file-upload:

**setFileUpload**
   ``setFileUpload(string $filename, string $formname, string $data = null, string $ctype = null)``

   Set a file to upload (using a POST request)

   Can be used in two ways: 1. $data is null (default): $filename is treated as the name if a local file which will
   be read and sent. Will try to guess the content type using mime_content_type(). 2. $data is set - $filename is
   sent as the file name, but $data is sent as the file contents and no file is read from the file system. In this
   case, you need to manually set the Content-Type ($ctype) or it will default to application/octet-stream.

   Returns Zend\\Http\\Client

.. _zend.http.client.methods.remove-file-upload:

**removeFileUpload**
   ``removeFileUpload(string $filename)``

   Remove a file to upload



   Returns boolean

.. _zend.http.client.methods.encode-form-data:

**encodeFormData**
   ``encodeFormData(string $boundary, string $name, mixed $value, string $filename = null, array $headers = array ( ))``

   Encode data to a multipart/form-data part suitable for a POST request.



   Returns string

.. _zend.http.client.examples:

Examples
--------

.. _zend.http.client.basic-requests.example-1:

Performing a Simple GET Request
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Performing simple *HTTP* requests is very easily done using the setRequest() and dispatch() methods:

.. code-block:: php
   :linenos:

   use Zend\Http\Client;
   use Zend\Http\Request;

   $request = new Request();
   $client = new Client('http://example.org');
   $client->setRequest($request);
   $response = $client->dispatch();

The ``request`` object can be configured using his methods as shown in the
:ref:`Zend\\Http\\Request manual page<zend.http.request>`. One of these methods is ``setMethod`` which refers
to the HTTP Method. This can be either ``GET``, ``POST``, ``PUT``, ``HEAD``, ``DELETE``, ``TRACE``,
``OPTIONS`` or ``CONNECT`` as defined by the *HTTP* protocol [#]_.

.. _zend.http.client.basic-requests.example-2:

Using Request Methods Other Than GET
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For convenience, these are all defined as class constants: Zend\\Http\\Request::METHOD_GET,
Zend\\Http\\Request::METHOD_POST and so on.

If no method is specified, the method set by the last ``setMethod()`` call is used. If ``setMethod()`` was never
called, the default request method is ``GET`` (see the above example).

.. code-block:: php
   :linenos:

   use Zend\Http\Client;
   use Zend\Http\Request;

   $request = new Request();
   $request->setUri('http://example.org');
   $client = new Client();

   // Performing a POST request
   $request->setMethod(Request::METHOD_POST);
   $client->setRequest($request);
   $response = $client->dispatch();

.. _zend.http.client.parameters.example-1:

Setting GET parameters
^^^^^^^^^^^^^^^^^^^^^^

Adding ``GET`` parameters to an *HTTP* request is quite simple, and can be done either by specifying them as part
of the URL, or by using the ``setParameterGet()`` method. This method takes the ``GET`` parameters as an
associative array of name => value ``GET`` variables.

.. code-block:: php
   :linenos:

   use Zend\Http\Client;
   $client = new Client();

   // This is equivalent to setting a URL in the Client's constructor:
   $client->setUri('http://example.com/index.php?knight=lancelot');

   // Adding several parameters with one call
   $client->setParameterGet(array(
      'first_name'  => 'Bender',
      'middle_name' => 'Bending',
      'last_name'   => 'Rodríguez',
      'made_in'     => 'Mexico',
   ));

.. _zend.http.client.parameters.example-2:

Setting POST Parameters
^^^^^^^^^^^^^^^^^^^^^^^

While ``GET`` parameters can be sent with every request method, ``POST`` parameters are only sent in the body of
``POST`` requests. Adding ``POST`` parameters to a request is very similar to adding ``GET`` parameters, and can be
done with the ``setParameterPost()`` method, which is identical to the ``setParameterGet()`` method in structure.

.. code-block:: php
   :linenos:

   use Zend\Http\Client;
   $client = new Client();

   // Setting several POST parameters, one of them with several values
   $client->setParameterPost(array(
       'language'  => 'es',
       'country'   => 'ar',
       'selection' => array(45, 32, 80)
   ));

Note that when sending ``POST`` requests, you can set both ``GET`` and ``POST`` parameters. On the other hand,
setting POST parameters on a non-``POST`` request will not trigger an error, rendering it useless. Unless the
request is a ``POST`` request, ``POST`` parameters are simply ignored.

.. _zend.http.client.request-object-usage:

A Complete Example
^^^^^^^^^^^^^^^^^^



.. code-block:: php
   :linenos:

   use Zend\Http\Request;
   use Zend\Http\Client;
   $request = new Request();
   $request->setUri('http://www.test.com');
   $request->setMethod('POST');
   $request->getPost()->set('foo', 'bar');

   $client = new Client();
   $response = $client->dispatch($request);

   if ($response->isSuccess()) {
       //  the POST was successful
   }




.. [#] See RFC 2616 -http://www.w3.org/Protocols/rfc2616/rfc2616.html.
