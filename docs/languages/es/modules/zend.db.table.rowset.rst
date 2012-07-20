.. _zend.db.table.rowset:

Zend_Db_Table_Rowset
====================

.. _zend.db.table.rowset.introduction:

Introduction
------------

When you run a query against a Table class using the ``find()`` or ``fetchAll()`` methods, the result is returned
in an object of type ``Zend_Db_Table_Rowset_Abstract``. A Rowset contains a collection of objects descending from
``Zend_Db_Table_Row_Abstract``. You can iterate through the Rowset and access individual Row objects, reading or
modifying data in the Rows.

.. _zend.db.table.rowset.fetch:

Fetching a Rowset
-----------------

``Zend_Db_Table_Abstract`` provides methods ``find()`` and ``fetchAll()``, each of which returns an object of type
``Zend_Db_Table_Rowset_Abstract``.

.. _zend.db.table.rowset.fetch.example:

.. rubric:: Example of fetching a rowset

.. code-block:: php
   :linenos:

   $bugs   = new Bugs();
   $rowset = $bugs->fetchAll("bug_status = 'NEW'");

.. _zend.db.table.rowset.rows:

Retrieving Rows from a Rowset
-----------------------------

The Rowset itself is usually less interesting than the Rows that it contains. This section illustrates how to get
the Rows that comprise the Rowset.

A legitimate query returns zero rows when no rows in the database match the query conditions. Therefore, a Rowset
object might contain zero Row objects. Since ``Zend_Db_Table_Rowset_Abstract`` implements the ``Countable``
interface, you can use ``count()`` to determine the number of Rows in the Rowset.

.. _zend.db.table.rowset.rows.counting.example:

.. rubric:: Counting the Rows in a Rowset

.. code-block:: php
   :linenos:

   $rowset   = $bugs->fetchAll("bug_status = 'FIXED'");

   $rowCount = count($rowset);

   if ($rowCount > 0) {
       echo "found $rowCount rows";
   } else {
       echo 'no rows matched the query';
   }

.. _zend.db.table.rowset.rows.current.example:

.. rubric:: Reading a Single Row from a Rowset

The simplest way to access a Row from a Rowset is to use the ``current()`` method. This is particularly appropriate
when the Rowset contains exactly one Row.

.. code-block:: php
   :linenos:

   $bugs   = new Bugs();
   $rowset = $bugs->fetchAll("bug_id = 1");
   $row    = $rowset->current();

If the Rowset contains zero rows, ``current()`` returns PHP's ``NULL`` value.

.. _zend.db.table.rowset.rows.iterate.example:

.. rubric:: Iterating through a Rowset

Objects descending from ``Zend_Db_Table_Rowset_Abstract`` implement the ``SeekableIterator`` interface, which means
you can loop through them using the ``foreach`` construct. Each value you retrieve this way is a
``Zend_Db_Table_Row_Abstract`` object that corresponds to one record from the table.

.. code-block:: php
   :linenos:

   $bugs = new Bugs();

   // fetch all records from the table
   $rowset = $bugs->fetchAll();

   foreach ($rowset as $row) {

       // output 'Zend_Db_Table_Row' or similar
       echo get_class($row) . "\n";

       // read a column in the row
       $status = $row->bug_status;

       // modify a column in the current row
       $row->assigned_to = 'mmouse';

       // write the change to the database
       $row->save();
   }

.. _zend.db.table.rowset.rows.seek.example:

.. rubric:: Seeking to a known position into a Rowset

``SeekableIterator`` allows you to seek to a position that you would like the iterator to jump to. Simply use the
``seek()`` method for that. Pass it an integer representing the number of the Row you would like your Rowset to
point to next, don't forget that it starts with index 0. If the index is wrong, ie doesn't exist, an exception will
be thrown. You should use ``count()`` to check the number of results before seeking to a position.

.. code-block:: php
   :linenos:

   $bugs = new Bugs();

   // fetch all records from the table
   $rowset = $bugs->fetchAll();

   // takes the iterator to the 9th element (zero is one element) :
   $rowset->seek(8);

   // retrieve it
   $row9 = $rowset->current();

   // and use it
   $row9->assigned_to = 'mmouse';
   $row9->save();

``getRow()`` allows you to get a specific row in the Rowset, knowing its position; don't forget however that
positions start with index zero. The first parameter for ``getRow()`` is an integer for the position asked. The
second optional parameter is a boolean; it tells the Rowset iterator if it must seek to that position in the same
time, or not (default is ``FALSE``). This method returns a ``Zend_Db_Table_Row`` object by default. If the position
requested does not exist, an exception will be thrown. Here is an example :

.. code-block:: php
   :linenos:

   $bugs = new Bugs();

   // fetch all records from the table
   $rowset = $bugs->fetchAll();

   // retrieve the 9th element immediately:
   $row9->getRow(8);

   // and use it:
   $row9->assigned_to = 'mmouse';
   $row9->save();

