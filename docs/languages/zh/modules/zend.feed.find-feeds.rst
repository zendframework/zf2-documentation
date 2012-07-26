.. _zend.feed.findFeeds:

从网页上获得Feed
==========

在网页上与该页内容其相关的详细信息常被包含在一个用 *<link>*\ 标记关联的Feed中。
*Zend_Feed*\ 能让你用一个简单的方法提取一个页面上所有关联的Feed:

.. code-block:: php
   :linenos:

   $feedArray = Zend_Feed::findFeeds('http://www.example.com/news.html');


*findFeeds()*\ 方法返回一个 *Zend_Feed_Abstract*\
对象数组，数组中的内容对应news.html页中所有用 *<link>*\
关联到的Feed。根据每个feed类型的不同， *$feedArray*\ 数组的下标变量可能是一个
*Zend_Feed_Rss*\ 对象的实例也可能是一个 *Zend_Feed_Atom*\
对象的实例。但是如果服务器端响应HTTP 404或者feed不符合规范，那么 *Zend_Feed*\
将抛出一个 *Zend_Feed_Exception*\ 异常。


