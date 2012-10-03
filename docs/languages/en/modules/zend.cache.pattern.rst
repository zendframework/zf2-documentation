.. _zend.cache.pattern:

Zend\\Cache\\Pattern
====================

.. _zend.cache.pattern.intro:

Overview
--------

Cache patterns are configurable objects to solve known performance bottlenecks. Each should be used only in the
specific situations they are designed to address. For example you can use one of the ``CallbackCache``,
``ObjectCache`` or ``ClassCache`` patterns to cache method and function calls; to cache output generation, the
``OutputCache`` pattern could assist.

All cache patterns implements the same interface, ``Zend\Cache\Pattern``, and most extend the abstract class
``Zend\Cache\Pattern\AbstractPattern`` to implement basic logic.

Configuration is provided via the ``Zend\Cache\Pattern\PatternOptions`` class, which can simply be instantiated
with an associative array of options passed to the constructor. To configure a pattern object, you can set an
instance of ``Zend\Cache\Pattern\PatternOptions`` with ``setOptions``, or provide your options (either as an
associative array or ``PatternOptions`` instance) as the second argument to the factory.

It's also possible to use a single instance of ``Zend\Cache\Pattern\PatternOptions`` and pass it to multiple
pattern objects.

.. _zend.cache.pattern.quick-start:

Quick Start
-----------

Pattern objects can either be created from the provided ``Zend\Cache\PatternFactory`` factory, or, by simply
instantiating one of the ``Zend\Cache\Pattern\*`` classes.

.. code-block:: php
   :linenos:

   use Zend\Cache\PatternFactory;
   use Zend\Cache\Pattern\PatternOptions;

   // Via the factory:
   $callbackCache = PatternFactory::factory('callback', array(
       'storage'      => 'apc',
       'cache_output' => true,
   ));

   // OR, the equivalent manual instantiation:
   $callbackCache = new \Zend\Cache\Pattern\CallbackCache();
   $callbackCache->setOptions(new PatternOptions(array(
       'storage'      => 'apc',
       'cache_output' => true,
   )));

.. _zend.cache.pattern.callbackcache:

Zend\\Cache\\Pattern\\CallbackCache
-----------------------------------

   This cache pattern caches calls of not specific functions and methods given as a callback.

.. _zend.cache.pattern.callbackcache.options:

.. table:: Configuration options

   +--------------+--------------------------------------------------------------+----------------+-------------------------------------------------+
   |Option        |Data Type                                                     |Default Value   |Description                                      |
   +==============+==============================================================+================+=================================================+
   |storage       |``string`` ``array`` ``Zend\Cache\Storage\StorageInterface``  |<none>          |The storage to write/read cached data            |
   +--------------+--------------------------------------------------------------+----------------+-------------------------------------------------+
   |cache_output  |``boolean``                                                   |``true``        |Cache output of callback                         |
   +--------------+--------------------------------------------------------------+----------------+-------------------------------------------------+

.. _zend.cache.pattern.classcache:

Zend\\Cache\\Pattern\\ClassCache
--------------------------------

   This cache pattern caches calls of static class methods.

.. _zend.cache.pattern.classcache.options:

.. table:: Configuration options

   +------------------------+--------------------------------------------------------------+----------------+-----------------------------------------------------------------+
   |Option                  |Data Type                                                     |Default Value   |Description                                                      |
   +========================+==============================================================+================+=================================================================+
   |storage                 |``string`` ``array`` ``Zend\Cache\Storage\StorageInterface``  |<none>          |The storage to write/read cached data                            |
   +------------------------+--------------------------------------------------------------+----------------+-----------------------------------------------------------------+
   |class                   |``string``                                                    |<none>          |The class name                                                   |
   +------------------------+--------------------------------------------------------------+----------------+-----------------------------------------------------------------+
   |cache_output            |``boolean``                                                   |``true``        |Cache output of callback                                         |
   +------------------------+--------------------------------------------------------------+----------------+-----------------------------------------------------------------+
   |cache_by_default        |``boolean``                                                   |``true``        |Cache method calls by default                                    |
   +------------------------+--------------------------------------------------------------+----------------+-----------------------------------------------------------------+
   |class_cache_methods     |``array``                                                     |``[]``          |List of methods to cache (If ``cache_by_default`` is disabled)   |
   +------------------------+--------------------------------------------------------------+----------------+-----------------------------------------------------------------+
   |class_non_cache_methods |``array``                                                     |``[]``          |List of methods to no-cache (If ``cache_by_default`` is enabled) |
   +------------------------+--------------------------------------------------------------+----------------+-----------------------------------------------------------------+

