.. _learning.view.placeholders.intro:

Introduction
============

Dans :ref:`le chapitre précédent <learning.layout>`, nous avons abordé le pattern Two Step View, qui permet
d'encapsuler des vues individuelles dans un layout plus global. A la fin du chapitre, cependant, nous avons parlé
de certaines limites :

- Comment changer le titre de la page ?

- Comment injecter conditionnellement des scripts ou des feuilles de style dans le layout ?

- Comment créer et rendre une barre de navigation optionnelle ? Que se passe-t-il si la barre doit contenir
  conditionnellement du contenu ?

Ces questions sont traitées dans le pattern `Composite View`_. Une approche de ce pattern est de proposer du
contenu pour le layout global. Dans Zend Framework, ce mécanisme est implémenté au travers d'aides de vue
spéciales appelées "placeholders." Les placeholders permettent d'agréger du contenu et de le rendre ailleurs.



.. _`Composite View`: http://java.sun.com/blueprints/corej2eepatterns/Patterns/CompositeView.html
