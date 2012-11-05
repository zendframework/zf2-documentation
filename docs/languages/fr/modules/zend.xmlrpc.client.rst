.. EN-Revision: none
.. _zend.xmlrpc.client:

Zend\XmlRpc\Client
==================

.. _zend.xmlrpc.client.introduction:

Introduction
------------

Zend Framework possède la capacité de consommer des services distants XML-RPC, via la classe
``Zend\XmlRpc\Client``. Ses caractéristiques principales sont la conversion automatique des types entre *PHP* et
XML-RPC, un objet proxy de serveur, et des possibilités d'introspection du serveur.

.. _zend.xmlrpc.client.method-calls:

Appels de méthodes
------------------

Le constructeur de ``Zend\XmlRpc\Client`` reçoit en premier paramètre l'URL du serveur XML-RPC distant.
L'instance retournée pourra alors être utilisée pour appeler n'importe quelle méthode distante.

Pour appeler une méthode distante, utilisez la méthode ``call()`` de votre instance. Le code suivant montre un
exemple avec le serveur XML-RPC du site de Zend Framework. Vous pouvez l'utiliser pour tester ou explorer les
possibilités des composants ``Zend_XmlRpc``.

.. _zend.xmlrpc.client.method-calls.example-1:

.. rubric:: XML-RPC appel de méthode

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   echo $client->call('test.sayHello');

   // hello

Le type de la valeur XML-RPC retournée sera automatiquement casté en un type compatible *PHP*. Dans l'exemple
ci-dessus, une *string* *PHP* est retournée et immédiatement utilisable.

Le premier paramètre de ``call()`` est le nom de la méthode distante à appeler. Si celle-ci demande des
paramètres, ceux-ci doivent alors être passés via le deuxième paramètre de ``call()``, sous forme de tableau
*PHP* (*array*) :

.. _zend.xmlrpc.client.method-calls.example-2:

.. rubric:: XML-RPC appel de méthode avec des paramètres

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   $arg1 = 1.1;
   $arg2 = 'foo';

   $result = $client->call('test.sayHello', array($arg1, $arg2));

   // $result est un type PHP natif

Le tableau de paramètres peut contenir des types *PHP* natifs, des objets ``Zend\XmlRpc\Value``, ou bien les deux
à la fois.

La méthode ``call()`` convertira automatiquement la réponse XML-RPC et retournera un type *PHP* natif valide. Un
objet ``Zend\XmlRpc\Response`` pour la valeur de retour sera de même disponible, via un appel à
``getLastResponse()``.

.. _zend.xmlrpc.value.parameters:

Types et conversions
--------------------

Certaines méthodes distantes requièrent des paramètres. Ceux-ci sont donnés sous forme de tableau *PHP* à
``call()``. Chaque paramètre est supposé être un type *PHP* natif qui sera alors lui-même converti, ou alors un
objet représentant un type XML-RPC (un objet parmi les ``Zend\XmlRpc\Value``).

.. _zend.xmlrpc.value.parameters.php-native:

Types PHP natifs comme paramètres
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les paramètres passés à ``call()`` peuvent être d'un type *PHP* natif, à savoir *string*, *integer*, *float*,
*boolean*, *array*, ou *object*. Dans ce cas, chacun des types sera converti de manière automatique en son type
compatible XML-RPC, suivant la table suivante :

.. _zend.xmlrpc.value.parameters.php-native.table-1:

.. table:: PHP et XML-RPC, conversions de types

   +--------------------------+----------------+
   |Type PHP natif            |XML-RPC type    |
   +==========================+================+
   |integer                   |int             |
   +--------------------------+----------------+
   |Zend\Crypt_Math\BigInteger|i8              |
   +--------------------------+----------------+
   |double                    |double          |
   +--------------------------+----------------+
   |boolean                   |boolean         |
   +--------------------------+----------------+
   |string                    |string          |
   +--------------------------+----------------+
   |null                      |nil             |
   +--------------------------+----------------+
   |array                     |array           |
   +--------------------------+----------------+
   |associative array         |struct          |
   +--------------------------+----------------+
   |object                    |array           |
   +--------------------------+----------------+
   |Zend_Date                 |dateTime.iso8601|
   +--------------------------+----------------+
   |DateTime                  |dateTime.iso8601|
   +--------------------------+----------------+

