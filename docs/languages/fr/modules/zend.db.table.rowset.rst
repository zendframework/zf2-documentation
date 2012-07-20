.. _zend.db.table.rowset:

Zend_Db_Table_Rowset
====================

.. _zend.db.table.rowset.introduction:

Introduction
------------

Lorsque vous effectuez une requête avec une classe de Table en utilisant ``find()`` ou ``fetchAll()``, le
résultat retourné est alors un objet de type ``Zend_Db_Table_Rowset_Abstract``. Un Rowset est un conteneur
d'objets descendants de ``Zend_Db_Table_Row_Abstract``. Vous pouvez itérer à travers ce conteneur et accéder aux
objet Row individuellement, en lecture ou écriture bien entendu.

.. _zend.db.table.rowset.fetch:

Récupérer un Rowset
-------------------

``Zend_Db_Table_Abstract`` possède des méthodes ``find()`` et ``fetchAll()``, chacune retourne un objet de type
``Zend_Db_Table_Rowset_Abstract``.

.. _zend.db.table.rowset.fetch.example:

.. rubric:: Exemple de récupération d'un rowset

.. code-block:: php
   :linenos:

   $bugs   = new Bugs();
   $rowset = $bugs->fetchAll("bug_status = 'NEW'");

.. _zend.db.table.rowset.rows:

Atteindre les Rows depuis un Rowset
-----------------------------------

L'objet Rowset en lui-même n'est pas très intéressant au regard des objets Rows qu'il contient, qui eux, le sont
bien plus.

Un requête légitime peut retourner zéro enregistrement, donc zéro Rows. De ce fait, un objet Rowset peut
contenir zéro objet Row. Comme ``Zend_Db_Table_Rowset_Abstract`` implémente l'interface *Countable*, vous pouvez
utiliser la fonction *PHP* ``count()`` dessus, pour compter les Rows qu'il contient.

.. _zend.db.table.rowset.rows.counting.example:

.. rubric:: Compter les Rows dans un Rowset

.. code-block:: php
   :linenos:

   $rowset   = $bugs->fetchAll("bug_status = 'FIXED'");

   $rowCount = count($rowset);

   if ($rowCount > 0) {
       echo "$rowCount rows trouvés";
   } else {
       echo 'Pas de rows pour cette requête';
   }

.. _zend.db.table.rowset.rows.current.example:

.. rubric:: Lecture d'un simple Row depuis un Rowset

La façon la plus simple d'accéder à un Row depuis l'objet Rowset est d'utiliser la méthode ``current()``. C'est
tout à fait adapté lorsque le Rowset ne contient qu'un résultat (Row).

.. code-block:: php
   :linenos:

   $bugs   = new Bugs();
   $rowset = $bugs->fetchAll("bug_id = 1");
   $row    = $rowset->current();

Si le Rowset ne contient aucun Row, ``current()`` retourne ``NULL``.

.. _zend.db.table.rowset.rows.iterate.example:

.. rubric:: Itération à travers un Rowset

Les objets descendants de ``Zend_Db_Table_Rowset_Abstract`` implémentent l'interface *Iterator*, ce qui veut dire
qu'ils peuvent être utilisés dans la structure *PHP* *foreach*. Chaque valeur récupérée représente alors un
objet de ``Zend_Db_Table_Row_Abstract`` qui correspond à un enregistrement dans la table.

.. code-block:: php
   :linenos:

   $bugs = new Bugs();

   // récupère tous les enregistrements de la table
   $rowset = $bugs->fetchAll();

   foreach ($rowset as $row) {

       // affiche 'Zend_Db_Table_Row' par défaut
       echo get_class($row) . "\n";

       // lit une colonne dans le résultat Row
       $status = $row->bug_status;

       // modifie une colonne dans le résultat courant
       $row->assigned_to = 'mmouse';

       // Enregistre en base de données
       $row->save();
   }

.. _zend.db.table.rowset.rows.seek.example:

.. rubric:: Déplacement vers une position précise dans le Rowset

