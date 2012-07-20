.. _zend.mvc.routing:

Routing
=======

Il Routing è l'atto di far corrispondere ad una richiesta un preciso controller.

Tipicamente, il routing esaminerà la richiesta URI e si occuperà di fare il "match" dell'URI path sulle regole
configurate. Se il set di regole combacia allora un controller sarà eseguito. Il routing può essere utilizzato
per altre porzioni della richiesta URI o dell'ambiente -- Per esempio: lo schema o l'host, i parametri della query,
headers, metodo della chiesta e molto altro.

Il Routing è stato riscritto dalle fondamenta per Zend Framework 2.0. L'esecuzione è molto simile, ma
internamente lavora in modo molto più consistenza, performante e spesso semplice.

L'unità base del routing è una classe ``Route``:

.. code-block:: php
   :linenos:

   namespace Zend\Mvc\Router;

   use zend\Stdlib\RequestInterface as Request;

   interface Route
   {
       public static function factory(array $options = array());
       public function match(Request $request);
       public function assemble(array $params = array(), array $options = array());
   }

Una ``Route`` accatta una ``Request``, e determina se ne può fare il match. Se può, ritorna un oggetto
``RouteMatch``:

.. code-block:: php
   :linenos:

   namespace Zend\Mvc\Router;

   class RouteMatch
   {
       public function __construct(array $params);
       public function setParam($name, $value);
       public function merge(RouteMatch $match);
       public function getParam($name, $default = null);
       public function getRoute();
   }

Tipicamente quando una ``Route`` corrisponde, questa definisce uno o più parametri. Questi sono passati ad un
``RouteMatch``, altri oggetti possono chiedere a ``RouteMatch`` i suoi valori.

.. code-block:: php
   :linenos:

   $id = $routeMatch->getParam('id', false);
   if (!$id) {
       throw new Exception('Required identifier is missing!');
   }
   $entity = $resource->get($id);

Spesso avrai tante "route" che vorrai controllare. Per facilitare questa operazione puoi utilizzare un aggregatore
di "route", tipicamente implementando ``RouteStack``:

.. code-block:: php
   :linenos:

   namespace Zend\Mvc\Router;

   interface RouteStack extends Route
   {
       public function addRoute($name, $route, $priority = null);
       public function addRoutes(array $routes);
       public function removeRoute($name);
   }

Tipicamente, le "route" dovrebbero essere richieste in un ordine di tipo LIFO (Last In First Out [Il primo ad
entrare è il primo ad uscire][n.d.t.]), questa è la ragione dietro al nome ``RouteStack``. Zend Framework concede
due implementazione di questa interfaccia: ``SimpleRouteStack``, ``TreeRoueStack``. In ognuna, registri le "route"
una alla volta utilizzando il metodo ``addRoute()``, o in "bulk" usando ``addRoutes()``.

.. code-block:: php
   :linenos:

   // One at a time:
   $route = Literal::factory(array(
       'route' => '/foo',
       'defaults' => array(
           'controller' => 'foo-index',
           'action'     => 'index',
       ),
   ));
   $router->addRoute('foo', $route);

   $router->addRoutes(array(
       // using already instantiated routes:
       'foo' => $route,

       // providing configuration to allow lazy-loading routes:
       'bar' => array(
           'type' => 'literal',
           'options' => array(
               'route' => '/bar',
               'defaults' => array(
                   'controller' => 'bar-index',
                   'action'     => 'index',
               ),
           ),
       ),
   ));

.. _zend.mvc.routing.router-types:

Tipi di Router
--------------

Sono forniti due "router", il ``SimpleRouteStack`` e ``TreeRouteStack``. Ognuno lavoro con la precedente
interfaccia, ma utilizza differenti opzioni e path di esecuzione.

.. _zend.mvc.routing.router-types.simple-route-stack:

SimpleRouteStack
^^^^^^^^^^^^^^^^

Questo router semplicemente raccoglie le "route" individuali e ne fornisce la logica di confronto in uno step e
cicla attraverso questi element nell'ordine LIFO finchè un confronto non è positivo. Per questo, "route" positive
molto spesso dovrebbero essere regisdtrate per ultime e le "route" meno frequenti per prime. In aggiunta,
bisognerebbe essere sicuri che le "route" che potenzialmente sovrascrivono le "route" già registrate siano le più
specifiche possibili (es. registrate per ultime). In alternativa puoi fornire una priorità con un terzo parametro
al metodo ``addRoute()``, specificando la priorità oppure impostando la proprietà nell'instanza prima di
aggiungere una nuova route allo stack.

.. _zend.mvc.routing.router-types.tree-route-stack:

TreeRouteStack
^^^^^^^^^^^^^^

