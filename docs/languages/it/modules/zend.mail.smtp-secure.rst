.. _zend.mail.smtp-secure:

Messa in sicurezza del trasporto SMTP
=====================================

*Zend_Mail* supporta anche l'uso di TLS e SSL per incrementare la sicurezza di una connessione SMTP. Si possono
utilizzare specificando il parametro *'ssl'* nell'array di configurazione del costruttore di
*Zend_Mail_Transport_Smtp*, indicando il valore *'ssl'* o *'tls'*. Opzionalmente è possibile fornire una porta, in
alternativa verranno usati i valori predefiniti 25 per TSL e 465 per SSL.

.. _zend.mail.smtp-secure.example-1:

.. rubric:: Abilitazione di una connessione sicura in Zend_Mail_Transport_Smtp

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Mail.php';
   require_once 'Zend/Mail/Transport/Smtp.php';

   $config = array('ssl' => 'tls',
                   'port' => 25); // valore opzionale della porta

   $transport = new Zend_Mail_Transport_Smtp('mail.server.com', $config);

   $mail = new Zend_Mail();
   $mail->setBodyText('Questo è il testo.');
   $mail->setFrom('qualcuno@example.com', 'Un mittente');
   $mail->addTo('qualcunaltro@example.com', 'Un destinatario');
   $mail->setSubject('Oggetto testuale');
   $mail->send($transport);


