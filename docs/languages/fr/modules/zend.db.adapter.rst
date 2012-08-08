.. EN-Revision: none
.. _zend.db.adapter:

Zend_Db_Adapter
===============

``Zend_Db`` et ses autres sous classes proposent une interface de connexion aux bases de données avec Zend
Framework. ``Zend_Db_Adapter`` est la classe de base que vous utilisez pour vous connecter aux bases de données
(SGBDs). Il y a différentes classes d'adaptateur par SGBD.

Les classes *Adapters* de ``Zend_Db`` créent un pont entre les extensions *PHP* et une interface commune. Ceci
vous aide à écrire des applications déployables avec de multiples SGBDs, demandant peu d'efforts.

L'interface de la classe d'adaptateur est semblable à celle de l'extension `PHP Data Objects`_. ``Zend_Db``
propose des classes d'adaptateurs vers les drivers *PDO* pour les SGBDs suivants :

- IBM DB2 et Informix Dynamic Server (IDS), en utilisant l'extension *PHP* `pdo_ibm`_.

- MySQL, utilisant l'extension *PHP* `pdo_mysql`_.

- Microsoft *SQL* Server, utilisant l'extension *PHP* `pdo_dblib`_.

- Oracle, utilisant l'extension *PHP* `pdo_oci`_.

- PostgreSQL, grâce à l'extension *PHP* `pdo_pgsql`_.

- SQLite, avec l'extension *PHP* `pdo_sqlite`_.

De plus, ``Zend_Db`` fournit aussi des classes se connectant avec les extensions *PHP* propres aux SGBDs (hors
*PDO* donc), pour les SGBDs suivants :

- MySQL, utilisant l'extension *PHP* `mysqli`_.

- Oracle, utilisant l'extension *PHP* `oci8`_.

- IBM DB2, utilisant l'extension *PHP* `ibm_db2`_.

- Firebird (Interbase), utilisant l'extension *PHP* `php_interbase`_

.. note::

   Chaque ``Zend_Db_Adapter`` utilise une extension *PHP*. Vous devez donc les avoir activées pour utiliser les
   classes en question. Par exemple, si vous voulez utiliser une classe ``Zend_Db_Adapter`` basée sur *PDO*, vous
   devrez alors avoir l'extension *PDO* d'installée, ainsi que l'extension représentant le driver spécifique à
   votre SGBD.

.. _zend.db.adapter.connecting:

Se connecter à un SGBD en utilisant un adaptateur
-------------------------------------------------

Cette section décrit comment créer une instance d'un adaptateur ``Zend_Db`` de base de données.

.. _zend.db.adapter.connecting.constructor:

Utilisation du constructeur du Zend_Db Adapter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Vous pouvez créer une instance d'un adaptateur en utilisant son constructeur. Celui-ci accepte un paramètre
représentant un tableau d'options.

.. _zend.db.adapter.connecting.constructor.example:

.. rubric:: Utiliser le constructeur de l'adaptateur

