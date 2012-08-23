.. EN-Revision: none
.. _zend.xmlrpc.server:

Zend_XmlRpc_Server
==================

.. _zend.xmlrpc.server.introduction:

Introduction
------------

``Zend_XmlRpc_Server`` fournit un serveur XML-RPC qui suit les spécifications `dictées par www.xmlrpc.com`_. Il
fournit aussi la méthode *system.multicall()*, permettant le traitement de requêtes multiples.

.. _zend.xmlrpc.server.usage:

Usage de base
-------------

Voici un exemple d'utilisation basique :

.. code-block:: php
   :linenos:

   $server = new Zend_XmlRpc_Server();
   $server->setClass('My_Service_Class');
   echo $server->handle();

.. _zend.xmlrpc.server.structure:

Structures du serveur
---------------------

``Zend_XmlRpc_Server`` se décompose en un objet serveur (lui-même), un objet requête, réponse, et des objets
d'erreurs.

Pour démarrer un serveur ``Zend_XmlRpc_Server``, vous devez attacher une ou plusieurs classes ou fonctions au
serveur, grâce à ``setClass()`` et ``addFunction()``.

Lorsque c'est fait, vous pouvez passer un objet ``Zend_XmlRpc_Request`` à ``Zend_XmlRpc_Server::handle()``, sinon
par défaut il utilisera un objet ``Zend_XmlRpc_Request_Http`` qui récupérera la requête depuis *php://input*.

``Zend_XmlRpc_Server::handle()`` va alors essayer de traiter la requête. Cette méthode retournera un objet
``Zend_XmlRpc_Response`` ou ``Zend_XmlRpc_Server_Fault``. Tous deux possèdent une méthode ``__toString()`` qui
crée une réponse *XML* valide XML-RPC.

.. _zend.xmlrpc.server.anatomy:

Anatomy of a webservice
-----------------------

.. _zend.xmlrpc.server.anatomy.general:

General considerations
^^^^^^^^^^^^^^^^^^^^^^

For maximum performance it is recommended to use a simple bootstrap file for the server component. Using
``Zend_XmlRpc_Server`` inside a :ref:`Zend_Controller <zend.controller>` is strongly discouraged to avoid the
overhead.

Services change over time and while webservices are generally less change intense as code-native *APIs*, it is
recommended to version your service. Do so to lay grounds to provide compatibility for clients using older versions
of your service and manage your service lifecycle including deprecation timeframes.To do so just include a version
number into your *URI*. It is also recommended to include the remote protocol name in the *URI* to allow easy
integration of upcoming remoting technologies. http://myservice.ws/**1.0/XMLRPC/**.

.. _zend.xmlrpc.server.anatomy.expose:

What to expose?
^^^^^^^^^^^^^^^

Most of the time it is not sensible to expose business objects directly. Business objects are usually small and
under heavy change, because change is cheap in this layer of your application. Once deployed and adopted, web
services are hard to change. Another concern is *I/O* and latency: the best webservice calls are those not
happening. Therefore service calls need to be more coarse-grained than usual business logic is. Often an additional
layer in front of your business objects makes sense. This layer is sometimes referred to as `Remote Facade.`_. Such
a service layer adds a coarse grained interface on top of your business logic and groups verbose operations into
smaller ones.

.. _zend.xmlrpc.server.conventions:

Conventions
-----------

``Zend_XmlRpc_Server`` permet d'attacher des classes et/ou des fonctions au serveur XML-RPC. Grâce à
``Zend_Server_Reflection``, l'introspection va utiliser les blocs de commentaires pour déterminer les types
d'arguments et de réponse de la fonction/classe.

Les types XML-RPC n'ont pas forcément de correspondance native vers un type *PHP*. Le code fera de son mieux pour
deviner le type de données approprié, en se basant sur les valeurs listées dans les balises @param et @return.
Certains types XML-RPC n'ont par contre pas d'équivalent *PHP* direct, ils devront alors être spécifiés
manuellement sous forme de balises phpdoc :

- dateTime.iso8601, une chaîne formatée comme YYYYMMDDTHH:mm:ss

