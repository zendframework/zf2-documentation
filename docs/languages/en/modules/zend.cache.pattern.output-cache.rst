.. _zend.cache.pattern.output-cache:

Zend\\Cache\\Pattern\\OutputCache
=================================

.. _zend.cache.pattern.output-cache.overview:

Overview
--------

The ``OutputCache`` pattern caches output between calls to ``start()`` and ``end()``.

.. _zend.cache.pattern.output-cache.quick-start:

Quick Start
-----------

Instantiating the output cache pattern

.. code-block:: php
   :linenos:

   use Zend\Cache\PatternFactory;

   $outputCache = PatternFactory::factory('output', array(
       'storage' => 'apc'
   ));

.. _zend.cache.pattern.output-cache.options:

Configuration options
---------------------

+--------+-------------------------------------------------------------+--------------+--------------------------------------+
|Option  |Data Type                                                    |Default Value |Description                           |
+========+=============================================================+==============+======================================+
|storage |``string`` ``array`` ``Zend\Cache\Storage\StorageInterface`` |<none>        |The storage to write/read cached data |
+--------+-------------------------------------------------------------+--------------+--------------------------------------+

.. _zend.cache.pattern.output-cache.methods:

Available Methods
-----------------

.. _zend.cache.pattern.output-cache.methods.start:

**start**
   ``start(string $key)``

   If there is a cached item with the given key display it's data and return true
   else start buffering output until end() is called or the script ends and return false.

   Returns boolean

.. _zend.cache.pattern.output-cache.methods.end:

**end**
   ``end()``

   Stops buffering output, write buffered data to cache using the given key on start()
   and displays the buffer.

   Returns boolean

.. _zend.cache.pattern.output-cache.methods.set-options:

**setOptions**
   ``setOptions(Zend\Cache\Pattern\PatternOptions $options)``

   Set pattern options

   Returns Zend\\Cache\\Pattern\\OutputCache

.. _zend.cache.pattern.output-cache.methods.get-options:

**getOptions**
   ``getOptions()``

   Get all pattern options

   Returns ``PatternOptions`` instance.

.. _zend.cache.pattern.pattern-factory.examples:

Examples
--------

.. _zend.cache.pattern.output-cache.examples.caching-simple-views:

.. rubric:: Caching simple view scripts

.. code-block:: php
   :linenos:

   $outputCache = Zend\Cache\PatternFactory::factory('output', array(
       'storage' => 'apc',
   ));
   
   $outputCache->start('mySimpleViewScript');
   include '/path/to/view/script.phtml';
   $outputCache->end();
