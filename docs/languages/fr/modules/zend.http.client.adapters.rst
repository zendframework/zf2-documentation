.. _zend.http.client.adapters:

Zend_Http_Client - Adaptateurs de connexion
===========================================

.. _zend.http.client.adapters.overview:

Présentation globale
--------------------

``Zend_Http_Client`` accepte des objets adaptateurs. Ces objets ont la responsabilité de soutenir la connexion
vers un serveur, à savoir écrire des requêtes et lire des réponses L'adaptateur peut donc être changé, et
même écrit ou réécrit pour correspondre à vos besoins, sans avoir l'obligation de toucher à toute la classe
dite "client". Vous vous connectez et manipulez votre connexion toujours de la même manière quelque soit
l'adaptateur situé dessous.

Actuellement, la classe cliente ``Zend_Http_Client`` est fournie avec quatre adaptateurs :

   - ``Zend_Http_Client_Adapter_Socket`` (défaut)

   - ``Zend_Http_Client_Adapter_Proxy``

   - ``Zend_Http_Client_Adapter_Curl``

   - ``Zend_Http_Client_Adapter_Test``



L'objet Zend_Http_Client se voit spécifié un adaptateur via son constructeur avec le tableau d'options, à
l'index 'adapter'. Fournissez alors une chaîne représentant la classe d'adaptateur à utiliser (par exemple
'Zend_Http_Client_Adapter_Socket'), ou un objet directement (par exemple *new Zend_Http_Client_Adapter_Test*). Vous
pouvez de même passer un adaptateur plus tard, avec la méthode ``Zend_Http_Client->setConfig()``.

.. _zend.http.client.adapters.socket:

Adaptateur Socket
-----------------

L'adaptateur par défaut est Zend_Http_Client_Adapter_Socket. Il est basé sur les fonctions *PHP* ``fsockopen()``
et soeurs. Il ne nécessite donc aucune extension particulière ni option de compilation de *PHP*.

L'adaptateur Socket peut être configuré avec des options, passées par ``Zend_Http_Client->setConfig()`` ou au
constructeur du client.



      .. _zend.http.client.adapter.socket.configuration.table:

      .. table:: Zend_Http_Client_Adapter_Socket configuration

         +-------------+----------------------------------------------------------------------------------------------------------------------+--------------+-----------------+
         |Paramètre    |Description                                                                                                           |Types attendus|Valeur par défaut|
         +=============+======================================================================================================================+==============+=================+
         |persistent   |Utilise ou non les connexions TCP persistantes                                                                        |booléen       |false            |
         +-------------+----------------------------------------------------------------------------------------------------------------------+--------------+-----------------+
         |ssltransport |Couche de transport SSL ('sslv2', 'tls')                                                                              |chaîne        |ssl              |
         +-------------+----------------------------------------------------------------------------------------------------------------------+--------------+-----------------+
         |sslcert      |Chemin vers le certificat SSL encodé PEM                                                                              |chaîne        |null             |
         +-------------+----------------------------------------------------------------------------------------------------------------------+--------------+-----------------+
         |sslpassphrase|Phrase de passe pour le fichier de certificat SSL                                                                     |chaîne        |null             |
         +-------------+----------------------------------------------------------------------------------------------------------------------+--------------+-----------------+
         |sslusecontext|Active l'utilisation de SSL aux niveaux des connexions proxiées même si la connexion proxiée elle-même ne le fait pas.|boolean       |FALSE            |
         +-------------+----------------------------------------------------------------------------------------------------------------------+--------------+-----------------+



   .. note::

      **Connexions TCP persistantes**

      L'utilisation de connexions *TCP* persistantes peut potentiellement accélérer vos requêtes *HTTP* mais
      n'a, dans la plupart des cas, qu'un petit effet positif et peut surcharger le serveur *HTTP* auquel vous
      êtes connecté.

      Il est recommandé d'utiliser les connexions *TCP* persistantes seulement si vous vous connectez au même
      serveur très fréquemment, et que vous êtes sûr que le serveur est capable de gérer un nombre élevé de
      connections concurrentes. Dans tous les cas vous êtes encouragés à tester l'effet des connections
      persistantes à la fois sur l'accélération du client et sur la charge du serveur avant d'activer cette
      option.

      De plus, quand vous utilisez des connexions persistantes, il est recommandé d'activer l'option "Keep-Alive"
      décrite dans :ref:` <zend.http.client.configuration>`, sinon les connexions persistantes n'auront que peu ou
      pas d'effet.



   .. note::

      **HTTPS SSL Paramètres de flux**

      *ssltransport, sslcert* and *sslpassphrase* sont seulement appropriées lors de l'utilisation d'HTTPS.

      Bien que les réglages par défaut du mode *SSL* fonctionneront pour la plupart des applications, vous
      pourrez avoir besoin de les changer si le serveur, auquel vous vous connectez, requière un paramétrage
      particulier du client. Dans ce cas, vous devriez lire les sections sur la couche de transport *SSL* et ses
      options à cette `adresse`_.



