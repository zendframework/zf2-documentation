.. EN-Revision: none
.. _zend.authentication.adapter.dbtable:

Authentification avec une table de base de données
==================================================

.. _zend.authentication.adapter.dbtable.introduction:

Introduction
------------

``Zend\Auth\Adapter\DbTable`` fournit la possibilité d'authentifier sur la base de crédits stockés dans une
table de base de données. Comme ``Zend\Auth\Adapter\DbTable`` requiert qu'une instance de
``Zend\Db\Adapter\Abstract`` soit fournie à son constructeur, chaque instance est liée à une connexion de base
de données particulière. Les autres options de configuration peuvent être réglées grâce au constructeur ou au
travers de différentes méthodes, une pour chaque option.

Les options de configuration disponibles incluent :

- **tableName**\  : il s'agit du nom de la table dans la base de données qui contient les crédits
  d'authentification, et envers laquelle la requête d'authentification sera réalisée.

- **identityColumn**\  : il s'agit du nom de la colonne dans la table utilisée pour représenter l'identité. La
  colonne d'identité doit contenir une valeur unique, comme un "username" ou une adresse émail.

- **credentialColumn**\  : il s'agit du nom de la colonne dans la table utilisée pour représenter le crédit.
  Dans le cas d'une simple authentification par identité / mot de passe, la valeur de crédit correspond au mot de
  passe. Voir aussi l'option ``credentialTreatment``.

- **credentialTreatment**\  : dans la plupart des cas, les mots de passe et autres données sensibles sont
  cryptés, hachés, encodés, masqués, ou sinon traités à travers une fonction ou un algorithme. En spécifiant
  un traitement paramétrable de chaîne avec cette méthode, comme ``MD5(?)`` ou ``PASSWORD(?)``, un développeur
  peut appliquer un code *SQL* arbitraire sur les données de crédit fournies. Comme ces fonctions sont
  spécifiques à chaque gestionnaire de base de données (*SGBD*), vérifiez le manuel de la base de données pour
  vérifier la disponibilité de ces fonctions dans votre système.

.. _zend.authentication.adapter.dbtable.introduction.example.basic_usage:

.. rubric:: Utilisation basique

Comme expliqué dans l'introduction, le constructeur de ``Zend\Auth\Adapter\DbTable`` requiert une instance de
``Zend\Db\Adapter\Abstract`` qui est utilisée comme connexion à la base de données à laquelle l'instance
d'adaptateur d'authentification est liée. Avant tout, la connexion à la base de donnée devrait être crée.

Le code suivant crée un adaptateur pour une base de données en mémoire, crée un schéma avec une table unique,
et insère une ligne sur laquelle nous pouvons réaliser une requête d'authentification plus tard. Cet exemple
requiert que l'extension *PDO* SQLite soit disponible :

.. code-block:: php
   :linenos:

   // Crée une connexion de base de données SQLite en mémoire
   $dbAdapter = new Zend\Db\Adapter\Pdo\Sqlite(array('dbname' =>
                                                     ':memory:'));

   // Construit une requête de création de table
   $sqlCreate = 'CREATE TABLE [users] ( '
              . '[id] INTEGER  NOT NULL PRIMARY KEY, '
              . '[username] VARCHAR(50) UNIQUE NOT NULL, '
              . '[password] VARCHAR(32) NULL, '
              . '[real_name] VARCHAR(150) NULL)';

   // Crée la table de crédits d'authentification
   $dbAdapter->query($sqlCreate);

   // Construit la requête pour insérer une ligne pour laquelle
   // l'authentification pourra réussir
   $sqlInsert = "INSERT INTO users (username, password, real_name) "
              . "VALUES ('my_username', 'my_password', 'My Real Name')";

   // Insertion des données
   $dbAdapter->query($sqlInsert);

