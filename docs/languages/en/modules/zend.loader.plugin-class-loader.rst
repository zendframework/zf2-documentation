.. _zend.loader.plugin-class-loader:

The PluginClassLoader
=====================

.. _zend.loader.plugin-class-loader.intro:

Overview
--------

Resolving plugin names to class names is a common requirement within Zend Framework applications. The
``PluginClassLoader`` implements the interfaces :ref:`PluginClassLocator <zend.loader.plugin-class-locator>`,
:ref:`ShortNameLocator <zend.loader.short-name-locator>`, and ``IteratorAggregate``, providing a simple mechanism
for aliasing plugin names to classnames for later retrieval.

While it can act as a standalone class, it is intended that developers will extend the class to provide a
per-component plugin map. This allows seeding the map with the most often-used plugins, while simultaneously
allowing the end-user to overwrite existing or register new plugins.

Additionally, ``PluginClassLoader`` provides the ability to statically seed all new instances of a given
``PluginClassLoader`` or one of its extensions (via Late Static Binding). If your application will always call for
defining or overriding particular plugin maps on given ``PluginClassLoader`` extensions, this is a powerful
capability.

.. _zend.loader.plugin-class-loader.quick-start:

Quick Start
-----------

Typical use cases involve simply instantiating a ``PluginClassLoader``, seeding it with one or more plugin/class
name associations, and then using it to retrieve the class name associated with a given plugin name.

.. code-block:: php
   :linenos:

   use Zend\Http\HeaderLoader;

   // Provide a global map, or override defaults:
   HeaderLoader::addStaticMap(array(
       'xrequestedfor' => 'My\Http\Header\XRequestedFor',
   ));

   // Instantiate the loader:
   $loader = new Zend\Http\HeaderLoader();

   // Register a new plugin:
   $loader->registerPlugin('xForwardedFor', 'My\Http\Header\XForwardedFor');

   // Load/retrieve the associated plugin class:
   $class = $loader->load('xrequestedfor'); // 'My\Http\Header\XRequestedFor'

.. note::

   **Case Sensitivity**

   The ``PluginClassLoader`` is designed to do case-insensitive plugin name lookups. While the above example
   defines a "xForwardedFor" plugin name, internally, this will be stored as simply "xforwardedfor". If another
   plugin is registered with simply a different word case, it will overwrite this entry.

.. _zend.loader.plugin-class-loader.options:

Configuration Options
---------------------

.. rubric:: PluginClassLoader Options

**$map**
   The constructor may take a single option, an array or ``Traversable`` object of key/value pairs corresponding to
   a plugin name and class name, respectively.

.. _zend.loader.plugin-class-loader.methods:

Available Methods
-----------------

.. _zend.loader.plugin-class-loader.methods.constructor:

\__construct
   Instantiate and initialize the loader
   ``__construct($map = null)``

   **__construct()**
   The constructor is used to instantiate and initialize the plugin class loader. If passed a string, an array, or a
   ``Traversable`` object, it will pass this to the :ref:`registerPlugins()
   <zend.loader.plugin-class-loader.methods.register-plugins>` method in order to seed (or overwrite) the plugin
   class map.


.. _zend.loader.plugin-class-loader.methods.add-static-map:

addStaticMap
   Statically seed the plugin loader map
   ``addStaticMap($map)``

   **addStaticMap()**
   Static method for globally pre-seeding the loader with a class map. It accepts either an array or
   ``Traversable`` object of plugin name/class name pairs.

   When using this method, be certain you understand the precedence in which maps will be merged; in decreasing
   order of preference:

   - Manually registered plugin/class name pairs (e.g., via :ref:`registerPlugin()
     <zend.loader.plugin-class-loader.methods.register-plugin>` or :ref:`registerPlugins()
     <zend.loader.plugin-class-loader.methods.register-plugins>`).

   - A map passed to the constructor .

   - The static map.

   - The map defined within the class itself.

   Also, please note that calling the method will **not** affect any instances already created.


.. _zend.loader.plugin-class-loader.methods.register-plugin:

registerPlugin
   Register a plugin/class association
   ``registerPlugin($shortName, $className)``

   **registerPlugin()**
   Defined by the :ref:`PluginClassLocator <zend.loader.plugin-class-locator>` interface. Expects two string
   arguments, the plugin ``$shortName``, and the class ``$className`` which it represents.


.. _zend.loader.plugin-class-loader.methods.register-plugins:

registerPlugins
   Register many plugin/class associations at once
   ``registerPlugins($map)``

   **registerPlugins()**
   Expects a string, an array or ``Traversable`` object of plugin name/class name pairs representing a plugin class
   map.

   If a string argument is provided, ``registerPlugins()`` assumes this is a class name. If the class does not
   exist, an exception will be thrown. If it does, it then instantiates the class and checks to see whether or not
   it implements ``Traversable``.


.. _zend.loader.plugin-class-loader.methods.unregister-plugin:

unregisterPlugin
   Remove a plugin/class association from the map
   ``unregisterPlugin($shortName)``

   **unregisterPlugin()**
   Defined by the ``PluginClassLocator`` interface; remove a plugin/class association from the plugin class map.


.. _zend.loader.plugin-class-loader.methods.get-registered-plugins:

getRegisteredPlugins
   Return the complete plugin class map
   ``getRegisteredPlugins()``

   **getRegisteredPlugins()**
   Defined by the ``PluginClassLocator`` interface; return the entire plugin class map as an array.


.. _zend.loader.plugin-class-loader.methods.is-loaded:

isLoaded
   Determine if a given plugin name resolves
   ``isLoaded($name)``

   **isLoaded()**
   Defined by the ``ShortNameLocator`` interface; determine if the given plugin has been resolved to a class name.


.. _zend.loader.plugin-class-loader.methods.get-class-name:

getClassName
   Return the class name to which a plugin resolves
   ``getClassName($name)``

   **getClassName()**
   Defined by the ``ShortNameLocator`` interface; return the class name to which a plugin name resolves.


.. _zend.loader.plugin-class-loader.methods.load:

load
   Resolve a plugin name
   ``load($name)``

   **load()**
   Defined by the ``ShortNameLocator`` interface; attempt to resolve a plugin name to a class name. If successful,
   returns the class name; otherwise, returns a boolean ``false``.


.. _zend.loader.plugin-class-loader.methods.get-iterator:

getIterator
   Return iterator capable of looping over plugin class map
   ``getIterator()``

   **getIterator()**
   Defined by the ``IteratorAggregate`` interface; allows iteration over the plugin class map. This can come in
   useful for using ``PluginClassLoader`` instances to other ``PluginClassLoader`` instances in order to merge
   maps.


.. _zend.loader.plugin-class-loader.examples:

Examples
--------

.. _zend.loader.plugin-class-loader.examples.static-maps:

.. rubric:: Using Static Maps

It's often convenient to provide global overrides or additions to the maps in a ``PluginClassLoader`` instance.
This can be done using the ``addStaticMap()`` method:

.. code-block:: php
   :linenos:

   use Zend\Loader\PluginClassLoader;

   PluginClassLoader::addStaticMap(array(
       'xrequestedfor' => 'My\Http\Header\XRequestedFor',
   ));

Any later instances created will now have this map defined, allowing you to load that plugin.

.. code-block:: php
   :linenos:

   use Zend\Loader\PluginClassLoader;

   $loader = new PluginClassLoader();
   $class = $loader->load('xrequestedfor'); // My\Http\Header\XRequestedFor

.. _zend.loader.plugin-class-loader.examples.extended-loader:

.. rubric:: Creating a pre-loaded map

In many cases, you know exactly which plugins you may be drawing upon on a regular basis, and which classes they
will refer to. In this case, simply extend the ``PluginClassLoader`` and define the map within the extending class.

.. code-block:: php
   :linenos:

   namespace My\Plugins;

   use Zend\Loader\PluginClassLoader;

   class PluginLoader extends PluginClassLoader
   {
       /**
        * @var array Plugin map
        */
       protected $plugins = array(
           'foo'    => 'My\Plugins\Foo',
           'bar'    => 'My\Plugins\Bar',
           'foobar' => 'My\Plugins\FooBar',
       );
   }

At this point, you can simply instantiate the map and use it.

.. code-block:: php
   :linenos:

   $loader = new My\Plugins\PluginLoader();
   $class  = $loader->load('foobar'); // My\Plugins\FooBar

``PluginClassLoader`` makes use of late static binding, allowing per-class static maps. If you want to allow
defining a :ref:`static map <zend.loader.plugin-class-loader.examples.static-maps>` specific to this extending
class, simply declare a protected static ``$staticMap`` property:

.. code-block:: php
   :linenos:

   namespace My\Plugins;

   use Zend\Loader\PluginClassLoader;

   class PluginLoader extends PluginClassLoader
   {
       protected static $staticMap = array();

       // ...
   }

To inject the static map, use the extending class' name to call the static ``addStaticMap()`` method.

.. code-block:: php
   :linenos:

   PluginLoader::addStaticMap(array(
       'baz'    => 'My\Plugins\Baz',
   ));

.. _zend.loader.plugin-class-loader.examples.using-as-plugin-map:

.. rubric:: Extending a plugin map using another plugin map

In some cases, a general map class may already exist; as an example, most components in Zend Framework that utilize
a plugin broker have an associated ``PluginClassLoader`` extension defining the plugins available for that
component within the framework. What if you want to define some additions to these? Where should that code go?

One possibility is to define the map in a configuration file, and then inject the configuration into an instance of
the plugin loader. This is certainly trivial to implement, but removes the code defining the plugin map from the
library.

An alternate solution is to define a new plugin map class. The class name or an instance of the class may then be
passed to the constructor or ``registerPlugins()``.

.. code-block:: php
   :linenos:

   namespace My\Plugins;

   use Zend\Loader\PluginClassLoader;
   use Zend\Http\HeaderLoader;

   class PluginLoader extends PluginClassLoader
   {
       /**
        * @var array Plugin map
        */
       protected $plugins = array(
           'foo'    => 'My\Plugins\Foo',
           'bar'    => 'My\Plugins\Bar',
           'foobar' => 'My\Plugins\FooBar',
       );
   }

   // Inject in constructor:
   $loader = new HeaderLoader('My\Plugins\PluginLoader');
   $loader = new HeaderLoader(new PluginLoader());

   // Or via registerPlugins():
   $loader->registerPlugins('My\Plugins\PluginLoader');
   $loader->registerPlugins(new PluginLoader());


