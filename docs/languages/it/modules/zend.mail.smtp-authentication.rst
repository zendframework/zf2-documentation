.. EN-Revision: none
.. _zend.mail.smtp-authentication:

Autenticazione SMTP
===================

*Zend_Mail* supporta l'uso dell'autenticazione SMTP, che si può abilitare passando il parametro 'auth' all'array
di configurazione nel costruttore di *Zend\Mail_Transport\Smtp*. I metodi di autenticazione integrati disponibili
sono PLAIN, LOGIN e CRAM-MD5, che necessitano dei valori di 'username' e 'password' nell'array di configurazione.

.. _zend.mail.smtp-authentication.example-1:

.. rubric:: Abilitazione dell'autenticazione in Zend\Mail_Transport\Smtp

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
   $mail->setBodyText('Questo è il testo.');
   $mail->setFrom('qualcuno@example.com', 'Un mittente');
   $mail->addTo('qualcunaltro@example.com', 'Un destinatario');
   $mail->setSubject('Oggetto testuale');
   $mail->send($transport);

.. note::

   **Tipi di autenticazione**

   Il tipo di autenticazione distingue maiuscole e minuscole ma non contiene punteggiatura. Es. per usare CRAM-MD5
   passare *'auth' => 'crammd5'* nel costruttore di *Zend\Mail_Transport\Smtp*.


