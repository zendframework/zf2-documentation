.. _zend.feed.modifying-feed:

修改Feed和条目结构
===========

*Zend_Feed*\
自然的语法既能扩展用于构建和修改Feed以及条目又能非常容易的读取它们。你能容易的把你的新的或者修改过的对象转化成一个结构完整的XML格式保存到文件或者发送到服务器。

.. rubric:: 修改一个已存在的条目

.. code-block::
   :linenos:

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/1');
   $entry = $feed->current();

   $entry->title = 'This is a new title';
   $entry->author->email = 'my_email@example.com';

   echo $entry->saveXML();


这段代码将输出一个新条目完整(包括 *<?xml ... >*
声明)的包含所有必要命名空间的XML格式。

注意上面的代码即使条目中不存在一个author标记也能工作。在开始赋值之前你就能用多层的
*->*\ 访问你想要访问的内容了，如果必要程序将自动为你创建所有中间节点。

如果你想在你的条目中用一个与 *atom:*, *rss:*, 或 *osrss:*\ 不同的命名空间，你必须用
*Zend_Feed*\ 类的 *Zend_Feed::registerNamespace()*\
方法注册你的命名空间。当你修改一个已存在的元素时，它将维持最初的命名空间。当添加一个新元素时，如果你不特别地指定别的命名空间则程序将使用默认的命名空间。

.. rubric:: 用自定义的命名空间创建一个Atom条目元素

.. code-block::
   :linenos:

   $entry = new Zend_Feed_Entry_Atom();
   // Atom的id总是由服务器分配
   $entry->title = 'my custom entry';
   $entry->author->name = 'Example Author';
   $entry->author->email = 'me@example.com';

   // 完成自定义部分
   Zend_Feed::registerNamespace('myns', 'http://www.example.com/myns/1.0');

   $entry->{'myns:myelement_one'} = 'my first custom value';
   $entry->{'myns:container_elt'}->part1 = 'first nested custom part';
   $entry->{'myns:container_elt'}->part2 = 'second nested custom part';

   echo $entry->saveXML();

   ?>



