.. _zend.mail.introduction:

Introduction
============

.. _zend.mail.introduction.getting-started:

Getting started
---------------

``Zend_Mail`` provides generalized functionality to compose and send both text and *MIME*-compliant multipart
e-mail messages. Mail can be sent with ``Zend_Mail`` via the default ``Zend_Mail_Transport_Sendmail`` transport or
via ``Zend_Mail_Transport_Smtp``.

.. _zend.mail.introduction.example-1:

.. rubric:: Simple E-Mail with Zend_Mail

A simple e-mail consists of some recipients, a subject, a body and a sender. To send such a mail using
``Zend_Mail_Transport_Sendmail``, do the following:

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('somebody@example.com', 'Some Sender');
   $mail->addTo('somebody_else@example.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send();

.. note:: Minimum definitions

   In order to send an e-mail with ``Zend_Mail`` you have to specify at least one recipient, a sender (e.g., with
   ``setFrom()``), and a message body (text and/or *HTML*).

For most mail attributes there are "get" methods to read the information stored in the mail object. for further
details, please refer to the *API* documentation. A special one is ``getRecipients()``. It returns an array with
all recipient e-mail addresses that were added prior to the method call.

For security reasons, ``Zend_Mail`` filters all header fields to prevent header injection with newline (**\n**)
characters. Double quotation is changed to single quotation and angle brackets to square brackets in the name of
sender and recipients. If the marks are in email address, the marks will be removed.

You also can use most methods of the ``Zend_Mail`` object with a convenient fluent interface.

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setBodyText('This is the text of the mail.')
       ->setFrom('somebody@example.com', 'Some Sender')
       ->addTo('somebody_else@example.com', 'Some Recipient')
       ->setSubject('TestSubject')
       ->send();

.. _zend.mail.introduction.sendmail:

Configuring the default sendmail transport
------------------------------------------

The default transport for a ``Zend_Mail`` instance is ``Zend_Mail_Transport_Sendmail``. It is essentially a wrapper
to the *PHP* `mail()`_ function. If you wish to pass additional parameters to the `mail()`_ function, simply create
a new transport instance and pass your parameters to the constructor. The new transport instance can then act as
the default ``Zend_Mail`` transport, or it can be passed to the ``send()`` method of ``Zend_Mail``.

.. _zend.mail.introduction.sendmail.example-1:

.. rubric:: Passing additional parameters to the Zend_Mail_Transport_Sendmail transport

This example shows how to change the Return-Path of the `mail()`_ function.

.. code-block:: php
   :linenos:

   $tr = new Zend_Mail_Transport_Sendmail('-freturn_to_me@example.com');
   Zend_Mail::setDefaultTransport($tr);

   $mail = new Zend_Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('somebody@example.com', 'Some Sender');
   $mail->addTo('somebody_else@example.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send();

.. note:: Safe mode restrictions

   The optional additional parameters will be cause the `mail()`_ function to fail if *PHP* is running in safe
   mode.

.. warning:: Sendmail Transport and Windows

   As the *PHP* manual states the ``mail()`` function has different behaviour on Windows and on \*nix based
   systems. Using the Sendmail Transport on Windows will not work in combination with ``addBcc()``. The ``mail()``
   function will sent to the BCC recipient such that all the other recipients can see him as recipient!

   Therefore if you want to use BCC on a windows server, use the SMTP transport for sending!



.. _`mail()`: http://php.net/mail
