.. _zend.db.table-gateway:

Zend\\Db\\TableGateway
======================

The Table Gateway object is intended to provide an object that represents a table in a database, and the methods of
this object mirror the most common operations on a database table. In code, the interface for such an object looks
like this:

.. code-block:: php
   :linenos:

   interface Zend\Db\TableGateway\TableGatewayInterface
   {
       public function getTable();
       public function select($where = null);
       public function insert($set);
       public function update($set, $where = null);
       public function delete($where);
   }

There are two primary implementations of the ``TableGatewayInterface`` that are of the most useful:
``AbstractTableGateway`` and ``TableGateway``. The ``AbstractTableGateway`` is an abstract basic implementation
that provides functionality for ``select()``, ``insert()``, ``update()``, ``delete()``, as well as an additional
API for doing these same kinds of tasks with explicit SQL objects. These methods are ``selectWith()``,
``insertWith()``, ``updateWith()`` and ``deleteWith()``. In addition, AbstractTableGateway also implements a
"Feature" API, that allows for expanding the behaviors of the base ``TableGateway`` implementation without having
to extend the class with this new functionality. The ``TableGateway`` concrete implementation simply adds a
sensible constructor to the ``AbstractTableGateway`` class so that out-of-the-box, ``TableGateway`` does not need
to be extended in order to be consumed and utilized to its fullest.

.. _zend.db.table-gateway.basic:

Basic Usage
-----------

The quickest way to get up and running with Zend\\Db\\TableGateway is to configure and utilize the concrete
implementation of the ``TableGateway``. The API of the concrete ``TableGateway`` is:

.. code-block:: php
   :linenos:

   class TableGateway extends AbstractTableGateway
   {
   	public $lastInsertValue;
   	public $table;
   	public $adapter;

   	public function __construct($table, Adapter $adapter, $features = null, ResultSet $resultSetPrototype = null, Sql $sql = null)

   	/** Inherited from AbstractTableGateway */

       public function isInitialized();
       public function initialize();
       public function getTable();
       public function getAdapter();
       public function getColumns();
       public function getFeatureSet();
       public function getResultSetPrototype();
       public function getSql();
       public function select($where = null);
       public function selectWith(Select $select);
       public function insert($set);
       public function insertWith(Insert $insert);
       public function update($set, $where = null);
       public function updateWith(Update $update);
       public function delete($where);
       public function deleteWith(Delete $delete);
       public function getLastInsertValue();
   }

The concrete ``TableGateway`` object practices constructor injection for getting dependencies and options into the
instance. The table name and an instance of an Adapter are all that is needed to setup a working ``TableGateway``
object.

Out of the box, this implementation makes no assumptions about table structure or metadata, and when ``select()``
is executed, a simple ResultSet object with the populated Adapter's Result (the datasource) will be returned and
ready for iteration.

.. code-block:: php
   :linenos:

   use Zend\Db\TableGateway\TableGateway;
   $projectTable = new TableGateway('project', $adapter);
   $rowset = $projectTable->select(array('type' => 'PHP'));

   echo 'Projects of type PHP: ';
   foreach ($rowset as $projectRow) {
   	echo $projectRow['name'] . PHP_EOL;
   }

   // or, when expecting a single row:
   $artistTable = new TableGateway('artist', $adapter);
   $rowset = $artistTable->select(array('id' => 2));
   $artistRow = $rowset->current();

   var_dump($artistRow);

The ``select()`` method takes the same arguments as ``Zend\Db\Sql\Select::where()`` with the addition of also being
able to accept a closure, which in turn, will be passed the current Select object that is being used to build the
SELECT query. The following usage is possible:

.. code-block:: php
   :linenos:

   use Zend\Db\TableGateway\TableGateway;
   use Zend\Db\Sql\Select;
   $artistTable = new TableGateway('artist', $adapter);

   // search for at most 2 artists who's name starts with Brit, ascending
   $rowset = $artistTable->select(function (Select $select) {
   	$select->where->like('name', 'Brit%');
   	$select->order('name ASC')->limit(2);
   });

.. _zend.db.table-gateway.features:

TableGateway Features
---------------------

The Features API allows for extending the functionality of the base ``TableGateway`` object without having to
polymorphically extend the base class. This allows for a wider array of possible mixing and matching of features to
achieve a particular behavior that needs to be attained to make the base implementation of ``TableGateway`` useful
for a particular problem.

With the ``TableGateway`` object, features should be injected though the constructor. The constructor can take
Features in 3 different forms: as a single feature object, as a FeatureSet object, or as an array of Feature
objects.

There are a number of features built-in and shipped with Zend\\Db:

- GlobalAdapterFeature: the ability to use a global/static adapter without needing to inject it into a
  ``TableGateway`` instance. This is more useful when you are extending the ``AbstractTableGateway``
  implementation:

.. code-block:: php
   :linenos:

   use Zend\Db\TableGateway\AbstractTableGateway;
   use Zend\Db\TableGateway\Feature;

   class MyTableGateway extends AbstractTableGateway
   {
      public function __construct()
      {
         $this->table = 'my_table';
     		$this->featureSet = new Feature\FeatureSet();
     		$this->featureSet->addFeature(new Feature\GlobalAdapterFeature());
     		$this->initialize();
      }
   }

   // elsewhere in code, in a bootstrap
   Zend\Db\TableGateway\Feature\GlobalAdapterFeature::setStaticAdapter($adapter);

   // in a controller, or model somewhere
   $table = new MyTableGateway(); // adapter is statically loaded

- MasterSlaveFeature: the ability to use a master adapter for insert(), update(), and delete() while using a slave
  adapter for all select() operations.

.. code-block:: php
   :linenos:

   $table = new TableGateway('artist', $adapter, new Feature\MasterSlaveFeature($slaveAdapter));

- MetadataFeature: the ability populate ``TableGateway`` with column information from a Metadata object. It will
  also store the primary key information in case RowGatewayFeature needs to consume this information.

.. code-block:: php
   :linenos:

   $table = new TableGateway('artist', $adapter, new Feature\MetadataFeature());

- EventFeature: the ability utilize a ``TableGateway`` object with Zend\\EventManager and to be able to subscribe
  to various events in a ``TableGateway`` lifecycle.

.. code-block:: php
   :linenos:

   $table = new TableGateway('artist', $adapter, new Feature\EventFeature($eventManagerInstance));

- RowGatewayFeature: the ability for ``select()`` to return a ResultSet object that upon iteration will
  return a ``RowGateway`` object for each row.

.. code-block:: php
   :linenos:

   $table = new TableGateway('artist', $adapter, new Feature\RowGatewayFeature('id'));
   $results = $table->select(array('id' => 2));

   $artistRow = $results->current();
   $artistRow->name = 'New Name';
   $artistRow->save();
