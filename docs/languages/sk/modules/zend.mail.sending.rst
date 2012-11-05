.. EN-Revision: none
.. _zend.mail.sending:

Posielanie cez SMTP
===================

Pre posielanie e-mailov cez SMTP je potrebné vytvoriť *Zend\Mail_Transport\Smtp* a registrovať s *Zend_Mail*
pred zavolaním metódy *send()*. Všetky nasledujúce volania *Zend\Mail\Mail::send()* v skripte budú používať
SMTP.

.. rubric:: Posielanie cez SMTP

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail/Transport/Smtp.php';
   $tr = new Zend\Mail_Transport\Smtp('mail.example.com');
   Zend\Mail\Mail::setDefaultTransport($tr);
   ?>
Volanie *setDefaultTransport()* a vytvorenie *Zend\Mail_Transport\Smtp* nie sú náročné. Tieto dva riadky kódu
môžu byť vykonané počas inicializácie skriptu (napr. config.inc a podobne). Tento spôsob umožní oddeliť
konfiguráciu od aplikačnej logiky - bez ohľadu na to či je e-mail posielaný cez SMTP, alebo `mail()`_, aký
mail server je použitý, atď.



.. _`mail()`: http://php.net/mail