.. code-block:: php
   :linenos:

   $db = new Zend_Db_Adapter_Pdo_Mysql(array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

.. _zend.db.adapter.connecting.factory:

Utiliser la fabrique (Factory) de Zend_Db
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Alternativement, il est possible d'utiliser la méthode statique ``Zend_Db::factory()``. Celle-ci charge
dynamiquement la classe d'adaptateur correspondant en utilisant :ref:`Zend_Loader::loadClass()
<zend.loader.load.class>`.

Le premier argument est une chaîne désignant l'adaptateur souhaité. Par exemple, "``Pdo_Mysql``" va correspondre
à la classe ``Zend_Db_Adapter_Pdo_Mysql``. Le second paramètre est un tableau d'options. C'est le même que celui
que vous auriez passé au constructeur de la classe directement.

.. _zend.db.adapter.connecting.factory.example:

.. rubric:: Utilisation de la méthode statique de fabrique de Zend_Db

.. code-block:: php
   :linenos:

   // Nous n'avons pas besoin de la ligne suivante car Zend_Db_Adapter_Pdo_Mysql
   // sera automatiquement chargé par la fabrique Zend_Db.

   // require_once 'Zend/Db/Adapter/Pdo/Mysql.php';

   // Charge automatiquement la classe Zend_Db_Adapter_Pdo_Mysql
   // et en créer une instance.
   $db = Zend_Db::factory('Pdo_Mysql', array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

Si vous créez votre propre classe d'adaptateur qui étend ``Zend_Db_Adapter_Abstract`` et que celle-ci ne respecte
pas la syntaxe du préfixe package "``Zend_Db_Adapter``", utilisez alors la clé "*adapterNamespace*" dans le
tableau de configuration passé à la méthode ``factory()`` afin de charger votre adaptateur.

.. _zend.db.adapter.connecting.factory.example2:

.. rubric:: Utilisation de la fabrique avec une classe personnalisée

.. code-block:: php
   :linenos:

   // Charge automatiquement la classe MyProject_Db_Adapter_Pdo_Mysql
   // et l'instantie.
   $db = Zend_Db::factory('Pdo_Mysql', array(
       'host'             => '127.0.0.1',
       'username'         => 'webuser',
       'password'         => 'xxxxxxxx',
       'dbname'           => 'test',
       'adapterNamespace' => 'MyProject_Db_Adapter'
   ));

.. _zend.db.adapter.connecting.factory-config:

Utiliser Zend_Config avec la fabrique Zend_Db
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Optionnellement, vous pouvez passer un objet de type :ref:`Zend_Config <zend.config>` en tant qu'argument de la
méthode ``factory()``, concernant la configuration.

Il est alors nécessaire que l'objet de configuration contienne une propriété *adapter*, qui représente une
chaîne de caractères décrivant l'adaptateur à utiliser. De plus, l'objet peut aussi contenir une propriété
nommée *params*, avec toutes les sous propriétés requises pour la configuration de l'adaptateur.

.. _zend.db.adapter.connecting.factory.example1:

.. rubric:: Utilisation de la fabrique avec un objet de type Zend_Config

Dans l'exemple qui va suivre, l'objet ``Zend_Config`` est crée à partir d'un tableau. Il eut été possible de le
créer à partir de fichiers externes, grâce à :ref:`Zend_Config_Ini <zend.config.adapters.ini>` ou
:ref:`Zend_Config_Xml <zend.config.adapters.xml>`.

.. code-block:: php
   :linenos:

   $config = new Zend_Config(
       array(
           'database' => array(
               'adapter' => 'Mysqli',
               'params' => array(
                   'host'     => '127.0.0.1',
                   'dbname'   => 'test',
                   'username' => 'webuser',
                   'password' => 'secret',
               )
           )
       )
   );

   $db = Zend_Db::factory($config->database);

Le second paramètre de la méthode ``factory()`` doit être un tableau associatif décrivant les paramètres de
l'adaptateur à utiliser. Cet argument est optionnel, si un objet de type ``Zend_Config`` est utilisé en premier
paramètre, alors il est supposé contenir les paramètres, et le second paramètre de ``factory()`` est alors
ignoré.

.. _zend.db.adapter.connecting.parameters:

Paramètres de l'adaptateur (Adapter)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La liste ci dessous explique les différents paramètres acceptés par les classes d'adaptateur ``Zend_Db``.

- **host**\  : le nom de l'hôte hébergeant le SGBD. Vous pouvez aussi spécifier une adresse IP. Si le SGBD se
  situe sur la même machine que l'application *PHP*, "localhost" ou "127.0.0.1" devraient alors être utilisés.

- **username**\  : nom d'utilisateur du compte de connexion au SGBD.

- **password**\  : mot de passe de l'utilisateur du compte de connexion au SGBD.

- **dbname**\  : nom de la base de données située dans le SGBD.

- **port**\  : Certains SGBDs acceptent que l'on spécifie un port pour d'y connecter. Indiquez le alors ici.

- **charset**\  : encodage utilisé pour la connexion.

- **options**\  : Ce paramètre est un tableau associatif d'options génériques à toutes les classes
  ``Zend_Db_Adapter``.

- **driver_options**\  : Ce paramètre est un tableau associatif d'options spécifiques à une extension de SGBD
  spécifique. Typiquement, il est possible avec ce paramètre de passer des options (attributs) au driver *PDO*.

- **adapterNamespace**\  : fournit le commencement du nom de la classe d'adaptateur, à utiliser la place de
  "``Zend_Db_Adapter``". Utilisez ceci si vous désirez que ``factory()`` charge une classe non Zend.

.. _zend.db.adapter.connecting.parameters.example1:

.. rubric:: Passer l'option de gestion de la casse à la fabrique

Vous pouvez spécifier cette option avec la constante ``Zend_Db::CASE_FOLDING``. Ceci correspond à l'attribut
``ATTR_CASE`` dans les drivers *PDO* et IBM DB2, ce qui ajuste la casse des clés dans les jeux de résultats. Les
valeurs possibles possibles sont ``Zend_Db::CASE_NATURAL`` (défaut), ``Zend_Db::CASE_UPPER``, et
``Zend_Db::CASE_LOWER``.

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

.. rubric:: Passer l'option d'auto-échappement à la fabrique

Vous pouvez spécifier cette option avec le paramètre ``Zend_Db::AUTO_QUOTE_IDENTIFIERS``. Si la valeur passée
est ``TRUE`` (par défaut), alors les identifiants tels que les noms de tables, de colonnes, ou encore les alias
*SQL*, sont échappés (délimités) dans la syntaxe de la requête *SQL* générée par l'objet d'adaptateur. Ceci
rend l'utilisation de mots *SQL* contenant des identifiant spéciaux plus simple. Dans le cas de ``FALSE``, vous
devrez vous-même délimiter ces identifiant avec la méthode ``quoteIdentifier()``.

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

.. rubric:: Passer des options de driver PDO à la fabrique

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

.. rubric:: Passer des options de sérialisation à la fabrique

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

Gestion des connexions dites paresseuses
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La création d'une instance d'une classe d'adaptateur ne crée pas physiquement une connexion au SGBD. L'adaptateur
sauvegarde les paramètres et se connectera physiquement à la demande, la première fois que vous aurez besoin
d'exécuter une requête. Ceci permet d'assurer que la création de l'instance elle-même est rapide, et ne coûte
rien en performances. Vous pouvez donc créer une instance de l'adaptateur, même si vous ne savez pas si vous
allez l'utiliser. Ainsi, si vos paramètres sont incorrects, il faudra attendre la tentative de connexion au SGBD
pour le vérifier réellement.

Si vous voulez forcer l'adaptateur à se connecter au SGBD, utilisez sa méthode ``getConnection()``. Elle
retournera alors un objet représentant la connexion, en fonction de l'extension *PHP* utilisée, ou une exception
si la connexion n'a pas été réalisée. Par exemple, si votre adaptateur utilise *PDO*, le retour sera un objet
*PDO*. La connexion physique au SGBD est alors réalisée.

Afin de vérifier si les paramètres de connexion au SGBD sont corrects, surveillez les exceptions envoyées par la
méthode ``getConnection()``.

De plus, un adaptateur peut être sérialisé pour être stocké, par exemple, dans une variable de session. Ceci
peut être utile non seulement pour l'adaptateur lui-même, mais aussi pour les autres objets qui l'agrègent,
comme un objet ``Zend_Db_Select``. Par défaut, les adaptateurs sont autorisés à être sérialisés, si vous ne
le voulez pas, vous devez passer l'option ``Zend_Db::ALLOW_SERIALIZATION=false``, regardez l'exemple ci-dessus.
Afin de respecter le principe de connexions paresseuses, l'adaptateur ne se reconnectera pas après la
désérialisation. Vous devez appeler vous-même ``getConnection()``. Vous pouvez permettre à l'adaptateur de se
reconnecter automatiquement en utilisant l'option d'adaptateur ``Zend_Db::AUTO_RECONNECT_ON_UNSERIALIZE=true``.

.. _zend.db.adapter.connecting.getconnection.example:

.. rubric:: Gérer les exceptions de connexion

.. code-block:: php
   :linenos:

   try {
       $db = Zend_Db::factory('Pdo_Mysql', $parameters);
       $db->getConnection();
   } catch (Zend_Db_Adapter_Exception $e) {
       // probablement mauvais identifiants,
       // ou alors le SGBD n'est pas joignable
   } catch (Zend_Exception $e) {
       // probablement que factory() n'a pas réussi à charger
       // la classe de l'adaptateur demandé
   }

.. _zend.db.adapter.example-database:

La base de données d'exemple
----------------------------

Dans cette documentation concernant ``Zend_Db``, nous utilisons un exemple simple de tables pour illustrer nos
exemples. Ces tables peuvent servir à stocker des informations sur la gestion des bugs dans une application. La
base de données contient quatre tables :

- **accounts** correspond aux informations sur les utilisateurs qui gèrent les bugs.

- **products** enregistre les produits pour lesquels des bugs vont être relevés.

- **bugs** est la table qui contient les bugs, à savoir leur état actuel, la personne ayant relevé le bug, la
  personne en charge de le corriger, et la personne chargée de vérifier le correctif.

- **bugs_products** enregistre les relations entre les bugs, et les produits. C'est une relation plusieurs à
  plusieurs car un même bug peut faire partie de plusieurs produits, et un produit peut évidemment posséder
  plusieurs bugs.

Le pseudo-code *SQL* suivant représente les tables de notre base de données d'exemple. Ces tables sont utilisées
aussi pour les tests unitaires automatisés de ``Zend_Db``.

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

Notez aussi que la table *bugs* contient plusieurs référence (clés étrangères) vers la table *accounts*.
Chacune de ces clés peut référencer un enregistrement différent de la table *accounts*, pour un bug donné.

Le diagramme qui suit illustre le modèle physique des données.

.. image:: ../images/zend.db.adapter.example-database.png
   :width: 387
   :align: center

.. _zend.db.adapter.select:

Lecture de résultats de requête
-------------------------------

Cette section décrit des méthodes de la classe d'adaptateur permettant l'obtention de résultats suivants une
requête SELECT.

.. _zend.db.adapter.select.fetchall:

Récupérer tous les résultats
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Vous pouvez à la fois exécuter une requête SELECT et récupérer tous ses résultats en une seule manipulation,
grâce à la méthode ``fetchAll()``.

Le premier paramètre de cette méthode est une chaîne représentant la requête SELECT à exécuter. Aussi, ce
premier paramètre peut être un objet :ref:`Zend_Db_Select <zend.db.select>`, qui sera alors converti en une
chaîne automatiquement.

Le second paramètre de de ``fetchAll()`` est un tableau de substitutions des éventuels jokers présents dans la
syntaxe *SQL*.

.. _zend.db.adapter.select.fetchall.example:

.. rubric:: Utiliser fetchAll()

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE bug_id = ?';

   $result = $db->fetchAll($sql, 2);

.. _zend.db.adapter.select.fetch-mode:

Changer le mode de récupération (Fetch Mode)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Par défaut, ``fetchAll()`` retourne un tableau d'enregistrements. Chaque enregistrement étant un tableau
associatif dont les clés sont les noms des colonnes *SQL* désirées, ou leurs alias.

Vous pouvez spécifier un mode de récupération de résultats différent, ceci par la méthode ``setFetchMode()``.
Les modes supportés sont identifiés par des constantes :

- **Zend_Db::FETCH_ASSOC**\  : Retourne un tableau d'enregistrements. Chaque enregistrement étant un tableau
  associatif dont les clés sont les noms des colonnes *SQL* désirées, ou leurs alias. Il s'agit du mode par
  défaut utilisé par les classes Zend_Db_Adapter.

  Notez que si votre résultat comporte plusieurs colonnes avec le même nom, par exemple lors d'une jointure, il
  ne peut y avoir qu'un clé avec un nom définit dans le tableau de résultat. Vous devriez toujours utiliser des
  alias avec le mode FETCH_ASSOC.

  Les noms des clés des tableaux correspondants aux noms des colonnes *SQL* telles que retournées par le SGBD,
  vous pouvez spécifier la casse pour ces noms, grâce à l'option ``Zend_Db::CASE_FOLDING``. Spécifiez ceci lors
  de l'instanciation de votre adaptateur. Voyez :ref:` <zend.db.adapter.connecting.parameters.example1>`.

- **Zend_Db::FETCH_NUM**\  : Retourne les enregistrements dans un tableau de tableaux. Les tableaux nichés sont
  indexés par des entiers correspondants à la position du champ dans la syntaxe *SQL* SELECT.

- **Zend_Db::FETCH_BOTH**\  : Retourne les enregistrements dans un tableau de tableaux. Les tableaux nichés sont
  indexés à la fois numériquement et lexicalement. C'est un mode qui réunit FETCH_ASSOC et FETCH_NUM. Ainsi,
  vous avez deux fois plus d'enregistrements, chacun d'entre eux étant doublé.

- **Zend_Db::FETCH_COLUMN**: Retourne les enregistrements dans un tableau de valeurs. Les valeurs correspondent à
  une des colonnes utilisées dans la requête *SQL* SELECT. Par défaut, il s'agit de la colonne à l'index 0.

- **Zend_Db::FETCH_OBJ**\  : Retourne les enregistrements dans un tableau d'objets. La classe de ces objets par
  défaut est la classe intégrée à *PHP*: *stdClass*. Les colonnes des enregistrements sont représentées par
  les propriétés publiques des objets.

.. _zend.db.adapter.select.fetch-mode.example:

.. rubric:: Utiliser setFetchMode()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchAll('SELECT * FROM bugs WHERE bug_id = ?', 2);

   // $result est un tableau d'objets
   echo $result[0]->bug_description;

.. _zend.db.adapter.select.fetchassoc:

Récupérer un enregistrement comme tableau associatif
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La méthode ``fetchAssoc()`` retourne des enregistrements sous forme de tableau de tableaux associatifs, quelque
soit la valeur de "fetch mode" en utilisant la première colonne comme index.

.. _zend.db.adapter.select.fetchassoc.example:

.. rubric:: Utiliser f ``etchAssoc()``

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchAssoc('SELECT bug_id, bug_description, bug_status FROM bugs');

   // $result est un tableau de tableaux associatifs
   echo $result[2]['bug_description']; // Description du bug #2
   echo $result[1]['bug_description']; // Description du bug #1

.. _zend.db.adapter.select.fetchcol:

Récupérer une seule colonne d'un enregistrement
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La méthode ``fetchCol()`` retourne les enregistrements dans un tableau de valeurs. Les valeurs correspondent à
une des colonnes utilisées dans la requête *SQL* SELECT, par défaut : la première. Toute autre colonne sera
ignorée. Si vous avez besoin de retourner une autre colonne, voyez :ref:`
<zend.db.statement.fetching.fetchcolumn>`. Cette méthode est indépendante de la valeur de "fetch mode".

.. _zend.db.adapter.select.fetchcol.example:

.. rubric:: Utiliser fetchCol()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $sql = 'SELECT bug_description, bug_id FROM bugs WHERE bug_id = ?';
   $result = $db->fetchCol($sql, 2);

   // Contient bug_description ; bug_id n'est pas retourné
   echo $result[0];

.. _zend.db.adapter.select.fetchpairs:

Récupérer des paires Clé-Valeur d'enregistrements
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La méthode ``fetchPairs()`` retourne un tableau de paires clés/valeurs. La clé est le résultat de la première
colonne sélectionnée dans la requête, la valeur est le résultat de la deuxième colonne sélectionnée dans la
requête. Il est donc inutile de sélectionner plus de deux colonnes avec cette méthode. De même, vous devez
sélectionner exactement deux colonnes avec cette méthode, pas moins. Si des clés ont des doublons, alors ils
seront écrasés.

Vous devriez réfléchir votre requête SELECT de manière à ce que la première colonne sélectionnée,
correspondant à la clé du tableau de résultat, soit unique (une clé primaire par exemple). Cette méthode est
indépendante de "fetch mode" éventuellement précédemment défini.

.. _zend.db.adapter.select.fetchpairs.example:

.. rubric:: Utilisation de fetchPairs()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchPairs('SELECT bug_id, bug_status FROM bugs');

   echo $result[2]; // le bug_status correspondant au bug_id numéro 2

.. _zend.db.adapter.select.fetchrow:

Récupérer un seul enregistrement complet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La méthode ``fetchRow()`` retourne un et un seul enregistrement (le premier si plusieurs correspondent), en
fonction de "fetch mode" que vous aurez précédemment défini. Cette méthode ressemble donc à ``fetchAll()`` si
ce n'est qu'elle ne retournera jamais plus d'un seul enregistrement. Arrangez vous donc pour que votre SELECT
possède une clause WHERE sur une clé primaire.

.. _zend.db.adapter.select.fetchrow.example:

.. rubric:: Utiliser fetchRow()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchRow('SELECT * FROM bugs WHERE bug_id = 2');

   // Ce résultat sera un objet, car le fetch mode en a décidé ainsi
   echo $result->bug_description;

.. _zend.db.adapter.select.fetchone:

Récupérer une colonne d'un enregistrement
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La méthode ``fetchOne()`` est une combinaison des méthodes ``fetchRow()`` et ``fetchCol()``, ainsi elle ne
retourne que la première colonne, du premier enregistrement retourné. La valeur de retour est donc une chaîne de
caractères. Toute requête retournant plusieurs colonnes et/ou plusieurs résultats est donc inutile avec cette
méthode.

.. _zend.db.adapter.select.fetchone.example:

.. rubric:: Utiliser fetchOne()

.. code-block:: php
   :linenos:

   $result = $db->fetchOne('SELECT bug_status FROM bugs WHERE bug_id = 2');

   // ceci est une chaine
   echo $result;

.. _zend.db.adapter.write:

Effectuer des changements dans la base de données
-------------------------------------------------

Il est bien entendu possible d'utiliser la classe d'adaptateur pour effectuer des changements dans vos données.
Cette section décrit les manières de procéder.

.. _zend.db.adapter.write.insert:

Insérer des données
^^^^^^^^^^^^^^^^^^^

Vous pouvez ajouter de nouveaux enregistrements dans une table, grâce à la méthode ``insert()``. Son premier
paramètre est une chaîne qui représente le nom de la table ciblée, le second paramètre est un tableau
associatif liant les noms des colonnes de la table, aux valeurs souhaitées.

.. _zend.db.adapter.write.insert.example:

.. rubric:: Insertion dans une table

.. code-block:: php
   :linenos:

   $data = array(
       'created_on'      => '2007-03-22',
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

Les colonnes non citées dans le tableau associatif sont laissées telles quelles. Ainsi, si le SGBD possède une
valeur DEFAULT pour les colonnes concernées, celle-ci sera utilisée, autrement, NULL sera utilisé.

Par défaut, les valeurs insérées avec cette méthode sont automatiquement échappées. Ceci pour des raisons de
sécurité, vous n'avez donc pas besoin de vous occuper de ce point là.

Si vous avez besoin d'écrire de la syntaxe *SQL*, comme des mots réservés, des noms de fonctions *SQL*, vous
voulez que ceux-ci ne soient pas échappés, et ne soient pas traités comme de vulgaires chaînes de caractères,
mais plutôt comme des expressions. Pour ceci, vous devriez passer ces valeurs dans votre tableau de données, en
tant qu'objets de type ``Zend_Db_Expr`` au lieu de chaînes de caractères banales.

.. _zend.db.adapter.write.insert.example2:

.. rubric:: Insérer des expressions dans une table

.. code-block:: php
   :linenos:

   $data = array(
       'created_on'      => new Zend_Db_Expr('CURDATE()'),
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

.. _zend.db.adapter.write.lastinsertid:

Récupérer une valeur générée
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Certains SGBDs supportent les clé primaires auto-incrémentées. Une table qui utilise un tel procédé génère
la valeur de la clé automatiquement lors d'une insertion (INSERT). La valeur de retour de la méthode ``insert()``
**n'est pas** le dernier ID inséré car la table peut ne pas avoir de clé auto-incrémentée. La valeur de retour
est le nombres d'enregistrements affectés (théoriquement 1).

Si votre table a été définie avec une clé auto-incrémentée, alors vous pouvez appeler la méthode
``lastInsertId()`` après une opération d'insertion. Cette méthode retourne la valeur auto-incrémentée,
générée dans le cadre de la connexion au SGBD.

.. _zend.db.adapter.write.lastinsertid.example-1:

.. rubric:: Utiliser lastInsertId() pour les clés auto-incrémentées

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // retourne la dernière valeur générée par la clé auto-incrémentée
   $id = $db->lastInsertId();

Certains SGBD supporte un objet de séquence, qui sert à générer des valeurs uniques qui vont servir pour les
clé primaires. Pour supporter ce procédé, la méthode ``lastInsertId()`` accepte deux paramètres optionnels
(chaînes de caractères). Ces paramètres nomment la table et la colonne en supposant que vous ayez respecté la
convention qui définit que la séquence est nommée en utilisant le nom de la table et des colonnes utilisées,
avec le suffixe "\_seq". Ces conventions sont celles de PostgreSQL pour les colonnes de type SERIAL. Par exemple,
une table "bugs" avec une clé primaire "bug_id" utilisera une séquence nommée "bugs_bug_id_seq".

.. _zend.db.adapter.write.lastinsertid.example-2:

.. rubric:: Utiliser lastInsertId() avec une séquence

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // retourne la dernière valeur générée par la séquence 'bugs_bug_id_seq'.
   $id = $db->lastInsertId('bugs', 'bug_id');

   // ceci retourne la dernière valeur générée par la séquence 'bugs_seq'.
   $id = $db->lastInsertId('bugs');

Si le nom de votre objet de séquence ne suit pas ces conventions de nommage, utilisez alors ``lastSequenceId()``.
Cette méthode prend un paramètre qui nomme la séquence explicitement.

.. _zend.db.adapter.write.lastinsertid.example-3:

.. rubric:: Utilisation de lastSequenceId()

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // retourne la dernière valeur générée par la séquence 'bugs_id_gen'.
   $id = $db->lastSequenceId('bugs_id_gen');

Pour les SGBDs ne supportant pas les séquences, comme MySQL, Microsoft *SQL* Server, et SQLite, les arguments
passés à la méthode ``lastInsertId()`` sont ignorés. La valeur retournée est la dernière valeur générée
pour la dernière requête INSERT, quelque soit la table concernée (pour cette connexion). Aussi, pour ces SGBDs,
la méthode ``lastSequenceId()`` retournera toujours ``NULL``.

.. note::

   **Pourquoi ne pas utiliser "SELECT MAX(id) FROM table"?**

   Quelques fois, cette requête retourne la valeur la plus récente de clé primaire insérée dans la table en
   question. Cependant, cette technique n'est pas pertinente dans un environnement où beaucoup de clients
   insèrent beaucoup de données dans une même table. Il est donc possible qu'un client insère une donnée entre
   le moment où la dernière insertion est effectuée, et l'appel de MAX(id), aboutissant ainsi à un résultat
   erroné. Il est très difficile de se rendre compte d'un tel comportement.

   Utiliser un mode d'isolation transactionnelle très élevé, comme "repeatable read" peut mitiger plus ou moins
   les risques, mais certains SGBDs ne supportent pas ce mode de transactions.

   De plus, utiliser une requête du type "MAX(id)+1" pour générer une nouvelle valeur de clé primaire n'est pas
   sécurisé non plus, car deux client peuvent se connecter simultanément et créer des effets indésirables.

   Tous les SGBDs fournissent un mécanisme de génération de valeurs uniques, et une méthode pour les
   récupérer. Ces mécanismes travaillent en dehors du mode transactionnel, et empêchent ainsi deux clients de
   générer la même valeur, ou de "se marcher dessus".

.. _zend.db.adapter.write.update:

Mettre à jour des données
^^^^^^^^^^^^^^^^^^^^^^^^^

Vous pouvez mettre à jour des données dans une table en utilisant la méthode ``update()`` de l'adaptateur. Cette
méthode accepte trois arguments : le premier est le nom de la table, le deuxième est un tableau faisant
correspondre les noms des colonnes *SQL* à leurs valeurs désirées.

Les valeurs dans ce tableau sont traitées comme des chaînes. Voyez :ref:` <zend.db.adapter.write.insert>` pour
plus d'informations sur la gestion des expressions *SQL* dans ce tableau.

Le troisième argument est une chaîne contenant l'expression *SQL* utilisée comme critère pour la mise à jour
des données dans la table. Les valeurs et les arguments dans ce paramètre ne sont pas échappés pour vous. Vous
devez donc vous assurer de l'éventuel bon échappement des caractères. Voyez :ref:` <zend.db.adapter.quoting>`
pour plus d'informations.

La valeur de retour de cette méthode est le nombre d'enregistrements affectés par l'opération de mise à jour
(UPDATE).

.. _zend.db.adapter.write.update.example:

.. rubric:: Mettre à jour des enregistrements

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $n = $db->update('bugs', $data, 'bug_id = 2');

Si vous oubliez le troisième paramètre, alors tous les enregistrements de la table sont mis à jour avec les
valeurs spécifiées dans le tableau de données.

Si vous spécifiez un tableau de chaîne en tant que troisième paramètre, alors ces chaînes sont jointes entre
elles avec une opération ``AND``.

Si vous fournissez un tableau de tableaux en tant que troisième argument, les valeurs seront automatiquement
échappées dans les clés. Elles seront ensuite jointes ensemble, séparées par des opérateurs ``AND``.

.. _zend.db.adapter.write.update.example-array:

.. rubric:: Mettre à jour des enregistrements avec un tableau de données

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $where[] = "reported_by = 'goofy'";
   $where[] = "bug_status = 'OPEN'";

   $n = $db->update('bugs', $data, $where);

   // la requête SQL executée est :
   //  UPDATE "bugs" SET "update_on" = '2007-03-23', "bug_status" = 'FIXED'
   //  WHERE ("reported_by" = 'goofy') AND ("bug_status" = 'OPEN')

.. _zend.db.adapter.write.update.example-arrayofarrays:

.. rubric:: UMettre à jour des enregistrements avec un tableau de tableaux

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $where['reported_by = ?'] = 'goofy';
   $where['bug_status = ?']  = 'OPEN';

   $n = $db->update('bugs', $data, $where);

   // la requête SQL executée est :
   //  UPDATE "bugs" SET "update_on" = '2007-03-23', "bug_status" = 'FIXED'
   //  WHERE ("reported_by" = 'goofy') AND ("bug_status" = 'OPEN')

.. _zend.db.adapter.write.delete:

Supprimer des enregistrements
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Il est possible de supprimer des enregistrements dans une table. La méthode ``delete()`` est faite pour cela. Elle
accepte deux paramètres, le premier est une chaîne désignant la table.

Le second paramètre est une chaîne contenant l'expression *SQL* utilisée comme critère pour effacer les
enregistrements. Les valeurs de cette expression de sont pas échappées automatiquement, vous devez donc vous en
occuper le cas échéant. Voyez :ref:` <zend.db.adapter.quoting>` pour les méthodes concernant l'échappement.

La valeur retournée par la méthode ``delete()`` est le nombre d'enregistrements affectés (effacés).

.. _zend.db.adapter.write.delete.example:

.. rubric:: Supprimer des enregistrements

.. code-block:: php
   :linenos:

   $n = $db->delete('bugs', 'bug_id = 3');

Si vous ne spécifiez pas le second paramètres, tous les enregistrements de la table seront alors supprimés.

Si le second paramètre est un tableau de chaînes, alors celles ci seront jointe en une expression *SQL*,
séparées par l'opérateur ``AND``.

Si vous fournissez un tableau de tableaux en tant que troisième argument, les valeurs seront automatiquement
échappées dans les clés. Elles seront ensuite jointes ensemble, séparées par des opérateurs ``AND``.

.. _zend.db.adapter.quoting:

Échapper des valeurs ou des identifiants
----------------------------------------

Lorsque vous envoyez des requêtes SQL au SGBD, il est souvent nécessaire d'y inclure des paramètres dynamiques,
PHP. Ceci est risqué car si un des paramètres contient certains caractères, comme l'apostrophe ('), alors la
requête résultante risque d'être mal formée. Par exemple, notez le caractère indésirable dans la requête
suivante :

   .. code-block:: php
      :linenos:

      $name = "O'Reilly";
      $sql = "SELECT * FROM bugs WHERE reported_by = '$name'";

      echo $sql;
      // SELECT * FROM bugs WHERE reported_by = 'O'Reilly'



Pire encore est le cas où de telles erreurs *SQL* peuvent être utilisées délibérément par une personne afin
de manipuler la logique de votre requête. Si une personne peut manipuler un paramètre de votre requête, par
exemple via un paramètre *HTTP* ou une autre méthode, alors il peut y avoir une fuite de données, voire même
une corruption totale de votre base de données. Cette technique très préoccupante de violation de la sécurité
d'un SGBD, est appelée "injection *SQL*" (voyez `http://en.wikipedia.org/wiki/SQL_Injection`_).

La classe Zend_Db Adapter possède des méthodes adaptées pour vous aider à faire face à de telles
vulnérabilités. La solution proposée est l'échappement de tels caractères (comme la "quote" = ') dans les
valeurs *PHP* avant leur passage dans la chaîne de requête. Ceci vous protège de l'insertion malveillante ou
involontaires, de caractères spéciaux dans les variables *PHP* faisant partie d'une requête *SQL*.