.. _zend.cache.pattern.objectcache:

Zend\\Cache\\Pattern\\ObjectCache
---------------------------------

   This cache pattern caches calls of object methods.

.. _zend.cache.pattern.objectcache.options:

.. table:: Configuration options

   +------------------------------+--------------------------------------------------------------+------------------------+-----------------------------------------------------------------+
   |Option                        |Data Type                                                     |Default Value           |Description                                                      |
   +==============================+==============================================================+========================+=================================================================+
   |storage                       |``string`` ``array`` ``Zend\Cache\Storage\StorageInterface``  |<none>                  |The storage to write/read cached data                            |
   +------------------------------+--------------------------------------------------------------+------------------------+-----------------------------------------------------------------+
   |object                        |``object``                                                    |<none>                  |The object to cache methods calls of                             |
   +------------------------------+--------------------------------------------------------------+------------------------+-----------------------------------------------------------------+
   |object_key                    |``null`` ``string``                                           |<Class name of object>  |A hopefully unique key of the object                             |
   +------------------------------+--------------------------------------------------------------+------------------------+-----------------------------------------------------------------+
   |cache_output                  |``boolean``                                                   |``true``                |Cache output of callback                                         |
   +------------------------------+--------------------------------------------------------------+------------------------+-----------------------------------------------------------------+
   |cache_by_default              |``boolean``                                                   |``true``                |Cache method calls by default                                    |
   +------------------------------+--------------------------------------------------------------+------------------------+-----------------------------------------------------------------+
   |object_cache_methods          |``array``                                                     |``[]``                  |List of methods to cache (If ``cache_by_default`` is disabled)   |
   +------------------------------+--------------------------------------------------------------+------------------------+-----------------------------------------------------------------+
   |object_non_cache_methods      |``array``                                                     |``[]``                  |List of methods to no-cache (If ``cache_by_default`` is enabled) |
   +------------------------------+--------------------------------------------------------------+------------------------+-----------------------------------------------------------------+
   |object_cache_magic_properties |``boolean``                                                   |``false``               |Cache calls of magic object properties                           |
   +------------------------------+--------------------------------------------------------------+------------------------+-----------------------------------------------------------------+

.. _zend.cache.pattern.capturecache:

Zend\\Cache\\Pattern\\CaptureCache
----------------------------------

   This cache pattern writes the output of the script to the requested file.
   So for next requests the webserver can response with a static file
   instead of starting PHP again to generate the response again.

.. _zend.cache.pattern.capturecache.options:

.. table:: Configuration options

   +------------------+--------------------------+------------------------+-----------------------------------------------------------------+
   |Option            |Data Type                 |Default Value           |Description                                                      |
   +==================+==========================+========================+=================================================================+
   |public_dir        |``string``                |<none>                  |Location of public directory to write output to                  |
   +------------------+--------------------------+------------------------+-----------------------------------------------------------------+
   |index_filename    |``string``                |"index.html"            |The name of the first file if only a directory was requested     |
   +------------------+--------------------------+------------------------+-----------------------------------------------------------------+
   |file_locking      |``boolean``               |``true``                |Locking output files on writing                                  |
   +------------------+--------------------------+------------------------+-----------------------------------------------------------------+
   |file_permission   |``integer`` ``boolean``   |0600 (``false`` on win) |Set permissions of generated output files                        |
   +------------------+--------------------------+------------------------+-----------------------------------------------------------------+
   |dir_permission    |``integer`` ``boolean``   |0700 (``false`` on win) |Set permissions of generated output directories                  |
   +------------------+--------------------------+------------------------+-----------------------------------------------------------------+
   |umask             |``integer`` ``boolean``   |``false``               |Using umask on generationg output files / directories            |
   +------------------+--------------------------+------------------------+-----------------------------------------------------------------+

