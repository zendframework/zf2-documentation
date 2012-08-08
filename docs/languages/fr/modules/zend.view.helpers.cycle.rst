.. EN-Revision: none
.. _zend.view.helpers.initial.cycle:

Aide Cycle
==========

L'aide *Cycle* est utilisée pour alterner des valeurs.

.. _zend.view.helpers.initial.cycle.basicusage:

.. rubric:: Aide Cycle : utilisation de base

Pour ajouter des éléments dans le cycle, spécifiez le simplement dans le constructeur ou utilisez ``assign(array
$data)``

.. code-block:: php
   :linenos:

   <?php foreach ($this->books as $book):?>
     <tr style="background-color:<?php echo $this->cycle(array("#F0F0F0",
                                                               "#FFFFFF"))
                                                 ->next()?>">
     <td><?php echo $this->escape($book['author']) ?></td>
   </tr>
   <?php endforeach;?>

   // Mouvement dans le sens inverse
   $this->cycle()->assign(array("#F0F0F0","#FFFFFF"));
   $this->cycle()->prev();
   ?>

La sortie:

.. code-block:: php
   :linenos:

   <tr style="background-color:'#F0F0F0'">
      <td>First</td>
   </tr>
   <tr style="background-color:'#FFFFFF'">
      <td>Second</td>
   </tr>

.. _zend.view.helpers.initial.cycle.advanceusage:

.. rubric:: Travailler avec 2 cycles ou plus

Pour utiliser 2 cycles, il faut renseigner leurs noms. Ca se passe au niveau du second paramètre de la méthode
cycle. *$this->cycle(array("#F0F0F0","#FFFFFF"),'cycle2')*. setName($name) peut aussi être utilisée.

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


