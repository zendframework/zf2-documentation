.. _zend.cache.storage.capabilities:

Zend\\Cache\\Storage\\Capabilities
==================================

.. _zend.cache.storage.capabilities.intro:

Overview
--------

Storage capabilities describes how a storage adapter works and which features it supports.

To get capabilities of a storage adapter, you can use the method ``getCapabilities()`` of the storage adapter but
only the storage adapter and its plugins have permissions to change them.

Because capabilities are mutable, for example, by changing some options, you can subscribe to the "change" event to
get notifications; see the examples for details.

If you are writing your own plugin or adapter, you can also change capabilities because you have access to the
marker object and can create your own marker to instantiate a new object of ``Zend\Cache\Storage\Capabilities``.

.. _zend.cache.storage.capabilities.methods:

Available Methods
-----------------

.. _zend.cache.storage.capabilities.methods.__construct:

**__construct**
   ``__construct(stdClass $marker, array $capabilities = array ( ), null|Zend\Cache\Storage\Capabilities $baseCapabilities)``
   ``__construct(Zend\Cache\Storage\StorageInterface $storage, stdClass $marker, array $capabilities = array(), Capabilities $baseCapabilities = null)``

   Constructor

.. _zend.cache.storage.capabilities.methods.get-supported-datatypes:

**getSupportedDatatypes**
   ``getSupportedDatatypes()``

   Get supported datatypes.

   Returns array.

.. _zend.cache.storage.capabilities.methods.set-supported-datatypes:

**setSupportedDatatypes**
   ``setSupportedDatatypes(stdClass $marker, array $datatypes)``

   Set supported datatypes.

   Implements a fluent interface.

.. _zend.cache.storage.capabilities.methods.get-supported-metadata:

**getSupportedMetadata**
   ``getSupportedMetadata()``

   Get supported metadata.

   Returns array.

.. _zend.cache.storage.capabilities.methods.set-supported-metadata:

**setSupportedMetadata**
   ``setSupportedMetadata(stdClass $marker, string $metadata)``

   Set supported metadata

   Implements a fluent interface.


.. _zend.cache.storage.capabilities.methods.get-min-ttl:

**getMinTtl**
   ``getMinTtl()``

   Get minimum supported time-to-live

   Returns int (0 means items never expire)

.. _zend.cache.storage.capabilities.methods.set-min-ttl:

**setMinTtl**
   ``setMinTtl(stdClass $marker, int $minTtl)``

   Set minimum supported time-to-live

   Implements a fluent interface.


.. _zend.cache.storage.capabilities.methods.get-max-ttl:

**getMaxTtl**
   ``getMaxTtl()``

   Get maximum supported time-to-live

   Returns int

.. _zend.cache.storage.capabilities.methods.set-max-ttl:

**setMaxTtl**
   ``setMaxTtl(stdClass $marker, int $maxTtl)``

   Set maximum supported time-to-live

   Implements a fluent interface.

.. _zend.cache.storage.capabilities.methods.get-static-ttl:

**getStaticTtl**
   ``getStaticTtl()``

   Is the time-to-live handled static (on write), or dynamic (on read).

   Returns boolean

.. _zend.cache.storage.capabilities.methods.set-static-ttl:

**setStaticTtl**
   ``setStaticTtl(stdClass $marker, boolean $flag)``

   Set if the time-to-live is handled statically (on write) or dynamically (on read)

   Implements a fluent interface.

.. _zend.cache.storage.capabilities.methods.get-ttl-precision:

**getTtlPrecision**
   ``getTtlPrecision()``

   Get time-to-live precision.

   Returns float.

.. _zend.cache.storage.capabilities.methods.set-ttl-precision:

**setTtlPrecision**
   ``setTtlPrecision(stdClass $marker, float $ttlPrecision)``

   Set time-to-live precision.

   Implements a fluent interface.

.. _zend.cache.storage.capabilities.methods.get-use-request-time:

**getUseRequestTime**
   ``getUseRequestTime()``

   Get the "use request time" flag status

   Returns boolean

.. _zend.cache.storage.capabilities.methods.set-use-request-time:

**setUseRequestTime**
   ``setUseRequestTime(stdClass $marker, boolean $flag)``

   Set the "use request time" flag.

   Implements a fluent interface.

.. _zend.cache.storage.capabilities.methods.get-expired-read:

**getExpiredRead**
   ``getExpiredRead()``

   Get flag indicating if expired items are readable.

   Returns boolean

.. _zend.cache.storage.capabilities.methods.set-expired-read:

**setExpiredRead**
   ``setExpiredRead(stdClass $marker, boolean $flag)``

   Set if expired items are readable.

   Implements a fluent interface.

.. _zend.cache.storage.capabilities.methods.get-max-key-length:

**getMaxKeyLength**
   ``getMaxKeyLength()``

   Get maximum key lenth.

   Returns int

.. _zend.cache.storage.capabilities.methods.set-max-key-length:

**setMaxKeyLength**
   ``setMaxKeyLength(stdClass $marker, int $maxKeyLength)``

   Set maximum key lenth.

   Implements a fluent interface.

.. _zend.cache.storage.capabilities.methods.get-namespace-is-prefix:

**getNamespaceIsPrefix**
   ``getNamespaceIsPrefix()``

   Get if namespace support is implemented as a key prefix.

   Returns boolean

.. _zend.cache.storage.capabilities.methods.set-namespace-is-prefix:

**setNamespaceIsPrefix**
   ``setNamespaceIsPrefix(stdClass $marker, boolean $flag)``

   Set if namespace support is implemented as a key prefix.

   Implements a fluent interface.

.. _zend.cache.storage.capabilities.methods.get-namespace-separator:

**getNamespaceSeparator**
   ``getNamespaceSeparator()``

   Get namespace separator if namespace is implemented as a key prefix.

   Returns string

.. _zend.cache.storage.capabilities.methods.set-namespace-separator:

**setNamespaceSeparator**
   ``setNamespaceSeparator(stdClass $marker, string $separator)``

   Set the namespace separator if namespace is implemented as a key prefix.

   Implements a fluent interface.

.. _zend.cache.storage.capabilities.examples:

Examples
--------

.. _zend.cache.storage.capabilities.examples.specific:

.. rubric:: Get storage capabilities and do specific stuff in base of it

.. code-block:: php
   :linenos:

   use Zend\Cache\StorageFactory;

   $cache = StorageFactory::adapterFactory('filesystem');
   $supportedDatatypes = $cache->getCapabilities()->getSupportedDatatypes();

   // now you can run specific stuff in base of supported feature
   if ($supportedDatatypes['object']) {
       $cache->set($key, $object);
   } else {
       $cache->set($key, serialize($object));
   }


.. _zend.cache.storage.capabilities.examples.event.change:

.. rubric:: Listen to change event

.. code-block:: php
   :linenos:

   use Zend\Cache\StorageFactory;

   $cache = StorageFactory::adapterFactory('filesystem', array(
       'no_atime' => false,
   ));

   // Catching capability changes
   $cache->getEventManager()->attach('capability', function($event) {
       echo count($event->getParams()) . ' capabilities changed';
   });

   // change option which changes capabilities
   $cache->getOptions()->setNoATime(true);
