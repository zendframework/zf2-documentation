.. EN-Revision: none
.. _learning.quickstart.create-model:

Utworzenie modelu oraz tabeli w bazie danych
============================================

Przed rozpoczęciem należy zastanowić się nad następującym zagadnieniem: gdzie tworzone klasy będą
przechowywane i w jaki sposób będzie można je odnaleźć? Utworzony właśnie domyślny projekt, używa
automatycznego dołączania plików (autoloader). Możliwe jest dołączenie do niego kolejnych autoloaderów tak
by umożliwić odnajdywanie tworzonych klas. Typowym rozwiązaniem jest umieszczenie różnych klas w głównym
katalogu - w tym wypadku nazwanego ``application/``- i nazywanie ich z zachowaniem wspólnego prefiksu.

Klasa ``Zend_Controller_Front`` umożliwia tworzenie modułów (modules) - odrębnych części, które same w sobie
są mini-aplikacjami. W ramach każdego modułu odwzorowywana jest taka sama struktura katalogów jaka jest
tworzona przez narzędzie ``zf`` w katalogu głównym aplikacji. Nazwy wszystkich klas w jednym module muszą
rozpoczynać się od wspólnego prefiksu - nazwy modułu. Katalog główny -``application/`` również jest
modułem (domyślnym) dlatego też jego zasoby zostaną uwzględnione w procesie automatycznego dołączania
plików.

``Zend_Application_Module_Autoloader`` oferuje funkcjonalność niezbędną do odwzorowania zasobów modułów na
odpowiednie ścieżki katalogów oraz ułatwia zachowanie spójnego standardu nazewnictwa. Instancja tej klasy jest
tworzona domyślnie podczas uruchamiania klasy bootstrap. Domyślnym prefiksem używanym przez bootstrap jest
"Application" więc modele, formularze oraz klasy tabel będą rozpoczynały się prefiksem "Application\_".

Teraz należy się zastanowić co składa się na księgę gości. Typowo będzie w niej lista wpisów z
**komentarzem**, **czasem zapisu** oraz **adresem email**. Zakładając użycie bazy danych, pole **unikalny
identyfikator** może również być przydatne. Aplikacja powinna umożliwiać zapis danych, pobieranie wpisów
pojedynczo oraz wszystkich na raz. Prosty model oferujący opisaną funkcjonalność może przedstawiać się
następująco:

.. code-block:: php
   :linenos:

   // application/models/Guestbook.php

   class Application_Model_Guestbook
   {
       protected $_comment;
       protected $_created;
       protected $_email;
       protected $_id;

       public function __set($name, $value);
       public function __get($name);

       public function setComment($text);
       public function getComment();

       public function setEmail($email);
       public function getEmail();

       public function setCreated($ts);
       public function getCreated();

       public function setId($id);
       public function getId();
   }

   class Application_Model_GuestbookMapper
   {
       public function save(Application_Model_Guestbook $guestbook);
       public function find($id);
       public function fetchAll();
   }

Metody ``__get()`` oraz ``__set()`` stanowią mechanizmy ułatwiające dostęp do poszczególnych właściwości
oraz pośredniczą w dostępie do innych getterów i setterów. Dzięki nim, można również upewnić się, że
jedynie pożądane właściwości będą dostępne.

Metody ``find()`` oraz ``fetchAll()`` umożliwiają zwrócenie pojedynczego lub wszystkich rekordów natomiast
``save()`` zapisuje dane.

W tym momencie można zacząć myśleć o skonfigurowaniu bazy danych.

Na początku należy zainicjować zasób ``Db``. Jego konfiguracja jest możliwa na podobnych zasadach jak w
przypadku zasobów ``Layout`` oraz ``View``. Można to osiągnąć za pomocą polecenia ``zf configure
db-adapter``:

