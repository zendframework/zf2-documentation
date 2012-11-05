.. EN-Revision: none
.. _zend.pdf.create:

Tworzenie oraz ładowanie dokumentów PDF.
========================================

Klasa *ZendPdf* reprezentuje dokument PDF i zapewnia funkcjonalność na poziomie dokumentu.

W celu utworzenia nowego dokumentu trzeba utworzyć obiekt *ZendPdf*.

Klasa *ZendPdf* zapewnia także dwie statyczne metody do ładowania istniejącego dokumentu PDF. Te metody to
*ZendPdf\Pdf::load()* oraz *ZendPdf\Pdf::parse()*. Obie zwracają obiekt ZendPdf lub wyrzucają wyjątek, jeśli
wystąpi błąd.

.. _zend.pdf.create.example-1:

.. rubric:: Tworzenie nowego lub ładowanie istniejącego dokumentu PDF.

.. code-block:: php
   :linenos:

   ...
   // Utwórz nowy dokument PDF.
   $pdf1 = new ZendPdf\Pdf();

   // Załaduj dokument PDF z pliku.
   $pdf2 = ZendPdf\Pdf::load($fileName);

   // Załaduj dokument PDF z łańcucha znaków.
   $pdf3 = ZendPdf\Pdf::parse($pdfString);
   ...


Format pliku PDF obsługuję inkrementalne uaktualnianie dokumentu. Wtedy za każdym razem gdy dokument jest
uaktualniony, tworzona jest nowa wersja dokumentu. Moduł ZendPdf umożliwia następnie ładowanie określonej
wersji dokumentu.

Wersja może być określona jako drugi parametr w metodach *ZendPdf\Pdf::load()* oraz *ZendPdf\Pdf::parse()* lub za
pomocą wywołania *ZendPdf\Pdf::rollback()* [#]_

.. _zend.pdf.create.example-2:

.. rubric:: Ładowanie określonej wersji dokumentu PDF.

.. code-block:: php
   :linenos:

   ...
   // Załaduj poprzednią wersję dokumentu PDF.
   $pdf1 = ZendPdf\Pdf::load($fileName, 1);

   // Załaduj poprzednią wersję dokumentu PDF.
   $pdf2 = ZendPdf\Pdf::parse($pdfString, 1);

   // Załaduj pierwszą wersję dokumentu PDF.
   $pdf3 = ZendPdf\Pdf::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...




.. [#] Metoda *ZendPdf\Pdf::rollback()* musi być wywołana przed jakimikolwiek zmianami. W przeciwnym wypadku
       zachowanie nie jest zdefiniowane.