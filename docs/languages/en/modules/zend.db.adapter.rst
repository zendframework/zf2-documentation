.. _zend.db.adapter:

Zend\\Db\\Adapter
=================

The Adapter object is the most important sub-component of ``Zend\Db``. It is responsible for adapting any code written
in or for Zend\\Db to the targeted php extensions and vendor databases. In doing this, it creates an abstraction
layer for the PHP extensions, which is called the "Driver" portion of the ``Zend\Db`` adapter. It also creates a
lightweight abstraction layer, called the "Platform" portion of the adapter, for the various idiosyncrasies that 
each vendor-specific platform might have in its SQL/RDBMS implementation.

.. _zend.db.adapter.quickstart:

Creating an Adapter - Quickstart
--------------------------------

Creating an adapter can simply be done by instantiating the ``Zend\Db\Adapter\Adapter`` class. The most common use
case, while not the most explicit, is to pass an array of configuration to the ``Adapter``.

.. code-block:: php
   :linenos:

   $adapter = new Zend\Db\Adapter\Adapter($configArray);

This driver array is an abstraction for the extension level required parameters. Here is a table for the
key-value pairs that should be in configuration array.

.. table:: 

   +------------+----------------------+-------------------------------------------------------------+
   |Key         |Is Required?          |Value                                                        |
   +============+======================+=============================================================+
   |driver      |required              |Mysqli, Sqlsrv, Pdo_Sqlite, Pdo_Mysql, Pdo=OtherPdoDriver    |
   +------------+----------------------+-------------------------------------------------------------+
   |database    |generally required    |the name of the database (schema)                            |
   +------------+----------------------+-------------------------------------------------------------+
   |username    |generally required    |the connection username                                      |
   +------------+----------------------+-------------------------------------------------------------+
   |password    |generally required    |the connection password                                      |
   +------------+----------------------+-------------------------------------------------------------+
   |hostname    |not generally required|the IP address or hostname to connect to                     |
   +------------+----------------------+-------------------------------------------------------------+
   |port        |not generally required|the port to connect to (if applicable)                       |
   +------------+----------------------+-------------------------------------------------------------+
   |charset     |not generally required|the character set to use                                     |
   +------------+----------------------+-------------------------------------------------------------+

.. note:: 

   Other names will work as well. Effectively, if the PHP manual uses a particular naming, this naming will be
   supported by our Driver. For example, dbname in most cases will also work for 'database'. Another example is that
   in the case of Sqlsrv, UID will work in place of username. Which format you chose is up to you, but the above table
   represents the official abstraction names.

So, for example, a MySQL connection using ext/mysqli:

.. code-block:: php
   :linenos:

    $adapter = new Zend\Db\Adapter\Adapter(array(
       'driver' => 'Mysqli',
       'database' => 'zend_db_example',
       'username' => 'developer',
       'password' => 'developer-password'
    ));

Another example, of a Sqlite connection via PDO:

.. code-block:: php
   :linenos:

    $adapter = new Zend\Db\Adapter\Adapter(array(
       'driver' => 'Pdo_Sqlite',
       'database' => 'path/to/sqlite.db'
    ));

It is important to know that by using this style of adapter creation, the ``Adapter`` will attempt to create any
dependencies that were not explicitly provided. A Driver object will be created from the configuration
array provided in the constructor. A Platform object will be created based off the type of Driver class that was
instantiated. And lastly, a default ResultSet object is created and utilized. Any of these objects can be injected,
to do this, see the next section.

The list of officially supported drivers:

* ``Mysqli``: The ext/mysqli driver
* ``Pgsql``: The ext/pgsql driver
* ``Sqlsrv``: The ext/sqlsrv driver (from Microsoft)
* ``Pdo_Mysql``: MySQL through the PDO extension
* ``Pdo_Sqlite``: SQLite though the PDO extension
* ``Pdo_Pgsql``: PostgreSQL through the PDO extension

.. _zend.db.adapter.instantiating:

Creating an Adapter Using Dependency Injection
----------------------------------------------

