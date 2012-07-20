.. _zend.tool.project.create-a-project:

Créer un projet
===============

.. note::

   Les exemples suivants considéreront que l'inferface en ligne de commande de ``Zend_Tool_Framework`` est
   disponible.

.. note::

   Pour exécuter l'une des commandes de ``Zend_Tool_Project`` en mode *CLI*, vous devez être dans le répertoire
   dans lequel le projet a été initialement créé.

Pour démarrer avec ``Zend_Tool_Project``, vous devez simplement créer un projet. La création d'un projet est
simple : allez où vous le souhaitez dans votre système de fichiers, créez un dossier, allez dans le dossier
créé, ensuite exécutez les commandes suivantes :

``/tmp/project$ zf create project``

Optionnellement, vous pouvez créer un projet n'importe où en exéxcutant :

``$ zf create project /chemin/vers/dossier-non-existant``

La table suivante décrit les fonctionnalités des fournisseurs qui sont disponibles. Comme vous pouvez le voir, il
existe un fournisseur "Project". Le fournisseur "Project" possède deux actions, et avec ces actions un certain
nombre d'options qui peuvent modifier le comportement de l'action et du fournisseur.

.. _zend.tool.project.project-provider-table:

.. table:: Project Provider Options

   +------------------+-------------------+---------------------------------------+---------------------------+
   |Nom du fournisseur|Actions disponibles|Paramètres                             |Utilisation en CLI         |
   +==================+===================+=======================================+===========================+
   |Project           |Create / Show      |create = [path=null, profile='default']|zf create project some/path|
   +------------------+-------------------+---------------------------------------+---------------------------+


