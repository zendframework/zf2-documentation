.. EN-Revision: none
.. _zend.view.helpers.initial.placeholder:

占位符助手（Placeholder Helper）
=========================

*Placeholder*
视图助手用来在视图脚本和视图实例之间持久化内容。它也提供一些有用的功能如：聚合内容、抓取视图脚本内容以后来用和添加前置（pre-）和后置（post-）文本到内容
（还可以为聚合内容定制分隔符等）。

.. _zend.view.helpers.initial.placeholder.usage:

.. rubric:: 占位符的基本用法

占位符的基本用法是将视图中的数据持久化。每个 *Placeholder*\
助手的启用都需要一个占位符名称，助手接着返回一个占位符容器对象，你可以用来处理或者简单地输出。

.. code-block:: php
   :linenos:

   <?php $this->placeholder('foo')->set("Some text for later") ?>

   <?php
       echo $this->placeholder('foo');
       // outputs "Some text for later"
   ?>

.. _zend.view.helpers.initial.placeholder.aggregation:

.. rubric:: 用占位符来聚合内容

通过占位符来聚合内容有时候很有用。例如视图脚本可拥有一个变量数组来存放数据，而视图脚本可以决定这些数据如何显示出来。

*Placeholder* 视图助手使用继承自 *ArrayObject*
的容器，为处理数组提供了丰富的功能。另外，它为格式化存储在容器里的内容提供了众多的方法：

- *setPrefix($prefix)* 用内容的前缀设置文本。任何时候使用 *getPrefix()*
  来确定当前的设置是什么。

- *setPostfix($prefix)* 用要追加的内容设置文本。任何时候使用 *getPostfix()*
  来确定当前的设置是什么。

- *setSeparator($prefix)* 设置用来分隔聚合内容的分隔符。任何时候使用 *getSeparator()*
  来确定当前的设置是什么。

- *setIndent($prefix)*
  可以用来给内容设置一个缩进的值。如果传递一个整数，就按这个数量来缩进；如果传递一个字符串，就按字符串的长度来缩进。任何时候使用
  *getIndent()* 来确定当前的设置是什么。

.. code-block:: php
   :linenos:

   <!-- first view script -->
   <?php $this->placeholder('foo')->exchangeArray($this->data) ?>

.. code-block:: php
   :linenos:

   <!-- later view script -->
   <?php
   $this->placeholder('foo')->setPrefix("<ul>\n    <li>")
                            ->setSeparator("</li><li>\n")
                            ->setIndent(4)
                            ->setPostfix("</li></ul>\n");
   ?>

   <?php
       echo $this->placeholder('foo');
       //输出一个带有漂亮缩进的HTML无序列表
   ?>

因为 *Placeholder* 容器对象从 *ArrayObject*
继承而来，所以你可以很容易地给特定的键赋值，而不是简单地把它压进容器。键可以作为对象属性或数组键来访问。

.. code-block:: php
   :linenos:

   <?php $this->placeholder('foo')->bar = $this->data ?>
   <?php echo $this->placeholder('foo')->bar ?>

   <?php
   $foo = $this->placeholder('foo');
   echo $foo['bar'];
   ?>

.. _zend.view.helpers.initial.placeholder.capture:

.. rubric:: 使用占位符（Placeholders）来抓取内容

有时你可能会在视图脚本（最容易的模板）为占位符放些内容， *Placeholder*
视图助手允许你抓取任意的内容，在以后用下列的 API
来解析并输出（本功能类似于缓冲输出－－Haohappy注）：

- *captureStart($type, $key)* 开始抓取内容。

  *$type* 应该是 *Placeholder* 的常量 *APPEND* 或 *SET* 其中之一。如果用 *APPEND*\
  ，被抓取得内容就追加到在占位符当前内容的列表； 如果用 *SET*\
  ，被抓取得内容就被用作占位符的唯一内容（替换以前的内容）。缺省地 *$type* 是
  *APPEND*\ 。

  *$key*\ 可用来在占位符容器指定一个特殊的键给你想抓取的内容。

  *captureStart()* 锁住抓取直到 *captureEnd()*
  被调用，不能在同一个占位符容器里嵌套抓取，这样做会引起一个异常。

- *captureEnd()* 使抓取内容停止，并根据 *captureStart()* 如何被调用来把它放到容器对象。

.. code-block:: php
   :linenos:

   <!-- Default capture: append -->
   <?php $this->placeholder('foo')->captureStart();
   foreach ($this->data as $datum): ?>
   <div class="foo">
       <h2><?= $datum->title ?></h2>
       <p><?= $datum->content ?></p>
   </div>
    <?php endforeach; ?>
   <?php $this->placeholder('foo')->captureEnd() ?>

   <?php echo $this->placeholder('foo') ?>

.. code-block:: php
   :linenos:

   <!-- Capture to key -->
   <?php $this->placeholder('foo')->captureStart('SET', 'data');
   foreach ($this->data as $datum): ?>
   <div class="foo">
       <h2><?= $datum->title ?></h2>
       <p><?= $datum->content ?></p>
   </div>
    <?php endforeach; ?>
   <?php $this->placeholder('foo')->captureEnd() ?>

   <?php echo $this->placeholder('foo')->data ?>

.. _zend.view.helpers.initial.placeholder.implementations:

具体占位符实现
-------

Zend Framework 自带有若干个具体实现的占位符，包括常用的占位符：doctype、page
title、以及各种 <head> 元素。对所有情况，不带参数调用占位符将返回元素自己。

每个元素的文档，请查看如下链接：

- :ref:`Doctype <zend.view.helpers.initial.doctype>`

- :ref:`HeadLink <zend.view.helpers.initial.headlink>`

- :ref:`HeadMeta <zend.view.helpers.initial.headmeta>`

- :ref:`HeadScript <zend.view.helpers.initial.headscript>`

- :ref:`HeadStyle <zend.view.helpers.initial.headstyle>`

- :ref:`HeadTitle <zend.view.helpers.initial.headtitle>`

- :ref:`InlineScript <zend.view.helpers.initial.inlinescript>`


