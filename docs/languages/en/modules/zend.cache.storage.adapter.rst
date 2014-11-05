.. _zend.cache.storage.adapter:

Zend\\Cache\\Storage\\Adapter
=============================

.. _zend.cache.storage.adapter.intro:

Overview
--------

   Storage adapters are wrappers for real storage resources such as memory
   and the filesystem, using the well known adapter pattern.

   They come with tons of methods to read, write and modify stored items
   and to get information about stored items and the storage.

   All adapters implement the interface ``Zend\Cache\Storage\StorageInterface``
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

   Because many caching operations throw an exception on error, you need to catch them manually or you can use the
   plug-in ``Zend\Cache\Storage\Plugin\ExceptionHandler`` with ``throw_exceptions`` set to ``false`` to automatically
   catch them. You can also define an ``exception_callback`` to log exceptions.

.. _zend.cache.storage.adapter.quick-start:

Quick Start
-----------

   Caching adapters can either be created from the provided ``Zend\Cache\StorageFactory`` factory, or by simply
   instantiating one of the ``Zend\Cache\Storage\Adapter\*`` classes.

   To make life easier, the ``Zend\Cache\StorageFactory`` comes with a ``factory`` method to create an adapter and
   create/add all requested plugins at once.

.. code-block:: php
   :linenos:

   use Zend\Cache\StorageFactory;

   // Via factory:
   $cache = StorageFactory::factory(array(
       'adapter' => array(
           'name'    => 'apc',
           'options' => array('ttl' => 3600),
       ),
       'plugins' => array(
           'exception_handler' => array('throw_exceptions' => false),
       ),
   ));

   // Alternately:
   $cache  = StorageFactory::adapterFactory('apc', array('ttl' => 3600));
   $plugin = StorageFactory::pluginFactory('exception_handler', array(
       'throw_exceptions' => false,
   ));
   $cache->addPlugin($plugin);

   // Or manually:
   $cache  = new Zend\Cache\Storage\Adapter\Apc();
   $cache->getOptions()->setTtl(3600);
   
   $plugin = new Zend\Cache\Storage\Plugin\ExceptionHandler();
   $plugin->getOptions()->setThrowExceptions(false);
   $cache->addPlugin($plugin);


.. _zend.cache.storage.adapter.options:

Basic Configuration Options
---------------------------

.. _zend.cache.adapter.common.options:

   Basic configuration is handled by either ``Zend\Cache\Storage\Adapter\AdapterOptions``, or an adapter-specific options
   class if it exists. You may pass the options instance to the class at instantiation or via the ``setOptions()``
   method, or alternately pass an associative array of options in either place (internally, these are then passed to
   an options class instance). Alternately, you can pass either the options instance or associative array to the
   ``Zend\Cache\StorageFactory::factory`` method.

   The following configuration options are defined by ``Zend\Cache\Storage\Adapter\AdapterOptions``
   and are available for every supported adapter. Adapter-specific configuration options
   are described on adapter level below.

   +--------------+-------------------------+----------------+-------------------------------------------------+
   |Option        |Data Type                |Default Value   |Description                                      |
   +==============+=========================+================+=================================================+
   |ttl           |``integer``              |0               |Time to live                                     |
   +--------------+-------------------------+----------------+-------------------------------------------------+
   |namespace     |``string``               |"zfcache"       |The "namespace" in which cache items will live   |
   +--------------+-------------------------+----------------+-------------------------------------------------+
   |key_pattern   |``null``|``string``      |``null``        |Pattern against which to validate cache keys     |
   +--------------+-------------------------+----------------+-------------------------------------------------+
   |readable      |``boolean``              |``true``        |Enable/Disable reading data from cache           |
   +--------------+-------------------------+----------------+-------------------------------------------------+
   |writable      |``boolean``              |``true``        |Enable/Disable writing data to cache             |
   +--------------+-------------------------+----------------+-------------------------------------------------+

.. _zend.cache.storage.adapter.methods-storage-interface:

The StorageInterface
--------------------

The ``Zend\Cache\Storage\StorageInterface`` is the basic interface implemented by all storage adapters.

.. function:: getItem(string $key, boolean & $success = null, mixed & $casToken = null)
   :noindex:

   Load an item with the given $key.

   If item exists set parameter $success to ``true``, set parameter $casToken and returns ``mixed`` value of item.

   If item can't load set parameter $success to ``false`` and returns ``null``.

   :rtype: mixed

