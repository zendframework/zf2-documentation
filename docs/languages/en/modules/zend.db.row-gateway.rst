.. _zend.db.row-gateway:

Zend\\Db\\RowGateway
====================

``Zend\Db\RowGateway`` is a sub-component of Zend\\Db that implements the Row Gateway pattern from PoEAA. This
effectively means that Row Gateway objects primarily model a row in a database, and have methods such as save() and
delete() that will help persist this row-as-an-object in the database itself. Likewise, after a row from the
database is retrieved, it can then be manipulated and save()'d back to the database in the same position (row), or
it can be delete()'d from the table.

The interface for a Row Gateway object simply adds save() and delete() and this is the interface that should be
assumed when a component has a dependency that is expected to be an instance of a RowGateway object:

.. code-block:: php
   :linenos:

   interface RowGatewayInterface
   {
       public function save();
       public function delete();
   }

.. _zend.db.row-gateway.row-gateway:

Quickstart
----------

While most of the time, RowGateway will be used in conjunction with other Zend\\Db\\ResultSet producing objects, it
is possible to use it standalone. To use it standalone, you simply need an Adapter and a set of data to work with.
The following use case demonstrates Zend\\Db\\RowGateway\\RowGateway usage in its simplest form:

.. code-block:: php
   :linenos:

   use Zend\Db\RowGateway\RowGateway;

   // query the database
   $resultSet = $adapter->query('SELECT * FROM `user` WHERE `id` = ?', array(2));

   // get array of data
   $rowData = $resultSet->current()->getArrayCopy();

   // row gateway
   $rowGateway = new RowGateway('id', 'my_table', $adapter);
   $rowGateway->populate($rowData, true);

   $rowGateway->first_name = 'New Name';
   $rowGateway->save();

   // or delete this row:
   $rowGateway->delete();


The workflow described above is greatly simplified when RowGateway is used in conjunction with the TableGateway
feature. What this achieves is a Table Gateway object that when select()'ing from a table, will produce a ResultSet
that is then capable of producing valid Row Gateway objects. Its usage looks like this:

.. code-block:: php
   :linenos:

   use Zend\Db\TableGateway\Feature\RowGatewayFeature;
   use Zend\Db\TableGateway\TableGateway;

   $table = new TableGateway('artist', $adapter, new RowGatewayFeature('id'));
   $results = $table->select(array('id' => 2));

   $artistRow = $results->current();
   $artistRow->name = 'New Name';
   $artistRow->save();


.. _zend.db.row-gateway.active-record-style:

ActiveRecord Style Objects
--------------------------

If you wish to have custom behaviour for your RowGateway objects (essentially making them behave
similarly to the ActiveRecord pattern), pass a prototype object implementing the
``RowGatewayInterface`` to the ``RowGatewayFeature`` constructor instead of a primary key:

.. code-block:: php
   :linenos:

   use Zend\Db\TableGateway\Feature\RowGatewayFeature;
   use Zend\Db\TableGateway\TableGateway;
   use Zend\Db\RowGateway\RowGatewayInterface;

   class Artist implements RowGatewayInterface
   {
       protected $adapter;

       public function __construct($adapter)
       {
          $this->adapter = $adapter;
       }

       // ... save() and delete() implementations
   }

   $table = new TableGateway('artist', $adapter, new RowGatewayFeature(new Artist($adapter)));


