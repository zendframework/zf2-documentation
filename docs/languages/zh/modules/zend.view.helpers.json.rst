.. _zend.view.helpers.initial.json:

JSON 助手
===========

当创建返回 JSON 的视图，设置适当的响应头也非常重要，JSON
视图助手就是来做这个的。另外，缺省地，它关闭（disable）了布局（如果布局是打开（enable）的），因为布局一般不和
JSON 响应一起使用。

JSON 助手设置下列的头：

.. code-block::
   :linenos:

   Content-Type: application/json

当解析响应来决定如何处理内容，大部分 AJAX 库寻找这个头。

JSON 助手的用法相当简单：

.. code-block::
   :linenos:
   <?php
   <?= $this->json($this->data) ?>
   ?>

