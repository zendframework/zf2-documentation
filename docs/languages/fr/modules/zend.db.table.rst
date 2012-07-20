.. _zend.db.table:

Zend_Db_Table
=============

.. _zend.db.table.introduction:

Introduction
------------

La classe ``Zend_Db_Table`` est une interface orientée objet vers les tables d'une base de données. Elle fournit
des méthodes pour la gestion de la plupart des opérations concernant une table. Bien entendu, vous pouvez
étendre la classe de base pour ajouter une logique personnalisée.

La solution que représente ``Zend_Db_Table`` est basée sur le motif de conception `Table Data Gateway`_. Cette
solution inclut aussi une classe implémentant le motif `Row Data Gateway`_.

.. _zend.db.table.defining:

Définir une classe de Table
---------------------------

Pour chaque table de la base de données envers laquelle vous souhaitez un accès, définissez une classe étendant
``Zend_Db_Table_Abstract``.

.. _zend.db.table.defining.table-schema:

Définir le nom de la table, et de la base de données
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Déclarez le nom de la table pour laquelle la classe va agir, en utilisant la propriété protégée ``$_name``.
C'est une chaîne, elle doit contenir le nom de la table tel qu'il apparaît dans la base de données.

.. _zend.db.table.defining.table-schema.example1:

.. rubric:: Déclarer une classe de Table avec un nom de table spécifique

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';
   }

Si vous ne spécifiez pas le nom de la table, le nom de la classe sera alors utilisé comme nom de table par
défaut.

.. _zend.db.table.defining.table-schema.example:

.. rubric:: Déclarer une classe de Table sans nom de table spécifique

.. code-block:: php
   :linenos:

   class bugs extends Zend_Db_Table_Abstract
   {
       // le nom de la table est ici supposé être le nom de la classe
   }

Vous pouvez aussi déclarer le nom de la base de données contenant la table, toujours au moyen d'une propriété
protégée de la classe : ``$_schema``, ou avec le nom de la base précédant le nom de la table dans la
propriété ``$_name``. Si vous choisissez de définir le nom de la base de données dans la propriété
``$_name``, alors ce choix sera prioritaire sur celui utilisant ``$_schema``.

.. _zend.db.table.defining.table-schema.example3:

.. rubric:: Déclarer une classe de Table avec un nom de base de données

.. code-block:: php
   :linenos:

   // Première alternative :
   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_schema = 'bug_db';
       protected $_name   = 'bugs';
   }

   // Seconde alternative :
   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bug_db.bugs';
   }

   // Si le nom de la base est spécifiée dans $_name ET $_schema,
   // alors c'est celui spécifié dans $_name qui prime :

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name   = 'bug_db.bugs';
       protected $_schema = 'ignored';
   }

Les noms de la base de données et de la table peuvent aussi être définis via le constructeur de la classe de
Table. Ils écrasent alors ceux éventuellement définis dans les propriétés de la classe (avec ``$_name`` et
``$_schema``).

.. _zend.db.table.defining.table-schema.example.constructor:

.. rubric:: Déclarer les noms de table et base de donnée à l'instanciation

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
   }

   // Première alternative :

   $tableBugs = new Bugs(array('name' => 'bugs', 'schema' => 'bug_db'));

   // Seconde alternative :

   $tableBugs = new Bugs(array('name' => 'bug_db.bugs'));

   // Si le nom de la base est spécifié dans name ET schema, alors c'est
   // celui spécifié dans name qui prime :

   $tableBugs = new Bugs(array('name' => 'bug_db.bugs',
                               'schema' => 'ignored'));

Si vous n'indiquez pas de base de données, c'est celle utilisée par l'adaptateur qui sera utilisée.

.. _zend.db.table.defining.primary-key:

Définir la clé primaire d'une table
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Toute table doit posséder une clé primaire. ``Zend_Db_Table`` ne fonctionne pas avec les tables sans clé
primaire. Vous pouvez les déclarer la(les) colonne servant de clé primaire grâce à la propriété protégée de
la classe ``$_primary``. Celle-ci peut être soit une chaîne, dans le cas d'une clé sur une colonne, ou un
tableau de chaînes pour une clé sur plusieurs colonnes (clé primaire composée).

.. _zend.db.table.defining.primary-key.example:

.. rubric:: Exemple de spécification de la clé primaire

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';
       protected $_primary = 'bug_id';
   }

Si vous ne spécifiez pas explicitement de clé primaire, alors ``Zend_Db_Table_Abstract`` va essayer de la trouver
lui-même en utilisant les informations renvoyées par ``describeTable()``.

.. note::

   Toute classe de table doit, par un moyen ou un autre, connaître la clé primaire de la table ciblée. Si la
   clé primaire ne peut être trouvée ( spécifiée dans la classe, ou découverte par ``describeTable()``),
   alors la table ne va pas pouvoir être utilisée avec ``Zend_Db_Table``.

.. _zend.db.table.defining.setup:

Redéfinir les méthodes de configuration de la classe de Table
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Lorsque vous créez votre instance de classe ``Zend_Db_Table``, le constructeur décompose le processus via
plusieurs méthodes permettant l'initialisation des métadonnées de la table. Chacune de ces étapes est
matérialisée par une méthode de la classe, surchargeable. N'oubliez cependant pas d'appeler la méthode parente
respective à la fin de votre traitement.

.. _zend.db.table.defining.setup.example:

.. rubric:: Exemple de redéfinition de la méthode \_setupTableName()

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected function _setupTableName()
       {
           $this->_name = 'bugs';
           parent::_setupTableName();
       }
   }

