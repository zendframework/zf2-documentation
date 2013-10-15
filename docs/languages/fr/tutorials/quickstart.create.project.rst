.. EN-Revision: none
.. _learning.quickstart.create-project:

Créer votre projet
==================

Afin de créer un projet, vous devez d'abord télécharger et extraire Zend Framework.

.. _learning.quickstart.create-project.install-zf:

Installer Zend Framework
------------------------

La manière la plus simple d'obtenir Zend Framework avec une pile *PHP* complète est d'installer `Zend Server`_.
Zend Server possède des installeurs natifs pour Mac OSX, Windows, Fedora Core, et Ubuntu, ainsi qu'un installeur
universel pour la plupart des distributions Linux.

Après avoir installé Zend Server, les fichiers du Framework devraient se trouver sous
``/usr/local/zend/share/ZendFramework`` sur Mac OSX et Linux, et ``C:\Program
Files\Zend\ZendServer\share\ZendFramework`` sur Windows. L'``include_path`` aura déja été configuré pour
inclure Zend Framework.

Il reste bien sûr possible `de télécharger la dernière version de Zend Framework`_ et l'extraire; notez
simplement où vous choisissez de l'extraire.

Optionellement, vous pouvez ajouter le chemin vers le sous-dossier ``library/`` de l'archive à l'``include_path``
de votre ``php.ini``.

Ca y est! Zend Framework est maintenant installé et prêt à l'emploi.

.. _learning.quickstart.create-project.create-project:

Créer votre projet
------------------

.. note::

   **Outil en ligne de commandes zf**

   Dans la dossier ``bin/`` de votre installation de Zend Framework se trouvent les scripts ``zf.sh`` et ``zf.bat``
   pour Unix et Windows respectivement. Notez le chemin absolu vers ces fichiers.

   Partout ou vous voyez une référence à la commande ``zf``, utilisez le chemin absolu du script. Sur les
   système Unix, vous pouvez utiliser la fonctionnalité d'alias dans le shell: ``alias
   zf.sh=path/to/ZendFramework/bin/zf.sh``.

   Si vous avez des problèmes pour configurer la commande ``zf``, veuillez vous référer :ref:`au manuel
   <zend.tool.framework.clitool>`.

Ouvrez un terminal (sous Windows, ``Démarrer -> Exécuter``, puis ``cmd``). Naviguez vers un dossier dans lequel
vous souhaitez démarrer un projet. Puis, utilisez le chemin vers le script approprié et lancez:

.. code-block:: console
   :linenos:

   % zf create project quickstart

Cette commande crée un projet avec une structure basique incluant des contrôleurs et vues. L'arbre va ressembler
à ceci:

.. code-block:: text
   :linenos:

   quickstart
   |-- application
   |   |-- Bootstrap.php
   |   |-- configs
   |   |   `-- application.ini
   |   |-- controllers
   |   |   |-- ErrorController.php
   |   |   `-- IndexController.php
   |   |-- models
   |   `-- views
   |       |-- helpers
   |       `-- scripts
   |           |-- error
   |           |   `-- error.phtml
   |           `-- index
   |               `-- index.phtml
   |-- library
   |-- public
   |   |-- .htaccess
   |   `-- index.php
   `-- tests
       |-- application
       |   `-- bootstrap.php
       |-- library
       |   `-- bootstrap.php
       `-- phpunit.xml

Dès lors si vous n'avez pas ajouté Zend Framework à votre ``include_path``, nous vous recommandons de copier ou
lier celui-ci dans le dossier ``library/`` de votre projet. Dans ce cas vous devriez copier récursivement (ou
lier) ``library/Zend/`` de l'installation de Zend Framework vers le dossier ``library/`` de votre projet. Sur les
systèmes Unix cela peut être effectué de la manière suivante:

.. code-block:: console
   :linenos:

   # Symlink:
   % cd library; ln -s path/to/ZendFramework/library/Zend .

   # Copy:
   % cd library; cp -r path/to/ZendFramework/library/Zend .