- base64, données encodées en base64

- struct, tableau associatif

Voici un exemple d'utilisation de type particulier:

.. code-block:: php
   :linenos:

   /**
   * This is a sample function
   *
   * @param base64 $val1 Base64-encoded data
   * @param dateTime.iso8601 $val2 An ISO date
   * @param struct $val3 An associative array
   * @return struct
   */
   function myFunc($val1, $val2, $val3)
   {}

PhpDocumentor ne vérifie (valide) pas les types des paramètres, mais les types sont obligatoires pour que le
serveur puisse lui, valider les paramètres passés aux appels des méthodes.

Il est parfaitement valide de spécifier plusieurs types pour les paramètres et les retours de méthodes. La
spécification XML-RPC suggère que system.methodSignature retourne un tableau des possibilités au regard des
paramètres d'entrée de la méthode, et de son type de sortie. Ceci ce fait grâce au caractère '\|' de
PhpDocumentor

.. code-block:: php
   :linenos:

   /**
   * This is a sample function
   *
   * @param string|base64 $val1 String or base64-encoded data
   * @param string|dateTime.iso8601 $val2 String or an ISO date
   * @param array|struct $val3 Normal indexed array or an associative array
   * @return boolean|struct
   */
   function myFunc($val1, $val2, $val3)
   {}

.. note::

   Attention toutefois, une signature multiple peut prêter à confusion au regard des personnes utilisant votre
   service. En général une fonction ne devrait posséder qu'une seule signature.

.. _zend.xmlrpc.server.namespaces:

Utiliser des espaces de noms (Namespaces)
-----------------------------------------

XML-RPC accepte le concept d'espace de noms, ce qui permet de grouper les méthodes XML-RPC. Ceci aide à prévenir
les collisions de noms (deux fonctions avec le même nom), de différentes classes. Par exemple le serveur XML-RPC
sert des méthodes dans l'espace "system" :

- system.listMethods

- system.methodHelp

- system.methodSignature

En interne la correspondance est faite avec les méthodes du même nom, de ``Zend_XmlRpc_Server``.

Si vous voulez ajouter un espace de noms aux méthodes que vous servez, procédez alors comme suit :

.. code-block:: php
   :linenos:

   // Toutes les méthodes publiques de My_Service_Class seront accessibles
   // via myservice.METHODNAME
   $server->setClass('My_Service_Class', 'myservice');

   // la fonction 'somefunc' sera accessible via funcs.somefunc
   $server->addFunction('somefunc', 'funcs');

.. _zend.xmlrpc.server.request:

Requêtes personnalisées
-----------------------

La plupart du temps, vous utiliserez l'objet de requête par défaut ``Zend_XmlRpc_Request_Http``, sans vous en
occuper. En revanche si vous avez un besoin spécifique, comme par exemple journaliser la requête, traiter une
requête CLI, GUI, ou autre environnement, vous devrez alors créer un objet étendant ``Zend_XmlRpc_Request``.
Implémentez les méthodes ``getMethod()`` et ``getParams()`` afin que le serveur puisse analyser ces informations
pour traiter la requête.

.. _zend.xmlrpc.server.response:

Réponses personnalisées
-----------------------

Comme avec les objets de requête, ``Zend_XmlRpc_Server`` peut retourner des objets de réponse personnalisés. Par
défaut il s'agit d'objets ``Zend_XmlRpc_Response_Http`` qui envoient un en-tête *HTTP* Content-Type *HTTP* pour
XML-RPC. Vous pourriez utiliser des objets de réponse personnalisés pour par exemple renvoyer les réponses vers
STDOUT, ou les journaliser.

Pour utiliser une classe de réponse personnalisée, utilisez ``Zend_XmlRpc_Server::setResponseClass()`` avant
d'appeler ``handle()``.

.. _zend.xmlrpc.server.fault:

Gérer les exceptions grâce aux erreurs (Faults)
-----------------------------------------------