Les méthodes de configuration que vous pouvez redéfinir sont :

- ``_setupDatabaseAdapter()`` vérifie si un adaptateur a été passé à la classe, éventuellement en récupère
  un depuis le registre. En redéfinissant cette méthode, vous pouvez ajouter une source de recherche pour
  l'adaptateur.

- ``_setupTableName()`` donne le nom de la table par défaut comme étant le nom de la classe. En redéfinissant
  cette méthode, vous pouvez spécifier le nom de la table avant son intervention.

- ``_setupMetadata()`` définit le nom de la base de données si le nom de la table est de la forme "base.table";
  appelle ``describeTable()`` pour récupérer les méta-données; remplir le tableau ``$_cols`` avec les noms des
  colonnes reçus via ``describeTable()``. La redéfinition de cette méthode permet de spécifier soi-même les
  noms des colonnes de la table.

- ``_setupPrimaryKey()`` donne le nom de la clé primaire par défaut en cherchant dans ``describeTable()``;
  vérifie que la clé primaire fait bien partie du tableau ``$_cols``. En redéfinissant cette méthode, vous
  pouvez spécifier une clé primaire manuellement.

.. _zend.db.table.initialization:

Initialisation de la Table
^^^^^^^^^^^^^^^^^^^^^^^^^^

Si lors de la construction de l'objet représentant votre Table, vous avez besoin d'implémenter une logique
spécifique, vous devriez utiliser la méthode ``init()``, qui est appelée juste après le constructeur, donc une
fois la table correctement créée.

.. _zend.db.table.defining.init.usage.example:

.. rubric:: Exemple d'utilisation de la méthode init()

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_observer;

       public function init()
       {
           $this->_observer = new MyObserverClass();
       }
   }

.. _zend.db.table.constructing:

Créer une instance de la classe de Table
----------------------------------------

Avant d'utiliser votre classe de Table, il faut en créer une instance, via son constructeur. Celui-ci accepte un
tableau d'options. La plus importante d'entre elles est l'adaptateur de base de données, qui représente la
connexion au SGBD. Il y a trois façon de le spécifier :

.. _zend.db.table.constructing.adapter:

Spécifier l'adaptateur de base de données
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La première manière de spécifier l'objet d'adaptateur à la classe de Table, est de le passer dans le tableau
d'options, à l'index *"db"*.

.. _zend.db.table.constructing.adapter.example:

.. rubric:: Exemple de construction d'un objet Table avec l'objet adaptateur

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory('PDO_MYSQL', $options);

   $table = new Bugs(array('db' => $db));

.. _zend.db.table.constructing.default-adapter:

Spécifier un adaptateur par défaut
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La deuxième manière de donner un objet adaptateur à la classe de Table est de le déclarer comme étant l'objet
adaptateur par défaut pour toutes les classes de Table. Vous pouvez faire ceci en utilisant la méthode statique
``Zend_Db_Table_Abstract::setDefaultAdapter()``. Son argument est un objet de type ``Zend_Db_Adapter_Abstract``.

.. _zend.db.table.constructing.default-adapter.example:

.. rubric:: Exemple de construction d'un objet Table en utilisant l'adaptateur par défaut

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory('PDO_MYSQL', $options);
   Zend_Db_Table_Abstract::setDefaultAdapter($db);

   // Plus tard...

   $table = new Bugs();

Il peut être intéressant de créer son objet adaptateur de base de données en un lieu approprié, comme le
fichier d'amorçage ("bootstrap"), et ensuite de le spécifier comme adaptateur par défaut pour toutes les tables,
à travers toute l'application. Attention toutefois, ce procédé fixe un et un seul adaptateur, pour toutes les
classes de table (héritant de ``Zend_Db_Table_Abstract``).

.. _zend.db.table.constructing.registry:

Stocker l'objet adaptateur dans le registre
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La troisième manière de passer l'objet adaptateur de base de données à votre classe de Table, est de passer une
chaîne de caractères dans la clé *"db"* du tableau de configuration accepté par le constructeur. Cette chaîne
représente alors l'index auquel est stocké l'adaptateur, dans le registre statique.

.. _zend.db.table.constructing.registry.example:

.. rubric:: Exemple de construction de l'objet Table avec le registre

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory('PDO_MYSQL', $options);
   Zend_Registry::set('my_db', $db);

   // Plus tard...

   $table = new Bugs(array('db' => 'my_db'));

Cette option est très semblable à celle qui consiste à définir un adaptateur par défaut à toutes les classes.
Le registre est en revanche plus flexible, car vous pouvez y stocker plusieurs adaptateurs, correspondants à
plusieurs SGBD différents. Changer de SGBD pour ses classes de Table est alors aussi simple que de changer de
valeur de registre.

.. _zend.db.table.insert:

Insérer des enregistrement dans une table
-----------------------------------------

Vous pouvez utiliser votre objet de Table pour insérer des données dans la table sur laquelle l'objet se base.
Utilisez sa méthode ``insert()`` qui accepte un seul paramètre : c'est un tableau dont les clés sont les noms
des colonnes de la table, et les valeurs les valeurs souhaitées pour insertions.

.. _zend.db.table.insert.example:

