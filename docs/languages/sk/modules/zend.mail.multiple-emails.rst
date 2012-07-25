.. _zend.mail.multiple-emails:

Posielanie viacerých e-mailov cez jedno SMTP spojenie
=====================================================

Pre každý posielaný e-mail je vždy vytvorené nové SMTP spojenie. Pre posielanie viacerých e-mailov cez jedno
SMTP spojenie je potrebné zmeniť správanie pri vytváraní spojenia (*connect()*). Ak už bude vytvorené SMTP
spojenie pred zavolaním metódy *send()*, toto spojenie bude použité a nebude po odoslaní e-mailu uzatvorené:

.. rubric:: Posielanie viacerých e-mailov cez jedno SMTP spojenie

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   // build message...
   require_once 'Zend/Mail/Transport/Smtp.php';
   $tr = new Zend_Mail_Transport_Smtp('mail.example.com');
   Zend_Mail::setDefaultTransport($tr);
   $tr->connect();
   for ($i = 0; $i < 5; $i++) {
   $mail->send();
   }
   $tr->disconnect();
   ?>