.. _zend.db.adapter.quoting.quote:

Utilisation de quote()
^^^^^^^^^^^^^^^^^^^^^^

La méthode ``quote()`` accepte un seul paramètre, une chaîne de caractère. Elle retourne une chaîne dont les
caractères spéciaux ont été échappés d'une manière convenable en fonction du SGBD sous-jacent. De plus, la
chaîne échappée est entourée d'apostrophes ("*'*").C'est la valeur standard de délimitations des chaînes en
*SQL*.

.. _zend.db.adapter.quoting.quote.example:

.. rubric:: Utiliser quote()

.. code-block:: php
   :linenos:

   $name = $db->quote("O'Reilly");
   echo $name;
   // 'O\'Reilly'

   $sql = "SELECT * FROM bugs WHERE reported_by = $name";

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

Notez que la valeur de retour contient les apostrophes de délimitation autour de la chaîne. Ceci est différent
de certaines fonctions qui se contentent juste d'échapper les caractères spéciaux, telle que
`mysql_real_escape_string()`_.

Certaines valeurs en revanche n'ont pas besoin d'être délimitées. Certains SGBDs n'acceptent pas que les valeurs
correspondant à des champs de type entier, soient délimitées. Autrement dit, l'exemple suivant est erroné dans
certaines implémentations de SQL. Nous supposons *intColumn* ayant un type SQL ``INTEGER``\  :

   .. code-block:: php
      :linenos:

      SELECT * FROM atable WHERE intColumn = '123'



