.. _zend.loader.module-autoloader:

The ModuleAutoloader
====================

.. _zend.loader.module-autoloader.intro:

Overview
--------

``Zend\Loader\ModuleAutoloader`` is a special implementation of the :ref:`Zend\\Loader\\SplAutoloader 
<zend.loader.spl-autoloader>` interface, used by :ref:`Zend\\ModuleManager <zend.module-manager.intro>` to
autoload ``Module`` classes from different sources.

Apart from being able to autoload modules from directories, the ``ModuleAutoloader`` can also autoload modules
packaged as `Phar archives`_, which allows for packaging your modules in a single file for easier distribution.
Supported archive formats are: ``.phar``, ``.phar.gz``, ``.phar.bz2``, ``.phar.tar``, ``.phar.tar.gz``,
``.phar.tar.bz2``, ``.phar.zip``, ``.tar``, ``tar.gz``, ``.tar.bz2`` and ``.zip``. It is, however, recommended
to avoid compressing your packages (be it either `gz`, `bz2` or `zip` compression), as it introduces additional 
CPU overhead to every request.

.. _zend.loader.module-autoloader.quickstart:

Quickstart
----------

As the ``ModuleAutoloader`` is meant to be used with the ``ModuleManager``, for examples of it's usage and
how to configure it, please see the :ref:`Module Autoloader Usage
<zend.module-manager.module-autoloader.usage>` section of the ``ModuleManager`` documentation.

.. _zend.loader.module-autoloader.options:

Configuration Options
---------------------

The ``ModuleAutoloader`` defines the following options.

.. rubric:: ModuleAutoloader Options

**$options**
    The ``ModuleAutoloader`` expects an array of options, where each option is either a path to scan for modules,
    or a key/value pair of explicit module paths. In the case of explicit module paths, the key is the module's
    name, and the value is the path to that module.

    .. code-block:: php
        :linenos:

        $options = array(
            '/path/to/modules',
            '/path/to/other/modules',
            'MyModule' => '/explicit/path/mymodule-v1.2'
        );

.. _zend.loader.module-autoloader.methods:

Available Methods
-----------------

.. _zend.loader.class-map-autoloader.methods.constructor:

\__construct
   Initialize and configure the object
   ``__construct($options = null)``

   **Constructor**
   Used during instantiation of the object. Optionally, pass options, which may be either an array or
   ``Traversable`` object; this argument will be passed to :ref:`setOptions()
   <zend.loader.module-autoloader.methods.set-options>`.


.. _zend.loader.module-autoloader.methods.set-options:

setOptions
   Configure the module autoloader
   ``setOptions($options)``

   **setOptions()**
   Configures the state of the autoloader, registering paths to modules. Expects an array or ``Traversable``
   object; the argument will be passed to :ref:`registerPaths()
   <zend.loader.module-autoloader.methods.register-paths>`.

.. _zend.loader.module-autoloader.methods.autoload:

autoload
   Attempt to load a ``Module`` class.
   ``autoload($class)``

   **autoload()**
   Attempts to load the specified ``Module`` class. Returns a boolean ``false`` on failure, or a string indicating
   the class loaded on success.

.. _zend.loader.module-autoloader.methods.register:

register
   Register with spl_autoload.
   ``register()``

   **register()**
   Registers the ``autoload()`` method of the current instance with ``spl_autoload_register()``.

.. _zend.loader.module-autoloader.methods.unregister:

unregister
   Unregister with spl_autoload.
   ``unregister()``

   **unregister()**
   Unregisters the ``autoload()`` method of the current instance with ``spl_autoload_unregister()``.

.. _zend.loader.module-autoloader.methods.register-paths:

registerPaths
   Register multiple paths with the autoloader.
   ``registerPaths($paths)``

   **registerPaths()**
   Register a paths to modules. Expects an array or ``Traversable`` object. For an example array, please see the
   :ref:`Configuration options <zend.loader.module-autoloader.options>` section.

.. _zend.loader.module-autoloader.methods.register-path:

registerPath
   Register a single path with the autoloader.
   ``registerPath($path, $moduleName=false)``

   **registerPath()**
   Register a single path with the autoloader. The first parameter, ``$path``, is expected to be a string. The
   second parameter, ``$moduleName``, is expected to be a module name, which allows for registering an explicit
   path to that module.

.. _zend.loader.module-autoloader.methods.getPaths:

getPaths
   Get all paths registered with the autoloader.
   ``getPaths()``

   **getPaths()**
   Returns an array of all the paths registered with the current instance of the autoloader.


.. _zend.loader.module-autoloader.examples:

Examples
--------

Please review the :ref:`examples in the quick start <zend.loader.module-autoloader.quickstart>` for usage.


.. _`Phar archives`: http://php.net/phar
