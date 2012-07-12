
Cycle Helper
============

The ``Cycle`` helper is used to alternate a set of values.

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
    


