
.. _zend.module-manager.module-class:

The Module Class
================

By default, ZF2 module system simply expects each module name to be able to be resolved to an object instance. The default module resolver, ``Zend\ModuleManager\Listener\ModuleResolverListener``, simply instantiates an instance of ``{moduleName}\Module`` for each enabled module.


.. _zend.module-manager.module-class.example.minimal-module:

.. rubric:: A Minimal Module

As an example, provided the module name "MyModule", ``Zend\ModuleManager\Listener\ModuleResolverListener`` will simply expect the class ``MyModule\Module`` to be available. It relies on a registered autoloader, (typically ``Zend\Loader\ModuleAutoloader``) to find and include the ``MyModule\Module`` class if it is not already available.

A module named "MyModule" module might start out looking something like this:



::

   MyModule/
       Module.php


Within ``Module.php``, you define your ``MyModule\Module`` class:

.. code-block:: php
   :linenos:

   namespace MyModule;

   class Module
   {
   }

Though it will not serve any purpose at this point, this "MyModule" module now has everything it needs to be considered a valid module and be loaded by the module system!

This ``Module`` class serves as the single entry point for module manager listeners to interact with a module. From within this simple, yet powerful class, modules can override or provide additional application configuration, perform initialization tasks such as registering autoloader(s) and event listeners, declaring dependencies, and much more.


.. _zend.module-manager.module-class.example.typical-module-class:

.. rubric:: A Typical Module Class

The following example shows a more typical usage of the ``Module`` class:

.. code-block:: php
   :linenos:

   namespace MyModule;

   class Module
   {
       public function getAutoloaderConfig()
       {
           return array(
               'Zend\Loader\ClassMapAutoloader' => array(
                   __DIR__ . '/autoload_classmap.php',
               ),
               'Zend\Loader\StandardAutoloader' => array(
                   'namespaces' => array(
                       __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                   ),
               ),
           );
       }

       public function getConfig()
       {
           return include __DIR__ . '/config/module.config.php';
       }
   }

For a list of the provided module manager listeners and the interfaces and methods that ``Module`` classes may implement in order to interact with the module manager and application, see the :ref:`module manager listeners documentation <zend.module-manager.module-manager.module-manager-listeners>` and the :ref:`module mananger events documentation <zend.module-manager.module-manager.module-manager-events>`.


.. _zend.module-manager.module-class.the-loadModules.post-event:

The "loadModules.post" Event
----------------------------

It is not safe for a module to assume that any other modules have already been loaded at the time ``init()`` method is called. If your module needs to perform any actions after all other modules have been loaded, the module manager's "loadModules.post" event makes this easy.

.. note::
   For more information on methods like ``init()`` and ``getConfig()``, refer to the :ref:`module manager listeners documentation <zend.module-manager.module-manager.module-manager-listeners>`.



.. _zend.module-manager.module-class.example.loadModules.post-event:

.. rubric:: Sample Usage of "loadModules.post" Event

.. code-block:: php
   :linenos:

   use Zend\EventManager\EventInterface as Event;
   use Zend\ModuleManager\ModuleManager;

   class Module
   {
       public function init(ModuleManager $moduleManger)
       {
           // Remember to keep the init() method as lightweight as possible
           $events = $moduleManager->getEventManager();
           $events->attach('loadModules.post', array($this, 'modulesLoaded'));
       }

       public function modulesLoaded(Event $e)
       {
           // This method is called once all modules are loaded.
           $moduleManager = $e->getTarget();
           $loadedModules = $moduleManager->getLoadedModules();
           $config        = $moduleManager->getConfig();
       }
   }


.. _zend.module-manager.module-class.the-mvc-bootstrap-event:

The MVC "bootstrap" Event
-------------------------

If you are writing an MVC-oriented module for ZF2, you may need access to additional parts of the application in your ``Module`` class such as the instance of ``Zend\Mvc\Application`` or its registered service manager instance. For this, you may utilize the MVC "bootstrap" event. The bootstrap event is triggered after the "loadModule.post" event, once *$application->bootstrap()* is called.


.. _zend.module-manager.module-class.example.mvc-bootstrap-event:

.. rubric:: Sample Usage of the MVC "bootstrap" Event

.. code-block:: php
   :linenos:

   use Zend\EventManager\EventInterface as Event;

   class Module
   {
       public function onBootstrap(Event $e)
       {
           // This method is called once the MVC bootstrapping is complete
           $application = $e->getApplication();
           $services    = $application->getServiceManager();
       }
   }


