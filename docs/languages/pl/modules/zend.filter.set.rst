.. EN-Revision: none
.. _zend.filter.set:

Standardowe klasy filtrów
=========================

Zend Framework posiada standardowy zestaw gotowych do użycia filtrów..

.. _zend.filter.set.alnum:

Alnum
-----

Zwraca łańcuch znaków *$value*, usuwając wszystkie znaki oprócz znaków alfabetu oraz cyfr. Filtr posiada
także opcję, służącą do zezwolenia na wystąpienie białych znaków.

.. _zend.filter.set.alpha:

Alpha
-----

Zwraca łańcuch znaków *$value*, usuwając wszystkie znaki oprócz znaków alfabetu. Filtr posiada także opcję,
służącą do zezwolenia na wystąpienie białych znaków.

.. _zend.filter.set.basename:

BaseName
--------

Gdy podamy łańcuch znaków zawierający ścieżkę do pliku, to filtr zwróci bazową nazwę pliku.

.. _zend.filter.set.digits:

Digits
------

Zwraca łańcuch znaków *$value*, usuwając wszystkie znaki oprócz cyfr.

.. _zend.filter.set.dir:

Dir
---

Zwraca nazwę katalogu gdy podamy ścieżkę do pliku lub katalogu.

.. _zend.filter.set.htmlentities:

HtmlEntities
------------

Zwraca łańcuch znaków *$value*, zamieniając znaki na ich odpowiadające encje HTML, jeśli istnieją.

.. _zend.filter.set.int:

Int
---

Zwraca wartość całkowitą (int) *$value*

.. _zend.filter.set.stripnewlines:

StripNewlines
-------------

Zwraca łańcuch znaków *$value* bez znaków nowej linii.

.. _zend.filter.set.realpath:

RealPath
--------

Rozwiązauje wszystkie dowiązania symboliczne oraz odniesienia do elementów '/./', '/../' oraz '/' w podanej
ścieżce i zwraca absolutną nazwę ścieżki. Zwrócona ścieżka nie będzie posiadała dowiązań
symbolicznych, a także elementów '/./' czy '/../'.

*Zend_Filter_RealPath* zwróci wartość logiczną *FALSE* gdy się to nie uda, np. jeśli plik nie istnieje. W
systemach BSD filtr *Zend_Filter_RealPath* nie zwróci wartośći *FALSE* jeśli tylko ostatnia część ścieżki
nie istnieje, a w pozostałych systemach zwróci wartość *FALSE*.

.. _zend.filter.set.stringtolower:

StringToLower
-------------

Zwraca łańcuch znaków *$value*, zamieniając wszystkie litery na małe.

.. _zend.filter.set.stringtoupper:

StringToUpper
-------------

Zwraca łańcuch znaków *$value*, zamieniając wszystkie litery na wielkie.

.. _zend.filter.set.stringtrim:

StringTrim
----------

Zwraca łańcuch znaków *$value* usuwając znaki na początku oraz na końcu łańcucha.

.. _zend.filter.set.striptags:

StripTags
---------

Filtr zwraca łańcuch znaków z usuniętymi wszystkimi znacznikami HTML oraz PHP, z wyjątkiem tych, których
wystąpienie zostało dozwolone. Oprócz możliwości określenia które znaczniki są dozwolone, programiści
mają także możliwość określenia atrybutów dozwolonych dla wszystkich znaczników, a także atrybutów
dozwolonych dla konkretnych znaczników. Dodatkowo ten filtr pozwala także na kontrolowanie, czy komentarze (np.,
*<!-- ... -->*) mają być usuwane, czy są dozwolone.


