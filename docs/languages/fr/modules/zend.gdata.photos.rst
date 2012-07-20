.. _zend.gdata.photos:

Utilisation des albums Web Picasa
=================================

Les albums Web Picasa représentent un service Google permettant de maintenir à jour des albums photos, tout en
pouvant récupérer des photos de l'album d'un membre. L'API propose des services pour ajouter, mettre à jour ou
supprimer des photos d'un album, de même que gérer des mots-clés ou des commentaires sur des images(photos).

L'accès public à un album, en lecture donc, n'est pas sujet à demande d'authentification. En revanche, toute
autre manipulation telle que la mise à jour ou la suppression, nécessitera que vous vous authentifiez.

Pour plus d'informations sur l'API, voyez `l'API Picasa Web Albums`_.

.. note::

   **Authentification**

   L'API propose les deux modes d'authentification, AuthSub (recommandé) et ClientAuth. Pour toute opération
   d'écriture vers le service, une authentification sera demandée, la lecture est elle, libre, au regard de
   l'API.

.. _zend.gdata.photos.connecting:

Se connecter au service
-----------------------

L'API Picasa, comme tous les autres services Web Google Gdata, est basée sur le protocole Atom Publishing Protocol
(APP), et le *XML*. Le trafic entre le client et le serveur se fait sur *HTTP*, et autorise des connexions
authentifiées, ou non.

Avant tout, il faut donc se connecter. Ceci se fait en deux étapes : créer un client *HTTP*, et insérer un
``Zend_Gdata_Photos`` dans celui-ci.

.. _zend.gdata.photos.connecting.authentication:

Authentification
^^^^^^^^^^^^^^^^

L'API propose un accès à la fois aux données publiques, et aux données privées. Les données publiques ne
requièrent pas d'authentification, mais ne sont accessibles qu'en lecture seule. L'écriture et l'accès aux
données privées requièrent une authentification, qui peut s'effectuer de trois manières différentes :

- **ClientAuth** permet une authentification directe en donnant un couple login/password. Les utilisateurs devront
  donc renseigner ces 2 paramètres sur votre site directement.

- **AuthSub** permet l'authentification en passant par un serveur proxy de Google. Les risques liés à la
  sécurité sont donc moindre avec cette méthode.

La librairie ``Zend_Gdata`` permet ces 2 types d'authentification. Le reste de ce chapitre supposera que vous soyez
habitué à l'authentification avec les service Web Google GData. Si ce n'est pas le cas, nous vous conseillons de
consulter :ref:`la section authentification <zend.gdata.introduction.authentication>` de ce manuel, ou encore `le
guide d'authentification Google GData webservices API`_.

.. _zend.gdata.photos.connecting.service:

Créer une instance du service
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Pour interagir avec les serveurs, la classe ``Zend_Gdata_Photos`` sera nécessaire. Elle abstrait toute la logique
de communication avec le Protocol Atom Publishing vers les serveurs de Google.

Une fois que vous avez choisi une méthode d'authentification, vous devez créer une instance de
``Zend_Gdata_Photos``. Le constructeur prend en paramètre une instance de ``Zend_Http_Client``. Cette classe est
l'interface AuthSub ou ClientAuth authentification. Si vous ne passez pas cette instance en argument, alors une
instance de ``Zend_Http_Client`` sera crée automatiquement, mais en mode non authentifié.

Voici un exemple qui démontre comment créer une classe vers le service avec le procédé d'authentification
ClientAuth :

.. code-block:: php
   :linenos:

   // Paramètres pour ClientAuth authentification
   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $user = "sample.user@gmail.com";
   $pass = "pa$$w0rd";

   // Création d'une client HTTP authentifié
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);

   // Création de l'instance du service
   $service = new Zend_Gdata_Photos($client);

Au sujet du procédé AuthSub, voici la démarche :

