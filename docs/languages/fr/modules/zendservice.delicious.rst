.. EN-Revision: none
.. _zendservice.delicious:

ZendService\Delicious\Delicious
======================

.. _zendservice.delicious.introduction:

Introduction
------------

``ZendService\Delicious\Delicious`` est une *API* pour accéder aux Web services *XML* et *JSON* de `del.icio.us`_. Ce
composant vous donne, si vous avez les droits, un accès en lecture-écriture à vos entrées sur del.icio.us. Il
permet également un accès en lecture seule aux données de tous les utilisateurs.

.. _zendservice.delicious.introduction.getAllPosts:

.. rubric:: Récupérer toutes vos entrées

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('identifiant', 'mot_de_passe');
   $posts = $delicious->getAllPosts();

   foreach ($posts as $post) {
       echo "--\n";
       echo "Titre: {$post->getTitle()}\n";
       echo "Url: {$post->getUrl()}\n";
   }

.. _zendservice.delicious.retrieving_posts:

Récupérer vos entrées
---------------------

``ZendService\Delicious\Delicious`` fournis trois méthodes pour récupérer vos entrées : ``getPosts()``,
``getRecentPosts()`` et ``getAllPosts()``. Elles retournent toutes une instance de la classe
``ZendService\Delicious\PostList``, qui contient toutes les entrées récupérées.

.. code-block:: php
   :linenos:

   /**
    * Récupère les entrées correspondants aux arguments. Si la date ou
    * l'url n'est pas précisée, la date la plus récente
    * sera prise en compte.
    *
    * @param string $tag Optionnel pour filtrer par tag
    * @param Zend_Date $dt Optionnel pour filtrer par date
    * @param string $url Optionnel pour filtrer par url
    * @return ZendService\Delicious\PostList
    */
   public function getPosts($tag = null, $dt = null, $url = null);

   /**
    * Récupère les dernières entrées
    *
    * @param string $tag Optionnel pour filtrer par tag
    * @param string $count Nombre maximum d'entrées à récupérer
    *                     (15 par défaut)
    * @return ZendService\Delicious\PostList
    */
   public function getRecentPosts($tag = null, $count = 15);

   /**
    * Récupère toutes les entrées
    *
    * @param string $tag Optionnel pour filtrer par tag
    * @return ZendService\Delicious\PostList
    */
   public function getAllPosts($tag = null);

.. _zendservice.delicious.postlist:

ZendService\Delicious\PostList
-------------------------------

Des instances de cette classe sont retournées par les méthodes ``getPosts()``, ``getAllPosts()``,
``getRecentPosts()``, et ``getUserPosts()`` de ``ZendService\Delicious\Delicious``.

Pour faciliter l'accès au données cette classe implémente les interfaces *Countable*, *Iterator*, et
*ArrayAccess*.

.. _zendservice.delicious.postlist.accessing_post_lists:

.. rubric:: Accéder à la liste des entrées

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('nom_d_utilisateur',
                                           'mot_de_passe');
   $posts = $delicious->getAllPosts();

   // Affiche le nombre d'entrées
   echo count($posts);

   // Itération sur les entrées
   foreach ($posts as $post) {
       echo "--\n";
       echo "Titre: {$post->getTitle()}\n";
       echo "Url: {$post->getUrl()}\n";
   }

   // Affiche une entrée en utilisant un tableau
   echo $posts[0]->getTitle();

.. note::

   Dans cette implémentation les méthodes ``ArrayAccess::offsetSet()`` et ``ArrayAccess::offsetUnset()`` lèvent
   des exceptions. Ainsi, du code tel que *unset($posts[0]);* ou *$posts[0] = 'A';* lèvera une exception car ces
   propriétés sont en lecture seule.

Les objets d'entrées ont deux capacités de filtrage incorporées. Les entrées peuvent être filtrées par
étiquette et *URL*.

.. _zendservice.delicious.postlist.example.withTags:

.. rubric:: Filtrage d'une entrée par une étiquette spécifique

Les entrées peuvent être filtrées par une (des) étiquette(s) spécifique(s) en utilisant ``withTags()``. Par
confort, ``withTag()`` est aussi fourni quand il est nécessaire 'e ne spécifier qu'une seule étiquette

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('nom_d_utilisateur',
                                           'mot_de_passe');
   $posts = $delicious->getAllPosts();

   // Affiche les entrées ayant les étiquettes "php" et "zend"
   foreach ($posts->withTags(array('php', 'zend')) as $post) {
       echo "Title: {$post->getTitle()}\n";
       echo "Url: {$post->getUrl()}\n";
   }

