.. EN-Revision: none
.. _zend.mail.boundary:

Nastavenie hranice MIME
=======================

Ak má e-mail viac častí oddeľujú sa pomocou hranice ktorá sa generuje náhodne. Pomocou metódy
*setMimeBoundary()* je možné nastaviť vlastnú MIME hranicu, napríklad:

.. rubric:: Nastavenie hranice MIME

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend\Mail\Mail();
   $mail->setMimeBoundary('=_' . md5(microtime(1) . $someId++);
   // build message...
   ?>

