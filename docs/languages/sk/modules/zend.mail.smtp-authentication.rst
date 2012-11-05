.. EN-Revision: none
.. _zend.mail.smtp-authentication:

SMTP Autentifikácia
===================

*Zend_Mail* podporuje použitie SMTP autentifikacie, ktorá môže byť povolená nastavením parametra 'auth' v
konfiguračnom poli konštruktora *Zend\Mail_Transport\Smtp*. Dostupné autentifikačné metódy su PLAIN, LOGIN a
CRAM-MD5 a všetky očakávajú zadané 'username' a 'password' v konfiguračnom poli.

.. rubric:: Nastavenie SMTP autentifikácie v Zend\Mail_Transport\Smtp

.. code-block:: php
   :linenos:

   <?php

   require_once 'Zend/Mail.php';
   require_once 'Zend/Mail/Transport/Smtp.php';

   $config = array('auth' => 'login',
                   'username' => 'myusername',
                   'password' => 'password');

   $transport = new Zend\Mail_Transport\Smtp('mail.server.com', $config);

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('sender@test.com', 'Some Sender');
   $mail->addTo('recipient@test.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send($transport);
.. note::

   **Druhy autentifikácie**

   Typy autentifikácie sú nezávislé na veľkosti písmen ale bez interpunkcie. Pre použitie napr. CRAM-MD5
   zadajte 'auth' => 'crammd5' v konštruktore *Zend\Mail_Transport\Smtp*.


