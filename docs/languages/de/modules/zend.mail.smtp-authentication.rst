.. _zend.mail.smtp-authentication:

SMTP Authentifizierung
======================

``Zend_Mail`` unterstützt die Verwendung von SMTP Authentifizierung, welche eingeschaltet werden kann durch die
Übergabe des 'auth' Parameters im Konfigurationsarray des ``Zend_Mail_Transport_Smtp`` Konstruktors. Die
vorhandenen eingebauten Authentifizierungsmethoden sind PLAIN, LOGIN und CRAM-MD5 welche alle einen Benutzernamen-
('username') und einen Passwortwert ('password') im Konfigurations Array erwarten.

.. _zend.mail.smtp-authentication.example-1:

.. rubric:: Authentifizierung innerhalb von Zend_Mail_Transport_Smtp einschalten

.. code-block:: php
   :linenos:

   $config = array('auth' => 'login',
                   'username' => 'MeinBenutzername',
                   'password' => 'Passwort');

   $transport = new Zend_Mail_Transport_Smtp('mail.server.com', $config);

   $mail = new Zend_Mail();
   $mail->setBodyText('Das ist der Text des Mails.');
   $mail->setFrom('sender@test.com', 'Einige Sender');
   $mail->addTo('recipient@test.com', 'Einige Empfänger');
   $mail->setSubject('TestBetreff');
   $mail->send($transport);

.. note::

   **Authentifizierungs Typen**

   Der Authentifizierungs Typ ist Groß-Kleinschreibungs unempfindlich enthält aber keine Satzzeichen. Um z.B.
   CRAM-MD5 zu verwenden müsste 'auth' => 'crammd5' dem ``Zend_Mail_Transport_Smtp`` Konstruktor übergeben
   werden.