``Zend\Mvc\Router\Http\TreeRouteStack`` fornisce l'attitudine di registrare alberi di "route", e utilizzerà un
algoritmo B-tree (albero bilanciato [n.d.t.]) per confrontare le strade. Così puoi registrare una singola "route"
con molte "foglie".

Una ``TreeRouteStack`` consiste in una delle seguenti configurazioni:

- Una "route" di base, che descrive la base di confronto richiesta, la radice dell'albero.

- Un opzionale "route_broker", che è ``Zend\Mvc\Router\RouteBroker`` che può caricare in modo debole le strade
  (lazy-loading).

- L'opzione "may_terminate" che informa il router che non deve seguire altri segmenti.

- Un array opzionale "child_routes" che contiene le strade addizionali che partona dalla "route" base (es.
  costruite da questa). Ogni route "figlio" può essere a sua volta una ``TreeRouteStack`` se lo desideri, infatti
  la "route"``Part`` lavora esattamente in questo modo.

Quando una "route" confronta in positivo su un ``TreeRouteStack``, Il parametro di confronto per ogni segmento
dell'albero sarà ritornato.

Un ``TreeRouteStack`` può essere il tuo solo sistema di "route" per la tua applicazione, oppure può descriverne
particolari segmenti.

Un esempio di un ``TreeRouteStack`` è fornito nella documentazione della "route"``Part``.

.. _zend.mvc.routing.route-types:

Tipi di Route
-------------

Zend Framework 2.0 è fornito con i seguenti tipi di "route".

.. _zend.mvc.routing.route-types.hostname:

Zend\\Mvc\\Router\\Http\\Hostname
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La ``Hostname`` route cerca di far corrispondere un hostname registrato nella richista su uno specifico criterio.
Tipicamente sarà fornito in una delle seguenti forme:

- "subdomain.domain.tld"

- ":subdomain.domain.tld"

Nel precedente esempio, la seconda strada ritorna una chiave "subdomain" come parte della route confrontata.

Per ogni segmento hostname gestito puoi fornirne un obbligo. Per esempio, se il segmento "subdomain" deve iniziare
con "fw" e contenere esattamente due cifre, la seguente strada deve essere fornita:

.. code-block:: php
   :linenos:

   $route = Hostname::factory(array(
       'route' => ':subdomain.domain.tld',
       'constraints' => array(
           'subdomain' => 'fw\d{2}'
       ),
   ));

Nel precedente esempio solo la chiave "submodule" sarà ritornata nel ``RouteMatch``. Se vuoi puoi fornire altre
informazioni di base per il confronto, o se vuoi dei valori di default di ritorno per "subdomain" hai bisogno di
fornirli.

.. code-block:: php
   :linenos:

   $route = Hostname::factory(array(
       'route' => ':subdomain.domain.tld',
       'constraints' => array(
           'subdomain' => 'fw\d{2}'
       ),
       'defaults' => array(
           'type' => 'json',
       ),
   ));

Quando viene eseguito il "match", la regola precedente ritorna due chiavi nel ``RouteMatch``, "subdomain" e "type".

.. _zend.mvc.routing.route-types.literal:

Zend\\Mvc\\Router\\Http\\Literal
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La ``Literal`` è stata fatta per confrontare esattamente il segmento URI. La configurazione infatti è solo la
strada che vuoi confrontare, parametri di default o parametri che vuoi in ritorno sul "match".

.. code-block:: php
   :linenos:

   $route = Literal::factory(array(
       'route' => '/foo',
       'defaults' => array(
           'controller' => 'foo-index',
       ),
   ));

La precedente "route" confronta il path "/foo" e ritorna la chiave "controller" nel ``RouteMatch``, con il valore
"foo-index".

.. _zend.mvc.routing.route-types.part:

Zend\\Mvc\\Router\\Http\\Part
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Una "route"``Part`` permette di percorrere l'albero delle possibili strade basandosi su un segmento dell'URI path.
Questa attualmente estende il ``TreeRouteStack``.

"Route"``Part`` è difficile da descrivere, ne facciamo un esempio qui.

.. code-block:: php
   :linenos:

   $route = Part::factory(array(
       'route' => array(
           'type'    => 'literal',
           'options' => array(
               'route'    => '/',
               'defaults' => array(
                   'controller' => 'ItsHomePage',
               ),
           )
       ),
       'may_terminate' => true,
       'route_broker'  => $routeBroker,
       'child_routes'  => array(
           'blog' => array(
               'type'    => 'literal',
               'options' => array(
                   'route'    => 'blog',
                   'defaults' => array(
                       'controller' => 'ItsBlog',
                   ),
               ),
               'may_terminate' => true,
               'child_routes'  => array(
                   'rss' => array(
                       'type'    => 'literal',
                       'options' => array(
                           'route'    => '/rss',
                           'defaults' => array(
                               'controller' => 'ItsRssBlog',
                           ),
                       ),
                       'child_routes'  => array(
                           'sub' => array(
                               'type'    => 'literal',
                               'options' => array(
                                   'route'    => '/sub',
                                   'defaults' => array(
                                       'action' => 'ItsSubRss',
                                   ),
                               )
                           ),
                       ),
                   ),
               ),
           ),
           'forum' => array(
               'type'    => 'literal',
               'options' => array(
                   'route'    => 'forum',
                   'defaults' => array(
                       'controller' => 'ItsForum',
                   ),
               ),
           ),
       ),
   ));

