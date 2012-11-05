.. _zend.serializer.introduction:

Introduction
============

``Zend\Serializer`` provides an adapter based interface to simply generate storable representation of *PHP* types
by different facilities, and recover.

.. _zend.serializer.introduction.example.dynamic:

.. rubric:: Using Zend\Serializer dynamic interface

To instantiate a serializer you should use the factory method with the name of the adapter:

.. code-block:: php
   :linenos:

   $serializer = Zend\Serializer\Serializer::factory('PhpSerialize');
   // Now $serializer is an instance of Zend\Serializer\Adapter\AdapterInterface,
   // specifically Zend\Serializer\Adapter\PhpSerialize

   try {
       $serialized = $serializer->serialize($data);
       // now $serialized is a string

       $unserialized = $serializer->unserialize($serialized);
       // now $data == $unserialized
   } catch (Zend\Serializer\Exception $e) {
       echo $e;
   }

The method ``serialize()`` generates a storable string. To regenerate this serialized data you can simply call the
method ``unserialize()``.

Any time an error is encountered serializing or unserializing, ``Zend\Serializer`` will throw a
``Zend\Serializer\Exception``.

To configure a given serializer adapter, you can optionally add an array or an instance of ``Zend\Config`` to the
``factory()`` or to the ``serialize()`` and ``unserialize()`` methods:

.. code-block:: php
   :linenos:

   $serializer = Zend\Serializer\Serializer::factory('Wddx', array(
       'comment' => 'serialized by Zend\Serializer',
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
   } catch (Zend\Serializer\Exception $e) {
       echo $e;
   }

Options passed to the ``factory()`` are valid for the instantiated object. You can change these options using the
``setOption(s)`` method. To change one or more options only for a single call, pass them as the second argument to
either the ``serialize()`` or ``unserialize()`` method.

.. _zend.serializer.introduction.example.static.php:

.. rubric:: Using the Zend\Serializer static interface

You can register a specific serializer adapter as a default serialization adapter for use with ``Zend\Serializer``.
By default, the ``PhpSerialize`` adapter will be registered, but you can change this option using the
``setDefaultAdapter()`` static method.

.. code-block:: php
   :linenos:

   Zend\Serializer\Serializer::setDefaultAdapter('PhpSerialize', $options);
   // or
   $serializer = Zend\Serializer\Serializer::factory('PhpSerialize', $options);
   Zend\Serializer\Serializer::setDefaultAdapter($serializer);

   try {
       $serialized   = Zend\Serializer\Serializer::serialize($data, $options);
       $unserialized = Zend\Serializer\Serializer::unserialize($serialized, $options);
   } catch (Zend\Serializer\Exception $e) {
       echo $e;
   }


