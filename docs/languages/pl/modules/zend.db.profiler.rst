.. _zend.db.profiler:

Zend_Db_Profiler
================

.. _zend.db.profiler.introduction:

Wprowadzenie
------------

*Zend_Db_Profiler* może być włączony aby pozwolić na profilowanie zapytań. Profilowanie umożliwia zbadanie
czasu trwania zapytań pozwalając na inspekcję przeprowadzonych zapytań bez potrzeby dodawania dodatkowego kodu
do klas. Zaawansowane użycie pozwala także programiście decydować o tym, jakich typów zapytania mają być
profilowane.

Włącz profiler przekazując odpowiednią dyrektywę do konstruktora adaptera, lub wywołując później metodę
adaptera.

.. code-block:: php
   :linenos:

   $params = array (
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test',
       'profiler' => true  // włącz profiler; ustaw false aby wyłączyć (domyślne wyłączony)
   );

   $db = Zend_Db::factory('PDO_MYSQL', $params);

   // wyłącz profiler:
   $db->getProfiler()->setEnabled(false);

   // włącz profiler:
   $db->getProfiler()->setEnabled(true);


Wartość opcji '*profiler*' jest dość elastyczna. Jest ona interpretowana zależnie id jej typu. W większości
przypadków powinieneś użyć wartości logicznej, ale inne typy pozwalają na dostosowanie zachowania profilera
do własnych potrzeb.

Parametr logiczny włącza profiler jeśli ma wartość *true*, lub wyłącza jeśli ma wartość *false*. Klasą
profilera domyślnie jest klasa *Zend_Db_Profiler*.

   .. code-block:: php
      :linenos:

      $params['profiler'] = true;
      $db = Zend_Db::factory('PDO_MYSQL', $params);




Przekazanie instancji obiektu profilera powoduje jej użycie przez sterownik bazy danych. Musi to być obiekt klasy
*Zend_Db_Profiler* lub klasy ją rozszerzającej. Aktywacja profilera odbywa się osobno.

   .. code-block:: php
      :linenos:

      $profiler = MyProject_Db_Profiler();
      $profiler->setEnabled(true);
      $params['profiler'] = $profiler;
      $db = Zend_Db::factory('PDO_MYSQL', $params);




Argument może być tablicą asocjacyjną zawierającą wszystkie lub jeden z kluczy '*enabled*', '*instance*',
oraz '*class*'. Klucz '*enabled*' odpowiada wartości logicznej, a '*instance*' wartości instancji, obie są
opisane powyżej. Klucz '*class*' jest używany do podania nazwy klasy jaka ma być użyta we własnym profilerze.
Musi być to obiekt klasy *Zend_Db_Profiler* lub klasy ją rozszerzającej. Instancja klasy jest tworzona bez
żadnych argumentów. Opcja '*class*' jest ingorowana jeśli podana jest opcja '*instance*'.

   .. code-block:: php
      :linenos:

      $params['profiler'] = array(
          'enabled' => true,
          'class'   => 'MyProject_Db_Profiler'
      );
      $db = Zend_Db::factory('PDO_MYSQL', $params);




Ostatecznie, argument może być obiektem klasy *Zend_Config* zawierającym właściwości, które są traktowane
jako klucze tablicy opisane powyżej. Przykładowo plik "config.ini" może zawierać następujące dane:

   .. code-block:: php
      :linenos:

      [main]
      db.profiler.class   = "MyProject_Db_Profiler"
      db.profiler.enabled = true


Konfiguracja może być przekazana za pomocą takiego kodu PHP:

   .. code-block:: php
      :linenos:

      $config = new Zend_Config_Ini('config.ini', 'main');
      $params['profiler'] = $config->db->profiler;
      $db = Zend_Db::factory('PDO_MYSQL', $params);


Właściwość '*instance*' może być użyta w następujący sposób:

   .. code-block:: php
      :linenos:

      $profiler = new MyProject_Db_Profiler();
      $profiler->setEnabled(true);
      $configData = array(
          'instance' => $profiler
      );
      $config = new Zend_Config($configData);
      $params['profiler'] = $config;
      $db = Zend_Db::factory('PDO_MYSQL', $params);




