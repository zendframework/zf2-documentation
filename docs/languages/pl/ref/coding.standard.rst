.. EN-Revision: none
.. _coding-standard:

**********************************
Standardy kodowania Zend Framework
**********************************

.. _coding-standard.overview:

Wstęp
-----

.. _coding-standard.overview.scope:

Zakres
^^^^^^

Ten dokument określa wytyczne dla programistów i zespołów tworzących Zend Framework lub tworzących aplikacje
w oparciu o Zend Framework. Wielu programistów używających Zend Framework uważa też za przydatne te standardy
kodowania ponieważ dzięki nim ich styl kodowania pozostaje zgodny z całym kodem Zend Framework. Warto też
zaznaczyć, że określenie standardów kodowaia wymaga znacznego wysiłku. Uwaga: Czasem programiści uważają,
że trzymanie się standardu jest ważniejsze od samej treści i idei standardu. Przewodnik po standardach
kodowania Zend Framework pokazuje najlepsze praktyki jakie mogą być stosowane w projekcie ZF. Możesz
modyfikować te standardy lub użyć ich w takiej postaci w jakiej są, ale musisz to zrobić zgodnie z
`licencją`_

Do poruszonych tematów należą:



   - Formatowanie plików PHP

   - Konwencje nazewnictwa

   - Styl kodowania

   - Dokumentacja



.. _coding-standard.overview.goals:

Cele
^^^^

Standardy kodowania są ważne w każdym projekcie programistycznym, a szczególnie gdy przy tym samym projekcie
pracuje większa ilość programistów. Standardy kodowania pomagają zapewnić wysoką jakość kodu, mniejszą
ilość błędów i łatwe zarządzanie.

.. _coding-standard.php-file-formatting:

Formatowanie plików PHP
-----------------------

.. _coding-standard.php-file-formatting.general:

Ogólnie
^^^^^^^

Dla plików zawierających tylko kod PHP użycie znacznika zamykającego ("?>") jest niedozwolone. Znacznik ten nie
jest wymagany przez PHP, a pominięcie go zapobiega przypadkowemu dołączeniu białych znaków do strumienia
wyjściowego.

**WAŻNE:** Dołączanie binarnych danych, na które pozwala funkcja *__HALT_COMPILER()* jest zabronione w plikach
projektów Zend Framework oraz w plikach od nich pochodzących. Użycie tej funkcjonalności jest dozwolone tylko w
specjalnych skryptach instalacyjnych.

.. _coding-standard.php-file-formatting.indentation:

Wcięcie
^^^^^^^

Wcięcia powinny składać się z 4 spacji. Znaki tabulatora są niedozwolone.

.. _coding-standard.php-file-formatting.max-line-length:

Maksymalna długość linii
^^^^^^^^^^^^^^^^^^^^^^^^

Zalecana maksymalna długość linii wynosi 80 znaków, czyli programiści powinni starać się aby długość
linii była bliska tej wartości jak to tylko możliwe. Jednak linie dłuższe są akceptowalne. Maksymalna
długość linii zawierającej kod PHP wynosi 120 znaków.

.. _coding-standard.php-file-formatting.line-termination:

Zakończenia linii
^^^^^^^^^^^^^^^^^

Linie powinny być zakończone w standardowy sposób systemu Unix dla plików tekstowych. Linie powinny kończyć
się tylko znakiem konca linii. Znaki końca linii są reprezentowane przez liczbę dziesiętną 10, lub
szesnastkową 0x0A.

Nie używaj znaku powrotu karetki (CR) tak jak to robią komputery z systemem Mac OS X (0x0D) lub kombinacji znaku
powrotu karetki i końca linii (CRLF) tak jak to robią komputery z systemem Windows (0x0D, 0x0A).

.. _coding-standard.naming-conventions:

Konwencje nazewnictwa
---------------------

.. _coding-standard.naming-conventions.classes:

Klasy
^^^^^

Zend Framework używa takiej konwencji nazewnictwa, w której nazwy klas bezpośrednio odpowiadają katalogom, w
których się znajdują. Głównym katalogiem standardowej biblioteki ZF jest katalog "Zend/", a głównym
katalogiem dodatkowej biblioteki ZF jest katalog "ZendX". Wszystkie klasy Zend Framework są przechowywanie
hierarchicznie w tych katalogach.

