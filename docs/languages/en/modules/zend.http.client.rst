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
``Zend\Uri\Http`` object), and an array or ``Zend\Config\Config`` object containing configuration options.
The ``send()`` method is used to submit the request to the remote server, and a ``Zend\Http\Response`` object is
returned:

.. code-block:: php
   :linenos:

   use Zend\Http\Client;

   $client = new Client('http://example.org', array(
       'maxredirects' => 0,
       'timeout'      => 30
   ));
   $response = $client->send();

Both constructor parameters can be left out, and set later using the setUri() and setConfig() methods:

.. code-block:: php
   :linenos:

   use Zend\Http\Client;

   $client = new Client();
   $client->setUri('http://example.org');
   $client->setOptions(array(
       'maxredirects' => 0,
       'timeout'      => 30
   ));
   $response = $client->send();

``Zend\Http\Client`` can also dispatch requests using a separately configured ``request`` object (see the
:ref:`Zend\\Http\\Request manual page<zend.http.request>` for full details of the methods available):

.. code-block:: php
   :linenos:

   use Zend\Http\Client;
   use Zend\Http\Request;

   $request = new Request();
   $request->setUri('http://example.org');

   $client = new Client();

   $response = $client->send($request);

.. note::

   ``Zend\Http\Client`` uses ``Zend\Uri\Http`` to validate URLs.  See the :ref:`Zend\\Uri manual page<zend.uri>`
   for more information on the validation process.

.. _zend.http.client.options:

Configuration
-------------

The constructor and setOptions() method accepts an associative array of configuration parameters, or a
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

The options are also passed to the adapter class upon instantiation, so the same array or ``Zend\Config\Config``
object) can be used for adapter configuration. See the
:ref:`Zend Http Client adapter section<zend.http.client.adapters>` for more information on the
adapter-specific options available.


.. _zend.http.client.examples:

Examples
--------

.. _zend.http.client.basic-requests.example-1:

Performing a Simple GET Request
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Performing simple *HTTP* requests is very easily done:

.. code-block:: php
   :linenos:

   use Zend\Http\Client;

   $client = new Client('http://example.org');
   $response = $client->send();

.. _zend.http.client.basic-requests.example-2:

Using Request Methods Other Than GET
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The request method can be set using ``setMethod()``. If no method is specified, the method set by the last
``setMethod()`` call is used. If ``setMethod()`` was never called, the default request method is ``GET``.

.. code-block:: php
   :linenos:

   use Zend\Http\Client;

   $client = new Client('http://example.org');

   // Performing a POST request
   $client->setMethod('POST');
   $response = $client->send();

For convenience, ``Zend\Http\Request`` defines all the request methods as class constants, ``Zend\Http\Request::METHOD_GET``,
``Zend\Http\Request::METHOD_POST`` and so on:

.. code-block:: php
   :linenos:

   use Zend\Http\Client;
   use Zend\Http\Request;

   $client = new Client('http://example.org');

   // Performing a POST request
   $client->setMethod(Request::METHOD_POST);
   $response = $client->send();

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

Connecting to SSL URLs
^^^^^^^^^^^^^^^^^^^^^^

If you are trying to connect to an SSL (https) URL and are using the default (``Zend\Http\Client\Adapter\Socket``)
adapter, you may need to set the ``sslcapath`` configuration option in order to allow PHP to validate the
SSL certificate:

.. code-block:: php
   :linenos:

   use Zend\Http\Client;

   $client = new Client('https://example.org', array(
      'sslcapath' => '/etc/ssl/certs'
   ));
   $response = $client->send();

The exact path to use will vary depending on your Operating System. Without this you'll get the exception
"Unable to enable crypto on TCP connection" when trying to connect.

Alternatively, you could switch to the curl adapter, which negotiates SSL connections more transparently:

.. code-block:: php
   :linenos:

   use Zend\Http\Client;

   $client = new Client('https://example.org', array(
      'adapter' => 'Zend\Http\Client\Adapter\Curl'
   ));
   $response = $client->send();

.. _zend.http.client.ssl-example:

A Complete Example
^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   use Zend\Http\Client;

   $client = new Client();
   $client->setUri('http://www.example.com');
   $client->setMethod('POST');
   $client->setParameterPost(array(
      'foo' => 'bar'
   ));

   $response = $client->send();

   if ($response->isSuccess()) {
       // the POST was successful
   }

or the same thing, using a request object:

.. code-block:: php
   :linenos:

   use Zend\Http\Client;
   use Zend\Http\Request;

   $request = new Request();
   $request->setUri('http://www.example.com');
   $request->setMethod('POST');
   $request->getPost()->set('foo', 'bar');

   $client = new Client();
   $response = $client->send($request);

   if ($response->isSuccess()) {
       // the POST was successful
   }


.. [#] See RFC 2616 -http://www.w3.org/Protocols/rfc2616/rfc2616.html.
