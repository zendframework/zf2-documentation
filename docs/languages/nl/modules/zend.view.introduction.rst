.. _zend.view.introduction:

Inleiding
=========

Zend_View is een klasse bestemd om met het "view" deel van het model-view-controller ontwerppatroon te werken. Meer
bepaald bestaat het om het view script gescheiden te houden van het model en controller scripts. Het verstrekt een
systeem van helpers, output filters en variabel escaping.

Zend_View is template systeem agnostisch; je mag PHP als je template taal gebruiken of instanties van andere
template systemen maken en ze binnenin je view script manipuleren.

Zend_View gebruiken gebeurt hoofdzakelijk in twee hoofdstappen: 1. Jouw controller script maakt een instantie van
Zend_View en kent er variabelen aan toe. 2. De controller vertelt Zend_View om een bepaald view weer te geven,
hierdoor de controle aan het viewscript doorgevend, welke de view output genereert.

.. _zend.view.introduction.controller:

Controller Script
-----------------

Als een eenvoudig voorbeeld, laat ons zeggen dat je controller een lijst van boekdata heeft dat het door een view
wil hebben weergegeven. Het controller script zou als volgt kunnen zijn:

.. code-block:: php
   :linenos:

   <?php
   // gebruik een model om data voor auteurs en titels van boeken te verkrijgen
   $data = array(
       array(
           'author' => 'Hernando de Soto',
           'title' => 'The Mystery of Capitalism'
       ),
       array(
           'author' => 'Henry Hazlitt',
           'title' => 'Economics in One Lesson'
       ),
       array(
           'author' => 'Milton Friedman',
           'title' => 'Free to Choose'
       )
   );

   // ken nu de boekdata aan een instantie van een Zend_View toe
   Zend_Loader::loadClass('Zend_View');
   $view = new Zend_View();
   $view->books = $data;

   // en geef het view script genaamd "boeklijst.php" weer
   echo $view->render('boeklijst.php');
   ?>

.. _zend.view.introduction.view:

View Script
-----------

Nu hebben we het geassocieerde view script, "boeklijst.php" nodig. dit is een PHP script zoals alle andere, met
één uitzondering: het voert zich uit binnenin de Zend_View instantie, wat betekent dat referenties naar $this
naar de eigenschappen en methodes van de Zend_View instantie verwijzen. (Variabelen die aan de instantie werden
toegwezen door de controller zijn publieke eigenschappen van de Zend_View instantie.) Zodoende zou een zeer
eenvoudig script er als volgt kunnen uitzien:

.. code-block:: php
   :linenos:

   <?php if ($this->books): ?>

       <!-- Een tabel van enige boeken. -->
       <table>
           <tr>
               <th>Auteur</th>
               <th>Titel</th>
           </tr>

           <?php foreach ($this->books as $key => $val): ?>
           <tr>
               <td><?php echo $this->escape($val['author']) ?></td>
               <td><?php echo $this->escape($val['title']) ?></td>
           </tr>
           <?php endforeach; ?>

       </table>

   <?php else: ?>

       <p>Er zijn geen boeken af te beelden.</p>

   <?php endif; ?>

Merk op hoe we de "escape()" methode gebruiken om output escaping op de variabelen toe te passen.