.. _zend.db.profiler.using:

Użycie profilera
----------------

W dowolnym momencie możesz pobrać profiler używając metody adaptera *getProfiler()*:

.. code-block:: php
   :linenos:

   $profiler = $db->getProfiler();


Zwraca to instancję *Zend_Db_Profiler*. Używając tej instancji programista może zbadać zapytania używając
rozmaitych metod:

- *getTotalNumQueries()* zwraca liczbę wszystkich zapytań które były profilowane.

- *getTotalElapsedSecs()* zwraca całkowity czas trwania profilowanych zapytań.

- *getQueryProfiles()* zwraca tablicę wszystkich profilów zapytań.

- *getLastQueryProfile()* zwraca ostatni (najnowszy) profil zapytania, niezależnie od tego czy zostało ono
  zakończone czy nie (jeśli nie zostało, to czas zakończenia będzie miał wartość null)

- *clear()* czyści wszystkie poprzednie profile zapytań ze stosu.

Wartość zwracana przez *getLastQueryProfile()* oraz pojedyncze elementy tablicy zwracanej przez
*getQueryProfiles()* są obiektami *Zend_Db_Profiler_Query*, które dają możliwość sprawdzenia osobno każdego
zapytania.

- Metoda *getQuery()* zwraca tekst SQL zapytania. Tekst przygotowanego zapytania SQL z parametrami jest tekstem w
  takiej postaci w jakiej był on przygotowany, więc zawiera on etykiety, a nie wartości użyte podczas wykonania
  zapytania.

- Metoda *getQueryParams()* zwraca tablicę wartości parametrów użytych podczas wykonania przygotowanego
  zapytania. Odnosi się to do parametrów oraz do argumentów metody *execute()*. Klucze tablicy są oparte na
  pozycji (od 1 w górę) lub nazwane (łańcuchy znaków).

- Metoda *getElapsedSecs()* zwraca czas trwania zapytania

Informacja której dostarcza *Zend_Db_Profiler* jest użyteczna przy profilowaniu wąskich gardeł w aplikacjach
oraz do szukania błędów w wykonanych zapytaniach. Na przykład aby zobaczyć ostatnie zapytanie jakie było
wykonane:

.. code-block:: php
   :linenos:

   $query = $profiler->getLastQueryProfile();

   echo $query->getQuery();


Możliwe, że strona generuje się powoli; użyj profilera aby ustalić czas wykonania wszystkich zapytań, a
następnie przejść poprzez zapytania aby znaleść te, które trwało najdłużej:

.. code-block:: php
   :linenos:

   $totalTime    = $profiler->getTotalElapsedSecs();
   $queryCount   = $profiler->getTotalNumQueries();
   $longestTime  = 0;
   $longestQuery = null;

   foreach ($profiler->getQueryProfiles() as $query) {
       if ($query->getElapsedSecs() > $longestTime) {
           $longestTime  = $query->getElapsedSecs();
           $longestQuery = $query->getQuery();
       }
   }

   echo 'Wykonano ' . $queryCount . ' zapytań w czasie ' . $totalTime . ' sekund' . "\n";
   echo 'Średni czas trwania zapytania: ' . $totalTime / $queryCount . ' sekund' . "\n";
   echo 'Zapytań na sekundę:: ' . $queryCount / $totalTime . "\n";
   echo 'Czas trwania najdłuższego zapytania: ' . $longestTime . "\n";
   echo "Najdłuższe zapytanie: \n" . $longestQuery . "\n";


.. _zend.db.profiler.advanced:

Zaawansowane użycie profilera
-----------------------------

Oprócz sprawdzania zapytań, profiler pozwala także programiście na określenie typów zapytań które mają
być profilowane. Poniższe metody operują na instancji *Zend_Db_Profiler*:

.. _zend.db.profiler.advanced.filtertime:

Filtrowanie ze względu na czas trwania zapytania
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*setFilterElapsedSecs()* pozwala programiście ustalić minimalny czas trwania zapytania jaki jest potrzebny do
tego by zostało ono profilowane. Aby usunąć filtr, wywołaj metodę z wartością null w parametrze.

.. code-block:: php
   :linenos:

   // Profiluj tylko zapytania które trwają przynajmniej 5 sekund:
   $profiler->setFilterElapsedSecs(5);

   // Profiluj wszystkie zapytania, niezależnie od czasu ich trwania:
   $profiler->setFilterElapsedSecs(null);


.. _zend.db.profiler.advanced.filtertype:

Filtrowanie ze względu na typ zapytania
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*setFilterQueryType()* pozwala programiście określić, które typy zapytań powinny być profilowane; aby
profilować zapytania wielu typów użyj logicznego operatora OR. Typy zapytań są zdefiniowane jako stałe w
*Zend_Db_Profiler*:

- *Zend_Db_Profiler::CONNECT*: operacje połączenia lub wybierania bazy danych.

- *Zend_Db_Profiler::QUERY*: ogólne zapytania które nie pasują do pozostałych typów.

- *Zend_Db_Profiler::INSERT*: każde zapytanie które wstawia nowe dane do bazy, generalnie SQL INSERT.

- *Zend_Db_Profiler::UPDATE*: każde zapytanie ktore uaktualnia dane w bazie, najczęściej SQL UPDATE.

- *Zend_Db_Profiler::DELETE*: każde zapytanie które usuwa istnięjące dane, najczęściej SQL DELETE.

- *Zend_Db_Profiler::SELECT*: każde zapytanie które pobiera istnięjące dane, najczęściej SQL SELECT.

- *Zend_Db_Profiler::TRANSACTION*: każda operacja transakcyjna, taka jak start transakcji, potwierdzenie zmian czy
  ich cofnięcie.

Analogicznie jak w metodzie *setFilterElapsedSecs()*, możesz usunąć wszystkie istniejące filtry przekazując
metodzie pusty parametr *null*.

.. code-block:: php
   :linenos:

   // profiluj tylko zapytania SELECT
   $profiler->setFilterQueryType(Zend_Db_Profiler::SELECT);

   // profiluj zapytania SELECT, INSERT, oraz UPDATE
   $profiler->setFilterQueryType(Zend_Db_Profiler::SELECT | Zend_Db_Profiler::INSERT | Zend_Db_Profiler::UPDATE);

   // profiluj zapytania DELETE
   $profiler->setFilterQueryType(Zend_Db_Profiler::DELETE);

   // Usuń wszystkie filtry
   $profiler->setFilterQueryType(null);


.. _zend.db.profiler.advanced.getbytype:

Pobieranie profili na podstawie typów zapytań
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Użycie metody *setFilterQueryType()* może zmniejszyć ilość wygenerowanych profili. Jakkolwiek, czasem bardziej
użyteczne jest przechowywanie wszystkich profili i wyświetlanie tylko tych których potrzebujesz w danym
momencie. Inną funkcjonalnością metody *getQueryProfiles()* jest to, że może ona przeprowadzić te filtrowanie
w locie, po przekazaniu typu zapytań (lub logicznej kombinacji typów zapytań) jako pierwszego argumentu;
przejdź do :ref:` <zend.db.profiler.advanced.filtertype>` aby zobaczyć listę stałych określających typy
zapytań.

.. code-block:: php
   :linenos:

   // Pobierz jedynie profile zapytań SELECT
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT);

   // Pobierz jedynie profile zapytań SELECT, INSERT, oraz UPDATE
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT | Zend_Db_Profiler::INSERT | Zend_Db_Profiler::UPDATE);

   // Pobierz jedynie profile zapytań DELETE
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::DELETE);


.. _zend.db.profiler.profilers:

Wyspecjalizowane profilery
--------------------------

Wyspecjalizowany profiler jest obiektem klasy dziedziczącej po klasie *Zend_Db_Profiler*. Wyspecjalizowane
profilery traktują profilowane informacje w szczególny sposób.

.. include:: zend.db.profiler.firebug.rst

