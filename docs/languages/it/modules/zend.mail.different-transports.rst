.. EN-Revision: none
.. _zend.mail.different-transports:

Utilizzo di differenti transport
================================

In caso si desideri inviare differenti e-mail utilizzando differenti connessioni, è possibile specificare
l'oggetto transport direttamente al metodo *send()* senza una chiamata precedente a *setDefaultTransport()*.
L'oggetto fornito sovrascriverà il transport predefinito per la richiesta *send()* corrente:

.. _zend.mail.different-transports.example-1:

.. rubric:: Utilizzo di differenti transport

.. code-block:: php
   :linenos:

   <?php
   $mail = new Zend\Mail\Mail();
   // crea il messaggio...
   $tr1 = new Zend\Mail\Transport\Smtp('server@example.com');
   $tr2 = new Zend\Mail\Transport\Smtp('altro_server@example.com');
   $mail->send($tr1);
   $mail->send($tr2);
   $mail->send();  // utilizza nuovamente il tipo predefinito

.. note::

   **Transport aggiuntivi**

   E' possibile scrivere transport aggiuntivi implementando l'interfaccia *Zend\Mail\Transport\Interface*.


