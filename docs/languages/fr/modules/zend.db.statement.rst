.. _zend.db.statement:

Zend_Db_Statement
=================

En plus des méthodes telles que ``fetchAll()`` et ``insert()`` documentée dans :ref:` <zend.db.adapter>`, vous
pouvez utiliser un objet statement pour l'analyser de manière plus complète et récupérer vos résultats. Cette
section décrit la marche à suivre pour obtenir un statement et utiliser ses méthodes propres.

Zend_Db_Statement est basé sur l'objet PDOStatement dans l'extension *PHP* `PHP Data Objects (PDO)`_.

.. _zend.db.statement.creating:

Créer un statement
------------------

Cet objet est typiquement retourné par la méthode ``query()`` de votre objet adaptateur de base de données.
Cette méthode prépare un statement *SQL*: le premier argument est une chaîne représentant la requête
préparée, le second, un tableau de paramètres liés.

.. _zend.db.statement.creating.example1:

.. rubric:: Création d'un objet statement avec query()

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE reported_by = ? AND bug_status = ?';
   $stmt = $db->query($sql, array('goofy', 'FIXED'));

L'objet statement représente un statement *SQL* qui a été préparé, et exécuté une fois avec les paramètres
de liaison ("bind") spécifiés. S'il s'agissait d'une requête SELECT par exemple, alors les résultats sont
prêts à être récupérés.

Vous pouvez créer un statement avec son constructeur, mais c'est assez peu usuel. Passez alors l'objet adaptateur
en premier argument, et la chaîne représentant la requête en second. Un fois construit, le statement est
préparé automatiquement, mais pas exécuté.

.. _zend.db.statement.creating.example2:

.. rubric:: Utilisation du constructeur de statement

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE reported_by = ? AND bug_status = ?';

   $stmt = new Zend_Db_Statement_Mysqli($db, $sql);

.. _zend.db.statement.executing:

Exécuter un statement
---------------------

Vous aurez besoin d'exécuter un statement si vous l'avez crée explicitement avec son constructeur. Utilisez sa
méthode ``execute()`` pour ceci. Le seul argument que cette méthode accepte est le tableau de "binds"
(paramètres préparés).

Si vous utilisez les **paramètres positionnés**, ceux utilisés avec le point d'interrogation (*?*), passez
simplement les valeurs dans le tableau.

.. _zend.db.statement.executing.example1:

.. rubric:: Exécuter un statement avec des paramètres positionnés

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE reported_by = ? AND bug_status = ?';

   $stmt = new Zend_Db_Statement_Mysqli($db, $sql);

   $stmt->execute(array('goofy', 'FIXED'));

Si vous utilisez les **paramètres nommés**, ceux définis avec un identifiant chaîne de caractère précédée
d'un (*:*), passez les valeurs liées sous forme de tableau associatif.

.. _zend.db.statement.executing.example2:

.. rubric:: Exécution d'un statement avec paramètres nommés

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs'
       . ' WHERE reported_by = :reporter'
       . ' AND bug_status = :status';

   $stmt = new Zend_Db_Statement_Mysqli($db, $sql);

   $stmt->execute(array(':reporter' => 'goofy', ':status' => 'FIXED'));

Les statements *PDO* acceptent les paramètres positionnés, ou nommés, mais pas les deux types en même temps.
Certaines classes Zend_Db_Statement pour les extensions non *PDO* peuvent ne supporter qu'un seul de ces types.

.. _zend.db.statement.fetching:

Récupérer des résultats depuis un statement SELECT
--------------------------------------------------

Vous disposez de méthodes sur l'objet statement lorsque celui-ci a été exécuté sur une requête *SQL* de type
SELECT, SHOW, DESCRIBE ou EXPLAIN (qui produisent des résultats). Aussi, INSERT, UPDATE et DELETE sont des
exemples de requêtes ne produisant pas de résultats. Vous pouvez donc les exécuter avec Zend_Db_Statement, mais
vous ne pourrez pas appeler les méthodes de récupération de résultats.

.. _zend.db.statement.fetching.fetch:

Récupérer un enregistrement unique depuis un statement
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La méthode ``fetch()`` permet de ne récupérer qu'un seul résultat dans le statement précédemment exécuté.
Trois paramètres sont disponibles pour cette méthode, tous optionnels :

- **Fetch style** en premier, permet de spécifier le mode de capture du résultat. C'est la structure dans
  laquelle celui-ci vous sera retourné. Voyez :ref:` <zend.db.adapter.select.fetch-mode>` pour une description des
  valeurs valides et de la forme des résultats alors renvoyés.

- **Cursor orientation** est le second paramètre. Par défaut il vaut ``Zend_Db::FETCH_ORI_NEXT``, ce qui signifie
  que chaque appel futur à ``fetch()`` retourne l'enregistrement suivant.

- **Offset**, en troisième paramètre. Si le paramètre "cursor orientation" est réglé sur
  ``Zend_Db::FETCH_ORI_ABS``, alors le numéro d'offset est le numéro du résultat à retourner, dans le
  statement. Si c'est ``Zend_Db::FETCH_ORI_REL``, le numéro d'offset est relatif à la position du curseur avant
  l'appel à ``fetch()``.