.. _zend.http.client.adapters.socket.example-1:

.. rubric:: Changer la couche de transport HTTPS

.. code-block:: php
   :linenos:

   // Définit des paramètres de configuration
   $config = array(
       'adapter'      => 'Zend_Http_Client_Adapter_Socket',
       'ssltransport' => 'tls'
   );

   // Instantie un objet client
   $client = new Zend_Http_Client('https://www.example.com', $config);

   // Cette requête sera envoyée vers une connexion sécurisée TLS
   $response = $client->request();

Le résultat ci-dessus sera similaire à l'ouverture d'une connexion *TCP* avec la commande *PHP* suivante :

``fsockopen('tls://www.example.com', 443)``

.. _zend.http.client.adapters.socket.streamcontext:

Customizing and accessing the Socket adapter stream context
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Starting from Zend Framework 1.9, ``Zend_Http_Client_Adapter_Socket`` provides direct access to the underlying
`stream context`_ used to connect to the remote server. This allows the user to pass specific options and
parameters to the *TCP* stream, and to the *SSL* wrapper in case of *HTTPS* connections.

You can access the stream context using the following methods of ``Zend_Http_Client_Adapter_Socket``:

   - **setStreamContext($context)** Sets the stream context to be used by the adapter. Can accept either a stream
     context resource created using the `stream_context_create()`_ *PHP* function, or an array of stream context
     options, in the same format provided to this function. Providing an array will create a new stream context
     using these options, and set it.

   - **getStreamContext()** Get the stream context of the adapter. If no stream context was set, will create a
     default stream context and return it. You can then set or get the value of different context options using
     regular *PHP* stream context functions.



.. _zend.http.client.adapters.socket.streamcontext.example-1:

.. rubric:: Setting stream context options for the Socket adapter

.. code-block:: php
   :linenos:

   // Array of options
   $options = array(
       'socket' => array(
           // Bind local socket side to a specific interface
           'bindto' => '10.1.2.3:50505'
       ),
       'ssl' => array(
           // Verify server side certificate,
           // do not accept invalid or self-signed SSL certificates
           'verify_peer' => true,
           'allow_self_signed' => false,

           // Capture the peer's certificate
           'capture_peer_cert' => true
       )
   );

   // Create an adapter object and attach it to the HTTP client
   $adapter = new Zend_Http_Client_Adapter_Socket();
   $client = new Zend_Http_Client();
   $client->setAdapter($adapter);

   // Method 1: pass the options array to setStreamContext()
   $adapter->setStreamContext($options);

   // Method 2: create a stream context and pass it to setStreamContext()
   $context = stream_context_create($options);
   $adapter->setStreamContext($context);

   // Method 3: get the default stream context and set the options on it
   $context = $adapter->getStreamContext();
   stream_context_set_option($context, $options);

   // Now, preform the request
   $response = $client->request();

   // If everything went well, you can now access the context again
   $opts = stream_context_get_options($adapter->getStreamContext());
   echo $opts['ssl']['peer_certificate'];

.. note::

   Note that you must set any stream context options before using the adapter to preform actual requests. If no
   context is set before preforming *HTTP* requests with the Socket adapter, a default stream context will be
   created. This context resource could be accessed after preforming any requests using the ``getStreamContext()``
   method.

.. _zend.http.client.adapters.proxy:

Adaptateur Proxy
----------------

L'adaptateur Zend_Http_Client_Adapter_Proxy est identique à celui par défaut, Socket, sauf que Proxy se
connectera au serveur via un serveur Proxy (mandataire). Cette utilisation peut être rencontrée pour des raisons
de performances ou de sécurité.

