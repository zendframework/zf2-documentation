
.. _zend.loader.prefix-path-loader:

The PrefixPathLoader
====================


.. _zend.loader.prefix-path-loader.intro:

Overview
--------

Zend Framework's 1.X series introduced a plugin methodology surrounding associations of vendor/component prefixes and filesystem paths in the ``Zend_Loader_PluginLoader`` class. Zend Framework 2 provides equivalent functionality with the ``PrefixPathLoader`` class, and expands it to take advantage of PHP 5.3 namespaces.

The concept is relatively simple: a given vendor prefix or namespace is mapped to one or more paths, and multiple prefix/path maps may be provided. To resolve a plugin name, the prefixes are searched as a stack (i.e., last in, first out, or LIFO), and each path associated with the prefix is also searched as a stack. As soon as a file is found matching the plugin name, the class will be returned.

Since searching through the filesystem can lead to performance degradation, the ``PrefixPathLoader`` provides several optimizations. First, it will attempt to autoload a plugin before scanning the filesystem. This allows you to benefit from your autoloader and/or an opcode cache. Second, it aggregates the class name and class file associated with each discovered plugin. You can then retrieve this information and cache it for later seeding a :ref:`ClassMapAutoloader <zend.loader.class-map-autoloader>` and :ref:`PluginClassLoader <zend.loader.plugin-class-loader>`.

``PrefixPathLoader`` implements the ``ShortNameLocator`` and ``PrefixPathMapper`` interfaces.

.. note::
   **Case Sensitivity**

   Unlike the :ref:`PluginClassLoader <zend.loader.plugin-class-loader>`, plugins resolved via the ``PrefixPathLoader`` are considered case sensitive. This is due to the fact that the lookup is done on the filesystem, and thus a file exactly matching the plugin name must exist.


.. note::
   **Preference is for Namespaces**

   Unlike the Zend Framework 1 variant, the ``PrefixPathLoader`` assumes that "prefixes" are PHP 5.3 namespaces by default. You can override this behavior, however, per prefix/path you map. Please see the documentation and examples below for details.



.. _zend.loader.prefix-path-loader.quick-start:

Quick Start
-----------

The ``PrefixPathLoader`` invariably requires some configuration -- it needs to know what namespaces and/or vendor prefixes it should try, as well as the paths associated with each. You can inform the class of these at instantiation, or later by calling either the ``addPrefixPath()`` or ``addPrefixPaths()`` methods.

.. code-block:: php
   :linenos:

   use Zend\Loader\PrefixPathLoader;

   // Configure at instantiation:
   $loader = new PrefixPathLoader(array(
       array('prefix' => 'Foo', 'path' => '../library/Foo'),
       array('prefix' => 'Bar', 'path' => '../vendor/Bar'),
   ));

   // Or configure manually using methods:
   $loader = new PrefixPathLoader();
   $loader->addPrefixPath('Foo', '../library/Foo');

   $loader->addPrefixPaths(array(
       array('prefix' => 'Foo', 'path' => '../library/Foo'),
       array('prefix' => 'Bar', 'path' => '../vendor/Bar'),
   ));

Once configured, you may then attempt to lookup a plugin.

.. code-block:: php
   :linenos:

   if (false === ($class = $loader->load('bar'))) {
       throw new Exception("Plugin class matching 'bar' not found!");
   }
   $plugin = new $class();


.. _zend.loader.prefix-path-loader.options:

Configuration Options
---------------------

.. rubric:: PrefixPathLoader Options

**$options**
   The constructor accepts either an array or a ``Traversable`` object of prefix paths. For the format allowed, please see the :ref:`addPrefixPaths() <zend.loader.prefix-path-loader.methods.add-prefix-paths>` method documentation.



.. _zend.loader.prefix-path-loader.methods:

Available Methods
-----------------


.. _zend.loader.prefix-path-loader.methods.constructor:

\__construct
   Instantiate and initialize loader

   ``__construct($options = null)``




   **__construct()**

   Instantiates and initializes a ``PrefixPathLoader`` instance. If the ``$prefixPaths`` protected member is defined, it re-initializes it to an ``Zend\Stdlib\ArrayStack`` instance, and passes the original value to :ref:`the addPrefixPaths() method <zend.loader.prefix-path-loader.methods.add-prefix-paths>`. It then checks to see if ``$staticPaths`` has been populated, and, if so, passes that on to the ``addPrefixPaths()`` method to merge the values. Finally, if ``$options`` is non-null, it passes that to ``addPrefixPaths()``.




.. _zend.loader.prefix-path-loader.methods.add-static-paths:

addStaticPaths
   Add paths statically

   ``addStaticPaths($paths)``




   **addStaticPaths()**

   Expects an array or ``Traversable`` object compatible with the ``addPrefixPaths()`` method. This method is static, and populates the protected ``$staticPaths`` member, which is used during instantiation to either override default paths or add additional prefix/path pairs to search.




.. _zend.loader.prefix-path-loader.methods.set-options:

setOptions
   Configure object state

   ``setOptions($options)``




   **setOptions()**

   Proxies to :ref:`addPrefixPaths() <zend.loader.prefix-path-loader.methods.add-prefix-paths>`.




.. _zend.loader.prefix-path-loader.methods.add-prefix-path:

addPrefixPath
   Map a namespace/vendor prefix to the given filesystem path

   ``addPrefixPath($prefix, $path, $namespaced = true)``




   **addPrefixPath()**

   Use this method to map a single filesystem path to a given namespace or vendor prefix. By default, the ``$prefix`` will be considered a PHP 5.3 namespace; you may specify that it is a vendor prefix by passing a boolean ``false`` value to the ``$namespaced`` argument.

   If the ``$prefix`` has been previously mapped, this method adds another ``$path`` to a stack -- meaning the new path will be searched first when attempting to resolve a plugin name to this ``$prefix``.




.. _zend.loader.prefix-path-loader.methods.add-prefix-paths:

addPrefixPaths
   Add many prefix/path pairs at once

   ``addPrefixPaths($prefixPaths)``




   **addPrefixPaths()**

   This method expects an array or ``Traversable`` object. Each item in the array or object must be one of the following:

   - An array, with the keys "prefix" and "path", and optionally "namespaced"; the keys correspond to the arguments to :ref:`addPrefixPath() <zend.loader.prefix-path-loader.methods.add-prefix-path>`. The "prefix" and "path" keys should point to string values, while the "namespaced" key should be a boolean.

   - An object, with the attributes "prefix" and "path", and optionally "namespaced"; the attributes correspond to the arguments to :ref:`addPrefixPath() <zend.loader.prefix-path-loader.methods.add-prefix-path>`. The "prefix" and "path" attributes should point to string values, while the "namespaced" attribute should be a boolean.

   The method will loop over arguments, and pass values to :ref:`addPrefixPath() <zend.loader.prefix-path-loader.methods.add-prefix-path>` to process.




.. _zend.loader.prefix-path-loader.methods.get-paths:

getPaths
   Retrieve all paths associated with a prefix, or all paths

   ``getPaths($prefix = null)``




   **getPaths()**

   Use this method to obtain the prefix/paths map. If no ``$prefix`` is provided, the return value is an ``Zend\Stdlib\ArrayStack``, where the keys are namespaces or vendor prefixes, and the values are ``Zend\Stdlib\SplStack`` instances containing all paths associated with the given namespace or prefix.

   If the ``$prefix`` argument is provided, two outcomes are possible. If the prefix is not found, a boolean ``false`` value is returned. If the prefix is found, a ``Zend\Stdlib\SplStack`` instance containing all paths associated with that prefix is returned.




.. _zend.loader.prefix-path-loader.methods.clear-paths:

clearPaths
   Clear all maps, or all paths for a given prefix

   ``clearPaths($prefix = null)``




   **clearPaths()**

   If no ``$prefix`` is provided, all prefix/path pairs are removed. If a ``$prefix`` is provided and found within the map, only that prefix is removed. Finally, if a ``$prefix`` is provided, but not found, a boolean ``false`` is returned.




.. _zend.loader.prefix-path-loader.methods.remove-prefix-path:

removePrefixPath


   ``removePrefixPath($prefix, $path)``




   **removePrefixPath()**

   Removes a single path from a given prefix.




.. _zend.loader.prefix-path-loader.methods.is-loaded:

isLoaded
   Has the given plugin been loaded?

   ``isLoaded($name)``




   **isLoaded()**

   Use this method to determine if the given plugin has been resolved to a class and file. Unlike ``PluginClassLoader``, this method can return a boolean ``false`` even if the loader is capable of loading the plugin; it simply indicates whether or not the current instance has yet resolved the plugin via the ``load()`` method.




.. _zend.loader.prefix-path-loader.methods.get-class-name:

getClassName
   Retrieve the class name to which a plugin resolves

   ``getClassName($name)``




   **getClassName()**

   Given a plugin name, this method will attempt to return the associated class name. The method completes successfully if, and only if, the plugin has been successfully loaded via ``load()``. Otherwise, it will return a boolean ``false``.




.. _zend.loader.prefix-path-loader.methods.load:

load
   Attempt to resolve a plugin to a class

   ``load($name)``




   **load()**

   Given a plugin name, the ``load()`` method will loop through the internal ``ArrayStack``. The plugin name is first normalized using ``ucwords()``, and then appended to the current vendor prefix or namespace. If the resulting class name resolves via autoloading, the class name is immediately returned. Otherwise, it then loops through the associated ``SplStack`` of paths for the prefix, looking for a file matching the plugin name (i.e., for plugin ``Foo``, file name ``Foo.php``) in the given path. If a match is found, the class name is returned.

   If no match is found, a boolean false is returned.




.. _zend.loader.prefix-path-loader.methods.get-plugin-map:

getPluginMap
   Get a list of plugin/class name pairs

   ``getPluginMap()``




   **getPluginMap()**

   Returns an array of resolved plugin name/class name pairs. This value may be used to seed a ``PluginClassLoader`` instance.




.. _zend.loader.prefix-path-loader.methods.get-class-map:

getClassMap
   Get a list of class name/file name pairs

   ``getClassMap()``




   **getClassMap()**

   Returns an array of resolved class name/file name pairs. This value may be used to seed a ``ClassMapAutoloader`` instance.




.. _zend.loader.prefix-path-loader.examples:

Examples
--------


.. _zend.loader.prefix-path-loader.examples.multiple-paths:

.. rubric:: Using multiple paths for the same prefix

Sometimes you may have code containing the same namespace or vendor prefix in two different locations. Potentially, the same class may be defined in different locations, but with slightly different functionality. (We do not recommend this, but sometimes it happens.)

The ``PrefixPathLoader`` easily allows for these situations; simply register the path you want to take precedence last.

Consider the following directory structures:

.. code-block:: text
   :linenos:

   project
   |-- library
   |   |-- Foo
   |   |   |-- Bar.php
   |   |   `-- Baz.php
   |-- vendor
   |   |-- Foo
   |   |   |-- Bar.php
   |   |   `-- Foobar.php

For purposes of this example, we'll assume that the common namespace is "Foo", and that the "Bar" plugin from the vendor branch is preferred. To make this possible, simply register the "vendor" directory last.