Nazwy klas mogą zawierać tylko znaki alfanumeryczne. Liczby są dozwolone w nazwach klas, jednak ich użycie jest
odradzane w większości przypadków. Użycie znaków podkreślenia jest dozwolone tylko w przypadku gdy są
separatorami ścieżek; plik "Zend/Db/Table.php" musi odpowiadać nazwie klasy "Zend_Db_Table".

Jeśli nazwa klasy składa się z więcej niż jednego słowa, pierwsza litera każdego kolejnego słowa powinna
być wielka. Zapisanie wyrazów w całości wielkimi literami jest niedozwolone, przykładowo nazwa klasy
"Zend_PDF" jest niedozwolona, a nazwa "Zend_Pdf" jest już akceptowalna.

Te konwencje określają mechanizm pseudo-przestrzeni nazw dla Zend Framework. Zend Framework będzie używać
funkcjonalności przestrzeni nazw PHP gdy będą już dostępne dla programistów do użycia w swoich aplikacjach.

Zobacz nazwy klas znajdujące się w standardowej lub dodatkowej bibliotece aby zobaczyć przykłady konwencji
nazewnictwa klas. **WAŻNE:** Kod który musi być rozwijany wraz bibliotekami ZF, a nie jest częścią
standardowych lub dodatkowych bibliotek (np. kod aplikacji lub biblioteki nie rozpowszechniane przez firmę Zend)
nigdy nie może zaczynać się przedrostkiem "Zend\_" oraz "ZendX\_".

.. _coding-standard.naming-conventions.filenames:

Nazwy plików
^^^^^^^^^^^^

W nazwach innych plików dozwolone jest użycie jedynie znaków alfanumerycznych, znaków podkreślenia ("\_") oraz
myślnika ("-"). Użycie spacji jest zabronione.

Nazwa każdego pliku zawierającego jakikolwiek kod PHP powinna być zakończona rozszerzeniem ".php", nie dotyczy
to skryptów widoków. Poniższe przykłady pokazują akceptowalne nazwy plików zawierających klasy Zend
Framework:

   .. code-block:: php
      :linenos:

      Zend/Db.php

      Zend/Controller/Front.php

      Zend/View/Helper/FormRadio.php


Nazwy plików powinny odpowiadać nazwom klas, tak jak to pokazano powyżej.

.. _coding-standard.naming-conventions.functions-and-methods:

Funkcje i metody
^^^^^^^^^^^^^^^^

Nazwy funkcji mogą zawierać tylko znaki alfanumeryczne. Znaki podkreślenia są niedozwolone. Użycie liczb w
nazwach funkcji jest dozwolone, ale odradzane w większości przypadków.

Nazwy funkcji zawsze muszą zaczynać się małą literą. Jeśli nazwa funkcji składa się z więcej niż jednego
wyrazu, pierwsza litera każdego następnego wyrazu powinna być wielka. Jest to powszechnie zwane formatowaniem
"camelCase".

Zalecane jest dobieranie szczegółowych nazw funkcji. Powinny one być tak szczegółowe, jak to możliwe, aby w
pełni opisać ich zachowanie i zastosowanie.

Oto przykłady akceptowalnych nazw funkcji:

   .. code-block:: php
      :linenos:

      filterInput()

      getElementById()

      widgetFactory()




W programowaniu zorientowanym obiektowo metody dostępowe dla instancji lub statycznych zmiennych powinny zawsze
zaczynać się od słów "get" lub "set". Jeśli implementujesz wzorzec projektowy, na przykład wzorzec
"singleton" lub "factory", nazwa metody powinna zawierać nazwę wzorca, dzięki czemu wzorzec będzie można
łatwo rozpoznać.

Pierwszy znak w nazwach metod zadeklarowanych jako "private" lub "protected" musi być znakiem podkreślenia. Jest
to jedyne akceptowalne użycie podkreślenia w nazwach metod. Metody zadeklarowane jako "public" nigdy nie powinny
zawierać znaku podkreślenia.

Definiowanie funkcji w przestrzeni globalnej (tzw. "latające funkcje") jest dozwolone, ale odradzane w
większości przypadków. Zalecane jest, aby takie funkcje były ujęte w statycznej klasie.

.. _coding-standard.naming-conventions.variables:

Zmienne
^^^^^^^

Nazwy zmiennych mogą zawierać tylko znaki alfanumeryczne. Znaki podkreślenia są niedozwolone. Użycie liczb w
nazwach zmiennych jest dozwolone, ale odradzane w większości przypadków.