Avec une connexion de base de données et des données disponibles dans la table, une instance de
``Zend\Auth\Adapter\DbTable`` peut être créée. Les valeurs d'options de configuration peuvent être fournies au
constructeur ou en tant que paramètres aux méthodes de réglage après l'instanciation :

.. code-block:: php
   :linenos:

   // Configure une instance avec des paramètres de constructeur ...
   $authAdapter = new Zend\Auth\Adapter\DbTable($dbAdapter,
                                                'users',
                                                'username',
                                                'password');

   // ... ou configure l'instance avec des méthodes de réglage
   $authAdapter = new Zend\Auth\Adapter\DbTable($dbAdapter);
   $authAdapter->setTableName('users')
               ->setIdentityColumn('username')
               ->setCredentialColumn('password');

A cet instant, l'instance de l'adaptateur d'authentification est prête à recevoir des requêtes
d'authentification. Dans le but de réaliser une requête d'authentification, les valeurs des crédits requêtés
sont fournies à l'adaptateur avant d'appeler la méthode ``authenticate()``\  :

.. code-block:: php
   :linenos:

   // Règle les valeurs d'entrées des crédits
   // (en général, à partir d'un formulaire d'enregistrement)
   $authAdapter->setIdentity('my_username')
               ->setCredential('my_password');

   // Réalise la requête d'authentification, et sauvegarde le résultat
   $result = $authAdapter->authenticate();

En plus de la disponibilité de la méthode ``getIdentity()`` pour récupérer l'objet du résultat
d'authentification, ``Zend\Auth\Adapter\DbTable`` supporte aussi la récupération de la ligne de la table qui a
réussi l'authentification :

.. code-block:: php
   :linenos:

   // Affiche l'identité
   echo $result->getIdentity() . "\n\n";

   // Affiche la ligne de résultat
   print_r($authAdapter->getResultRowObject());

   /* Affiche:
   my_username

   Array
   (
       [id] => 1
       [username] => my_username
       [password] => my_password
       [real_name] => My Real Name
   )
   */

Puisque la ligne de la table contient la valeur de crédit, il est important de garantir ces valeurs contre
l'accès fortuit.

.. _zend.authentication.adapter.dbtable.advanced.storing_result_row:

Utilisation avancée : maintenir persistant l'objet de résultat DbTable
----------------------------------------------------------------------

Par défaut, ``Zend\Auth\Adapter\DbTable`` retourne l'identité fournie à l'objet Auth en cas d'authentification
couronnée de succès. Un autre scénario d'utilisation, où les développeurs veulent stocker dans le mécanisme
de stockage persistant du ``Zend_Auth`` un objet d'identité contenant d'autres informations utiles, est résolu en
utilisant la méthode ``getResultRowObject()`` retournant un objet **stdClass**. Le petit bout de code suivant
illustre cette utilisation :

.. code-block:: php
   :linenos:

   // authentifie avec Zend\Auth\Adapter\DbTable
   $result = $this->_auth->authenticate($adapter);

   if ($result->isValid()) {

       // stocke l'identité comme objet dans lequel seulement username et
       // real_name sont retournés
       $storage = $this->_auth->getStorage();
       $storage->write($adapter->getResultRowObject(array('username',
                                                          'real_name')));

       // stocke l'identité comme objet dans lequel la colonne password
       // a été omis
       $storage->write($adapter->getResultRowObject(null, 'password'));

       /* ... */

   } else {

       /* ... */

   }

.. _zend.authentication.adapter.dbtable.advanced.advanced_usage:

Utilisation avancée par l'exemple
---------------------------------

