.. _zend.cache.backends:

Les backends Zend_Cache
=======================

Il existe deux types de backends : les standards et les étendus. Bien sûr, les backends étendus offrent des
fonctionnalités supplémentaires.

.. _zend.cache.backends.file:

Zend_Cache_Backend_File
-----------------------

Ces backends (étendus) stockent les enregistrements de cache dans des fichiers (dans un dossier choisi).

Les options disponibles sont :

.. _zend.cache.backends.file.table:

.. table:: Options du backend File

   +--------------------------+---------------+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                    |Type de données|Valeur par défaut|Description                                                                                                                                                                                                                                                                                                                                                                                                                 |
   +==========================+===============+=================+============================================================================================================================================================================================================================================================================================================================================================================================================================+
   |cache_dir                 |String         |/tmp/            |Répertoire où stocker les fichiers de cache                                                                                                                                                                                                                                                                                                                                                                                 |
   +--------------------------+---------------+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file_locking              |Boolean        |TRUE             |Active / désactive le verrou de fichier : peut éviter la corruption du cache dans de mauvaises circonstances, mais il n'aide en rien sur des serveur multithreadés ou sur des systèmes de fichier NFS...                                                                                                                                                                                                                    |
   +--------------------------+---------------+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |read_control              |Boolean        |TRUE             |Active / désactive le contrôle de lecture : si activé, une clé de contrôle est embarquée dans le fichier de cache et cette clé est comparée avec celle calculée après la lecture.                                                                                                                                                                                                                                           |
   +--------------------------+---------------+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |read_control_type         |String         |'crc32'          |Type de contrôle de lecture (seulement si le contrôle de lecture est activé). Les valeurs disponibles sont : "md5" (meilleur mais plus lent), "crc32" (un peu moins sécurisé, mais plus rapide, c'est un meilleur choix), "adler32" (nouveau choix, plus rapide que crc32),"strlen" pour un test de longueur uniquement (le plus rapide).                                                                                   |
   +--------------------------+---------------+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hashed_directory_level    |Integer        |0                |Niveau de structure du hash du répertoire : 0 signifie "pas de hashage de la structure du répertoire", 1 signifie "un niveau de répertoire", 2 signifie "deux niveaux"... Cette option peut accélérer le cache seulement lorsque vous avez plusieurs centaines de fichiers de cache. Seuls des tests de performance spécifiques peuvent vous aider à choisir la meilleure valeur pour vous. 1 ou 2, peut-être un bon départ.|
   +--------------------------+---------------+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hashed_directory_umask    |Integer        |0700             |Umask pour l'arborescence                                                                                                                                                                                                                                                                                                                                                                                                   |
   +--------------------------+---------------+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file_name_prefix          |String         |'zend_cache'     |Préfixe pour les fichiers mis en cache ; faîtes très attention avec cette option, en cas de valeur trop générique dans le dossier de cache (comme /tmp), ceci peut causer des désastres lors du nettoyage du cache.                                                                                                                                                                                                         |
   +--------------------------+---------------+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_file_umask          |Integer        |0700             |umask des fichiers de cache.                                                                                                                                                                                                                                                                                                                                                                                                |
   +--------------------------+---------------+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |metatadatas_array_max_size|Integer        |100              |Taille maximale interne pour les tableaux de métadonnées (ne changez pas cette valeur à moins de bien savoir ce que vous faîtes).                                                                                                                                                                                                                                                                                           |
   +--------------------------+---------------+-----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.sqlite:

Zend_Cache_Backend_Sqlite
-------------------------

Ce backend (étendu) stocke les enregistrements de cache dans une base de donnée SQLite.

Les options disponibles sont :

.. _zend.cache.backends.sqlite.table:

.. table:: Options du backend Sqlite

   +------------------------------------+---------------+-----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                              |Type de données|Valeur par défaut|Description                                                                                                                                                                                                                                                                                                                                                                   |
   +====================================+===============+=================+==============================================================================================================================================================================================================================================================================================================================================================================+
   |cache_db_complete_path (obligatoire)|String         |NULL             |Le chemin complet (nom du fichier inclus) de la base de donnée SQLite                                                                                                                                                                                                                                                                                                         |
   +------------------------------------+---------------+-----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automatic_vacuum_factor             |Integer        |10               |Désactive / Active le processus de vidange automatique. Celui-ci défragmente le fichier de base de données (et diminue sa taille) quand clean() ou delete() est appelé : 0 pour une vidange automatique ; 1 pour une vidange systématique (quand clean() ou delete() est appelé) ; x (entier) > 1 pour une vidange automatique aléatoirement 1 fois sur x clean() ou delete().|
   +------------------------------------+---------------+-----------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.memcached:

Zend_Cache_Backend_Memcached
----------------------------

Ce backend (étendu) stocke les enregistrements de cache dans un serveur memcached. `Memcached`_ est un système de
cache en mémoire distribuée, de haute performance. Pour utiliser ce backend, vous devez avoir un démon memcached
et l'extension `PECL memcache`_.

Attention : avec ce backend, les balises ("tags") ne sont pas supportées pour le moment comme l'argument
"doNotTestCacheValidity=true".

Les options disponibles sont :

.. _zend.cache.backends.memcached.table:

.. table:: Options du backend Memcached

   +-------------+---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option       |Type de données|Valeur par défaut                                                                                                                                                             |Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
   +=============+===============+==============================================================================================================================================================================+============================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
   |servers      |Array          |array(array('host' => 'localhost', 'port' => 11211, 'persistent' => true, 'weight' => 1, 'timeout' => 5, 'retry_interval' => 15, 'status' => true, 'failure_callback' => '' ))|Un tableau de serveurs memcached ; chaque serveur memcached est décrit par un tableau associatif : 'host' => (string) : le nom du serveur memcached, 'port' => (int) : le port du serveur memcached, 'persistent' => (bool) : utilisation ou pas des connexions persistantes pour ce serveur memcached, 'weight' => (int) : le poids du serveur memcached, 'timeout' => (int) : le time out du serveur memcached, 'retry_interval' => (int) : l'intervalle avant réexécution du serveur memcached, 'status' => (bool) : le statut du serveur memcached, 'failure_callback' => (callback) : le failure_callback d'échec du serveur memcached.|
   +-------------+---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |compression  |Boolean        |FALSE                                                                                                                                                                         |TRUE, si vous voulez utiliser la compression à la volée                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
   +-------------+---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |compatibility|Boolean        |FALSE                                                                                                                                                                         |TRUE, si vous voulez utiliser le mode de compatibilité avec les anciens serveurs / extensions memcache                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
   +-------------+---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.apc:

Zend_Cache_Backend_Apc
----------------------

Ce backend (étendu) stocke les enregistrements de cache en mémoire partagée grâce à l'extension `APC`_
(Alternative *PHP* Cache) qui est requise pour utiliser ce backend.

Attention: avec ce backend, les balises ("tags") ne sont pas supportées pour le moment comme l'argument
"doNotTestCacheValidity=true".

Il n'y a pas d'options pour ce backend.

.. _zend.cache.backends.xcache:

Zend_Cache_Backend_Xcache
-------------------------

Ce backend stocke ces enregistrements de cache dans la mémoire partagée à travers l'extension `XCache`_\ (qui
est bien sûr nécessaire pour utiliser ce backend).

