.. EN-Revision: none
.. _zend.cache.frontends:

Frontendy Zend_Cache
====================

.. _zend.cache.core:

Zend_Cache_Core
---------------

.. _zend.cache.core.introduction:

Wprowadzenie
^^^^^^^^^^^^

``Zend_Cache_Core`` jest specjalnym frontendem ponieważ jest on jądrem modułu. Jest on podstawowym frontendem
bufora i jest rozszerzany przez inne klasy.

.. note::

   Wszystkie frontendy dziedziczą z klasy ``Zend_Cache_Core`` więc jej metody i opcje (opisane niżej) są także
   dostępne w innych frontendach, dlatego nie będą tu opisane.

.. _zend.cache.core.options:

Dostępne opcje
^^^^^^^^^^^^^^

Te opcje są przekazywane do metody fabryki jako pokazano w poprzednich przykładach.

.. _zend.cache.frontends.core.options.table:

.. table:: Dostępne opcje

   +-------------------------+----------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Opcja                    |Typ danych|Domyślna wartość|Opis                                                                                                                                                                                                                                                                                                                                                                                                                                       |
   +=========================+==========+================+===========================================================================================================================================================================================================================================================================================================================================================================================================================================+
   |caching                  |Boolean   |TRUE            |włącza / wyłącza buforowanie (może być użyteczne do sprawdzania buforowanych skryptów)                                                                                                                                                                                                                                                                                                                                                     |
   +-------------------------+----------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_id_prefix          |String    |NULL            |określa rzedrostek dla wszystkich identyfikatorów bufora, jeśli ma wartość NULL, nie będzie użyty żaden przedrostek. Przedrostek identyfikatorów zasadniczo tworzy przestrzeń nazw dla buforu, pozwalając na korzystanie z dzielonego bufora przez kilka aplikacji czy serwisów internetowych. Każda aplikacja czy serwis internetowy powinny używać innego przedrostka, więc określone identyfikatory będą mogły być użyte więcej niż raz.|
   +-------------------------+----------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |lifetime                 |Integer   |3600            |okres ważności bufora (w sekundach), jeśli ustawiony na NULL, bufor będzie ważny na zawsze                                                                                                                                                                                                                                                                                                                                                 |
   +-------------------------+----------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |logging                  |Boolean   |FALSE           |jeśli ma wartość true, aktywowane jest logowanie za pomocą Zend_Log is activated (ale system jest wolniejszy)                                                                                                                                                                                                                                                                                                                              |
   +-------------------------+----------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |write_control            |Boolean   |TRUE            |Włącza / wyłącza kontrolę zapisu (bufor jest odczytywany zaraz po zapisaniu aby wykryć uszkodzone wpisy), włączając kontrolę zapisu lekko zwolniesz zapisywanie bufora, ale nie będzie to miało wpływu na jego odczytywanie (może to wykryć niektóre uszkodzone pliki bufora, ale nie jest to perfekcyjna kontrola)                                                                                                                        |
   +-------------------------+----------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automatic_serialization  |Boolean   |FALSE           |Włącza / wyłącza serializację, może być użyte do bezpośredniego zapisywania danych, które nie są łańcuchami znaków (ale jest to wolniejsze)                                                                                                                                                                                                                                                                                                |
   +-------------------------+----------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automatic_cleaning_factor|Integer   |10              |Włącza / ustawia proces automatycznego czyszczenia (garbage collector): 0 oznacza brak automatycznego czyszczenia, 1 oznacza systematyczne czyszczenie bufora, a x > 1 oznacza automatyczne losowe czyszczenie 1 raz na x operacji zapisu.                                                                                                                                                                                                 |
   +-------------------------+----------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |ignore_user_abort        |Boolean   |FALSE           |jeśli ma wartość true, komponent ustawi flagę PHP ignore_user_abort wewnątrz metody save() aby zapobiec uszkodzeniom buforu w niektórych przypadkach                                                                                                                                                                                                                                                                                       |
   +-------------------------+----------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.core.examples:

Przykłady
^^^^^^^^^

Przykład jest podany w dokumentacji na samym początku.

Jeśli w buforze przechowujesz tylko łańcuchy znakow (ponieważ z opcją "automatic_serialization" możliwe jest
przechowywanie wartości logicznych), możesz użyć bardziej kompaktowej konstrukcji:

