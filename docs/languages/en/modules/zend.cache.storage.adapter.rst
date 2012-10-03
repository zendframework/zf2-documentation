.. _zend.cache.storage.adapter:

Zend\Cache\Storage\Adapter
=============================

.. _zend.cache.storage.adapter.intro:

Overview
--------

   Storage adapters are wrappers for real storage resources such as memory
   and the filesystem, using the well known adapter pattern.

   They comes with tons of methods to read, write and modify stored items
   and to get information about stored items and the storage.

   All adapters implements the interface ``Zend\Cache\Storage\StorageInterface``
   and most extend ``Zend\Cache\Storage\Adapter\AbstractAdapter``, which comes with basic logic.

   Configuration is handled by either ``Zend\Cache\Storage\Adapter\AdapterOptions``,
   or an adapter-specific options class if it exists. You may pass the options
   instance to the class at instantiation or via the ``setOptions()`` method,
   or alternately pass an associative array of options in either place
   (internally, these are then passed to an options class instance).
   Alternately, you can pass either the options instance or associative array
   to the ``Zend\Cache\StorageFactory::factory`` method.

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

.. _zend.cache.adapter.common.options:

   Basic configuration is handled by either ``Zend\Cache\Storage\Adapter\AdapterOptions``, or an adapter-specific options
   class if it exists. You may pass the options instance to the class at instantiation or via the ``setOptions()``
   method, or alternately pass an associative array of options in either place (internally, these are then passed to
   an options class instance). Alternately, you can pass either the options instance or associative array to the
   ``Zend\Cache\StorageFactory::factory`` method.

   The following configuration options are defined by ``Zend\Cache\Storage\Adapter\AdapterOptions``
   and are available for every supported adapter. Adapter-specific configuration options
   are descriped on adapter level below.

   +--------------+-------------------------+----------------+-------------------------------------------------+
   |Option        |Data Type                |Default Value   |Description                                      |
   +==============+=========================+================+=================================================+
   |ttl           |``integer``              |0               |Time to live                                     |
   +--------------+-------------------------+----------------+-------------------------------------------------+
   |namespace     |``string``               |""              |The "namespace" in which cache items will live   |
   +--------------+-------------------------+----------------+-------------------------------------------------+
   |key_pattern   |``null`` ``string``      |``null``        |Pattern against which to validate cache keys     |
   +--------------+-------------------------+----------------+-------------------------------------------------+
   |readable      |``boolean``              |``true``        |Enable/Disable reading data from cache           |
   +--------------+-------------------------+----------------+-------------------------------------------------+
   |writable      |``boolean``              |``true``        |Enable/Disable writing data to cache             |
   +--------------+-------------------------+----------------+-------------------------------------------------+

.. _zend.cache.storage.adapter.methods-storage-interface:

Available Methods defined by ``Zend\Cache\Storage\StorageInterface``
--------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.get-item:

**getItem**
   ``getItem(string $key, boolean & $success = null, mixed & $casToken = null)``

   Load an item with the given $key.

   If item exists set parameter $success to ``true``, set parameter $casToken and returns ``mixed`` value of item.

   If item can't load set parameter $success to ``false`` and returns ``null``.

.. _zend.cache.storage.adapter.methods.get-items:

**getItems**
   ``getItems(array $keys)``

   Load all items given by $keys.

   Returns ``array`` of key-value pairs of available items.

.. _zend.cache.storage.adapter.methods.has-item:

**hasItem**
   ``hasItem(string $key)``

   Test if an item exists.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods.has-items:

**hasItems**
   ``hasItems(array $keys)``

   Test multiple items.

   Returns ``array``

.. _zend.cache.storage.adapter.methods.get-metadata:

**getMetadata**
   ``getMetadata(string $key)``

   Get metadata of an item.

   Returns ``array``|``boolean``

.. _zend.cache.storage.adapter.methods.get-metadatas:

**getMetadatas**
   ``getMetadatas(array $keys)``

   Get multiple metadata.

   Returns ``array``

.. _zend.cache.storage.adapter.methods.set-item:

**setItem**
   ``setItem(string $key, mixed $value)``

   Store an item.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods.set-items:

**setItems**
   ``setItems(array $keyValuePairs)``

   Store multiple items.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods.add-item:

**addItem**
   ``addItem(string $key, mixed $value)``

   Add an item.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods.add-items:

**addItems**
   ``addItems(array $keyValuePairs)``

   Add multiple items.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods.replace-item:

