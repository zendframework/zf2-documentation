.. _zend.stdlib.hydrator:

Zend\\Stdlib\\Hydrator
======================

Hydration is the act of populating an object from a set of data.

The ``Hydrator`` is a simple component to provide mechanisms both for hydrating objects, as well as extracting data
sets from them.

The component consists of an interface, and several implementations for common use cases.

.. _zend.stdlib.hydrator.interface:

HydratorInterface
-----------------

.. code-block:: php
   :linenos:

   namespace Zend\Stdlib\Hydrator;

   interface HydratorInterface
   {
       /**
        * Extract values from an object
        *
        * @param  object $object
        * @return array
        */
       public function extract($object);

       /**
        * Hydrate $object with the provided $data.
        *
        * @param  array $data
        * @param  object $object
        * @return void
        */
       public function hydrate(array $data, $object);
   }

.. _zend.stdlib.hydrator.usage:

Usage
-----

Usage is quite simple: simply instantiate the hydrator, and then pass information to it.

.. code-block:: php
   :linenos:

   use Zend\Stdlib\Hydrator;
   $hydrator = new Hydrator\ArraySerializable();

   $object = new ArrayObject(array());

   $hydrator->hydrate($someData, $object);

   // or, if the object has data we want as an array:
   $data = $hydrator->extract($object);

.. _zend.stdlib.hydrator.concrete:

Available Implementations
-------------------------

- **Zend\\Stdlib\\Hydrator\\ArraySerializable**

  Follows the definition of ``ArrayObject``. Objects must implement either the ``exchangeArray()`` or
  ``populate()`` methods to support hydration, and the ``getArrayCopy()`` method to support extraction.

- **Zend\\Stdlib\\Hydrator\\ClassMethods**

  Any data key matching a setter method will be called in order to hydrate; any method matching a getter method
  will be called for extraction.

- **Zend\\Stdlib\\Hydrator\\ObjectProperty**

  Any data key matching a publicly accessible property will be hydrated; any public properties will be used for
  extraction.