Il precedente esempio confronta i seguenti:

- "/" carica il "ItsHomePage" controller

- "/blog" carica il "ItsBlog" controller

- "/blog/rss" carica il "ItsRssBlog" controller

- "/blog/rss/sub" carica il "ItsSubRss" controller

- "/forum" carica il"ItsForum" controller

Puoi usare qualunque tipo di "route" come strada figlio di una "route"``Part``.

.. _zend.mvc.routing.route-types.regex:

Zend\\Mvc\\Router\\Http\\Regex
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Una "route"``Regex`` utilizza una espressione regolare per confrontare un path URI. Qualunque espressione regolare
è permessa; la nostra raccomandazione è di usare i nomi da catturare di ogni valore che si vuole in ritorno
``RouteMatch``.

Le "route" basate sulle espressioni regolari sono spesso complesse, puoi specificare una "spec" o specifica da
usare quando costruisci un URL da una espressione regolare. La specifica è semplicemente una stringa, i
rimpiazzamenti sono identificati utilizzando "%keyname%" nella stringa, le chiavi per tutti i valori catturati o
parametri con il nome sono passati al metodo ``assemble()``.

Come tutte le altre "route", la "route"``Regex`` può accettare valori di default, ovvero parametri che vengono
inclusi nella risposta ``RouteMatch`` quando sono confrontati positivamente.

.. code-block:: php
   :linenos:

   $route = Regex::factory(array(
       'regex' => '/blog/(?<id>[a-zA-Z0-9_-]+)(\.(?<format>(json|html|xml|rss)))?',
       'defaults' => array(
           'controller' => 'blog-entry',
           'format'     => 'html',
       ),
       'spec' => '/blog/%id%.%format%',
   ));

La precedente si realizza con "/blog/001-some-blog_slug-here.html", e ritorna tre oggetti nel ``RouteMatch``: un
"id", un controller ed un "format". Quando assembli una URL da questa strada, l'id e il "format" dovranno essere
passati per riempire la specifica.

.. _zend.mvc.routing.route-types.scheme:

Zend\\Mvc\\Router\\Http\\Scheme
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

La "route"``Scheme`` confronta solo lo schema dello URI e devono essere esatti. Questa "route" e simile alla
"route"``Literal``, semplicemente prende quello che vuoi da confrontare ed i default, ovvero i parametri da
ritornare sul confronto.

.. code-block:: php
   :linenos:

   $route = Scheme::factory(array(
       'scheme' => 'https',
       'defaults' => array(
           'https' => true,
       ),
   ));

La precedente "route" confronta se lo schema "https" è presente, in questo caso sarà ritornata la chiave "https"
nel ``RouteMatch`` con un valore booleano ``true``.

.. _zend.mvc.routing.route-types.segment:

Zend\\Mvc\\Router\\Http\\Segment
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Una "route"``Segment`` permette di confrontare un qualunque segmento di un URI path. I segmenti sono delineati
dall'utilizzo della virgola, seguita da un carattere alfanumerico. Se un segmento è opzionale dovrà essere
inglobato dalle parentesi quadre. Un esempio: "/:foo[/:bar]" si realizza su un "/" seguito dal testo e assegnato ad
una chiave "foo"; se è presente un successivo carattere "/" un qualunque testo successivo sarà assegnato alla
chiave "bar".

La separazione tra "literal" e un nome del segmento può essere quanlunque cosa. Per esempio la precedente può
essere realizzata anche come: "/:foo{-}[-:bar]". La sequenza {-} dopo il parametro :foo indica un set di uno o più
delimitatori.

Ogni segmento può avere un obbligo associato. Ogni obbligo è semplicemente una espressione regolare che indica la
condizione sotto la quale il segmento deve rimanere.

Come per le altre "route", puoi indicare dei valori di default da utilizzare. Questi sono particolarmente utili
quando hai dei segmenti opzionali.

Un esempio complesso:

.. code-block:: php
   :linenos:

   $route = Segment::factory(array(
       'route' => '/:controller[/:action]',
       'constraints' => array(
           'controller' => '[a-zA-Z][a-zA-Z0-9_-]+',
           'action'     => '[a-zA-Z][a-zA-Z0-9_-]+',
       ),
       'defaults' => array(
           'controller' => 'application-index',
           'action'     => 'index',
       ),
   ));


