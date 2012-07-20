.. _zend.loader.autoloader-resource:

Autoloaders de ressources
=========================

Les autoloaders de ressources servent à manipuler du code de librairies dans des espaces de noms, respectant les
conventions de codage du Zend Framework, mais n'ayant pas une correspondance 1:1 entre le nom de la classe et la
structure du dossier. Leur but est de faciliter le chargement du code des ressources de l'application, comme les
modèles, les *ACL*\ s, les formulaires...

Les autoloaders de ressources s'enregistrent dans l':ref:`autoloader <zend.loader.autoloader>` à leur
instanciation, avec l'espace de noms auxquels ils sont rattachés. Ceci permet de facilement isoler du code dans
des dossiers, sous l'espace de noms, tout en gardant les bénéfices de l'autoload.

.. _zend.loader.autoloader-resource.usage:

Utilisation de l'autoloader de ressources
-----------------------------------------

Soit la structure de répertoires suivante :

.. code-block:: text
   :linenos:

   path/to/some/directory/
       acls/
           Site.php
       forms/
           Login.php
       models/
           User.php

Au sein de ce répertoire, toutes les classes sont préfixées par l'espace de noms "My\_". Dans le dossier "acls",
le préfixe de composant "Acl\_" est ajouté, ce qui donne un nom de classe final "My_Acl_Site". Aussi, le dossier
"forms" correspond à "Form\_", ce qui donne "My_Form_Login". Le dossier "models" n'a pas d'espace de noms
particulier, donnant donc "My_User".

Pour instancier un autoloader de ressoucres, il faut au minimum lui passer son dossier de travail (base path), et
le nom de l'espace de noms correspondant :

.. code-block:: php
   :linenos:

   $resourceLoader = new Zend_Loader_Autoloader_Resource(array(
       'basePath'  => 'path/to/some/directory',
       'namespace' => 'My',
   ));

.. note::

   **Espace de noms de base**

   Dans ``Zend_Loader_Autoloader``, vous devez spécifier le underscore final ("\_") dans votre espace de noms.
   ``Zend_Loader_Autoloader_Resource`` suppose par contre que tout le code à auto-charger utilisera le séparateur
   d'espaces de noms underscore. Ainsi, vous n'avez pas besoin de le préciser avec l'autoloader de ressources.

Maintenant que notre autoloader est configuré, nous pouvons ajouter des composants à auto-charger. Ceci se fait
via la méthode ``addResourceType()``, qui accepte 3 arguments : un "type" de ressource, utiliser en interne comme
nom de référence ; le sous dossier dans lequel la ressource en question est logé, et l'espace de noms du
composant à rajouter à l'espace de noms général. Voici un exemple :

.. code-block:: php
   :linenos:

   $resourceLoader->addResourceType('acl', 'acls/', 'Acl')
                  ->addResourceType('form', 'forms/', 'Form')
                  ->addResourceType('model', 'models/');

Aussi, vous auriez pu effectuer la même action avec un tableau *PHP*. ``addResourceTypes()`` est alors
appropriée :

.. code-block:: php
   :linenos:

   $resourceLoader->addResourceTypes(array(
       'acl' => array(
           'path'      => 'acls/',
           'namespace' => 'Acl',
       ),
       'form' => array(
           'path'      => 'forms/',
           'namespace' => 'Form',
       ),
       'model' => array(
           'path'      => 'models/',
       ),
   ));

Enfin, vous pouvez spécifier tout cela d'un seul coup avec des tableaux nichés. La clé doit alors être
"resourceTypes" :

.. code-block:: php
   :linenos:

   $resourceLoader = new Zend_Loader_Autoloader_Resource(array(
       'basePath'      => 'path/to/some/directory',
       'namespace'     => 'My',
       'resourceTypes' => array(
           'acl' => array(
               'path'      => 'acls/',
               'namespace' => 'Acl',
           ),
           'form' => array(
               'path'      => 'forms/',
               'namespace' => 'Form',
           ),
           'model' => array(
               'path'      => 'models/',
           ),
       ),
   ));

.. _zend.loader.autoloader-resource.module:

L'autoloader de ressource Module
--------------------------------

Zend Framework fournit une implémentation concrète de ``Zend_Loader_Autoloader_Resource`` qui contient des
correspondances de ressources pour mettre en avant la structure modulaire par défaut que propose le Zend Framework
dans ses applications *MVC*. Ce chargeur, ``Zend_Application_Module_Autoloader``, propose le mapping suivant :

.. code-block:: text
   :linenos:

   forms/       => Form
   models/      => Model
       DbTable/ => Model_DbTable
       mappers/ => Model_Mapper
   plugins/     => Plugin
   services/    => Service
   views/
       helpers  => View_Helper
       filters  => View_Filter

Par exemple, avec un module dont le préfixe est "Blog\_", le chargement de la classe "Blog_Form_Entry" mènerait
au chargement du fichier "forms/Entry.php".

En utilisant les bootstraps de modules avec ``Zend_Application``, une instance de
``Zend_Application_Module_Autoloader`` sera crée pour chaque module utilisé.

.. _zend.loader.autoloader-resource.factory:

Utiliser les autoloaders de ressources comme fabriques d'objets
---------------------------------------------------------------



.. _zend.loader.autoloader-resource.reference:

Référence de l'autoloader de ressources
---------------------------------------