Sur Windows le plus simple sera d'utiliser l'explorateur.

Maintenant que le projet est crée, les principaux points à comprendre sont le bootstrap, la configuration, les
contrôleurs d'action et les vues.

.. _learning.quickstart.create-project.bootstrap:

Le Bootstrap
------------

Votre classe ``Bootstrap`` définit les ressources (composants) à initialiser. Par défaut, le :ref:`contrôleur
frontal <zend.controller.front>` est initialisé et il utilise ``application/controllers/`` comme dossier de
contrôleurs par défaut (nous reverrons cela). La classe ressemble à:

.. code-block:: php
   :linenos:

   // application/Bootstrap.php

   class Bootstrap extends Zend\Application\Bootstrap\Bootstrap
   {
   }

Comme vous le voyez, rien de plus n'est nécessaire pour commencer.

.. _learning.quickstart.create-project.configuration:

Configuration
-------------

Le Zend Framework lui-même n'a pas besoin de configuration, mais l'application oui. La configuration par défaut
est placée sous ``application/configs/application.ini`` et contient des directives de base pour régler
l'environnement *PHP* (par exemple, activer ou désactiver le rapport d'erreurs), indiquer le chemin vers votre
classe de bootstrap (ainsi que son nom) , et le chemin vers les contrôleurs d'action. Cela ressemble à:

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   [production]
   phpSettings.display_startup_errors = 0
   phpSettings.display_errors = 0
   includePaths.library = APPLICATION_PATH "/../library"
   bootstrap.path = APPLICATION_PATH "/Bootstrap.php"
   bootstrap.class = "Bootstrap"
   appnamespace = "Application"
   resources.frontController.controllerDirectory = APPLICATION_PATH "/controllers"
   resources.frontController.params.displayExceptions = 0

   [staging : production]

   [testing : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

   [development : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

Plusieurs choses sont à connaitre concernant ce fichier. D'abord, si vous utilisez une configuration basée sur
des fichiers *INI*, vous pouvez faire usage des constantes directement; ``APPLICATION_PATH`` est ici une constante.
Aussi, notez que plusieurs sections ont été définies: production, staging, testing, et development. Les trois
dernières héritent de la section "production". C'est une manière utile d'organiser sa configuration et de
s'assurer que les paramètres appropriés sont utilisés pour chaque étape du développement de l'application.

.. _learning.quickstart.create-project.action-controllers:

Contrôleurs d'action
--------------------

Les **contrôleurs d'action** de votre application contiennent la logique 'utile' de celle-ci et font correspondre
les requêtes aux bons modèles et aux bonnes vues.

Un contrôleur d'action devrait posséder une ou plusieurs méthodes se terminant par "Action"; ces méthodes sont
interrogées via le web. Par défaut, les URLs de Zend Framework suivent le schéma ``/controller/action``, où
"controller" correspond à la classe de contrôleur (sans le suffixe "Controller") et "action" correspond à la
méthode d'action (sans le suffixe "Action").

Typiquement, vous aurez toujours besoin d'un ``IndexController``, qui est utilisé par défaut et servira aussi la
page d'accueil, et un ``ErrorController``, utilisé pour indiquer les erreurs *HTTP* 404 (contrôleur ou action
introuvable) et les erreurs *HTTP* 500 (erreurs de l'application).

``IndexController`` par défaut est défini comme suit:

.. code-block:: php
   :linenos:

   // application/controllers/IndexController.php

   class IndexController extends Zend\Controller\Action
   {

       public function init()
       {
           /* Initialisez le contrôleur et l'action ici */
       }

       public function indexAction()
       {
           // corps de l'action
       }
   }

``ErrorController`` par défaut est défini comme suit:

.. code-block:: php
   :linenos:

   // application/controllers/ErrorController.php

   class ErrorController extends Zend\Controller\Action
   {

       public function errorAction()
       {
           $errors = $this->_getParam('error_handler');

           switch ($errors->type) {
               case Zend\Controller\Plugin\ErrorHandler::EXCEPTION_NO_ROUTE:
               case Zend\Controller\Plugin\ErrorHandler::EXCEPTION_NO_CONTROLLER:
               case Zend\Controller\Plugin\ErrorHandler::EXCEPTION_NO_ACTION:

                   // 404 error -- controller or action not found
                   $this->getResponse()->setHttpResponseCode(404);
                   $this->view->message = 'Page not found';
                   break;
               default:
                   // application error
                   $this->getResponse()->setHttpResponseCode(500);
                   $this->view->message = 'Application error';
                   break;
           }

           $this->view->exception = $errors->exception;
           $this->view->request   = $errors->request;
       }
   }

Notez que (1) ``IndexController`` ne contient pas de code réel, et (2) ``ErrorController`` référence un attribut
"view". Ceci nous mène vers la section suivante.

.. _learning.quickstart.create-project.views:

Vues
----

Les vues dans Zend Framework sont écrites en *PHP* classique. Les scripts de vues sont placés sous
``application/views/scripts/``, ils sont référencés plus tard dans les contrôleurs. Dans notre cas, nous avons
un ``IndexController`` et un ``ErrorController``, et nous avons ainsi des dossiers ``index/`` et ``error/``
correspondants dans le dossier scripts des vues. Dans ces dossiers, vous trouverez ou créerez des scripts de vue
correspondants aux actions exposées par les contrôleurs; dans le cas par défaut nous avons ainsi des scripts de
vue ``index/index.phtml`` et ``error/error.phtml``.

Les scripts de vue peuvent contenir le code de présentation que vous voulez et utiliser les tags **<?php** ou
**?>** pour insérer du *PHP*.

Ce qui suit présente le code par défaut de ``index/index.phtml``:

.. code-block:: php
   :linenos:

   <!-- application/views/scripts/index/index.phtml -->
   <style>

       a:link,
       a:visited
       {
           color: #0398CA;
       }

       span#zf-name
       {
           color: #91BE3F;
       }

       div#welcome
       {
           color: #FFFFFF;
           background-image: url(http://framework.zend.com/images/bkg_header.jpg);
           width:  600px;
           height: 400px;
           border: 2px solid #444444;
           overflow: hidden;
           text-align: center;
       }

       div#more-information
       {
           background-image: url(http://framework.zend.com/images/bkg_body-bottom.gif);
           height: 100%;
       }

   </style>
   <div id="welcome">
       <h1>Welcome to the <span id="zf-name">Zend Framework!</span><h1 />
       <h3>This is your project's main page<h3 />
       <div id="more-information">
           <p>
               <img src="http://framework.zend.com/images/PoweredBy_ZF_4LightBG.png" />
           </p>

           <p>
               Helpful Links: <br />
               <a href="http://framework.zend.com/">Zend Framework Website</a> |
               <a href="http://framework.zend.com/manual/en/">Zend Framework
                   Manual</a>
           </p>
       </div>
   </div>

Le script de vue ``error/error.phtml`` est plus intéréssant car il inclut des conditions écrites en *PHP*:

.. code-block:: php
   :linenos:

   <!-- application/views/scripts/error/error.phtml -->
   <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN";
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd>
   <html xmlns="http://www.w3.org/1999/xhtml">
   <head>
     <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
     <title>Zend Framework Default Application</title>
   </head>
   <body>
     <h1>An error occurred</h1>
     <h2><?php echo $this->message ?></h2>

     <?php if ('development' == $this->env): ?>

     <h3>Exception information:</h3>
     <p>
         <b>Message:</b> <?php echo $this->exception->getMessage() ?>
     </p>

     <h3>Stack trace:</h3>
     <pre><?php echo $this->exception->getTraceAsString() ?>
     </pre>

     <h3>Request Parameters:</h3>
     <pre><?php echo var_export($this->request->getParams(), 1) ?>
     </pre>
     <?php endif ?>

   </body>
   </html>

.. _learning.quickstart.create-project.vhost:

Creation d'un hôte virtuel
--------------------------

Pour le quickstart nous supposerons que vous utilisez le `serveur web Apacher`_. Zend Framework fonctionne très
bien avec d'autres serveurs -- y compris Microsoft Internet Information Server, lighttpd, nginx, et plus -- mais la
plupart des développeurs devraient être familiers à Apache, et cela permet d'introduire la structure de dossiers
de Zend Framework et les capacités de réécriture.

Pour créer un vhost, vous devez connaitre l'emplacement du fichier ``httpd.conf``, et les emplacements des autres
fichiers de configuration protenciels. Voici quelques emplacements classiques:

- ``/etc/httpd/httpd.conf`` (Fedora, RHEL, et autres)

- ``/etc/apache2/httpd.conf`` (Debian, Ubuntu, et autres)

- ``/usr/local/zend/etc/httpd.conf`` (Zend Server sur \*nix)

- ``C:\Program Files\Zend\Apache2\conf`` (Zend Server sur Windows)

Au sein de ``httpd.conf`` (ou ``httpd-vhosts.conf`` sur certains systèmes), vous aurez besoin de deux choses.
D'abord s'assurer que ``NameVirtualHost`` est défini; typiquement à une valeur de "\*:80". Ensuite, définir les
hôtes virtuels:

.. code-block:: apache
   :linenos:

   <VirtualHost *:80>
       ServerName quickstart.local
       DocumentRoot /path/to/quickstart/public

       SetEnv APPLICATION_ENV "development"

       <Directory /path/to/quickstart/public>
           DirectoryIndex index.php
           AllowOverride All
           Order allow,deny
           Allow from all
       </Directory>
   </VirtualHost>

Notons plusieurs points. D'abord le ``DocumentRoot`` pointe vers le dossier ``public`` du projet; ceci signifie que
seuls les fichiers sous cette arborescence peuvent être servis directement par le serveur. Ensuite,
``AllowOverride``, ``Order``, et ``Allow``; ces directives servent à autoriser l'utilisation de fichiers
``htaccess`` dans le projet. Pendant le développement, c'est une bonne pratique car ça évite de redémarrer sans
arrêt le serveur dès qu'un changement y est opéré; cependant en production le contenu de ``htaccess`` devrait
être reproduit dans la configuration puis désactivé. Enfin notez ``SetEnv``. Ici nous renseignons une variable
d'environnement pour l'hôte virtuel, celle-ci sera récupérée dans ``index.php`` et utilisée pour affecter la
constante ``APPLICATION_ENV`` de l'application Zend Framework. En production, vous pouvez oublier cette directive
(dans un tel cas la valeur par défaut sera "production") ou la préciser explicitement à la valeur "production".

Finalement, vous devrez ajouter une entrée au DNS ou au fichier d'hôtes (``hosts``) pour la valeur de
``ServerName``. Sur les systèmes \*nix, il s'agit de ``/etc/hosts``; sur Windows, vous trouverez normalement ce
fichier sous ``C:\WINDOWS\system32\drivers\etc``. Quel que soit le système, l'entrée sera de la forme:

.. code-block:: text
   :linenos:

   127.0.0.1 quickstart.local

Démarrez votre serveur web (ou redémarrez le), et tout devrait être prêt.

.. _learning.quickstart.create-project.checkpoint:

Checkpoint
----------

Dès lors, vous devriez pouvoir démarrer votre application Zend Framework. Faites pointer votre navigateur vers
l'hôte configuré dans la section précédente et une page d'accueil devrait s'afficher.



.. _`Zend Server`: http://www.zend.com/en/products/server-ce/downloads
.. _`de télécharger la dernière version de Zend Framework`: http://framework.zend.com/download/latest
.. _`serveur web Apacher`: http://httpd.apache.org/
