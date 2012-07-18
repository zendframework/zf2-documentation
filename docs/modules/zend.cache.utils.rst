.. _zend.cache.utils:

Zend\\Cache\\Utils
==================

.. _zend.cache.utils.intro:

Overview
--------

The class ``Zend\Cache\Utils`` is a class that defines a set of methods that perform common, often re-used logic
needed by the ``Zend\Cache`` component.

It is a static class and has only static members.

.. _zend.cache.utils.methods:

Available Methods
-----------------

.. _zend.cache.utils.methods.get-disk-capacity:

**getDiskCapacity**
   ``getDiskCapacity(string $path)``
   Get disk capacity

   Returns array

.. _zend.cache.utils.methods.get-php-memory-capacity:

**getPhpMemoryCapacity**
   ``getPhpMemoryCapacity()``
   Get php memory capacity

   Returns array

.. _zend.cache.utils.methods.get-system-memory-capacity:

**getSystemMemoryCapacity**
   ``getSystemMemoryCapacity()``
   Get system memory capacity

   Returns array

.. _zend.cache.utils.methods.generate-hash:

**generateHash**
   ``generateHash(string $algo, string $data, bool $raw = false)``
   Generate a hash value.

   This helper adds the virtual hash algo "strlen".

   Returns string

.. _zend.cache.utils.methods.get-hash-algos:

**getHashAlgos**
   ``getHashAlgos()``
   Return a list of registered hashing algorithms, incl. the virtual hash algo "strlen".

   Returns string

.. _zend.cache.utils.examples:

Examples
--------

.. _zend.cache.utils.examples.getCapacity:

.. rubric:: Get capacity of a disk path, internal php memory, or the system memory

.. code-block:: php
   :linenos:

   use Zend\Cache\Utils;

   var_dump(Utils::getDiskCapacity(__DIR__));
   var_dump(Utils::getPhpMemoryCapacity());
   var_dump(Utils::getSystemMemoryCapacity());

   /*
    * Will produce:
    *
    * array(2) {
    *   ["total"]=>
    *   float(892826808320)
    *   ["free"]=>
    *   float(649714921472)
    * }
    * array(2) {
    *   ["total"]=>
    *   float(134217728)
    *   ["free"]=>
    *   float(129236992)
    * }
    * array(2) {
    *   ["total"]=>
    *   float(516055040)
    *   ["free"]=>
    *   float(417021952)
    * }
    */


