.. EN-Revision: none
.. _zend.cache.frontends:

Les frontends Zend_Cache
========================

.. _zend.cache.frontends.core:

Zend\Cache\Core
---------------

.. _zend.cache.frontends.core.introduction:

Introduction
^^^^^^^^^^^^

``Zend\Cache\Core`` est un frontend spécial parce qu'il est le coeur du module. C'est le frontend de cache
générique qui est étendu par les autres classes.

.. note::

   Tous les frontends héritent de ``Zend\Cache\Core`` ainsi ses méthodes et options (décrites ci-dessous) seront
   aussi disponibles dans les autres frontends, cependant ils ne sont pas documentés ici.

.. _zend.cache.frontends.core.options:

Options disponibles
^^^^^^^^^^^^^^^^^^^

Ces options sont passées à la méthode de fabrique comme montrées dans les exemples précédents.

.. _zend.cache.frontends.core.options.table:

.. table:: Options du frontend Core

   +-------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                   |Type de données|Valeur par défaut|Description                                                                                                                                                                                                                                                                                                                                                                                                    |
   +=========================+===============+=================+===============================================================================================================================================================================================================================================================================================================================================================================================================+
   |caching                  |Boolean        |TRUE             |Active / désactive le cache (peut=être très utile pour le débogage de scripts en cache)                                                                                                                                                                                                                                                                                                                        |
   +-------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_id_prefix          |String         |NULL             |Un préfixe pour tous les ID de cache, si réglé à NULL, aucun préfixe d'ID de cache ne sera utilisé. Le préfixe d'ID de cache sert essentiellement à créer des espaces de noms dans le cache, permettant à plusieurs applications ou sites Web d'utiliser un cache partagé. Chaque application ou site web peut utilisé un préfixe d'ID de cache différent et un préfixe peut aussi être utilisé plusieurs fois.|
   +-------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |lifetime                 |Integer        |3600             |Temps de vie (en secondes) du cache, si défini à NULL, le cache est valide indéfiniment                                                                                                                                                                                                                                                                                                                        |
   +-------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |logging                  |Boolean        |FALSE            |Si défini à TRUE, le logging par Zend_Log est activé (mais le système sera plus lent)                                                                                                                                                                                                                                                                                                                          |
   +-------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |write_control            |Boolean        |TRUE             |Active / désactive le contrôle d'écriture (le cache est lu juste après l'écriture pour détecter des entrées corrompues), activer "writeControl" va ralentir un petit peu l'écriture du cache, mais pas la lecture (il peut détecter des fichiers de cache corrompus, mais ceci n'est pas un contrôle parfait).                                                                                                 |
   +-------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automatic_serialization  |Boolean        |FALSE            |Active / désactive la sérialisation automatique, il peut être utilisé pour enregistrer directement des données qui ne sont pas des chaînes de caractères (mais c'est plus lent).                                                                                                                                                                                                                               |
   +-------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automatic_cleaning_factor|Integer        |0                |Active / désactive le nettoyage automatique ("garbage collector"): 0 signifie aucun nettoyage automatique de cache, 1 signifie un nettoyage systématique du cache et x > 1 signifie le nettoyage aléatoire 1 fois toute les x écritures.                                                                                                                                                                       |
   +-------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |ignore_user_abort        |Boolean        |FALSE            |Si réglé à TRUE, le cache active le drapeau PHP "ignore_user_abort" dans la méthode save() pour prévenir de la corruption du cache dans certains cas.                                                                                                                                                                                                                                                          |
   +-------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.core.examples:

Exemples
^^^^^^^^

Un exemple est donné dans le manuel, tout au début.

Si vous stocker uniquement des chaînes de caractères dans le cache (parce qu'avec l'option
"automatic_serialization", il est possible de stocker des booléens), vous pouvez utiliser une construction plus
compact comme :

.. code-block:: php
   :linenos:

   // nous avons déjà $cache

   $id = 'myBigLoop'; // id de cache de "ce que l'on veut cacher"

   if (!($data = $cache->load($id))) {
       // cache absent

       $data = '';
       for ($i = 0; $i < 10000; $i++) {
           $data = $data . $i;
       }

       $cache->save($data);

   }

   // [...] fait quelque chose avec $data
   // (affichage, passage ailleurs, etc, etc)

Si vous voulez cacher des blocs multiples ou des instances de données, l'idée reste la même :

.. code-block:: php
   :linenos:

   // on s'assure que l'on utilise des identifiant uniques
   $id1 = 'foo';
   $id2 = 'bar';

   // block 1
   if (!($data = $cache->load($id1))) {
       // cache absent

       $data = '';
       for ($i=0;$i<10000;$i++) {
           $data = $data . $i;
       }

       $cache->save($data);

   }
   echo($data);

   // ceci n'est pas affecté par la mise en cache
   echo('NEVER CACHED! ');

   // block 2
   if (!($data = $cache->load($id2))) {
       // cache missed

       $data = '';
       for ($i=0;$i<10000;$i++) {
           $data = $data . '!';
       }

       $cache->save($data);

   }
   echo($data);

Si vous voulez cacher des valeurs "spéciales" (des booléens avec l'option "automatic_serialization") ou des
chaînes vides, vous ne pouvez pas utiliser la construction compacte montrée ci-dessus. Vous devez tester de
manière formelle l'état du cache.

.. code-block:: php
   :linenos:

   // La construction compacte (ne pas utiliser si vous cachez
   // des chaînes et/ou des booléens)
   if (!($data = $cache->load($id))) {

       // cache absent

       // [...] on crée $data

       $cache->save($data);

   }

   // on fait qqch avec $data

   // [...]

   // La construction complète (fonctionne dans tous les cas)
   if (!($cache->test($id))) {

       // cache absent

       // [...] on crée $data

       $cache->save($data);

   } else {

       // lecture du cache

       $data = $cache->load($id);

   }

   // on fait qqch avec $data

.. _zend.cache.frontends.output:

Zend\Cache_Frontend\Output
--------------------------

.. _zend.cache.frontends.output.introduction:

Introduction
^^^^^^^^^^^^

``Zend\Cache_Frontend\Output`` est un frontend capturant la sortie. Il utilise la bufferisation de sortie de *PHP*
pour capturer tout ce qui passe entre les méthodes ``start()`` et ``end()``.

.. _zend.cache.frontends.output.options:

Options disponibles
^^^^^^^^^^^^^^^^^^^

Ce frontend n'a pas d'options spécifiques autres que celles de ``Zend\Cache\Core``.

.. _zend.cache.frontends.output.examples:

Exemples
^^^^^^^^

Un exemple est donnée dans le manuel, tout au début. Le voici avec des changements mineurs :

.. code-block:: php
   :linenos:

   // s'il y a un cache manquant, la bufferisation de sortie est lancée
   if (!$cache->start('mypage')) {

       // affiche tout comme d'habitude
       echo 'Hello world! ';
       echo 'This is cached ('.time().') ';

       $cache->end(); // affiche ce qu'il y a dans le buffer
   }

   echo 'This is never cached ('.time().').';

Utiliser cette forme est assez simple pour définir une mise de cache de sortie dans vos projets déjà en
production, avec peu de refactorisation de code.

.. _zend.cache.frontends.function:

Zend\Cache_Frontend\Function
----------------------------

.. _zend.cache.frontends.function.introduction:

Introduction
^^^^^^^^^^^^

``Zend\Cache_Frontend\Function`` met en cache les résultats des appels de fonction. Elle a une seule méthode
principale appelée ``call()`` qui prend un nom de fonction et des paramètres pour l'appel dans un tableau.

.. _zend.cache.frontends.function.options:

Options disponibles
^^^^^^^^^^^^^^^^^^^

.. _zend.cache.frontends.function.options.table:

.. table:: Options du frontend Function

   +--------------------+---------------+-----------------+--------------------------------------------------------------+
   |Option              |Type de données|Valeur par défaut|Description                                                   |
   +====================+===============+=================+==============================================================+
   |cache_by_default    |Boolean        |TRUE             |si TRUE, les appels de fonction seront mis en cache par défaut|
   +--------------------+---------------+-----------------+--------------------------------------------------------------+
   |cached_functions    |Array          |''               |les noms de fonctions seront toujours mis en cache            |
   +--------------------+---------------+-----------------+--------------------------------------------------------------+
   |non_cached_functions|Array          |''               |les noms de fonctions ne doivent jamais être mis en cache     |
   +--------------------+---------------+-----------------+--------------------------------------------------------------+

.. _zend.cache.frontends.function.examples:

Exemples
^^^^^^^^

Utiliser la fonction ``call()`` est la même chose qu'utiliser ``call_user_func_array()`` en *PHP*\  :

.. code-block:: php
   :linenos:

   $cache->call('veryExpensiveFunc', $params);

   // $params est dans un tableau par exemple, pour appeler
   // (avec mise en cache) : veryExpensiveFunc(1, 'foo', 'bar')
   // vous devriez utiliser
   $cache->call('veryExpensiveFunc', array(1, 'foo', 'bar'));

``Zend\Cache_Frontend\Function`` est assez intelligente pour mettre en cache la valeur de retour de la fonction,
ainsi que sa sortie interne.

.. note::

   Vous pouvez passer n'importe quelle fonction utilisateur à l'exception de ``array()``, ``echo()``, ``empty()``,
   ``eval()``, ``exit()``, ``isset()``, ``list()``, ``print()`` et ``unset()``.

.. _zend.cache.frontends.class:

Zend\Cache_Frontend\Class
-------------------------

.. _zend.cache.frontends.class.introduction:

Introduction
^^^^^^^^^^^^

``Zend\Cache_Frontend\Class`` est différent de ``Zend\Cache_Frontend\Function`` parce qu'elle permet de mettre en
cache les objets et les méthodes statiques.

.. _zend.cache.frontends.class.options:

Options disponibles
^^^^^^^^^^^^^^^^^^^

.. _zend.cache.frontends.class.options.table:

.. table:: Options du frontend Class

   +----------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                |Type de données|Valeur par défaut|Description                                                                                                                                                                                                    |
   +======================+===============+=================+===============================================================================================================================================================================================================+
   |cached_entity (requis)|Mixed          |                 |si défini avec un nom de classe, nous allons mettre en cache une classe abstraite et utiliser uniquement les appels statiques ; si défini avec un objet, nous allons mettre en cache les méthodes de cet objet.|
   +----------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_by_default      |Boolean        |TRUE             |si TRUE, les appels vont être cachés par défaut                                                                                                                                                                |
   +----------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cached_methods        |Array          |                 |les noms des méthodes qui seront toujours mis en cache                                                                                                                                                         |
   +----------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |non_cached_methods    |Array          |                 |les noms des méthodes qui ne doivent jamais être mises en cache                                                                                                                                                |
   +----------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.frontends.class.examples:

Exemples
^^^^^^^^

Par exemple, pour mettre en cache des appels statiques :

.. code-block:: php
   :linenos:

   class test {

       // Méthode statique
       public static function foobar($param1, $param2) {
           echo "foobar_output($param1, $param2)";
           return "foobar_return($param1, $param2)";
       }

   }

   // [...]
   $frontendOptions = array(
       'cached_entity' => 'test' // Le nom de la classe
   );
   // [...]

   // l'appel caché
   $res = $cache->foobar('1', '2');

Pour mettre en cache des appels classiques aux méthodes :

.. code-block:: php
   :linenos:

   class test {

       private $_string = 'hello !';

       public function foobar2($param1, $param2) {
           echo($this->_string);
           echo "foobar2_output($param1, $param2)";
           return "foobar2_return($param1, $param2)";
       }

   }

   // [...]
   $frontendOptions = array(
       'cached_entity' => new test() // Une instance de la classe
   );
   // [...]

   // L'appel mis en cache
   $res = $cache->foobar2('1', '2');

.. _zend.cache.frontends.file:

Zend\Cache_Frontend\File
------------------------

.. _zend.cache.frontends.file.introduction:

Introduction
^^^^^^^^^^^^

``Zend\Cache_Frontend\File`` est un frontend piloté par la modification d'un "fichier maître". C'est vraiment
intéressant, par exemple, dans les problématiques de configuration ou de templates. Il est également possible
d'utiliser plusieurs fichiers maîtres.

Par exemple, vous avez un fichier de configuration *XML* qui est analysé par une fonction, celle-ci retourne un
"objet de configuration" (comme avec ``Zend_Config``). Avec ``Zend\Cache_Frontend\File``, vous pouvez stocker
l'objet de configuration dans le cache (pour éviter d'analyser le fichier de configuration *XML* chaque fois) mais
avec une sorte de forte dépendance au fichier maître. Ainsi si le fichier *XML* de configuration est modifié, le
cache est immédiatement invalide.

.. _zend.cache.frontends.file.options:

Options disponibles
^^^^^^^^^^^^^^^^^^^

.. _zend.cache.frontends.file.options.table:

.. table:: Options du frontend File

   +---------------------------+---------------+---------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                     |Type de données|Valeur par défaut                |Description                                                                                                                                                                                                                                                        |
   +===========================+===============+=================================+===================================================================================================================================================================================================================================================================+
   |master_file (déprécié)     |String         |''                               |le chemin complet et le nom du fichier maître                                                                                                                                                                                                                      |
   +---------------------------+---------------+---------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |master_files               |Array          |array()                          |un tableau de chemin complet de fichiers maîtres                                                                                                                                                                                                                   |
   +---------------------------+---------------+---------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |master_files_mode          |String         |Zend\Cache_Frontend\File::MODE_OR|Zend\Cache_Frontend\File::MODE_AND oU Zend\Cache_Frontend\File::MODE_OR ; si MODE_AND, alors tous les fichiers maîtres doivent être modifiés pour rendre invalide le cache, si MODE_OR, alors un seul fichier maître modifié est nécessaire pour invalider le cache|
   +---------------------------+---------------+---------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |ignore_missing_master_files|Boolean        |FALSE                            |si TRUE, l'absence de fichiers maîtres est ignoré silencieusement (sinon une exception est levée)                                                                                                                                                                  |
   +---------------------------+---------------+---------------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.frontends.file.examples:

Exemples
^^^^^^^^

L'utilisation de ce frontend est la même que celle de ``Zend\Cache\Core``. Il n'y a pas besoin d'exemple
spécifique - la seule chose à faire est de définir le **master_file** lors de l'utilisation de la fabrique.

.. _zend.cache.frontends.page:

Zend\Cache_Frontend\Page
------------------------

.. _zend.cache.frontends.page.introduction:

Introduction
^^^^^^^^^^^^

``Zend\Cache_Frontend\Page`` est comme ``Zend\Cache_Frontend\Output`` mais créé pour une page complète. Il est
impossible d'utiliser ``Zend\Cache_Frontend\Page`` pour mettre en cache un bloc unique.

D'un autre côté, le "cache ID", est calculé automatiquement avec ``$_SERVER['REQUEST_URI']`` et (en fonction des
options) ``$_GET``, ``$_POST``, ``$_SESSION``, ``$_COOKIE``, ``$_FILES``. De plus, vous avez seulement une méthode
pour appeler (``start()``) parce que l'appel à ``end()`` est totalement automatique lorsque la page est terminé.

