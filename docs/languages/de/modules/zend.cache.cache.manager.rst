.. EN-Revision: none
.. _zend.cache.cache.manager:

Der Cache Manager
=================

Es ist die Natur von Anwendungen eine Vielzahl an Caches jedes Types zu benötigen oft abhängig vom Controller,
der Bibliothek oder dem Domainmodell auf das zugegriffen wird. Um die einfache Definition von ``Zend_Cache``
Optionen zu erlauben (wie von der Bootstrap), damit auf ein Cacheobjekt zugegriffen werden kann und nur ein
minimales Setup im Sourcecode der Anwendung benötigt wird, wurde die Klasse ``Zend\Cache\Manager`` geschrieben.
Diese Klasse wird von ``Zend\Application\Resource\Cachemanager`` verwendet um sicherzustellen das die Konfiguration
der Bootstrap vorhanden ist, und ``Zend\Controller\Action\Helper\Cache`` um einen einfachen Zugriff und eine
einfache Instanzierung von Controllern und anderen Helfern zu erlauben.

Die grundsätzliche Operation dieser Komponente ist wie folgt. Der Cache Manager erlaubt es Benutzern "Option
Templates" zu konfigurieren, grundsätzlich Optionen für ein Set von benannten Caches. Diese können gesetzt
werden indem die Methode ``Zend\Cache\Manager::setCacheTemplate()`` verwendet wird. Diese Templates führen einen
Cache nicht aus solange der Benutzer nicht versucht einen benannten Cache zu empfangen (assoziiert mit einem
existierenden Optionstemplate) indem die Methode ``Zend\Cache\Manager::getCache()`` verwendet wird.

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
    * Überall anders wo der Cache Manager vorhanden ist...
    */
   $databaseCache = $manager->getCache('database');

Der Cache Manager erlaubt das einfache Erstellen von vor-instanzierten Caches durch Verwenden der Methode
``Zend\Cache\Manager::setCache()``.

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
    * Überall anders wo der Cache Manager vorhanden ist...
    */
   $databaseCache = $manager->getCache('database');

Wenn man aus irgendeinem Grund unsicher ist ob der Cache Manager einen vor-instanzierten Cache enthält oder ein
relevantes Option Cache Template um einen auf Anfrage zu erstellen, kann die Existenz einer benannten
Cachekonfiguration oder Instanz geprüft werden indem die Methode ``Zend\Cache\Manager::hasCache()`` verwendet
wird.

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
    * Überall anders wo der Cache Manager vorhanden ist...
    */
   if ($manager->hasCache('database')) {
       $databaseCache = $manager->getCache('database');
   } else {
       // Erstelle einen Cache wenn keiner from Manager vorhanden ist
   }

In einigen Szenarios könnte man eine Anzahl von generell zu verwendenden Caches definiert haben indem
``Zend\Cache\Manager`` verwendet wird, aber deren Optionen feintunen bevor Sie anhängig von Ihren Notwendigkeiten
verwendet werden. Man kann vorher gesetzte Cache Templates on the fly bearbeiten bevor Sie instanziert werden indem
die Methode ``Zend\Cache\Manager::setTemplateOptions()`` verwendet wird.

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
    * Überall anders wo der Cache Manager vorhanden ist...
    * Hier haben wir entschieden einige kommende Datenbankabfragen zu Memcache zu
    * Speichern statt dem vorkonfigurierten File Backend
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

Um zu helfen den Cache Manager sinnvoller zu machen wird ``Zend\Application\Resource\Cachemanager`` und auch der
Action Helfer ``Zend\Controller\Action\Helper\Cache`` angeboten. Beide sind in den betreffenden Abschnitten des
Referenz Handbuchs beschrieben.

``Zend\Cache\Manager`` enthält bereits vier vordefinierte Cache Templates welche "skeleton", "default", "page" und
"tagcache" heißen. Der Standardcache ist ein einfacher Dateibasierter Cache welcher das Core Frontend verwendet
und annimmt das ein cache_dir auf dem gleichen Level wie das konventionelle "public" Verzeichnis einer Zend
Framework Anwendung existiert und "cache" heißt. Der Skeleton Cache ist aktuell ein ``NULL`` Cache, er enthält
also keine Optionen. Die verbleibenden zwei Caches werden verwendet um einen standardmäßigen statischen
Seitencache zu implementieren wobei statisches *HTML*, *XML* oder sogar *JSON* in statische Dateien unter
``/public`` geschrieben sein können. Die Kontrolle über einen statischen Seitencache wird über
``Zend\Controller\Action\Helper\Cache`` angeboten, und man kann die Einstellungen dieser "page" verändern und den
"tagcache" den Sie verwendet um Tags zu verfolgen indem ``Zend\Cache\Manager::setTemplateOptions()`` verwendet
wird, oder sogar ``Zend\Cache\Manager::setCacheTemplate()`` wenn alle deren Optionen überladen werden.