Nazwy zmiennych instancji, które są zadeklarowane używając modyfikatora "private" lub "protected", powinny
zaczynać się od znaku podkreślenia. Jest to jedyny dozwolony przypadek użycia znaków podkreślenia w nazwach
funkcji. Zmienne klas zadeklarowane jako "public" nie mogą nigdy zaczynac się od znaku podkreślenia.

Tak jak nazwy funkcji (zobacz powyżej sekcję 3.3), nazwy zmiennych muszą się zawsze zaczynać małą literą i
muszą być zgodne z metodą "camelCaps".

Zalecane jest dobieranie szczegółowych nazw zmiennych. Powinny one być tak szczegółowe, jak to możliwe, aby w
pełni opisać dane które programista wewnątrz nich przechowuje. Lakoniczne nazwy zmiennych takie jak "$i" czy
"$n" są odradzane, ich użycie jest dopuszczalne tylko w kontekście najkrótszych pętli. Jeśli pętla zawiera
więcej niż 20 linii kodu, nazwy indeksów powinny być bardziej opisowe.

.. _coding-standard.naming-conventions.constants:

Stałe
^^^^^

Nazwy stałych mogą zawierać znaki alfanumeryczne oraz znaki podkreślenia. Liczby są dozwolone w nazwach
stałych.

Nazwy stałych powinny składać się tylko z wielkich liter.

Aby zwiększyć czytelność, słowa w nazwach stałych muszą być oddzielone znakiem podkreślenia. Na przykład,
nazwa stałej *EMBED_SUPPRESS_EMBED_EXCEPTION* jest dozwolona, a nazwa *EMBED_SUPPRESSEMBEDEXCEPTION* nie jest.

Stałe muszą być definiowane jako stałe klas przez użycie konstrukcji "const". Definiowanie stałych w
przestrzeni globalnej za pomocą konstrukcji "define" jest dozwolone, ale odradzane.

.. _coding-standard.coding-style:

Styl kodowania
--------------

.. _coding-standard.coding-style.php-code-demarcation:

Odgraniczanie kodu PHP
^^^^^^^^^^^^^^^^^^^^^^

Kod PHP musi być zawsze odgraniczony za pomocą pełnych, standardowych znaczników PHP:

   .. code-block:: php
      :linenos:

      <?php

      ?>




Użycie skróconej wersji znaczników jest niedozwolone. Pliki, które zawierają tylko kod PHP, nie powinny nigdy
być zakończone znacznikiem zamykającym (Zobacz :ref:` <coding-standard.php-file-formatting.general>`).

.. _coding-standard.coding-style.strings:

Łańcuchy znaków
^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.strings.literals:

Proste łańcuchy znaków
^^^^^^^^^^^^^^^^^^^^^^

Kiedy łańcuch znaków jest prosty (nie zawiera podstawienia zmiennych), do jego odgraniczenia powinien zostać
użyty pojedynczy cudzysłów (apostrof):

   .. code-block:: php
      :linenos:

      $a = 'Example String';




.. _coding-standard.coding-style.strings.literals-containing-apostrophes:

Proste łańcuchy znaków zawierające apostrofy
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Kiedy prosty łańcuch znaków zawiera wewnątrz apostrofy, dozwolone jest odgraniczenie łańcucha za pomocą
cudzysłowów (podwójnych). Jest to szczególnie przydatne w wyrażeniach SQL:

   .. code-block:: php
      :linenos:

      $sql = "SELECT `id`, `name` from `people` WHERE `name`='Fred' OR `name`='Susan'";


Ta składnia jest zalecana w przeciwieństwie do zabezpieczenia apostrofów znakami ukośnika.

.. _coding-standard.coding-style.strings.variable-substitution:

Podstawienia zmiennych
^^^^^^^^^^^^^^^^^^^^^^

Podstawienia zmiennych są dozwolone na dwa sposoby:

   .. code-block:: php
      :linenos:

      $greeting = "Hello $name, welcome back!";

      $greeting = "Hello {$name}, welcome back!";




Dla zachowania spójności, taka forma jest niedozwolona:

   .. code-block:: php
      :linenos:

      $greeting = "Hello ${name}, welcome back!";




.. _coding-standard.coding-style.strings.string-concatenation:

Łączenie łańcuchów znaków
^^^^^^^^^^^^^^^^^^^^^^^^^

Łańcuchy znaków mogą być łączone za pomocą operatora ".". Przed i za znakiem "." zawsze powinniśmy dodać
znak odstępu:

   .. code-block:: php
      :linenos:

      $company = 'Zend' . 'Technologies';




