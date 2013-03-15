.. _zend.http.headers:

The Headers Class
=================

.. _zend.http.headers.intro:

Overview
--------

The ``Zend\Http\Headers`` class is a container for HTTP headers. It is typically accessed as part of a
``Zend\Http\Request`` or ``Zend\Http\Response`` ``getHeaders()`` call. The Headers container will lazily load
actual Header objects as to reduce the overhead of header specific parsing.

The ``Zend\Http\Header\*`` classes are the domain specific implementations for the various types of Headers that
one might encounter during the typical HTTP request. If a header of unknown type is encountered, it will be
implemented as a ``Zend\Http\Header\GenericHeader`` instance. See the below table for a list of the various HTTP
headers and the API that is specific to each header type.

.. _zend.http.headers.quick-start:

Quick Start
-----------

The quickest way to get started interacting with header objects is by getting an already populated Headers
container from a request or response object.

.. code-block:: php
   :linenos:

   // $client is an instance of Zend\Http\Client

   // You can retrieve the request headers by first retrieving
   // the Request object and then calling getHeaders on it
   $requestHeaders  = $client->getRequest()->getHeaders();

   // The same method also works for retrieving Response headers
   $responseHeaders = $client->getResponse()->getHeaders();

``Zend\Http\Headers`` can also extract headers from a string:

.. code-block:: php
   :linenos:

   $headerString = <<<EOB
   Host: www.example.com
   Content-Type: text/html
   Content-Length: 1337
   EOB;

   $headers = Zend\Http\Headers::fromString($headerString);
   // $headers is now populated with three objects
   //   (1) Zend\Http\Header\Host
   //   (2) Zend\Http\Header\ContentType
   //   (3) Zend\Http\Header\ContentLength

Now that you have an instance of ``Zend\Http\Headers`` you can manipulate the individual headers it contains using
the provided public API methods outlined in the ":ref:`Available Methods<zend.http.headers.methods>`" section.


.. _zend.http.headers.options:

Configuration Options
---------------------

No configuration options are available.

.. _zend.http.headers.methods:

Available Methods
-----------------

.. _zend.http.headers.methods.from-string:

**Headers::fromString**
   ``Headers::fromString(string $string)``

   Populates headers from string representation

   Parses a string for headers, and aggregates them, in order, in the current instance, primarily as strings until
   they are needed (they will be lazy loaded).

   Returns ``Zend\Http\Headers``

.. _zend.http.headers.methods.set-plugin-class-loader:

**setPluginClassLoader**
   ``setPluginClassLoader(Zend\Loader\PluginClassLocator $pluginClassLoader)``

   Set an alternate implementation for the plugin class loader

   Returns ``Zend\Http\Headers``

.. _zend.http.headers.methods.get-plugin-class-loader:

**getPluginClassLoader**
   ``getPluginClassLoader()``

   Return an instance of a ``Zend\Loader\PluginClassLocator``, lazyload and inject map if necessary.

   Returns ``Zend\Loader\PluginClassLocator``

.. _zend.http.headers.methods.add-headers:

**addHeaders**
   ``addHeaders(array|Traversable $headers)``

   Add many headers at once

   Expects an array (or ``Traversable`` object) of type/value pairs.

   Returns ``Zend\Http\Headers``

.. _zend.http.headers.methods.add-header-line:

**addHeaderLine**
   ``addHeaderLine(string $headerFieldNameOrLine, string $fieldValue)``

   Add a raw header line, either in name => value, or as a single string 'name: value'

   This method allows for lazy-loading in that the parsing and instantiation of Header object will be delayed until
   they are retrieved by either ``get()`` or ``current()``.

   Returns ``Zend\Http\Headers``

.. _zend.http.headers.methods.add-header:

**addHeader**
   ``addHeader(Zend\Http\Header\HeaderInterface $header)``

   Add a Header to this container, for raw values see ``addHeaderLine()`` and ``addHeaders()``.

   Returns ``Zend\Http\Headers``

.. _zend.http.headers.methods.remove-header:

**removeHeader**
   ``removeHeader(Zend\Http\Header\HeaderInterface $header)``

   Remove a Header from the container

   Returns bool

.. _zend.http.headers.methods.clear-headers:

**clearHeaders**
   ``clearHeaders()``

   Clear all headers

   Removes all headers from queue

   Returns ``Zend\Http\Headers``

.. _zend.http.headers.methods.get:

