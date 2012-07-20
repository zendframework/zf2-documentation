.. _zend.pdf.introduction:

Wprowadzenie
============

Moduł Zend_Pdf jest silnikiem służącym do manipulacji plikami PDF (Portable Document Format) napisanym w
całości w PHP 5. Może on ładować istniejące dokumenty, tworzyć nowe, modyfikować i zapisywać zmodyfikowane
dokumenty. Umożliwia to dowolnej aplikacji PHP dynamicznie przygotowywać dokumenty PDF modyfikując istniejące
szablony lub generować dokumenty od podstaw. Moduł Zend_Pdf wspiera następujące funkcjonalności:



   - Tworzenie nowego dokumentu lub ładowanie istniejącego. [#]_

   - Ładowanie określonej wersji dokumentu.

   - Manipulowanie stronami w dokumencie. Zmiana kolejności stron, dodawanie nowych stron, usuwanie stron z
     dokumentu.

   - Podstawowe operacje rysowania (linie, prostokąty, wielokąty, okręgi, elipsy oraz sektory).

   - Wypisywanie tekstu używając 14 standardowych (wbudowanych) czcionek lub twoich własych czcionek TrueType.

   - Obracanie.

   - Obsługa plików graficznych. [#]_

   - Inkrementalne uaktualnianie plików PDF.





.. [#] Obecnie jest możliwe ładowanie dokumentów PDF V1.4 (Acrobat 5).
.. [#] Obecnie wspierane są pliki JPG, PNG [do 8bit na kanał+Alpha] oraz TIFF.