.. code-block:: console
   :linenos:

   % zf configure db-adapter \
   > 'adapter=PDO_SQLITE&dbname=APPLICATION_PATH "/../data/db/guestbook.db"' \
   > production
   A db configuration for the production has been written to the application config file.

   % zf configure db-adapter \
   > 'adapter=PDO_SQLITE&dbname=APPLICATION_PATH "/../data/db/guestbook-testing.db"' \
   > testing
   A db configuration for the production has been written to the application config file.

   % zf configure db-adapter \
   > 'adapter=PDO_SQLITE&dbname=APPLICATION_PATH "/../data/db/guestbook-dev.db"' \
   > development
   A db configuration for the production has been written to the application config file.

Teraz, po otworzeniu pliku ``application/configs/application.ini`` można zobaczyć instrukcje, jakie zostały do
niego dodane w odpowiednich sekcjach.

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   [production]
   ; ...
   resources.db.adapter = "PDO_SQLITE"
   resources.db.params.dbname = APPLICATION_PATH "/../data/db/guestbook.db"

   [testing : production]
   ; ...
   resources.db.adapter = "PDO_SQLITE"
   resources.db.params.dbname = APPLICATION_PATH "/../data/db/guestbook-testing.db"

   [development : production]
   ; ...
   resources.db.adapter = "PDO_SQLITE"
   resources.db.params.dbname = APPLICATION_PATH "/../data/db/guestbook-dev.db"

