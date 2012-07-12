
Zend_Test_PHPUnit_Db
====================

Coupling of data-access and the domain model often requires the use of a database for testing purposes. But the database is persistent across different tests which leads to test results that can affect each other. Furthermore setting up the database to be able to run a test is quite some work. PHPUnit's Database extension simplifies testing with a database by offering a very simple mechanism to set up and teardown the database between different tests. This component extends the PHPUnit Database extension with Zend Framework specific code, such that writing database tests against a Zend Framework application is simplified.

Database Testing can be explained with two conceptual entities, DataSets and DataTables. Internally the PHPUnit Database extension can build up an object structure of a database, its tables and containing rows from configuration files or the real database content. This abstract object graph can then be compared using assertions. A common use-case in database testing is setting up some tables with seed data, then performing some operations, and finally asserting that the operated on database-state is equal to some predefined expected state. ``Zend_Test_PHPUnit_Db`` simplifies this task by allowing to generate DataSets and DataTables from existing ``Zend_Db_Table_Abstract`` or ``Zend_Db_Table_Rowset_Abstract`` instances.

Furthermore this component allows to integrate any ``Zend_Db_Adapter_Abstract`` for testing whereas the original extension only works with *PDO* . A Test Adapter implementation for ``Zend_Db_Adapter_Abstract`` is also included in this component. It allows to instantiate a Db Adapter that requires no database at all and acts as an *SQL* and result stack which is used by the *API* methods.

.. include:: zend.test.phpunit.db.quickstart.rst
.. include:: zend.test.phpunit.db.testing.rst
.. include:: zend.test.phpunit.db.adapter.rst

