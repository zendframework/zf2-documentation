.. _zend.mail.sending:

Sending via SMTP
================

To send mail via SMTP, ``Zend\Mail\Transport\Smtp`` needs to be created and registered with ``Zend\Mail`` before
the ``send()`` method is called. For all remaining ``Zend\Mail\Message::send()`` calls in the current script, the SMTP
transport will then be used:

.. _zend.mail.sending.example-1:

.. rubric:: Sending E-Mail via SMTP

.. code-block:: php
   :linenos:

   $tr = new Zend\Mail\Transport\Smtp('mail.example.com');
   Zend\Mail\Message::setDefaultTransport($tr);

The ``setDefaultTransport()`` method and the constructor of ``Zend\Mail\Transport\Smtp`` are not expensive. These
two lines can be processed at script setup time (e.g., config.inc or similar) to configure the behavior of the
``Zend\Mail\Message`` class for the rest of the script. This keeps configuration information out of the application logic -
whether mail is sent via SMTP or `mail()`_, what mail server is used, etc.



.. _`mail()`: http://php.net/mail
