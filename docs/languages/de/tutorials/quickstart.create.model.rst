.. EN-Revision: none
.. _learning.quickstart.create-model:

Ein Modell und eine Datenbank Tabelle erstellen
===============================================

Bevor wir anfangen nehmen wie etwas an: Wo werden diese Klassen leben, und wie werden wir Sie finden? Das
Standardprojekt welches wir erstellt haben instanziert einen Autoloader. Wir können Ihm andere Autoloader
anhängen damit er weiss wo andere Klassen zu finden sind. Typischerweise wollen wir das unsere verschiedenen MVC
Klassen im selben Baum gruppiert sind -- in diesem Fall ``application/``-- und meistens einen gemeinsamen Präfix
verwenden.

``Zend\Controller\Front`` hat den Begriff von "Modulen", welche individuelle Mini-Anwendungen sind. Module mimen
die Verzeichnisstruktur welche das ``zf`` Tool unter ``application/`` einrichtet, und von allen Klassen in Ihm wird
angenommen das Sie mit einen gemeinsamen Präfix beginnen, dem Namen des Moduls. ``application/`` selbst ist ein
Modul -- das "default" oder "application" Modul. Als solches richten wir das Autoloading für Ressourcen in diesem
Verzeichnis ein.

``Zend\Application_Module\Autoloader`` bietet die Funktionalität welche benötigt wird um die verschiedenen
Ressourcen unter einem Modul mit den richtigen Verzeichnissen zu verbinden, und auch einen standardmäßigen
Namensmechanismus. Standardmäßig wird eine Instanz der Klasse wärend der Initialisierung des Bootstrap Objekts
erstellt; unser Application Bootstrap verwendet standardmäßig das Modulpräfix "Application". Daher beginnen alle
unsere Modelle, Formulare, und Tabellenklassen mit dem Klassenpräfix "Application\_".

Nehmen wir jetzt also an was ein Guestbook ausmacht. Typischerweise sind Sie einfach eine Liste ein Einträgen mit
einem **Kommentar** (comment), einem **Zeitpunkt** (timestamp) und oft einer **Email Adresse**. Angenommen wir
speichern diese in einer Datenbank, dann wollen wir auch einen **eindeutigen Identifikator** für jeden Eintrag.
Wir wollen in der Lage sein einen Eintrag zu speichern, individuelle Einträge zu holen, und alle Einträge zu
empfangen. Als solches könnte das Modell einer einfachen Guestbook *API* wie folgt aussehen:

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

``__get()`` und ``__set()`` bieten uns bequeme Mechanismen an um auf individuelle Eigenschaften von Einträgen
zuzugreifen und auf andere Getter und Setter zu verweisen. Sie stellen auch sicher das nur Eigenschaften im Objekt
vorhanden sind die wir freigegeben haben.

``find()`` und ``fetchAll()`` bieten die Fähigkeit einen einzelnen Eintrag oder alle Einträge zu holen, wärend
``save()`` das Speichern der Einträge im Datenspeicher übernimmt.

Von hier an können wir über die Einrichtung unserer Datenbank nachdenken.

Zuerst muss unsere ``Db`` Ressource initialisiert werden. Wie bei der ``Layout`` und ``View`` kann die
Konfiguration für die ``Db`` Ressource angegeben werden. Dies kann mit dem Befehl ``zf configure db-adapter``
getan werden:

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

Jetzt muss die Datei ``application/configs/application.ini`` bearbeitet werden, und man kann sehen das die
folgenden Zeilen in den betreffenden Abschnitten hinzugefügt wurden.

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   [production]
   ; ...
   resources.db.adapter       = "PDO_SQLITE"
   resources.db.params.dbname = APPLICATION_PATH "/../data/db/guestbook.db"

   [testing : production]
   ; ...
   resources.db.adapter = "PDO_SQLITE"
   resources.db.params.dbname = APPLICATION_PATH "/../data/db/guestbook-testing.db"

   [development : production]
   ; ...
   resources.db.adapter = "PDO_SQLITE"
   resources.db.params.dbname = APPLICATION_PATH "/../data/db/guestbook-dev.db"

