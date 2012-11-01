.. EN-Revision: none
.. _performance.classloading:

Chargement des classes
======================

Tous ceux qui ont déjà réalisé le profilage d'une application Zend Framework reconnaîtront immédiatement que
le chargement des classes y est relativement coûteux. Entre le nombre important de fichier de classe qui doivent
être chargées pour un grand nombre de composants et l'utilisation des plugins qui n'impliquent pas une relation
1:1 entre leur nom de classe et le système de fichier, les différents appels de *include_once* et *require_once*
peuvent être problématique. Ce chapitre a pour but de fournir des solutions concrètes pour solutionner ces
problèmes.

.. _performance.classloading.includepath:

Comment optimiser mon include_path ?
------------------------------------

Une optimisation triviale pour accélérer la vitesse de chargement des classes est de faire attention à votre
*include_path*. En particulier, vous devriez faire quatre choses : utilisez des chemins absolus (ou des chemins
relatifs à des chemins absolus), réduire le nombre des chemins à inclure, définir le dossier de Zend Framework
le plus tôt possible dans l'*include_path* et inclure le dossier courant en dernier dans votre *include_path*.

.. _performance.classloading.includepath.abspath:

Utiliser des chemins absolus
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Tandis que ceci peut sembler une micro-optimisation, le fait est que si vous ne le faites pas, vous n'obtiendrez
qu'un très petit avantage de la mise en cache du realpath de PHP, et en conséquence, le cache d'opcode ne
fonctionnera pas tout à fait comme vous pourriez l'imaginer.

Il y a deux manières simples de s'assurer de ceci. Premièrement, vous pouvez le mettre en dur dans votre
``php.ini``, ``httpd.conf``, ou ``.htaccess``. Deuxièmement, vous pouvez utiliser la fonction *realpath()* de PHP
au moment du paramétrage de votre *include_path*\  :

