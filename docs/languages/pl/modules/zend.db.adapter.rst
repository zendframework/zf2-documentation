.. EN-Revision: none
.. _zend.db.adapter:

Zend_Db_Adapter
===============

``Zend_Db`` i powiązane z nim klasy udostępniają prosty interfejs dla baz danych *SQL* z poziomu Zend Framework.
Klasa ``Zend_Db_Adapter`` jest podstawowym komponentem potrzebnym by połączyć aplikację PHP z systemem
zarządzania bazą danych (*RDBMS*). Dla każdego rodzaju bazy danych istnieje oddzielna klasa adaptera
``Zend_Db``.

Adaptery ``Zend_Db`` tworzą połączenie pomiędzy rozszerzeniami *PHP* dla konkretnych rodzajów baz danych a
wspólnym interfejsem, dzięki czemu można napisać aplikację raz i w nieskomplikowany sposób uruchamiać ją z
wieloma rodzajami *RDBMS*

Interfejs klasy adaptera jest podobny do interfejsu rozszerzenia `PHP Data Objects`_. ``Zend_Db`` zawiera klasy
adapterów dla sterowników *PDO* następujących rodzajów baz danych:

- IBM DB2 oraz Informix Dynamic Server (IDS), poprzez rozszerzenie *PHP* `pdo_ibm`_.

- MySQL, poprzez rozszerzenie *PHP* `pdo_mysql`_

- Microsoft *SQL* Server, używając rozszerzenia *PHP* `pdo_dblib`_

- Oracle, poprzez rozszerzenie *PHP* `pdo_oci`_

- PostgreSQL, poprzez rozszerzenie *PHP* `pdo_pgsql`_

- SQLite, używając rozszerzenia *PHP* `pdo_sqlite`_

Dodatkowo ``Zend_Db`` dostarcza klas adapterów korzystających z rozszerzeń *PHP* dla następujących rodzajów
baz danych:

- MySQL, poprzez rozszerzenie *PHP* `mysqli`_

- Oracle, poprzez rozszerzenie *PHP* `oci8`_

- IBM DB2 oraz DB2/i5, poprzez rozszerzenie *PHP* `ibm_db2`_

- Firebird/Interbase, poprzez rozszerzenie *PHP* `php_interbase`_

.. note::

   Każdy adapter ``Zend_Db`` używa określonego rozszerzenia *PHP*. Aby użyć adaptera należy mieć
   zainstalowane i włączone odpowiadające mu rozszerzenie *PHP*. Np. aby użyć dowolnego adaptera *PDO*
   ``Zend_Db``, wymagane jest posiadanie włączonego rozszerzenia *PDO* oraz sterownika dla danego rodzaju
   *RDBMS*.

.. _zend.db.adapter.connecting:

Połączenie z bazą danych za pomocą adaptera
-------------------------------------------

Ta część opisuje jak tworzy się instancję adaptera bazy danych. Jest to odpowiednik połączenia z bazą
danych w aplikacji *PHP*.

.. _zend.db.adapter.connecting.constructor:

Użycie konstruktora adaptera Zend_Db
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Można utworzyć instancję adaptera za pomocą konstruktora. Przyjmuje on pojedynczy argument - tablicę
parametrów używanych do deklaracji połączenia.

.. _zend.db.adapter.connecting.constructor.example:

.. rubric:: Użycie konstruktora adaptera