.. function:: getItems(array $keys)
   :noindex:

   Load all items given by $keys returning key-value pairs.

   :rtype: array

.. function:: hasItem(string $key)
   :noindex:

   Test if an item exists.

   :rtype: boolean

.. function:: hasItems(array $keys)
   :noindex:

   Test multiple items.

   :rtype: string[]

.. function:: getMetadata(string $key)
   :noindex:

   Get metadata of an item.

   :rtype: array|boolean

.. function:: getMetadatas(array $keys)
   :noindex:

   Get multiple metadata.

   :rtype: array

.. function:: setItem(string $key, mixed $value)
   :noindex:

   Store an item.

   :rtype: boolean

.. function:: setItems(array $keyValuePairs)
   :noindex:

   Store multiple items.

   :rtype: boolean

.. function:: addItem(string $key, mixed $value)
   :noindex:

   Add an item.

   :rtype: boolean

.. function:: addItems(array $keyValuePairs)
   :noindex:

   Add multiple items.

   :rtype: boolean

.. function:: replaceItem(string $key, mixed $value)
   :noindex:

   Replace an item.

   :rtype: boolean

.. function:: replaceItems(array $keyValuePairs)
   :noindex:

   Replace multiple items.

   :rtype: boolean

.. function:: checkAndSetItem(mixed $token, string $key, mixed $value)
   :noindex:

   Set item only if token matches. It uses the token received from ``getItem()``
   to check if the item has changed before overwriting it.

   :rtype: boolean

.. function:: touchItem(string $key)
   :noindex:

   Reset lifetime of an item.

   :rtype: boolean

.. function:: touchItems(array $keys)
   :noindex:

   Reset lifetime of multiple items.

   :rtype: boolean

.. function:: removeItem(string $key)
   :noindex:

   Remove an item.

   :rtype: boolean

.. function:: removeItems(array $keys)
   :noindex:

   Remove multiple items.

   :rtype: boolean

.. function:: incrementItem(string $key, int $value)
   :noindex:

   Increment an item.

   :rtype: integer|boolean

.. function:: incrementItems(array $keyValuePairs)
   :noindex:

   Increment multiple items.

   :rtype: boolean

.. function:: decrementItem(string $key, int $value)
   :noindex:

   Decrement an item.

   :rtype: integer|boolean

.. function:: decrementItems(array $keyValuePairs)
   :noindex:

   Decrement multiple items.

   :rtype: boolean

.. function:: getCapabilities()
   :noindex:

   Capabilities of this storage.

   :rtype: Zend\\Cache\\Storage\\Capabilities

.. _zend.cache.storage.adapter.methods-available-space-capable-interface:

The AvailableSpaceCapableInterface
----------------------------------

The ``Zend\Cache\Storage\AvailableSpaceCapableInterface`` implements a method
to make it possible getting the current available space of the storage.

.. function:: getAvailableSpace()
   :noindex:

   Get available space in bytes.

   :rtype: integer|float

.. _zend.cache.storage.adapter.methods-total-space-capable-interface:

The TotalSpaceCapableInterface
------------------------------

The ``Zend\Cache\Storage\TotalSpaceCapableInterface`` implements a method to
make it possible getting the total space of the storage.

.. function:: getTotalSpace()
   :noindex:

   Get total space in bytes.

   :rtype: integer|float

.. _zend.cache.storage.adapter.methods-clear-by-namespace-interface:

The ClearByNamespaceInterface
-----------------------------

The ``Zend\Cache\Storage\ClearByNamespaceInterface`` implements a method to
clear all items of a given namespace.

.. function:: clearByNamespace(string $namespace)
   :noindex:

   Remove items of given namespace.

   :rtype: boolean

.. _zend.cache.storage.adapter.methods-clear-by-prefix-interface:

The ClearByPrefixInterface
--------------------------

The ``Zend\Cache\Storage\ClearByPrefixInterface`` implements a method to clear
all items of a given prefix (within the current configured namespace).

.. function:: clearByPrefix(string $prefix)
   :noindex:

   Remove items matching given prefix.

   :rtype: boolean

.. _zend.cache.storage.adapter.methods-clear-expired-interface:

The ClearExpiredInterface
-------------------------

The ``Zend\Cache\Storage\ClearExpiredInterface`` implements a method to clear
all expired items (within the current configured namespace).

.. function:: clearExpired()
   :noindex:

   Remove expired items.

   :rtype: boolean

