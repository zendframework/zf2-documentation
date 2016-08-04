.. _zend.module-manager.module-class:

The Module Class
================

By default, the Zend Framework 2 module system simply expects each module name to be capable of resolving to an object
instance. The default module resolver, ``Zend\ModuleManager\Listener\ModuleResolverListener``, simply instantiates 
an instance of ``{moduleName}\Module`` for each enabled module.

.. _zend.module-manager.module-class.example.minimal-module:

A Minimal Module
----------------

As an example, provided the module name "MyModule", ``Zend\ModuleManager\Listener\ModuleResolverListener`` will
simply expect the class ``MyModule\Module`` to be available. It relies on a registered autoloader (typically
``Zend\Loader\ModuleAutoloader``) to find and include the ``MyModule\Module`` class if it isn't already available.

The directory structure of a module named "MyModule" might start out looking something like this:


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

Though it will not serve any purpose at this point, this "MyModule" module now has everything required to be
considered a valid module and to be loaded by the module system!

This ``Module`` class serves as the single entry point for ``ModuleManager`` listeners to interact with a module. From
within this simple - yet powerful - class, modules can override or provide additional application configuration,
perform initialization tasks such as registering autoloader(s), services and event listeners, declaring dependencies, 
and much more.

.. _zend.module-manager.module-class.example.typical-module-class:

A Typical Module Class
----------------------

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

For a list of the provided module manager listeners and the interfaces and methods that ``Module`` classes may
implement in order to interact with the module manager and application, see the :ref:`module manager
listeners <zend.module-manager.module-manager.module-manager-listeners>` and the :ref:`module mananger
events <zend.module-manager.module-manager.module-manager-events>` documentations.

.. _zend.module-manager.module-class.the-loadModules.post-event:

The "loadModules.post" Event
----------------------------

It is not safe for a module to assume that any other modules have already been loaded at the time ``init()`` method
is called. If your module needs to perform any actions after all other modules have been loaded, the module
manager's "loadModules.post" event makes this easy.

.. note::

   For more information on methods like ``init()`` and ``getConfig()``, refer to the :ref:`module manager listeners
   documentation <zend.module-manager.module-manager.module-manager-listeners>`.

.. _zend.module-manager.module-class.example.loadModules.post-event:

Sample Usage of "loadModules.post" Event
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   use Zend\EventManager\EventInterface as Event;
   use Zend\ModuleManager\ModuleManager;

   class Module
   {
       public function init(ModuleManager $moduleManager)
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
           // To get the configuration from another module named 'FooModule'
           $config = $moduleManager->getModule('FooModule')->getConfig();
       }
   }

.. note::

   The ``init()`` method is called for **every** module implementing this feature,
   on **every** page request, and should **only** be used for performing **lightweight** tasks such as registering
   event listeners.

.. _zend.module-manager.module-class.the-mvc-bootstrap-event:

The MVC "bootstrap" Event
-------------------------

If you are writing an MVC-oriented module for Zend Framework 2, you may need access to additional parts of the 
application in your ``Module`` class such as the instance of ``Zend\Mvc\Application`` or its registered 
``ServiceManager`` instance. For this, you may utilize the MVC "bootstrap" event. The bootstrap event is triggered 
after the "loadModule.post" event, once *$application->bootstrap()* is called.

.. _zend.module-manager.module-class.example.mvc-bootstrap-event:

Sample Usage of the MVC "bootstrap" Event
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

.. note::

   The ``onBootstrap()`` method is called for **every** module implementing this feature,
   on **every** page request, and should **only** be used for performing **lightweight** tasks such as registering
   event listeners.