**replaceItem**
   ``replaceItem(string $key, mixed $value)``

   Replace an item.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods.replace-items:

**replaceItems**
   ``replaceItems(array $keyValuePairs)``

   Replace multiple items.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods.check-and-set-item:

**checkAndSetItem**
   ``checkAndSetItem(mixed $token, string $key, mixed $value)``

   Set item only if token matches.
   It uses the token received from ``getItem()`` to check if the item has changed before overwriting it.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods.touch-item:

**touchItem**
   ``touchItem(string $key)``

   Reset lifetime of an item.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods.touch-items:

**touchItems**
   ``touchItems(array $keys)``

   Reset lifetime of multiple items.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods.remove-item:

**removeItem**
   ``removeItem(string $key)``

   Remove an item.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods.remove-items:

**removeItems**
   ``removeItems(array $keys)``

   Remove multiple items.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods.increment-item:

**incrementItem**
   ``incrementItem(string $key, int $value)``

   Increment an item.

   Returns ``integer``|``boolean``

.. _zend.cache.storage.adapter.methods.increment-items:

**incrementItems**
   ``incrementItems(array $keyValuePairs)``

   Increment multiple items.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods.decrement-item:

**decrementItem**
   ``decrementItem(string $key, int $value)``

   Decrement an item.

   Returns ``interger``|``boolean``

.. _zend.cache.storage.adapter.methods.decrement-items:

**decrementItems**
   ``decrementItems(array $keyValuePairs)``

   Decrement multiple items.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods.get-capabilities:

**getCapabilities**
   ``getCapabilities()``

   Capabilities of this storage.

   Returns ``Zend\Cache\Storage\Capabilities``

.. _zend.cache.storage.adapter.methods-available-space-capable-interface:

Available Methods defined by ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
----------------------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.get-available-space:

**getAvailableSpace**
   ``getAvailableSpace()``

   Get available space in bytes.

   Returns ``integer``|``float``

.. _zend.cache.storage.adapter.methods-total-space-capable-interface:

Available Methods defined by ``Zend\Cache\Storage\TotalSpaceCapableInterface``
------------------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.get-total-space:

**getTotalSpace**
   ``getTotalSpace()``

   Get total space in bytes.

   Returns ``integer``|``float``

.. _zend.cache.storage.adapter.methods-clear-by-namespace-interface:

Available Methods defined by ``Zend\Cache\Storage\ClearByNamespaceInterface``
-----------------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.clear-by-namespace:

**clearByNamespace**
   ``clearByNamespace(string $namespace)``

   Remove items of given namespace.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods-clear-by-prefix-interface

Available Methods defined by ``Zend\Cache\Storage\ClearByPrefixInterface``
--------------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.clear-by-prefix:

**clearByPrefix**
   ``clearByPrefix(string $prefix)``

   Remove items matching given prefix.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods-clear-expired-interface

Available Methods defined by ``Zend\Cache\Storage\ClearExpiredInterface``
-------------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.clear-expired:

**clearExpired**
   ``clearExpired()``

   Remove expired items.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods-flushable-interface

Available Methods defined by ``Zend\Cache\Storage\FlushableInterface``
----------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.flush:

**flush**
   ``flush()``

   Flush the whole storage.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods-iterable-interface

Available Methods defined by ``Zend\Cache\Storage\IterableInterface`` (extends ``IteratorAggregate``)
-----------------------------------------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.get-iterator:

**getIterator**
   ``getIterator()``

   Get an Iterator.

   Returns ``Zend\Cache\Storage\IteratorInterface``

.. _zend.cache.storage.adapter.methods-optimizable-interface

Available Methods defined by ``Zend\Cache\Storage\OptimizableInterface``
------------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.optimize:

**optimize**
   ``optimize()``

   Optimize the storage.

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods-taggable-interface

Available Methods defined by ``Zend\Cache\Storage\TaggableInterface``
---------------------------------------------------------------------

.. _zend.cache.storage.adapter.methods.set-tags:

**setTags**
   ``setTags(string $key, string[] $tags)``

   Set tags to an item by given key.
   (An empty array will remove all tags)

   Returns ``boolean``

.. _zend.cache.storage.adapter.methods.get-tags:

**getTags**
   ``getTags(string $key)``

   Get tags of an item by given key.

   Returns ``string[]``|``false``