*SeekableIterator* vous permet de vus déplacer à une position précise dans l'itérateur. Utilisez pour ceci la
méthode ``seek()``. Elle prend en paramètre un entier représentant le numéro de la position désirée.
N'oubliez pas que le premier enregistrement est stocké à la position zéro. Si vous spécifiez une position qui
n'existe pas, une exception sera levée. Vous devriez utiliser ``count()`` pour vérifier le nombre
d'enregistrements Rows présents.

.. code-block:: php
   :linenos:

   $bugs = new Bugs();

   // récupère tous les enregistrements de la table
   $rowset = $bugs->fetchAll();

   // Déplace l'itérateur à l'enregistrement 8 (le neuvième donc) :
   $rowset->seek(8);

   // récupèration de cet enregistrement
   $row9 = $rowset->current();

   // et utilisation
   $row9->assigned_to = 'mmouse';
   $row9->save();

``getRow()`` permet de retourner directement un enregistrement en fonction de sa position dans l'itérateur Rowset.
Le premier paramètre est un entier représentant cette position. Le second paramètre est optionnel, et indique si
oui ou non l'itérateur doit rester sur cette position, après avoir retourné le Row correspondant. Par défaut,
il est à ``FALSE``. Cette méthode retourne donc un objet ``Zend_Db_Table_Row``. Si la position demandée n'existe
pas, une exception est levée :

.. code-block:: php
   :linenos:

   $bugs = new Bugs();

   // récupère tous les enregistrements de la table
   $rowset = $bugs->fetchAll();

   // récupère le neuvième enregistrement immédiatement
   $row9->getRow(8);

   // utilisation de l'enregistrement récupéré :
   $row9->assigned_to = 'mmouse';
   $row9->save();

Dès que vous avez accès à un objet individuel Row, vous pouvez le piloter comme présenté dans la section
:ref:` <zend.db.table.row>`.

.. _zend.db.table.rowset.to-array:

Récupérer un Rowset en tant que tableau (Array)
-----------------------------------------------

Vous pouvez accéder à toutes les données d'un Rowset au moyen d'un tableau *PHP* avec la méthode ``toArray()``.
Ce tableau possède deux dimensions. Chaque entrée du tableau représente un tableau de l'objet Row. Les clés
sont les noms des champs, et les valeurs leurs valeurs.

.. _zend.db.table.rowset.to-array.example:

.. rubric:: Utiliser toArray()

.. code-block:: php
   :linenos:

   $bugs   = new Bugs();
   $rowset = $bugs->fetchAll();

   $rowsetArray = $rowset->toArray();

   $rowCount = 1;
   foreach ($rowsetArray as $rowArray) {
       echo "row #$rowCount:\n";
       foreach ($rowArray as $column => $value) {
           echo "\t$column => $value\n";
       }
       ++$rowCount;
       echo "\n";
   }

Le tableau retourné par ``toArray()`` n'est pas une référence. Le modifier ne modifiera en aucun cas les
données réelles dans la base de données.

.. _zend.db.table.rowset.serialize:

Sérialisation et Désérialisation d'un Rowset
--------------------------------------------

Les objets de type ``Zend_Db_Table_Rowset_Abstract`` sont sérialisables. De la même manière que vous sérialisez
un objet Row individuel, le Rowset est sérialisable et désérialisable.

.. _zend.db.table.rowset.serialize.example.serialize:

.. rubric:: Sérialiser d'un Rowset

Utilisez simplement la fonction *PHP* ``serialize()`` pour créer une chaîne de caractères représentant votre
objet Rowset.

.. code-block:: php
   :linenos:

   $bugs   = new Bugs();
   $rowset = $bugs->fetchAll();

   // Convertit l'objet en sa forme sérialisée
   $serializedRowset = serialize($rowset);

   // Maintenant vous pouvez écrire $serializedRowset
   // dans un fichier, etc.

.. _zend.db.table.rowset.serialize.example.unserialize:

.. rubric:: Désérialisation d'un objet Rowset sérialisé

