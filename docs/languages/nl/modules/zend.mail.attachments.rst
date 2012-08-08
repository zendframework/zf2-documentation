.. EN-Revision: none
.. _zend.mail.attachments:

Bijlagen
========

Je kan bestanden aan e-mail bijvoegen door de *addAttachment()* methode te gebruiken. Het standaard gedrag van
*Zend_Mail* neemt aan dat de bijlage een binair object is (application/octet-stream), het zou moeten gezonden
worden met 64base encoding en als een bijlage moet worden behandeld. Deze veronderstellingen kunnen overschreven
worden door meer parameters aan *addAttachment()* door te geven:

.. rubric:: E-mails met bijlagen

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   // bericht maken...
   $mail->addAttachment($someBinaryString);
   $mail->addAttachment($myImage, 'image/gif', Zend_Mime::DISPOSITION_INLINE, Zend_Mime::ENCODING_8BIT);
   ?>
Als je meer controle wil over het MIME deel dat voor deze bijlage word gemaakt kan je de waarde die door
*addAttachment()* wordt teruggegeven gebruiken om zijn attributen te veranderen. De *addAttachment* geeft een
*Zend_Mime_Part* object terug:

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();

   $at = $mail->addAttachment($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend_Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend_Mime::ENCODING_8BIT;
   $at->filename    = 'test.gif';

   $mail->send();
   ?>

