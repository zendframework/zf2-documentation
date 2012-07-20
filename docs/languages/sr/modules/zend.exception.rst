.. _zend.exception.using:

Koriscenje izuzetaka
====================

All exceptions thrown by Zend Framework classes should throw an exception that derives from the base class
Zend_Exception.

.. _zend.exception.using.example:

.. rubric:: Example of catching an exception

.. code-block::
   :linenos:
   <?php

   try {
       Zend_Loader::loadClass('nonexistantclass');
   } catch (Zend_Exception $e) {
       echo "Caught exception: " . get_class($e) . "\n";
       echo "Message: " . $e->getMessage() . "\n";
       // other code to recover from the failure.
   }

   ?>
See the documentation for each respective Zend Framework component for more specific information on which methods
throw exceptions, the circumstances for the exceptions, and which exception classes derive from Zend_Exception.


