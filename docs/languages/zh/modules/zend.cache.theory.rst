.. _zend.cache.theory:

缓存原理
====

在Zend_Cache中有三个关键概念.一是用于标识缓存纪录的唯一标识符(一个字符串).二是
*'lifeTime'*\ 指令,正如例子中所见,
它定义了缓存纪录的生命期(超过该值,缓存纪录被销毁).第三个关键概念是条件执行,你的部分代码可用被跳过,以加速性能.
前端函数(例如. *Zend_Cache_Core::get()*)在缓存不命中时返回false,这使用户能处理 *if(){ ... }*
语句中的条件,包含代码中他们所要缓存(或者跳过)的部分,最后是否必须保存这些你曾经生成的块(例如:
*Zend_Cache_Core::save()*).

.. note::

   在有些前端 *Function*\ 中不需要条件执行,例如,当整个逻辑在前端内部实现的时候.

.. note::

   '缓存命中'是一个术语,它表示当一个缓存纪录发现可用,是有效的并且是'fresh'的(换言之,就是还没有过期).'Cache
   miss' 表示当在缓存中找不到需要的数据时,发生缓存不命中. 当一个Cache
   miss发生是,你必须生成你的数据,并使它被缓存.而对于缓存命中,后端自动透明地从Cache中取回缓存纪录.

.. _zend.cache.factory:

Zend_Cache 工厂方法
---------------

下面的示例给出了一个构造 *Zend_Cache*\ 前端实例的好方法:

.. code-block:: php
   :linenos:

   // We choose a backend (for example 'File' or 'Sqlite'...)
   $backendName = '[...]';

   // 选择一个前端(例如'Core', 'Output', 'Page'...)
   $frontendName = '[...]';

   // 为选择的前端设置一个选项数组
   $frontendOptions = array([...]);

   // 为选择的后端设置一个选项数组
   $backendOptions = array([...]);

   // 创建实例(当然,最后两个参数是可选的)
   $cache = Zend_Cache::factory($frontendName, $backendName, $frontendOptions, $backendOptions);



在下面的例子中我们假设变量 *$cache*\
保存有一个有效的,已实例化的前端,并且你知道该如何给你选择的后端传递参数.

.. note::

   必须使用 *Zend_Cache::factory()*\ 来得到前端实例.你自己 直接实例化的 前端或者后端
   不能按照期望工作.

.. _zend.cache.tags:

标记纪录
----

标记是给缓存纪录分类的一种方法.当你使用 *save()*\
方法保存一个缓存时,你可以给该缓存纪录设置一个或多个标记,多个标记以数组形式组织在一起
此后你不再需要该缓存纪录使,你可以清除所有指定标记的缓存纪录.

.. code-block:: php
   :linenos:

   $cache->save($huge_data, 'myUniqueID', array('tagA', 'tagB', 'tagC'));


.. note::

   note than the *save()* method accepts an optional fourth argument : *$specificLifetime* (if != false, it sets a
   specific lifetime for this particular cache record)

.. _zend.cache.clean:

缓存清理
----

删除特定id的Cache纪录,使用 *remove()*\ 方法:

.. code-block:: php
   :linenos:

   $cache->remove('idToRemove');


在单个操作中删除多个Cache纪录,可以使用 *clean()*\ 方法.例如,删除所有的缓存纪录:

.. code-block:: php
   :linenos:

   // 清除所有缓存纪录
   $cache->clean(Zend_Cache::CLEANING_MODE_ALL);

   // 仅清除过期的
   $cache->clean(Zend_Cache::CLEANING_MODE_OLD);



如果你想删除标记为'tagA'和'tagC'的缓存项:

.. code-block:: php
   :linenos:

   $cache->clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG, array('tagA', 'tagC'));


可用的清除模式有: *CLEANING_MODE_ALL*, *CLEANING_MODE_OLD*, *CLEANING_MODE_MATCHING_TAG* 和
*CLEANING_MODE_NOT_MATCHING_TAG*.
后面的,正如它名称所暗示的,在清除操作中组合了一个标记数组,对其中的每个元素作处理.


