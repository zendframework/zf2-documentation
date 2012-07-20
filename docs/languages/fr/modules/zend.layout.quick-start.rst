.. _zend.layout.quickstart:

Zend_Layout - Démarrage rapide
==============================

Il y a deux modes d'utilisation de ``Zend_Layout``: avec Zend Framework *MVC*, et sans.

.. _zend.layout.quickstart.layouts:

Scripts de layout
-----------------

Dans tous les cas, un script de layout est nécessaire. Les scripts de layout utilisent simplement Zend_View (ou
une implémentation particulière personnalisée). Les variables de layout sont enregistrées dans le
:ref:`placeholder <zend.view.helpers.initial.placeholder>` *Layout*, et peuvent être accédées via l'aide de vue
placeholder ou directement en tant que propriétés de l'objet layout.

Par exemple :

.. code-block:: php
   :linenos:

   <!DOCTYPE html
       PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
   <html>
   <head>
       <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
       <title>Mon Site</title>
   </head>
   <body>
   <?php
       // récupère la clé "content" via l'aide de vue layout :
       echo $this->layout()->content;

       // récupère la clé "foo" via l'aide de vue placeholder :
       echo $this->placeholder('Zend_Layout')->foo;

       // récupère l'objet layout, et accède à diverses clés :
       $layout = $this->layout();
       echo $layout->bar;
       echo $layout->baz;
   ?>
   </body>
   </html>

Toutes les aides de vue enregistrées sont accessibles dans ``Zend_Layout`` car il utilise ``Zend_View`` pour son
propre rendu. Vous pouvez aussi accéder aux variables de la vue. Les aides :ref:`placeholder
<zend.view.helpers.initial.placeholder>` sont très pratiques pour l'accès aux éléments tels que <head>, les
scripts, les méta, etc. :

.. code-block:: php
   :linenos:

   <!DOCTYPE html
       PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
   <html>
   <head>
       <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
       <?php echo $this->headTitle() ?>
       <?php echo $this->headScript() ?>
       <?php echo $this->headStyle() ?>
   </head>
   <body>
       <?php echo $this->render('header.phtml') ?>

       <div id="nav"><?php echo $this->placeholder('nav') ?></div>

       <div id="content"><?php echo $this->layout()->content ?></div>

       <?php echo $this->render('footer.phtml') ?>
   </body>
   </html>

.. _zend.layout.quickstart.mvc:

Utilisation de Zend_Layout avec le système MVC de Zend Framework
----------------------------------------------------------------

