.. EN-Revision: none
.. _zend.feed.introduction:

Introduction
============

Le composant ``Zend_Feed`` offre des services permettant de traiter des flux *RSS* et Atom. Il permet d'accéder
aux éléments d'un flux, aux attributs d'un flux et aux attributs des entrées d'un flux, tout cela au moyen d'une
syntaxe intuitive. ``Zend_Feed`` prend aussi complètement en charge la modification de la structure des flux et
des entrées, avec la même syntaxe intuitive que précédemment, et il sait transformer le résultat en *XML*. À
l'avenir, la prise en charge des modifications pourrait aussi inclure la prise en charge du protocole de
publication Atom.

Sur le plan de la programmation, ``Zend_Feed`` est constitué d'une classe de base ``Zend_Feed`` et de classes de
base abstraites ``Zend\Feed\Abstract`` et ``Zend\Feed\Entry\Abstract``, permettant de représenter respectivement
des flux et des entrées ; ``Zend_Feed`` contient aussi des implémentations particulières de ces classes
abstraites pour les flux et entrées *RSS* et Atom ainsi qu'un assistant en coulisses qui assure le bon
fonctionnement de la syntaxe intuitive.

Dans l'exemple ci-dessous, nous illustrons une utilisation simple de ``Zend_Feed``\  : on obtient un flux *RSS* et
on enregistre les portions du flux qui nous intéressent dans un tableau *PHP* simple, qui pourra ensuite être
utilisé pour afficher les données, les stocker dans une base de données etc.

.. note::

   **Attention**

   Beaucoup de flux *RSS* ont à leur disposition différentes propriétés, pour les canaux comme pour les
   éléments. La spécification *RSS* spécifie beaucoup de propriétés optionnelles et gardez donc cela à
   l'esprit lorsque vous écrivez du code qui manipule des données *RSS*.

.. _zend.feed.introduction.example.rss:

.. rubric:: Manipuler des données RSS avec Zend_Feed

.. code-block:: php
   :linenos:

   // on va chercher les dernières news de Slashdot
   try {
       $rssSlashdot =
   Zend\Feed\Feed::import('http://rss.slashdot.org/Slashdot/slashdot');
   } catch (Zend\Feed\Exception $e) {
       // l'importation du flux a échoué
       echo "Une exception a été interceptée lors de l'importation "
          . "du flux : {$e->getMessage()}\n";
       exit;
   }

   // on initialise un tableau contenant les données du canal RSS
   $canal = array(
       'titre'       => $rssSlashdot->title(),
       'lien'        => $rssSlashdot->link(),
       'description' => $rssSlashdot->description(),
       'elements'    => array()
       );

   // on itère sur chaque élément du canal et
   // on stocke les données qui nous intéressent
   foreach ($rssSlashdot as $elem) {
       $canal['elements'][] = array(
           'titre'       => $elem->title(),
           'lien'        => $elem->link(),
           'description' => $elem->description()
           );
   }