.. note::

   **Comment est casté un tableau vide ?**

   Fournir un tableau vide à une méthode XML-RPC est problématique, car il peut être représenté sous la forme
   soit d'un tableau, soit d'une structure ("struct"). ``Zend\XmlRpc\Client`` détecte ce genre de conditions et
   fait une requête vers la méthode *system.methodSignature* du serveur pour déterminer le type XML-RPC
   approprié vers le quel casté.

   Cependant, ceci peut mener malgré tout à des soucis. Premièrement, les serveurs qui ne supportent
   *system.methodSignature* vont retourner une requête de type échec, et ``Zend\XmlRpc\Client`` résultera en un
   cast de la valeur de type tableau XML-RPC ("array"). De plus, ceci sous-entend que tout appel avec des arguments
   de type tableau entraîneront un appel additionnel au serveur distant.

   Pour désactiver entièrement la recherche, vous pouvez appeler la méthode ``setSkipSystemLookup()`` avant de
   réaliser votre appel XML-RPC :

   .. code-block:: php
      :linenos:

      $client->setSkipSystemLookup(true);
      $result = $client->call('foo.bar', array(array()));

.. _zend.xmlrpc.value.parameters.xmlrpc-value:

Objets Zend\XmlRpc\Value en tant que paramètres
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les paramètres peuvent aussi être des objets ``Zend\XmlRpc\Value`` qui spécifient alors exactement un type
XML-RPC. Les raisons principales d'utiliser un tel procédé sont :

   - Lorsque vous voulez être certain du type de paramètre (la méthode attend un entier et vous le récupérez
     sous forme de chaîne de caractères depuis une base de données).

   - Lorsque la méthode attend un type *base64* ou *dateTime.iso8601* (ceux-ci n'existant pas nativement dans le
     langage *PHP*).

   - Lorsque la conversion de types (cast) peut échouer (vous voulez passer une valeur XML-RPC vide comme
     paramètre. Mais les valeurs vides en *PHP* sont représentés sous forme de tableaux vides, or si vous passez
     un tableau vide à votre méthode *call*, il va être converti en un tableau XML-RPC, comme ce n'est pas un
     tableau associatif).



Deux manières existent pour créer des objets ``Zend\XmlRpc\Value``: instanciez une sous-classe
``Zend\XmlRpc\Value`` directement, ou utilisez une fabrique ("factory method") telle que
``Zend\XmlRpc\Value::getXmlRpcValue()``.

.. _zend.xmlrpc.value.parameters.xmlrpc-value.table-1:

.. table:: Objets Zend\XmlRpc\Value comme types XML-RPC

   +----------------+----------------------------------------+----------------------------+
   |XML-RPC Type    |Zend\XmlRpc\Value Constante             |Zend\XmlRpc\Value Objet     |
   +================+========================================+============================+
   |int             |Zend\XmlRpc\Value::XMLRPC_TYPE_INTEGER  |Zend\XmlRpc_Value\Integer   |
   +----------------+----------------------------------------+----------------------------+
   |i8              |Zend\XmlRpc\Value::XMLRPC_TYPE_I8       |Zend\XmlRpc_Value\BigInteger|
   +----------------+----------------------------------------+----------------------------+
   |ex:i8           |Zend\XmlRpc\Value::XMLRPC_TYPE_APACHEI8 |Zend\XmlRpc_Value\BigInteger|
   +----------------+----------------------------------------+----------------------------+
   |double          |Zend\XmlRpc\Value::XMLRPC_TYPE_DOUBLE   |Zend\XmlRpc_Value\Double    |
   +----------------+----------------------------------------+----------------------------+
   |boolean         |Zend\XmlRpc\Value::XMLRPC_TYPE_BOOLEAN  |Zend\XmlRpc_Value\Boolean   |
   +----------------+----------------------------------------+----------------------------+
   |string          |Zend\XmlRpc\Value::XMLRPC_TYPE_STRING   |Zend\XmlRpc_Value\String    |
   +----------------+----------------------------------------+----------------------------+
   |nil             |Zend\XmlRpc\Value::XMLRPC_TYPE_NIL      |Zend\XmlRpc_Value\Nil       |
   +----------------+----------------------------------------+----------------------------+
   |ex:nil          |Zend\XmlRpc\Value::XMLRPC_TYPE_APACHENIL|Zend\XmlRpc_Value\Nil       |
   +----------------+----------------------------------------+----------------------------+
   |base64          |Zend\XmlRpc\Value::XMLRPC_TYPE_BASE64   |Zend\XmlRpc_Value\Base64    |
   +----------------+----------------------------------------+----------------------------+
   |dateTime.iso8601|Zend\XmlRpc\Value::XMLRPC_TYPE_DATETIME |Zend\XmlRpc_Value\DateTime  |
   +----------------+----------------------------------------+----------------------------+
   |array           |Zend\XmlRpc\Value::XMLRPC_TYPE_ARRAY    |Zend\XmlRpc_Value\Array     |
   +----------------+----------------------------------------+----------------------------+
   |struct          |Zend\XmlRpc\Value::XMLRPC_TYPE_STRUCT   |Zend\XmlRpc_Value\Struct    |
   +----------------+----------------------------------------+----------------------------+

