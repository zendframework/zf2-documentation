.. _zend.cache.storage.adapter:

Zend\\Cache\\Storage\\Adapter
=============================

.. _zend.cache.storage.adapter.intro:

Overview
--------

Storage adapters are wrappers for real storage resources such as memory and the filesystem, using the well known
adapter pattern.

They comes with tons of methods to read, write and modify stored items and to get information about stored items
and the storage.

All adapters implements the interface ``Zend\Cache\Storage\Adapter`` and most extend
``Zend\Cache\Storage\Adapter\AbstractAdapter``, which comes with basic logic.

Configuration is handled by either ``Zend\Cache\Storage\Adapter\AdapterOptions``, or an adapter-specific options
class if it exists. You may pass the options instance to the class at instantiation or via the ``setOptions()``
method, or alternately pass an associative array of options in either place (internally, these are then passed to
an options class instance). Alternately, you can pass either the options instance or associative array to the
``Zend\Cache\StorageFactory::factory`` method.

.. note::

   **Many methods throw exceptions**

   Because many caching methods can throw exceptions, you need to catch them manually or you can use the plug-in
   ``Zend\Cache\Storage\Plugin\ExceptionHandler`` to automatically catch them and redirect exceptions into a log
   file using the option "exception_callback".

.. _zend.cache.storage.adapter.quick-start:

Quick Start
-----------

Caching adapters can either be created from the provided ``Zend\Cache\StorageFactory`` factory, or by simply
instantiating one of the ``Zend\Cache\Storage\Adapter\*``\ classes.

To make life easier, the ``Zend\Cache\StorageFactory`` comes with a ``factory`` method to create an adapter and
create/add all requested plugins at once.

.. code-block:: php
   :linenos:

   use Zend\Cache\StorageFactory;

   // Via factory:
   $cache = StorageFactory::factory(array(
       'adapter' => 'apc',
       'plugins' => array(
           'exception_handler' => array('throw_exceptions' => false),
       ),
   ));

   // Alternately:
   $cache  = StorageFactory::adapterFactory('apc');
   $plugin = StorageFactory::pluginFactory('exception_handler', array(
       'throw_exceptions' => false,
   ));
   $cache->addPlugin($plugin);

   // Or manually:
   $cache  = new Zend\Cache\Storage\Adapter\Apc();
   $plugin = new Zend\Cache\Storage\Plugin\ExceptionHandler(array(
       'throw_exceptions' => false,
   ));
   $cache->addPlugin($plugin);


.. _zend.cache.storage.adapter.options:

Configuration Options
---------------------

.. _zend.cache.storage.adapter.options.ignore-missing-items:

**ignore_missing_items**
   Enables or disables ignoring of missing items.

   If enabled and a missing item was requested:

   - ``getItem``, ``getMetadata``: return false

   - ``removeItem[s]``: return true

   - ``incrementItem[s]``, ``decrementItem[s]``: add a new item with 0 as base

   - ``touchItem[s]``: add new empty item

   If disabled and a missing item was requested:

   - ``getItem``, ``getMetadata``, ``incrementItem[s]``, ``decrementItem[s]``, ``touchItem[s]``

   - ``setIgnoreMissingItems(boolean $flag)``
     Implements a fluent interface.

   - ``getIgnoreMissingItems()``
     Returns boolean

.. _zend.cache.storage.adapter.options.key-pattern:

**key_pattern**
   Pattern against which to validate cache keys.

   - ``setKeyPattern(null|string $pattern)``
     Implements a fluent interface.

   - ``getKeyPattern()``
     Returns string

.. _zend.cache.storage.adapter.options.namespace:

**namespace**
   The "namespace" in which cache items will live.

   - ``setNamespace(string $namespace)``
     Implements a fluent interface.

   - ``getNamespace()``
     Returns string

.. _zend.cache.storage.adapter.options.namespace-pattern:

**namespace_pattern**
   Pattern against which to validate namespace values.

   - ``setNamespacePattern(null|string $pattern)``
     Implements a fluent interface.

   - ``getNamespacePattern()``
     Returns string

.. _zend.cache.storage.adapter.options.readable:

**readable**
   Enable/Disable reading data from cache.

   - ``setReadable(boolean $flag)``
     Implements a fluent interface.

   - ``getReadable()``
     Returns boolean

.. _zend.cache.storage.adapter.options.ttl:

**ttl**
   Set time to live.

   - ``setTtl(int|float $ttl)``
     Implements a fluent interface.

   - ``getTtl()``
     Returns float

.. _zend.cache.storage.adapter.options.writable:

**writable**
   Enable/Disable writing data to cache.

   - ``setWritable(boolean $flag)``
     Implements a fluent interface.

   - ``getWritable()``
     Returns boolean

.. _zend.cache.storage.adapter.methods:

Available Methods
-----------------

.. _zend.cache.storage.adapter.methods.set-options:

**setOptions**
   ``setOptions(array|Traversable|Zend\Cache\Storage\Adapter\AdapterOptions $options)``
   Set options.

   Implements a fluent interface.

.. _zend.cache.storage.adapter.methods.get-options:

