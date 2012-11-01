.. EN-Revision: none
.. _zend.uri.chapter:

Zend_Uri
========

.. _zend.uri.overview:

Wstęp
-----

*Zend_Uri* jest komponentem, który pomaga w manipulowaniu i sprawdzaniu poprawności adresem `Uniform Resource
Identifier`_ (URI). Klasa *Zend_Uri* istnieje głownie aby obsłużyć inne komponenty takie jak na przykład
*Zend\Http\Client* ale także jest użyteczna jako osobne narzędzie.

Adresy URI zawsze zaczynają się nazwą schematu zakończoną średnikiem. Konstrukcje różnych schematów
różnią się od siebie znacząco. Klasa *Zend_Uri* zapewnia fabrykę, która zwracą swoją podklasę
specjalizującą się w danym schemacie. Podklasa będzie nazwana *Zend\Uri\<scheme>*, gdzie *<scheme>* jest nazwą
schematu zamienioną na małe litery z pierwszą literą zamienioną na wielką. Wyjątkiem od tej reguły jest
schemat HTTPS, który także jest obsługiwany przez klasę *Zend\Uri\Http*.

.. _zend.uri.creation:

Tworzenie nowego URI
--------------------

*Zend_Uri* zbuduje nowy URI z szablonu jeśli do metody *Zend\Uri\Uri::factory()* przekazana jest tylko nazwa schematu.

.. _zend.uri.creation.example-1:

.. rubric:: Tworzenie nowego URI za pomocą *Zend\Uri\Uri::factory()*

.. code-block:: php
   :linenos:

   // Aby utworzyć URI z szablonu, przekaż tylko schemat.
   $uri = Zend\Uri\Uri::factory('http');

   // $uri jest instancją Zend\Uri\Http


Aby utworzyć nowy URI z szablonu, przekaż tylko nazwę schematu do metody *Zend\Uri\Uri::factory()* [#]_. Jeśli
przekazana jest nazwa nieobsługiwanego schematu, wyrzucony będzie wyjątek *Zend\Uri\Exception*.

Jeśli schemat lub przekazany URI jest obsługiwany, metoda *Zend\Uri\Uri::factory()* zwróci swoją podklasę, która
specjalizuje się w schemacie który ma zostać utworzony.

.. _zend.uri.manipulation:

Manipulowanie istniejącym URI
-----------------------------

Aby manipulować istniejącym URI, przekaż cały URI do *Zend\Uri\Uri::factory()*.

.. _zend.uri.manipulation.example-1:

.. rubric:: Manipulowanie istniejącym URI za pomocą *Zend\Uri\Uri::factory()*

.. code-block:: php
   :linenos:

   // Aby manipulować istniejącym URI, przekaż go do metody fabryki.
   $uri = Zend\Uri\Uri::factory('http://www.zend.com');

   // $uri jest instancją Zend\Uri\Http


URI zostanie przetworzony i zostanie sprawdzona jego poprawność. Jeśli okaże się, że jest niepoprawny, od
razu zostanie wyrzucony wyjątek *Zend\Uri\Exception*. W przeciwnym wypadku, metoda *Zend\Uri\Uri::factory()* zwróci
swoją podklasę specjalizującą się w schemacie URI, którym chcemy manipulować.

.. _zend.uri.validation:

Sprawdzanie poprawności URI
---------------------------

Funkcja *Zend\Uri\Uri::check()* może być użyta jeśli potrzebne jest tylko sprawdzenie poprawności istniejącego
URI.

.. _zend.uri.validation.example-1:

.. rubric:: Sprawdzanie poprawności URI za pomocą *Zend\Uri\Uri::check()*

.. code-block:: php
   :linenos:

   // Sprawdź czy podany URI ma poprawny format
   $valid = Zend\Uri\Uri::check('http://uri.in.question');

   // $valid ma wartość TRUE dla poprawnego URI, lub FALSE w przeciwnym wypadku.


*Zend\Uri\Uri::check()* zwraca wartość logiczną, co jest bardziej wygodne niż używanie *Zend\Uri\Uri::factory()* i
wyłapywanie wyjątku.

.. _zend.uri.instance-methods:

Wspólne metody instancji
------------------------

Każda instancja podklasy *Zend_Uri* (np. *Zend\Uri\Http*) ma kilka metod, ktore są użyteczne do pracy z rożnego
rodzaju URI.

.. _zend.uri.instance-methods.getscheme:

Pobieranie schematu URI
^^^^^^^^^^^^^^^^^^^^^^^

Nazwa schematu URI jest częścią URI, która znajduje się przed dwukropkiem. Na przykład nazwą schematu adresu
*http://www.zend.com* jest *http*.

.. _zend.uri.instance-methods.getscheme.example-1:

.. rubric:: Pobieranie schematu z obiektu *Zend\Uri\**

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\Uri::factory('http://www.zend.com');

   $scheme = $uri->getScheme();  // "http"


Metoda *getScheme()* zwraca tylko schemat z obiektu URI.

.. _zend.uri.instance-methods.geturi:

Pobieranie całego URI
^^^^^^^^^^^^^^^^^^^^^

.. _zend.uri.instance-methods.geturi.example-1:

.. rubric:: Pobieranie całego URI z obiektu *Zend\Uri\**

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\Uri::factory('http://www.zend.com');

   echo $uri->getUri();  // "http://www.zend.com"


Metoda *getUri()* zwraca reprezentację całego URI jako łańcuch znaków.

.. _zend.uri.instance-methods.valid:

Sprawdzanie poprawności URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Zend\Uri\Uri::factory()* zawsze sprawdzi poprawność przekazanego do niej URI i nie utworzy nowej instancji podklasy
*Zend_Uri* jeśli podany adres URI jest niepoprawny. Jakkolwiek, po tym jak zostanie utworzona instancja podklasy
*Zend_Uri* dla nowego URI lub dla poprawnego istniejącego, możliwe jest to, że URI później może stać się
niepoprawny, po tym jak będziemy nim manipulować.

.. _zend.uri.instance-methods.valid.example-1:

.. rubric:: Sprawdzanie poprawności obiektu *Zend\Uri\**

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\Uri::factory('http://www.zend.com');

   $isValid = $uri->valid();  // TRUE


Metoda *valid()* zapewnia możliwość sprawdzenia czy obiekt URI jest wciąż poprawny.



.. _`Uniform Resource Identifier`: http://www.w3.org/Addressing/

.. [#] Obecnie, Zend_Uri obsługuje tylko schematy HTTP oraz HTTPS.