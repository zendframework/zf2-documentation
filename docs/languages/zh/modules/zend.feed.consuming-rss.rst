.. EN-Revision: none
.. _zend.feed.consuming-rss:

RSS Feed的使用
===========

用一个 *Zend_Feed_Rss*\ 对象实例和一个Feed的URL来读取一个RSS Feed再简单不过了:

.. code-block:: php
   :linenos:

   $channel = new Zend_Feed_Rss('http://rss.example.com/channelName');


如果在获得feed时发生任何错误，那么一个 *Zend_Feed_Exception*\ 异常将被抛出。

一旦你获得一个Feed对象，那么你就能在这个对象上直接访问任何RSS
标准定义的channel属性:

.. code-block:: php
   :linenos:

   echo $channel->title();?>


注意函数语法。如果用 "getter" 的语法 (*$obj->property*)
取一个对象变量或是调用一个对象方法(*$obj->property()*)时， *Zend_Feed*\
将把这个变量名或方法名作为一个XML对象的属性处理(就像访问XML中的某个节点)。这样在取得指定的节点内容后还能访问其子节点。

如果RSS的channel有属性，那么可以用访问 PHP 数组的语法获得他们:

.. code-block:: php
   :linenos:

   echo $channel->category['domain'];?>


因为XML的属性不能拥有子节点，所以不需要用方法的语法访问其属性。 values.

最常用的是您可以通过循环遍历Feed的条目来作些事情。 *Zend_Feed_Abstract* 实现的是PHP
的Iterator接口，因此要打印channel中的文章标题可以像下面这样:

.. code-block:: php
   :linenos:


   foreach ($channel as $item) {
       echo $item->title() . "\n";
   }


如果你对RSS不是很熟，那这有一分关于RSS channel和各个RSS
item(条目)标准元素的列表可能对你有帮助。

必须的 channel 元素:



   - *title*- channel 名

   - *link*- channel相关的站点URL

   - *description*- 一句或者若干关于channel的描述



可选的channel元素:



   - *pubDate*- 这份内容发布的时间，用 RFC 822 的日期格式

   - *language*- channel的书写语言

   - *category*- channel属于的一个或多个分类(用多个标记指名)



RSS 的 *<item>* 组成没有严格的要求。但是 *title* 或 *description*\ 必须至少有一个。

常用的item元素:



   - *title*- item的标题

   - *link*- item的链接

   - *description*- item的概述

   - *author*- 作者Email

   - *category*- item所属的一个或者多个分类

   - *comments*- item相关评论的URL链接

   - *pubDate*- item的发布日期( RFC 822 日期格式)



在你的代码中，一个非空元素总是被能测到:

.. code-block:: php
   :linenos:

   if ($item->propname()) {
       // ... proceed.
   }


如果你用 *$item->propname*\ 代替 *$item->propname()*\
，那么你将总是得到一个空对象使条件判断为 *TRUE*\ ，因此条件判断将失效。

更多信息，请参看RSS 2.0的官方说明: `http://blogs.law.harvard.edu/tech/rss`_\ 。



.. _`http://blogs.law.harvard.edu/tech/rss`: http://blogs.law.harvard.edu/tech/rss