``Zend_XmlRpc_Server`` attrape les Exceptions générées par vos classes/fonctions, et génère une réponse
XML-RPC "fault" lorsqu'une exception a été rencontrée. Par défaut, les message et code des exceptions ne sont
pas attachés dans la réponse XML-RPC. Ceci est du au fait que de telles exceptions peuvent en dire trop, au
regard de la sécurité de votre application.

Des classes d'exception peuvent cependant être mises en liste blanche, et donc utilisées pour les réponses
d'erreur ("fault"). Utilisez simplement ``Zend_XmlRpc_Server_Fault::attachFaultException()`` en lui passant une
classe d'exception :

.. code-block:: php
   :linenos:

   Zend_XmlRpc_Server_Fault::attachFaultException('My_Project_Exception');

Si vous héritez correctement vos exceptions, vous pouvez alors passer en liste blanche l'exception de plus bas
niveau, et ainsi accepter plusieurs types d'exceptions qui en hériteront. Évidemment, les
Zend_XmlRpc_Server_Exceptions sont elles automatiquement mises en liste blanche, afin de pouvoir traiter les
requêtes vers des méthodes inexistantes, ou toute autre erreur "générique".

Toute exception rencontrée, mais non mise en liste blanche, donnera naissance à une réponse d'erreur avec le
code "404" et le message "Unknown error".

.. _zend.xmlrpc.server.caching:

Cacher la définition du serveur entre les requêtes
--------------------------------------------------

Attacher beaucoup de classes au serveur XML-RPC peut consommer beaucoup de ressources, car l'introspection de
chaque classe/fonction est mise en place.

Pour améliorer les performances, ``Zend_XmlRpc_Server_Cache`` peut être utilisé pour mettre en cache la
définition d'un serveur. Combiné à ``__autoload()``, ceci améliore grandement les performances.

Un exemple d'utilisation :

.. code-block:: php
   :linenos:

   function __autoload($class)
   {
       Zend_Loader::loadClass($class);
   }

   $cacheFile = dirname(__FILE__) . '/xmlrpc.cache';
   $server = new Zend_XmlRpc_Server();

   if (!Zend_XmlRpc_Server_Cache::get($cacheFile, $server)) {
       require_once 'My/Services/Glue.php';
       require_once 'My/Services/Paste.php';
       require_once 'My/Services/Tape.php';

       $server->setClass('My_Services_Glue', 'glue');
       // espace de noms glue
       $server->setClass('My_Services_Paste', 'paste');
       // espace de noms paste
       $server->setClass('My_Services_Tape', 'tape');
       // espace de noms tape

       Zend_XmlRpc_Server_Cache::save($cacheFile, $server);
   }

   echo $server->handle();

L'exemple ci dessus essaye de récupérer la définition du serveur via le fichier ``xmlrpc.cache``. Si ceci
échoue, alors les classes nécessaires au service sont chargées, attachées au serveur, et une tentative de
création de cache est lancée.

.. _zend.xmlrpc.server.use:

Exemples d'utilisation
----------------------

Voici quelques exemples qui démontrent les diverses options disponibles pour un serveur XML-RPC.

.. _zend.xmlrpc.server.use.attach-function:

.. rubric:: Utilisation basique

L'exemple ci dessous attache une fonction au service XML-RPC.

.. code-block:: php
   :linenos:

   /**
    * Retourne le hash MD5 d'une valeur
    *
    * @param string $value Valeur à hasher
    * @return string Hash MD5 de la valeur
    */
   function md5Value($value)
   {
       return md5($value);
   }

   $server = new Zend_XmlRpc_Server();
   $server->addFunction('md5Value');
   echo $server->handle();

.. _zend.xmlrpc.server.use.attach-class:

.. rubric:: Attacher une classe

L'exemple ci dessous montre comment attacher les méthodes publiques d'une classe en tant que méthodes XML-RPC.

.. code-block:: php
   :linenos:

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb');
   echo $server->handle();

.. _zend.xmlrpc.server.use.attach-class-with-arguments:

.. rubric:: Attaching a class with arguments

The following example illustrates how to attach a class' public methods and passing arguments to its methods. This
can be used to specify certain defaults when registering service classes.

