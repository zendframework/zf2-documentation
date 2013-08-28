.. _zend.exception.using:

Using Exceptions
================

``Zend_Exception`` is simply the base class for all exceptions thrown within Zend Framework.

.. _zend.exception.using.example:

.. rubric:: Catching an Exception

The following code listing demonstrates how to catch an exception thrown in a Zend Framework class:

.. code-block:: php
   :linenos:

   try {
       // Calling Zend\Loader\Loader::loadClass() with a non-existent class will cause
       // an exception to be thrown in Zend\Loader\Loader:
       Zend\Loader\Loader::loadClass('NonExistentClass');
   } catch (Zend_Exception $e) {
       echo "Caught exception: " . get_class($e) . "\n";
       echo "Message: " . $e->getMessage() . "\n";
       // Other code to recover from the error
   }

``Zend_Exception`` can be used as a catch-all exception class in a catch block to trap all exceptions thrown by
Zend Framework classes. This can be useful when the program can not recover by catching a specific exception type.

The documentation for each Zend Framework component and class will contain specific information on which methods
throw exceptions, the circumstances that cause an exception to be thrown, and the various exception types that may
be thrown.


