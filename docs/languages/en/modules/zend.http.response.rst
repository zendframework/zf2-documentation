.. _zend.http.response:

The Response Class
==================

.. _zend.http.response.intro:

Overview
--------

The ``Zend\Http\Response`` class is responsible for providing a fluent API that allows a developer to interact with
all the various parts of an HTTP response.

A typical HTTP Response looks like this:


::

   ---------------------------
   | VERSION | CODE | REASON |
   ---------------------------
   |        HEADERS          |
   ---------------------------
   |         BODY            |
   ---------------------------

The first line of the response consists of the HTTP version, status code, and the reason string for the provided
status code; this is called the Response Line. Next is a set of headers; there can be 0 or an unlimited number of
headers. The remainder of the response is the response body, which is typically a string of HTML that will render
on the client's browser, but which can also be a place for request/response payload data typical of an AJAX
request. More information on the structure and specification of an HTTP response can be found in `RFC-2616 on the
W3.org site`_.

.. _zend.http.response.quick-start:

Quick Start
-----------

Response objects can either be created from the provided ``fromString()`` factory, or, if you wish to have a
completely empty object to start with, by simply instantiating the ``Zend\Http\Response`` class.

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
   ));
   $response->setContent(<<<EOS
   <html>
   <body>
       Hello World
   </body>
   </html>
   EOS);

.. _zend.http.response.options:

Configuration Options
---------------------

No configuration options are available.

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

.. _zend.http.request.methods.set-server:

**setHeaders**
   ``setHeaders(Zend\Http\Headers $headers)``

   Provide an alternate Parameter Container implementation for headers in this object. (This is NOT the primary API
   for value setting; for that, see ``getHeaders()``.)

   Returns ``Zend\Http\Request``

.. _zend.http.request.methods.get-headers:

**getHeaders**
   ``getHeaders()``

   Return the container responsible for storing HTTP headers.  This container exposes the primary API for
   manipulating headers set in the HTTP response.  See :ref:`the section on Zend\\Http\\Headers<zend.http.headers>`
   for more information.

   Returns ``Zend\Http\Headers``

.. _zend.http.request.methods.set-version:

**setVersion**
   ``setVersion(string $version)``

   Set the HTTP version for this object, one of 1.0 or 1.1 (``Request::VERSION_10``, ``Request::VERSION_11``).

   Returns ``Zend\Http\Request``.

.. _zend.http.request.methods.get-version:

**getVersion**
   ``getVersion()``

   Return the HTTP version for this request

   Returns string

.. _zend.http.response.methods.set-status-code:

**setStatusCode**
   ``setStatusCode(numeric $code)``

   Set HTTP status code

   Returns ``Zend\Http\Response``

.. _zend.http.response.methods.get-status-code:

**getStatusCode**
   ``getStatusCode()``

   Retrieve HTTP status code

   Returns int

.. _zend.http.response.methods.set-reason-phrase:

**setReasonPhrase**
   ``setReasonPhrase(string $reasonPhrase)``

   Set custom HTTP status message

   Returns ``Zend\Http\Response``

.. _zend.http.response.methods.get-reason-phrase:

**getReasonPhrase**
   ``getReasonPhrase()``

   Get HTTP status message

   Returns string

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

**isSuccess**
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

**decodeDeflate**
   ``decodeDeflate(string $body)``

   Decode a zlib deflated message (when Content-encoding = deflate)

   Currently requires PHP with zlib support

   Returns string

.. _zend.http.response._parent_.zend.stdlib.message.methods.set-metadata:

**setMetadata**
   ``setMetadata(string|int|array|Traversable $spec, mixed $value)``

   Set message metadata

   Non-destructive setting of message metadata; always adds to the metadata, never overwrites the entire metadata
   container.

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

   Get raw message content

   Returns mixed
   
.. _zend.http.response._parent_.zend.stdlib.message.methods.get-body:

**getBody**
   ``getBody()``

   Get decoded message content

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

.. rubric:: Generating a formatted HTTP Response from a Response object

.. code-block:: php
   :linenos:

   use Zend\Http\Response;
   $response = new Response();
   $response->setStatusCode(Response::STATUS_CODE_200);
   $response->getHeaders()->addHeaders(array(
       'HeaderField1' => 'header-field-value',
       'HeaderField2' => 'header-field-value2',
   ));
   $response->setContent(<<<EOS
   <html>
   <body>
       Hello World
   </body>
   </html>
   EOS);



.. _`RFC-2616 on the W3.org site`: http://www.w3.org/Protocols/rfc2616/rfc2616-sec6.html