Die endgültige Konfigurationsdatei sollte wie folgt aussehen:

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

Es ist zu beachten das die Datenbank(en) unter ``data/db/`` gespeichert wird. Diese Verzeichnisse sind zu erstellen
und weltweit-schreibbar zu machen. Auf Unix-artigen Systemen kann man das wie folgt durchführen:

.. code-block:: console
   :linenos:

   % mkdir -p data/db; chmod -R a+rwX data

Unter Windows muss man die Verzeichnisse im Explorer erstellen und die Zugriffsrechte so zu setzen das jeder in das
Verzeichnis schreiben darf.

Ab diesem Punkt haben wir eine Verbindung zu einer Datenbank; in unserem Fall ist es eine verbindung zu einer
Sqlite Datenbank die in unserem ``application/data/`` Verzeichnis ist. Designen wir also eine einfache Tabelle die
unsere Guestbook Einträge enthalten wird.

.. code-block:: sql
   :linenos:

   -- scripts/schema.sqlite.sql
   --
   -- Man muss das Datenbank Schema mit diesem SQL laden.

   CREATE TABLE guestbook (
       id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
       email VARCHAR(32) NOT NULL DEFAULT 'noemail@test.com',
       comment TEXT NULL,
       created DATETIME NOT NULL
   );

   CREATE INDEX "id" ON "guestbook" ("id");

Und damit wir gleich einige Arbeitsdaten haben, erstellen wir ein paar Zeilen an Information um unsere Anwendung
interessant zu machen.

.. code-block:: sql
   :linenos:

   -- scripts/data.sqlite.sql
   --
   -- Man kann damit beginnen die Datenbank zu befüllen indem die folgenden SQL
   -- Anweisungen ausgeführt werden.

   INSERT INTO guestbook (email, comment, created) VALUES
       ('ralph.schindler@zend.com',
       'Hallo! Hoffentlich geniesst Ihr dieses Beispiel einer ZF Anwendung!
       DATETIME('NOW'));
   INSERT INTO guestbook (email, comment, created) VALUES
       ('foo@bar.com',
       'Baz baz baz, baz baz Baz baz baz - baz baz baz.',
       DATETIME('NOW'));

Jetzt haben wir sowohl das Schema als auch einige Daten definiert. Schreiben wir also ein Skript das wir jetzt
ausführen können um diese Datenbank zu erstellen. Natürlich wird das nicht in der Produktion benötigt, aber
dieses Skriupt hilft Entwicklern die Notwendigkeiten der Datenbank lokal zu erstellen damit Sie eine voll
funktionsfähige Anwendung haben. Das Skript ist als ``scripts/load.sqlite.php`` mit dem folgenden Inhalt zu
erstellen:

