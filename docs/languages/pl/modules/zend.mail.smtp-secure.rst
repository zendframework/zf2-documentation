.. _zend.mail.smtp-secure:

Bezpieczne połączenie SMTP
==========================

Klasa *Zend_Mail* obsługuje także użycie bezpiecznego połączenia SMTP za pomocą protokołu TLS lub SSL. Może
to być aktywowane przez przekazanie parametru 'ssl' o wartości 'ssl' lub 'tls' w tablicy konfiguracyjnej do
konstruktora klasy *Zend_Mail_Transport_Smtp*. Doodatkowo podany może być numer portu, w przeciwnym wypadku
użyta będzie domyślna wartość -- 25 dla TLS oraz 465 dla SSL.

.. _zend.mail.smtp-secure.example-1:

.. rubric:: Aktywowanie bezpiecznego połączenia w klasie Zend_Mail_Transport_Smtp

.. code-block:: php
   :linenos:

   $config = array('ssl' => 'tls',
                   'port' => 25); // Podany opcjonalny numer portu

   $transport = new Zend_Mail_Transport_Smtp('mail.server.com', $config);

   $mail = new Zend_Mail();
   $mail->setBodyText('To jest treść wiadomości e-mail.');
   $mail->setFrom('sender@test.com', 'Nadawca');
   $mail->addTo('recipient@test.com', 'Adresat');
   $mail->setSubject('Testowy temat');
   $mail->send($transport);