.. code-block:: php
   :linenos:

   $paths = array(
       realpath(dirname(__FILE__) . '/../library'),
       '.',
   );
   set_include_path(implode(PATH_SEPARATOR, $paths);

Vous **pouvez** utiliser des chemins relatifs - du moment qu'ils sont relatifs à un chemin absolu :

.. code-block:: php
   :linenos:

   define('APPLICATION_PATH', realpath(dirname(__FILE__)));
   $paths = array(
       APPLICATION_PATH . '/../library'),
       '.',
   );
   set_include_path(implode(PATH_SEPARATOR, $paths);

Néanmoins, c'est typiquement une tâche insignifiante de fournir simplement le chemin à *realpath()*.

.. _performance.classloading.includepath.reduce:

Réduire le nombre de dossier défini dans l'include_path
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les chemins d'inclusion sont scannés dans l'ordre dans lequel ils apparaissent dans l'*include_path*. Évidemment,
ceci veut dire que vous aurez un résultat plus rapide si le fichier est trouvé dans le premier chemin scanné que
si vous le trouvez dans le dernier chemin scanné. De plus, une amélioration plutôt évidente est de diminuer
tout simplement le nombre de chemins dans votre *include_path* à seulement de ce que vous avez réellement besoin.
Regardez chaque chemin que vous avez défini dans votre include_path pour déterminer si vous avez réellement
besoin d'une fonctionnalité dans votre application ; si ce n'est pas le cas, enlevez le.

Une autre optimisation consiste en la combinaison de chemins. Par exemple, Zend Framework suit la convention de
nommage PEAR ; ainsi , si vous utilisez des librairies PEAR (ou d'autres framework ou librairies de composants qui
respectent la convention de nommage PEAR), essayez de mettre toutes ces librairies dans le même chemin de
l'*include_path*. Ceci peut souvent être réalisé par quelque chose d'assez simple comme de créer des liens
symboliques vers une ou plusieurs bibliothèques dans un dossier commun.

.. _performance.classloading.includepath.early:

Définir le dossier de Zend Framework le plus tôt possible dans l'include_path
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Pour continuer avec les suggestions précédentes, une autre optimisation évidente est de définir le dossier de
Zend Framework le plus tôt possible dans votre *include_path*. Dans la plupart des cas, il devrait être le
premier de la liste. Ceci permet de s'assurer les fichiers de Zend Framework à inclure le sont dès le premier
scan.

.. _performance.classloading.includepath.currentdir:

Définir le dossier courant le plus tard possible ou pas du tout
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La plupart des exemples d'*include_path* montre l'utilisation du répertoire courant ("*.*"). Ceci est pratique
pour s'assurer que les scripts dans le même dossier que le fichier courant peuvent aussi être chargés. Cependant
ces mêmes exemples montrent souvent ce dossier comme étant le premier de la liste des include_path - ce qui veut
dire l'arbre de dossiers courant est toujours scanné en premier. La plupart du temps, avec Zend Framework, ce
n'est pas nécessaire, et ce dossier peut tout naturellement être mis en dernière position de la liste.

.. _performance.classloading.includepath.example:

.. rubric:: Exemple : optimisation de l'include_path

Essayons de mettre ensemble toutes ces suggestions. Considérons que nous utilisons une ou plusieurs composants
PEAR en conjonction avec Zend Framework - par exemple les composants PHPUnit et Archive_Tar - et qu'il est
occasionnellement nécessaire d'inclure les fichiers relativement au fichier courant.

Premièrement, nous allons créer un dossier pour les librairies dans notre projet. Dans ce même dossier, nous
allons créer un lien symbolique vers notre dossier Zend Framework "``library/Zend``", ainsi que les dossiers
nécessaires dans notre installation PEAR :

.. code-block:: php
   :linenos:

   library
       Archive/
       PEAR/
       PHPUnit/
       Zend/

Ceci nous permet d'ajouter notre propre librairie si nécessaire, tout en laissant intact les librairies
partagées.

Ensuite, nous optons pur la création de notre *include_path* par programme à l'intérieur de notre fichier
``public/index.php``. Ceci nous permet de déplacer notre code dans le système de fichiers, sans devoir éditer
l'*include_path* à chaque fois.

Nous emprunterons des idées à chacune des suggestions ci-dessus : nous utiliserons les chemins absolus,
déterminé en utilisant le *realpath()*\  ; nous positionnerons Zend Framework au plus tôt dans
l'*include_path*; nous avons déjà vérifié les chemins d'inclusions nécessaires ; et nous mettrons le dossier
courant comme dernier chemin. En fait, nous faisons tout bien ici - nous allons donc terminer avec seulement deux
chemins.

.. code-block:: php
   :linenos:

   $paths = array(
       realpath(dirname(__FILE__) . '/../library'),
       '.'
   );
   set_include_path(implode(PATH_SEPARATOR, $paths));

.. _performance.classloading.striprequires:

Comment éliminer les déclarations require_once non nécessaires ?
----------------------------------------------------------------

Le chargement tardif ("lazy loading") est une technique d'optimisation conçue pour repousser l'opération
coûteuse de chargement d'une classe jusqu'au dernier moment possible - c'est-à-dire lors de l'instanciation d'un
objet de cette classe, ou lors de l'utilisation d'une constante de classe ou d'une propriété statique. PHP
supporte tout ceci via l'autoloading (ou "chargement automatique"), ce qui vous permet de définir un ou plusieurs
callbacks à exécuter dans le but de faire correspondre un nom de classe à un fichier.

Cependant, la plupart des avantages que vous pourrez retirer de l'autoloading sont diminués si le code de votre
librairie exécute toujours des appels à *require_once*- ce qui est précisément le cas de Zend Framework. La
question est donc : comment éliminer ces déclarations *require_once* dans le but de maximiser les performances de
l'autoloader.

.. _performance.classloading.striprequires.sed:

Effacer les appels de require_once avec find et sed
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Une manière simple d'effacer les appels require_once est d'utiliser les utilitaires Unix "find" en conjonction
avec "sed" pour passe en commentaires tous les appels. Essayez d'exécuter les commandes suivantes (où "%" indique
le prompteur shell) :

