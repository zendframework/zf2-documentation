
.. _zend.http.client.advanced:

Zend_Http_Client - Advanced Usage
=================================


.. _zend.http.client.redirections:

HTTP Redirections
-----------------

By default, ``Zend_Http_Client`` automatically handles *HTTP* redirections, and will follow up to 5 redirections. This can be changed by setting the 'maxredirects' configuration parameter.

According to the *HTTP*/1.1 RFC, *HTTP* 301 and 302 responses should be treated by the client by resending the same request to the specified location - using the same request method. However, most clients to not implement this and always use a ``GET`` request when redirecting. By default, ``Zend_Http_Client`` does the same - when redirecting on a 301 or 302 response, all ``GET`` and POST parameters are reset, and a ``GET`` request is sent to the new location. This behavior can be changed by setting the 'strictredirects' configuration parameter to boolean ``TRUE``:
.. _zend.http.client.redirections.example-1:

.. rubric:: Forcing RFC 2616 Strict Redirections on 301 and 302 Responses

.. code-block:: php
   :linenos:

   // Strict Redirections
   $client->setConfig(array('strictredirects' => true));

   // Non-strict Redirections
   $client->setConfig(array('strictredirects' => false));



You can always get the number of redirections done after sending a request using the getRedirectionsCount() method.


.. _zend.http.client.cookies:

Adding Cookies and Using Cookie Persistence
-------------------------------------------

``Zend_Http_Client`` provides an easy interface for adding cookies to your request, so that no direct header modification is required. This is done using the setCookie() method. This method can be used in several ways:
.. _zend.http.client.cookies.example-1:

.. rubric:: Setting Cookies Using setCookie()

.. code-block:: php
   :linenos:

   // Easy and simple: by providing a cookie name and cookie value
   $client->setCookie('flavor', 'chocolate chips');

   // By directly providing a raw cookie string (name=value)
   // Note that the value must be already URL encoded
   $client->setCookie('flavor=chocolate%20chips');

   // By providing a Zend_Http_Cookie object
   $cookie = Zend_Http_Cookie::fromString('flavor=chocolate%20chips');
   $client->setCookie($cookie);

For more information about ``Zend_Http_Cookie`` objects, see :ref:`this section <zend.http.cookies>`.

``Zend_Http_Client`` also provides the means for cookie stickiness - that is having the client internally store all sent and received cookies, and resend them automatically on subsequent requests. This is useful, for example when you need to log in to a remote site first and receive and authentication or session ID cookie before sending further requests.
.. _zend.http.client.cookies.example-2:

.. rubric:: Enabling Cookie Stickiness

.. code-block:: php
   :linenos:

   // To turn cookie stickiness on, set a Cookie Jar
   $client->setCookieJar();

   // First request: log in and start a session
   $client->setUri('http://example.com/login.php');
   $client->setParameterPost('user', 'h4x0r');
   $client->setParameterPost('password', '1337');
   $client->request('POST');

   // The Cookie Jar automatically stores the cookies set
   // in the response, like a session ID cookie.

   // Now we can send our next request - the stored cookies
   // will be automatically sent.
   $client->setUri('http://example.com/read_member_news.php');
   $client->request('GET');

For more information about the ``Zend_Http_CookieJar`` class, see :ref:`this section <zend.http.cookies.cookiejar>`.


.. _zend.http.client.custom_headers:

Setting Custom Request Headers
------------------------------

Setting custom headers can be done by using the setHeaders() method. This method is quite diverse and can be used in several ways, as the following example shows:
.. _zend.http.client.custom_headers.example-1:

.. rubric:: Setting A Single Custom Request Header

.. code-block:: php
   :linenos:

   // Setting a single header, overwriting any previous value
   $client->setHeaders('Host', 'www.example.com');

   // Another way of doing the exact same thing
   $client->setHeaders('Host: www.example.com');

   // Setting several values for the same header
   // (useful mostly for Cookie headers):
   $client->setHeaders('Cookie', array(
       'PHPSESSID=1234567890abcdef1234567890abcdef',
       'language=he'
   ));



setHeader() can also be easily used to set multiple headers in one call, by providing an array of headers as a single parameter:
.. _zend.http.client.custom_headers.example-2:

.. rubric:: Setting Multiple Custom Request Headers