.. note::

   **Conversion automatique**

   Lorsque vous créez un objet ``Zend\XmlRpc\Value``, sa valeur est déterminée par un type *PHP*. Celui-ci va
   être converti vers le type désiré en utilisant le cast *PHP*. Par exemple si une chaîne de caractères est
   donnée comme valeur à un objet ``Zend\XmlRpc_Value\Integer``, elle sera alors convertie suivant la règle
   *(int)$value*.

.. _zend.xmlrpc.client.requests-and-responses:

Objet proxy du serveur
----------------------

Un autre moyen d'appeler des méthodes avec un client XML-RPC est d'utiliser le proxy du serveur. C'est un objet
*PHP* qui proxie un espace de nom XML-RPC, en fonctionnant autant que possible comme les objets *PHP*.

Pour instancier un proxy serveur, appelez ``getProxy()`` de ``Zend\XmlRpc\Client``. Elle retourne un objet
``Zend\XmlRpc_Client\ServerProxy``. Tout appel de méthode sur l'objet proxy sera proxié vers le serveur XML-RPC,
et les paramètres seront utilisés comme pour une méthode *PHP* banale.

.. _zend.xmlrpc.client.requests-and-responses.example-1:

.. rubric:: Proxy espace de nom par défaut

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   $service = $client->getProxy();
   // Proxy l'espace de nom par défaut

   $hello = $service->test->sayHello(1, 2);
   // test.Hello(1, 2) retourne "hello"

La méthode ``getProxy()`` reçoit un argument optionnel désignant l'espace de nom à utiliser par le proxy. Par
défaut, il s'agit de l'espace général, voici un exemple utilisant un espace de nom *test*:

.. _zend.xmlrpc.client.requests-and-responses.example-2:

.. rubric:: Proxy un espace de nom

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   $test  = $client->getProxy('test');
   // Proxy l'espace de nommage "test"

   $hello = $test->sayHello(1, 2);
   // test.Hello(1,2) retourne "hello"

Si le serveur distant supporte les espaces de noms imbriqués, alors le proxy les supportera. Par exemple, si le
serveur dans l'exemple ci-dessus acceptait les espaces de noms imbriqués, alors sa méthode *test.foo.bar()*
aurait pu être appelée via *$test->foo->bar()*.

.. _zend.xmlrpc.client.error-handling:

Gestion des erreurs
-------------------

Deux types d'erreurs peuvent être distingués : erreurs *HTTP*, ou erreurs XML-RPC. L'objet ``Zend\XmlRpc\Client``
reconnaît ces erreurs et fournit les moyens de les repérer et de les gérer.

.. _zend.xmlrpc.client.error-handling.http:

Erreurs HTTP
^^^^^^^^^^^^

Si une erreur *HTTP* survient, par exemple le serveur renvoie un *404 Not Found*, alors une
``Zend\XmlRpc_Client\HttpException`` sera levée.

.. _zend.xmlrpc.client.error-handling.http.example-1:

.. rubric:: Gérer les erreurs HTTP

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://foo/404');

   try {

       $client->call('bar', array($arg1, $arg2));

   } catch (Zend\XmlRpc_Client\HttpException $e) {

       // $e->getCode() retourne 404
       // $e->getMessage() retourne "Not Found"

   }

Quelque soit l'utilisation du client XML-RPC, une ``Zend\XmlRpc_Client\HttpException`` sera systématiquement
levée lorsqu'une erreur *HTTP* de quelque type que ce soit est rencontrée.

.. _zend.xmlrpc.client.error-handling.faults:

