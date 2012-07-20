.. _zend.view.helpers.initial.partial:

区域助手（Partial Helper）
====================

*Partial*
视图助手被用来在它自己的变量范围内解析特定的模板。主要用法是（解析）可重用的模板片段，你不需要操心变量名的冲突。另外，它们让你从特定的模块指定
partial 视图脚本。

*Partial* 的兄弟 *PartialLoop* 视图助手允许传递可迭代数据并为每个条目解析一部分。

.. _zend.view.helpers.initial.partial.usage:

.. rubric:: Partials 的基本用法

partials 的基本用法是在它自己的视图范围内解析一个模板的片段。

.. code-block::
   :linenos:

   <?php // partial.phtml ?>
   <ul>
       <li>From: <?= $this->escape($this->from) ?></li>
       <li>Subject: <?= $this->escape($this->subject) ?></li>
   </ul>

你可以这样从视图脚本里调用它：

.. code-block::
   :linenos:

   <?= $this->partial('partial.phtml', array(
       'from' => 'Team Framework',
       'subject' => 'view partials')); ?>

解析结果如下：

.. code-block::
   :linenos:

   <ul>
       <li>From: Team Framework</li>
       <li>Subject: view partials</li>
   </ul>

.. note::

   **什么是模型（model）?**

   和 *Partial*
   视图助手一起使用的模型（即partial()的第二个参数，Haohappy注）可以是下列其中之一：

   - **数组**\ 。如果传递了数组，它应当是联合数组，因为它的 ‘键/值’
     对用作为视图变量的键赋值给视图。

   - **实现了toArray() 方法的对象**\ 。如果被传递的对象有 *toArray()* 方法， *toArray()*\
     的结果将被当作视图变量赋值给视图对象。

   - **标准对象**\ 。 任何其它对象将把 *object_get_vars()*\
     的结果（对象的所有公共属性）赋值给视图对象。

   如果你的模型是一个对象，你可能想让它 **作为对象**\ 传递给 partial
   脚本，而不是把它系列化成一个数组变量。 你可以通过设置适当的助手的 'objectKey'
   属性来完成这个：

   .. code-block::
      :linenos:

      // Tell partial to pass objects as 'model' variable
      $view->partial()->setObjectKey('model');

      // Tell partial to pass objects from partialLoop as 'model' variable in final
      // partial view script:
      $view->partialLoop()->setObjectKey('model');

   当传递 *Zend_Db_Table_Rowset*\ s 给 *partialLoop()*\ 时这个技术相当有用，
   因为你在视图脚本里有全部访问 row
   对象的权限，允许你调用它们的方法（如从父或依赖的 rows 获取数据）。

.. _zend.view.helpers.initial.partial.partialloop:

.. rubric:: 使用 PartialLoop 来解析可迭代的（Iterable）的模型

可能你常常会需要在一个循环里使用 partials
来输出相同的内容片段多次，这时你就可以把大块的重复的内容或复杂的显示逻辑放到一个地方。然而这对性能有影响，因为partial助手需要在每个迭代里调用一次。

*PartialLoop* 视图助手解决了这个问题。 它允许你把迭代条目（实现 *Iterator*\
的数组或对象）当做模型来传递。它这些把这些条目当作模型迭代、传递给 partial
脚本。在迭代器里的条目可以是 *Partial* 视图助手允许的任何模型。

让我们看一下下面的 partial 视图脚本：

.. code-block::
   :linenos:

   <? // partialLoop.phtml ?>
       <dt><?= $this->key ?></dt>
       <dd><?= $this->value ?></dd>


添加下列 "model"：

.. code-block::
   :linenos:
   <?php
   $model = array(
       array('key' => 'Mammal', 'value' => 'Camel'),
       array('key' => 'Bird', 'value' => 'Penguin'),
       array('key' => 'Reptile', 'value' => 'Asp'),
       array('key' => 'Fish', 'value' => 'Flounder'),
   );
   ?>
在视图脚本中，你可以这样调用 *PartialLoop* 助手：

.. code-block::
   :linenos:

   <dl>
   <?= $this->partialLoop('partialLoop.phtml', $model) ?>
   </dl>

.. code-block::
   :linenos:

   <dl></dl>
       <dt>Mammal</dt>
       <dd>Camel</dd>

       <dt>Bird</dt>
       <dd>Penguin</dd>

       <dt>Reptile</dt>
       <dd>Asp</dd>

       <dt>Fish</dt>
       <dd>Flounder</dd>

   </dl>

.. _zend.view.helpers.initial.partial.modules:

.. rubric:: 在其它模块中解析 Partials

有时候 partial
存在于不同的模块(Module)。如果你知道模块的名称，你可以把它当作第二个参数传递给
*partial()* 或者 *partialLoop()*\ ，把 *$model* 作为第三个参数。

例如，如果一个你想用一个在 'list' 模块的 pager partial，就象下面这样来运用：

.. code-block::
   :linenos:

   <?= $this->partial('pager.phtml', 'list', $pagerData) ?>

这样，你可以重用原来是特别供给其它模块使用的 partials
。所以，在共享的视图脚本路径里放置可重用的 partials 很可能是个好习惯。


