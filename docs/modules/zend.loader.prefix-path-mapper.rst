
.. _zend.loader.prefix-path-mapper:

The PrefixPathMapper Interface
==============================


.. _zend.loader.prefix-path-mapper.intro:

Overview
--------

One approach to resolving plugin names to class names utilizes prefix/path pairs. In this methodology, the developer specifies one or more directories containing plugins that have a common namespace or prefix. When resolving a plugin, the mapper will loop through these prefixes, and look for a class file matching the requested plugin; if found, that plugin class is loaded from the file and used. The ``PrefixPathMapper`` interface defines a common interface for specifying and modifying a map of prefix/path pairs.


.. _zend.loader.prefix-path-mapper.quick-start:

Quick Start
-----------

The ``PrefixPathMapper`` provides simply two methods: one for registering a prefix path, and another for removing one.

.. code-block:: php
   :linenos:

   namespace Zend\Loader;

   interface PrefixPathMapper
   {
       public function addPrefixPath($prefix, $path);
       public function removePrefixPath($prefix, $path);
   }


.. _zend.loader.prefix-path-mapper.options:

Configuration Options
---------------------

This component defines no configuration options, as it is an interface.


.. _zend.loader.prefix-path-mapper.methods:

Available Methods
-----------------


.. _zend.loader.prefix-path-mapper.methods.add-prefix-path:

addPrefixPath
   Register a prefix/path association

   ``addPrefixPath($prefix, $path)``




   **addPrefixPath()**

   Implement this method to allow registering a prefix/path pair. The prefix may be either an older, PHP 5.2-style vendor prefix or a true PHP 5.3 namespace; the path should be a path to a directory of files using the given prefix or namespace. The implemenation should determine whether or not to aggregate paths for each namespace, or simply maintain a 1:1 association.




.. _zend.loader.prefix-path-mapper.methods.remove-prefix-path:

removePrefixPath
   Remove a prefix/path association

   ``removePrefixPath($prefix, $path)``




   **removePrefixPath()**

   Implement this method to remove a prefix/path association from the internal map.




.. _zend.loader.prefix-path-mapper.examples:

Examples
--------

Please see the :ref:`Quick Start <zend.loader.prefix-path-mapper.quick-start>` for the interface specification.