.. _zend.cache.storage.adapter.methods-flushable-interface:

The FlushableInterface
----------------------

The ``Zend\Cache\Storage\FlushableInterface`` implements a method to flush
the complete storage.

.. function:: flush()
   :noindex:

   Flush the whole storage.

   :rtype: boolean

.. _zend.cache.storage.adapter.methods-iterable-interface:

The IterableInterface
---------------------

The ``Zend\Cache\Storage\IterableInterface`` implements a method to get an
iterator to iterate over items of the storage. It extends ``IteratorAggregate``
so it's possible to directly iterate over the storage using ``foreach``.

.. function:: getIterator()
   :noindex:

   Get an Iterator.

   :rtype: Zend\\Cache\\Storage\\IteratorInterface

.. _zend.cache.storage.adapter.methods-optimizable-interface:

The OptimizableInterface
------------------------

The ``Zend\Cache\Storage\OptimizableInterface`` implements a method to run
optimization processes on the storage.

.. function:: optimize()
   :noindex:

   Optimize the storage.

   :rtype: boolean

.. _zend.cache.storage.adapter.methods-taggable-interface:

The TaggableInterface
---------------------

The ``Zend\Cache\Storage\TaggableInterface`` implements methods to mark items
with one or more tags and to clean items matching tags.

.. function:: setTags(string $key, string[] $tags)
   :noindex:

   Set tags to an item by given key.
   (An empty array will remove all tags)

   :rtype: boolean

.. function:: getTags(string $key)
   :noindex:

   Get tags of an item by given key.

   :rtype: string[]|false

.. function:: clearByTags(string[] $tags, boolean $disjunction = false)
   :noindex:

   Remove items matching given tags.

   If $disjunction is ``true`` only one of the given tags must match
   else all given tags must match.

   :rtype: boolean

.. _zend.cache.storage.adapter.apc:

The Apc Adapter
---------------

   The ``Zend\Cache\Storage\Adapter\Apc`` adapter stores cache items in shared
   memory through the required PHP extension APC_ (Alternative PHP Cache).

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
   - ``Zend\Cache\Storage\ClearByNamespaceInterface``
   - ``Zend\Cache\Storage\ClearByPrefixInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\IterableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.apc.capabilities:

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

.. _zend.cache.storage.adapter.apc.options:

.. table:: Adapter specific options

   +--------------------+-----------+---------------+--------------------------------------------+
   |Name                |Data Type  |Default Value  |Description                                 |
   +====================+===========+===============+============================================+
   |namespace_separator |``string`` |":"            |A separator for the namespace and prefix    |
   +--------------------+-----------+---------------+--------------------------------------------+

.. _zend.cache.storage.adapter.dba:

The Dba Adapter
---------------

   The ``Zend\Cache\Storage\Adapter\Dba`` adapter stores cache items into dbm_
   like databases using the required PHP extension dba_.

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
   - ``Zend\Cache\Storage\ClearByNamespaceInterface``
   - ``Zend\Cache\Storage\ClearByPrefixInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\IterableInterface``
   - ``Zend\Cache\Storage\OptimizableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.dba.capabilities:

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

.. _zend.cache.storage.adapter.dba.options:

.. table:: Adapter specific options

   +--------------------+-----------+---------------+------------------------------------------------------------------------------------+
   |Name                |Data Type  |Default Value  |Description                                                                         |
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

.. note::

   **This adapter doesn't support automatically expire items**

   Because of this adapter doesn't support automatically expire items it's
   very important to clean outdated items by self.

.. _zend.cache.storage.adapter.filesystem:

The Filesystem Adapter
----------------------

   The ``Zend\Cache\Storage\Adapter\Filesystem`` adapter stores cache items
   into the filesystem.

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

.. _zend.cache.storage.adapter.filesystem.capabilities:

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

.. _zend.cache.storage.adapter.filesystem.options:

