.. _zend.cache.backends:

Zend_Cache Backends
===================

There are two kinds of backends: standard ones and extended ones. Of course, extended backends offer more features.

.. _zend.cache.backends.file:

Zend_Cache_Backend_File
-----------------------

This (extended) backends stores cache records into files (in a chosen directory).

Available options are :

.. _zend.cache.backends.file.table:

.. table:: File Backend Options

   +--------------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                    |Data Type|Default Value|Description                                                                                                                                                                                                                                                                                                                     |
   +==========================+=========+=============+================================================================================================================================================================================================================================================================================================================================+
   |cache_dir                 |String   |'/tmp/'      |Directory where to store cache files                                                                                                                                                                                                                                                                                            |
   +--------------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file_locking              |Boolean  |TRUE         |Enable or disable file_locking : Can avoid cache corruption under bad circumstances but it doesn't help on multithread webservers or on NFS filesystems...                                                                                                                                                                      |
   +--------------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |read_control              |Boolean  |TRUE         |Enable / disable read control : if enabled, a control key is embedded in the cache file and this key is compared with the one calculated after the reading.                                                                                                                                                                     |
   +--------------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |read_control_type         |String   |'crc32'      |Type of read control (only if read control is enabled). Available values are : 'md5' (best but slowest), 'crc32' (lightly less safe but faster, better choice), 'adler32' (new choice, faster than crc32), 'strlen' for a length only test (fastest).                                                                           |
   +--------------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hashed_directory_level    |Integer  |0            |Hashed directory structure level : 0 means "no hashed directory structure", 1 means "one level of directory", 2 means "two levels"... This option can speed up the cache only when you have many thousands of cache files. Only specific benchs can help you to choose the perfect value for you. Maybe, 1 or 2 is a good start.|
   +--------------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hashed_directory_umask    |Integer  |0700         |Umask for the hashed directory structure                                                                                                                                                                                                                                                                                        |
   +--------------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file_name_prefix          |String   |'zend_cache' |prefix for cache files ; be really careful with this option because a too generic value in a system cache dir (like /tmp) can cause disasters when cleaning the cache                                                                                                                                                           |
   +--------------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_file_umask          |Integer  |0700         |umask for cache files                                                                                                                                                                                                                                                                                                           |
   +--------------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |metatadatas_array_max_size|Integer  |100          |internal max size for the metadatas array (don't change this value unless you know what you are doing)                                                                                                                                                                                                                          |
   +--------------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.sqlite:

Zend_Cache_Backend_Sqlite
-------------------------

This (extended) backends stores cache records into a SQLite database.

Available options are :

.. _zend.cache.backends.sqlite.table:

.. table:: Sqlite Backend Options

   +----------------------------------+---------+-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                            |Data Type|Default Value|Description                                                                                                                                                                                                                                                                                                                                              |
   +==================================+=========+=============+=========================================================================================================================================================================================================================================================================================================================================================+
   |cache_db_complete_path (mandatory)|String   |NULL         |The complete path (filename included) of the SQLite database                                                                                                                                                                                                                                                                                             |
   +----------------------------------+---------+-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automatic_vacuum_factor           |Integer  |10           |Disable / Tune the automatic vacuum process. The automatic vacuum process defragment the database file (and make it smaller) when a clean() or delete() is called: 0 means no automatic vacuum ; 1 means systematic vacuum (when delete() or clean() methods are called) ; x (integer) > 1 => automatic vacuum randomly 1 times on x clean() or delete().|
   +----------------------------------+---------+-------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.memcached:

Zend_Cache_Backend_Memcached
----------------------------

This (extended) backends stores cache records into a memcached server. `memcached`_ is a high-performance, distributed memory object caching system. To use this backend, you need a memcached daemon and `the memcache PECL extension`_.

Be careful : with this backend, "tags" are not supported for the moment as the "doNotTestCacheValidity=true" argument.

Available options are :

.. _zend.cache.backends.memcached.table:

.. table:: Memcached Backend Options

   +-------------+---------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option       |Data Type|Default Value                                                                                                                                                                 |Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
   +=============+=========+==============================================================================================================================================================================+===========================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
   |servers      |Array    |array(array('host' => 'localhost', 'port' => 11211, 'persistent' => true, 'weight' => 1, 'timeout' => 5, 'retry_interval' => 15, 'status' => true, 'failure_callback' => '' ))|An array of memcached servers ; each memcached server is described by an associative array : 'host' => (string) : the name of the memcached server, 'port' => (int) : the port of the memcached server, 'persistent' => (bool) : use or not persistent connections to this memcached server 'weight' => (int) :the weight of the memcached server, 'timeout' => (int) :the time out of the memcached server, 'retry_interval' => (int) :the retry interval of the memcached server, 'status' => (bool) :the status of the memcached server, 'failure_callback' => (callback) : the failure_callback of the memcached server|
   +-------------+---------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |compression  |Boolean  |FALSE                                                                                                                                                                         |TRUE if you want to use on-the-fly compression                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
   +-------------+---------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |compatibility|Boolean  |FALSE                                                                                                                                                                         |TRUE if you want to use this compatibility mode with old memcache servers or extensions                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
   +-------------+---------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.apc:

Zend_Cache_Backend_Apc
----------------------

This (extended) backends stores cache records in shared memory through the `APC`_ (Alternative *PHP* Cache) extension (which is of course need for using this backend).

Be careful : with this backend, "tags" are not supported for the moment as the "doNotTestCacheValidity=true" argument.

There is no option for this backend.

.. _zend.cache.backends.xcache:

Zend_Cache_Backend_Xcache
-------------------------

This backends stores cache records in shared memory through the `XCache`_ extension (which is of course need for using this backend).

Be careful : with this backend, "tags" are not supported for the moment as the "doNotTestCacheValidity=true" argument.

Available options are :

.. _zend.cache.backends.xcache.table:

.. table:: Xcache Backend Options

   +--------+---------+-------------+----------------------------------------------------------------------------+
   |Option  |Data Type|Default Value|Description                                                                 |
   +========+=========+=============+============================================================================+
   |user    |String   |NULL         |xcache.admin.user, necessary for the clean() method                         |
   +--------+---------+-------------+----------------------------------------------------------------------------+
   |password|String   |NULL         |xcache.admin.pass (in clear form, not MD5), necessary for the clean() method|
   +--------+---------+-------------+----------------------------------------------------------------------------+

.. _zend.cache.backends.platform:

Zend_Cache_Backend_ZendPlatform
-------------------------------

This backend uses content caching *API* of the `Zend Platform`_ product. Naturally, to use this backend you need to have Zend Platform installed.

This backend supports tags, but does not support ``CLEANING_MODE_NOT_MATCHING_TAG`` cleaning mode.

Specify this backend using a word separator -- '-', '.', ' ', or '\_' -- between the words 'Zend' and 'Platform' when using the ``Zend_Cache::factory()`` method:

.. code-block:: php
   :linenos:

   $cache = Zend_Cache::factory('Core', 'Zend Platform');

There are no options for this backend.

.. _zend.cache.backends.twolevels:

Zend_Cache_Backend_TwoLevels
----------------------------

This (extend) backend is an hybrid one. It stores cache records in two other backends : a fast one (but limited) like Apc, Memcache... and a "slow" one like File, Sqlite...

This backend will use the priority parameter (given at the frontend level when storing a record) and the remaining space in the fast backend to optimize the usage of these two backends.

Specify this backend using a word separator -- '-', '.', ' ', or '\_' -- between the words 'Two' and 'Levels' when using the ``Zend_Cache::factory()`` method:

.. code-block:: php
   :linenos:

   $cache = Zend_Cache::factory('Core', 'Two Levels');

Available options are :

.. _zend.cache.backends.twolevels.table:

.. table:: TwoLevels Backend Options

   +--------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                    |Data Type|Default Value|Description                                                                                                                                                                                   |
   +==========================+=========+=============+==============================================================================================================================================================================================+
   |slow_backend              |String   |File         |the "slow" backend name                                                                                                                                                                       |
   +--------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend              |String   |Apc          |the "fast" backend name                                                                                                                                                                       |
   +--------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |slow_backend_options      |Array    |array()      |the "slow" backend options                                                                                                                                                                    |
   +--------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend_options      |Array    |array()      |the "fast" backend options                                                                                                                                                                    |
   +--------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |slow_backend_custom_naming|Boolean  |FALSE        |if TRUE, the slow_backend argument is used as a complete class name; if FALSE, the frontend argument is used as the end of "Zend_Cache_Backend_[...]" class name                              |
   +--------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend_custom_naming|Boolean  |FALSE        |if TRUE, the fast_backend argument is used as a complete class name; if FALSE, the frontend argument is used as the end of "Zend_Cache_Backend_[...]" class name                              |
   +--------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |slow_backend_autoload     |Boolean  |FALSE        |if TRUE, there will no require_once for the slow backend (useful only for custom backends)                                                                                                    |
   +--------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend_autoload     |Boolean  |FALSE        |if TRUE, there will no require_once for the fast backend (useful only for custom backends)                                                                                                    |
   +--------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |auto_refresh_fast_cache   |Boolean  |TRUE         |if TRUE, auto refresh the fast cache when a cache record is hit                                                                                                                               |
   +--------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |stats_update_factor       |Integer  |10           |disable / tune the computation of the fast backend filling percentage (when saving a record into cache, computation of the fast backend filling percentage randomly 1 times on x cache writes)|
   +--------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.zendserver:

Zend_Cache_Backend_ZendServer_Disk and Zend_Cache_Backend_ZendServer_ShMem
--------------------------------------------------------------------------

These backends store cache records using `Zend Server`_ caching functionality.

Be careful: with these backends, "tags" are not supported for the moment as the "doNotTestCacheValidity=true" argument.

These backend work only withing Zend Server environment for pages requested through *HTTP* or *HTTPS* and don't work for command line script execution

Specify this backend using parameter **customBackendNaming** as ``TRUE`` when using the ``Zend_Cache::factory()`` method:

.. code-block:: php
   :linenos:

   $cache = Zend_Cache::factory('Core', 'Zend_Cache_Backend_ZendServer_Disk',
                                $frontendOptions, $backendOptions, false, true);

There is no option for this backend.

.. _zend.cache.backends.static:

Zend_Cache_Backend_Static
-------------------------

This backend works in concert with ``Zend_Cache_Frontend_Capture`` (the two must be used together) to save the output from requests as static files. This means the static files are served directly on subsequent requests without any involvement of *PHP* or Zend Framework at all.

.. note::

   ``Zend_Cache_Frontend_Capture`` operates by registering a callback function to be called when the output buffering it uses is cleaned. In order for this to operate correctly, it must be the final output buffer in the request. To guarantee this, the output buffering used by the Dispatcher **must** be disabled by calling ``Zend_Controller_Front``'s ``setParam()`` method, for example, ``$front->setParam('disableOutputBuffering', true);`` or adding "resources.frontcontroller.params.disableOutputBuffering = true" to your bootstrap configuration file (assumed *INI*) if using ``Zend_Application``.

The benefits of this cache include a large throughput increase since all subsequent requests return the static file and don't need any dynamic processing. Of course this also has some disadvantages. The only way to retry the dynamic request is to purge the cached file from elsewhere in the application (or via a cronjob if timed). It is also restricted to single-server applications where only one filesystem is used. Nevertheless, it can be a powerful means of getting more performance without incurring the cost of a proxy on single machines.

Before describing its options, you should note this needs some changes to the default ``.htaccess`` file in order for requests to be directed to the static files if they exist. Here's an example of a simple application caching some content, including two specific feeds which need additional treatment to serve a correct Content-Type header:

.. code-block:: text
   :linenos:

   AddType application/rss+xml .xml
   AddType application/atom+xml .xml

   RewriteEngine On

   RewriteCond %{REQUEST_URI} feed/rss$
   RewriteCond %{DOCUMENT_ROOT}/cached/%{REQUEST_URI}.xml -f
   RewriteRule .* cached/%{REQUEST_URI}.xml [L,T=application/rss+xml]

   RewriteCond %{REQUEST_URI} feed/atom$
   RewriteCond %{DOCUMENT_ROOT}/cached/%{REQUEST_URI}.xml -f
   RewriteRule .* cached/%{REQUEST_URI}.xml [L,T=application/atom+xml]

   RewriteCond %{DOCUMENT_ROOT}/cached/index.html -f
   RewriteRule ^/*$ cached/index.html [L]
   RewriteCond %{DOCUMENT_ROOT}/cached/%{REQUEST_URI}.(html|xml|json|opml|svg) -f
   RewriteRule .* cached/%{REQUEST_URI}.%1 [L]

   RewriteCond %{REQUEST_FILENAME} -s [OR]
   RewriteCond %{REQUEST_FILENAME} -l [OR]
   RewriteCond %{REQUEST_FILENAME} -d
   RewriteRule ^.*$ - [NC,L]

   RewriteRule ^.*$ index.php [NC,L]

The above assumes static files are cached to the directory ``./public/cached``. We'll cover the option setting this location, "public_dir", below.

Due to the nature of static file caching, the backend class offers two additional methods: ``remove()`` and ``removeRecursively()``. Both accept a request *URI*, which when mapped to the "public_dir" where static files are cached, and has a pre-stored extension appended, provides the name of either a static file to delete, or a directory path to delete recursively. Due to the restraints of ``Zend_Cache_Backend_Interface``, all other methods such as ``save()`` accept an ID which is calculated by applying ``bin2hex()`` to a request *URI*.

Given the level at which static caching operates, static file caching is addressed for simpler use with the ``Zend_Controller_Action_Helper_Cache`` action helper. This helper assists in setting which actions of a controller to cache, with what tags, and with which extension. It also offers methods for purging the cache by request *URI* or tag. Static file caching is also assisted by ``Zend_Cache_Manager`` which includes pre-configured configuration templates for a static cache (as ``Zend_Cache_Manager::PAGECACHE`` or "page"). The defaults therein can be configured as needed to set up a "public_dir" location for caching, etc.

.. note::

   It should be noted that the static cache actually uses a secondary cache to store tags (obviously we can't store them elsewhere since a static cache does not invoke *PHP* if working correctly). This is just a standard Core cache, and should use a persistent backend such as File or TwoLevels (to take advantage of memory storage without sacrificing permanent persistance). The backend includes the option "tag_cache" to set this up (it is obligatory), or the ``setInnerCache()`` method.

.. _zend.cache.backends.static.table:

.. table:: Static Backend Options

   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option               |Data Type|Default Value|Description                                                                                                                                                                                                                                                                                             |
   +=====================+=========+=============+========================================================================================================================================================================================================================================================================================================+
   |public_dir           |String   |NULL         |Directory where to store static files. This must exist in your public directory.                                                                                                                                                                                                                        |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file_locking         |Boolean  |TRUE         |Enable or disable file_locking : Can avoid cache corruption under bad circumstances but it doesn't help on multithread webservers or on NFS filesystems...                                                                                                                                              |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |read_control         |Boolean  |TRUE         |Enable / disable read control : if enabled, a control key is embedded in the cache file and this key is compared with the one calculated after the reading.                                                                                                                                             |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |read_control_type    |String   |'crc32'      |Type of read control (only if read control is enabled). Available values are : 'md5' (best but slowest), 'crc32' (lightly less safe but faster, better choice), 'adler32' (new choice, faster than crc32), 'strlen' for a length only test (fastest).                                                   |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_file_umask     |Integer  |0700         |umask for cached files.                                                                                                                                                                                                                                                                                 |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_directory_umask|Integer  |0700         |Umask for directories created within public_dir.                                                                                                                                                                                                                                                        |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file_extension       |String   |'.html'      |Default file extension for static files created. This can be configured on the fly, see Zend_Cache_Backend_Static::save() though generally it's recommended to rely on Zend_Controller_Action_Helper_Cache when doing so since it's simpler that way than messing with arrays or serialization manually.|
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |index_filename       |String   |'index'      |If a request URI does not contain sufficient information to construct a static file (usually this means an index call, e.g. URI of '/'), the index_filename is used instead. So '' or '/' would map to 'index.html' (assuming the default file_extension is '.html').                                   |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |tag_cache            |Object   |NULL         |Used to set an 'inner' cache utilised to store tags and file extensions associated with static files. This must be set or the static cache cannot be tracked and managed.                                                                                                                               |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |disable_caching      |Boolean  |FALSE        |If set to TRUE, static files will not be cached. This will force all requests to be dynamic even if marked to be cached in Controllers. Useful for debugging.                                                                                                                                           |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _`memcached`: http://www.danga.com/memcached/
.. _`the memcache PECL extension`: http://pecl.php.net/package/memcache
.. _`APC`: http://pecl.php.net/package/APC
.. _`XCache`: http://xcache.lighttpd.net/
.. _`Zend Platform`: http://www.zend.com/en/products/platform/
.. _`Zend Server`: http://www.zend.com/en/products/server/downloads-all?zfs=zf_download
