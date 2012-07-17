
.. _zend.cache.introduction:

Introduction
============

``Zend_Cache`` provides a generic way to cache any data.

Caching in Zend Framework is operated by frontends while cache records are stored through backend adapters (**File**, **Sqlite**, **Memcache**...) through a flexible system of IDs and tags. Using those, it is easy to delete specific types of records afterwards (for example: "delete all cache records marked with a given tag").

The core of the module (``Zend_Cache_Core``) is generic, flexible and configurable. Yet, for your specific needs there are cache frontends that extend ``Zend_Cache_Core`` for convenience: **Output**, **File**, **Function** and **Class**.


.. _zend.cache.introduction.example-1:

.. rubric:: Getting a Frontend with Zend_Cache::factory()

``Zend_Cache::factory()`` instantiates correct objects and ties them together. In this first example, we will use **Core** frontend together with **File** backend.

.. code-block:: php
   :linenos:

   $frontendOptions = array(
      'lifetime' => 7200, // cache lifetime of 2 hours
      'automatic_serialization' => true
   );

   $backendOptions = array(
       'cache_dir' => './tmp/' // Directory where to put the cache files
   );

   // getting a Zend_Cache_Core object
   $cache = Zend_Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

.. note::
   **Frontends and Backends Consisting of Multiple Words**

   Some frontends and backends are named using multiple words, such as 'ZendPlatform'. When specifying them to the factory, separate them using a word separator, such as a space (' '), hyphen ('-'), or period ('.').



.. _zend.cache.introduction.example-2:

.. rubric:: Caching a Database Query Result

Now that we have a frontend, we can cache any type of data (we turned on serialization). for example, we can cache a result from a very expensive database query. After it is cached, there is no need to even connect to the database; records are fetched from cache and unserialized.

.. code-block:: php
   :linenos:

   // $cache initialized in previous example

   // see if a cache already exists:
   if(!$result = $cache->load('myresult')) {

       // cache miss; connect to the database

       $db = Zend_Db::factory( [...] );

       $result = $db->fetchAll('SELECT * FROM huge_table');

       $cache->save($result, 'myresult');

   } else {

       // cache hit! shout so that we know
       echo "This one is from cache!\n\n";

   }

   print_r($result);


.. _zend.cache.introduction.example-3:

.. rubric:: Caching Output with Zend_Cache Output Frontend

We 'mark up' sections in which we want to cache output by adding some conditional logic, encapsulating the section within ``start()`` and ``end()`` methods (this resembles the first example and is the core strategy for caching).

Inside, output your data as usual - all output will be cached when execution hits the ``end()`` method. On the next run, the whole section will be skipped in favor of fetching data from cache (as long as the cache record is valid).

.. code-block:: php
   :linenos:

   $frontendOptions = array(
      'lifetime' => 30,                   // cache lifetime of 30 seconds
      'automatic_serialization' => false  // this is the default anyways
   );

   $backendOptions = array('cache_dir' => './tmp/');

   $cache = Zend_Cache::factory('Output',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   // we pass a unique identifier to the start() method
   if(!$cache->start('mypage')) {
       // output as usual:

       echo 'Hello world! ';
       echo 'This is cached ('.time().') ';

       $cache->end(); // the output is saved and sent to the browser
   }

   echo 'This is never cached ('.time().').';

Notice that we output the result of ``time()`` twice; this is something dynamic for demonstration purposes. Try running this and then refreshing several times; you will notice that the first number doesn't change while second changes as time passes. That is because the first number was output in the cached section and is saved among other output. After half a minute (we've set lifetime to 30 seconds) the numbers should match again because the cache record expired -- only to be cached again. You should try this in your browser or console.

.. note::
   When using ``Zend_Cache``, pay attention to the important cache identifier (passed to ``save()`` and ``start()``). It must be unique for every resource you cache, otherwise unrelated cache records may wipe each other or, even worse, be displayed in place of the other.



