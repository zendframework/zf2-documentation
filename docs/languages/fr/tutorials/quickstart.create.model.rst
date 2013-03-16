.. EN-Revision: none
.. _learning.quickstart.create-model:

Créer un modèle et une table en base de données
===============================================

Avant de démarrer, considérons ceci: où vont se trouver ces classes et comment les retrouver? Le projet par
défaut que nous avons conçu instancie un autoloader. Nous pouvons lui attacher d'autres autoloaders pour qu'il
puisse trouver des classes différentes. Typiquement nous voulons que nos classes MVC soient groupées sous une
même arborescence -- dans ce cas, ``application/``-- et nous utiliserons un préfixe commun.

``Zend\Controller\Front`` a une notion de "modules", qui sont des mini-applications individuelles. Les modules
reflètent la structure de répertoires que la commande ``zf`` crée sous ``application/``, et toutes les classes
à l'intérieur sont supposées commencer par un préfixe étant le nom du module. ``application/`` est lui-même
un module -- le module "default" ou "application". Ainsi, nous allons vouloir configurer un autoload pour les
ressources sous ce dossier.

``Zend\Application_Module\Autoloader`` propose la fonctionnalité nécessaire à la correspondance entre les
ressources d'un module et ses dossiers, il propose pour cela un mécanisme de nommage standard. Une instance de la
classe est créée par défaut pendant l'initialisation de l'objet de bootstrap et utilisera le préfixe de module
"Application". De ce fait, nos classes de modèles, formulaires, et tables commenceront toutes par le préfixe de
classe "Application\_".

Maintenant voyons de quoi est fait un livre d'or. Typiquement il existe simplement une liste d'entrées avec un
**commentaire**, **timestamp**, et souvent une **adresse email**. En supposant que nous stockons cela dans une base
de données, nous aurons aussi besoin d'un **identifiant unique** pour chaque entrée. Nous voudrons aussi
sauvegarder une entrée, récupérer une entrée individuelle ou encore récupérer toutes les entrées. De ce
fait, l'*API* du modèle d'un simple livre d'or ressemblerait à ceci:

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

``__get()`` et ``__set()`` nous simplifierons l'accès aux attributs et proxieront vers les autres getters et
setters. Ils nous permettront de même de nous assurer que seuls les attributs que nous avons définis seront
accessibles dans l'objet.

``find()`` et ``fetchAll()`` permettent de récupérer une seule entrée ou toutes les entrées alors que
``save()`` offrira la possibilité de stocker une entrée dans le support de stockage.

Maintenant à partir de là, nous pouvons commencer à penser en terme de base de données.

Nous devons d'abord initialiser une ressource ``Db``. Comme pour les ressources ``Layout`` et ``View``, nous pouvons
utiliser de la configuration pour ``Db``. Cela est possible au moyen de la commande ``zf configure db-adapter``:

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

Editez maintenant le fichier ``application/configs/application.ini``, vous verrez que les lignes suivantes ont
été ajoutées dans les sections appropriées:

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

Votre fichier de configuration final devrait ressembler à ceci:

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

Notez que la/les base(s) de données seront stockées sous ``data/db/``. Créez ces dossiers et affectez leur les
bons droits. Sur les systèmes Unix utilisez:

.. code-block:: console
   :linenos:

   % mkdir -p data/db; chmod -R a+rwX data

Sur Windows, vous devrez créer le dossier avec l'explorateur et lui donner les bonnes permissions pour que tout le
monde puisse y écrire.

Dès lors, nous possédons une connexion à une base de données, dans notre cas il s'agit de Sqlite et la base est
placée sous le dossier ``application/data/``. Créons maintenant une table pour stocker nos entrées de livre
d'or.

.. code-block:: sql
   :linenos:

   -- scripts/schema.sqlite.sql
   --
   -- You will need load your database schema with this SQL.

   CREATE TABLE guestbook (
       id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
       email VARCHAR(32) NOT NULL DEFAULT 'noemail@test.com',
       comment TEXT NULL,
       created DATETIME NOT NULL
   );

   CREATE INDEX "id" ON "guestbook" ("id");

Puis pour ne pas travailler dans le vide, créons quelques enregistrements de départ.

.. code-block:: sql
   :linenos:

   -- scripts/data.sqlite.sql
   --
   -- You can begin populating the database with the following SQL statements.

   INSERT INTO guestbook (email, comment, created) VALUES
       ('ralph.schindler@zend.com',
       'Hello! Hope you enjoy this sample zf application!',
       DATETIME('NOW'));
   INSERT INTO guestbook (email, comment, created) VALUES
       ('foo@bar.com',
       'Baz baz baz, baz baz Baz baz baz - baz baz baz.',
       DATETIME('NOW'));