En utilisant l'adaptateur Proxy, quelques paramètres de configuration seront nécessaires en plus du paramètre
'adapter' :



      .. _zend.http.client.adapters.proxy.table:

      .. table:: Zend_Http_Client paramètres de configuration

         +----------+------------------------------------------+-----------------+-------------------------------------+
         |Paramètre |Description                               |Valeurs attendues|Valeur par défaut                    |
         +==========+==========================================+=================+=====================================+
         |proxy_host|Adresse du serveur Proxy                  |chaîne           |'proxy.myhost.com' ou '10.1.2.3'     |
         +----------+------------------------------------------+-----------------+-------------------------------------+
         |proxy_port|Port du serveur Proxy                     |entier           |8080 (défaut) ou 81                  |
         +----------+------------------------------------------+-----------------+-------------------------------------+
         |proxy_user|nom d'utilisateur pour le Proxy, si requis|chaîne           |'shahar' ou '' pour aucun (défaut)   |
         +----------+------------------------------------------+-----------------+-------------------------------------+
         |proxy_pass|Mot de passe du Proxy, si requis          |chaîne           |'secret' ou '' pour aucun (défaut)   |
         +----------+------------------------------------------+-----------------+-------------------------------------+
         |proxy_auth|Type d'authentification HTTP du Proxy     |chaîne           |Zend_Http_Client::AUTH_BASIC (défaut)|
         +----------+------------------------------------------+-----------------+-------------------------------------+



*proxy_host* devrait toujours être fourni. Si ça n'est pas le cas, alors le client retournera sur une connexion
Socket par défaut. *proxy_port* est par défaut à "8080".

*proxy_user* et *proxy_pass* ne sont requis que si le serveur Proxy demande une authentification. Si vous
remplissez ces options, alors un champ d'en-tête *HTTP*"Proxy-Authentication" sera ajouté à vos requêtes, via
votre client.

*proxy_auth* définit le type d'authentification à utiliser, si le serveur Proxy demande une authentification.
Actuellement, seule la méthode "basic" (``Zend_Http_Client::AUTH_BASIC``) est supportée.

.. _zend.http.client.adapters.proxy.example-1:

.. rubric:: Utiliser Zend_Http_Client derrière un serveur Proxy

.. code-block:: php
   :linenos:

   // Paramètres de configuration
   $config = array(
       'adapter'    => 'Zend_Http_Client_Adapter_Proxy',
       'proxy_host' => 'proxy.int.zend.com',
       'proxy_port' => 8000,
       'proxy_user' => 'shahar.e',
       'proxy_pass' => 'bananashaped'
   );

   // Crée l'objet client
   $client = new Zend_Http_Client('http://www.example.com', $config);

   // utilisez l'objet client ici ...

Comme déjà dit, si proxy_host n'est pas rempli ou défini en tant que chaîne vide, alors le client utilisera
l'adaptateur Socket par défaut. Ceci est utile si le proxy est utilisé optionnellement, ou par intermittence.

.. note::

   Since the proxy adapter inherits from ``Zend_Http_Client_Adapter_Socket``, you can use the stream context access
   method (see :ref:` <zend.http.client.adapters.socket.streamcontext>`) to set stream context options on Proxy
   connections as demonstrated above.

.. _zend.http.client.adapters.curl:

The cURL Adapter
----------------

cURL is a standard *HTTP* client library that is distributed with many operating systems and can be used in *PHP*
via the cURL extension. It offers functionality for many special cases which can occur for a *HTTP* client and make
it a perfect choice for a *HTTP* adapter. It supports secure connections, proxy, all sorts of authentication
mechanisms and shines in applications that move large files around between servers.

.. _zend.http.client.adapters.curl.example-1:

.. rubric:: Setting cURL options

.. code-block:: php
   :linenos:

   $config = array(
       'adapter'   => 'Zend_Http_Client_Adapter_Curl',
       'curloptions' => array(CURLOPT_FOLLOWLOCATION => true),
   );
   $client = new Zend_Http_Client($uri, $config);

By default the cURL adapter is configured to behave exactly like the Socket Adapter and it also accepts the same
configuration parameters as the Socket and Proxy adapters. You can also change the cURL options by either
specifying the 'curloptions' key in the constructor of the adapter or by calling ``setCurlOption($name, $value)``.
The ``$name`` key corresponds to the CURL_* constants of the cURL extension. You can get access to the Curl handle
by calling *$adapter->getHandle();*

.. _zend.http.client.adapters.curl.example-2:

.. rubric:: Transfering Files by Handle

You can use cURL to transfer very large files over *HTTP* by filehandle.