.. table:: Adapter specific options

   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |Name                |Data Type             |Default Value            |Description                                                                         |
   +====================+======================+=========================+====================================================================================+
   |namespace_separator |``string``            |":"                      |A separator for the namespace and prefix                                            |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |cache_dir           |``string``            |""                       |Directory to store cache files                                                      |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |clear_stat_cache    |``boolean``           |``true``                 |Call ``clearstatcache()`` enabled?                                                  |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |dir_level           |``integer``           |1                        |Defines how much sub-directories should be created                                  |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |dir_permission      |``integer`` ``false`` |0700                     |Set explicit permission on creating new directories                                 |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |file_locking        |``boolean``           |``true``                 |Lock files on writing                                                               |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |file_permission     |``integer`` ``false`` |0600                     |Set explicit permission on creating new files                                       |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |key_pattern         |``string``            |``/^[a-z0-9_\+\-]*$/Di`` |Validate key against pattern                                                        |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |no_atime            |``boolean``           |``true``                 |Don't get 'fileatime' as 'atime' on metadata                                        |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |no_ctime            |``boolean``           |``true``                 |Don't get 'filectime' as 'ctime' on metadata                                        |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+
   |umask               |``integer`` ``false`` |``false``                |Use umask_ to set file and directory permissions                                    |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------+

.. _zend.cache.storage.adapter.memcached:

The Memcached Adapter
---------------------

   The ``Zend\Cache\Storage\Adapter\Memcached`` adapter stores cache
   items over the memcached protocol. It's using the required PHP extension
   memcached_ which is based on Libmemcached_.

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.memcached.capabilities:

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

.. _zend.cache.storage.adapter.memcached.options:

.. table:: Adapter specific options

   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------------------------+
   |Name                |Data Type             |Default Value            |Description                                                                                           |
   +====================+======================+=========================+======================================================================================================+
   |servers             |``array``             |``[]``                   |List of servers in [] = array(``string`` host, ``integer`` port)                                      |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------------------------+
   |lib_options         |``array``             |``[]``                   |Associative array of Libmemcached options were the array key is the option name                       |
   |                    |                      |                         |(without the prefix "OPT\_") or the constant value. The array value is the option value               |
   |                    |                      |                         |                                                                                                      |
   |                    |                      |                         |Please read this<http://php.net/manual/memcached.setoption.php> for more information                  |
   +--------------------+----------------------+-------------------------+------------------------------------------------------------------------------------------------------+

.. _zend.cache.storage.adapter.redis:

The Redis Adapter
---------------------

   The ``Zend\Cache\Storage\Adapter\Redis`` adapter stores cache
   items over the redis protocol. It's using the required PHP extension
   redis_.

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.redis.capabilities:

.. table:: Capabilities

   +--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
   |Capability          |Value                                                                                                                                            |
   +====================+=================================================================================================================================================+
   |supportedDatatypes  | ``string``, ``array`` (serialized), ``object`` (serialized)                                                                                     |
   +--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
   |supportedMetadata   |<none>                                                                                                                                           |
   +--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
   |minTtl              |1                                                                                                                                                |
   +--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
   |maxTtl              |0                                                                                                                                                |
   +--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
   |staticTtl           |``true``                                                                                                                                         |
   +--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
   |ttlPrecision        |1                                                                                                                                                |
   +--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
   |useRequestTime      |``false``                                                                                                                                        |
   +--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
   |expiredRead         |``false``                                                                                                                                        |
   +--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
   |maxKeyLength        |255                                                                                                                                              |
   +--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
   |namespaceIsPrefix   |``true``                                                                                                                                         |
   +--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+
   |namespaceSeparator  |<none>                                                                                                                                           |
   +--------------------+-------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.storage.adapter.redis.options:

.. table:: Adapter specific options

   +--------------------+----------------------+-------------------------+--------------------------------------------------------------------------------------+
   |Name                |Data Type             |Default Value            |Description                                                                           |
   +====================+======================+=========================+======================================================================================+
   |database            |``integer``           |0                        |Set database identifier                                                               |
   +--------------------+----------------------+-------------------------+--------------------------------------------------------------------------------------+
   |lib_option          |``array``             |``[]``                   | Associative array of redis options were the array key is the option name             |
   +--------------------+----------------------+-------------------------+--------------------------------------------------------------------------------------+
   |namespace_separator |``string``            |":"                      |A separator for the namespace and prefix                                              |
   +--------------------+----------------------+-------------------------+--------------------------------------------------------------------------------------+
   |password            |``string``            |""                       |Set password                                                                          |
   +--------------------+----------------------+-------------------------+--------------------------------------------------------------------------------------+
   |persistent_id       |``string``            |````                     |Set persistant id (``RDB``, ``AOF``)                                                  |
   +--------------------+----------------------+-------------------------+--------------------------------------------------------------------------------------+
   |resource_manager    |``string``            |````                     |Set the redis resource manager to use                                                 |
   +--------------------+----------------------+-------------------------+--------------------------------------------------------------------------------------+
   |servers             |                      |                         | Server can be described as follows:                                                  |
   |                    |                      |                         |  - URI:   /path/to/sock.sock                                                         |
   |                    |                      |                         |  - Assoc: array('host' => <host>[, 'port' => <port>[, 'timeout' => <timeout>]])      |
   |                    |                      |                         |  - List:  array(<host>[, <port>, [, <timeout>]])                                     |
   +--------------------+----------------------+-------------------------+--------------------------------------------------------------------------------------+

