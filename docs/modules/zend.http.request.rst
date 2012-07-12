
Zend\\Http\\Request
===================

.. _zend.http.request.intro:

Overview
--------

The ``Zend\Http\Request`` object is responsible for providing a fluent API that allows a developer to interact with all the various parts of an HTTP request.

A typical HTTP request looks like this:
--------------------------| METHOD | URI | VERSION |--------------------------| HEADERS |--------------------------| BODY |--------------------------
In simplified terms, the request consist of a method, *URI* and the HTTP version number which all make up the "Request Line." Next is a set of headers; there can be 0 or an unlimited number of headers. After that is the request body, which is typically used when a client wishes to send data to the server in the form of an encoded file, or include a set of POST parameters, for example. More information on the structure and specification of an HTTP request can be found in `RFC-2616 on the W3.org site`_ .

.. _zend.http.request.quick-start:

Quick Start
-----------

Request objects can either be created from the provided ``fromString()`` factory, or, if you wish to have a completely empty object to start with, by simply instantiating the ``Zend\Http\Request`` class.

.. code-block:: php
    :linenos:
    
    use Zend\Http\Request;
    $request = Request::fromString(<<<EOS
    POST /foo HTTP/1.1
    HeaderField1: header-field-value
    HeaderField2: header-field-value2
    
    foo=bar&
    EOS);
    
    // OR, the completely equivalent
    
    $request = new Request();
    $request->setMethod(Request::METHOD_POST);
    $request->setUri('/foo');
    $request->header()->addHeaders(array(
        'HeaderField1' => 'header-field-value',
        'HeaderField2' => 'header-field-value2',
    );
    $request->post()->set('foo', 'bar');
    
    

.. _zend.http.request.options:

Configuration Options
---------------------

None currently

.. _zend.http.request.methods:

Available Methods
-----------------

.. _zend.http.request.methods.from-string:


**Request::fromString**


    ``Request::fromString(string $string)``


A factory that produces a Request object from a well-formed Http Request string

Returns ``Zend\Http\Request`` 

.. _zend.http.request.methods.set-method:


**setMethod**


    ``setMethod(string $method)``


Set the method for this request.

Returns ``Zend\Http\Request`` 

.. _zend.http.request.methods.get-method:


**getMethod**


    ``getMethod()``


Return the method for this request.

Returns string.

.. _zend.http.request.methods.set-uri:


**setUri**


    ``setUri(string|\\Zend\\Stdlib\\RequestInterface|\\Zend\\Stdlib\\Message|\\Zend\\Stdlib\\ParametersInterface|\\Zend\\Stdlib\\Parameters|\\Zend\\Uri\\Http $uri)``


Set the URI/URL for this request; this can be a string or an instance of ``Zend\Uri\Http`` .

Returns Zend\\Http\\Request

.. _zend.http.request.methods.get-uri:


**getUri**


    ``getUri()``


Return the URI for this request object.

Returns string.

.. _zend.http.request.methods.uri:


**uri**


    ``uri()``


Return the URI for this request object as an instance of ``Zend\Uri\Http`` .

Returns ``Zend\Uri\Http`` .

.. _zend.http.request.methods.set-version:


**setVersion**


    ``setVersion(string $version)``


Set the HTTP version for this object, one of 1.0 or 1.1 ( ``Request::VERSION_10`` , ``Request::VERSION_11`` ).

Returns ``Zend\Http\Request`` .

.. _zend.http.request.methods.get-version:


**setVersion**


    ``getVersion()``


Return the HTTP version for this request

Returns string

.. _zend.http.request.methods.set-query:


**setQuery**


    ``setQuery(Zend\\Stdlib\\ParametersInterface $query)``


Provide an alternate Parameter Container implementation for query parameters in this object. (This is NOT the primary API for value setting; for that, see ``query()`` .)

Returns Zend\\Http\\Request

.. _zend.http.request.methods.query:


**setQuery**


    ``query()``


Return the parameter container responsible for query parameters.

Returns ``Zend\Stdlib\ParametersInterface`` 

.. _zend.http.request.methods.set-post:


**setPost**


    ``setPost(Zend\\Stdlib\\ParametersInterface $post)``


Provide an alternate Parameter Container implementation for post parameters in this object. (This is NOT the primary API for value setting; for that, see ``post()`` .)

Returns ``Zend\Http\Request`` 

.. _zend.http.request.methods.post:


**post**


    ``post()``


Return the parameter container responsible for post parameters.

Returns ``Zend\Stdlib\ParametersInterface`` 

.. _zend.http.request.methods.cookie:


**cookie**


    ``cookie()``


Return the Cookie header, this is the same as calling$request->header()->get('Cookie');.

Returns ``Zend\Http\Header\Cookie`` 

.. _zend.http.request.methods.set-file:


**setFile**


    ``setFile(Zend\\Stdlib\\ParametersInterface $files)``


Provide an alternate Parameter Container implementation for file parameters in this object. (This is NOT the primary API for value setting; for that, see ``file()`` .)

Returns ``Zend\Http\Request`` 

.. _zend.http.request.methods.file:


**file**


    ``file()``


Return the parameter container responsible for file parameters

Returns ``Zend\Stdlib\ParametersInterface`` 

.. _zend.http.request.methods.set-server:


**setServer**


    ``setServer(Zend\\Stdlib\\ParametersInterface $server)``


Provide an alternate Parameter Container implementation for server parameters in this object. (This is NOT the primary API for value setting; for that, see ``server()`` .)

Returns ``Zend\Http\Request`` 

.. _zend.http.request.methods.server:


**server**


    ``server()``


Return the parameter container responsible for server parameters

Returns ``Zend\Stdlib\ParametersInterface`` 

.. _zend.http.request.methods.set-env:


**setEnv**


    ``setEnv(Zend\\Stdlib\\ParametersInterface $env)``


Provide an alternate Parameter Container implementation for env parameters in this object. (This is NOT the primary API for value setting; for that, see ``env()`` .)

Returns ``Zend\Http\Request`` 

.. _zend.http.request.methods.env:


**env**


    ``env()``


Return the parameter container responsible for env parameters

Returns ``Zend\Stdlib\ParametersInterface`` 

.. _zend.http.request.methods.set-header:


**setHeader**


    ``setHeader(Zend\\Http\\Headers $headers)``


Provide an alternate Parameter Container implementation for headers in this object. (This is NOT the primary API for value setting; for that, see ``header()`` .)

Returns ``Zend\Http\Request`` 

.. _zend.http.request.methods.header:


**header**


    ``header()``


Return the header container responsible for headers

Returns ``Zend\Http\Headers`` 

.. _zend.http.request.methods.set-raw-body:


**setRawBody**


    ``setRawBody(string $string)``


Set the raw body for the request

Returns ``Zend\Http\Request`` 

.. _zend.http.request.methods.get-raw-body:


**getRawBody**


    ``getRawBody()``


Get the raw body for the request

Returns string

.. _zend.http.request.methods.is-options:


**isOptions**


    ``isOptions()``


Is this an OPTIONS method request?

Returns bool

.. _zend.http.request.methods.is-get:


**isGet**


    ``isGet()``


Is this a GET method request?

Returns bool

.. _zend.http.request.methods.is-head:


**isHead**


    ``isHead()``


Is this a HEAD method request?

Returns bool

.. _zend.http.request.methods.is-post:


**isPost**


    ``isPost()``


Is this a POST method request?

Returns bool

.. _zend.http.request.methods.is-put:


**isPut**


    ``isPut()``


Is this a PUT method request?

Returns bool

.. _zend.http.request.methods.is-delete:


**isDelete**


    ``isDelete()``


Is this a DELETE method request?

Returns bool

.. _zend.http.request.methods.is-trace:


**isTrace**


    ``isTrace()``


Is this a TRACE method request?

Returns bool

.. _zend.http.request.methods.is-connect:


**isConnect**


    ``isConnect()``


Is this a CONNECT method request?

Returns bool

.. _zend.http.request.methods.render-request-line:


**renderRequestLine**


    ``renderRequestLine()``


Return the formatted request line (first line) for this HTTP request

Returns string

.. _zend.http.request.methods.to-string:


**toString**


    ``toString()``


Returns string

.. _zend.http.request.methods.__to-string:


**__toString**


    ``__toString()``


Allow PHP casting of this object

Returns string

.. _zend.stdlib.message.methods.set-metadata:


**setMetadata**


    ``setMetadata(string|int|array|Traversable $spec, mixed $value)``


Set message metadata

Non-destructive setting of message metadata; always adds to the metadata, never overwritesthe entire metadata container.

Returns ``Zend\Stdlib\Message`` 

.. _zend.stdlib.message.methods.get-metadata:


**getMetadata**


    ``getMetadata(null|string|int $key, null|mixed $default)``


Retrieve all metadata or a single metadatum as specified by key

Returns mixed

.. _zend.stdlib.message.methods.set-content:


**setContent**


    ``setContent(mixed $value)``


Set message content

Returns ``Zend\Stdlib\Message`` 

.. _zend.stdlib.message.methods.get-content:


**getContent**


    ``getContent()``


Get message content

Returns mixed

.. _zend.http.request.examples:

Examples
--------

.. _zend.http.request.examples.from-string:

Generating a Request object from a string
-----------------------------------------

.. code-block:: php
    :linenos:
    
    use Zend\Http\Request;
    $string = "GET /foo HTTP/1.1\r\n\r\nSome Content";
    $request = Request::fromString($string);
    
    $request->getMethod();  // returns Request::METHOD_GET
    $request->getUri();     // returns '/foo'
    $request->getVersion(); // returns Request::VERSION_11 or '1.1'
    $request->getRawBody(); // returns 'Some Content'
    

.. _zend.http.request.examples.from-array:

Generating a Request object from an array
-----------------------------------------

.. code-block:: php
    :linenos:
    
    N/A
    

.. _zend.http.request.examples.headers:

Retrieving and setting headers
------------------------------

.. code-block:: php
    :linenos:
    
    use Zend\Http\Request;
    $request = new Request();
    $request->getHeaders()->get('Content-Type'); // return content type
    $request->getHeaders()->addHeader(new Cookie('foo' => 'bar'));
    foreach ($request->getHeaders() as $header) {
        echo $header->getFieldName() . ' with value ' . $header->getFieldValue();
    }
    

.. _zend.http.request.examples.parameters:

Retrieving and setting GET and POST values
------------------------------------------

.. code-block:: php
    :linenos:
    
    use Zend\Http\Request;
    $request = new Request();
    
    // post() and get() both return, by default, a Parameters object, which extends ArrayObject
    $request->post()->foo = 'value';
    echo $request->get()->myVar;
    echo $request->get()->offsetGet('myVar');
    

.. _zend.http.request.examples.to-string:

Generating an formatted HTTP Request from an Request object
-----------------------------------------------------------

.. code-block:: php
    :linenos:
    
    use Zend\Http\Request;
    $request = new Request();
    $request->setMethod(Request::METHOD_POST);
    $request->setUri('/foo');
    $request->header()->addHeaders(array(
        'HeaderField1' => 'header-field-value',
        'HeaderField2' => 'header-field-value2',
    );
    $request->post()->set('foo', 'bar');
    echo $request->toString();
    
    /** Will produce:
    POST /foo HTTP/1.1
    HeaderField1: header-field-value
    HeaderField2: header-field-value2
    
    foo=bar
    */
    


.. _`RFC-2616 on the W3.org site`: http://www.w3.org/Protocols/rfc2616/rfc2616-sec5.html
