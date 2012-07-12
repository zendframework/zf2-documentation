
Sending via SMTP
================

To send mail via SMTP, ``Zend_Mail_Transport_Smtp`` needs to be created and registered with ``Zend_Mail`` before the ``send()`` method is called. For all remaining ``Zend_Mail::send()`` calls in the current script, the SMTP transport will then be used:

The ``setDefaultTransport()`` method and the constructor of ``Zend_Mail_Transport_Smtp`` are not expensive. These two lines can be processed at script setup time (e.g., config.inc or similar) to configure the behavior of the ``Zend_Mail`` class for the rest of the script. This keeps configuration information out of the application logic - whether mail is sent via SMTP or `mail()`_ , what mail server is used, etc.


.. _`mail()`: http://php.net/mail
