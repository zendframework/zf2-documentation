.. EN-Revision: none
.. _zend.mail.multiple-emails:

Meerdere e-mails sturen via een SMTP verbinding
===============================================

Standaard wordt een SMTP verbinding gemaakt voor elke e-mail die wordt gestuurd. Indien je meerdere e-mails via
eenzelfde SMTP verbinding wil sturen moet je zelf *connect()* afhandelen. Als de transportwijze reeds vastgesteld
is voor *send()* word opgeroepen zal dat transport worden gebruikt en de verbinding zal niet afgesloten worden:

.. rubric:: Meerdere e-mails sturen via een SMTP verbinding

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   // bericht maken...
   require_once 'Zend/Mail/Transport/Smtp.php';
   $tr = new Zend_Mail_Transport_Smtp('mail.example.com');
   $tr->connect();
   for ($i = 0; $i < 5; $i++) {
       $mail->send();
   }
   $tr->disconnect();
   ?>

