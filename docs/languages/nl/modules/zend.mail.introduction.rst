.. _zend.mail.introduction:

Inleiding
=========

*Zend_Mail* verstrekt globale functionaliteit om zowel tekst als MIME-compliant multipart e-mails te sturen. Mail
kan gestuurd worden met *Zend_Mail* via de ingebouwde PHP functie `mail()`_ of via een directe SMTP verbinding.

.. rubric:: Eenvoudige E-mail met Zend_Mail

Een eenvoudige e-mail bestaat uit enkele geadresseerden, een onderwerp, een inhoud en een afzender. Om zo'n mail te
sturen met de PHP `mail()`_ functie doe je het volgende:

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->setBodyText('Dit is de inhoud van de mail.');
   $mail->setFrom('somebody@example.com', 'Een afzender');
   $mail->addTo('somebody_else@example.com', 'Een geadresseerde');
   $mail->setSubject('TestOnderwerp');
   $mail->send();
   ?>
.. note::

   Om een mail te sturen met *Zend_Mail* moet je op zijn minst één geadresseerde, een afzender (bijvoorbeeld met
   *setFrom()*) en een inhoud (tekst of HTML) ingeven.

Voor de meeste mail attributen zijn er "get" methodes om de informatie die in het mail object is opgeslaan te
lezen. Voor meer detail kan je terecht bij de API documentatie. Een speciale methode is *getRecipients()*. Deze
methode stuurt een array terug van alle geadresseerden die werden toegevoegd voor de roep aan de methode.

Om veiligheidsredenen filtert *Zend_Mail* alle headervelden om header injectie te voorkomen met behulp van newline
(*\n*) tekens.



.. _`mail()`: http://php.net/mail
