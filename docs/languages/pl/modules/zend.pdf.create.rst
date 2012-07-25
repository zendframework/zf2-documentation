.. _zend.pdf.create:

Tworzenie oraz ładowanie dokumentów PDF.
========================================

Klasa *Zend_Pdf* reprezentuje dokument PDF i zapewnia funkcjonalność na poziomie dokumentu.

W celu utworzenia nowego dokumentu trzeba utworzyć obiekt *Zend_Pdf*.

Klasa *Zend_Pdf* zapewnia także dwie statyczne metody do ładowania istniejącego dokumentu PDF. Te metody to
*Zend_Pdf::load()* oraz *Zend_Pdf::parse()*. Obie zwracają obiekt Zend_Pdf lub wyrzucają wyjątek, jeśli
wystąpi błąd.

.. _zend.pdf.create.example-1:

.. rubric:: Tworzenie nowego lub ładowanie istniejącego dokumentu PDF.

.. code-block:: php
   :linenos:

   ...
   // Utwórz nowy dokument PDF.
   $pdf1 = new Zend_Pdf();

   // Załaduj dokument PDF z pliku.
   $pdf2 = Zend_Pdf::load($fileName);

   // Załaduj dokument PDF z łańcucha znaków.
   $pdf3 = Zend_Pdf::parse($pdfString);
   ...


Format pliku PDF obsługuję inkrementalne uaktualnianie dokumentu. Wtedy za każdym razem gdy dokument jest
uaktualniony, tworzona jest nowa wersja dokumentu. Moduł Zend_Pdf umożliwia następnie ładowanie określonej
wersji dokumentu.

Wersja może być określona jako drugi parametr w metodach *Zend_Pdf::load()* oraz *Zend_Pdf::parse()* lub za
pomocą wywołania *Zend_Pdf::rollback()* [#]_

.. _zend.pdf.create.example-2:

.. rubric:: Ładowanie określonej wersji dokumentu PDF.

.. code-block:: php
   :linenos:

   ...
   // Załaduj poprzednią wersję dokumentu PDF.
   $pdf1 = Zend_Pdf::load($fileName, 1);

   // Załaduj poprzednią wersję dokumentu PDF.
   $pdf2 = Zend_Pdf::parse($pdfString, 1);

   // Załaduj pierwszą wersję dokumentu PDF.
   $pdf3 = Zend_Pdf::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...




.. [#] Metoda *Zend_Pdf::rollback()* musi być wywołana przed jakimikolwiek zmianami. W przeciwnym wypadku
       zachowanie nie jest zdefiniowane.