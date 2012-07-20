.. _zend.http.client.advanced:

Zend_Http_Client - Utilisation avancée
======================================

.. _zend.http.client.redirections:

Redirections HTTP
-----------------

Par défaut, ``Zend_Http_Client`` gère automatiquement les redirections *HTTP*, et suivra jusqu'à 5 redirections.
Ce comportement peut être modifié en changeant le paramètre de configuration "maxredirects".

Conformément à la RFC HTTP/1.1, les codes réponse HTTP 301 et 302 doivent être traités par le client en
envoyant à nouveau la même requête à l'adresse spécifiée - en utilisant la même méthode de requête.
Cependant, la plupart des clients ne réagissent pas correctement et redirige toujours via une requête GET. Par
défaut, ``Zend_Http_Client`` agit de même - Lors d'une redirection basée sur la réception d'un code 301 ou 302,
tous les paramètres GET et POST sont remis à zéro, et une requête GET est envoyée à la nouvelle adresse. Ce
comportement peut être modifié en positionnant le paramètre de configuration "strictredirects" à ``TRUE``:



      .. _zend.http.client.redirections.example-1:

      .. rubric:: Forcer des redirections conformes au RFC 2616 lors de la réception d'un code statut 301 and 302

      .. code-block:: php
         :linenos:

         // Redirections strictes
         $client->setConfig(array('strictredirects' => true)

         // Redirections non strictes
         $client->setConfig(array('strictredirects' => false)



Il est toujours possible d'obtenir le nombre de redirections effectuées après l'envoi d'une requête en invoquant
la méthode getRedirectionsCount().

.. _zend.http.client.cookies:

Ajout de cookies et gestion de leur persistance
-----------------------------------------------

``Zend_Http_Client`` fournit une interface simple afin d'ajouter des cookies à une requête de manière à ce
qu'aucune modification directe de l'en-tête ne soit nécessaire. Ceci est réalisé via la méthode
``setCookie()``. Cette méthode peut être utilisée de plusieurs manières :



      .. _zend.http.client.cookies.example-1:

      .. rubric:: Définition de cookies via setCookie()

      .. code-block:: php
         :linenos:

         // Simple et facile : en fournissant un nom de cookie et une valeur
         $client->setCookie('parfum', 'pépites de chocolat');

         // en fournissant directement une chaîne de cookie encodée (nom=valeur)
         // Notez que la valeur doit être déjà encodée au format URL
         $client->setCookie('parfum=p%C3%A9pites%20de%20chocolat');

         // En fournissant un objet Zend_Http_Cookie
         $cookie =
             Zend_Http_Cookie::fromString('parfum=p%C3%A9pites%20de%20chocolat');
         $client->setCookie($cookie);

Pour plus d'information sur les objets ``Zend_Http_Cookie``, voir :ref:` <zend.http.cookies>`.

``Zend_Http_Client`` permet également la persistance des cookies - ce qui permet au client de stocker tous les
cookies reçus et transmis, et de les retransmettre automatiquement lors des requêtes suivantes. Cela se révèle
très utile lorsqu'il est nécessaire de s'identifier sur un site donné (et de recevoir ainsi un cookie de
session) avant de pouvoir envoyer d'autres requêtes.



      .. _zend.http.client.cookies.example-2:

      .. rubric:: Activer la persistance des cookies

      .. code-block:: php
         :linenos:

         // Pour activer la persistance des cookies,
         // définissez un Magasin de cookie "Cookie Jar"
         $client->setCookieJar();

         // Première requête : s'identifier et démarrer une session
         $client->setUri('http://exemple.com/login.php');
         $client->setParameterPost('user', 'h4x0r');
         $client->setParameterPost('password', '1337');
         $client->request('POST');

         // Le magasin de cookies stocke automatiquement les
         // cookies transmis dans la réponse, un cookie de session par exemple

         // Maintenant nous pouvons envoyer notre requête suivante
         // les cookies stockés seront transmis automatiquement.
         $client->setUri('http://exemple.com/lire_actualite_membres.php');
         $client->request('GET');

Pour plus d'information sur la classe ``Zend_Http_CookieJar``, voir :ref:` <zend.http.cookies.cookiejar>`.

.. _zend.http.client.custom_headers:

Définir des en-têtes personnalisés
----------------------------------

Il est possible de définir des en-têtes personnalisés en utilisant la méthode ``setHeaders()``. Cette méthode
est très versatile et peut être utilisée de diverses manières comme le montre l'exemple suivant :



      .. _zend.http.client.custom_headers.example-1:

      .. rubric:: Définir un en-tête personnalisé unique

      .. code-block:: php
         :linenos:

         // Définition d'un en-tête unique,
         // écrasant toute valeur précédemment définie
         $client->setHeaders('Host', 'www.exemple.com');

         // La même chose d'une autre manière
         $client->setHeaders('Host: www.example.com');

         // Définition de plusieurs valeurs pour le même en-tête
         // (surtout utile pour les en-têtes de cookies)
         $client->setHeaders('Cookie', array(
             'PHPSESSID=1234567890abcdef1234567890abcdef',
             'language=fr'
         ));



``setHeader()`` peut aussi être facilement utilisé pour définir des en-têtes multiples en un seul appel, en
fournissant un tableau d'en-têtes comme paramètre unique :



      .. _zend.http.client.custom_headers.example-2:

      .. rubric:: Définition de plusieurs en-têtes personnalisés

      .. code-block:: php
         :linenos:

         // Définition de plusieurs en-têtes,
         // écrasant toute valeur précédemment définie
         $client->setHeaders(array(
             'Host' => 'www.exemple.com',
             'Accept-encoding' => 'gzip,deflate',
             'X-Powered-By' => 'Zend Framework'));

         // Le tableau peut contenir uniquement des valeurs
         $client->setHeaders(array(
             'Host: www.exemple.com',
             'Accept-encoding: gzip,deflate',
             'X-Powered-By: Zend Framework'));



.. _zend.http.client.file_uploads:

Envoi de fichiers
-----------------

Il est possible d'envoyer des fichiers au travers d'HTTP en utilisant la méthode *setFileUpload*. Cette méthode
attend un nom de fichier comme premier paramètre, un nom de formulaire comme second paramètre, et, en option, des
données comme troisième paramètre. Si le troisième paramètre est ``NULL``, la valeur du premier paramètre est
supposée être un fichier sur le disque dur et ``Zend_Http_Client`` essaiera de lire ce fichier et de l'envoyer.
Sinon la valeur du premier paramètre sera envoyée comme nom du fichier mais il n'est pas nécessaire que le
fichier existe sur le disque dur. Le deuxième paramètre est toujours requis, et est équivalent à l'attribut
"name" d'une balise <input>, si le fichier devait être envoyé à partir d'un formulaire HTML. Un quatrième
paramètre optionnel fournit le type du fichier. S'il n'est pas spécifié et que ``Zend_Http_Client`` lit le
fichier à partir du disque dur, la fonction mime_content_type sera utilisée pour tenter de définir, si possible,
le type du fichier. Dans tous les cas, le type MIME par défaut sera 'application/octet-stream'.



      .. _zend.http.client.file_uploads.example-1:

      .. rubric:: Utilisation de setFileUpload pour envoyer des fichiers

      .. code-block:: php
         :linenos:

         // Envoi de données arbitraires comme fichier
         $texte = 'ceci est un texte ordinaire';
         $client->setFileUpload('du_texte.txt', 'upload', $texte, 'text/plain');

         // envoi d'un fichier existant
         $client->setFileUpload('/tmp/Backup.tar.gz', 'bufile');

         // envoi des fichiers
         $client->request('POST');

Dans le premier exemple, la variable $texte est envoyée et sera disponible dans ``$_FILES['upload']`` côté
serveur. Dans le second exemple, le fichier existant "``/tmp/Backup.tar.gz``" est envoyé au serveur et sera
disponible dans ``$_FILES['bufile']``. Son type sera défini automatiquement si possible. Sinon, le type sera
défini comme "application/octet-stream".

.. note::

   **Envoi de fichiers**

   Lors de l'envoi de fichiers, le type de la requête *HTTP* est automatiquement défini comme
   "multipart/form-data". Gardez à l'esprit que vous devez utiliser la méthode POST ou la méthode PUT pour
   envoyer des fichiers. La plupart des serveurs ignoreront le corps de la requête si vous utilisez une autre
   méthode.

.. _zend.http.client.raw_post_data:

Envoyer des données brutes via POST
-----------------------------------

Vous pouvez utiliser ``Zend_Http_Client`` pour envoyer des données brutes via POST en utilisant la méthode
``setRawData()``. Cette méthode accepte deux paramètres : le premier contient les données à transmettre dans le
corps de la requête. Le deuxième paramètre, optionnel, contient le type des données. Bien que ce paramètre
soit optionnel, vous devriez normalement le définir avant l'envoi de la requête, soit via setRawData() ou via la
méthode ``setEncType()``.



      .. _zend.http.client.raw_post_data.example-1:

      .. rubric:: Envoi de données brutes via POST

      .. code-block:: php
         :linenos:

         $xml = '<book>' .
                '  <title>Islands in the Stream</title>' .
                '  <author>Ernest Hemingway</author>' .
                '  <year>1970</year>' .
                '</book>';

         $client->setRawData($xml, 'text/xml')->request('POST');

         // Une autre manière de faire la même chose :
         $client->setRawData($xml)->setEncType('text/xml')->request('POST');

Les données seront disponible côté serveur via la variable PHP ``$HTTP_RAW_POST_DATA`` ou via le flux
php://input.

.. note::

   **Utiliser des données brutes POST**

   Définir des données brutes POST pour une requête écrasera tout autre paramètre POST ou envoi de fichiers.
   Il est recommandé de ne pas utiliser les deux conjointement. Gardez à l'esprit que la plupart des serveurs
   ignoreront le corps de la requête si celle-ci n'utilise pas la méthode POST.

.. _zend.http.client.http_authentication:

Authentification HTTP
---------------------

Actuellement, ``Zend_Http_Client`` propose uniquement l'authentification HTTP "basic". Cette fonctionnalité est
utilisée via la méthode ``setAuth()``, ou en spécifiant le nom d'utilisateur et le mot de passe dans l'URI. La
méthode ``setAuth()`` accepte trois paramètres : le nom d'utilisateur, le mot de passe et un type
d'authentification optionnel. Comme mentionné, seule l'authentification "basic" est actuellement implémentée
(l'ajout de l'authentification "digest" est planifié).



      .. _zend.http.client.http_authentication.example-1:

      .. rubric:: Définir nom d'utilisateur et mot de passe pour l'authentification HTTP

      .. code-block:: php
         :linenos:

         // Utilisation de l'authentification 'basic'
         $client->setAuth('shahar',
                          'monMotdePasse!',
                          Zend_Http_Client::AUTH_BASIC);

         // L'authentification 'basic' étant le comportement par défaut,
         // on peut aussi écrire ceci :
         $client->setAuth('shahar', 'monMotdePasse!');

         // Vous pouvez aussi spécifier le nom d'utilisateur
         // et le mot de passe dans l'URI
         $client->setUri('http://christer:secret@example.com');



.. _zend.http.client.multiple_requests:

Envoyer plusieurs requêtes avec le même client
----------------------------------------------

``Zend_Http_Client`` a été également conçu spécifiquement pour gérer plusieurs requêtes consécutives avec
la même instance. Ceci est utile dans les cas ou le script nécessite d'accéder à des données en provenance de
divers emplacements ou, par exemple, lors de l'accès à des ressources *HTTP* nécessitant une authentification
préalable.

Lorsqu'on génère plusieurs requêtes vers le même hôte, il est chaudement recommandé d'activer la variable de
configuration "keepalive". De cette manière, si le serveur supporte le mode de connexion "keep-alive", la
connexion au serveur sera fermée après l'exécution de toutes les requêtes et la destruction de l'instance. Ceci
permet d'éviter au serveur d'ouvrir et de fermer de multiples connexions *TCP*.

Lorsqu'on génère plusieurs requêtes avec le même client, mais qu'on souhaite s'assurer que tous les paramètres
spécifiques de chacune des requêtes sont effacés, on peut utiliser la méthode ``resetParameters()``. Ceci
permet de supprimer tous les paramètres GET et POST, le contenu des requêtes et les en-têtes spécifiques de
manière à ce qu'ils ne soient pas réutilisés lors de la requête suivante.

.. note::

   **Réinitialiser les paramètres**

   Notez que les en-têtes spécifiques non liés à la requête ne sont pas réinitialisés par défaut quand la
   méthode ``resetParameters`` est invoquée. En fait, seuls les en-têtes "Content-length" et "Content-type" sont
   supprimés. Ceci permet de définir une seule fois les en-têtes comme "Accept-language" ou "Accept-encoding".

   Pour effacer tous les entêtes et toutes les données excepté l'URI et la méthode, utilisez
   ``resetParameters(true)``.

Une autre fonctionnalité spécifique aux requêtes consécutives est l'objet Magasin de Cookies ("Cookie Jar"). Il
permet de sauver automatiquement les cookies définis par le serveur lors de la première requête et de les
renvoyer de manière transparente lors de chacune des requêtes suivantes. Ceci permet, par exemple, de passer une
étape d'authentification avant d'envoyer d'autres requêtes.

Si votre application nécessite une requête d'authentification par utilisateur, et que d'autres requêtes peuvent
être effectuées via plusieurs scripts différents, il peut se révéler pratique de stocker le Magasin de cookies
dans la session utilisateur. De cette manière, il sera possible de ne s'identifier qu'une seule fois par session.

.. _zend.http.client.multiple_requests.example-1:

.. rubric:: Exécuter plusieurs requêtes avec un seul client

.. code-block:: php
   :linenos:

   // D'abord, instancier le client
   $client =
       new Zend_Http_Client('http://www.exemple.com/obtientdonnees.php',
                            array('keepalive' => true));

   // Disposons-nous du cookie de session ?
   if (isset($_SESSION['cookiejar']) &&
       $_SESSION['cookiejar'] instanceof Zend_Http_CookieJar)) {

       $client->setCookieJar($_SESSION['cookiejar']);
   } else {
       // Sinon, Identifions-nous et stockons le cookie
       $client->setCookieJar();
       $client->setUri('http://www.exemple.com/connexion.php');
       $client->setParameterPost(array(
           'user' => 'shahar',
           'pass' => 'secret'
       ));
       $client->request(Zend_Http_Client::POST);

       // Maintenant, effaçons les paramètres et définissons l'URI
       // à sa valeur originale (notez que les cookies envoyés par le
       // serveur sont stockés dans le magasin de cookies)
       $client->resetParameters();
       $client->setUri('http://www.exemple.com/obtientdonnees.php');
   }

   $reponse = $client->request(Zend_Http_Client::GET);

   // Stockons les cookies dans la session pour la page suivante
   $_SESSION['cookiejar'] = $client->getCookieJar();

.. _zend.http.client.streaming:

Data Streaming
--------------

By default, ``Zend_Http_Client`` accepts and returns data as PHP strings. However, in many cases there are big
files to be sent or received, thus keeping them in memory might be unnecessary or too expensive. For these cases,
``Zend_Http_Client`` supports reading data from files (and in general, PHP streams) and writing data to files
(streams).

In order to use stream to pass data to ``Zend_Http_Client``, use ``setRawData()`` method with data argument being
stream resource (e.g., result of ``fopen()``).



      .. _zend.http.client.streaming.example-1:

      .. rubric:: Sending file to HTTP server with streaming

      .. code-block:: php
         :linenos:

         $fp = fopen("mybigfile.zip", "r");
         $client->setRawData($fp, 'application/zip')->request('PUT');



Only PUT requests currently support sending streams to HTTP server.

In order to receive data from the server as stream, use ``setStream()``. Optional argument specifies the filename
where the data will be stored. If the argument is just TRUE (default), temporary file will be used and will be
deleted once response object is destroyed. Setting argument to FALSE disables the streaming functionality.

When using streaming, ``request()`` method will return object of class ``Zend_Http_Client_Response_Stream``, which
has two useful methods: ``getStreamName()`` will return the name of the file where the response is stored, and
``getStream()`` will return stream from which the response could be read.

You can either write the response to pre-defined file, or use temporary file for storing it and send it out or
write it to another file using regular stream functions.



      .. _zend.http.client.streaming.example-2:

      .. rubric:: Receiving file from HTTP server with streaming

      .. code-block:: php
         :linenos:

         $client->setStream(); // will use temp file
         $response = $client->request('GET');
         // copy file
         copy($response->getStreamName(), "my/downloads/file");
         // use stream
         $fp = fopen("my/downloads/file2", "w");
         stream_copy_to_stream($response->getStream(), $fp);
         // Also can write to known file
         $client->setStream("my/downloads/myfile)->request('GET');




