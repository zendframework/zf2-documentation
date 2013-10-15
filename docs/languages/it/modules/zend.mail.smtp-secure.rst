.. EN-Revision: none
.. _zend.mail.smtp-secure:

Messa in sicurezza del trasporto SMTP
=====================================

*Zend_Mail* supporta anche l'uso di TLS e SSL per incrementare la sicurezza di una connessione SMTP. Si possono
utilizzare specificando il parametro *'ssl'* nell'array di configurazione del costruttore di
*Zend\Mail_Transport\Smtp*, indicando il valore *'ssl'* o *'tls'*. Opzionalmente è possibile fornire una porta, in
alternativa verranno usati i valori predefiniti 25 per TSL e 465 per SSL.

.. _zend.mail.smtp-secure.example-1:

.. rubric:: Abilitazione di una connessione sicura in Zend\Mail_Transport\Smtp

.. code-block:: php
   :linenos:

   <?php
   $config = array('ssl' => 'tls',
                   'port' => 25); // valore opzionale della porta

   $transport = new Zend\Mail_Transport\Smtp('mail.server.com', $config);

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('Questo è il testo.');
   $mail->setFrom('qualcuno@example.com', 'Un mittente');
   $mail->addTo('qualcunaltro@example.com', 'Un destinatario');
   $mail->setSubject('Oggetto testuale');
   $mail->send($transport);


