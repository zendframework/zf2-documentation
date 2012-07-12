
Quickstart
==========

.. _zend.test.phpunit.db.quickstart.testcase:

Setup a Database TestCase
-------------------------

We are now writting some database tests for the Bug Database example in the ``Zend_Db_Table`` documentation. First we begin to test that inserting a new bug is actually saved in the database correctly. First we have to setup a test-class that extends ``Zend_Test_PHPUnit_DatabaseTestCase`` . This class extends the PHPUnit Database Extension, which in turn extends the basic ``PHPUnit_Framework_TestCase`` . A database testcase contains two abstract methods that have to be implemented, one for the database connection and one for the initial dataset that should be used as seed or fixture.

.. note::
    ****

    You should be familiar with the PHPUnit Database extension to follow this quickstart easily. Although all the concepts are explained in this documentation it may be helpful to read the PHPUnit documentation first.

.. code-block:: php
    :linenos:
    
    class BugsTest extends Zend_Test_PHPUnit_DatabaseTestCase
    {
        private $_connectionMock;
    
        /**
         * Returns the test database connection.
         *
         * @return PHPUnit_Extensions_Database_DB_IDatabaseConnection
         */
        protected function getConnection()
        {
            if($this->_connectionMock == null) {
                $connection = Zend_Db::factory(...);
                $this->_connectionMock = $this->createZendDbConnection(
                    $connection, 'zfunittests'
                );
                Zend_Db_Table_Abstract::setDefaultAdapter($connection);
            }
            return $this->_connectionMock;
        }
    
        /**
         * @return PHPUnit_Extensions_Database_DataSet_IDataSet
         */
        protected function getDataSet()
        {
            return $this->createFlatXmlDataSet(
                dirname(__FILE__) . '/_files/bugsSeed.xml'
            );
        }
    }
    

Here we create the database connection and seed some data into the database. Some important details should be noted on this code:

    - You cannot directly return a Zend_Db_Adapter_Abstract
    - from the getConnection() method, but a PHPUnit
    - specific wrapper which is generated with the
    - createZendDbConnection() method.
    - The database schema (tables and database) is not re-created on every
    - testrun. The database and tables have to be created manually before running
    - the tests.
    - Database tests by default truncate the data during
    - setUp() and then insert the seed data which is
    - returned from the getDataSet() method.
    - DataSets have to implement the interface
    - PHPUnit_Extensions_Database_DataSet_IDataSet.
    - There is a wide range of XML and YAML configuration file
    - types included in PHPUnit which allows to specifiy how the tables and datasets
    - should look like and you should look into the PHPUnit documentation to get the
    - latest information on these dataset specifications.


.. _zend.test.phpunit.db.quickstart.dataset:

Specify a seed dataset
----------------------

In the previous setup for the database testcase we have specified a seed file for the database fixture. We now create this file specified in the Flat *XML* format:

.. code-block:: php
    :linenos:
    
    <?xml version="1.0" encoding="UTF-8" ?>
    <dataset>
        <zfbugs bug_id="1" bug_description="system needs electricity to run"
            bug_status="NEW" created_on="2007-04-01 00:00:00"
            updated_on="2007-04-01 00:00:00" reported_by="goofy"
            assigned_to="mmouse" verified_by="dduck" />
        <zfbugs bug_id="2" bug_description="Implement Do What I Mean function"
            bug_status="VERIFIED" created_on="2007-04-02 00:00:00"
            updated_on="2007-04-02 00:00:00" reported_by="goofy"
            assigned_to="mmouse" verified_by="dduck" />
        <zfbugs bug_id="3" bug_description="Where are my keys?" bug_status="FIXED"
            created_on="2007-04-03 00:00:00" updated_on="2007-04-03 00:00:00"
            reported_by="dduck" assigned_to="mmouse" verified_by="dduck" />
        <zfbugs bug_id="4" bug_description="Bug no product" bug_status="INCOMPLETE"
            created_on="2007-04-04 00:00:00" updated_on="2007-04-04 00:00:00"
            reported_by="mmouse" assigned_to="goofy" verified_by="dduck" />
    </dataset>
    

We will work with this four entries in the database table "zfbugs" in the next examples. The required MySQL schema for this example is:

.. code-block:: php
    :linenos:
    
    CREATE TABLE IF NOT EXISTS `zfbugs` (
        `bug_id` int(11) NOT NULL auto_increment,
        `bug_description` varchar(100) default NULL,
        `bug_status` varchar(20) default NULL,
        `created_on` datetime default NULL,
        `updated_on` datetime default NULL,
        `reported_by` varchar(100) default NULL,
        `assigned_to` varchar(100) default NULL,
        `verified_by` varchar(100) default NULL,
    PRIMARY KEY  (`bug_id`)
    ) ENGINE=InnoDB AUTO_INCREMENT=1 ;
    

.. _zend.test.phpunit.db.quickstart.initial-tests:

A few initial database tests
----------------------------

