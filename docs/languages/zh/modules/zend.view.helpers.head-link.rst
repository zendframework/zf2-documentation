.. _zend.view.helpers.initial.headlink:

HeadLink 助手
===============

HTML的 *<link>* 标签越来越多地用于为你的站点链接不同资源：stylesheet, feed, favicon,
trackback等。 *HeadLink*
助手提供了一个简单的接口用来创建和聚合这些元素以供稍后在你的布局脚本里获取和输出。

*HeadLink* 助手有以下特殊的方法用来添加 stylesheet 链接：

- *appendStylesheet($href, $media, $conditionalStylesheet)*

- *offsetSetStylesheet($index, $href, $media, $conditionalStylesheet)*

- *prependStylesheet($href, $media, $conditionalStylesheet)*

- *setStylesheet($href, $media, $conditionalStylesheet)*

*$media* 值缺省为 'screen'，但可以为任何有效的媒体(media)值。 *$conditionalStylesheet*
是布尔值，将用于解析时来决定是否有特殊的注释应该被包括以防止在特定的平台上加载stylesheet。

另外， *HeadLink* 助手有特殊的方法用来添加 'alternate' 链接到它的堆栈：

- *appendAlternate($href, $type, $title)*

- *offsetSetAlternate($index, $href, $type, $title)*

- *prependAlternate($href, $type, $title)*

- *setAlternate($href, $type, $title)*

*headLink()* 助手方法允许指定所有的必要的属性给 *<link>* 元素， 也允许指定替代 －
是否新元素替换所有其他的，前置（栈顶），或追加（栈底）。

*HeadLink* 助手是 :ref:`占位符助手 <zend.view.helpers.initial.placeholder>`\ 的一个具体实现。

.. _zend.view.helpers.initial.headlink.basicusage:

.. rubric:: HeadLink 助手的基本用法

任何时候可以指定 *headLink*\
，典型地，将在布局脚本里指定全局链接，并在应用程序视图脚本里指定特定的链接。在布局脚本里的
<head> 部份，用echo来输出。

.. code-block::
   :linenos:

   <?php // 在视图脚本中设置链接：
   $this->headLink()->appendStylesheet('/styles/basic.css')
                    ->headLink(array('rel' => 'favicon', 'href' => '/img/favicon.ico'), 'PREPEND')
                    ->prependStylesheet('/styles/moz.css', 'screen', true);
   ?>
   <?php // 解析链接：?>
   <?= $this->headLink() ?>