``fetch()`` retourne ``FALSE`` si il n'y a plus de résultats restants dans le statement.

.. _zend.db.statement.fetching.fetch.example:

.. rubric:: Utiliser fetch() dans une boucle

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT * FROM bugs');

   while ($row = $stmt->fetch()) {
       echo $row['bug_description'];
   }

Voyez aussi `PDOStatement::fetch()`_.

.. _zend.db.statement.fetching.fetchall:

Récupérer un jeu de résultat complet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Pour récupérer tous les résultats d'un statement, utilisez ``fetchAll()``. Ceci est équivalent à appeler
``fetch()`` dans un boucle et retourner tous les résultats dans un tableau. La méthode ``fetchAll()`` accepte
deux paramètres. Le premier est le mode de capture (fetch style), le deuxième est le numéro de la colonne à
retourner, si Zend_Db::FETCH_COLUMN est utilisé.

.. _zend.db.statement.fetching.fetchall.example:

.. rubric:: Utilisation de fetchAll()

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT * FROM bugs');

   $rows = $stmt->fetchAll();

   echo $rows[0]['bug_description'];

Voyez aussi `PDOStatement::fetchAll()`_.

.. _zend.db.statement.fetching.fetch-mode:

Changer le mode de capture (Fetch Mode)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Par défaut l'objet statement retourne les colonnes du jeu de résultat en tant que tableau associatif, en faisant
correspondre les noms des colonne et leur valeur. Vous pouvez cependant spécifier un format différent, comme il
est possible de faire avec la classe de l'adaptateur. La méthode ``setFetchMode()`` permet ceci. Indiquez un mode
de capture en utilisant les constantes de la classe Zend_Db : FETCH_ASSOC, FETCH_NUM, FETCH_BOTH, FETCH_COLUMN, et
FETCH_OBJ. Voyez :ref:` <zend.db.adapter.select.fetch-mode>` pour plus d'informations sur ces modes de capture. Les
appels suivants à ``fetch()`` ou ``fetchAll()`` utiliseront le mode spécifié auparavant.

.. _zend.db.statement.fetching.fetch-mode.example:

.. rubric:: Paramétrer le mode de capture (fetch mode)

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT * FROM bugs');

   $stmt->setFetchMode(Zend_Db::FETCH_NUM);

   $rows = $stmt->fetchAll();

   echo $rows[0][0];

Voyez aussi `PDOStatement::setFetchMode()`_.

.. _zend.db.statement.fetching.fetchcolumn:

Récupérer une colonne simple depuis un statement exécuté
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Pour retourner une colonne de résultat depuis un statement, utilisez la méthode ``fetchColumn()``. Le paramètre
optionnel est un entier représentant l'index de la colonne désirée, par défaut zéro. Cette méthode retourne
un type scalaire, ou ``FALSE`` s'il n'y a plus de résultats dans le statement.

Notez que cette méthode se comporte différemment de ``fetchCol()`` de l'adaptateur. La méthode ``fetchColumn()``
du statement retourne une seule valeur d'un seul résultat. ``fetchCol()`` de l'adaptateur retourne un tableau de
valeurs issues de la première colonne du jeu résultat.

.. _zend.db.statement.fetching.fetchcolumn.example:

.. rubric:: Utiliser fetchColumn()

.. code-block:: php
   :linenos:

   $sql = 'SELECT bug_id, bug_description, bug_status FROM bugs';

   $stmt = $db->query($sql);

   $bug_status = $stmt->fetchColumn(2);

Voyez aussi `PDOStatement::fetchColumn()`_.

.. _zend.db.statement.fetching.fetchobject:

Récupérer un résultat (Row) sous forme d'objet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Pour récupérer une ligne de résultat en tant qu'objet, depuis un statement exécuté, utilisez la méthode
``fetchObject()``. Celle-ci prend deux paramètres optionnels. Le premier est une chaîne indiquant le nom de la
classe que l'on souhaite se voir retourner, par défaut il s'agit de "*stdClass*". Le deuxième paramètre est un
tableau de paramètres qui sera passé au constructeur de cette classe.

.. _zend.db.statement.fetching.fetchobject.example:

.. rubric:: Utiliser fetchObject()

.. code-block:: php
   :linenos:

   $sql = 'SELECT bug_id, bug_description, bug_status FROM bugs';

   $stmt = $db->query($sql);

   $obj = $stmt->fetchObject();

   echo $obj->bug_description;

Voyez aussi `PDOStatement::fetchObject()`_.



.. _`PHP Data Objects (PDO)`: http://www.php.net/pdo
.. _`PDOStatement::fetch()`: http://www.php.net/PDOStatement-fetch
.. _`PDOStatement::fetchAll()`: http://www.php.net/PDOStatement-fetchAll
.. _`PDOStatement::setFetchMode()`: http://www.php.net/PDOStatement-setFetchMode
.. _`PDOStatement::fetchColumn()`: http://www.php.net/PDOStatement-fetchColumn
.. _`PDOStatement::fetchObject()`: http://www.php.net/PDOStatement-fetchObject
