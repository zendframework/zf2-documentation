.. EN-Revision: none
.. _learning.autoloading.resources:

Auto-chargement de resources
============================

En développant des applications, il est souvent difficile de regrouper certaines classes dans une relation 1:1
avec le système de fichiers que recommande le Zend framework, ou alors ça ne semble pas intuitif de le faire.
Cela signifie que les classes ne seront pas trouvées par l'autoloader.

Si vous lisez :ref:`les caractéristiques de l'architecture <learning.autoloading.design>` de l'autoloader, le
dernier point de cette section indique qu'une solution existe pour un tel problème. Zend Framework utilise alors
``Zend_Loader_Autoloader_Resource``.

Une ressource est juste un nom qui correspond à un espace de noms pour un composant (qui est ajouté à l'espace
de noms de l'autoloader) et un chemin (qui est relatif au chemin de base de l'autoloader). Sous forme de code, vous
feriez quelque chose comme:

.. code-block:: php
   :linenos:

   $loader = new Zend_Application_Module_Autoloader(array(
       'namespace' => 'Blog',
       'basePath'  => APPLICATION_PATH . '/modules/blog',
   ));

Une fois le chargeur en place, il faut l'informer des différents types de ressources qu'il va avoir à gérer. Ces
types sont simplement des paires d'arbres et de préfixes.

Considérons ce qui suit comme exemple:

.. code-block:: text
   :linenos:

   path/to/some/resources/
   |-- forms/
   |   `-- Guestbook.php        // Foo_Form_Guestbook
   |-- models/
   |   |-- DbTable/
   |   |   `-- Guestbook.php    // Foo_Model_DbTable_Guestbook
   |   |-- Guestbook.php        // Foo_Model_Guestbook
   |   `-- GuestbookMapper.php  // Foo_Model_GuestbookMapper

Le premier reflexe est de créer un chargeur de ressources:

.. code-block:: php
   :linenos:

   $loader = new Zend_Loader_Autoloader_Resource(array(
       'basePath'  => 'path/to/some/resources/',
       'namespace' => 'Foo',
   ));

Puis, nous définissons des types de ressources. ``Zend_Loader_Autoloader_Resourse::addResourceType()`` prend trois
arguments: le "type" de resource (une chaine arbitraire), le chemin sous le chemin de base dans lequel le type de
ressource doit se trouver, et le préfixe particulier à utiliser pour ce type de ressource. Dans l'arbre
représenté ci-dessus, il y a trois types : form (dans le sous-dossier "forms", avec un préfixe "Form"), model
(dans le sous-dossier "models", avec un préfixe "Model"), et dbtable (dans le sous-dossier "``models/DbTable``",
avec un préfixe "``Model_DbTable``"). Nous les définirons comme ceci:

.. code-block:: php
   :linenos:

   $loader->addResourceType('form', 'forms', 'Form')
          ->addResourceType('model', 'models', 'Model')
          ->addResourceType('dbtable', 'models/DbTable', 'Model_DbTable');

Il ne reste plus qu'à utiliser les classes:

.. code-block:: php
   :linenos:

   $form      = new Foo_Form_Guestbook();
   $guestbook = new Foo_Model_Guestbook();

.. note::

   **Autoload de ressource Module**

   La couche *MVC* de Zend Framework encourage l'utilisation de "modules", qui sont des mini-applications de votre
   site. Les modules possèdent typiquement des types de ressource par défaut, et Zend Framework :ref:`recommande
   une hiérarchie de répertoires standard pour les modules <project-structure.filesystem>`.Les autoloaders de
   ressources sont particulièrement adaptés à cette situation -- tellement qu'ils sont activés par défaut
   lorsque vous créez des classes de bootstrap qui étendent ``Zend_Application_Module_Bootstrap``. Pour plus
   d'informations, lisez la :ref:`documentation de Zend_Loader_Autoloader_Module
   <zend.loader.autoloader-resource.module>`.


