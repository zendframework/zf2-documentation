.. _zend.session.savehandler.dbtable:

Zend_Session_SaveHandler_DbTable
================================

Le paramétrage basique pour ``Zend_Session_SaveHandler_DbTable`` doit contenir au moins quatre colonnes, décrites
dans une configuration de type *array* ou objet ``Zend_Config``: "primary" qui est la clé primaire et reçoit par
défaut l'ID de session dont le format est par défaut une chaîne de 32 caractères ; "modifiedColumn" qui est le
timestamp Unix de la date de dernière modification ; "lifetimeColumn" qui est la durée de vie de la session
("modified" + "lifetime" doit être supérieur à "time()") ; et "dataColumn" qui est la donnée sérialisée
stockée en session.

.. _zend.session.savehandler.dbtable.basic:

.. rubric:: Paramétrage basique

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

   // Préparation de l'adaptateur de connexion à la base de données
   $db = Zend_Db::factory('Pdo_Mysql', array(
       'host'        =>'example.com',
       'username'    => 'dbuser',
       'password'    => '******',
       'dbname'    => 'dbname'
   ));

   // Vous pouvez soit passer l'adaptateur par défaut à Zend_Db_Table
   // ou l'objet $db dans votre tableau $config
   Zend_Db_Table_Abstract::setDefaultAdapter($db);
   $config = array(
       'name'           => 'session',
       'primary'        => 'id',
       'modifiedColumn' => 'modified',
       'dataColumn'     => 'data',
       'lifetimeColumn' => 'lifetime'
   );

   // Création de votre Zend_Session_SaveHandler_DbTable
   // et paramétrage du gestionnaire de sauvegarde à Zend_Session
   Zend_Session::setSaveHandler(new Zend_Session_SaveHandler_DbTable($config));

   // Démarrage de la session
   Zend_Session::start();

   // Vous pouvez maintenant utiliser Zend_Session comme avant

Vous pouvez aussi utiliser des colonnes multiples pour votre clé primaire de ``Zend_Session_SaveHandler_DbTable``.

.. _zend.session.savehandler.dbtable.multi-column-key:

.. rubric:: Utilisation d'une clé primaire multi-colonnes

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

   // Préparation de l'adaptateur de connexion à la base de données comme ci-dessus
   // NOTE : cette configuration est fournie à Zend_Db_Table donc tout élément spécifique à la table peut y être ajouté
   $config = array(
       'name'              => 'session',
       // Nom de la table comme pour Zend_Db_Table
       'primary'           => array(
           'session_id',
           // l'ID de session fourni par PHP
           'save_path',
           // session.save_path
           'name',
           // session name
       ),
       'primaryAssignment' => array(
       // vous devez avertir le gestionnaire de sauvegarde quelles colonnes
       // vous utilisez en tant que clé primaire. L'ORDRE EST IMPORTANT.
           'sessionId',
           // - la première colonne de la clé primaire est l'ID de session
           'sessionSavePath',
           // - la seconde colonne de la clé primaire est le "save path"
           'sessionName',
           // - la troisième colonne de la clé primaire est le "session name"
       ),
       'modifiedColumn'    => 'modified',
       // date de la dernière modification
       'dataColumn'        => 'session_data',
       // donnée sérialisée
       'lifetimeColumn'    => 'lifetime',
       // durée de vie de l'enregistrement
   );

   // Informez Zend_Session d'utiliser votre gestionnaire de sauvegarde
   Zend_Session::setSaveHandler(
       new Zend_Session_SaveHandler_DbTable($config)
   );

   // Démarrage de la session
   Zend_Session::start();

   // Utilisez Zend_Session normalement


