.. _zend.layout.options:

Zend_Layout 配置选项
================

*Zend_Layout*\ 有多种配置选项。这些都可以用调用适当的访问器来设置，传递数组或
*Zend_Config*\ 对象给构造器或 *startMvc()*\ ，传递选项数组给 *setOptions()*\ ，或传递
*Zend_Config*\ 对象给to *setConfig()*\ 。

- **layout**\
  ：被使用的布局。使用当前变形器来解析提供给合适的布局视图脚本的名称。缺省地，这个值是'layout'并解析为'layout.phtml'。访问器是
  *setLayout()* 和 *getLayout()*\ 。

- **layoutPath**: 布局视图脚本的基本路径。访问器是 *setLayoutPath()* 和 *getLayoutPath()*\ 。

- **contentKey**: 用于缺省内容（和MVC一起使用）的布局变量。缺省值是'content'。访问器是
  *setContentKey()* 和 *getContentKey()*\ 。

- **mvcSuccessfulActionOnly**:
  当使用MVC，当动作抛出一个异常并且这个标志为true，布局将不被解析（这是为了防止当
  :ref:`ErrorHandler plugin <zend.controller.plugins.standard.errorhandler>`
  在使用时，布局被双重解析）。缺省地，这个标记是true。访问器是
  *setMvcSuccessfulActionOnly()* 和 *getMvcSuccessfulActionOnly()*\ 。

- **view**:
  当解析时使用的视图对象。当和MVC一起使用时，如果没有视图对象被显式传递，
  *Zend_Layout* 将尝试使用用 :ref:`the ViewRenderer <zend.controller.actionhelpers.viewrenderer>`
  注册的视图对象。访问器是 *setView()* 和 *getView()*\ 。

- **helperClass**: 当和MVC组件一起使用 *Zend_Layout* 时的动作助手。 缺省是
  *Zend_Layout_Controller_Action_Helper_Layout*\ 。访问器是 *setHelperClass()* 和 *getHelperClass()*\ 。

- **pluginClass**: 当和MVC组件一起使用 *Zend_Layout* 时的前端控制器插件类。缺省是
  *Zend_Layout_Controller_Plugin_Layout*\ 。访问器是 *setPluginClass()* 和 *getPluginClass()*\ 。

- **inflector**: 当解析布局名给布局视图脚本路径时的变形器；参见 :ref:`Zend_Layout
  变形器文档有更多细节 <zend.layout.advanced.inflector>`\ 。访问器是 *setInflector()* 和
  *getInflector()*\ 。

.. note::

   **助手类和插件类必须传递给startMvc()**

   为了 *helperClass*\ 和 *pluginClass*\ 设置有效，它们必须作为选项传递给 *startMvc()*\
   ；如果以后设置，它们就没有影响。

.. _zend.layout.options.examples:

范例
--

下面的例子假定使用 *$options*\ 数组和 *$config*\ 对象：

.. code-block::
   :linenos:
   <?php
   $options = array(
       'layout'     => 'foo',
       'layoutPath' => '/path/to/layouts',
       'contentKey' => 'CONTENT',           // ignored when MVC not used
   );
   ?>
.. code-block::
   :linenos:
   <?php
   /**
   [layout]
   layout = "foo"
   layoutPath = "/path/to/layouts"
   contentKey = "CONTENT"
   */
   $config = new Zend_Config_Ini('/path/to/layout.ini', 'layout');
   ?>
.. _zend.layout.options.examples.constructor:

.. rubric:: 传递选项给构造器或startMvc()

为了配置 *Zend_Layout*\ 实例，构造器和 *startMvc()*
静态方法都可以接受选项数组或带有选项的 *Zend_Config* 对象。

首先，看一下传递数组：

.. code-block::
   :linenos:
   <?php
   // Using constructor:
   $layout = new Zend_Layout($options);

   // Using startMvc():
   $layout = Zend_Layout::startMvc($options);
   ?>
现在使用配置对象：

.. code-block::
   :linenos:
   <?php
   $config = new Zend_Config_Ini('/path/to/layout.ini', 'layout');

   // Using constructor:
   $layout = new Zend_Layout($config);

   // Using startMvc():
   $layout = Zend_Layout::startMvc($config);
   ?>
基本上，这是定制 *Zend_Layout*\ 实例的最简单的方法。

.. _zend.layout.options.examples.setoptionsconfig:

.. rubric:: 使用setOption() 和 setConfig()

有时候在 *Zend_Layout* 对象初始化以后才需要配置； *setOptions()* 和 *setConfig()*\
让你快速而起容易地来做：

.. code-block::
   :linenos:
   <?php
   // Using an array of options:
   $layout->setOptions($options);

   // Using a Zend_Config object:
   $layout->setConfig($options);
   ?>
然而要注意特定的选项，如 *pluginClass* 和 *helperClass*\
，当用这个方法传递，将没有效果；它们需要传递给构造器或者 *startMvc()* 方法。

.. _zend.layout.options.examples.accessors:

.. rubric:: 使用访问器

最后，通过访问器来配置 *Zend_Layout*
实例。所有的访问器实现一个流畅的接口，意味这它们的调用可能被链接：

.. code-block::
   :linenos:
   <?php
   $layout->setLayout('foo')
          ->setLayoutPath('/path/to/layouts')
          ->setContentKey('CONTENT');
   ?>

