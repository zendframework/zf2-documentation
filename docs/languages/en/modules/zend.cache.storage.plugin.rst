.. _zend.cache.storage.plugin:

Zend\\Cache\\Storage\\Plugin
============================

.. _zend.cache.storage.plugin.intro:

Overview
--------

Cache storage plugins are objects to add missing functionality or to influence behavior of a storage adapter.

The plugins listen to events the adapter triggers and can change called method arguments (\*.post - events),
skipping and directly return a result (using ``stopPropagation``), changing the result (with ``setResult`` of
``Zend\Cache\Storage\PostEvent``) and catching exceptions (with ``Zend\Cache\Storage\ExceptionEvent``).

.. _zend.cache.storage.plugin.quick-start:

Quick Start
-----------

Storage plugins can either be created from ``Zend\Cache\StorageFactory`` with the ``pluginFactory``, or by simply
instantiating one of the ``Zend\Cache\Storage\Plugin\*``\ classes.

To make life easier, the ``Zend\Cache\StorageFactory`` comes with the method ``factory`` to create an adapter and
all given plugins at once.

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

.. _zend.cache.storage.plugin.clear-expired-by-factor:

The ClearExpiredByFactor Plugin
-------------------------------

   The ``Zend\Cache\Storage\Plugin\ClearExpiredByFactor`` plugin calls the
   storage method ``clearExpired()`` randomly (by factor) after every call of
   ``setItem()``, ``setItems()``, ``addItem()`` and ``addItems()``.

.. _zend.cache.storage.plugin.clear-expired-by-factor.options:

.. table:: Plugin specific options

   +--------------------+------------+---------------+--------------------------------------------+
   |Name                |Data Type   |Default Value  |Description                                 |
   +====================+============+===============+============================================+
   |clearing_factor     |``integer`` |0              |The automatic clearing factor               |
   +--------------------+------------+---------------+--------------------------------------------+

.. note::

    **The ClearExpiredInterface is required**

    The storage have to implement the ``Zend\Cache\Storage\ClearExpiredInterface``
    to work with this plugin.

.. _zend.cache.storage.plugin.exeption-handler:

The ExceptionHandler Plugin
---------------------------

   The ``Zend\Cache\Storage\Plugin\ExceptionHandler`` plugin catches all
   exceptions thrown on reading or writing to cache and sends the exception
   to a defined callback function.
   
   It's configurable if the plugin should re-throw the catched exception.
   

.. _zend.cache.storage.plugin.exeption-handler.options:

.. table:: Plugin specific options

   +--------------------+----------------------+---------------+--------------------------------------------+
   |Name                |Data Type             |Default Value  |Description                                 |
   +====================+======================+===============+============================================+
   |exception_callback  |``callable`` ``null`` |``null``       |Callback will be called on an exception     |
   |                    |                      |               |and get the exception as argument           |
   +--------------------+----------------------+---------------+--------------------------------------------+
   |throw_exceptions    |``boolean``           |``true``       |Re-throw catched exceptions                 |
   +--------------------+----------------------+---------------+--------------------------------------------+

.. _zend.cache.storage.plugin.ignore-user-abort:

The IgnoreUserAbort Plugin
--------------------------

   The ``Zend\Cache\Storage\Plugin\IgnoreUserAbort`` plugin ignores script
   terminations by users until write operations to cache finished.

.. _zend.cache.storage.plugin.ignore-user-abort.options:

.. table:: Plugin specific options

   +--------------------+-------------+---------------+-----------------------------------------------------+
   |Name                |Data Type    |Default Value  |Description                                          |
   +====================+=============+===============+=====================================================+
   |exit_on_abort       |``boolean``  |``true``       |Terminate script execution if user abort the script  |
   +--------------------+-------------+---------------+-----------------------------------------------------+

.. _zend.cache.storage.plugin.optimize-by-factor:

The OptimizeByFactor Plugin
---------------------------

   The ``Zend\Cache\Storage\Plugin\OptimizeByFactor`` plugin calls the storage
   method ``optimize()`` randomly (by factor) after removing items from cache.

.. _zend.cache.storage.plugin.optimize-by-factor.options:

.. table:: Plugin specific options

   +--------------------+-------------+---------------+-----------------------------------------------------+
   |Name                |Data Type    |Default Value  |Description                                          |
   +====================+=============+===============+=====================================================+
   |optimizing_factor   |``integer``  |0              |The automatic optimization factor                    |
   +--------------------+-------------+---------------+-----------------------------------------------------+

.. note::

    **The OptimizableInterface is required**

    The storage have to implement the ``Zend\Cache\Storage\OptimizableInterface``
    to work with this plugin.

.. _zend.cache.storage.plugin.serializer:

The Serializer Plugin
---------------------

   The ``Zend\Cache\Storage\Plugin\Serializer`` plugin will serialize data on
   writing to cache and unserialize on reading. So it's possible to store
   different datatypes into cache storages only support strings.

.. _zend.cache.storage.plugin.serializer.options:

.. table:: Plugin specific options

   +--------------------+-----------------------------------------------------------------+---------------+-------------------------------------------------------------------------+
   |Name                |Data Type                                                        |Default Value  |Description                                                              |
   +====================+=================================================================+===============+=========================================================================+
   |serializer          |``null`` ``string`` ``Zend\Serializer\Adapter\AdapterInterface`` |``null``       |The serializer to use                                                    |
   |                    |                                                                 |               |                                                                         |
   |                    |                                                                 |               | - If ``null`` use the default serializer                                |
   |                    |                                                                 |               | - If ``string`` instantiate the serializer with ``serializer_options``  |
   +--------------------+-----------------------------------------------------------------+---------------+-------------------------------------------------------------------------+
   |serializer_options  |``array``                                                        |``[]``         |Array of serializer options used to instantiate the serializer           |
   +--------------------+-----------------------------------------------------------------+---------------+-------------------------------------------------------------------------+

.. _zend.cache.storage.plugin.methods:

Available Methods
-----------------

.. function:: setOptions(Zend\\Cache\\Storage\\Plugin\\PluginOptions $options)
   :noindex:

   Set options.

   :rtype: Zend\\Cache\\Storage\\Plugin\\PluginInterface

.. function:: getOptions()
   :noindex:

   Get options.

   :rtype: Zend\\Cache\\Storage\\Plugin\\PluginOptions

.. function:: attach(Zend\\EventManager\\EventManagerInterface $events)
   :noindex:

   Defined by ``Zend\EventManager\ListenerAggregateInterface``, attach one or more listeners.

   :rtype: void

.. function:: detach(Zend\\EventManager\\EventManagerInterface $events)
   :noindex:

   Defined by ``Zend\EventManager\ListenerAggregateInterface``, detach all previously attached listeners.

   :rtype: void

.. _zend.cache.storage.plugin.examples:

Examples
--------

.. _zend.cache.storage.plugin.examples.write-basics:

.. rubric:: Basics of writing an own storage plugin

.. code-block:: php
   :linenos:

   use Zend\Cache\Storage\Event;
   use Zend\Cache\Storage\Plugin\AbstractPlugin;
   use Zend\EventManager\EventManagerInterface;
   
   class MyPlugin extends AbstractPlugin
   {
       
       protected $handles = array();
       
       // This method have to attach all events required by this plugin
       public function attach(EventManagerInterface $events)
       {
           $this->handles[] = $events->attach('getItem.pre', array($this, 'onGetItemPre'));
           $this->handles[] = $events->attach('getItem.post', array($this, 'onGetItemPost'));
           return $this;
       }
       
       // This method have to detach all events required by this plugin
       public function detach(EventManagerInterface $events)
       {
           foreach ($this->handles as $handle) {
              $events->detach($handle);
           }
           $this->handles = array();
           return $this;
       }
       
       public function onGetItemPre(Event $event)
       {
           $params = $event->getParams();
           echo sprintf("Method 'getItem' with key '%s' started\n", $params['key']);
       }
       
       public function onGetItemPost(Event $event)
       {
           $params = $event->getParams();
           echo sprintf("Method 'getItem' with key '%s' finished\n", $params['key']);
       }
   }
   
   // After defining this basic plugin we can instantiate and add it to an adapter instance
   $plugin = new MyPlugin();
   $cache->addPlugin($plugin);
   
   // Now on calling getItem our basic plugin should print the expected output
   $cache->getItem('cache-key');
   // Method 'getItem' with key 'cache-key' started
   // Method 'getItem' with key 'cache-key' finished
