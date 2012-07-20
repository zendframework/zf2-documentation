.. _zend.mail.html-mails:

HTML E-Mail
===========

Om e-mail in HTML formaat te sturen moet je de inhoud geven via de methode *setBodyHTML()* in plaats van
*setBodyText()*. Het MIME inhoudstype zal automatisch naar *text/html* worden gezet. Indien je zowel HTML als tekst
inhoud gebruikt zal er automatisch een multipart/alternative MIME message worden gegenereerd:

.. rubric:: HTML E-Mail zenden

.. code-block::
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->setBodyText('Mijn mooie testtekst');
   $mail->setBodyHtml('Mijn mooie <b>test</b>tekst');
   $mail->setFrom('somebody@example.com', 'Een afzender');
   $mail->addTo('somebody_else@example.com', 'Een geadresseerde');
   $mail->setSubject('TestOnderwerp');
   $mail->send();
   ?>