.. code-block:: php
   :linenos:

   class Services_PricingService
   {
       /**
        * Calculate current price of product with $productId
        *
        * @param ProductRepository $productRepository
        * @param PurchaseRepository $purchaseRepository
        * @param integer $productId
        */
       public function calculate(ProductRepository $productRepository,
                                 PurchaseRepository $purchaseRepository,
                                 $productId)
       {
           ...
       }
   }

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_PricingService',
                     'pricing',
                     new ProductRepository(),
                     new PurchaseRepository());

The arguments passed at ``setClass()`` at server construction time are injected into the method call
``pricing.calculate()`` on remote invokation. In the example above, only the argument *$purchaseId* is expected
from the client.

.. _zend.xmlrpc.server.use.attach-class-with-arguments-constructor:

.. rubric:: Passing arguments only to constructor

``Zend_XmlRpc_Server`` allows to restrict argument passing to constructors only. This can be used for constructor
dependency injection. To limit injection to constructors, call ``sendArgumentsToAllMethods`` and pass *false* as an
argument. This disables the default behavior of all arguments being injected into the remote method. In the example
below the instance of ``ProductRepository`` and ``PurchaseRepository`` is only injected into the constructor of
``Services_PricingService2``.

.. code-block:: php
   :linenos:

   class Services_PricingService2
   {
       /**
        * @param ProductRepository $productRepository
        * @param PurchaseRepository $purchaseRepository
        */
       public function __construct(ProductRepository $productRepository,
                                   PurchaseRepository $purchaseRepository)
       {
           ...
       }

       /**
        * Calculate current price of product with $productId
        *
        * @param integer $productId
        * @return double
        */
       public function calculate($productId)
       {
           ...
       }
   }

   $server = new Zend_XmlRpc_Server();
   $server->sendArgumentsToAllMethods(false);
   $server->setClass('Services_PricingService2',
                     'pricing',
                     new ProductRepository(),
                     new PurchaseRepository());

.. _zend.xmlrpc.server.use.attach-instance:

.. rubric:: Attaching a class instance

``setClass()`` allows to register a previously instantiated object at the server. Just pass an instance instead of
the class name. Obviously passing arguments to the constructor is not possible with pre-instantiated objects.

.. _zend.xmlrpc.server.use.attach-several-classes-namespaces:

.. rubric:: Attacher plusieurs classes grâce aux espaces de noms

L'exemple ci dessous montre comment attacher plusieurs classes grâce aux espaces de noms.

.. code-block:: php
   :linenos:

   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb', 'comb');
   // méthodes appelées sous la forme comb.*
   $server->setClass('Services_Brush', 'brush');
   // méthodes appelées sous la forme brush.*
   $server->setClass('Services_Pick', 'pick');
   // méthodes appelées sous la forme pick.*
   echo $server->handle();

.. _zend.xmlrpc.server.use.exceptions-faults:

.. rubric:: Spécifier les exceptions à utiliser en cas d'erreurs dans les réponses XML-RPC

L'exemple ci dessous montre comment spécifier les exceptions à utiliser en cas d'erreurs dans les réponses
XML-RPC.

.. code-block:: php
   :linenos:

   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Utilise les Services_Exception pour les erreurs
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb', 'comb');
   // méthodes appelées sous la forme comb.*
   $server->setClass('Services_Brush', 'brush');
   // méthodes appelées sous la forme brush.*
   $server->setClass('Services_Pick', 'pick');
   // méthodes appelées sous la forme pick.*
   echo $server->handle();

.. _zend.xmlrpc.server.use.custom-request-object:

.. rubric:: Utiliser un objet de requête personnalisé

Some use cases require to utilize a custom request object. For example, *XML/RPC* is not bound to *HTTP* as a
transfer protocol. It is possible to use other transfer protocols like *SSH* or telnet to send the request and
response data over the wire. Another use case is authentication and authorization. In case of a different transfer
protocol, one need to change the implementation to read request data.

L'exemple suivant montre comment utiliser un objet de requête personnalisé.