.. code-block:: php
   :linenos:

   // Setting multiple headers, overwriting any previous value
   $client->setHeaders(array(
       'Host' => 'www.example.com',
       'Accept-encoding' => 'gzip,deflate',
       'X-Powered-By' => 'Zend Framework'));

   // The array can also contain full array strings:
   $client->setHeaders(array(
       'Host: www.example.com',
       'Accept-encoding: gzip,deflate',
       'X-Powered-By: Zend Framework'));




.. _zend.http.client.file_uploads:

File Uploads
------------

You can upload files through *HTTP* using the setFileUpload method. This method takes a file name as the first parameter, a form name as the second parameter, and data as a third optional parameter. If the third data parameter is ``NULL``, the first file name parameter is considered to be a real file on disk, and ``Zend_Http_Client`` will try to read this file and upload it. If the data parameter is not ``NULL``, the first file name parameter will be sent as the file name, but no actual file needs to exist on the disk. The second form name parameter is always required, and is equivalent to the "name" attribute of an >input< tag, if the file was to be uploaded through an *HTML* form. A fourth optional parameter provides the file's content-type. If not specified, and ``Zend_Http_Client`` reads the file from the disk, the mime_content_type function will be used to guess the file's content type, if it is available. In any case, the default MIME type will be application/octet-stream.
.. _zend.http.client.file_uploads.example-1:

.. rubric:: Using setFileUpload to Upload Files

.. code-block:: php
   :linenos:

   // Uploading arbitrary data as a file
   $text = 'this is some plain text';
   $client->setFileUpload('some_text.txt', 'upload', $text, 'text/plain');

   // Uploading an existing file
   $client->setFileUpload('/tmp/Backup.tar.gz', 'bufile');

   // Send the files
   $client->request('POST');

In the first example, the $text variable is uploaded and will be available as $_FILES['upload'] on the server side. In the second example, the existing file /tmp/Backup.tar.gz is uploaded to the server and will be available as $_FILES['bufile']. The content type will be guesses automatically if possible - and if not, the content type will be set to 'application/octet-stream'.

.. note::
   **Uploading files**

   When uploading files, the *HTTP* request content-type is automatically set to multipart/form-data. Keep in mind that you must send a POST or PUT request in order to upload files. Most servers will ignore the requests body on other request methods.



.. _zend.http.client.raw_post_data:

Sending Raw POST Data
---------------------

You can use a ``Zend_Http_Client`` to send raw POST data using the setRawData() method. This method takes two parameters: the first is the data to send in the request body. The second optional parameter is the content-type of the data. While this parameter is optional, you should usually set it before sending the request - either using setRawData(), or with another method: setEncType().
.. _zend.http.client.raw_post_data.example-1:

.. rubric:: Sending Raw POST Data

.. code-block:: php
   :linenos:

   $xml = '<book>' .
          '  <title>Islands in the Stream</title>' .
          '  <author>Ernest Hemingway</author>' .
          '  <year>1970</year>' .
          '</book>';

   $client->setRawData($xml, 'text/xml')->request('POST');

   // Another way to do the same thing:
   $client->setRawData($xml)->setEncType('text/xml')->request('POST');

The data should be available on the server side through *PHP*'s $HTTP_RAW_POST_DATA variable or through the php://input stream.

.. note::
   **Using raw POST data**

   Setting raw POST data for a request will override any POST parameters or file uploads. You should not try to use both on the same request. Keep in mind that most servers will ignore the request body unless you send a POST request.



.. _zend.http.client.http_authentication:

HTTP Authentication
-------------------

Currently, ``Zend_Http_Client`` only supports basic *HTTP* authentication. This feature is utilized using the ``setAuth()`` method, or by specifying a username and a password in the URI. The ``setAuth()`` method takes 3 parameters: The user name, the password and an optional authentication type parameter. As mentioned, currently only basic authentication is supported (digest authentication support is planned).
.. _zend.http.client.http_authentication.example-1:

.. rubric:: Setting HTTP Authentication User and Password

.. code-block:: php
   :linenos:

   // Using basic authentication
   $client->setAuth('shahar', 'myPassword!', Zend_Http_Client::AUTH_BASIC);

   // Since basic auth is default, you can just do this:
   $client->setAuth('shahar', 'myPassword!');

   // You can also specify username and password in the URI
   $client->setUri('http://christer:secret@example.com');




.. _zend.http.client.multiple_requests:

Sending Multiple Requests With the Same Client
----------------------------------------------

``Zend_Http_Client`` was also designed specifically to handle several consecutive requests with the same object. This is useful in cases where a script requires data to be fetched from several places, or when accessing a specific *HTTP* resource requires logging in and obtaining a session cookie, for example.

