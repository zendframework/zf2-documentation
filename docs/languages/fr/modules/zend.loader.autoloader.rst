.. _zend.loader.autoloader:

L'autoloader
============

``Zend_Loader_Autoloader`` propose une solution intelligente et souple d'auto-chargement (autoload) pour Zend
Framework. Il a été conçu pour remplir plusieurs objectifs :

- Proposer un autoloader à base d'espaces de noms (auparavant, les espaces de noms étaient interceptés).

- Proposer d'enregistrer des autoloads personnalisés, et les gérer comme une pile. (A l'heure actuelle, ceci
  permet de s'affranchir de certaines contraintes avec *spl_autoload*, qui ne permet pas le ré-enregistrement
  d'une fonction à  base d'objet).

- Proposer un autoload optimisé pour les espaces de noms, qui permet une meilleure résolution des noms de
  classes.

``Zend_Loader_Autoloader`` est un singleton, il est donc universellement accessible. Ceci permet d'enregistrer des
autoload depuis n'importe où dans votre code.

.. _zend.loader.autoloader.usage:

Utiliser le chargeur automatique (autoloader)
---------------------------------------------

La première fois qu'une instance de l'autoloader est créée, il s'enregistre lui-même sur la fonction
*spl_autoload*. Vous récupérez son instance via la méthode ``getInstance()``\  :

.. code-block:: php
   :linenos:

   $autoloader = Zend_Loader_Autoloader::getInstance();

Par défaut, l'autoloader est configuré pour capturer les espaces de noms "Zend\_" et "ZendX\_". Si votre propre
librairie de code utilise un espace de noms différent, vous devez alors enregistrer celui-ci avec la méthode
``registerNamespace()``. Par exemple, si votre librairie possède l'espace de noms "My\_", vous devriez agir comme
cela :

.. code-block:: php
   :linenos:

   $autoloader->registerNamespace('My_');

.. note::

   **Préfixes des espaces de noms**

   Notez que l'exemple précédent enregistre "My\_" et non "My". Ceci car ``Zend_Loader_Autoloader`` est un
   autoloader global, et n'a aucune idée qu'un préfixe de classe possède un underscore. Si c'est **votre** cas,
   alors faites le apparaître lors de son enregistrement dans l'autoloader.

Il est aussi possible que vous enregistriez vos propres fonctions d'autoload, optionnellement avec un espace de
noms spécifique, ``Zend_Loader_Autoloader`` va alors tenter de l'utiliser lorsque nécessaire (lors de
l'auto-chargement).

Par exemple, vous pourriez avoir besoin d'un ou plusieurs composants eZcomponents avec votre application Zend
Framework. Pour utiliser ses capacités d'autoload, ajoutez son autoloader à votre pile grâce à 
``pushAutoloader()``\  :

.. code-block:: php
   :linenos:

   $autoloader->pushAutoloader(array('ezcBase', 'autoload'), 'ezc');

Ceci indique que les classes dont le nom commence par "ezc" devra utiliser cette fonction d'autoload.

``unshiftAutoloader()``, elle, rajoute la méthode d'autoload au début de la pile.

Par défaut, ``Zend_Loader_Autoloader`` ne supprime aucune erreur lorsqu'il utilise son autoloader interne,
s'appuyant sur ``Zend_Loader::loadClass()``. La plupart du temps, c'est le comportement recherché. Cependant, si
vous voulez faire apparaître les éventuelles erreurs de chargement, appelez alors ``suppressNotFoundWarnings()``\
 :

.. code-block:: php
   :linenos:

   $autoloader->suppressNotFoundWarnings(true);

Enfin, il se peut que vous vouliez que l'autoloader par défaut charge toutes les classes de tous les espaces de
noms. Par exemple, les librairies PEAR ne partagent pas un espace de noms commun, ce qui rend la tâche difficile
si on veut associer chacun des espaces de noms internes. Utilisez alors ``setFallbackAutoloader()`` pour rendre
l'autoloader "global" et charger tous les espaces de noms :

