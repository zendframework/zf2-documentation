.. EN-Revision: none
.. _zend.session.savehandler.dbtable:

Zend\Session_SaveHandler\DbTable
================================

Das Basis Setup für ``Zend\Session_SaveHandler\DbTable`` muß zumindest vier Spalten haben, die wie folgt im
Config Array oder ``Zend_Config`` Objekt beschrieben werden: primary, ist der Primary-Key und standardmäßig nur
die SessionID welche standardmäßig ein String der Länge 32 ist; modified, ist der Unix-Timestamp des Datums der
letzten Änderung; lifetime, ist die Lebenszeit der Session (``modified + lifetime > time();``); und data, sind die
serialisierten Daten die in der Session gespeichert werden.

.. _zend.session.savehandler.dbtable.basic:

.. rubric:: Basis Setup

.. code-block:: sql
   :linenos:

   CREATE TABLE `session` (
     `id` char(32),
     `modified` int,
     `lifetime` int,
     `data` text,
     PRIMARY KEY (`id`)
   );

.. code-block:: php
   :linenos:

   // Datenbank Verbindung vorbereiten
   $db = Zend\Db\Db::factory('Pdo_Mysql', array(
       'host'     =>'example.com',
       'username' => 'dbuser',
       'password' => '******',
       'dbname'   => 'dbname'
   ));

   // Entweder den Standardadapter Zend\Db\Table setzen
   // oder eine DB-Verbindung direkt an den save Handler $config übergeben
   Zend\Db_Table\Abstract::setDefaultAdapter($db);
   $config = array(
       'name'           => 'session',
       'primary'        => 'id',
       'modifiedColumn' => 'modified',
       'dataColumn'     => 'data',
       'lifetimeColumn' => 'lifetime'
   );

   // Erstellen der Zend\Session_SaveHandler\DbTable und
   // Setzen des save Handlers für Zend_Session
   Zend\Session\Session::setSaveHandler(new Zend\Session_SaveHandler\DbTable($config));

   // Session starten
   Zend\Session\Session::start();

   // Jetzt kann Zend_Session wie sonst verwendet werden

Man kann auch mehrere Spalten im Primarykey für ``Zend\Session_SaveHandler\DbTable`` verwenden.

.. _zend.session.savehandler.dbtable.multi-column-key:

.. rubric:: Mehr-Spalten Primary-Keys verwenden

.. code-block:: sql
   :linenos:

   CREATE TABLE `session` (
       `session_id` char(32) NOT NULL,
       `save_path` varchar(32) NOT NULL,
       `name` varchar(32) NOT NULL DEFAULT '',
       `modified` int,
       `lifetime` int,
       `session_data` text,
       PRIMARY KEY (`Session_ID`, `save_path`, `name`)
   );

.. code-block:: php
   :linenos:

   // Die DB Verbindung wie vorher einrichten
   // BEACHTE: Diese Config wird auch an Zend\Db\Table übergeben sodas
   // spezielles für die Tabelle genauso in die Config gegeben werden kann
   $config = array(
       'name'              => 'session', // Tabellenname von Zend\Db\Table
       'primary'           => array(
           'session_id',   // Die SessionID von PHP
           'save_path',    // session.save_path
           'name',         // Session Name
       ),
       'primaryAssignment' => array(
           // Man muß dem Save-Handler mitteilen welche Spalten man als
           // Primary-Key verwendet. DIE REIHENFOLGE IST WICHITG
           'sessionId', // Erste Spalte des Primary-Keys ist die sessionID
           'sessionSavePath', // Zweite Spalte des Primary-Keys ist der save-path
           'sessionName', // Dritte Spalte des Primary-Keys ist der Session Name
       ),
       'modifiedColumn' => 'modified', // Zeit nach der die Session abläuft
       'dataColumn'     => 'session_data', // Serialisierte Daten
       'lifetimeColumn' => 'lifetime', // Lebensende für einen speziellen Eintrag
   );

   // Zend_Session mitteilen das der Save Handler verwendet werden soll
   Zend\Session\Session::setSaveHandler(new Zend\Session_SaveHandler\DbTable($config));

   // Session starten
   Zend\Session\Session::start();

   // Zend_Session wie normal verwenden


