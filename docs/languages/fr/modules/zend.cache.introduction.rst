.. _zend.cache.introduction:

Introduction
============

``Zend_Cache`` fournit un moyen générique de mettre en cache des données.

Le cache dans Zend Framework est réalisé via les frontends alors que les caches d'enregistrements sont stockés
grâce à des adaptateurs de backend (**File**, **Sqlite**, **Memcache**...) grâce à un système souple d'ID et
de balises. En les utilisant, il est simple de supprimer des types spécifiques d'enregistrements par la suite (par
exemple: "supprime tous les enregistrements de cache marqués avec une balise donnée").

Le coeur du module (``Zend_Cache_Core``) est générique, souple et configurable. Pour le moment, pour vos besoins
spécifiques, il y a des frontends qui étendent ``Zend_Cache_Core`` simplement : **Output**, **File**,
**Function** et **Class**.

.. _zend.cache.introduction.example-1:

.. rubric:: Créer un frontend avec Zend_Cache::factory()

``Zend_Cache::factory()`` instancie les objets corrects et les lie ensemble. Dans le premier exemple, nous allons
utiliser le frontend **Core** avec le backend **File**.

.. code-block:: php
   :linenos:

   $frontendOptions = array(
      'lifetime' => 7200, // temps de vie du cache de 2 heures
      'automatic_serialization' => true
   );

   $backendOptions = array(
       // Répertoire où stocker les fichiers de cache
       'cache_dir' => './tmp/'
   );

   // créer un objet Zend_Cache_Core
   $cache = Zend_Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

.. note::

   **Frontends et Backends constitués de plusieurs mots**

   Certains frontends et backends sont nommés en utilisant plusieurs mots, comme "ZendPlatform". En les
   spécifiant à la fabrique, séparez les en utilisant un séparateur de mot, comme l'espace (" "), le tiret
   ("-") ou le point (".").

.. _zend.cache.introduction.example-2:

.. rubric:: Mettre en cache un résultat de requête sur une base de données

Maintenant que nous avons un frontend, nous pouvons mettre en cache tout type de données (nous avons activé la
sérialisation). Par exemple nous pouvons mettre en cache le résultat d'une requête de base de données
coûteuse. Après qu'il soit mis en cache, il n'y a plus besoin de se connecter à la base de données. Les
enregistrements récupérés depuis le cache sont désérialisés.

.. code-block:: php
   :linenos:

   // $cache initialisé dans l'exemple précédent

   // on regarde si un cache existe déjà
   if(!$result = $cache->load('myresult')) {

       // le cache est manquant, connexion à la base de données
       $db = Zend_Db::factory( [...] );

       $result = $db->fetchAll('SELECT * FROM grosse_table');

       $cache->save($result, 'myresult');

   } else {

       // il y a un cache
       echo "Ceci est issu du cache !\n\n";

   }

   print_r($result);

.. _zend.cache.introduction.example-3:

.. rubric:: Cache de sortie avec le frontend de sortie Zend_Cache

Nous marquons les sections dans lesquelles nous voulons un cache de sortie en ajoutant de la logique
conditionnelle, en encapsulant la section entre les méthodes ``start()`` et ``end()`` (cela ressemble au premier
exemple et est le coeur de la stratégie de mise en cache).

A l'intérieur, affichez vos données comme d'habitude toutes les sorties seront misent en cache quand la méthode
``end()`` est appelée. A la prochaine exécution, la section complète sera évitée, au profit de la
récupération de son cache (si le cache est encore valide).

.. code-block:: php
   :linenos:

   $frontendOptions = array(
       // temps de vue du cache de 30 secondes
       'lifetime' => 30,
       // par défaut
       'automatic_serialization' => false
   );

   $backendOptions = array('cache_dir' => './tmp/');

   $cache = Zend_Cache::factory('Output',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   // nous passons un identifiant unique de la méthode start()
   if(!$cache->start('mypage')) {
       // affichage

       echo 'Hello world! ';
       echo 'Ceci est issu du cache('.time().') ';

       // la sortie est sauvegardée est envoyé au navigateur
       $cache->end();
   }

   echo "Ceci n' jamais mis en cache (" . time() . ").";

Notez que nous affichons le résultat de ``time()`` deux fois ; c'est dans un but de démonstration. Essayez de
lancer la page et de la rafraîchir plusieurs fois ; vous allez constater que le premier nombre ne change pas
alors que le second change à chaque actualisation. C'est parce que le premier nombre a été mis en cache et
sauvegardé. Après 30 secondes ("lifeTime" a été mis à 30 secondes), le premier nombre devrait de nouveau
correspondre au second nombre parce que le cache a expiré -- seulement pour être mis en cache de nouveau. Vous
devriez essayer ce code dans votre navigateur ou dans une console.

.. note::

   Lorsque vous utilisez ``Zend_Cache``, faîtes attention à l'identifiant du cache (passé à ``save()`` et
   ``start()``). Il doit être unique pour chaque ressource que vous mettez en cache, sinon il est possible que des
   caches en efface d'autres, ou encore pire, s'affiche en lieu et place d'autres.


