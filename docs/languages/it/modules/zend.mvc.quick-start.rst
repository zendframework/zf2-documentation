.. EN-Revision: none
.. _zend.mvc.quick-start:

Quick Start
===========

Ora che conosci le basi di come le applicazioni ed i moduli sono strutturati, vedremo il modo più semplice per
iniziare.

.. _zend.mvc.quick-start.install:

Installare la Zend Skeleton Application
---------------------------------------

Il modo più semplice per cominciare consiste nello scaricare l'applicazione di esempio ed i moduli. Per fare
questo dobbiamo seguire i seguenti passi.

.. _zend.mvc.quick-start.install.using-git:

Utilizzare Git
^^^^^^^^^^^^^^

Semplicemente cloniamo il repository ``ZendSkeletonApplication``, utilizziamo la opzione ``--recursive`` che
automaticamente prende anche ZF.

.. code-block:: php
   :linenos:

   prompt> git clone --recursive git://github.com/zendframework/ZendSkeletonApplication.git my-application

.. _zend.mvc.quick-start.install.manual-installation:

Manuale di installazione
^^^^^^^^^^^^^^^^^^^^^^^^

- Scarica il tarball del repository ``ZendSkeletonApplication``:

  - Zip: https://github.com/zendframework/ZendSkeletonApplication/zipball/master

  - Tarball: https://github.com/zendframework/ZendSkeletonApplication/tarball/master

- Decomprimi l'archivio che hai selezionato e rinomina la directory dandole il nome del tuo progetto; noi
  utilizzeremo "my-application" in tutto il documento.

- Installa Zend Framework, e se si ha la libreria nel proprio ``include_path``, crea un link simbolico nella
  cartella "library", oppure installala direttamente nella tua applicazione utilizzando Pyrus.

.. _zend.mvc.quick-start.create-a-new-module:

Crea un nuovo modulo
--------------------

Di default, un modulo è incluso nella ``ZendSketonApplication``, chiamato "Application". Questo contiene:

- Un "view listener" che esegue il render delle viste basate sul controller in uso e le inietta dentro il layout
  del sito.

È necessario modificare questi altri file qualora si volesse alterare la home page del tuo sito e/o la pagina di
errore.

Nuove funzionalità possono essere aggiunte creando nuovi moduli.

Per iniziare a sviluppare moduli raccomandiamo di utilizzare la ``ZendSkeletonModule`` come base. Scaricala da qui:

- Zip: https://github.com/zendframework/ZendSkeletonModule/zipball/master

- Tarball: https://github.com/zendframework/ZendSkeletonModule/tarball/master

Decomprimi il pacchetto e rinomina la directory "ZendSkeletonModule" per riflettere il nome del module che vuoi
creare; quando hai finito, muovi il module dentro il tuo nuovo progetto nella directory ``modules/``.

A questo punto è possibile di creare qualche funzionalità.

.. _zend.mvc.quick-start.update-the-module-class:

Aggiorare la classe Module
--------------------------

Semplicemente aggiornare la classe Module. Faremo attenzione che il namespace sia corretto, che la configurazione
sia abilitata e restituita e imposteremo l'autoloading sull'inizializzazione. Finchè siamo attivamente al lavoro
su questo modulo la lista delle classi sarà in continuo movimento e quindi dobbiamo essere particolarmente
flessibili sulla nostra strategia di autoloading, utilizziamo ``StandardAutoloader``. Per cominciare.

Prima di tutto lasciamo che ``autoload_classmap.php`` ritorni un array vuoto:

.. code-block:: php
   :linenos:

   <?php
   // autoload_classmap.php
   return array();

Modificheremo anche il nostro ``config/module.config.php`` come segue:

.. code-block:: php
   :linenos:

   return array(
       'view_manager' => array(
           'template_path_stack' => array(
               '<module-name>' => __DIR__ . '/../view'
           ),
       ),
   );

Al posto di "module-name" metti con solo caratteri minuscoli, separati dal trattino, il nome del tuo modulo --
esempio "ZendUser" diventerebbe "zend-user".

Dopo di che modifica il file ``Module.php`` come segue:

