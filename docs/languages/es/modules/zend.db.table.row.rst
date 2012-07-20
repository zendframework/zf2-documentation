.. _zend.db.table.row:

Zend_Db_Table_Row
=================

.. _zend.db.table.row.introduction:

Introducción
------------

``Zend_Db_Table_Row`` is a class that contains an individual row of a ``Zend_Db_Table`` object. When you run a
query against a Table class, the result is returned in a set of ``Zend_Db_Table_Row`` objects. You can also use
this object to create new rows and add them to the database table.

``Zend_Db_Table_Row`` is an implementation of the `Row Data Gateway`_ pattern.

.. _zend.db.table.row.read:

Fetching a Row
--------------

``Zend_Db_Table_Abstract`` provides methods ``find()`` and ``fetchAll()``, which each return an object of type
``Zend_Db_Table_Rowset``, and the method ``fetchRow()``, which returns an object of type ``Zend_Db_Table_Row``.

.. _zend.db.table.row.read.example:

.. rubric:: Example of fetching a row

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()->where('bug_id = ?', 1));

A ``Zend_Db_Table_Rowset`` object contains a collection of ``Zend_Db_Table_Row`` objects. See :ref:`
<zend.db.table.rowset>`.

.. _zend.db.table.row.read.example-rowset:

.. rubric:: Example of reading a row in a rowset

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $rowset = $bugs->fetchAll($bugs->select()->where('bug_status = ?', 1));
   $row = $rowset->current();

.. _zend.db.table.row.read.get:

Reading column values from a row
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Db_Table_Row_Abstract`` provides accessor methods so you can reference columns in the row as object
properties.

.. _zend.db.table.row.read.get.example:

.. rubric:: Example of reading a column in a row

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()->where('bug_id = ?', 1));

   // Echo the value of the bug_description column
   echo $row->bug_description;

.. note::

   Earlier versions of ``Zend_Db_Table_Row`` mapped these column accessors to the database column names using a
   string transformation called **inflection**.

   Currently, ``Zend_Db_Table_Row`` does not implement inflection. Accessed property names need to match the
   spelling of the column names as they appear in your database.

.. _zend.db.table.row.read.to-array:

Retrieving Row Data as an Array
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can access the row's data as an array using the ``toArray()`` method of the Row object. This returns an
associative array of the column names to the column values.

.. _zend.db.table.row.read.to-array.example:

.. rubric:: Example of using the toArray() method

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()->where('bug_id = ?', 1));

   // Get the column/value associative array from the Row object
   $rowArray = $row->toArray();

   // Now use it as a normal array
   foreach ($rowArray as $column => $value) {
       echo "Column: $column\n";
       echo "Value:  $value\n";
   }

The array returned from ``toArray()`` is not updateable. You can modify values in the array as you can with any
array, but you cannot save changes to this array to the database directly.

.. _zend.db.table.row.read.relationships:

Fetching data from related tables
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``Zend_Db_Table_Row_Abstract`` class provides methods for fetching rows and rowsets from related tables. See
:ref:` <zend.db.table.relationships>` for more information on table relationships.

.. _zend.db.table.row.write:

Writing rows to the database
----------------------------

.. _zend.db.table.row.write.set:

Changing column values in a row
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can set individual column values using column accessors, similar to how the columns are read as object
properties in the example above.

Using a column accessor to set a value changes the column value of the row object in your application, but it does
not commit the change to the database yet. You can do that with the ``save()`` method.

.. _zend.db.table.row.write.set.example:

.. rubric:: Example of changing a column in a row

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()->where('bug_id = ?', 1));

   // Change the value of one or more columns
   $row->bug_status = 'FIXED';

   // UPDATE the row in the database with new values
   $row->save();

.. _zend.db.table.row.write.insert:

Inserting a new row
^^^^^^^^^^^^^^^^^^^

You can create a new row for a given table with the ``createRow()`` method of the table class. You can access
fields of this row with the object-oriented interface, but the row is not stored in the database until you call the
``save()`` method.

.. _zend.db.table.row.write.insert.example:

.. rubric:: Example of creating a new row for a table

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $newRow = $bugs->createRow();

   // Set column values as appropriate for your application
   $newRow->bug_description = '...description...';
   $newRow->bug_status = 'NEW';

   // INSERT the new row to the database
   $newRow->save();

The optional argument to the createRow() method is an associative array, with which you can populate fields of the
new row.

.. _zend.db.table.row.write.insert.example2:

.. rubric:: Example of populating a new row for a table

