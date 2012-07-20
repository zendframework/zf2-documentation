.. _zend.validate.set:

Standardowe klasy weryfikatorów
===============================

Zend Framework posiada standardowy zestaw gotowych do użycia klas weryfikatorów.

.. _zend.validate.set.alnum:

Alnum
-----

Zwraca wartość *true* tylko wtedy, gdy wartość *$value* zawiera tylko znaki alfabetu oraz cyfry. Ten
weryfikator posiada także opcję, służącą do określenia, czy białe znaki mąją być uznane za prawidłowe.

.. _zend.validate.set.alpha:

Alpha
-----

Zwraca wartość *true* tylko wtedy, gdy wartość *$value* zawiera tylko znaki alfabetu. Ten weryfikator posiada
także opcję, służącą do określenia, czy białe znaki mąją być uznane za prawidłowe.

.. _zend.validate.set.barcode:

Barcode
-------

Ten weryfikator jest pomocny przy sprawdzaniu poprawności wartości kodu kreskowego. Obecnie obsługuje standardy
"*UPC-A*" (Universal Product Code) oraz "*EAN-13*" (European Article Number). Metoda *isValid()* zwraca wartość
*true* tylko w przypadku poprawnej weryfikacji poprzez algorytm kodów kreskowych. Powinieneś usunąć wszystkie
znaki nie będące cyframi od zera do dziewiątki (0-9) przed podaniem wartości do weryfikatora.

.. _zend.validate.set.between:

Between
-------

Zwraca wartość *true* tylko wtedy, gdy wartość *$value* znajduje się pomiędzy minimalną a maksymalną
zadaną graniczną wartością. Porównanie domyślnie nie jest ostre (wartość *$value* może być równa
granicznej wartości), ale może być to nadpisane w celu uzyskania ścisłego porównania, w którym wartość
*$value* musi być ściśle większa od wartości minimalnej i ściśle mniejsza od wartości maksymalnej.

.. _zend.validate.set.ccnum:

Ccnum
-----

Zwraca wartość *true* tylko wtedy, gdy wartość *$value* jest prawidłowym numerem karty kredytowej według
algorytmu Luhn'a (suma kontrolna mod-10).

.. _zend.validate.set.date:

Date
----

Zwraca wartość *true* jeśli wartość *$value* jest poprawną datą w formacie *YYYY-MM-DD*. Jeśli podano
opcjonalny parametr *locale* wtedy data będzie sprawdzana zgodnie z podaną lokalizacją. Dodatkowo jeśli podano
opcjonalny parametr *format* będzie on podstawą do sprawdzenia poprawności daty. Sprawdź
:ref:`Zend_Date::isDate() <zend.date.others.comparison.table>` aby uzyskać szczegóły opcjonalnych parametrów.

.. _zend.validate.set.digits:

Digits
------

Zwraca wartość *true* tylko wtedy, gdy wartość *$value* zawiera tylko cyfry.

.. include:: zend.validate.email-address.rst
.. _zend.validate.set.float:

Float
-----

Zwraca wartość *true* tylko wtedy, gdy wartość *$value* jest wartością zmiennoprzecinkową.

.. _zend.validate.set.greater_than:

GreaterThan
-----------

Zwraca wartość *true* tylko wtedy, gdy wartość *$value* jest większa od zadanej minimalnej granicznej
wartości.

.. _zend.validate.set.hex:

Hex
---

Zwraca wartość *true* tylko wtedy, gdy wartość *$value* zawiera tylko znaki szesnastkowe.

.. include:: zend.validate.hostname.rst
.. _zend.validate.set.in_array:

InArray
-------

Zwraca wartość *true* tylko wtedy gdy wartość *$value* znajduje się w zadanej tablicy. Jeśli opcja ścisłego
sprawdzania ma wartość *true*, wtedy typ wartości *$value* jest także sprawdzany.

.. _zend.validate.set.int:

Int
---

Zwraca wartość *true* tylko wtedy, gdy wartość *$value* jest poprawną wartością całkowitą.

.. _zend.validate.set.ip:

Ip
--

Zwraca wartość *true* tylko wtedy, gdy wartość *$value* jest poprawnym adresem IP.

.. _zend.validate.set.less_than:

LessThan
--------

Zwraca wartość *true* tylko wtedy, gdy wartość *$value* jest mniejsza od zadanej maksymalnej granicznej
wartości.

.. _zend.validate.set.not_empty:

NotEmpty
--------

Zwraca wartość *true* tylko wtedy, gdy wartość *$value* nie jest pustą wartością.

.. _zend.validate.set.regex:

Regex
-----

Zwraca wartość *true* tylko wtedy, gdy wartość *$value* pasuje do zadanego wyrażenia regularnego.

.. _zend.validate.set.string_length:

StringLength
------------

Zwraca wartość *true* tylko wtedy gdy długość łańcucha znaków *$value* jest większa lub równa od zadanej
wartośći minimalnej i mniejsza lub równa od zadanej wartości maksymalnej. (wtedy gdy zadana wartość
maksymalna jest różna od *null*). Od wersji 1.5.0 metoda *setMin()* wyrzuca wyjątek jeśli zadana wartość
minimalna jest ustawiona na wartość większą od zadanej wartości maksymalnej, a metoda *setMax()* wyrzuca
wyjątek jeśli zadana wartość maksymalna jest ustawiona na wartość mniejszą od zadanej wartości minimalnej.
Od wersji 1.0.2, ta klasa obsługuje UTF-8 i inne kodowania znaków, w oparciu o obecną wartość dyrektywy
`iconv.internal_encoding`_.



.. _`iconv.internal_encoding`: http://www.php.net/manual/en/ref.iconv.php#iconv.configuration
