.. EN-Revision: none
.. _zend.cache.frontends:

Zend_Cache前端
============

.. _zend.cache.frontends.core:

Zend_Cache_Core
---------------

.. _zend.cache.frontends.core.introduction:

简介
^^

*Zend_Cache_Core*\ 是一个特别的前端,因为他是模块的核心.
它是一个一般化(generic)的缓存前端,并且由其他类扩展.

.. note::

   所有的前端继承自 *Zend_Cache_Core*\
   因此它的方法和选项(描述如下)应该在其他的前端中可用,所以这里没有进行文档化.

.. _zend.cache.frontends.core.options:

可用选项
^^^^

这些选项被传递给如前面例子中演示的工厂方法.

.. _zend.cache.frontends.core.options.table:

.. table:: 核心前端选项

   +-------------------------+-------+-----+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |选项                       |数据类型   |默认值  |描述                                                                                                                                                                       |
   +=========================+=======+=====+=========================================================================================================================================================================+
   |caching                  |boolean|true |打开 / 关闭缓存 (对被缓存脚本的调试非常有用)                                                                                                                                                |
   +-------------------------+-------+-----+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_id_prefix          |string |null |所有缓存 id 的前缀，如果设置为 null ，没有缓存 id 前缀使用。 缓存 id 前缀在缓存里创建一个命名空间，允许多个程序和网上共享缓存。 每个程序或网站可以使用不同的缓存 id 前缀，所以特定的缓存 id 可以使用多次。                                                      |
   +-------------------------+-------+-----+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |lifetime                 |int    |3600 |缓存生命期(秒), 如果设置为 null, 缓存永远有效.                                                                                                                                            |
   +-------------------------+-------+-----+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |logging                  |boolean|false|如果设置为true,日志纪录(通过使用Zend_Log)被激活(但是系统将变慢)                                                                                                                                 |
   +-------------------------+-------+-----+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |write_control            |boolean|true |打开 / 关闭 写控制 （the cache is read just after writing to detect corrupt entries），打开写控制轻微地放慢缓存写的速度但不影响读（it can detect some corrupt cache files but it's not a perfect control）|
   +-------------------------+-------+-----+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automatic_serialization  |boolean|false|打开 / 关闭自动序列化, 可以直接用于保存非字符串数据(但是很慢)                                                                                                                                       |
   +-------------------------+-------+-----+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automatic_cleaning_factor|int    |10   |关闭 / 调整自动清理过程 (垃圾收集器): 0 表示不自动清理缓存,1 表示自动清理缓存,并且如果x > 1 表示x写操作后自动随机清理1次.                                                                                                 |
   +-------------------------+-------+-----+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |ignore_user_abort        |boolean|false|如果设置为 true，核心将在 save() 方法里设置 ignore_user_abort PHP flag，以免在某些情况下缓存崩溃。                                                                                                    |
   +-------------------------+-------+-----+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.core.examples:

例子
^^

An example is given in the manual at the very beginning.

如果你只向缓存中存储字符串(由于"automatic_serialization"选项,可能会存储一些布尔值),你可以使用更加简介的构造:

.. code-block:: php
   :linenos:

   // 假定你已经有 $cache

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


如果你缓存多个块或则数据实例,意思是一样的:

.. code-block:: php
   :linenos:

   // 确保使用独一无二的 identifiers:
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


如果你想缓存特殊值（带 "automatic_serialization"
选项的布尔值）或不能用上述紧缩结构的空字符串，你需要正式地测试缓存记录。

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

简介
^^

*Zend_Cache_Frontend_Output* 是一个输出捕捉前端.它在PHP中使用输出缓冲捕获 *start()* 和 *end()*
方法间的一切输出.

.. _zend.cache.frontends.output.options:

可用的选项
^^^^^

该前端除了 *Zend_Cache_Core*\ 那些选项外没有任何特定的选项.

.. _zend.cache.frontends.output.examples:

例子
^^

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


Using this form it is fairly easy to set up output caching in your already working project with little or no code
refactoring.

.. _zend.cache.frontends.function:

Zend_Cache_Frontend_Function
----------------------------

.. _zend.cache.frontends.function.introduction:

Introduction
^^^^^^^^^^^^

*Zend_Cache_Frontend_Function* caches the results of function calls. It has a single main method named *call()*
which takes a function name and parameters for the call in an array.

.. _zend.cache.frontends.function.options:

A可用的选项
^^^^^^

.. _zend.cache.frontends.function.options.table:

.. table:: 函数前端选项

   +--------------------+-------+----+-----------------------+
   |选项                  |数据类型   |默认值 |描述                     |
   +====================+=======+====+=======================+
   |cache_by_default    |boolean|true|如果为true,默认情况下,函数调用将被缓存.|
   +--------------------+-------+----+-----------------------+
   |cached_functions    |array  |    |函数名称总是被缓存              |
   +--------------------+-------+----+-----------------------+
   |non_cached_functions|array  |    |决不缓存函数名称               |
   +--------------------+-------+----+-----------------------+

.. _zend.cache.frontends.function.examples:

例子
^^

在PHP中使用 *call()* 函数于使用 *call_user_func_array()*\ 相同:

.. code-block:: php
   :linenos:

   $cache->call('veryExpensiveFunc', $params);

   // $params is an array
   // For example to call veryExpensiveFunc(1, 'foo', 'bar') with
   // caching, you can use
   // $cache->call('veryExpensiveFunc', array(1, 'foo', 'bar'))


*Zend_Cache_Frontend_Function* is smart enough to cache both the return value of the function and its internal
output.

.. note::

   You can pass any built in or user defined function with the exception of *array()*, *echo()*, *empty()*,
   *eval()*, *exit()*, *isset()*, *list()*, *print()* and *unset()*.

.. _zend.cache.frontends.class:

Zend_Cache_Frontend_Class
-------------------------

.. _zend.cache.frontends.class.introduction:

Introduction
^^^^^^^^^^^^

*Zend_Cache_Frontend_Class* is different from *Zend_Cache_Frontend_Function* because it allows caching of object
and static method calls.

.. _zend.cache.frontends.class.options:

Available options
^^^^^^^^^^^^^^^^^

.. _zend.cache.frontends.class.options.table:

.. table:: Class frontend options

   +------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                  |Data Type|Default Value|Description                                                                                                                                   |
   +========================+=========+=============+==============================================================================================================================================+
   |cached_entity (required)|mixed    |             |if set to a class name, we will cache an abstract class and will use only static calls; if set to an object, we will cache this object methods|
   +------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_by_default        |boolean  |true         |if true, calls will be cached by default                                                                                                      |
   +------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------+
   |cached_methods          |array    |             |method names which will always be cached                                                                                                      |
   +------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------+
   |non_cached_methods      |array    |             |method names which must never be cached                                                                                                       |
   +------------------------+---------+-------------+----------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.frontends.class.examples:

Examples
^^^^^^^^

For example, to cache static calls :

.. code-block:: php
   :linenos:

   class test {

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
^^^^^^^^^^^^

*Zend_Cache_Frontend_File* is a frontend driven by the modification time of a "master file". It's really
interesting for examples in configuration or templates issues.

For instance, you have an XML configuration file which is parsed by a function which returns a "config object"
(like with *Zend_Config*). With *Zend_Cache_Frontend_File*, you can store the "config object" into cache (to avoid
the parsing of the XML config file at each time) but with a sort of strong dependency on the "master file". So, if
the XML config file is modified, the cache is immediately invalidated.

.. _zend.cache.frontends.file.options:

Available options
^^^^^^^^^^^^^^^^^

.. _zend.cache.frontends.file.options.table:

.. table:: File frontend options

   +-----------------------+---------+-------------+---------------------------------------------+
   |Option                 |Data Type|Default Value|Description                                  |
   +=======================+=========+=============+=============================================+
   |master_file (mandatory)|string   |             |the complete path and name of the master file|
   +-----------------------+---------+-------------+---------------------------------------------+

.. _zend.cache.frontends.file.examples:

Examples
^^^^^^^^

Use of this frontend is the same than of *Zend_Cache_Core*. There is no need of a specific example - the only thing
to do is to define the *master_file* when using the factory.

.. _zend.cache.frontends.page:

Zend_Cache_Frontend_Page
------------------------

.. _zend.cache.frontends.page.introduction:

Introduction
^^^^^^^^^^^^

*Zend_Cache_Frontend_Page* is like *Zend_Cache_Frontend_Output* but designed for a complete page. It's impossible
to use *Zend_Cache_Frontend_Page* for caching only a single block.

On the other hand, the "cache id" is calculated automatically with *$_SERVER['REQUEST_URI']* and (depending on
options) *$_GET*, *$_POST*, *$_SESSION*, *$_COOKIE*, *$_FILES*. More over, you have only one method to call
(*start()*) because the *end()* call is fully automatic when the page is ended.

For the moment, it's not implemented but we plan to add a HTTP conditional system to save bandwidth (the system
will send a HTTP 304 Not Modified if the cache is hit and if the browser has already the good version).

