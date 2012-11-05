.. EN-Revision: none
.. _zend.pdf.pages:

Document pagina's
=================

De PDF document pagina abstractie word afgehandeld door de *ZendPdf\Page* klasse.

PDF pagina's worden ofwel vanuit bestaande PDF documenten geladen of worden nieuw aangemaakt.

Een nieuwe pagina kan worden verkregen door een nieuw *ZendPdf\Page* object te maken of door de
*ZendPdf\Pdf::newPage()* methode op te roepen, welke een *ZendPdf\Page* object teruggeeft. Het verschil is dat de
*ZendPdf\Pdf::newPage()* methode een nieuwe pagina in een bestaand PDF document maakt. Ongebonden pagina's kunnen niet
in verschillende PDF documenten worden gebruikt, maar zijn iets sneller om aan te maken. [#]_\ Aan jou om de keuze
te maken welke aanpak je kiest.

De *ZendPdf\Pdf::newPage()* methode en de *ZendPdf\Page* constructor aanvaarden dezelfde set parameters. Ofwel is het
de paginagrootte ($x, $y) in points (1/72 duim), of een vastgestelde constante, welke een paginatype voorstelt:

   - ZendPdf\Const::PAGESIZE_A4

   - ZendPdf\Const::PAGESIZE_A4_LANDSCAPE

   - ZendPdf\Const::PAGESIZE_LETTER

   - ZendPdf\Const::PAGESIZE_LETTER_LANDSCAPE



Document pagina's worden opgeslagen in de publieke *$pages* eigenschap van de *ZendPdf* klasse. Dat is een array
van *ZendPdf\Page* objecten. Het omvat de volledige set, en de orde van de pagina's van het document en kan
gemanipuleerd worden als een array:

.. rubric:: PDF pagina management

.. code-block:: php
   :linenos:

   <?php
   ...
   // De volgorde omkeren
   $pdf->pages = array_reverse($pdf->pages);
   ...
   // Een nieuw pagina toevoegen
   $pdf->pages[] = new ZendPdf\Page(ZendPdf\Const::PAGESIZE_A4);
   // Een nieuwe pagina toevoegen
   $pdf->pages[] = $pdf->newPage(ZendPdf\Const::PAGESIZE_A4);

   // De aangeduide pagina verwijderen.
   unset($pdf->pages[$id]);

   ...
   ?>


.. [#] Het is een limitatie van de V1.0 versie van de ZendPdf module. Deze limitatie zal verdwijnen in volgende
       versies. Ongebonden pagina's zullen altijd een beter (optimaler) resultaat geven om pagina's in te delen
       onder documenten.