Le second paramètre optionnel de ``quote()`` permet de spécifier un type *SQL*.

.. _zend.db.adapter.quoting.quote.example-2:

.. rubric:: Utiliser quote() avec un type SQL

.. code-block:: php
   :linenos:

   $value = '1234';
   $sql = 'SELECT * FROM atable WHERE intColumn = '
        . $db->quote($value, 'INTEGER');

De plus, chaque classe Zend_Db_Adapter possèdent des constantes représentant les différents type *SQL* des SGBDs
respectifs qu'elles représentent. Ainsi, les constantes ``Zend_Db::INT_TYPE``, ``Zend_Db::BIGINT_TYPE``, et
``Zend_Db::FLOAT_TYPE`` peuvent vous permettre d'écrire un code portable entre différents SGBDs.

Zend_Db_Table fournit les types *SQL* à ``quote()`` automatiquement en fonction des colonnes utilisées par la
table référencée.

.. _zend.db.adapter.quoting.quote-into:

Utilisation de quoteInto()
^^^^^^^^^^^^^^^^^^^^^^^^^^

Une autre manière est d'échapper une expression *SQL* contenant une variable *PHP*. Vous pouvez utiliser
``quoteInto()`` pour cela. Cette méthode accepte trois arguments. Le premier est la chaîne représentant
l'expression *SQL* dont les paramètres variables sont remplacés par un joker(*?*), et le second argument est la
variable *PHP* à utiliser pour le remplacement du joker.

