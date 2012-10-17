.. _zend.module-manager.module-autoloader:

The Module Autoloader
=====================

Zend Framework 2 ships with the default module autoloader ``Zend\Loader\ModuleAutoloader``. It is a specialized
autoloader responsible for locating and on-demand loading of, the ``Module`` classes from a variety of
sources.

.. _zend.module-manager.module-autoloader.usage:

Module Autoloader Usage
-----------------------

By default, the provided ``Zend\ModuleManager\Listener\DefaultListenerAggregate`` sets up the
``ModuleAutoloader``; as a developer, you need only provide an array of module paths, either
absolute or relative to the application's root, for the ``ModuleAutoloader`` to check when loading
modules. The ``DefaultListenerAggregate`` will take care of instantiating and registering the
``ModuleAutoloader`` for you.


.. note::

   In order for paths relative to your application directory to work, you must have the directive 
   ``chdir(dirname(__DIR__));`` in your ``public/index.php`` file.

.. _zend.module-manager.module-autoloader.example.module-autoloading:

.. rubric:: Registering module paths with the ``DefaultListenerAggregate``

The following example will search for modules in three different ``module_paths``. Two are local directories of this
application and the third is a system-wide shared directory.

.. code-block:: php
   :linenos:

   // public/index.php
   use Zend\ModuleManager\Listener;
   use Zend\ModuleManager\ModuleManager;

   chdir(dirname(__DIR__));

   // Instantiate and configure the default listener aggregate
   $listenerOptions = new Listener\ListenerOptions(array(
       'module_paths' => array(
           './module',
           './vendor',
           '/usr/share/zfmodules',
       )
   ));
   $defaultListeners = new Listener\DefaultListenerAggregate($listenerOptions);

   // Instantiate the module manager
   $moduleManager = new ModuleManager(array(
       'Application',
       'FooModule',
       'BarModule',
   ));

   // Attach the default listener aggregate and load the modules
   $moduleManager->getEventManager()->attachAggregate($defaultListeners);
   $moduleManager->loadModules();

.. note::

   Module paths behave very similar to PHP's ``include_path`` and are searched in the order they are defined. If you
   have modules with the same name in more than one registered module path, the module autoloader will return the
   first one it finds.

.. _zend.module-manager.module-autoloader.non-standard-module-paths:

Non-Standard / Explicit Module Paths
------------------------------------

Sometimes you may want to specify exactly where a module is instead of having ``Zend\Loader\ModuleAutoloader`` try
to find it in the registered paths.

.. _zend.module-manager.module-autoloader.example.module-loading-nonstandard-paths:

.. rubric:: Registering a Non-Standard / Explicit Module Path

In this example, the autoloader will first check for ``MyModule\Module`` in
``/path/to/mymoduledir-v1.2/Module.php``. If it's not found, then it will fall back to searching any other
registered module paths.

.. code-block:: php
   :linenos:

   // ./public/index.php
   use Zend\Loader\ModuleAutoloader;
   use Zend\ModuleManager\Listener;
   use Zend\ModuleManager\ModuleManager;

   chdir(dirname(__DIR__));

   // Instantiate and configure the default listener aggregate
   $listenerOptions = new Listener\ListenerOptions(array(
       'module_paths' => array(
           './module',
           './vendor',
           '/usr/share/zfmodules',
           'MyModule' => '/path/to/mymoduledir-v1.2',
       )
   ));
   $defaultListeners = new Listener\DefaultListenerAggregate($listenerOptions);

   /**
    * Without DefaultListenerAggregate:
    *
    * $moduleAutoloader = new ModuleAutoloader(array(
    *     './module',
    *     './vendor',
    *     '/usr/share/zfmodules',
    *     'MyModule' => '/path/to/mymoduledir-v1.2',
    * ));
    * $moduleAutoloader->register();
    *
    */

   // Instantiate the module manager
   $moduleManager = new ModuleManager(array(
       'MyModule',
       'FooModule',
       'BarModule',
   ));

   // Attach the default listener aggregate and load the modules
   $moduleManager->getEventManager()->attachAggregate($defaultListeners);
   $moduleManager->loadModules();

This same method works if you provide the path to a phar archive.

.. _zend.module-manager.module-autoloader.packaging-modules-with-phar:

Packaging Modules with Phar
---------------------------

If you prefer, you may easily package your module as a `phar archive`_. The module autoloader is able to autoload
modules in the following archive formats: .phar, .phar.gz, .phar.bz2, .phar.tar, .phar.tar.gz, .phar.tar.bz2,
.phar.zip, .tar, .tar.gz, .tar.bz2, and .zip.

The easiest way to package your module is to simply tar the module directory. You can then replace the
``MyModule/`` directory with ``MyModule.tar``, and it should still be autoloaded without any additional changes!

.. note::

   If possible, avoid using any type of compression (bz2, gz, zip) on your phar archives, as it introduces
   unnecessary CPU overhead to each request.



.. _`phar archive`: http://php.net/phar
