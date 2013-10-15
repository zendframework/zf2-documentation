.. _zendservice.nirvanix:

ZendService\\Nirvanix
=====================

.. _zendservice.nirvanix.introduction:

Introduction
------------

Nirvanix provides an Internet Media File System (IMFS), an Internet storage service that allows applications to
upload, store and organize files and subsequently access them using a standard Web Services interface. An IMFS is
distributed clustered file system, accessed over the Internet, and optimized for dealing with media files (audio,
video, etc). The goal of an IMFS is to provide massive scalability to deal with the challenges of media storage
growth, with guaranteed access and availability regardless of time and location. Finally, an IMFS gives
applications the ability to access data securely, without the large fixed costs associated with acquiring and
maintaining physical storage assets.

.. _zendservice.nirvanix.registering:

Registering with Nirvanix
-------------------------

Before you can get started with ``ZendService\Nirvanix\Nirvanix``, you must first register for an account. Please see the
`Getting Started`_ page on the Nirvanix website for more information.

After registering, you will receive a Username, Password, and Application Key. All three are required to use
``ZendService\Nirvanix\Nirvanix``.

.. _zendservice.nirvanix.apiDocumentation:

API Documentation
-----------------

Access to the Nirvanix IMFS is available through both *SOAP* and a faster REST service. ``ZendService\Nirvanix\Nirvanix``
provides a relatively thin *PHP* 5 wrapper around the REST service.

``ZendService\Nirvanix\Nirvanix`` aims to make using the Nirvanix REST service easier but understanding the service itself
is still essential to be successful with Nirvanix.

The `Nirvanix API Documentation`_ provides an overview as well as detailed information using the service. Please
familiarize yourself with this document and refer back to it as you use ``ZendService\Nirvanix\Nirvanix``.

.. _zendservice.nirvanix.features:

Features
--------

Nirvanix's REST service can be used effectively with *PHP* using the `SimpleXML`_ extension and
``Zend\Http\Client`` alone. However, using it this way is somewhat inconvenient due to repetitive operations like
passing the session token on every request and repeatedly checking the response body for error codes.

``ZendService\Nirvanix\Nirvanix`` provides the following functionality:



   - A single point for configuring your Nirvanix authentication credentials that can be used across the Nirvanix
     namespaces.

   - A proxy object that is more convenient to use than an *HTTP* client alone, mostly removing the need to
     manually construct *HTTP* POST requests to access the REST service.

   - A response wrapper that parses each response body and throws an exception if an error occurred, alleviating
     the need to repeatedly check the success of many commands.

   - Additional convenience methods for some of the more common operations.



.. _zendservice.nirvanix.storing-your-first:

Getting Started
---------------

Once you have registered with Nirvanix, you're ready to store your first file on the IMFS. The most common
operations that you will need to do on the IMFS are creating a new file, downloading an existing file, and deleting
a file. ``ZendService\Nirvanix\Nirvanix`` provides convenience methods for these three operations.

.. code-block:: php
   :linenos:

   $auth = array('username' => 'your-username',
                 'password' => 'your-password',
                 'appKey'   => 'your-app-key');

   $nirvanix = new ZendService\Nirvanix\Nirvanix($auth);
   $imfs = $nirvanix->getService('IMFS');

   $imfs->putContents('/foo.txt', 'contents to store');

   echo $imfs->getContents('/foo.txt');

   $imfs->unlink('/foo.txt');

The first step to using ``ZendService\Nirvanix\Nirvanix`` is always to authenticate against the service. This is done by
passing your credentials to the ``ZendService\Nirvanix\Nirvanix`` constructor above. The associative array is passed
directly to Nirvanix as POST parameters.

Nirvanix divides its web services into `namespaces`_. Each namespace encapsulates a group of related operations.
After getting an instance of ``ZendService\Nirvanix\Nirvanix``, call the ``getService()`` method to create a proxy for the
namespace you want to use. Above, a proxy for the ``IMFS`` namespace is created.

After you have a proxy for the namespace you want to use, call methods on it. The proxy will allow you to use any
command available on the REST *API*. The proxy may also make convenience methods available, which wrap web service
commands. The example above shows using the IMFS convenience methods to create a new file, retrieve and display
that file, and finally delete the file.

.. _zendservice.nirvanix.understanding-proxy:

Understanding the Proxy
-----------------------

In the previous example, we used the ``getService()`` method to return a proxy object to the ``IMFS`` namespace.
The proxy object allows you to use the Nirvanix REST service in a way that's closer to making a normal *PHP* method
call, as opposed to constructing your own *HTTP* request objects.

A proxy object may provide convenience methods. These are methods that the ``ZendService\Nirvanix\Nirvanix`` provides to
simplify the use of the Nirvanix web services. In the previous example, the methods ``putContents()``,
``getContents()``, and ``unlink()`` do not have direct equivalents in the REST *API*. They are convenience methods
provided by ``ZendService\Nirvanix\Nirvanix`` that abstract more complicated operations on the REST *API*.

For all other method calls to the proxy object, the proxy will dynamically convert the method call to the
equivalent *HTTP* POST request to the REST *API*. It does this by using the method name as the *API* command, and
an associative array in the first argument as the POST parameters.

