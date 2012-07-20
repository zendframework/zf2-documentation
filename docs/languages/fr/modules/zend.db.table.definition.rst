.. _zend.db.table.definition:

Zend_Db_Table_Definition
========================

.. _zend.db.table.definition.introduction:

Introduction
------------

``Zend_Db_Table_Definition`` est une classe qui peut être utilisée pour décrire les relations et les options de
configuration qui devraient être utilisées lorsque ``Zend_Db_Table`` est manipulée par instantiation concrête.

.. _zend.db.table.definition.usage:

Utilisation de base
-------------------

Les options décrites dans un objet de définition sont les mêmes que celles qu'utilisent les classes étendant
Zend_Db_Table_Abstract. Votre objet de définition peut alors être passé à la classe à l'instanciation,
celle-ci connaitra alors la définition de toutes les tables concernées.

Voici un exemple d'objet de définition qui va décrire les noms des tables et les relations entre les objets
supports de ces tables. Note: Si 'name' n'est pas précisé, la clé servira alors de nom à la table, c'est le cas
dans notre exemple avec 'genre'.

.. _zend.db.table.definition.example1:

.. rubric:: Décrire un modèle de base de données

.. code-block:: php
   :linenos:

   $definition = new Zend_Db_Table_Definition(array(
       'author' => array(
           'name' => 'author',
           'dependentTables' => array('book')
           ),
       'book' => array(
           'name' => 'book',
           'referenceMap' => array(
               'author' => array(
                   'columns' => 'author_id',
                   'refTableClass' => 'author',
                   'refColumns' => 'id'
                   )
               )
           ),
       'genre' => null,
       'book_to_genre' => array(
           'referenceMap' => array(
               'book' => array(
                   'columns' => 'book_id',
                   'refTableClass' => 'book',
                   'refColumns' => 'id'
                   ),
               'genre' => array(
                   'columns' => 'genre_id',
                   'refTableClass' => 'genre',
                   'refColumns' => 'id'
                   )
               )
           )
       ));

Comme vous le voyez, les mêmes options que vous utilisez en général en étendant Zend_Db_Table_Abstract sont
présentes dans ce tableau. Cette définition va **persister** vers toutes les tables qui seront créees par votre
objet, ceci assure une isolation et un bon fonctionnement.

Ci-après un exemple d'instanciation d'une table et de l'utilisation de findDependentRowset() et
findManyToManyRowset() qui vont correspondre au modèle de données:

.. _zend.db.table.definition.example2:

.. rubric:: Intéragir avec la définition utilisée

.. code-block:: php
   :linenos:

   $authorTable = new Zend_Db_Table('author', $definition);
   $authors = $authorTable->fetchAll();

   foreach ($authors as $author) {
       echo $author->id . ': ' . $author->first_name . ' ' . $author->last_name . PHP_EOL;
       $books = $author->findDependentRowset('book');
       foreach ($books as $book) {
           echo '    Book: ' . $book->title . PHP_EOL;
           $genreOutputArray = array();
           foreach ($book->findManyToManyRowset('genre', 'book_to_genre') as $genreRow) {
               $genreOutputArray[] = $genreRow->name;
           }
           echo '        Genre: ' . implode(', ', $genreOutputArray) . PHP_EOL;
       }
   }

.. _zend.db.table.definition.advanced-usage:

Utilisation avancée
-------------------

Quelques fois vous voudriez mixer les utilisations, via la définition et une extension concrête de
Zend_Db_Table_Abstract. Pour ce faire, omettez de spécifier une définition concernant la classe concrête.
Zend_Db_Table utiisera alors l'instance que vous lui passerez.

Dans l'exemple d'après, nous allons placer une des tables sous forme de classe concrête, et laisser les autres
sous forme de définitions. Nous allons voir alors comment les faire intéragir.

.. _zend.db.table.definition.example3:

.. rubric:: Mixer la définition et l'extension concrête

.. code-block:: php
   :linenos:

   class MyBook extends Zend_Db_Table_Abstract
   {
       protected $_name = 'book';
       protected $_referenceMap = array(
           'author' => array(
               'columns' => 'author_id',
               'refTableClass' => 'author',
               'refColumns' => 'id'
               )
           );
   }

   $definition = new Zend_Db_Table_Definition(array(
       'author' => array(
           'name' => 'author',
           'dependentTables' => array('MyBook')
           ),
       'genre' => null,
       'book_to_genre' => array(
           'referenceMap' => array(
               'book' => array(
                   'columns' => 'book_id',
                   'refTableClass' => 'MyBook',
                   'refColumns' => 'id'
                   ),
               'genre' => array(
                   'columns' => 'genre_id',
                   'refTableClass' => 'genre',
                   'refColumns' => 'id'
                   )
               )
           )
       ));

   $authorTable = new Zend_Db_Table('author', $definition);
   $authors = $authorTable->fetchAll();

   foreach ($authors as $author) {
       echo $author->id . ': ' . $author->first_name . ' ' . $author->last_name . PHP_EOL;
       $books = $author->findDependentRowset(new MyBook());
       foreach ($books as $book) {
           echo '    Book: ' . $book->title . PHP_EOL;
           $genreOutputArray = array();
           foreach ($book->findManyToManyRowset('genre', 'book_to_genre') as $genreRow) {
               $genreOutputArray[] = $genreRow->name;
           }
           echo '        Genre: ' . implode(', ', $genreOutputArray) . PHP_EOL;
       }
   }


