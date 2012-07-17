
.. _zend.http.response:

Zend\\Http\\Response
====================


.. _zend.http.response.intro:

Overview
--------

The ``Zend\Http\Response`` class is responsible for providing a fluent API that allows a developer to interact with all the various parts of an HTTP response.

A typical HTTP Response looks like this:



::

   ---------------------------
   | VERSION | CODE | REASON |
   ---------------------------
   |        HEADERS          |
   ---------------------------
   |         BODY            |
   ---------------------------


The first line of the response consists of the HTTP version, status code, and the reason string for the provided status code; this is called the Response Line. Next is a set of headers; there can be 0 or an unlimited number of headers. The remainder of the response is the response body, which is typically a string of HTML that will render on the client's browser, but which can also be a place for request/response payload data typical of an AJAX request. More information on the structure and specification of an HTTP response can be found in `RFC-2616 on the W3.org site`_.


.. _zend.http.response.quick-start:

Quick Start
-----------

Response objects can either be created from the provided ``fromString()`` factory, or, if you wish to have a completely empty object to start with, by simply instantiating the ``Zend\Http\Response`` class.

.. code-block:: php
   :linenos:

   use Zend\Http\Response;
   $response = Response::fromString(<<<EOS
   HTTP/1.0 200 OK
   HeaderField1: header-field-value
   HeaderField2: header-field-value2

   <html>
   <body>
       Hello World
   </body>
   </html>
   EOS);

   // OR

   $response = new Response();
   $response->setStatusCode(Response::STATUS_CODE_200);
   $response->getHeaders()->addHeaders(array(
       'HeaderField1' => 'header-field-value',
       'HeaderField2' => 'header-field-value2',
   );
   $response->setRawBody(<<<EOS
   <html>
   <body>
       Hello World
   </body>
   </html>
   EOS);


.. _zend.http.response.options:

Configuration Options
---------------------

None currently available


.. _zend.http.response.methods:

Available Methods
-----------------


.. _zend.http.response.methods.from-string:

**Response::fromString**
   ``Response::fromString(string $string)``


   Populate object from string


   Returns ``Zend\Http\Response``



.. _zend.http.response.methods.render-status-line:

**renderStatusLine**
   ``renderStatusLine()``


   Render the status line header


   Returns string



.. _zend.http.response.methods.set-headers:

**setHeaders**
   ``setHeaders(Zend\Http\Headers $headers)``


   Set response headers


   Returns ``Zend\Http\Response``



.. _zend.http.response.methods.headers:

**headers**
   ``headers()``


   Get response headers


   Returns ``Zend\Http\Headers``



.. _zend.http.response.methods.set-version:

**setVersion**
   ``setVersion(string $version)``


   Returns ``Zend\Http\Response``



.. _zend.http.response.methods.get-version:

**getVersion**
   ``getVersion()``


   Returns string



.. _zend.http.response.methods.get-status-code:

**getStatusCode**
   ``getStatusCode()``


   Retrieve HTTP status code


   Returns int



.. _zend.http.response.methods.set-reason-phrase:

**setReasonPhrase**
   ``setReasonPhrase(string $reasonPhrase)``


   Returns ``Zend\Http\Response``



.. _zend.http.response.methods.get-reason-phrase:

**getReasonPhrase**
   ``getReasonPhrase()``


   Get HTTP status message


   Returns string



.. _zend.http.response.methods.set-status-code:

**setStatusCode**
   ``setStatusCode(numeric $code)``


   Set HTTP status code and (optionally) message


   Returns ``Zend\Http\Response``



.. _zend.http.response.methods.is-client-error:

**isClientError**
   ``isClientError()``


   Does the status code indicate a client error?


   Returns bool



.. _zend.http.response.methods.is-forbidden:

**isForbidden**
   ``isForbidden()``


   Is the request forbidden due to ACLs?


   Returns bool



.. _zend.http.response.methods.is-informational:

**isInformational**
   ``isInformational()``


   Is the current status "informational"?


   Returns bool



.. _zend.http.response.methods.is-not-found:

**isNotFound**
   ``isNotFound()``


   Does the status code indicate the resource is not found?


   Returns bool



.. _zend.http.response.methods.is-ok:

**isOk**
   ``isOk()``


   Do we have a normal, OK response?


   Returns bool



.. _zend.http.response.methods.is-server-error:

**isServerError**
   ``isServerError()``


   Does the status code reflect a server error?


   Returns bool



.. _zend.http.response.methods.is-redirect:

**isRedirect**
   ``isRedirect()``


   Do we have a redirect?


   Returns bool



.. _zend.http.response.methods.is-success:

**isRedirect**
   ``isSuccess()``


   Was the response successful?


   Returns bool



.. _zend.http.response.methods.decode-chunked-body:

**decodeChunkedBody**
   ``decodeChunkedBody(string $body)``


   Decode a "chunked" transfer-encoded body and return the decoded text


   Returns string



.. _zend.http.response.methods.decode-gzip:

**decodeGzip**
   ``decodeGzip(string $body)``


   Decode a gzip encoded message (when Content-encoding = gzip)


   Currently requires PHP with zlib support


   Returns string



.. _zend.http.response.methods.decode-deflate:

**decodeGzip**
   ``decodeDeflate(string $body)``


   Decode a zlib deflated message (when Content-encoding = deflate)


   Currently requires PHP with zlib support


   Returns string



.. _zend.http.response._parent_.zend.stdlib.message.methods.set-metadata:

**setMetadata**
   ``setMetadata(string|int|array|Traversable $spec, mixed $value)``


   Set message metadata


   Non-destructive setting of message metadata; always adds to the metadata, never overwrites the entire metadata container.


   Returns ``Zend\Stdlib\Message``



.. _zend.http.response._parent_.zend.stdlib.message.methods.get-metadata:

**getMetadata**
   ``getMetadata(null|string|int $key, null|mixed $default)``


   Retrieve all metadata or a single metadatum as specified by key


   Returns mixed



.. _zend.http.response._parent_.zend.stdlib.message.methods.set-content:

**setContent**
   ``setContent(mixed $value)``


   Set message content


   Returns ``Zend\Stdlib\Message``



.. _zend.http.response._parent_.zend.stdlib.message.methods.get-content:

**getContent**
   ``getContent()``


   Get message content





   Returns mixed



.. _zend.http.response._parent_.zend.stdlib.message.methods.to-string:

**toString**
   ``toString()``


   Returns string



.. _zend.http.response.examples:

Examples
--------


.. _zend.http.response.examples.from-string:

.. rubric:: Generating a Response object from a string

.. code-block:: php
   :linenos:

   use Zend\Http\Response;
   $request = Response::fromString(<<<EOS
   HTTP/1.0 200 OK
   HeaderField1: header-field-value
   HeaderField2: header-field-value2

   <html>
   <body>
       Hello World
   </body>
   </html>
   EOS);


.. _zend.http.response.examples.construct-response:

.. rubric:: Generating a Response object from a string

.. code-block:: php
   :linenos:

   use Zend\Http\Response;
   $response = new Response();
   $response->setStatusCode(Response::STATUS_CODE_200);
   $response->getHeaders()->addHeaders(array(
       'HeaderField1' => 'header-field-value',
       'HeaderField2' => 'header-field-value2',
   );
   $response->setRawBody(<<<EOS
   <html>
   <body>
       Hello World
   </body>
   </html>
   EOS);



.. _`RFC-2616 on the W3.org site`: http://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html
