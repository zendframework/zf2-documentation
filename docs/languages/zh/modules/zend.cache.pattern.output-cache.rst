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

Configuration Options
---------------------

+--------+-------------------------------------------------------------+--------------+--------------------------------------+
|Option  |Data Type                                                    |Default Value |Description                           |
+========+=============================================================+==============+======================================+
|storage |``string`` ``array`` ``Zend\Cache\Storage\StorageInterface`` |<none>        |The storage to write/read cached data |
+--------+-------------------------------------------------------------+--------------+--------------------------------------+

.. _zend.cache.pattern.output-cache.methods:

Available Methods
-----------------

.. function:: start(string $key)
   :noindex:

   If there is a cached item with the given key display it's data and return ``true``
   else start buffering output until ``end()`` is called or the script ends and return ``false``.

   :rtype: boolean

.. function:: end()
   :noindex:

   Stops buffering output, write buffered data to cache using the given key on ``start()``
   and displays the buffer.

   :rtype: boolean

.. function:: setOptions(Zend\\Cache\\Pattern\\PatternOptions $options)
   :noindex:

   Set pattern options.

   :rtype: Zend\\Cache\\Pattern\\OutputCache

.. function:: getOptions()
   :noindex:

   Get all pattern options.

   :rtype: Zend\\Cache\\Pattern\\PatternOptions

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