.. rubric:: Exemple d'insertion de données dans la table

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $data = array(
       'created_on'      => '2007-03-22',
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

   $table->insert($data);

Par défaut les paramètres sont traités comme des valeurs littérales. Si vous souhaitez utiliser une expression
*SQL* à la place, manipulez un objet ``Zend_Db_Expr`` plutôt.

.. _zend.db.table.insert.example-expr:

.. rubric:: Exemple d'insertion d'expressions dans une table

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $data = array(
       'created_on'      => new Zend_Db_Expr('CURDATE()'),
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

Dans les exemples ci-dessus, il est supposé que la table possède une clé primaire auto-incrémentée. C'est le
comportement par défaut que gère ``Zend_Db_Table_Abstract``, mais il y a d'autres comportements valides, qui sont
détaillés ci-dessous.

.. _zend.db.table.insert.key-auto:

Utiliser une table avec une clé primaire auto-incrémentée
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Une clé primaire auto-incrémentée génère une valeur entière unique si vous omettez la colonne de la clé
primaire dans une requête *SQL* de type ``INSERT``.

Dans ``Zend_Db_Table_Abstract``, si vous définissez la variable protégée ``$_sequence`` à un booléen ``TRUE``
(défaut), alors la classe va supposer que la table qu'elle représente possède une clé primaire
auto-incrémentée.

.. _zend.db.table.insert.key-auto.example:

.. rubric:: Exemple de déclaration d'une clé primaire auto-incrémentée

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';

       // Ce comportement est celui par défaut, il est noté ici
       // uniquement pour l'exemple, mais non necéssaire
       protected $_sequence = true;
   }

MySQL, MSSQL, et SQLite sont des exemples de SGBD supportant les clé primaires auto-incrémentées.

PostgreSQL a une propriété ``SERIAL`` qui définit une séquence automatiquement, basée sur le nom de la table
et d'une colonne, et utilise cette séquence pour générer des valeurs de clés pour les nouveaux enregistrements.
IBM DB2 a une propriété ``IDENTITY`` qui fonctionne de la même manière. Si vous utilisez ces propriétés
d'automatisme, considérez votre classe de Table (``Zend_Db_Table``) comme si elle avait une clé primaire
auto-incrémentée. Déclarez ainsi ``$_sequence`` à ``TRUE``.

.. _zend.db.table.insert.key-sequence:

Utiliser une Table avec une séquence
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Une séquence est un objet de base de données qui génère des valeurs uniques pouvant être utilisées comme
clés primaires dans une ou plusieurs tables de la base de données.

Si vous définissez ``$_sequence`` avec une chaîne de caractères, ``Zend_Db_Table_Abstract`` va alors supposer
que cette chaîne représente le nom de l'objet de séquence. Elle sera donc utilisée pour générer une valeur
lors de requêtes ``INSERT`` le nécessitant.

.. _zend.db.table.insert.key-sequence.example:

.. rubric:: Exemple de déclaration d'une séquence dans une classe de Table

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';

       protected $_sequence = 'bug_sequence';
   }

Oracle, PostgreSQL, et IBM DB2 sont des SGBDs qui supportent les séquences.

PostgreSQL et IBM DB2 ont aussi des mécanismes définissant implicitement la séquence et les colonnes associées.
Si vous utilisez un de ces procédés, considérez votre classe de table comme ayant une clé primaire
auto-incrémentée. N'utilisez la chaîne de la séquence dans $_sequence que si vous voulez explicitement utiliser
cette séquence pour générer la valeur suivante de clé.

.. _zend.db.table.insert.key-natural:

Utiliser une classe de Table avec une clé naturelle
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Certaines tables ont des clé naturelles, c'est à dire que vous devez fournir vous même, manuellement, la valeur
de la clé concernée. Aucun mécanisme automatique (auto-incrémentation ou séquence) ne le fait pour vous.

Si vous utilisez ``$_sequence`` avec la valeur booléenne ``FALSE``, alors ``Zend_Db_Table_Abstract`` se comportera
comme si une clé naturelle est utilisée. Ainsi, lors de l'appel de la méthode ``insert()``, vous devrez
spécifier la valeur de la clé primaire vous même, autrement une ``Zend_Db_Table_Exception`` sera levée.

.. _zend.db.table.insert.key-natural.example:

.. rubric:: Exemple de déclaration d'une clé naturelle

.. code-block:: php
   :linenos:

   class BugStatus extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bug_status';

       protected $_sequence = false;
   }

.. note::

   Tous les SGBDs gère ce cas. Les tables d'intersection dans les relations de type "plusieurs à plusieurs" sont
   de bons exemples de clés naturelles, souvent composées d'autres clés étrangères.

.. _zend.db.table.update:

Mettre à jour des enregistrements dans une table
------------------------------------------------

Vous pouvez mettre à jour des enregistrements de votre table en utilisant la méthode *update* de votre classe de
Table. Elle accepte deux paramètres. Le premier est un tableau associatifs des colonnes concernées, et de leurs
valeurs respectives. Le deuxième est une expression *SQL* qui sera utiliser comme clause ``WHERE`` dans la
requête ``UPDATE``.

.. _zend.db.table.update.example:

.. rubric:: Exemple de mise à jour d'enregistrements dans une table

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $where = $table->getAdapter()->quoteInto('bug_id = ?', 1234);

   $table->update($data, $where);

La méthode de la classe de Table ``update()`` est proxiées vers la méthode :ref:`update()
<zend.db.adapter.write.update>` de l'adaptateur. Le deuxième paramètre peut donc être un tableau d'arguments
pour la clause WHERE. Chaque élément du tableau sera joint au suivant avec une opération ``AND``.

.. note::

   Les valeurs et les identifiants *SQL* ne sont pas échappés automatiquement. Si vous voulez échapper des
   valeurs, vous devrez utiliser ``quote()``, ``quoteInto()``, et ``quoteIdentifier()`` de l'adaptateur.

