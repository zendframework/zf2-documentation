.. _zend.serializer.introduction:

Introduction
============

``Zend_Serializer`` provides an adapter based interface to simply generate storable representation of *PHP* types by different facilities, and recover.

.. _zend.serializer.introduction.example.dynamic:

.. rubric:: Using Zend_Serializer dynamic interface

To instantiate a serializer you should use the factory method with the name of the adapter:

.. code-block:: php
   :linenos:

   $serializer = Zend_Serializer::factory('PhpSerialize');
   // Now $serializer is an instance of Zend_Serializer_Adapter_AdapterInterface,
   // specifically Zend_Serializer_Adapter_PhpSerialize

   try {
       $serialized = $serializer->serialize($data);
       // now $serialized is a string

       $unserialized = $serializer->unserialize($serialized);
       // now $data == $unserialized
   } catch (Zend_Serializer_Exception $e) {
       echo $e;
   }

The method ``serialize()`` generates a storable string. To regenerate this serialized data you can simply call the method ``unserialize()``.

Any time an error is encountered serializing or unserializing, ``Zend_Serializer`` will throw a ``Zend_Serializer_Exception``.

To configure a given serializer adapter, you can optionally add an array or an instance of ``Zend_Config`` to the ``factory()`` or to the ``serialize()`` and ``unserialize()`` methods:

.. code-block:: php
   :linenos:

   $serializer = Zend_Serializer::factory('Wddx', array(
       'comment' => 'serialized by Zend_Serializer',
   ));

   try {
       $serialized = $serializer->serialize(
           $data,
           array('comment' => 'change comment')
       );

       $unserialized = $serializer->unserialize(
           $serialized,
           array(/* options for unserialize */)
       );
   } catch (Zend_Serializer_Exception $e) {
       echo $e;
   }

Options passed to the ``factory()`` are valid for the instantiated object. You can change these options using the ``setOption(s)`` method. To change one or more options only for a single call, pass them as the second argument to either the ``serialize()`` or ``unserialize()`` method.

.. _zend.serializer.introduction.example.static.php:

.. rubric:: Using the Zend_Serializer static interface

You can register a specific serializer adapter as a default serialization adapter for use with ``Zend_Serializer``. By default, the ``PhpSerialize`` adapter will be registered, but you can change this option using the ``setDefaultAdapter()`` static method.

.. code-block:: php
   :linenos:

   Zend_Serializer::setDefaultAdapter('PhpSerialize', $options);
   // or
   $serializer = Zend_Serializer::factory('PhpSerialize', $options);
   Zend_Serializer::setDefaultAdapter($serializer);

   try {
       $serialized   = Zend_Serializer::serialize($data, $options);
       $unserialized = Zend_Serializer::unserialize($serialized, $options);
   } catch (Zend_Serializer_Exception $e) {
       echo $e;
   }


