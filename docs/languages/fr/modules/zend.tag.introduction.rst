.. EN-Revision: none
.. _zend.tag.introduction:

Introduction
============

``Zend_Tag`` est une suite de composants permettant de manipuler des entités taguables. Ce composant propose 2
classes dans ce but, ``Zend_Tag_Item`` et ``Zend_Tag_ItemList``. Aussi, l'interface ``Zend_Tag_Taggable`` vous
permet d'utiliser vos modèles dans des tags avec ``Zend_Tag``.

``Zend_Tag_Item`` est un composant proposant les fonctionnalités basiques pour traiter des tags dans ``Zend_Tag``.
Une entités taguables consiste en un titre et un poids (nombre d'occurrences). Il existe aussi d'autres
paramètres utilisés par ``Zend_Tag``.

Pour grouper plusieurs entités ensemble, ``Zend_Tag_ItemList`` propose un itérateur de tableau et des fonctions
pour calculer le poids absolu des valeurs en fonction du poids de chaque entité.

.. _zend.tag.example.using:

.. rubric:: Utiliser Zend_Tag

Cet exemple montre comment créer une liste de tags en pondérant chacun d'eux.

.. code-block:: php
   :linenos:

   // Crée la liste
   $list = new Zend_Tag_ItemList();

   // Ajoute des entités dans la liste
   $list[] = new Zend_Tag_Item(array('title' => 'Code', 'weight' => 50));
   $list[] = new Zend_Tag_Item(array('title' => 'Zend Framework', 'weight' => 1));
   $list[] = new Zend_Tag_Item(array('title' => 'PHP', 'weight' => 5));

   // Valeurs absolues des entités
   $list->spreadWeightValues(array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));

   // Sortie
   foreach ($list as $item) {
       printf("%s: %d\n", $item->getTitle(), $item->getParam('weightValue'));
   }

Ceci va afficher les 3 entités Code, Zend Framework et *PHP* avec les valeurs absolues 10, 1 et 2.