Now that we have implemented the two required abstract methods of the ``Zend_Test_PHPUnit_DatabaseTestCase`` and specified the seed database content, which will be re-created for each new test, we can go about to make our first assertion. This will be a test to insert a new bug.

.. code-block:: php
    :linenos:
    
    class BugsTest extends Zend_Test_PHPUnit_DatabaseTestCase
    {
        public function testBugInsertedIntoDatabase()
        {
            $bugsTable = new Bugs();
    
            $data = array(
                'created_on'      => '2007-03-22 00:00:00',
                'updated_on'      => '2007-03-22 00:00:00',
                'bug_description' => 'Something wrong',
                'bug_status'      => 'NEW',
                'reported_by'     => 'garfield',
                'verified_by'     => 'garfield',
                'assigned_to'     => 'mmouse',
            );
    
            $bugsTable->insert($data);
    
            $ds = new Zend_Test_PHPUnit_Db_DataSet_QueryDataSet(
                $this->getConnection()
            );
            $ds->addTable('zfbugs', 'SELECT * FROM zfbugs');
    
            $this->assertDataSetsEqual(
                $this->createFlatXmlDataSet(dirname(__FILE__)
                                          . "/_files/bugsInsertIntoAssertion.xml"),
                $ds
            );
        }
    }
    

Now up to the ``$bugsTable->insert($data);`` everything looks familiar. The lines after that contain the assertion methodname. We want to verify that after inserting the new bug the database has been updated correctly with the given data. For this we create a ``Zend_Test_PHPUnit_Db_DataSet_QueryDataSet`` instance and give it a database connection. We will then tell this dataset that it contains a table "zfbugs" which is given by an *SQL* statement. This current/actual state of the database is compared to the expected database state which is contained in another *XML* file "bugsInsertIntoAssertions.xml". This *XML* file is a slight deviation from the one given above and contains another row with the expected data:

.. code-block:: php
    :linenos:
    
    <?xml version="1.0" encoding="UTF-8" ?>
    <dataset>
        <!-- previous 4 rows -->
        <zfbugs bug_id="5" bug_description="Something wrong" bug_status="NEW"
            created_on="2007-03-22 00:00:00" updated_on="2007-03-22 00:00:00"
            reported_by="garfield" assigned_to="mmouse" verified_by="garfield" />
    </dataset>
    

There are other ways to assert that the current database state equals an expected state. The "Bugs" table in the example already knows a lot about its inner state, so why not use this to our advantage? The next example will assert that deleting from the database is possible:

.. code-block:: php
    :linenos:
    
    class BugsTest extends Zend_Test_PHPUnit_DatabaseTestCase
    {
        public function testBugDelete()
        {
            $bugsTable = new Bugs();
    
            $bugsTable->delete(
                $bugsTable->getAdapter()->quoteInto("bug_id = ?", 4)
            );
    
            $ds = new Zend_Test_PHPUnit_Db_DataSet_DbTableDataSet();
            $ds->addTable($bugsTable);
    
            $this->assertDataSetsEqual(
                $this->createFlatXmlDataSet(dirname(__FILE__)
                                          . "/_files/bugsDeleteAssertion.xml"),
                $ds
            );
        }
    }
    

We have created a ``Zend_Test_PHPUnit_Db_DataSet_DbTableDataSet`` dataset here, which takes any ``Zend_Db_Table_Abstract`` instance and adds it to the dataset with its table name, in this example "zfbugs". You could add several tables more if you wanted using the method ``addTable()`` if you want to check for expected database state in more than one table.

Here we only have one table and check against an expected database state in "bugsDeleteAssertion.xml" which is the original seed dataset without the row with id 4.

Since we have only checked that two specific tables (not datasets) are equal in the previous examples we should also look at how to assert that two tables are equal. Therefore we will add another test to our TestCase which verifies updating behaviour of a dataset.

.. code-block:: php
    :linenos:
    
    class BugsTest extends Zend_Test_PHPUnit_DatabaseTestCase
    {
        public function testBugUpdate()
        {
            $bugsTable = new Bugs();
    
            $data = array(
                'updated_on'      => '2007-05-23',
                'bug_status'      => 'FIXED'
            );
    
            $where = $bugsTable->getAdapter()->quoteInto('bug_id = ?', 1);
    
            $bugsTable->update($data, $where);
    
            $rowset = $bugsTable->fetchAll();
    
            $ds        = new Zend_Test_PHPUnit_Db_DataSet_DbRowset($rowset);
            $assertion = $this->createFlatXmlDataSet(
                dirname(__FILE__) . '/_files/bugsUpdateAssertion.xml'
            );
            $expectedRowsets = $assertion->getTable('zfbugs');
    
            $this->assertTablesEqual(
                $expectedRowsets, $ds
            );
        }
    }
    

Here we create the current database state from a ``Zend_Db_Table_Rowset_Abstract`` instance in conjunction with the ``Zend_Test_PHPUnit_Db_DataSet_DbRowset($rowset)`` instance which creates an internal data-representation of the rowset. This can again be compared against another data-table by using the ``$this->assertTablesEqual()`` assertion.


