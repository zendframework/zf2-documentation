.. _zend.loader.plugin-class-locator:

The PluginClassLocator interface
================================

.. _zend.loader.plugin-class-locator.intro:

Overview
--------

The ``PluginClassLocator`` interface describes a component capable of maintaining an internal map of plugin names
to actual class names. Classes implementing this interface can register and unregister plugin/class associations,
and return the entire map.

.. _zend.loader.plugin-class-locator.quick-start:

Quick Start
-----------

Classes implementing the ``PluginClassLocator`` need to implement only three methods, as illustrated below.

.. code-block:: php
   :linenos:

   namespace Zend\Loader;

   interface PluginClassLocator
   {
       public function registerPlugin($shortName, $className);
       public function unregisterPlugin($shortName);
       public function getRegisteredPlugins();
   }

.. _zend.loader.plugin-class-locator.options:

Configuration Options
---------------------

This component defines no configuration options, as it is an interface.

.. _zend.loader.plugin-class-locator.methods:

Available Methods
-----------------

.. _zend.loader.plugin-class-locator.methods.register-plugin:

registerPlugin
   Register a mapping of plugin name to class name
   ``registerPlugin($shortName, $className)``

   **registerPlugin()**
   Implement this method to add or overwrite plugin name/class name associations in the internal plugin map.
   ``$shortName`` will be aliased to ``$className``.


.. _zend.loader.plugin-class-locator.methods.unregister-plugin:

unregisterPlugin
   Remove a plugin/class name association
   ``unregisterPlugin($shortName)``

   **unregisterPlugin()**
   Implement this to allow removing an existing plugin mapping corresponding to ``$shortName``.


.. _zend.loader.plugin-class-locator.methods.get-registered-plugins:

getRegisteredPlugins
   Retrieve the map of plugin name/class name associations
   ``getRegisteredPlugins()``

   **getRegisteredPlugins()**
   Implement this to allow returning the plugin name/class name map.


.. _zend.loader.plugin-class-locator.examples:

Examples
--------

Please see the :ref:`Quick Start <zend.loader.plugin-class-locator.quick-start>` for the interface specification.


