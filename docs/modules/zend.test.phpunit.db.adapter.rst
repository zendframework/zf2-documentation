
Using the Database Testing Adapter
==================================

There are times when you don't want to test parts of your application with a real database, but are forced to because of coupling. The ``Zend_Test_DbAdapter`` offers a convenient way to use a implementation of ``Zend_Db_Adapter_Abstract`` without having to open a database connection. Furthermore this Adapter is very easy to mock from within your PHPUnit testsuite, since it requires no constructor arguments.

The Test Adapter acts as a stack for various database results. Its order of results have to be userland implemented, which might be a tedious task for tests that call many different database queries, but its just the right helper for tests where only a handful of queries are executed and you know the exact order of the results that have to be returned to your userland code.

.. code-block:: php
    :linenos:
    
    $adapter   = new Zend_Test_DbAdapter();
    $stmt1Rows = array(array('foo' => 'bar'), array('foo' => 'baz'));
    $stmt1     = Zend_Test_DbStatement::createSelectStatement($stmt1Rows);
    $adapter->appendStatementToStack($stmt1);
    
    $stmt2Rows = array(array('foo' => 'bar'), array('foo' => 'baz'));
    $stmt2     = Zend_Test_DbStatement::createSelectStatement($stmt2Rows);
    $adapter->appendStatementToStack($stmt2);
    
    $rs = $adapter->query('SELECT ...'); // Returns Statement 2
    while ($row = $rs->fetch()) {
        echo $rs['foo']; // Prints "Bar", "Baz"
    }
    $rs = $adapter->query('SELECT ...'); // Returns Statement 1
    

Behaviour of any real database adapter is simulated as much as possible such that methods like ``fetchAll()`` , ``fetchObject()`` , ``fetchColumn`` and more are working for the test adapter.

You can also put INSERT, UPDATE and DELETE statement onto the result stack, these however only return a statement which allows to specifiy the result of ``$stmt->rowCount()`` .

.. code-block:: php
    :linenos:
    
    $adapter = new Zend_Test_DbAdapter();
    $adapter->appendStatementToStack(
        Zend_Test_DbStatement::createInsertStatement(1)
    );
    $adapter->appendStatementToStack(
        Zend_Test_DbStatement::createUpdateStatement(2)
    );
    $adapter->appendStatementToStack(
        Zend_Test_DbStatement::createDeleteStatement(10
    ));
    

By default the query profiler is enabled, so that you can retrieve the executed SQL statements and their bound parameters to check for the correctness of the execution.

.. code-block:: php
    :linenos:
    
    $adapter = new Zend_Test_DbAdapter();
    $stmt = $adapter->query("SELECT * FROM bugs");
    
    $qp = $adapter->getProfiler()->getLastQueryProfile();
    
    echo $qp->getQuerY(); // SELECT * FROM bugs
    

The test adapter never checks if the query specified is really of the type SELECT, DELETE, INSERT or UPDATE which is returned next from the stack. The correct order of returning the data has to be implemented by the user of the test adapter.

The Test adapter also specifies methods to simulate the use of the methods ``listTables()`` , ``describeTables()`` and ``lastInsertId()`` . Additionally using the ``setQuoteIdentifierSymbol()`` you can specify which symbol should be used for quoting, by default none is used.


