.. _zend.pdf.save:

Wijzigen van het PDF document opslaan
=====================================

Er kunnen twee methodes worden aangewend om gewijzigde PDF documenten op te slaan. Deze zijn de *Zend_Pdf::save()*
en *Zend_Pdf::render()* methodes.

De *Zend_Pdf::save($filename, $updateOnly = false)* methode slaat het PDF document in een bestand op. Indien
$updateOnly TRUE is zal alleen het nieuwe PDF segment aan het bestand worden toegevoegd. Zoniet wordt het bestand
overschreven.

*Zend_Pdf::render($filename, $newSegmentOnly = false)* geeft het PDF document als een string terug. Indien
$newSegmentOnly TRUE is, wordt alleen het nieuwe PDF bestandssegment teruggestuurd.

.. rubric:: Een PDF document opslaan

.. code-block:: php
   :linenos:

   <?php
   ...
   // PDF document laden.
   $pdf = Zend_Pdf::load($fileName);
   ...
   // Document updaten
   $pdf->save($fileName, true);
   // Het document als een nieuw bestand opslaan
   $pdf->save($newFileName);

   // Het document als een string terugsturen.
   $pdfString = $pdf->render();

   ...
   ?>

