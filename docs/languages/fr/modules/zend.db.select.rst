.. _zend.db.select:

Zend_Db_Select
==============

.. _zend.db.select.introduction:

Introduction
------------

L'objet ``Zend_Db_Select`` représente une instruction de requête *SQL* de type ``SELECT``. La classe a des
méthodes pour ajouter différentes parties à la requête. Vous pouvez indiquer quelques parties de la requête en
utilisant des structures de données et des méthodes de *PHP*, et la classe forme la syntaxe correcte de *SQL*
pour vous. Après avoir construit une requête, vous pouvez l'exécuter comme si vous l'aviez écrite comme une
chaîne de caractères.

Les possibilités offertes par ``Zend_Db_Select`` inclut :

- des méthodes orientées objet pour spécifier des requêtes *SQL* morceau par morceau ;

- l'abstraction de certaines parties de la requête *SQL* indépendamment de la base de données ;

- l'échappement automatique des identificateurs de méta-données dans la plupart des cas, pour supporter les
  identificateurs contenant les mots réservés *SQL* et les caractères spéciaux ;

- l'échappement des identificateurs et des valeurs, afin de réduire les risques d'attaques par injection *SQL*.

L'utilisation de ``Zend_Db_Select`` n'est pas obligatoire. Pour de très simple requêtes SELECT , il est
d'habitude plus simple de spécifier la requête *SQL* entière comme une chaîne et l'exécuter en utilisant des
méthodes de l'adaptateur comme ``query()`` ou ``fetchAll()``. L'utilisation de ``Zend_Db_Select`` est utile si
vous devez assembler une requête SELECT par procédure, ou basé sur une logique conditionnelle dans votre
application.

.. _zend.db.select.creating:

Créer un objet Select
---------------------

Vous pouvez créer une instance d'un objet ``Zend_Db_Select`` en utilisant la méthode ``select()`` de l'objet
``Zend_Db_Adapter_Abstract``.

.. _zend.db.select.creating.example-db:

.. rubric:: Exemple d'utilisation de la méthode select()

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory( ...options... );
   $select = $db->select();

Une autre manière de créer un objet ``Zend_Db_Select`` est avec son constructeur, en indiquant l'adaptateur de
base de données comme argument.

.. _zend.db.select.creating.example-new:

.. rubric:: Exemple de création d'un nouvel objet Select

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory( ...options... );
   $select = new Zend_Db_Select($db);

.. _zend.db.select.building:

Construction de requêtes Select
-------------------------------

En construisant la requête, vous pouvez ajouter des clauses à la requête une par une. Il y a une méthode
séparée pour ajouter chaque clause à l'objet ``Zend_Db_Select``.

.. _zend.db.select.building.example:

.. rubric:: Exemple d'utilisation des méthodes d'ajout de clauses

.. code-block:: php
   :linenos:

   // Créer un objet Zend_Db_Select
   $select = $db->select();

   // Ajouter une clause FROM
   $select->from( ...spécifiez une table et des colonnes... )

   // Ajouter une clause WHERE
   $select->where( ...spécifiez des critères de recherche... )

   // Ajouter une clause ORDER BY
   $select->order( ...spécifiez des critères de tri... );

Vous pouvez également employer la plupart des méthodes de l'objet Zend_Db_Select avec une interface fluide et
simple. Une `interface fluide`_ signifie que chaque méthode renvoie une référence à l'objet qui a été
appelé, ainsi vous pouvez immédiatement appeler une autre méthode.

.. _zend.db.select.building.example-fluent:

.. rubric:: Exemple d'utilisation de l'interface fluide

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from( ...spécifiez une table et des colonnes... )
                ->where( ...spécifiez des critères de recherche... )
                ->order( ...spécifiez des critères de tri... );

Les exemples de cette section montrent l'utilisation de l'interface fluide, mais vous pouvez employer une interface
non-fluide dans tous les cas. Il est souvent nécessaire d'employer l'interface non-fluide, par exemple, si votre
application doit exécuter de la logique avant d'ajouter une clause à une requête.

.. _zend.db.select.building.from:

Ajouter une clause FROM
^^^^^^^^^^^^^^^^^^^^^^^

Indiquez la table pour la requête en utilisant la méthode ``from()``. Vous pouvez indiquer le nom de table comme
une chaîne de caractères. ``Zend_Db_Select`` applique l'échappement des identificateurs autour du nom de table,
ainsi vous pouvez employer les caractères spéciaux.

.. _zend.db.select.building.from.example:

.. rubric:: Exemple d'utilisation de la méthode from()

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT *
   //   FROM "produits"

   $select = $db->select()
                ->from( 'produits' );

Vous pouvez également indiquer le nom de corrélation (parfois appelé "l'alias de table") pour une table. Au lieu
d'une chaîne de caractère simple, employez un tableau associatif faisant correspondre le nom de corrélation au
nom de table. Dans d'autres clauses de la requête *SQL*, employez ce nom de corrélation. Si votre requête
réalise des jointures sur plus d'une table, ``Zend_Db_Select`` produit des noms uniques de corrélation basés sur
les noms de table, pour chaque table pour lesquelles vous n'indiquez pas le nom de corrélation.

.. _zend.db.select.building.from.example-cname:

.. rubric:: Exemple d'utilisation d'un alias de nom de table

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT p.*
   //   FROM "produits" AS p

   $select = $db->select()
                ->from( array('p' => 'produits') );