Attention : avec ce backend, les balises ("tags") ne sont pas supportées pour le moment comme l'argument
"doNotTestCacheValidity=true".

Les options disponibles sont :

.. _zend.cache.backends.xcache.table:

.. table:: Options du backend Xcache

   +--------+---------------+-----------------+-------------------------------------------------------------------------------+
   |Option  |Type de données|Valeur par défaut|Description                                                                    |
   +========+===============+=================+===============================================================================+
   |user    |String         |NULL             |xcache.admin.user, nécessaire pour la méthode clean().                         |
   +--------+---------------+-----------------+-------------------------------------------------------------------------------+
   |password|String         |NULL             |xcache.admin.pass (en texte clair non MD5), nécessaire pour la méthode clean().|
   +--------+---------------+-----------------+-------------------------------------------------------------------------------+

.. _zend.cache.backends.platform:

Zend_Cache_Backend_ZendPlatform
-------------------------------

Ce backend utilise l'*API* de cache de contenu de la `Zend Platform`_. Naturellement, pour utiliser ce backend,
vous devez avoir installé une Zend Platorm.

Ce backend supporte les balises ("tags") mais ne supporte pas le mode de nettoyage
``CLEANING_MODE_NOT_MATCHING_TAG``.

Spécifiez ce backend en utilisant un séparateur de mot - "-", ".", " " ou "\_" - entre les mots "Zend" et
"Platform" quand vous utilisez la méthode ``Zend_Cache::factory()``\  :

