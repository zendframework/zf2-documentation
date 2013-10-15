.. EN-Revision: none
.. _zend.mail.smtp-secure:

SMTP Übertragungen sichern
==========================

``Zend_Mail`` unterstützt die Verwendung von TLS oder *SSL* um SMTP Verbindungen zu sichern. Das kann
eingeschaltet werden durch das Übergeben des 'ssl' Parameters an das Konfigurationsarray im
``Zend\Mail\Transport\Smtp`` Konstruktor indem entweder der Wert 'ssl' oder 'tls' übergeben wird. Ein Port kann
optional angegeben werden, andernfalls ist er standardmäßig 25 für TLS oder 465 für *SSL*.

.. _zend.mail.smtp-secure.example-1:

.. rubric:: Aktivieren einer sicheren Verbindung innerhalb von Zend\Mail\Transport\Smtp

.. code-block:: php
   :linenos:

   $config = array('ssl' => 'tls',
                   'port' => 25); // Optionale unterstützte Portnummer

   $transport = new Zend\Mail\Transport\Smtp('mail.server.com', $config);

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('Das ist der Text der Mail.');
   $mail->setFrom('sender@test.com', 'Einige Sender');
   $mail->addTo('recipient@test.com', 'Einige Empfänger');
   $mail->setSubject('TestBetreff');
   $mail->send($transport);