Maintenant que nous avons la définition de la base de données ainsi que des données, créons un script qui
pourra être lancé pour entièrement initialiser la base de données de manière autonomme. Bien sûr cela ne sera
pas nécessaire en production. Créez le script ``scripts/load.sqlite.php`` avec le contenu suivant:

.. code-block:: php
   :linenos:

   // scripts/load.sqlite.php

   /**
    * Script pour créer et charger la base
    */

   // Initialise le chemin vers l'application et l'autoload
   defined('APPLICATION_PATH')
       || define('APPLICATION_PATH', realpath(dirname(__FILE__) . '/../application'));
   set_include_path(implode(PATH_SEPARATOR, array(
       APPLICATION_PATH . '/../library',
       get_include_path(),
   )));
   require_once 'Zend/Loader/Autoloader.php';
   Zend\Loader\Autoloader::getInstance();

   // Definit des options CLI
   $getopt = new Zend\Console\Getopt(array(
       'withdata|w' => 'Load database with sample data',
       'env|e-s'    => 'Application environment for which to create database (defaults to development)',
       'help|h'     => 'Help -- usage message',
   ));
   try {
       $getopt->parse();
   } catch (Zend\Console_Getopt\Exception $e) {
       // Mauvaises options passées: afficher l'aide
       echo $e->getUsageMessage();
       return false;
   }

   // Si l'aid eest demandée, l'afficher
   if ($getopt->getOption('h')) {
       echo $getopt->getUsageMessage();
       return true;
   }

   // Initialise des valeurs selon la présence ou absence d'options CLI
   $withData = $getopt->getOption('w');
   $env      = $getopt->getOption('e');
   defined('APPLICATION_ENV')
       || define('APPLICATION_ENV', (null === $env) ? 'development' : $env);

   // Initialise Zend_Application
   $application = new Zend\Application\Application(
       APPLICATION_ENV,
       APPLICATION_PATH . '/configs/application.ini'
   );

   // Initialise et récupère la ressoucre DB
   $bootstrap = $application->getBootstrap();
   $bootstrap->bootstrap('db');
   $dbAdapter = $bootstrap->getResource('db');

   // Informons l'utilisateur de ce qui se passe (nous créons une base de données
   // ici)
   if ('testing' != APPLICATION_ENV) {
       echo 'Writing Database Guestbook in (control-c to cancel): ' . PHP_EOL;
       for ($x = 5; $x > 0; $x--) {
           echo $x . "\r"; sleep(1);
       }
   }

   // Vérifions si un fichier pour la base existe déja
   $options = $bootstrap->getOption('resources');
   $dbFile  = $options['db']['params']['dbname'];
   if (file_exists($dbFile)) {
       unlink($dbFile);
   }

   // Chargement du fichier de la base de données.
   try {
       $schemaSql = file_get_contents(dirname(__FILE__) . '/schema.sqlite.sql');
       // utilise la connexion directement pour charger le sql
       $dbAdapter->getConnection()->exec($schemaSql);
       chmod($dbFile, 0666);

       if ('testing' != APPLICATION_ENV) {
           echo PHP_EOL;
           echo 'Database Created';
           echo PHP_EOL;
       }

       if ($withData) {
           $dataSql = file_get_contents(dirname(__FILE__) . '/data.sqlite.sql');
           // utilise la connexion directement pour charger le sql
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

   // Ce script sera lancé depuis la ligne de commandes
   return true;

Exécutons ce script. Depuis un terminal ou un invite DOS, effectuez:

.. code-block:: console
   :linenos:

   % php scripts/load.sqlite.php --withdata

Vous devriez voir ceci:

.. code-block:: text
   :linenos:

   path/to/ZendFrameworkQuickstart/scripts$ php load.sqlite.php --withdata
   Writing Database Guestbook in (control-c to cancel):
   1
   Database Created
   Data Loaded.

Nous avons maintenant une base de données et une table pour notre application de livre d'or. Les prochaines
étapes seront de créer le code applicatif. Ceci incluera une source de données (dans notre cas nous utiliserons
``Zend\Db\Table``), un datamapper pour connecter cette source à notre modèle et enfin un contrôleur pour
intéragir avec le modèle et afficher du contenu divers.

Nous allons utiliser un `Table Data Gateway`_ pour se connecter à notre source de données; ``Zend\Db\Table``
propose cette fonctionnalité. Créons les classes basées sur ``Zend\Db\Table``. Comme nous avons opéré pour les
layouts ou la base, nous pouvons utiliser la commande ``zf`` pour nous aider, avec la commande complète ``create
db-table``. Celle-ci prend deux arguments au minimum, le nom de la classe à créer et la table qui y fera
référence.

.. code-block:: console
   :linenos:

   % zf create db-table Guestbook guestbook
   Creating a DbTable at application/models/DbTable/Guestbook.php
   Updating project profile 'zfproject.xml'

En regardant l'orborescence du projet, un nouveau dossier ``application/models/DbTable/`` a été crée contenant
le fichier ``Guestbook.php``. Si vous ouvrez ce fichier, vous y verrez le contenu suivant:

.. code-block:: php
   :linenos:

   // application/models/DbTable/Guestbook.php

   /**
    * This is the DbTable class for the guestbook table.
    */
   class Application_Model_DbTable_Guestbook extends Zend\Db_Table\Abstract
   {
       /** Table name */
       protected $_name    = 'guestbook';
   }

Notez le préfixe de classe: ``Application_Model_DbTable``. Le premier segment est "Application", le nom du module,
puis vient le nom du composant "Model_DbTable" qui est lié au dossier ``models/DbTable/`` du module.

Pour étendre ``Zend\Db\Table``, seuls un nom de table et éventuellement un nom de clé primaire (si ce n'est pas
"id") sont nécessaires.

Créons maintenant un `Data Mapper`_. Un **Data Mapper** fait correspondre un objet métier à la base de données.
Dans notre cas ``Application_Model_Guestbook`` vers la source de données ``Application_Model_DbTable_Guestbook``.
Une *API* typique pour un data mapper est:

.. code-block:: php
   :linenos:

   // application/models/GuestbookMapper.php

   class Application_Model_GuestbookMapper
   {
       public function save($model);
       public function find($id, $model);
       public function fetchAll();
   }

En plus de ces méthodes nous allons ajouter des méthodes pour affecter/récupérer l'objet Table Data Gateway.
Pour créer la classe initiale, utilsez l'outil CLI ``zf``:

.. code-block:: console
   :linenos:

   % zf create model GuestbookMapper
   Creating a model at application/models/GuestbookMapper.php
   Updating project profile '.zfproject.xml'

Maintenant, éditez la classe ``Application_Model_GuestbookMapper`` dans ``application/models/GuestbookMapper.php``
pour y voir ceci:

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

Maintenant il faut créer la classe de modèle. Une fois de plus, nous utiliserons la commande ``zf create model``:

.. code-block:: console
   :linenos:

   % zf create model Guestbook
   Creating a model at application/models/Guestbook.php
   Updating project profile '.zfproject.xml'

Nous allons modifier cette classe *PHP* vide pour simplifier le remplissage du modèle via un tableau dans le
constructeur ou une méthode ``setOptions()``. Le code final de la classe de modèle stockée dans
``application/models/Guestbook.php`` devrait ressembler à ceci:

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

Enfin, pour connecter tous ces éléments ensemble, créons un contrôleur qui listera les entrées de la base de
données.

Pour créer le nouveau contrôleur, utilisez la commande ``zf create controller``:

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

Ceci va créer ``GuestbookController`` dans ``application/controllers/GuestbookController.php``, avec une seule
action ``indexAction()``. Un script de vue sera aussi crée pour ce contrôleur, il sera logé dans
``application/views/scripts/guestbook/``, avec une vue pour l'action index.

Nous allons utiliser l'action "index" pour lister toutes les entrées du livre d'or.

Un aterrissage sur ``indexAction()`` devra lister toutes les entrées du livre d'or. Ceci ressemblera à ce qui
suit:

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

Et bien sûr un script de vue sera nécessaire. Editez ``application/views/scripts/guestbook/index.phtml`` pour y
inclure ceci:

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

   **Checkpoint**

   Naviguez maintenant vers "http://localhost/guestbook". Vous devriez voir ceci apparaitre dans votre navigateur:

   .. image:: ../images/learning.quickstart.create-model.png
      :width: 525
      :align: center

.. note::

   **Utiliser le script de chargement des données**

   Le script de chargement des données montré dans la section en question (``scripts/load.sqlite.php``) peut
   être utilisé pour créer une base de données pour chaque environnement défini et la remplir de données
   d'exemple. En interne, il utilise ``Zend\Console\Getopt``, qui permet de préciser des options à la commande.
   Si vous passez "-h" ou "--help", toutes les options disponibles seront affichées:

   .. code-block:: php
      :linenos:

      Usage: load.sqlite.php [ options ]
      --withdata|-w         Load database with sample data
      --env|-e [  ]         Application environment for which to create database
                            (defaults to development)
      --help|-h             Help -- usage message)]]

   L'option "-e" permet de préciser la valeur de la constante ``APPLICATION_ENV``-- ce qui en effet permet de
   créer une base de données SQLite pour chaque environnement défini. N'oubliez pas l'envrionnement lorsque vous
   utilisez ce script.



.. _`Table Data Gateway`: http://martinfowler.com/eaaCatalog/tableDataGateway.html
.. _`Data Mapper`: http://martinfowler.com/eaaCatalog/dataMapper.html