Available Methods
-----------------

.. _zend.cache.pattern.methods.set-options:

**setOptions**
   ``setOptions(Zend\Cache\Pattern\PatternOptions $options)``

   Set pattern options

   Returns Zend\\Cache\\Pattern

.. _zend.cache.pattern.methods.get-options:

**getOptions**
   ``getOptions()``

   Get all pattern options

   Returns ``PatternOptions`` instance.

.. _zend.cache.pattern.examples:

Examples
--------

.. _zend.cache.pattern.examples.callback:

.. rubric:: Using the callback cache pattern

.. code-block:: php
   :linenos:

   use Zend\Cache\PatternFactory;

   $callbackCache = PatternFactory::factory('callback', array(
       'storage' => 'apc'
   ));

   // Calls and caches the function doResourceIntensiceStuff with three arguments
   // and returns result
   $result = $callbackCache->call('doResourceIntensiveStuff', array(
       'argument1',
       'argument2',
       'argumentN',
   ));

.. _zend.cache.pattern.examples.object:

.. rubric:: Using the object cache pattern

.. code-block:: php
   :linenos:

   use Zend\Cache\PatternFactory;

   $object      = new MyObject();
   $objectProxy = PatternFactory::factory('object', array(
       'object'  => $object,
       'storage' => 'apc',
   ));

   // Calls and caches $object->doResourceIntensiveStuff with three arguments
   // and returns result
   $result = $objectProxy->doResourceIntensiveStuff('argument1', 'argument2', 'argumentN');

.. _zend.cache.pattern.examples.class:

.. rubric:: Using the class cache pattern

.. code-block:: php
   :linenos:

   use Zend\Cache\PatternFactory;

   $classProxy = PatternFactory::factory('class', array(
       'class'   => 'MyClass',
       'storage' => 'apc',
   ));

   // Calls and caches MyClass::doResourceIntensiveStuff with three arguments
   // and returns result
   $result = $classProxy->doResourceIntensiveStuff('argument1', 'argument2', 'argumentN');

.. _zend.cache.pattern.examples.output:

.. rubric:: Using the output cache pattern

.. code-block:: php
   :linenos:

   use Zend\Cache\PatternFactory;

   $outputCache = PatternFactory::factory('output', array(
       'storage' => 'filesystem',
   ));

   // Start capturing all output (excluding headers) and write it to storage.
   // If there is already a cached item with the same key it will be
   // output and return true, else false.
   if ($outputCache->start('MyUniqueKey') === false) {
       echo 'cache output since: ' . date('H:i:s') . "<br />\n";

       // end capturing output, write content to cache storage and display
       // captured content
       $outputCache->end();
   }

   echo 'This output is never cached.';

.. _zend.cache.pattern.examples.capture:

.. rubric:: Using the capture cache pattern

You need to configure your HTTP server to redirect missing content to run your script generating it.

This example uses Apache with the following .htaccess:

.. code-block:: text
   :linenos:

   ErrorDocument 404 /index.php

Within your index.php you can add the following content:

.. code-block:: php
   :linenos:

   use Zend\Cache\PatternFactory;

   $capture = PatternFactory::factory('capture', array(
       'public_dir' => __DIR__,
   ));

   // Start capturing all output excl. headers. and write to public directory
   // If the request was already written the file will be overwritten.
   $capture->start();

   // do stuff to dynamically generate output