.. code-block:: php
   :linenos:

   $cache = Zend_Cache::factory('Core', 'Zend Platform');

Il n'y a pas d'options pour ce backend.

.. _zend.cache.backends.twolevels:

Zend_Cache_Backend_TwoLevels
----------------------------

Ce backend (étendu) est un hybride. Il stocke les enregistrements de cache dans deux autres backends : un rapide
(mais limité) comme Apc, Memcache... et un plus "lent" comme File, Sqlite...

Ce backend utilise le paramètre priorité (fourni au niveau du frontend au moment d'un enregistrement) et l'espace
restant dans le backend rapide pour optimiser l'utilisation de ces deux backends.

Spécifiez ce backend avec un séparateur de mots - "-", ".", " ", ou "\_" - entre les mots "Two" et "Levels" quand
vous utilisez la méthode ``Zend_Cache::factory()``\  :

.. code-block:: php
   :linenos:

   $cache = Zend_Cache::factory('Core', 'Two Levels');

Les options disponibles sont :

.. _zend.cache.backends.twolevels.table:

.. table:: Options du backend TwoLevels

   +--------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option                    |Type de données|Valeur par défaut|Description                                                                                                                                                                                                                      |
   +==========================+===============+=================+=================================================================================================================================================================================================================================+
   |slow_backend              |String         |File             |le nom du backend "lent"                                                                                                                                                                                                         |
   +--------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend              |String         |Apc              |le nom du backend "rapide"                                                                                                                                                                                                       |
   +--------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |slow_backend_options      |Array          |array()          |les options du backend "lent"                                                                                                                                                                                                    |
   +--------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend_options      |Array          |array()          |les options du backend "rapide"                                                                                                                                                                                                  |
   +--------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |slow_backend_custom_naming|Boolean        |FALSE            |si TRUE, l'argument "slow_backend" est utilisé en tant que nom complet de classe ; si FALSE, l'argument frontend est utilisé concaténé à "Zend_Cache_Backend_<...>"                                                              |
   +--------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend_custom_naming|Boolean        |FALSE            |si TRUE, l'argument "fast_backend" est utilisé en tant que nom complet de classe ; si FALSE, l'argument frontend est utilisé concaténé à "Zend_Cache_Backend_<...>"                                                              |
   +--------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |slow_backend_autoload     |Boolean        |FALSE            |si TRUE, il n'y aura pas de require_once pour le "slow_backend" (utile seulement pour les backends personnalisés)                                                                                                                |
   +--------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend_autoload     |Boolean        |FALSE            |si TRUE, il n'y aura pas de require_once pour le "fast_backend" (utile seulement pour les backends personnalisés)                                                                                                                |
   +--------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |auto_refresh_fast_cache   |Boolean        |TRUE             |si TRUE, rafraîchissement automatique du cache rapide quand un enregistrement est appelé                                                                                                                                         |
   +--------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |stats_update_factor       |Integer        |10               |désactive / personnalise le calcul du pourcentage de remplissage du backend rapide (lors d'une sauvegarde d'un enregistrement dans le cache, le calcul du remplissage est effectué aléatoirement 1 fois sur x écritures de cache)|
   +--------------------------+---------------+-----------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.zendserver:

Zend_Cache_Backend_ZendServer_Disk et Zend_Cache_Backend_ZendServer_ShMem
-------------------------------------------------------------------------

Ces backends utilisent les fonctionnalités de mise en cache de `Zend Server`_\ pour stocker les données.

Attention : avec ces backends ne supportent pas les balises ("tags") pour le moment de même que l'argument
"doNotTestCacheValidity=true".

Ces backends fonctionnent seulement dans l'environnement de Zend Server pour les pages requêtées à travers
*HTTP* ou *HTTPS* et ne fonctionnent pas pour les scripts exécutés en ligne de commande.

Spécifiez ce backend en utilisant le paramètre **customBackendNaming** à ``TRUE`` quand vous utilisez la
méthode ``Zend_Cache::factory()``\  :

.. code-block:: php
   :linenos:

   $cache = Zend_Cache::factory('Core', 'Zend_Cache_Backend_ZendServer_Disk',
                                $frontendOptions, $backendOptions, false, true);

Il n'y a pas d'options pour ce backend.

.. _zend.cache.backends.static:

Zend_Cache_Backend_Static
-------------------------

This backend works in concert with ``Zend_Cache_Frontend_Capture`` (the two must be used together) to save the
output from requests as static files. This means the static files are served directly on subsequent requests
without any involvement of *PHP* or Zend Framework at all.

.. note::

   ``Zend_Cache_Frontend_Capture`` operates by registering a callback function to be called when the output
   buffering it uses is cleaned. In order for this to operate correctly, it must be the final output buffer in the
   request. To guarantee this, the output buffering used by the Dispatcher **must** be disabled by calling
   ``Zend_Controller_Front``'s ``setParam()`` method, for example, ``$front->setParam('disableOutputBuffering',
   true);`` or adding "resources.frontcontroller.params.disableOutputBuffering = true" to your bootstrap
   configuration file (assumed *INI*) if using ``Zend_Application``.

