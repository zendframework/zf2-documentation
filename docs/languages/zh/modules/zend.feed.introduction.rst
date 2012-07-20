.. _zend.feed.introduction:

介绍
======

*Zend_Feed*\ 提供了处理的 RSS 和 Atom Feed的功能。它提供了一套自然的方法用于
访问Feed元素、属性、和条目属性。 除此之外 *Zend_Feed*\ 还扩展提供了同样简单的方法
用于修改feed和条目的结构，并将结果转化成XML格式。不久的将来这些扩展可能会被 Atom
Publishig Protocol(AtomPP)所支持。

*Zend_Feed*\ 由一个 *Zend_Feed*\ 基类、一个 *Zend_Feed_Abstract*\
抽象类以及一个用于表示Feed和条目的 *Zend_Feed_Entry_Abstract*\ 基类组成。这些类封装了 RSS
和 Atom 的feed和条目特性的，提供了一套自然的方法使他们用起来变得异常简单。

在下面的例子中，我们示范了一个获得一个RSS
feed并将其中的一般部分相关数据保存到一个PHP数组中的简单实例，这样这些数据就能方便的用于输出、保存到数据库等等。

.. note::

   **Be aware**

   许多RSS中的channel和item属性是不同的。RSS的规范中提供了许多可选的属性，因此在编写RSS相关应用代码时要充分考虑这点。

.. rubric:: 用Zend_Feed来处理RSS Feed数据

.. code-block::
   :linenos:

   <?php
   require_once 'Zend/Feed.php';

   // 取得最新的 Slashdot 头条新闻
   try {
       $slashdotRss = Zend_Feed::import('http://rss.slashdot.org/Slashdot/slashdot');
   } catch (Zend_Feed_Exception $e) {
       // feed 导入失败
       echo "Exception caught importing feed: {$e->getMessage()}\n";
       exit;
   }

   // 初始化保存 channel 数据的数组
   $channel = array(
       'title'       => $slashdotRss->title(),
       'link'        => $slashdotRss->link(),
       'description' => $slashdotRss->description(),
       'items'       => array()
       );

   // 循环获得channel的item并存储到相关数组中
   foreach ($slashdotRss as $item) {
       $channel['items'][] = array(
           'title'       => $item->title(),
           'link'        => $item->link(),
           'description' => $item->description()
           );
   }


