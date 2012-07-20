.. _zend.http.response:

Zend_Http_Response
==================

.. _zend.http.response.introduction:

Introduction
------------

``Zend_Http_Response`` fournit un accès simplifié aux réponses *HTTP* d'un message, ainsi qu'un ensemble de
méthodes statiques pour analyser ces réponses *HTTP*. Habituellement ``Zend_Http_Response`` est utilisé en tant
qu'objet retourné par une requête ``Zend_Http_Client``.

Dans la plupart des cas, un objet ``Zend_Http_Response`` sera instancié en utilisant la méthode ``fromString()``,
qui lit une chaîne contenant une réponse HTTP, et retourne un nouvel objet ``Zend_Http_Response``:



      .. _zend.http.response.introduction.example-1:

      .. rubric:: Instancier un objet Zend_Http_Response en utilisant la méthode factory

      .. code-block:: php
         :linenos:

         $str = '';
         $sock = fsockopen('www.exemple.com', 80);
         $req =     "GET / HTTP/1.1\r\n" .
                 "Host: www.exemple.com\r\n" .
                 "Connection: close\r\n" .
                 "\r\n";

         fwrite($sock, $req);
         while ($buff = fread($sock, 1024))
             $str .= $sock;

         $response = Zend_Http_Response::fromString($str);



Vous pouvez aussi utiliser le constructeur pour créer un nouvel objet de réponse *HTTP*, en spécifiant tous les
paramètres de la réponse :

*public function __construct($code, $headers, $body = null, $version = '1.1', $message = null)*

- ``$code``: le code de la réponse *HTTP* (par ex. 200, 404, etc.)

- ``$headers``: un tableau associatif d'en-têtes de réponse *HTTP* (par ex. "Host" => "exemple.com")

- ``$body``: le corps de la réponse sous la forme d'une chaîne

- ``$version``: la version de la réponse *HTTP* (habituellement 1.0 ou 1.1)

- ``$message``: le message de la réponse *HTTP* (par ex. "OK", "Internal Server Error"). Si non spécifié, le
  message sera paramétré suivant le code de la réponse.

.. _zend.http.response.testers:

Méthodes de tests booléennes
----------------------------

Une fois qu'un objet ``Zend_Http_Response`` est instancié, il fournit plusieurs méthodes qui peuvent être
utilisées pour tester le type de la réponse. Elles retournent toutes un booléen ``TRUE`` ou ``FALSE``:

   - ``isSuccessful()``: la requête est réussie ou non. Retourne *true* pour les codes de réponses *HTTP* 1xx et
     2xx.

   - ``isError()``: la requête implique une erreur ou non. Retourne *true* pour les codes de réponses *HTTP* 4xx
     (erreurs du client) et 5xx (erreurs du serveur).

   - ``isRedirect()``: la requête est une redirection ou non. Retourne *true* pour les codes de réponses *HTTP*
     3xx.





      .. _zend.http.response.testers.example-1:

      .. rubric:: Utiliser la méthode isError() pour valider une réponse

      .. code-block:: php
         :linenos:

         if ($response->isError()) {
           echo "Erreur de transmission des données.\n"
           echo "Les infos Serveur sont : "
              . $response->getStatus()
              . " " . $response->getMessage()
              . "\n";
         }
         // ... traiter la réponse ici ...



.. _zend.http.response.acessors:

Méthodes accesseurs
-------------------