.. _zend.db.table.delete:

Supprimer des enregistrements d'une Table
-----------------------------------------

Pour effacer des enregistrements de votre table en utilisant sa classe de Table, utilisez sa méthode ``delete()``.
Son seul paramètre est une chaîne ou un tableau définissant la clause ``WHERE`` à utiliser lors de la requête
``DELETE``.

.. _zend.db.table.delete.example:

.. rubric:: Exemple de suppression d'enregistrements

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $where = $table->getAdapter()->quoteInto('bug_id = ?', 1235);

   $table->delete($where);

Cette méthode est proxiée vers :ref:`delete() <zend.db.adapter.write.delete>` de l'adaptateur. Si le paramètre
est un tableau, chacun des éléments du tableau sera joint au suivant avec l'opération ``AND`` pour former la
clause WHERE.

.. note::

   Les valeurs et les identifiants *SQL* ne sont pas échappés automatiquement. Si vous voulez échapper des
   valeurs, vous devrez utiliser ``quote()``, ``quoteInto()``, et ``quoteIdentifier()`` de l'adaptateur.

.. _zend.db.table.find:

Récupérer des enregistrements par clé primaire
----------------------------------------------

Vous pouvez interroger votre table afin de récupérer des enregistrements en spécifiant une ou plusieurs valeurs
de clé primaire. La méthode ``find()`` permet ceci, elle prend comme premier paramètre une valeur ou un tableau
de valeurs de clé primaire.

.. _zend.db.table.find.example:

.. rubric:: Exemple de récupération d'enregistrements par clé primaire

.. code-block:: php
   :linenos:

   $table = new Bugs();

   // Récupère un enregistrement, mais
   // retourne un Rowset
   $rows = $table->find(1234);

   // Récupère plusieurs enregistrement
   // retourne un Rowset
   $rows = $table->find(array(1234, 5678));

Si une seule clé est passée en paramètre, la méthode retournera au plus un résultat (car par définition, une
clé primaire assure l'unicité d'un enregistrement). Si vous passez plusieurs valeurs de clés, alors la méthode
pourra retourner plusieurs enregistrements. Cette méthode pourra aussi retourner zéro enregistrement. Quoiqu'il
en soit, l'objet de retour est bien un ``Zend_Db_Table_Rowset_Abstract``.

Si votre clé primaire est une clé composée de plusieurs colonnes, passez alors les autres valeurs de colonne
comme paramètres à la méthode ``find()``. Il doit y avoir autant de paramètres passés à la méthode, que de
colonnes composant la clé.

Ainsi, pour trouver plusieurs enregistrements en passant plusieurs valeurs de clés primaires composées, passez
autant de tableaux composés, que de colonnes représentant les clés. Les tableaux doivent donc, comporter le
même nombre de valeurs. Celles-ci vont ainsi fonctionner par tuples : tous les premiers éléments des tableaux
seront évalués pour la première recherche, et chacun représentera une colonne composant la clé primaire. Puis
ainsi de suite, jusqu'à la fin des tableaux.

.. _zend.db.table.find.example-compound:

.. rubric:: Exemple de recherche avec une clé primaire composée

L'exemple suivant appelle ``find()`` pour récupérer deux enregistrements en se basant sur une clé à deux
colonnes. Le premier enregistrement aura une clé primaire (1234, 'ABC'), et le second une valeur de clé primaire
(5678, 'DEF').

.. code-block:: php
   :linenos:

   class BugsProducts extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs_products';
       protected $_primary = array('bug_id', 'product_id');
   }

   $table = new BugsProducts();

   // Retourne un enregistrement unique, basé sur une clé
   // primaire à deux colonnes
   $rows = $table->find(1234, 'ABC');

   // Retourne deux enregistrements, basés sur une clé
   // primaire à deux colonnes
   $rows = $table->find(array(1234, 5678), array('ABC', 'DEF'));

.. _zend.db.table.fetch-all:

Requêter pour plusieurs enregistrements
---------------------------------------

.. _zend.db.table.fetch-all.select:

API de l'objet Select
^^^^^^^^^^^^^^^^^^^^^

