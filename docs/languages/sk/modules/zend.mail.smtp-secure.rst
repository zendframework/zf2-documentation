.. _zend.mail.smtp-secure:

Zabezpečenie SMTP prenosu
=========================

*Zend_Mail* takisto podporuje použitie TLS alebo SSL na zabezpečnie SMTP spojenia. Pre zabezpečenie spojenia je
potrebné nastaviť 'ssl' parameter v konfiguračnom poli ktoré je predávané v konštruktore
*Zend_Mail_Transport_Smtp* s hodnotou 'ssl' alebo 'tls'. Takisto je možné nastaviť iný port ako 25 pre TLS,
alebo 465 pre SSL.

.. rubric:: Vytvorene zabezpečného spojenia pomocou Zend_Mail_Transport_Smtp

.. code-block:: php
   :linenos:

   <?php

   require_once 'Zend/Mail.php';
   require_once 'Zend/Mail/Transport/Smtp.php';

   $config = array('ssl' => 'tls',
                   'port' => 25); // Optional port number supplied

   $transport = new Zend_Mail_Transport_Smtp('mail.server.com', $config);

   $mail = new Zend_Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('sender@test.com', 'Some Sender');
   $mail->addTo('recipient@test.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send($transport);