The more expressive and explicit way of creating an adapter is by injecting all your dependencies up front.
``Zend\Db\Adapter\Adapter`` uses constructor injection, and all required dependencies are injected through the
constructor, which has the following signature (in pseudo-code):

.. code-block:: php
   :linenos:

   use Zend\Db\Adapter\Platform\PlatformInterface;
   use Zend\Db\ResultSet\ResultSet;

   class Zend\Db\Adapter\Adapter {
       public function __construct($driver, PlatformInterface $platform = null, ResultSet $queryResultSetPrototype = null)
   }

What can be injected:

* $driver - an array of connection parameters (see above) or an instance of ``Zend\Db\Adapter\Driver\DriverInterface``
* $platform - (optional) an instance of ``Zend\Db\Platform\PlatformInterface``, the default will be created based off the driver implementation
* $queryResultSetPrototype - (optional) an instance of ``Zend\Db\ResultSet\ResultSet``, to understand this object's role, see the section below on querying through the adapter

.. _zend.db.adapter.query-preparing:

Query Preparation Through Zend\\Db\\Adapter\\Adapter::query()
-------------------------------------------------------------

By default, query() prefers that you use "preparation" as a means for processing SQL statements. This generally
means that you will supply a SQL statement with the values substituted by placeholders, and then the parameters for
those placeholders are supplied separately. An example of this workflow with ``Zend\Db\Adapter\Adapter`` is:

.. code-block:: php
   :linenos:

   $adapter->query('SELECT * FROM `artist` WHERE `id` = ?', array(5));

The above example will go through the following steps:

* create a new Statement object
* prepare an array into a ParameterContainer if necessary
* inject the ParameterContainer into the Statement object
* execute the Statement object, producing a Result object
* check the Result object to check if the supplied sql was a "query", or a result set producing statement
* if it is a result set producing query, clone the ResultSet prototype, inject Result as datasource, return it
* else, return the Result

.. _zend.db.adapter.query-execution:

Query Execution Through Zend\\Db\\Adapter\\Adapter::query()
-----------------------------------------------------------

In some cases, you have to execute statements directly. The primary purpose for needing to execute sql instead of
prepare and execute a sql statement, might be because you are attempting to execute a DDL statement (which in most
extensions and vendor platforms), are un-preparable. An example of executing:

.. code-block:: php
   :linenos:

   $adapter->query('ALTER TABLE ADD INDEX(`foo_index`) ON (`foo_column`)', Adapter::QUERY_MODE_EXECUTE);

The primary difference to notice is that you must provide the Adapter::QUERY_MODE_EXECUTE (execute) as the second
parameter.

.. _zend.db.adapter.statement-creation:

Creating Statements
-------------------

While query() is highly useful for one-off and quick querying of a database through Adapter, it generally makes
more sense to create a statement and interact with it directly, so that you have greater control over the
prepare-then-execute workflow. To do this, Adapter gives you a routine called createStatement() that allows you to
create a Driver specific Statement to use so you can manage your own prepare-then-execute workflow.

.. code-block:: php
   :linenos:

   // with optional parameters to bind up-front
   $statement = $adapter->createStatement($sql, $optionalParameters);
   $result = $statement->execute();

.. _zend.db.adapter.driver:

Using the Driver Object
-----------------------

The Driver object is the primary place where  ``Zend\Db\Adapter\Adapter`` implements the connection level
abstraction making it possible to use all of Zend\Db's interfaces via the various ext/mysqli, ext/sqlsrv,
PDO, and other PHP level drivers.  To make this possible, each driver is composed of 3 objects:

* A connection: ``Zend\Db\Adapter\Driver\ConnectionInterface``
* A statement: ``Zend\Db\Adapter\Driver\StatementInterface``
* A result: ``Zend\Db\Adapter\Driver\ResultInterface``

Each of the built-in drivers practices "prototyping" as a means of creating objects when new instances
are requested.  The workflow looks like this:

* An adapter is created with a set of connection parameters
* The adapter chooses the proper driver to instantiate, for example ``Zend\Db\Adapter\Driver\Mysqli``
* That driver class is instantiated
* If no connection, statement or result objects are injected, defaults are instantiated

This driver is now ready to be called on when particular workflows are requested.  Here is what the
Driver API looks like:

.. code-block:: php
   :linenos:

   namespace Zend\Db\Adapter\Driver;

    interface DriverInterface
    {
        const PARAMETERIZATION_POSITIONAL = 'positional';
        const PARAMETERIZATION_NAMED = 'named';
        const NAME_FORMAT_CAMELCASE = 'camelCase';
        const NAME_FORMAT_NATURAL = 'natural';
        public function getDatabasePlatformName($nameFormat = self::NAME_FORMAT_CAMELCASE);
        public function checkEnvironment();
        public function getConnection();
        public function createStatement($sqlOrResource = null);
        public function createResult($resource);
        public function getPrepareType();
        public function formatParameterName($name, $type = null);
        public function getLastGeneratedValue();
    }

From this DriverInterface, you can

* Determine the name of the platform this driver supports (useful for choosing the proper platform object)
* Check that the environment can support this driver
* Return the Connection object
* Create a Statement object which is optionally seeded by an SQL statement (this will generally be a clone of a prototypical statement object)
* Create a Result object which is optionally seeded by a statement resource (this will generally be a clone of a prototypical result object)
* Format parameter names, important to distinguish the difference between the various ways parameters are named between extensions
* Retrieve the overall last generated value (such as an auto-increment value)

Statement objects generally look like this:

.. code-block:: php
   :linenos:
   
   namespace Zend\Db\Adapter\Driver;

   interface StatementInterface extends StatementContainerInterface
   {
       public function getResource();
       public function prepare($sql = null);
       public function isPrepared();
       public function execute($parameters = null);

       /** Inherited from StatementContainerInterface */
       public function setSql($sql);
       public function getSql();
       public function setParameterContainer(ParameterContainer $parameterContainer);
       public function getParameterContainer();
   }
   
Result objects generally look like this:

.. code-block:: php
   :linenos:
   
   namespace Zend\Db\Adapter\Driver;

   interface ResultInterface extends \Countable, \Iterator
   {
       public function buffer();
       public function isQueryResult();
       public function getAffectedRows();
       public function getGeneratedValue();
       public function getResource();
       public function getFieldCount();
   }

.. _zend.db.adapter.platform:

Using The Platform Object
-------------------------

The Platform object provides an API to assist in crafting queries in a way that is specific to the SQL
implementation of a particular vendor. Nuances such as how identifiers or values are quoted, or what the identifier
separator character is are handled by this object. To get an idea of the capabilities, the interface for a platform
object looks like this:

.. code-block:: php
   :linenos:
   
   namespace Zend\Db\Adapter\Platform;

   interface PlatformInterface
   {
       public function getName();
       public function getQuoteIdentifierSymbol();
       public function quoteIdentifier($identifier);
       public function quoteIdentifierChain($identiferChain)
       public function getQuoteValueSymbol();
       public function quoteValue($value);
       public function quoteValueList($valueList);
       public function getIdentifierSeparator();
       public function quoteIdentifierInFragment($identifier, array $additionalSafeWords = array());
   }

While one can instantiate your own Platform object, generally speaking, it is easier to get the proper
Platform instance from the configured adapter (by default the Platform type will match the underlying
driver implementation):

.. code-block:: php
   :linenos:

   $platform = $adapter->getPlatform();
   // or
   $platform = $adapter->platform; // magic property access

The following is a couple of example of Platform usage:

.. code-block:: php
  :linenos:

  /** @var $adapter Zend\Db\Adapter\Adapter */
  /** @var $platform Zend\Db\Adapter\Platform\Sql92 */
  $platform = $adapter->getPlatform();
  
  // "first_name"
  echo $platform->quoteIdentifier('first_name');
  
  // " 
  echo $platform->getQuoteIdentifierSymbol(); 
  
  // "schema"."mytable"
  echo $platform->quoteIdentifierChain(array('schema','mytable')));
  
  // '
  echo $platform->getQuoteValueSymbol();
  
  // 'myvalue'
  echo $platform->quoteValue('myvalue');
  
  // 'value', 'Foo O\\'Bar'
  echo $platform->quoteValueList(array('value',"Foo O'Bar")));
  
  // .
  echo $platform->getIdentifierSeparator();
  
  // "foo" as "bar"
  echo $platform->quoteIdentifierInFragment('foo as bar');
  
  // additionally, with some safe words:
  // ("foo"."bar" = "boo"."baz")
  echo $platform->quoteIdentifierInFragment('(foo.bar = boo.baz)', array('(', ')', '='));
  
.. _zend.db.adapter.parameter-container:

Using The Parameter Container
-----------------------------

The ParameterContainer object is a container for the various parameters that need to be passed into a Statement
object to fulfill all the various parameterized parts of the SQL statement. This object implements the ArrayAccess
interface.  Below is the ParameterContainer API:

.. code-block:: php

   namespace Zend\Db\Adapter;

    class ParameterContainer implements \Iterator, \ArrayAccess, \Countable {
        public function __construct(array $data = array())
        
        /** methods to interact with values */
        public function offsetExists($name)
        public function offsetGet($name)
        public function offsetSetReference($name, $from)
        public function offsetSet($name, $value, $errata = null)
        public function offsetUnset($name)
        
        /** set values from array (will reset first) */
        public function setFromArray(Array $data)
        
        /** methods to interact with value errata */
        public function offsetSetErrata($name, $errata)
        public function offsetGetErrata($name)
        public function offsetHasErrata($name)
        public function offsetUnsetErrata($name)
        
        /** errata only iterator */
        public function getErrataIterator()
        
        /** get array with named keys */
        public function getNamedArray()
        
        /** get array with int keys, ordered by position */
        public function getPositionalArray()
        
        /** iterator: */
        public function count()
        public function current()
        public function next()
        public function key()
        public function valid()
        public function rewind()
        
        /** merge existing array of parameters with existing parameters */
        public function merge($parameters)    
    }


In addition to handling parameter names and values, the container will assist in tracking parameter
types for PHP type to SQL type handling.  For example, it might be important that:

.. code-block:: php
    
    $container->offsetSet('limit', 5);
    
be bound as an integer.  To achieve this, pass in the ParameterContainer::TYPE_INTEGER constant as the 3rd parameter:

.. code-block:: php
    
    $container->offsetSet('limit', 5, $container::TYPE_INTEGER);
    
This will ensure that if the underlying driver supports typing of bound parameters, that this translated
information will also be passed along to the actual php database driver.

.. _zend.db.adapter.parameter-container.examples:

Examples
--------

Creating a Driver and Vendor portable Query, Preparing and Iterating Result

.. code-block:: php
   :linenos:

   $adapter = new Zend\Db\Adapter\Adapter($driverConfig);

   $qi = function($name) use ($adapter) { return $adapter->platform->quoteIdentifier($name); };
   $fp = function($name) use ($adapter) { return $adapter->driver->formatParameterName($name); };

   $sql = 'UPDATE ' . $qi('artist')
       . ' SET ' . $qi('name') . ' = ' . $fp('name')
       . ' WHERE ' . $qi('id') . ' = ' . $fp('id');

   /** @var $statement Zend\Db\Adapter\Driver\StatementInterface */
   $statement = $adapter->query($sql);

   $parameters = array(
       'name' => 'Updated Artist',
       'id' => 1
   );

   $statement->execute($parameters);

   // DATA INSERTED, NOW CHECK

   /* @var $statement Zend\Db\Adapter\DriverStatementInterface */
   $statement = $adapter->query('SELECT * FROM '
       . $qi('artist')
       . ' WHERE id = ' . $fp('id'));

   /* @var $results Zend\Db\ResultSet\ResultSet */
   $results = $statement->execute(array('id' => 1));

   $row = $results->current();
   $name = $row['name'];


