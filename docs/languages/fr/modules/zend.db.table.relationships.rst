.. _zend.db.table.relationships:

Relations Zend_Db_Table
=======================

.. _zend.db.table.relationships.introduction:

Introduction
------------

Les tables possèdent des relations entre elles, dans une base de données relationnelle. Une entité d'une table
peut être liée à une autre entité d'une autre table, via un procédé appelé contrainte d'intégrité
référentielle

La classe ``Zend_Db_Table_Row`` possède des méthodes pour récupérer des enregistrement dans d'autres tables,
liées à celle en cours.

.. _zend.db.table.relationships.defining:

Définir ses relations
---------------------

Chaque table doit avoir sa classe étendant ``Zend_Db_Table_Abstract``, comme décrit dans :ref:`
<zend.db.table.defining>`. Voyez aussi :ref:` <zend.db.adapter.example-database>` pour une description de la base
de donnée qui servira d'exemple pour la suite de ce chapitre.

Voici les classes correspondantes à ces tables :

.. code-block:: php
   :linenos:

   class Accounts extends Zend_Db_Table_Abstract
   {
       protected $_name            = 'accounts';
       protected $_dependentTables = array('Bugs');
   }

   class Products extends Zend_Db_Table_Abstract
   {
       protected $_name            = 'products';
       protected $_dependentTables = array('BugsProducts');
   }

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name            = 'bugs';

       protected $_dependentTables = array('BugsProducts');

       protected $_referenceMap    = array(
           'Reporter' => array(
               'columns'           => 'reported_by',
               'refTableClass'     => 'Accounts',
               'refColumns'        => 'account_name'
           ),
           'Engineer' => array(
               'columns'           => 'assigned_to',
               'refTableClass'     => 'Accounts',
               'refColumns'        => 'account_name'
           ),
           'Verifier' => array(
               'columns'           => array('verified_by'),
               'refTableClass'     => 'Accounts',
               'refColumns'        => array('account_name')
           )
       );
   }

   class BugsProducts extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs_products';

       protected $_referenceMap    = array(
           'Bug' => array(
               'columns'           => array('bug_id'),
               'refTableClass'     => 'Bugs',
               'refColumns'        => array('bug_id')
           ),
           'Product' => array(
               'columns'           => array('product_id'),
               'refTableClass'     => 'Products',
               'refColumns'        => array('product_id')
           )
       );

   }

Si vous utilisez ``Zend_Db_Table`` pour émuler les cascades ``UPDATE`` et ``DELETE``, alors déclarez
``$_dependentTables`` en tant que tableau dans la classe des tables parentes. Listez ainsi le nom de chaque table
dépendante. Utilisez bien le nom des classes, et non les noms physiques des tables.

.. note::

   Si votre SGBD implémente le mécanisme des cascades, alors vous n'avez pas besoin de déclarer
   ``$_dependentTables``. Voyez :ref:` <zend.db.table.relationships.cascading>` pour plus d'informations.

Déclarez un tableau ``$_referenceMap`` dans les classes de chaque table dépendante (qui "reçoit une clé").
C'est un tableau associatif, dit de "rôles". Un rôle définit quelle table est parente dans la relation, et
quelle est sa colonne de parenté.

Le rôle est utilisé comme index du tableau ``$_referenceMap``. Il est utilisé pour définir la relation, et
pourra faire partie du nom de certaines méthodes, comme nous le verrons plus tard. Choisissez ainsi un nom de
rôle de manière intelligente.

Dans l'exemple du dessus, les rôles dans la classe Bugs sont : *"Reporter"*, *"Engineer"*, *"Verifier"* et
*"Product"*.

La valeur de chaque rôle dans le tableau ``$_referenceMap`` est aussi un tableau associatif. Les éléments de
chaque rôle sont décrits ci-après.