.. _zend.cache.storage.adapter.memory:

The Memory Adapter
------------------

   The ``Zend\Cache\Storage\Adapter\Memory`` adapter stores cache items into
   the PHP process using an array.

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
   - ``Zend\Cache\Storage\ClearByPrefixInterface``
   - ``Zend\Cache\Storage\ClearExpiredInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\IterableInterface``
   - ``Zend\Cache\Storage\TaggableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.memory.capabilities:

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

.. _zend.cache.storage.adapter.memory.options:

.. table:: Adapter specific options

   +--------------------+-----------------------+-------------------------------------+-----------------------------------------------------------------------------------------------+
   |Name                |Data Type              |Default Value                        |Description                                                                                    |
   +====================+=======================+=====================================+===============================================================================================+
   |memory_limit        |``string`` ``integer`` |<50% of ini value ``memory_limit``>  |Limit of how much memory can PHP allocate to allow store items into this adapter               |
   |                    |                       |                                     |                                                                                               |
   |                    |                       |                                     | - If the used memory of PHP exceeds this limit an OutOfSpaceException will be thrown.         |
   |                    |                       |                                     | - A number less or equal 0 will disable the memory limit                                      |
   |                    |                       |                                     | - When a number is used, the value is measured in bytes (Shorthand notation may also be used) |
   +--------------------+-----------------------+-------------------------------------+-----------------------------------------------------------------------------------------------+

.. note::

   All stored items will be lost after terminating the script.

.. _zend.cache.storage.adapter.wincache:

The WinCache Adapter
--------------------

   The ``Zend\Cache\Storage\Adapter\WinCache`` adapter stores cache items into
   shared memory through the required PHP extension WinCache_.

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.wincache.capabilities:

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

.. _zend.cache.storage.adapter.wincache.options:

.. table:: Adapter specific options

   +--------------------+-----------+---------------+--------------------------------------------+
   |Name                |Data Type  |Default Value  |Description                                 |
   +====================+===========+===============+============================================+
   |namespace_separator |``string`` |":"            |A separator for the namespace and prefix    |
   +--------------------+-----------+---------------+--------------------------------------------+

.. _zend.cache.storage.adapter.xcache:

The XCache Adapter
------------------

   The ``Zend\Cache\Storage\Adapter\XCache`` adapter stores cache items into
   shared memory through the required PHP extension XCache_.

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
   - ``Zend\Cache\Storage\ClearByNamespaceInterface``
   - ``Zend\Cache\Storage\ClearByPrefixInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\IterableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.xcache.capabilities:

.. table:: Capabilities

   +--------------------+---------------------------------------------------------------------------------------------------+
   |Capability          |Value                                                                                              |
   +====================+===================================================================================================+
   |supportedDatatypes  |``boolean``, ``integer``, ``double``, ``string``, ``array`` (serialized), ``object`` (serialized)  |
   +--------------------+---------------------------------------------------------------------------------------------------+
   |supportedMetadata   |internal_key, size, refcount, hits, ctime, atime, hvalue                                           |
   +--------------------+---------------------------------------------------------------------------------------------------+
   |minTtl              |1                                                                                                  |
   +--------------------+---------------------------------------------------------------------------------------------------+
   |maxTtl              |<ini value of ``xcache.var_maxttl``>                                                               |
   +--------------------+---------------------------------------------------------------------------------------------------+
   |staticTtl           |``true``                                                                                           |
   +--------------------+---------------------------------------------------------------------------------------------------+
   |ttlPrecision        |1                                                                                                  |
   +--------------------+---------------------------------------------------------------------------------------------------+
   |useRequestTime      |``true``                                                                                           |
   +--------------------+---------------------------------------------------------------------------------------------------+
   |expiredRead         |``false``                                                                                          |
   +--------------------+---------------------------------------------------------------------------------------------------+
   |maxKeyLength        |5182                                                                                               |
   +--------------------+---------------------------------------------------------------------------------------------------+
   |namespaceIsPrefix   |``true``                                                                                           |
   +--------------------+---------------------------------------------------------------------------------------------------+
   |namespaceSeparator  |<Option value of ``namespace_separator``>                                                          |
   +--------------------+---------------------------------------------------------------------------------------------------+

