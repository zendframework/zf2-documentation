.. _zend.cache.introduction:

简介
======

*Zend_Cache* 提供了一个缓存任何数据的一般方法.

在Zend Framework中缓存由前端操作,同时通过后端适配器(*File*, *Sqlite*, *Memcache*...)和
一个灵活的IDs和Tags系统(标识符和标记系统)存储缓存纪录.使用此方法,易于删除特定类型的纪录(例如:"删除所有标记为tag的纪录")

模块(*Zend_Cache_Core*)
的核心是通用,灵活和可配置.对于特定的需要,为了便捷,这里有一些继承自
*Zend_Cache_Core*\ 的前端: *Output*, *File*, *Function* 和 *Class*.

.. _zend.cache.introduction.example-1:

.. rubric:: 调用 *Zend_Cache::factory()*\ 取得一个前端

*Zend_Cache::factory()* 实例化正确的对象并把他们捆绑到一起. 在这第一个例子中我们将把
*Core* 前端和 *File* 后端一起使用.

.. code-block::
   :linenos:

   $frontendOptions = array(
      'lifeTime' => 7200, // 两小时的缓存生命期
      'automatic_serialization' => true
   );

   $backendOptions = array(
       'cache_dir' => './tmp/' // 放缓存文件的目录
   );

   // 取得一个Zend_Cache_Core 对象
   $cache = Zend_Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);


.. note::

   **由多个字组成的前端和后端**

   一些前端和后端使用多个字命名,例如'ZendPlatform'.当指定给工厂时,使用字分隔符,比如空格('
   '),连字符('-'),或则点('.').

.. _zend.cache.introduction.example-2:

.. rubric:: Caching a database query result

现在有了一个前端,可用缓存任何类型的数据了(开了序列化'serialization').例如,能够缓存从昂贵的数据库查询中缓存一个结果.结果被缓存后,不再需要连接到数据库;数据直接在缓存中取回和反序列化.

.. code-block::
   :linenos:

   // $cache 在先前的例子中已经初始化了

   // 查看一个缓存是否存在:
   if(!$result = $cache->load('myresult')) {

       // 缓存不命中;连接到数据库

       $db = Zend_Db::factory( [...] );

       $result = $db->fetchAll('SELECT * FROM huge_table');

       $cache->save($result, 'myresult');

   } else {

       // cache hit! shout so that we know
       echo "This one is from cache!\n\n";

   }

   print_r($result);




.. _zend.cache.introduction.example-3:

.. rubric:: 用 *Zend_Cache* 输出前端缓存输出

通过加入条件逻辑,我们'mark up'(标记)那些希望缓存输出的段(sections),在 *start()* 和 *end()*\
方法间封装这些section(这类似第一个例子,并且是缓存的核心策略).

在内部,像往常一样输出你的数据,当执行到 *end()*\
方法时,所有之前的输出都被缓存.在下一次运行时,整个段(end()方法调用前的代码)将被跳过执行,直接从Cache中取回数据(只要缓存纪录是有效的).

.. code-block::
   :linenos:

   $frontendOptions = array(
      'lifeTime' => 30,                  // cache lifetime of 30 seconds
      'automatic_serialization' => false  // this is the default anyway s
   );
   // 翻译时实验系统为Windows,请使用Windows的读者修改cacheDir的路径为实际的路径
   $backendOptions = array('cache_dir' => './tmp/');

   $cache = Zend_Cache::factory('Output',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   // 传递一个唯一标识符给start()方法
   if(!$cache->start('mypage')) {
       // output as usual:

       echo 'Hello world! ';
       echo 'This is cached ('.time().') ';

       $cache->end(); // the output is saved and sent to the browser
   }

   echo 'This is never cached ('.time().').';



注意我们两次输出了 *time()*\
的结果;为演示目的第二次的time()调用是动态的.再运行然后刷新多次;你会注意到当随着时间的流逝第一个数字并没有随时间改变.这是因为第一个数组在缓存段中输出,因此输出是被缓存了.
30秒后(我们设置了lifetime为30秒)由于缓存纪录超时而变得无效了,第一个数字再次更新,同时于第二个时间匹配(相同).你应该在你的浏览器或者控制台中试一下.

.. note::

   在使用Zend_Cache是特别要注意的Cache标识(传递给 *save()*\ 和 *start()*\
   的参数).它必须对于你所缓存的每个资源唯一,否则不相关的缓存纪录就会相互覆盖,
   更糟的是,导致错误的显示结果.