.. code-block:: php
   :linenos:

   // scripts/load.sqlite.php

   /**
    * Skript für das erstellen und Laden der Datenbank
    */

   // Initialisiert den Pfad und das Autoloading der Anwendung
   defined('APPLICATION_PATH')
       || define('APPLICATION_PATH', realpath(dirname(__FILE__) . '/../application'));
   set_include_path(implode(PATH_SEPARATOR, array(
       APPLICATION_PATH . '/../library',
       get_include_path(),
   )));
   require_once 'Zend/Loader/Autoloader.php';
   Zend\Loader\Autoloader::getInstance();

   // Definiert einige CLI Optionen
   $getopt = new Zend\Console\Getopt(array(
       'withdata|w' => 'Datenbank mit einigen Daten laden',
       'env|e-s'    => "Anwendungsumgebung für welche die Datenbank "
                     . "erstellt wird (Standard ist Development)",
       'help|h'     => 'Hilfe -- Verwendung',
   ));
   try {
       $getopt->parse();
   } catch (Zend\Console_Getopt\Exception $e) {
       // Schlechte Option übergeben: Verwendung ausgeben
       echo $e->getUsageMessage();
       return false;
   }

   // Wenn Hilfe angefragt wurde, Verwendung ausgeben
   if ($getopt->getOption('h')) {
       echo $getopt->getUsageMessage();
       return true;
   }

   // Werte basierend auf Ihrer Anwesenheit oder Abwesenheit von CLI Optionen initialisieren
   $withData = $getopt->getOption('w');
   $env      = $getopt->getOption('e');
   defined('APPLICATION_ENV')
       || define('APPLICATION_ENV', (null === $env) ? 'development' : $env);

   // Zend_Application initialisieren
   $application = new Zend\Application\Application(
       APPLICATION_ENV,
       APPLICATION_PATH . '/configs/application.ini'
   );

   // Die DB Ressource initialisieren und empfangen
   $bootstrap = $application->getBootstrap();
   $bootstrap->bootstrap('db');
   $dbAdapter = $bootstrap->getResource('db');

   // Den Benutzer informieren was abgeht
   // (wir erstellen hier aktuell eine Datenbank)
   if ('testing' != APPLICATION_ENV) {
       echo 'Schreiben in die Guestbook Datenbank (control-c um abzubrechen): ' . PHP_EOL;
       for ($x = 5; $x > 0; $x--) {
           echo $x . "\r"; sleep(1);
       }
   }

   // Prüfen um zu sehen ob wie bereits eine Datenbankdatei haben
   $options = $bootstrap->getOption('resources');
   $dbFile  = $options['db']['params']['dbname'];
   if (file_exists($dbFile)) {
       unlink($dbFile);
   }

   // Dieser Block führt die aktuellen Statements aus welche von der Schemadatei
   // geladen werden.
   try {
       $schemaSql = file_get_contents(dirname(__FILE__) . '/schema.sqlite.sql');
       // Die Verbindung direkt verwenden um SQL im Block zu laden
       $dbAdapter->getConnection()->exec($schemaSql);
       chmod($dbFile, 0666);

       if ('testing' != APPLICATION_ENV) {
           echo PHP_EOL;
           echo 'Datenbank erstellt';
           echo PHP_EOL;
       }

       if ($withData) {
           $dataSql = file_get_contents(dirname(__FILE__) . '/data.sqlite.sql');
           // Die Verbindung direkt verwenden um SQL in Blöcken zu laden
           $dbAdapter->getConnection()->exec($dataSql);
           if ('testing' != APPLICATION_ENV) {
               echo 'Daten geladen.';
               echo PHP_EOL;
           }
       }

   } catch (Exception $e) {
       echo 'EIN FEHLER IST AUFGETRETEN:' . PHP_EOL;
       echo $e->getMessage() . PHP_EOL;
       return false;
   }

   // Generell gesprochen wird dieses Skript von der Kommandozeile aus aufgerufen
   return true;

Jetzt führen wir dieses Skript aus. Von einem Terminal oder der DOS Kommandozeile ist das folgende zu tun:

.. code-block:: console
   :linenos:

   % php scripts/load.sqlite.php --withdata

Man sollte eine ähnliche Ausgabe wie folgt sehen:

.. code-block:: text
   :linenos:

   path/to/ZendFrameworkQuickstart/scripts$ php load.sqlite.php --withdata
   Schreiben in die Guestbook Datenbank (control-c um abzubrechen):
   1
   Datenbank erstellt
   Daten geladen.

Jetzt haben wir eine voll funktionsfähige Datenbank und eine Tabelle für unsere Guestbook Anwendung. Unsere
nächsten paar Schritte sind die Ausarbeitung unseres Anwendungscodes. Das inkludiert das Bauen einer Datenquelle
(in unserem Fall verwenden wir ``Zend\Db\Table``), und einen Daten Mapper um diese Datenquelle mit unserem Domain
Modell zu verbinden. Letztendlich erstellen wir den Controller der mit diesem Modell interagiert damit sowohl
existierende Einträge angezeigt als auch neue Einträge bearbeitet werden.

