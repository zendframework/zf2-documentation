.. EN-Revision: none
.. _zend.feed.consuming-atom:

Atom Feed的使用
============

*Zend_Feed_Atom*\ 在使用上有许多方法与 *Zend_Feed_Rss*\
是大相径庭的。它提供了相同的方法访问Feed中的属性和遍历所有Feed中的所有条目。不同之处在于Atom协议结构自身。Atom作为RSS的继承者，它是一个更广泛的协议，在处理Feed中提供的所有内容方面它被设计的更加容易，RSS中的
*description*\ 标记在Atom中被分割成两个元素 *summary* 和 *content*\ 就是为了这个目的。

.. _zend.feed.consuming-atom.example.usage:

.. rubric:: Atom Feed的基本用法

读取一个Atom Feed并打印出每个条目的 *title* 和 *summary*\ ：

.. code-block:: php
   :linenos:

   <?php

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/');
   echo 'The feed contains ' . $feed->count() . ' entries.' . "\n\n";
   foreach ($feed as $entry) {
       echo '标题: ' . $entry->title() . "\n";
       echo '摘要: ' . $entry->summary() . "\n\n";
   }
在Atom Feed中你能找到以下Feed属性：



   - *title*- Feed的标题, 和RSS中的channel标题一样

   - *id*- 在Atom中的每个Feed和条目都有一个唯一的标识符(id)

   - *link*- Feed可以有多个链接，它们之间用 *type*\ 属性区别

     当 *type="text/html"*\
     时与RSS的channel中的link是一样的。如果这个链接是一个在Feed中相同内容的候选版本，那么它将有一个
     *rel="alternate"*\ 属性。

   - *subtitle*- Feed的描述，等同于RSS中的频道描述

     *author->name()*- Feed作者名

     *author->email()*- Feed作者的email地址



Atom 条目通常具有以下属性：



   - *id*- 条目唯一标识符

   - *title*- 条目标题，和RSS的item标题相同

   - *link*- 一个到另外一种格式的链接或者当前条目的一个候选观点

   - *summary*- 条目内容摘要

   - *content*- 条目的全部内容；如果feed就包含摘要可以被挑过

   - *author*- 有 *name* 和 *email* 子标记就像feed的author一样

   - *published*- 条目的发布日期(RFC 3339格式)

   - *updated*- 条目的最后更新日期(RFC 3339格式)



更多关于Atom的信息和丰富的资源，请参看 `http://www.atomenabled.org/`_.



.. _`http://www.atomenabled.org/`: http://www.atomenabled.org/
