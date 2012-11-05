.. EN-Revision: none
.. _zend.mail.different-transports:

Verschillende Transporten gebruiken
===================================

In het geval je verschillende e-mails via verschillende verbindingen wil sturen kan je ook het transport object
direct doorgeven aan *send()* zonder vooraf een oproep aan *setDefaultTransport()* te doen. Het zo doorgegeven
object zal het standaard transport vervangen voor het huidige *send()* verzoek:

.. rubric:: Verschillende Transporten gebruiken

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend\Mail\Mail();
   // bericht maken...
   require_once 'Zend/Mail/Transport/Smtp.php';
   $tr1 = new Zend\Mail_Transport\Smtp('server@example.com');
   $tr1 = new Zend\Mail_Transport\Smtp('other_server@example.com');
   $mail->send($tr1);
   $mail->send($tr2);
   $mail->send();  // standaard transport weer gebruiken
   ?>
.. note::

   Bijkomende transporten kunnen geschreven worden door de *Zend\Mail_Transport\Interface* te implementeren.


