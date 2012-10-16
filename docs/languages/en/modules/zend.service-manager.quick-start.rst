.. _zend.service-manager.quick-start:

Zend\\ServiceManager Quick Start
================================

By default, Zend Framework utilizes ``Zend\ServiceManager`` within the MVC layer. As such, in most cases you'll be
providing services, invokable classes, aliases, and factories either via configuration or via your module classes.

By default, the module manager listener ``Zend\ModuleManager\Listener\ServiceListener`` will do the following:

- For modules implementing the ``Zend\ModuleManager\Feature\ServiceProvider`` interface, or the
  ``getServiceConfig()`` method, it will call that method and merge the configuration.

- After all modules have been processed, it will grab the configuration from the registered
  ``Zend\ModuleManager\Feature\ConfigListener``, and merge any configuration under the ``service_manager`` key.

- Finally, it will use the merged configuration to configure the ``ServiceManager``.

In most cases, you won't interact with the ``ServiceManager``, other than to provide services to it; your
application will typically rely on good configuration in the ``ServiceManager`` to ensure that classes are
configured correctly with their dependencies. When creating factories, however, you may want to interact with the
``ServiceManager`` to retrieve other services to inject as dependencies. Additionally, there are some cases where
you may want to receive the ``ServiceManager`` to lazy-retrieve dependencies; as such, you'll want to implement
``ServiceLocatorAwareInterface``, and learn the API of the ``ServiceManager``.

.. _zend.service-manager.quick-start.config:

Using Configuration
-------------------

Configuration requires a ``service_manager`` key at the top level of your configuration, with one or more of the
following sub-keys:

- **abstract_factories**, which should be an array of abstract factory class names.

- **aliases**, which should be an associative array of alias name/target name pairs (where the target name may also
  be an alias).

- **factories**, an array of service name/factory class name pairs. The factories should be either classes
  implementing ``Zend\ServiceManager\FactoryInterface`` or invokable classes. If you are using PHP configuration
  files, you may provide any PHP callable as the factory.

- **invokables**, an array of service name/class name pairs. The class name should be class that may be directly
  instantiated without any constructor arguments.

- **services**, an array of service name/object pairs. Clearly, this will only work with PHP configuration.

- **shared**, an array of service name/boolean pairs, indicating whether or not a service should be shared. By
  default, the ``ServiceManager`` assumes all services are shared, but you may specify a boolean false value here
  to indicate a new instance should be returned.

.. _zend.service-manager.quick-start.module:

Modules as Service Providers
----------------------------

Modules may act as service configuration providers. To do so, the Module class must either implement
``Zend\ModuleManager\Feature\ServiceProviderInterface`` or simply the method ``getServiceConfig()`` (which
is also defined in the interface). This method must return one of the following:

- An array (or ``Traversable`` object) of configuration compatible with ``Zend\ServiceManager\Config``.
  (Basically, it should have the keys for configuration as discussed in :ref:`the previous section
  <zend.service-manager.quick-start.config>`.

- A string providing the name of a class implementing ``Zend\ServiceManager\ConfigInterface``.

- An instance of either ``Zend\ServiceManager\Config``, or an object implementing
  ``Zend\ServiceManager\ConfigInterface``.

As noted previously, this configuration will be merged with the configuration returned from other modules as well
as configuration files, prior to being passed to the ``ServiceManager``; this allows overriding configuration from
modules easily.

.. _zend.service-manager.quick-start.examples:

Examples
--------

.. _zend.service-manager.quick-start.examples.config-array:

Sample Configuration
^^^^^^^^^^^^^^^^^^^^

The following is valid configuration for any configuration being merged in your application, and demonstrates each
of the possible configuration keys. Configuration is merged in the following order:

- Configuration returned from Module classes via the ``getServiceConfig()`` method, in the order in which
  modules are processed.

- Module configuration under the ``service_manager`` key, in the order in which modules are processed.

- Application configuration under the ``config/autoload/`` directory, in the order in which they are processed.

As such, you have a variety of ways to override service manager configuration settings.

.. code-block:: php
   :linenos:

   <?php
   // a module configuration, "module/SomeModule/config/module.config.php"
   return array(
       'service_manager' => array(
           'abstract_factories' => array(
               // Valid values include names of classes implementing
               // AbstractFactoryInterface, instances of classes implementing
               // AbstractFactoryInterface, or any PHP callbacks
               'SomeModule\Service\FallbackFactory',
           ),
           'aliases' => array(
               // Aliasing a FQCN to a service name
               'SomeModule\Model\User' => 'User',
               // Aliasing a name to a known service name
               'AdminUser' => 'User',
               // Aliasing to an alias
               'SuperUser' => 'AdminUser',
           ),
           'factories' => array(
               // Keys are the service names.
               // Valid values include names of classes implementing
               // FactoryInterface, instances of classes implementing
               // FactoryInterface, or any PHP callbacks
               'User'     => 'SomeModule\Service\UserFactory',
               'UserForm' => function ($serviceManager) {
                   $form = new SomeModule\Form\User();

                   // Retrieve a dependency from the service manager and inject it!
                   $form->setInputFilter($serviceManager->get('UserInputFilter'));
                   return $form;
               },
           ),
           'invokables' => array(
               // Keys are the service names
               // Values are valid class names to instantiate.
               'UserInputFiler' => 'SomeModule\InputFilter\User',
           ),
           'services' => array(
               // Keys are the service names
               // Values are objects
               'Auth' => new SomeModule\Authentication\AuthenticationService(),
           ),
           'shared' => array(
               // Usually, you'll only indicate services that should _NOT_ be
               // shared -- i.e., ones where you want a different instance
               // every time.
               'UserForm' => false,
           ),
       ),
   );

.. note::

   **Configuration and PHP**

   Typically, you should not have your configuration files create new instances of objects or even closures for
   factories; at the time of configuration, not all autoloading may be in place, and if another configuration
   overwrites this one later, you're now spending CPU and memory performing work that is ultimately lost.

   For instances that require factories, write a factory. If you'd like to inject specific, configured instances,
   use the Module class to do so, or a listener.

.. _zend.service-manager.quick-start.examples.return-array:

Module Returning an Array
^^^^^^^^^^^^^^^^^^^^^^^^^

The following demonstrates returning an array of configuration from a module class. It can substantively the same as
the array configuration from the previous example.

.. code-block:: php
   :linenos:

   namespace SomeModule;

   class Module
   {
       public function getServiceConfig()
       {
           return array(
               'abstract_factories' => array(),
               'aliases' => array(),
               'factories' => array(),
               'invokables' => array(),
               'services' => array(),
               'shared' => array(),
           );
       }
   }

.. _zend.service-manager.quick-start.examples.return-config-instance:

.. rubric:: Returning a Configuration instance

First, let's create a class that holds configuration.

.. code-block:: php
   :linenos:

   namespace SomeModule\Service;

   use SomeModule\Authentication;
   use SomeModule\Form;
   use Zend\ServiceManager\Config;
   use Zend\ServiceManager\ServiceManager;

   class ServiceConfiguration extends Config
   {
       /**
        * This is hard-coded for brevity.
        */
       public function configureServiceManager(ServiceManager $serviceManager)
       {
           $serviceManager->setFactory('User', 'SomeModule\Service\UserFactory');
           $serviceManager->setFactory('UserForm', function ($serviceManager) {
               $form = new Form\User();

               // Retrieve a dependency from the service manager and inject it!
               $form->setInputFilter($serviceManager->get('UserInputFilter'),
               return $form;
           });
           $serviceManager->setInvokableClass('UserInputFilter', 'SomeModule\InputFilter\User');
           $serviceManager->setService('Auth', new Authentication\AuthenticationService());
           $serviceManager->setAlias('SomeModule\Model\User', 'User');
           $serviceManager->setAlias('AdminUser', 'User');
           $serviceManager->setAlias('SuperUser', 'AdminUser');
           $serviceManager->setShared('UserForm', false);
       }
   }

Now, we'll consume it from our Module.

.. code-block:: php
   :linenos:

   namespace SomeModule;

   // We could implement Zend\ModuleManager\Feature\ServiceProviderInterface.
   // However, the module manager will still find the method without doing so.
   class Module
   {
       public function getServiceConfig()
       {
           return new Service\ServiceConfiguration();
           // OR:
           // return 'SomeModule\Service\ServiceConfiguration';
       }
   }

.. _zend.service-manager.quick-start.examples.service-manager-aware:

.. rubric:: Creating a ServiceLocator-aware class

By default, the Zend Framework MVC registers an initializer that will inject the ``ServiceManager`` instance, which is an implementation of ``Zend\ServiceManager\ServiceLocatorInterface``, into
any class implementing ``Zend\ServiceManager\ServiceLocatorAwareInterface``. A simple implementation looks like the following.

.. code-block:: php
   :linenos:

   namespace SomeModule\Controller\BareController;

   use Zend\ServiceManager\ServiceLocatorAwareInterface;
   use Zend\ServiceManager\ServiceLocatorInterface;
   use Zend\Stdlib\DispatchableInterface as Dispatchable;
   use Zend\Stdlib\RequestInterface as Request;
   use Zend\Stdlib\ResponseInterface as Response;

   class BareController implements
       Dispatchable,
       ServiceLocatorAwareInterface
   {
       protected $services;

       public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
       {
           $this->services = $serviceLocator;
       }

       public function dispatch(Request $request, Response $response = null)
       {
           // ...

           // Retrieve something from the service manager
           $router = $this->services->get('Router');

           // ...
       }
   }