.. code-block:: php
   :linenos:

   $data = array(
       'bug_description' => '...description...',
       'bug_status'      => 'NEW'
   );

   $bugs = new Bugs();
   $newRow = $bugs->createRow($data);

   // INSERT the new row to the database
   $newRow->save();

.. note::

   The ``createRow()`` method was called ``fetchNew()`` in earlier releases of ``Zend_Db_Table``. You are
   encouraged to use the new method name, even though the old name continues to work for the sake of backward
   compatibility.

.. _zend.db.table.row.write.set-from-array:

Changing values in multiple columns
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Db_Table_Row_Abstract`` provides the ``setFromArray()`` method to enable you to set several columns in a
single row at once, specified in an associative array that maps the column names to values. You may find this
method convenient for setting values both for new rows and for rows you need to update.

.. _zend.db.table.row.write.set-from-array.example:

.. rubric:: Example of using setFromArray() to set values in a new Row

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $newRow = $bugs->createRow();

   // Data are arranged in an associative array
   $data = array(
       'bug_description' => '...description...',
       'bug_status'      => 'NEW'
   );

   // Set all the column values at once
   $newRow->setFromArray($data);

   // INSERT the new row to the database
   $newRow->save();

.. _zend.db.table.row.write.delete:

Deleting a row
^^^^^^^^^^^^^^

You can call the ``delete()`` method on a Row object. This deletes rows in the database matching the primary key in
the Row object.

.. _zend.db.table.row.write.delete.example:

.. rubric:: Example of deleting a row

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow('bug_id = 1');

   // DELETE this row
   $row->delete();

You do not have to call ``save()`` to apply the delete; it is executed against the database immediately.

.. _zend.db.table.row.serialize:

Serializing and unserializing rows
----------------------------------

It is often convenient to save the contents of a database row to be used later. **Serialization** is the name for
the operation that converts an object into a form that is easy to save in offline storage (for example, a file).
Objects of type ``Zend_Db_Table_Row_Abstract`` are serializable.

.. _zend.db.table.row.serialize.serializing:

Serializing a Row
^^^^^^^^^^^^^^^^^

Simply use *PHP*'s ``serialize()`` function to create a string containing a byte-stream representation of the Row
object argument.

.. _zend.db.table.row.serialize.serializing.example:

.. rubric:: Example of serializing a row

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow('bug_id = 1');

   // Convert object to serialized form
   $serializedRow = serialize($row);

   // Now you can write $serializedRow to a file, etc.

.. _zend.db.table.row.serialize.unserializing:

Unserializing Row Data
^^^^^^^^^^^^^^^^^^^^^^

Use PHP's ``unserialize()`` function to restore a string containing a byte-stream representation of an object. The
function returns the original object.

Note that the Row object returned is in a **disconnected** state. You can read the Row object and its properties,
but you cannot change values in the Row or execute other methods that require a database connection (for example,
queries against related tables).

.. _zend.db.table.row.serialize.unserializing.example:

.. rubric:: Example of unserializing a serialized row

.. code-block:: php
   :linenos:

   $rowClone = unserialize($serializedRow);

   // Now you can use object properties, but read-only
   echo $rowClone->bug_description;

.. note::

   **Why do Rows unserialize in a disconnected state?**

   A serialized object is a string that is readable to anyone who possesses it. It could be a security risk to
   store parameters such as database account and password in plain, unencrypted text in the serialized string. You
   would not want to store such data to a text file that is not protected, or send it in an email or other medium
   that is easily read by potential attackers. The reader of the serialized object should not be able to use it to
   gain access to your database without knowing valid credentials.

.. _zend.db.table.row.serialize.set-table:

Reactivating a Row as Live Data
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can reactivate a disconnected Row, using the ``setTable()`` method. The argument to this method is a valid
object of type ``Zend_Db_Table_Abstract``, which you create. Creating a Table object requires a live connection to
the database, so by reassociating the Table with the Row, the Row gains access to the database. Subsequently, you
can change values in the Row object and save the changes to the database.

.. _zend.db.table.row.serialize.set-table.example:

.. rubric:: Example of reactivating a row

.. code-block:: php
   :linenos:

   $rowClone = unserialize($serializedRow);

   $bugs = new Bugs();

   // Reconnect the row to a table, and
   // thus to a live database connection
   $rowClone->setTable($bugs);

   // Now you can make changes to the row and save them
   $rowClone->bug_status = 'FIXED';
   $rowClone->save();

.. _zend.db.table.row.extending:

Extending the Row class
-----------------------

``Zend_Db_Table_Row`` is the default concrete class that extends ``Zend_Db_Table_Row_Abstract``. You can define
your own concrete class for instances of Row by extending ``Zend_Db_Table_Row_Abstract``. To use your new Row class
to store results of Table queries, specify the custom Row class by name either in the ``$_rowClass`` protected
member of a Table class, or in the array argument of the constructor of a Table object.

