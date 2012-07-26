.. _zend.mail.boundary:

De MIME Boundary controleren
============================

In een multipart bericht wordt meestal een willekeurige MIME boundary aangemaakt om de verschillende delen van het
bericht te scheiden. In sommige gevallen kan het echter zijn dat je zelf de MIME boundary wil opgeven die gebruikt
moet worden. Dat kan gedaan worden met de *setMimeBoundary()* methode, zoals in het volgende voorbeeld:

.. rubric:: De MIME Boundary veranderen

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend_Mail();
   $mail->setMimeBoundary('=_' . md5(microtime(1) . $someId++);
   // bericht maken...
   ?>

