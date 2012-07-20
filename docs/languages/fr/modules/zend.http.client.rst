.. _zend.http.client:

Introduction
============

``Zend_Http_Client`` fournit une interface qui permet d'utiliser le protocole *HTTP* (Hyper-Text Transfer
Protocol). ``Zend_Http_Client`` supporte les fonctionnalités de base d'un client *HTTP*, ainsi que des
fonctionnalités plus avancées, comme l'authentification ou l'upload de fichiers. Toutes les requêtes retournent
un objet Zend_Http_Response, avec lequel on pourra accéder au corps ou aux en-têtes de la réponse *HTTP* (voyez
:ref:` <zend.http.response>`).

.. _zend.http.client.introduction:

Utilisation de Zend_Http_Client
-------------------------------

Le constructeur de classe accepte deux paramètres : l'URI (ou un objet *Zend_Uri_Http*), et un tableau ou un objet
Zend_Config d'options de configuration. Ils peuvent aussi être définis avec des méthodes plus tard :
``setUri()`` et ``setConfig()``.



      .. _zend.http.client.introduction.example-1:

      .. rubric:: Instanciation d'un objet Zend_Http_Client

      .. code-block:: php
         :linenos:

         $client = new Zend_Http_Client('http://example.org', array(
             'maxredirects' => 0,
             'timeout'      => 30));

         // OU
         $client = new Zend_Http_Client();
         $client->setUri('http://example.org');
         $client->setConfig(array(
             'maxredirects' => 0,
             'timeout'      => 30));

         // You can also use a Zend_Config object to set the client's configuration
         $config = new Zend_Config_Ini('httpclient.ini, 'secure');
         $client->setConfig($config);



.. note::

   ``Zend_Http_Client`` utilise ``Zend_Uri_Http`` pour valider les *URL*\ s. Ce qui veut dire que certains
   caractères comme les pipes ("\|") ou le symbole "^" ne seront pas acceptés par défaut dans les *URL*\ s. Ceci
   peut être modifié par le réglage de l'option "allow_unwise" de ``Zend_Uri`` à ``TRUE``. Voir :ref:`
   <zend.uri.validation.allowunwise>` pour de plus amples informations.

.. _zend.http.client.configuration:

Les paramètres de configuration
-------------------------------

Le constructeur et ``setConfig()`` acceptent un tableau associatif de paramètre de configuration, ou un objet
Zend_Config. Fixer ces paramètres est optionnel, ils ont tous une valeur par défaut.



      .. _zend.http.client.configuration.table:

      .. table:: Zend_Http_Client : paramètres de configuration

         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |Paramètre      |Description                                                                                                                                                                         |Valeur attendue|Valeur par défaut                |
         +===============+====================================================================================================================================================================================+===============+=================================+
         |maxredirects   |Nombre maximum de redirections à suivre (0 = aucune)                                                                                                                                |entier         |5                                |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |strict         |Validation faite ou non sur les noms d'en-têtes. Si à FALSE, des fonctions de validation n'interviendront pas. Habituellement ceci ne devrait pas être changé                       |booléen        |TRUE                             |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |strictredirects|Est ce que le client doit suivre strictement les redirections selon la RFC2616 ? (voyez )                                                                                           |booléen        |FALSE                            |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |useragent      |La chaîne User Agent du client (envoyée en en-tête de requête)                                                                                                                      |chaîne         |'Zend_Http_Client'               |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |timeout        |Connexion timeout (secondes)                                                                                                                                                        |entier         |10                               |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |httpversion    |Version du protocole HTTP à utiliser ('1.1', '1.0' ou '0.9')                                                                                                                        |chaîne         |'1.1'                            |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |adapter        |Classe adaptateur à utiliser (voyez )                                                                                                                                               |mixed          |'Zend_Http_Client_Adapter_Socket'|
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |keepalive      |Utilisation du pipelining HTTP (connexion ouverte après déconnexion du client)                                                                                                      |booléen        |FALSE                            |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |storeresponse  |Stockage ou non de la dernière réponse pour une récupération ultérieure avec getLastResponse(). Si réglez à FALSE, getLastResponse() retournera NULL.                               |booléen        |TRUE                             |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |encodecookies  |Whether to pass the cookie value through urlencode/urldecode. Enabling this breaks support with some web servers. Disabling this limits the range of values the cookies can contain.|boolean        |TRUE                             |
         +---------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+



.. _zend.http.client.basic-requests:

Utilisation basique
-------------------

Exécuter des requêtes HTTP basiques est très simple grâce à la méthode ``request()``, et ceci nécessite
rarement plus d'une ligne de code :



      .. _zend.http.client.basic-requests.example-1:

      .. rubric:: Requête GET simple

      .. code-block:: php
         :linenos:

         $client = new Zend_Http_Client('http://example.org');
         $response = $client->request();

La méthode ``request()`` accepte un paramètre optionnel définissant la méthode HTTP, - GET, POST, PUT, HEAD,
DELETE, TRACE, OPTIONS ou CONNECT - comme définies dans la RFC 2616 concernant le protocole HTTP [#]_. Ces
méthodes HTTP sont aussi définies en tant que constantes de classe, Zend_Http_Request::GET,
Zend_Http_Request::POST, etc...

Si aucune méthode de requêtage HTTP n'est définie, alors la dernière utilisée via ``setMethod()`` sera
utilisée. Si ``setMethod()`` n'a jamais été appelée, GET est alors utilisée par défaut.



      .. _zend.http.client.basic-requests.example-2:

      .. rubric:: Requêtes d'autres types que GET

      .. code-block:: php
         :linenos:

         // requête POST
         $response = $client->request('POST');

         // autre manière de faire :
         $client->setMethod(Zend_Http_Client::POST);
         $response = $client->request();



.. _zend.http.client.parameters:

Ajouts de paramètres GET et POST
--------------------------------

Ajouter des paramètres GET à la requête HTTP est très simple. Vous pouvez les ajouter en tant que partie de
l'URL désirée, ou en utilisant la méthode ``setParameterGet()``. Celle-ci prend en premier paramètre le nom du
paramètre GET, et en second sa valeur. Un tableau associatif peut aussi être utilisé.



      .. _zend.http.client.parameters.example-1:

      .. rubric:: Ajouts de paramètres GET

      .. code-block:: php
         :linenos:

         // Avec la méthode setParameterGet
         $client->setParameterGet('knight', 'lancelot');

         // Ce qui est équivalent à :
         $client->setUri('http://example.com/index.php?knight=lancelot');

         // Ajout de plusieurs paramètres en un appel
         $client->setParameterGet(array(
             'first_name'  => 'Bender',
             'middle_name' => 'Bending'
             'made_in'     => 'Mexico',
         ));



Coté POST, c'est très similaire à GET, sauf que les paramètres POST doivent faire partie du corps de la
requête. Il n'est donc pas possible de les ajouter dans l'URL. Utilisez simplement ``setParameterPost()`` de la
même manière que sa soeur ``setParameterGet()``.



      .. _zend.http.client.parameters.example-2:

      .. rubric:: Ajout de paramètres POST

      .. code-block:: php
         :linenos:

         // passage de paramètre POST simple
         $client->setParameterPost('language', 'fr');

         // Plusieurs paramètres, dont un avec plusieurs valeurs
         $client->setParameterPost(array(
             'language'  => 'es',
             'country'   => 'ar',
             'selection' => array(45, 32, 80)
         ));

Notez qu'en plus de paramètres POST, vous pouvez ajouter des paramètres GET à une requête POST. Le contraire
n'est pas possible, ainsi les paramètres POST ajoutés à une requête GET seront acceptés certes, mais ignorés.

.. _zend.http.client.accessing_last:

Accéder à la dernière requête, ou réponse
-----------------------------------------

``Zend_Http_Client`` fournit un moyen d'accéder à la dernière requête qu'il a effectuée, ainsi qu'à la
dernière réponse qu'il a reçue. ``Zend_Http_Client->getLastRequest()`` ne prends pas de paramètres et retourne
la dernière requête sous forme de chaîne de caractères. ``Zend_Http_Client->getLastResponse()`` retourne elle
la dernière réponse, mais sous forme d'objet :ref:`Zend_Http_Response <zend.http.response>`.



.. _`http://www.w3.org/Protocols/rfc2616/rfc2616.html`: http://www.w3.org/Protocols/rfc2616/rfc2616.html

.. [#] Voyez la RFC 2616 -`http://www.w3.org/Protocols/rfc2616/rfc2616.html`_.