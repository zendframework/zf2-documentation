.. _zend.cache.cache.manager:

The Cache Manager
=================

It's the nature of applications to require a multitude of caches of any type often dependent on the controller,
library or domain model being accessed. To allow for a simple means of defining ``Zend_Cache`` options in advance
(such as from a bootstrap) so that accessing a cache object requires minimum setup within the application source
code, the ``Zend_Cache_Manager`` class was written. This class is accompanied by
``Zend_Application_Resource_Cachemanager`` ensuring bootstrap configuration is available and
``Zend_Controller_Action_Helper_Cache`` to allow simple cache access and instantiation from controllers and other
helpers.

The basic operation of this component is as follows. The Cache Manager allows users to setup "option templates",
basically options for a set of named caches. These can be set using the method
``Zend_Cache_Manager::setCacheTemplate()``. These templates do not give rise to a cache until the user attempts to
retrieve a named cache (associated with an existing option template) using the method
``Zend_Cache_Manager::getCache()``.

.. code-block:: php
   :linenos:

   $manager = new Zend_Cache_Manager;

   $dbCache = array(
       'frontend' => array(
           'name' => 'Core',
           'options' => array(
               'lifetime' => 7200,
               'automatic_serialization' => true
           )
       ),
       'backend' => array(
           'name' => 'Core',
           'options' => array(
               'cache_dir' => '/path/to/cache'
           )
       )
   );

   $manager->setCacheTemplate('database', $dbCache);

   /**
    * Anywhere else where the Cache Manager is available...
    */
   $databaseCache = $manager->getCache('database');

The Cache Manager also allows simple setting of pre-instantiated caches using the method
``Zend_Cache_Manager::setCache()``.

.. code-block:: php
   :linenos:

   $frontendOptions = array(
      'lifetime' => 7200,
      'automatic_serialization' => true
   );

   $backendOptions = array(
       'cache_dir' => '/path/to/cache'
   );

   $dbCache = Zend_Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   $manager = new Zend_Cache_Manager;
   $manager->setCache('database', $dbCache);

   /**
    * Anywhere else where the Cache Manager is available...
    */
   $databaseCache = $manager->getCache('database');

If for any reason, you are unsure where the Cache Manager contains a pre-instantiated cache or a relevant option
cache template to create one on request, you can check for the existence of a name cache configuration or instance
using the method ``Zend_Cache_Manager::hasCache()``.

.. code-block:: php
   :linenos:

   $manager = new Zend_Cache_Manager;

   $dbCache = array(
       'frontend' => array(
           'name' => 'Core',
           'options' => array(
               'lifetime' => 7200,
               'automatic_serialization' => true
           )
       ),
       'backend' => array(
           'name' => 'Core',
           'options' => array(
               'cache_dir' => '/path/to/cache'
           )
       )
   );

   $manager->setCacheTemplate('database', $dbCache);

   /**
    * Anywhere else where the Cache Manager is available...
    */
   if ($manager->hasCache('database')) {
       $databaseCache = $manager->getCache('database');
   } else {
       // create a cache from scratch if none available from Manager
   }

In some scenarios, you may have defined a number of general use caches using ``Zend_Cache_Manager`` but need to
fine-tune their options before use depending on the circumstances. You can edit previously set cache templates on
the fly before they are instantiated using the method ``Zend_Cache_Manager::setTemplateOptions()``.

.. code-block:: php
   :linenos:

   $manager = new Zend_Cache_Manager;

   $dbCache = array(
       'frontend' => array(
           'name' => 'Core',
           'options' => array(
               'lifetime' => 7200,
               'automatic_serialization' => true
           )
       ),
       'backend' => array(
           'name' => 'Core',
           'options' => array(
               'cache_dir' => '/path/to/cache'
           )
       )
   );

   $manager->setCacheTemplate('database', $dbCache);

   /**
    * Anywhere else where the Cache Manager is available...
    * Here we decided to store some upcoming database queries to Memcached instead
    * of the preconfigured File backend.
    */
   $fineTuning = array(
       'backend' => array(
           'name' => 'Memcached',
           'options' => array(
               'servers' => array(
                   array(
                       'host' => 'localhost',
                       'port' => 11211,
                       'persistent' => true,
                       'weight' => 1,
                       'timeout' => 5,
                       'retry_interval' => 15,
                       'status' => true,
                       'failure_callback' => ''
                   )
               )
           )
       )
   );
   $manager->setTemplateOptions('database', $fineTuning);
   $databaseCache = $manager->getCache('database');

To assist in making the Cache Manager more useful, it is accompanied by ``Zend_Application_Resource_Cachemanager``
and also the ``Zend_Controller_Action_Helper_Cache`` Action Helper. Both of these are described in their relevant
areas of the Reference Guide.

Out of the box, ``Zend_Cache_Manager`` already includes four pre-defined cache templates called "skeleton",
"default", "page" and "tagcache". The default cache is a simple File based cache using the Core frontend which
assumes a cache_dir called "cache" exists at the same level as the conventional "public" directory of a Zend
Framework application. The skeleton cache is actually a ``NULL`` cache, i.e. it contains no options. The remaining
two caches are used to implement a default Static Page Cache where static *HTML*, *XML* or even *JSON* may be
written to static files in ``/public``. Control over a Static Page Cache is offered via
``Zend_Controller_Action_Helper_Cache``, though you may alter the settings of this "page" the "tagcache" it uses to
track tags using ``Zend_Cache_Manager::setTemplateOptions()`` or even ``Zend_Cache_Manager::setCacheTemplate()`` if
overloading all of their options.