Let's say you want to call the REST *API* method `RenameFile`_, which does not have a convenience method in
``ZendService\Nirvanix\Nirvanix``:

.. code-block:: php
   :linenos:

   $auth = array('username' => 'your-username',
                 'password' => 'your-password',
                 'appKey'   => 'your-app-key');

   $nirvanix = new ZendService\Nirvanix\Nirvanix($auth);
   $imfs = $nirvanix->getService('IMFS');

   $result = $imfs->renameFile(array('filePath' => '/path/to/foo.txt',
                                     'newFileName' => 'bar.txt'));

Above, a proxy for the ``IMFS`` namespace is created. A method, ``renameFile()``, is then called on the proxy. This
method does not exist as a convenience method in the *PHP* code, so it is trapped by ``__call()`` and converted
into a POST request to the REST *API* where the associative array is used as the POST parameters.

Notice in the Nirvanix *API* documentation that *sessionToken* is required for this method but we did not give it
to the proxy object. It is added automatically for your convenience.

The result of this operation will either be a ``ZendService\Nirvanix\Response`` object wrapping the *XML* returned
by Nirvanix, or a ``ZendService\Nirvanix\Exception`` if an error occurred.

.. _zendservice.nirvanix.examining-results:

Examining Results
-----------------

The Nirvanix REST *API* always returns its results in *XML*. ``ZendService\Nirvanix\Nirvanix`` parses this *XML* with the
*SimpleXML* extension and then decorates the resulting *SimpleXMLElement* with a ``ZendService\Nirvanix\Response``
object.

The simplest way to examine a result from the service is to use the built-in *PHP* functions like ``print_r()``:

.. code-block:: php
   :linenos:

   <?php
   $auth = array('username' => 'your-username',
                 'password' => 'your-password',
                 'appKey'   => 'your-app-key');

   $nirvanix = new ZendService\Nirvanix\Nirvanix($auth);
   $imfs = $nirvanix->getService('IMFS');

   $result = $imfs->putContents('/foo.txt', 'fourteen bytes');
   print_r($result);
   ?>

   ZendService\Nirvanix\Response Object
   (
       [_sxml:protected] => SimpleXMLElement Object
           (
               [ResponseCode] => 0
               [FilesUploaded] => 1
               [BytesUploaded] => 14
           )
   )

You can access any property or method of the decorated *SimpleXMLElement*. In the above example,
*$result->BytesUploaded* could be used to see the number of bytes received. Should you want to access the
*SimpleXMLElement* directly, just use *$result->getSxml()*.

The most common response from Nirvanix is success (*ResponseCode* of zero). It is not normally necessary to check
*ResponseCode* because any non-zero result will throw a ``ZendService\Nirvanix\Exception``. See the next section
on handling errors.

.. _zendservice.nirvanix.handling-errors:

Handling Errors
---------------

When using Nirvanix, it's important to anticipate errors that can be returned by the service and handle them
appropriately.

All operations against the REST service result in an *XML* return payload that contains a *ResponseCode* element,
such as the following example:

.. code-block:: xml
   :linenos:

   <Response>
      <ResponseCode>0</ResponseCode>
   </Response>

When the *ResponseCode* is zero such as in the example above, the operation was successful. When the operation is
not successful, the *ResponseCode* is non-zero and an *ErrorMessage* element should be present.

To alleviate the need to repeatedly check if the *ResponseCode* is non-zero, ``ZendService\Nirvanix\Nirvanix``
automatically checks each response returned by Nirvanix. If the *ResponseCode* indicates an error, a
``ZendService\Nirvanix\Exception`` will be thrown.

.. code-block:: xml
   :linenos:

   $auth = array('username' => 'your-username',
                 'password' => 'your-password',
                 'appKey'   => 'your-app-key');
   $nirvanix = new ZendService\Nirvanix\Nirvanix($auth);

   try {

     $imfs = $nirvanix->getService('IMFS');
     $imfs->unlink('/a-nonexistent-path');

   } catch (ZendService\Nirvanix\Exception\DomainException $e) {
     echo $e->getMessage() . "\n";
     echo $e->getCode();
   }

In the example above, ``unlink()`` is a convenience method that wraps the *DeleteFiles* command on the REST *API*.
The *filePath* parameter required by the `DeleteFiles`_ command contains a path that does not exist. This will
result in a ``ZendService\Nirvanix\Nirvanix`` exception being thrown with the message "Invalid path" and code 70005.

The `Nirvanix API Documentation`_ describes the errors associated with each command. Depending on your needs, you
may wrap each command in a *try* block or wrap many commands in the same *try* block for convenience.



.. _`Getting Started`: http://www.nirvanix.com/gettingStarted.aspx
.. _`Nirvanix API Documentation`: http://developer.nirvanix.com/sitefiles/1000/API.html
.. _`SimpleXML`: http://www.php.net/simplexml
.. _`namespaces`: http://developer.nirvanix.com/sitefiles/1000/API.html#_Toc175999879
.. _`RenameFile`: http://developer.nirvanix.com/sitefiles/1000/API.html#_Toc175999923
.. _`DeleteFiles`: http://developer.nirvanix.com/sitefiles/1000/API.html#_Toc175999918