Pour le moment, ceci n'est pas implémenté mais nous prévoyons d'ajouter un système de condition *HTTP* pour
économiser de la bande passante (le système émettra un en-tête "*HTTP* 304 Not Modified" si le cache est
trouvé, et si le navigateur a déjà la bonne version).

.. note::

   Ce frontend opére en enregistrant une fonction de rappel qui doit être appelée quand le buffer de sortie
   qu'il utilise est nettoyé. Dans le but de fonctionner correctement, il doit être le buffer de sortie final de
   la requête. Pour garantir ceci, le buffer de sortie utilisé par le distributeur (Dispatcher) **doit** être
   désactivé en appelant la méthode ``setParam()`` de ``Zend\Controller\Front``, par exemple
   ``$front->setParam('disableOutputBuffering', true);`` ou en ajoutant
   "resources.frontcontroller.params.disableOutputBuffering = true" à votre fichier d'amorçage (présumé de type
   *INI*) si vous utilisez ``Zend_Application``.

.. _zend.cache.frontends.page.options:

Options disponibles
^^^^^^^^^^^^^^^^^^^

.. _zend.cache.frontends.page.options.table:

.. table:: Options du frontend Page

   +----------------+---------------+----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option          |Type de données|Valeur par défaut     |Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
   +================+===============+======================+===================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
   |http_conditional|Boolean        |FALSE                 |utilisez le système "httpConditionnal" ou pas (pas encore implémenté)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
   +----------------+---------------+----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |debug_header    |Boolean        |FALSE                 |si TRUE, un texte de débogage est ajouté avant chaque page de cache                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
   +----------------+---------------+----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |default_options |Array          |array(...see below...)|un tableau associatif d'options par défaut : (boolean, TRUE par défaut) cache : le cache est activé si TRUE(boolean, FALSE par défaut) cache_with_get_variables : si TRUE, le cache est toujours activé même s'il y a des variables dans le tableau $_GET(boolean, FALSE par défaut) cache_with_post_variables : si TRUE, le cache est toujours activé même s'il y a des variables dans le tableau $_POST(boolean, FALSE par défaut) cache_with_session_variables : si TRUE, le cache est toujours activé s'il y a des variables dans le tableau $_SESSION(boolean, FALSE par défaut) cache_with_files_variables : si TRUE, le cache est toujours activé s'il y a des variables dans le tableau $_FILES(boolean, FALSE par défaut) cache_with_cookie_variables : si TRUE, le cache est toujours activé s'il y a des variables dans le tableau $_COOKIE(boolean, TRUE par défaut) make_id_with_get_variables : si TRUE, l'identifiant du cache sera dépendant du contenu du tableau $_GET(boolean, TRUE par défaut) make_id_with_post_variables : si TRUE, l'identifiant du cache sera dépendant du contenu du tableau $_POST(boolean, TRUE par défaut) make_id_with_session_variables : si TRUE, l'identifiant du cache sera dépendant du contenu du tableau $_SESSION(boolean, TRUE par défaut) make_id_with_files_variables : si TRUE, l'identifiant du cache sera dépendant du contenu du tableau $_FILES(boolean, TRUE par défaut) make_id_with_cookie_variables : si TRUE, l'identifiant du cache sera dépendant du contenu du tableau $_COOKIE(int, FALSE par défaut) specific_lifetime : si TRUE, la durée de vie fournie sera utilisée pour l'expression régulière choisie (array, array() par défaut) tags : balises pour l'enregistrement en cache (int, NULL par défaut) priority : priorité (si le backend le supporte)|
   +----------------+---------------+----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |regexps         |Array          |array()               |un tableau associatif pour définir les options, uniquement pour certaines REQUEST_URI, les clés sont des expressions régulières PCRE, les valeurs sont des tableaux associatifs avec des options spécifiques pour définir si les expressions régulières correspondent dans $_SERVER['REQUEST_URI'] (voir les options par défaut pour la liste des options disponibles) ; si plusieurs expressions régulières correspondent à un $_SERVER['REQUEST_URI'], seule la dernière sera utilisée.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
   +----------------+---------------+----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |memorize_headers|Array          |array()               |un tableau de chaînes correspondant aux noms d'en-têtes HTTP. Les en-têtes listés seront stockées avec les données de cache et renvoyées lorsque le cache sera rappelé.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
   +----------------+---------------+----------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.frontends.page.examples:

Exemples
^^^^^^^^

L'utilisation de ``Zend\Cache_Frontend\Page`` est vraiment trivial :

.. code-block:: php
   :linenos:

   // [...] // require, configuration et factory

   $cache->start();
   // si le cache est trouvé, le résultat est envoyé au navigateur
   // et le script s'arrête là

   // reste de la page ...

Un exemple plus complexe qui montre un moyen pour obtenir une gestion centralisée du cache dans un fichier
d'amorçage (pour utiliser avec ``Zend_Controller`` par exemple)

.. code-block:: php
   :linenos:

   // vous devriez éviter de mettre trop de lignes avant la section
   // de cache par exemple, pour des performances optimales,
   // "require_once" ou "Zend\Loader\Loader::loadClass" devrait être
   // après la section de cache

   $frontendOptions = array(
      'lifetime' => 7200,
      'debug_header' => true, // pour le déboguage
      'regexps' => array(
          // met en cache la totalité d'IndexController
          '^/$' => array('cache' => true),

          // met en cache la totalité d'IndexController
          '^/index/' => array('cache' => true),

          // nous ne mettons pas en cache l'ArticleController...
          '^/article/' => array('cache' => false),

          // ...mais nous mettons en cache l'action "view"
          '^/article/view/' => array(
               // de cet ArticleController
              'cache' => true,

              // et nous mettons en cache même lorsqu'il y a
              // des variables dans $_POST
              'cache_with_post_variables' => true,

              // (mais le cache sera dépendent du tableau $_POST)
              'make_id_with_post_variables' => true,
          )
      )
   );
   $backendOptions = array(
       'cache_dir' => '/tmp/'
   );

   // obtenir un objet Zend\Cache_Frontend\Page
   $cache = Zend\Cache\Cache::factory('Page',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   $cache->start();
   // si nous trouvons un cache, le résultat est envoyé au navigateur,
   // et le script s'arrête là

   // [...] la fin du fichier de démarrage
   // (ces lignes ne seront pas exécutées si on trouve un cache)

.. _zend.cache.frontends.page.cancel:

La méthode spécifique cancel()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A cause de problèmes de design, dans certains cas (par exemple quand on utilise des codes de retour *HTTP* autres
que 200), vous pouvez avoir besoin de stopper le processus de mise en cache courant. Il a donc été introduit pour
ce frontend en particulier, la méthode ``cancel()``.

.. code-block:: php
   :linenos:

   // [...] require, configuration et fabrique

   $cache->start();

   // [...]

   if ($unTest) {
       $cache->cancel();
       // [...]
   }

   // [...]

.. _zend.cache.frontends.capture:

Zend\Cache_Frontend\Capture
---------------------------

.. _zend.cache.frontends.capture.introduction:

Introduction
^^^^^^^^^^^^

``Zend\Cache_Frontend\Capture`` is like ``Zend\Cache_Frontend\Output`` but designed for a complete page. It's
impossible to use ``Zend\Cache_Frontend\Capture`` for caching only a single block. This class is specifically
designed to operate in concert only with the ``Zend\Cache_Backend\Static`` backend to assist in caching entire
pages of *HTML*/*XML* or other content to a physical static file on the local filesystem.

Please refer to the documentation on ``Zend\Cache_Backend\Static`` for all use cases pertaining to this class.

.. note::

   This frontend operates by registering a callback function to be called when the output buffering it uses is
   cleaned. In order for this to operate correctly, it must be the final output buffer in the request. To guarantee
   this, the output buffering used by the Dispatcher **must** be disabled by calling ``Zend\Controller\Front``'s
   ``setParam()`` method, for example, ``$front->setParam('disableOutputBuffering', true);`` or adding
   "resources.frontcontroller.params.disableOutputBuffering = true" to your bootstrap configuration file (assumed
   *INI*) if using ``Zend_Application``.


