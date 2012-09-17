.. _zend.service-manager.intro:

Zend\\ServiceManager
====================

The `Service Locator design pattern`_ is implemented by the ``ServiceManager``.  The Service Locator is a 
service/object locator, tasked with retrieving other objects. You may interact with the ``ServiceManger`` 
via the following methods

.. code-block:: php

  // /library/Zend/ServiceManager/ServiceLocatorInterface.php
	namespace Zend\ServiceManager;

	interface ServiceLocatorInterface
	{
		public function get($name);
		public function has($name);
	}
	
- ``has($name)``, tests whether the ``ServiceManager`` has a named service;

- ``get($name)``, retrieves a service by the given name.

In addition to above methods, the ``ServiceManger`` can be instantiated via the following features:

- **Service registration**. You can register an object under a given name (*$services->setService('foo',
  $object)*).

- **Lazy-loaded service objects**. You can tell the manager what class to instantiate on first request
  (*$services->setInvokableClass('foo', 'Fully\Qualified\Classname')*).

- **Service factories**. Instead of an actual object instance or a class name, you can tell the manager to invoke
  the provided factory in order to get the object instance. Factories may be either any PHP callable, an object
  implementing ``Zend\ServiceManager\FactoryInterface``, or the name of a class implementing that interface.

- **Service aliasing**. You can tell the manager that when a particular name is requested, use the provided name
  instead. You can alias to a known service, a lazy-loaded service, a factory, or even other aliases.

- **Abstract factories**. An abstract factory can be considered a "fallback" -- if the service does not exist in
  the manager, it will then pass it to any abstract factories attached to it until one of them is able to return an
  object.

- **Initializers**. You may want certain injection points always populated -- as an example, any object you load
  via the service manager that implements ``Zend\EventManager\EventManagerAware`` should likely receive an
  ``EventManager`` instance. **Initializers** are PHP callbacks or classes implementing
  ``Zend\ServiceManager\InitializerInterface``; they receive the new instance, and can then manipulate it.

In addition to the above, the ``ServiceManager`` also provides optional ties to ``Zend\Di``, allowing ``Di`` to act
as an initializer or an abstract factory for the manager.


.. _`Service Locator design pattern`: http://en.wikipedia.org/wiki/Service_locator_pattern