.. code-block:: php
   :linenos:

   $putFileSize   = filesize("filepath");
   $putFileHandle = fopen("filepath", "r");

   $adapter = new Zend_Http_Client_Adapter_Curl();
   $client = new Zend_Http_Client();
   $client->setAdapter($adapter);
   $adapter->setConfig(array(
       'curloptions' => array(
           CURLOPT_INFILE => $putFileHandle,
           CURLOPT_INFILESIZE => $putFileSize
       )
   ));
   $client->request("PUT");

.. _zend.http.client.adapters.test:

Adaptateur Test
---------------

Il est quelque fois difficile de tester une application qui a besoin d'une connexion *HTTP*. Par exemple, une
application qui est en charge de lire un flux *RSS* aura besoin d'une connexion, qui n'est pas tout le temps
disponible.

C'est pour cette raison que l'adaptateur ``Zend_Http_Client_Adapter_Test`` est présent. Vous pouvez de cette
manière écrire vos applications, et lors de la phase de tests, passer votre connexion sur l'adaptateur Test
(objet mock).

La classe ``Zend_Http_Client_Adapter_Test`` possède une méthode supplémentaire, ``setResponse()``. Elle prend en
paramètre un objet ``Zend_Http_Response`` ou une chaîne. Une fois cet objet de réponse déterminé, l'adaptateur
de Test retournera toujours cette réponse, sans effectuer de réelle requête *HTTP*.

.. _zend.http.client.adapters.test.example-1:

.. rubric:: Tester avec un objet de réponse HTTP unique

.. code-block:: php
   :linenos:

   // Création de l'adatateur et de l'objet client :
   $adapter = new Zend_Http_Client_Adapter_Test();
   $client = new Zend_Http_Client('http://www.example.com', array(
       'adapter' => $adapter
   ));

   // Passage de l'objet de réponse
   $adapter->setResponse(
       "HTTP/1.1 200 OK"        . "\r\n" .
       "Content-type: text/xml" . "\r\n" .
                                  "\r\n" .
       '<?xml version="1.0" encoding="UTF-8"?>' .
       '<rss version="2.0" xmlns:content="http://purl.org/rss/1.0/modules/content/"' .
       '     xmlns:wfw="http://wellformedweb.org/CommentAPI/"' .
       '     xmlns:dc="http://purl.org/dc/elements/1.1/">' .
       '  <channel>' .
       '    <title>Premature Optimization</title>' .
       // etc....
       '</rss>');

   $response = $client->request('GET');
   // ... continuez à parser $response...

L'exemple ci dessus montre comment préconfigurer la réponse qui sera retournée lors d'une requête de votre
objet client. Ainsi lors des tests, votre application continuera de se comporter normalement, elle aura tout
simplement été trompée (mock). Aucune connexion *HTTP* n'est dans ce cas là nécessaire.

Quelques fois, plusieurs transactions *HTTP* peuvent être nécessaires. Une réponse peut demander une
redirection, vers une autre. Dans ce cas, utiliser ``setResponse()`` toute seule n'est pas possible car il ne sera
pas possible de spécifier les réponses suivantes, nécessaires alors à l'application.

.. _zend.http.client.adapters.test.example-2:

.. rubric:: Tester avec plusieurs réponses HTTP

.. code-block:: php
   :linenos:

   // Création des objets adaptateur, et client
   $adapter = new Zend_Http_Client_Adapter_Test();
   $client = new Zend_Http_Client('http://www.example.com', array(
       'adapter' => $adapter
   ));

   // Configuration de la première réponse attendue
   $adapter->setResponse(
       "HTTP/1.1 302 Found"      . "\r\n" .
       "Location: /"             . "\r\n" .
       "Content-Type: text/html" . "\r\n" .
                                   "\r\n" .
       '<html>' .
       '  <head><title>Moved</title></head>' .
       '  <body><p>This page has moved.</p></body>' .
       '</html>');

   // Configuration des réponses successives
   $adapter->addResponse(
       "HTTP/1.1 200 OK"         . "\r\n" .
       "Content-Type: text/html" . "\r\n" .
                                   "\r\n" .
       '<html>' .
       '  <head><title>My Pet Store Home Page</title></head>' .
       '  <body><p>...</p></body>' .
       '</html>');

   // l'objet $client est prêt à être testé
   // son comportement est déja configuré

La méthode ``setResponse()`` détruit toutes les réponses dans le buffer de ``Zend_Http_Client_Adapter_Test`` et
définit la première réponse qui sera retournée. La méthode ``addResponse()`` définit les réponses suivantes.

