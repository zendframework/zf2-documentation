.. _zend.di.quick-start:

Zend\\Di Quickstart
===================

Questa "QuickStart" ha come obiettivo quello di introdurre gli sviluppatori al componente Zend\\Di DiC. Comunemente
parlando, il codice non è mai semplice come in questo esempio, quindi approfondire questa sezione del manuale è
fortemente suggerita.

Assumi per un momento che hai la seguente parte di codice nella tua applicazione e che tu senti che è un buon
candidato per essere gestita dal DiC, dopo tutto, tu stai già iniettando tutte le tue dipendenze:

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

Con il codice sopra, dovrai legare ed utilizzare il codice scrivendo come segue:

.. code-block:: php
   :linenos:

   // l'oggetto $config è dichiarato precedentemente

   $dbAdapter = new MyLibrary\DbAdapter($config->username, $config->password);
   $movieFinder = new MyMovieApp\MovieFinder($dbAdapter);
   $movieLister = new MyMovieApp\MovieLister($movieFinder);
   foreach ($movieLister as $movie) {
       // cicla e visulizza $movie
   }

Se stai facendo come il codice sopra in ogni controller o vista dove vuoi listare i video, non solo è ripetitivo e
noioso da scrivere, ma anche non mantenibile se per esempio vuoi scambiare una di queste dipendenze su larga scala.

Dal momento che questo esempio di codice ha già delle buone pratiche di iniezione delle dipendenze, con la
iniezione nel costruttore, questo è un ottimo candidato per utilizzare Zend\\Di. L'utilizzo è semplice come:

.. code-block:: php
   :linenos:

       // da qualche parte nel bootstrap
       $di = new Zend\Di\Di();
       $di->instanceManager()->setParameters('MyLibrary\DbAdapter', array(
           'username' => $config->username,
           'password' => $config->password
       ));

       // dentro ogni controller
       $movieLister = $di->get('MyMovieApp\MovieLister');
       foreach ($movieLister as $movie) {
           // cicla e visualizza $movie
       }

Nell'esempio precedente, otteniamo l'istanza di default di Zend\\Di\\Di. Significa che Zend\\Di\\Di è costruita da
una DefinitionList con una RuntimeDefinition (utilizzando Reflection) e con una istanza vuota del manager e nessuna
configurazione. Qui vediamo il costruttore di Zend\\Di\\Di:

.. code-block:: php
   :linenos:

       public function __construct(DefinitionList $definitions = null, InstanceManager $instanceManager = null, Configuration $config = null)
       {
           $this->definitions = ($definitions) ?: new DefinitionList(new Definition\RuntimeDefinition());
           $this->instanceManager = ($instanceManager) ?: new InstanceManager();

           if ($config) {
               $this->configure($config);
           }
       }

Significa che quando $di->get() è invocato sarà consultata la RuntimeDefinition. Questa utilizza la reflection
per capire la struttura del codice. Finchè è nota la struttura del codice può collegare le dipendenze insieme ed
ecco come può legare gli oggetti per te. Zend\\Di\\Definition\\RuntimeDefinition utilizzerà i nomi dei parametri
nei metodi come nomi del parametro della classe. Questo è come l'username e la password sono mappati come primo e
secondo parametro, rispettivamente, del costrutture che li utilizza.

Se vuoi passare l'username e la password durante l'invocazione, questo si realizza passandoli come secondo
argomento della get():

.. code-block:: php
   :linenos:

       // dentro ogni controller
       $di = new Zend\Di\Di();
       $movieLister = $di->get('MyMovieApp\MovieLister', array(
           'username' => $config->username,
           'password' => $config->password
       ));
       foreach ($movieLister as $movie) {
           // cicla e visualizza $movie
       }

E' importante sottolineare che quando usi i parametri durante l'invocazione, i nomi dei parametri saranno applicati
ad ogni classe che accetta un parametro con lo stesso nome.

Chiamando $di->get(), questa istanza di MovieLister sarà automaticamente condivisa. Questi significa che chiamate
successive alla get() risponderanno la stessa istanza come nella precedente chiamata. Se desideri avere istanze
completamente diverse di MovieLister, puoi utilizzare $di->newInstance().


