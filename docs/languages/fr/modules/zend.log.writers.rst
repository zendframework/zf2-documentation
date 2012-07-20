.. _zend.log.writers:

Rédacteurs (Writers)
====================

Un rédacteur est un objet qui hérite de ``Zend_Log_Writer_Abstract``. La responsabilité d'un rédacteur est
d'enregistrer des données de log dans un stockage particulier.

.. _zend.log.writers.stream:

Écrire vers un flux (stream)
----------------------------

``Zend_Log_Writer_Stream`` envoie des données de log à un `flux de PHP`_.

Pour écrire des données de log dans le buffer d'affichage de PHP, il faut utiliser l'URL *php://output*.
Alternativement, vous pouvez préférer envoyer des données de log directement à un flux comme ``STDERR``
(*php://stderr*).

   .. code-block:: php
      :linenos:

      $redacteur = new Zend_Log_Writer_Stream('php://output');
      $logger = new Zend_Log($redacteur);

      $logger->info("Message d'information");



Pour écrire des données dans un fichier, employer un des `Filesystem URLs`_:

   .. code-block:: php
      :linenos:

      $redacteur = new Zend_Log_Writer_Stream('/chemin/vers/fichierdelog');
      $logger = new Zend_Log($redacteur);

      $logger->info("Message d'information");

Par défaut, le flux s'ouvre en mode d'ajout (*"a"*). Pour l'ouvrir avec un mode différent, le constructeur de
``Zend_Log_Writer_Stream`` accepte un deuxième paramètre facultatif pour le mode.

Le constructeur de ``Zend_Log_Writer_Stream`` accepte également une ressource existante de flux :

   .. code-block:: php
      :linenos:

      $flux = @fopen('/chemin/vers/fichierdelog', 'a', false);
      if (! $flux) {
          throw new Exception('Impossible d\'ouvrir le flux');
      }

      $redacteur = new Zend_Log_Writer_Stream($flux);
      $logger = new Zend_Log($redacteur);

      $logger->info("Message d'information");

Vous ne pouvez pas indiquer le mode pour des ressources existantes de flux. Le faire entraînera une
``Zend_Log_Exception``.

.. _zend.log.writers.database:

Écrire dans des bases de données
--------------------------------

``Zend_Log_Writer_Db`` écrit les informations de log dans une table de base de données en utilisant ``Zend_Db``.
Le constructeur de ``Zend_Log_Writer_Db`` reçoit une instance de ``Zend_Db_Adapter``, un nom de table, et un plan
de correspondance entre les colonnes de la base de données et les données élémentaires d'événement :

   .. code-block:: php
      :linenos:

      $parametres = array ('host'     => '127.0.0.1',
                       'username' => 'malory',
                       'password' => '******',
                       'dbname'   => 'camelot');
      $db = Zend_Db::factory('PDO_MYSQL', $parametres);

      $planDeCorrespondance = array('niveau' => 'priority', 'msg' => 'message');
      $redacteur = new Zend_Log_Writer_Db($db,
                                          'nom_de_la_table_de_log',
                                          $planDeCorrespondance);

      $logger = new Zend_Log($redacteur);

      $logger->info("Message d'information");

L'exemple ci-dessus écrit une ligne unique de données de log dans la table appelée *nom_de_la_table_de_log*. La
colonne de base de données appelée *niveau* reçoit le niveau de priorité et la colonne appelée *msg* reçoit
le message de log.

.. include:: zend.log.writers.firebug.rst
.. include:: zend.log.writers.mail.rst
.. include:: zend.log.writers.syslog.rst
.. include:: zend.log.writers.zend-monitor.rst
.. _zend.log.writers.null:

Déraciner les rédacteurs
------------------------

Le ``Zend_Log_Writer_Null`` est une souche qui écrit des données de log nulle part. Il est utile pour neutraliser
le log ou déraciner le log pendant les essais :

   .. code-block:: php
      :linenos:

      $redacteur = new Zend_Log_Writer_Null;
      $logger = new Zend_Log($redacteur);

      // va nulle part
      $logger->info("Message d'information");



.. _zend.log.writers.mock:

Tester avec un simulacre
------------------------

Le ``Zend_Log_Writer_Mock`` est un rédacteur très simple qui enregistre les données brutes qu'il reçoit dans un
tableau exposé comme propriété publique.

   .. code-block:: php
      :linenos:

      $simulacre = new Zend_Log_Writer_Mock;
      $logger = new Zend_Log($simulacre);

      $logger->info("Message d'information");

      var_dump($mock->events[0]);

      // Array
      // (
      //    [timestamp] => 2007-04-06T07:16:37-07:00
      //    [message] => Message d'information
      //    [priority] => 6
      //    [priorityName] => INFO
      // )



Pour effacer les événements notés dans le simulacre, il faut simplement réaliser *$simulacre->events =
array()*.

.. _zend.log.writers.compositing:

Additionner les rédacteurs
--------------------------

Il n'y a aucun objet composite de rédacteurs. Cependant, une instance d'enregistreur peut écrire vers tout nombre
de rédacteurs. Pour faire ceci, employer la méthode ``addWriter()``:

   .. code-block:: php
      :linenos:

      $redacteur1 =
          new Zend_Log_Writer_Stream('/chemin/vers/premier/fichierdelog');
      $redacteur2 =
          new Zend_Log_Writer_Stream('/chemin/vers/second/fichierdelog');

      $logger = new Zend_Log();
      $logger->addWriter($redacteur1);
      $logger->addWriter($redacteur2);

      // va dans les 2 rédacteurs
      $logger->info("Message d'information");





.. _`flux de PHP`: http://www.php.net/stream
.. _`Filesystem URLs`: http://www.php.net/manual/fr/wrappers.php#wrappers.file
