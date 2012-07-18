.. _zend.exception.previous:

Previous Exceptions
===================

Since Zend Framework 1.10, ``Zend_Exception`` implements the *PHP* 5.3 support for previous exceptions. Simply put, when in a ``catch()`` block, you can throw a new exception that references the original exception, which helps provide additional context when debugging. By providing this support in Zend Framework, your code may now be forwards compatible with *PHP* 5.3.

Previous exceptions are indicated as the third argument to an exception constructor.

.. _zend.exception.previous.example:

.. rubric:: Previous exceptions

.. code-block:: php
   :linenos:

   try {
       $db->query($sql);
   } catch (Zend_Db_Statement_Exception $e) {
       if ($e->getPrevious()) {
           echo '[' . get_class($e)
               . '] has the previous exception of ['
               . get_class($e->getPrevious())
               . ']' . PHP_EOL;
       } else {
           echo '[' . get_class($e)
               . '] does not have a previous exception'
               . PHP_EOL;
       }

       echo $e;
       // displays all exceptions starting by the first thrown
       // exception if available.
   }


