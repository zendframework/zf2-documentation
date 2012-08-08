.. EN-Revision: none
.. _zend.di.instancemanager:

Zend\\Di InstanceManager
========================

L'InstanceManager è responsabile per ogni informazione associata con Zend\\Di\\Di Dic a runtime. Questo significa
che le informazioni che vanno nell'instance manager sono specifiche per i bisogni dell'Application ed ancor più
per l'ambiente in cui l'applicazione è in azione.

.. _zend.di.instancemanager.parameters:

Parametri
---------

I parametri sono semplicemente dei punti di accesso per tutte le dipendenze o valori di configurazione delle
istanze. Una classe consiste in un grouppo di parametri, ognuno univocamente identificato. Quando scrivi le tue
classi, dovresti cercare di non utilizzare lo stesso nome di parametro due volte nella stessa classe quando pensi
che questo parametro sia usato sia per la configurazione dell'istanza che per un oggetto dipendente. Questo porta
ad un parametro ambiguo, questa situazione sarebbe meglio evitarla.

Nel nostro esempio di ricerca dei video (movie finder) possiamo ulteriormente analizzare questi concetti:

.. code-block:: php
   :linenos:

   namespace MyLibrary
   {
       class DbAdapter
       {
           protected $username = null;
           protected $password = null;
           public function __construct($username, $password)
           {
               $this->username = $username;
               $this->password = $password;
           }
       }
   }

   namespace MyMovieApp
   {
       class MovieFinder
       {
           protected $dbAdapter = null;
           public function __construct(\MyLibrary\DbAdapter $dbAdapter)
           {
               $this->dbAdapter = $dbAdapter;
           }
       }

       class MovieLister
       {
           protected $movieFinder = null;
           public function __construct(MovieFinder $movieFinder)
           {
               $this->movieFinder = $movieFinder;
           }
       }
   }

Nel precedente esempio, la classe DbAdapter ha 2 parametri: username e password; MovieFinder ha un parametro:
dbAdapter e MovieLister ha anche lei un parametro: movieFinder. Qualunque di questi può essere utilizzato per
l'iniziezione delle dipendenze o come valori scalabili durante la configurazione o durante l'invocazione.

Guardiamo il codice precedente, finchè i parametri di dbAdapter e di movieFinder sono entrambi fortemente
tipizzati con tipi concreti, il DiC può assumerli e riempirli con i giusti oggetti da solo. D'altra parte,
username e password non hanno un tipo definito e sono più simili a valori scalari. Finchè il DiC non può
riconoscere queste informazioni, devono essere forniti all'instance manager sotto forma di parametri. In questo
modo non si forza $di->get('MyMovieApp\\MovieLister') a lanciare un eccezione.

Il modo seguente usa i parametri disponibili:

.. code-block:: php
   :linenos:

   // setting instance configuration into the instance manager
   $di->instanceManager()->setParameters('MyLibrary\DbAdapter', array(
       'username' => 'myusername',
       'password' => 'mypassword'
   ));

   // forcing a particular dependency to be used by the instance manager
   $di->instanceManager()->setParameters('MyMovieApp\MovieFinder', array(
       'dbAdapter' => new MyLibrary\DbAdaper('myusername', 'mypassword')
   ));

   // passing instance parameters at call time
   $movieLister = $di->get('MyMovieApp\MovieLister', array(
       'username' => $config->username,
       'password' => $config->password
   ));

   // passing a specific instance at call time
   $movieLister = $di->get('MyMovieApp\MovieLister', array(
       'dbAdapter' => new MyLibrary\DbAdaper('myusername', 'mypassword')
   ));

.. _zend.di.instancemanager.preferences:

Preferenze
----------

In qualche caso potresti essere utilizzare delle interfacce come tipo al posto di classi concrete. Assumi che
nell'esempio dei video vi siano le seguenti modifiche:

.. code-block:: php
   :linenos:

   namespace MyMovieApp
   {
       interface MovieFinderInterface
       {
           // methods required for this type
       }

       class GenericMovieFinder
       {
           protected $dbAdapter = null;
           public function __construct(\MyLibrary\DbAdapter $dbAdapter)
           {
               $this->dbAdapter = $dbAdapter;
           }
       }

       class MovieLister
       {
           protected $movieFinder = null;
           public function __construct(MovieFinderInterface $movieFinder)
           {
               $this->movieFinder = $movieFinder;
           }
       }
   }

Come avrai notato, ora il tipo MovieLister semplicemente si aspetta l'iniezione di una dipendenza che implementa
l'interfaccia MovieFinderInterface. Questo permette implementazioni multiple di questa interfaccia da usare come
dipendenza, se questo è quello che l'utente decide di fare. Come puoi immaginare, Zend\\Di, non è in grado di
capire da solo quale dipendenza concreta deve essere configurata, per questo tipo di preferenza bisogna informare
l'instance manager.

Per passare questa informazioni all'instance manager, guarda il seguente codice:

.. code-block:: php
   :linenos:

   $di->instanceManager()->addTypePreference('MyMovieApp\MovieFinderInterface', 'MyMovieApp\GenericMovieFinder');
   // assuming all instance config for username, password is setup
   $di->get('MyMovieApp\MovieLister');

.. _zend.di.instancemanager.aliases:

Alias
-----

In certe situazioni potresti aver bisogno di un alias per una istanza. Ci sono due ragioni per fare questo
principalmente. Primo, vuoi semplicamente creare un'alternativa quando utilizzi il DiC al posto di usare l'intero
nome della classe. Secondo potresti accorgerti di aver bisogno lo stesso oggetto in due contesti separati. Questo
significa che quando fai l'alias di una classe specifica, allora puoi attaccare una specifica configurazione a
questo alias al posto di attacarla come configurazione del nome della classe.

Per mostrare questi punti, diamo un occhiata ad un caso d'uso dove abbiamo die DbAdapters separati, uno per le
operazioni di lettura ed un altro per le operazioni di scrittura:

Nota: Gli alias possono avere parametri registrati durante l'assegnazione.

.. code-block:: php
   :linenos:

   // assume the MovieLister example of code from the QuickStart

   $im = $di->instanceManager();

   // add alias for short naming
   $im->addAlias('movielister', 'MyMovieApp\MovieLister');

   // add aliases for specific instances
   $im->addAlias('dbadapter-readonly', 'MyLibrary\DbAdapter', array(
       'username' => $config->db->readAdapter->useranme,
       'password' => $config->db->readAdapter->password,
   ));
   $im->addAlias('dbadapter-readwrite', 'MyLibrary\DbAdapter', array(
       'username' => $config->db->readWriteAdapter>useranme,
       'password' => $config->db->readWriteAdapter>password,
   ));

   // set a default type to use, pointing to an alias
   $im->addTypePreference('MyLibrary\DbAdapter', 'dbadapter-readonly');

   $movieListerRead = $di->get('MyMovieApp\MovieLister');
   $movieListerReadWrite = $di->get('MyMovieApp\MovieLister', array('dbAdapter' => 'dbadapter-readwrite'));


