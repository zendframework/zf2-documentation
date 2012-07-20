.. _zend.loader.pluginloader:

Chargeur de Plugins
===================

Zend Framework vous propose l'utilisation de composants "pluggables", que vous créez vous même. Ceux-ci ne sont
pas forcément dans l'include_path. De même, ils ne suivent pas forcément les mêmes règles de nommage que les
composants de Zend Framework. ``Zend_Loader_PluginLoader`` propose une solution à ce problème.

*PluginLoader* suit la convention "une classe par fichier" et les tirets bas sont utilisés comme séparateurs de
dossiers. Il accepte aussi qu'un préfixe optionnel lui soit passé, afin de charger une classe. Tous les chemins
sont analysés en ordre LIFO. Grâce à ces deux spécificités, vous pouvez "namespacer" vos plugins, et écraser
les plugins enregistrés plus tôt.

.. _zend.loader.pluginloader.usage:

Utilisation basique
-------------------

Même si nous parlons de "plugins", ce n'est pas réservé aux plugins de contrôleur frontal, mais bien à toute
classe étant utilisée avec Zend Framework. Imaginons une structure de répertoires comme suit, dans laquelle les
dossiers "application" et "library" sont dans l'include_path :

.. code-block:: text
   :linenos:

   application/
       modules/
           foo/
               views/
                   helpers/
                       FormLabel.php
                       FormSubmit.php
           bar/
               views/
                   helpers/
                       FormSubmit.php
   library/
       Zend/
           View/
               Helper/
                   FormLabel.php
                   FormSubmit.php
                   FormText.php

Maintenant créons un chargeur de plugins pour utiliser les différentes classes d'aides de vue :

.. code-block:: php
   :linenos:

   $loader = new Zend_Loader_PluginLoader();
   $loader->addPrefixPath('Zend_View_Helper',
                          'Zend/View/Helper/')
          ->addPrefixPath('Foo_View_Helper',
                          'application/modules/foo/views/helpers')
          ->addPrefixPath('Bar_View_Helper',
                          'application/modules/bar/views/helpers');

Il devient alors possible de charger une aide de vue en spécifiant juste le nom de sa classe :

.. code-block:: php
   :linenos:

   // charge l'aide 'FormText' :
   $formTextClass = $loader->load('FormText');
   // 'Zend_View_Helper_FormText'

   // charge l'aide 'FormLabel' :
   $formLabelClass = $loader->load('FormLabel');
   // 'Foo_View_Helper_FormLabel'

   // charge l'aide 'FormSubmit' :
   $formSubmitClass = $loader->load('FormSubmit');
   // 'Bar_View_Helper_FormSubmit'

Une fois chargée, la classe devient instanciable.

.. note::

   **Plusieurs dossiers peuvent être assignés à un même préfixe**

   Vous pouvez "namespacer" vos composants en enregistrant plusieurs chemins pour un même préfixe.
   ``Zend_Loader_PluginLoader`` cherchera alors en ordre LIFO (dernier arrivé, premier sorti). Ceci est pratique
   pour court-circuiter ses composants et utiliser ceux en incubateur, par exemple.

.. note::

   **Paramétrage des chemins dans le constructeur**

   En constructeur, passez un tableau de paires prefix / path ou prefix / paths -- plusieurs dossiers par préfixe
   :

   .. code-block:: php
      :linenos:

      $loader = new Zend_Loader_PluginLoader(array(
          'Zend_View_Helper' => 'Zend/View/Helper/',
          'Foo_View_Helper'  => 'application/modules/foo/views/helpers',
          'Bar_View_Helper'  => 'application/modules/bar/views/helpers'
      ));

``Zend_Loader_PluginLoader`` peut aussi permettre de partager des plugins grâce au registre. Indiquez le nom du
registre de cette manière :

.. code-block:: php
   :linenos:

   // Stocke les plugins dans le registre à l'index 'foobar':
   $loader = new Zend_Loader_PluginLoader(array(), 'foobar');

Si un autre composant instancie le *PluginLoader* en utilisant le même nom de registre, alors tous les chemins et
plugins déjà chargés seront disponibles.

