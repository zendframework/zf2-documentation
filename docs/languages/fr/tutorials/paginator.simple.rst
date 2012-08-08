.. EN-Revision: none
.. _learning.paginator.simple:

Exemples simples
================

Dans ce premier exemple nous n'allons rien faire de magnifique, mais ça donnera une bonne idée de l'utilité de
``Zend_Paginator``. Imaginons un tableau $data qui contient les chiffres de 1 à 100, nous voulons le diviser en un
nombre de pages. Nous pouvons utiliser la méthode statique ``factory()`` de ``Zend_Paginator`` pour récupérer un
objet ``Zend_Paginator`` avec notre tableau à l'intérieur.

.. code-block:: php
   :linenos:

   // Créer un tableau contenant les chiffres de 1 à 100
   $data = range(1, 100);

   // Récupérons un objet Paginator grâce à la fabrique.
   $paginator = Zend_Paginator::factory($data);

C'est presque terminé! La variable $paginator contient une référence vers l'objet Paginator. Par défaut il
servira 10 entités par page. Pour afficher les données sur la page, il suffit d'itérer sur l'objet Paginator
dans une boucle foreach. La page en cours est par défaut la première, nous verrons comment choisir une page
après. Le code ci-après affiche une liste qui contient les chiffres de 1 à 10, ce sont les chiffres de la
première page.

.. code-block:: php
   :linenos:

   // Créer un tableau contenant les chiffres de 1 à 100
   $data = range(1, 100);

   // Récupérons un objet Paginator grâce à la fabrique.
   $paginator = Zend_Paginator::factory($data);

   ?><ul><?php

   // Rendu de chaque donnée dans une liste
   foreach ($paginator as $item) {
       echo '<li>' . $item . '</li>';
   }

   ?></ul>

Essayons maintenant de récupérer les données de la deuxième page. Vous pouvez utiliser la méthode
``setCurrentPageNumber()`` pour choisir la page.

.. code-block:: php
   :linenos:

   // Créer un tableau contenant les chiffres de 1 à 100
   $data = range(1, 100);

   // Récupérons un objet Paginator grâce à la fabrique.
   $paginator = Zend_Paginator::factory($data);

   // Selection de la page 2
   $paginator->setCurrentPageNumber(2);

   ?><ul><?php

   // Rendu de chaque donnée dans une liste
   foreach ($paginator as $item) {
       echo '<li>' . $item . '</li>';
   }

   ?></ul>

Bien sûr ici, ce sont les chiffres 1 à 20 qui s'affichent.

Ces quelques exemples simplifiés sont loin de tout montrer sur ``Zend_Paginator``. Une application réelle ne lit
pas ses données depuis un tableau c'est pourquoi la section suivante montre comment utiliser le Paginator avec des
résultats d'une requête sql. Au besoin, familiarisez vous avec ``Zend_Db_Select``.

Dans l'exemple utilisant une base de données, nous chercherons des billets de blog appelés 'posts'. La table des
'posts' a quatre colonnes: id, title, body, date_created. Voyons un exemple simple.

.. code-block:: php
   :linenos:

   // Créons un objet select qui récupère des billets et les range par date de création descendante
   $select = $db->select()->from('posts')->sort('date_created DESC');

   // Créons un paginateur pour cette requête
   $paginator = Zend_Paginator::factory($select);

   // Selection de la page 2
   $paginator->setCurrentPageNumber(2);

   ?><ul><?php

   // Affichage du titre de chaque billet pour la page en cours
   foreach ($paginator as $item) {
       echo '<li>' . $item->title . '</li>';
   }

   ?></ul>

Comme vous le voyez, cet exemple n'est pas très différent du précédent. La seule différence est
``Zend_Db_Select`` qui est passé à la méthode ``factory()`` à la place d'un tableau. Pour plus de détails
notamment sur l'optimisation de la requête de l'objet select, lisez le chapitre sur les adaptateurs DbSelect et
DbTableSelect de la documentation de ``Zend_Paginator``.