**get**
   ``get(string $name)``

   Get all headers of a certain name/type

   Returns false| ``Zend\Http\Header\HeaderInterface``\ | ``ArrayIterator``

.. _zend.http.headers.methods.has:

**has**
   ``has(string $name)``

   Test for existence of a type of header

   Returns bool

.. _zend.http.headers.methods.next:

**next**
   ``next()``

   Advance the pointer for this object as an interator

   Returns void

.. _zend.http.headers.methods.key:

**key**
   ``key()``

   Return the current key for this object as an interator

   Returns mixed

.. _zend.http.headers.methods.valid:

**valid**
   ``valid()``

   Is this iterator still valid?

   Returns bool

.. _zend.http.headers.methods.rewind:

**rewind**
   ``rewind()``

   Reset the internal pointer for this object as an iterator

   Returns void

.. _zend.http.headers.methods.current:

**current**
   ``current()``

   Return the current value for this iterator, lazy loading it if need be

   Returns ``Zend\Http\Header\HeaderInterface``

.. _zend.http.headers.methods.count:

**count**
   ``count()``

   Return the number of headers in this container. If all headers have not been parsed, actual count could increase
   if MultipleHeader objects exist in the Request/Response. If you need an exact count, iterate.

   Returns int

.. _zend.http.headers.methods.to-string:

**toString**
   ``toString()``

   Render all headers at once

   This method handles the normal iteration of headers; it is up to the concrete classes to prepend with the
   appropriate status/request line.

   Returns string

.. _zend.http.headers.methods.to-array:

**toArray**
   ``toArray()``

   Return the headers container as an array

   Returns array

.. _zend.http.headers.methods.force-loading:

**forceLoading**
   ``forceLoading()``

   By calling this, it will force parsing and loading of all headers, after this ``count()`` will be accurate

   Returns bool

.. _zend.http.headers.header-description:

Zend\\Http\\Header\\* Base Methods
----------------------------------

.. _zend.http.header.generic-header.methods.from-string:

**fromString**
   ``fromString(string $headerLine)``

   Factory to generate a header object from a string

   Returns ``Zend\Http\Header\GenericHeader``

.. _zend.http.header.generic-header.methods.get-field-name:

**getFieldName**
   ``getFieldName()``

   Retrieve header field name

   Returns string

.. _zend.http.header.generic-header.methods.get-field-value:

**getFieldValue**
   ``getFieldValue()``

   Retrieve header field value

   Returns string

.. _zend.http.header.generic-header.methods.to-string:

**toString**
   ``toString()``

   Cast to string as a well formed HTTP header line

   Returns in form of "NAME: VALUE\\r\\n"

   Returns string

.. _zend.http.header-types.list:

List of HTTP Header Types
-------------------------

.. table:: Zend\\Http\\Header\\* Classes

   +------------------+-----------------------------------------------------------------------------------------------+
   |Class Name        |Additional Methods                                                                             |
   +==================+===============================================================================================+
   |Accept            |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |AcceptCharset     |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |AcceptEncoding    |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |AcceptLanguage    |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |AcceptRanges      |getRangeUnit() / setRangeUnit() - The range unit of the accept ranges header                   |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Age               |getDeltaSeconds() / setDeltaSeconds() - The age in delta seconds                               |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Allow             |getAllowedMethods() / setAllowedMethods() - An array of allowed methods                        |
   +------------------+-----------------------------------------------------------------------------------------------+
   |AuthenticationInfo|N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Authorization     |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |CacheControl      |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Connection        |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |ContentDisposition|N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |ContentEncoding   |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |ContentLanguage   |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |ContentLength     |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |ContentLocation   |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |ContentMD5        |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |ContentRange      |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |ContentType       |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Cookie            |Extends \\ArrayObject                                                                          |
   |                  |setEncodeValue() / getEncodeValue() - Whether or not to encode values                          |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Date              |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Etag              |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Expect            |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Expires           |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |From              |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Host              |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |IfMatch           |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |IfModifiedSince   |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |IfNoneMatch       |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |IfRange           |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |IfUnmodifiedSince |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |KeepAlive         |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |LastModified      |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Location          |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |MaxForwards       |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Pragma            |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |ProxyAuthenticate |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |ProxyAuthorization|N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Range             |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Referer           |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Refresh           |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |RetryAfter        |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Server            |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |SetCookie         |getName() / setName() - The cookie name                                                        |
   |                  |getValue() / setValue() - The cookie value                                                     |
   |                  |getExpires() / setExpires() - The time frame the cookie is valid for, null is a session cookie |
   |                  |getPath() / setPath() - The uri path the cookie is bound to                                    |
   |                  |getDomain() / setDomain() - The domain the cookie applies to                                   |
   |                  |getMaxAge() / setMaxAge() - The maximum age of the cookie                                      |
   |                  |getVersion() / setVersion() - The cookie version                                               |
   |                  |isSecure() / setSecure() - Whether the cookies contains the Secure flag                        |
   |                  |isHttponly() / setHttponly() - Whether the cookies can be accessed via HTTP only               |
   |                  |isSessionCookie() - Whether the cookie is a session cookie                                     |
   |                  |isExpired() - Whether the cookie is expired                                                    |
   |                  |isValidForRequest() - Whether the cookie is valid for a given request domain, path and isSecure|
   +------------------+-----------------------------------------------------------------------------------------------+
   |TE                |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Trailer           |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |TransferEncoding  |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Upgrade           |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |UserAgent         |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Vary              |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Via               |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |Warning           |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+
   |WWWAuthenticate   |N/A                                                                                            |
   +------------------+-----------------------------------------------------------------------------------------------+