.. code-block:: php
   :linenos:

   // zakładamy, że mamy już obiekt $cache

   $id = 'myBigLoop'; // id bufora czyli "tego co chcemy buforować"

   if (!($data = $cache->load($id))) {
       // brak bufora

       $data = '';
       for ($i = 0; $i < 10000; $i++) {
           $data = $data . $i;
       }

       $cache->save($data);

   }

   // [...] przetwarzaj dane $data (wyświetl je, przekaż itp.)

Jeśli chcesz buforować wiele bloków lub instancji danych, idea jest ta sama:

.. code-block:: php
   :linenos:

   // upewnij się, że używasz unikalnych identyfiikatorów:
   $id1 = 'foo';
   $id2 = 'bar';

   // blok 1
   if (!($data = $cache->load($id1))) {
       // brak bufora

       $data = '';
       for ($i=0;$i<10000;$i++) {
           $data = $data . $i;
       }

       $cache->save($data);

   }
   echo($data);

   // to nigdy nie jest buforowane
   echo('NEVER CACHED! ');

   // blok 2
   if (!($data = $cache->load($id2))) {
       // brak bufora

       $data = '';
       for ($i=0;$i<10000;$i++) {
           $data = $data . '!';
       }

       $cache->save($data);

   }
   echo($data);

Jeśli chcesz buforować specjalne wartości (np. wartości logiczne przy włączonej opcji
"automatic_serialization") lub puste łańcuchy znaków, nie możesz używać uproszczonej konstrukcji
przedstawionej powyżej. Musisz jawnie sprawdzić rekord bufora.

.. code-block:: php
   :linenos:

   // konstrukcja uproszczona (nie działa poprawnie dla pustych
   // łańcuchów znaków i wartości logicznych)
   if (!($data = $cache->load($id))) {

       // brak bufora

       // [...] tworzymy dane $data

       $cache->save($data);

   }

   // pracujemy na danych $data

   // [...]

   // konstrukcja kompletna (działa zawsze)
   if (!($cache->test($id))) {

       // brak bufora

       // [...] tworzymy dane $data

       $cache->save($data);

   } else {

       // bufor został znaleziony

       $data = $cache->load($id);

   }

   // pracujemy na danych $data

.. _zend.cache.frontend.output:

Zend_Cache_Frontend_Output
--------------------------

.. _zend.cache.frontend.output.introduction:

Wprowadzenie
^^^^^^^^^^^^

``Zend_Cache_Frontend_Output`` jest frontendem przechwytującym dane wyjściowe. Przejmuje on wyświetlanie danych
wyjściowych w PHP przechwytując wszystko co jest pomiędzy metodami ``start()`` oraz ``end()``.

.. _zend.cache.frontend.output.options:

Dostępne opcje
^^^^^^^^^^^^^^

Ten frontend nie ma żadnych specyficznych opcji innych niż te z ``Zend_Cache_Core``.

.. _zend.cache.frontend.output.examples:

Przykłady
^^^^^^^^^

Przykład jest podany w dokumentacji na samym początku. To są główne różnice:

.. code-block:: php
   :linenos:

   // jeśli bufor nie istnieje, przechwytywane są dane wyjściowe
   if (!($cache->start('mypage'))) {

       // wyświetlaj jak zawsze
       echo 'Witaj! ';
       echo 'To jest buforowane ('.time().') ';

       $cache->end(); // kończy się wyświetlanie danych
   }

   echo 'To nie jest nigdy buforowane ('.time().').';

Używając tej formy bardzo łatwe jest ustawienie buforowania danych wyjściowych w twoim aktualnie działającym
projekcie przy małej ilości przeróbek w kodzie lub przy ich braku.

.. _zend.cache.frontend.function:

Zend_Cache_Frontend_Function
----------------------------

.. _zend.cache.frontend.function.introduction:

Wprowadzenie
^^^^^^^^^^^^

Frontend ``Zend_Cache_Frontend_Function`` buforuje rezultaty wywołań funkcji. Posiada on jedną metodą nazwaną
``call()``, ktora przyjmuje nazwę funkcji oraz parametry do wywołania w tablicy.

.. _zend.cache.frontend.function.options:

Dostępne opcje
^^^^^^^^^^^^^^

.. table:: Dostępne opcje

   +--------------------+----------+----------------+------------------------------------------------------------------+
   |Opcja               |Typ danych|Domyślna wartość|Opis                                                              |
   +====================+==========+================+==================================================================+
   |cache_by_default    |Boolean   |TRUE            |jeśli ma wartość true, wywołania funkcji będą domyślnie buforowane|
   +--------------------+----------+----------------+------------------------------------------------------------------+
   |cached_functions    |Array     |                |nazwy funkcji które mają być zawsze buforowane                    |
   +--------------------+----------+----------------+------------------------------------------------------------------+
   |non_cached_functions|Array     |                |nazwy funkcji które nigdy nie mają być buforowane                 |
   +--------------------+----------+----------------+------------------------------------------------------------------+

