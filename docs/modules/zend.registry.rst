
Using the Registry
==================

A registry is a container for storing objects and values in the application space. By storing the value in a registry, the same object is always available throughout your application. This mechanism is an alternative to using global storage.

The typical method to use registries with Zend Framework is through static methods in the ``Zend_Registry`` class. Alternatively, the registry can be used as an array object, so you can access elements stored within it with a convenient array-like interface.

.. _zend.registry.using.storing:

Setting Values in the Registry
------------------------------

Use the static method ``set()`` to store an entry in the registry.

.. _zend.registry.using.storing.example:

Example of set() Method Usage
-----------------------------

.. code-block:: php
    :linenos:
    
    Zend_Registry::set('index', $value);
    

The value returned can be an object, an array, or a scalar. You can change the value stored in a specific entry of the registry by calling the ``set()`` method to set the entry to a new value.

The index can be a scalar ( ``NULL`` , string, or number), like an ordinary array.

.. _zend.registry.using.retrieving:

Getting Values from the Registry
--------------------------------

To retrieve an entry from the registry, use the static ``get()`` method.

.. _zend.registry.using.retrieving.example:

Example of get() Method Usage
-----------------------------

.. code-block:: php
    :linenos:
    
    $value = Zend_Registry::get('index');
    

The ``getInstance()`` method returns the singleton registry object. This registry object is iterable, making all values stored in the registry easily accessible.

.. _zend.registry.using.retrieving.example-iterating:

Example of Iterating over the Registry
--------------------------------------

.. code-block:: php
    :linenos:
    
    $registry = Zend_Registry::getInstance();
    
    foreach ($registry as $index => $value) {
        echo "Registry index $index contains:\n";
        var_dump($value);
    }
    

.. _zend.registry.using.constructing:

Constructing a Registry Object
------------------------------

In addition to accessing the static registry via static methods, you can create an instance directly and use it as an object.

The registry instance you access through the static methods is simply one such instance. It is for convenience that it is stored statically, so that it is accessible from anywhere in an application.

Use the traditionalnewoperator to instantiate ``Zend_Registry`` . Instantiating ``Zend_Registry`` using its constructor also makes initializing the entries in the registry simple by taking an associative array as an argument.

.. _zend.registry.using.constructing.example:

Example of Constructing a Registry
----------------------------------

.. code-block:: php
    :linenos:
    
    $registry = new Zend_Registry(array('index' => $value));
    

Once such a ``Zend_Registry`` object is instantiated, you can use it by calling any array object method or by setting it as the singleton instance for ``Zend_Registry`` with the static method ``setInstance()`` .

.. _zend.registry.using.constructing.example-setinstance:

Example of Initializing the Singleton Registry
----------------------------------------------

.. code-block:: php
    :linenos:
    
    $registry = new Zend_Registry(array('index' => $value));
    
    Zend_Registry::setInstance($registry);
    

The ``setInstance()`` method throws a ``Zend_Exception`` if the static registry has already been initialized.

.. _zend.registry.using.array-access:

Accessing the Registry as an Array
----------------------------------

If you have several values to get or set, you may find it convenient to access the registry with array notation.

.. _zend.registry.using.array-access.example:

Example of Array Access
-----------------------

.. code-block:: php
    :linenos:
    
    $registry = Zend_Registry::getInstance();
    
    $registry['index'] = $value;
    
    var_dump( $registry['index'] );
    

.. _zend.registry.using.array-object:

Accessing the Registry as an Object
-----------------------------------

You may also find it convenient to access the registry in an object-oriented fashion by using index names as object properties. You must specifically construct the registry object using the ``ArrayObject::ARRAY_AS_PROPS`` option and initialize the static instance to enable this functionality.
.. note::
    ****

    You must set the ``ArrayObject::ARRAY_AS_PROPS`` optionbeforethe static registry has been accessed for the first time.


Known Issues with the ArrayObject::ARRAY_AS_PROPS Option
--------------------------------------------------------

Some versions of *PHP* have proven very buggy when using the registry with the ``ArrayObject::ARRAY_AS_PROPS`` option.

.. _zend.registry.using.array-object.example:

Example of Object Access
------------------------

.. code-block:: php
    :linenos:
    
    // in your application bootstrap:
    $registry = new Zend_Registry(array(), ArrayObject::ARRAY_AS_PROPS)
    Zend_Registry::setInstance($registry);
    $registry->tree = 'apple';
    
    .
    .
    .
    
    // in a different function, elsewhere in your application:
    $registry = Zend_Registry::getInstance();
    
    echo $registry->tree; // echo's "apple"
    
    $registry->index = $value;
    
    var_dump($registry->index);
    

.. _zend.registry.using.isset:

Querying if an Index Exists
---------------------------

To find out if a particular index in the registry has been set, use the static method ``isRegistered()`` .

.. _zend.registry.using.isset.example-isregistered:

Example of isRegistered() Method Usage
--------------------------------------

.. code-block:: php
    :linenos:
    
    if (Zend_Registry::isRegistered($index)) {
        $value = Zend_Registry::get($index);
    }
    

To find out if a particular index in a registry array or object has a value, use the ``isset()`` function as you would with an ordinary array.

.. _zend.registry.using.isset.example-isset:

Example of isset() Method Usage
-------------------------------

.. code-block:: php
    :linenos:
    
    $registry = Zend_Registry::getInstance();
    
    // using array access syntax
    if (isset($registry['index'])) {
        var_dump( $registry['index'] );
    }
    
    // using object access syntax
    if (isset($registry->index)) {
        var_dump( $registry->index );
    }
    

.. _zend.registry.using.subclassing:

Extending the Registry
----------------------

The static registry is an instance of the class ``Zend_Registry`` . If you want to add functionality to the registry, you should create a class that extends ``Zend_Registry`` and specify this class to instantiate for the singleton in the static registry. Use the static method ``setClassName()`` to specify the class.
.. note::
    ****

    The class must be a subclass of ``Zend_Registry`` .


.. _zend.registry.using.subclassing.example:

Example of Specifying the Singleton Registry's Class Name
---------------------------------------------------------

.. code-block:: php
    :linenos:
    
    Zend_Registry::setClassName('My_Registry');
    
    Zend_Registry::set('index', $value);
    

The registry throws a ``Zend_Exception`` if you attempt to set the classname after the registry has been accessed for the first time. It is therefore recommended that you specify the class name for your static registry in your application bootstrap.

.. _zend.registry.using.unsetting:

Unsetting the Static Registry
-----------------------------

Although it is not normally necessary, you can unset the singleton instance of the registry, if desired. Use the static method ``_unsetInstance()`` to do so.

Data Loss Risk
--------------

When you use ``_unsetInstance()`` , all data in the static registry are discarded and cannot be recovered.

You might use this method, for example, if you want to use ``setInstance()`` or ``setClassName()`` after the singleton registry object has been initialized. Unsetting the singleton instance allows you to use these methods even after the singleton registry object has been set. Using ``Zend_Registry`` in this manner is not recommended for typical applications and environments.

.. _zend.registry.using.unsetting.example:

Example of _unsetInstance() Method Usage
----------------------------------------

.. code-block:: php
    :linenos:
    
    Zend_Registry::set('index', $value);
    
    Zend_Registry::_unsetInstance();
    
    // change the class
    Zend_Registry::setClassName('My_Registry');
    
    Zend_Registry::set('index', $value);
    