-------------------------------

.. _zend.cache.storage.adapter.xcache.options:

.. table:: Adapter specific options

   +--------------------+------------+---------------+---------------------------------------------------------------------------------------+
   |Name                |Data Type   |Default Value  |Description                                                                            |
   +====================+============+===============+=======================================================================================+
   |namespace_separator |``string``  |":"            |A separator for the namespace and prefix                                               |
   +--------------------+------------+---------------+---------------------------------------------------------------------------------------+
   |admin_auth          |``boolean`` |``false``      |Enable admin authentication by configuration options ``admin_user`` and ``admin_pass`` |
   |                    |            |               |                                                                                       |
   |                    |            |               |This makes XCache_ administration functions accessible if ``xcache.admin.enable_auth`` |
   |                    |            |               |is enabled without the need of HTTP-Authentication.                                    |
   +--------------------+------------+---------------+---------------------------------------------------------------------------------------+
   |admin_user          |``string``  |""             |The username of ``xcache.admin.user``                                                  |
   +--------------------+------------+---------------+---------------------------------------------------------------------------------------+
   |admin_pass          |``string``  |""             |The password of ``xcache.admin.pass`` in plain text                                    |
   +--------------------+------------+---------------+---------------------------------------------------------------------------------------+

.. _zend.cache.storage.adapter.zend-server-disk:

The ZendServerDisk Adapter
--------------------------

   This ``Zend\Cache\Storage\Adapter\ZendServerDisk`` adapter stores cache
   items on filesystem through the `Zend Server Data Caching API`_.

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\AvailableSpaceCapableInterface``
   - ``Zend\Cache\Storage\ClearByNamespaceInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.zend-server-disk.capabilities:

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

.. _zend.cache.storage.adapter.zend-server-shm:

The ZendServerShm Adapter
-------------------------

   The ``Zend\Cache\Storage\Adapter\ZendServerShm`` adapter stores cache
   items in shared memory through the `Zend Server Data Caching API`_.

   This adapter implements the following interfaces:

   - ``Zend\Cache\Storage\StorageInterface``
   - ``Zend\Cache\Storage\ClearByNamespaceInterface``
   - ``Zend\Cache\Storage\FlushableInterface``
   - ``Zend\Cache\Storage\TotalSpaceCapableInterface``

.. _zend.cache.storage.adapter.zend-server-shm.capabilities:

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
--------

.. rubric:: Basic usage

.. code-block:: php
   :linenos:

   $cache   = \Zend\Cache\StorageFactory::factory(array(
       'adapter' => array(
           'name' => 'filesystem'
       ),
       'plugins' => array(
           // Don't throw exceptions on cache errors
           'exception_handler' => array(
               'throw_exceptions' => false
           ),
       )
   ));
   $key    = 'unique-cache-key';
   $result = $cache->getItem($key, $success);
   if (!$success) {
       $result = doExpensiveStuff();
       $cache->setItem($key, $result);
   }

.. rubric:: Get multiple rows from db

.. code-block:: php
   :linenos:

   // Instantiate the cache instance using a namespace for the same type of items
   $cache   = \Zend\Cache\StorageFactory::factory(array(
       'adapter' => array(
           'name'    => 'filesystem'
           // With a namespace we can indicate the same type of items
           // -> So we can simple use the db id as cache key
           'options' => array(
               'namespace' => 'dbtable'
           ),
       ),
       'plugins' => array(
           // Don't throw exceptions on cache errors
           'exception_handler' => array(
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
       $query          = 'SELECT * FROM dbtable WHERE id IN (' . implode(',', $missingIds) . ')';
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
.. _redis: https://github.com/nicolasff/phpredis
.. _Libmemcached: http://libmemcached.org/
.. _WinCache: http://pecl.php.net/package/WinCache
.. _XCache: http://xcache.lighttpd.net/
.. _Zend Server Data Caching API: http://www.zend.com/en/products/server/
.. _umask: http://wikipedia.org/wiki/Umask