.. _zend.cache.storage.adapter.methods.get-tags:

**clearByTags**
   ``clearByTags(string[] $tags, boolean $disjunction = false)``

   Remove items matching given tags.

   If $disjunction is ``true`` only one of the given tags must match
   else all given tags must match.

   Returns ``boolean``

.. _zend.cache.storage.adapter.apc

Zend\\Cache\\Storage\\Adapter\\Apc
----------------------------------

   This adapter stores cache items in shared memory through the required PHP extension APC_ (Alternative PHP Cache).

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
   - ``Zend\Cache\Storage\ClearByNamespaceInterface``
   - ``Zend\Cache\Storage\ClearByPrefixInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\IterableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.apc.capabilities

.. table:: Capabilities

   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |Capability          |Value                                                                                                        |
   +====================+=============================================================================================================+
   |supportedDatatypes  |``null``, ``boolean``, ``integer``, ``double``, ``string``, ``array`` (serialized), ``object`` (serialized)  |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |supportedMetadata   |internal_key, atime, ctime, mtime, rtime, size, hits, ttl                                                    |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |minTtl              |1                                                                                                            |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |maxTtl              |0                                                                                                            |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |staticTtl           |``true``                                                                                                     |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |ttlPrecision        |1                                                                                                            |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |useRequestTime      |<ini value of ``apc.use_request_time``>                                                                      |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |expiredRead         |``false``                                                                                                    |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |maxKeyLength        |5182                                                                                                         |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |namespaceIsPrefix   |``true``                                                                                                     |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |namespaceSeparator  |<Option value of ``namespace_separator``>                                                                    |
   +--------------------+-------------------------------------------------------------------------------------------------------------+

-------------------------------

.. _zend.cache.storage.adapter.apc.options

.. table:: Adapter specific options

   +--------------------+-----------+---------------+--------------------------------------------+
   |Name                |Data Type  |Default Value  |Describtion                                 |
   +====================+===========+===============+============================================+
   |namespace_separator |``string`` |":"            |A separator for the namespace and prefix    |
   +--------------------+-----------+---------------+--------------------------------------------+

.. _zend.cache.storage.adapter.dba

Zend\\Cache\\Storage\\Adapter\\Dba
----------------------------------

   This adapter stores cache items into dbm_ like databases using the required PHP extension dba_.

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
   - ``Zend\Cache\Storage\ClearByNamespaceInterface``
   - ``Zend\Cache\Storage\ClearByPrefixInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\IterableInterface``
   - ``Zend\Cache\Storage\OptimizableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.dba.capabilities

.. table:: Capabilities

   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |Capability          |Value                                                                                                              |
   +====================+===================================================================================================================+
   |supportedDatatypes  |``string``, ``null`` => ``string``, ``boolean`` => ``string``, ``integer`` => ``string``, ``double`` => ``string`` |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |supportedMetadata   |<none>                                                                                                             |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |minTtl              |0                                                                                                                  |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |maxKeyLength        |0                                                                                                                  |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |namespaceIsPrefix   |``true``                                                                                                           |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |namespaceSeparator  |<Option value of ``namespace_separator``>                                                                          |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+

-------------------------------

.. _zend.cache.storage.adapter.dba.options

.. table:: Adapter specific options

   +--------------------+-----------+---------------+------------------------------------------------------------------------------------+
   |Name                |Data Type  |Default Value  |Describtion                                                                         |
   +====================+===========+===============+====================================================================================+
   |namespace_separator |``string`` |":"            |A separator for the namespace and prefix                                            |
   +--------------------+-----------+---------------+------------------------------------------------------------------------------------+
   |pathname            |``string`` |""             |Pathname to the database file                                                       |
   +--------------------+-----------+---------------+------------------------------------------------------------------------------------+
   |mode                |``string`` |"c"            |The mode to open the database                                                       |
   |                    |           |               |Please read dba_open_ for more information                                          |
   +--------------------+-----------+---------------+------------------------------------------------------------------------------------+
   |handler             |``string`` |"flatfile"     |The name of the handler which shall be used for accessing the database.             |
   +--------------------+-----------+---------------+------------------------------------------------------------------------------------+

.. _zend.cache.storage.adapter.filesystem