.. _zendservice.delicious.postlist.example.byUrl:

.. rubric:: Filtrage d'une entrée par URL

Les entrées peuvent être filtrées par *URL* correspondant à une expression régulière spécifiée en utilisant
la méthode ``withUrl()``:

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('nom_d_utilisateur',
                                           'mot_de_passe');
   $posts = $delicious->getAllPosts();

   // Affiche les entrées ayant "help" dans l'URL
   foreach ($posts->withUrl('/help/') as $post) {
       echo "Title: {$post->getTitle()}\n";
       echo "Url: {$post->getUrl()}\n";
   }

.. _zendservice.delicious.editing_posts:

Édition des entrées
-------------------

.. _zendservice.delicious.editing_posts.post_editing:

.. rubric:: Édition d'une entrée

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('nom_d_utilisateur',
                                           'mot_de_passe');
   $posts = $delicious->getPosts();

   // change le titre
   $posts[0]->setTitle('Nouveau Titre');
   // sauvegarde le changement
   $posts[0]->save();

.. _zendservice.delicious.editing_posts.method_call_chaining:

.. rubric:: Enchaînement des appels de méthode

Toutes les méthodes "setter" renvoient l'objet ``ZendService\Delicious\PostList`` vous pouvez donc chaîner les
appels aux méthodes en utilisant une interface fluide.

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('nom_d_utilisateur',
                                           'mot_de_passe');
   $posts = $delicious->getPosts();

   $posts[0]->setTitle('Nouveau Titre')
            ->setNotes('Nouvelle note')
            ->save();

.. _zendservice.delicious.deleting_posts:

Supprimer des entrées
---------------------

Il y a deux moyens de supprimer une entrée, en spécifiant son *URL* ou en appelant la méthode ``delete()`` sur
un objet ZendService\Delicious\PostList.

.. _zendservice.delicious.deleting_posts.deleting_posts:

.. rubric:: Suppression d'une entrée

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('nom_d_utilisateur',
                                           'mot_de_passe');

   // en spécifiant l' URL
   $delicious->deletePost('http://framework.zend.com');

   // en appelant la méthode de l'objet ZendService\Delicious\PostList
   $posts = $delicious->getPosts();
   $posts[0]->delete();

   // une autre façon d'utiliser deletePost()
   $delicious->deletePost($posts[0]->getUrl());

.. _zendservice.delicious.adding_posts:

Ajout d'entrées
---------------

Pour ajouter une entrée vous devez appeler la méthode ``createNewPost()``, qui renvoie un objet
``ZendService\Delicious\Post``. Quand vous éditez l'entrée, vous devez la sauvegarder dans la base de donnée de
del.icio.us en appelant la méthode ``save()``.

.. _zendservice.delicious.adding_posts.adding_a_post:

.. rubric:: Ajouter une entrée

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('nom_d_utilisateur',
                                           'mot_de_passe');

   // créé et sauvegarde une nouvelle entrée (en chainant les méthodes)
   $delicious->createNewPost('Zend Framework', 'http://framework.zend.com')
             ->setNotes('Page d\'accueil de Zend Framework')
             ->save();

   // créé et sauvegarde une nouvelle entrée (sans enchaîner les méthodes)
   $newPost = $delicious->createNewPost('Zend Framework',
                                        'http://framework.zend.com');
   $newPost->setNotes('Page d\'accueil de Zend Framework');
   $newPost->save();

.. _zendservice.delicious.tags:

Les étiquettes ("tags")
-----------------------

.. _zendservice.delicious.tags.tags:

.. rubric:: Récupérer les étiquettes

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('nom_d_utilisateur',
                                           'mot_de_passe');

   // récupère tous les étiquettes
   print_r($delicious->getTags());

   // renomme l'étiquette "ZF" en "zendFramework"
   $delicious->renameTag('ZF', 'zendFramework');

.. _zendservice.delicious.bundles:

Les groupes d'étiquettes
------------------------

.. _zendservice.delicious.bundles.example:

.. rubric:: Gestion des groupes d'étiquette

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('nom_d_utilisateur',
                                           'mot_de_passe');

   // récupère tous les groupes
   print_r($delicious->getBundles());

   // efface le groupe someBundle
   $delicious->deleteBundle('someBundle');

   // ajoute un groupe
   $delicious->addBundle('newBundle', array('tag1', 'tag2'));

.. _zendservice.delicious.public_data:

Données publiques
-----------------

