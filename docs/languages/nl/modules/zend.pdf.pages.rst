.. _zend.pdf.pages:

Document pagina's
=================

De PDF document pagina abstractie word afgehandeld door de *Zend_Pdf_Page* klasse.

PDF pagina's worden ofwel vanuit bestaande PDF documenten geladen of worden nieuw aangemaakt.

Een nieuwe pagina kan worden verkregen door een nieuw *Zend_Pdf_Page* object te maken of door de
*Zend_Pdf::newPage()* methode op te roepen, welke een *Zend_Pdf_Page* object teruggeeft. Het verschil is dat de
*Zend_Pdf::newPage()* methode een nieuwe pagina in een bestaand PDF document maakt. Ongebonden pagina's kunnen niet
in verschillende PDF documenten worden gebruikt, maar zijn iets sneller om aan te maken. [#]_\ Aan jou om de keuze
te maken welke aanpak je kiest.

De *Zend_Pdf::newPage()* methode en de *Zend_Pdf_Page* constructor aanvaarden dezelfde set parameters. Ofwel is het
de paginagrootte ($x, $y) in points (1/72 duim), of een vastgestelde constante, welke een paginatype voorstelt:

   - Zend_Pdf_Const::PAGESIZE_A4

   - Zend_Pdf_Const::PAGESIZE_A4_LANDSCAPE

   - Zend_Pdf_Const::PAGESIZE_LETTER

   - Zend_Pdf_Const::PAGESIZE_LETTER_LANDSCAPE



Document pagina's worden opgeslagen in de publieke *$pages* eigenschap van de *Zend_Pdf* klasse. Dat is een array
van *Zend_Pdf_Page* objecten. Het omvat de volledige set, en de orde van de pagina's van het document en kan
gemanipuleerd worden als een array:

.. rubric:: PDF pagina management

.. code-block::
   :linenos:
   <?php
   ...
   // De volgorde omkeren
   $pdf->pages = array_reverse($pdf->pages);
   ...
   // Een nieuw pagina toevoegen
   $pdf->pages[] = new Zend_Pdf_Page(Zend_Pdf_Const::PAGESIZE_A4);
   // Een nieuwe pagina toevoegen
   $pdf->pages[] = $pdf->newPage(Zend_Pdf_Const::PAGESIZE_A4);

   // De aangeduide pagina verwijderen.
   unset($pdf->pages[$id]);

   ...
   ?>


.. [#] Het is een limitatie van de V1.0 versie van de Zend_Pdf module. Deze limitatie zal verdwijnen in volgende
       versies. Ongebonden pagina's zullen altijd een beter (optimaler) resultaat geven om pagina's in te delen
       onder documenten.