Kiedy łączymy łańcuchy znaków za pomocą operatora ".", zalecane jest podzielenie wyrażenia na wiele linii w
celu zwiększenia czytelności. W takich przypadkach, każda linia powinna być wcięta za pomocą znaków odstępu
aby wszystkie operatory "." leżały w jednej linii pod znakiem "=":

   .. code-block:: php
      :linenos:

      $sql = "SELECT `id`, `name` FROM `people` "
           . "WHERE `name` = 'Susan' "
           . "ORDER BY `name` ASC ";




.. _coding-standard.coding-style.arrays:

Tablice
^^^^^^^

.. _coding-standard.coding-style.arrays.numerically-indexed:

Tablice indeksowane numerycznie
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Niedozwolone jest użycie ujemnych liczb jako indeksów tabel.

Indeksowana tablica powinna zaczynać się od nieujemnej liczby, jednak liczby inne niż 0 jako pierwszy indeks są
odradzane.

Kiedy deklarujesz indeksowaną numerycznie tablicę za pomocą funkcji *array*, powinieneś dodać znak odstępu po
każdym przecinku w celu zwiększenia czytelności:

   .. code-block:: php
      :linenos:

      $sampleArray = array(1, 2, 3, 'Zend', 'Studio');




Dozwolone jest deklarowanie tablic indeksowanych numerycznie w wielu wierszach używając konstrukcji "array". W
takim przypadku, każdy następny wiersz musi być dopełniony, znakami odstępu aby początki wierszy były
wyrównane:

   .. code-block:: php
      :linenos:

      $sampleArray = array(1, 2, 3, 'Zend', 'Studio',
                           $a, $b, $c,
                           56.44, $d, 500);




.. _coding-standard.coding-style.arrays.associative:

Tablice asocjacyjne
^^^^^^^^^^^^^^^^^^^

Kiedy deklarujesz tablice asocjacyjne za pomocą konstrukcji *array* zalecane jest rozbicie wyrażenia na wiele
wierszy. W takim przypadku każdy następny wiersz powinien być dopełniony znakami odstępu, aby klucze i
wartości były wyrównane:

   .. code-block:: php
      :linenos:

      $sampleArray = array('firstKey'  => 'firstValue',
                           'secondKey' => 'secondValue');




.. _coding-standard.coding-style.classes:

Klasy
^^^^^

.. _coding-standard.coding-style.classes.declaration:

Deklaracja klas
^^^^^^^^^^^^^^^

Klasy powinny być nazywane zgodnie z konwencjami Zend Framework.

Klamra otwierająca klasę powinna zawsze znajdować się w linii pod nazwą klasy (styl "one true brace").

Każda klasa musi posiadać blok dokumentacji zgodny ze standardem PHPDocumentor.

Każdy kod wewnątrz klasy musi być wcięty na cztery spacje.

Tylko jedna klasa dozwolona jest w jednym pliku PHP.

Umieszczanie dodatkowego kodu w pliku klasy jest dozwolone, ale odradzane. W takich plikach dwie puste linie muszą
oddzielać kod klasy od dodatkowego kodu PHP w pliku.

Oto przykład poprawnej deklaracji klasy:

   .. code-block:: php
      :linenos:

      /**
       * Blok dokumentacji
       */
      class SampleClass
      {
          // cała zawartość klasy musi
          // być wcięta na cztery spacje
      }




.. _coding-standard.coding-style.classes.member-variables:

Zmienne klas
^^^^^^^^^^^^

Zmienne klas powinny być nazywane zgodnie z poniższymi konwencjami.

Wszystkie zmienne muszą być deklarowane na samym początku klasy, przed zadeklarowaniem jakichkolwiek funkcji.

Użycie konstrukcji *var* jest niedozwolone. Zawsze deklarujemy widoczność zmiennych klas za pomocą jednej z
konstrukcji: *private*, *protected*, lub *public*. Uzyskiwanie dostępu do zmiennych klas bezpośrednio poprzez
ustawienie ich jako publicznych jest dozwolone, ale odradzane na rzecz metod dostępowych (set/get).

.. _coding-standard.coding-style.functions-and-methods:

Funkcje i metody
^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.functions-and-methods.declaration:

Deklaracja funkcji oraz metod
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Funkcje powinny być nazywane zgodnie z poniższymi konwencjami.