Zend\\Cache\\Storage\\Adapter\\Filesystem
-----------------------------------------

   This adapter stores cache items into the filesystem.

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
   - ``Zend\Cache\Storage\ClearByNamespaceInterface``
   - ``Zend\Cache\Storage\ClearByPrefixInterface``
   - ``Zend\Cache\Storage\ClearExpiredInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\IterableInterface``
   - ``Zend\Cache\Storage\OptimizableInterface``
   - ``Zend\Cache\Storage\TaggableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.filesystem.capabilities

.. table:: Capabilities

   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |Capability          |Value                                                                                                              |
   +====================+===================================================================================================================+
   |supportedDatatypes  |``string``, ``null`` => ``string``, ``boolean`` => ``string``, ``integer`` => ``string``, ``double`` => ``string`` |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |supportedMetadata   |mtime, filespec, atime, ctime                                                                                      |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |minTtl              |1                                                                                                                  |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |maxTtl              |0                                                                                                                  |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |staticTtl           |``false``                                                                                                          |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |ttlPrecision        |1                                                                                                                  |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |useRequestTime      |``false``                                                                                                          |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |expiredRead         |``true``                                                                                                           |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |maxKeyLength        |251                                                                                                                |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |namespaceIsPrefix   |``true``                                                                                                           |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |namespaceSeparator  |<Option value of ``namespace_separator``>                                                                          |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+

-------------------------------

.. _zend.cache.storage.adapter.filesystem.options

.. table:: Adapter specific options

   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |Name                |Data Type             |Default Value            |Describtion                                                                         |
   +====================+======================+=========================+====================================================================================+
   |namespace_separator |``string``            |":"                      |A separator for the namespace and prefix                                            |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |cache_dir           |``string``            |""                       |Directory to store cache files                                                      |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |clear_stat_cache    |``boolean``           |``true``                 |Call ``clearstatcache()`` enabled?                                                  |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |dir_level           |``integer``           |1                        |Defines how much sub-directaries should be created                                  |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |dir_permission      |``integer``           |0700                     |Permission creating new directories                                                 |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |file_locking        |``boolean``           |``true``                 |Lock files on writing                                                               |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |file_permission     |``integer``           |0700                     |Permission creating new files                                                       |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |key_pattern         |``string``            |``/^[a-z0-9_\+\-]*$/Di`` |Validate key against pattern                                                        |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |no_atime            |``boolean``           |``true``                 |Don't get 'fileatime' as 'atime' on metadata                                        |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |no_ctime            |``boolean``           |``true``                 |Don't get 'filectime' as 'ctime' on metadata                                        |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |umask               |``integer`` ``false`` |``false``                |Don't get 'filectime' as 'ctime' on metadata                                        |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+

.. _zend.cache.storage.adapter.memcached

Zend\\Cache\\Storage\\Adapter\\Memcached
----------------------------------------

   This adapter stores cache items over the memcached protocol.
   It's using the required PHP extension memcached_ which is based on Libmemcached_.

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.memcached.capabilities

.. table:: Capabilities

   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |Capability          |Value                                                                                                              |
   +====================+===================================================================================================================+
   |supportedDatatypes  |``null``, ``boolean``, ``integer``, ``double``, ``string``, ``array`` (serialized), ``object`` (serialized)        |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |supportedMetadata   |<none>                                                                                                             |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |minTtl              |1                                                                                                                  |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |maxTtl              |0                                                                                                                  |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |staticTtl           |``true``                                                                                                           |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |ttlPrecision        |1                                                                                                                  |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |useRequestTime      |``false``                                                                                                          |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |expiredRead         |``false``                                                                                                          |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |maxKeyLength        |255                                                                                                                |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |namespaceIsPrefix   |``true``                                                                                                           |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |namespaceSeparator  |<none>                                                                                                             |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+

-------------------------------

.. _zend.cache.storage.adapter.memcached.options

.. table:: Adapter specific options

   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------------------------+
   |Name                |Data Type             |Default Value            |Describtion                                                                                           |
   +====================+======================+=========================+======================================================================================================+
   |servers             |``array``             |``[]``                   |List of servers in [] = array(``string`` host, ``integer`` port)                                      |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------------------------+
   |lib_options         |``array``             |``[]``                   |Assosiative array of Libmemcached options were the array key is the option name                       |
   |                    |                      |                         |(without the prefix "OPT\_") or the constant value. The array value is the option value               |
   |                    |                      |                         |                                                                                                      |
   |                    |                      |                         |Please read this<http://php.net/manual/memcached.setoption.php> for more information                  |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------------------------+

.. _zend.cache.storage.adapter.memory