.. code-block:: php
   :linenos:

   session_start();

   /**
    * Retourne l'URL complet de la page actuelle,
    * en fonction des variables d'environnement
    *
    * Env variables utilisées:
    * $_SERVER['HTTPS'] = (on|off|)
    * $_SERVER['HTTP_HOST'] = value of the Host: header
    * $_SERVER['SERVER_PORT'] = port number (only used if not http/80,https/443)
    * $_SERVER['REQUEST_URI'] = the URI after the method of the HTTP request
    *
    * @return string Current URL
    */
   function getCurrentUrl()
   {
       global $_SERVER;

       /**
        * Filtre php_self pour éviter des problèmes de sécurité
        */
       $php_request_uri = htmlentities(substr($_SERVER['REQUEST_URI'], 0,
       strcspn($_SERVER['REQUEST_URI'], "\n\r")), ENT_QUOTES);

       if (isset($_SERVER['HTTPS'])
        && strtolower($_SERVER['HTTPS']) == 'on') {
           $protocol = 'https://';
       } else {
           $protocol = 'http://';
       }
       $host = $_SERVER['HTTP_HOST'];
       if ($_SERVER['SERVER_PORT'] != '' &&
           (($protocol == 'http://' && $_SERVER['SERVER_PORT'] != '80') ||
           ($protocol == 'https://' && $_SERVER['SERVER_PORT'] != '443'))) {
               $port = ':' . $_SERVER['SERVER_PORT'];
       } else {
           $port = '';
       }
       return $protocol . $host . $port . $php_request_uri;
   }

   /**
    * Retourne l'URL AuthSub que l'utilisateur doit visiter
    * pour authentifier ses requêtes
    *
    * Utilise getCurrentUrl() pour récupérer le prochain URL
    * vers lequel l'utilisateur sera redirigé après
    * s'être authentifié.
    *
    * @return string AuthSub URL
    */
   function getAuthSubUrl()
   {
       $next = getCurrentUrl();
       $scope = 'http://picasaweb.google.com/data';
       $secure = false;
       $session = true;
       return Zend_Gdata_AuthSub::getAuthSubTokenUri($next,
                                                     $scope,
                                                     $secure,
                                                     $session);
   }

   /**
    * Retourne un objet servant de client HTTP avec les bons en-têtes,
    * permettant de communiquer avec les services Google, et utilisant
    * l'authentification AuthSub.
    *
    * Utilise $_SESSION['sessionToken'] pour stocker le jeton de session
    * AuthSub après l'avoir obtenu. $_GET['token'] récupère ce jeton
    * après la redirection d'authentification
    *
    * @return Zend_Http_Client
    */
   function getAuthSubHttpClient()
   {
       global $_SESSION, $_GET;
       if (!isset($_SESSION['sessionToken']) && isset($_GET['token'])) {
           $_SESSION['sessionToken'] =
               Zend_Gdata_AuthSub::getAuthSubSessionToken($_GET['token']);
       }
       $client =
           Zend_Gdata_AuthSub::getHttpClient($_SESSION['sessionToken']);
       return $client;
   }

   /**
    * Créer une instance du service, redirigeant l'utilisateur
    * vers le serveur AuthSub si nécéssaire.
    */
   $service = new Zend_Gdata_Photos(getAuthSubHttpClient());

Enfin, un client non authentifié peut aussi être crée :

.. code-block:: php
   :linenos:

   // Création d'une instance du service en mode non authentifié
   $service = new Zend_Gdata_Photos();

.. _zend.gdata.photos.queries:

Comprendre et construire des requêtes
-------------------------------------

Pour créer des requêtes vers le service Web, vous devrez utiliser une de ces classes :

- **User** Cette classe requêtera tout ce qui concerne un utilisateur du service. Sans spécifier d'utilisateur,
  "default" sera utilisé.

- **Album** Cette classe va servir de base pour toutes les requêtes concernant les albums Picasa.

- **Photo** Cette classe va servir de base pour toutes les requêtes concernant les photos Picasa.

Une *UserQuery* peut être construite comme suit :

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_UserQuery();
   $query->setUser("sample.user");