Wir verwenden ein `Table Data Gateway`_ um uns mit unserer Datenquelle zu verbinden; ``Zend\Db\Table`` bietet diese
Funktionalität. Um anzufangen erstellen wir eine ``Zend\Db\Table``-basierende Tabellenklasse. Wie wir es für
Layouts und den Datenbank Adapter getan haben, können wir das ``zf`` Tool verwenden um uns zu assistieren indem
der Befehl ``create db-table`` verwendet wird. Dieser nimmt mindestens zwei Argumente, den Namen mit dem man auf
die Klasse referenzieren will, und die Datenbanktabelle auf die Sie zeigt.

.. code-block:: console
   :linenos:

   % zf create db-table Guestbook guestbook
   Creating a DbTable at application/models/DbTable/Guestbook.php
   Updating project profile 'zfproject.xml'

Wenn man in der Verzeichnisbaum sieht, dann wird man jetzt sehen das ein neues Verzeichnis
``application/models/DbTable/`` zusammen mit der Datei ``Guestbook.php`` erstellt wurde. Wenn man die Datei öffnet
wird man den folgenden Inhalt sehen:

.. code-block:: php
   :linenos:

   // application/models/DbTable/Guestbook.php

   /**
    * Das ist die DbTable Klasse für die Guestbook Tabelle.
    */
   class Application_Model_DbTable_Guestbook extends Zend\Db_Table\Abstract
   {
       /** Tabellenname */
       protected $_name    = 'guestbook';
   }

Der Klassenpräfix ist zu beachten: ``Application_Model_DbTable``. Der Klassenpräfix für unser Modul
"Application" ist das erste Segment, und dann haben wir die Komponente "Model_DbTable"; die letztere verweist auf
das Verzeichnis ``models/DbTable/`` des Moduls.

Alles das ist wirklich notwendig wenn ``Zend\Db\Table`` erweitert wird um einen Tabellennamen anzubieten und
optional den primären Schlüssel (wenn es nicht die "id" ist).

Jetzt erstellen wir einen `Daten Mapper`_. Ein **Daten Mapper** bildet ein Domain Objekt in der Datenbank ab. In
unserem Fall bildet es unser Modell ``Application_Model_Guestbook`` auf unsere Datenquelle,
``Application_Model_DbTable_Guestbook``, ab. Eine typische *API* für einen Daten Mapper ist wie folgt:

.. code-block:: php
   :linenos:

   // application/models/GuestbookMapper.php

   class Application_Model_GuestbookMapper
   {
       public function save($model);
       public function find($id, $model);
       public function fetchAll();
   }

Zusätzlich zu diesen Methoden, fügen wir Methoden für das Setzen und Holen des Table Data Gateways hinzu. Um die
initiale Klasse zu erstellen kann das ``zf`` CLI Tool verwendet werden:

.. code-block:: console
   :linenos:

   % zf create model GuestbookMapper
   Creating a model at application/models/GuestbookMapper.php
   Updating project profile '.zfproject.xml'

