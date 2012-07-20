.. _zend.view.helpers.initial.headtitle:

HeadTitle 助手
============

HTML *<title>* 元素用来提供标题给HTML文档。 *HeadTitle*
助手允许用程序生成和存储标题供以后解析和输出。

*HeadTitle* 助手是 :ref:`占位符助手 <zend.view.helpers.initial.placeholder>` 的一个具体实现。
它覆盖 *toString()* 方法来确保生成 *<title>* 元素，并添加一个 *headTitle()*
方法来快速并容易地设置和标题元素的聚合。那个方法的 signature 是 *headTitle($title,
$setType = 'APPEND')*\ ，缺省地是追加到堆栈（聚合标题元素）的值，但你也可以指定
'PREPEND' ( 放栈顶 ) 或 'SET' ( 重写堆栈 )。

.. _zend.view.helpers.initial.headtitle.basicusage:

.. rubric:: HeadTitle 助手基本用法

你可以在任何时候指定一个标题标签。一般的用法可以让你在应用程序的每一个层次来设置标题段：站点、控制器、动作和潜在的资源。

.. code-block::
   :linenos:
   <?php
   // setting the controller and action name as title segments:
   //把控制器和动作的名称设置为标题的一部分
   $request = Zend_Controller_Front::getInstance()->getRequest();
   $this->headTitle($request->getActionName())
        ->headTitle($request->getControllerName());

   // setting the site in the title; possibly in the layout script:
   //添加标题内容，这种写法常用于布局脚本中
   $this->headTitle('Zend Framework');

   // setting a separator string for segments:
   //为标题的各部分设置分隔符
   $this->headTitle()->setSeparator(' / ');
   ?>

在布局脚本中准备好标题后，使用echo即可输出：

.. code-block::
   :linenos:

   <!-- renders <action> / <controller> / Zend Framework -->
   <?= $this->headTitle() ?>