.. code-block:: console
   :linenos:

   % cd chemin/vers/la/librarie/ZendFramework
   % find . -name '*.php' -not -wholename '*/Loader/Autoloader.php' \
     -not -wholename '*/Application.php' -print0 | \
     xargs -0 sed --regexp-extended --in-place 's/(require_once)/\/\/ \1/g'

Cette ligne unique (coupée en deux pour la lisibilité) itère parmi les fichiers PHP et y remplace toute les
instances de *require_once* par *//require_once*, c'est-à-dire en commentant toutes ces lignes (tout en maintenant
les appels à ``require_once`` dans ``Zend_Application`` et ``Zend\Loader\Autoloader``, puisque ces classes
tomberont en erreur sans ceux-ci).

Cette commande peut être simplement ajoutée à un script de construction automatique ou à un processus de mise
en production, permettent ainsi d'augmenter les performances de votre application en production. Il est à noter,
cependant, que si vous utilisez cette technique, vous **devez** utiliser l'autoloading ; vous pouvez l'activer dans
votre fichier ``public/index.php`` en ajoutant le code suivant :

.. code-block:: php
   :linenos:

   require_once 'Zend/Loader/Autoloader.php';
   Zend\Loader\Autoloader::getInstance();

.. _performance.classloading.pluginloader:

Comment accélérer le chargement des plugins ?
---------------------------------------------

Certains composants utilisent les plugins, ce qui vous permet de créer vos propres classes afin de les utiliser
avec le composant, de même que de surcharger les plugins standard existants embarqués dans Zend Framework. Ceci
fournit une importante flexibilité au framework, mais a un prix : le chargement des plugins est une tâche assez
coûteuse.

Le chargeur de plugins vous permet de définir des paires préfixe de classe / chemin, vous autorisant ainsi à
spécifier des fichiers de classe dans des chemins de dossiers non standard. Chaque préfixe peut avoir de
multiples chemins associés. En interne, le chargeur de plugins boucle à travers chaque préfixe, et ensuite à
travers chaque chemin lui étant associé, en testant l'existence du fichier et s'il est accessible dans ce chemin.
Il le charge ensuite, et teste pour voir si la classe recherchée est bien disponible. Comme vous pouvez
l'imaginer, tout ceci entraîne des appels aux stats du système de fichiers.

Multipliez ceci par le nombre de composants qui utilisent le PluginLoader, et vous aurez une idée de l'importance
de ce problème. Au moment de l'écriture de ce document, les composants suivants utilisent le PluginLoader :

- ``Zend\Controller_Action\HelperBroker``\  : aides d'action

- ``Zend\File\Transfer``\  : adaptateurs

- ``Zend\Filter\Inflector``\  : filtres (utilisé par l'aide d'action *ViewRenderer* et ``Zend_Layout``)

- ``Zend\Filter\Input``\  : filtres et validateurs

- ``Zend_Form``\  : éléments, validateurs, filtres, décorateurs, captcha et adaptateur pour les transferts de
  fichiers

- ``Zend_Paginator``\  : adaptateurs

- ``Zend_View``\  : aides de vues, filtres

Comment réduire le nombre des appels réalisés ?

.. _performance.classloading.pluginloader.includefilecache:

Utiliser le fichier de cache des inclusions du PluginLoader
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zend Framework 1.7.0 ajoute un fichier de cache des inclusions au PluginLoader. Cette fonctionnalité écrit dans
un fichier les appels "*include_once*", que vous pouvez ensuite inclure dans votre fichier d'amorçage. Même si
ceci introduit de nouveaux appels include_once dans votre code, cela permet de s'assurer que le PluginLoader les
retournera au plus vite.

La documentation du PluginLoader :ref:`inclue un exemple complet de son utilisation
<zend.loader.pluginloader.performance.example>`.


