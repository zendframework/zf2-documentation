.. EN-Revision: none
.. _user-guide.modules:

#######
Modules
#######

Zend Framework 2 utilise un système de modules, et vous organisez le code
spécifique à votre application au sein de chaque module. Le module Application
qui est fourni avec le skeleton est utilisé pour le boostrapping, la gestion des erreurs
et le routing de toute votre application. Il est généralement  utilisé pour fournir les
contrôleurs de base de l'application (ex: la page d'accueil de votre application), mais
nous n'allons pas utiliser celui fourni dans ce tutoriel, étant donné que nous voulons que
notre liste d'albums soit la page d'accueil de notre application, qui sera elle-même dans 
notre module.

Nous allons placer tout notre code dans le module Album, qui contiendra nos contrôleurs,
modèles, formulaires et vues, avec leur configuration respective. Nous serons de même amenés à modifier
le module Application

Commençons avec l'arborescence requise.

Mise en place du module Album
---------------------------

Commencez par créer un dossier ``Album`` ainsi que ses sous-dossiers
qui contiendront les fichiers du module.

.. code-block:: text

    zf2-tutorial/
        /module
            /Album
                /config
                /src
                    /Album
                        /Controller
                        /Form
                        /Model
                /view
                    /album
                        /album

Comme vous pouvez le voir, le module ``Album`` a des dossiers distincts pour
chaque type de fichiers qu'il contiendra. Les fichiers de classes PHP du namespace
``Album`` seront stockés dans le dossier ``src/Album``, ce qui nous permettra d'avoir
autant de namespaces que nécessaire. Le dossier view contient lui-aussi un sous-dossier
``album`` pour les fichiers de vue de notre module.

Afin de charger et de configurer un module, Zend Framework 2 a un ``ModuleManager``.
Il ira lire ``Module.php`` dans le dossier racine du module (``module/Album``), et 
s'attendra à y trouver une classe nommée ``Album\Module``. Ainsi, les classes d'un 
module auront pour namespace le nom du module lui-même, qui est aussi le nom du dossier
qui contient le module.

Creez ``Module.php`` dans le module ``Album`` :

.. code-block:: php

    // module/Album/Module.php
    namespace Album;
    
    class Module
    {
        public function getAutoloaderConfig()
        {
            return array(
                'Zend\Loader\ClassMapAutoloader' => array(
                    __DIR__ . '/autoload_classmap.php',
                ),
                'Zend\Loader\StandardAutoloader' => array(
                    'namespaces' => array(
                        __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                    ),
                ),
            );
        }
    
        public function getConfig()
        {
            return include __DIR__ . '/config/module.config.php';
        }
    }

Le ``ModuleManager`` appelera ``getAutoloaderConfig()`` and ``getConfig()``
automatiquement pour nous.

Chargement automatique des fichiers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Notre méthode``getAutoloaderConfig()`` retourne un tableau qui est compatible avec
l'``AutoloaderFactory`` de ZF2. nous le configurons de sorte que nous ajoutons un
fichier de classe au ``ClassmapAutoloader``, et nous ajoutons aussi le namespace
au ``StandardAutoloader``. Ce dernier a besoin comme paramètres d'un namespace et
du chemin où sont stockés les fichiers du namespace. Il est PSR-0 compliant, ie. 
classes et fichiers obéissent aux règles définies par la norme PSR-0
<https://github.com/php-fig/fig-standards/blog/master/accepted/PSR-0.md>`_.

Comme nous sommes en développement, nous n'avons pas la nécessité d'auto-charger nos fichiers,
on retourne donc un tableau vide à l'autoloader. On crée le fichier ``autoload_classmap.php`` avec 
le contenu suivant : 

.. code-block:: php

    <?php
    // module/Album/autoload_classmap.php:
    return array();

Comme il s'agit d'un tableau vide, quand l'autoloader cherchera une classe dans 
le namespace ``Album``, il sera redirigé vers le `StandardAutoloader`` pour nous.

Alternativement, si vous utilisez Composer, vous pourriez ne pas implémenter 
``getAutoloaderConfig()`` et à la place, ajouter ``"Application":
"module/Application/src"`` à la clé ``psr-0`` dans ``composer.json``. Si vous choisissez
cette technique, vous devrez lancer `php composer.phar update`` afin de mettre
à jour les fichiers d'auto-chargement de composer.

Configuration
-------------

Ayant satisfait l'autoloader, regardons rapidement la méthode ``getConfig()``
dans ``Album\Module``.  Cette méthode charge simplement le fichier ``config/module.config.php``

Créer le fichier suivant de configuration pour le module  ``Album`` :

.. code-block:: php

    // module/Album/config/module.config.php:
    return array(
        'controllers' => array(
            'invokables' => array(
                'Album\Controller\Album' => 'Album\Controller\AlbumController',
            ),
        ),
        'view_manager' => array(
            'template_path_stack' => array(
                'album' => __DIR__ . '/../view',
            ),
        ),
    );

La configuration est passée aux composants respectifs par le
``ServiceManager``. Nous avons besoin de deux sections distinctes : 
`controller`` and ``view_manager``. La section controller renvoie une liste
de tous les contrôleurs que propose le module. Nous aurons besoin d'un contrôleur,
``AlbumController``, qui nous référencerons comme ``Album\Controller\Album``.
Nous le nommons ainsi étant donné que la clé doit être unique parmi tous les 
modules, donc nous la préfixons du nom de notre module.

Dans la section ``view_manager``, nous ajoutons notre dossier view à 
la configuration de ``TemplatePathStack``. Cela nous permettra de trouver les scripts
de vues du module ``Album``, stockés dans notre dossier ``views/``.

Informez l'application de notre nouveau module
----------------------------------------------

Nous devons maintenant dire au ``ModuleManager`` que notre nouveau module existe. Cela
est fait dans le fichier `config/application.config.php`` fourni avec le skeleton. Mettez à 
jour ce fichier de telle façon que sa section ``modules`` contienne notre module ``Album``
comme ci-dessous :

(Les changements à effectuer sont montrés dans les commentaires du code)

.. code-block:: php

    // config/application.config.php:
    return array(
        'modules' => array(
            'Application',
            'Album',                  // <-- Add this line
        ),
        'module_listener_options' => array( 
            'config_glob_paths'    => array(
                'config/autoload/{,*.}{global,local}.php',
            ),
            'module_paths' => array(
                './module',
                './vendor',
            ),
        ),
    );

Comme vous pouvez le voir, nous avons ajouté notre module `Album`` dans la liste
des modules, après le module `Application``

Le module est désormais prêt, nous allons pouvoir y ajouter notre code.
