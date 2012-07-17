
.. _zend.config.theory_of_operation:

Theory of Operation
===================

Configuration data are made accessible to the ``Zend\Config\Config`` constructor through an associative array, which may be multi-dimensional, in order to support organizing the data from general to specific. Concrete adapter classes adapt configuration data from storage to produce the associative array for the ``Zend\Config\Config`` constructor. User scripts may provide such arrays directly to the ``Zend\Config\Config`` constructor, without using a reader class, since it may be appropriate to do so in certain situations.

Each configuration data array value becomes a property of the ``Zend\Config\Config`` object. The key is used as the property name. If a value is itself an array, then the resulting object property is created as a new ``Zend\Config\Config`` object, loaded with the array data. This occurs recursively, such that a hierarchy of configuration data may be created with any number of levels.

``Zend\Config\Config`` implements the **Countable** and **Iterator** interfaces in order to facilitate simple access to configuration data. Thus, one may use the `count()`_ function and *PHP* constructs such as `foreach`_ with ``Zend\Config\Config`` objects.

By default, configuration data made available through ``Zend\Config\Config`` are read-only, and an assignment (e.g., ``$config->database->host = 'example.com';``) results in a thrown exception. This default behavior may be overridden through the constructor, however, to allow modification of data values. Also, when modifications are allowed, ``Zend\Config\Config`` supports unsetting of values (i.e. ``unset($config->database->host)``). The ``isReadOnly()`` method can be used to determine if modifications to a given ``Zend\Config\Config`` object are allowed and the ``setReadOnly()`` method can be used to stop any further modifications to a ``Zend\Config\Config`` object that was created allowing modifications.

.. note::
   **Modifying Config does not save changes**

   It is important not to confuse such in-memory modifications with saving configuration data out to specific storage media. Tools for creating and modifying configuration data for various storage media are out of scope with respect to ``Zend\Config\Config``. Third-party open source solutions are readily available for the purpose of creating and modifying configuration data for various storage media.


If you have two ``Zend\Config\Config`` objects, you can merge them into a single object using the ``merge()`` function. For example, given ``$config`` and ``$localConfig``, you can merge data from ``$localConfig`` to ``$config`` using ``$config->merge($localConfig);``. The items in ``$localConfig`` will override any items with the same name in ``$config``.

.. note::
   The ``Zend\Config\Config`` object that is performing the merge must have been constructed to allow modifications, by passing ``TRUE`` as the second parameter of the constructor. The ``setReadOnly()`` method can then be used to prevent any further modifications after the merge is complete.




.. _`count()`: http://php.net/count
.. _`foreach`: http://php.net/foreach
