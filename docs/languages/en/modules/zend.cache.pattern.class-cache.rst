.. _zend.cache.pattern.class-cache:

Zend\\Cache\\Pattern\\ClassCache
================================

.. _zend.cache.pattern.class-cache.overview:

Overview
--------

The ``ClassCache`` pattern is an extension to the ``CallbackCache`` pattern.
It has the same methods but instead it generates the internally used callback in base of
the configured class name and the given method name.

.. _zend.cache.pattern.class-cache.quick-start:

Quick Start
-----------

Instantiating the class cache pattern

.. code-block:: php
   :linenos:

   use Zend\Cache\PatternFactory;

   $classCache = PatternFactory::factory('class', array(
       'class'   => 'MyClass',
       'storage' => 'apc'
   ));

.. _zend.cache.pattern.class-cache.options:

Configuration Options
---------------------

+------------------------+-------------------------------------------------------------+--------------+-----------------------------------------------------------------+
|Option                  |Data Type                                                    |Default Value |Description                                                      |
+========================+=============================================================+==============+=================================================================+
|storage                 |``string`` ``array`` ``Zend\Cache\Storage\StorageInterface`` |<none>        |The storage to write/read cached data                            |
+------------------------+-------------------------------------------------------------+--------------+-----------------------------------------------------------------+
|class                   |``string``                                                   |<none>        |The class name                                                   |
+------------------------+-------------------------------------------------------------+--------------+-----------------------------------------------------------------+
|cache_output            |``boolean``                                                  |``true``      |Cache output of callback                                         |
+------------------------+-------------------------------------------------------------+--------------+-----------------------------------------------------------------+
|cache_by_default        |``boolean``                                                  |``true``      |Cache method calls by default                                    |
+------------------------+-------------------------------------------------------------+--------------+-----------------------------------------------------------------+
|class_cache_methods     |``array``                                                    |``[]``        |List of methods to cache (If ``cache_by_default`` is disabled)   |
+------------------------+-------------------------------------------------------------+--------------+-----------------------------------------------------------------+
|class_non_cache_methods |``array``                                                    |``[]``        |List of methods to no-cache (If ``cache_by_default`` is enabled) |
+------------------------+-------------------------------------------------------------+--------------+-----------------------------------------------------------------+

.. _zend.cache.pattern.class-cache.methods:

Available Methods
-----------------

.. _zend.cache.pattern.class-cache.methods.call:

**call**
   ``call(string $method, array $args = array())``

   Call the specified method of the configured class

   Returns the result

.. _zend.cache.pattern.class-cache.methods.__call:

**__call**
   ``__call(string $method, array $args)``

   Call the specified method of the configured class

   Returns the result

**__set**

    ``__set(string $name, mixed $value)``
    
    Set a static property of the configured class

**__get**

    ``__get(string $name)``
    
    Get a static property of the configured class

**__isset**

    ``__isset(string $name)``

    Checks if a static property of the configured class exists

**__unset**

    ``__unset(string $name)``

    Unset a static property of the configured class

**generateKey**
   ``generateKey(string $method, array $args = array())``

   Generate a unique key in base of a key representing the callback part
   and a key representing the arguments part.

   Returns the key

.. _zend.cache.pattern.class-cache.methods.set-options:

**setOptions**
   ``setOptions(Zend\Cache\Pattern\PatternOptions $options)``

   Set pattern options

   Returns Zend\\Cache\\Pattern\\ClassCache

.. _zend.cache.pattern.class-cache.methods.get-options:

**getOptions**
   ``getOptions()``

   Get all pattern options

   Returns ``PatternOptions`` instance.

.. _zend.cache.pattern.pattern-factory.examples:

Examples
--------

.. _zend.cache.pattern.class-cache.examples.cached-feed-reader:

.. rubric:: Caching of import feeds

.. code-block:: php
   :linenos:

   $cachedFeedReader = Zend\Cache\PatternFactory::factory('class', array(
       'class'   => 'Zend\Feed\Reader\Reader',
       'storage' => 'apc',
       
       // The feed reader doesn't output anything
       // so the output don't need to be catched and cached
       'cache_output' => false,
   ));

   $feed = $cachedFeedReader->call("import", array('http://www.planet-php.net/rdf/'));
   // OR
   $feed = $cachedFeedReader->import('http://www.planet-php.net/rdf/');
