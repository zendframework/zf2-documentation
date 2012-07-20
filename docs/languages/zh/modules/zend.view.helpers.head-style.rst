.. _zend.view.helpers.initial.headstyle:

HeadStyle 助手
================

在 HTML *<head>* 元素中 HTML *<style>* 元素用来包含 CSS stylesheets inline 。

.. note::

   **使用 HeadLink 来链接 CSS 文件**

   :ref:`HeadLink <zend.view.helpers.initial.headlink>` 为包含外部 stylesheets 应该用来生成 *<link>*
   元素。如果想定义自己的 stylesheets inline， 使用 *HeadScript* 。

*HeadStyle* 助手支持下列方法来设置和添加 stylesheet 声明：

- *appendStyle($content, $attributes = array())*

- *offsetSetStyle($index, $content, $attributes = array())*

- *prependStyle($content, $attributes = array())*

- *setStyle($content, $attributes = array())*

对于所有情况， *$content* 是实际上的 CSS 声明。 *$attributes* 是提供给 *style*
标签的任何额外的属性：lang、 title、 media 或 dir 都是允许的。

*HeadStyle*
也允许抓取样式声明，如果想用程序生成声明，然后在任何地方自由使用，这很有用。这个用法将在下面的例子给出。

最后，你也可以用 *headStyle()*\ 方法 来快速地添加声明元素，它的用法：
*headStyle($content$placement = 'APPEND', $attributes = array())* 。 *$placement* 是 'APPEND'、 'PREPEND' 或
'SET'。

*HeadStyle* 覆盖 *append()*\ ， *offsetSet()*\ ， *prepend()* 和 *set()*
中的每一个来加强上述特殊方法的用法。 在内部，它存储每个条目为 *stdClass*
令牌，它在稍后用 *itemToString()* 方法 serializes
。这允许在堆栈里检查条目，并可选地通过修改返回的对象来修改这些条目。

*HeadStyle* 助手是 :ref:`占位符助手 <zend.view.helpers.initial.placeholder>` 的一个具体实现。

.. _zend.view.helpers.initial.headstyle.basicusage:

.. rubric:: HeadStyle 助手的基本用法

在任何时候都可以指定一个新的样式标签：

.. code-block::
   :linenos:

   <?php // adding styles
   $this->headStyle()->appendStyle($styles);
   ?>

对 CSS 来说，顺序非常重要，因为层叠的顺序(the order of the
cascade)，你需要确保样式表中的声明按特定的顺序加载。使用append、 prepend 和 offsetSet
指令可帮助你达到目的：

.. code-block::
   :linenos:

   <?php // Putting styles in order

   // place at a particular offset:
   $this->headStyle()->offsetSetStyle(100, $customStyles);

   // place at end:
   $this->headStyle()->appendStyle($finalStyles);

   // place at beginning
   $this->headStyle()->prependStyle($firstStyles);
   ?>

当准备好在布局脚本里输出所有样式声明，简单地 echo 助手：

.. code-block::
   :linenos:

   <?= $this->headStyle() ?>

.. _zend.view.helpers.initial.headstyle.capture:

.. rubric:: 用 HeadStyle 助手抓取样式声明

有时候需要用程序生成 CSS 样式声明。当你可以使用字符串串联，heredoc等等，
通常通过创建脚本和在PHP标签里做手脚会更容易些。 *HeadStyle*
可以做这个，把它抓取到堆栈：

.. code-block::
   :linenos:

   <?php $this->headStyle()->captureStart() ?>
   body {
       background-color: <?= $this->bgColor ?>;
   }
   <?php $this->headStyle()->captureEnd() ?>

下面是一些假设：

- 样式声明将追加到堆栈。如果需要替换或者加到堆栈顶部，那么需要分别把 'SET' 或
  'PREPEND' 作为第一个参数传递给 *captureStart()* 。

- 如果想指定任何另外的属性给 *<style>* 标签，通过数组把它们作为第二个参数传递给
  *captureStart()* 。


