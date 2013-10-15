.. EN-Revision: none
.. _zend.mail.multiple-emails:

Versand von mehreren E-Mails über eine SMTP Verbindung
======================================================

Standardmäßig erstellt ein einzelner SMTP Transport eine einzelne Verbindung und verwendet Sie wieder wärend der
Laufzeit der Skriptausführung. Es können mehrere E-Mails über diese SMTP Verbindung gesendet werden. Ein RSET
Kommando wird vor jeder Ausführung angewendet um sicherzustellen das der korrekte SMTP Handschlag folgt.

Optional kann auch eine standardmäßige From Emailadresse und Name definiert werden sowie ein standardmäßiger
reply-to Header. Das kann durch die statischen Methoden ``setDefaultFrom()`` und ``setDefaultReplyTo()`` getan
werden. Diese Standardwerte werden verwendet wenn man keine From oder Reply-to Adresse oder -Name angibt bis die
Standardwerte zurückgesetzt werden (gelöscht). Das Zurücksetzen der Standardwerte kann durch die Verwendung von
``clearDefaultFrom()`` und ``clearDefaultReplyTo`` durchgeführt werden.

.. _zend.mail.multiple-emails.example-1:

.. rubric:: Versand von mehreren E-Mails über eine SMTP Verbindung

.. code-block:: php
   :linenos:

   // Transport erstellen
   $config = array('name' => 'sender.example.com');
   $transport = new Zend\Mail\Transport\Smtp('mail.example.com', $config);

   // Setzt From & Reply-To Adressen
   // und Namen für alle Emails die zu versenden sind
   Zend\Mail\Mail::setDefaultFrom('sender@example.com', 'John Doe');
   Zend\Mail\Mail::setDefaultReplyTo('replyto@example.com','Jane Doe');

   // Durch die Nachrichten gehen
   for ($i = 0; $i < 5; $i++) {
       $mail = new Zend\Mail\Mail();
       $mail->addTo('studio@example.com', 'Test');
       $mail->setFrom('studio@example.com', 'Test');
       $mail->setSubject(
           'Demonstration - mit einer SMTP Verbindung mehrfache E-Mails senden'
       );
       $mail->setBodyText('...Hier die Nachricht...');
       $mail->send($transport);
   }

   // Setzt die Standardwerte zurück
   Zend\Mail\Mail::clearDefaultFrom();
   Zend\Mail\Mail::clearDefaultReplyTo();

Wenn man eine separate Verbindung für jeden Mailtransport haben will, muß der Transport vor und nach jedem Aufruf
der ``send()`` Methode erstellt und gelöscht werden. Oder alternativ kann die Verbindung zwischen jedem Transport,
durch Zugriff auf das Protokoll Objekt des Transportes, manipuliert werden.

.. _zend.mail.multiple-emails.example-2:

.. rubric:: Die Transportverbindung manuell kontrollieren

.. code-block:: php
   :linenos:

   // Transport erstellen
   $transport = new Zend\Mail\Transport\Smtp();

   $protocol = new Zend\Mail\Protocol\Smtp('mail.example.com');
   $protocol->connect();
   $protocol->helo('mail.example.com');

   $transport->setConnection($protocol);

   // Durch die Nachrichten gehen
   for ($i = 0; $i < 5; $i++) {
       $mail = new Zend\Mail\Mail();
       $mail->addTo('studio@example.com', 'Test');
       $mail->setFrom('studio@example.com', 'Test');
       $mail->setSubject(
           'Demonstration - mit einer SMTP Verbindung mehrfache E-Mails senden'
       );
       $mail->setBodyText('...Hier die Nachricht...');

       // Die Verbindung manuell kontrollieren
       $protocol->rset();
       $mail->send($transport);
   }

   $protocol->quit();
   $protocol->disconnect();


