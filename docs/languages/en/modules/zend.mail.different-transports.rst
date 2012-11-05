.. _zend.mail.different-transports:

Using Different Transports
==========================

In case you want to send different e-mails through different connections, you can also pass the transport object
directly to ``send()`` without a prior call to ``setDefaultTransport()``. The passed object will override the
default transport for the actual ``send()`` request.

.. _zend.mail.different-transports.example-1:

.. rubric:: Using Different Transports

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Message();
   // build message...
   $tr1 = new Zend\Mail\Transport\Smtp('server@example.com');
   $tr2 = new Zend\Mail\Transport\Smtp('other_server@example.com');
   $mail->send($tr1);
   $mail->send($tr2);
   $mail->send();  // use default again

.. note::

   **Additional transports**

   Additional transports can be written by implementing ``Zend\Mail\Transport\Interface``.