Les réponses seront rejouées dans leur ordre d'ajout.

Dans l'exemple ci-dessus, l'adaptateur est configuré pour un scénario de test de redirections 302. En fonction de
votre application, le suivi d'une redirection peut être ou non désiré. Dans notre exemple, nous nous attendons
à ce que la redirection soit suivie et nous configurons notre adaptateur de tests pour ceci. La réponse de
redirection originelle (302) est définie avec la méthode ``setResponse()``, quant à la réponse non redirigeante
(200) suivante, elles est définie avec la méthode ``addResponse()``. Lorsque votre objet client est configuré,
vous pouvez l'injecter dans votre application à tester, et voir le résultat et les comportements.

If you need the adapter to fail on demand you can use ``setNextRequestWillFail($flag)``. The method will cause the
next call to ``connect()`` to throw an ``Zend_Http_Client_Adapter_Exception`` exception. This can be useful when
your application caches content from an external site (in case the site goes down) and you want to test this
feature.

.. _zend.http.client.adapters.test.example-3:

.. rubric:: Forcing the adapter to fail

.. code-block:: php
   :linenos:

   // Instantiate a new adapter and client
   $adapter = new Zend_Http_Client_Adapter_Test();
   $client = new Zend_Http_Client('http://www.example.com', array(
       'adapter' => $adapter
   ));

   // Force the next request to fail with an exception
   $adapter->setNextRequestWillFail(true);

   try {
       // This call will result in a Zend_Http_Client_Adapter_Exception
       $client->request();
   } catch (Zend_Http_Client_Adapter_Exception $e) {
       // ...
   }

   // Further requests will work as expected until
   // you call setNextRequestWillFail(true) again

.. _zend.http.client.adapters.extending:

Créer vos propres adaptateurs de connexion
------------------------------------------

Vous pouvez créer vos propres adaptateurs, si vous avez un besoin spécial à utiliser. Par exemple, des
possibilités de cache, ou des sockets persistantes.

Pour ceci, votre classe d'adaptateur doit implémenter l'interface ``Zend_Http_Client_Adapter_Interface``.
L'exemple suivant montre un squelette de classe. Toutes les méthodes publiques, ici, sont indispensables à la
classe, elles sont issues de l'interface :

.. _zend.http.client.adapters.extending.example-1:

.. rubric:: Création de votre propre adaptateur de connexion

.. code-block:: php
   :linenos:

   class MyApp_Http_Client_Adapter_BananaProtocol
       implements Zend_Http_Client_Adapter_Interface
   {
       /**
        * Définit le tableau de configuration pour cet adaptateur
        *
        * @param array $config
        */
       public function setConfig($config = array())
       {
           // Ceci change rarement, vous devriez copier l'implémentation
           // présente dans Zend_Http_Client_Adapter_Socket.
       }

       /**
        * Connecte à une serveur distant
        *
        * @param string  $host
        * @param int     $port
        * @param boolean $secure
        */
       public function connect($host, $port = 80, $secure = false)
       {
           // Etablit la connexion au serveur
       }

       /**
        * Envoie une requête au serveur
        *
        * @param string        $method
        * @param Zend_Uri_Http $url
        * @param string        $http_ver
        * @param array         $headers
        * @param string        $body
        * @return string Request as text
        */
       public function write($method,
                             $url,
                             $http_ver = '1.1',
                             $headers = array(),
                             $body = '')
       {
           // Envoie la requête au serveur distant. Cette fonction devrait
           // retourner la requête complète (en-tête et corps) as a string
       }

       /**
        * Lit la réponse du serveur
        *
        * @return string
        */
       public function read()
       {
           // Lit la réponse du serveur distant, et la retourne sous forme
           // de chaine de caractères
       }

       /**
        * Ferme la connexion avec le serveur
        *
        */
       public function close()
       {
           // Ferme la connexion, appelée en dernière.
       }
   }

   // Maintenant, vous pouvez utiliser cet adaptateur :
   $client = new Zend_Http_Client(array(
       'adapter' => 'MyApp_Http_Client_Adapter_BananaProtocol'
   ));



.. _`adresse`: http://www.php.net/manual/en/transports.php#transports.inet
.. _`stream context`: http://php.net/manual/en/stream.contexts.php
.. _`stream_context_create()`: http://php.net/manual/en/function.stream-context-create.php
