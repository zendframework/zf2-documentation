.. _zend.mail.additional-headers:

Bijkomende Headers
==================

Je kan willekeurige headers zetten met de *addHeader* methode. Deze methode verwacht twee parameters die de naam en
de waarde van het headerveld moeten bevatten. Een derde optionele parameter geeft aan of de header één enkele of
meerdere waarden zou moeten hebben:

.. rubric:: E-mailbericht Headers toevoegen

.. code-block::
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->addHeader('X-MailGenerator', 'MijnSuperToepassing');
   $mail->addHeader('X-greetingsTo', 'Mamma', true); // Meerdere waarden
   $mail->addHeader('X-greetingsTo', 'Pappa', true);
   ?>