The benefits of this cache include a large throughput increase since all subsequent requests return the static file
and don't need any dynamic processing. Of course this also has some disadvantages. The only way to retry the
dynamic request is to purge the cached file from elsewhere in the application (or via a cronjob if timed). It is
also restricted to single-server applications where only one filesystem is used. Nevertheless, it can be a powerful
means of getting more performance without incurring the cost of a proxy on single machines.

Before describing its options, you should note this needs some changes to the default ``.htaccess`` file in order
for requests to be directed to the static files if they exist. Here's an example of a simple application caching
some content, including two specific feeds which need additional treatment to serve a correct Content-Type header:

.. code-block:: text
   :linenos:

   AddType application/rss+xml .xml
   AddType application/atom+xml .xml

   RewriteEngine On

   RewriteCond %{REQUEST_URI} feed/rss$
   RewriteCond %{DOCUMENT_ROOT}/cached/%{REQUEST_URI}.xml -f
   RewriteRule .* cached/%{REQUEST_URI}.xml [L,T=application/rss+xml]

   RewriteCond %{REQUEST_URI} feed/atom$
   RewriteCond %{DOCUMENT_ROOT}/cached/%{REQUEST_URI}.xml -f
   RewriteRule .* cached/%{REQUEST_URI}.xml [L,T=application/atom+xml]

   RewriteCond %{DOCUMENT_ROOT}/cached/index.html -f
   RewriteRule ^/*$ cached/index.html [L]
   RewriteCond %{DOCUMENT_ROOT}/cached/%{REQUEST_URI}.(html|xml|json|opml|svg) -f
   RewriteRule .* cached/%{REQUEST_URI}.%1 [L]

   RewriteCond %{REQUEST_FILENAME} -s [OR]
   RewriteCond %{REQUEST_FILENAME} -l [OR]
   RewriteCond %{REQUEST_FILENAME} -d
   RewriteRule ^.*$ - [NC,L]

   RewriteRule ^.*$ index.php [NC,L]

The above assumes static files are cached to the directory ``./public/cached``. We'll cover the option setting this
location, "public_dir", below.

Due to the nature of static file caching, the backend class offers two additional methods: ``remove()`` and
``removeRecursively()``. Both accept a request *URI*, which when mapped to the "public_dir" where static files are
cached, and has a pre-stored extension appended, provides the name of either a static file to delete, or a
directory path to delete recursively. Due to the restraints of ``Zend_Cache_Backend_Interface``, all other methods
such as ``save()`` accept an ID which is calculated by applying ``bin2hex()`` to a request *URI*.

Given the level at which static caching operates, static file caching is addressed for simpler use with the
``Zend_Controller_Action_Helper_Cache`` action helper. This helper assists in setting which actions of a controller
to cache, with what tags, and with which extension. It also offers methods for purging the cache by request *URI*
or tag. Static file caching is also assisted by ``Zend_Cache_Manager`` which includes pre-configured configuration
templates for a static cache (as ``Zend_Cache_Manager::PAGECACHE`` or "page"). The defaults therein can be
configured as needed to set up a "public_dir" location for caching, etc.

.. note::

   It should be noted that the static cache actually uses a secondary cache to store tags (obviously we can't store
   them elsewhere since a static cache does not invoke *PHP* if working correctly). This is just a standard Core
   cache, and should use a persistent backend such as File or TwoLevels (to take advantage of memory storage
   without sacrificing permanent persistance). The backend includes the option "tag_cache" to set this up (it is
   obligatory), or the ``setInnerCache()`` method.

.. _zend.cache.backends.static.table:

.. table:: Static Backend Options

   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option               |Data Type|Default Value|Description                                                                                                                                                                                                                                                                                             |
   +=====================+=========+=============+========================================================================================================================================================================================================================================================================================================+
   |public_dir           |String   |NULL         |Directory where to store static files. This must exist in your public directory.                                                                                                                                                                                                                        |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file_locking         |Boolean  |TRUE         |Enable or disable file_locking : Can avoid cache corruption under bad circumstances but it doesn't help on multithread webservers or on NFS filesystems...                                                                                                                                              |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |read_control         |Boolean  |TRUE         |Enable / disable read control : if enabled, a control key is embedded in the cache file and this key is compared with the one calculated after the reading.                                                                                                                                             |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |read_control_type    |String   |'crc32'      |Type of read control (only if read control is enabled). Available values are : 'md5' (best but slowest), 'crc32' (lightly less safe but faster, better choice), 'adler32' (new choice, faster than crc32), 'strlen' for a length only test (fastest).                                                   |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_file_umask     |Integer  |0700         |umask for cached files.                                                                                                                                                                                                                                                                                 |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_directory_umask|Integer  |0700         |Umask for directories created within public_dir.                                                                                                                                                                                                                                                        |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file_extension       |String   |'.html'      |Default file extension for static files created. This can be configured on the fly, see Zend_Cache_Backend_Static::save() though generally it's recommended to rely on Zend_Controller_Action_Helper_Cache when doing so since it's simpler that way than messing with arrays or serialization manually.|
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |index_filename       |String   |'index'      |If a request URI does not contain sufficient information to construct a static file (usually this means an index call, e.g. URI of '/'), the index_filename is used instead. So '' or '/' would map to 'index.html' (assuming the default file_extension is '.html').                                   |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |tag_cache            |Object   |NULL         |Used to set an 'inner' cache utilised to store tags and file extensions associated with static files. This must be set or the static cache cannot be tracked and managed.                                                                                                                               |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |disable_caching      |Boolean  |FALSE        |If set to TRUE, static files will not be cached. This will force all requests to be dynamic even if marked to be cached in Controllers. Useful for debugging.                                                                                                                                           |
   +---------------------+---------+-------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _`Memcached`: http://www.danga.com/memcached/
.. _`PECL memcache`: http://pecl.php.net/package/memcache
.. _`APC`: http://pecl.php.net/package/APC
.. _`XCache`: http://xcache.lighttpd.net/
.. _`Zend Platform`: http://www.zend.com/fr/products/platform
.. _`Zend Server`: http://www.zend.com/en/products/server/downloads-all?zfs=zf_download