Ostatecznie plik konfiguracyjny powinien wyglądać następująco:

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   [production]
   phpSettings.display_startup_errors = 0
   phpSettings.display_errors = 0
   bootstrap.path = APPLICATION_PATH "/Bootstrap.php"
   bootstrap.class = "Bootstrap"
   appnamespace = "Application"
   resources.frontController.controllerDirectory = APPLICATION_PATH "/controllers"
   resources.frontController.params.displayExceptions = 0
   resources.layout.layoutPath = APPLICATION_PATH "/layouts/scripts"
   resources.view[] =
   resources.db.adapter = "PDO_SQLITE"
   resources.db.params.dbname = APPLICATION_PATH "/../data/db/guestbook.db"

   [staging : production]

   [testing : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1
   resources.db.adapter = "PDO_SQLITE"
   resources.db.params.dbname = APPLICATION_PATH "/../data/db/guestbook-testing.db"

   [development : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1
   resources.db.adapter = "PDO_SQLITE"
   resources.db.params.dbname = APPLICATION_PATH "/../data/db/guestbook-dev.db"

Należy zauważyć, iż baza (bazy) danych będzie przechowywana w katalogu ``data/db/``. Te katalogi powinny
zostać utworzone i udostępnione wszystkim. W systemach unix można tego dokonać następująco:

.. code-block:: console
   :linenos:

   % mkdir -p data/db; chmod -R a+rwX data

W systemach Windows należy utworzyć odpowiednie katalogi w eksploratorze oraz ustawić uprawnienia w taki sposób
aby każdy użytkownik miał prawo zapisu.

Połączenie z bazą danych zostało utworzone - w tym przypadku bazą jest Sqlite znajdująca się w katalogu
``application/data/``. Następnym krokiem jest utworzenie tabeli przechowującej rekordy księgi gości.

.. code-block:: sql
   :linenos:

   -- scripts/schema.sqlite.sql
   --
   -- Poniższy kod SQL należy uruchomić w bazie danych

   CREATE TABLE guestbook (
       id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
       email VARCHAR(32) NOT NULL DEFAULT 'noemail@test.com',
       comment TEXT NULL,
       created DATETIME NOT NULL
   );

   CREATE INDEX "id" ON "guestbook" ("id");

Aby mieć zestaw danych do testowania można utworzyć w tabeli kilka rekordów.

.. code-block:: sql
   :linenos:

   -- scripts/data.sqlite.sql
   --
   -- Poniższy kod SQL może posłużyć do zapełnienia tabeli testowymi danymi

   INSERT INTO guestbook (email, comment, created) VALUES
       ('ralph.schindler@zend.com',
       'Hello! Hope you enjoy this sample zf application!',
       DATETIME('NOW'));
   INSERT INTO guestbook (email, comment, created) VALUES
       ('foo@bar.com',
       'Baz baz baz, baz baz Baz baz baz - baz baz baz.',
       DATETIME('NOW'));

Mamy zdefiniowany schemat bazy danych oraz niewielką ilość danych do zaimportowania. Teraz można napisać
skrypt tworzący bazę danych. Ten krok nie jest potrzebny w środowisku produkcyjnym. Dzięki niemu można
lokalnie wypracować odpowiednią strukturę bazy danych aby tworzona aplikacja działała zgodnie z założeniami.
Skrypt ``scripts/load.sqlite.php`` można wypełnić w poniższy sposób:

.. code-block:: php
   :linenos:

   // scripts/load.sqlite.php

   /**
    * Skrypt tworzący bazę danych i wypełniający ją danymi
    */

   // Inicjalizacja ścieżek oraz autoloadera
   defined('APPLICATION_PATH')
       || define('APPLICATION_PATH', realpath(dirname(__FILE__) . '/../application'));
   set_include_path(implode(PATH_SEPARATOR, array(
       APPLICATION_PATH . '/../library',
       get_include_path(),
   )));
   require_once 'Zend/Loader/Autoloader.php';
   Zend_Loader_Autoloader::getInstance();

   // Zdefiniowanie opcji CLI
   $getopt = new Zend_Console_Getopt(array(
       'withdata|w' => 'Load database with sample data',
       'env|e-s'    => 'Application environment for which to create database (defaults to development)',
       'help|h'     => 'Help -- usage message',
   ));
   try {
       $getopt->parse();
   } catch (Zend_Console_Getopt_Exception $e) {
       // Bad options passed: report usage
       echo $e->getUsageMessage();
       return false;
   }

   // W przypadku zażądania pomocy, wyświetlenie informacji o użyciu
   if ($getopt->getOption('h')) {
       echo $getopt->getUsageMessage();
       return true;
   }

   // Inicjalizacja wartości na podstawie opcji CLI
   $withData = $getopt->getOption('w');
   $env      = $getopt->getOption('e');
   defined('APPLICATION_ENV')
       || define('APPLICATION_ENV', (null === $env) ? 'development' : $env);

   // Inicjalizacja Zend_Application
   $application = new Zend_Application(
       APPLICATION_ENV,
       APPLICATION_PATH . '/configs/application.ini'
   );

   // Inicjalizacja oraz zwrócenie zasobu bazy danych
   $bootstrap = $application->getBootstrap();
   $bootstrap->bootstrap('db');
   $dbAdapter = $bootstrap->getResource('db');

   // Powiadomienie użytkownika o postępie (w tym miejscu jest tworzona baza danych)
   if ('testing' != APPLICATION_ENV) {
       echo 'Writing Database Guestbook in (control-c to cancel): ' . PHP_EOL;
       for ($x = 5; $x > 0; $x--) {
           echo $x . "\r"; sleep(1);
       }
   }

   // Sprawdzenie czy plik bazy danych istnieje
   $options = $bootstrap->getOption('resources');
   $dbFile  = $options['db']['params']['dbname'];
   if (file_exists($dbFile)) {
       unlink($dbFile);
   }

   // Wywołanie poleceń zawartych w pliku tworzącym schemat
   try {
       $schemaSql = file_get_contents(dirname(__FILE__) . '/schema.sqlite.sql');
       // bezpośrednie użycie obiektu połączenia w celu wywołania poleceń SQL
       $dbAdapter->getConnection()->exec($schemaSql);
       chmod($dbFile, 0666);

       if ('testing' != APPLICATION_ENV) {
           echo PHP_EOL;
           echo 'Database Created';
           echo PHP_EOL;
       }

       if ($withData) {
           $dataSql = file_get_contents(dirname(__FILE__) . '/data.sqlite.sql');
           // bezpośrednie użycie obiektu połączenia w celu wywołania poleceń SQL
           $dbAdapter->getConnection()->exec($dataSql);
           if ('testing' != APPLICATION_ENV) {
               echo 'Data Loaded.';
               echo PHP_EOL;
           }
       }

   } catch (Exception $e) {
       echo 'AN ERROR HAS OCCURED:' . PHP_EOL;
       echo $e->getMessage() . PHP_EOL;
       return false;
   }

   // Ten skrypt powinien zostać uruchomiony z wiersza poleceń
   return true;

Teraz należy wywołać powyższy skrypt. Można to zrobić z poziomu terminala lub wiersza poleceń poprzez
wpisanie następującej komendy:

.. code-block:: console
   :linenos:

   % php scripts/load.sqlite.php --withdata

Powinien pojawić się następujący komunikat:

.. code-block:: text
   :linenos:

   path/to/ZendFrameworkQuickstart/scripts$ php load.sqlite.php --withdata
   Writing Database Guestbook in (control-c to cancel):
   1
   Database Created
   Data Loaded.

Po zdefiniowaniu bazy danych aplikacji księgi gości można przystąpić do budowy kodu samej aplikacji. W
następnych krokach zostanie zbudowana klasa dostępu do danych (poprzez ``Zend_Db_Table``), oraz klasa mapująca -
służąca do połączenia z wcześniej opisanym modelem. Na koniec utworzony zostanie kontroler zarządzający
modelem, którego zadaniem będzie wyświetlanie istniejących rekordów oraz obróbka nowych danych.

Aby łączyć się ze źródłem danych użyty zostanie wzorzec `Table Data Gateway`_ udostępniany poprzez klasę
``Zend_Db_Table``. Na początek należy utworzyć klasę opartą o ``Zend_Db_Table``. Podobnie jak przy layoucie
oraz adapterze bazy danych - można skorzystać z narzędzia ``zf`` i jego komendy ``create db-table``. Należy
przy tym podać minimalnie dwa argumenty: nazwę tworzonej klasy oraz nazwę tabeli bazy danych, do której
prowadzi.

.. code-block:: console
   :linenos:

   % zf create db-table Guestbook guestbook
   Creating a DbTable at application/models/DbTable/Guestbook.php
   Updating project profile 'zfproject.xml'

Spoglądając na strukturę katalogów należy zwrócić uwagę na nowy katalog ``application/models/DbTable/``
zawierający plik ``Guestbook.php``. Ten plik powinien zawierać następującą treść:

.. code-block:: php
   :linenos:

   // application/models/DbTable/Guestbook.php

   /**
    * This is the DbTable class for the guestbook table.
    */
   class Application_Model_DbTable_Guestbook extends Zend_Db_Table_Abstract
   {
       /** Table name */
       protected $_name    = 'guestbook';
   }

Należy zwrócić uwagę na prefiks: ``Application_Model_DbTable``. Prefiks klas aplikacji "Application" znajduje
się na pierwszym miejscu. Po nim występuje komponent "Model_DbTable", który jest mapowany do katalogu
``models/DbTable/`` znajdującego się w module.

Jedyne dane niezbędne przy tworzeniu klasy pochodnej w stosunku do ``Zend_Db_Table`` to nazwa tabeli i opcjonalnie
klucz pierwotny (jeśli jest inny niż "id").

Teraz należy utworzyć klasę mapującą obiekt w aplikacji na obiekt w bazie danych czyli `Data Mapper`_.
Obiektem w bazie danych jest ``Application_Model_Guestbook`` natomiast za obiekt bazy danych odpowiada
``Application_Model_DbTable_Guestbook``. Typowe *API* takiej klasy wygląda następująco:

.. code-block:: php
   :linenos:

   // application/models/GuestbookMapper.php

   class Application_Model_GuestbookMapper
   {
       public function save($model);
       public function find($id, $model);
       public function fetchAll();
   }

Dodatkowo można zdefiniować metody ustawiające i zwracające Table Data Gateway. Do utworzenia klasy można
użyć narzędzia ``zf``:

.. code-block:: console
   :linenos:

   % zf create model GuestbookMapper
   Creating a model at application/models/GuestbookMapper.php
   Updating project profile '.zfproject.xml'

Po otwarciu klasy ``Application_Model_GuestbookMapper`` z lokalizacji ``application/models/GuestbookMapper.php``
widać następujący kod:

.. code-block:: php
   :linenos:

   // application/models/GuestbookMapper.php

   class Application_Model_GuestbookMapper
   {
       protected $_dbTable;

       public function setDbTable($dbTable)
       {
           if (is_string($dbTable)) {
               $dbTable = new $dbTable();
           }
           if (!$dbTable instanceof Zend_Db_Table_Abstract) {
               throw new Exception('Invalid table data gateway provided');
           }
           $this->_dbTable = $dbTable;
           return $this;
       }

       public function getDbTable()
       {
           if (null === $this->_dbTable) {
               $this->setDbTable('Application_Model_DbTable_Guestbook');
           }
           return $this->_dbTable;
       }

       public function save(Application_Model_Guestbook $guestbook)
       {
           $data = array(
               'email'   => $guestbook->getEmail(),
               'comment' => $guestbook->getComment(),
               'created' => date('Y-m-d H:i:s'),
           );

           if (null === ($id = $guestbook->getId())) {
               unset($data['id']);
               $this->getDbTable()->insert($data);
           } else {
               $this->getDbTable()->update($data, array('id = ?' => $id));
           }
       }

       public function find($id, Application_Model_Guestbook $guestbook)
       {
           $result = $this->getDbTable()->find($id);
           if (0 == count($result)) {
               return;
           }
           $row = $result->current();
           $guestbook->setId($row->id)
                     ->setEmail($row->email)
                     ->setComment($row->comment)
                     ->setCreated($row->created);
       }

       public function fetchAll()
       {
           $resultSet = $this->getDbTable()->fetchAll();
           $entries   = array();
           foreach ($resultSet as $row) {
               $entry = new Application_Model_Guestbook();
               $entry->setId($row->id)
                     ->setEmail($row->email)
                     ->setComment($row->comment)
                     ->setCreated($row->created);
               $entries[] = $entry;
           }
           return $entries;
       }
   }

W obecnym momencie można przystąpić do utworzenia klasy modelu używając polecenia ``zf create model``:

.. code-block:: console
   :linenos:

   % zf create model Guestbook
   Creating a model at application/models/Guestbook.php
   Updating project profile '.zfproject.xml'

Nowo utworzoną klasę *PHP* można zmodyfikować tak aby ułatwić umieszczanie danych w modelu poprzez
przekazanie tablicy do konstruktora lub do metody ``setOptions()``. Ostatecznie model znajdujący się w
``application/models/Guestbook.php`` powinien wyglądać następująco:

.. code-block:: php
   :linenos:

   // application/models/Guestbook.php

   class Application_Model_Guestbook
   {
       protected $_comment;
       protected $_created;
       protected $_email;
       protected $_id;

       public function __construct(array $options = null)
       {
           if (is_array($options)) {
               $this->setOptions($options);
           }
       }

       public function __set($name, $value)
       {
           $method = 'set' . $name;
           if (('mapper' == $name) || !method_exists($this, $method)) {
               throw new Exception('Invalid guestbook property');
           }
           $this->$method($value);
       }

       public function __get($name)
       {
           $method = 'get' . $name;
           if (('mapper' == $name) || !method_exists($this, $method)) {
               throw new Exception('Invalid guestbook property');
           }
           return $this->$method();
       }

       public function setOptions(array $options)
       {
           $methods = get_class_methods($this);
           foreach ($options as $key => $value) {
               $method = 'set' . ucfirst($key);
               if (in_array($method, $methods)) {
                   $this->$method($value);
               }
           }
           return $this;
       }

       public function setComment($text)
       {
           $this->_comment = (string) $text;
           return $this;
       }

       public function getComment()
       {
           return $this->_comment;
       }

       public function setEmail($email)
       {
           $this->_email = (string) $email;
           return $this;
       }

       public function getEmail()
       {
           return $this->_email;
       }

       public function setCreated($ts)
       {
           $this->_created = $ts;
           return $this;
       }

       public function getCreated()
       {
           return $this->_created;
       }

       public function setId($id)
       {
           $this->_id = (int) $id;
           return $this;
       }

       public function getId()
       {
           return $this->_id;
       }
   }

W ostatnim kroku, aby połączyć wszystkie elementy, należy utworzyć kontroler, którego zadaniem będzie
zaprezentowanie listy zapisanych rekordów oraz obsługa dodawania nowych danych.

Aby to osiągnąć należy użyć polecenia ``zf create controller``:

.. code-block:: console
   :linenos:

   % zf create controller Guestbook
   Creating a controller at
       application/controllers/GuestbookController.php
   Creating an index action method in controller Guestbook
   Creating a view script for the index action method at
       application/views/scripts/guestbook/index.phtml
   Creating a controller test file at
       tests/application/controllers/GuestbookControllerTest.php
   Updating project profile '.zfproject.xml'

Powyższe polecenie tworzy nowy kontroler -``GuestbookController`` w pliku
``application/controllers/GuestbookController.php`` zawierający jedną akcję -``indexAction()``. Na użytek tego
kontrolera utworzony zostaje również katalog widoków: ``application/views/scripts/guestbook/`` zawierający
skrypt widoku dla akcji index.

Akcja "index" będzie stanowić domyślny punkt kontrolera pokazujący zapisane rekordy.

Teraz należy zaprogramować logikę aplikacji. Aby pokazać zapisane rekordy użytkownikowi wchodzącemu do
``indexAction()`` można użyć poniższego kodu:

.. code-block:: php
   :linenos:

   // application/controllers/GuestbookController.php

   class GuestbookController extends Zend_Controller_Action
   {
       public function indexAction()
       {
           $guestbook = new Application_Model_GuestbookMapper();
           $this->view->entries = $guestbook->fetchAll();
       }
   }

Dodatkowo potrzebny jest jeszcze widok wyświetlający dane. W pliku
``application/views/scripts/guestbook/index.phtml`` można umieścić następujący zapis:

.. code-block:: php
   :linenos:

   <!-- application/views/scripts/guestbook/index.phtml -->

   <p><a href="<?php echo $this->url(
       array(
           'controller' => 'guestbook',
           'action'     => 'sign'
       ),
       'default',
       true) ?>">Sign Our Guestbook</a></p>

   Guestbook Entries: <br />
   <dl>
       <?php foreach ($this->entries as $entry): ?>
       <dt><?php echo $this->escape($entry->email) ?></dt>
       <dd><?php echo $this->escape($entry->comment) ?></dd>
       <?php endforeach ?>
   </dl>

.. note::

   **Punkt kontrolny**

   Teraz, po przejściu do "http://localhost/guestbook" powinna się pojawić lista zapisanych rekordów:

   .. image:: ../images/learning.quickstart.create-model.png
      :width: 525
      :align: center

.. note::

   **Użycie skryptu ładującego dane**

   Skrypt ładujący dane pokazany we wcześniejszej części tego rozdziału (``scripts/load.sqlite.php``) może
   zostać użyty do utworzenia bazy danych jak i do zaimportowania przykładowych danych dla każdego środowiska.
   Wewnętrznie korzysta z klasy ``Zend_Console_Getopt``, dzięki czemu możliwe jest podanie parametrów
   sterujących skryptem. Podając parametr "-h" lub "--help" można zapoznać się z dostępnymi opcjami:

   .. code-block:: php
      :linenos:

      Usage: load.sqlite.php [ options ]
      --withdata|-w         Load database with sample data
      --env|-e [  ]         Application environment for which to create database
                            (defaults to development)
      --help|-h             Help -- usage message)]]

   Parametr "-e" pozwala na nadanie wartości stałej ``APPLICATION_ENV`` określającej środowisko, co z kolei
   umożliwia utworzenie bazy danych SQLite dla każdego środowiska oddzielnie. Należy się upewnić, że skrypt
   jest uruchamiany z odpowiednią wartością tego parametru dla każdego ze środowisk.



.. _`Table Data Gateway`: http://martinfowler.com/eaaCatalog/tableDataGateway.html
.. _`Data Mapper`: http://martinfowler.com/eaaCatalog/dataMapper.html
