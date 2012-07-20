.. _zend.exception.using:

使用“异常”
======

Zend Framework 抛出的所有异常都必须是 Zend_Exception 的子类的对象。

.. _zend.exception.using.example:

.. rubric:: 捕捉一个异常的例子

.. code-block::
   :linenos:
   <?php

   try {
       Zend_Loader::loadClass('nonexistantclass');
   } catch (Zend_Exception $e) {
       echo "Caught exception: " . get_class($e) . "\n";
       echo "Message: " . $e->getMessage() . "\n";
       // 处理错误的代码
   }
请仔细查看ZF手册，了解具体的每种异常是由哪些方法抛出的，其抛出条件，还有具体是
Zend_Exception 的哪个子类的实例。