Le but principal de l'objet réponse est de fournir un accès facile à divers paramètres de la réponse.

   - *int getStatus()*: récupère le code de la réponse *HTTP* (par ex. 200, 504, etc.)

   - *string getMessage()*: récupère le message de la réponse *HTTP* (par ex. "Not Found", "Authorization
     Required")

   - *string getBody()*: récupère le corps complet décodé de la réponse *HTTP*

   - *string getRawBody()*: récupère le corps brut, possiblement encodé, de la réponse *HTTP*. Si le corps est
     encodé en utilisant l'encodage GZIP par exemple, il ne sera pas décodé.

   - *array getHeaders()*: récupère les en-têtes de la réponse *HTTP* sous la forme d'un tableau associatif
     (par ex. 'Content-type' => 'text/html')

   - *string|array getHeader($header)*: récupère un en-tête spécifique de la réponse *HTTP*, spécifié par
     ``$header``

   - *string getHeadersAsString($status_line = true, $br = "\n")*: récupère l'ensemble des en-têtes sous la
     forme d'une chaîne. Si ``$status_line`` est à ``TRUE`` (défaut), la première ligne de statut (par ex.
     "HTTP/1.1 200 OK") sera aussi retournée. Les lignes sont coupées avec le paramètre ``$br`` (par ex. "<br
     />")

   - *string asString($br = "\n")*: récupère la réponse complète sous la forme d'une chaîne. Les lignes sont
     coupées avec le paramètre ``$br`` (par ex. "<br />"). Vous pouvez aussi utiliser la méthode magique
     ``__toString()`` lors du cast de l'objet en chaîne de caractère. Ce sera alors proxié vers ``asString()``.





      .. _zend.http.response.acessors.example-1:

      .. rubric:: Utiliser les méthodes accesseurs de Zend_Http_Response

      .. code-block:: php
         :linenos:

         if ($response->getStatus() == 200) {
           echo "La requête retourne les informations suivantes :<br />";
           echo $response->getBody();
         } else {
           echo "Une erreur est apparue lors de la recherche des données :<br />";
           echo $response->getStatus() . ": " . $response->getMessage();
         }



   .. note::

      **Vérifier toujours la valeur retournée**

      Puisqu'une réponse peut contenir plusieurs exemplaires du même en-tête, la méthode ``getHeader()`` et la
      méthode ``getHeaders()`` peuvent renvoyer l'un comme l'autre soit une chaîne seule, soit un tableau de
      chaînes pour chaque en-tête. Vous devez donc toujours vérifier si la valeur retournée est une chaîne ou
      un tableau.





      .. _zend.http.response.acessors.example-2:

      .. rubric:: Accéder aux en-têtes de réponse

      .. code-block:: php
         :linenos:

         $ctype = $response->getHeader('Content-type');
         if (is_array($ctype)) $ctype = $ctype[0];

         $body = $response->getBody();
         if ($ctype == 'text/html' || $ctype == 'text/xml') {
           $body = htmlentities($body);
         }

         echo $body;



.. _zend.http.response.static_parsers:

Analyseurs statiques de réponse HTTP
------------------------------------

La classe ``Zend_Http_Response`` inclut également plusieurs méthodes utilisées en interne pour traiter et
analyser des messages de réponse *HTTP*. Ces méthodes sont toutes exposées en tant que méthodes statiques, ce
qui permet de les utiliser extérieurement, ainsi il n'est pas nécessaire d'instancier un objet réponse si vous
souhaitez extraire une partie spécifique de la réponse.

   - *int Zend_Http_Response::extractCode($response_str)*: extrait et retourne le code de la réponse *HTTP* (par
     ex. 200 ou 404) issu de ``$response_str``

   - *string Zend_Http_Response::extractMessage($response_str)*: extrait et retourne le message de la réponse
     *HTTP* (par ex. "OK" ou "File Not Found") issu de ``$response_str``

   - *string Zend_Http_Response::extractVersion($response_str)*: extrait et retourne la version *HTTP* (par ex. 1.1
     or 1.0) issue de ``$response_str``

   - *array Zend_Http_Response::extractHeaders($response_str)*: extrait et retourne les en-têtes de la réponse
     *HTTP* issus de ``$response_str`` sous la forme d'un tableau

   - *string Zend_Http_Response::extractBody($response_str)*: extrait et retourne le corps de la réponse *HTTP*
     issu de ``$response_str``

   - *string Zend_Http_Response::responseCodeAsText($code = null, $http11 = true)*: récupère le message standard
     de la réponse *HTTP* pour le code ``$code``. Par exemple, la méthode retournera "Internal Server Error" si
     ``$code`` vaut 500. Si ``$http11`` vaut ``TRUE`` (valeur par défaut), la méthode retournera les messages
     standards *HTTP*/1.1 - sinon les messages *HTTP*/1.0 seront retournés. Si ``$code`` n'est pas spécifié,
     cette méthode retournera tous les codes de réponse *HTTP* connus sous la forme d'un tableau associatif (code
     => message).



Indépendamment des méthodes d'analyse, la classe inclut également un ensemble de décodeurs pour les encodages
de transfert de réponse *HTTP* communs :

   - *string Zend_Http_Response::decodeChunkedBody($body)*: décode un corps complet de type
     "Content-Transfer-Encoding: Chunked"

   - *string Zend_Http_Response::decodeGzip($body)*: décode un corps de type "Content-Encoding: gzip"

   - *string Zend_Http_Response::decodeDeflate($body)*: décode un corps de type "Content-Encoding: deflate"