.. code-block:: php
   :linenos:

   $db = new Zend_Db_Adapter_Pdo_Mysql(array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

.. _zend.db.adapter.connecting.factory:

Użycie fabryki Zend_Db
^^^^^^^^^^^^^^^^^^^^^^

Alternatywą w stosunku do bezpośredniego używania konstruktora jest utworzenie instancji adaptera za pomocą
statycznej metody ``Zend_Db::factory()``. Ta metoda dynamicznie ładuje plik klasy adaptera używając
:ref:`Zend_Loader::loadClass() <zend.loader.load.class>`.

Pierwszy argument metody to łańcuch znaków, który wyznacza nazwę bazową klasy adaptera. Np. string
'``Pdo_Mysql``' odpowiada klasie ``Zend_Db_Adapter_Pdo_Mysql``. Drugi argument to ta sama tablica parametrów,
którą należało podać adapterowi konstruktora.

.. _zend.db.adapter.connecting.factory.example:

.. rubric:: Użycie metody fabryki adaptera

.. code-block:: php
   :linenos:

   // Poniższa instrukcja jest zbędna ponieważ plik z klasą
   // Zend_Db_Adapter_Pdo_Mysql zostanie załadowany przez fabrykę
   // Zend_Db

   // require_once 'Zend/Db/Adapter/Pdo/Mysql.php';

   // Załaduj klasę Zend_Db_Adapter_Pdo_Mysql automatycznie
   // i utwórz jej instancję
   $db = Zend_Db::factory('Pdo_Mysql', array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

Jeśli jest zdefiniowana własna klasa dziedzicząca po ``Zend_Db_Adapter_Abstract`` ale jej nazwa nie zawiera
"``Zend_Db_Adapter``", można użyć metody ``factory()`` do załadowania adaptera jedynie jeśli poda się swój
prefiks nazwy adaptera z kluczem 'adapterNamespace' do argumentu zawierającego parametry połączenia.

.. _zend.db.adapter.connecting.factory.example2:

.. rubric:: Użycie metody fabryki dla własnej klasy adaptera

.. code-block:: php
   :linenos:

   // Nie trzeba ładować pliku klasy adaptera
   // bo robi to metoda fabryki Zend_Db

   // Załadowanie klasy MyProject_Db_Adapter_Pdo_Mysql automatycznie
   // i utworzenie jej instancji
   $db = Zend_Db::factory('Pdo_Mysql', array(
       'host'             => '127.0.0.1',
       'username'         => 'webuser',
       'password'         => 'xxxxxxxx',
       'dbname'           => 'test',
       'adapterNamespace' => 'MyProject_Db_Adapter'
   ));

.. _zend.db.adapter.connecting.factory-config:

Użycie Zend_Config z fabryką Zend_Db
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Każdy z argumentów metody ``factory()`` może również zostać podany w formie obiektu klasy :ref:`Zend_Config
<zend.config>`.

Jeśli pierwszy argument jest obiektem ``Zend_Config`` to wymagane jest aby posiadał właściwość o nazwie
``adapter``, w której będzie zapisany łańcuch znaków określający nazwę bazową klasy adaptera. Opcjonalnie,
obiekt ten może zawierać właściwość '``params``' z właściwościami potomnymi odpowiadającymi nazwom
parametrów adaptera. Będą one użyte jedynie w przypadku braku drugiego argumentu metody ``factory()``.

.. _zend.db.adapter.connecting.factory.example1:

.. rubric:: Użycie metody fabryki adaptera z obiektem Zend_Config

W poniższym przykładzie, obiekt ``Zend_Config`` jest utworzony z tablicy. Można również załadować dane z
pliku zewnętrznego poprzez klasy :ref:`Zend_Config_Ini <zend.config.adapters.ini>` oraz :ref:`Zend_Config_Xml
<zend.config.adapters.xml>`.

.. code-block:: php
   :linenos:

   $config = new Zend_Config(
       array(
           'database' => array(
               'adapter' => 'Mysqli',
               'params'  => array(
                   'host'     => '127.0.0.1',
                   'dbname'   => 'test',
                   'username' => 'webuser',
                   'password' => 'secret',
               )
           )
       )
   );

   $db = Zend_Db::factory($config->database);

Drugi argument metody ``factory()`` może stanowić tablicę asocjacyjną zawierającą wartości odpowiadające
parametrom adaptera. Ten argument jest opcjonalny. Jeśli pierwszy argument jest obiektem klasy ``Zend_Config`` to
powinien zawierać wszystkie parametry a drugi argument jest ignorowany.

.. _zend.db.adapter.connecting.parameters:

Parametry adaptera
^^^^^^^^^^^^^^^^^^

Poniższa lista opisuje parametry wspólne dla klas adapterów ``Zend_Db``.

- **host**: łańcuch znaków zawierający nazwę hosta lub adres IP serwera bazy danych. Jeśli baza danych jest
  uruchomiona na tej samej maszynie co aplikacja to można tu umieścić 'localhost' lub '127.0.0.1'.

- **username**: identyfikator użytkownika używany do autoryzacji połączenia z serwerem bazy danych.

- **password**: hasło użytkownika używane do autoryzacji połączenia z serwerem bazy danych.

- **dbname**: nazwa instancji bazy danych na serwerze.

- **port**: niektóre serwery bazy danych używają do komunikacji numeru portu określonego przez administratora.
  Ten parametr pozwala na ustawienie numeru portu przez który aplikacja *PHP* się łączy tak aby zgadzał się z
  tym ustawionym na serwerze bazy danych.

- **charset**: określenie zestawu znaków używanego podczas połączenia.

- **options**: ten parametr to tablica asocjacyjna opcji obsługiwanych przez wszystkie klasy ``Zend_Db_Adapter``.

- **driver_options**: ten parametr to tablica asocjacyjna zawierająca dodatkowe opcje specyficzne dla każdego
  rozszerzenia bazy danych. Typowym przykładem użycia tego parametru jest zbiór atrybutów sterownika *PDO*.

- **adapterNamespace**: początkowa część nazwy klasy używanego adaptera, używana zamiast
  '``Zend_Db_Adapter``'. Przydatna w przypadku użycia metody ``factory()`` do załadowana własnej klasy adaptera.

.. _zend.db.adapter.connecting.parameters.example1:

.. rubric:: Przekazanie do fabryki opcji zmiany wielkości znaków

Opcję tą można podać za pomocą stałej ``Zend_Db::CASE_FOLDING``. Odpowiada ona atrybutowi ``ATTR_CASE`` w
*PDO* oraz rozszerzeniu IBM DB2, który zmienia wielkość znaków w nazwach kolumn zwracanych w rezultacie
zapytania. Opcja przybiera wartości ``Zend_Db::CASE_NATURAL`` (bez zmiany - domyślnie), ``Zend_Db::CASE_UPPER``
(zmiana na wielkie znaki) oraz ``Zend_Db::CASE_LOWER`` (zmiana na małe znaki).

.. code-block:: php
   :linenos:

   $options = array(
       Zend_Db::CASE_FOLDING => Zend_Db::CASE_UPPER
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend_Db::factory('Db2', $params);

.. _zend.db.adapter.connecting.parameters.example2:

.. rubric:: Przekazanie do fabryki opcji automatycznego umieszczania w cudzysłowie

Tą opcję można podać za pomocą stałej ``Zend_Db::AUTO_QUOTE_IDENTIFIERS``. Jeśli jej wartość wynosi
``TRUE`` (domyślnie) to identyfikatory takie jak nazwy tabel, kolumn oraz aliasy w składni każdego polecenia
*SQL* generowanego za pomocą danego adaptera będą umieszczane w cudzysłowie. Takie podejście upraszcza
używanie identyfikatorów zawierających słowa kluczowe *SQL* lub znaki specjalne. Jeśli wartość opcji wynosi
``FALSE`` to identyfikatory nie są umieszczane w cudzysłowie. Jeśli zachodzi potrzeba owinięcia
identyfikatorów cudzysłowami należy to zrobić samodzielnie za pomocą metody ``quoteIdentifier()``.

.. code-block:: php
   :linenos:

   $options = array(
       Zend_Db::AUTO_QUOTE_IDENTIFIERS => false
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend_Db::factory('Pdo_Mysql', $params);

.. _zend.db.adapter.connecting.parameters.example3:

.. rubric:: Przekazanie do fabryki opcji sterownika PDO

.. code-block:: php
   :linenos:

   $pdoParams = array(
       PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => true
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'driver_options' => $pdoParams
   );

   $db = Zend_Db::factory('Pdo_Mysql', $params);

   echo $db->getConnection()
           ->getAttribute(PDO::MYSQL_ATTR_USE_BUFFERED_QUERY);

.. _zend.db.adapter.connecting.parameters.example4:

.. rubric:: Przekazanie do fabryki opcji serializacji

.. code-block:: php
   :linenos:

   $options = array(
       Zend_Db::ALLOW_SERIALIZATION => false
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend_Db::factory('Pdo_Mysql', $params);

.. _zend.db.adapter.connecting.getconnection:

Zarządzanie leniwymi połączeniami
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Utworzenie instancji klasy adaptera nie powoduje natychmiastowego połączenia z serwerem bazy danych. Adapter
zachowuje parametry połączenia ale łączy się na żądanie - w momencie pierwszego wywołania zapytania.
Dzięki temu zainicjowanie adaptera jest szybkie i tanie. Można utworzyć adapter nawet jeśli nie jest się
pewnym czy wykonanie jakiegokolwiek zapytania przy danym połączeniu będzie niezbędne.

Jeśli zajdzie potrzeba zmuszenia adaptera do połączenia z bazą danych, należy wówczas wywołać metodę
``getConnection()``. Zwraca ona obiekt połączenia odpowiednio do rozszerzenia *PHP* używanego do połączenia.
Jeśli używa się adaptera korzystającego z *PDO*, to metoda ``getConnection()``, po zainicjowaniu połączenia z
serwerem bazy danych, zwróci obiekt *PDO*.

Możliwość wymuszenia połączenia z bazą danych może być przydatna gdy chce się złapać wyjątki rzucane
przez adapter powstałe w rezultacie podania złych danych uwierzytelniających lub innych błędów połączenia.
Te wyjątki nie są rzucane dopóki nie jest ustanowiona próba połączenia, więc można uprościć kod aplikacji
i obsłużyć je w jednym miejscu. W przeciwnym razie należałoby je przechwycać w momencie wywołania pierwszego
zapytania do bazy danych.

Dodatkowo adapter może zostać poddany serializacji i przechowany np. w zmiennej sesyjnej. Może to być pomocne
nie tylko dla adaptera ale również z punktu widzenia obiektów, które z niego korzystają, takich jak
``Zend_Db_Select``. Domyślnie serializacja adapterów jest dozwolona ale jeśli jest taka potrzeba - można ją
wyłączyć poprzez podanie opcji ``Zend_Db::ALLOW_SERIALIZATION`` z wartością ``FALSE`` (przykład niżej). Aby
pozostać w zgodzie z zasadą leniwego połączenia, adapter nie połączy się automatycznie po odserializowaniu.
Należy zatem wywołać metodę ``getConnection()``. Można również zmusić adapter aby po odserializowaniu
łączył się z bazą danych automatycznie poprzez podanie opcji ``Zend_Db::AUTO_RECONNECT_ON_UNSERIALIZE`` z
wartością ``TRUE``.

.. _zend.db.adapter.connecting.getconnection.example:

.. rubric:: Obsługa wyjątków połączenia

.. code-block:: php
   :linenos:

   try {
       $db = Zend_Db::factory('Pdo_Mysql', $parameters);
       $db->getConnection();
   } catch (Zend_Db_Adapter_Exception $e) {
       // przyczyną problemów mogą być złe dane uwierzytelniające lub np. baza danych
       // nie jest uruchomiona
   } catch (Zend_Exception $e) {
       // przyczyną może być np. problem z załadowaniem odpowiedniej klasy adaptera
   }

.. _zend.db.adapter.example-database:

Przykładowa baza danych
-----------------------

W dokumentacji klas ``Zend_Db`` używany jest prosty zestaw tabel w celu zilustrowania użycia klas i metod. Te
tabele mogą przechowywać dane związane z przechowywaniem błędów (bugs) powstałych podczas rozwijania
projektu informatycznego. Baza danych zawiera cztery tabele:

- **accounts** przechowuje informacje o każdym użytkowniku bazy danych błędów.

- **products** przechowuje informacje o każdym produkcie, dla którego można zapisać wystąpienie usterki.

- **bugs** przechowuje informacje o błędach, włączając jego obecny stan, osobę zgłaszającą, osobę
  przypisaną do rozwiązania problemu oraz osobę przeznaczoną do zweryfikowania poprawności zastosowanego
  rozwiązania.

- **bugs_products** przechowuje relację pomiędzy usterkami a produktami. To odzwierciedla połączenie
  wiele-do-wielu, ponieważ dany błąd może się odnosić do wielu produktów a jeden produkt może posiadać
  wiele usterek.

Poniższy pseudokod definicji danych *SQL* opisuje tabele z tego przykładu. Te tabele są bardzo często używane
w testach jednostkowych ``Zend_Db``.

.. code-block:: sql
   :linenos:

   CREATE TABLE accounts (
     account_name      VARCHAR(100) NOT NULL PRIMARY KEY
   );

   CREATE TABLE products (
     product_id        INTEGER NOT NULL PRIMARY KEY,
     product_name      VARCHAR(100)
   );

   CREATE TABLE bugs (
     bug_id            INTEGER NOT NULL PRIMARY KEY,
     bug_description   VARCHAR(100),
     bug_status        VARCHAR(20),
     reported_by       VARCHAR(100) REFERENCES accounts(account_name),
     assigned_to       VARCHAR(100) REFERENCES accounts(account_name),
     verified_by       VARCHAR(100) REFERENCES accounts(account_name)
   );

   CREATE TABLE bugs_products (
     bug_id            INTEGER NOT NULL REFERENCES bugs,
     product_id        INTEGER NOT NULL REFERENCES products,
     PRIMARY KEY       (bug_id, product_id)
   );

Należy zwrócić uwagę, iż tabela 'bugs' zawiera wiele kluczy obcych odnoszących się do tabeli 'accounts'.
Każdy z nich może prowadzić do innego wiersza tabeli 'accounts' w ramach jednego bugu.

Poniższy diagram ilustruje fizyczny model danych przykładowej bazy danych

.. image:: ../images/zend.db.adapter.example-database.png
   :width: 387
   :align: center

.. _zend.db.adapter.select:

Pobranie rezultatów zapytania
-----------------------------

Ta część opisuje metody klasy adaptera za pomocą których można wywołać zapytania *SELECT* oraz pobrać ich
rezultaty.

.. _zend.db.adapter.select.fetchall:

Pobranie całego zbioru rezultatów
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Za pomocą metody ``fetchAll()`` można wywołać zapytanie *SQL* *SELECT* oraz pobrać jego rezultaty w jednym
kroku.

Pierwszym argumentem metody jest łańcuch znaków zawierający polecenie *SELECT*. Alternatywnie, w pierwszym
argumencie można umieścić obiekt klasy :ref:`Zend_Db_Select <zend.db.select>`. Adapter automatycznie dokonuje
konwersji tego obiektu do łańcucha znaków zawierającego zapytanie *SELECT*.

Drugi argument metody ``fetchAll()`` to tablica wartości używanych do zastąpienia parametrów wiązanych w
zapytaniu *SQL*.

.. _zend.db.adapter.select.fetchall.example:

.. rubric:: Użycie metody fetchAll()

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE bug_id = ?';

   $result = $db->fetchAll($sql, 2);

.. _zend.db.adapter.select.fetch-mode:

Zmiana trybu zwracania danych
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Domyślnie ``fetchAll()`` zwraca tablicę wierszy, z których każdy jest tablicą asocjacyjną. Kluczami tablicy
asocjacyjnej są kolumny lub ich aliasy podane w zapytaniu *SELECT*.

Można ustawić inny tryb zwracania rezultatów poprzez metodę ``setFetchMode()``. Dopuszczalne tryby są
identyfikowane przez stałe:

- **Zend_Db::FETCH_ASSOC**: zwraca dane w postaci tablicy tablic asocjacyjnych. Klucze tablicy asocjacyjnej to
  nazwy kolumn. To jest domyślny tryb zwrotu danych w klasach ``Zend_Db_Adapter``.

  Należy zwrócić uwagę na fakt iż jeśli lista kolumn do zwrotu zawiera więcej niż jedną kolumnę o
  określonej nazwie, np. jeśli pochodzą one z różnych tabel połączonych klauzulą *JOIN*, to w asocjacyjnej
  tablicy wynikowej może być tylko jeden klucz o podanej nazwie. Jeśli używany jest tryb *FETCH_ASSOC*, należy
  upewnić się, że kolumny w zapytaniu *SELECT* posiadają aliasy, dzięki czemu rezultat zapytania będzie
  zawierał unikatowe nazwy kolumn.

  Domyślnie, łańcuchy znaków z nazwami kolumn są zwracane w taki sposób w jaki zostały otrzymane przez
  sterownik bazy danych. Przeważnie jest odpowiada to stylowi nazw kolumn używanego rodzaju bazy danych. Dzięki
  opcji ``Zend_Db::CASE_FOLDING`` można określić wielkość zwracanych znaków. Opcji tej można użyć podczas
  inicjowania adaptera. Przykład: :ref:` <zend.db.adapter.connecting.parameters.example1>`.

- **Zend_Db::FETCH_NUM**: zwraca dane jako tablicę tablic. Indeksami tablicy są liczby całkowite odpowiadające
  pozycji danej kolumny w liście *SELECT* zapytania.

- **Zend_Db::FETCH_BOTH**: zwraca dane jako tablicę tablic. Kluczami tablicy są zarówno łańcuchy znaków (tak
  jak w trybie FETCH_ASSOC) oraz liczby całkowite (tak jak w trybie FETCH_NUM). Należy zwrócić uwagę na fakt
  iż liczba elementów tablicy wynikowej będzie dwukrotnie większa niż w przypadku użycia trybów FETCH_ASSOC
  lub FETCH_NUM.

- **Zend_Db::FETCH_COLUMN**: zwraca dane jako tablicę wartości. Wartości odpowiadają rezultatom zapytania
  przypisanym jednej kolumnie zbioru wynikowego. Domyślnie, jest to pierwsza kolumna, indeksy rozpoczynają się
  od 0.

- **Zend_Db::FETCH_OBJ**: zwraca dane jako tablicę obiektów. Domyślną klasą jest wbudowana w *PHP* klasa
  stdClass. Kolumny rezultatu zapytania stają się właściwościami powstałego obiektu.

.. _zend.db.adapter.select.fetch-mode.example:

.. rubric:: Użycie metody setFetchMode()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchAll('SELECT * FROM bugs WHERE bug_id = ?', 2);

   // $result jest tablicą obiektów
   echo $result[0]->bug_description;

.. _zend.db.adapter.select.fetchassoc:

Pobranie rezultatów jako tablicy asocjacyjnej
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Metoda ``fetchAssoc()`` zwraca dane w formie tablicy tablic asocjacyjnych, niezależnie od wartości ustalonej jako
tryb zwracania rezultatów zapytania.

.. _zend.db.adapter.select.fetchassoc.example:

.. rubric:: Użycie fetchAssoc()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchAssoc('SELECT * FROM bugs WHERE bug_id = ?', 2);

   // $result staje się tablicą tablic asocjacyjnych, mimo ustawionego
   // trybu zwracania rezultatów zapytania
   echo $result[0]['bug_description'];

.. _zend.db.adapter.select.fetchcol:

Zwrócenie pojedynczej kolumny ze zbioru wynikowego
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Metoda ``fetchCol()`` zwraca dane w postaci tablicy wartości niezależnie od wartości ustalonej jako tryb
zwrcania rezultatów zapytania. Ta metoda zwraca pierwszą kolumnę ze zbioru powstałego na skutek wywołania
zapytania. Inne kolumny znajdujące się w tym zbiorze są ignorowane. Aby zwrócić inną niż pierwsza kolumnę
należy skorzystać z przykładu :ref:` <zend.db.statement.fetching.fetchcolumn>`.

.. _zend.db.adapter.select.fetchcol.example:

.. rubric:: Użycie fetchCol()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchCol(
       'SELECT bug_description, bug_id FROM bugs WHERE bug_id = ?', 2);

   // zawiera bug_description; bug_id nie zostanie zwrócona
   echo $result[0];

.. _zend.db.adapter.select.fetchpairs:

Zwrócenie ze zbioru wynikowego par klucz-wartość
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Metoda ``fetchPairs()`` zwraca dane w postaci tablicy par klucz-wartość. Zwracana jest to tablica asocjacyjna z
pojedynczą wartością w każdym polu. Wartości z pierwszej kolumny zapytania *SELECT* stają się kluczami
tablicy wynikowej zaś wartości drugiej zostają umieszczone jako wartości tablicy. Pozostałe kolumny zwracane
przez zapytanie są ignorowane.

Należy konstruować zapytanie *SELECT* w taki sposób aby pierwsza kolumna posiadała unikalne wartości. W
przeciwnym wypadku wartości tablicy asocjacyjnej zostaną nadpisane.

.. _zend.db.adapter.select.fetchpairs.example:

.. rubric:: Użycie fetchPairs()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchPairs('SELECT bug_id, bug_status FROM bugs');

   echo $result[2];

.. _zend.db.adapter.select.fetchrow:

Zwrócenie pojedynczego wiersza ze zbioru wynikowego
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Metoda ``fetchRow()`` pobiera dane używając bieżącego trybu zwracania rezultatów ale zwraca jedynie pierwszy
wiersz ze zbioru wynikowego.

.. _zend.db.adapter.select.fetchrow.example:

.. rubric:: Using fetchRow()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchRow('SELECT * FROM bugs WHERE bug_id = 2');

   // $result to pojedynczy obiekt a nie tablica obiektów
   echo $result->bug_description;

.. _zend.db.adapter.select.fetchone:

Zwrócenie pojedynczej wartości ze zbioru wynikowego
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Metoda ``fetchOne()`` można opisać jako kombinacja ``fetchRow()`` oraz ``fetchCol()`` bo zwraca dane pochodzące
z pierwszego wiersza zbioru wynikowego ograniczając kolumny do pierwszej w wierszu. Ostatecznie zostaje zwrócona
pojedyncza wartość skalarna a nie tablica czy obiekt

.. _zend.db.adapter.select.fetchone.example:

.. rubric:: Using fetchOne()

.. code-block:: php
   :linenos:

   $result = $db->fetchOne('SELECT bug_status FROM bugs WHERE bug_id = 2');

   // pojedyncza wartość string
   echo $result;

.. _zend.db.adapter.write:

Zapisywanie zmian do bazy danych
--------------------------------

Adaptera klasy można użyć również do zapisania nowych, bądź do zmiany istniejących danych w bazie. Ta
część opisuje metody włąściwe dla tych operacji.

.. _zend.db.adapter.write.insert:

Dodawanie danych
^^^^^^^^^^^^^^^^

Za pomocą metody ``insert()`` można dodać nowe wiersze do tabeli bazy danych. Jej pierwszym argumentem jest
łańcuch znaków oznaczający nazwę tabeli. Drugim - tablica asocjacyjna z odwzorowaniem nazw kolumn i wartości
jakie mają zostać w nich zapisane.

.. _zend.db.adapter.write.insert.example:

.. rubric:: Dodawanie danych do tabeli

.. code-block:: php
   :linenos:

   $data = array(
       'created_on'      => '2007-03-22',
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

Kolumny, które nie zostały podane w tablicy z danymi nie będą umieszczone w zapytaniu na zasadzie analogicznej
do użycia polecenia *SQL* *INSERT*: Jeśli kolumna ma podaną wartość domyślną (*DEFAULT*) to ta wartość
zostanie zapisana w nowym wierszu. W przeciwnym przypadku kolumna nie będzie miała żadnej wartości (``NULL``).

Domyślnym sposobem zapisu danych jest użycie parametrów wiązanych. Dzięki temu ryzyko wystąpienia niektórych
form zagrożenia bezpieczeństwa aplikacji jest ograniczone. W tablicy z danymi nie trzeba używać unikania lub
umieszczania wartości w cudzysłowiu.

Może wystąpić potrzeba potraktowania wartości w tablicy danych jako wyrażeń *SQL*. W takim wypadku nie
powinno się stosować umieszczania w cudzysłowiu. Domyślnie wszystkie podane wartości string są traktowane jak
literały. Aby upewnić się, że wartość jest wyrażeniem *SQL* i nie powinna zostać umieszczona w
cudzysłowie, należy ją podać jako obiekt klasy ``Zend_Db_Expr`` zamiast prostego łańcucha znaków.

.. _zend.db.adapter.write.insert.example2:

.. rubric:: Umieszczanie wyrażeń w tabeli

.. code-block:: php
   :linenos:

   $data = array(
       'created_on'      => new Zend_Db_Expr('CURDATE()'),
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

.. _zend.db.adapter.write.lastinsertid:

Pobranie wygenerowanej wartości
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Niektóre systemy zarządzania bazą danych wspierają klucze pierwotne o automatycznie zwiększanych wartościach.
Tabela zdefiniowana w ten sposób generuje wartość klucza pierwotnego automatycznie przy każdym poleceniu
*INSERT*. Wartością zwracaną przez metodę ``insert()`` **nie** jest ostatni zapisany identyfikator, ponieważ
tabela mogła nie posiadać automatycznie inkrementowanej kolumny. Zamiast tego wartością zwrotną jest ilość
zapisanych wierszy (przeważnie 1).

Jeśli tabela jest zdefiniowana za pomocą automatycznego klucza pierwotnego to można użyć metody
``lastInsertId()``. Po udanym dodaniu wiersza metoda ta zwraca ostatnią wartość klucza wygenerowaną w ramach
bieżącego połączenia.

.. _zend.db.adapter.write.lastinsertid.example-1:

.. rubric:: Użycie lastInsertId() dla automatycznego klucza pierwotnego

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // zwrócenie ostatniej wartości wygenerowanej przez automatyczną kolumnę
   $id = $db->lastInsertId();

Niektóre systemy zarządzania bazą danych wspierają obiekt sekwencji, który służy do generowania unikalnych
wartości, które mogą posłużyć jako klucz pierwotny. Aby obsługiwać również sekwencje metoda
``lastInsertId()`` akceptuje dodatkowe dwa argumenty. Pierwszym z nich jest nazwa tabeli zaś drugim - nazwa
kolumny. Założona jest konwencja według której sekwencja ma nazwę składającą się z nazwy tabeli oraz
kolumny do której generuje wartości z dodatkowym sufiksem "\_seq". Podstawą tego założenia są domyślne
ustawienia PostgreSQL. Przykładowo tabela "bugs" z kluczem pierwotnym w kolumnie "bug_id" będzie używała
sekwencji o nazwie "bugs_bug_id_seq".

.. _zend.db.adapter.write.lastinsertid.example-2:

.. rubric:: Użycie lastInsertId() dla sekwencji

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // zwrócenie ostatniej wartości wygenerowanej przez sekwencję 'bugs_bug_id_seq'
   $id = $db->lastInsertId('bugs', 'bug_id');

   // zwrócenie ostatniej wartości wygenerowanej przez sekwencję 'bugs_seq'
   $id = $db->lastInsertId('bugs');

Jeśli nazwa obiektu sekwencji nie podąża za tą konwencją można użyć metody ``lastSequenceId()``, która
przyjmuje pojedynczy łańcuch znaków - nazwę sekwencji - jako argument.

.. _zend.db.adapter.write.lastinsertid.example-3:

.. rubric:: Użycie lastSequenceId()

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // zwrócenie ostatniej wartości wygenerowanej przez sekwencję 'bugs_id_gen'
   $id = $db->lastSequenceId('bugs_id_gen');

Dla systemów zarządzania bazą danych które nie wspierają sekwencji, włączając MySQL, Microsoft *SQL*
Server, oraz SQLite dodatkowe argumenty podane do metody ``lastInsertId()`` są ignorowane a zwrócona jest
ostatnia wartość wygenerowana dla dowolnej tabeli poprzez polecenie *INSERT* podczas bieżącego połączenia.
Dla tych *RDBMS* metoda ``lastSequenceId()`` zawsze zwraca ``NULL``.

.. note::

   **Dlaczego nie należy używać "SELECT MAX(id) FROM table"?**

   Powyższe zapytanie często zwraca ostatni klucz pierwotny, jaki został zapisany w wierszu tabeli. Ten sposób
   nie jest jednak bezpieczny w przypadku, gdy wiele klientów zapisuje rekordy do bazy danych. Jest możliwe, że
   w momencie pomiędzy zapisaniem jednego rekordu a zapytaniem o ``MAX(id)``, do tabeli zostanie zapisany kolejny
   rekord, wprowadzony przez innego użytkownika. Przez to zwrócona wartość nie będzie identyfikowała
   pierwszego wprowadzonego wiersza tylko drugi - wprowadzony przez inne połączenie. Nie ma pewnego sposobu na
   wykrycie, że do takiego zdarzenia doszło.

   Zastosowanie mocnej izolacji transakcji, tak jak przy trybie "repeatable read" może pomóc w ograniczeniu
   ryzyka wystąpienia takiej sytuacji ale niektóre systemy zarządzania bazą danych nie wspierają izolacji
   transakcji w wystarczającym stopniu lub aplikacja może intencjonalnie korzystać jedynie z niskiego trybu
   izolacji transakcji.

   Dodatkowo, używanie wyrażeń takich jak "MAX(id)+1" do generowania nowych wartości klucza głównego nie jest
   bezpieczne bo dwa połączenia mogą wykonać to zapytanie praktycznie jednocześnie i w rezultacie próbować
   użyć jednakowej wartości dla kolejnego polecenia *INSERT*.

   Wszystkie systemy zarządzania bazą danych udostępniają mechanizmy służące generowaniu unikalnych
   wartości oraz zwracaniu ostatniej z nich. Mechanizmy te intencjonalnie działają poza zasięgiem izolacji
   transakcji więc nie jest możliwe aby wartość wygenerowana dla jednego klienta pojawiła się jako ostatnia
   wygenerowana dla innego połączenia.

.. _zend.db.adapter.write.update:

Aktualizacja danych
^^^^^^^^^^^^^^^^^^^

Aktualizacji wierszy tabeli w bazie danych można dokonać poprzez metodę adaptera ``update()``. Metoda przyjmuje
trzy argumenty: pierwszym jest nazwa tabeli; drugim - tablica asocjacyjna mapująca kolumny, które mają ulec
zmianie oraz wartości jakie kolumny przybiorą; trzecim - warunek wyznaczający wiersze do zmiany.

Wartości w tablicy z danymi są traktowane jak literały znakowe. Należy zapoznać się z akapitem :ref:`
<zend.db.adapter.write.insert>` aby uzyskać więcej informacji na temat użyci w niej wyrażeń *SQL*.

Trzecim argumentem metody jest string zawierający wyrażenie *SQL* będące kryterium wyznaczającym wiersze do
zmiany. Wartości i identyfikatory w tym argumencie nie są umieszczane w cudzysłowie ani unikane. Należy, więc,
zadbać o to samemu. Należy zapoznać się z akapitem :ref:` <zend.db.adapter.quoting>` aby zasięgnąć
dodatkowych informacji.

Wartością zwracaną jest ilość wierszy zmienionych przez operację aktualizacji.

.. _zend.db.adapter.write.update.example:

.. rubric:: Aktualizacja wierszy

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $n = $db->update('bugs', $data, 'bug_id = 2');

Jeśli trzeci argument nie zostanie podany to wszystkie wiersze w tabeli zostaną zaktualizowane zgodnie z
kolumnami i wartościami podanymi w drugim argumencie.

Jeśli trzeci argument zostanie podany jako tablica łańcuchów znakowych to w zapytaniu łańcuchy zostaną
połączone za pomocą operatorów ``AND``.

Przy podaniu trzeciego argumentu jako tablicy tablic, ich wartości zostaną automatycznie otoczone cudzysłowami i
umieszczone w kluczach tych tablic. Po czym zostaną połączone za pomocą operatorów ``AND``.

.. _zend.db.adapter.write.update.example-array:

.. rubric:: Aktualizacja wierszy tablicy za pomocą tablicy wyrażeń

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $where[] = "reported_by = 'goofy'";
   $where[] = "bug_status = 'OPEN'";

   $n = $db->update('bugs', $data, $where);

   // Powstałe wyrażenie SQL to:
   //  UPDATE "bugs" SET "update_on" = '2007-03-23', "bug_status" = 'FIXED'
   //  WHERE ("reported_by" = 'goofy') AND ("bug_status" = 'OPEN')

.. _zend.db.adapter.write.update.example-arrayofarrays:

.. rubric:: Aktualizacja wierszy tablicy za pomocą tablicy tablic

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $where['reported_by = ?'] = 'goofy';
   $where['bug_status = ?']  = 'OPEN';

   $n = $db->update('bugs', $data, $where);

   // Powstałe wyrażenie SQL to:
   //  UPDATE "bugs" SET "update_on" = '2007-03-23', "bug_status" = 'FIXED'
   //  WHERE ("reported_by" = 'goofy') AND ("bug_status" = 'OPEN')

.. _zend.db.adapter.write.delete:

Usuwanie danych
^^^^^^^^^^^^^^^

Usuwania danych można dokonać używając metody ``delete()``. Przyjmuje ona dwa argumenty: pierwszym z nich jest
łańcuch znaków z nazwą tabeli; Drugim - warunek określający wiersze do usunięcia.

Drugi argument to string zawierający wyrażenie *SQL* użyte jako kryterium wyznaczania usuwanych wierszy.
Wartości i identyfikatory nie są unikane ani umieszczane w cudzysłowie - należy zatroszczyć się o to samemu.
Aby dowiedzieć się więcej na ten temat można skorzystać z akapitu :ref:` <zend.db.adapter.quoting>`.

Wartość zwrotna to ilość wierszy, jakie uległy zmianie w wyniku zadziałania operacji usuwania.

.. _zend.db.adapter.write.delete.example:

.. rubric:: Usuwanie wierszy

.. code-block:: php
   :linenos:

   $n = $db->delete('bugs', 'bug_id = 3');

Jeśli drugi argument nie zostanie podany to wszystkie wiersze z tabeli ulegną usunięciu.

Jeśli drugi argument zostanie podany jako tablica łańcuchów znaków to te łańcuchy ulegną konkatenacji jako
wyrażenia logiczne połączone operatorem ``AND``.

Jeśli trzeci argument będzie tablicą tablic to jej wartości zostaną automatycznie otoczone cudzysłowami i
umieszczona w kluczach tablic. Potem zostaną połączone razem za pomocą operatora ``AND``.

.. _zend.db.adapter.quoting:

Umieszczanie wartości i identyfikatorów w cudzysłowie
-----------------------------------------------------

Podczas tworzenia zapytań *SQL* często dochodzi do sytuacji, w której niezbędne jest umieszczenie wartości
zmiennych *PHP* w wyrażeniach *SQL*. Stanowi to zagrożenie, ponieważ jeśli wartość łańcuchowej zmiennej
*PHP* zawiera określone znaki, takie jak symbol cudzysłowu, to mogą one spowodować błąd w poleceniu *SQL*.
Poniżej znajduje się przykład zapytania zawierającego niespójną liczbę symboli cudzysłowu:

   .. code-block:: php
      :linenos:

      $name = "O'Reilly";
      $sql = "SELECT * FROM bugs WHERE reported_by = '$name'";

      echo $sql;
      // SELECT * FROM bugs WHERE reported_by = 'O'Reilly'



Zagrożenie potęguje fakt iż podobne błędy mogą zostać wykorzystane przez osobę próbującą zmanipulować
działanie funkcji aplikacji. Jeśli takiej osobie uda się wpłynąć na wartość zmiennej *PHP* poprzez parametr
*HTTP* (bądź inny mechanizm), to będzie mogła zmienić zapytanie *SQL* tak by dokonywało operacji zupełnie
niezamierzonych przez twórców, takich jak zwrócenie danych, do których osoba nie powinna mieć dostępu. To
jest poważny i szeroko rozpowszechniony sposób łamania zabezpieczeń aplikacji znany pod nazwą "SQL Injection"
(wstrzyknięcie SQL -`http://en.wikipedia.org/wiki/SQL_Injection`_).

Adaptery klasy ``Zend_Db`` udostępniają funkcje przydatne do zredukowania zagrożenia atakiem *SQL* Injection w
kodzie *PHP*. Przyjętym rozwiązaniem jest unikanie znaków specjalnych takich jak cudzysłów w wartościach
zmiennych *PHP* przed umieszczeniem ich w poleceniu *SQL*. Takie podejście zapewnia ochronę przed przypadkową
jak i intencjonalną zmianą znaczenia poleceń *SQL* przez zmienne *PHP* zawierające znaki specjalne.

.. _zend.db.adapter.quoting.quote:

Użycie quote()
^^^^^^^^^^^^^^

Metoda ``quote()`` przyjmuje pojedynczy argument - łańcuch znaków. Na wyjściu zwraca podany argument ze
wszystkimi znakami specjalnymi poddanymi uniknięciu w sposób właściwy dla używanego *RDBMS* i otoczony znakami
ograniczającymi łańcuchy znakowe. Standardowym znakiem ograniczającym stringi w *SQL* jest pojedynczy
cudzysłów (').

.. _zend.db.adapter.quoting.quote.example:

.. rubric:: Użycie quote()

.. code-block:: php
   :linenos:

   $name = $db->quote("O'Reilly");
   echo $name;
   // 'O\'Reilly'

   $sql = "SELECT * FROM bugs WHERE reported_by = $name";

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

Należy zwrócić uwagę, że wartość zwrotna metody ``quote()`` zawiera znaki ograniczające stringi. Jest to
zachowanie różne od niektórych funkcji które unikają specjalne znaki ale nie ujmują całego łańcucha w
znaki ograniczające, tak jak `mysql_real_escape_string()`_.

Wartości mogą wymagać umieszczenia w cudzysłowach lub nie, zgodnie z kontekstem używanego typu danych *SQL*. W
przypadku niektórych rodzajów systemów zarządzania bazą danych liczby całkowite nie mogą być ograniczane
cudzysłowami jeśli są porównywane z kolumną lub wyrażeniem zwracającym inną liczbę całkowitą. Innymi
słowy, poniższy zapis może wywołać błąd w niektórych implementacjach *SQL* zakładając, że ``intColumn``
jest określona typem danych ``INTEGER``.

   .. code-block:: php
      :linenos:

      SELECT * FROM atable WHERE intColumn = '123'



Można użyć opcjonalnego, drugiego argumentu metody ``quote()`` aby określić typ danych *SQL* i ograniczyć
stosowanie cudzysłowu.

.. _zend.db.adapter.quoting.quote.example-2:

.. rubric:: Użycie quote() z podanym typem danych SQL

.. code-block:: php
   :linenos:

   $value = '1234';
   $sql = 'SELECT * FROM atable WHERE intColumn = '
        . $db->quote($value, 'INTEGER');

Każda klasa ``Zend_Db_Adapter`` ma zapisane nazwy numerycznych typów danych *SQL* odpowiednio do swojego rodzaju
*RDBMS*. Zamiast tego można w tym miejscu również korzystać ze stałych ``Zend_Db::INT_TYPE``,
``Zend_Db::BIGINT_TYPE`` oraz ``Zend_Db::FLOAT_TYPE`` aby uniezależnić kod od rodzaju bazy danych.

``Zend_Db_Table`` automatycznie określa typy danych *SQL* dla metody ``quote()`` podczas generowania zapytań
*SQL* odnoszących się do klucza pierwotnego tabeli.

.. _zend.db.adapter.quoting.quote-into:

Użycie quoteInto()
^^^^^^^^^^^^^^^^^^

Najbardziej typowym przypadkiem użycia cudzysłowu do ograniczania zmiennych jest umieszczenie zmiennej *PHP* w
zapytaniu *SQL*. Aby to osiągnąć można użyć metody ``quoteInto()``. Przyjmuje ona dwa argumenty: pierwszym
jest łańcuch znaków zawierający symbol "?", który zostanie zastąpiony; drugim jest zmienna *PHP*, która ma
trafić na miejsce "?".

Zastępowany symbol jest używany przez wielu producentów baz danych do oznaczenia pozycyjnych parametrów
wiązanych ale metoda ``quoteInto()`` jedynie emuluje takie parametry. W wyniku jej działania wartość zmiennej
jest zwyczajnie umieszczana w łańcuchu z zapytaniem, po wstępnym uniknięciu specjalnych znaków i umieszczeniu
w cudzysłowie. Prawdziwa implementacja parametrów wiązanych zakłada separację łańcucha znaków polecenia
*SQL* od samych parametrów oraz wstępne parsowanie polecenia na serwerze bazy danych.

.. _zend.db.adapter.quoting.quote-into.example:

.. rubric:: Użycie quoteInto()

.. code-block:: php
   :linenos:

   $sql = $db->quoteInto("SELECT * FROM bugs WHERE reported_by = ?", "O'Reilly");

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

Można użyć opcjonalnego, trzeciego parametru metody ``quoteInto()`` aby określić typ danych *SQL*. Numeryczne
typy danych (w przeciwieństwie do innych typów) nie podlegają umieszczaniu w cudzysłowie.

.. _zend.db.adapter.quoting.quote-into.example-2:

.. rubric:: Użycie quoteInto() z podaniem typu danych SQL

.. code-block:: php
   :linenos:

   $sql = $db
       ->quoteInto("SELECT * FROM bugs WHERE bug_id = ?", '1234', 'INTEGER');

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 1234

.. _zend.db.adapter.quoting.quote-identifier:

Użycie quoteIdentifier()
^^^^^^^^^^^^^^^^^^^^^^^^

Wartości nie są jedyną częścią składni polecenia *SQL*, która może być zmienna. W przypadku użycia
zmiennych *PHP* do określenia tabel, kolumn lub innych identyfikatorów zapytania *SQL*, może zajść potrzeba
umieszczenia również tych elementów w cudzysłowie. Domyślnie identyfikatory *SQL* muszą przestrzegać
określonych reguł - podobnie jak w *PHP* oraz większości innych języków programowania. Przykładem takiej
reguły jest zakaz używania spacji lub określonych znaków interpunkcyjnych, specjalnych ani też znaków spoza
ASCII. Poza tym istnieje lista określonych słów, które służą do tworzenia zapytań - ich też nie powinno
się używać jako identyfikatorów.

Mimo to *SQL* posiada **ograniczone identyfikatory** (delimited identifiers), dzięki którym można skorzystać z
większego wachlarza znaków do nazywania obiektów. Jeśli określony identyfikator zostanie ograniczony
odpowiednim rodzajem cudzysłowu to będzie można użyć znaków, które bez tego ograniczenia spowodowałyby
błąd. Identyfikatory ograniczone mogą zawierać spacje, znaki interpunkcyjne czy lokalne litery. Można nawet
używać zarezerwowanych słów *SQL* jeśli zostaną otoczone odpowiednimi znakami ograniczającymi.

Metoda ``quoteIdentifier()`` zachowuje się podobnie jak ``quote()`` ale otacza podany łańcuch znaków za pomocą
znaków ograniczających zgodnie z rodzajem używanego adaptera. Standardowy *SQL* używa podwójnego cudzysłowu
(") jako znaku ograniczającego a większość systemów zarządzania bazą danych podąża za tym przykładem.
MySQL domyślnie używa znaków back-tick (\`). Metoda ``quoteIdentifier()`` dokonuje również unikania znaków
specjalnych znajdujących się w przekazanym argumencie.

.. _zend.db.adapter.quoting.quote-identifier.example:

.. rubric:: Użycie quoteIdentifier()

.. code-block:: php
   :linenos:

   // można użyć tabeli o nazwie takiej samej jak słowo zarezerwowane SQL
   $tableName = $db->quoteIdentifier("order");

   $sql = "SELECT * FROM $tableName";

   echo $sql
   // SELECT * FROM "order"

W *SQL* identyfikatory ograniczone są wrażliwe na wielkość liter, w przeciwieństwie do zwykłych
identyfikatorów. Przez to, należy upewnić się, że pisownia identyfikatora w 100% odpowiada pisowni zapisanej w
schemacie, włącznie z wielkością liter.

W większości przypadków gdzie polecenie *SQL* jest generowane wewnątrz klas ``Zend_Db``, domyślnym zachowaniem
jest automatyczne ograniczanie identyfikatorów. Można to zmienić poprzez opcję
``Zend_Db::AUTO_QUOTE_IDENTIFIERS`` wywoływaną podczas inicjalizacji adaptera. Więcej informacji: :ref:`
<zend.db.adapter.connecting.parameters.example2>`.

.. _zend.db.adapter.transactions:

Kontrolowanie transakcji bazy danych
------------------------------------

W świecie baz danych transakcja to zbiór operacji, który może zostać zapisany bądź cofnięty za pomocą
jednej instrukcji, nawet jeśli zmiany wynikające z tych operacji dotyczyły wielu tabel. Wszystkie zapytania do
bazy danych są przeprowadzane w kontekście transakcji. Jeśli nie są zarządzane jawnie to sterownik bazy danych
używa ich w sposób przezroczysty dla użytkownika. Takie podejście nazywa się trybem **auto-commit**- sterownik
bazy danych tworzy transakcje dla każdego tworzonego polecenia i zapisuje efekty jego działania po każdym
wywołaniu polecenia *SQL*. Domyślnie wszystkie adaptery ``Zend_Db`` działają w trybie **auto-commit**.

Można również bezpośrednio wskazać początek i koniec transakcji i w ten sposób kontrolować ilość zapytań
*SQL* jakie trafiają do zapisania (bądź cofnięcia) jako pojedyncza operacja. Aby rozpocząć transakcję
należy wywołać metodę ``beginTransaction()``. Następujące po niej polecenia *SQL* są wykonywane w
kontekście wspólnej transakcji do momentu zasygnalizowania jej końca.

Aby zakończyć transakcję należy użyć metody ``commit()`` lub ``rollBack()``. Pierwsza z nich powoduje
zapisanie zmian wynikających z operacji przeprowadzonych w czasie transakcji. Oznacza to, że efekty tych zmian
będą widoczne w wynikach zapytań wywołanych w ramach innych transakcji.

Metoda ``rollBack()`` dokonuje odwrotnej operacji: cofa zmiany dokonane podczas transakcji. W efekcie wszystkie
dane zmienione podczas transakcji zostają cofnięte do wartości z momentu przed jej rozpoczęciem. Cofnięcie
zmian jednej transakcji nie ma wpływu na zmiany dokonane przez inną transakcję trwającą nawet w tym samym
czasie.

Po skończonej transakcji ``Zend_Db_Adapter`` wraca do trybu auto-commit do momentu ponownego wywołania metody
``beginTransaction()`` i ręcznego rozpoczęcia nowej transakcji.

.. _zend.db.adapter.transactions.example:

.. rubric:: Kontrolowanie transakcjami dla zachowania spójności

.. code-block:: php
   :linenos:

   // Ręczne rozpoczęcie transakcji
   $db->beginTransaction();

   try {
       // Próba wywołania jednego bądź wielu zapytań:
       $db->query(...);
       $db->query(...);
       $db->query(...);

       // Jeśli wszystkie odniosły sukces - zapisanie transakcji, dzięki czemu wszystkie rezultaty
       // zostaną zapisane za jednym razem.
       $db->commit();

   } catch (Exception $e) {
       // Jeśli któreś z zapytań zakończyło się niepowodzeniem i został wyrzucony wyjątek, należy
       // cofnąć całą transakcję odwracając zmiany w niej dokonane (nawet te które zakończyły się
       // sukcesem). Przez to albo wszystkie zmiany zostają zapisane albo żadna.
       $db->rollBack();
       echo $e->getMessage();
   }

.. _zend.db.adapter.list-describe:

Uzyskiwanie listy i opisu tabel
-------------------------------

Metoda ``listTables()`` zwraca tablicę łańcuchów znakowych, zawierającą wszystkie tabele w bieżącej bazie
danych.

Metoda ``describeTable()`` zwraca tablicę asocjacyjną metadanych tabeli. Jako argument należy podać nazwę
tabeli. Drugi argument jest opcjonalny - wskazuje nazwę schematu w którym tabela się znajduje.

Kluczami zwracanej tablicy asocjacyjnej są nazwy kolumn tabeli. Wartość przy każdej kolumnie to następna
tablica asocjacyjna z następującymi kluczami i wartościami:

.. _zend.db.adapter.list-describe.metadata:

.. table:: Metadane zwracane przez describeTable()

   +----------------+---------+------------------------------------------------------------------------------------------------+
   |Klucz           |Typ      |Opis                                                                                            |
   +================+=========+================================================================================================+
   |SCHEMA_NAME     |(string) |Nazwa schematu bazy danych, w którym tabela się znajduje.                                       |
   +----------------+---------+------------------------------------------------------------------------------------------------+
   |TABLE_NAME      |(string) |Nazwa tabeli zawierającej daną kolumnę.                                                         |
   +----------------+---------+------------------------------------------------------------------------------------------------+
   |COLUMN_NAME     |(string) |Nazwa kolumny.                                                                                  |
   +----------------+---------+------------------------------------------------------------------------------------------------+
   |COLUMN_POSITION |(integer)|Liczba porządkowa wskazująca na miejsce kolumny w tabeli.                                       |
   +----------------+---------+------------------------------------------------------------------------------------------------+
   |DATA_TYPE       |(string) |Nazwa typu danych dozwolonych w kolumnie.                                                       |
   +----------------+---------+------------------------------------------------------------------------------------------------+
   |DEFAULT         |(string) |Domyślna wartość kolumny (jeśli istnieje).                                                      |
   +----------------+---------+------------------------------------------------------------------------------------------------+
   |NULLABLE        |(boolean)|TRUE jeśli columna dopuszcza wartości SQLNULL, FALSE jeśli kolumna zawiera ograniczenie NOTNULL.|
   +----------------+---------+------------------------------------------------------------------------------------------------+
   |LENGTH          |(integer)|Dopuszczalny rozmiar kolumny, w formie zgłoszonej przez serwer bazy danych.                     |
   +----------------+---------+------------------------------------------------------------------------------------------------+
   |SCALE           |(integer)|Skala typów SQL NUMERIC lub DECIMAL.                                                            |
   +----------------+---------+------------------------------------------------------------------------------------------------+
   |PRECISION       |(integer)|Precyzja typów SQL NUMERIC lub DECIMAL.                                                         |
   +----------------+---------+------------------------------------------------------------------------------------------------+
   |UNSIGNED        |(boolean)|TRUE jeśli typ danych liczbowych ma klauzulę UNSIGNED.                                          |
   +----------------+---------+------------------------------------------------------------------------------------------------+
   |PRIMARY         |(boolean)|TRUE jeśli kolumna jest częścią klucza pierwotnego tabeli.                                      |
   +----------------+---------+------------------------------------------------------------------------------------------------+
   |PRIMARY_POSITION|(integer)|Liczba porządkowa (min. 1) oznaczająca pozycję kolumny w kluczu pierwotnym.                     |
   +----------------+---------+------------------------------------------------------------------------------------------------+
   |IDENTITY        |(boolean)|TRUE jeśli kolumna korzysta z wartości automatycznie generowanych.                              |
   +----------------+---------+------------------------------------------------------------------------------------------------+

.. note::

   **Pole metadanych IDENTITY w różnych systemach zarządzania bazą danych**

   Pole metadanych IDENTITY zostało wybrane jako ogólny termin określający relację do klucza tabeli. Może
   być znany pod następującymi nazwami:

   - ``IDENTITY``- DB2, MSSQL

   - ``AUTO_INCREMENT``- MySQL

   - ``SERIAL``- PostgreSQL

   - ``SEQUENCE``- Oracle

Jeśli w bazie danych nie istnieje tabela i schemat o podanych nazwach to ``describeTable()`` zwraca pustą
tablicę.

.. _zend.db.adapter.closing:

Zamykanie połączenia
--------------------

Najczęściej nie ma potrzeby zamykać połączenia z bazą danych. *PHP* automatycznie czyści wszystkie zasoby
pod koniec działania. Rozszerzenia bazy danych są zaprojektowane w taki sposób aby połączenie zostało
zamknięte w momencie usunięcia referencji do obiektu zasobu.

Jednak w przypadku skryptu *PHP*, którego czas wykonania jest znaczący, który inicjuje wiele połączeń z bazą
danych, może zajść potrzeba ręcznego zamknięcia połączenia aby ograniczyć wykorzystanie zasobów serwera
bazy danych. Aby wymusić zamknięcie połączenia z bazą danych należy użyć metody adaptera
``closeConnection()``.

Od wersji 1.7.2 istnieje możliwość sprawdzenia czy w obecnej chwili połączenie z serwerem bazy danych
występuje za pomocą metody ``isConnected()``. Jej rezultat oznacza czy zasób połączenia został ustanowiony i
nie został zamknięty. Ta metoda nie jest zdolna sprawdzić zamknięcia połączenia od strony serwera bazy
danych. Dzięki użyciu jej w wewnętrznych metodach zamykających połączenie można dokonywać wielokrotnego
zamknięcia połączenia bez ryzyka wystąpienia błędów. Przed wersją 1.7.2 było to możliwe jedynie w
przypadku adapterów *PDO*.

.. _zend.db.adapter.closing.example:

.. rubric:: Zamknięcie połączenia z bazą danych

.. code-block:: php
   :linenos:

   $db->closeConnection();

.. note::

   **Czy Zend_Db wspiera połączenia trwałe (Persistent Connections)?**

   Tak, trwałe połączenia są wspierane poprzez flagę ``persistent`` ustawioną na wartość ``TRUE`` w
   konfiguracji adaptera ``Zend_Db`` (a nie sterownika bazy danych).

   .. _zend.db.adapter.connecting.persistence.example:

   .. rubric:: Użycie flagi stałego połączenia z adapterem Oracle

   .. code-block:: php
      :linenos:

      $db = Zend_Db::factory('Oracle', array(
          'host'       => '127.0.0.1',
          'username'   => 'webuser',
          'password'   => 'xxxxxxxx',
          'dbname'     => 'test',
          'persistent' => true
      ));

   Należy zwrócić uwagę, że używanie połączeń stałych może zwiększyć ilość nieużywanych połączeń
   na serwerze bazy danych. Przez to, korzyści w wydajności (wynikające z wykluczenia potrzeby nawiązywania
   połączenia przy każdym żądaniu) mogą zostać skutecznie przeważone przez problemy spowodowane przez tą
   technikę.

   Połączenia z bazą danych mają stany. Oznacza to, że pewne obiekty na serwerze bazy danych istnieją w
   kontekście sesji. Chodzi o blokady, zmienne użytkownika, tabele tymczasowe, informacje o ostatnio wykonanym
   zapytaniu - takie jak ilość pobranych wierszy, ostatnia wygenerowana wartość identyfikatora. W przypadku
   użycia połączeń stałych istnieje ryzyko, że aplikacja uzyska dostęp do niepoprawnych bądź
   zastrzeżonych danych, które zostały utworzone podczas poprzedniego żądania.

   W obecnym stanie jedynie adaptery Oracle, DB2 oraz *PDO* (zgodnie z dokumentacją *PHP*) wspierają połączenia
   stałe w ``Zend_Db``.

.. _zend.db.adapter.other-statements:

Wykonywanie innych poleceń na bazie danych
------------------------------------------

Podczas tworzenia kodu może zajść potrzeba uzyskania dostępu bezpośrednio do obiektu połączenia tak jak
udostępnia to używane rozszerzenie bazy danych *PHP*. Niektóre rozszerzenia mogą oferować funkcje
nieodzwierciedlone w metodach klasy ``Zend_Db_Adapter_Abstract``.

Wszystkie polecenia *SQL* w ``Zend_Db`` są wywoływane poprzez instrukcje preparowane (prepared statement). Jednak
niektóre funkcje bazy danych są z nimi niekompatybilne. Polecenia *DDL* takie jak CREATE czy ALTER nie mogą być
wywoływane w ten sposób w MySQL. Dodatkowo polecenia *SQL* nie korzystają z `cache'u zapytań MySQL (MySQL Query
Cache)`_ dla wersji wcześniejszej niż MySQL 5.1.17.

Większość rozszerzeń baz danych *PHP* umożliwia wywoływanie poleceń *SQL* bez preparowania. W przypadku
*PDO* jest to możliwe poprzez metodę ``exec()``. Aby uzyskać dostęp do obiektu połączenia odpowiedniego
rozszerzenia *PHP* należy wywołać metodę ``getConnection()``.

.. _zend.db.adapter.other-statements.example:

.. rubric:: Wywołanie polecenia niepreparowanego dla adaptera PDO

.. code-block:: php
   :linenos:

   $result = $db->getConnection()->exec('DROP TABLE bugs');

W podobny sposób można korzystać z innych metod szczególnych dla konkretnego rozszerzenia *PHP*. Należy jednak
mieć w pamięci, iż w ten sposób ogranicza się tworzoną aplikację do współpracy z interfejsem oferowanym
jedynie przez konkretne rozszerzenie konkretnej bazy danych.

W przyszłych wersjach ``Zend_Db`` planowane jest umieszczanie dodatkowych metod służących do obejmowania
funkcjonalności wspólnych dla wielu rozszerzeń baz danych *PHP* ale wsteczna kompatybilność zostanie
zachowana.

.. _zend.db.adapter.server-version:

Pobranie wersji serwera
-----------------------

Począwszy od wersji 1.7.2 można pobrać wersję serwera bazy danych w formie podobnej do numeru wersji *PHP* tak
aby można było skorzystać z funkcji ``version_compare()``. Jeśli taka informacja nie jest dostępna to zostanie
zwrócona wartość ``NULL``.

.. _zend.db.adapter.server-version.example:

.. rubric:: Weryfikacja wersji serwera przed wywołaniem zapytania

.. code-block:: php
   :linenos:

   $version = $db->getServerVersion();
   if (!is_null($version)) {
       if (version_compare($version, '5.0.0', '>=')) {
           // wykonanie zapytania
       } else {
           // wykonanie innego zapytania
       }
   } else {
       // wersja serwera niedostępna
   }

.. _zend.db.adapter.adapter-notes:

Informacje o konkretnych adapterach
-----------------------------------

Ten akapit wymienia różnice pomiędzy klasami adapterów, z istnienia których należy sobie zdawać sprawę.

.. _zend.db.adapter.adapter-notes.ibm-db2:

IBM DB2
^^^^^^^

- Aby uzyskać ten adapter poprzez metodę ``factory()`` należy użyć nazwy 'Db2'.

- Ten adapter używa rozszerzenia *PHP* ibm_db2.

- IBM DB2 wspiera sekwencje oraz klucze automatycznie zwiększające. Przez to argumenty dla ``lastInsertId()`` są
  opcjonalne. Jeśli nie poda się argumentów adapter zwróci ostatnią wartość wygenerowaną dla klucza
  automatycznego. Jeśli argumenty zostaną podane to adapter zwróci ostatnią wartość wygenerowaną przez
  sekwencję o nazwie zgodnej z konwencją '**tabela**\ _ **kolumna**\ _seq'.

.. _zend.db.adapter.adapter-notes.mysqli:

MySQLi
^^^^^^

- Aby uzyskać ten adapter poprzez metodę ``factory()`` należy użyć nazwy 'Mysqli'.

- Ten adapter używa rozszerzenia *PHP* mysqli.

- MySQL nie wspiera sekwencji więc ``lastInsertId()`` ignoruje argumenty i zwraca ostatnią wartość
  wygenerowaną dla klucza automatycznego. Metoda ``lastSequenceId()`` zwraca ``NULL``.

.. _zend.db.adapter.adapter-notes.oracle:

Oracle
^^^^^^

- Aby uzyskać ten adapter poprzez metodę ``factory()`` należy użyć nazwy 'Oracle'.

- Ten adapter używa rozszerzenia *PHP* oci8.

- Oracle nie wspiera kluczy automatycznych więc należy podać nazwę sekwencji w metodzie ``lastInsertId()`` lub
  ``lastSequenceId()``.

- Rozszerzenie Oracle nie wspiera parametrów pozycyjnych. Należy używać nazwanych parametrów.

- Obecnie, opcja ``Zend_Db::CASE_FOLDING`` nie jest zaimplementowana w tym adapterze. Aby użyć tej opcji z Oracle
  zalecane jest korzystanie z adaptera *PDO* OCI.

- Domyślnie pola LOB są zwracane jako obiekty OCI-Lob. Można ustawić pobieranie ich w formie łańcuchów
  znakowych dla wszystkich żądań poprzez opcję sterownika '``lob_as_string``'. Aby jednorazowo pobrać obiekt
  Lob jako string należy użyć metody ``setLobAsString(boolean)`` na adapterze lub na obiekcie zapytania.

.. _zend.db.adapter.adapter-notes.sqlsrv:

Microsoft SQL Server
^^^^^^^^^^^^^^^^^^^^

- Aby uzyskać ten adapter poprzez metodę ``factory()`` należy użyć nazwy 'Sqlsrv'.

- Ten adapter używa rozszerzenia *PHP* sqlsrv.

- Microsoft *SQL* Server nie wspiera sekwencji więc ``lastInsertId()`` ignoruje argument określający klucz
  pierwotny i zwraca ostatnią wartość wygenerowaną przez automatyczny klucz (jeśli jest podana nazwa tabeli)
  lub identyfikator zwrócony przez ostatnie polecenie INSERT. Metoda ``lastSequenceId()`` zwraca ``NULL``.

- ``Zend_Db_Adapter_Sqlsrv`` ustawia opcję ``QUOTED_IDENTIFIER ON`` bezpośrednio po połączeniu się z bazą
  danych *SQL* Server. To powoduje, że sterownik zaczyna używać standardowego znaku cudzysłowu (**"**) jako
  ograniczenia identyfikatorów zamiast - charakterystycznych dla produktu Microsoftu - nawiasów kwadratowych.

- Jednym z kluczy podawanych do tablicy opcji może być ``driver_options`` dzięki czemu można skorzystać z
  wartości podanych w dokumentacji *SQL* Server `http://msdn.microsoft.com/en-us/library/cc296161(SQL.90).aspx`_.

- Dzięki metodzie ``setTransactionIsolationLevel()`` można ustawić poziom izolacji transakcji dla bieżącego
  połączenia. Rozpoznawane wartości to ``SQLSRV_TXN_READ_UNCOMMITTED``, ``SQLSRV_TXN_READ_COMMITTED``,
  ``SQLSRV_TXN_REPEATABLE_READ``, ``SQLSRV_TXN_SNAPSHOT`` or ``SQLSRV_TXN_SERIALIZABLE``.

- Począwszy od Zend Framework 1.9 minimalną wspieraną wersją rozszerzenia *PHP* Microsoft *SQL* Server jest
  1.0.1924.0. a dla *MSSQL* Server Native Client - wersja 9.00.3042.00.

.. _zend.db.adapter.adapter-notes.pdo-ibm:

PDO dla IBM DB2 oraz Informix Dynamic Server (IDS)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Aby uzyskać ten adapter poprzez metodę ``factory()`` należy użyć nazwy '``Pdo_Ibm``'.

- Ten adapter używa rozszerzeń *PHP* pdo and pdo_ibm.

- Należy używać wersji 1.2.2 lub wyższej rozszerzenia PDO_IBM. Zaleca się uaktualnienie wcześniejszych wersji
  poprzez *PECL*.

.. _zend.db.adapter.adapter-notes.pdo-mssql:

PDO Microsoft SQL Server
^^^^^^^^^^^^^^^^^^^^^^^^

- Aby uzyskać ten adapter poprzez metodę ``factory()`` należy użyć nazwy '``Pdo_Mssql``'.

- Ten adapter używa rozszerzeń *PHP* pdo and pdo_dblib.

- Microsoft *SQL* Server nie wspiera sekwencji więc ``lastInsertId()`` ignoruje argument określający klucz
  pierwotny i zwraca ostatnią wartość wygenerowaną przez automatyczny klucz (jeśli jest podana nazwa tabeli)
  lub identyfikator zwrócony przez ostatnie polecenie INSERT. Metoda ``lastSequenceId()`` zwraca ``NULL``.

- W przypadku pracy z łańcuchami znaków unicode zakodowanych w sposób inny niż UCS-2 (czyli również w formie
  UTF-8), może zajść potrzeba dokonania konwersji w kodzie aplikacji lub przechowywania danych w kolumnach
  binarnych. Aby uzyskać więcej informacji można skorzystać z `Microsoft's Knowledge Base`_.

- ``Zend_Db_Adapter_Pdo_Mssql`` ustawia opcję ``QUOTED_IDENTIFIER ON`` bezpośrednio po połączeniu się z bazą
  danych *SQL* Server. To powoduje, że sterownik zaczyna używać standardowego znaku cudzysłowu (**"**) jako
  ograniczenia identyfikatorów zamiast - charakterystycznych dla produktu Microsoftu - nawiasów kwadratowych.

- Adapter rozpoznaje klucz ``pdoType`` w tablicy opcji. Jego wartość może wynosić "mssql" (domyślnie),
  "dblib", "freetds", lub "sybase". To wpływa na prefiks *DSN* używany przez adapter do utworzenia łańcucha
  połączenia. Wartości "freetds" oraz "sybase" powodują utworzenie prefiksu "sybase:" używanego przez
  biblioteki `FreeTDS`_. Należy zapoznać się z informacjami dotyczącymi prefiksów *DSN* używanymi przez ten
  sterownik pod adresem `http://www.php.net/manual/en/ref.pdo-dblib.connection.php`_

.. _zend.db.adapter.adapter-notes.pdo-mysql:

PDO MySQL
^^^^^^^^^

- Aby uzyskać ten adapter poprzez metodę ``factory()`` należy użyć nazwy '``Pdo_Mysql``'.

- Ten adapter używa rozszerzeń *PHP* pdo and pdo_mysql.

- MySQL nie wspiera sekwencji więc ``lastInsertId()`` ignoruje argumenty i zwraca ostatnią wartość
  wygenerowaną dla klucza automatycznego. Metoda ``lastSequenceId()`` zwraca ``NULL``.

.. _zend.db.adapter.adapter-notes.pdo-oci:

PDO Oracle
^^^^^^^^^^

- Aby uzyskać ten adapter poprzez metodę ``factory()`` należy użyć nazwy '``Pdo_Oci``'.

- Ten adapter używa rozszerzeń *PHP* pdo and pdo_oci.

- Oracle nie wspiera kluczy automatycznych więc należy podać nazwę sekwencji w metodzie ``lastInsertId()`` lub
  ``lastSequenceId()``.

.. _zend.db.adapter.adapter-notes.pdo-pgsql:

PDO PostgreSQL
^^^^^^^^^^^^^^

- Aby uzyskać ten adapter poprzez metodę ``factory()`` należy użyć nazwy '``Pdo_Pgsql``'.

- Ten adapter używa rozszerzeń *PHP* pdo and pdo_pgsql.

- PostgreSQL wspiera sekwencje oraz klucze automatyczne. Przez to podawanie argumentów w ``lastInsertId()`` jest
  opcjonalne. Jeśli nie poda się argumentów adapter zwróci ostatnią wartość wygenerowaną dla klucza
  automatycznego. Jeśli argumenty zostaną podane to adapter zwróci ostatnią wartość wygenerowaną przez
  sekwencję o nazwie zgodnej z konwencją '**tabela**\ _ **kolumna**\ _seq'.

.. _zend.db.adapter.adapter-notes.pdo-sqlite:

PDO SQLite
^^^^^^^^^^

- Aby uzyskać ten adapter poprzez metodę ``factory()`` należy użyć nazwy '``Pdo_Sqlite``'.

- Ten adapter używa rozszerzeń *PHP* pdo and pdo_sqlite.

- SQLite nie wspiera sekwencji więc ``lastInsertId()`` ignoruje argumenty i zwraca ostatnią wartość
  wygenerowaną dla klucza automatycznego. Metoda ``lastSequenceId()`` zwraca ``NULL``.

- Aby połączyć się z bazą danych SQLite2 należy podać ``'sqlite2' => true`` jako jeden z elementów tablicy
  parametrów podczas tworzenia instancji adaptera ``Pdo_Sqlite``.

- Aby połączyć się z bazą danych SQLite rezydującą w pamięci należy podać ``'dbname' => ':memory:'`` jako
  jeden z elementów tablicy parametrów podczas tworzenia instancji adaptera ``Pdo_Sqlite``.

- Starsze wersje sterownika *PHP* SQLite nie wspierają poleceń PRAGMA niezbędnych dla zachowania krótkich nazw
  kolumn w wynikach zapytania. W przypadku wystąpienia problemów z zapytaniami JOIN polegających na zwracaniu
  wyników z nazwami kolumn w postaci "tabela.kolumna" zaleca się aktualizację *PHP* do najnowszej wersji.

.. _zend.db.adapter.adapter-notes.firebird:

Firebird/Interbase
^^^^^^^^^^^^^^^^^^

- Ten adapter używa rozszerzenia *PHP* php_interbase.

- Firebird/Interbase nie wspiera kluczy automatycznych więc należy podać nazwę sekwencji w metodzie
  ``lastInsertId()`` lub ``lastSequenceId()``.

- Obecnie, opcja ``Zend_Db::CASE_FOLDING`` nie jest zaimplementowana w tym adapterze. Identyfikatory bez znaków
  ograniczających są zwracane w postaci wielkich liter.

- Nazwa adaptera to ``ZendX_Db_Adapter_Firebird``.

  Należy pamiętać o użyciu parametru adapterNamespace z wartością ``ZendX_Db_Adapter``.

  Zaleca się aktualizację pliku ``gds32.dll`` (lub odpowiednika wersji linux) dostarczanym z *PHP* do wersji
  odpowiadającej serwerowi bazy danych. Dla Firebird odpowiednikiem ``gds32.dll`` jest ``fbclient.dll``.

  Domyślnie wszystkie identyfikatory (nazwy tabel, kolumn) są zwracane wielkimi literami.



.. _`PHP Data Objects`: http://www.php.net/pdo
.. _`pdo_ibm`: http://www.php.net/pdo-ibm
.. _`pdo_mysql`: http://www.php.net/pdo-mysql
.. _`pdo_dblib`: http://www.php.net/pdo-dblib
.. _`pdo_oci`: http://www.php.net/pdo-oci
.. _`pdo_pgsql`: http://www.php.net/pdo-pgsql
.. _`pdo_sqlite`: http://www.php.net/pdo-sqlite
.. _`mysqli`: http://www.php.net/mysqli
.. _`oci8`: http://www.php.net/oci8
.. _`ibm_db2`: http://www.php.net/ibm_db2
.. _`php_interbase`: http://www.php.net/ibase
.. _`http://en.wikipedia.org/wiki/SQL_Injection`: http://en.wikipedia.org/wiki/SQL_Injection
.. _`mysql_real_escape_string()`: http://www.php.net/mysqli_real_escape_string
.. _`cache'u zapytań MySQL (MySQL Query Cache)`: http://dev.mysql.com/doc/refman/5.1/en/query-cache-how.html
.. _`http://msdn.microsoft.com/en-us/library/cc296161(SQL.90).aspx`: http://msdn.microsoft.com/en-us/library/cc296161(SQL.90).aspx
.. _`Microsoft's Knowledge Base`: http://support.microsoft.com/kb/232580
.. _`FreeTDS`: http://www.freetds.org/
.. _`http://www.php.net/manual/en/ref.pdo-dblib.connection.php`: http://www.php.net/manual/en/ref.pdo-dblib.connection.php
