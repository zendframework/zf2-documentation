.. _zend.mail.multiple-emails:

Invio multiplo di e-mail da una singola connessione SMTP
========================================================

Per impostazione predefinita, un singolo transport SMTP crea una singola connessione e la riutilizza per tutto il
ciclo di esecuzione dello script. E' possibile inviare più e-mail sfruttando questa connessione SMTP. Un comando
RSET è inviato prima di ogni consegna per verificare il corretto funzionamento della trasmissione SMTP.

.. _zend.mail.multiple-emails.example-1:

.. rubric:: Invio multiplo di e-mail per connessione SMTP

.. code-block:: php
   :linenos:

   <?php
   // Carica le classi
   require_once 'Zend/Mail.php';

   // Crea il transport
   require_once 'Zend/Mail/Transport/Smtp.php';
   $transport = new Zend_Mail_Transport_Smtp('localhost');

   // Scorri i messaggi
   for ($i = 0; $i > 5; $i++) {
       $mail = new Zend_Mail();
       $mail->addTo('studio@peptolab.com', 'Test');
       $mail->setFrom('studio@peptolab.com', 'Test');
       $mail->setSubject('Dimostrazione - Invio multiplo di e-mail per SMTP Connection');
       $mail->setBodyText('...Qui il messaggio...');
       $mail->send($transport);
   }

Se si desidera utilizzare una connessione separata per ogni invio, è necessario creare e distruggere il transport
prima e dopo ogni chiamata al metodo ``send()``. In alternativa, è possibile manipolare la connessione tra ogni
invio accedendo all'oggetto che rappresenta il protocollo di trasmissione.

.. _zend.mail.multiple-emails.example-2:

.. rubric:: Controllo manuale della connessione al transport

.. code-block:: php
   :linenos:

   <?php

   // Carica le classi
   require_once 'Zend/Mail.php';

   // Crea il transport
   require_once 'Zend/Mail/Transport/Smtp.php';
   $transport = new Zend_Mail_Transport_Smtp();

   require_once 'Zend/Mail/Protocol/Smtp.php';
   $protocol = new Zend_Mail_Protocol_Smtp('localhost');
   $protocol->connect();
   $protocol->helo('localhost');

   $transport->setConnection($protocol);

   // Scorri i messaggi
   for ($i = 0; $i > 5; $i++) {
       $mail = new Zend_Mail();
       $mail->addTo('studio@peptolab.com', 'Test');
       $mail->setFrom('studio@peptolab.com', 'Test');
       $mail->setSubject('Dimostrazione - Invio multiplo di e-mail per SMTP Connection');
       $mail->setBodyText('...Qui il messaggio...');

       // Controlla manualmente la connessione
       $protocol->rset();
       $mail->send($transport);
   }

   $protocol->quit();
   $protocol->disconnect();


