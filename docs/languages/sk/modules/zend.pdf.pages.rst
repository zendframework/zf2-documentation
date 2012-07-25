.. _zend.pdf.pages:

Stránky dokumentu
=================

Stránky v PDF dokumente sú reprezentované triedou *Zend_Pdf_Page*.

Stránky PDF dukumentu možu byt načítane zo súboru, alebo vytvorené.

Nové stránky môžu byť získané vytvorením nového objektu *Zend_Pdf_Page* alebo zavolaním metódy
*Zend_Pdf::newPage()*, ktorá vráti objekt *Zend_Pdf_Page*. Rozdiel je ten, že metóda *Zend_Pdf::newPage()*
vytvorí stránku, ktorá je spojená z dokumentom. Rozdiel oproti nespojeným stránkam je to, že nemôže byť
použitá vo viacerých PDF dokumentoch, ale za to je rýchlejšia. [#]_

Metóda *Zend_Pdf::newPage()* a konštruktor *Zend_Pdf_Page* majú rovnaké parametre. Buď veľkosť stránky ($x,
$y) zadanú v bodoch (1/72 palca), alebo jednu z preddefinovaných konštánt, ktoré sú považované za typ
stránky:

   - Zend_Pdf_Page::SIZE_A4

   - Zend_Pdf_Page::SIZE_A4_LANDSCAPE

   - Zend_Pdf_Page::SIZE_LETTER

   - Zend_Pdf_Page::SIZE_LETTER_LANDSCAPE



Stránky dokumentu sú uložené v poli *$pages*, ktoré je verejná vlastnosť objektu *Zend_Pdf*. Toto pole
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
   $pdf->pages[] = new Zend_Pdf_Page(Zend_Pdf_Page::SIZE_A4);
   // Pridanie stránky
   $pdf->pages[] = $pdf->newPage(Zend_Pdf_Page::SIZE_A4);

   // Odstránenie stránky
   unset($pdf->pages[$id]);

   ...
   ?>


.. [#] Toto je limitácia verzie 1.0 Zend_Pdf a bude odstránená v budúcich verziách. Nepripojené stránky
       dávajú lepšie (optimálne) výsledky pre zdieľanie stránok medzi dokumentami.