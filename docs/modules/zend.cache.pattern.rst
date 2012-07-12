
Zend\\Cache\\Pattern
====================

.. _zend.cache.pattern.intro:

Overview
--------

Cache patterns are configurable objects to solve known performance bottlenecks. Each should be used only in the specific situations they are designed to address. For example you can use one of the ``CallbackCache`` , ``ObjectCache`` or ``ClassCache`` patterns to cache method and function calls; to cache output generation, the ``OutputCache`` pattern could assist.

All cache patterns implements the same interface, ``Zend\Cache\Pattern`` , and most extend the abstract class ``Zend\Cache\Pattern\AbstractPattern`` to implement basic logic.

Configuration is provided via the ``Zend\Cache\Pattern\PatternOptions`` class, which can simply be instantiated with an associative array of options passed to the constructor. To configure a pattern object, you can set an instance of ``Zend\Cache\Pattern\PatternOptions`` with ``setOptions`` , or provide your options (either as an associative array or ``PatternOptions`` instance) as the second argument to the factory.

It's also possible to use a single instance of ``Zend\Cache\Pattern\PatternOptions`` and pass it to multiple pattern objects.

.. _zend.cache.pattern.quick-start:

Quick Start
-----------

Pattern objects can either be created from the provided ``Zend\Cache\PatternFactory`` factory, or, by simply instantiating one of the ``Zend\Cache\Pattern\*`` classes.

.. code-block:: php
    :linenos:
    
    use Zend\Cache\PatternFactory,
        Zend\Cache\Pattern\PatternOptions;
    
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
    

.. _zend.cache.pattern.options:

Configuration Options
---------------------

.. _zend.cache.pattern.options.cache-by-default:


**cache_by_default**


Flag indicating whether or not to cache by default. Used by the ``ClassCache`` and ``ObjectCache`` patterns.

.. _zend.cache.pattern.options.cache-output:


**cache_output**


Used by the ``CallbackCache`` , ``ClassCache`` , and ``ObjectCache`` patterns. Flag used to determine whether or not to cache output.

.. _zend.cache.pattern.options.class:


**class**


Set the name of the class to cache. Used by the ``ClassCache`` pattern.

.. _zend.cache.pattern.options.class-cache-methods:


**class_cache_methods**


Set list of method return values to cache. Used by ``ClassCache`` Pattern.

.. _zend.cache.pattern.options.class-non-cache-methods:


**class_non_cache_methods**


Set list of method return values that shouldnotbe cached. Used by the ``ClassCache`` pattern.

.. _zend.cache.pattern.options.dir-perm:


**dir_perm**


Set directory permissions; proxies to "dir_umask" property, setting the inverse of the provided value. Used by the ``CaptureCache`` pattern.

.. _zend.cache.pattern.options.dir-umask:


**dir_umask**


Set the directory umask value. Used by the ``CaptureCache`` pattern.

.. _zend.cache.pattern.options.file-locking:


**file_locking**


Set whether or not file locking should be used. Used by the ``CaptureCache`` pattern.

.. _zend.cache.pattern.options.file-perm:


**file_perm**


Set file permissions; proxies to the "file_umask" property, setting the inverse of the value provided. Used by the ``CaptureCache`` pattern.

.. _zend.cache.pattern.pattern-options.methods.set-file-umask:


**file_umask**


Set file umask; used by the ``CaptureCache`` pattern.

.. _zend.cache.pattern.options.index-filename:


**index_filename**


Set value for index filename. Used by the ``CaptureCache`` pattern.

.. _zend.cache.pattern.options.object:


**object**


Set object to cache; used by the ``ObjectCache`` pattern.

.. _zend.cache.pattern.options.object-cache-magic-properties:


**object_cache_magic_properties**


Set flag indicating whether or not to cache magic properties. Used by the ``ObjectCache`` pattern.

.. _zend.cache.pattern.options.object-cache-methods:


**object_cache_methods**


Set list of object methods for which to cache return values. Used by ``ObjectCache`` pattern.

.. _zend.cache.pattern.options.object-key:


**object_key**


Set the object key part; used to generate a callback key in order to speed up key generation. Used by the ``ObjectCache`` pattern.

.. _zend.cache.pattern.options.object-non-cache-methods:


**object_non_cache_methods**


Set list of object methods for whichnotto cache return values. Used by the ``ObjectCache`` pattern.

.. _zend.cache.pattern.options.public-dir:


**public_dir**


Set location of public directory; used by the ``CaptureCache`` pattern.

.. _zend.cache.pattern.options.storage:


**storage**


Set the storage adapter. Required for the following Pattern classes: ``CallbackCache`` , ``ClassCache`` , ``ObjectCache`` , ``OutputCache`` .

.. _zend.cache.pattern.options.tag-key:


**tag_key**


Set the prefix used for tag keys. Used by the ``CaptureCache`` pattern.

.. _zend.cache.pattern.options.tags:


**tags**


Set list of tags to use for captured content. Used by the ``CaptureCache`` pattern.

.. _zend.cache.pattern.options.tag-storage:


****


Set storage adapter to use for tags. Used by the ``CaptureCache`` pattern.

.. _zend.cache.pattern.methods:

Available Methods
-----------------

.. _zend.cache.pattern.methods.set-options:


**setOptions**


    ``setOptions(Zend\\Cache\\Pattern\\PatternOptions $options)``


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

Using the callback cache pattern
--------------------------------

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

Using the object cache pattern
------------------------------

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

Using the class cache pattern
-----------------------------

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

Using the output cache pattern
------------------------------

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

Using the capture cache pattern
-------------------------------

You need to configure your HTTP server to redirect missing content to run your script generating it.

This example uses Apache with the following .htaccess:

.. code-block:: php
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
    
    