Zend\\Cache\\Storage\\Adapter\\Memory
-------------------------------------

   This adapter stores cache items into the PHP process using an array.

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
   - ``Zend\Cache\Storage\ClearByPrefixInterface``
   - ``Zend\Cache\Storage\ClearExpiredInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\IterableInterface``
   - ``Zend\Cache\Storage\TaggableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.memory.capabilities

.. table:: Capabilities

   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |Capability          |Value                                                                                                              |
   +====================+===================================================================================================================+
   |supportedDatatypes  |``string``, ``null``, ``boolean``, ``integer``, ``double``, ``array``, ``object``, ``resource``                    |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |supportedMetadata   |mtime                                                                                                              |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |minTtl              |1                                                                                                                  |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |maxTtl              |<Value of ``PHP_INT_MAX``>                                                                                         |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |staticTtl           |``false``                                                                                                          |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |ttlPrecision        |0.05                                                                                                               |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |useRequestTime      |``false``                                                                                                          |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |expiredRead         |``true``                                                                                                           |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |maxKeyLength        |0                                                                                                                  |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+
   |namespaceIsPrefix   |``false``                                                                                                          |
   +--------------------+-------------------------------------------------------------------------------------------------------------------+

-------------------------------

.. _zend.cache.storage.adapter.memory.options

.. table:: Adapter specific options

   +--------------------+-----------------------+-------------------------------------+-----------------------------------------------------------------------------------------------+
   |Name                |Data Type              |Default Value                        |Describtion                                                                                    |
   +====================+=======================+=====================================+===============================================================================================+
   |memory_limit        |``string`` ``integer`` |<50% of ini value ``memory_limit``>  |Limit of how much memory can PHP allocate to allow store items into this adapter               |
   |                    |                       |                                     |                                                                                               |
   |                    |                       |                                     | - If the used memory of PHP exceeds this limit an OutOfSpaceException will be thrown.         |
   |                    |                       |                                     | - A number less or equal 0 will disable the memory limit                                      |
   |                    |                       |                                     | - When a number is used, the value is measured in bytes (Shorthand notation may also be used) |
   +--------------------+-----------------------+-------------------------------------+-----------------------------------------------------------------------------------------------+

.. note::

   All stored items will be lost after terminating the script.

.. _zend.cache.storage.adapter.wincache

Zend\\Cache\\Storage\\Adapter\\WinCache
---------------------------------------

   This adapter stores cache items in shared memory through the required PHP extension WinCache_.

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.wincache.capabilities

.. table:: Capabilities

   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |Capability          |Value                                                                                                        |
   +====================+=============================================================================================================+
   |supportedDatatypes  |``null``, ``boolean``, ``integer``, ``double``, ``string``, ``array`` (serialized), ``object`` (serialized)  |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |supportedMetadata   |internal_key, ttl, hits, size                                                                                |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |minTtl              |1                                                                                                            |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |maxTtl              |0                                                                                                            |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |staticTtl           |``true``                                                                                                     |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |ttlPrecision        |1                                                                                                            |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |useRequestTime      |<ini value of ``apc.use_request_time``>                                                                      |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |expiredRead         |``false``                                                                                                    |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |namespaceIsPrefix   |``true``                                                                                                     |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |namespaceSeparator  |<Option value of ``namespace_separator``>                                                                    |
   +--------------------+-------------------------------------------------------------------------------------------------------------+

-------------------------------

.. _zend.cache.storage.adapter.wincache.options

.. table:: Adapter specific options

   +--------------------+-----------+---------------+--------------------------------------------+
   |Name                |Data Type  |Default Value  |Describtion                                 |
   +====================+===========+===============+============================================+
   |namespace_separator |``string`` |":"            |A separator for the namespace and prefix    |
   +--------------------+-----------+---------------+--------------------------------------------+

.. _zend.cache.storage.adapter.zend-server-disk

Zend\\Cache\\Storage\\Adapter\\ZendServerDisk
---------------------------------------------

   This adapter stores cache items on filesystem through the `Zend Server Data Caching API`_.

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
   - ``Zend\Cache\Storage\ClearByNamespaceInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.zend-server-disk.capabilities

