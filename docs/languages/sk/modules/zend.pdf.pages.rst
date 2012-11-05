.. EN-Revision: none
.. _zend.pdf.pages:

Stránky dokumentu
=================

Stránky v PDF dokumente sú reprezentované triedou *ZendPdf\Page*.

Stránky PDF dukumentu možu byt načítane zo súboru, alebo vytvorené.

Nové stránky môžu byť získané vytvorením nového objektu *ZendPdf\Page* alebo zavolaním metódy
*ZendPdf\Pdf::newPage()*, ktorá vráti objekt *ZendPdf\Page*. Rozdiel je ten, že metóda *ZendPdf\Pdf::newPage()*
vytvorí stránku, ktorá je spojená z dokumentom. Rozdiel oproti nespojeným stránkam je to, že nemôže byť
použitá vo viacerých PDF dokumentoch, ale za to je rýchlejšia. [#]_

Metóda *ZendPdf\Pdf::newPage()* a konštruktor *ZendPdf\Page* majú rovnaké parametre. Buď veľkosť stránky ($x,
$y) zadanú v bodoch (1/72 palca), alebo jednu z preddefinovaných konštánt, ktoré sú považované za typ
stránky:

   - ZendPdf\Page::SIZE_A4

   - ZendPdf\Page::SIZE_A4_LANDSCAPE

   - ZendPdf\Page::SIZE_LETTER

   - ZendPdf\Page::SIZE_LETTER_LANDSCAPE



Stránky dokumentu sú uložené v poli *$pages*, ktoré je verejná vlastnosť objektu *ZendPdf*. Toto pole
určuje poradie stránok a je sním možné manipulovať ako klasickým poľom:

.. rubric:: PDF document pages management.

.. code-block:: php
   :linenos:

   <?php
   ...
   // Otočenie poradia stránok
   $pdf->pages = array_reverse($pdf->pages);
   ...
   // Pridanie stránky
   $pdf->pages[] = new ZendPdf\Page(ZendPdf\Page::SIZE_A4);
   // Pridanie stránky
   $pdf->pages[] = $pdf->newPage(ZendPdf\Page::SIZE_A4);

   // Odstránenie stránky
   unset($pdf->pages[$id]);

   ...
   ?>


.. [#] Toto je limitácia verzie 1.0 ZendPdf a bude odstránená v budúcich verziách. Nepripojené stránky
       dávajú lepšie (optimálne) výsledky pre zdieľanie stránok medzi dokumentami.