Certaines marques de SGBDR supportent un spécificateur de schéma principal pour une table. Vous pouvez spécifiez
un nom de table comme "*nomDuSchema.nomDeTable*", où ``Zend_Db_Select`` échappera chaque partie individuellement,
ou vous pouvez spécifier le nom du schéma séparément. Un nom de schéma spécifié dans le nom de table sera
prioritaire sur un schéma fourni séparément dans les cas où les deux seraient fournis.

.. _zend.db.select.building.from.example-schema:

.. rubric:: Exemple d'utilisation d'un nom de schéma

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT *
   //   FROM "monschema"."produits"

   $select = $db->select()
                ->from( 'monschema.produits' );

   // ou

   $select = $db->select()
                ->from('produits', '*', 'monschema');

.. _zend.db.select.building.columns:

Ajouter des colonnes
^^^^^^^^^^^^^^^^^^^^

Dans le deuxième argument de la méthode ``from()``, vous pouvez indiquer les colonnes à choisir parmi les tables
respectives. Si vous n'indiquez aucune colonne, la valeur par défaut est "***", la caractère de remplacement
*SQL* pour "toutes les colonnes".

Vous pouvez énumérer les colonnes dans un tableau simple de chaîne de caractère, ou en tant que tableau
associatif faisant correspondre l'alias de la colonne au nom de la colonne. Si vous avez seulement une colonne à
requêter, et vous n'avez pas besoin d'indiquer un alias de colonne, vous pouvez l'énumérer comme une chaîne
simple au lieu d'un tableau.

Si vous passez un tableau comme argument pour les colonnes, aucune colonne pour la table correspondante ne sera
inclus dans le jeu de résultat. Voir un :ref:`exemple de code <zend.db.select.building.join.example-no-columns>`
sous la section concernant la méthode ``join()``.

Vous pouvez indiquer le nom de colonne en tant que "*aliasDeTable.nomDeColonne*". ``Zend_Db_Select`` échappera
chaque partie individuellement. Si vous n'indiquez pas un nom d'alias pour une colonne, elle emploie le nom de
corrélation de la table nommée dans la méthode courante ``from()``.

.. _zend.db.select.building.columns.example:

.. rubric:: Exemples de spécification de colonnes

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT p."produit_id", p."produit_nom"
   //   FROM "produits" AS p

   $select = $db->select()
                ->from(array('p' => 'produits'),
                       array('produit_id', 'produit_nom'));

   // Construire la même requête, en spécifiant l'alias de table :
   //   SELECT p."produit_id", p."produit_nom"
   //   FROM "produits" AS p

   $select = $db->select()
                ->from(array('p' => 'produits'),
                       array('p.produit_id', 'p.produit_nom'));

   // Construire cette requête avec un alias pour une colonne :
   //   SELECT p."produit_id" AS prodno, p."produit_nom"
   //   FROM "produits" AS p

   $select = $db->select()
                ->from(array('p' => 'produits'),
                       array('prodno' => 'produit_id', 'produit_nom'));

.. _zend.db.select.building.columns-expr:

Ajouter une expression de colonne
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les colonnes dans les requêtes *SQL* sont parfois des expressions, pas simplement des noms de colonnes d'une
table. Les expressions peuvent avoir des noms d'alias ou peuvent nécessiter d'être échappées. Si la chaîne de
caractère désignant votre colonne contient des parenthèses, ``Zend_Db_Select`` la reconnaît comme une
expression.

Vous pouvez aussi créer un objet de type ``Zend_Db_Expr`` explicitement, pour éviter qu'une chaîne soit traitée
comme un nom de colonne. ``Zend_Db_Expr`` est une classe minimale qui contient une unique chaîne de caractère.
``Zend_Db_Select`` reconnaît les objets de type ``Zend_Db_Expr`` et les convertit en chaînes de caractères, mais
n'applique aucun changement, tel qu'un échappement ou un alias.

.. note::

   Utiliser ``Zend_Db_Expr`` pour les noms de colonnes n'est pas nécessaire si votre expression de colonne
   contient des parenthèses ; ``Zend_Db_Select`` reconnaît les parenthèses et traite la chaîne comme une
   expression en omettant l'échappement et les alias.

.. _zend.db.select.building.columns-expr.example:

.. rubric:: Exemples d'utilisation de colonnes contenant des expressions

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT p."produit_id", LOWER(produit_nom)
   //   FROM "produits" AS p
   // Une expression avec parenthèses devient implicitement
   // un objet Zend_Db_Expr.

   $select = $db->select()
                ->from(array('p' => 'produits'),
                       array('produit_id', 'LOWER(produit_nom)'));

   // Construire cette requête :
   //   SELECT p."produit_id", (p.prix * 1.08) AS prix_avec_taxe
   //   FROM "produits" AS p

   $select = $db->select()
                ->from(array('p' => 'produits'),
                       array('produit_id',
                             'prix_avec_taxe' => '(p.prix * 1.08)'));

   // Construire cette requête en utilisant explicitement Zend_Db_Expr :
   //   SELECT p."produit_id", p.prix * 1.08 AS prix_avec_taxe
   //   FROM "produits" AS p

   $select = $db->select()
                ->from(array('p' => 'produits'),
                       array('produit_id',
                             'prix_avec_taxe' =>
                                   new Zend_Db_Expr('p.prix * 1.08')));

Dans les cas ci-dessus, ``Zend_Db_Select`` ne change pas la chaîne pour appliquer des alias ou échapper les
identificateurs. Si ces changements sont nécessaires pour résoudre l'ambiguïté, vous devez faire manuellement
les changements dans la chaîne de caractères.