.. _zend.cache.frontend.function.examples:

Przykłady
^^^^^^^^^

Użycie funkcji ``call()`` jest takie samo jak użycie funkcji ``call_user_func_array()`` w PHP:

.. code-block:: php
   :linenos:

   $cache->call('veryExpensiveFunc', $params);

   // $params jest tablicą
   // przykładowo aby wywołać (z buforowaniem) funkcję veryExpensiveFunc(1, 'foo', 'bar'), użyj
   // $cache->call('veryExpensiveFunc', array(1, 'foo', 'bar'))

Frontend ``Zend_Cache_Frontend_Function`` jest na tyle sprytny, że buforuje zarówno wartość zwracaną przez
funkcję, jak i wszystkie dane wyjściowe, które ona wypisuje.

.. note::

   Możesz przekazać dowolną wbudowaną funkcję lub zdefiniowną przez użytkownika z wyjątkiem ``array()``,
   ``echo()``, ``empty()``, ``eval()``, ``exit()``, ``isset()``, ``list()``, ``print()`` oraz ``unset()``.

.. _zend.cache.frontend.class:

Zend_Cache_Frontend_Class
-------------------------

.. _zend.cache.frontend.class.introduction:

Wprowadzenie
^^^^^^^^^^^^

Frontend ``Zend_Cache_Frontend_Class`` różnie się od frontendu ``Zend_Cache_Frontend_Function`` tym, że
umożliwia buforowanie wywołań metod obiektów (także statycznych)

.. _zend.cache.frontend.class.options:

Dostępne opcje
^^^^^^^^^^^^^^

.. _zend.cache.frontends.class.options.table:

.. table:: Dostępne opcje

   +------------------------+----------+----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Opcja                   |Typ danych|Domyślna wartość|Opis                                                                                                                                                                          |
   +========================+==========+================+==============================================================================================================================================================================+
   |cached_entity (wymagane)|Mixed     |                |jeśli ustawiona jest nazwa klasy, będziemy buforować klasę abstrakcyjną i używać tylko statycznych wywołań; jeśli ustawiony jest obiekt będziemy buforować metody tego obiektu|
   +------------------------+----------+----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_by_default        |Boolean   |TRUE            |jeśli ma wartość true, wywołania będą domyślnie buforowane                                                                                                                    |
   +------------------------+----------+----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cached_methods          |Array     |                |nazwy metod które mają być zawsze buforowane                                                                                                                                  |
   +------------------------+----------+----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |non_cached_methods      |Array     |                |nazwy metod które nie mają być nigdy buforowane                                                                                                                               |
   +------------------------+----------+----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.frontend.class.examples:

Przykłady
^^^^^^^^^

Na przykład, aby buforować statyczne wywołania:

.. code-block:: php
   :linenos:

   class Test {

       // metoda statyczna
       public static function foobar($param1, $param2) {
           echo "foobar_output($param1, $param2)";
           return "foobar_return($param1, $param2)";
       }

   }

   // [...]
   $frontendOptions = array(
       'cached_entity' => 'Test' // Nazwa klasy
   );
   // [...]

   # buforowane wywołanie
   $result = $cache->foobar('1', '2');

Aby buforować klasyczne wywołania metod:

.. code-block:: php
   :linenos:

   class Test {

       private $_string = 'hello !';

       public function foobar2($param1, $param2) {
           echo($this->_string);
           echo "foobar2_output($param1, $param2)";
           return "foobar2_return($param1, $param2)";
       }

   }

   // [...]
   $frontendOptions = array(
       'cached_entity' => new Test() // instancja klasy
   );
   // [...]

   # buforowane wywołanie
   $result = $cache->foobar2('1', '2');

.. _zend.cache.frontends.file:

Zend_Cache_Frontend_File
------------------------

.. _zend.cache.frontends.file.introduction:

Wprowadzenie
^^^^^^^^^^^^

``Zend_Cache_Frontend_File`` jeest frontendem działającym w oparciu o datę modyfikacji "głównego pliku". Jest
to bardzo interesujące, na przykład przy zagadnieniach związanych z konfiguracją czy szablonami.