``Zend_Controller`` propose une manière d'étendre ses fonctionnalités au travers de :ref:`plugins de contrôleur
frontal <zend.controller.plugins>` et :ref:`d'aides d'action <zend.controller.actionhelpers>`. ``Zend_View``
propose aussi des :ref:`aides <zend.view.helpers>`. ``Zend_Layout`` utilise toutes ces possibilités
lorsqu'employé avec les composants *MVC*.

``Zend_Layout::startMvc()`` crée une instance de ``Zend_Layout`` avec des paramètres de configuration optionnels.
Cette méthode enregistre aussi un plugin de contrôleur frontal qui s'occupe du rendu du layout rempli, lorsque la
boucle de distribution est terminée. Elle enregistre également une aide d'action qui permet aux actions
d'accéder à l'objet *layout*. Enfin, l'aide de vue layout, elle, donne accès à l'objet layout depuis la vue.

Regardons d'abord comment initialiser Zend_Layout afin de l'utiliser dans un contexte *MVC*

.. code-block:: php
   :linenos:

   // Dans le fichier de démarrage (bootstrap)
   Zend_Layout::startMvc();

``startMvc()`` peut prendre en paramètre un tableau d'options ou un objet ``Zend_Config`` pour personnaliser
l'instance. Ces options sont détaillées dans :ref:` <zend.layout.options>`.

Dans le contrôleur d'action, vous pouvez donc accéder à l'instance de layout via l'aide d'action :

.. code-block:: php
   :linenos:

   class FooController extends Zend_Controller_Action
   {
       public function barAction()
       {
           // désactive les layouts pour cette action
           $this->_helper->layout->disableLayout();
       }

       public function bazAction()
       {
           // utilise un script de layout différent pour
           // cette action
           $this->_helper->layout->setLayout('foobaz');
       };
   }

Dans vos scripts de vue, utiliser l'aide *layout* pour accéder à l'instance de ``Zend_Layout``. Notez que cette
aide est différente des autres car elle ne retourne pas une chaîne, mais bien un objet. Vous pouvez donc
enchaîner une méthode immédiatement :

.. code-block:: php
   :linenos:

   $this->layout()->setLayout('foo'); // utilise un script de layout spécifique

Autrement, vous pouvez n'importe où accéder à votre instance de ``Zend_Layout`` via la méthode statique
``getMvcInstance()``:

.. code-block:: php
   :linenos:

   // Retourne null si startMvc() n'a pas été appelée auparavant
   $layout = Zend_Layout::getMvcInstance();

Enfin, le plugin de contrôleur frontal ``Zend_Layout`` dispose d'une caractéristique annexe au rendu automatique
du layout : il analyse les segments de l'objet de réponse et les assigne en tant que variables de layout dans vos
scripts de layout. Le segment "default" est assigné à la variable "content". Ceci permet de mettre la main sur le
contenu rendu dans l'action principale.

Par exemple, supposons que votre code rencontre d'abord ``FooController::indexAction()``, qui va rendre du contenu
dans le segment par défaut de la réponse. Ensuite il forward vers ``NavController::menuAction()``, qui rend son
contenu dans un segment nommé 'nav'. Enfin, vous forwardez vers ``CommentController::fetchAction()`` pour
récupérer des commentaires, mais vous les rendez aussi dans le segment par défaut de la réponse (ce qui va
rajouter du contenu). Votre script de layout peut alors rendre chaque segment de manière séparée :

.. code-block:: php
   :linenos:

   <body>
       <!-- rend /nav/menu -->
       <div id="nav"><?php echo $this->layout()->nav ?></div>

       <!-- rend /foo/index + /comment/fetch -->
       <div id="content"><?php echo $this->layout()->content ?></div>
   </body>

Cette approche est particulièrement utile avec :ref:`l'aide d'action <zend.controller.actionhelpers.actionstack>`
ActionStack et son :ref:`plugin <zend.controller.plugins.standard.actionstack>` du même nom. Vous pouvez les
utiliser pour gérer une pile d'actions et ainsi décomposer vos processus.

.. _zend.layout.quickstart.standalone:

Utilisation de Zend_Layout en composant indépendant
---------------------------------------------------

Pris indépendamment des composants *MVC*, Zend_Layout n'offre pas tout à fait les mêmes possibilités et la
même flexibilité. Cependant, vous bénéficiez de deux avantages :

- Des variables propres aux layouts.

- Isolation du script de layout, de son contenu issu des scripts de vue.

En tant que composant indépendant, instanciez un objet ``Zend_Layout``, configurez le au moyen d'accesseurs,
passez vos variables comme des propriétés de l'objet, et rendez le layout :

.. code-block:: php
   :linenos:

   $layout = new Zend_Layout();

   // Spécification du chemin des scripts layout:
   $layout->setLayoutPath('/chemin/vers/layouts');

   // passage de quelques variables :
   $layout->content = $content;
   $layout->nav     = $nav;

   // Utilisation d'un script de layout "foo" :
   $layout->setLayout('foo');

   // rendu du layout :
   echo $layout->render();

.. _zend.layout.quickstart.example:

Layout d'exemple
----------------

Une image valant mieux qu'un paragraphe, voyez donc celle-ci qui décrit l'utilisation :

.. image:: ../images/zend.layout.quickstart.example.png
   :align: center

Avec cette approche, vous pouvez régler vos mises en forme *CSS*. En positionnement absolu, par exemple, vous
pourriez rendre la barre de navigation plus tard, en fin. Le mécanisme d'obtention du contenu reste le même
cependant.


