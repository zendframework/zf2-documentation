.. _zend.feed.consuming-atom-single-entry:

单个Atom条目的处理
=========================

单个Atom *<entry>* 元素自身也是有效的。通常在Feed的URL后带上 */<entryId>*\
就是一个条目的URL。就像 *http://atom.example.com/feed/1*\ ， 我们就以上述的URL作为例子。

如果你想读取单个条目，你仍然可以使用 *Zend_Feed_Atom*\
对象，它将自动创建一个匿名的Feed用来包含条目。

.. _zend.feed.consuming-atom-single-entry.example.atom:

.. rubric:: 读取Atom Feed的单个条目

.. code-block::
   :linenos:
   <?php

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/1');
   echo 'The feed has: ' . $feed->count() . ' entry.';

   $entry = $feed->current();
或者如果你确定只想访问文档的一个 *<entry>*\ ，那么你可以用条目对象直接访问：

.. _zend.feed.consuming-atom-single-entry.example.entryatom:

.. rubric:: 用条目对象直接访问Atom Feed的单个条目

.. code-block::
   :linenos:
   <?php

   $entry = new Zend_Feed_Entry_Atom('http://atom.example.com/feed/1');
   echo $entry->title();

