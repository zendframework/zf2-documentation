
Zend\\Cache\\Storage\\Plugin
============================

.. _zend.cache.storage.plugin.intro:

Overview
--------

Cache storage plugins are objects to add missing functionality or to influence behavior of a storage adapter.

The plugins listen to events the adapter triggers and can change called method arguments (*.post - events), skipping and directly return a result (using ``stopPropagation`` ), changing the result (with ``setResult`` of ``Zend\Cache\Storage\PostEvent`` ) and catching exceptions (with ``Zend\Cache\Storage\ExceptionEvent`` ).

.. _zend.cache.storage.plugin.quick-start:

Quick Start
-----------

Storage plugins can either be created from ``Zend\Cache\StorageFactory`` with the ``pluginFactory`` , or by simply instantiating one of the ``Zend\Cache\Storage\Plugin\*`` classes.

To make life easier, the ``Zend\Cache\StorageFactory`` comes with the method ``factory`` to create an adapter and all given plugins at once.

.. code-block:: php
    :linenos:
    
    use Zend\Cache\StorageFactory;
    
    // Via factory:
    $cache = StorageFactory::factory(array(
        'adapter' => 'filesystem',
        'plugins' => array('serializer'),
    ));
    
    // Alternately:
    $cache  = StorageFactory::adapterFactory('filesystem');
    $plugin = StorageFactory::pluginFactory('serializer');
    $cache->addPlugin($plugin);
    
    // Or manually:
    $cache  = new Zend\Cache\Storage\Adapter\Filesystem();
    $plugin = new Zend\Cache\Storage\Plugin\Serializer();
    $cache->addPlugin($plugin);
    

.. _zend.cache.storage.plugin.options:

Configuration Options
---------------------

.. _zend.cache.storage.plugin.options.clearing-factor:


**clearing_factor**


Set the automatic clearing factor. Used by the ``ClearByFactor`` plugin.

.. _zend.cache.storage.plugin.options.clear-by-namespace:


**clear_by_namespace**


Flag indicating whether or not to clear by namespace. Used by the ``ClearByFactor`` plugin.

.. _zend.cache.storage.plugin.options.exception-callback:


**exception_callback**


Set callback to call on intercepted exception. Used by the ``ExceptionHandler`` plugin.

.. _zend.cache.storage.plugin.options.optimizing-factor:


**optimizing_factor**


Set automatic optimizing factor. Used by the ``OptimizeByFactor`` plugin.

.. _zend.cache.storage.plugin.options.serializer:


**serializer**


Set serializer adapter to use. Used by ``Serializer`` plugin.

.. _zend.cache.storage.plugin.options.serializer-options:


**serializer_options**


Set configuration options for instantiating a serializer adapter. Used by the ``Serializer`` plugin.

.. _zend.cache.storage.plugin.options.throw-exceptions:


**throw_exceptions**


Set flag indicating we should re-throw exceptions. Used by the ``ExceptionHandler`` plugin.

.. _zend.cache.storage.plugin.methods:

Available Methods
-----------------

.. _zend.cache.storage.plugin.methods.set-options:


**setOptions**


    ``setOptions(Zend\\Cache\\Storage\\Plugin\\PluginOptions $options)``


Set options

Implements a fluent interface.

.. _zend.cache.storage.plugin.methods.get-options:


**getOptions**


    ``getOptions()``


Get options

Returns PluginOptions

.. _zend.cache.storage.plugin.methods.attach:


**attach**


    ``attach(EventCollection $events)``


Defined by ``Zend\EventManager\ListenerAggregate`` , attach one or more listeners.

Returns void

.. _zend.cache.storage.plugin.methods.detach:


**detach**


    ``detach(EventCollection $events)``


Defined by ``Zend\EventManager\ListenerAggregate`` , detach all previously attached listeners.

Returns void

.. _zend.cache.storage.plugin.examples:

TODO: Examples
--------------




