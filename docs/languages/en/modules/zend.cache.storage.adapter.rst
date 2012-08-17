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

All adapters implements the interface ``Zend\Cache\Storage\StorageInterface`` and most extend
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

Basic configuration Options
---------------------------

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

.. _zend.cache.storage.adapter.methods-storage-interface:

Available Methods defined by ``Zend\Cache\Storage\StorageInterface``
--------------------------------------------------------------------

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
   ``getItem(string $key, boolean & $success = null, mixed & $casToken = null)``

   Load an item with the given $key,
   set parameter $success to TRUE and
   set parameter $casToken.

   If item can't load this method returns NULL and
   set parameter $success to FALSE.

.. _zend.cache.storage.adapter.methods.get-items:

**getItems**
   ``getItems(array $keys)``

   Load all items given by $keys.
   
   Returns an array of key-value pairs of available items.

.. _zend.cache.storage.adapter.methods.has-item:

**hasItem**
   ``hasItem(string $key)``

   Test if an item exists.

   Returns boolean

.. _zend.cache.storage.adapter.methods.has-items:

**hasItems**
   ``hasItems(array $keys)``

   Test multiple items.

   Returns array

.. _zend.cache.storage.adapter.methods.get-metadata:

**getMetadata**
   ``getMetadata(string $key)``

   Get metadata of an item.

   Returns array|boolean

.. _zend.cache.storage.adapter.methods.get-metadatas:

**getMetadatas**
   ``getMetadatas(array $keys)``

   Get multiple metadata

   Returns array

.. _zend.cache.storage.adapter.methods.set-item:

**setItem**
   ``setItem(string $key, mixed $value)``

   Store an item.

   Returns boolean

.. _zend.cache.storage.adapter.methods.set-items:

**setItems**
   ``setItems(array $keyValuePairs)``

   Store multiple items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.add-item:

**addItem**
   ``addItem(string $key, mixed $value)``

   Add an item.

   Returns boolean

.. _zend.cache.storage.adapter.methods.add-items:

**addItems**
   ``addItems(array $keyValuePairs)``

   Add multiple items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.replace-item:

**replaceItem**
   ``replaceItem(string $key, mixed $value)``

   Replace an item.

   Returns boolean

.. _zend.cache.storage.adapter.methods.replace-items:

**replaceItems**
   ``replaceItems(array $keyValuePairs)``

   Replace multiple items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.check-and-set-item:

**checkAndSetItem**
   ``checkAndSetItem(mixed $token, string $key, mixed $value)``

   Set item only if token matches

   It uses the token from received from ``getItem()`` to check if the item has changed before overwriting it.

   Returns boolean

.. _zend.cache.storage.adapter.methods.touch-item:

**touchItem**
   ``touchItem(string $key)``

   Reset lifetime of an item

   Returns boolean

.. _zend.cache.storage.adapter.methods.touch-items:

**touchItems**
   ``touchItems(array $keys)``

   Reset lifetime of multiple items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.remove-item:

**removeItem**
   ``removeItem(string $key)``

   Remove an item.

   Returns boolean

.. _zend.cache.storage.adapter.methods.remove-items:

**removeItems**
   ``removeItems(array $keys)``

   Remove multiple items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.increment-item:

**incrementItem**
   ``incrementItem(string $key, int $value)``

   Increment an item.

   Returns int|boolean

.. _zend.cache.storage.adapter.methods.increment-items:

**incrementItems**
   ``incrementItems(array $keyValuePairs)``

   Increment multiple items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.decrement-item:

**decrementItem**
   ``decrementItem(string $key, int $value)``

   Decrement an item.

   Returns int|boolean

.. _zend.cache.storage.adapter.methods.decrement-items:

**decrementItems**
   ``decrementItems(array $keyValuePairs)``

   Decrement multiple items.

   Returns boolean

.. _zend.cache.storage.adapter.methods.get-capabilities:

**getCapabilities**
   ``getCapabilities()``

   Capabilities of this storage

   Returns Zend\\Cache\\Storage\\Capabilities

.. _zend.cache.storage.adapter.methods-available-space-capable-interface:

Available Methods defined by ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
----------------------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.get-available-space:

**getAvailableSpace**
   ``getAvailableSpace()``

   Get available space in bytes

   Returns int|float

.. _zend.cache.storage.adapter.methods-total-space-capable-interface:

Available Methods defined by ``Zend\Cache\Storage\TotalSpaceCapableInterface``
------------------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.get-total-space:

**getTotalSpace**
   ``getTotalSpace()``

   Get total space in bytes

   Returns int|float

.. _zend.cache.storage.adapter.methods-clear-by-namespace-interface:

Available Methods defined by ``Zend\Cache\Storage\ClearByNamespaceInterface``
-----------------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.clear-by-namespace:

**clearByNamespace**
   ``clearByNamespace(string $namespace)``

   Remove items of given namespace

   Returns boolean

.. _zend.cache.storage.adapter.methods-clear-by-prefix-interface

Available Methods defined by ``Zend\Cache\Storage\ClearByPrefixInterface``
--------------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.clear-by-prefix:

**clearByPrefix**
   ``clearByPrefix(string $prefix)``

   Remove items matching given prefix

   Returns boolean

.. _zend.cache.storage.adapter.methods-clear-expired-interface

Available Methods defined by ``Zend\Cache\Storage\ClearExpiredInterface``
-------------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.clear-expired:

**clearExpired**
   ``clearExpired()``

   Remove expired items

   Returns boolean

.. _zend.cache.storage.adapter.methods-flushable-interface

Available Methods defined by ``Zend\Cache\Storage\FlushableInterface``
----------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.flush:

**flush**
   ``flush()``

   Flush the whole storage

   Returns boolean

.. _zend.cache.storage.adapter.methods-iterable-interface

Available Methods defined by ``Zend\Cache\Storage\IterableInterface`` (extends ``IteratorAggregate``)
-----------------------------------------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.get-iterator:

**getIterator**
   ``getIterator()``

   Get an Iterator

   Returns ``Zend\Cache\Storage\IteratorInterface``

.. _zend.cache.storage.adapter.methods-optimizable-interface

Available Methods defined by ``Zend\Cache\Storage\OptimizableInterface``
------------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.optimize:

**optimize**
   ``optimize()``

   Optimize the storage

   Returns boolean

.. _zend.cache.storage.adapter.methods-taggable-interface

Available Methods defined by ``Zend\Cache\Storage\TaggableInterface``
---------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.set-tags:

**setTags**
   ``setTags(string   $key, string[] $tags)``

   Set tags to an item by given key.
   An empty array will remove all tags.

   Returns boolean

.. _zend.cache.storage.adapter.methods.get-tags:

**getTags**
   ``getTags(string $key)``

   Get tags of an item by given key

   Returns string[]|FALSE

.. _zend.cache.storage.adapter.methods.get-tags:

**clearByTags**
   ``clearByTags(string[] $tags, boolean $disjunction = false)``

   Remove items matching given tags.

    If $disjunction only one of the given tags must match
    else all given tags must match.

   Returns boolean

.. _zend.cache.storage.adapter.examples:

TODO: Examples
--------------