Jetzt muss die Klasse ``Application_Model_GuestbookMapper`` welche in ``application/models/GuestbookMapper.php``
gefunden werden kann so geändert werden dass Sie wie folgt zu lesen ist:

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
           if (!$dbTable instanceof Zend\Db_Table\Abstract) {
               throw new Exception('Ungültiges Table Data Gateway angegeben');
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

Jetzt ist es Zeit unsere Modellklasse zu erstellen. Wir machen dies indem wieder das Kommando ``zf create model``
verwendet wird:

.. code-block:: console
   :linenos:

   % zf create model Guestbook
   Creating a model at application/models/Guestbook.php
   Updating project profile '.zfproject.xml'

Wir verändern diese leere *PHP* Klasse um es einfach zu machen das Modell bekanntzugeben indem ein Array an Daten
entweder an den Constructor oder an die ``setOptions()`` Methode übergeben wird. Das endgültige Modell, welches
in ``application/models/Guestbook.php`` ist, sollte wie folgt aussehen:

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
               throw new Exception('Ungültige Guestbook Eigenschaft');
           }
           $this->$method($value);
       }

       public function __get($name)
       {
           $method = 'get' . $name;
           if (('mapper' == $name) || !method_exists($this, $method)) {
               throw new Exception('Ungültige Guestbook Eigenschaft');
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

Letztendlich, um diese Elemente alle zusammen zu verbinden, erstellen wir einen Guestbook Controller der die
Einträge auflistet welche aktuell in der Datenbank sind.

Um einen neuen Controller zu erstellen muss das Kommando ``zf create controller`` verwendet werden:

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

Das erstellt einen neuen Controller, ``GuestbookController``, in
``application/controllers/GuestbookController.php`` mit einer einzelnen Aktions Methode, ``indexAction()``. Er
erstellt auch ein View Skript Verzeichnis für den Controller, ``application/views/scripts/guestbook/``, mit einem
View Skript für die Index Aktion.

Wir verwenden die "index" Aktion als Landeseite um alle Guestbook Einträge anzusehen.

Jetzt betrachten wir die grundsätzliche Anwendungslogik. Bei einem Treffer auf ``indexAction()`` zeigen wir alle
Guestbook Einträge an. Das würde wie folgt aussehen:

.. code-block:: php
   :linenos:

   // application/controllers/GuestbookController.php

   class GuestbookController extends Zend\Controller\Action
   {
       public function indexAction()
       {
           $guestbook = new Application_Model_GuestbookMapper();
           $this->view->entries = $guestbook->fetchAll();
       }
   }

Und natürlich benötigen wir ein View Skript um damit weiterzumachen.
``application/views/scripts/guestbook/index.phtml`` ist zu bearbeiten damit Sie wie folgt aussieht:

.. code-block:: php
   :linenos:

   <!-- application/views/scripts/guestbook/index.phtml -->

   <p><a href="<?php echo $this->url(
       array(
           'controller' => 'guestbook',
           'action'     => 'sign'
       ),
       'default',
       true) ?>">Im Guestbook eintragen</a></p>

   Guestbook Einträge: <br />
   <dl>
       <?php foreach ($this->entries as $entry): ?>
       <dt><?php echo $this->escape($entry->email) ?></dt>
       <dd><?php echo $this->escape($entry->comment) ?></dd>
       <?php endforeach ?>
   </dl>

.. note::

   **Checkpoint**

   Jetzt gehen wir auf "http://localhost/guestbook". Man sollte das folgende im Browser sehen:

   .. image:: ../images/learning.quickstart.create-model.png
      :width: 525
      :align: center

.. note::

   **Das Datenlade Skript verwenden**

   Das Datenlade Skript welches in diesem Kapitel beschrieben wird (``scripts/load.sqlite.php``) kann verwendet
   werden um die Datenbank, für jede Umgebung die man definiert hat, zu erstellen sowie Sie mit Beispieldaten zu
   laden. Intern verwendet es ``Zend\Console\Getopt``, was es erlaubt eine Anzahl von Kommandozeilen Schalter
   anzubieten. Wenn man den "-h" oder "--help" Schalter übergibt, werden die folgenden Optionen angegeben:

   .. code-block:: php
      :linenos:

      Usage: load.sqlite.php [ options ]
      --withdata|-w         Datenbank mit einigen Daten laden
      --env|-e [  ]         Anwendungsumgebung für welche die Datenbank erstellt wird
                            (Standard ist Development)
      --help|-h             Hilfe -- Verwendung)]]

   Der "-e" Schalter erlaubt es den Wert zu spezifizieren der für die Konstante ``APPLICATION_ENV`` verwendet wird
   -- welcher es erlaubt eine SQLite Datenbank für jede Umgebung zu erstellen die man definiert. Man sollte
   sicherstellen dass das Skript für die Umgebung gestartet wird welche man für die eigene Anwendung ausgewählt
   hat wenn man in Betrieb geht.



.. _`Table Data Gateway`: http://martinfowler.com/eaaCatalog/tableDataGateway.html
.. _`Daten Mapper`: http://martinfowler.com/eaaCatalog/dataMapper.html