- **columns** => une chaîne de caractères ou un tableau de chaînes désignant le(s) nom(s) des clés
  étrangères dans la table dépendante (la table actuelle donc).

  Il est courant qu'il s'agisse d'une seule colonne, mais on peut rencontrer le cas de clés composées de
  multiples colonnes.

- **refTableClass** => désigne la classe de la table parente, liée à cette colonne. Utilisez le nom de la classe
  et non le nom de la table physique.

  Il est courant qu'une table dépendante n'ait qu'une seule référence d'une même table parente. Cependant
  certaines tables peuvent avoir plusieurs références vers une même table parente. Dans notre base de données
  d'exemple, c'est le cas avec la table *bugs*. Elle possède soit une et une seule colonne référençant la table
  parente *products*, mais elle possède trois références (donc trois colonnes) vers la table parente *accounts*.
  Chaque référence doit être matérialisée par un rôle unique dans le tableau ``$_referenceMap``.

- **refColumns** => c'est une chaîne de caractères ou un tableau de chaînes nommant la(es) colonne(s) (clé
  primaire) de la table parente.

  Si vous devez utiliser de multiples colonnes parentes pour une seule clé, alors veillez à bien les entrer dans
  *'columns'* dans le même ordre que dans *'refColumns'*.

  Il est optionnel de spécifier la *refColumns*. La clé primaire est utilisée par défaut comme colonne parente
  dans une relation.

- **onDelete** => le nom de l'action à exécuter si un enregistrement est supprimé de la table parente. Voyez
  :ref:` <zend.db.table.relationships.cascading>` pour plus d'informations.

- **onUpdate** => le nom de l'action à exécuter si un enregistrement est mis à jour dans la table parente. Voyez
  :ref:` <zend.db.table.relationships.cascading>` pour plus d'informations.

.. _zend.db.table.relationships.fetching.dependent:

Récupérer des enregistrements dépendants (enfants)
--------------------------------------------------

Si vous possédez un enregistrement actif (*Row*), il est possible de récupérer ses enfants dépendants, si les
dépendances ont été déclarées suivant la procédure ci-dessus. Utilisez la méthode :

.. code-block:: php
   :linenos:

   $row->findDependentRowset($table, [$rule]);

Cette méthode retourne un objet instance de ``Zend_Db_Table_Rowset_Abstract``, qui contient tous les
enregistrements (*Row*) de la table dépendante ``$table`` faisant référence à l'enregistrement actif actuel
``$row``.

Le paramètre ``$table`` désigne la table dépendante à utiliser. Ceci peut être une chaîne de caractères
aussi bien qu'un objet de la classe de cette table.

.. _zend.db.table.relationships.fetching.dependent.example:

.. rubric:: Récupérer des enregistrements dépendants

Cet exemple montre comment obtenir un enregistrement actif (objet *Row*) de la table *Accounts*, et comment en
récupérer les enfants dépendants de la table *Bugs*. (les bugs reportés par ce compte)

.. code-block:: php
   :linenos:

   $accountsTable      = new Accounts();
   $accountsRowset     = $accountsTable->find(1234);
   $user1234           = $accountsRowset->current();

   $bugsReportedByUser = $user1234->findDependentRowset('Bugs');

Le second paramètre ``$rule`` est optionnel. Il s'agit du nom du rôle à utiliser depuis le tableau
``$_referenceMap`` de la classe de la table dépendante. Si vous ne le spécifiez pas, le premier rôle sera
utilisé. Il n'y a dans la majorité des cas qu'un seul rôle.

Dans l'exemple ci dessus, nous ne fournissons pas de nom de rôle, le premier est donc pris en considération, et
il s'agit de *"Reporter"*.

.. _zend.db.table.relationships.fetching.dependent.example-by:

.. rubric:: Récupérer des enregistrements dépendants avec un rôle spécifique

Dans cet exemple nous montrons comment obtenir un enregistrement (*Row*) depuis la table *Accounts*, et comment
trouver les *Bugs* assignés à ce compte (*Account*). Nous devrons alors nommer le rôle *"Engineer"*.

