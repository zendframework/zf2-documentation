.. _zend.version.reading:

Odczytywanie wersji Zend Framework
==================================

Stała klasy *Zend_Version::VERSION* zawiera łańcuch znaków, który określa aktualny numer wersji Zend
Framework. Przykładowo może to być "0.9.0beta".

Statyczna metoda *Zend_Version::compareVersion($version)* jest oparta na funkcji `version_compare()`_. Metoda
zwraca -1 gdy wersja ze zmiennej *$version* jest starsza niż wersja Zend Framework, 0 jeśli są takie same, a +1
gdy wersja ze zmiennej *$version* jest nowsza niż wersja Zend Framework.

.. _zend.version.reading.example:

.. rubric:: Przykład użycia metody compareVersion()

.. code-block:: php
   :linenos:

   // zwraca -1, 0 lub 1
   $cmp = Zend_Version::compareVersion('1.0.0');




.. _`version_compare()`: http://php.net/version_compare
