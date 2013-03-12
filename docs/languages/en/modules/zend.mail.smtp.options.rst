.. _zend.mail.smtp-options:

Zend\\Mail\\Transport\\SmtpOptions
==================================

.. _zend.mail.smtp-options.intro:

Overview
--------

This document details the various options available to the ``Zend\Mail\Transport\Smtp`` mail transport.

.. _zend.mail.smtp-options.quick-start:

Quick Start
-----------

.. _zend.mail.smtp-options.quick-start.basic-smtp-usage:

.. rubric:: Basic SMTP Transport Usage

.. code-block:: php
   :linenos:

   use Zend\Mail\Transport\Smtp as SmtpTransport;
   use Zend\Mail\Transport\SmtpOptions;

   // Setup SMTP transport
   $transport = new SmtpTransport();
   $options   = new SmtpOptions(array(
       'name' => 'localhost.localdomain',
       'host' => '127.0.0.1',
       'port' => 25,
   ));
   $transport->setOptions($options);

.. _zend.mail.smtp-options.quick-start.plain-smtp-usage:

.. rubric:: SMTP Transport Usage with PLAIN AUTH

.. code-block:: php
   :linenos:

   use Zend\Mail\Transport\Smtp as SmtpTransport;
   use Zend\Mail\Transport\SmtpOptions;

   // Setup SMTP transport using PLAIN authentication
   $transport = new SmtpTransport();
   $options   = new SmtpOptions(array(
       'name'              => 'localhost.localdomain',
       'host'              => '127.0.0.1',
       'connection_class'  => 'plain',
       'connection_config' => array(
           'username' => 'user',
           'password' => 'pass',
       ),
   ));
   $transport->setOptions($options);

.. _zend.mail.smtp-options.quick-start.login-smtp-usage:

.. rubric:: SMTP Transport Usage with LOGIN AUTH

.. code-block:: php
   :linenos:

   use Zend\Mail\Transport\Smtp as SmtpTransport;
   use Zend\Mail\Transport\SmtpOptions;

   // Setup SMTP transport using LOGIN authentication
   $transport = new SmtpTransport();
   $options   = new SmtpOptions(array(
       'name'              => 'localhost.localdomain',
       'host'              => '127.0.0.1',
       'connection_class'  => 'login',
       'connection_config' => array(
           'username' => 'user',
           'password' => 'pass',
       ),
   ));
   $transport->setOptions($options);

.. _zend.mail.smtp-options.quick-start.crammd5-smtp-usage:

.. rubric:: SMTP Transport Usage with CRAM-MD5 AUTH

.. code-block:: php
   :linenos:

   use Zend\Mail\Transport\Smtp as SmtpTransport;
   use Zend\Mail\Transport\SmtpOptions;

   // Setup SMTP transport using CRAM-MD5 authentication
   $transport = new SmtpTransport();
   $options   = new SmtpOptions(array(
       'name'              => 'localhost.localdomain',
       'host'              => '127.0.0.1',
       'connection_class'  => 'crammd5',
       'connection_config' => array(
           'username' => 'user',
           'password' => 'pass',
       ),
   ));
   $transport->setOptions($options);

.. _zend.mail.smtp-options.quick-start.plain-smtp-with-ssl-usage:

.. rubric:: SMTP Transport Usage with PLAIN AUTH over TLS

.. code-block:: php
   :linenos:

   use Zend\Mail\Transport\Smtp as SmtpTransport;
   use Zend\Mail\Transport\SmtpOptions;

   // Setup SMTP transport using PLAIN authentication over TLS
   $transport = new SmtpTransport();
   $options   = new SmtpOptions(array(
       'name'              => 'example.com',
       'host'              => '127.0.0.1',
       'port'              => 587, // Notice port change for TLS is 587
       'connection_class'  => 'plain',
       'connection_config' => array(
           'username' => 'user',
           'password' => 'pass',
           'ssl'      => 'tls',
       ),
   ));
   $transport->setOptions($options);


.. _zend.mail.smtp-options.options:

Configuration Options
---------------------

.. rubric:: Configuration Options

.. _zend.mail.smtp-options.options.name:

**name**
   Name of the SMTP host; defaults to "localhost".

.. _zend.mail.smtp-options.options.host:

**host**
   Remote hostname or IP address; defaults to "127.0.0.1".

.. _zend.mail.smtp-options.options.port:

**port**
   Port on which the remote host is listening; defaults to "25".

.. _zend.mail.smtp-options.options.connection-class:

**connection_class**
   Fully-qualified classname or short name resolvable via ``Zend\Mail\Protocol\SmtpLoader``. Typically, this will
   be one of "smtp", "plain", "login", or "crammd5", and defaults to "smtp".

   Typically, the connection class should extend the ``Zend\Mail\Protocol\AbstractProtocol`` class, and
   specifically the SMTP variant.

.. _zend.mail.smtp-options.options.connection-config:

**connection_config**
   Optional associative array of parameters to pass to the :ref:`connection class
   <zend.mail.smtp-options.options.connection-class>` in order to configure it. By default this is empty. For
   connection classes other than the default, you will typically need to define the "username" and "password"
   options. For secure connections you will use the "ssl" => "tls" and port 587 for TLS or "ssl" => "ssl"
   and port 465 for SSL.

.. _zend.mail.smtp-options.methods:

Available Methods
-----------------

.. _zend.mail.smtp-options.methods.get-name:

**getName**
   ``getName()``

   Returns the string name of the local client hostname.

.. _zend.mail.smtp-options.methods.set-name:

**setName**
   ``setName(string $name)``

   Set the string name of the local client hostname.

   Implements a fluent interface.

.. _zend.mail.smtp-options.methods.get-connection-class:

**getConnectionClass**
   ``getConnectionClass()``

   Returns a string indicating the connection class name to use.

.. _zend.mail.smtp-options.methods.set-connection-class:

**setConnectionClass**
   ``setConnectionClass(string $connectionClass)``

   Set the connection class to use.

   Implements a fluent interface.

.. _zend.mail.smtp-options.methods.get-connection-config:

**getConnectionConfig**
   ``getConnectionConfig()``

   Get configuration for the connection class.

   Returns array.

.. _zend.mail.smtp-options.methods.set-connection-config:

**setConnectionConfig**
   ``setConnectionConfig(array $config)``

   Set configuration for the connection class. Typically, if using anything other than the default connection
   class, this will be an associative array with the keys "username" and "password".

   Implements a fluent interface.

.. _zend.mail.smtp-options.methods.get-host:

**getHost**
   ``getHost()``

   Returns a string indicating the IP address or host name of the SMTP server via which to send messages.

.. _zend.mail.smtp-options.methods.set-host:

**setHost**
   ``setHost(string $host)``

   Set the SMTP host name or IP address.

   Implements a fluent interface.

.. _zend.mail.smtp-options.methods.get-port:

**getPort**
   ``getPort()``

   Retrieve the integer port on which the SMTP host is listening.

.. _zend.mail.smtp-options.methods.set-port:

**setPort**
   ``setPort(int $port)``

   Set the port on which the SMTP host is listening.

   Implements a fluent interface.

.. _zend.stdlib.options.methods.__construct:

**__construct**
   ``__construct(null|array|Traversable $config)``

   Instantiate the class, and optionally configure it with values provided.

.. _zend.mail.smtp-options.examples:

Examples
--------

Please see the :ref:`Quick Start <zend.mail.smtp-options.quick-start>` for examples.


