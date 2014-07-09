.. _zend.cache.pattern:

Zend\\Cache\\Pattern
====================

.. _zend.cache.pattern.overview:

Overview
--------

Cache patterns are configurable objects to solve known performance bottlenecks. Each should be used only in the
specific situations they are designed to address. For example you can use one of the ``CallbackCache``,
``ObjectCache`` or ``ClassCache`` patterns to cache method and function calls; to cache output generation, the
``OutputCache`` pattern could assist.

All cache patterns implement the same interface, ``Zend\Cache\Pattern\PatternInterface``, and most extend the abstract
class ``Zend\Cache\Pattern\AbstractPattern`` to implement basic logic.

Configuration is provided via the ``Zend\Cache\Pattern\PatternOptions`` class, which can simply be instantiated
with an associative array of options passed to the constructor. To configure a pattern object, you can set an
instance of ``Zend\Cache\Pattern\PatternOptions`` with ``setOptions``, or provide your options (either as an
associative array or ``PatternOptions`` instance) as the second argument to the factory.

It's also possible to use a single instance of ``Zend\Cache\Pattern\PatternOptions`` and pass it to multiple
pattern objects.

.. _zend.cache.pattern.quick-start:

Quick Start
-----------

Pattern objects can either be created from the provided ``Zend\Cache\PatternFactory`` factory, or, by simply
instantiating one of the ``Zend\Cache\Pattern\*Cache`` classes.

.. code-block:: php
   :linenos:

   // Via the factory:
   $callbackCache = Zend\Cache\PatternFactory::factory('callback', array(
       'storage' => 'apc',
   ));

.. code-block:: php
   :linenos:

   // OR, the equivalent manual instantiation:
   $callbackCache = new Zend\Cache\Pattern\CallbackCache();
   $callbackCache->setOptions(new Zend\Cache\Pattern\PatternOptions(array(
       'storage' => 'apc',
   )));

Available Methods
-----------------

The following methods are implemented by ``Zend\Cache\Pattern\AbstractPattern``.
Please read documentation of specific patterns to get more information.

.. _zend.cache.pattern.methods.set-options:

.. function:: setOptions(Zend\\Cache\\Pattern\\PatternOptions $options)
   :noindex:

   Set pattern options.

   :rtype: Zend\\Cache\\Pattern\\PatternInterface

.. function:: getOptions()
   :noindex:

   Get all pattern options.

   :rtype: Zend\\Cache\\Pattern\\PatternOptions
