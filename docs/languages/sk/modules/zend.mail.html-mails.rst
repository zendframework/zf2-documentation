.. EN-Revision: none
.. _zend.mail.html-mails:

HTML e-mail
===========

Na poslanie e-mailu v HTML formáte je potrebné vytvoriť telo e-mailu pomocou metódy *setBodyHTML()* na miesto
metódy *setBodyText()*. Obsah bude automaticky označený ako *text/html*. Ak sa vytvorí HTML a aj textová
verzia e-mailu výsledný e-mail bude typu multipart/alternative:

.. rubric:: Vytvorenie a poslanie HTML e-mailu

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->setBodyText('Môj pekný Test Text');
   $mail->setBodyHtml('Môj pekný <b>Test</b> Text');
   $mail->setFrom('somebody@example.com', 'Odosielateľ');
   $mail->addTo('somebody_else@example.com', 'Príjemca');
   $mail->setSubject('Predmet');
   $mail->send();
   ?>