Le joker est le même symbole que celui utilisé par beaucoup de SGBDs pour la substitution de paramètre dans une
requête préparée. ``quoteInto()`` ne fait qu'émuler ce comportement : la méthode ne fait que remplacer le
joker par la valeur *PHP*, en lui appliquant la méthode *quote*. De vrais paramètres de requêtes préparées
conservent une réelle isolation entre la requête et ses paramètres.

.. _zend.db.adapter.quoting.quote-into.example:

.. rubric:: Utiliser quoteInto()

.. code-block:: php
   :linenos:

   $sql = $db->quoteInto("SELECT * FROM bugs WHERE reported_by = ?",
                         "O'Reilly");

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

Le troisième paramètre optionnel s'utilise comme avec la méthode *quote*. Il sert à spécifier un type *SQL*,
les types numériques ne sont pas délimités.

.. _zend.db.adapter.quoting.quote-into.example-2:

.. rubric:: Utiliser quoteInto() avec un type SQL

.. code-block:: php
   :linenos:

   $sql = $db->quoteInto("SELECT * FROM bugs WHERE bug_id = ?",
                         '1234',
                         'INTEGER');

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 1234

.. _zend.db.adapter.quoting.quote-identifier:

Utilisation de quoteIdentifier()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les valeurs ne sont pas les seuls données qui peuvent être dynamiques dans une requête *SQL*,et donc passées
par des variables *PHP*. Les noms des tables, des colonnes, ou tout autre identifiant *SQL* spécial de la requête
peuvent aussi être dynamiques. En général, les identifiant spéciaux d'une requête ont une syntaxe identique à
celle des variables *PHP*\  : pas d'espaces dans les noms, certains autres caractères interdits, la ponctuation
est interdite, etc... Aussi, les identifiants ne peuvent valoir certaines valeurs de mots réservés : une table
ne peut s'appeler "FROM". Il se peut donc que vous ayez besoin aussi d'échapper des paramètres voués à être
substitués à des identifiant dans la requête *SQL*, et non plus à des valeurs.

Le langage *SQL* possède une caractéristique appelée **identifiant délimités**. Si vous entourez un
identifiant *SQL* dans un type spécial de délimiteurs, alors vous pouvez écrire des requêtes qui auraient été
invalides autrement. Ainsi, vous pouvez inclure des espaces, de la ponctuation ou des caractères internationaux
dans vos identifiant, et aussi utiliser des mots réservés.