.. _zend.http.headers.examples:

Examples
--------

.. _zend.http.headers.examples.retrieving-headers:

.. rubric:: Retrieving headers from a Zend\\Http\\Headers object

.. code-block:: php
   :linenos:

   // $client is an instance of Zend\Http\Client
   $response = $client->send();
   $headers = $response->getHeaders();

   // We can check if the Request contains a specific header by
   // using the ``has`` method. Returns boolean ``TRUE`` if at least
   // one matching header found, and ``FALSE`` otherwise
   $headers->has('Content-Type');

   // We can retrieve all instances of a specific header by using
   // the ``get`` method:
   $contentTypeHeaders = $headers->get('Content-Type');

There are three possibilities for the return value of the above call to the ``get`` method:

 -  If no Content-Type header was set in the Request, ``get`` will return false.

 -  If only one Content-Type header was set in the Request,
    ``get`` will return an instance of ``Zend\Http\Header\ContentType``.

 -  If more than one Content-Type header was set in the Request,
    ``get`` will return an ArrayIterator containing one
    ``Zend\Http\Header\ContentType`` instance per header.

.. _zend.http.headers.examples.adding-headers:

.. rubric:: Adding headers to a Zend\\Http\\Headers object

.. code-block:: php
   :linenos:

   $headers = new Zend\Http\Headers();

   // We can directly add any object that implements Zend\Http\Header\HeaderInterface
   $typeHeader = Zend\Http\Header\ContentType::fromString('Content-Type: text/html');
   $headers->addHeader($typeHeader);

   // We can add headers using the raw string representation, either
   // passing the header name and value as separate arguments...
   $headers->addHeaderLine('Content-Type', 'text/html');

   // .. or we can pass the entire header as the only argument
   $headers->addHeaderLine('Content-Type: text/html');

   // We can also add headers in bulk using addHeaders, which accepts
   // an array of individual header definitions that can be in any of
   // the accepted formats outlined below:
   $headers->addHeaders(array(

       // An object implementing Zend\Http\Header\HeaderInterface
       Zend\Http\Header\ContentType::fromString('Content-Type: text/html'),

       // A raw header string
       'Content-Type: text/html',

       // We can also pass the header name as the array key and the
       // header content as that array key's value
       'Content-Type' => 'text/html');

   ));

.. _zend.http.headers.examples.removing-headers:

.. rubric:: Removing headers from a Zend\\Http\\Headers object

We can remove all headers of a specific type using the ``removeHeader`` method,
which accepts a single object implementing ``Zend\Http\Header\HeaderInterface``

.. code-block:: php
   :linenos:

   // $headers is a pre-configured instance of Zend\Http\Headers

   // We can also delete individual headers or groups of headers
   $matches = $headers->get('Content-Type');

   // If more than one header was found, iterate over the collection
   // and remove each one individually
   if ($matches instanceof ArrayIterator) {
       foreach ($headers as $header) {
           $headers->removeHeader($header);
       }
   // If only a single header was found, remove it directly
   } elseif ($matches instanceof Zend\Http\Header\HeaderInterface) {
       $headers->removeHeader($header);
   }

   // In addition to this, we can clear all the headers currently stored in
   // the container by calling the clearHeaders() method
   $matches->clearHeaders();

