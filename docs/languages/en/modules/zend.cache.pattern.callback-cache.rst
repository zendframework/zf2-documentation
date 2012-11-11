.. _zend.cache.pattern.callback-cache:

Zend\\Cache\\Pattern\\CallbackCache
===================================

.. _zend.cache.pattern.callback-cache.overview:

Overview
--------

The callback cache pattern caches calls of non specific functions and methods given as a callback.

.. _zend.cache.pattern.callback-cache.quick-start:

Quick Start
-----------

For instantiation you can use the ``PatternFactory`` or do it manual:

.. code-block:: php
   :linenos:

   use Zend\Cache\PatternFactory;
   use Zend\Cache\Pattern\PatternOptions;

   // Via the factory:
   $callbackCache = PatternFactory::factory('callback', array(
       'storage'      => 'apc',
       'cache_output' => true,
   ));

   // OR, the equivalent manual instantiation:
   $callbackCache = new \Zend\Cache\Pattern\CallbackCache();
   $callbackCache->setOptions(new PatternOptions(array(
       'storage'      => 'apc',
       'cache_output' => true,
   )));

.. _zend.cache.pattern.callback-cache.options:

Configuration Options
---------------------

+-------------+-------------------------------------------------------------+--------------+--------------------------------------+
|Option       |Data Type                                                    |Default Value |Description                           |
+=============+=============================================================+==============+======================================+
|storage      |``string`` ``array`` ``Zend\Cache\Storage\StorageInterface`` |<none>        |The storage to write/read cached data |
+-------------+-------------------------------------------------------------+--------------+--------------------------------------+
|cache_output |``boolean``                                                  |``true``      |Cache output of callback              |
+-------------+-------------------------------------------------------------+--------------+--------------------------------------+

.. _zend.cache.pattern.callback-cache.methods:

Available Methods
-----------------

.. _zend.cache.pattern.callback-cache.methods.call:

**call**
   ``call(callable $callback, array $args = array())``

   Call the specified callback or get the result from cache

   Returns the result

.. _zend.cache.pattern.callback-cache.methods.__call:

**__call**
   ``__call(string $function, array $args)``

   Function call handler

   Returns the result

**generateKey**
   ``generateKey(callable $callback, array $args = array())``

   Generate a unique key in base of a key representing the callback part
   and a key representing the arguments part.

   Returns the key

.. _zend.cache.pattern.callback-cache.methods.set-options:

**setOptions**
   ``setOptions(Zend\Cache\Pattern\PatternOptions $options)``

   Set pattern options

   Returns Zend\\Cache\\Pattern\\CallbackCache

.. _zend.cache.pattern.callback-cache.methods.get-options:

**getOptions**
   ``getOptions()``

   Get all pattern options

   Returns ``PatternOptions`` instance.

.. _zend.cache.pattern.pattern-factory.examples:

Examples
--------

.. _zend.cache.pattern.callback-cache.examples.instantiate:

.. rubric:: Instantiating the callback cache pattern

.. code-block:: php
   :linenos:

   use Zend\Cache\PatternFactory;

   $callbackCache = PatternFactory::factory('callback', array(
       'storage' => 'apc'
   ));