After you have access to an individual Row object, you can manipulate the Row using methods described in :ref:`
<zend.db.table.row>`.

.. _zend.db.table.rowset.to-array:

Retrieving a Rowset as an Array
-------------------------------

You can access all the data in the Rowset as an array using the ``toArray()`` method of the Rowset object. This
returns an array containing one entry per Row. Each entry is an associative array having keys that correspond to
column names and elements that correspond to the respective column values.

.. _zend.db.table.rowset.to-array.example:

.. rubric:: Using toArray()

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

The array returned from ``toArray()`` is not updateable. That is, you can modify values in the array as you can
with any array, but changes to the array data are not propagated to the database.

.. _zend.db.table.rowset.serialize:

Serializing and Unserializing a Rowset
--------------------------------------

Objects of type ``Zend_Db_Table_Rowset_Abstract`` are serializable. In a similar fashion to serializing an
individual Row object, you can serialize a Rowset and unserialize it later.

.. _zend.db.table.rowset.serialize.example.serialize:

.. rubric:: Serializing a Rowset

Simply use PHP's ``serialize()`` function to create a string containing a byte-stream representation of the Rowset
object argument.

.. code-block:: php
   :linenos:

   $bugs   = new Bugs();
   $rowset = $bugs->fetchAll();

   // Convert object to serialized form
   $serializedRowset = serialize($rowset);

   // Now you can write $serializedRowset to a file, etc.

.. _zend.db.table.rowset.serialize.example.unserialize:

.. rubric:: Unserializing a Serialized Rowset

Use PHP's ``unserialize()`` function to restore a string containing a byte-stream representation of an object. The
function returns the original object.

Note that the Rowset object returned is in a **disconnected** state. You can iterate through the Rowset and read
the Row objects and their properties, but you cannot change values in the Rows or execute other methods that
require a database connection (for example, queries against related tables).

.. code-block:: php
   :linenos:

   $rowsetDisconnected = unserialize($serializedRowset);

   // Now you can use object methods and properties, but read-only
   $row = $rowsetDisconnected->current();
   echo $row->bug_description;

.. note::

   **Why do Rowsets unserialize in a disconnected state?**

   A serialized object is a string that is readable to anyone who possesses it. It could be a security risk to
   store parameters such as database account and password in plain, unencrypted text in the serialized string. You
   would not want to store such data to a text file that is not protected, or send it in an email or other medium
   that is easily read by potential attackers. The reader of the serialized object should not be able to use it to
   gain access to your database without knowing valid credentials.

You can reactivate a disconnected Rowset using the ``setTable()`` method. The argument to this method is a valid
object of type ``Zend_Db_Table_Abstract``, which you create. Creating a Table object requires a live connection to
the database, so by reassociating the Table with the Rowset, the Rowset gains access to the database. Subsequently,
you can change values in the Row objects contained in the Rowset and save the changes to the database.

.. _zend.db.table.rowset.serialize.example.set-table:

.. rubric:: Reactivating a Rowset as Live Data

.. code-block:: php
   :linenos:

   $rowset = unserialize($serializedRowset);

   $bugs = new Bugs();

   // Reconnect the rowset to a table, and
   // thus to a live database connection
   $rowset->setTable($bugs);

   $row = $rowset->current();

   // Now you can make changes to the row and save them
   $row->bug_status = 'FIXED';
   $row->save();

Reactivating a Rowset with ``setTable()`` also reactivates all the Row objects contained in that Rowset.

.. _zend.db.table.rowset.extending:

Extending the Rowset class
--------------------------

You can use an alternative concrete class for instances of Rowsets by extending ``Zend_Db_Table_Rowset_Abstract``.
Specify the custom Rowset class by name either in the ``$_rowsetClass`` protected member of a Table class, or in
the array argument of the constructor of a Table object.

.. _zend.db.table.rowset.extending.example:

.. rubric:: Specifying a custom Rowset class

.. code-block:: php
   :linenos:

   class MyRowset extends Zend_Db_Table_Rowset_Abstract
   {
       // ...customizations
   }

   // Specify a custom Rowset to be used by default
   // in all instances of a Table class.
   class Products extends Zend_Db_Table_Abstract
   {
       protected $_name = 'products';
       protected $_rowsetClass = 'MyRowset';
   }

   // Or specify a custom Rowset to be used in one
   // instance of a Table class.
   $bugs = new Bugs(array('rowsetClass' => 'MyRowset'));

Typically, the standard ``Zend_Db_Rowset`` concrete class is sufficient for most usage. However, you might find it
useful to add new logic to a Rowset, specific to a given Table. For example, a new method could calculate an
aggregate over all the Rows in the Rowset.

.. _zend.db.table.rowset.extending.example-aggregate:

.. rubric:: Example of Rowset class with a new method

.. code-block:: php
   :linenos:

   class MyBugsRowset extends Zend_Db_Table_Rowset_Abstract
   {
       /**
        * Find the Row in the current Rowset with the
        * greatest value in its 'updated_at' column.
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


