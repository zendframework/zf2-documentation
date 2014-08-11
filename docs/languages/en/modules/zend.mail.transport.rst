.. _zend.mail.transport:

Zend\\Mail\\Transport
=====================

.. _zend.mail.transport.intro:

Overview
--------

Transports take care of the actual delivery of mail. Typically, you only need to worry about two possibilities:
using PHP's native ``mail()`` functionality, which uses system resources to deliver mail, or using the *SMTP*
protocol for delivering mail via a remote server. Zend Framework also includes a "File" transport, which creates a
mail file for each message sent; these can later be introspected as logs or consumed for the purposes of sending
via an alternate transport mechanism later.

The ``Zend\Mail\Transport`` interface defines exactly one method, ``send()``. This method accepts a
``Zend\Mail\Message`` instance, which it then introspects and serializes in order to send.

.. _zend.mail.transport.quick-start:

Quick Start
-----------

Using a mail transport is typically as simple as instantiating it, optionally configuring it, and then passing a
message to it.

.. _zend.mail.transport.quick-start.sendmail-usage:

Sendmail Transport Usage
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   use Zend\Mail\Message;
   use Zend\Mail\Transport\Sendmail as SendmailTransport;

   $message = new Message();
   $message->addTo('matthew@zend.com')
           ->addFrom('ralph.schindler@zend.com')
           ->setSubject('Greetings and Salutations!')
           ->setBody("Sorry, I'm going to be late today!");

   $transport = new SendmailTransport();
   $transport->send($message);

.. _zend.mail.transport.quick-start.smtp-usage:

SMTP Transport Usage
^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   use Zend\Mail\Message;
   use Zend\Mail\Transport\Smtp as SmtpTransport;
   use Zend\Mail\Transport\SmtpOptions;

   $message = new Message();
   $message->addTo('matthew@zend.com')
           ->addFrom('ralph.schindler@zend.com')
           ->setSubject('Greetings and Salutations!')
           ->setBody("Sorry, I'm going to be late today!");

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
   $transport->send($message);

.. _zend.mail.transport.quick-start.file-usage:

File Transport Usage
^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   use Zend\Mail\Message;
   use Zend\Mail\Transport\File as FileTransport;
   use Zend\Mail\Transport\FileOptions;

   $message = new Message();
   $message->addTo('matthew@zend.com')
           ->addFrom('ralph.schindler@zend.com')
           ->setSubject('Greetings and Salutations!')
           ->setBody("Sorry, I'm going to be late today!");

   // Setup File transport
   $transport = new FileTransport();
   $options   = new FileOptions(array(
       'path'              => 'data/mail/',
       'callback'  => function (FileTransport $transport) {
           return 'Message_' . microtime(true) . '_' . mt_rand() . '.txt';
       },
   ));
   $transport->setOptions($options);
   $transport->send($message);

.. _zend.mail.transport.options:

Configuration Options
---------------------

Configuration options are per transport. Please follow the links below for transport-specific options.

- :ref:`SMTP Transport Options <zend.mail.smtp-options>`

- :ref:`File Transport Options <zend.mail.file-options>`

.. _zend.mail.transport.methods:

Available Methods
-----------------

.. _zend.mail.transport.methods.send:

**send**
   ``send(Zend\Mail\Message $message)``

   Send a mail message.

   Returns void

.. _zend.mail.transport.examples:

Examples
--------

Please see the :ref:`Quick Start section <zend.mail.transport.quick-start>` for examples.


