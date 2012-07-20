.. _zend.exception.basic:

Basic usage
===========

``Zend_Exception`` is the base class for all exceptions thrown by Zend Framework. This class extends the base
``Exception`` class of PHP.

.. _zend.exception.catchall.example:

.. rubric:: Catch all Zend Framework exceptions

.. code-block:: php
   :linenos:

   try {
       // your code
   } catch (Zend_Exception $e) {
       // do something
   }

.. _zend.exception.catchcomponent.example:

.. rubric:: Catch exceptions thrown by a specific component of Zend Framework

.. code-block:: php
   :linenos:

   try {
       // your code
   } catch (Zend_Db_Exception $e) {
       // do something
   }