.. warning::

   L'API pour les opérations de récupération d'enregistrements a été améliorée afin d'autoriser un objet
   ``Zend_Db_Table_Select`` à modifier la requête. Les anciens comportements de ``fetchRow()`` et ``fetchAll()``
   sont désormais dépréciés, mais toujours fonctionnels à ce jour.

   Les requêtes suivantes sont sémantiquement identiques et fonctionnent. Il est conseillé cependant d'utiliser
   l'implémentation avec l'objet select.



      .. code-block:: php
         :linenos:

         // Récupérer un rowset
         $rows = $table->fetchAll('bug_status = "NEW"', 'bug_id ASC', 10, 0);
         $rows = $table->fetchAll($table->select()->where('bug_status = ?', 'NEW')
                                                  ->order('bug_id ASC')
                                                  ->limit(10, 0));
         // ou avec liaison :
         $rows = $table->fetchAll(
             $table->select()
                 ->where('bug_status = :status')
                 ->bind(array(':status'=>'NEW')
                 ->order('bug_id ASC')
                 ->limit(10, 0)
             );

         // Récupérer un row
         $row = $table->fetchRow('bug_status = "NEW"', 'bug_id ASC');
         $row = $table->fetchRow($table->select()->where('bug_status = ?', 'NEW')
                                                 ->order('bug_id ASC'));
         // ou avec liaison :
         $row = $table->fetchRow(
             $table->select()
                 ->where('bug_status = :status')
                 ->bind(array(':status'=>'NEW')
                 ->order('bug_id ASC')
             );





L'objet ``Zend_Db_Table_Select`` est une extension de ``Zend_Db_Select`` mais qui applique des restrictions
particulières à la requête. Les restrictions sont :

- Vous **pouvez** utiliser l'objet pour ne sélectionner que certaines colonnes de l'enregistrement à retourner.
  Ceci est pratique dans le cas où vous n'avez pas besoin spécifiquement de toutes les colonnes d'une table.

- Vous **pouvez** spécifier des colonnes avec des évaluations envers des expressions *SQL*. Cependant,
  l'enregistrement résultant sera alors en mode lecture seule (``readOnly``) et ne pourra pas être propagé en
  base de données (``save()``). Un appel à ``save()`` lèvera une exception.

- Vous **pouvez** utiliser des jointures JOIN vers d'autres tables, mais uniquement pour des critères de jointure,
  et non sélectionner des colonnes jointes.

- Vous **ne pouvez pas** spécifier de colonnes JOINtes comme faisant partie du résultat de la requête. L'objet
  row/rowset serait alors corrompu, et contiendrait des données d'une table étrangère à sa table originale. Une
  erreur sera renvoyée dans un tel cas.





      .. _zend.db.table.qry.rows.set.simple.usage.example:

      .. rubric:: Utilisation simple

      .. code-block:: php
         :linenos:

         $table = new Bugs();

         $select = $table->select();
         $select->where('bug_status = ?', 'NEW');

         $rows = $table->fetchAll($select);



L'objet *Select* utilise une interface fluide (fluent interface), permettant le chaînage des méthodes.





      .. _zend.db.table.qry.rows.set.fluent.interface.example:

      .. rubric:: Exemple d'interface fluide

      .. code-block:: php
         :linenos:

         $table = new Bugs();

         $rows = $table->fetchAll($table->select()
                                        ->where('bug_status = ?', 'NEW'));



.. _zend.db.table.fetch-all.usage:

Récupérer un jeu d'enregistrements :
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Vous pouvez demander une requête qui retourne plusieurs enregistrements. La méthode ``fetchAll()`` de votre
classe de Table permet ceci. Elle retourne un objet de type ``Zend_Db_Table_Rowset_Abstract``, même si aucun
enregistrement ne correspond à la requête.

.. _zend.db.table.qry.rows.set.finding.row.example:

.. rubric:: Exemple de récupération d'enregistrements

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $select = $table->select()->where('bug_status = ?', 'NEW');

   $rows = $table->fetchAll($select);

Vous pouvez aussi définir les clauses *SQL* *ORDER BY* ou encore ``LIMIT`` (ou autre équivalent comme OFFSET).

.. _zend.db.table.fetch-all.example2:

.. rubric:: Exemple de récupération d'enregistrements avec des clauses SQL

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $order  = 'bug_id';

   // Retourne les enregistrements du 21ème au 30ème
   $count  = 10;
   $offset = 20;

   $select = $table->select()->where('bug_status = ?', 'NEW')
                             ->order($order)
                             ->limit($count, $offset);

   $rows = $table->fetchAll($select);

Tous les arguments de requêtes sont optionnels. Vous pouvez écrire une requête sans clause WHERE ni LIMIT ou
encore ORDER.

.. _zend.db.table.advanced.usage:

Utilisation avancée
^^^^^^^^^^^^^^^^^^^

Pour une utilisation plus avancée, vous pourriez vouloir spécifier une à une les colonnes que les
enregistrements trouvés doivent comporter. Ceci se fait au moyen de la clause FROM de l'objet select. Le premier
paramètre dans la clause FROM est le même que celui d'un objet Zend_Db_Select, cependant l'objet
Zend_Db_Table_Select admet une instance de Zend_Db_Table_Abstract pour définir le nom de la table.





      .. _zend.db.table.qry.rows.set.retrieving.a.example:

      .. rubric:: Récupérer des colonnes spécifiques sur les enregistrements

      .. code-block:: php
         :linenos:

         $table = new Bugs();

         $select = $table->select();
         $select->from($table, array('bug_id', 'bug_description'))
                ->where('bug_status = ?', 'NEW');

         $rows = $table->fetchAll($select);



.. important::

   Le jeu de résultats retourné est tout de même valide. Il ne possède en revanche que certaines colonnes de la
   table. La méthode ``save()`` est appelable, mais elle ne mettre à jour que ces colonnes.

Il est aussi possible de spécifier des expressions dans une clause FROM, et donc récupérer un objet row/rowset en lecture seule. Dans l'exemple ci-après, nous retournons un enregistrement de la table "bugs" qui représente un agrégat du nombre de nouveaux bugs reportés. Regardez la clause GROUP. L'alias SQL "count" sera accessible dans le row/rowset résultant, comme si il faisait parti de la table en tant que colonne.





      .. _zend.db.table.qry.rows.set.retrieving.b.example:

      .. rubric:: Récupérer des enregistrements avec des requêtes incluant des expressions

      .. code-block:: php
         :linenos:

         $table = new Bugs();

         $select = $table->select();
         $select->from($table,
                       array('COUNT(reported_by) as `count`', 'reported_by'))
                ->where('bug_status = ?', 'NEW')
                ->group('reported_by');

         $rows = $table->fetchAll($select);

Vous pouvez aussi utiliser une table de jointure comme partie de votre requête. Dans l'exemple ci-dessous, nous
utilisons la table "accounts" comme partie de la recherche, pour tous les bugs reportés par "Bob".





      .. _zend.db.table.qry.rows.set.refine.example:

      .. rubric:: Utiliser une table intermédiaire par jointure avec ``fetchAll()``

      .. code-block:: php
         :linenos:

         $table = new Bugs();

         // Récupération avec la partie from déjà spécifié, important lors des jointures
         $select = $table->select(Zend_Db_Table::SELECT_WITH_FROM_PART);
         $select->setIntegrityCheck(false)
                ->where('bug_status = ?', 'NEW')
                ->join('accounts', 'accounts.account_name = bugs.reported_by')
                ->where('accounts.account_name = ?', 'Bob');

         $rows = $table->fetchAll($select);



L'objet ``Zend_Db_Table_Select`` est destiné à sélectionner des données sur une table précise. Des jointures
peuvent être faites, mais il n'est pas possible de sélectionner des colonnes ne faisant pas partie de la table
sous-jacente. Cependant, ceci aurait pu être utile dans certains cas, et l'objet ``Zend_Db_Table_Select`` possède
une clause spéciale déverrouillant cette limitation. Passez la valeur ``FALSE`` à sa méthode
*setIntegrityCheck*. Il est alors possible de sélectionner des colonnes hors table. Attention toutefois, l'objet
row/rowset résultant sera verrouillé. Impossible d'y appeler ``save()``, ``delete()`` ou même d'affecter une
valeur à certains de ses champs. Une exception sera systématiquement levée.

.. _zend.db.table.qry.rows.set.integrity.example:

.. rubric:: Déverrouiller un objet Zend_Db_Table_Select pour récupérer des colonnes JOINtes

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $select = $table->select(Zend_Db_Table::SELECT_WITH_FROM_PART)
                   ->setIntegrityCheck(false);
   $select->where('bug_status = ?', 'NEW')
          ->join('accounts',
                 'accounts.account_name = bugs.reported_by',
                 'account_name')
          ->where('accounts.account_name = ?', 'Bob');

   $rows = $table->fetchAll($select);

.. _zend.db.table.fetch-row:

Récupérer un seul enregistrement
--------------------------------

Vous pouvez demander à ne récupérer qu'un seul résultat, en requêtant de manière similaire à la méthode
``fetchAll()``.

.. _zend.db.table.fetch-row.example1:

.. rubric:: Exemple de récupération d'un seul enregistrement

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $select  = $table->select()->where('bug_status = ?', 'NEW')
                              ->order('bug_id');

   $row = $table->fetchRow($select);

Cette méthode retourne un objet de type Zend_Db_Table_Row_Abstract. Si la requête ne trouve aucun enregistrement,
alors ``fetchRow()`` retournera ``NULL``.

.. _zend.db.table.info:

Récupérer les méta données d'une Table
--------------------------------------

La classe Zend_Db_Table_Abstract propose des informations concernant ses méta données.La méthode ``info()``
retourne un tableau d'informations sur les colonnes, la clé primaire, etc. de la table.

.. _zend.db.table.info.example:

.. rubric:: Exemple de récupération du nom de la table

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $info = $table->info();

   echo "The table name is " . $info['name'] . "\n";

Les clés du tableau retourné par ``info()`` sont les suivantes :

- **name**\  => nom de la table.

- **cols**\  => un tableau contenant les colonnes de la table.

- **primary**\  => un tableau contenant la(les) colonnes utilisée(s) pour définir la clé primaire de la table.

- **metadata**\  => un tableau associatif, associant les noms des colonnes de la tables, à leurs informations
  intrinsèques. Les données sont les mêmes que celles retournée par ``describeTable()``.

- **rowClass**\  => le nom de la classe concrète servant les objets représentants les enregistrements de la
  table. Par défaut : Zend_Db_Table_Row.

- **rowsetClass**\  => le nom de la classe concrète servant de conteneur d'objets représentants les
  enregistrements de la table. Par défaut : Zend_Db_Table_Rowset.

- **referenceMap**\  => un tableau associatif. Il représente les références de cette table vers ses parents
  éventuelles. Voyez :ref:` <zend.db.table.relationships.defining>`.

- **dependentTables**\  => un tableau de noms de classes de tables qui référencent cette table. Voyez :ref:`
  <zend.db.table.relationships.defining>`.

- **schema**\  => Le nom de la base de données comportant cette table.

.. _zend.db.table.metadata.caching:

Cacher les méta données de la table
-----------------------------------

Par défaut, ``Zend_Db_Table_Abstract`` demande à la base de données les :ref:`méta données de table
<zend.db.table.info>`, à chaque instanciation d'objet de table. L'objet de table analyse les métadonnées de la
table dans le SGDB en utilisant la méthode ``describeTable()`` de l'adaptateur. Les opérations nécessitant cette
introspection incluent :

- ``insert()``

- ``find()``

- ``info()``

Cependant, il peut être dégradant pour les performances du SGBD de lui demander ces informations à chaque
instanciation de chaque objet de chaque table. Ainsi, un système de cache pour les méta données a été mis en
place.

La mise en cache des méta données des tables peut être contrôlée de deux manières :

   - **Un appel à la méthode statique Zend_Db_Table_Abstract::setDefaultMetadataCache()**- Ceci permet
     d'enregistrer une fois pour toutes l'objet de cache que toutes les tables devront utiliser.

   - **L'appel au constructeur Zend_Db_Table_Abstract::__construct()**- Il va permettre de spécifier l'objet de
     cache pour une table en particulier.

Dans tous les cas, vous devrez passer soit ``NULL`` (et ainsi désactiver le cache des méta données des tables),
soit une instance de :ref:`Zend_Cache_Core <zend.cache.frontends.core>`. Il est possible d'utiliser à la fois
*setDefaultMetadataCache* et le constructeur afin d'avoir un objet de cache par défaut, puis un spécifique pour
certaines classes.

.. _zend.db.table.metadata.caching-default:

.. rubric:: Utiliser un objet de cache de méta données pour toutes les classes

L'exemple qui suit illustre la manière de passer un objet de cache de méta données général, pour toutes les
classes de table :

.. code-block:: php
   :linenos:

   // D'abord, configurons le cache
   $frontendOptions = array(
       'automatic_serialization' => true
       );

   $backendOptions  = array(
       'cache_dir'                => 'cacheDir'
       );

   $cache = Zend_Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   // Puis passons le comme objet de cache par défaut
   Zend_Db_Table_Abstract::setDefaultMetadataCache($cache);

   // Testons avec une classe
   class Bugs extends Zend_Db_Table_Abstract
   {
       // ...
   }

   // Chaque instance utilise l'objet par défaut
   $bugs = new Bugs();

.. _zend.db.table.metadata.caching-instance:

.. rubric:: Utiliser un objet de cache de métadonnées pour une instance précise

L'exemple qui suit illustre la manière de passer un objet de cache de méta données spécifique, pour une
instance précise :

.. code-block:: php
   :linenos:

   // D'abord, configurons le cache
   $frontendOptions = array(
       'automatic_serialization' => true
       );

   $backendOptions  = array(
       'cache_dir'                => 'cacheDir'
       );

   $cache = Zend_Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   // Testons avec une classe
   class Bugs extends Zend_Db_Table_Abstract
   {
       // ...
   }

   // Lors de son instanciation, il est possible
   // de lui passer l'objet de cache
   $bugs = new Bugs(array('metadataCache' => $cache));

.. note::

   **Sérialisation automatique avec Cache Frontend**

   Étant donné que les informations retournées par ``describeTable()`` le sont sous forme de tableau, assurez
   vous que le paramètre *automatic_serialization* est à ``TRUE`` pour l'objet de la classe ``Zend_Cache_Core``.

Dans nos exemples, nous utilisons ``Zend_Cache_Backend_File``, mais vous pouvez utiliser le backend que vous
souhaitez, voyez :ref:`Zend_Cache <zend.cache>` pour plus d'informations.

.. _zend.db.table.metadata.caching.hardcoding:

Coder en dur les métadonnées de tables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Pour cacher les métadonnées une étape plus avant, vous pouvez aussi choisir de coder en dur ces métadonnées.
Dans ce cas particulier, cependant, tout changement au schéma de la table requerra un changement dans votre code.
Ainsi, il est seulement recommandé pour ceux qui sont dans la phase d'optimisation pour un usage en production.

La structure des métadonnées est comme ceci :

.. code-block:: php
   :linenos:

   protected $_metadata = array(
       '<column_name>' => array(
           'SCHEMA_NAME'      => <string>,
           'TABLE_NAME'       => <string>,
           'COLUMN_NAME'      => <string>,
           'COLUMN_POSITION'  => <int>,
           'DATA_TYPE'        => <string>,
           'DEFAULT'          => NULL|<value>,
           'NULLABLE'         => <bool>,
           'LENGTH'           => <string - length>,
           'SCALE'            => NULL|<value>,
           'PRECISION'        => NULL|<value>,
           'UNSIGNED'         => NULL|<bool>,
           'PRIMARY'          => <bool>,
           'PRIMARY_POSITION' => <int>,
           'IDENTITY'         => <bool>,
       ),
       // additional columns...
   );

Une manière simple de récupérer les valeurs appropriées est d'activer le cache des métadonnées et d'utiliser
celles présentes dans votre cache.

Vous pouvez désactiver cette optimisation en mettant à ``FALSE`` le paramètre *metadataCacheInClass*\  :

.. code-block:: php
   :linenos:

   // Lors de l'instanciation :
   $bugs = new Bugs(array('metadataCacheInClass' => false));

   // Ou plus tard :
   $bugs->setMetadataCacheInClass(false);

Ce paramètre est activé par défaut, ce qui assure que le tableau ``$_metadata`` n'est chargé qu'une seule fois
par instance

.. _zend.db.table.extending:

Personnaliser et étendre une classe de Table
--------------------------------------------

.. _zend.db.table.extending.row-rowset:

Utiliser des objets Row ou Rowset personnalisés
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Par défaut, les méthodes de la classe de Table retourne des jeux d'enregistrements comme étant des instances de
la classe ``Zend_Db_Table_Rowset``, ces "Rowsets" contiennent des enregistrements de la table, représentés par
des objets instances de ``Zend_Db_Table_Row``. Vous pouvez spécifier vos propres classes pour row/rowset, mais
elles doivent étendre ``Zend_Db_Table_Rowset_Abstract`` ou ``Zend_Db_Table_Row_Abstract``, respectivement.

Vous pouvez spécifier vos classes row/rowset en utilisant le constructeur de la classe de Table, via le tableau
d'options, aux clés *"rowClass"* et *"rowsetClass"*. Indiquez les noms des classes sous forme de chaînes de
caractères.

.. _zend.db.table.extending.row-rowset.example:

.. rubric:: Exemple de spécification de ses propres classes Row et Rowset

.. code-block:: php
   :linenos:

   class My_Row extends Zend_Db_Table_Row_Abstract
   {
       ...
   }

   class My_Rowset extends Zend_Db_Table_Rowset_Abstract
   {
       ...
   }

   $table = new Bugs(
       array(
           'rowClass'    => 'My_Row',
           'rowsetClass' => 'My_Rowset'
       )
   );

   $where = $table->getAdapter()->quoteInto('bug_status = ?', 'NEW')

   // Retourne un objet de type My_Rowset,
   // contenant des objets de type My_Row.
   $rows = $table->fetchAll($where);

Vous pouvez aussi utiliser les méthodes ``setRowClass()`` et ``setRowsetClass()``. Ceci s'applique alors de
manière ponctuelle, et non plus globale pour toute la classe de Table en tout point.

.. _zend.db.table.extending.row-rowset.example2:

.. rubric:: Exemple de changement ponctuel des classes de Row et Rowset

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $where = $table->getAdapter()->quoteInto('bug_status = ?', 'NEW')

   // Retourne un objet de type Zend_Db_Table_Rowset
   // contenant des objets de type Zend_Db_Table_Row.
   $rowsStandard = $table->fetchAll($where);

   $table->setRowClass('My_Row');
   $table->setRowsetClass('My_Rowset');

   // Retourne un objet de type My_Rowset,
   // contenant des objets de type My_Row.
   $rowsCustom = $table->fetchAll($where);

   // L'objet $rowsStandard existe toujours et n'a pas changé d'état.

Pour des informations détaillées concernant les classes Row et Rowset, voyez :ref:` <zend.db.table.row>` et
:ref:` <zend.db.table.rowset>`.

.. _zend.db.table.extending.insert-update:

Personnaliser les logiques Insert, Update, et Delete
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Vous pouvez redéfinir les méthodes ``insert()`` et ``update()`` afin d'y ajouter votre propre logique. Assurez
vous d'appeler les méthodes parentes une fois votre code écrit.

.. _zend.db.table.extending.insert-update.example:

.. rubric:: Exemple d'implémentation d'une logique personnalisée gérant des timestamps

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';

       public function insert(array $data)
       {
           // Ajout d'un timestamp
           if (empty($data['created_on'])) {
               $data['created_on'] = time();
           }
           return parent::insert($data);
       }

       public function update(array $data, $where)
       {
           // Ajout d'un timestamp
           if (empty($data['updated_on'])) {
               $data['updated_on'] = time();
           }
           return parent::update($data, $where);
       }
   }

Il est aussi possible de redéfinir la méthode ``delete()``.

.. _zend.db.table.extending.finders:

Définir des méthodes de recherches personnalisées dans Zend_Db_Table
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Bien que ``fetchAll()`` fonctionne très bien, si vous avez plusieurs appels similaires à cette méthode (ou une
autre), il peut être intéressant de factoriser du code en créant votre propre méthode de récupération
d'enregistrements, utilisant ``fetchAll()`` ou une autre méthode.

.. _zend.db.table.extending.finders.example:

.. rubric:: Méthode personnalisée de récupération d'enregistrements "bugs" par critère "status"

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';

       public function findByStatus($status)
       {
           $where = $this->getAdapter()->quoteInto('bug_status = ?',
                                                   $status);
           return $this->fetchAll($where, 'bug_id');
       }
   }