Funkcje wewnątrz klas zawsze muszą mieć zadeklarowaną dostępność za pomocą konstrukcji *private*,
*protected*, lub *public*.

Tak jak w klasach, klamra otwierająca powinna zawsze znajdować się w linii pod nazwą funkcji (styl "one true
brace"). Nie powinno być odstępu między nazwą funkcji a otwierającym nawiasem argumentów.

Deklarowanie funkcji w przestrzeni globalnej jest odradzane.

Oto przykład poprawnej deklaracji funkcji w klasie:

   .. code-block:: php
      :linenos:

      /**
       * Blok dokumentacji
       */
      class Foo
      {
          /**
           * Blok dokumentacji
           */
          public function bar()
          {
              // cała zawartość funkcji musi
              // być wcięta na cztery spacje
          }
      }




**UWAGA:** Przekazywanie przez referencję dozwolone jest tylko podczas deklaracji funkcji:

   .. code-block:: php
      :linenos:

      /**
       * Blok dokumentacji
       */
      class Foo
      {
          /**
           * Blok dokumentacji
           */
          public function bar(&$baz)
          {}
      }




Przekazywanie przez referencję podczas wywołania jest zabronione.

Zwracana wartość nie może być objęta cudzysłowami. To mogłoby zmniejszyć czytelność kodu i może
spowodować, że przestanie on działać, jeśli metoda w przyszłości będzie zwracać referencję.

   .. code-block:: php
      :linenos:

      /**
       * Blok dokumentacji
       */
      class Foo
      {
          /**
           * ŹLE
           */
          public function bar()
          {
              return($this->bar);
          }

          /**
           * DOBRZE
           */
          public function bar()
          {
              return $this->bar;
          }
      }




.. _coding-standard.coding-style.functions-and-methods.usage:

Użycie funkcji oraz metod
^^^^^^^^^^^^^^^^^^^^^^^^^

Argumenty funkcji powinny być oddzielone jednym znakiem odstępu po przecinku. To jest przykład poprawnego
wywołania funkcji przyjmującej trzy argumenty:

   .. code-block:: php
      :linenos:

      threeArguments(1, 2, 3);




Przekazywanie przez referencję w czasie wywołania jest zabronione. Zobacz sekcję opisującą sposób deklaracji
funkcji, aby poznać prawidłowy sposób przekazywania argumentów przez referencję.

Funkcje które przyjmują tablice jako argumenty, mogą zawierać konstrukcję "array" i mogą być rozdzielone na
wiele linii w celu zwiększenia czytelności. W tych przypadkach wciąż obowiązuje standard dla tablic:

   .. code-block:: php
      :linenos:

      threeArguments(array(1, 2, 3), 2, 3);

      threeArguments(array(1, 2, 3, 'Zend', 'Studio',
                           $a, $b, $c,
                           56.44, $d, 500), 2, 3);




.. _coding-standard.coding-style.control-statements:

Instrukcje kontrolne
^^^^^^^^^^^^^^^^^^^^

.. _coding-standard.coding-style.control-statements.if-else-elseif:

If/Else/Elseif
^^^^^^^^^^^^^^

Wyrażenia kontrolne oparte o konstrukcje *if* oraz *elseif* muszą posiadać jeden znak odstępu przed nawiasem
otwierającym warunek i jeden znak odstępu za nawiasem zamykającym.

Instrukcje warunkowe znajdujące się pomiędzy nawiasami muszą być odgraniczone znakami odstępu. Do grupowania
większych warunków zalecane jest użycie dodatkowych nawiasów.

Klamrowy nawias otwierający powinien znajdować się w tej samej linii co warunek. Nawias zamykający zawsze
powinien znajdować się w osobnej nowej linii. Zawartość znajdująca się między nawiasami klamrowymi musi być
wcięta za pomocą czterech znaków odstępu.

   .. code-block:: php
      :linenos:

      if ($a != 2) {
          $a = 2;
      }




Formatowanie instrukcji "if", które zawierają instrukcję "elseif" lub "else", powinno wyglądać tak jak w
poniższym przykładzie:

   .. code-block:: php
      :linenos:

      if ($a != 2) {
          $a = 2;
      } else {
          $a = 7;
      }

      if ($a != 2) {
          $a = 2;
      } elseif ($a == 3) {
          $a = 4;
      } else {
          $a = 7;
      }


W pewnych okolicznościach PHP pozwala na zapisanie tych wyrażeń bez nawiasów. Standard kodowania wymaga, aby
wszystkie wyrażenia "if", "elseif" oraz "else" używały nawiasów.

Użycie instrukcji "elseif" jest dozwolone ale mocno odradzane. Zamiast tej instrukcji zalecane jest użycie
kombinacji "else if".

.. _coding-standards.coding-style.control-statements.switch:

Instrukcja Switch
^^^^^^^^^^^^^^^^^

Instrukcje kontrolne umieszczone wewnątrz instrukcji "switch" muszą posiadać pojedynczy znak odstępu zarówno
przed nawiasem jak i za nim.

Cała zawartość wewnątrz instrukcji "switch" musi być wcięta na cztery spacje. Zawartość każdej instrukcji
"case" musi być wcięta na kolejne cztery spacje.

.. code-block:: php
   :linenos:

   switch ($numPeople) {
       case 1:
           break;

       case 2:
           break;

       default:
           break;
   }


Konstrukcja *default* powinna zawsze znaleźć się wewnątrz konstrukcji *switch*.

**UWAGA:** W niektórych przypadkach przydatne jest zapisanie jednej klauzuli *case*, po której sterowanie powinno
przejść do następnej klauzuli *case* poprzez nie umieszczanie polecenia *break* lub *return* w wyjściowym
*case*. Aby odróżnić takie sytuacje od niezamierzonych błędów, wszystkie instrukcje *case* których
intencjonalnie pozbawiono *break* lub *return* muszą zawierać komentarz: "// break intentionally omitted".

.. _coding-standards.inline-documentation:

Dokumentacja
^^^^^^^^^^^^

.. _coding-standards.inline-documentation.documentation-format:

Format dokumentacji
^^^^^^^^^^^^^^^^^^^

Wszystkie bloki dokumentacji muszą być kompatybilne z formatem phpDocumentor. Opisywanie formatu phpDocumentor
jest poza zakresem tego dokumentu. Aby uzyskać więcej informacji, odwiedź: `http://phpdoc.org/`_

Każdy plik źródłowy napisany dla Zend Framework lub działający w oparciu o framework musi posiadać na
początku pliku ogólny blok dokumentacji dla danego pliku oraz blok dokumentacji dla klasy bezpośrednio przed jej
deklaracją. Poniżej są przykłady takich bloków:

.. _coding-standards.inline-documentation.files:

Pliki
^^^^^

Każdy plik zawierający kod PHP musi na samym początku posiadać blok dokumentacji zawierający przynajmniej
następujące znaczniki standardu phpDocumentor:

   .. code-block:: php
      :linenos:

      /**
       * Short description for file
       *
       * Long description for file (if any)...
       *
       * LICENSE: Some license information
       *
       * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
       * @license    http://framework.zend.com/license   BSD License
       * @link       http://framework.zend.com/package/PackageName
       * @since      File available since Release 1.5.0
      */




.. _coding-standards.inline-documentation.classes:

Klasy
^^^^^

Każda klasa musi posiadać blok dokumentacji zawierający przynajmniej następujące znaczniki standardu
phpDocumentor:

   .. code-block:: php
      :linenos:

      /**
       * Short description for class
       *
       * Long description for class (if any)...
       *
       * @copyright  Copyright (c) 2005-2012 Zend Technologies USA Inc. (http://www.zend.com)
       * @license    http://framework.zend.com/license   BSD License
       * @version    Release: @package_version@
       * @link       http://framework.zend.com/package/PackageName
       * @since      Class available since Release 1.5.0
       * @deprecated Class deprecated in Release 2.0.0
       */




.. _coding-standards.inline-documentation.functions:

Funkcje
^^^^^^^

Każda funkcja, a także metoda obiektu, musi posiadać blok dokumentacji zawierający przynajmniej następujące
znaczniki standardu phpDocumentor:



   - Opis funkcji

   - Opis wszystkich argumentów

   - Opis wszystkich możliwych zwracanych wartości



Nie jest konieczne użycie znacznika "@access" ponieważ poziom dostępu jest znany dzięki konstrukcji "public",
"private", lub "protected" użytej podczas deklaracji funkcji.

Jeśli funkcja/metoda może wyrzucać wyjątek, użyj znacznika "@throws":

   .. code-block:: php
      :linenos:

      @throws exceptionclass [opis wyjątku]






.. _`licencją`: http://framework.zend.com/license
.. _`http://phpdoc.org/`: http://phpdoc.org/
