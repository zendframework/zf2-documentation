.. _zend.mail.different-transports:

Verschillende Transporten gebruiken
===================================

In het geval je verschillende e-mails via verschillende verbindingen wil sturen kan je ook het transport object
direct doorgeven aan *send()* zonder vooraf een oproep aan *setDefaultTransport()* te doen. Het zo doorgegeven
object zal het standaard transport vervangen voor het huidige *send()* verzoek:

.. rubric:: Verschillende Transporten gebruiken

.. code-block::
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   // bericht maken...
   require_once 'Zend/Mail/Transport/Smtp.php';
   $tr1 = new Zend_Mail_Transport_Smtp('server@example.com');
   $tr1 = new Zend_Mail_Transport_Smtp('other_server@example.com');
   $mail->send($tr1);
   $mail->send($tr2);
   $mail->send();  // standaard transport weer gebruiken
   ?>
.. note::

   Bijkomende transporten kunnen geschreven worden door de *Zend_Mail_Transport_Interface* te implementeren.