.. code-block:: php
   :linenos:

   $accountsTable      = new Accounts();
   $accountsRowset     = $accountsTable->find(1234);
   $user1234           = $accountsRowset->current();

   $bugsAssignedToUser = $user1234->findDependentRowset('Bugs',
                                                        'Engineer');

Vous pouvez rajouter des critères à vos relations, comme l'ordre ou la limite, ceci en utilisant l'objet *select*
de l'enregistrement parent.





      .. _zend.db.table.relationships.fetching.dependent.example-by-select:

      .. rubric:: Récupérer des enregistrements dépendants en utilisant un objet Zend_Db_Table_Select

      Dans cet exemple nous montrons comment obtenir un enregistrement (*Row*) depuis la table *Accounts*, et
      comment trouver les *Bugs* assignés à ce compte (*Account*), mais limités seulement à trois
      enregistrements, et ordonnés par nom. Nous devrons nommer le rôle *"Engineer"*.

      .. code-block:: php
         :linenos:

         $accountsTable      = new Accounts();
         $accountsRowset     = $accountsTable->find(1234);
         $user1234           = $accountsRowset->current();
         $select             = $accountsTable->select()->order('name ASC')
                                                       ->limit(3);

         $bugsAssignedToUser = $user1234->findDependentRowset('Bugs',
                                                              'Engineer',
                                                              $select);

Vous pouvez récupérer les enregistrements dépendants d'une autre manière. En utilisant les "méthodes
magiques". En effet, ``Zend_Db_Table_Row_Abstract`` va utiliser la méthode ``findDependentRowset('<TableClass>',
'<Rule>')`` si vous appelez sur l'enregistrement une méthode correspondante à un de ces motifs :



- *$row->find<TableClass>()*

- *$row->find<TableClass>By<Rule>()*

Dans les motifs ci-dessus, *<TableClass>* et *<Rule>* désignent respectivement le nom de la table dépendante et
le rôle à utiliser.

.. note::

   Certains frameworks tels que Rails pour Ruby, utilise un mécanisme dit d'inflexion, qui permet de transformer
   les noms des identifiants (nom de table, de rôle...) d'une certaine manière bien spécifique dans les
   méthodes appelées. Cela n'est pas le cas de Zend Framework : vous devez, dans vos méthodes magiques, utiliser
   l'orthographe exacte des noms des rôles et classes, tels que vous les définissez.

.. _zend.db.table.relationships.fetching.dependent.example-magic:

.. rubric:: Récupérer des enregistrements dépendants en utilisant les méthodes magiques

Cet exemple a le même effet que le précédent. Il utilise simplement les méthodes magiques pour récupérer les
enregistrements dépendants.

.. code-block:: php
   :linenos:

   $accountsTable    = new Accounts();
   $accountsRowset   = $accountsTable->find(1234);
   $user1234         = $accountsRowset->current();

   // Utilise le rôle par défaut (le premier de la liste)
   $bugsReportedBy   = $user1234->findBugs();

   // Utilise un rôle spécifique
   $bugsAssignedTo   = $user1234->findBugsByEngineer();

.. _zend.db.table.relationships.fetching.parent:

Récupérer l'enregistrement parent
---------------------------------

Si vous possédez un enregistrement (*Row*) dont la table possède une table parente, il est possible alors de
récupérer l'enregistrement parent. Utilisez pour cela la méthode :

.. code-block:: php
   :linenos:

   $row->findParentRow($table, [$rule]);

La logique veut qu'il ne puisse y avoir qu'un et un seul parent par enregistrement. Ainsi, cette méthode retourne
un objet *Row* et non un objet *Rowset*

Le premier paramètre ``$table`` désigne la table parente. Ceci peut être une chaîne de caractères, ou un objet
instance de la classe de la table parente.

.. _zend.db.table.relationships.fetching.parent.example:

.. rubric:: Récupérer l'enregistrement parent

Cet exemple illustre la récupération d'un enregistrement *Bugs* (disons par exemple ceux avec le statut "NEW"),
et l'obtention de l'enregistrement parent correspondant à *Accounts* (la personne ayant reporté le bug)

.. code-block:: php
   :linenos:

   $bugsTable   = new Bugs();
   $bugsRowset  = $bugsTable->fetchAll(array('bug_status = ?' => 'NEW'));
   $bug1        = $bugsRowset->current();

   $reporter    = $bug1->findParentRow('Accounts');

Le second paramètre ``$rule`` est optionnel. Il s'agit du nom du rôle à utiliser depuis le tableau
``$_referenceMap`` de la classe de la table dépendante. Si vous ne le spécifiez pas, le premier rôle sera
utilisé. Il n'y a dans la majorité des cas qu'un seul rôle.

Dans l'exemple ci dessus, nous ne fournissons pas de nom de rôle, le premier est donc pris en considération, et
il s'agit de *"Reporter"*.

.. _zend.db.table.relationships.fetching.parent.example-by:

.. rubric:: Récupérer un enregistrement parent avec un rôle spécifique

Cet exemple va démontrer comment, à partir d'un enregistrement de *Bugs*, récupérer la personne en étant
assignée. Il va falloir utiliser le rôle *"Engineer"*.

.. code-block:: php
   :linenos:

   $bugsTable   = new Bugs();
   $bugsRowset  = $bugsTable->fetchAll(array('bug_status = ?', 'NEW'));
   $bug1        = $bugsRowset->current();

   $engineer    = $bug1->findParentRow('Accounts', 'Engineer');

Vous pouvez récupérer l'enregistrement parent d'une autre manière. En utilisant les "méthodes magiques". En
effet, Zend_Db_Table_Row_Abstract va utiliser la méthode ``findParentRow('<TableClass>', '<Rule>')`` si vous
appelez sur l'enregistrement une méthode correspondante à un de ces motifs :

- *$row->findParent<TableClass>([Zend_Db_Table_Select $select])*

- *$row->findParent<TableClass>By<Rule>([Zend_Db_Table_Select $select])*

Dans les motifs ci-dessus, *<TableClass>* et *<Rule>* représentent respectivement le nom de la classe de la table
parente, et le rôle à utiliser éventuellement.

.. note::

   Les noms de la table et du rôle doivent être orthographiés de la même manière qu'ils ne le sont lors de
   leur définition dans la table.

.. _zend.db.table.relationships.fetching.parent.example-magic:

.. rubric:: Récupérer un enregistrement parent en utilisant les méthodes magiques

Cet exemple a le même effet que le précédent. Il utilise simplement les méthodes magiques pour récupérer
l'enregistrement parent.

.. code-block:: php
   :linenos:

   $bugsTable   = new Bugs();
   $bugsRowset  = $bugsTable->fetchAll(array('bug_status = ?', 'NEW'));
   $bug1        = $bugsRowset->current();

   // Utilise le rôle par défaut ( le premier déclaré)
   $reporter    = $bug1->findParentAccounts();

   // Utilise un rôle spécifique
   $engineer    = $bug1->findParentAccountsByEngineer();

.. _zend.db.table.relationships.fetching.many-to-many:

Récupérer des enregistrements dans une relation N-N (plusieurs-à-plusieurs ou "many-to-many")
---------------------------------------------------------------------------------------------

Si vous possédez un enregistrement sur une table (appelons la "table d'origine") ayant une relation plusieurs à
plusieurs vers une autre table (appelons la "table de destination"), vous pouvez alors accéder aux enregistrements
de la table de destination, via une table dite "d'intersection". Utilisez la méthode :

.. code-block:: php
   :linenos:

   $row->findManyToManyRowset($table,
                              $intersectionTable,
                              [$rule1,
                              [$rule2,
                              [Zend_Db_Table_Select $select]]]);

