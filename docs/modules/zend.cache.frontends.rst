
Zend_Cache Frontends
====================

.. _zend.cache.frontends.core:

Zend_Cache_Core
---------------

.. _zend.cache.frontends.core.introduction:

Introduction
------------

``Zend_Cache_Core`` is a special frontend because it is the core of the module. It is a generic cache frontend and is extended by other classes.

.. note::
    ****

    All frontends inherit from ``Zend_Cache_Core`` so that its methods and options (described below) would also be available in other frontends, therefore they won't be documented there.

.. _zend.cache.frontends.core.options:

Available options
-----------------

These options are passed to the factory method as demonstrated in previous examples.

.. _zend.cache.frontends.core.options.table:


Core Frontend Options
---------------------
+-------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Option                   |Data Type|Default Value|Description                                                                                                                                                                                                                                                                                                                       |
+=========================+=========+=============+==================================================================================================================================================================================================================================================================================================================================+
|caching                  |Boolean  |TRUE         |enable / disable caching (can be very useful for the debug of cached scripts)                                                                                                                                                                                                                                                     |
+-------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|cache_id_prefix          |String   |NULL         |A prefix for all cache ids, if set to NULL, no cache id prefix will be used. The cache id prefix essentially creates a namespace in the cache, allowing multiple applications or websites to use a shared cache. Each application or website can use a different cache id prefix so specific cache ids can be used more than once.|
+-------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|lifetime                 |Integer  |3600         |cache lifetime (in seconds), if set to NULL, the cache is valid forever.                                                                                                                                                                                                                                                          |
+-------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|logging                  |Boolean  |FALSE        |if set to TRUE, logging through Zend_Log is activated (but the system is slower)                                                                                                                                                                                                                                                  |
+-------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|write_control            |Boolean  |TRUE         |Enable / disable write control (the cache is read just after writing to detect corrupt entries), enabling write_control will lightly slow the cache writing but not the cache reading (it can detect some corrupt cache files but it's not a perfect control)                                                                     |
+-------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|automatic_serialization  |Boolean  |FALSE        |Enable / disable automatic serialization, it can be used to save directly datas which aren't strings (but it's slower)                                                                                                                                                                                                            |
+-------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|automatic_cleaning_factor|Integer  |10           |Disable / Tune the automatic cleaning process (garbage collector): 0 means no automatic cache cleaning, 1 means systematic cache cleaning and x > 1 means automatic random cleaning 1 times in x write operations.                                                                                                                |
+-------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|ignore_user_abort        |Boolean  |FALSE        |if set to TRUE, the core will set the ignore_user_abort PHP flag inside the save() method to avoid cache corruptions in some cases                                                                                                                                                                                                |
+-------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+


.. _zend.cache.core.examples:

Examples
--------

An example is given in the manual at the very beginning.