Na przykład, jeśli masz plik konfiguracyjny XML, który jest analizowany przez funkcję zwracającą obiekt
konfiguracji (na przykład ``Zend_Config``). Za pomocą frontendu ``Zend_Cache_Frontend_File``, możesz przechować
obiekt konfiguracji w buforze (aby zapobiec analizowaniu pliku konfiguracyjnego XML za każdym razem), ale przy
zależności od "głównego pliku". Więc jeśli plik konfiguracyjny XML zostanie zmodyfikowany, bufor natychmiast
straci ważność.

.. _zend.cache.frontends.file.options:

Dostępne opcje
^^^^^^^^^^^^^^

.. _zend.cache.frontends.file.options.table:

.. table:: Dostępne opcje

   +-----------------------+----------+----------------+----------------------------------------+
   |Opcja                  |Typ danych|Domyślna wartość|Opis                                    |
   +=======================+==========+================+========================================+
   |master_file (mandatory)|String    |                |kompletna ścieżka i nazwa głównego pliku|
   +-----------------------+----------+----------------+----------------------------------------+

.. _zend.cache.frontends.file.examples:

Przykłady
^^^^^^^^^

Użycie tego frontendu jest takie same jak ``Zend_Cache_Core``. Nie ma potrzeby zamieszczania specyficznego
przykładu - jedyną rzeczą do zrobienia jest zdefiniowanie pliku **master_file** gdy używamy metody fabryki.

.. _zend.cache.frontends.page:

Zend_Cache_Frontend_Page
------------------------

.. _zend.cache.frontends.page.introduction:

Wprowadzenie
^^^^^^^^^^^^

Frontend ``Zend_Cache_Frontend_Page`` działa jak ``Zend_Cache_Frontend_Output`` ale jest zaprojektowany dla
kompletnej strony. Nie jest możliwe użycie ``Zend_Cache_Frontend_Page`` do buforowania pojedynczego bloku.

Z drugiej strony, identyfikator bufora jest obliczany na podstawie ``$_SERVER['REQUEST_URI']`` oraz (zależnie od
opcji) ``$_GET``, ``$_POST``, ``$_SESSION``, ``$_COOKIE``, ``$_FILES``. Jeszcze lepiej, masz tylko jedną metodę
do wywołania (``start()``) ponieważ metoda ``end()`` jest wywoływana w pełni automatycznie na końcu strony.

Obecnie nie jest to zaimplementowane, ale planujemy dodać warunkowy system HTTP w celu oszczędzania transferu
(system wyśle nagłówek HTTP 304 Not Modified jeśli bufor istnieje i gdy przeglądarka ma aktualną wersję
bufora).

.. _zend.cache.frontends.page.options:

Dostępne opcje (for this frontend in Zend_Cache factory)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.cache.frontends.page.options.table:

.. table:: Dostępne opcje

   +----------------+----------+-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Opcja           |Typ danych|Domyślna wartość         |Opis                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
   +================+==========+=========================+==========================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
   |http_conditional|Boolean   |FALSE                    |użyj systemu http_conditional (obecnie jeszcze nie zaimplementowane)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
   +----------------+----------+-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |debug_header    |Boolean   |FALSE                    |jeśli ma wartość true, testowy tekst jest dodawany przed każdą buforowaną stroną                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
   +----------------+----------+-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |default_options |Array     |array(...zobacz niżej...)|asocjacyjna tablica domyślnych opcji: (boolean, domyślnie wartość true) cache : bufor jest włączony jeśli ma wartość true (boolean, domyślnie wartość false) cache_with_get_variables : jeśli ma wartość true, buforowanie jest włączone nawet wtedy gdy są jakieś zmienne w tablicy $_GET(boolean, domyślnie wartość false) cache_with_post_variables : jeśli ma wartość true, buforowanie jest włączone nawet wtedy gdy są jakieś zmienne w tablicy $_POST(boolean, domyślnie wartość false) cache_with_session_variables : jeśli ma wartość true, buforowanie jest włączone nawet wtedy gdy są jakieś zmienne w tablicy $_SESSION(boolean, domyślnie wartość false) cache_with_files_variables : jeśli ma wartość true, buforowanie jest włączone nawet wtedy gdy są jakieś zmienne w tablicy $_FILES(boolean, domyślnie wartość false) cache_with_cookie_variables : jeśli ma wartość true, buforowanie jest włączone nawet wtedy gdy są jakieś zmienne w tablicy $_COOKIE(boolean, domyślnie wartość true) makeI_id_with_get_variables : jeśli ma wartość true, identyfikator bufora będzie zależał od zawartości tablicy $_GET(boolean, domyślnie wartość true) make_id_with_post_variables : jeśli ma wartość true, identyfikator bufora będzie zależał od zawartości tablicy $_POST(boolean, domyślnie wartość true) make_id_with_session_variables : jeśli ma wartość true, identyfikator bufora będzie zależał od zawartości tablicy $_SESSION(boolean, domyślnie wartość true) make_id_with_files_variables : jeśli ma wartość true, identyfikator bufora będzie zależał od zawartości tablicy $_FILES(boolean, domyślnie wartość true) make_id_with_cookie_variables : jeśli ma wartość true, identyfikator bufora będzie zależał od zawartości tablicy $_COOKIE(int, domyślnie wartość false) specific_lifetime : jeśli ma wartość inną niż false, podana wartość zostanie użyta dla danego wyrażenia regularnego (array, domyślnie wartość array()) tags : etykiety dla buforowanego rekordu (int, domyślnie wartość null) priority : priorytet (jeśli backend to obsługuje)|
   +----------------+----------+-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |regexps         |Array     |array()                  |tablica asocjacyjna do ustawienia opcji tylko dla pewnych adresów REQUEST_URI, klucze są wyrażeniami regularnymi (PCRE), wartości są asocjacyjnymi tablicami ze specyficznymi opcjami do ustawienia gdy wyrażenie regularne zostanie dopasowane do $_SERVER['REQUEST_URI'] (zobacz default_options aby zobaczyć listę wszystkich dostępnych opcji) ; jeśli kilka wyrażen regularnych będzie pasowało do $_SERVER['REQUEST_URI'], zostanie użyte tylko te ostatnie                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
   +----------------+----------+-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |memorize_headers|array     |array()                  |tablica łańcuchów znaków odpowiadająca nazwom nagłówków HTTP. Wymienione nagłówki będą przechowane wraz z danymi buforu i odtworzone gdy bufor zostanie użyty                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
   +----------------+----------+-------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.frontends.page.examples:

Przykłady
^^^^^^^^^

Użycie ``Zend_Cache_Frontend_Page`` jest naprawdę łatwe:

.. code-block:: php
   :linenos:

   // [...] // wymagane, konfiguracja i fabryka

   $cache->start();
   // jeśli bufor jest trafiony, wynik jest wysyłany do przeglądaki a skrypt tutaj kończy działanie

   // reszta strony

bardziej kompleksowy przykład, który pokazuje sposób centralnego zarządzania buforowaniem w pliku ładującym
(przykładowo do użycia z klasą ``Zend_Controller``)

.. code-block:: php
   :linenos:

   /**
    * Powinieneś unikać tworzenia dużej ilości kodu przed sekcją buforowania na
    * przykład, w celu optymalizacji, instrukcje "require_once" lub
    * "Zend_Loader::loadClass" powinny znajdować się za sekcją buforowania
    */

   $frontendOptions = array(
      'lifetime' => 7200,
      'debug_header' => true, // dla testów
      'regexps' => array(
          // buforuj cały kontroler IndexController
          '^/$' => array('cache' => true),

          // buforuj cały kontroler IndexController
          '^/index/' => array('cache' => true),

          // nie buforuj kontrolera ArticleController...
          '^/article/' => array('cache' => false),

          // ...ale buforuj akcję "view"
          '^/article/view/' => array(
              // kontrolera ArticleController
              'cache' => true,

              // i buforuj gdy są dostępne zmienne $_POST
              'cache_with_post_variables' => true,

              // (ale bufor będzie zależał od tablicy $_POST)
              'make_id_with_post_variables' => true,
          )
      )
   );

   $backendOptions = array(
       'cache_dir' => '/tmp/'
   );

   // pobieranie obiektu Zend_Cache_Frontend_Page
   $cache = Zend_Cache::factory('Page',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   $cache->start();
   // jeśli bufor jest trafiony, wynik jest wysyłany do przeglądaki
   // a skrypt tutaj kończy działanie

   // [...] koniec pliku uruchamiającego
   // te linie nie będą wykonane jeśli bufor jest trafiony

.. _zend.cache.frontends.page.cancel:

Metoda zaniechania buforowania
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Z powodu wymagań projektowych, w niektórych przypadkach (na przykład gdy używamy kodów innych niż HTTP/200),
możesz potrzebować zaniechać proces buforowania. Dlatego dla tego frontendu udostępniamy metodę cancel().

.. code-block:: php
   :linenos:

   // [...] // konfiguracja itp.

   $cache->start();

   // [...]

   if ($someTest) {
       $cache->cancel();
       // [...]
   }

   // [...]


