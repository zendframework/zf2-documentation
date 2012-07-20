.. _zend.view.helpers.initial.cycle:

Cycle ヘルパー
==========

``Cycle``\ ヘルパーは 一組の値を交互に切り替えるために使われます。

.. _zend.view.helpers.initial.cycle.basicusage:

.. rubric:: Cycle ヘルパーの基本的な使用法

循環する要素を追加するためには、コンストラクタで指定するか、 ``assign(array $data)``\
関数を使います。

.. code-block:: php
   :linenos:

   <?php foreach ($this->books as $book):?>
     <tr style="background-color:<?php echo $this->cycle(array("#F0F0F0",
                                                               "#FFFFFF"))
                                                 ->next()?>">
     <td><?php echo $this->escape($book['author']) ?></td>
   </tr>
   <?php endforeach;?>

   // 後方への移動は関数に指示して割り当てます。
   $this->cycle()->assign(array("#F0F0F0","#FFFFFF"));
   $this->cycle()->prev();
   ?>

出力

.. code-block:: php
   :linenos:

   <tr style="background-color:'#F0F0F0'">
      <td>First</td>
   </tr>
   <tr style="background-color:'#FFFFFF'">
      <td>Second</td>
   </tr>

.. _zend.view.helpers.initial.cycle.advanceusage:

.. rubric:: ２つ以上の繰り返しを利用する

２つ以上の繰り返しを利用する場合は、繰り返しの名前を指定しなければなりません。
第２パラメータを cycle メソッドで設定してください。
``$this->cycle(array("#F0F0F0","#FFFFFF"),'cycle2')``. setName($name)関数を使うこともできます。

.. code-block:: php
   :linenos:

   <?php foreach ($this->books as $book):?>
     <tr style="background-color:<?php echo $this->cycle(array("#F0F0F0",
                                                               "#FFFFFF"))
                                                 ->next()?>">
     <td><?php echo $this->cycle(array(1,2,3),'number')->next()?></td>
     <td><?php echo $this->escape($book['author'])?></td>
   </tr>
   <?php endforeach;?>