.. code-block:: php
   :linenos:

   namespace <your module name here>;

   use Zend\Module\Consumer\AutoloaderProvider;

   class Module implements AutoloaderProvider
   {
       public function getAutoloaderConfig()
       {
           return array(
               'Zend\Loader\ClassMapAutoloader' => array(
                   __DIR__ . '/autoload_classmap.php',
               ),
               'Zend\Loader\StandardAutoloader' => array(
                   'namespaces' => array(
                       __NAMESPACE__ => __DIR__ . '/src/' . __NAMESPACE__,
                   ),
               ),
           );
       }

       public function getConfig()
       {
           return include __DIR__ . '/config/module.config.php';
       }
   }

A questo punto hai il tuo "module" correttamente modificato. Ora passiamo al controller!

.. _zend.mvc.quick-start.create-a-controller:

Create un Controller
--------------------

I controller sono semplici oggetti che implementano ``Zend\Stdlib\Dispatchable``. Questo significa se semplicemente
devi implementare un ``dispatch()`` che prende un oggetto ``Response`` come argomento.

In pratica questo significherebbe scrivere la logica da gestire basata su una regola di routing per ogni
controller. Abbiamo creato due controller base su cui tu puoi cominciare:

- ``Zend\Mvc\Controller\ActionController`` permette il "match" di una "route" con un'azione. Quando si verifica un
  "match" un metodo verrà chiamato dal controller. Per esempio se hai una "route" che restituisce "foo" per
  l'azione, il metodo "fooAction" sarà quello invocato.

