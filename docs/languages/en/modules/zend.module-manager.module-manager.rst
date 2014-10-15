.. _zend.module-manager.module-manager:

The Module Manager
==================

The module manager, ``Zend\ModuleManager\ModuleManager``, is a very simple class which is responsible for iterating
over an array of module names and triggering a sequence of events for each. Instantiation of module classes,
initialization tasks, and configuration are all performed by attached event listeners.

.. _zend.module-manager.module-manager.module-manager-events:

Module Manager Events
---------------------

The Module Manager events are defined in ``Zend\ModuleManager\ModuleEvent``.

.. rubric:: Events triggered by ``Zend\ModuleManager\ModuleManager``

**loadModules (ModuleEvent::EVENT_LOAD_MODULES)**
   This event is primarily used internally to help encapsulate the work of loading modules in event listeners, and
   allow the loadModules.post event to be more user-friendly. Internal listeners will attach to this event with a
   negative priority instead of loadModules.post so that users can safely assume things like config merging have
   been done once loadModules.post is triggered, without having to worry about priorities at all.

**loadModule.resolve (ModuleEvent::EVENT_LOAD_MODULE_RESOLVE)**
   Triggered for each module that is to be loaded. The listener(s) to this event are responsible for taking a
   module name and resolving it to an instance of some class. The default module resolver shipped with ZF2 simply
   looks for the class ``{modulename}\Module``, instantiating and returning it if it exists.

   The name of the module may be retrieved by listeners using the ``getModuleName()`` method of the ``Event``
   object; a listener should then take that name and resolve it to an object instance representing the given
   module. Multiple listeners can be attached to this event, and the module manager will trigger them in order of
   their priority until one returns an object. This allows you to attach additional listeners which have
   alternative methods of resolving modules from a given module name.

**loadModule (ModuleEvent::EVENT_LOAD_MODULE)**
   Once a module resolver listener has resolved the module name to an object, the module manager then triggers this
   event, passing the newly created object to all listeners.

**mergeConfig (ModuleEvent::EVENT_MERGE_CONFIG)**
   After all modules have been loaded, the ``mergeConfig`` event is triggered.  By default,
   ``Zend\ModuleManager\Listener\ConfigLister`` listens on this event at priority 1000, and merges
   all configuration. You may attach additional listeners to this event in order to manipulate the
   merged configuration. See :ref:`the tutorial on manipulating merged configuration <tutorials.config.advanced.manipulating-merged-configuration>` for more information.

**loadModules.post (ModuleEvent::EVENT_LOAD_MODULES_POST)**
   This event is triggered by the module manager to allow any listeners to perform work after every module has
   finished loading. For example, the default configuration listener,
   ``Zend\ModuleManager\Listener\ConfigListener`` (covered later), attaches to this event to merge additional
   user-supplied configuration which is meant to override the default supplied configurations of installed modules.

.. _zend.module-manager.module-manager.module-manager-listeners:

Module Manager Listeners
------------------------

By default, Zend Framework provides several useful module manager listeners.

.. rubric:: Provided Module Manager Listeners

**Zend\\ModuleManager\\Listener\\DefaultListenerAggregate**
   To help simplify the most common use case of the module manager, ZF2 provides this default aggregate listener.
   In most cases, this will be the only listener you will need to attach to use the module manager, as it will take
   care of properly attaching the requisite listeners (those listed below) for the module system to function
   properly.

**Zend\\ModuleManager\\Listener\\AutoloaderListener**
   This listener checks each module to see if it has implemented
   ``Zend\ModuleManager\Feature\AutoloaderProviderInterface`` or simply defined the ``getAutoloaderConfig()``
   method. If so, it calls the ``getAutoloaderConfig()`` method on the module class and passes the returned array
   to ``Zend\Loader\AutoloaderFactory``.

**Zend\\ModuleManager\\Listener\\ModuleDependencyCheckerListener**
   This listener checks each module to verify if all the modules it depends on were loaded.
   When a module class implements ``Zend\ModuleManager\Feature\DependencyIndicatorInterface`` or simply
   has a defined ``getModuleDependencies()`` method, the listener will call ``getModuleDependencies()``. Each of
   the values returned by the method is checked against the loaded modules list: if one of the values is not in
   that list, a ``Zend\ModuleManager\Exception\MissingDependencyModuleException`` is be thrown.

**Zend\\ModuleManager\\Listener\\ConfigListener**
   If a module class has a ``getConfig()`` method, or implements ``Zend\ModuleManager\Feature\ConfigProviderInterface``,
   this listener will call it and merge the returned array (or ``Traversable`` object) into the main application configuration.

