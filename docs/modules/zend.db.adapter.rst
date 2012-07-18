.. _zend.db.adapter:

Zend\\Db\\Adapter
=================

The Adapter object is the most important sub-component of Zend\\Db. It is responsible for adapting any code written in or for Zend\\Db to the targeted php extensions and vendor databases. In doing this, it creates an abstraction layer for the PHP extensions, which is called the "Driver" portion of the Zend\\Db adapter. It also creates a lightweight abstraction layer for the various idiosyncrasies that each vendor specific platform might have in it's SQL/RDBMS implementation which is called the "Platform" portion of the adapter.

.. _zend.db.adapter.quickstart:

Creating an Adapter (Quickstart)
--------------------------------

Creating an adapter can simply be done by instantiating the ``Zend\Db\Adapter\Adapter`` class. The most common use case, while not the most explicit, is to pass an array of information to the Adapter.

.. code-block:: php
   :linenos:

   $adapter = new Zend\Db\Adapter\Adapter($driverArray);

This driver array is an abstraction for the extension level required parameters. Here is a table for the

.. table:: Connection Array Keys

   +------------+----------------------+-------------------------------------------------------------+
   |Name        |Required              |Notes                                                        |
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
   |port        |not generally required|not generally required the port to connect to (if applicable)|
   +------------+----------------------+-------------------------------------------------------------+
   |characterset|not generally required|not generally required the character set to use              |
   +------------+----------------------+-------------------------------------------------------------+

\* other names will work as well. Effectively, if the PHP manual uses a particular naming, this naming will be supported by our Driver. For example, dbname in most cases will also work for 'database'. Another example is that in the case of Sqlsrv, UID will work in place of username. Which format you chose is up to you, but the above table represents the official abstraction names.

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

It is important to know that by using this style of adapter creation, the Adapter will attempt to create any dependencies that were not explicitly provided. A Driver object will be created from the contents of the $driver array provided in the constructor. A Platform object will be created based off the type of Driver object that was instantiated. And lastly, a default ResultSet object is created and utilized. Any of these objects can be injected, to do this, see the next section.

.. _zend.db.adapter.instantiating:

Creating an Adapter (By Injecting Dependencies)
-----------------------------------------------

The more expressive and explicit way of creating an adapter is by injecting all your dependencies up front. ``Zend\Db\Adapter\Adapter`` uses constructor injection, and all required dependencies are injected through the constructor, which has the following signature (in pseudo-code):

.. code-block:: php
   :linenos:

   use Zend\Db\Adapter\Platform\PlatformInterface;
   use Zend\Db\ResultSet\ResultSet;

   class Zend\Db\Adapter\Adapter {
       public function __construct($driver, PlatformInterface $platform = null, ResultSet $queryResultSetPrototype = null)
   }

What can be injected:

$driver - an array or an instance of ``Zend\Db\Adapter\Driver\DriverInterface`` $platform - (optional) an instance of ``Zend\Db\Platform\PlatformInterface``, the default will be created based off the driver implementation $queryResultSetPrototype - (optional) an instance of ``Zend\Db\ResultSet\ResultSet``, to understand this object's role, see the section below on querying through the adapter

.. _zend.db.adapter.query-preparing:

Query Preparation Through Zend\\Db\\Adapter\\Adapter::query()
-------------------------------------------------------------

By default, query() prefers that you use "preparation" as a means for processing SQL statements. This generally means that you will supply a SQL statement with the values substituted by placeholders, and then the parameters for those placeholders are supplied separately. An example of this workflow with ``Zend\Db\Adapter\Adapter`` is:

.. code-block:: php
   :linenos:

   $adapter->query('SELECT * FROM `artist` WHERE `id` = ?', array(5));

The above example will go through the following steps:

- create a new Statement object

- prepare an array into a ParameterContainer if necessary

- inject the ParameterContainer into the Statement object

- execute the Statement object, producing a Result object

- check the Result object to check if the supplied sql was a "query", or a result set producing statement

- if it is a result set producing query, clone the ResultSet prototype, inject Result as datasource, return it

- else, return the Result

.. _zend.db.adapter.query-execution:

Query Execution Through Zend\\Db\\Adapter\\Adapter::query()
-----------------------------------------------------------

In some cases, you have to execute statements directly. The primary purpose for needing to execute sql instead of prepare and execute a sql statement, might be because you are attempting to execute a DDL statement (which in most extensions and vendor platforms), are un-preparable. An example of executing:

.. code-block:: php
   :linenos:

               $adapter->query('ALTER TABLE ADD INDEX(`foo_index`) ON (`foo_column`))', Adapter::QUERY_MODE_EXECUTE);

The primary difference to notice is that you must provide the Adapter::QUERY_MODE_EXECUTE (execute) as the second parameter.

.. _zend.db.adapter.statement-creation:

Creating Statements
-------------------

While query() is highly useful for one-off and quick querying of a database through Adapter, it generally makes more sense to create a statement and interact with it directly, so that you have greater control over the prepare-then-execute workflow. To do this, Adapter gives you a routine called createStatement() that allows you to create a Driver specific Statement to use so you can manage your own prepare-then-execute workflow.

.. code-block:: php
   :linenos:

   $statement = $adapter->createStatement($sql, $optionalParameters);
   $result = $statement->execute();

.. _zend.db.adapter.platform:

Using The Platform Object
-------------------------

The Platform object provides an API to assist in crafting queries in a way that is specific to the SQL implementation of a particular vendor. Nuances such as how identifiers or values are quoted, or what the identifier separator character is are handled by this object. To get an idea of the capabilities, the interface for a platform object looks like this:

.. code-block:: php
   :linenos:

   interface Zend\Db\Adapter\Platform\PlatformInterface
   {
       public function getName();
       public function getQuoteIdentifierSymbol();
       public function quoteIdentifier($identifier);
       public function getQuoteValueSymbol();
       public function quoteValue($value);
       public function getIdentifierSeparator();
       public function quoteIdentifierInFragment($identifier, array $additionalSafeWords = array());
   }

For example, to quote a column name, specific to MySQL's way of quoting:

.. code-block:: php
   :linenos:

   $platform = new Zend\Db\Adapter\Platform\Mysql;
   $column = $platform->quoteIdentifier('first_name'); // returns `first_name`

Generally speaking, it is easier to get the proper Platform instance from the adapter:

.. code-block:: php
   :linenos:

   $platform = $adapter->getPlatform();
   // or
   $platform = $adapter->platform; // magic property access

.. _zend.db.adapter.parameter-container:

Using The Parameter Container
-----------------------------

The ParameterContainer object is a container for the various parameters that need to be passed into a Statement object to fulfill all the various parameterized parts of the SQL statement. This object implements the ArrayAccess interface.

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

   /* @var $statement Zend\Db\Adapter\DriverStatementInterface */
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


