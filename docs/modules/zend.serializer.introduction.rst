
Introduction
============

``Zend_Serializer`` provides an adapter based interface to simply generate storable representation of *PHP* types by different facilities, and recover.

The method ``serialize()`` generates a storable string. To regenerate this serialized data you can simply call the method ``unserialize()`` .

Any time an error is encountered serializing or unserializing, ``Zend_Serializer`` will throw a ``Zend_Serializer_Exception`` .

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


