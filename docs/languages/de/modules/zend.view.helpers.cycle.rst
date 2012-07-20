.. _zend.view.helpers.initial.cycle:

Cycle Helfer
============

Der ``Cycle`` Helfer wird verwendet um ein Set von Werte zu ändern.

.. _zend.view.helpers.initial.cycle.basicusage:

.. rubric:: Grundsätzliche Verwendung des Cycle Helfers

Um Elemente hinzuzufügen die man durchlaufen will müssen diese im Constructor spezifiziert oder die
``assign(array $data)`` Funktion verwendet werden.

.. code-block:: php
   :linenos:

   <?php foreach ($this->books as $book):?>
     <tr style="background-color:<?php echo $this->cycle(array("#F0F0F0",
                                                               "#FFFFFF"))
                                                 ->next()?>">
     <td><?php echo $this->escape($book['author']) ?></td>
   </tr>
   <?php endforeach;?>

   // Rückwärts bewegen und die assign Funktion verwenden
   $this->cycle()->assign(array("#F0F0F0","#FFFFFF"));
   $this->cycle()->prev();
   ?>

Die Ausgabe

.. code-block:: php
   :linenos:

   <tr style="background-color:'#F0F0F0'">
      <td>Erstes</td>
   </tr>
   <tr style="background-color:'#FFFFFF'">
      <td>Zweites</td>
   </tr>

.. _zend.view.helpers.initial.cycle.advanceusage:

.. rubric:: Mit einem oder mehreren Zyklen arbeiten

Um zwei Zyklen zu verwenden muß man den Namen des Zyklus verwenden. Einfach zwei Parameter in der cycle Methode
setzen. ``$this->cycle(array("#F0F0F0","#FFFFFF"),'cycle2')``. Man kann auch die setName($name) Funktion verwenden.

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