Utilisez simplement la fonction *PHP* ``unserialize()``.

Notez que l'objet retourné fonctionne alors en mode **déconnecté**. Vous pouvez itérer à travers, et lire les
objets Row qu'il contient, mais vous ne pouvez plus faire intervenir la base de données, ni changer de valeurs
dans les Rows.

.. code-block:: php
   :linenos:

   $rowsetDisconnected = unserialize($serializedRowset);

   // Maintenant vous pouvez utiliser l'objet, mais en lecture seule
   $row = $rowsetDisconnected->current();
   echo $row->bug_description;

.. note::

   **Pourquoi ce mode déconnecté imposé ?**

   Un objet sérialisé est une chaîne de caractère, humainement visible. Il est donc peut sécurisé d'y laisser
   un mot de passe vers un serveur de base de données. Le lecteur d'un objet Rowset sérialisé ne devrait pas
   pouvoir accéder à la base de données. De plus, une connexion à une base de données est un type non
   sérialisable par *PHP* (ressource).

Il est bien entendu possible de reconnecter l'objet Rowset à la base de données, et plus précisément à la
Table dont il fut issu. Utilisez la méthode ``setTable()`` et passez lui une instance héritant de
``Zend_Db_Table_Abstract``. Une fois reconnecté, l'objet Rowset possède de nouveau un accès à la base de
données, et n'est donc plus en mode lecture seule.

.. _zend.db.table.rowset.serialize.example.set-table:

.. rubric:: Réactivation d'un Rowset

.. code-block:: php
   :linenos:

   $rowset = unserialize($serializedRowset);

   $bugs = new Bugs();

   // Reconnecte le rowset à une table, et par
   // conséquent, à la connexion vers la base de données active
   $rowset->setTable($bugs);

   $row = $rowset->current();

   // Maintenant vous pouvez modifier les objets Row et les sauvegarder
   $row->bug_status = 'FIXED';
   $row->save();

Réactiver un Rowset avec ``setTable()`` réactive tous les Rows le composant.

.. _zend.db.table.rowset.extending:

Étendre la classe Rowset
------------------------

Vous pouvez utilisez votre propre classe étendant ``Zend_Db_Table_Rowset_Abstract``. Spécifiez votre classe dans
la propriété protégée ``$_rowsetClass`` de la classe de votre Table, ou dans le tableau du constructeur de
l'objet Table.

.. _zend.db.table.rowset.extending.example:

.. rubric:: Spécifier sa propre classe de Rowset

.. code-block:: php
   :linenos:

   class MyRowset extends Zend_Db_Table_Rowset_Abstract
   {
       // ...personnalisations
   }

   // Spécifie la classe de Rowset utilisée pour toutes les
   // instance de la classe de Table
   class Products extends Zend_Db_Table_Abstract
   {
       protected $_name = 'products';
       protected $_rowsetClass = 'MyRowset';
   }

   // Ou pour une classe de table spécifique, via son constructeur
   $bugs = new Bugs(array('rowsetClass' => 'MyRowset'));

En temps normal, la classe standard Zend_Db_Rowset est suffisante. Cependant, il peut être judicieux de rajouter
de la logique dans son Rowset, pour une table précise. Par exemple, une nouvelle méthode pourrait effectuer des
calculs.

.. _zend.db.table.rowset.extending.example-aggregate:

.. rubric:: Exemple d'une classe Rowset personnalisée avec une nouvelle méthode

.. code-block:: php
   :linenos:

   class MyBugsRowset extends Zend_Db_Table_Rowset_Abstract
   {
       /**
        * Trouve les Rows dans le Rowset courant avec la plus grande
        * valeur pour la colonne 'updated_at'.
        */
       public function getLatestUpdatedRow()
       {
           $max_updated_at = 0;
           $latestRow = null;
           foreach ($this as $row) {
               if ($row->updated_at > $max_updated_at) {
                   $latestRow = $row;
               }
           }
           return $latestRow;
       }
   }

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';
       protected $_rowsetClass = 'MyBugsRowset';
   }


