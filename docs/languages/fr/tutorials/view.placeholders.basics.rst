.. _learning.view.placeholders.basics:

Utilisation de base des Placeholders
====================================

Zend Framework définit une aide de vue générique ``placeholder()`` que vous pouvez utiliser pour créer vos
placeholders ("conteneurs") personnalisés. Il propose aussi une variété de placeholders pour des
fonctionnalités très demandées comme préciser un **DocType**, le titre d'une page, etc.

Tous les placeholders agissent de la même manière. Ce sont des conteneurs, et donc vous pouvez les manipuler
comme des collections. Vous pouvez ainsi :

- **Ajouter (append)** ou **préfixer(prepend)** des entités dans la collection.

- **Remplacer (replace)** toute la collection avec une seule valeur.

- Spécifier une chaîne utilisée pour **préfixer le contenu** de la collection lors de son rendu.

- Spécifier une chaîne utilisée pour **ajouter le contenu** de la collection lors de son rendu.

- Spécifier une chaîne utilisée pour **séparer du contenu** de la collection lors de son rendu.

- **Capturer du contenu** dans la collection.

- **Rendre** le contenu agrégé.

Typiquement, vous appelerez cette aide de vue sans argument, ce qui retournera le conteneur sur lequel opérer.
Après vous afficherez (echo) ce contenu ou appelerez une méthode dessus pour le remplir ou le configurer. Si le
conteneur est vide, son rendu sera une simple chaîne vide, sinon, le contenu sera aggrégé en fonction des
règles que vous avez fixées.

Par exemple, créons une barre de menu qui contient des "blocs" de contenu. Supposons que la structure de chaque
bloc ressemble à ceci :

.. code-block:: html
   :linenos:

   <div class="sidebar">
       <div class="block">
           <p>
               Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus
               consectetur aliquet odio ac consectetur. Nulla quis eleifend
               tortor. Pellentesque varius, odio quis bibendum consequat, diam
               lectus porttitor quam, et aliquet mauris orci eu augue.
           </p>
       </div>
       <div class="block">
           <ul>
               <li><a href="/some/target">Link</a></li>
               <li><a href="/some/target">Link</a></li>
           </ul>
       </div>
   </div>

Le contenu variera en fonction du contrôleur et de l'action, mais la structure est identique, elle. Configurons en
premier lieu la barre de menu dans une méthode du bootstrap :

.. code-block:: php
   :linenos:

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       // ...

       protected function _initSidebar()
       {
           $this->bootstrap('View');
           $view = $this->getResource('View');

           $view->placeholder('sidebar')
                // "prefix" -> contenu à afficher une fois avant les données
                // dans la collection
                ->setPrefix("<div class=\"sidebar\">\n    <div class=\"block\">\n")
                // "separator" -> contenu à afficher entre chaque entité de
                // la collection
                ->setSeparator("</div>\n    <div class=\"block\">\n")
                // "postfix" -> contenu à afficher une fois après les données
                // dans la collection
                ->setPostfix("</div>\n</div>");
       }

       // ...
   }

Le code ci-dessus définit un placeholder, "sidebar", qui n'a pas d'entité. Ce code configure la structure de base
du placeholder, selon nos désirs.

Maintenant supposons que pour toutes les actions du contrôleur "user" nous voulons un bloc en haut qui contienne
des informations. Nous pouvons faire cela de deux manières : (a) nous pourrions ajouter le contenu au placeholder
directement dans la méthode ``preDispatch()`` du contrôleur, ou (b) nous pourrions rendre un script de vue depuis
la méthode ``preDispatch()``. Nous utiliserons le cas (b), car il propose une séparation propre des logiques en
laissant la vue classique contenir ses données utiles.

Nous appelerons le script de vue "``user/_sidebar.phtml``", et nous le remplirons comme ceci :

.. code-block:: php
   :linenos:

   <?php $this->placeholder('sidebar')->captureStart() ?>
   <h4>User Administration</h4>
   <ul>
       <li><a href="<?php $this->url(array('action' => 'list')) ?>">
           List</a></li>
       <li><a href="<?php $this->url(array('action' => 'create')) ?>">
           Create</a></a></li>
   </ul>
   <?php $this->placeholder('sidebar')->captureEnd() ?>

L'exemple ci-dessus utilise les possibilités de capture dynamique de contenu des placeholders. Par défaut, le
contenu est ajouté à la suite ce qui permet d'en agréger. Cet exemple utilise des aides de vues et du contenu
*HTML* statique pour générer un menu qui est capturé et ajouté au placeholder.

Pour utiliser le script de vue, nous écrirons ceci dans la méthode ``preDispatch()``\  :

.. code-block:: php
   :linenos:

   class UserController extends Zend_Controller_Action
   {
       // ...

       public function preDispatch()
       {
           // ...

           $this->view->render('user/_sidebar.phtml');

           // ...
       }

       // ...
   }

Notez que nous ne capturons pas le rendu, il n'y a pas besoin car le contenu complet de ce script de vue est déja
capturé dans un placeholder.

Maintenant imaginons que l'action "view" dans ce même contrôleur ait besoin de présenter des informations. Dans
"``user/view.phtml``" il pourrait y avoir ceci :

.. code-block:: php
   :linenos:

   $this->placeholder('sidebar')
        ->append('<p>User: ' . $this->escape($this->username) .  '</p>');

Cet exemple utilise la méthode ``append()`` et lui passe du contenu à agréger.

Enfin, modifions le script de layout pour rendre le placeholder :

.. code-block:: php
   :linenos:

   <html>
   <head>
       <title>My Site</title>
   </head>
   <body>
       <div class="content">
           <?php echo $this->layout()->content ?>
       </div>
       <?php echo $this->placeholder('sidebar') ?>
   </body>
   </html>

Pour les contrôleurs et les actions que ne remplissent pas le placeholder "sidebar", aucun contenu ne sera
rendu ; cependant afficher le placeholder rendra le contenu "fixe" suivant les règles définies dans le bootstrap
ainsi que le contenu agrégé dans l'application. Dans le cas de l'action "``/user/view``", en supposant que le nom
de l'utilisateur est "matthew", nous pouvons récupérer le contenu de la barre de menu comme ceci (formaté pour
la lisibilité de l'exemple) :

.. code-block:: html
   :linenos:

   <div class="sidebar">
       <div class="block">
           <h4>User Administration</h4>
           <ul>
               <li><a href="/user/list">List</a></li>
               <li><a href="/user/create">Create</a></a></li>
           </ul>
       </div>
       <div class="block">
           <p>User: matthew</p>
       </div>
   </div>

Les possibilités sont immenses en ce qui concerne les placeholders et les layouts, essayez les et lisez les
:ref:`sections relatives du manuel <zend.view.helpers.initial.placeholder>` pour plus d'informations.


