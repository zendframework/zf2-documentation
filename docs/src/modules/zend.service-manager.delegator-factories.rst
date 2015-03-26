.. _zend.service-manager.delegator-factories:

Delegator service factories
===========================

``Zend\ServiceManager`` can instantiate `delegators`_ of requested services, decorating them
as specified in a delegate factory implementing the `delegator factory interface`_.

The delegate pattern is useful in cases when you want to wrap a real service in a `decorator`_,
or generally intercept actions being performed on the delegate in an `AOP`_ fashioned way.

Delegator factory signature
^^^^^^^^^^^^^^^^^^^^^^^^^^^

A delegator factory has the following signature:

.. code-block:: php
   :linenos:

   namespace Zend\ServiceManager;

   interface DelegatorFactoryInterface
   {
       public function createDelegatorWithName(ServiceLocatorInterface $serviceLocator, $name, $requestedName, $callback);
   }

The parameters passed to the ``DelegatorFactoryInterface#createDelegatorWithName`` factory are the following:

 - ``$serviceLocator`` is the service locator that is used while creating the delegator for the requested service

 - ``$name`` is the canonical name of the service being requested

 - ``$requestedName`` is the name of the service as originally requested to the service locator

 - ``$callback`` is a `callable`_ that is responsible of instantiating the delegated service (the real service instance)

A Delegator factory use case
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A typical use case for `delegators`_ is to handle logic before or after a method is called.

In the following example, an event is being triggered before ``Buzzer::buzz()`` is called and some output text
is prepended.

The delegated object ``Buzzer`` (original object) is defined as following:

.. code-block:: php
   :linenos:

   class Buzzer
   {
       public function buzz()
       {
           return 'Buzz!';
       }
   }

The delegator class ``BuzzerDelegator`` has the following structure:

.. code-block:: php
   :linenos:

   use Zend\EventManager\EventManagerInterface;

   class BuzzerDelegator extends Buzzer
   {
       protected $realBuzzer;
       protected $eventManager;

       public function __construct(Buzzer $realBuzzer, EventManagerInterface $eventManager)
       {
           $this->realBuzzer   = $realBuzzer;
           $this->eventManager = $eventManager;
       }

       public function buzz()
       {
           $this->eventManager->trigger('buzz', $this);

           return $this->realBuzzer->buzz();
       }
   }

To use the ``BuzzerDelegator``, you can run the following code:

.. code-block:: php
   :linenos:

   $wrappedBuzzer = new Buzzer();
   $eventManager  = new Zend\EventManager\EventManager();

   $eventManager->attach('buzz', function () { echo "Stare at the art!\n"; });

   $buzzer = new BuzzerDelegator($wrappedBuzzer, $eventManager);

   echo $buzzer->buzz(); // "Stare at the art!\nBuzz!"

This logic is fairly simple as long as you have access to the instantiation logic of the
``$wrappedBuzzer`` object.

You may not always be able to define how ``$wrappedBuzzer`` is created, since a factory for it may be
defined by some code to which you don't have access, or which you cannot modify without introducing further
complexity.

Delegator factories solve this specific problem by allowing you to wrap, decorate or modify any existing service.

A simple delegator factory for the ``buzzer`` service can be implemented as following:

.. code-block:: php
   :linenos:

   use Zend\ServiceManager\DelegatorFactoryInterface;
   use Zend\ServiceManager\ServiceLocatorInterface;

   class BuzzerDelegatorFactory implements DelegatorFactoryInterface
   {
       public function createDelegatorWithName(ServiceLocatorInterface $serviceLocator, $name, $requestedName, $callback)
       {
           $realBuzzer   = call_user_func($callback);
           $eventManager = $serviceLocator->get('EventManager');

           $eventManager->attach('buzz', function () { echo "Stare at the art!\n"; });

           return new BuzzerDelegator($realBuzzer, $eventManager);
       }
   }

You can then instruct the service manager to handle the service ``buzzer`` as a delegate:

.. code-block:: php
   :linenos:

   $serviceManager = new Zend\ServiceManager\ServiceManager();

   $serviceManager->setInvokableClass('buzzer', 'Buzzer'); // usually not under our control

   // as opposed to normal factory classes, a delegator factory is a
   // service like any other, and must be registered:
   $serviceManager->setInvokableClass('buzzer-delegator-factory', 'BuzzerDelegatorFactory');

   // telling the service manager to use a delegator factory to handle service 'buzzer'
   $serviceManager->addDelegator('buzzer', 'buzzer-delegator-factory');

   // now, when fetching 'buzzer', we get a BuzzerDelegator instead
   $buzzer = $serviceManager->get('buzzer');

   $buzzer->buzz(); // "Stare at the art!\nBuzz!"

You can also call ``$serviceManager->addDelegator()`` multiple times, with the same or different delegator
factory service names. Each call will add one decorator around the instantiation logic of that particular
service.

Another way of configuring the service manager to use delegator factories is via configuration:

.. code-block:: php
   :linenos:

   $config = array(
       'invokables' => array(
           'buzzer'                   => 'Buzzer',
           'buzzer-delegator-factory' => 'BuzzerDelegatorFactory',
       ),
       'delegators' => array(
           'buzzer' => array(
                'buzzer-delegator-factory'
                // eventually add more delegators here
           ),
       ),
   );

.. _`AOP`: http://en.wikipedia.org/wiki/Aspect-oriented_programming
.. _`decorator`: http://en.wikipedia.org/wiki/Decorator_pattern
.. _`callable`: http://www.php.net/manual/en/language.types.callable.php
.. _`delegators`: http://en.wikipedia.org/wiki/Delegation_pattern
.. _`delegator factory interface`: https://github.com/zendframework/zf2/tree/master/library/Zend/ServiceManager/DelegatorFactoryInterface.php