.. table:: Capabilities

   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |Capability          |Value                                                                                                        |
   +====================+=============================================================================================================+
   |supportedDatatypes  |``null``, ``boolean``, ``integer``, ``double``, ``string``, ``array`` (serialized), ``object`` (serialized)  |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |supportedMetadata   |<none>                                                                                                       |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |minTtl              |1                                                                                                            |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |maxTtl              |0                                                                                                            |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |maxKeyLength        |0                                                                                                            |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |staticTtl           |``true``                                                                                                     |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |ttlPrecision        |1                                                                                                            |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |useRequestTime      |``false``                                                                                                    |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |expiredRead         |``false``                                                                                                    |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |namespaceIsPrefix   |``true``                                                                                                     |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |namespaceSeparator  |``::``                                                                                                       |
   +--------------------+-------------------------------------------------------------------------------------------------------------+

.. _zend.cache.storage.adapter.zend-server-shm

Zend\\Cache\\Storage\\Adapter\\ZendServerShm
---------------------------------------------

   This adapter stores cache items in shared memory through the `Zend Server Data Caching API`_.

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\ClearByNamespaceInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.zend-server-shm.capabilities

.. table:: Capabilities

   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |Capability          |Value                                                                                                        |
   +====================+=============================================================================================================+
   |supportedDatatypes  |``null``, ``boolean``, ``integer``, ``double``, ``string``, ``array`` (serialized), ``object`` (serialized)  |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |supportedMetadata   |<none>                                                                                                       |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |minTtl              |1                                                                                                            |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |maxTtl              |0                                                                                                            |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |maxKeyLength        |0                                                                                                            |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |staticTtl           |``true``                                                                                                     |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |ttlPrecision        |1                                                                                                            |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |useRequestTime      |``false``                                                                                                    |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |expiredRead         |``false``                                                                                                    |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |namespaceIsPrefix   |``true``                                                                                                     |
   +--------------------+-------------------------------------------------------------------------------------------------------------+
   |namespaceSeparator  |``::``                                                                                                       |
   +--------------------+-------------------------------------------------------------------------------------------------------------+

.. _zend.cache.storage.adapter.examples:

Examples
--------------

.. _zend.cache.storage.adapter.examples.basic:

.. rubric:: Basic usage

.. code-block:: php
   :linenos:

   $cache   = \Zend\Cache\StorageFactory::factory(array(
       'storage' => 'filesystem',
       'plugins' => array(
           // Don't throw exceptions on cache errors
           'ExaptionHander' => array(
               'throw_exceptions' => false
           ),
       )
   ));
   $key    = 'unique-cache-key';
   $result = $cache->getItem($key, $success);
   if (!$success) {
       $result = doExpansiveStuff();
       $cache->setItem($key, $result);
   }

.. _zend.cache.storage.adapter.examples.basic:

.. rubric:: Get multiple rows from db

.. code-block:: php
   :linenos:

   // Instantiate the cache instance using a namespace for the same type of items
   $cache   = \Zend\Cache\StorageFactory::factory(array(
       'storage' => array(
           'name'    => 'filesystem'
           // With a namespace we can indicate the same type of items
           // -> So we can simple use the db id as cache key
           'options' => array(
               'namespace' => 'dbtable'
           ),
       ),
       'plugins' => array(
           // Don't throw exceptions on cache errors
           'ExceptionHandler' => array(
               'throw_exceptions' => false
           ),
           // We store database rows on filesystem so we need to serialize them
           'Serializer'
       )
   ));
   
   // Load two rows from cache if possible
   $ids     = array(1, 2);
   $results = $cache->getItems($ids);
   if (count($results) < count($ids)) {
       // Load rows from db if loading from cache failed
       $missingIds     = array_diff($ids, array_keys($results));
       $missingResults = array();
       $query          = 'SELEcT * FROM dbtable WHERE id IN (' . implode(',', $missingIds) . ')';
       foreach ($pdo->query($query, PDO::FETCH_ASSOC) as $row) {
           $missingResults[ $row['id'] ] = $row;
       }
       
       // Update cache items of the loaded rows from db
       $cache->setItems($missingResults);
       
       // merge results from cache and db
       $results = array_merge($results, $missingResults);
   }


.. _APC: http://pecl.php.net/package/APC
.. _dbm: http://en.wikipedia.org/wiki/Dbm
.. _dba: http://php.net/manual/book.dba.php
.. _dba_open: http://php.net/manual/function.dba-open.php
.. _memcached: http://pecl.php.net/package/memcached
.. _Libmemcached: http://libmemcached.org/
.. _WinCache: http://pecl.php.net/package/WinCache
.. _Zend Server Data Caching API: http://www.zend.com/en/products/server/