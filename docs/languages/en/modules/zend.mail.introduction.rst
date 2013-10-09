.. _zend.mail.introduction:

Introduction to Zend\\Mail
==========================

.. _zend.mail.introduction.getting-started:

Getting started
---------------

``Zend\Mail`` provides generalized functionality to compose and send both text and *MIME*-compliant multipart
email messages. Mail can be sent with ``Zend\Mail`` via the ``Mail\Transport\Sendmail``,
``Mail\Transport\Smtp`` or the ``Mail\Transport\File`` transport. Of course, you can also implement
your own transport by implementing the ``Mail\Transport\TransportInterface``.

.. _zend.mail.introduction.example-1:

.. rubric:: Simple email with Zend\Mail

A simple email consists of one or more recipients, a subject, a body and a sender. To send such a mail using
``Zend\Mail\Transport\Sendmail``, do the following:

.. code-block:: php
   :linenos:

   use Zend\Mail;

   $mail = new Mail\Message();
   $mail->setBody('This is the text of the email.');
   $mail->setFrom('Freeaqingme@example.org', 'Sender\'s name');
   $mail->addTo('Matthew@example.com', 'Name of recipient');
   $mail->setSubject('TestSubject');

   $transport = new Mail\Transport\Sendmail();
   $transport->send($mail);

.. note::

   **Minimum definitions**

   In order to send an email using ``Zend\Mail`` you have to specify at least one recipient as well as a message body.
   Please note that each Transport may require additional parameters to be set.

For most mail attributes there are "get" methods to read the information stored in the message object. for further
details, please refer to the *API* documentation.

You also can use most methods of the ``Mail\Message`` object with a convenient fluent interface.

.. code-block:: php
   :linenos:

   use Zend\Mail;

   $mail = new Mail\Message();
   $mail->setBody('This is the text of the mail.')
        ->setFrom('somebody@example.com', 'Some Sender')
        ->addTo('somebody_else@example.com', 'Some Recipient')
        ->setSubject('TestSubject');

.. _zend.mail.introduction.sendmail:

Configuring the default sendmail transport
------------------------------------------

The most simple to use transport is the ``Mail\Transport\Sendmail`` transport class. It is essentially a wrapper
to the *PHP* `mail()`_ function. If you wish to pass additional parameters to the `mail()`_ function, simply create
a new transport instance and pass your parameters to the constructor.

.. _zend.mail.introduction.sendmail.example-1:

.. rubric:: Passing additional parameters to the ``Zend\Mail\Transport\Sendmail`` transport.

This example shows how to change the Return-Path of the `mail()`_ function.

.. code-block:: php
   :linenos:

   use Zend\Mail;

   $mail = new Mail\Message();
   $mail->setBody('This is the text of the email.');
   $mail->setFrom('Freeaqingme@example.org', 'Dolf');
   $mail->addTo('matthew@example.com', 'Matthew');
   $mail->setSubject('TestSubject');

   $transport = new Mail\Transport\Sendmail('-freturn_to_me@example.com');
   $transport->send($mail);

.. note::

   **Safe mode restrictions**

   Supplying additional parameters to the transport will cause the `mail()`_
   function to fail if *PHP* is running in safe mode.

.. note::

   **Choosing your transport wisely**

   Although the sendmail transport is the transport that requires only minimal
   configuration, it may not be suitable for your production environment. This
   is because emails sent using the sendmail transport will be more often delivered
   to SPAM-boxes. This can partly be remedied by using the
   :ref:`SMTP Transport <zend.mail.transport.quick-start.smtp-usage>` combined
   with an SMTP server that has an overall good reputation. Additionally, techniques
   such as SPF and DKIM may be employed to ensure even more email messages are
   delivered as should.

.. warning::

   **Sendmail Transport and Windows**

   As the *PHP* manual states the ``mail()`` function has different behaviour on Windows and on \*nix based
   systems. Using the Sendmail Transport on Windows will not work in combination with ``addBcc()``. The ``mail()``
   function will sent to the BCC recipient such that all the other recipients can see him as recipient!

   Therefore if you want to use BCC on a windows server, use the SMTP transport for sending!


.. _`mail()`: http://php.net/mail