.. code-block:: php
   :linenos:

   use Zend\Loader\PrefixPathLoader;

   $loader = new PrefixPathLoader();

   // Multiple calls to addPrefixPath():
   $loader->addPrefixPath('Foo', PROJECT_ROOT . '/library/Foo')
          ->addPrefixPath('Foo', PROJECT_ROOT . '/vendor/Foo');

   // Or use a single call to addPrefixPaths():
   $loader->addPrefixPaths(array(
       array('prefix' => 'Foo', 'path' => PROJECT_ROOT . '/library/Foo'),
       array('prefix' => 'Foo', 'path' => PROJECT_ROOT . '/vendor/Foo'),
   ));

   // And then resolve plugins:
   $bar    = $loader->load('bar');    // Foo\Bar from vendor/Foo/Bar.php
   $baz    = $loader->load('baz');    // Foo\Baz from library/Foo/Baz.php
   $foobar = $loader->load('foobar'); // Foo\Foobar from vendor/Foo/Baz.php


.. _zend.loader.prefix-path-loader.examples.optimizing:

.. rubric:: Prototyping with PrefixPathLoader

``PrefixPathLoader`` is quite useful for prototyping applications. With minimal configuration, you can access a full directory of plugins, without needing to update maps as new plugins are added. However, this comes with a price: performance. Since plugins are resolved typically using by searching the filesystem, you are introducing I/O calls every time you request a new plugin.

With this in mind, ``PrefixPathLoader`` provides two methods for assisting in migrating to more performant solutions. The first is ``getClassMap()``. This method returns an array of class name/file name pairs suitable for use with :ref:`ClassMapAutoloader <zend.loader.class-map-autoloader>`. Injecting your autoloader with that map will ensure that on subsequent calls, ``load()`` should be able to find the appropriate class via autoloading -- assuming that the match is on the first prefix checked.

The second solution is the ``getPluginMap()`` method, which creates a plugin name/class name map suitable for injecting into a :ref:`PluginClassLoader <zend.loader.plugin-class-loader>` instance. Combine this with class map-based autoloading, and you can actually eliminate I/O calls altogether when using an opcode cache.

Usage of these methods is quite simple.

.. code-block:: php
   :linenos:

   // After a number of load() operations, or at the end of the request:
   $classMap  = $loader->getClassMap();
   $pluginMap = $loader->getPluginMap();

From here, you will need to do a little work. First, you need to serialize this information somehow for later use. For that, there are two options: ``Zend\Serializer`` or ``Zend\Cache``.

.. code-block:: php
   :linenos:

   // Using Zend\Serializer:
   use Zend\Serializer\Serializer;

   $adapter = Serializer::factory('PhpCode');
   $content = "<?php\nreturn " . $adapter->serialize($classMap) . ";";
   file_put_contents(APPLICATION_PATH . '/.classmap.php', $content);

   // Using Zend\Cache:
   use Zend\Cache\Cache;

   $cache = Cache::factory(
       'Core', 'File',
       array('lifetime' => null, 'automatic_serialization' => true),
       array('cache_dir' => APPLICATION_PATH . '/../cache/classmaps')
   );
   $cache->save($pluginMap, 'pluginmap');

Note: the examples alternate between the class map and plugin map; however, either technique applies to either map.

Once the data is cached, you can retrieve it late to populate. In the example of the class map above, you would simply pass the filename to the ``ClassMapAutoloader`` instance:

.. code-block:: php
   :linenos:

   $autoloader = new Zend\Loader\ClassMapAutoloader();
   $autoloader->registerAutoloadMap(APPLICATION_PATH . '/.classmap.php');

If using ``Zend\Cache``, you would retrieve the cached data, and pass it to the appropriate component; in this case, we pass the value to a ``PluginClassLoader`` instance.

.. code-block:: php
   :linenos:

   $map = $cache->load('pluginmap');

   $loader = new Zend\Loader\PluginClassLoader($map);

With some creative and well disciplined architecture, you can likely automate these processes to ensure that development can benefit from the dynamic nature of the ``PrefixPathLoader``, and production can benefit from the performance optimizations of the ``ClassMapAutoloader`` and ``PluginClassLoader``.


