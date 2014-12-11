.. _zend.mail.file-options:

Zend\\Mail\\Transport\\FileOptions
==================================

.. _zend.mail.file-options.intro:

Overview
--------

This document details the various options available to the ``Zend\Mail\Transport\File`` mail transport.

.. _zend.mail.file-options.quick-start:

Quick Start
-----------

.. code-block:: php
   :linenos:

   use Zend\Mail\Transport\File as FileTransport;
   use Zend\Mail\Transport\FileOptions;

   // Setup File transport
   $transport = new FileTransport();
   $options   = new FileOptions(array(
       'path'              => 'data/mail/',
       'callback'  => function (FileTransport $transport) {
           return 'Message_' . microtime(true) . '_' . mt_rand() . '.txt';
       },
   ));
   $transport->setOptions($options);

.. _zend.mail.file-options.options:

Configuration Options
---------------------

.. _zend.mail.file-options.options.path:

**path**
   The path under which mail files will be written.

.. _zend.mail.file-options.options.callback:

**callback**
   A PHP callable to be invoked in order to generate a unique name for a message file. By default, the following is
   used:

   .. code-block:: php
      :linenos:

      function (Zend\Mail\FileTransport $transport) {
          return 'ZendMail_' . time() . '_' . mt_rand() . '.tmp';
      }

.. _zend.mail.file-options.methods:

Available Methods
-----------------

``Zend\Mail\Transport\FileOptions`` extends ``Zend\Stdlib\AbstractOptions``, and inherits all functionality from that
class; this includes property overloading. Additionally, the following explicit setters and
getters are provided.

.. _zend.mail.file-options.methods.set-path:

**setPath**
   ``setPath(string $path)``

   Set the path under which mail files will be written.

   Implements fluent interface.

.. _zend.mail.file-options.methods.get-path:

**getPath**
   ``getPath()``

   Get the path under which mail files will be written.

   Returns string

.. _zend.mail.file-options.methods.set-callback:

**setCallback**
   ``setCallback(Callable $callback)``

   Set the callback used to generate unique filenames for messages.

   Implements fluent interface.

.. _zend.mail.file-options.methods.get-callback:

**getCallback**
   ``getCallback()``

   Get the callback used to generate unique filenames for messages.

   Returns PHP callable argument.

.. _zend.mail.file-options.methods.__construct:

**__construct**
   ``__construct(null|array|Traversable $config)``

   Initialize the object. Allows passing a PHP array or ``Traversable`` object with which to populate the instance.

.. _zend.mail.file-options.examples:

Examples
--------

Please see the :ref:`Quick Start <zend.mail.file-options.quick-start>` for examples.