.. _zend.db.table.extending.inflection:

Utiliser l'inflexion dans Zend_Db_Table
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

L'**inflexion** est un processus de transformations de caractères. Par défaut, si vous ne définissez pas de nom
à votre table via la propriété protégée ``$_name``, ``Zend_Db_Table_Abstract`` va utiliser le nom de la classe
comme nom de table, sans effectuer aucune transformation.

Certaines personnes peuvent vouloir utiliser un mécanisme d'inflexion pour transformer le nom de la classe d'une
manière bien spécifique, afin de retrouver le nom de la table.

Par exemple, une classe nommée "*BugsProducts*", peut vouloir refléter une table s'appelant "*bugs_products*,"
sans utiliser la propriété de classe ``$_name``. Dans cette règle d'inflexion, les mots composant le nom de la
classe sont écrits en "CamelCase", et seraient transformés en mots en minuscules, et séparés par des tirets
bas.

Vous pouvez aussi spécifier le nom de la table indépendamment du nom de la classe. Utilisez pour cela la
propriété ``$_name`` de la classe de Table.

Si vous voulez utiliser l'inflexion, vous devrez créer une classe (abstraite) étendant
``Zend_Db_Table_Abstract``, et redéfinissant sa méthode protégée ``_setupTableName()``. Toutes les classes de
Table devront alors hériter de cette nouvelle classe abstraite.

.. _zend.db.table.extending.inflection.example:

.. rubric:: Exemple d'une classe abstraite utilisant l'inflexion

.. code-block:: php
   :linenos:

   abstract class MyAbstractTable extends Zend_Db_Table_Abstract
   {
       protected function _setupTableName()
       {
           if (!$this->_name) {
               $this->_name = myCustomInflector(get_class($this));
           }
           parent::_setupTableName();
       }
   }

   class BugsProducts extends MyAbstractTable
   {
   }

C'est à vous d'écrire les fonctions qui vont établir le mécanisme d'inflexion.



.. _`Table Data Gateway`: http://www.martinfowler.com/eaaCatalog/tableDataGateway.html
.. _`Row Data Gateway`: http://www.martinfowler.com/eaaCatalog/rowDataGateway.html