Bien que le but initial de ``Zend_Auth`` (et par extension celui de ``Zend\Auth\Adapter\DbTable``) est
principalement l'**authentification** et non l'**autorisation** (ou contrôle d'accès), il existe quelques
exemples et problèmes qui franchissent la limite des domaines auxquels ils appartiennent. Selon la façon dont
vous avez décidé d'expliquer votre problème, il semble parfois raisonnable de résoudre ce qui pourrait
ressembler à un problème d'autorisation dans l'adaptateur d'authentification.

Ceci étant dit, ``Zend\Auth\Adapter\DbTable`` possède des mécanismes qui sont construits de telle sorte qu'ils
peuvent être démultipliés pour ajouter des contrôles supplémentaires au moment de l'authentification pour
résoudre quelques problèmes communs d'utilisateur.

.. code-block:: php
   :linenos:

   // La valeur du champs "etat" d'un compte
   // ne doit pas être égal à "compromis"
   $adapter = new Zend\Auth\Adapter\DbTable($db,
                                            'utilisateurs',
                                            'login',
                                            'password',
                                            'MD5(?) AND etat != "compromis"');

   // La valeur du champs "actif" d'un compte
   // doit être égal à "TRUE"
   $adapter = new Zend\Auth\Adapter\DbTable($db,
                                            'utilisateurs',
                                            'login',
                                            'password',
                                            'MD5(?) AND actif = "TRUE"');

Un autre scénario possible est l'implantation d'un mécanisme de "salting". "Salting" est un terme se référant
une technique qui peut fortement améliorer la sécurité de votre application. C'est basé sur l'idée que
concaténer une chaîne aléatoire à tout mot de passe rend impossible la réussite d'une attaque de type "brute
force" sur la base de données en utilisant des valeurs préalablement hashées issues d'un dictionnaire.

Par conséquent nous devons modifier notre table pour stocker notre chaîne de "salt" aléatoire :

.. code-block:: php
   :linenos:

   $sqlAlter = "ALTER TABLE [users] "
             . "ADD COLUMN [password_salt] "
             . "AFTER [password]";

   $dbAdapter->query($sqlAlter);

Voici une méthode simple pour générer une chaîne aléatoire pour chaque utilisateur à leur enregistrement :

.. code-block:: php
   :linenos:

   for ($i = 0; $i < 50; $i++)
   {
       $dynamicSalt .= chr(rand(33, 126));
   }

Et maintenant, construisons l'adaptateur :

.. code-block:: php
   :linenos:

   $adapter = new Zend\Auth\Adapter\DbTable(
       $db,
       'users',
       'username',
       'password',
       "MD5(CONCAT('"
       . Zend\Registry\Registry::get('staticSalt')
       . "', ?, password_salt))"
   );

.. note::

   Vous pouvez encore améliorer la sécurité en utilisant une chaîne de "salt" statique codée en dur dans votre
   application. Dans le cas ou la base de données est compromise (par exemple par une attaque de type injection
   *SQL*) mais que votre serveur Web est intact, les données sont inutilisables par l'attaquant.

Une autre alternative est d'utiliser la méthode ``getDbSelect()`` de la classe ``Zend\Auth\Adapter\DbTable``
après la construction de l'adaptateur. Cette méthode retournera une instance d'objet ``Zend\Db\Select`` utilisée
pour réaliser la routine ``authenticate()``. Il est important de noter que cette méthode retournera toujours le
même objet, que la méthode ``authenticate()`` a été appelée ou non. Cet objet **ne comportera aucune**
information d'identité ou de crédit puisque celles-ci sont placées dans l'objet select au moment de
``authenticate()``.

Un exemple de situation nécessitant l'utilisation de la méthode ``getDbSelect()`` serait de vérifier le statut
d'un utilisateur, en d'autres termes pour voir si le compte d'un utilisateur est activé.

.. code-block:: php
   :linenos:

   // En continuant avec l'exemple ci-dessus
   $adapter = new Zend\Auth\Adapter\DbTable(
       $db,
       'users',
       'username',
       'password',
       'MD5(?)'
   );

   // Récupérer l'objet select (par référence)
   $select = $adapter->getDbSelect();
   $select->where('active = "TRUE"');

   // Authentification, ceci s'assure que users.active = TRUE
   $adapter->authenticate();


