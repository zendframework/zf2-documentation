.. _zend.db.result-set:

Zend\\Db\\ResultSet
===================

``Zend\Db\ResultSet`` is a sub-component of Zend\\Db for abstracting the iteration of rowset producing queries.
While data sources for this can be anything that is iterable, generally a
``Zend\Db\Adpater\Driver\ResultInterface`` based object is the primary source for retrieving data.

``Zend\Db\ResultSet``'s must implement the ``Zend\Db\ResultSet\ResultSetInterface`` and all sub-components of
Zend\\Db that return a ResultSet as part of their API will assume an instance of a ``ResultSetInterface`` should be
returned. In most casts, the Prototype pattern will be used by consuming object to clone a prototype of a ResultSet
and return a specialized ResultSet with a specific data source injected. The interface of ResultSetInterface looks
like this:

.. code-block:: php
   :linenos:

   interface ResultSetInterface extends \Traversable, \Countable
   {
       public function initialize($dataSource);
       public function getFieldCount();
   }

.. _zend.db.result-set.result-set:

Quickstart
----------

``Zend\Db\ResultSet\ResultSet`` is the most basic form of a ResultSet object that will expose each row as either an
ArrayObject-like object or an array of row data. The following workflow is based on that inside
``Zend\Db\Adapter\Adapter::query()``:

.. code-block:: php
   :linenos:

   use Zend\Db\Adapter\Driver\ResultInterface;
   use Zend\Db\ResultSet\ResultSet;

   $stmt = $driver->createStatement($sql);
   $stmt->prepare($parameters);
   $result = $stmt->execute();

   if ($result instanceof ResultInterface && $result->isQueryResult()) {
       $resultSet = new ResultSet;
       $resultSet->initialize($result);

       foreach ($resultSet as $row) {
           echo $row->my_column . PHP_EOL;
       }
   }

.. _zend.db.result-set.hydrating-result-set:

Zend\\Db\\ResultSet\\HydratingResultSet
---------------------------------------

``Zend\Db\ResultSet\HydratingResultSet`` is a more flexible ``ResultSet`` object that allows the developer to
choose an appropriate "hydration strategy" for getting row data into a target object. While iterating,
``HydratingResultSet`` will take a prototype of a target object and clone it for each successive new row it
iterates. With this newly cloned row, ``HydratingResultSet`` will hydrate the target object with the row data.

In the example below, rows from the database will be iterated, and during iteration, ``HydratingRowSet`` will use
the Reflection based hydrator to inject the row data directly into the protected members of the cloned UserEntity
object:

.. code-block:: php
   :linenos:

   use Zend\Db\Adapter\Driver\ResultInterface;
   use Zend\Db\ResultSet\HydratingResultSet;
   use Zend\Stdlib\Hydrator\Reflection as ReflectionHydrator;

   class UserEntity {
       protected $first_name;
       protected $last_name;
       public function getFirstName() { return $this->first_name; }
       public function getLastName() { return $this->last_name; }
   }

   $stmt = $driver->createStatement($sql);
   $stmt->prepare($parameters);
   $result = $stmt->execute();

   if ($result instanceof ResultInterface && $result->isQueryResult()) {
       $resultSet = new HydratingResultSet(new ReflectionHydrator, new UserEntity);
       $resultSet->initialize($result);

       foreach ($resultSet as $user) {
           echo $user->getFirstName() . ' ' . $user->getLastName() . PHP_EOL;
       }
   }

For more information, see the ``Zend\Stdlib\Hydrator`` documentation to get a better sense of the different
strategies that can be employed in order to populate a target object.


