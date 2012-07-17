
.. _zend.view.helpers.initial.cycle:

Cycle Helper
============

The ``Cycle`` helper is used to alternate a set of values.


.. _zend.view.helpers.initial.cycle.basicusage:

.. rubric:: Cycle Helper Basic Usage

To add elements to cycle just specify them in constructor or use ``assign(array $data)`` function

.. code-block:: php
   :linenos:

   <?php foreach ($this->books as $book):?>
     <tr style="background-color:<?php echo $this->cycle(array("#F0F0F0",
                                                               "#FFFFFF"))
                                                 ->next()?>">
     <td><?php echo $this->escape($book['author']) ?></td>
   </tr>
   <?php endforeach;?>

   // Moving in backwards order and assign function
   $this->cycle()->assign(array("#F0F0F0","#FFFFFF"));
   $this->cycle()->prev();
   ?>

The output

.. code-block:: php
   :linenos:

   <tr style="background-color:'#F0F0F0'">
      <td>First</td>
   </tr>
   <tr style="background-color:'#FFFFFF'">
      <td>Second</td>
   </tr>


.. _zend.view.helpers.initial.cycle.advanceusage:

.. rubric:: Working with two or more cycles

To use two cycles you have to specify the names of cycles. Just set second parameter in cycle method. ``$this->cycle(array("#F0F0F0","#FFFFFF"),'cycle2')``. You can also use setName($name) function.

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