- ``Zend\Mvc\Controller\RestfulController`` analizza la Request per determinare quale metodo HTTP è stato
  utilizzato e chiama un metodo appropriato sulla base di questa analisi.

  - ``GET`` chiamerà il metodo ``getList()``, oppure, se viene scoperto un "id" durante il match di routing, il
    metodo ``get()`` ( l'identificatore passato come unico parametro).

  - ``POST`` chiamerà un metodo ``create()`` passando ``$_POST`` al primo parametro.

  - ``PUT`` si aspetta un "id" da confrontare durante il routing, chiamerà il metodo ``update()`` passando
    l'identificatore, e qualunque informazione trovata nel body della richiesta.

  - ``DELETE`` si aspetta un "id" che deve essere confrontato durante la fase di routing e chiamerà il metodo
    ``delete()``.

Per iniziare creeremo un controller in stile "hello world" con una singola azione. Iniziamo creando la directory
``src/<module name>/Controller/`` e creiamo il file ``HelloController.php`` al suo interno. Modifica il suo
contenuto:

.. code-block:: php
   :linenos:

   <?php
   namespace <module name>\Controller;

   use Zend\Mvc\Controller\ActionController;
   use Zend\View\Model\ViewModel;

   class HelloController extends ActionController
   {
       public function worldAction()
       {
           $request = $this->getRequest();
           $message = $request->query()->get('message', 'foo');
           return new ViewModel(array('message' => $message));
       }
   }

Bene, cosa stiamo facendo qui?

- Stiamo creando un action controller.

- Stiamo definendo un azione "world".

- Stiamo realizzando un messaggio utilizzando i parametri (si è assolutamente una pessima idea in ambiente di
  produzione!).

- Ritorniamo un array di valori che andreamo a processare dopo.

Stiamo ritornando un ``ViewModel``. Lo strato della vista utilizzerà tale oggetto per visualizarla produrre un
output tramite il template e le variabili assegnategli. Di default puoi omettere il nome del template e la logica
delle viste risolverà in automatico da "lowercase-controller-name/lowercase-action-name". Comunque puoi
sovrascrivere questa specifica con qualcosa di differente chiamando ``setTemplate()`` sulla instanza del
``ViewModel``. Tipicamnte, i template sono file con estensione ".phtml" nella cartella ``views`` del tuo modulo.

Bene, con questi concetti, creiamo la prima vista.

.. _zend.mvc.quick-start.create-a-view-script:

Creare una vista
----------------

Crea la cartella ``view/<module-name>hello``. Dentro questa directory , creiamo il file chiamato ``world.phtml``.
Dentro questo scriviamo il seguente codice quanto segue:

.. code-block:: php
   :linenos:

   <h1>Greetings!</h1>

   <p>You said "<?php echo $this->escape($message) ?>".</p>

Questo è tutto. Salviamo il file.

.. note::

   Che cosa è il metodo ``escape()``? Attualmente è un :ref:`view helper <zend.view.helpers>`, ed è disegnato
   per aiutarti a mitigare gli attacchi *XSS*. Mai fidarsi dell'input degli utenti, se non sei sicuro della
   sorgente di una variabile della tua vista, usa l'escaping.

.. _zend.mvc.quick-start.create-a-route:

Creare una "route"
------------------

Ora abbiamo un controller ed una vista, dobbiamo creare una "route" per queste.

.. note::

   ``ZendSkeletonApplication`` include una "route di base" che ti porta su questa azione. Questa "route" si compone
   come "/{controller}/{action}", che ti permette di specificare: "/zend-user-hello/world". Ora andremo a creare un
   strada solo per scopi illustrativi, creare "route" esplicite è una pratica raccomandata. L'applicazione cerca
   un'istanza ``Zend\Mvc\Router\RouteStack`` per configurare il "routing".Il router creato di default è
   ``Zend\Mvc\Router\Http\TreeRouteStack``.

In aggiunta dobbiamo informare l'applicazione che riguardo il controller a noi creato.

Apri il file ``configs/module.config.php`` e modificalo per aggiungere alle "routes" un array che sia come questo:

.. code-block:: php
   :linenos:

   return array(
       'routes' => array(
           '<module name>-hello-world' => array(
               'type'    => `Zend\Mvc\Router\Http\Literal`,
               'options' => array(
                   'route' => '/hello/world',
                   'defaults' => array(
                       'controller' => '<module name>-hello',
                       'action'     => 'world',
                   ),
               ),
           ),
       ),
       // ... di configuration ...
   );

Come prima, ``<module-name>`` deve essere modificato con la versione in caratteri minuscoli e separato da trattini.

Ora abbiamo una "route" per il nostro controller. Comunque, come può sapere quale controller andare ad eseguire?
``<module name>-hello`` è descrittivo ma non è il nome della classe. Ciò avviene tramite un cosiddetto \`alias`
che viene assegnato al controller.

.. _zend.mvc.quick-start.tell-the-application-about-our-module:

Informare l'applicazione del tuo modulo
---------------------------------------

Fin'ora non abbiamo mai spiegato alla nostra applicazione che è stato aggiunto un nuovo modulo!

Di default i moduli non sono analizzati finchè non viene detto a Zend\\ModuleManager di farlo. Quindi dobbiamo
notificare l'applicazione dell'esistenza del nostro modulo.

Ricordi il file ``config/application.config.php``? Modificalo aggiungendo il modulo. Una volta applicate le
modifiche, il file dovrebbe apparire come segue:

.. code-block:: php
   :linenos:

   <?php
   return array(
       'modules' => array(
           'Application',
           '<module namespace>',
       ),
       'module_listener_options' => array(
           'module_paths' => array(
               './module',
               './vendor',
           ),
       ),
   );

Rimpiazza ``<module namespace>`` con il namespace del tuo modulo.

.. _zend.mvc.quick-start.test-it-out:

Provalo!
--------

Siamo pronti per provare il tutto! Crea un nuovo "vhost" puntando la "document root" alla cartella ``public`` della
tua applicazione e attiva il tuo browser. Dovresti vedere una semplice pagina come questa:

.. code-block:: php
   :linenos:

   Module:     Application
   Controller: Index
   Action:     index

Ora ricarica l'URL appendendo il percorso "hello/world" all'indirizzo della pagina la pagina. Dovresti vedere il
seguente contenuto:

.. code-block:: html
   :linenos:

   <h1>Greetings!</h1>

   <p>You said "foo".</p>

Ora modifica ancora l'indirizzo aggiungendo "?message=bar" e ricarica la pagina. Dovresti ottenere:

.. code-block:: html
   :linenos:

   <h1>Greetings!</h1>

   <p>You said "bar".</p>

Congratulazioni! Hai appena creato il tuo primo modulo ZF2!