.. code-block:: php
   :linenos:

   $autoloader->setFallbackAutoloader(true);

.. note::

   **Loading Classes from PHP Namespaces**

   Starting in version 1.10.0, Zend Framework now allows loading classes from PHP namespaces. This support follows
   the same guidelines and implementation as that found in the `PHP Framework Interop Group PSR-0`_ reference
   implementation.

   Under this guideline, the following rules apply:

   - Each namespace separator is converted to a ``DIRECTORY_SEPARATOR`` when loading from the file system.

   - Each "\_" character in the **CLASS NAME** is converted to a ``DIRECTORY_SEPARATOR``. The "\_" character has no
     special meaning in the namespace.

   - The fully-qualified namespace and class is suffixed with ".php" when loading from the file system.

   As examples:

   - ``\Doctrine\Common\IsolatedClassLoader`` =>
     ``/path/to/project/lib/vendor/Doctrine/Common/IsolatedClassLoader.php``

   - ``\namespace\package\Class_Name`` => ``/path/to/project/lib/vendor/namespace/package/Class/Name.php``

   - ``\namespace\package_name\Class_Name`` =>
     ``/path/to/project/lib/vendor/namespace/package_name/Class/Name.php``

.. _zend.loader.autoloader.zf-version:

Selecting a Zend Framework version
----------------------------------

Typically, you will use the version of Zend Framework that the autoloader you instantiate came with. However, when
developing a project, it's often useful to track specific versions, major or minor branches, or just the latest
version. ``Zend_Loader_Autoloader``, as of version 1.10, offers some features to help manage this task.

Imagine the following scenario:

- During **development**, you want to track the latest version of Zend Framework you have installed, so that you
  can ensure the application works when you upgrade between versions.

  When pushing to **Quality Assurance**, however, you need to have slightly more stability, so you want to use the
  latest installed revision of a specific minor version.

  Finally, when you push to **production**, you want to pin to a specific installed version, to ensure no breakage
  occurs if or when you add new versions of Zend Framework to you server.

The autoloader allows you to do this with the method ``setZfPath()``. This method takes two arguments, a **path**
to a set of Zend Framework installations, and a **version** to use. Once invoked, it prepends a path to the
``include_path`` pointing to the appropriate Zend Framework installation library.

The directory you specify as your **path** should have a tree such as the following:

.. code-block:: text
   :linenos:

   ZendFramework/
   |-- 1.9.2/
   |   |-- library/
   |-- ZendFramework-1.9.1-minimal/
   |   |-- library/
   |-- 1.8.4PL1/
   |   |-- library/
   |-- 1.8.4/
   |   |-- library/
   |-- ZendFramework-1.8.3/
   |   |-- library/
   |-- 1.7.8/
   |   |-- library/
   |-- 1.7.7/
   |   |-- library/
   |-- 1.7.6/
   |   |-- library/

(where **path** points to the directory "ZendFramework" in the above example)

Note that each subdirectory should contain the directory ``library``, which contains the actual Zend Framework
library code. The individual subdirectory names may be version numbers, or simply be the untarred contents of a
standard Zend Framework distribution tarball/zipfile.

Now, let's address the use cases. In the first use case, in **development**, we want to track the latest source
install. We can do that by passing "latest" as the version:

.. code-block:: php
   :linenos:

   $autoloader->setZfPath($path, 'latest');

In the example from above, this will map to the directory ``ZendFramework/1.9.2/library/``; you can verify this by
checking the return value of ``getZfPath()``.

In the second situation, for **quality assurance**, let's say we want to pin to the 1.8 minor release, using the
latest install you have for that release. You can do so as follows:

.. code-block:: php
   :linenos:

   $autoloader->setZfPath($path, '1.8');

In this case, it will find the directory ``ZendFramework/1.8.4PL1/library/``.

In the final case, for **production**, we'll pin to a specific version -- 1.7.7, since that was what was available
when Quality Assurance tested prior to our release.

