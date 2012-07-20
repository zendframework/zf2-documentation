.. _zend.loader.pluginloader:

加载插件
====

很多 Zend Framework 组件支持插件，允许通过指定类的前缀和到类的文件（不需要在
*include_path* 或不需要遵循传统命名约定的文件）的路径动态加载函数。
*Zend_Loader_PluginLoader* 提供了普通的函数来完成这个工作。

*PluginLoader* 的基本用法遵循 Zend Framework
的命名约定（一个文件一个类），解析路径时，使用下划线作为路径分隔符。当决定是否加载特别的插件类，允许传递可选的类前缀来预处理。另外，路径按
LIFO 顺序来搜索。由于 LIFO
搜索和类的前缀，允许命名空间给插件，这样可以从早期注册的路径来覆盖插件。

.. _zend.loader.pluginloader.usage:

基本用例
----

首先，假定下面的目录结构和类文件，并且根（toplevel）目录和库目录在 include_path 中：

.. code-block::
   :linenos:

   application/
       modules/
           foo/
               views/
                   helpers/
                       FormLabel.php
                       FormSubmit.php
           bar/
               views/
                   helpers/
                       FormSubmit.php
   library/
       Zend/
           View/
               Helper/
                   FormLabel.php
                   FormSubmit.php
                   FormText.php

现在，创建一个插件加载器来使各种各样的视图助手仓库可用：

.. code-block::
   :linenos:
   <?php
   $loader = new Zend_Loader_PluginLoader();
   $loader->addPrefixPath('Zend_View_Helper', 'Zend/View/Helper/')
          ->addPrefixPath('Foo_View_Helper', 'application/modules/foo/views/helpers')
          ->addPrefixPath('Bar_View_Helper', 'application/modules/bar/views/helpers');
   ?>
接着用类名中添加路径时定义的前缀后面的部分来加载一个给定的视图助手：

.. code-block::
   :linenos:
   <?php
   // load 'FormText' helper:
   $formTextClass = $loader->load('FormText'); // 'Zend_View_Helper_FormText';

   // load 'FormLabel' helper:
   $formLabelClass = $loader->load('FormLabel'); // 'Foo_View_Helper_FormLabel'

   // load 'FormSubmit' helper:
   $formSubmitClass = $loader->load('FormSubmit'); // 'Bar_View_Helper_FormSubmit'
   ?>
类加载后，就可以实例化了。

.. note::

   **为一个前缀注册多个路径**

   有时候，多个路径使用相同的前缀， *Zend_Loader_PluginLoader*
   实际上为每个给定的前缀注册一个路径数组；最后注册的被首先检查，当你使用孵化器里的组件时，这相当有用。

.. note::

   **实例化时定义路径**

   你可以提供给构造器一个可选的“前缀/路径”对（或“前缀/多个路径”）数组参数：

   .. code-block::
      :linenos:
      <?php
      $loader = new Zend_Loader_PluginLoader(array(
          'Zend_View_Helper' => 'Zend/View/Helper/',
          'Foo_View_Helper'  => 'application/modules/foo/views/helpers',
          'Bar_View_Helper'  => 'application/modules/bar/views/helpers'
      ));
      ?>
*Zend_Loader_PluginLoader*
在不需要使用单态实例的情况下，也可选地允许共享插件，这是通过静态注册表来完成的，在实例化时需要注册表名作为构造器的第二个参数：

.. code-block::
   :linenos:
   <?php
   // Store plugins in static registry 'foobar':
   $loader = new Zend_Loader_PluginLoader(array(), 'foobar');
   ?>
其它使用同名注册表来实例化 *PluginLoader* 的组件将可以访问已经加载的路径和插件。

.. _zend.loader.pluginloader.paths:

处理插件路径
------

上节的例子示例如何给插件加载器添加路径，那么如何确定已经加载的路径或删除他们呢？

- 如果没有提供 *$prefix*\ ， *getPaths($prefix = null)*
  以“前缀/路径”对返回所有的路径；或者如果提供了 *$prefix*\ ， *getPaths($prefix = null)*
  返回为给定的前缀注册的路径。

- *clearPaths($prefix = null)* 将缺省地清除所有的已注册路径，或者如果提供了 *$prefix*
  并放在堆栈里，只清除和那些和给定前缀关联的路径。

- *removePrefixPath($prefix, $path = null)*
  允许有选择地清除和给定前缀相关的特定的路径。如果没有提供 *$path*
  ，所有的和前缀相关的路径被清除，如果提供了 *$path*
  并且相应的前缀存在，只有这个相关的路径被清除。

.. _zend.loader.pluginloader.checks:

测试插件和获取类的名字
-----------

有时候你想确定在执行一个动作之前是否插件类已经加载， *isLoaded()*
返回插件名的状态。

*PluginLoader* 的另一个普通用例是确定已加载类的完全合格的插件类名， *getClassName()*
提供该功能。一般地，这个和 *isLoaded()* 联合使用：

.. code-block::
   :linenos:
   <?php
   if ($loader->isLoaded('Adapter')) {
       $class   = $loader->getClassName('Adapter');
       $adapter = call_user_func(array($class, 'getInstance'));
   }
   ?>