Cette méthode retourne un objet instance de ``Zend_Db_Table_Rowset_Abstract`` qui contient les enregistrements de
la table ``$table`` qui correspondent à la relation plusieurs à plusieurs. L'enregistrement courant de la table
courante, ``$row``, est utilisé comme point de départ pour effectuer une jointure vers la table de destination,
via la table d'intersection.

Le premier paramètre ``$table`` peut être soit une chaîne soit un objet instance de la classe de la table de
destination dans la relation plusieurs à plusieurs.

Le second paramètre ``$intersectionTable`` peut être soit une chaîne soit un objet instance de la classe de la
table d'intersection dans la relation plusieurs à plusieurs.

.. _zend.db.table.relationships.fetching.many-to-many.example:

.. rubric:: Récupérer des enregistrements dans une relation plusieurs-à-plusieurs

Cet exemple montre comment posséder un enregistrement de la table d'origine *Bugs*, et comment en récupérer les
enregistrements de *Products*, qui représentent les produits qui font référence à ce bug.

.. code-block:: php
   :linenos:

   $bugsTable        = new Bugs();
   $bugsRowset       = $bugsTable->find(1234);
   $bug1234          = $bugsRowset->current();

   $productsRowset   = $bug1234->findManyToManyRowset('Products',
                                                      'BugsProducts');

Les troisième et quatrième paramètres, ``$rule1`` et ``$rule2``, sont optionnels. Ce sont des chaînes de
caractères qui désignent les rôles à utiliser dans le tableau ``$_referenceMap`` de la table d'intersection.

``$rule1`` nomme le rôle dans la relation entre la table d'origine et la table d'intersection. Dans notre exemple,
il s'agit donc de la relation de *Bugs* à *BugsProducts*.

``$rule2``\ nomme le rôle dans la relation entre la table d'origine et la table d'intersection. Dans notre
exemple, il s'agit donc de la relation de *BugsProducts* à *Products*.

Si vous ne spécifiez pas de rôles, alors le premier rôle trouvé pour la table, dans le tableau
``$_referenceMap``, sera utilisé. Dans la grande majorité des cas, il n'y a qu'un rôle.

Dans l'exemple ci-dessus, les rôles ne sont pas spécifiés. Ainsi ``$rule1`` prend la valeur *"Reporter"* et
``$rule2`` prend la valeur *"Product"*.

.. _zend.db.table.relationships.fetching.many-to-many.example-by:

.. rubric:: Récupérer des enregistrements dans une relation plusieurs-à-plusieurs avec un rôle spécifique

Cet exemple montre comment à partir d'un enregistrement de *Bugs*, récupérer les enregistrements de *Products*,
représentant les produits comportant ce bug.

.. code-block:: php
   :linenos:

   $bugsTable        = new Bugs();
   $bugsRowset       = $bugsTable->find(1234);
   $bug1234          = $bugsRowset->current();

   $productsRowset   = $bug1234->findManyToManyRowset('Products',
                                                      'BugsProducts',
                                                      'Bug');

Vous pouvez récupérer l'enregistrement de destination d'une autre manière. En utilisant les "méthodes
magiques". En effet, ``Zend_Db_Table_Row_Abstract`` va utiliser la méthode *findManyToManyRowset('<TableClass>',
'<IntersectionTableClass>', '<Rule1>', '<Rule2>')* si vous appelez sur l'enregistrement une méthode correspondante
à un de ces motifs :

- *$row->find<TableClass>Via<IntersectionTableClass>([Zend_Db_Table_Select $select])*

- *$row->find<TableClass>Via<IntersectionTableClass>By<Rule1>([Zend_Db_Table_Select $select])*

- *$row->find<TableClass>Via<IntersectionTableClass>By<Rule1>And<Rule2>([Zend_Db_Table_Select $select])*