**getOptions**
   ``getOptions()``
   Get options

   Returns Zend\\Cache\\Storage\\Adapter\\AdapterOptions

.. _zend.cache.storage.adapter.methods.get-item:

**getItem**
   ``getItem(string $key, array $options = array ())``
   Get an item.

   Returns mixed

.. _zend.cache.storage.adapter.methods.get-items:

**getItems**
   ``getItems(array $keys, array $options = array ())``
   Get multiple items.

   Returns array

.. _zend.cache.storage.adapter.methods.has-item:

**hasItem**
   ``hasItem(string $key, array $options = array ())``
   Test if an item exists.

   Returns boolean

.. _zend.cache.storage.adapter.methods.has-items:

**hasItems**
   ``hasItems(array $keys, array $options = array ())``
   Test multiple items.

   Returns array

.. _zend.cache.storage.adapter.methods.get-metadata:

**getMetadata**
   ``getMetadata(string $key, array $options = array ())``
   Get metadata of an item.

   Returns array|boolean

.. _zend.cache.storage.adapter.methods.get-metadatas:

**getMetadatas**
   ``getMetadatas(array $keys, array $options = array ())``
   Get multiple metadata

   Returns array

.. _zend.cache.storage.adapter.methods.set-item:

**setItem**
   ``setItem(string $key, mixed $value, array $options = array ())``
   Store an item.

   Returns boolean

.. _zend.cache.storage.adapter.methods.set-items:

**setItems**
   ``setItems(array $keyValuePairs, array $options = array ())``
   Store multiple items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.add-item:

**addItem**
   ``addItem(string $key, mixed $value, array $options = array ())``
   Add an item.

   Returns boolean

.. _zend.cache.storage.adapter.methods.add-items:

**addItems**
   ``addItems(array $keyValuePairs, array $options = array ())``
   Add multiple items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.replace-item:

**replaceItem**
   ``replaceItem(string $key, mixed $value, array $options = array ())``
   Replace an item.

   Returns boolean

.. _zend.cache.storage.adapter.methods.replace-items:

**replaceItems**
   ``replaceItems(array $keyValuePairs, array $options = array ())``
   Replace multiple items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.check-and-set-item:

**checkAndSetItem**
   ``checkAndSetItem(mixed $token, string|null $key, mixed $value, array $options = array ())``
   Set item only if token matches

   It uses the token from received from ``getItem()`` to check if the item has changed before overwriting it.

   Returns boolean

.. _zend.cache.storage.adapter.methods.touch-item:

**touchItem**
   ``touchItem(string $key, array $options = array ())``
   Reset lifetime of an item

   Returns boolean

.. _zend.cache.storage.adapter.methods.touch-items:

**touchItems**
   ``touchItems(array $keys, array $options = array ())``
   Reset lifetime of multiple items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.remove-item:

**removeItem**
   ``removeItem(string $key, array $options = array ())``
   Remove an item.

   Returns boolean

.. _zend.cache.storage.adapter.methods.remove-items:

**removeItems**
   ``removeItems(array $keys, array $options = array ())``
   Remove multiple items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.increment-item:

**incrementItem**
   ``incrementItem(string $key, int $value, array $options = array ())``
   Increment an item.

   Returns int|boolean

.. _zend.cache.storage.adapter.methods.increment-items:

**incrementItems**
   ``incrementItems(array $keyValuePairs, array $options = array ())``
   Increment multiple items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.decrement-item:

**decrementItem**
   ``decrementItem(string $key, int $value, array $options = array ())``
   Decrement an item.

   Returns int|boolean

.. _zend.cache.storage.adapter.methods.decrement-items:

**decrementItems**
   ``decrementItems(array $keyValuePairs, array $options = array ())``
   Decrement multiple items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.get-delayed:

**getDelayed**
   ``getDelayed(array $keys, array $options = array ())``
   Request multiple items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.find:

**find**
   ``find(int $mode = 2, array $options = array ())``
   Find items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.fetch:

**fetch**
   ``fetch()``
   Fetches the next item from result set

   Returns array|boolean

.. _zend.cache.storage.adapter.methods.fetch-all:

**fetchAll**
   ``fetchAll()``
   Returns all items of result set.

   Returns array

.. _zend.cache.storage.adapter.methods.clear:

**clear**
   ``clear(int $mode = 1, array $options = array ())``
   Clear items off all namespaces.

   Returns boolean

.. _zend.cache.storage.adapter.methods.clear-by-namespace:

**clearByNamespace**
   ``clearByNamespace(int $mode = 1, array $options = array ())``
   Clear items by namespace.

   Returns boolean

.. _zend.cache.storage.adapter.methods.optimize:

**optimize**
   ``optimize(array $options = array ())``
   Optimize adapter storage.

   Returns boolean

.. _zend.cache.storage.adapter.methods.get-capabilities:

**getCapabilities**
   ``getCapabilities()``
   Capabilities of this storage

   Returns Zend\\Cache\\Storage\\Capabilities

.. _zend.cache.storage.adapter.methods.get-capacity:

**getCapacity**
   ``getCapacity(array $options = array ())``
   Get storage capacity.

   Returns array|boolean

.. _zend.cache.storage.adapter.examples:

TODO: Examples
--------------