.. _zend.cache.frontends.page.options:

Available options (for this frontend in Zend_Cache factory)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.cache.frontends.page.options.table:

.. table:: Page frontend options

   +----------------+---------+----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option          |Data Type|Default Value         |Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
   +================+=========+======================+============================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
   |http_conditional|boolean  |false                 |use the http_conditional system (not implemented for the moment)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
   +----------------+---------+----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |debug_header    |boolean  |false                 |if true, a debug text is added before each cached pages                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
   +----------------+---------+----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |default_options |array    |array(...see below...)|an associative array of default options : (boolean, true by default) cache : cache is on if true (boolean, false by default) cache_with_get_variables : if true, cache is still on even if there are some variables in $_GET array (boolean, false by default) cache_with_post_variables : if true, cache is still on even if there are some variables in $_POST array (boolean, false by default) cache_with_session_variables : if true, cache is still on even if there are some variables in $_SESSION array (boolean, false by default) cache_with_files_variables : if true, cache is still on even if there are some variables in $_FILES array (boolean, false by default) cache_with_cookie_variables : if true, cache is still on even if there are some variables in $_COOKIE array (boolean, true by default) make_id_with_get_variables : if true, the cache id will be dependent of the content of the $_GET array (boolean, true by default) make_id_with_post_variables : if true, the cache id will be dependent of the content of the $_POST array (boolean, true by default) make_id_with_session_variables : if true, the cache id will be dependent of the content of the $_SESSION array (boolean, true by default) make_id_with_files_variables : if true, the cache id will be dependent of the content of the $_FILES array (boolean, true by default) make_id_with_cookie_variables : if true, the cache id will be dependent of the content of the $_COOKIE array|
   +----------------+---------+----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |regexps         |array    |array()               |an associative array to set options only for some REQUEST_URI, keys are (PCRE) regexps, values are associative arrays with specific options to set if the regexp matchs on $_SERVER['REQUEST_URI'] (see default_options for the list of available options) ; if several regexps match the $_SERVER['REQUEST_URI'], only the last one will be used                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
   +----------------+---------+----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |memorize_headers|array    |array()               |对应于一些 HTTP 头名称的字符串数组。列表中的头将保存在缓存里，需要的时候就调出来。                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
   +----------------+---------+----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.frontends.page.examples:

Examples
^^^^^^^^

Use of Zend_Cache_Frontend_Page is really trivial :

.. code-block:: php
   :linenos:

   // [...] // require, configuration and factory

   $cache->start();
   // if the cache is hit, the result is sent to the browser and the script stop here

   // rest of the page ...


a more complex example which shows a way to get a centralized cache management in a bootstrap file (for using with
Zend_Controller for example)

.. code-block:: php
   :linenos:

   /*
    * you should avoid putting too many lines before the cache section.
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

特殊的取消方法
^^^^^^^

因为设计问题，在有些情况下（例如使用非 HTTP/200
返回代码时），你可能需要取消当前缓存处理，所以
我们引入这个特别的前端，cancel()方法。

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