Si vos noms de colonne sont des mots-clés de *SQL* ou contiennent les caractères spéciaux, vous devriez employer
la méthode ``quoteIdentifier()`` de l'adaptateur et interpoler le résultat dans la chaîne de caractères. La
méthode ``quoteIdentifier()`` utilise l'échappement *SQL* pour délimiter les identificateurs, qui indique
clairement que c'est un identificateur pour une table ou une colonne, et non n'importe quelle autre partie de la
syntaxe de *SQL*.

Votre code est plus indépendant du SGBDR si vous utilisez la méthode ``quoteIdentifier()`` au lieu d'échapper
littéralement dans votre chaîne, car quelques marques de SGBDR utilisent des symboles non standards pour
échapper les identificateurs. La méthode ``quoteIdentifier()`` est conçue pour utiliser le symbole
d'échappement approprié basé sur le type d'adaptateur. La méthode ``quoteIdentifier()`` échappe aussi tout
caractère d'échappement qui apparaissent dans l'identificateur lui-même.

.. _zend.db.select.building.columns-quoteid.example:

.. rubric:: Exemples d'échappement de colonnes dans une expression

.. code-block:: php
   :linenos:

   // Construire cette requête, en échappant une colonne spéciale
   // nommée "from" dans une expression :
   //   SELECT p."from" + 10 AS origine
   //   FROM "produits" AS p

   $select = $db->select()
                ->from(array('p' => 'produits'),
                       array('origine' => '(p.'
                                        . $db->quoteIdentifier('from')
                                        . ' + 10)'));

.. _zend.db.select.building.columns-atomic:

Ajouter des colonnes à une table FROM ou JOIN existante
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Il peut y avoir des cas où vous souhaitez ajouter des colonnes à une table FROM ou JOIN existante après que ces
méthodes aient été appelées. La méthode ``columns()`` vous permet d'ajouter des colonnes spécifiques à
n'importe quel moment avant que la requête ne soit exécutée. Vous pouvez fournir les colonnes en tant qu'une
chaîne de caractères, une ``Zend_Db_Expr`` ou un tableau de ces derniers. Le second argument de cette méthode
peut être omis, impliquant que les colonnes sont ajoutées à la table FROM, sinon un alias déjà défini doit
être utilisé.

.. _zend.db.select.building.columns-atomic.example:

.. rubric:: Exemples d'ajout de colonnes avec la méthode ``columns()``

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT p."produit_id", p."produit_nom"
   //   FROM "produits" AS p

   $select = $db->select()
                ->from(array('p' => 'produits'), 'produit_id')
                ->columns('produit_nom');

   // Construire la même requête, en spécifiant l'alias :
   //   SELECT p."produit_id", p."produit_nom"
   //   FROM "produits" AS p

   $select = $db->select()
                ->from(array('p' => 'produits'), 'p.produit_id')
                ->columns('produit_nom', 'p');
                // Ou alternativement columns('p.produit_nom')

.. _zend.db.select.building.join:

Ajouter une autre table à la requête avec JOIN
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Beaucoup de requêtes utiles impliquent l'utilisation de ``JOIN`` pour combiner les lignes issues de tables
multiples. Vous pouvez ajouter des tables à une requête en utilisant la méthode ``join()``. L'utilisation de
cette méthode est similaire à la méthode ``from()``, excepté que vous pouvez aussi spécifier une condition
join dans la plupart des cas.

.. _zend.db.select.building.join.example:

.. rubric:: Exemple d'utilisation de la méthode join()

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT p."produit_id", p."produit_nom", l.*
   //   FROM "produits" AS p JOIN "ligne_items" AS l
   //     ON p.produit_id = l.produit_id

   $select = $db->select()
                ->from(array('p' => 'produits'),
                       array('produit_id', 'produit_nom'))
               ->join(array('l' => 'ligne_items'),
                      'p.produit_id = l.produit_id');

Le deuxième argument de ``join()`` est une chaîne qui représente la condition join. C'est une expression qui
déclare les critères par lesquels les lignes d'une table correspondent aux lignes dans une autre table. Vous
pouvez utiliser un nom d'alias dans cette expression.

.. note::

   Aucun échappement n'est appliqué à une expression que vous spécifiez pour une condition join ; si vous avez
   des noms de colonnes qui nécessitent d'être échappées, vous devez utiliser ``quoteIdentifier()`` quand vous
   préparez la chaîne pour une condition join.

Le troisième argument de ``join()`` est un tableau des noms de colonnes, comme c'est utilisé dans la méthode
``from()``. La valeur par défaut est "***", la méthode supporte les alias, les expressions, et les objets
``Zend_Db_Expr`` de la même manière que le tableau de noms de colonnes de la méthode ``from()``.

Pour ne choisir aucune colonne à partir d'une table, utilisez un tableau vide pour la liste de colonnes. Cette
utilisation fonctionnerait aussi avec la méthode ``from()``, mais typiquement vous pouvez avoir besoin de colonnes
issues de la table primaire dans vos requêtes, tandis que vous pourriez ne vouloir aucune colonne de la table
jointe.

.. _zend.db.select.building.join.example-no-columns:

