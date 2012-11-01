.. EN-Revision: none
.. _zend.pdf.create:

Maken en laden van PDF documenten
=================================

De *ZendPdf* klasse stelt het PDF document zelf op en verstrekt functionaliteit op document niveau.

Om een nieuw document aan te maken moet je een nieuw *ZendPdf* object aanmaken.

De *ZendPdf* klasse verstrekt ook twee statische methodes om bestaande PDF documenten te laden. Deze zijn de
*ZendPdf\Pdf::load()* en *ZendPdf\Pdf::parse()* methodes. Beiden geven een *ZendPdf* object als resultaat terug of
werpen een exceptie op indien er een probleem optrad.

.. rubric:: Maak een nieuw of laad een bestaand PDF document

.. code-block:: php
   :linenos:

   <?php
   ...
   // Maak een nieuw PDF document.
   $pdf1 = new ZendPdf\Pdf();

   // Laad een PDF document van een bestand.
   $pdf2 = ZendPdf\Pdf::load($fileName);

   // Laad een PDF document van een string.
   $pdf3 = ZendPdf\Pdf::parse($pdfString);
   ...
   ?>
Het PDF bestandsformaat ondersteund incremental document update. Dus elke keer als een document wordt aangepast
word er een nieuwe revisie van het document gemaakt. De *ZendPdf* module ondersteunt het opvragen van een bepaalde
revisie.

De revisie kan worden bepaald als een tweede parameter voor de *ZendPdf\Pdf::load()* en *ZendPdf\Pdf::parse()* methodes
of worden opgevraagd door *ZendPdf\Pdf::rollback()* [#]_

.. rubric:: Een bepaalde revisie van een document opvragen

.. code-block:: php
   :linenos:

   <?php
   ...
   // Een vorige revisie van het PDF document opvragen.
   $pdf1 = ZendPdf\Pdf::load($fileName, 1);

   // Een vorige revisie van het PDF document opvragen.
   $pdf2 = ZendPdf\Pdf::parse($pdfString, 1);

   // De eerste revisie van het PDF document opvragen.
   $pdf3 = ZendPdf\Pdf::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...
   ?>


.. [#] De *ZendPdf\Pdf::rollback()* methode moet aangeroepen worden voor er enige veranderingen aan het document
       worden doorgevoerd. Indien dit niet het geval is is het gedrag onvoorspelbaar.