.. code-block:: php
   :linenos:

   require_once 'Services/Request.php';
   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Utilise les Services_Exception pour les erreurs
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb', 'comb');
   // méthodes appelées sous la forme comb.*
   $server->setClass('Services_Brush', 'brush');
   // méthodes appelées sous la forme brush.*
   $server->setClass('Services_Pick', 'pick');
   // méthodes appelées sous la forme pick.*

   // Crée un objet de requête
   $request = new Services_Request();

   echo $server->handle($request);

.. _zend.xmlrpc.server.use.custom-response-object:

.. rubric:: Utiliser un objet de réponse personnalisé

L'exemple suivant montre comment utiliser un objet de réponse personnalisé.

.. code-block:: php
   :linenos:

   require_once 'Services/Request.php';
   require_once 'Services/Response.php';
   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Utilise les Services_Exception pour les erreurs
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb', 'comb');
   // méthodes appelées sous la forme comb.*
   $server->setClass('Services_Brush', 'brush');
   // méthodes appelées sous la forme brush.*
   $server->setClass('Services_Pick', 'pick');
   // méthodes appelées sous la forme pick.*

   // Crée un objet de requête
   $request = new Services_Request();

   // Utilise une réponse personnalisée
   $server->setResponseClass('Services_Response');

   echo $server->handle($request);

.. _zend.xmlrpc.server.performance:

Optimisation des performances
-----------------------------

.. _zend.xmlrpc.server.performance.caching:

.. rubric:: Cache entre les requêtes

Les exemples suivants montrent comment gérer une politique de cache inter-requêtes.

.. code-block:: php
   :linenos:

   require_once 'Services/Request.php';
   require_once 'Services/Response.php';
   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Specifier un fichier de cache
   $cacheFile = dirname(__FILE__) . '/xmlrpc.cache';

   // Utilise les Services_Exception pour les erreurs
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();

   // Essaye de récupérer la définition du serveur via le cache
   if (!Zend_XmlRpc_Server_Cache::get($cacheFile, $server)) {
       $server->setClass('Services_Comb', 'comb');
       // méthodes appelées sous la forme comb.*
       $server->setClass('Services_Brush', 'brush');
       // méthodes appelées sous la forme brush.*
       $server->setClass('Services_Pick', 'pick');
       // méthodes appelées sous la forme pick.*

       // Sauve le cache
       Zend_XmlRpc_Server_Cache::save($cacheFile, $server));
   }

   // Crée un objet de requête
   $request = new Services_Request();

   // Utilise une réponse personnalisée
   $server->setResponseClass('Services_Response');

   echo $server->handle($request);

.. note::

   The server cache file should be located outside the document root.

.. _zend.xmlrpc.server.performance.xmlgen:

.. rubric:: Optimizing XML generation

``Zend_XmlRpc_Server`` uses ``DOMDocument`` of *PHP* extension *ext/dom* to generate it's *XML* output. While
*ext/dom* is available on a lot of hosts it is is not exactly the fastest. Benchmarks have shown, that
``XMLWriter`` from *ext/xmlwriter* performs better.

If *ext/xmlwriter* is available on your host, you can select a the ``XMLWriter``-based generator to leaverage the
performance differences.

.. code-block:: php
   :linenos:

   require_once 'Zend/XmlRpc/Server.php';
   require_once 'Zend/XmlRpc/Generator/XMLWriter.php';

   Zend_XmlRpc_Value::setGenerator(new Zend_XmlRpc_Generator_XMLWriter());

   $server = new Zend_XmlRpc_Server();
   ...

.. note::

   **Benchmark your application**

   Performance is determined by a lot of parameters and benchmarks only apply for the specific test case.
   Differences come from PHP version, installed extensions, webserver and operating system just to name a few.
   Please make sure to benchmark your application on your own and decide which generator to use based on **your**
   numbers.

.. note::

   **Benchmark your client**

   This optimization makes sense for the client side too. Just select the alternate *XML* generator before doing
   any work with ``Zend_XmlRpc_Client``.



.. _`dictées par www.xmlrpc.com`: http://www.xmlrpc.com/spec
.. _`Remote Facade.`: http://martinfowler.com/eaaCatalog/remoteFacade.html