When performing several requests to the same host, it is highly recommended to enable the 'keepalive' configuration flag. This way, if the server supports keep-alive connections, the connection to the server will only be closed once all requests are done and the Client object is destroyed. This prevents the overhead of opening and closing *TCP* connections to the server.

When you perform several requests with the same client, but want to make sure all the request-specific parameters are cleared, you should use the resetParameters() method. This ensures that ``GET`` and POST parameters, request body and request-specific headers are reset and are not reused in the next request.

.. note::
   **Resetting parameters**

   Note that non-request specific headers are not reset by default when the ``resetParameters()`` method is used. Only the 'Content-length' and 'Content-type' headers are reset. This allows you to set-and-forget headers like 'Accept-language' and 'Accept-encoding'


   To clean all headers and other data except for URI and method, use ``resetParameters(true)``.


Another feature designed specifically for consecutive requests is the Cookie Jar object. Cookie Jars allow you to automatically save cookies set by the server in the first request, and send them on consecutive requests transparently. This allows, for example, going through an authentication request before sending the actual data fetching request.

If your application requires one authentication request per user, and consecutive requests might be performed in more than one script in your application, it might be a good idea to store the Cookie Jar object in the user's session. This way, you will only need to authenticate the user once every session.


.. _zend.http.client.multiple_requests.example-1:

.. rubric:: Performing consecutive requests with one client

.. code-block:: php
   :linenos:

   // First, instantiate the client
   $client = new Zend_Http_Client('http://www.example.com/fetchdata.php', array(
       'keepalive' => true
   ));

   // Do we have the cookies stored in our session?
   if (isset($_SESSION['cookiejar']) &&
       $_SESSION['cookiejar'] instanceof Zend_Http_CookieJar) {

       $client->setCookieJar($_SESSION['cookiejar']);
   } else {
       // If we don't, authenticate and store cookies
       $client->setCookieJar();
       $client->setUri('http://www.example.com/login.php');
       $client->setParameterPost(array(
           'user' => 'shahar',
           'pass' => 'somesecret'
       ));
       $client->request(Zend_Http_Client::POST);

       // Now, clear parameters and set the URI to the original one
       // (note that the cookies that were set by the server are now
       // stored in the jar)
       $client->resetParameters();
       $client->setUri('http://www.example.com/fetchdata.php');
   }

   $response = $client->request(Zend_Http_Client::GET);

   // Store cookies in session, for next page
   $_SESSION['cookiejar'] = $client->getCookieJar();


.. _zend.http.client.streaming:

Data Streaming
--------------

By default, ``Zend_Http_Client`` accepts and returns data as *PHP* strings. However, in many cases there are big files to be sent or received, thus keeping them in memory might be unnecessary or too expensive. For these cases, ``Zend_Http_Client`` supports reading data from files (and in general, *PHP* streams) and writing data to files (streams).

In order to use stream to pass data to ``Zend_Http_Client``, use ``setRawData()`` method with data argument being stream resource (e.g., result of ``fopen()``).
.. _zend.http.client.streaming.example-1:

.. rubric:: Sending file to HTTP server with streaming

.. code-block:: php
   :linenos:

   $fp = fopen("mybigfile.zip", "r");
   $client->setRawData($fp, 'application/zip')->request('PUT');



Only PUT requests currently support sending streams to *HTTP* server.

In order to receive data from the server as stream, use ``setStream()``. Optional argument specifies the filename where the data will be stored. If the argument is just ``TRUE`` (default), temporary file will be used and will be deleted once response object is destroyed. Setting argument to ``FALSE`` disables the streaming functionality.

When using streaming, ``request()`` method will return object of class ``Zend_Http_Client_Response_Stream``, which has two useful methods: ``getStreamName()`` will return the name of the file where the response is stored, and ``getStream()`` will return stream from which the response could be read.

You can either write the response to pre-defined file, or use temporary file for storing it and send it out or write it to another file using regular stream functions.
.. _zend.http.client.streaming.example-2:

.. rubric:: Receiving file from HTTP server with streaming

.. code-block:: php
   :linenos:

   $client->setStream(); // will use temp file
   $response = $client->request('GET');
   // copy file
   copy($response->getStreamName(), "my/downloads/file");
   // use stream
   $fp = fopen("my/downloads/file2", "w");
   stream_copy_to_stream($response->getStream(), $fp);
   // Also can write to known file
   $client->setStream("my/downloads/myfile)->request('GET');