**Zend\\ModuleManager\\Listener\\InitTrigger**
   If a module class either implements ``Zend\ModuleManager\Feature\InitProviderInterface``, or simply defines an
   ``init()`` method, this listener will call ``init()`` and pass the current instance of
   ``Zend\ModuleManager\ModuleManager`` as the sole parameter.

   Like the ``OnBootstrapListener``, the ``init()`` method is called for **every** module implementing this feature,
   on **every** page request and should **only** be used for performing **lightweight** tasks such as registering
   event listeners.

**Zend\\ModuleManager\\Listener\\LocatorRegistrationListener**
   If a module class implements ``Zend\ModuleManager\Feature\LocatorRegisteredInterface``, this listener will
   inject the module class instance into the ``ServiceManager`` using the module class name as the service name.
   This allows you to later retrieve the module class from the ``ServiceManager``.

**Zend\\ModuleManager\\Listener\\ModuleResolverListener**
   This is the default module resolver. It attaches to the "loadModule.resolve" event and simply returns an
   instance of ``{moduleName}\Module``.

**Zend\\ModuleManager\\Listener\\OnBootstrapListener**
   If a module class implements ``Zend\ModuleManager\Feature\BootstrapListenerInterface``, or simply defines an
   ``onBootstrap()`` method, this listener will register the ``onBootstrap()`` method with the
   ``Zend\Mvc\Application`` ``bootstrap`` event. This method will then be triggered during the ``bootstrap`` event
   (and passed an ``MvcEvent`` instance).

   Like the ``InitTrigger``, the ``onBootstrap()`` method is called for **every** module implementing this feature,
   on **every** page request, and should **only** be used for performing **lightweight** tasks such as registering
   event listeners.

