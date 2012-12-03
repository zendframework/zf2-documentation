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

.. function:: __construct(Zend\\Cache\\Storage\\StorageInterface $storage, stdClass $marker, array $capabilities = array(), Zend\\Cache\\Storage\\Capabilities|null $baseCapabilities = null)
   :noindex:

   Constructor

.. function:: getSupportedDatatypes()
   :noindex:

   Get supported datatypes.

   :rtype: array

.. function:: setSupportedDatatypes(stdClass $marker, array $datatypes)
   :noindex:

   Set supported datatypes.

   :rtype: Zend\\Cache\\Storage\\Capabilities

.. function:: getSupportedMetadata()
   :noindex:

   Get supported metadata.

   :rtype: array

.. function:: setSupportedMetadata(stdClass $marker, string $metadata)
   :noindex:

   Set supported metadata.

   :rtype: Zend\\Cache\\Storage\\Capabilities

.. function:: getMinTtl()
   :noindex:

   Get minimum supported time-to-live.

   (Returning 0 means items never expire)

   :rtype: integer

.. function:: setMinTtl(stdClass $marker, int $minTtl)
   :noindex:

   Set minimum supported time-to-live.

   :rtype: Zend\\Cache\\Storage\\Capabilities

.. function:: getMaxTtl()
   :noindex:

   Get maximum supported time-to-live.

   :rtype: integer

.. function:: setMaxTtl(stdClass $marker, int $maxTtl)
   :noindex:

   Set maximum supported time-to-live.

   :rtype: Zend\\Cache\\Storage\\Capabilities

.. function:: getStaticTtl()
   :noindex:

   Is the time-to-live handled static (on write), or dynamic (on read).

   :rtype: boolean

.. function:: setStaticTtl(stdClass $marker, boolean $flag)
   :noindex:

   Set if the time-to-live is handled statically (on write) or dynamically (on read).

   :rtype: Zend\\Cache\\Storage\\Capabilities

.. function:: getTtlPrecision()
   :noindex:

   Get time-to-live precision.

   :rtype: float

.. function:: setTtlPrecision(stdClass $marker, float $ttlPrecision)
   :noindex:

   Set time-to-live precision.

   :rtype: Zend\\Cache\\Storage\\Capabilities

.. function:: getUseRequestTime()
   :noindex:

   Get the "use request time" flag status.

   :rtype: boolean

.. function:: setUseRequestTime(stdClass $marker, boolean $flag)
   :noindex:

   Set the "use request time" flag.

   :rtype: Zend\\Cache\\Storage\\Capabilities

.. function:: getExpiredRead()
   :noindex:

   Get flag indicating if expired items are readable.

   :rtype: boolean

.. function:: setExpiredRead(stdClass $marker, boolean $flag)
   :noindex:

   Set if expired items are readable.

   :rtype: Zend\\Cache\\Storage\\Capabilities

.. function:: getMaxKeyLength()
   :noindex:

   Get maximum key length.

   :rtype: integer

.. function:: setMaxKeyLength(stdClass $marker, int $maxKeyLength)
   :noindex:

   Set maximum key length.

   :rtype: Zend\\Cache\\Storage\\Capabilities

.. function:: getNamespaceIsPrefix()
   :noindex:

   Get if namespace support is implemented as a key prefix.

   :rtype: boolean

.. function:: setNamespaceIsPrefix(stdClass $marker, boolean $flag)
   :noindex:

   Set if namespace support is implemented as a key prefix.

   :rtype: Zend\\Cache\\Storage\\Capabilities

.. function:: getNamespaceSeparator()
   :noindex:

   Get namespace separator if namespace is implemented as a key prefix.

   :rtype: string

.. function:: setNamespaceSeparator(stdClass $marker, string $separator)
   :noindex:

   Set the namespace separator if namespace is implemented as a key prefix.

   :rtype: Zend\\Cache\\Storage\\Capabilities

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