.. rubric:: Exemple avec aucune colonne spécifiée

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT p."produit_id", p."produit_nom"
   //   FROM "produits" AS p JOIN "ligne_items" AS l
   //     ON p.produit_id = l.produit_id

   $select = $db->select()
                ->from(array('p' => 'produits'),
                       array('produit_id', 'produit_name'))
                ->join(array('l' => 'ligne_items'),
                       'p.produit_id = l.produit_id',
                       array() ); // liste de colonnes vide

Notez le tableau vide (``array()``) dans l'exemple ci-dessus à la place de la liste de colonnes de la table
jointe.

Le *SQL* a plusieurs types de jointures. Voyez la liste ci-dessous des méthodes supportant les différents types
de jointures dans ``Zend_Db_Select``.

- ``INNER JOIN`` avec les méthodes *join(table, jointure, [colonnes])* ou *joinInner(table, jointure,
  [colonnes])*.

  Ceci est le type de jointure le plus commun. Les lignes de chaque table sont comparées en utilisant la condition
  join spécifiée. Le résultat inclut seulement les lignes qui vérifient la condition join. Le résultat peut
  être vide si aucune ligne ne satisfait la condition.

  Tous les marques de SGBDR supportent ce type de jointure.

- ``LEFT JOIN`` avec la méthode *joinLeft(table, condition, [colonnes])*.

  Toutes les lignes issues de la table opérande de gauche sont inclues, les lignes correspondantes de la table de
  droite sont inclues, et les colonnes de la table opérande de droite sont remplies de NULL si aucune ligne
  existante ne correspond à la table de gauche.

  Tous les marques de SGBDR supportent ce type de jointure.

- ``RIGHT JOIN`` avec la méthode *joinRight(table, condition, [colonnes])*.

  La jointure étrangère droite est le complément de la jointure étrangère gauche. Toutes les lignes issues de
  la table opérande de droite sont inclues, les lignes correspondantes de la table de gauche sont inclues, et les
  colonnes de la table opérande de gauche sont remplies de NULL si aucune ligne existante ne correspond à la
  table de droite.

  Certaines marques de SGBDR ne supportent pas ce type de jointure, mais en général toute jointure droite peut
  être représentée comme une jointure gauche en inversant l'ordre des tables.

- ``FULL JOIN`` avec la méthode *joinFull(table, condition, [colonnes])*.

  Une jointure étrangère complète est comme la combinaison d'une jointure étrangère gauche et d'une jointure
  étrangère droite. Toutes les lignes des deux tables sont inclues, appairées ensemble dans la même ligne de
  résultat si elles satisfont la condition de jointure, et sinon appairées avec des valeurs NULL à la place des
  colonnes de l'autre table.

  Certaines marques de SGBDR ne supportent pas ce type de jointure.

- ``CROSS JOIN`` avec la méthode *joinCross(table, [colonnes])*.

  Une jointure croisée est un produit cartésien. Chaque ligne de la première table est assortie avec chaque
  ligne de la seconde. Ainsi le nombre de lignes du résultat est équivalent au produit du nombre de lignes de
  chacune des tables. Vous pouvez filtrer le résultat en utilisant une clause WHERE ; dans ce cas une jointure
  croisée est semblable à l'ancienne syntaxe de jointure SQL-89.

  La méthode ``joinCross()`` n'a pas de paramètres pour spécifier la condition de jointure. Certaines marques de
  SGBDR ne supportent pas ce type de jointure.

- ``NATURAL JOIN`` avec la méthode ``joinNatural(table, [colonnes])``.

  Une jointure naturelle compare chaque(s) colonne(s) qui apparaissent avec le même nom dans les deux tables. La
  comparaison est l'égalité pour toute(s) la(es) colonne(s) ; la comparaison des colonnes utilisant l'inégalité
  n'est pas une jointure naturelle. Seules les jointures internes (NdT : INNER) naturelles sont supportées par
  cette *API*, même si la syntaxe *SQL* permet aussi bien des jointures naturelles étrangères (NdT : OUTER).

  La méthode ``joinNatural()`` n'a pas de paramètres pour spécifier la condition de jointure.

En plus de ces méthodes join, vous pouvez simplifier vos requêtes en utilisant les méthodes de type
*join\*Using*. Au lieu de fournir une condition complète à votre jointure, vous fournissez simplement le nom de
la colonne sur laquelle réaliser la jointure et l'objet ``Zend_Db_Select`` complète la condition pour vous.

.. _zend.db.select.building.joinusing.example:

.. rubric:: Exemple avec la méthode ``joinUsing()``

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT *
   //   FROM "table1"
   //   JOIN "table2"
   //   ON "table1".colonne1 = "table2".colonne1
   //   WHERE colonne2 = 'foo'

   $select = $db->select()
                ->from('table1')
                ->joinUsing('table2', 'colonne1')
                ->where('column2 = ?', 'foo');

Chacune des méthodes join applicables du composant ``Zend_Db_Select`` possède une méthode correspondante
"using".

- ``joinUsing(table, join, [columns])`` et ``joinInnerUsing(table, join, [columns])``

- ``joinLeftUsing(table, join, [columns])``

- ``joinRightUsing(table, join, [columns])``

- ``joinFullUsing(table, join, [columns])``

.. _zend.db.select.building.where:

Ajouter une clause WHERE
^^^^^^^^^^^^^^^^^^^^^^^^

Vous pouvez spécifier des critères pour restreindre le nombre de lignes du résultat en utilisant la méthode
``where()``. Le premier argument de cette méthode est une expression *SQL*, et cette expression est utilisée dans
une clause ``WHERE`` dans la requête.

