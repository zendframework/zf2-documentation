.. _zend.serializer:

Introduction to Zend\\Serializer
================================

The ``Zend\Serializer`` component provides an adapter based interface to
simply generate storable representation of PHP_ types by different facilities,
and recover.

For more information what a serializer is read the wikipedia page of Serialization_.

.. _zend.serializer.quick-start:

Quick Start
-----------

Serializing adapters can either be created from the provided
``Zend\Serializer\Serializer::factory`` method, or by simply instantiating one
of the ``Zend\Serializer\Adapter\*`` classes.

.. code-block:: php
   :linenos:

   use Zend\Serializer\Serializer;

   // Via factory:
   $serializer = Zend\Serializer\Serializer::factory('PhpSerialize');
   
   // Alternately:
   $serializer = new Zend\Serializer\Adapter\PhpSerialize();
   
   // Now $serializer is an instance of Zend\Serializer\Adapter\AdapterInterface,
   // specifically Zend\Serializer\Adapter\PhpSerialize

   try {
       $serialized = $serializer->serialize($data);
       // now $serialized is a string

       $unserialized = $serializer->unserialize($serialized);
       // now $data == $unserialized
   } catch (Zend\Serializer\Exception\ExceptionInterface $e) {
       echo $e;
   }

The method ``serialize()`` generates a storable string. To regenerate this
serialized data you can simply call the method ``unserialize()``.

Any time an error is encountered serializing or unserializing,
``Zend\Serializer`` will throw a ``Zend\Serializer\Exception\ExceptionInterface``.

Because of an application often uses internally only one serializer it is
possible to define and use a default serializer. That serializer will be used
by defaut by other components like ``Zend\Cache\Storage\Plugin\Serializer``.

To use the default serializer you can simply use the static serialization
methods of the basic ``Zend\Serializer\Serializer``:

.. code-block:: php
   :linenos:

   use Zend\Serializer\Serializer;

   try {
       $serialized = Serializer::serialize($data);
       // now $serialized is a string

       $unserialized = Serializer::unserialize($serialized);
       // now $data == $unserialized
   } catch (Zend\Serializer\Exception\ExceptionInterface $e) {
       echo $e;
   }

.. _zend.serializer.options:

Basic configuration Options
---------------------------

To configure a serializer adapter, you can optionally use an instance of
``Zend\Serializer\Adapter\AdapterOptions``, an instance of one of the adapter
specific options class, an ``array`` or an instance of ``Traversable``.
The adapter will convert it into the adapter specífic options class instance
(if present) or into the basic ``Zend\Serializer\Adapter\AdapterOptions`` class
instance.

Options can be passed as second argument to the provided
``Zend\Serializer\Serializer::factory`` method, using the method ``setOptions``
or set as constructor argument.

.. _zend.serializer.serializer.methods:

Available Methods
-----------------

Each serializer implements the interface ``Zend\Serializer\Adapter\AdapterInterface``.

This interface defines the following methods:

.. _zend.serializer.adapter.adapterinterface.methods.serialize:

**serialize**
   ``serialize(mixed $value)``

   Generates a storable representation of a value.

   Returns ``string`` of the serialized value

.. _zend.serializer.adapter.adapterinterface.methods.unserialize:

**unserialize**
   ``unserialize(string $value)``

   Creates a PHP value from a stored representation.

   Returns the PHP value


The basic class ``Zend\Serializer\Serializer`` will be used to instantiate the
adapters, to configure the factory and to handle static serializing.

It defines the following **static** methods:

.. _zend.serializer.serializer.methods.factory:

**factory**
   ``factory(string|Zend\Serializer\Adapter\AdapterInterface $adapterName, Zend\Serializer\Adapter\AdapterOptions|array|Traversable|null $adapterOptions = null)``

   Create a serializer adapter instance.

   Returns ``Zend\Serializer\Adapter\AdapterInterface``

.. _zend.serializer.serializer.methods.set-adapter-plugin-manager:

**setAdapterPluginManager**
   ``setAdapterPluginManager(Zend\Serializer\AdapterPluginManager $adapters)``

   Change the adapter plugin manager

   Returns ``void``

.. _zend.serializer.serializer.methods.get-adapter-plugin-manager:

**getAdapterPluginManager**
   ``getAdapterPluginManager()``

   Get the adapter plugin manager

   Returns ``Zend\Serializer\AdapterPluginManager``

.. _zend.serializer.serializer.methods.reset-adapter-plugin-manager:

**resetAdapterPluginManager**
   ``resetAdapterPluginManager()``

   Resets the internal adapter plugin manager

   Returns ``void``

.. _zend.serializer.serializer.methods.set-default-adapter:

**setDefaultAdapter**
   ``setDefaultAdapter(string|Zend\Serializer\Adapter\AdapterInterface $adapter, Zend\Serializer\Adapter\AdapterOptions|array|Traversable|null $adapterOptions = null)``

   Change the default adapter.

   Returns ``void``

.. _zend.serializer.serializer.methods.get-default-adapter:

**getDefaultAdapter**
   ``getDefaultAdapter()``

   Get the default adapter.

   Returns ``Zend\Serializer\Adapter\AdapterInterface``

.. _zend.serializer.serializer.methods.serialize:

**serialize**
   ``serialize(mixed $value, string|Zend\Serializer\Adapter\AdapterInterface|null $adapter = null, Zend\Serializer\Adapter\AdapterOptions|array|Traversable|null $adapterOptions = null)``

   Generates a storable representation of a value using the default adapter.
   Optionally different adapter could be provided as second argument.

   Returns ``string`` of the serialized value

.. _zend.serializer.serializer.methods.unserialize:

**unserialize**
   ``unserialize(string $value, string|Zend\Serializer\Adapter\AdapterInterface|null $adapter = null, Zend\Serializer\Adapter\AdapterOptions|array|Traversable|null $adapterOptions = null)``

   Creates a PHP value from a stored representation using the default adapter.
   Optionally different adapter could be provided as second argument

   Returns PHP value

.. _PHP: http://php.net
.. _Serialization: http://en.wikipedia.org/wiki/Serialization