If you store only strings into cache (because with "automatic_serialization" option, it's possible to store some booleans), you can use a more compact construction like:

.. code-block:: php
    :linenos:
    
    // we assume you already have $cache
    
    $id = 'myBigLoop'; // cache id of "what we want to cache"
    
    if (!($data = $cache->load($id))) {
        // cache miss
    
        $data = '';
        for ($i = 0; $i < 10000; $i++) {
            $data = $data . $i;
        }
    
        $cache->save($data);
    
    }
    
    // [...] do something with $data (echo it, pass it on etc.)
    

If you want to cache multiple blocks or data instances, the idea is the same:

.. code-block:: php
    :linenos:
    
    // make sure you use unique identifiers:
    $id1 = 'foo';
    $id2 = 'bar';
    
    // block 1
    if (!($data = $cache->load($id1))) {
        // cache missed
    
        $data = '';
        for ($i=0;$i<10000;$i++) {
            $data = $data . $i;
        }
    
        $cache->save($data);
    
    }
    echo($data);
    
    // this isn't affected by caching
    echo('NEVER CACHED! ');
    
    // block 2
    if (!($data = $cache->load($id2))) {
        // cache missed
    
        $data = '';
        for ($i=0;$i<10000;$i++) {
            $data = $data . '!';
        }
    
        $cache->save($data);
    
    }
    echo($data);
    

If you want to cache special values (boolean with "automatic_serialization" option) or empty strings you can't use the compact construction given above. You have to test formally the cache record.

.. code-block:: php
    :linenos:
    
    // the compact construction
    // (not good if you cache empty strings and/or booleans)
    if (!($data = $cache->load($id))) {
    
        // cache missed
    
        // [...] we make $data
    
        $cache->save($data);
    
    }
    
    // we do something with $data
    
    // [...]
    
    // the complete construction (works in any case)
    if (!($cache->test($id))) {
    
        // cache missed
    
        // [...] we make $data
    
        $cache->save($data);
    
    } else {
    
        // cache hit
    
        $data = $cache->load($id);
    
    }
    
    // we do something with $data
    

.. _zend.cache.frontends.output:

Zend_Cache_Frontend_Output
--------------------------

.. _zend.cache.frontends.output.introduction:

Introduction
------------

``Zend_Cache_Frontend_Output`` is an output-capturing frontend. It utilizes output buffering in *PHP* to capture everything between its ``start()`` and ``end()`` methods.

.. _zend.cache.frontends.output.options:

Available Options
-----------------

This frontend doesn't have any specific options other than those of ``Zend_Cache_Core`` .

.. _zend.cache.frontends.output.examples:

Examples
--------

An example is given in the manual at the very beginning. Here it is with minor changes:

.. code-block:: php
    :linenos:
    
    // if it is a cache miss, output buffering is triggered
    if (!($cache->start('mypage'))) {
    
        // output everything as usual
        echo 'Hello world! ';
        echo 'This is cached ('.time().') ';
    
        $cache->end(); // output buffering ends
    
    }
    
    echo 'This is never cached ('.time().').';
    

Using this form it is fairly easy to set up output caching in your already working project with little or no code refactoring.

.. _zend.cache.frontends.function:

Zend_Cache_Frontend_Function
----------------------------

.. _zend.cache.frontends.function.introduction:

Introduction
------------

``Zend_Cache_Frontend_Function`` caches the results of function calls. It has a single main method named ``call()`` which takes a function name and parameters for the call in an array.

.. _zend.cache.frontends.function.options:

Available Options
-----------------

.. _zend.cache.frontends.function.options.table:


Function Frontend Options
-------------------------
+--------------------+---------+-------------+-------------------------------------------------+
|Option              |Data Type|Default Value|Description                                      |
+====================+=========+=============+=================================================+
|cache_by_default    |Boolean  |TRUE         |if TRUE, function calls will be cached by default|
+--------------------+---------+-------------+-------------------------------------------------+
|cached_functions    |Array    |             |function names which will always be cached       |
+--------------------+---------+-------------+-------------------------------------------------+
|non_cached_functions|Array    |             |function names which must never be cached        |
+--------------------+---------+-------------+-------------------------------------------------+


.. _zend.cache.frontends.function.examples:

Examples
--------

Using the ``call()`` function is the same as using ``call_user_func_array()`` in *PHP* :

.. code-block:: php
    :linenos:
    
    $cache->call('veryExpensiveFunc', $params);
    
    // $params is an array
    // For example to call veryExpensiveFunc(1, 'foo', 'bar') with
    // caching, you can use
    // $cache->call('veryExpensiveFunc', array(1, 'foo', 'bar'))
    

``Zend_Cache_Frontend_Function`` is smart enough to cache both the return value of the function and its internal output.

.. note::
    ****

    You can pass any built in or user defined function with the exception of ``array()`` , ``echo()`` , ``empty()`` , ``eval()`` , ``exit()`` , ``isset()`` , ``list()`` , ``print()`` and ``unset()`` .

.. _zend.cache.frontends.class:

Zend_Cache_Frontend_Class
-------------------------

.. _zend.cache.frontends.class.introduction:

Introduction
------------

``Zend_Cache_Frontend_Class`` is different from ``Zend_Cache_Frontend_Function`` because it allows caching of object and static method calls.

.. _zend.cache.frontends.class.options:

Available Options
-----------------

.. _zend.cache.frontends.class.options.table:


Class Frontend Options
----------------------
+------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|Option                  |Data Type|Default Value|Description                                                                                                                                   |
+========================+=========+=============+==============================================================================================================================================+
|cached_entity (required)|Mixed    |             |if set to a class name, we will cache an abstract class and will use only static calls; if set to an object, we will cache this object methods|
+------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|cache_by_default        |Boolean  |TRUE         |if TRUE, calls will be cached by default                                                                                                      |
+------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|cached_methods          |Array    |             |method names which will always be cached                                                                                                      |
+------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------+
|non_cached_methods      |Array    |             |method names which must never be cached                                                                                                       |
+------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------+


.. _zend.cache.frontends.class.examples:

Examples
--------

For example, to cache static calls :

.. code-block:: php
    :linenos:
    
    class Test {
    
        // Static method
        public static function foobar($param1, $param2) {
            echo "foobar_output($param1, $param2)";
            return "foobar_return($param1, $param2)";
        }
    
    }
    
    // [...]
    $frontendOptions = array(
        'cached_entity' => 'Test' // The name of the class
    );
    // [...]
    
    // The cached call
    $result = $cache->foobar('1', '2');
    

To cache classic method calls :

.. code-block:: php
    :linenos:
    
    class Test {
    
        private $_string = 'hello !';
    
        public function foobar2($param1, $param2) {
            echo($this->_string);
            echo "foobar2_output($param1, $param2)";
            return "foobar2_return($param1, $param2)";
        }
    
    }
    
    // [...]
    $frontendOptions = array(
        'cached_entity' => new Test() // An instance of the class
    );
    // [...]
    
    // The cached call
    $result = $cache->foobar2('1', '2');
    

.. _zend.cache.frontends.file:

Zend_Cache_Frontend_File
------------------------

.. _zend.cache.frontends.file.introduction:

Introduction
------------

``Zend_Cache_Frontend_File`` is a frontend driven by the modification time of a "master file". It's really interesting for examples in configuration or templates issues. It's also possible to use multiple master files.

For instance, you have an *XML* configuration file which is parsed by a function which returns a "config object" (like with ``Zend_Config`` ). With ``Zend_Cache_Frontend_File`` , you can store the "config object" into cache (to avoid the parsing of the *XML* config file at each time) but with a sort of strong dependency on the "master file". So, if the *XML* config file is modified, the cache is immediately invalidated.

.. _zend.cache.frontends.file.options:

Available Options
-----------------

.. _zend.cache.frontends.file.options.table:


File Frontend Options
---------------------
+---------------------------+---------+---------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Option                     |Data Type|Default Value                    |Description                                                                                                                                                                                                                                    |
+===========================+=========+=================================+===============================================================================================================================================================================================================================================+
|master_file (deprecated)   |String   |''                               |the complete path and name of the master file                                                                                                                                                                                                  |
+---------------------------+---------+---------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|master_files               |Array    |array()                          |an array of complete path of master files                                                                                                                                                                                                      |
+---------------------------+---------+---------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|master_files_mode          |String   |Zend_Cache_Frontend_File::MODE_OR|Zend_Cache_Frontend_File::MODE_AND or Zend_Cache_Frontend_File::MODE_OR ; if MODE_AND, then all master files have to be touched to get a cache invalidation if MODE_OR, then a single touched master file is enough to get a cache invalidation|
+---------------------------+---------+---------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|ignore_missing_master_files|Boolean  |FALSE                            |if TRUE, missing master files are ignored silently (an exception is raised else)                                                                                                                                                               |
+---------------------------+---------+---------------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+


.. _zend.cache.frontends.file.examples:

Examples
--------

Use of this frontend is the same than of ``Zend_Cache_Core`` . There is no need of a specific example - the only thing to do is to define themaster_filewhen using the factory.

.. _zend.cache.frontends.page:

Zend_Cache_Frontend_Page
------------------------

.. _zend.cache.frontends.page.introduction:

Introduction
------------

``Zend_Cache_Frontend_Page`` is like ``Zend_Cache_Frontend_Output`` but designed for a complete page. It's impossible to use ``Zend_Cache_Frontend_Page`` for caching only a single block.

On the other hand, the "cache id" is calculated automatically with ``$_SERVER['REQUEST_URI']`` and (depending on options) ``$_GET`` , ``$_POST`` , ``$_SESSION`` , ``$_COOKIE`` , ``$_FILES`` . More over, you have only one method to call ( ``start()`` ) because the ``end()`` call is fully automatic when the page is ended.

For the moment, it's not implemented but we plan to add a *HTTP* conditional system to save bandwidth (the system will send a *HTTP* 304 Not Modified if the cache is hit and if the browser has already the good version).

.. note::
    ****

    This frontend operates by registering a callback function to be called when the output buffering it uses is cleaned. In order for this to operate correctly, it must be the final output buffer in the request. To guarantee this, the output buffering used by the Dispatchermustbe disabled by calling ``Zend_Controller_Front`` 's ``setParam()`` method, for example, ``$front->setParam('disableOutputBuffering', true);`` or adding "resources.frontcontroller.params.disableOutputBuffering = true" to your bootstrap configuration file (assumed *INI* ) if using ``Zend_Application`` .

.. _zend.cache.frontends.page.options:

Available Options
-----------------

.. _zend.cache.frontends.page.options.table:


Page Frontend Options
---------------------
+----------------+---------+----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|Option          |Data Type|Default Value         |Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
+================+=========+======================+=================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
|http_conditional|Boolean  |FALSE                 |use the http_conditional system (not implemented for the moment)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
+----------------+---------+----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|debug_header    |Boolean  |FALSE                 |if TRUE, a debug text is added before each cached pages                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
+----------------+---------+----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|default_options |Array    |array(...see below...)|an associative array of default options: (boolean, TRUE by default) cache: cache is on if TRUE(boolean, FALSE by default) cache_with_get_variables: if TRUE, cache is still on even if there are some variables in $_GET array (boolean, FALSE by default) cache_with_post_variables: if TRUE, cache is still on even if there are some variables in $_POST array (boolean, FALSE by default) cache_with_session_variables: if TRUE, cache is still on even if there are some variables in $_SESSION array (boolean, FALSE by default) cache_with_files_variables: if TRUE, cache is still on even if there are some variables in $_FILES array (boolean, FALSE by default) cache_with_cookie_variables: if TRUE, cache is still on even if there are some variables in $_COOKIE array (boolean, TRUE by default) make_id_with_get_variables: if TRUE, the cache id will be dependent of the content of the $_GET array (boolean, TRUE by default) make_id_with_post_variables: if TRUE, the cache id will be dependent of the content of the $_POST array (boolean, TRUE by default) make_id_with_session_variables: if TRUE, the cache id will be dependent of the content of the $_SESSION array (boolean, TRUE by default) make_id_with_files_variables: if TRUE, the cache id will be dependent of the content of the $_FILES array (boolean, TRUE by default) make_id_with_cookie_variables: if TRUE, the cache id will be dependent of the content of the $_COOKIE array (int, FALSE by default) specific_lifetime: if not FALSE, the given lifetime will be used for the chosen regexp (array, array() by default) tags: tags for the cache record (int, NULL by default) priority: priority (if the backend supports it)|
+----------------+---------+----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|regexps         |Array    |array()               |an associative array to set options only for some REQUEST_URI, keys are (PCRE) regexps, values are associative arrays with specific options to set if the regexp matchs on $_SERVER['REQUEST_URI'] (see default_options for the list of available options); if several regexps match the $_SERVER['REQUEST_URI'], only the last one will be used                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
+----------------+---------+----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
|memorize_headers|Array    |array()               |an array of strings corresponding to some HTTP headers name. Listed headers will be stored with cache datas and "replayed" when the cache is hit                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
+----------------+---------+----------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+


.. _zend.cache.frontends.page.examples:

Examples
--------

Use of ``Zend_Cache_Frontend_Page`` is really trivial:

.. code-block:: php
    :linenos:
    
    // [...] // require, configuration and factory
    
    $cache->start();
    // if the cache is hit, the result is sent to the browser
    // and the script stop here
    
    // rest of the page ...
    

a more complex example which shows a way to get a centralized cache management in a bootstrap file (for using with ``Zend_Controller`` for example)

.. code-block:: php
    :linenos:
    
    /*
     * You should avoid putting too many lines before the cache section.
     * For example, for optimal performances, "require_once" or
     * "Zend_Loader::loadClass" should be after the cache section.
     */
    
    $frontendOptions = array(
       'lifetime' => 7200,
       'debug_header' => true, // for debugging
       'regexps' => array(
           // cache the whole IndexController
           '^/$' => array('cache' => true),
    
           // cache the whole IndexController
           '^/index/' => array('cache' => true),
    
           // we don't cache the ArticleController...
           '^/article/' => array('cache' => false),
    
           // ... but we cache the "view" action of this ArticleController
           '^/article/view/' => array(
               'cache' => true,
    
               // and we cache even there are some variables in $_POST
               'cache_with_post_variables' => true,
    
               // but the cache will be dependent on the $_POST array
               'make_id_with_post_variables' => true
           )
       )
    );
    
    $backendOptions = array(
        'cache_dir' => '/tmp/'
    );
    
    // getting a Zend_Cache_Frontend_Page object
    $cache = Zend_Cache::factory('Page',
                                 'File',
                                 $frontendOptions,
                                 $backendOptions);
    
    $cache->start();
    // if the cache is hit, the result is sent to the browser and the
    // script stop here
    
    // [...] the end of the bootstrap file
    // these lines won't be executed if the cache is hit
    

.. _zend.cache.frontends.page.cancel:

The Specific Cancel Method
--------------------------

Because of design issues, in some cases (for example when using non *HTTP* 200 return codes), you could need to cancel the current cache process. So we introduce for this particular frontend, the ``cancel()`` method.

.. code-block:: php
    :linenos:
    
    // [...] // require, configuration and factory
    
    $cache->start();
    
    // [...]
    
    if ($someTest) {
        $cache->cancel();
        // [...]
    }
    
    // [...]
    

.. _zend.cache.frontends.capture:

Zend_Cache_Frontend_Capture
---------------------------

.. _zend.cache.frontends.capture.introduction:

Introduction
------------

``Zend_Cache_Frontend_Capture`` is like ``Zend_Cache_Frontend_Output`` but designed for a complete page. It's impossible to use ``Zend_Cache_Frontend_Capture`` for caching only a single block. This class is specifically designed to operate in concert only with the ``Zend_Cache_Backend_Static`` backend to assist in caching entire pages of *HTML* / *XML* or other content to a physical static file on the local filesystem.

Please refer to the documentation on ``Zend_Cache_Backend_Static`` for all use cases pertaining to this class.

.. note::
    ****

    This frontend operates by registering a callback function to be called when the output buffering it uses is cleaned. In order for this to operate correctly, it must be the final output buffer in the request. To guarantee this, the output buffering used by the Dispatchermustbe disabled by calling ``Zend_Controller_Front`` 's ``setParam()`` method, for example, ``$front->setParam('disableOutputBuffering', true);`` or adding "resources.frontcontroller.params.disableOutputBuffering = true" to your bootstrap configuration file (assumed *INI* ) if using ``Zend_Application`` .