Dans les motifs ci dessus, *<TableClass>* et *<IntersectionTableClass>* sont des chaînes de caractères
correspondantes aux noms des classes des tables de destination et d'intersection (respectivement). *<Rule1>* et
*<Rule2>* sont respectivement des chaînes désignant les rôles dans la table d'intersection pour la table de
référence, et de destination.

.. note::

   Les noms de la table et des rôles doivent être orthographiés de manière exacte, tel qu'ils le sont lors de
   leurs définitions respectives.

.. _zend.db.table.relationships.fetching.many-to-many.example-magic:

.. rubric:: Récupérer des enregistrements dans une relation plusieurs-à-plusieurs avec les méthodes magiques

Cet exemple illustre la récupération d'enregistrements dans une table de destination, bugs, depuis un produit, en
passant par une table d'intersection, le tout, via des méthodes magiques.

.. code-block:: php
   :linenos:

   $bugsTable   = new Bugs();
   $bugsRowset  = $bugsTable->find(1234);
   $bug1234     = $bugsRowset->current();

   // Utilisation des rôles par défaut
   $products    = $bug1234->findProductsViaBugsProducts();

   // Utilisation d'un rôle spécifique
   $products    = $bug1234->findProductsViaBugsProductsByBug();

.. _zend.db.table.relationships.cascading:

Opérations d'écritures en cascade
---------------------------------

.. note::

   **Déclarer l'intégrité référentielle**

   Déclarer les opérations de cascades dûes à l'intégrité référentielle dans ``Zend_Db_Table`` directement,
   ne doit se faire **seulement** si votre SGBD ne supporte pas nativement ce genre d'opérations.

   C'est le cas par exemple de MySQL utilisant le stockage de tables MyISAM, ou encore SQLite. Ces solutions là ne
   supportent pas l'intégrité référentielle. Il peut alors être intéressant d'utiliser ``Zend_Db_Table`` pour
   émuler un tel comportement

   Si votre SGBD en revanche supporte les clauses *ON DELETE* et *ON UPDATE*, alors vous devriez les déclarer
   directement dans le SGBD plutôt que de vous fier à l'émulation proposée par ``Zend_Db_Table``. Déclarer son
   intégrité référentielle dans son SGBD directement est tout à fait recommandé pour les performances,
   l'intégrité (l'atomicité des opérations), et la logique de base de données.

   Il est très important de ne pas déclarer ses règles d'intégrité référentielle à la fois dans son SGBD et
   dans les classes ``Zend_Db_Table``.

Vous pouvez déclarer des opérations de cascade sur un ``UPDATE`` ou un ``DELETE``, à appliquer sur les
enregistrements dépendants à la table en cours.

.. _zend.db.table.relationships.cascading.example-delete:

.. rubric:: Exemple de DELETE cascade

Cet exemple montre l'effacement d'un enregistrement de *Products*, qui va propager l'effacement des enregistrements
dépendants dans la table *Bugs*.

.. code-block:: php
   :linenos:

   $productsTable  = new Products();
   $productsRowset = $productsTable->find(1234);
   $product1234    = $productsRowset->current();

   $product1234->delete();
   // Cascades automatiques vers le table Bugs
   // et suppression des enregistrements dépendants.

De la même manière, si vous utilisez un ``UPDATE`` pour changer la valeur de la clé primaire d'une table
parente, vous pourriez nécessiter que les clés étrangères des tables dépendantes soient mises à jour.

En général s'il s'agit d'une séquence, il n'est pas nécessaire de mettre à jour les enregistrements
dépendants. En revanche concernant les clé dites **naturelles**, il peut s'avérer nécessaire de propager un
changement de valeur.

Afin de déclarer une relation de cascades dans ``Zend_Db_Table``, éditer les rôles dans ``$_referenceMap``.
Ajoutez les clés *'onDelete'* et *'onUpdate'* et donnez leur la valeur 'cascade' (ou la constante
``self::CASCADE``). Avant qu'un enregistrement ne soit modifié(sa clé primaire) / supprimé, tous les
enregistrements dans les tables dépendantes seront modifiés / supprimés.

