
Usage, API and Extensions Points
================================

The Quickstart already gave a good introduction on how database testing can be done using PHPUnit and the Zend Framework. This section gives an overview over the *API* that the ``Zend_Test_PHPUnit_Db`` component comes with and how it works internally.

.. note::
    **Some Remarks on Database Testing**

    Just as the Controller TestCase is testing an application at an integration level, the Database TestCase is an integration testing method. Its using several different application layers for testing purposes and therefore should be consumed with caution.

    It should be noted that testing domain and business logic with integration tests such as Zend Framework's Controller and Database TestCases is a bad practice. The purpose of an Integration test is to check that several parts of an application work smoothly when wired together. These integration tests do not replace the need for a set of unit tests that test the domain and business logic at a much smaller level, the isolated class.

.. _zend.test.phpunit.db.testing.testcase:

The Zend_Test_PHPUnit_DatabaseTestCase class
--------------------------------------------

The ``Zend_Test_PHPUnit_DatabaseTestCase`` class derives from the ``PHPUnit_Extensions_Database_TestCase`` which allows to setup tests with a fresh database fixture on each run easily. The Zend implementation offers some additional convenience features over the PHPUnit Database extension when it comes to using ``Zend_Db`` resources inside your tests. The workflow of a database test-case can be described as follows.

For each test PHPUnit creates a new instance of the TestCase and calls the ``setUp()`` method.

The Database TestCase creates an instance of a Database Tester which handles the setting up and tearing down of the database.

The database tester collects the information on the database connection and initial dataset from ``getConnection()`` and ``getDataSet()`` which are both abstract methods and have to be implemented by any Database Testcase.

By default the database tester truncates the tables specified in the given dataset, and then inserts the data given as initial fixture.

When the database tester has finished setting up the database, PHPUnit runs the test.

After running the test, ``tearDown()`` is called. Because the database is wiped in ``setUp()`` before inserting the required initial fixture, no actions are executed by the database tester at this stage.

.. note::
    ****

    The Database TestCase expects the database schema and tables to be setup correctly to run the tests. There is no mechanism to create and tear down database tables.

The ``Zend_Test_PHPUnit_DatabaseTestCase`` class has some convenience functions that can help writing tests that interact with the database and the database testing extension.

The next table lists only the new methods compared to the ``PHPUnit_Extensions_Database_TestCase`` , whose `API is documented in the PHPUnit Documentation`_ .

.. _zend.test.phpunit.db.testing.testcase.api-methods:


Zend_Test_PHPUnit_DatabaseTestCase API Methods
----------------------------------------------
+---------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Method                                                                                                   |Description                                                                                                                                                                                                                                  |
+=========================================================================================================+=============================================================================================================================================================================================================================================+
|createZendDbConnection(Zend_Db_Adapter_Abstract $connection, $schema)                                    |Create a PHPUnit Database Extension compatible Connection instance from a Zend_Db_Adapter_Abstract instance. This method should be used in for testcase setup when implementing the abstract getConnection() method of the database testcase.|
+---------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|getAdapter()                                                                                             |Convenience method to access the underlying Zend_Db_Adapter_Abstract instance which is nested inside the PHPUnit database connection created with getConnection().                                                                           |
+---------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|createDbRowset(Zend_Db_Table_Rowset_Abstract $rowset, $tableName = null)                                 |Create a DataTable Object that is filled with the data from a given Zend_Db_Table_Rowset_Abstract instance. The table the rowset is connected to is chosen when $tableName is NULL.                                                          |
+---------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|createDbTable(Zend_Db_Table_Abstract $table, $where = null, $order = null, $count = null, $offset = null)|Create a DataTable object that represents the data contained in a Zend_Db_Table_Abstract instance. For retrieving the data fetchAll() is used, where the optional parameters can be used to restrict the data table to a certain subset.     |
+---------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|createDbTableDataSet(array $tables=array())                                                              |Create a DataSet containing the given $tables, an array of Zend_Db_Table_Abstract instances.                                                                                                                                                 |
+---------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+


.. _zend.test.phpunit.db.testing.controllerintegration:

Integrating Database Testing with the ControllerTestCase
--------------------------------------------------------

Because *PHP* does not support multiple inheritance it is not possible to use the Controller and Database testcases in conjunction. However you can use the ``Zend_Test_PHPUnit_Db_SimpleTester`` database tester in your controller test-case to setup a database enviroment fixture for each new controller test. The Database TestCase in general is only a set of convenience functions which can also be accessed and used without the test case.

.. _zend.test.phpunit.db.testing.controllerintegration.example:

Database integration example
----------------------------

This example extends the User Controller Test from the ``Zend_Test_PHPUnit_ControllerTestCase`` documentation to include a database setup.

.. code-block:: php
    :linenos:
    
    class UserControllerTest extends Zend_Test_PHPUnit_ControllerTestCase
    {
        public function setUp()
        {
            $this->setupDatabase();
            $this->bootstrap = array($this, 'appBootstrap');
            parent::setUp();
        }
    
        public function setupDatabase()
        {
            $db = Zend_Db::factory(...);
            $connection = new Zend_Test_PHPUnit_Db_Connection($db,
                                                          'database_schema_name');
            $databaseTester = new Zend_Test_PHPUnit_Db_SimpleTester($connection);
    
            $databaseFixture =
                        new PHPUnit_Extensions_Database_DataSet_FlatXmlDataSet(
                            dirname(__FILE__) . '/_files/initialUserFixture.xml'
                        );
    
            $databaseTester->setupDatabase($databaseFixture);
        }
    }
    

Now the Flat *XML* dataset "initialUserFixture.xml" is used to set the database into an initial state before each test, exactly as the DatabaseTestCase works internally.


.. _`API is documented in the PHPUnit Documentation`: http://www.phpunit.de/manual/current/en/database.html
