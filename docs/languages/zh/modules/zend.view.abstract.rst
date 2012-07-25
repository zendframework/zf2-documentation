.. _zend.view.abstract:

Zend_View_Abstract
==================

*Zend_View_Abstract* 是个基础类， *Zend_View* 就是继承它的并声明 *_run()* 方法的具体实现
（由 *render()* 调用 ）。

很多开发者发现他们想继承 *Zend_View_Abstract*
并添加自定义的函数，不可避免地碰到它的包括许多私有成员的设计问题。本文档解释其中缘由。

*Zend_View* 有点反模板引擎，它使用 PHP 本身作为模板，结果所有的 PHP
可用并且视图脚本继承了它所调用对象的范围 （scope）。

It is this latter point that is salient to the design decisions. 在内部， *Zend_View::_run()* 做：

.. code-block:: php
   :linenos:

   <?php
   protected function _run()
   {
       include func_get_arg(0);
   }
   ?>
这样，视图脚本拥有访问当前对象 (*$this*) **和任何那个对象的方法和成员**
的权限，因为许多操作基于有限可见性的成员，这会引起问题：视图脚本可以直接调用方法或修改至关重要的属性。想象一下脚本意外地重写
*$_path* 或 *$_file* －任何进一步地调用 *render()* 或视图助手将会中断。

幸好，PHP 5 对这个可见性声明有个方案：私有成员（private
member）不能由继承该类的对象访问。所以我们就这样设计：因为 *Zend_View* **继承**
*Zend_View_Abstract*\ ，视图脚本就这样限制到只有 *Zend_View_Abstract* 的 protected 或 public
成员和方法。这样有效地限制了它可以执行的动作，保证了关键的安全区域不被视图脚本修改。