.. _zend.db.table.relationships.cascading.example-declaration:

.. rubric:: Exemple de déclaration des opérations de cascade

Dans l'exemple ci-après, les enregistrements de *Bugs* sont automatiquement supprimés si l'enregistrement dans la
table *Products* auquel ils font référence est supprimé. L'élément *"onDelete"* de la ``$_referenceMap`` est
mis à ``self::CASCADE``.

Pas de mise à jour en cascade en revanche pour cette table, si la clé primaire de la table parente est changée.
En effet, l'élément *"onUpdate"* est mis à ``self::RESTRICT``. Vous auriez aussi pu tout simplement ne pas
spécifier *"onUpdate"*.

.. code-block:: php
   :linenos:

   class BugsProducts extends Zend_Db_Table_Abstract
   {
       ...
       protected $_referenceMap    = array(
           'Product' => array(
               'columns'           => array('product_id'),
               'refTableClass'     => 'Products',
               'refColumns'        => array('product_id'),
               'onDelete'          => self::CASCADE,
               'onUpdate'          => self::RESTRICT
           ),
           ...
       );
   }

.. _zend.db.table.relationships.cascading.notes:

Notes concernant les opérations de cascade
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Les opérations de cascades déclenchées par Zend_Db_Table ne sont pas atomiques.**

Ceci signifie que si votre SGBD possède un moyen de gérer les cascades, comme l'intégrité référentielle (et
les clés étrangères), alors vous ne devriez pas utiliser les cascades INSERT via ``Zend_Db_Table``, car elles
vont entrer en conflit avec le système d'intégrité référentielle du SGBD qui lui, est atomique.

Le problème est plus mitigé concernant ``DELETE``. Vous pouvez détruire de manière non atomique un
enregistrement dépendant, avant de détruire son parent.

Cependant, les deux opérations ``UPDATE`` et ``DELETE`` utilisées de manière non atomique(que), c'est à dire
avec le mécanisme de ``Zend_Db_Table``, peuvent laisser la base de données dans un état non désiré, ou état
intermédiaire. Supposez que vous supprimiez tous les enregistrements dépendants, pour finir par leur parent
unique. A un moment donnée, la base de donnée sera dans un état tel que le parent sera sans enfants, mais
toujours bel et bien présent. Si un autre client se connecte exactement à ce moment là, il va pouvoir requêter
éventuellement le parent, en croyant que celui-ci n'a plus d'enfant, ce qui normalement n'est pas le cas. Il est
alors totalement impossible pour ce client là de se rendre compte qu'il a effectuer une lecture au beau milieu
d'une plus vaste opération d'effacement.

Les problèmes de changements non-atomique peuvent être anéantis en utilisant les transactions isolantes, c'est
d'ailleurs un de leur rôle clé. Cependant certains SGBDs ne supportent pas encore les transactions, et autorisent
leurs clients à lire des changements incomplets pas validés en totalité.

**Les opérations de cascades de Zend_Db_Table ne sont utilisées que par Zend_Db_Table.**

Les cascades pour ``DELETE`` et ``UPDATE`` définies dans vos classes ``Zend_Db_Table`` ne sont utilisées que lors
du recours aux méthodes ``save()`` ou ``delete()`` sur les enregistrements *Row*. Si vous utilisez une autre
interface pour vos ``UPDATE`` ou ``DELETE``, comme par exemple un outil de requêtes, ou une autre application, les
opérations de cascades ne sont bien sûr pas appliquées. C'est même le cas si vous utilisez les méthodes
``update()`` et ``delete()`` dans la classe ``Zend_Db_Adapter``.

**Pas d'INSERT en cascade**

Le support pour les cascades d'``INSERT`` n'est pas assuré. Vous devez explicitement insérer les enregistrements
dépendants à un enregistrement parent.