.. _zend.db.select.building.where.example:

.. rubric:: Exemple d'utilisation de la méthode where()

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT produit_id, produit_nom, prix
   //   FROM "produits"
   //   WHERE prix > 100.00

   $select = $db->select()
                ->from('produits',
                       array('produit_id', 'produit_nom', 'prix'))
                ->where('prix > 100.00');

.. note::

   Aucun échappement n'est appliqué aux expressions passées aux méthodes ``where()`` ou ``orWhere()``. Si vous
   avez des noms de colonnes qui nécessitent d'être échappés, vous devez utiliser ``quoteIdentifier()`` quand
   vous générez la chaîne pour la condition.

Le second argument de la méthode ``where()`` est optionnel. C'est une valeur à substituer dans l'expression.
``Zend_Db_Select`` échappe cette valeur et la substitue au caractère point ("*?*") d'interrogation dans
l'expression.

.. _zend.db.select.building.where.example-param:

.. rubric:: Exemple d'un paramètre dans la méthode where()

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT produit_id, produit_nom, prix
   //   FROM "produits"
   //   WHERE (prix > 100.00)

   $prixminimum = 100;

   $select = $db->select()
                ->from('produits',
                       array('produit_id', 'produit_nom', 'prix'))
                ->where('prix > ?', $prixminimum);

Vous pouvez fournir un tableau en tant que second paramètre de la méthode ``where()`` quand vous utilisez
l'opérateur SQL "IN".

.. _zend.db.select.building.where.example-array:

.. rubric:: Exemple d'un paramètre de type tableau pour la méthode where()

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT produit_id, produit_nom, prix
   //   FROM "produits"
   //   WHERE (produit_id IN (1, 2, 3))

   $productIds = array(1, 2, 3);

   $select = $db->select()
                ->from('produits',
                       array('produit_id', 'produit_nom', 'prix'))
                ->where('produit_id IN (?)', $productIds);

Vous pouvez appeler la méthode ``where()`` plusieurs fois sur la même objet ``Zend_Db_Select``. La requête
résultante combine les différents termes ensemble en utilisant ``AND`` entre eux.

.. _zend.db.select.building.where.example-and:

.. rubric:: Exemple avec plusieurs appels de where()

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT produit_id, produit_nom, prix
   //   FROM "produits"
   //   WHERE (prix > 100.00)
   //     AND (prix < 500.00)

   $prixminimum = 100;
   $prixmaximum = 500;

   $select = $db->select()
                ->from('produits',
                       array('produit_id', 'produit_nom', 'prix'))
                ->where('prix > ?', $prixminimum)
                ->where('prix < ?', $prixmaximum);

Si vous devez combiner ensemble des termes en utilisant *OR*, utilisez la méthode ``orWhere()``. Cette méthode
est utilisée de la même manière que la méthode ``where()``, excepté que le terme spécifié est précédé par
*OR*, au lieu de ``AND``.

.. _zend.db.select.building.where.example-or:

.. rubric:: Exemple d'utilisation de la méthode orWhere()

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT produit_id, produit_nom, prix
   //   FROM "produits"
   //   WHERE (prix < 100.00)
   //     OR (prix > 500.00)

   $prixminimum = 100;
   $prixmaximum = 500;

   $select = $db->select()
                ->from('produits',
                       array('produit_id', 'produit_nom', 'prix'))
                ->where('prix < ?', $prixminimum)
                ->orWhere('prix > ?', $prixmaximum);

``Zend_Db_Select`` met automatiquement des parenthèses autour de chaque expression spécifiée en utilisant les
méthodes ``where()`` ou ``orWhere()``. Ceci permet de s'assurer que la priorité de l'opérateur booléen
n'entraîne pas de résultats inattendus.

.. _zend.db.select.building.where.example-parens:

.. rubric:: Exemple de mise en parenthèse d'expressions booléennes

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT produit_id, produit_nom, prix
   //   FROM "produits"
   //   WHERE (prix < 100.00 OR prix > 500.00)
   //     AND (produit_nom = 'Pomme')

   $prixminimum = 100;
   $prixmaximum = 500;
   $prod = 'Pomme';

   $select = $db->select()
                ->from('produits',
                       array('produit_id', 'produit_nom', 'prix'))
                ->where("prix < $prixminimum OR prix > $prixmaximum")
                ->where('produit_nom = ?', $prod);

Dans l'exemple ci-dessus, le résultat serait tout à fait différent sans parenthèses, car ``AND`` a une plus
grande priorité que *OR*. ``Zend_Db_Select`` applique les parenthèses avec pour effet de relier de manière plus
étroite chaque expression dans les appels successifs de ``where()`` qu'avec ``AND`` qui combine les expressions.

.. _zend.db.select.building.group:

Ajouter une clause GROUP BY
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Dans la syntaxe *SQL*, la clause *GROUP BY* vous permet de réduire le nombre de lignes du résultat de la requête
à une ligne par valeur unique trouvé dans une(des) colonne(s) nommées) dans la clause *GROUP BY*.

Dans ``Zend_Db_Select``, vous pouvez spécifier la(es) colonne(s) à utiliser pour calculer les groupes de lignes
en utilisant la méthode ``group()``. L'argument de cette méthode est une colonne ou un tableau de colonnes à
utiliser dans la clause *GROUP BY*.

.. _zend.db.select.building.group.example:

