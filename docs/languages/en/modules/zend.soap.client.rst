.. _zend.soap.client:

Zend\\Soap\\Client
==================

The ``Zend\Soap\Client`` class simplifies *SOAP* client development for *PHP* programmers.

It may be used in WSDL or non-WSDL mode.

Under the WSDL mode, the ``Zend\Soap\Client`` component uses a WSDL document to define transport layer options.

The WSDL description is usually provided by the web service the client will access. If the WSDL description is not
made available, you may want to use ``Zend\Soap\Client`` in non-WSDL mode. Under this mode, all *SOAP* protocol
options have to be set explicitly on the ``Zend\Soap\Client`` class.

.. _zend.soap.client.constructor:

Zend\\Soap\\Client Constructor
------------------------------

The ``Zend\Soap\Client`` constructor takes two parameters:

- ``$wsdl``- the *URI* of a WSDL file.

- ``$options``- options to create *SOAP* client object.

Both of these parameters may be set later using ``setWsdl($wsdl)`` and ``setOptions($options)`` methods
respectively.

.. note::

   **Important!**

   If you use ``Zend\Soap\Client`` component in non-WSDL mode, you **must** set the 'location' and 'uri' options.

The following options are recognized:

- 'soap_version' ('soapVersion') - soap version to use (SOAP_1_1 or *SOAP*\ _1_2).

- 'classmap' ('classMap') - can be used to map some WSDL types to *PHP* classes. The option must be an array with
  WSDL types as keys and names of *PHP* classes as values.

- 'encoding' - internal character encoding (UTF-8 is always used as an external encoding).

- 'wsdl' which is equivalent to ``setWsdl($wsdlValue)`` call. Changing this option may switch ``Zend\Soap\Client``
  object to or from WSDL mode.

- 'uri' - target namespace for the *SOAP* service (required for non-WSDL-mode, doesn't work for WSDL mode).

- 'location' - the *URL* to request (required for non-WSDL-mode, doesn't work for WSDL mode).

- 'style' - request style (doesn't work for WSDL mode): ``SOAP_RPC`` or ``SOAP_DOCUMENT``.

- 'use' - method to encode messages (doesn't work for WSDL mode): ``SOAP_ENCODED`` or ``SOAP_LITERAL``.

- 'login' and 'password' - login and password for an *HTTP* authentication.

- 'proxy_host', 'proxy_port', 'proxy_login', and 'proxy_password' - an *HTTP* connection through a proxy server.

- 'local_cert' and 'passphrase' -*HTTPS* client certificate authentication options.

- 'compression' - compression options; it's a combination of ``SOAP_COMPRESSION_ACCEPT``, ``SOAP_COMPRESSION_GZIP``
  and ``SOAP_COMPRESSION_DEFLATE`` options which may be used like this:

.. code-block:: php
    :linenos:

    // Accept response compression
    $client = new Zend\Soap\Client("some.wsdl",
      array('compression' => SOAP_COMPRESSION_ACCEPT));
    ...

    // Compress requests using gzip with compression level 5
    $client = new Zend\Soap\Client("some.wsdl",
      array('compression' => SOAP_COMPRESSION_ACCEPT | SOAP_COMPRESSION_GZIP | 5));
    ...

    // Compress requests using deflate compression
    $client = new Zend\Soap\Client("some.wsdl",
      array('compression' => SOAP_COMPRESSION_ACCEPT | SOAP_COMPRESSION_DEFLATE));


.. _zend.soap.client.calls:

Performing SOAP Requests
------------------------

After we've created a ``Zend\Soap\Client`` object we are ready to perform *SOAP* requests.

Each web service method is mapped to the virtual ``Zend\Soap\Client`` object method which takes parameters with
common *PHP* types.

Use it like in the following example:

.. code-block:: php
   :linenos:

   //****************************************************************
   //                Server code
   //****************************************************************
   // class MyClass {
   //     /**
   //      * This method takes ...
   //      *
   //      * @param integer $inputParam
   //      * @return string
   //      */
   //     public function method1($inputParam) {
   //         ...
   //     }
   //
   //     /**
   //      * This method takes ...
   //      *
   //      * @param integer $inputParam1
   //      * @param string  $inputParam2
   //      * @return float
   //      */
   //     public function method2($inputParam1, $inputParam2) {
   //         ...
   //     }
   //
   //     ...
   // }
   // ...
   // $server = new Zend\Soap\Server(null, $options);
   // $server->setClass('MyClass');
   // ...
   // $server->handle();
   //
   //****************************************************************
   //                End of server code
   //****************************************************************

   $client = new Zend\Soap\Client("MyService.wsdl");
   ...

   // $result1 is a string
   $result1 = $client->method1(10);
   ...

   // $result2 is a float
   $result2 = $client->method2(22, 'some string');


