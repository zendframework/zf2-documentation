.. _zend.service-manager.intro:

Zend\\ServiceManager
====================

The `Service Locator design pattern`_ is implemented by the ``Zend\ServiceManager`` component.
The Service Locator is a  service/object locator, tasked with retrieving other objects.
Following is the ``Zend\ServiceManager\ServiceLocatorInterface`` API:

.. code-block:: php
   :linenos:

   namespace Zend\ServiceManager;

   interface ServiceLocatorInterface
   {
       public function get($name);
       public function has($name);
   }
	
- ``has($name)``, tests whether the ``ServiceManager`` has a named service;

- ``get($name)``, retrieves a service by the given name.

A ``Zend\ServiceManager\ServiceManager`` is an implementation of the ``ServiceLocatorInterface``.
In addition to the above described methods, the ``ServiceManager`` provides additional API:

- **Service registration**. ``ServiceManager::setService`` allows you to register an object as a service:

  .. code-block:: php
     :linenos:

     $serviceManager->setService('my-foo', new stdClass());
     $serviceManager->setService('my-settings', array('password' => 'super-secret'));

     var_dump($serviceManager->get('my-foo')); // an instance of stdClass
     var_dump($serviceManager->get('my-settings')); // array('password' => 'super-secret')

- **Lazy-loaded service objects**. ``ServiceManager::setInvokableClass`` allows you to tell the
  ``ServiceManager`` what class to instantiate when a particular service is requested:

  .. code-block:: php
     :linenos:

     $serviceManager->setInvokableClass('foo-service-name', 'Fully\Qualified\Classname');

     var_dump($serviceManager->get('foo-service-name')); // an instance of Fully\Qualified\Classname

- **Service factories**. Instead of an actual object instance or a class name, you can tell the
  ``ServiceManager`` to invoke a provided factory in order to get the object instance. Factories
  may be either a PHP `callback`_, an object implementing ``Zend\ServiceManager\FactoryInterface``,
  or the name of a class implementing that interface:

  .. code-block:: php
     :linenos:

     use Zend\ServiceManager\FactoryInterface;
     use Zend\ServiceManager\ServiceLocatorInterface;

     class MyFactory implements FactoryInterface
     {
         public function createService(ServiceLocatorInterface $serviceLocator)
         {
             return new \stdClass();
         }
     }

     // registering a factory instance
     $serviceManager->setFactory('foo-service-name', new MyFactory());

     // registering a factory by factory class name
     $serviceManager->setFactory('bar-service-name', 'MyFactory');

     // registering a callback as a factory
     $serviceManager->setFactory('baz-service-name', function () { return new \stdClass(); });

     var_dump($serviceManager->get('foo-service-name')); // stdClass(1)
     var_dump($serviceManager->get('bar-service-name')); // stdClass(2)
     var_dump($serviceManager->get('baz-service-name')); // stdClass(3)

- **Service aliasing**. With ``ServiceManager::setAlias`` you can create aliases of any registered
  service, factory or invokable, or even other aliases:

  .. code-block:: php
     :linenos:

     $foo      = new \stdClass();
     $foo->bar = 'baz!';

     $serviceManager->setService('my-foo', $foo);
     $serviceManager->setAlias('my-bar', 'my-foo');
     $serviceManager->setAlias('my-baz', 'my-bar');

     var_dump($serviceManager->get('my-foo')->bar); // baz!
     var_dump($serviceManager->get('my-bar')->bar); // baz!
     var_dump($serviceManager->get('my-baz')->bar); // baz!

- **Abstract factories**. An abstract factory can be considered as a "fallback" factory. If the
  service manager was not able to find a service for the requested name, it will check the registered
  abstract factories:

  .. code-block:: php
     :linenos:

     use Zend\ServiceManager\ServiceLocatorInterface;
     use Zend\ServiceManager\AbstractFactoryInterface;

     class MyAbstractFactory implements AbstractFactoryInterface
     {
         public function canCreateServiceWithName(ServiceLocatorInterface $serviceLocator, $name, $requestedName)
         {
             // this abstract factory only knows about 'foo' and 'bar'
             return $requestedName === 'foo' || $requestedName === 'bar';
         }

         public function createServiceWithName(ServiceLocatorInterface $serviceLocator, $name, $requestedName)
         {
             $service = new \stdClass();

             $service->name = $requestedName;

             return $service;
         }
     }

     $serviceManager->addAbstractFactory('MyAbstractFactory');

     var_dump($serviceManager->get('foo')->name); // foo
     var_dump($serviceManager->get('bar')->name); // bar
     var_dump($serviceManager->get('baz')->name); // exception! Zend\ServiceManager\Exception\ServiceNotFoundException

- **Initializers**. You may want certain injection points to be always called. As an example,
  any object you load via the service manager that implements
  ``Zend\EventManager\EventManagerAwareInterface`` should likely receive an ``EventManager``
  instance. **Initializers** are PHP `callbacks`_ or classes implementing
  ``Zend\ServiceManager\InitializerInterface``. They receive the new instance, and can then manipulate it:

  .. code-block:: php
     :linenos:

     use Zend\ServiceManager\ServiceLocatorInterface;
     use Zend\ServiceManager\InitializerInterface;

     class MyInitializer implements InitializerInterface
     {
         public function initialize($instance, ServiceLocatorInterface $serviceLocator)
         {
             if ($instance instanceof \stdClass) {
                 $instance->initialized = 'initialized!';
             }
         }
     }

     $serviceManager->setInvokableClass('my-service', 'stdClass');

     var_dump($serviceManager->get('my-service')->initialized); // initialized!

In addition to the above, the ``ServiceManager`` also provides optional ties to ``Zend\Di``, allowing ``Di`` to act
as an initializer or an abstract factory for the service manager.


.. _`Service Locator design pattern`: http://en.wikipedia.org/wiki/Service_locator_pattern
.. _`callback`: http://www.php.net/manual/de/language.pseudo-types.php#language.types.callback
.. _`callbacks`: http://www.php.net/manual/de/language.pseudo-types.php#language.types.callback