.. rubric:: Exemple d'utilisation de la méthode group()

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT p."produit_id", COUNT(*) AS ligne_items_par_produit
   //   FROM "produits" AS p JOIN "ligne_items" AS l
   //     ON p.produit_id = l.produit_id
   //   GROUP BY p.produit_id

   $select = $db->select()
                ->from(array('p' => 'produits'),
                       array('produit_id'))
                ->join(array('l' => 'ligne_items'),
                       'p.produit_id = l.produit_id',
                       array('ligne_items_par_produit' => 'COUNT(*)'))
               ->group('p.produit_id');

Comme le tableau de colonnes de la méthode ``from()``, vous pouvez utiliser des noms d'alias dans le nom de la
colonne, et la colonne est échappée comme un identificateur à moins que la chaîne ne contiennent des
parenthèses ou que ce soit un objet de type ``Zend_Db_Expr``.

.. _zend.db.select.building.having:

Ajouter une clause HAVING
^^^^^^^^^^^^^^^^^^^^^^^^^

Dans la syntaxe *SQL*, la clause ``HAVING`` applique une restriction sur un groupe de lignes. Ceci est similaire à
la manière dont la clause ``WHERE`` applique une restriction sur des lignes. Mais les deux clauses sont
différentes car les conditions ``WHERE`` sont appliquées avant que les groupes de lignes ne soient définis,
alors que les conditions ``HAVING`` sont appliquées après que les groupes aient été définis.

Dans ``Zend_Db_Select``, vous pouvez spécifier des conditions pour restreindre des groupes en utilisant la
méthode ``having()``. Son utilisation est similaire à celle de la méthode ``where()``. Le premier argument est
une chaîne contenant une expression *SQL*. Le second argument facultatif est une valeur qui est utilisé pour
remplacer le caractère de substitution positionné dans l'expression *SQL*. Les expressions passées dans de
multiples appels de la méthode ``having()`` sont combinées en utilisant l'opérateur booléen ``AND``, ou
l'opérateur *OR* si vous utilisez la méthode ``orHaving()``.

.. _zend.db.select.building.having.example:

.. rubric:: Exemple d'utilisation de la méthode having()

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT p."produit_id", COUNT(*) AS ligne_items_par_produit
   //   FROM "produits" AS p JOIN "ligne_items" AS l
   //     ON p.produit_id = l.produit_id
   //   GROUP BY p.produit_id
   //   HAVING ligne_items_par_produit > 10

   $select = $db->select()
                ->from(array('p' => 'produits'),
                       array('produit_id'))
                ->join(array('l' => 'ligne_items'),
                       'p.produit_id = l.produit_id',
                       array('ligne_items_par_produit' => 'COUNT(*)'))
                ->group('p.produit_id')
                ->having('ligne_items_par_produit > 10');

.. note::

   Aucun échappement n'est appliqué aux expressions fournies aux méthodes ``having()`` ou ``orHaving()``. Si
   vous avez des noms de colonnes qui nécessitent d'être échappées, vous devez utiliser ``quoteIdentifier()``
   quand vous générez la chaîne de cette condition.

.. _zend.db.select.building.order:

Ajouter une clause ORDER BY
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Dans la syntaxe *SQL*, la clause *ORDER BY* spécifie une ou plusieurs colonnes ou expressions suivant lesquelles
le résultat d'une requête doit être trié. Si plusieurs colonnes sont listées, les colonnes secondaires sont
utilisées pour résoudre les égalités ; l'ordre du tri est déterminé par les colonnes secondaires si les
colonnes précédentes contiennent des valeurs identiques. Le tri par défaut est ascendant (du plus petit vers le
plus grand). Vous pouvez aussi appliqué un tri descendant (du plus grand vers le plus petit) pour une colonne en
spécifiant le mot-clé ``DESC`` après la colonne.

Dans ``Zend_Db_Select``, vous pouvez utiliser la méthode ``order()`` pour spécifier une colonne ou un tableau de
colonnes par lesquelles vous voulez trier. Chaque élément du tableau est une chaîne nommant une colonne,
facultativement suivi les mots-clés ``ASC`` ou ``DESC`` en séparant avec un espace.

Comme pour les méthodes ``from()`` et ``group()``, les noms de colonnes sont échappées comme des
identificateurs, à moins qu'elles ne contiennent des parenthèses ou ne soient des objets de type
``Zend_Db_Expr``.

.. _zend.db.select.building.order.example:

.. rubric:: Exemple d'utilisation de la méthode order()

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT p."produit_id", COUNT(*) AS ligne_items_par_produit
   //   FROM "produits" AS p JOIN "ligne_items" AS l
   //     ON p.produit_id = l.produit_id
   //   GROUP BY p.produit_id
   //   ORDER BY "ligne_items_par_produit" DESC, "produit_id"

   $select = $db->select()
                ->from(array('p' => 'produits'),
                       array('produit_id'))
                ->join(array('l' => 'ligne_items'),
                       'p.produit_id = l.produit_id',
                       array('ligne_items_par_produit' => 'COUNT(*)'))
                ->group('p.produit_id')
                ->order(array('ligne_items_par_produit DESC',
                              'produit_id'));

.. _zend.db.select.building.limit:

Ajouter une clause LIMIT
^^^^^^^^^^^^^^^^^^^^^^^^

Certaines marques de SGBDR étendent la syntaxe *SQL* avec une clause ``LIMIT``. Cette clause réduit le nombre de
lignes d'un résultat à un nombre maximum que vous spécifiez. Vous pouvez de plus indiquer un nombre de lignes à
éviter avant de commencer à produire le résultat. Cette fonctionnalité facilite l'extraction d'un sous-ensemble
d'un résultat, par exemple quand vous affichez des résultats avec un défilement de pages.

