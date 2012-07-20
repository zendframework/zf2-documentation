.. _zend.db.table.definition:

Zend_Db_Table_Definition
========================

.. _zend.db.table.definition.introduction:

Einführung
----------

``Zend_Db_Table_Definition`` ist eine Klasse die verwendet werden kann um Relationen und Optionen der Konfiguration
zu beschreiben die verwendet werden sollten wenn ``Zend_Db_Table`` über eine konkrete Instanz verwendet wird.

.. _zend.db.table.definition.usage:

Grundsätzliche Verwendung
-------------------------

Für alle gleichen Optionen die vorhanden sind wenn eine erweiterte ``Zend_Db_Table_Abstract`` Klasse konfiguriert
wird, sind diese Optionen auch vorhanden wenn eine Definitionsdatei beschrieben wird. Diese Definitionsdatei sollte
der Klasse zum Zeitpunkt der Instanziierung übergeben werden damit diese die komplette Definition aller Tabellen
in der besagten Definition kennt.

Anbei ist eine Definition welche die Tabellennamen und Relationen zwischen den Tabellen Objekten beschreibt.
Beachte: Wenn 'name' von der Definition ausgelassen wird, wird er als Schlüssel der definierten Tabelle genommen
(ein Beispiel hierfür ist die 'genre' Sektion im Beispiel anbei.)

.. _zend.db.table.definition.example1:

.. rubric:: Die Definition eines Datenbank Data Modells beschreiben

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

Wie man sieht sind die gleichen Optionen die man generell in einer erweiterten ``Zend_Db_Table_Abstract`` Klasse
sieht auch in diesem Array dokumentiert. Wenn es in den Constructor von ``Zend_Db_Table`` übergeben wird, ist
diese Definition **persistent** in jeder Tabelle die erstellt werden muß um die richtigen Zeilen zurückzugeben.

Anbei ist ein Beispiel der Instanziierung einer primären Tabelle sowie Aufrufe von ``findDependentRowset()`` und
``findManyToManyRowset()`` die mit dem oben beschriebenen Datenmodell korrespondieren:

.. _zend.db.table.definition.example2:

.. rubric:: Mit der beschriebenen Definition interagieren

.. code-block:: php
   :linenos:

   $authorTable = new Zend_Db_Table('author', $definition);
   $authors = $authorTable->fetchAll();

   foreach ($authors as $author) {
       echo $author->id
          . ': '
          . $author->first_name
          . ' '
          . $author->last_name
          . PHP_EOL;
       $books = $author->findDependentRowset('book');
       foreach ($books as $book) {
           echo '    Buch: ' . $book->title . PHP_EOL;
           $genreOutputArray = array();
           $genres = $book->findManyToManyRowset('genre', 'book_to_genre');
           foreach ($genres as $genreRow) {
               $genreOutputArray[] = $genreRow->name;
           }
           echo '        Genre: ' . implode(', ', $genreOutputArray) . PHP_EOL;
       }
   }

.. _zend.db.table.definition.advanced-usage:

Fortgeschrittene Verwendung
---------------------------

Manchmal will man beide Paradigmen für die Definition und Verwendung des Tabellen Gateways verwenden: Beide durch
Wrweiterung und konkrete Instanziierung. Um das zu tun muß man einfach alle Tabellen Konfigurationen aus der
Definition lassen. Das erlaubt es ``Zend_Db_Table`` in der aktuell referierten Klasse statt im
Definitionsschlüssel nachzusehen.

Aufbauend auf dem Beispiel anbei, erlauben wir es einer der Tabellenkonfigurationen eine erweiterte
``Zend_Db_Table_Abstract`` Klasse zu sein, wärend der Rest der Tabellen Teil der Definition ist. Wir zeigen auch
wie man mit dieser neuen Definition interagieren kann.

.. _zend.db.table.definition.example3:

.. rubric:: Mit einer gemischten Zend_Db_Table Definition interagieren

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
       echo $author->id
          . ': '
          . $author->first_name
          . ' '
          . $author->last_name
          . PHP_EOL;
       $books = $author->findDependentRowset(new MyBook());
       foreach ($books as $book) {
           echo '    Buch: ' . $book->title . PHP_EOL;
           $genreOutputArray = array();
           $genres = $book->findManyToManyRowset('genre', 'book_to_genre');
           foreach ($genres as $genreRow) {
               $genreOutputArray[] = $genreRow->name;
           }
           echo '        Genre: ' . implode(', ', $genreOutputArray) . PHP_EOL;
       }
   }


