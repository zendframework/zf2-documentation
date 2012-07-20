.. _zend.mail.sending:

Wysyłanie przez SMTP
====================

Aby wysłać mail przez SMTP, obiekt *Zend_Mail_Transport_Smtp* musi być utworzony i zarejestrowany w obiekcie
*Zend_Mail* zanim zostanie wywołana metoda *send()*. Dla kolejnych wywołań *Zend_Mail::send()* w tym skrypcie
będzie także użyty transport SMTP:

.. _zend.mail.sending.example-1:

.. rubric:: Wysyłanie e-maila przez SMTP

.. code-block::
   :linenos:

   $tr = new Zend_Mail_Transport_Smtp('mail.example.com');
   Zend_Mail::setDefaultTransport($tr);


Metoda *setDefaultTransport()* oraz konstruktor *Zend_Mail_Transport_Smtp* nie są czasochłonne. Te dwie linie
mogą być wykonane w czasie przygotowania skryptu (np. w pliku config.inc czy w podobnym) w celu skonfigurowania
zachowania klasy *Zend_Mail* w reszcie skryptu. To utrzymuje informacje konfiguracyjne poza logiką aplikacji - to
czy wiadomości mają być wysyłane przez SMTP czy przez funkcję PHP `mail()`_, jaki serwer poczty ma być użyty
itp.



.. _`mail()`: http://php.net/mail
