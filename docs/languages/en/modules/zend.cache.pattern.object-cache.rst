.. _zend.cache.pattern.object-cache:

Zend\\Cache\\Pattern\\ObjectCache
=================================

.. _zend.cache.pattern.object-cache.overview:

Overview
--------

The ``ObjectCache`` pattern is an extension to the ``CallbackCache`` pattern.
It has the same methods but instead it generates the internally used callback in base of
the configured object and the given method name.

.. _zend.cache.pattern.object-cache.quick-start:

Quick Start
-----------

Instantiating the object cache pattern

.. code-block:: php
   :linenos:

   use Zend\Cache\PatternFactory;

   $object      = new stdClass();
   $objectCache = PatternFactory::factory('object', array(
       'object'  => $object,
       'storage' => 'apc'
   ));

.. _zend.cache.pattern.object-cache.options:

Configuration Options
---------------------

+------------------------------+-------------------------------------------------------------+-----------------------+-----------------------------------------------------------------+
|Option                        |Data Type                                                    |Default Value          |Description                                                      |
+==============================+=============================================================+=======================+=================================================================+
|storage                       |``string`` ``array`` ``Zend\Cache\Storage\StorageInterface`` |<none>                 |The storage to write/read cached data                            |
+------------------------------+-------------------------------------------------------------+-----------------------+-----------------------------------------------------------------+
|object                        |``object``                                                   |<none>                 |The object to cache methods calls of                             |
+------------------------------+-------------------------------------------------------------+-----------------------+-----------------------------------------------------------------+
|object_key                    |``null`` ``string``                                          |<Class name of object> |A hopefully unique key of the object                             |
+------------------------------+-------------------------------------------------------------+-----------------------+-----------------------------------------------------------------+
|cache_output                  |``boolean``                                                  |``true``               |Cache output of callback                                         |
+------------------------------+-------------------------------------------------------------+-----------------------+-----------------------------------------------------------------+
|cache_by_default              |``boolean``                                                  |``true``               |Cache method calls by default                                    |
+------------------------------+-------------------------------------------------------------+-----------------------+-----------------------------------------------------------------+
|object_cache_methods          |``array``                                                    |``[]``                 |List of methods to cache (If ``cache_by_default`` is disabled)   |
+------------------------------+-------------------------------------------------------------+-----------------------+-----------------------------------------------------------------+
|object_non_cache_methods      |``array``                                                    |``[]``                 |List of methods to no-cache (If ``cache_by_default`` is enabled) |
+------------------------------+-------------------------------------------------------------+-----------------------+-----------------------------------------------------------------+
|object_cache_magic_properties |``boolean``                                                  |``false``              |Cache calls of magic object properties                           |
+------------------------------+-------------------------------------------------------------+-----------------------+-----------------------------------------------------------------+

.. _zend.cache.pattern.object-cache.methods:

Available Methods
-----------------

.. _zend.cache.pattern.object-cache.methods.call:

**call**
   ``call(string $method, array $args = array())``

   Call the specified method of the configured object

   Returns the result

.. _zend.cache.pattern.object-cache.methods.__call:

**__call**
   ``__call(string $method, array $args)``

   Call the specified method of the configured object

   Returns the result

**__set**

    ``__set(string $name, mixed $value)``
    
    Set a property of the configured object

**__get**

    ``__get(string $name)``
    
    Get a property of the configured object

**__isset**

    ``__isset(string $name)``

    Checks if static property of the configured object exists

**__unset**

    ``__unset(string $name)``

    Unset a property of the configured object

**generateKey**
   ``generateKey(string $method, array $args = array())``

   Generate a unique key in base of a key representing the callback part
   and a key representing the arguments part.

   Returns the key

.. _zend.cache.pattern.object-cache.methods.set-options:

**setOptions**
   ``setOptions(Zend\Cache\Pattern\PatternOptions $options)``

   Set pattern options

   Returns Zend\\Cache\\Pattern\\ObjectCache

.. _zend.cache.pattern.object-cache.methods.get-options:

**getOptions**
   ``getOptions()``

   Get all pattern options

   Returns ``PatternOptions`` instance.

.. _zend.cache.pattern.pattern-factory.examples:

Examples
--------

.. _zend.cache.pattern.object-cache.examples.cached-filter:

.. rubric:: Caching a filter

.. code-block:: php
   :linenos:

   $filter       = new Zend\Filter\RealPath();
   $cachedFilter = Zend\Cache\PatternFactory::factory('object', array(
       'object'     => $filter,
	   'object_key' => 'RealpathFilter',
       'storage'    => 'apc',
       
       // The realpath filter doesn't output anything
       // so the output don't need to be catched and cached
       'cache_output' => false,
   ));

   $path = $cachedFilter->call("filter", array('/www/var/path/../../mypath'));
   // OR
   $path = $cachedFilter->filter('/www/var/path/../../mypath');
