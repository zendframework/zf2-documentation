.. _zend.db.table.row:

Zend_Db_Table_Row
=================

.. _zend.db.table.row.introduction:

Introduction
------------

``Zend_Db_Table_Row`` est la classe qui donne accès à chacun des résultats issus d'un objet ``Zend_Db_Table``.
Lorsque vous exécutez une requête via une classe de Table, alors les résultats sont des objets
``Zend_Db_Table_Row``. Vous pouvez aussi utiliser ces objets comme résultats vides : pour créer des nouveaux
résultats à ajouter à la base de données.

``Zend_Db_Table_Row`` est une implémentation du design pattern `Row Data Gateway`_

.. _zend.db.table.row.read:

Récupérer un résultat (un "Row")
--------------------------------

``Zend_Db_Table_Abstract`` possède des méthodes ``find()`` et ``fetchAll()``, qui retournent un objet de type
``Zend_Db_Table_Rowset``, et une méthode ``fetchRow()``, qui retourne un objet de type ``Zend_Db_Table_Row``.

.. _zend.db.table.row.read.example:

.. rubric:: Exemple de récupération d'un Row

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()
                               ->where('bug_id = ?', 1));

Un objet ``Zend_Db_Table_Rowset`` contient une collection d'objets ``Zend_Db_Table_Row``. Voyez :ref:`
<zend.db.table.rowset>`.

.. _zend.db.table.row.read.example-rowset:

.. rubric:: Exemple de lecture d'un Row dans un Rowset

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $rowset = $bugs->fetchAll($bugs->select()
                                  ->where('bug_status = ?', 1));
   $row = $rowset->current();

.. _zend.db.table.row.read.get:

Lecture des valeurs des colonnes, dans un Row
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Db_Table_Row_Abstract`` possède des accesseurs. Les colonnes *SQL* du résultat sont disponibles en lecture
et écriture, via des propriétés de classe.

.. _zend.db.table.row.read.get.example:

.. rubric:: Lecture d'une colonne dans un Row

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()
                               ->where('bug_id = ?', 1));

   // Affiche la valeur de la colonne bug_description
   echo $row->bug_description;

.. note::

   Les versions antérieures de ``Zend_Db_Table_Row`` utilisaient un processus de transformation nommé
   **inflexion** pour récupérer les valeurs des colonnes dans un résultat.

   Actuellement, ``Zend_Db_Table_Row`` n'utilise pas d'inflexion. Les noms des propriétés de l'objet doivent
   correspondre à l'orthographe des noms des colonnes dans la base de données sous-jacente

.. _zend.db.table.row.read.to-array:

Récupérer les valeurs des colonnes comme un tableau
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Vous pouvez accéder aux données d'un row sous forme de tableau grâce à la méthode ``toArray()``. Celle-ci
retourne un tableau associatif.

.. _zend.db.table.row.read.to-array.example:

.. rubric:: Exemple avec toArray()

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()
                               ->where('bug_id = ?', 1));

   // Récupère un tableau associatif column/value
   $rowArray = $row->toArray();

   // Utilisation comme un tableau normal
   foreach ($rowArray as $column => $value) {
       echo "Column: $column\n";
       echo "Value:  $value\n";
   }

Le tableau retourné par ``toArray()`` n'est pas une référence. Vous pouvez modifier ses valeurs, cela n'aura
aucune répercussion dans la base de données.

.. _zend.db.table.row.read.relationships:

Récupérer des données des tables liées
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Db_Table_Row_Abstract`` possède des méthodes permettant de récupérer des données des tables liées à
la table interrogée. Voyez :ref:` <zend.db.table.relationships>` pour plus d'informations sur les relations entre
les tables.

.. _zend.db.table.row.write:

Sauvegarde un Row en base de données
------------------------------------

.. _zend.db.table.row.write.set:

Changement des valeurs des colonnes d'un Row
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Vous pouvez changer les valeurs de chaque colonne du résultat Row, simplement avec les accesseurs, comme en
lecture. Effectuez une banale affectation.

Utiliser l'accesseur pour spécifier une valeur à une colonne d'un résultat Row ne répercute pas le comportement
immédiatement en base de données. Vous devez utiliser explicitement la méthode ``save()`` pour ceci.

.. _zend.db.table.row.write.set.example:

.. rubric:: Exemple de changement de la valeur d'une colonne dans un Row

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()
                               ->where('bug_id = ?', 1));

   // Change la valeur d'une ou plusieurs colonnes
   $row->bug_status = 'FIXED';

   // MET A JOUR l'enregistrement dans la base de données
   $row->save();

.. _zend.db.table.row.write.insert:

Créer un Row vierge
^^^^^^^^^^^^^^^^^^^

Vous pouvez créer un nouvel enregistrement vierge (Row) pour une table avec la méthode ``createRow()`` issue de
la classe de cette Table. Vous pouvez alors affecter des valeurs à ses colonnes grâce aux accesseurs, comme
déjà vu, puis enregistrer le Row en base de données avec sa méthode ``save()``.

.. _zend.db.table.row.write.insert.example:

.. rubric:: Exemple de création d'un Row vierge pour une table

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $newRow = $bugs->createRow();

   // affecte des valeurs aux colonnes
   $newRow->bug_description = '...description...';
   $newRow->bug_status = 'NEW';

   // INSERT le nouvel enregistrement dans la base de données
   $newRow->save();

L'argument optionnel de ``createRow()`` est un tableau associatif qui sert à peupler tout de suite l'objet de
valeurs.

.. _zend.db.table.row.write.insert.example2:

.. rubric:: Exemple de remplissage des valeurs d'un nouveau Row vierge

.. code-block:: php
   :linenos:

   $data = array(
       'bug_description' => '...description...',
       'bug_status'      => 'NEW'
   );

   $bugs = new Bugs();
   $newRow = $bugs->createRow($data);

   // INSERT l'enregistrement en base de données
   $newRow->save();

.. note::

   La méthode ``createRow()`` était nommée ``fetchNew()`` dans les anciennes version de ``Zend_Db_Table``. Il
   est recommandé de ne plus utiliser cette ancienne appellation, même si celle-ci fonctionne toujours
   actuellement.

.. _zend.db.table.row.write.set-from-array:

Changement en masse des valeurs dans un Row
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Db_Table_Row_Abstract`` possède une méthode ``setFromArray()`` qui permet de lui peupler ses valeurs avec
celles issues d'un tableau associatif nom de la colonne / valeur.

.. _zend.db.table.row.write.set-from-array.example:

.. rubric:: Exemple d'utilisation de setFromArray() avec un enregistrement (Row) vierge

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $newRow = $bugs->createRow();

   // Les données sont dans un tableau associatif
   $data = array(
       'bug_description' => '...description...',
       'bug_status'      => 'NEW'
   );

   // Affecte toutes les valeurs des colonnes en une seule fois
   $newRow->setFromArray($data);

   // INSERT l'enregistrement en base de données
   $newRow->save();

.. _zend.db.table.row.write.delete:

Supprimer un Row
^^^^^^^^^^^^^^^^

Vous pouvez appeler la méthode ``delete()`` d'un objet Row. Ceci supprime les lignes dans la base de données qui
correspondent à la clé primaire de l'objet Row.

.. _zend.db.table.row.write.delete.example:

.. rubric:: Effacer un Row

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow('bug_id = 1');

   // EFFACE cet enregistrement de la base de données
   $row->delete();

Notez qu'il n'est pas nécessaire d'appeler ``save()`` pour un effacement. Celui-ci est à effet immédiat.

.. _zend.db.table.row.serialize:

Sérialisation et désérialisation d'un Row
-----------------------------------------

Il peut être utile de sauvegarder le contenu d'un enregistrement (Row) sur un support quelconque, pour une
utilisation ultérieure. La **sérialisation** est le nom de l'opération qui consiste à transformer un objet en
une forme facilement stockable (dans un fichier par exemple). Les objets du type ``Zend_Db_Table_Row_Abstract``
sont sérialisables.

.. _zend.db.table.row.serialize.serializing:

Sérialiser un Row
^^^^^^^^^^^^^^^^^

Utilisez simplement la fonction *PHP* ``serialize()`` pour créer une chaîne de caractères représentant votre
objet Row.

.. _zend.db.table.row.serialize.serializing.example:

.. rubric:: Exemple de sérialisation d'un Row

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow('bug_id = 1');

   // Convertit l'objet en une forme sérialisée
   $serializedRow = serialize($row);

   // Maintenant vous pouvez utiliser $serializedRow
   // pour l'écrire dans un fichier, etc.

.. _zend.db.table.row.serialize.unserializing:

Désérialiser les données d'un Row
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Utilisez simplement la fonction *PHP* ``unserialize()``. L'objet Row originel est alors recréé.

Notez que l'objet retourné fonctionne alors en mode **déconnecté**. Vous pouvez lire les valeurs des colonnes,
mais pas les modifier ni enregistrer l'objet en base de données (``save()``).

.. _zend.db.table.row.serialize.unserializing.example:

.. rubric:: Exemple de désérialisation d'un objet Row sérialisé

.. code-block:: php
   :linenos:

   $rowClone = unserialize($serializedRow);

   // Vous ne pouvez faire qu'une utilisation en lecture seule
   echo $rowClone->bug_description;

.. note::

   **Pourquoi ce mode déconnecté imposé ?**

   Un objet sérialisé est une chaîne de caractère, humainement visible. Il est donc peu sécurisé d'y laisser
   un mot de passe vers un serveur de base de données. Le lecteur d'un objet Row sérialisé ne devrait pas
   pouvoir accéder à la base de données. De plus, une connexion à une base de données est un type non
   sérialisable par *PHP* (ressource).

.. _zend.db.table.row.serialize.set-table:

Reconnecter l'objet Row à la Table
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Il est bien entendu possible de reconnecter l'objet Row à la base de données, et plus précisément à la Table
dont il fut issu. Utilisez la méthode ``setTable()`` et passez lui une instance héritant de
``Zend_Db_Table_Abstract``. Une fois reconnecté, l'objet Row possède de nouveau un accès à la base de données,
et n'est donc plus en mode lecture seule.

.. _zend.db.table.row.serialize.set-table.example:

.. rubric:: Exemple de réactivation d'un Row

.. code-block:: php
   :linenos:

   $rowClone = unserialize($serializedRow);

   $bugs = new Bugs();

   // Reconnecte le Row à la table et donc, à la base de données
   $rowClone->setTable($bugs);

   // Maintenant il est possible de l'utiliser en mode écriture
   $rowClone->bug_status = 'FIXED';
   $rowClone->save();

.. _zend.db.table.row.extending:

Étendre la classe Row
---------------------

Vous pouvez utilisez votre propre classe étendant ``Zend_Db_Table_Row_Abstract``. Spécifiez votre classe dans la
propriété protégée ``$_rowClass`` de la classe de votre Table, ou dans le tableau du constructeur de l'objet
Table.

.. _zend.db.table.row.extending.example:

.. rubric:: Spécification d'une classe Row personnalisée

.. code-block:: php
   :linenos:

   class MyRow extends Zend_Db_Table_Row_Abstract
   {
       // ...personnalisations
   }

   // Spécifie la classe de Row utilisée pour toutes les
   // instance de la classe de Table
   class Products extends Zend_Db_Table_Abstract
   {
       protected $_name = 'products';
       protected $_rowClass = 'MyRow';
   }

   // Ou pour une classe de table spécifique, via son constructeur
   $bugs = new Bugs(array('rowClass' => 'MyRow'));

.. _zend.db.table.row.extending.overriding:

Initialisation et pré-traitements d'un Row
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si vous avez un besoin spécifique d'implémenter une logique spéciale après la création d'une instance de Row,
vous pouvez utiliser sa méthode ``init()``, qui est appelée dans son constructeur, mais après que les méta
données aient été calculées.



      .. _zend.db.table.row.init.usage.example:

      .. rubric:: Exemple d'utilisation de la méthode init()

      .. code-block:: php
         :linenos:

         class MyApplicationRow extends Zend_Db_Table_Row_Abstract
         {
             protected $_role;

             public function init()
             {
                 $this->_role = new MyRoleClass();
             }
         }



.. _zend.db.table.row.extending.insert-update:

Définir sa propre logique pour Insert, Update, et Delete dans Zend_Db_Table_Row
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La classe des Rows appelle les méthodes protégées ``_insert()``, ``_update()``, et ``_delete()`` avant
d'effectuer chacune des opérations respectives ``INSERT``, ``UPDATE``, et ``DELETE``. Il est donc possible de
définir sa propre logique dans votre sous-classe de Row.

Ci-dessous vous trouverez des exemples d'utilisation d'une logique personnalisée dans les classes de Row :

.. _zend.db.table.row.extending.overriding-example1:

.. rubric:: Exemple de logique personnalisée dans une classe de Row

La logique personnelle peut donc être déportée dans une classe de Row qui ne s'appliquera qu'à certaines
tables, et pas à d'autres. Sinon, la classe de Table utilise le Row par défaut.

Par exemple, vous souhaitez historiser toutes les insertions sur une Table spécifique, mais uniquement si la
configuration du site le permet :

.. code-block:: php
   :linenos:

   class MyLoggingRow extends Zend_Db_Table_Row_Abstract
   {
       protected function _insert()
       {
           $log = Zend_Registry::get('database_log');
           $log->info(Zend_Debug::dump($this->_data,
                                       "INSERT: $this->_tableClass",
                                       false));
       }
   }

   // $loggingEnabled est une variable d'exemple qui définit si
   // l'historisation est activée ou pas
   if ($loggingEnabled) {
       $bugs = new Bugs(array('rowClass' => 'MyLoggingRow'));
   } else {
       $bugs = new Bugs();
   }

.. _zend.db.table.row.extending.overriding-example2:

.. rubric:: Exemple d'une classe de Row qui historise les insertions de plusieurs tables

En passant l'objet Row personnalisé à chacune des Tables concernées, alors vous n'aurez pas besoin de définir
cette logique dans chacune des classes des Tables.

Dans cet exemple, le code qui effectue l'historisation est identique à celui de l'exemple précédent.

.. code-block:: php
   :linenos:

   class MyLoggingRow extends Zend_Db_Table_Row_Abstract
   {
       protected function _insert()
       {
           $log = Zend_Registry::get('database_log');
           $log->info(Zend_Debug::dump($this->_data,
                                       "INSERT: $this->_tableClass",
                                       false));
       }
   }

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';
       protected $_rowClass = 'MyLoggingRow';
   }

   class Products extends Zend_Db_Table_Abstract
   {
       protected $_name = 'products';
       protected $_rowClass = 'MyLoggingRow';
   }

.. _zend.db.table.row.extending.inflection:

Définir l'inflexion dans Zend_Db_Table_Row
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Il peut être intéressant de personnaliser l'accès aux colonnes de la table représentée par un résultat Row,
plutôt que d'utiliser le nom des colonnes telles que définies dans le SGBDR sous-jacent. La transformation de
l'un vers l'autre est appelée **inflexion**.

Les classes Zend_Db n'utilisent pas l'inflexion par défaut. Voyez :ref:` <zend.db.table.extending.inflection>`
pour plus de détails sur ce procédé.

Ainsi si vous voulez utiliser l'inflexion, vous devez implémenter vous-même la transformation à effectuer en
redéfinissant la méthode ``_transformColumn()`` dans votre classe de Row, et bien entendu utiliser cette classe
de Row pour votre Table.

.. _zend.db.table.row.extending.inflection.example:

.. rubric:: Exemple d'utilisation de l'inflexion

Ceci vous permet d'utiliser les accesseurs de votre Row de manière transformée. La classe de votre Row utilisera
``_transformColumn()`` pour changer le nom de la colonne appelée, avant de le faire correspondre à un nom dans la
table réelle de la base de données.

.. code-block:: php
   :linenos:

   class MyInflectedRow extends Zend_Db_Table_Row_Abstract
   {
       protected function _transformColumn($columnName)
       {
           $nativeColumnName = myCustomInflector($columnName);
           return $nativeColumnName;
       }
   }

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';
       protected $_rowClass = 'MyInflectedRow';
   }

   $bugs = new Bugs();
   $row = $bugs->fetchNew();

   // Utilisez des nom de colonnes CamelCase, l'inflecteur les
   // transformera alors pour vous afin d'établir la correspondance
   // avec les noms natifs des colonnes.
   $row->bugDescription = 'New description';

En revanche, c'est à vous d'écrire votre mécanisme d'inflexion.



.. _`Row Data Gateway`: http://www.martinfowler.com/eaaCatalog/rowDataGateway.html
