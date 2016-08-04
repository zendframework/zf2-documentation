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

.. function:: call(string $method, array $args = array())
   :noindex:

    Call the specified method of the configured class.

   :rtype: mixed

.. function:: __call(string $method, array $args)
   :noindex:

    Call the specified method of the configured class.

   :rtype: mixed

.. function:: __set(string $name, mixed $value)
   :noindex:

    Set a static property of the configured class.

   :rtype: void

.. function:: __get(string $name)
   :noindex:

    Get a static property of the configured class.

   :rtype: mixed

.. function:: __isset(string $name)
   :noindex:

    Checks if a static property of the configured class exists.

   :rtype: boolean

.. function:: __unset(string $name)
   :noindex:

    Unset a static property of the configured class.

   :rtype: void

.. function:: generateKey(string $method, array $args = array())
   :noindex:

   Generate a unique key in base of a key representing the callback part
   and a key representing the arguments part.

   :rtype: string

.. function:: setOptions(Zend\\Cache\\Pattern\\PatternOptions $options)
   :noindex:

   Set pattern options.

   :rtype: Zend\\Cache\\Pattern\\ClassCache

.. function:: getOptions()
   :noindex:

   Get all pattern options.

   :rtype: Zend\\Cache\\Pattern\\PatternOptions

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
       // so the output don't need to be caught and cached
       'cache_output' => false,
   ));

   $feed = $cachedFeedReader->call("import", array('http://www.planet-php.net/rdf/'));
   // OR
   $feed = $cachedFeedReader->import('http://www.planet-php.net/rdf/');
