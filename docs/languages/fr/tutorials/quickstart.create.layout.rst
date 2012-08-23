.. EN-Revision: none
.. _learning.quickstart.create-layout:

Créer une layout
================

Vous avez remarqué que les scripts de vue dans les sections précédentes étaient des fragments de *HTML*, pas
des pages complètes. C'est le design : nous voulons que nos actions retournent du contenu uniquement relatif à
elles mêmes et non de l'application en général.

Maintenant nous devons introduire le contenu généré dans une page entière *HTML*. Nous utiliserons un layout
global pour tout le site dans ce but.

Il y a deux designs pattern que le Zend Framework utilise pour les layouts : `Two Step View`_ et `Composite
View`_. **Two Step View** est souvent associé au pattern `Transform View`_ l'idée de base est que les vues de
l'application créent une représentation qui est ensuite injectée dans une vue plus globale. Le pattern
**Composite View** traite avec une vue fabriquée à partir de plusieurs vues applicatives.

Dans Zend Framework, :ref:`Zend_Layout <zend.layout>` combine les idées de ces patterns. Plutôt que chaque vue
inclue tout le design, chacune ne contient que ses propres données.

Par contre vous pourriez avoir besoin occasionnellement d'informations globales dans la vue générale.
Heureusement, le Zend Framework propose une variété de conteneurs appelés **placeholders** pour permettre de
stocker de telles informations depuis les scripts de vue des actions.

Pour démarrer avec ``Zend_Layout``, nous devons d'abord informer le bootstrap de l'objet ``Layout`` (ressource).
On peut activer cela au moyen de la commande ``zf enable layout``:

.. code-block:: console
   :linenos:

   % zf enable layout
   Layouts have been enabled, and a default layout created at
   application/layouts/scripts/layout.phtml
   A layout entry has been added to the application config file.

Comme le suggère la commande, ``application/configs/application.ini`` est mis à jour et contient maintenant les
informations suivantes dans la section ``production``\  :

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   ; Add to [production] section:
   resources.layout.layoutPath = APPLICATION_PATH "/layouts/scripts"

Le fichier *INI* final devrait ressembler à ceci :

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   [production]
   ; PHP settings we want to initialize
   phpSettings.display_startup_errors = 0
   phpSettings.display_errors = 0
   includePaths.library = APPLICATION_PATH "/../library"
   bootstrap.path = APPLICATION_PATH "/Bootstrap.php"
   bootstrap.class = "Bootstrap"
   appnamespace = "Application"
   resources.frontController.controllerDirectory = APPLICATION_PATH "/controllers"
   resources.frontController.params.displayExceptions = 0
   resources.layout.layoutPath = APPLICATION_PATH "/layouts/scripts"

   [staging : production]

   [testing : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

   [development : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

Cette directive indique à l'application de chercher les scripts de layout dans ``application/layouts/scripts``. Si
vous examinez votre structure de répertoires, vous verrez que ce dossier a été créé pour vous, avec le fichier
``layout.phtml``.

Nous voulons aussi nous assurer que nous avons une déclaration de DocType XHTML pour notre application. Pour
activer cela, nous devons ajouter une ressource à notre bootstrap.

La manière la plus simple d'ajouter une ressource au bootstrap est de définir une méthode protégée qui
commence par ``_init``. Dans notre cas, nous voulons initialiser le doctype et donc nous créons une méthode
``_initDoctype()``\  :

.. code-block:: php
   :linenos:

   // application/Bootstrap.php

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       protected function _initDoctype()
       {
       }
   }

Dans cette méthode, nous devons renseigner la vue au sujet du doctype. Mais d'où va provenir notre objet de
vue ? La solution simple consiste à initialiser la ressource ``View`` et la récupérer dans la méthode de
bootstrap pour l'utiliser.

Pour initialiser la vue, ajoutez la ligne suivante dans le fichier ``application/configs/application.ini``, dans la
section ``production``\  :

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   ; Add to [production] section:
   resources.view[] =

Ceci indique de charger la vue avec aucune option (les '[]' indiquent que la clé "view" est un tableau et nous ne
lui passons rien du tout).

Maintenant que nous possédons une vue, retournons à notre méthode ``_initDoctype()``. A l'intérieur, nous
allons d'abord nous assurer que la ressource ``View`` existe, puis nous la récupèrerons et la configurerons :

.. code-block:: php
   :linenos:

   // application/Bootstrap.php

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       protected function _initDoctype()
       {
           $this->bootstrap('view');
           $view = $this->getResource('view');
           $view->doctype('XHTML1_STRICT');
       }
   }

Maintenant que ``Zend_Layout`` est initialisé et que le Doctype est réglé, créons notre vue globale de
layout :

.. code-block:: php
   :linenos:

   <!-- application/layouts/scripts/layout.phtml -->
   <?php echo $this->doctype() ?>
   <html xmlns="http://www.w3.org/1999/xhtml">
   <head>
     <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
     <title>Zend Framework Quickstart Application</title>
     <?php echo $this->headLink()->appendStylesheet('/css/global.css') ?>
   </head>
   <body>
   <div id="header" style="background-color: #EEEEEE; height: 30px;">
       <div id="header-logo" style="float: left">
           <b>ZF Quickstart Application</b>
       </div>
       <div id="header-navigation" style="float: right">
           <a href="<?php echo $this->url(
               array('controller'=>'guestbook'),
               'default',
               true) ?>">Guestbook</a>
       </div>
   </div>

   <?php echo $this->layout()->content ?>

   </body>
   </html>

Nous récupérons le contenu de l'application au moyen de l'aide de vue ``layout()`` et nous accédons à la clé
"content". Vous pouvez utiliser d'autres segments de l'objet de réponse, mais dans la plupart des cas ce n'est pas
nécessaire.

Notez aussi l'utilisation du placeholer ``headLink()``. C'est un moyen simple de générer du *HTML* pour les
éléments <link> et ca permet de les garder sous le coude au travers de l'application. Si vous devez ajouter des
feuilles CSS c'est aussi possible.

.. note::

   **Checkpoint**

   Allez maintenant sur "http://localhost" et regarder le code source rendu. Vous devriez voir votre entête XHTML
   et vos sections head, title et body.



.. _`Two Step View`: http://martinfowler.com/eaaCatalog/twoStepView.html
.. _`Composite View`: http://java.sun.com/blueprints/corej2eepatterns/Patterns/CompositeView.html
.. _`Transform View`: http://www.martinfowler.com/eaaCatalog/transformView.html