Erreurs XML-RPC (Faults)
^^^^^^^^^^^^^^^^^^^^^^^^

Une erreur XML-RPC peut être assimilée à une exception en *PHP*. C'est un type spécial retourné par une des
méthodes du client XML-RPC, et ce type contient un message, et un code d'erreur. Les erreurs XML-RPC seront
gérées différemment en fonction du contexte d'utilisation de l'objet ``Zend\XmlRpc\Client``.

Lors de l'utilisation de la méthode ``call()``, ou de l'objet proxy serveur, une erreur XML-RPC aura pour effet de
lancer une ``Zend\XmlRpc_Client\FaultException``. Le code et le message de l'exception seront rendus dans leurs
valeurs respectives de la réponse XML-RPC.

.. _zend.xmlrpc.client.error-handling.faults.example-1:

.. rubric:: Gérer les erreurs XML-RPC

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   try {

       $client->call('badMethod');

   } catch (Zend\XmlRpc_Client\FaultException $e) {

       // $e->getCode() retourne 1
       // $e->getMessage() retourne "Unknown method"

   }

En utilisant ``call()``, une exception ``Zend\XmlRpc_Client\FaultException`` sera donc lancée si une erreur
survient. Un objet ``Zend\XmlRpc\Response`` contenant l'erreur sera de même disponible via la méthode
``getLastResponse()``.

Lors de l'utilisation de la méthode ``doRequest()``, aucune exception ne sera levée si une erreur XML-RPC
survient. Simplement, l'objet ``Zend\XmlRpc\Response`` retourné contiendra l'erreur. Vérifiez-en l'état avec
``isFault()``.

.. _zend.xmlrpc.client.introspection:

Introspection du serveur
------------------------

Certains serveurs XML-RPC supportent l'introspection de leurs méthodes au travers de l'espace de noms *system.*
``Zend\XmlRpc\Client`` fournit un support d'un tel procédé.

Une instance de ``Zend\XmlRpc_Client\ServerIntrospection`` sera retournée si vous appelez la méthode
``getIntrospector()`` sur l'objet ``Zend_XmlRpcClient``.

.. _zend.xmlrpc.client.request-to-response:

De la requête à la réponse
--------------------------

Dans les faits, la méthode ``call()`` de ``Zend\XmlRpc\Client`` fabrique un objet ``Zend\XmlRpc\Request`` et
l'envoie à une méthode ``doRequest()``, qui retourne un objet de réponse ``Zend\XmlRpc\Response``.

La méthode ``doRequest()`` est disponible directement si besoin :

.. _zend.xmlrpc.client.request-to-response.example-1:

.. rubric:: Effectuer une requête et récupérer une réponse manuellement

.. code-block:: php
   :linenos:

   $client = new Zend\XmlRpc\Client('http://framework.zend.com/xmlrpc');

   $request = new Zend\XmlRpc\Request();
   $request->setMethod('test.sayHello');
   $request->setParams(array('foo', 'bar'));

   $client->doRequest($request);

   // $client->getLastRequest() retoure instanceof Zend\XmlRpc\Request
   // $client->getLastResponse() retourne instanceof Zend\XmlRpc\Response

Lorsqu'une méthode XML-RPC est appelée, quel qu'en soit le moyen, (``call()``, ``doRequest()`` ou proxy serveur),
le dernier objet de requête, et son homologue de réponse, seront toujours disponibles, au travers des appels à
``getLastRequest()`` et ``getLastResponse()``.

.. _zend.xmlrpc.client.http-client:

Client HTTP et tests
--------------------

Dans tous les exemples utilisés sur cette page, nous ne parlons jamais du client *HTTP*. Lorsque c'est
nécessaire, une instance de ``Zend\Http\Client`` sera créée par défaut et injectée dans ``Zend\XmlRpc\Client``
de manière automatique.

L'objet client *HTTP* peut être récupéré à tout moment grâce à la méthode ``getHttpClient()``.
``setHttpClient()`` permet d'injecter un objet ``Zend\Http\Client``.

``setHttpClient()`` est particulièrement utilisée pour les tests unitaires. Lorsque combinée avec
``Zend\Http\Client\Adapter\Test``, les services Web peuvent être déguisés (émulés) pour les tests. Voyez les
tests unitaires de ``Zend\XmlRpc\Client`` pour des exemples concrets.


