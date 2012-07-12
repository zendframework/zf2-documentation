
The Theory of Caching
=====================

There are three key concepts in ``Zend_Cache`` . One is the unique identifier (a string) that is used to identify cache records. The second one is the'lifetime'directive as seen in the examples; it defines for how long the cached resource is considered 'fresh'. The third key concept is conditional execution so that parts of your code can be skipped entirely, boosting performance. The main frontend function (e.g. ``Zend_Cache_Core::get()`` ) is always designed to return ``FALSE`` for a cache miss if that makes sense for the nature of a frontend. That enables end-users to wrap parts of the code they would like to cache (and skip) in ``if()`` { ... }statements where the condition is a ``Zend_Cache`` method itself. On the end if these blocks you must save what you've generated, however (e.g. ``Zend_Cache_Core::save()`` ).

.. note::
    ****

    The conditional execution design of your generating code is not necessary in some frontends (Function, for an example) when the whole logic is implemented inside the frontend.

.. note::
    ****

    'Cache hit' is a term for a condition when a cache record is found, is valid and is 'fresh' (in other words hasn't expired yet). 'Cache miss' is everything else. When a cache miss happens, you must generate your data (as you would normally do) and have it cached. When you have a cache hit, on the other hand, the backend automatically fetches the record from cache transparently.

.. _zend.cache.factory:

The Zend_Cache Factory Method
-----------------------------

A good way to build a usable instance of a ``Zend_Cache`` Frontend is given in the following example :

.. code-block:: php
    :linenos:
    
    // We choose a backend (for example 'File' or 'Sqlite'...)
    $backendName = '[...]';
    
    // We choose a frontend (for example 'Core', 'Output', 'Page'...)
    $frontendName = '[...]';
    
    // We set an array of options for the chosen frontend
    $frontendOptions = array([...]);
    
    // We set an array of options for the chosen backend
    $backendOptions = array([...]);
    
    // We create an instance of Zend_Cache
    // (of course, the two last arguments are optional)
    $cache = Zend_Cache::factory($frontendName,
                                 $backendName,
                                 $frontendOptions,
                                 $backendOptions);
    

In the following examples we will assume that the ``$cache`` variable holds a valid, instantiated frontend as shown and that you understand how to pass parameters to your chosen backends.

.. note::
    ****

    Always use ``Zend_Cache::factory()`` to get frontend instances. Instantiating frontends and backends yourself will not work as expected.

.. _zend.cache.tags:

Tagging Records
---------------

Tags are a way to categorize cache records. When you save a cache with the ``save()`` method, you can set an array of tags to apply for this record. Then you will be able to clean all cache records tagged with a given tag (or tags):

.. code-block:: php
    :linenos:
    
    $cache->save($huge_data, 'myUniqueID', array('tagA', 'tagB', 'tagC'));
    

.. note::
    ****

    note than the ``save()`` method accepts an optional fourth argument: ``$specificLifetime`` (if != ``FALSE`` , it sets a specific lifetime for this particular cache record)

.. _zend.cache.clean:

Cleaning the Cache
------------------

To remove or invalidate in particular cache id, you can use the ``remove()`` method :

.. code-block:: php
    :linenos:
    
    $cache->remove('idToRemove');
    

To remove or invalidate several cache ids in one operation, you can use the ``clean()`` method. For example to remove all cache records :

.. code-block:: php
    :linenos:
    
    // clean all records
    $cache->clean(Zend_Cache::CLEANING_MODE_ALL);
    
    // clean only outdated
    $cache->clean(Zend_Cache::CLEANING_MODE_OLD);
    

If you want to remove cache entries matching the tags 'tagA' and 'tagC':

.. code-block:: php
    :linenos:
    
    $cache->clean(
        Zend_Cache::CLEANING_MODE_MATCHING_TAG,
        array('tagA', 'tagC')
    );
    

If you want to remove cache entries not matching the tags 'tagA' or 'tagC':

.. code-block:: php
    :linenos:
    
    $cache->clean(
        Zend_Cache::CLEANING_MODE_NOT_MATCHING_TAG,
        array('tagA', 'tagC')
    );
    

If you want to remove cache entries matching the tags 'tagA' or 'tagC':

.. code-block:: php
    :linenos:
    
    $cache->clean(
        Zend_Cache::CLEANING_MODE_MATCHING_ANY_TAG,
        array('tagA', 'tagC')
    );
    

Available cleaning modes are: ``CLEANING_MODE_ALL`` , ``CLEANING_MODE_OLD`` , ``CLEANING_MODE_MATCHING_TAG`` , ``CLEANING_MODE_NOT_MATCHING_TAG`` and ``CLEANING_MODE_MATCHING_ANY_TAG`` . The latter are, as their names suggest, combined with an array of tags in cleaning operations.