Dans ``Zend_Db_Select``, vous pouvez utiliser la méthode ``limit()`` pour spécifier le nombre de lignes ainsi que
le nombre de lignes à omettre. Le premier argument de cette méthode est le nombre de lignes désirées. Le second
argument est le nombre de lignes à omettre.

.. _zend.db.select.building.limit.example:

.. rubric:: Exemple d'utilisation de la méthode limit()

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT p."produit_id", p."produit_nom"
   //   FROM "produits" AS p
   //   LIMIT 10, 20

   $select = $db->select()
                ->from(array('p' => 'produits'),
                       array('produit_id', 'produit_nom'))
                ->limit(10, 20);

.. note::

   La syntaxe ``LIMIT`` n'est pas supporté par toutes les marques de SGBDR. Quelques SGBDR nécessite une syntaxe
   différente pour supporter une fonctionnalité similaire. Chaque classe ``Zend_Db_Adapter_Abstract`` inclue une
   méthode pour produire le code *SQL* approprié à ce SGBDR.

Utilisez de manière alternative la méthode ``limitPage()`` pour spécifier le nombre de lignes et le décalage.
Cette méthode vous permet de limiter le jeu de résultats à une série d'un nombre fixé de résultats issus du
jeu total de résultats de la requête. En d'autres termes, vous spécifiez la taille de la "page" de résultats,
et le nombre ordinal de la page unique de résultats que vous souhaitez voir retourner par la requête. Le numéro
de la page est le premier argument de la méthode ``limitPage()``, et la taille de la page est le second argument.
Les deux arguments sont obligatoires ; ils n'ont pas de valeurs par défaut.

.. _zend.db.select.building.limit.example2:

.. rubric:: Exemple d'utilisation de la méthode limitPage()

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p
   //   LIMIT 10, 20

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->limitPage(2, 10);

.. _zend.db.select.building.distinct:

Ajouter le modificateur de requête DISTINCT
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La méthode ``distinct()`` vous permet d'ajouter le mot-clé ``DISTINCT`` à votre requête *SQL*.

.. _zend.db.select.building.distinct.example:

.. rubric:: Exemple d'utilisation de la méthode distinct()

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT DISTINCT p."produit_nom"
   //   FROM "produits" AS p

   $select = $db->select()
                ->distinct()
                ->from(array('p' => 'produits'), 'produit_nom');

.. _zend.db.select.building.for-update:

Ajouter le modificateur de requête FOR UPDATE
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La méthode ``forUpdate()`` vous permet d'ajouter le modificateur *FOR UPDATE* à votre requête *SQL*.

.. _zend.db.select.building.for-update.example:

.. rubric:: Exemple d'utilisation de la méthode forUpdate()

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT FOR UPDATE p.*
   //   FROM "produits" AS p

   $select = $db->select()
                ->forUpdate()
                ->from(array('p' => 'produits'));

.. _zend.db.select.building.union:

Construire une requête UNION
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Vous pouvez construire des requêtes de type union avec ``Zend_Db_Select`` en fournissant un tableau de
``Zend_Db_Select`` ou de chaînes de requêtes SQL à la méthode ``union()``. En second paramètre, vous pouvez
fournir les constantes ``Zend_Db_Select::SQL_UNION`` ou ``Zend_Db_Select::SQL_UNION_ALL`` pour spécifier le type
d'union que vous souhaitez réaliser.

.. _zend.db.select.building.union.example:

.. rubric:: Exemple avec la méthode union()

.. code-block:: php
   :linenos:

   $sql1 = $db->select();
   $sql2 = "SELECT ...";

   $select = $db->select()
       ->union(array($sql1, $sql2))
       ->order("id");

.. _zend.db.select.execute:

Exécuter des requêtes Select
----------------------------

Cette section décrit comment exécuter une requête représentée par un objet ``Zend_Db_Select``.

.. _zend.db.select.execute.query-adapter:

Exécuter des requêtes Select à partir de l'adaptateur Db
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Vous pouvez exécuter la requête représentée par l'objet ``Zend_Db_Select`` en le passant comme premier argument
de la méthode ``query()`` d'un objet ``Zend_Db_Adapter_Abstract``. Utilisez les objets ``Zend_Db_Select`` plutôt
qu'une simple chaîne de requête.

La méthode ``query()`` retourne un objet de type ``Zend_Db_Statement`` ou *PDOStatement*, dépendant du type
d'adaptateur.

.. _zend.db.select.execute.query-adapter.example:

.. rubric:: Exemple d'utilisation de la méthode query() de l'adaptateur Db

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('produits');

   $stmt = $db->query($select);
   $result = $stmt->fetchAll();

.. _zend.db.select.execute.query-select:

Exécuter des requêtes Select à partir de objet Select
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Comme alternative à l'emploi de la méthode ``query()``\ de l'objet adaptateur, vous pouvez utiliser la méthode
``query()`` de l'objet ``Zend_Db_Select``. Les deux méthodes retourne un objet de type ``Zend_Db_Statement`` ou
*PDOStatement*, dépendant du type d'adaptateur.

.. _zend.db.select.execute.query-select.example:

.. rubric:: Exemple d'utilisation de la méthode query() de l'objet Select

