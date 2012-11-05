.. EN-Revision: none
.. _zend.mail.sending:

Wysyłanie przez SMTP
====================

Aby wysłać mail przez SMTP, obiekt *Zend\Mail_Transport\Smtp* musi być utworzony i zarejestrowany w obiekcie
*Zend_Mail* zanim zostanie wywołana metoda *send()*. Dla kolejnych wywołań *Zend\Mail\Mail::send()* w tym skrypcie
będzie także użyty transport SMTP:

.. _zend.mail.sending.example-1:

.. rubric:: Wysyłanie e-maila przez SMTP

.. code-block:: php
   :linenos:

   $tr = new Zend\Mail_Transport\Smtp('mail.example.com');
   Zend\Mail\Mail::setDefaultTransport($tr);


Metoda *setDefaultTransport()* oraz konstruktor *Zend\Mail_Transport\Smtp* nie są czasochłonne. Te dwie linie
mogą być wykonane w czasie przygotowania skryptu (np. w pliku config.inc czy w podobnym) w celu skonfigurowania
zachowania klasy *Zend_Mail* w reszcie skryptu. To utrzymuje informacje konfiguracyjne poza logiką aplikacji - to
czy wiadomości mają być wysyłane przez SMTP czy przez funkcję PHP `mail()`_, jaki serwer poczty ma być użyty
itp.



.. _`mail()`: http://php.net/mail