L'API Web del.icio.us autorise l'accès aux données publiques de tous les utilisateurs.

.. _zendservice.delicious.public_data.functions_for_retrieving_public_data:

.. table:: Méthodes pour récupérer les données publiques

   +----------------+----------------------------------------+-------------------------------+
   |Nom             |Description                             |Type de retour                 |
   +================+========================================+===============================+
   |getUserFans()   |Récupère les fans d'un utilisateur      |Array                          |
   +----------------+----------------------------------------+-------------------------------+
   |getUserNetwork()|Récupère le réseau d'un utilisateur     |Array                          |
   +----------------+----------------------------------------+-------------------------------+
   |getUserPosts()  |Récupère les entrées d'un utilisateur   |ZendService\Delicious\PostList|
   +----------------+----------------------------------------+-------------------------------+
   |getUserTags()   |Récupère les étiquettes d'un utilisateur|Array                          |
   +----------------+----------------------------------------+-------------------------------+

.. note::

   Si vous utilisez uniquement ces méthodes, le nom d'utilisateur et le mot de passe ne sont pas obligatoires pour
   créer un nouvel objet ``ZendService\Delicious\Delicious``.

.. _zendservice.delicious.public_data.retrieving_public_data:

.. rubric:: Récupérer les données publiques

.. code-block:: php
   :linenos:

   // nom d'utilisateur et mot de passe optionnels
   $delicious = new ZendService\Delicious\Delicious();

   // récupère les fans de l'utilisateur someUser
   print_r($delicious->getUserFans('someUser'));

   // récupère le réseau de l'utilisateur someUser
   print_r($delicious->getUserNetwork('someUser'));

   // récupère les Tags de l'utilisateur someUser
   print_r($delicious->getUserTags('someUser'));

.. _zendservice.delicious.public_data.posts:

Entrées publiques
^^^^^^^^^^^^^^^^^

Quand vous récupérez des entrées publiques, la méthode ``getUserPosts()`` retourne un objet
``ZendService\Delicious\PostList`` qui contient des objets ``ZendService\Delicious\SimplePost``. Ces derniers
contiennent des informations basiques sur l'entrée : *URL*, title, notes, and tags.

.. _zendservice.delicious.public_data.posts.SimplePost_methods:

.. table:: Méthodes de la classe ZendService\Delicious\SimplePost

   +----------+-----------------------------------+--------------+
   |Nom       |Description                        |Type de retour|
   +==========+===================================+==============+
   |getNotes()|Récupère les notes de l'entrée     |String        |
   +----------+-----------------------------------+--------------+
   |getTags() |Récupère les étiquettes de l'entrée|Array         |
   +----------+-----------------------------------+--------------+
   |getTitle()|Récupère le titre de l'entrée      |String        |
   +----------+-----------------------------------+--------------+
   |getUrl()  |Récupère l'URL de l'entrée         |String        |
   +----------+-----------------------------------+--------------+

.. _zendservice.delicious.httpclient:

Client HTTP
-----------

``ZendService\Delicious\Delicious`` utilise ``Zend\Rest\Client`` pour effectuer les requêtes *HTTP* sur le Web service de
del.icio.us. Pour modifier le client *HTTP* utiliser par ``ZendService\Delicious\Delicious``, vous devez modifier le client
*HTTP* de ``Zend\Rest\Client``.

.. _zendservice.delicious.httpclient.changing:

.. rubric:: Modifier le client HTTP de ``Zend\Rest\Client``

.. code-block:: php
   :linenos:

   $myHttpClient = new My_Http_Client();
   Zend\Rest\Client::setHttpClient($myHttpClient);

Quand vous effectuez plus d'une requête avec ``ZendService\Delicious\Delicious`` vous pouvez accélérez vos requêtes en
configurant votre client *HTTP* pour qu'il ne ferme pas les connexions.

.. _zendservice.delicious.httpclient.keepalive:

.. rubric:: Configurer votre client HTTP pour qu'il ne ferme pas les connexions

.. code-block:: php
   :linenos:

   Zend\Rest\Client::getHttpClient()->setConfig(array(
           'keepalive' => true
   ));

.. note::

   En raison de quelques problèmes de del.icio.us avec *'ssl2'* (environs 2 secondes pour une requête), quand un
   objet ``ZendService\Delicious\Delicious`` est construit, le transport *SSL* de ``Zend\Rest\Client`` est configuré sur
   *'ssl'* au lieu de la valeur par défaut *'ssl2'*.



.. _`del.icio.us`: http://del.icio.us