Pour chaque requête, des paramètres de limitations de la recherche peuvent être passés grâce aux méthodes
get(Paramètre) and set(Paramètre) :

- **Projection** spécifie le format de retour des données dans le flux. Peut être "api" ou "base". En temps
  normal, "api" est conseillé, c'est la valeur par défaut d'ailleurs.

- **Type** détermine le type des éléments retournés, "feed"(défaut) ou "entry".

- **Access** détermine la visibilité des éléments retournés, "all"(défaut), "public", ou "private". Les
  éléments non publics ne seront retournés que si le client est authentifié.

- **Tag** fournit un filtre par mots-clés sur les éléments retournés.

- **Kind** détermine un filtre sur la sorte (le type) d'éléments retournés.

- **ImgMax** spécifie un filtre par dimension maximale sur les éléments retournés.

- **Thumbsize** spécifie un filtre par dimension maximale des miniatures retournées.

- **User** spécifie l'utilisateur dont les éléments sont recherchés. Par défaut, "default".

- **AlbumId** spécifie l'identifiant de l'album recherché. Ceci ne s'applique qu'aux requêtes album et photo.
  Dans le cas d'une recherche de photo, ceci indique l'album dans lequel effectuer la requête de recherche. Ce
  paramètre annule et remplace AlbumName, si spécifié.

- **AlbumName** spécifie le nom de l'album recherché. Ceci ne s'applique qu'aux requêtes album et photo. Dans le
  cas d'une recherche de photo, ceci indique l'album dans lequel effectuer la requête de recherche. Ce paramètre
  annule et remplace AlbumId, si spécifié.

- **PhotoId** spécifie l'identifiant de la photo recherchée. Ceci ne s'applique qu'aux requêtes photo.

.. _zend.gdata.photos.retrieval:

Récupérer des flux et des éléments
----------------------------------

Le service propose des méthodes de récupération de flux, ou d'éléments simples, concernant les utilisateurs,
albums, ou photos.

.. _zend.gdata.photos.user_retrieval:

Récupérer un utilisateur
^^^^^^^^^^^^^^^^^^^^^^^^

Le service propose de récupérer un utilisateur, et toutes les infos de son flux, comme ses photos, ses albums....
Si le client est authentifié et demande des informations sur son propre compte, alors les éléments marqués
comme "*hidden*" seront aussi retournés.

Le flux de l'utilisateur est accessible en passant son nom à la méthode *getUserFeed*:

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   try {
       $userFeed = $service->getUserFeed("sample.user");
   } catch (Zend_Gdata_App_Exception $e) {
       echo "Error: " . $e->getMessage();
   }

