.. _zend.module-manager.module-manager:

The Module Manager
==================

The module manager, ``Zend\ModuleManager\ModuleManager``, is a very simple class which is responsible for iterating
over an array of module names and triggering a sequence of events for each. Instantiation of module classes,
initialization tasks, and configuration are all performed by attached event listeners.

.. _zend.module-manager.module-manager.module-manager-events:

Module Manager Events
---------------------

.. rubric:: Events triggered by ``Zend\ModuleManager\ModuleManager``

**loadModules**
   This event is primarily used internally to help encapsulate the work of loading modules in event listeners, and
   allow the loadModules.post event to be more user-friendly. Internal listeners will attach to this event with a
   negative priority instead of loadModules.post so that users can safely assume things like config merging have
   been done once loadModules.post is triggered, without having to worry about priorities at all.

**loadModule.resolve**
   Triggered for each module that is to be loaded. The listener(s) to this event are responsible for taking a
   module name and resolving it to an instance of some class. The default module resolver shipped with ZF2 simply
   looks for the class ``{modulename}\Module``, instantiating and returning it if it exists.

   The name of the module may be retrieved by listeners using the ``getModuleName()`` method of the ``Event``
   object; a listener should then take that name and resolve it to an object instance representing the given
   module. Multiple listeners can be attached to this event, and the module manager will trigger them in order of
   their priority until one returns an object. This allows you to attach additional listeners which have
   alternative methods of resolving modules from a given module name.

**loadModule**
   Once a module resolver listener has resolved the module name to an object, the module manager then triggers this
   event, passing the newly created object to all listeners.

**loadModules.post**
   This event is triggered by the module manager to allow any listeners to perform work after every module has
   finished loading. For example, the default configuration listener,
   ``Zend\ModuleManager\Listener\ConfigListener`` (covered later), attaches to this event to merge additional
   user-supplied configuration which is meant to override the default supplied configurations of installed modules.

.. _zend.module-manager.module-manager.module-manager-listeners:

Module Manager Listeners
------------------------

By default, Zend Framework provides several useful module manager listeners.

.. rubric:: Provided Module Manager Listeners

**Zend\ModuleManager\Listener\DefaultListenerAggregate**
   To help simplify the most common use case of the module manager, ZF2 provides this default aggregate listener.
   In most cases, this will be the only listener you will need to attach to use the module manager, as it will take
   care of properly attaching the requisite listeners (those listed below) for the module system to function
   properly.

**Zend\ModuleManager\Listener\AutoloaderListener**
   This listener checks each module to see if it has implemented
   ``Zend\ModuleManager\Feature\AutoloaderProviderInterface`` or simply defined the ``getAutoloaderConfig()``
   method. If so, it calls the ``getAutoloaderConfig()`` method on the module class and passes the returned array
   to ``Zend\Loader\AutoloaderFactory``.

**Zend\ModuleManager\Listener\ConfigListener**
   If a module class has a ``getConfig()`` method, this listener will call it and merge the returned array (or
   ``Traversable`` object) into the main application configuration.

**Zend\ModuleManager\Listener\InitTrigger**
   If a module class either implements ``Zend\ModuleManager\Feature\InitProviderInterface``, or simply defines an
   ``init()`` method, this listener will call ``init()`` and pass the current instance of
   ``Zend\ModuleManager\ModuleManager`` as the sole parameter. The ``init()`` method is called for **every** module
   implementing this feature, on **every** page request and should **only** be used for performing **lightweight**
   tasks such as registering event listeners.

**Zend\ModuleManager\Listener\LocatorRegistrationListener**
   If a module class implements ``Zend\ModuleManager\Feature\LocatorRegisteredInterface``, this listener will
   inject the module class instance into the ``ServiceManager`` using the module class name as the service name.
   This allows you to later retrieve the module class from the ``ServiceManager``.

**Zend\ModuleManager\Listener\ModuleResolverListener**
   This is the default module resolver. It attaches to the "loadModule.resolve" event and simply returns an
   instance of ``{moduleName}\Module``.

**Zend\ModuleManager\Listener\OnBootstrapListener**
   If a module class implements ``Zend\ModuleManager\Feature\BootstrapListenerInterface``, or simply defines an
   ``onBootstrap()`` method, this listener will register the ``onBootstrap()`` method with the
   ``Zend\Mvc\Application`` ``bootstrap`` event. This method will then be triggered during the ``bootstrap`` event
   (and passed an ``MvcEvent`` instance).

   Like the ``InitTrigger``, the ``onBootstrap()`` method is called for **every** module implementing this feature,
   on **every** page request, and should **only** be used for performing **lightweight** tasks such as registering
   event listeners.

**Zend\ModuleManager\Listener\ServiceListener**
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


