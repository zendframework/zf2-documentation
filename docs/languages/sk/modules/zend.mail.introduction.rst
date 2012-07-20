.. _zend.mail.introduction:

Úvod
====

*Zend_Mail* poskytuje obecnú funkcionalitu pre posielanie a vytvaranie textovych a MIME e-mailov. E-Mail môže
byť poslaný pomocou vstavanej PHP funkcie `mail()`_ alebo cez SMTP spojenie.

.. rubric:: Jednoduchý E-Mail pomocou Zend_Mail

Jednoduchý e-mail pozostáva z niekoľkých prijímateľov, predmetu, tela a odosielateľa. Pre poslanie e-mailu
pomocou PHP funkcie `mail()`_ stačí nasledujúce:

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('somebody@example.com', 'Some Sender');
   $mail->addTo('somebody_else@example.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send();
   ?>
.. note::

   **Minimálne požiadavky**

   Na poslanie e-mailu pomocou *Zend_Mail* je potrebné zadať aspoň jedného príjemcu, odosielateľa
   (*setFrom()*) a telo správy (text a/alebo HTML).

Pre väčšinu atribútov e-mailu existujú "get" metódy na získanie hodnôt uložených v objekte. Ďalšie
detaily sú v API dokumentácii. Jedna z metód je *getRecipients()*. Metóda vráti v poli uložený zoznam
adresátov e-mailu, ktorí boli pridaný pred volaním tejto metódy.

Z dôvodu bezpečnosti *Zend_Mail* filtruje všetky hodnoty hlavičiek aby sa zabránilo vloženiu iných
hlavičiek pomocou znaku nového riadku (*\n*).

Väčšinu metód je možné použiť v pohodlnom plynulom rozhraní. Pohodlné plynulé rozhranie znamená, to že
každé volanie vráti referenciu na objekt nad ktorým bola metóda volaná a hneď je teda možné zavolať inú
metódu.

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->setBodyText('This is the text of the mail.')
       ->setFrom('somebody@example.com', 'Some Sender')
       ->addTo('somebody_else@example.com', 'Some Recipient')
       ->setSubject('TestSubject')
       ->send();
   ?>


.. _`mail()`: http://php.net/mail