La méthode ``quoteIdentifier()`` fonctionne comme ``quote()``, mais elle utilise un caractère de délimitation
spécial, en fonction du SGBD sous-jacent. Par exemple, le standard *SQL* spécifie des doubles quotes (*"*) et
beaucoup de SGBDs utilisent ceci. MySQL utilise les apostrophes inverses (back-quotes) (*`*) par défaut. Les
caractères spéciaux sont aussi échappés.

.. _zend.db.adapter.quoting.quote-identifier.example:

.. rubric:: Utiliser quoteIdentifier()

.. code-block:: php
   :linenos:

   // nous possédons une table ayant un nom correspondant
   // à un mot reservé en SQL
   $tableName = $db->quoteIdentifier("order");

   $sql = "SELECT * FROM $tableName";

   echo $sql
   // SELECT * FROM "order"

Les identifiant *SQL* délimités sont sensibles à la casse. Vous devriez toujours utiliser la casse telle qu'elle
est utilisée dans votre base de données (nom des tables, des colonnes ...).

Dans les cas où le *SQL* est généré à l'intérieur des classes ``Zend_Db``, alors les identifiant *SQL* seront
automatiquement échappés. Vous pouvez changer ce comportement avec l'option
``Zend_Db::AUTO_QUOTE_IDENTIFIERS``.Spécifiez la lors de l'instanciation de l'adaptateur. Voyez :ref:`
<zend.db.adapter.connecting.parameters.example2>`.

.. _zend.db.adapter.transactions:

Gérer les transactions dans une base de données
-----------------------------------------------

Les bases de données définissent les transactions comme étant des unités logiques de travail qui peuvent êtres
validées ("commit") ou annulées ("rollback") en tant qu'une seule opération, même sur de multiples tables.
Toutes les requêtes aux bases de données sont considérées comme faisant partie d'une transaction, même si le
driver de base de données fait ceci implicitement. Ceci s'appelle le mode **auto-commit**, dans lequel le driver
de base de données créer une transaction pour chaque requête exécutée et la valide. Par défaut toutes les
classes ``Zend_Db_Adapter`` fonctionnent en mode auto-commit.

Vous pouvez manuellement spécifier lorsque vous voulez démarrer une transaction. Vous contrôler ainsi combien de
requêtes doivent y être exécutées, et valider ou annuler ce groupe de requêtes. Utilisez
``beginTransaction()`` pour démarrer une transaction. Toutes les requêtes suivantes seront alors exécutées dans
cette transaction avant que vous ne l'annuliez, ou validiez.

Pour terminer une transaction, utilisez les méthodes ``commit()`` ou ``rollBack()``. ``commit()`` validera et
appliquera les changements de la transaction au SGBD, ils deviendront alors visibles dans les autres transactions.

``rollBack()`` fait le contraire : elle annule les changements qu'ont générés les requêtes dans la
transaction. L'annulation n'a aucun effet sur les changements qui ont été opérés par d'autres transactions
parallèles.

Après qu'une transaction soit terminées, ``Zend_Db_Adapter`` retourne en mode auto-commit jusqu'à un nouvel
appel à ``beginTransaction()``.

.. _zend.db.adapter.transactions.example:

.. rubric:: Manipuler les transactions pour assurer l'intégrité de la logique

.. code-block:: php
   :linenos:

   // Démarre explicitement une transaction.
   $db->beginTransaction();

   try {
       // Essaye d'executer une ou plusieurs requêtes :
       $db->query(...);
       $db->query(...);
       $db->query(...);

       // Si toutes ont réussi, valide les changements en une seule passe.
       $db->commit();

   } catch (Exception $e) {
       // Si une des requête s'est mal déroulée, alors nous voulons
       // annuler les changements de toutes les requêtes faisant partie
       // de la transaction, même celles qui se sont bien déroulées.
       // Tous les changements sont annulés d'un seul coup.
       $db->rollBack();
       echo $e->getMessage();
   }

.. _zend.db.adapter.list-describe:

Lister et décrire les tables
----------------------------

La méthode ``listTables()`` retourne un tableau de chaînes décrivant les tables de la base de données courante.

La méthode ``describeTable()`` retourne un tableau associatif de métadonnées sur une table. Spécifiez en le nom
en paramètre. Le second paramètre est optionnel et définit la base de données à utiliser, comme par exemple si
aucune n'a été sélectionnée précédemment.

Les clés de ce tableau représentent les noms des colonnes, les valeurs sont un tableau avec les clés
suivantes :

.. _zend.db.adapter.list-describe.metadata:

.. table:: Champs de métadonnées retournés par describeTable()

   +----------------+---------+----------------------------------------------------------------+
   |clé             |type     |description                                                     |
   +================+=========+================================================================+
   |SCHEMA_NAME     |(chaîne) |Nom de la base de données dans laquelle la table existe.        |
   +----------------+---------+----------------------------------------------------------------+
   |TABLE_NAME      |(chaîne) |Nom de la table dans laquelle la colonne existe.                |
   +----------------+---------+----------------------------------------------------------------+
   |COLUMN_NAME     |(chaîne) |Nom de la colonne.                                              |
   +----------------+---------+----------------------------------------------------------------+
   |COLUMN_POSITION |(entier) |Position de la colonne dans la table.                           |
   +----------------+---------+----------------------------------------------------------------+
   |DATA_TYPE       |(chaîne) |Nom du type de données tel que renvoyé par le SGBD.             |
   +----------------+---------+----------------------------------------------------------------+
   |DEFAULT         |(chaîne) |Valeur par défaut de la colonne, si une existe.                 |
   +----------------+---------+----------------------------------------------------------------+
   |NULLABLE        |(booléen)|TRUE si la colonne accepte la valeur SQL 'NULL', FALSE sinon.   |
   +----------------+---------+----------------------------------------------------------------+
   |LENGTH          |(entier) |Longueur ou taille de la colonne telle que reportée par le SGBD.|
   +----------------+---------+----------------------------------------------------------------+
   |SCALE           |(entier) |Échelle du type SQLNUMERIC ou DECIMAL.                          |
   +----------------+---------+----------------------------------------------------------------+
   |PRECISION       |(entier) |Précision du type SQLNUMERIC ou DECIMAL.                        |
   +----------------+---------+----------------------------------------------------------------+
   |UNSIGNED        |(booléen)|TRUE si le type est un entier non signé, défini par UNSIGNED.   |
   +----------------+---------+----------------------------------------------------------------+
   |PRIMARY         |(booléen)|TRUE si la colonne fait partie d'une clé primaire.              |
   +----------------+---------+----------------------------------------------------------------+
   |PRIMARY_POSITION|(entier) |Position de la colonne dans la clé primaire.                    |
   +----------------+---------+----------------------------------------------------------------+
   |IDENTITY        |(booléen)|TRUE si la colonne utilise une valeur auto-générée.             |
   +----------------+---------+----------------------------------------------------------------+

.. note::

   **A quoi correspond le champs de métadonnées "IDENTITY" en fonction du SGBD ?**

   Le champs de métadonnées "IDENTITY" a été choisi en tant que terme idiomatique pour représenter une
   relation de substitution de clés. Ce champ est généralement connu par les valeurs suivantes :

   - ``IDENTITY``- DB2, MSSQL

   - ``AUTO_INCREMENT``- MySQL

   - ``SERIAL``- PostgreSQL

   - ``SEQUENCE``- Oracle

Si aucune table ne correspond à votre demande, alors ``describeTable()`` retourne un tableau vide.

.. _zend.db.adapter.closing:

Fermer une connexion
--------------------

Normalement, il n'est pas nécessaire de fermer explicitement sa connexion. *PHP* nettoie automatiquement les
ressources laissées ouvertes en fin de traitement. Les extensions des SGBDs ferment alors les connexions
respectives pour les ressources détruites par *PHP*.

Cependant, il se peut que vous trouviez utile de fermer la connexion manuellement. Vous pouvez alors utiliser la
méthode de l'adaptateur ``closeConnection()`` afin de fermer explicitement la connexion vers le SGBD.

A partir de la version 1.7.2, vous pouvez vérifier si vous êtes actuellement connecté au serveur SGBD grâce à
la méthode ``isConnected()``. Ceci correspond à une ressource de connexion qui a été initiée et qui n'est pas
close. Cette fonction ne permet pas actuellement de tester la fermeture de la connexion au niveau du SGBD par
exemple. Cette fonction est utilisée en interne pour fermer la connexion. Elle vous permet entre autres de fermer
plusieurs fois une connexion sans erreurs. C'était déjà le cas avant la version 1.7.2 pour les adaptateurs de
type *PDO* mais pas pour les autres.

.. _zend.db.adapter.closing.example:

.. rubric:: Fermer une connexion à un SGBD

.. code-block:: php
   :linenos:

   $db->closeConnection();

.. note::

   **Zend_Db supporte-t-il les connexions persistantes ?**

   Oui, la persistance est supportée grace à l'addition de l'option *persistent* quand il est à une valeur true
   dans la configuration (pas celle du driver) d'un adaptateur de ``Zend_Db``.

   .. _zend.db.adapter.connecting.persistence.example:

   .. rubric:: Utiliser l'option de persistance avec l'adaptateur Oracle

   .. code-block:: php
      :linenos:

      $db = Zend_Db::factory('Oracle', array(
          'host'       => '127.0.0.1',
          'username'   => 'webuser',
          'password'   => 'xxxxxxxx',
          'dbname'     => 'test',
          'persistent' => true
      ));

   Notez cependant qu'utiliser des connexions persistantes peut mener à un trop grand nombre de connexions en
   attente (idle), ce qui causera plus de problème que cela n'est sensé en résoudre.

   Les connexions aux bases de données possède un état. Dans cet état sont mémorisés des objets propres au
   SGBD. Par exemples des verrous, des variables utilisateur, des tables temporaires, des informations sur les
   requêtes récentes, les derniers enregistrements affectés, les dernières valeurs auto-générées, etc. Avec
   des connexions persistantes, il se peut que vous accédiez à des données ne faisant pas partie de votre
   session de travail avec le SGBD, ce qui peut s'avérer dangereux.

   Actuellement, seuls les adpatateurs Oracle, DB2 et *PDO* (si spécifiés par *PHP*) supportent la persistance
   avec Zend_Db.

.. _zend.db.adapter.other-statements:

Exécuter des requêtes sur le driver directement
-----------------------------------------------

Il peut y avoir des cas où vous souhaitez accéder directement à la connexion 'bas niveau', sous
``Zend_Db_Adapter``.

Par exemple, toute requête effectuée par ``Zend_Db`` est préparée, et exécutée. Cependant, certaines
caractéristiques des bases de données ne sont pas compatibles avec les requêtes préparées. Par exemple, des
requêtes du type CREATE ou ALTER ne peuvent pas être préparées sous MySQL. De même, les requêtes préparées
ne bénéficient pas du `cache de requêtes`_, avant MySQL 5.1.17.

La plupart des extensions *PHP* pour les bases de données proposent une méthode permettant d'envoyer une requête
directe, sans préparation. Par exemple, *PDO* propose pour ceci la méthode ``exec()``. Vous pouvez récupérer
l'objet de connexion "bas niveau" grâce à la méthode de l'adaptateur ``getConnection()``.

.. _zend.db.adapter.other-statements.example:

.. rubric:: Envoyer une requête directe dans un adaptateur PDO

.. code-block:: php
   :linenos:

   $result = $db->getConnection()->exec('DROP TABLE bugs');

De la même manière, vous pouvez accéder à toutes les propriétés ou méthodes de l'objet "bas niveau",
utilisé par ``Zend_Db``. Attention toutefois en utilisant ce procédé, vous risquez de rendre votre application
dépendante du SGBD qu'elle utilise, en manipulant des méthodes propres à l'extension utilisée.

Dans de futures versions de ``Zend_Db``, il sera possible d'ajouter des méthodes pour des fonctionnalités
communes aux extensions de bases de données de *PHP*. Ceci ne rompra pas la compatibilité.

.. _zend.db.adapter.server-version:

Récupérer la version du serveur SGBD
------------------------------------

A partir de la version 1.7.2, vous pouvez récupérer la version du serveur avec le style de syntaxe *PHP* ce qui
permet d'utiliser ``version_compare()``. Si cette information n'est pas disponible, vous recevrez un ``NULL``.

.. _zend.db.adapter.server-version.example:

.. rubric:: Vérifier la version du serveur avant de lancer une requête

.. code-block:: php
   :linenos:

   $version = $db->getServerVersion();
   if (!is_null($version)) {
       if (version_compare($version, '5.0.0', '>=')) {
           // faire quelquechose
       } else {
           // faire autre chose
       }
   } else {
       // impossible de lire la version du serveur
   }

.. _zend.db.adapter.adapter-notes:

Notes sur des adaptateur spécifiques
------------------------------------

Cette section liste des différences entre les adaptateurs, que vous devriez considérer.

.. _zend.db.adapter.adapter-notes.ibm-db2:

IBM DB2
^^^^^^^

- Passez le paramètre 'Db2' à la méthode ``factory()``.

- Cet adaptateur utilise l'extension *PHP* ibm_db2.

- IBM DB2 supporte les séquences et les clés auto-incrémentées. Les arguments de ``lastInsertId()`` sont donc
  optionnels. Si vous ne passez pas de paramètres, alors l'adaptateur retourne la dernière valeur de clé auto-
  incrémentée. Sinon, il retourne la dernière valeur de la séquence passée en paramètre, en se référant à
  la convention '**table**\ _ **colonne**\ _seq'.

.. _zend.db.adapter.adapter-notes.mysqli:

MySQLi
^^^^^^

- Passez le paramètre 'Mysqli' à la méthode ``factory()``.

- Cet adaptateur utilise l'extension *PHP* mysqli.

- MySQL ne supporte pas les séquences, donc ``lastInsertId()`` ignore tout paramètre qu'on lui passe. Elle
  retourne toujours la valeur de la dernière clé auto-incrémentée. ``lastSequenceId()``, elle, retourne
  toujours ``NULL``.

.. _zend.db.adapter.adapter-notes.oracle:

Oracle
^^^^^^

- Passez le paramètre 'Oracle' à la méthode ``factory()``.

- Cet adaptateur utilise l'extension *PHP* oci8.

- Oracle ne supporte pas les clé auto-incrémentées, donc vous devriez spécifier un paramètre de séquence à
  ``lastInsertId()`` ou ``lastSequenceId()``.

- L'extension Oracle ne supporte pas les paramètres positionnés (?). Vous devez utiliser des paramètres nommés
  (:name).

- Actuellement l'option ``Zend_Db::CASE_FOLDING`` n'est pas supportée par l'adaptateur Oracle. Pour l'utiliser,
  vous devez utiliser l'adaptateur basé sur *PDO* et OCI.

- Par défaut les champs LOB ("Large Objet Binaire") sont retournés sous la forme d'objets OCI-Lob. Vous pouvez
  les récupérer sous forme de chaînes pour toutes les requêtes en utilisant l'option de driver
  *'lob_as_string'* ou pour une requête en particulier en utilisant la méthode ``setLobAsString(boolean)`` de
  l'adaptateur ou de l'objet statement.

.. _zend.db.adapter.adapter-notes.sqlsrv:

Microsoft SQL Server
^^^^^^^^^^^^^^^^^^^^

- Specify this Adapter to the ``factory()`` method with the name 'Sqlsrv'.

- This Adapter uses the *PHP* extension sqlsrv

- Only Microsoft *SQL* Server 2005 or greater is supported.

- Microsoft *SQL* Server does not support sequences, so ``lastInsertId()`` ignores primary key argument and returns
  the last value generated for an auto-increment key if a table name is specified or a last insert query returned
  id. The ``lastSequenceId()`` method returns ``NULL``.

- ``Zend_Db_Adapter_Sqlsrv`` sets ``QUOTED_IDENTIFIER ON`` immediately after connecting to a *SQL* Server database.
  This makes the driver use the standard *SQL* identifier delimiter symbol (**"**) instead of the proprietary
  square-brackets syntax *SQL* Server uses for delimiting identifiers.

- You can specify ``driver_options`` as a key in the options array. The value can be a anything from here
  `http://msdn.microsoft.com/en-us/library/cc296161(SQL.90).aspx`_.

- You can use ``setTransactionIsolationLevel()`` to set isolation level for current connection. The value can be
  ``SQLSRV_TXN_READ_UNCOMMITTED``, ``SQLSRV_TXN_READ_COMMITTED``, ``SQLSRV_TXN_REPEATABLE_READ``,
  ``SQLSRV_TXN_SNAPSHOT`` or ``SQLSRV_TXN_SERIALIZABLE``.

- As of Zend Framework 1.9, the minimal supported build of the *PHP* *SQL* Server extension from Microsoft is
  1.0.1924.0. and the *MSSQL* Server Native Client version 9.00.3042.00.

.. _zend.db.adapter.adapter-notes.pdo-ibm:

PDO pour IBM DB2 et Informix Dynamic Server (IDS)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Passez le paramètre 'Pdo_Ibm' à la méthode ``factory()``.

- Cet adaptateur utilise les extensions *PHP* pdo et pdo_ibm.

- Vous devez possédez l'extension PDO_IBM en version 1.2.2 minimum. Si ce n'est pas le cas, vous devrez la mettre
  à jour via *PECL*.

.. _zend.db.adapter.adapter-notes.pdo-mssql:

PDO Microsoft SQL Server
^^^^^^^^^^^^^^^^^^^^^^^^

- Passez le paramètre 'Pdo_Mssql' à la méthode ``factory()``.

- Cet adaptateur utilise les extensions *PHP* pdo et pdo_dblib.

- Microsoft *SQL* Server ne supporte pas les séquences, ainsi ``lastInsertId()`` ignore les paramètres qu'on lui
  passe et retourne toujours la valeur de la dernière clé auto-incrémentée. ``lastSequenceId()`` retourne
  toujours ``NULL``.

- Si vous travaillez avec des chaînes Unicode avec un encodage autre que UCS-2 (comme UTF-8), vous devrez
  peut-être réaliser une conversion dans votre code d'application ou stocker les données dans un champs binaire.
  Reportez vous à la `base de connaissance Microsoft`_ pour plus d'informations.

- Zend_Db_Adapter_Pdo_Mssql met ``QUOTED_IDENTIFIER`` à ON dès que la connexion a été effectuée. Le driver
  utilise donc le délimiteur d'identifiant *SQL* *"* au lieu de son délimiteur habituel.

- Vous pouvez spécifier la clé *pdoType* dans le tableau d'options de construction de l'adaptateur. La valeur
  peut être "mssql" (défaut), "dblib", "freetds", ou "sybase". Cette option affecte la syntaxe du préfixe DSN
  que l'adaptateur utilisera. "freetds" et "sybase" impliquent un préfixe "sybase:", qui est utilisé par les
  librairies `FreeTDS`_.Voyez aussi `http://www.php.net/manual/en/ref.pdo-dblib.connection.php`_ pour plus
  d'informations sur les DSN pour ce driver.

.. _zend.db.adapter.adapter-notes.pdo-mysql:

PDO MySQL
^^^^^^^^^

- Passez le paramètre 'Pdo_Mysql' à la méthode ``factory()``.

- Cet adaptateur utilise les extensions *PHP* pdo et pdo_mysql.

- MySQL ne supporte pas les séquences, ainsi ``lastInsertId()`` ignore les paramètres qu'on lui passe et retourne
  toujours la valeur de la dernière clé auto-incrémentée. ``lastSequenceId()`` retourne toujours ``NULL``.

.. _zend.db.adapter.adapter-notes.pdo-oci:

PDO Oracle
^^^^^^^^^^

- Passez le paramètre 'Pdo_Oci' à la méthode ``factory()``.

- Cet adaptateur utilise les extensions *PHP* pdo et pdo_oci.

- Oracle ne supporte pas les clé auto-incrémentées, donc vous devriez spécifier un paramètre de séquence à
  ``lastInsertId()`` ou ``lastSequenceId()``.

.. _zend.db.adapter.adapter-notes.pdo-pgsql:

PDO PostgreSQL
^^^^^^^^^^^^^^

- Passez le paramètre 'PDO_Pgsql' à la méthode ``factory()``.

- Cet adaptateur utilise les extensions *PHP* pdo et pdo_pgsql.

- PostgreSQL supporte les séquences et les clés auto-incrémentées. Les arguments de ``lastInsertId()`` sont
  donc optionnels. Si vous ne passez pas de paramètres, alors l'adaptateur retourne la dernière valeur de clé
  auto- incrémentée. Sinon, il retourne la dernière valeur de la séquence passée en paramètre, en se
  référant à la convention '**table**\ _ **colonne**\ _seq'.

.. _zend.db.adapter.adapter-notes.pdo-sqlite:

PDO SQLite
^^^^^^^^^^

- Passez le paramètre 'PDO_Sqlite' à la méthode ``factory()``.

- Cet adaptateur utilise les extensions *PHP* pdo et pdo_sqlite.

- SQLite ne supporte pas les séquences, ainsi ``lastInsertId()`` ignore les paramètres qu'on lui passe et
  retourne toujours la valeur de la dernière clé auto-incrémentée. ``lastSequenceId()`` retourne toujours
  ``NULL``.

- Pour vous connecter à une base de données SQLite2, spécifiez le paramètre *'sqlite2'=>true* dans le tableau
  d'options passé à l'adaptateur, lors de la création de l'instance de Pdo_Sqlite Adapter.

- Pour vous connecter à une base de données SQLite en mémoire, spécifiez le paramètre
  *'dsnprefix'=>':memory:'* dans le tableau d'options passé à l'adaptateur, lors de la création de l'instance de
  Pdo_Sqlite Adapter.

- Les anciennes versions du driver SQLite pour *PHP* ne semblent pas supporter les commandes PRAGMA nécessaires
  pour s'assurer que les colonnes ayant un nom court soient utilisées dans les résultats. Si vous avez des
  problèmes, tels que vos enregistrements sont retournés avec une forme "nomtable.nomcolonne" lors de vos
  jointures, vous devriez alors mettre à jour votre version de *PHP*.

.. _zend.db.adapter.adapter-notes.firebird:

Firebird (Interbase)
^^^^^^^^^^^^^^^^^^^^

- Cet adaptateur utilise l'extension *PHP* php_interbase.

- Firebird (Interbase) ne supporte pas les clé auto-incrémentées, donc vous devez spécifier un paramètre de
  séquence à ``lastInsertId()`` ou ``lastSequenceId()``.

- Pour l'instant l'option ``Zend_Db::CASE_FOLDING`` n'est pas supportée par l'adaptateur Firebird (Interbase).
  Tout identificateur non échappé sera automatiquement retourné en majuscules.

- Le nom de l'adaptateur est ZendX_Db_Adapter_Firebird.

  Rappelez vous qu'il est nécessaire d'utiliser le paramètre 'adapterNamespace' avec la valeur ZendX_Db_Adapter.

  Nous recommandons de mettre à jour gds32.dll (ou l'équivalent linux) embarqué avec *PHP*, à la même version
  que celle du serveur. Pour Firebird l'équivalent à ``gds32.dll`` est ``fbclient.dll``.

  Par défaut tous les identifiants (nomde tables, de cahmps) sont retournés en majuscules.



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
.. _`cache de requêtes`: http://dev.mysql.com/doc/refman/5.1/en/query-cache-how.html
.. _`http://msdn.microsoft.com/en-us/library/cc296161(SQL.90).aspx`: http://msdn.microsoft.com/en-us/library/cc296161(SQL.90).aspx
.. _`base de connaissance Microsoft`: http://support.microsoft.com/kb/232580
.. _`FreeTDS`: http://www.freetds.org/
.. _`http://www.php.net/manual/en/ref.pdo-dblib.connection.php`: http://www.php.net/manual/en/ref.pdo-dblib.connection.php
