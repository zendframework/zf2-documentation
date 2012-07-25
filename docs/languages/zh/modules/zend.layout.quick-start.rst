.. _zend.layout.quickstart:

Zend_Layout 快速入门
================

*Zend_Layout*\ 有两个基本用例：带有Zend Framework MVC和不带。

.. _zend.layout.quickstart.layouts:

布局脚本
----

在两种情况下都需要创建布局脚本。布局脚本简单地使用Zend_View（或者无论哪种你在使用的视图实现）。布局变量用
*Zend_Layout* :ref:`placeholder <zend.view.helpers.initial.placeholder>`
注册，可以通过占位符助手或者通过布局助手从布局对象的对象属性里获取。

如下例：

.. code-block:: php
   :linenos:

   <!DOCTYPE html
       PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
   <html>
   <head>
       <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
       <title>My Site</title>
   </head>
   <body>
   <?php
       // fetch 'content' key using layout helper:
       echo $this->layout()->content;

       // fetch 'foo' key using placeholder helper:
       echo $this->placeholder('Zend_Layout')->foo;

       // fetch layout object and retrieve various keys from it:
       $layout = $this->layout();
       echo $layout->bar;
       echo $layout->baz;
   ?>
   </body>
   </html>

因为 *Zend_Layout*\ 使用 *Zend_View*\
来解析，你也可以使用任何视图助手注册，并也可以访问任何先前分配的视图变量。特别有用的是各种各样的
:ref:`占位符助手 <zend.view.helpers.initial.placeholder>`\ ，因为它允许为如
<head>节（section）、导航（navigation）等区域获取内容：

.. code-block:: php
   :linenos:

   <!DOCTYPE html
       PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
   <html>
   <head>
       <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
       <?= $this->headTitle() ?>
       <?= $this->headScript() ?>
       <?= $this->headStyle() ?>
   </head>
   <body>
       <?= $this->render('header.phtml') ?>

       <div id="nav"><?= $this->placeholder('nav') ?></div>

       <div id="content"><?= $this->layout()->content ?></div>

       <?= $this->render('footer.phtml') ?>
   </body>
   </html>

.. _zend.layout.quickstart.mvc:

和Zend Framework MVC一起使用 Zend_Layout
-----------------------------------

*Zend_Controller*\ 通过 :ref:`前端控制器插件 <zend.controller.plugins>` 和 :ref:`动作控制器助手
<zend.controller.actionhelpers>` 提供了一组丰富的扩展函数。 *Zend_View* 也有 :ref:`助手
<zend.view.helpers>`\ 。当和（Zend Framework）MVC组件一起使用时， *Zend_Layout*
利用这些多种扩展点。

*Zend_Layout::startMvc()*\ 创建一个带有任何你提供给它的可选配置的 *Zend_Layout*\
的实例。接着它注册一个前端控制器插件，一旦派遣循环完成，这个插件就解析带有任何应用程序内容的布局，并且注册一个动作助手允许从动作控制器来访问布局对象。另外，可以任何时候用
*布局*\ 视图助手从视图脚本抓取布局实例。

首先，来看看如何初始化Zend_Layout来和MVC一起使用：

.. code-block:: php
   :linenos:

   <?php
   // In your bootstrap:
   Zend_Layout::startMvc();
   ?>
*startMvc()* 可以带一个可选的数组或 *Zend_Config* 对象来定制实例；这些选项详见 :ref:`
<zend.layout.options>` 。

在动作控制器例，你可以把局实例作为一个动作助手来访问：

.. code-block:: php
   :linenos:

   <?php
   class FooController extends Zend_Controller_Action
   {
       public function barAction()
       {
           // disable layouts for this action:
           $this->_helper->layout->disableLayout();
       }

       public function bazAction()
       {
           // use different layout script with this action:
           $this->_helper->layout->setLayout('foobaz');
       };
   }
   ?>
在视图脚本里，可以通过 *layout*\
视图助手来访问布局对象。这个视图助手和其它的有细微的区别：不带参数，返回一个对象而不是一个字符串值。这允许在布局对象里立即调用方法：

.. code-block:: php
   :linenos:

   <?php $this->layout()->setLayout('foo'); // set alternate layout ?>

在任何时候，通过 *getMvcInstance()* 静态方法获取和MVC一起注册的 *Zend_Layout*\ 的实例：

.. code-block:: php
   :linenos:

   <?php
   // Returns null if startMvc() has not first been called
   $layout = Zend_Layout::getMvcInstance();
   ?>
最后， *Zend_Layout*
的前端控制器插件有一个除解析布局外的重要特征：它从响应对象获取所有被命名的段（segments）并分配它们为布局变量，分配‘default’段给变量‘content’。这允许访问应用程序内容和在视图脚本里解析。

作为例子，让代码首先点击 *FooController::indexAction()*
，它解析一些内容到缺省的响应段，并接着转发给 *NavController::menuAction()*
，它解析内容给'nav'响应段。最后，转发给 *CommentController::fetchAction()*
并取得一些注释，但是也解析那些给缺省响应段（追加内容给那个段）。视图脚本可以接着分别解析：

.. code-block:: php
   :linenos:

   <body>
       <!-- renders /nav/menu -->
       <div id="nav"><?= $this->layout()->nav ?></div>

       <!-- renders /foo/index + /comment/fetch -->
       <div id="content"><?= $this->layout()->content ?></div>
   </body>

当和动作堆栈 :ref:`动作助手 <zend.controller.actionhelpers.actionstack>` 和 :ref:`插件
<zend.controller.plugins.standard.actionstack>`\
一起协同使用时，这个特性特别有用，通过循环可以设置一个动作堆栈，这样就创建一个部件化的页面。

.. _zend.layout.quickstart.standalone:

使用Zend_Layout做为独立的组件
--------------------

做为独立组件，Zend_Layout不提供和MVC一起使用那样的方便和更多的功能。然而，它仍有两个主要优点：

- 布局变量范围

- 从其它视图脚本分离视图脚本布局

当用作独立组件，简单地初始化布局对象，使用不同的访问器来设置状态、设置变量为对象属性和解析布局：

.. code-block:: php
   :linenos:

   <?php
   $layout = new Zend_Layout();

   // Set a layout script path:
   $layout->setLayoutPath('/path/to/layouts');

   // set some variables:
   $layout->content = $content;
   $layout->nav     = $nav;

   // choose a different layout script:
   $layout->setLayout('foo');

   // render final layout
   echo $layout->render();
   ?>
.. _zend.layout.quickstart.example:

尝试一下布局
------

有时候百闻不如一见。下面是一个布局脚本例子来展示它是如何工作的。

.. image:: ../images/zend.layout.quickstart.example.png
   :align: center

基于所设置的CSS文件，实际元素的顺序可能不同；例如：如果使用绝对位置，导航稍后显示在文档种，但仍在顶部；对于sidebar或header同样适用，然而实际的显示内容的机制保持相同。