.. _zend.db.table.row.extending.example:

.. rubric:: Specifying a custom Row class

.. code-block:: php
   :linenos:

   class MyRow extends Zend_Db_Table_Row_Abstract
   {
       // ...customizations
   }

   // Specify a custom Row to be used by default
   // in all instances of a Table class.
   class Products extends Zend_Db_Table_Abstract
   {
       protected $_name = 'products';
       protected $_rowClass = 'MyRow';
   }

   // Or specify a custom Row to be used in one
   // instance of a Table class.
   $bugs = new Bugs(array('rowClass' => 'MyRow'));

.. _zend.db.table.row.extending.overriding:

Row initialization
^^^^^^^^^^^^^^^^^^

If application-specific logic needs to be initialized when a row is constructed, you can select to move your tasks
to the ``init()`` method, which is called after all row metadata has been processed. This is recommended over the
``__construct`` method if you do not need to alter the metadata in any programmatic way.



      .. _zend.db.table.row.init.usage.example:

      .. rubric:: Example usage of init() method

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

Defining Custom Logic for Insert, Update, and Delete in Zend_Db_Table_Row
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The Row class calls protected methods ``_insert()``, ``_update()``, and ``_delete()`` before performing the
corresponding operations ``INSERT``, ``UPDATE``, and ``DELETE``. You can add logic to these methods in your custom
Row subclass.

If you need to do custom logic in a specific table, and the custom logic must occur for every operation on that
table, it may make more sense to implement your custom code in the ``insert()``, ``update()`` and ``delete()``
methods of your Table class. However, sometimes it may be necessary to do custom logic in the Row class.

Below are some example cases where it might make sense to implement custom logic in a Row class instead of in the
Table class:

.. _zend.db.table.row.extending.overriding-example1:

.. rubric:: Example of custom logic in a Row class

The custom logic may not apply in all cases of operations on the respective Table. You can provide custom logic on
demand by implementing it in a Row class and creating an instance of the Table class with that custom Row class
specified. Otherwise, the Table uses the default Row class.

You need data operations on this table to record the operation to a ``Zend_Log`` object, but only if the
application configuration has enabled this behavior.

.. code-block:: php
   :linenos:

   class MyLoggingRow extends Zend_Db_Table_Row_Abstract
   {
       protected function _insert()
       {
           $log = Zend_Registry::get('database_log');
           $log->info(Zend_Debug::dump($this->_data,
                                       "INSERT: $this->_tableClass",
                                       false)
                     );
       }
   }

   // $loggingEnabled is an example property that depends
   // on your application configuration
   if ($loggingEnabled) {
       $bugs = new Bugs(array('rowClass' => 'MyLoggingRow'));
   } else {
       $bugs = new Bugs();
   }

.. _zend.db.table.row.extending.overriding-example2:

.. rubric:: Example of a Row class that logs insert data for multiple tables

The custom logic may be common to multiple tables. Instead of implementing the same custom logic in every one of
your Table classes, you can implement the code for such actions in the definition of a Row class, and use this Row
in each of your Table classes.

In this example, the logging code is identical in all table classes.

.. code-block:: php
   :linenos:

   class MyLoggingRow extends Zend_Db_Table_Row_Abstract
   {
       protected function _insert()
       {
           $log = Zend_Registry::get('database_log');
           $log->info(Zend_Debug::dump($this->_data,
                                       "INSERT: $this->_tableClass",
                                       false)
                     );
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

Define Inflection in Zend_Db_Table_Row
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Some people prefer that the table class name match a table name in the *RDBMS* by using a string transformation
called **inflection**.

``Zend_Db`` classes do not implement inflection by default. See :ref:` <zend.db.table.extending.inflection>` for an
explanation of this policy.

If you prefer to use inflection, then you must implement the transformation yourself, by overriding the
``_transformColumn()`` method in a custom Row class, and using that custom Row class when you perform queries
against your Table class.

.. _zend.db.table.row.extending.inflection.example:

.. rubric:: Example of defining an inflection transformation

This allows you to use an inflected version of the column name in the accessors. The Row class uses the
``_transformColumn()`` method to change the name you use to the native column name in the database table.

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

   // Use camelcase column names, and rely on the
   // transformation function to change it into the
   // native representation.
   $row->bugDescription = 'New description';

You are responsible for writing the functions to perform inflection transformation. Zend Framework does not provide
such a function.



.. _`Row Data Gateway`: http://www.martinfowler.com/eaaCatalog/rowDataGateway.html
