.. _zend.layout.advanced:

Zend_Layout 高级用法
================

*Zend_Layout*
有无数用例提供给愿意修改它以适应不同的视图实现、文件系统布局及更多的高级开发者。

主要的扩展点是：

- **定制视图对象。** *Zend_Layout* 允许使用任何实现 *Zend_View_Interface* 的类。

- **定制前端控制器插件。** *Zend_Layout*
  和在返回响应之前自动解析布局的标准前端控制器插件一起发布。你可以替换你自己的插件。

- **定制动作助手。** *Zend_Layout*
  和标准动作助手一起发布，因为这个助手对于布局对象自己是一个哑代理（dumb
  proxy），所以它应该适合大部分的需求。

- **定制布局脚本路径解析（resolution）**\ 。 *Zend_Layout*
  允许为布局脚本路径解析使用你自己的 :ref:`变形器（inflector） <zend.filter.inflector>`
  ，或者简单地修改附加的变形器来指定你自己的变形规则。

.. _zend.layout.advanced.view:

定制视图对象
------

*Zend_Layout* 允许任何实现 *Zend_View_Interface* 的类或者扩展 *Zend_View_Abstract*
来解析布局脚本。简单地把定制的视图对象当作参数传递给 constructor/*startMvc()*\
，或者用 *setView()* 访问器来设置它：

.. code-block:: php
   :linenos:

   <?php
   $view = new My_Custom_View();
   $layout->setView($view);
   ?>
.. note::

   **不是所有的 Zend_View 实现都等同**

   虽然 *Zend_Layout*\ 允许使用任何实现 *Zend_View_Interface*\ 的类，如果它们不能使用各种
   *Zend_View*\ 助手，也可能遇到问题，特别是布局和 :ref:`占位符
   <zend.view.helpers.initial.placeholder>`\ 助手。这是因为 *Zend_Layout*\ 通过它自己和
   :ref:`占位符 <zend.view.helpers.initial.placeholder>`\ 在可用的对象里设置变量。

   如果要使用一个定制的不支持这些助手 *Zend_View*\
   实现，那么需要找到一个办法把布局变量给视图。这可以通过两个办法来实现：扩展
   *Zend_Layout*\ 对象和改变 *render()*\
   方法来传递变量给视图；或者，创建自己的插件类，在解析布局前传递它们。

   做为替换方案，如果你的视图实现支持任何种类的插件，你可以通过'Zend_Layout'占位符使用
   :ref:`占位符助手 <zend.view.helpers.initial.placeholder>`\ ：

   .. code-block:: php
      :linenos:

      <?php
      $placeholders = new Zend_View_Helper_Placeholder();
      $layoutVars   = $placeholders->placeholder('Zend_Layout')->getArrayCopy();
      ?>
.. _zend.layout.advanced.plugin:

定制前端控制器插件
---------

当和MVC组件一起使用， *Zend_Layout*\
注册一个前端控制器插件，这个插件把解析布局做为在退出派遣循环之前的最后一个动作。在大多数情况下，缺省的插件适用，但如果你象写你自己的，可以通过传递
*pluginClass*\ 选项给 *startMvc()*\ 方法来指定插件类的名称去加载。

为这个目的所写的任何插件类将需要扩展 *Zend_Controller_Plugin_Abstract*\
，并应该接受一个布局对象实例做为参数给构造器。另外，你的实现细节取决于你。

被使用缺省插件类是 *Zend_Layout_Controller_Plugin_Layout*\ 。

.. _zend.layout.advanced.helper:

定制动作助手
------

当和MVC组件一起使用， *Zend_Layout*\ 用助手经纪注册一个动作控制器助手。缺省助手，
*Zend_Layout_Controller_Action_Helper_Layout*\
，扮作一个哑代理给布局对象实例自己，并应该适合大多数用例。

如果你觉得需要写定制的函数，简单地写一个扩展 *Zend_Controller_Action_Helper_Abstract*
的动作助手类并把类名做为 *helperClass*\ 选项传递给 *startMvc()*\
方法，细节就取决于你了。

.. _zend.layout.advanced.inflector:

定制布局脚本路径解析（Resolution）：使用变形器（Inflector）
---------------------------------------

为翻译布局名到布局脚本路径， *Zend_Layout* 用 *Zend_Filter_Inflector*\
来建立一个过滤链。缺省地，它遵循'StringToLower'（字符变小写）来使用规则'CamelCaseToDash'（驼峰变短横线）和加后缀'phtml'来转换名字到路径。如下几个例子所示：

- 'foo' will be transformed to 'foo.phtml'.

- 'FooBarBaz' will be transformed to 'foo-bar-baz.phtml'.

有三个选项来修改变形：通过 *Zend_Layout*\
访问器修改变形目标和/或视图后缀，修改变形器规则和与 *Zend_Layout*\
实例联合变形器目标，或者创建你自己的变形器实例并传递给 *Zend_Layout::setInflector()*\
。

.. _zend.layout.advanced.inflector.accessors:

.. rubric:: 使用Zend_Layout访问器来修改变形器(inflector)

缺省的 *Zend_Layout*\
变形器对目标和脚本后缀使用静态地址(references)，并拥有访问器来设置这些值。

.. code-block:: php
   :linenos:

   <?php
   // Set the inflector target:
   $layout->setInflectorTarget('layouts/:script.:suffix');

   // Set the layout view script suffix:
   $layout->setViewSuffix('php');
   ?>
.. _zend.layout.advanced.inflector.directmodification:

.. rubric:: Zend_Layout 变形器的直接修改

变形器有目标和一个或多个规则。缺省目标和 *Zend_Layout*\
一起使用是':script.:suffix'；':script'是被传递的已注册的布局名称，':suffix'是变形器的静态规则。

让我们假设你想用后缀'html'做为布局脚本的文件扩展名，并且想分离混合大小写字和驼峰字为下划线而不是短横线，还不想使用小写字母。另外，你想让它去'layouts'子目录去找脚本。

.. code-block:: php
   :linenos:

   <?php
   $layout->getInflector()->setTarget('layouts/:script.:suffix')
                          ->setStaticRule('suffix', 'html')
                          ->setFilterRule(array('CamelCaseToUnderscore'));
   ?>
.. _zend.layout.advanced.inflector.custom:

.. rubric:: 定制变形器（inflectors）

在大多数情况下，修改已存在的变形器已经足够。然而，你可能想有一个在多个地方使用的变形器，并带有不同的对象和类型。
*Zend_Layout*\ 支持它。

.. code-block:: php
   :linenos:

   <?php
   $inflector = new Zend_Filter_Inflector('layouts/:script.:suffix');
   $inflector->addRules(array(
       ':script' => array('CamelCaseToUnderscore'),
       'suffix'  => 'html'
   ));
   $layout->setInflector($inflector);
   ?>
.. note::

   **变形（Inflection）可以被禁止**

   在 *Zend_Layout*\
   对象种用访问器可以禁止和允许变形。这对想指定绝对路径给布局视图脚本来说很有用，或者知道指定布局脚本不需要变形的机制，简单地使用
   *enableInflection()* 和 *disableInflection()* 方法。


