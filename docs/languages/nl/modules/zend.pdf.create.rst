.. _zend.pdf.create:

Maken en laden van PDF documenten
=================================

De *Zend_Pdf* klasse stelt het PDF document zelf op en verstrekt functionaliteit op document niveau.

Om een nieuw document aan te maken moet je een nieuw *Zend_Pdf* object aanmaken.

De *Zend_Pdf* klasse verstrekt ook twee statische methodes om bestaande PDF documenten te laden. Deze zijn de
*Zend_Pdf::load()* en *Zend_Pdf::parse()* methodes. Beiden geven een *Zend_Pdf* object als resultaat terug of
werpen een exceptie op indien er een probleem optrad.

.. rubric:: Maak een nieuw of laad een bestaand PDF document

.. code-block:: php
   :linenos:

   <?php
   ...
   // Maak een nieuw PDF document.
   $pdf1 = new Zend_Pdf();

   // Laad een PDF document van een bestand.
   $pdf2 = Zend_Pdf::load($fileName);

   // Laad een PDF document van een string.
   $pdf3 = Zend_Pdf::parse($pdfString);
   ...
   ?>
Het PDF bestandsformaat ondersteund incremental document update. Dus elke keer als een document wordt aangepast
word er een nieuwe revisie van het document gemaakt. De *Zend_Pdf* module ondersteunt het opvragen van een bepaalde
revisie.

De revisie kan worden bepaald als een tweede parameter voor de *Zend_Pdf::load()* en *Zend_Pdf::parse()* methodes
of worden opgevraagd door *Zend_Pdf::rollback()* [#]_

.. rubric:: Een bepaalde revisie van een document opvragen

.. code-block:: php
   :linenos:

   <?php
   ...
   // Een vorige revisie van het PDF document opvragen.
   $pdf1 = Zend_Pdf::load($fileName, 1);

   // Een vorige revisie van het PDF document opvragen.
   $pdf2 = Zend_Pdf::parse($pdfString, 1);

   // De eerste revisie van het PDF document opvragen.
   $pdf3 = Zend_Pdf::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...
   ?>


.. [#] De *Zend_Pdf::rollback()* methode moet aangeroepen worden voor er enige veranderingen aan het document
       worden doorgevoerd. Indien dit niet het geval is is het gedrag onvoorspelbaar.