**Zend\\ModuleManager\\Listener\\ServiceListener**
   If a module class implements ``Zend\ModuleManager\Feature\ServiceProviderInterface``, or simply defines an
   ``getServiceConfig()`` method, this listener will call that method and aggregate the return values for
   use in configuring the ``ServiceManager``.

   The ``getServiceConfig()`` method may return either an array of configuration compatible with
   ``Zend\ServiceManager\Config``, an instance of that class, or the string name of a class that extends it.
   Values are merged and aggregated on completion, and then merged with any configuration from the
   ``ConfigListener`` falling under the ``service_manager`` key. For more information, see the ``ServiceManager``
   documentation.

   Unlike the other listeners, this listener is not managed by the ``DefaultListenerAggregate``; instead, it is
   created and instantiated within the ``Zend\Mvc\Service\ModuleManagerFactory``, where it is injected with the
   current ``ServiceManager`` instance before being registered with the ``ModuleManager`` events.

   Additionally, this listener manages a variety of plugin managers, including
   :ref:`view helpers <zend.view.helpers>`, :ref:`controllers
   <zend.mvc.controllers>`, and :ref:`controller plugins <zend.mvc.controller-plugins>`.
   In each case, you may either specify configuration to define plugins, or
   provide configuration via a ``Module`` class. Configuration follows the same
   format as for the ``ServiceManager``. The following table outlines the plugin
   managers that may be configured this way (including the ``ServiceManager``),
   the configuration key to use, the ``ModuleManager`` feature interface to
   optionally implement (all interfaces specified live in the
   ``Zend\ModuleManager\Feature`` namespace) , and the module method to
   optionally define to provide configuration.

   +------------------------------------------------+------------------------+---------------------------------------+-------------------------------+
   | Plugin Manager                                 | Config Key             | Interface                             | Module Method                 |
   +================================================+========================+=======================================+===============================+
   | ``Zend\Mvc\Controller\ControllerManager``      | ``controllers``        | ``ControllerProviderInterface``       | ``getControllerConfig``       |
   +------------------------------------------------+------------------------+---------------------------------------+-------------------------------+
   | ``Zend\Mvc\Controller\PluginManager``          | ``controller_plugins`` | ``ControllerPluginProviderInterface`` | ``getControllerPluginConfig`` |
   +------------------------------------------------+------------------------+---------------------------------------+-------------------------------+
   | ``Zend\Filter\FilterPluginManager``            | ``filters``            | ``FilterProviderInterface``           | ``getFilterConfig``           |
   +------------------------------------------------+------------------------+---------------------------------------+-------------------------------+
   | ``Zend\Form\FormElementManager``               | ``form_elements``      | ``FormElementProviderInterface``      | ``getFormElementConfig``      |
   +------------------------------------------------+------------------------+---------------------------------------+-------------------------------+
   | ``Zend\Stdlib\Hydrator\HydratorPluginManager`` | ``hydrators``          | ``HydratorProviderInterface``         | ``getHydratorConfig``         |
   +------------------------------------------------+------------------------+---------------------------------------+-------------------------------+
   | ``Zend\InputFilter\InputFilterPluginManager``  | ``input_filters``      | ``InputFilterProviderInterface``      | ``getInputFilterConfig``      |
   +------------------------------------------------+------------------------+---------------------------------------+-------------------------------+
   | ``Zend\Mvc\Router\RoutePluginManager``         | ``route_manager``      | ``RouteProviderInterface``            | ``getRouteConfig``            |
   +------------------------------------------------+------------------------+---------------------------------------+-------------------------------+
   | ``Zend\Serializer\AdapterPluginManager``       | ``serializers``        | ``SerializerProviderInterface``       | ``getSerializerConfig``       |
   +------------------------------------------------+------------------------+---------------------------------------+-------------------------------+
   | ``Zend\ServiceManager\ServiceManager``         | ``service_manager``    | ``ServiceProviderInterface``          | ``getServiceConfig``          |
   +------------------------------------------------+------------------------+---------------------------------------+-------------------------------+
   | ``Zend\Validator\ValidatorPluginManager``      | ``validators``         | ``ValidatorProviderInterface``        | ``getValidatorConfig``        |
   +------------------------------------------------+------------------------+---------------------------------------+-------------------------------+
   | ``Zend\View\HelperPluginManager``              | ``view_helpers``       | ``ViewHelperProviderInterface``       | ``getViewHelperConfig``       |
   +------------------------------------------------+------------------------+---------------------------------------+-------------------------------+
   | ``Zend\Log\ProcessorPluginManager``            | ``log_processors``     | ``LogProcessorProviderInterface``     | ``getLogProcessorConfig``     |
   +------------------------------------------------+------------------------+---------------------------------------+-------------------------------+
   | ``Zend\Log\WriterPluginManager``               | ``log_writers``        | ``LogWriterProviderInterface``        | ``getLogWriterConfig``        |
   +------------------------------------------------+------------------------+---------------------------------------+-------------------------------+

   Configuration follows the examples in the :ref:`ServiceManager configuration
   section <zend.service-manager.quick-start.config>`. As a brief recap, the
   following configuration keys and values are allowed:

   +------------------------+------------------------------------------------------------+
   | Config Key             | Allowed values                                             |
   +========================+============================================================+
   | ``services``           | service name/instance pairs (these should likely be        |
   |                        | defined only in ``Module`` classes)                        |
   +------------------------+------------------------------------------------------------+
   | ``invokables``         | service name/class name pairs of classes that may be       |
   |                        | invoked without constructor arguments                      |
   +------------------------+------------------------------------------------------------+
   | ``factories``          | service names pointing to factories. Factories may be any  |
   |                        | PHP callable, or a string class name of a class            |
   |                        | implementing ``Zend\ServiceManager\FactoryInterface``, or  |
   |                        | of a class implementing the ``__invoke`` method  (if a     |
   |                        | callable is used, it should be defined only in ``Module``  |
   |                        | classes)                                                   |
   +------------------------+------------------------------------------------------------+
   | ``abstract_factories`` | array of either concrete instances of                      |
   |                        | ``Zend\ServiceManager\AbstractFactoryInterface``, or       |
   |                        | string class names of classes implementing that interface  |
   |                        | (if an instance is used, it should be defined only in      |
   |                        | ``Module`` classes)                                        |
   +------------------------+------------------------------------------------------------+
   | ``initializers``       | array of PHP callables or string class names of classes    |
   |                        | implementing ``Zend\ServiceManager\InitializerInterface``  |
   |                        | (if a callable is used, it should be defined only in       |
   |                        | ``Module`` classes)                                        |
   +------------------------+------------------------------------------------------------+

   When working with plugin managers, you will be passed the plugin manager
   instance to factories, abstract factories, and initializers. If you need
   access to the application services, you can use the ``getServiceLocator()``
   method, as in the following example:

   .. code-block:: php
       :linenos:

       public function getViewHelperConfig()
       {
           return array('factories' => array(
               'foo' => function ($helpers) {
                   $services    = $helpers->getServiceLocator();
                   $someService = $services->get('SomeService');
                   $helper      = new Helper\Foo($someService);

                   return $helper;
               },
           ));
       }

   This is a powerful technique, as it allows your various plugins to remain
   agnostic with regards to where and how dependencies are injected, and thus
   allows you to use Inversion of Control principals even with plugins.