.. _zend.loader.pluginloader.paths:

Manipulation des chemins des Plugins
------------------------------------

Pour afficher ou supprimer des chemins déjà enregistrés, utilisez l'une des méthodes suivantes :

- ``getPaths($prefix = null)`` retourne les chemin sous la forme prefix / path si ``$prefix`` n'est pas renseigné.
  Sinon, ce sont les chemins enregistrés pour le préfixe en question qui sont renvoyés.

- ``clearPaths($prefix = null)`` va effacer tous les chemins. Si ``$prefix`` est passé, ce sont les chemins
  correspondants à ce préfixe qui seront supprimés.

- ``removePrefixPath($prefix, $path = null)`` permet de supprimer un chemin précis, d'un préfixe spécifié. Si
  ``$path`` n'est pas renseigné, tous les chemins du préfixe seront effacés.

.. _zend.loader.pluginloader.checks:

Test des Plugins et récupération des noms de classe
---------------------------------------------------

Lorsque vous voulez savoir si une classe de plugin a été chargée, ``isLoaded()`` prend en paramètre le nom du
plugin, et retourne sont statut.

Une autre utilisation de *PluginLoader* peut être de récupérer le nom des classes des plugins chargés.
``getClassName()`` vous le permet. Utilisée en conjonction avec ``isLoaded()``, vous pouvez écrire par exemple
ceci :

.. code-block:: php
   :linenos:

   if ($loader->isLoaded('Adapter')) {
       $class   = $loader->getClassName('Adapter');
       $adapter = call_user_func(array($class, 'getInstance'));
   }

.. _zend.loader.pluginloader.performance:

Obtenir de meilleures performances avec les Plugins
---------------------------------------------------

Le chargement des plugins peut être une opération consommatrice en ressources. En interne, il doit parcourir
chaque préfixe, ainsi que chaque chemin dans ce préfixe jusqu'à ce qu'il trouve un fichier qui correspond - et
qui définit de plus la classe voulue. Dans le cas où le fichier existe mais ne défini pas la classe, une erreur
sera ajouté à la pile d'erreur *PHP*, opération qui est elle aussi consommatrice. La question qui vient à
l'esprit est : comment maintenir la flexibilité des plugins et la performance ?

``Zend_Loader_PluginLoader`` offre une fonctionnalité intégrée pour ce cas, un fichier de cache des inclusions
de classe. Quand il est activé, ceci crée un fichier qui contient toutes les inclusions qui ont fonctionnées et
qui peuvent donc être appelées dans votre fichier d'initialisation. En utilisant ceci, vous pouvez
considérablement accroître les performances de vos serveurs de production.

.. _zend.loader.pluginloader.performance.example:

.. rubric:: Utilisation du fichier de cache des inclusions de classe de PluginLoader

Pour utiliser le fichier de cache des inclusions de classe, collez simplement le code suivant dans votre fichier
d'initialisation :

.. code-block:: php
   :linenos:

   $classFileIncCache = APPLICATION_PATH .  '/../data/pluginLoaderCache.php';
   if (file_exists($classFileIncCache)) {
       include_once $classFileIncCache;
   }
   Zend_Loader_PluginLoader::setIncludeFileCache($classFileIncCache);

Évidemment, le chemin et le fichier varieront en fonction de vos besoins. Ce code doit intervenir aussi vite que
possible, pour s'assurer que tous les composants à base de plugins pourront l'utiliser.

En cours du développement, vous pouvez souhaiter désactiver le cache. Une méthode permettant ceci est d'utiliser
une clé de configuration pour déterminer ou non si le chargeur de plugins doit mettre les informations en cache.

.. code-block:: php
   :linenos:

   $classFileIncCache = APPLICATION_PATH .  '/../data/pluginLoaderCache.php';
   if (file_exists($classFileIncCache)) {
       include_once $classFileIncCache;
   }
   if ($config->enablePluginLoaderCache) {
       Zend_Loader_PluginLoader::setIncludeFileCache($classFileIncCache);
   }

Cette technique vous permet de restreindre les modifications au seul fichier de configuration plutôt que dans
votre code.