.. code-block:: php
   :linenos:

   $select = $db->select()
       ->from('produits');

   $stmt = $select->query();
   $result = $stmt->fetchAll();

.. _zend.db.select.execute.tostring:

Convertir un objet Select en une chaîne SQL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Si vous devez accéder à la chaîne représentant la requête *SQL* correspondant à un objet ``Zend_Db_Select``,
utilisez la méthode ``__toString()``.

.. _zend.db.select.execute.tostring.example:

.. rubric:: Exemple d'utilisation de la méthode \__toString()

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('produits');

   $sql = $select->__toString();
   echo "$sql\n";

   // L'affichage est la chaîne :
   //   SELECT * FROM "produits"

.. _zend.db.select.other:

Autres méthodes
---------------

Cette section décrit les autres méthodes de la classe ``Zend_Db_Select`` qui ne sont pas couvertes ci-dessus :
``getPart()`` et ``reset()``.

.. _zend.db.select.other.get-part:

Récupérer des parties de l'objet Select
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La méthode ``getPart()`` retourne une représentation d'une partie de votre requête *SQL*. Par exemple, vous
pouvez utiliser cette méthode pour retourner un tableau d'expressions pour la clause ``WHERE``, ou un tableau de
colonnes (ou d'expressions de colonnes) qui sont dans l'élément ``SELECT``, ou les valeurs de nombre et de
décalage pour la clause ``LIMIT``.

La valeur retournée n'est pas une chaîne de caractère contenant un fragment de syntaxe *SQL*. La valeur
retournée est une représentation interne, qui est typiquement une structure de type tableau contenant des valeurs
et des expressions. Chaque partie de la requête a une structure différente.

L'argument unique de la méthode ``getPart()`` est une chaîne qui identifie quelle partie de la requête Select
doit être retournée. Par exemple, la chaîne "*from*" identifie la partie de l'objet Select qui stocke
l'information concernant les tables dans la clause ``FROM``, incluant les tables jointes.

La classe Zend_Db_Select définit des constantes que vous pouvez utiliser pour les parties de la requête *SQL*.
Vous pouvez utiliser ces constantes ou des chaînes de caractères littérales.

.. _zend.db.select.other.get-part.table:

.. table:: Constantes utilisées par getPart() et reset()

   +----------------------------+---------------------+
   |Constante                   |Chaîne correspondante|
   +============================+=====================+
   |Zend_Db_Select::DISTINCT    |'distinct'           |
   +----------------------------+---------------------+
   |Zend_Db_Select::FOR_UPDATE  |'forupdate'          |
   +----------------------------+---------------------+
   |Zend_Db_Select::COLUMNS     |'columns'            |
   +----------------------------+---------------------+
   |Zend_Db_Select::FROM        |'from'               |
   +----------------------------+---------------------+
   |Zend_Db_Select::WHERE       |'where'              |
   +----------------------------+---------------------+
   |Zend_Db_Select::GROUP       |'group'              |
   +----------------------------+---------------------+
   |Zend_Db_Select::HAVING      |'having'             |
   +----------------------------+---------------------+
   |Zend_Db_Select::ORDER       |'order'              |
   +----------------------------+---------------------+
   |Zend_Db_Select::LIMIT_COUNT |'limitcount'         |
   +----------------------------+---------------------+
   |Zend_Db_Select::LIMIT_OFFSET|'limitoffset'        |
   +----------------------------+---------------------+

.. _zend.db.select.other.get-part.example:

.. rubric:: Exemple d'utilisation de la méthode getPart()

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('produits')
                ->order('produit_id');

   // Vous pouvez spécifier une chaîne littérale
   $orderData = $select->getPart( 'order' );

   // Vous pouvez utiliser une constante
   $orderData = $select->getPart( Zend_Db_Select::ORDER );

   // La valeur retournée peut être une structure tableau, pas une chaîne.
   // Chaque partie a une structure différente
   print_r( $orderData );

.. _zend.db.select.other.reset:

Effacer des parties de l'objet Select
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La méthode ``reset()`` vous permet de vider une partie spécifique de la requête *SQL*, ou toutes les parties si
vous omettez l'argument.

L'argument unique est facultatif. Vous pouvez spécifier la partie de la requête à effacer, en utilisant les
mêmes chaînes que vous utilisez en tant qu'argument de la méthode ``getPart()``. La partie de la requête que
vous spécifiez est initialisée à l'état par défaut.

Si vous omettez le paramètre, ``reset()`` initialise toutes les parties de la requête à leurs valeurs par
défaut. Ceci rend l'objet Zend_Db_Select équivalent à un nouvel objet, comme si vous l'aviez tout juste
instancié.

.. _zend.db.select.other.reset.example:

.. rubric:: Exemple d'utilisation de la méthode reset()

.. code-block:: php
   :linenos:

   // Construire cette requête :
   //   SELECT p.*
   //   FROM "produits" AS p
   //   ORDER BY "produit_nom"

   $select = $db->select()
                ->from(array('p' => 'produits')
                ->order('produit_nom');

   // Changer la condition d'ordre avec une colonne différente :
   //   SELECT p.*
   //   FROM "produits" AS p
   //   ORDER BY "produit_id"

   // Vider la partie afin de la redéfinir
   $select->reset( Zend_Db_Select::ORDER );

   // Et spécifier une colonne différente
   $select->order('produit_id');

   // Vider toutes les parties de la requête
   $select->reset();



.. _`interface fluide`: http://en.wikipedia.org/wiki/Fluent_interface
