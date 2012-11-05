.. EN-Revision: none
.. _zend.pdf.pages:

Strony dokumentu.
=================

.. _zend.pdf.pages.creation:

Tworzenie strony.
-----------------

Strona dokumentu PDF jest reprezentowana przez klasę *ZendPdf\Page*.

Strony PDF mogą być tworzone lub ładowane z istniejącego dokumentu PDF.

Nowa strona może być dodana przez utworzenie obiektu *ZendPdf\Page* lub wywołanie metody *ZendPdf\Pdf::newPage()*,
która zwraca obiekt *ZendPdf\Page*. Różnicą jest to, że metoda *ZendPdf\Pdf::newPage()* tworzy stronę
dołączoną do dokumentu. W przeciwieństwie to luźnych stron, niepołączonych z żadnym dokumentem, nie może
ona być użyta z kilkoma dokumentami PDF, ale ma ona trochę lepszą wydajność. [#]_. Do ciebie należy wybor
sposobu, którego użyjesz.

Metoda *ZendPdf\Pdf::newPage()* oraz konstruktor klasy *ZendPdf\Page* przyjmują ten sam zestaw parametrów. W
obydwóch jest to rozmiar strony ($x, $y) w punktach (1/72 cala), lub definiowana stała, która jest traktowana
jako typ strony:

   - ZendPdf\Page::SIZE_A4

   - ZendPdf\Page::SIZE_A4_LANDSCAPE

   - ZendPdf\Page::SIZE_LETTER

   - ZendPdf\Page::SIZE_LETTER_LANDSCAPE



Strony dokumentu są przechowywane w tablicy *$pages* będącej publiczną właściwością klasy *ZendPdf*. Jest
to tablica obiektów *ZendPdf\Page*. Kompletnie definiuje ona zbiór oraz kolejność stron dokumentu, a także
możemy nią manipulować jak zwykłą tablicą:

.. _zend.pdf.pages.example-1:

.. rubric:: Zarządzanie stronami dokumentu PDF.

.. code-block:: php
   :linenos:

   ...
   // Odwróć kolejność stron
   $pdf->pages = array_reverse($pdf->pages);
   ...
   // Dodaj nową stronę
   $pdf->pages[] = new ZendPdf\Page(ZendPdf\Page::SIZE_A4);
   // Dodaj nową stronę
   $pdf->pages[] = $pdf->newPage(ZendPdf\Page::SIZE_A4);

   // Usuń określoną stronę.
   unset($pdf->pages[$id]);

   ...


.. _zend.pdf.pages.cloning:

Klonowanie stron.
-----------------

Istniejące strony PDF mogą być klonowane przez tworzenie nowego obiektu *ZendPdf\Page* z istniejącą stroną w
parametrze.

.. _zend.pdf.pages.example-2:

.. rubric:: Klonowanie istniejącej strony.

.. code-block:: php
   :linenos:

   ...
   // Przechowaj szablon strony w osobnej zmiennej
   $template = $pdf->pages[$templatePageIndex];
   ...
   // Dodaj nową stronę
   $page1 = new ZendPdf\Page($template);
   $pdf->pages[] = $page1;
   ...

   // Dodaj kolejną stronę
   $page2 = new ZendPdf\Page($template);
   $pdf->pages[] = $page2;
   ...

   // Usuń źródłowy szablon strony z dokumentów
   unset($pdf->pages[$templatePageIndex]);

   ...


Jest to przydatne gdy chcesz utworzyć wiele stron używając jednego szablonu.

.. caution::

   Ważne! Klonowane strony korzystają z tych samych zasobów co szablon strony, więc mogą być one użyte tylko
   w tym samym dokumencie co szablon. Zmodyfkowany dokument może być zapisany jako nowy dokument.



.. [#] Jest to limitacja wersji V1.0 modułu ZendPdf. Będzie to wyeliminowane w przyszłych wersjach. Jednak
       luźne strony zawsze będą dawały lepsze (bardziej optymalne) wyniki przy używaniu stron w kilku
       dokumentach.