Ou alors, le flux peut être requêté directement :

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_UserQuery();
   $query->setUser("sample.user");

   try {
       $userFeed = $service->getUserFeed(null, $query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "Error: " . $e->getMessage();
   }

Construire une requête donne aussi accès aux éléments d'un utilisateur :

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_UserQuery();
   $query->setUser("sample.user");
   $query->setType("entry");

   try {
       $userEntry = $service->getUserEntry($query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "Error: " . $e->getMessage();
   }

.. _zend.gdata.photos.album_retrieval:

Récupérer un album
^^^^^^^^^^^^^^^^^^

Le service donne accès aux flux d'albums et à leurs contenus.

Le flux d'albums est disponible en construisant un objet de requête et en le passant à *getAlbumFeed*:

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_AlbumQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");

   try {
       $albumFeed = $service->getAlbumFeed($query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "Error: " . $e->getMessage();
   }

L'objet de requête accepte aussi un nom d'album avec *setAlbumName*. Attention, ceci annule un identifiant d'album
éventuellement précédemment spécifié.

Construire une requête donne aussi accès au requêtage d'un album :

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_AlbumQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setType("entry");

   try {
       $albumEntry = $service->getAlbumEntry($query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "Error: " . $e->getMessage();
   }

.. _zend.gdata.photos.photo_retrieval:

Récupérer une Photo
^^^^^^^^^^^^^^^^^^^

Le service permet la récupération de flux de photos, et des commentaires et/ou mots-clés associés

Le flux de photos est accessible en construisant un objet de requête et en le passant à la méthode
*getPhotoFeed*:

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");

   try {
       $photoFeed = $service->getPhotoFeed($query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "Error: " . $e->getMessage();
   }

Construire une requête donne aussi accès au requêtage d'une photo :

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");
   $query->setType("entry");

   try {
       $photoEntry = $service->getPhotoEntry($query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "Error: " . $e->getMessage();
   }

.. _zend.gdata.photos.comment_retrieval:

Récupérer des commentaires
^^^^^^^^^^^^^^^^^^^^^^^^^^

Vous pouvez récupérer des commentaires depuis des éléments divers de flux. En spécifiant à votre requête un
paramètre de "comment", celle-ci retournera les mots-clés associés à la ressource demandée (user, album ou
photo)

Voici comment effectuer des actions sur les commentaires récupérés d'une photo :

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");
   $query->setKind("comment");

   try {
       $photoFeed = $service->getPhotoFeed($query);

       foreach ($photoFeed as $entry) {
           if ($entry instanceof Zend_Gdata_Photos_CommentEntry) {
               // Faites quelque chose avec le commentaire
           }
       }
   } catch (Zend_Gdata_App_Exception $e) {
       echo "Error: " . $e->getMessage();
   }

.. _zend.gdata.photos.tag_retrieval:

Récupérer des mots-clés
^^^^^^^^^^^^^^^^^^^^^^^

Vous pouvez récupérer des mots-clés depuis des éléments divers de flux. En spécifiant à votre requête un
paramètre de "tag", celle-ci retournera les mots-clés associés à la ressource demandée.

Voici comment effectuer des actions sur les mots-clés récupérés d'une photo :

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");
   $query->setKind("tag");

   try {
       $photoFeed = $service->getPhotoFeed($query);

       foreach ($photoFeed as $entry) {
           if ($entry instanceof Zend_Gdata_Photos_TagEntry) {
               // Faites quelque chose avec le mot-clé
           }
       }
   } catch (Zend_Gdata_App_Exception $e) {
       echo "Error: " . $e->getMessage();
   }

.. _zend.gdata.photos.creation:

Créer des ressources
--------------------

Des opérations de création sont possible, qu'il s'agisse d'albums, photos, commentaires, ou mots-clés.

.. _zend.gdata.photos.album_creation:

Créer un album
^^^^^^^^^^^^^^

Il est possible de créer un album, pour les clients authentifiés :

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $entry = new Zend_Gdata_Photos_AlbumEntry();
   $entry->setTitle($service->newTitle("test album"));

   $service->insertAlbumEntry($entry);

.. _zend.gdata.photos.photo_creation:

Créer une photo
^^^^^^^^^^^^^^^

Créer une photo est possible pour les clients authentifiés, procédez comme suit :

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   // $photo est le nom d'un fichier issu d'un formulaire d'uplaod

   $fd = $service->newMediaFileSource($photo["tmp_name"]);
   $fd->setContentType($photo["type"]);

   $entry = new Zend_Gdata_Photos_PhotoEntry();
   $entry->setMediaSource($fd);
   $entry->setTitle($service->newTitle($photo["name"]));

   $albumQuery = new Zend_Gdata_Photos_AlbumQuery;
   $albumQuery->setUser("sample.user");
   $albumQuery->setAlbumId("1");

   $albumEntry = $service->getAlbumEntry($albumQuery);

   $service->insertPhotoEntry($entry, $albumEntry);

.. _zend.gdata.photos.comment_creation:

Créer un commentaire pour une photo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Il est possible de créer un commentaire pour une photo, voici un exemple :

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $entry = new Zend_Gdata_Photos_CommentEntry();
   $entry->setTitle($service->newTitle("comment"));
   $entry->setContent($service->newContent("comment"));

   $photoQuery = new Zend_Gdata_Photos_PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $photoEntry = $service->getPhotoEntry($photoQuery);

   $service->insertCommentEntry($entry, $photoEntry);

.. _zend.gdata.photos.tag_creation:

Créer un mot-clé pour une photo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Il est possible de créer un mot-clé pour une photo, voici un exemple :

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $entry = new Zend_Gdata_Photos_TagEntry();
   $entry->setTitle($service->newTitle("tag"));

   $photoQuery = new Zend_Gdata_Photos_PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $photoEntry = $service->getPhotoEntry($photoQuery);

   $service->insertTagEntry($entry, $photoEntry);

.. _zend.gdata.photos.deletion:

Supprimer des éléments
----------------------

Il est possible de supprimer albums, photos, commentaires, et mots-clés.

.. _zend.gdata.photos.album_deletion:

Supprimer un album
^^^^^^^^^^^^^^^^^^

Supprimer un album est possible si le client est authentifié :

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $albumQuery = new Zend_Gdata_Photos_AlbumQuery;
   $albumQuery->setUser("sample.user");
   $albumQuery->setAlbumId("1");
   $albumQuery->setType('entry');

   $entry = $service->getAlbumEntry($albumQuery);

   $service->deleteAlbumEntry($entry, true);

.. _zend.gdata.photos.photo_deletion:

Supprimer une photo
^^^^^^^^^^^^^^^^^^^

Supprimer une photo est possible si le client est authentifié :

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $photoQuery = new Zend_Gdata_Photos_PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $entry = $service->getPhotoEntry($photoQuery);

   $service->deletePhotoEntry($entry, true);

.. _zend.gdata.photos.comment_deletion:

Supprimer un commentaire
^^^^^^^^^^^^^^^^^^^^^^^^

Supprimer un commentaire est possible si le client est authentifié :

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $photoQuery = new Zend_Gdata_Photos_PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $path = $photoQuery->getQueryUrl() . '/commentid/' . "1000";

   $entry = $service->getCommentEntry($path);

   $service->deleteCommentEntry($entry, true);

.. _zend.gdata.photos.tag_deletion:

Supprimer un mot-clé
^^^^^^^^^^^^^^^^^^^^

Supprimer un mot-clé est possible, si le client est authentifié :

.. code-block:: php
   :linenos:

       $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $photoQuery = new Zend_Gdata_Photos_PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setKind("tag");
   $query = $photoQuery->getQueryUrl();

   $photoFeed = $service->getPhotoFeed($query);

   foreach ($photoFeed as $entry) {
       if ($entry instanceof Zend_Gdata_Photos_TagEntry) {
           if ($entry->getContent() == $tagContent) {
               $tagEntry = $entry;
           }
       }
   }

   $service->deleteTagEntry($tagEntry, true);

.. _zend.gdata.photos.optimistic_concurrenty:

Gestion des accès concurrents
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les flux GData, dont ceux de Picasa Web Albums, implémentent un système d'accès concurrent qui empêche les
changements avec écrasements par inadvertance. Si vous demandez l'effacement d'une ressource qui a été modifiée
depuis votre dernière requête, alors une exception sera levée, sauf si vous demandez le contraire explicitement
(dans un tel cas, la procédure d'effacement sera réessayée sur l'élément mis à jour).

Voici un exemple de gestion des versions et accès concurrent sur un effacement avec *deleteAlbumEntry*:

.. code-block:: php
   :linenos:

       // $album est l'albumEntry à effacer
   try {
       $this->delete($album);
   } catch (Zend_Gdata_App_HttpException $e) {
       if ($e->getMessage()->getStatus() === 409) {
           $entry =
               new Zend_Gdata_Photos_AlbumEntry($e->getMessage()
                                                  ->getBody());
           $this->delete($entry->getLink('edit')->href);
       } else {
           throw $e;
       }
   }



.. _`l'API Picasa Web Albums`: http://code.google.com/apis/picasaweb/overview.html
.. _`le guide d'authentification Google GData webservices API`: http://code.google.com/apis/gdata/auth.html
