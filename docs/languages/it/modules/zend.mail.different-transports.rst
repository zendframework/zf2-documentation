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
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   // crea il messaggio...
   require_once 'Zend/Mail/Transport/Smtp.php';
   $tr1 = new Zend_Mail_Transport_Smtp('server@example.com');
   $tr2 = new Zend_Mail_Transport_Smtp('altro_server@example.com');
   $mail->send($tr1);
   $mail->send($tr2);
   $mail->send();  // utilizza nuovamente il tipo predefinito

.. note::

   **Transport aggiuntivi**

   E' possibile scrivere transport aggiuntivi implementando l'interfaccia *Zend_Mail_Transport_Interface*.