.. code-block:: php
   :linenos:

   $autoloader->setZfPath($path, '1.7.7');

Predictably, it finds the directory ``ZendFramework/1.7.7/library/``.

You can also specify these values in the configuration file you use with ``Zend_Application``. To do so, you'd
specify the following information:

.. code-block:: ini
   :linenos:

   [production]
   autoloaderZfPath = "path/to/ZendFramework"
   autoloaderZfVersion = "1.7.7"

   [qa]
   autoloaderZfVersion = "1.8"

   [development]
   autoloaderZfVersion = "latest"

Note the different environment sections, and the different version specified in each environment; these factors
will allow ``Zend_Application`` to configure the autoloader appropriately.

.. warning::

   **Performance implications**

   For best performance, either do not use this feature, or specify a specific Zend Framework version (i.e., not
   "latest", a major revision such as "1", or a minor revision such as "1.8"). Otherwise, the autoloader will need
   to scan the provided path for directories matching the criteria -- a somewhat expensive operation to perform on
   each request.

.. _zend.loader.autoloader.interface:

L'interface de l'autoloader
---------------------------

Vous pouvez donc ajouter des fonctions de chargement par espace de noms, mais Zend Framework définit aussi une
interface pour l'autoload, ``Zend_Loader_Autoloader_Interface``\  :

.. code-block:: php
   :linenos:

   interface Zend_Loader_Autoloader_Interface
   {
       public function autoload($class);
   }

L'utilisation de l'interface vous permet de passer un objet aux méthodes ``pushAutoloader()`` et
``unshiftAutoloader()`` de ``Zend_Loader_Autoloader``\  :

.. code-block:: php
   :linenos:

   // Foo_Autoloader implémente Zend_Loader_Autoloader_Interface:
   $foo = new Foo_Autoloader();

   $autoloader->pushAutoloader($foo, 'Foo_');

.. _zend.loader.autoloader.reference:

Référence de l'autoloader
-------------------------

Voici un guide des méthodes de ``Zend_Loader_Autoloader``.

.. _zend.loader.autoloader.reference.api:

.. table:: Méthodes de Zend_Loader_Autoloader

   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Méthode                                      |Valeur de retour              |Paramètres                                                                                                                                |Description                                                                                                                                                                                                                                                                                                  |
   +=============================================+==============================+==========================================================================================================================================+=============================================================================================================================================================================================================================================================================================================+
   |getInstance()                                |Zend_Loader_Autoloader        |N/A                                                                                                                                       |Retourne l'instance singleton de Zend_Loader_Autoloader Au premier appel, enregistre l'autoloader avec spl_autoload. Cette méthode est statique.                                                                                                                                                             |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |resetInstance()                              |void                          |N/A                                                                                                                                       |Remet à zéro l'état interne de Zend_Loader_Autoloader en désenregistrant les fonctions d'autoload éventuellement présentes, ainsi que tous les espaces de noms.                                                                                                                                              |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |autoload($class)                             |string|false                  |$class, requis. Une classe à charger.                                                                                                     |Essaye de résoudre un nom de classe en fichier, et tente de la charger.                                                                                                                                                                                                                                      |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setDefaultAutoloader($callback)              |Zend_Loader_Autoloader        |$callback, requis.                                                                                                                        |Spécifie une fonction PHP à utiliser comme autoloader par défaut.                                                                                                                                                                                                                                            |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDefaultAutoloader()                       |callback                      |N/A                                                                                                                                       |Retourne la fonction d'autoload par défaut, il s'agit par défaut de Zend_Loader::loadClass().                                                                                                                                                                                                                |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setAutoloaders(array $autoloaders)           |Zend_Loader_Autoloader        |$autoloaders, requis.                                                                                                                     |Passe une liste d'autoloaders (sous forme de noms de fonctions PHP) Ã  ajouter Ã  la pile de ceux déjà présents.                                                                                                                                                                                             |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getAutoloaders()                             |Array                         |N/A                                                                                                                                       |Récupère la pile d'autoloaders interne.                                                                                                                                                                                                                                                                      |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getNamespaceAutoloaders($namespace)          |Array                         |$namespace, requis                                                                                                                        |Récupère tous les autoloaders qui sont associés à un certain espace de noms.                                                                                                                                                                                                                                 |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |registerNamespace($namespace)                |Zend_Loader_Autoloader        |$namespace, requis.                                                                                                                       |Enregistre un ou plusieurs espaces de noms, avec l'autoloader par défaut. Si $namespace est une chaîne, c'est cet espace de noms qui sera enregistré, si c'est un tableau de chaînes, ils le seront tous.                                                                                                    |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |unregisterNamespace($namespace)              |Zend_Loader_Autoloader        |$namespace, requis.                                                                                                                       |Désenregistre (supprime) un espace de noms depuis l'autoloader par défaut. Si $namespace est une chaîne, c'est cet espace de noms qui sera désenregistré, si c'est un tableau de chaînes, ils le seront tous.                                                                                                |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getRegisteredNamespaces()                    |Array                         |N/A                                                                                                                                       |Retourne un tableau comportant tous les espaces de noms enregistrés avec l'autoloader par défaut.                                                                                                                                                                                                            |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |suppressNotFoundWarnings($flag = null)       |boolean|Zend_Loader_Autoloader|$flag, optionnel.                                                                                                                         |Affecte ou récupère la valeur du paramètre indiquant si l'autoloader par défaut doit supprimer les warnings "file not found". Si aucun argument (ou null) lui est passé, il retourne sa valeur actuelle, dans le cas contraire, il retournera l'instance de l'autoloader permettant le chainage des méthodes.|
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setFallbackAutoloader($flag)                 |Zend_Loader_Autoloader        |$flag, requis.                                                                                                                            |Affecte la valeur du drapeau utilisé pour déterminer si l'autoloader par défaut doit être utilisé comme "catch-all" pour charger tous les espaces de noms.                                                                                                                                                   |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |isFallbackAutoloader()                       |Boolean                       |N/A                                                                                                                                       |Retourne la valeur du drapeau utilisé pour déterminer si l'autoloader par défaut doit être utilisé comme "catch-all" pour charger tous les espaces de noms.                                                                                                                                                  |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getClassAutoloaders($class)                  |Array                         |$class, requis.                                                                                                                           |Retourne une liste d'autoloaders d'espaces de noms qui pourraient correspondre à la classe indiquée. Si aucun ne correspond, la liste de tous les autoloaders globaux (non associés à des espaces de noms) sera retournée.                                                                                   |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |unshiftAutoloader($callback, $namespace = '')|Zend_Loader_Autoloader        |$callback, requis. Une fonction PHP valide. $namespace, optionnel. Une chaîne représentant un préfixe de classe.                          |Ajoute un autoloader au début de la pile des autoloaders internes. Si un espace de noms est fourni, il sera utilisé pour cet autoloader, sinon l'autoloader sera global.                                                                                                                                     |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |pushAutoloader($callback, $namespace = '')   |Zend_Loader_Autoloader        |$callback, requis. Une fonction PHP valide. $namespace, optionnel. Une chaîne représentant un préfixe de classe.                          |Ajoute un autoloader à la fin de la pile des autoloaders internes. Si un espace de noms est fourni, il sera utilisé pour cet autoloader, sinon l'autoloader sera global.                                                                                                                                     |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |removeAutoloader($callback, $namespace = '') |Zend_Loader_Autoloader        |$callback, requis. Une fonction PHP valide. $namespace, optionnel. Une chaîne représentant un préfixe de classe, ou un tableau de chaînes.|Supprime un autoloader de la pile interne. Si un espace de noms est indiqué, supprime l'autoloader pour cet espace de noms uniquement.                                                                                                                                                                       |
   +---------------------------------------------+------------------------------+------------------------------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _`PHP Framework Interop Group PSR-0`: http://groups.google.com/group/php-standards/web/psr-0-final-proposal
