.. EN-Revision: none
.. _zend.cache.cache.manager:

Le gestionnaire de Cache
========================

Une application comporte par nature plusieurs caches de types différents fonctions du contrôleur ou du modèle
accédé. Afin de faciliter la création et la manipulation des options de ``Zend_Cache`` au plus tôt (par exemple
en bootstrap), ``Zend\Cache\Manager`` a été créée. Cette classe est accompagnée de
``Zend\Application_Resource\Cachemanager`` pour tout ce qui concerne le bootstrap et
``Zend\Controller\Action\Helper\Cache`` afin d'accéder aux caches depuis les contrôleurs et autres aides
d'action.

Le gestionnaire de cache utilise des templates, ce sont en fait des ensembles de configurations valides pour un
cache. Ces templates s'enregistrent grâce à ``Zend\Cache\Manager::setCacheTemplate()`` et ne donnent naissance à
un objet de cache que lorsque ``Zend\Cache\Manager::getCache()`` sera appelée.

.. code-block:: php
   :linenos:

   $manager = new Zend\Cache\Manager;

   $dbCache = array(
       'frontend' => array(
           'name' => 'Core',
           'options' => array(
               'lifetime' => 7200,
               'automatic_serialization' => true
           )
       ),
       'backend' => array(
           'name' => 'Core',
           'options' => array(
               'cache_dir' => '/path/to/cache'
           )
       )
   );

   $manager->setCacheTemplate('database', $dbCache);

   /**
    * Partout ailleurs où le gestionnaire de cache est accessible...
    */
   $databaseCache = $manager->getCache('database');

Le gestionnaire autorise aussi l'enregistrement d'objets de cache préalablement créés, ceci grâce à la
méthode ``Zend\Cache\Manager::setCache()``.

.. code-block:: php
   :linenos:

   $frontendOptions = array(
      'lifetime' => 7200,
      'automatic_serialization' => true
   );

   $backendOptions = array(
       'cache_dir' => '/path/to/cache'
   );

   $dbCache = Zend\Cache\Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   $manager = new Zend\Cache\Manager;
   $manager->setCache('database', $dbCache);

   /**
    * Partout ailleurs où le gestionnaire de cache est accessible...
    */
   $databaseCache = $manager->getCache('database');

Si vous n'êtes pas sûr si le gestionnaire possède en lui un template de configuration ou un objet de cache déja
enregistré, vérifiez celà grâce à ``Zend\Cache\Manager::hasCache()``.

.. code-block:: php
   :linenos:

   $manager = new Zend\Cache\Manager;

   $dbCache = array(
       'frontend' => array(
           'name' => 'Core',
           'options' => array(
               'lifetime' => 7200,
               'automatic_serialization' => true
           )
       ),
       'backend' => array(
           'name' => 'Core',
           'options' => array(
               'cache_dir' => '/path/to/cache'
           )
       )
   );

   $manager->setCacheTemplate('database', $dbCache);

   /**
    * Partout ailleurs où le gestionnaire de cache est accessible...
    */
   if ($manager->hasCache('database')) {
       $databaseCache = $manager->getCache('database');
   } else {
       // Créer un cache à la main puisque non trouvé dans le gestionnaire
   }

Dans certains cas, vous pouvez avoir défini un certain de cas d'utilisation avec ``Zend\Cache\Manager``, mais vous
avez besoin de préciser un option dans un cas particulier. Il est alors possible de modifier la configuration d'un
template de cache après l'avoir saisie, ceci au moyen de ``Zend\Cache\Manager::setTemplateOptions()``.

.. code-block:: php
   :linenos:

   $manager = new Zend\Cache\Manager;

   $dbCache = array(
       'frontend' => array(
           'name' => 'Core',
           'options' => array(
               'lifetime' => 7200,
               'automatic_serialization' => true
           )
       ),
       'backend' => array(
           'name' => 'Core',
           'options' => array(
               'cache_dir' => '/path/to/cache'
           )
       )
   );

   $manager->setCacheTemplate('database', $dbCache);

   /**
    * Partout ailleurs où le gestionnaire de cache est accessible...
    * Ici nous changeons le support de stockage vers Memcache plutôt que ce
    * qu'il était avant : File.
    */
   $fineTuning = array(
       'backend' => array(
           'name' => 'Memcached',
           'options' => array(
               'servers' => array(
                   array(
                       'host' => 'localhost',
                       'port' => 11211,
                       'persistent' => true,
                       'weight' => 1,
                       'timeout' => 5,
                       'retry_interval' => 15,
                       'status' => true,
                       'failure_callback' => ''
                   )
               )
           )
       )
   );
   $manager->setTemplateOptions('database', $fineTuning);
   $databaseCache = $manager->getCache('database');

Pour rendre le gestionnaire de cache plus utile, il est accompagné de ``Zend\Application_Resource\Cachemanager``
et ``Zend\Controller\Action\Helper\Cache``. Toutes deux sont décrites dans leurs pages respectives de la
documentation.

Aussi, ``Zend\Cache\Manager`` inclut déja quatre templates prédéfinis "skeleton", "default", "page" et
"tagcache". Le cache "default" utilise des fichiers comme stockage et un Core comme frontend, il s'attend à
posséder un dossier cache_dir appelé "cache" au même niveau que le dossier normalisé "public" dans une
application Zend Framework. Le cache "skeleton" est un cache ``NULL``, il ne comporte pas d'options. Les 2 autres
caches sont utilisés avec des pages statiques dans lesquelles du *HTML*, *XML* ou encore *JSON* peut être stocké
dans des fichiers statiques dans ``/public``. Le contrôle sur les pages statiques est assuré par
``Zend\Controller\Action\Helper\Cache``, même si vous pouvez changer les options "page", "tagcache" (par exemple)
en utilisant ``Zend\Cache\Manager::setTemplateOptions()`` ou même ``Zend\Cache\Manager::setCacheTemplate()``.


