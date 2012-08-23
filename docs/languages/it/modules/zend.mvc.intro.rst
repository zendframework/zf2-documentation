.. EN-Revision: none
.. _zend.mvc.intro:

Introduzione al layer MVC
=========================

``Zend\Mvc`` è un completamente nuova implentazione MVC disegnata dalle fondamenta per Zend Framework 2.0. Il
punto chiave di questa implementazione sono le performance e la flessibilità.

L'apparato MVC è costruito sopra questi componenti:

- ``Zend\Di``, nello specifico la sua interfaccia ``LocatorInterface``, comunque il Dependency Injection Container
  (DiC).

- ``Zend\EventManager``

- ``Zend\Http``, nello specifico la richiesta e la risposta, che sono usate con:

- ``Zend\Stdlib\DispatchableInterface``; tutti i "controller" sono semplicemente deglio oggetti eseguibili
  (dispatchable objects)

Insieme al layer MVC molti altri sottocomponenti sono disponibili:

- ``Zend\Mvc\Router`` contiene le classi per gestire il routing delle richieste (l'atto di consegnare una richiesta
  ad un controller o un oggetto eseguibile (dispatchable))

- ``Zend\Mvc\PhpEnvironment``, un insieme di decorators per la richiesta (``Request``) e la risposta (``Response``)
  degli oggetti HTTP che garantiscono che la richiesta sia introdotta nel sistema (includendo parametri, variabili
  POST, gli header HTTP, etc.)

- ``Zend\Mvc\Controller``, un insieme di classi "controller" astratte che hanno delle responsabilità di base come
  il legare eventi, eseguire azioni, etc.

La porta di ingresso (gateway) per lo MVC è l'oggetto ``Zend\Mvc\Application`` (riferito semplicemente con il nome
della sua classe da qui in avanti ``Application``). La sua principale responsabilità è quella **instradare** le
richieste e di ricevere ed **eseguire** il controller richiesto. Una volta compiuto questo compito, ritorna una
risposta che può essere **inviata**.

.. _zend.mvc.intro.basic-application-structure:

Struttura base di una applicazione
----------------------------------

La struttura base di una applicazione è la seguente:


::

   application_root/
       config/
           application.config.php
       data/
       module/
       vendor/
       public/
           .htaccess
           index.php

Il file ``public/index.php`` esegue il lavoro di base come la configurazione primaria e la configurazione della
``Application``. Quando compiuto avvia (``run()``) l'``Application`` e invia (``send()``) la risposta ottenuta.

La directory ``config`` contiene tipicamente la configurazione utilizzata da ``Zend\Module\Manager`` in modo da
caricare i moduli e miscelare le configurazioni. Vedremo in dettaglio questa sezione successivamente.

La directory ``vendor`` dovrebbe contenere qualunque modulo o libreria con cui l'applicazione ha una dipendenza che
è sviluppata da parti terze. Questa potrebbe includere Zend Framework, librerie costruite dalla nostra aziend
oppure librerie da altri progetti di parti terze. Librerie e module posizionati in ``vendor`` non dovrebero essere
modificate direttamente nel progetto in quanto sono gestite esternamente.

Infine, la directory ``module`` conterrà uno o più module a cui sono consegnate funzionalità della nostra
applicazione.

Deleghiamo ai nostri module, questi sono l'unità elementare della nostra applicazione web.

.. _zend.mvc.intro.basic-module-structure:

Struttura base dei moduli
-------------------------

Un module puà contenere possibilmente qualunque cosa: codice PHP, incluse funzionalità MVC, librerie, view
scripts e/o assetti pubblici come immagini, CSS, JavaScript. Una delle richieste -- e anche questo è opzionale --
è che un module lavora con un namespace PHP e che questo contiene una class ``Module`` in questo namespace. Questa
classe allora sarà utilizzata da ``Zend\Module\Manager`` in modo da poter elaborare un certo numero di task.

La struttura raccomandata di un module è la seguente:


::

   module_root/
       Module.php
       autoload_classmap.php
       autoload_function.php
       autoload_register.php
       config/
           module.config.php
       public/
           images/
           css/
           js/
       src/
           <module_namespace>/
               <code files>
       tests/
           phpunit.xml
           bootstrap.php
           <module_namespace>/
               <test code files>
       views/
           <dir-named-after-a-controller/
               <.phtml files>

Finchè un module lavora come namespace, la directory radice dovrebbe essere quel namespace. Tipicamente questo
namespace includerà anche un prefisso di chi lo realizza (vendor name). Per esempio se realizziamo un module che
realizzi alcune funzionalità sugli "User" che è realizzato dalla Zend probabilmente dovrebbe chiamarsi "ZendUser"
e questo è anche il nome con cui dovrebbe chiamarsi la directory radice.

Il file ``Module.php`` messo nella directory radice sarà così nel namespace del modulo:

.. code-block:: php
   :linenos:

   namespace ZendUser;

   class Module
   {
   }

Di default se è definito un ``init()``, questo sarà invocat da un listener ``Zend\Module\Manager`` quando questo
caricherà la classe del module e passa un istanza del manager. Questo ti permette di realizzare task di
configurazione per il listener degli eventi specifici del modulo. Il metodo ``init()`` è chiamato **sempre** per
ogni richiesta e dovrebbe essere utilizzato **solo** per eseguire task molto leggeri come registrari eventi per i
listener.

Il tre ``autoload_*.php`` non sono richiesti ma fortemente consigliati. Loro realizzano:

- ``autoload_classmap.php`` dovrebbe ritornare un array che è una mappatura (classmap) di classi, in pratica
  coppie di nome/filename (con i nomi di file risolti con la costante magica ``__DIR__``).

- ``autoload_function.php`` dovrebbe ritornare un call PHP che può essere passato alla funzione
  ``spl_autoload_register()``. Tipicamente questo callback utilizza la "map" ritornata da ``autoload_filemap.php``.

- ``autoload_register.php`` dovrebbe registrare un callback PHP (tipicamente che viene ritornato da
  ``autoload_function.php`` con ``spl_autoload_register()``).

Il concetto di questi tre file è di fornire un meccanismo di defuault per l'autoloading delle classi contenute in
un modulo, realizzando in modo semplice un metodo per lavorare con un modulo senza richiedere ``Zend\Module`` (es.
esternamente da un applicazione ZF2).

La directory ``config`` dovrebbe contenere qualunque configurazione specifica del modulo. Questi file posso essere
in qualunque formato gestito da ``Zend\Config``. Raccomandiamo di chiamare la configurazione principale
"module.format" e per le configurazioni basate in PHP "module.config.php". Tipicamente creerai configurazioni per
il router allo stesso modo che per il dependency injector (iniettore delle dipendenze).

La directory ``src`` dovrebbe essere una `directory con struttura PSR-0 compatibile`_ con il codice sorgente del
tuo modulo. Tipicamente avrai almeno una sottodirectory chiamata con il namespace del tuo modulo, comunque puoi
"traghettare" il tuo codice con namespace multipli se lo desideri.

La directory ``tests`` dovrebbe contenere le tue unit tests. Tipicamente queste saranno scritte utilizzando
`PHPUnit`_, e conterranno artefatti collegati con le loro configurazioni (es. ``phpunit.xml``, bootstrap.php).

La directory ``public`` può essere utilizzata per contenere assetti che tu vuoi esporre nella tua applicazioni
come documenti. Possono essere file immagini, file CSS, file JavaScript, etc. Come questi saranno esposti è
lasciato allo sviluppatore.

La directory ``views`` contiene le viste (view scripts) collegati con i tuoi controller.

.. _zend.mvc.intro.bootstrapping-an-application:

Bootstrap di una Application
----------------------------

Una ``Application`` è composta da molti oggetti, ma in particolare interessano allo sviluppatore il Router ed il
Locator. Questi hanno sempre bisogno di essere configurati ed iniettati per avviare una ``Application``. Il
bootstrap consiste nel configurare ed iniettare il router, così come il locator.

Lo Zend Framework ha una implementazione del boostrap di default ``Zend\Mvc\Bootstrap``. Questa classe accetta una
istanza di ``Zend\Config\Config`` al suo costruttore, una volta che avete una istanza potete chiamare il metodo
``bootstrap()`` passandogli la ``Application``. Questa configurerà il tuo locator (utilizzando ``Zend\Di\Di`` di
default) ed il tuo router (utilizzando ``Zend\Mvc\Router\Http\TreeRouteStack`` di default).

Una volta assolti questi due compiti, sarà invocato l'evento "bootstrap" che è collegato all'istanza
``EventManager``. Questo permette ai tuoi moduli di collegari listeners e questi possono realizzare dei bootstrap
specifici per il tuo modulo (che potrebbero includere la registrazione delle ACL, configurare le cache oppure i
listener per i log, etc.).

L'utilizzo sarebbe il seguente:

.. code-block:: php
   :linenos:

   // Assuming $config is the merged config from all modules
   $bootstrap   = new Bootstrap($config);
   $application = new Application();
   $bootstrap->bootstrap($application);

A questo punto la tua ``Application`` è pronta per essere avviata:

.. code-block:: php
   :linenos:

   $response = $application->run();
   $response->send();

Il metodo ``run()`` esegue tipicamente quattro cose:

- Elabora l'oggetto ``Request``, controllando che questo sia completamente configurato sul sistema su cui si sta
  lavorando (questo include l'iniezione degli heder, query, parametri POST e molto altro).

- Esegue l'evento "route". Di default, il metodo ``route()`` della classe ``Application`` è registrato come un
  listener, ma tu puoi fornire dei tuoi listener per rimpiazzarlo o intercettarlo prima o dopo la sua esecuzione.

- Avvia l'evento "dispatch". Di default, il metodo ``dispatch()`` della classe ``Application`` è registrato come
  un listener, ma tu puoi fornire dei tuoi listener per rimpiazzarlo o intercettarlo prima o dopo la sua
  esecuzione.

- Elabora l'oggetto ``Response`` capace di inviarsi dalla risposta dell'evento "dispatch".

Noterai che hai un sacco di controllo sul tuo workflow. Utilizzando il sistema di priorità dell'EventManager puoi
intercettare gli eventi "route" e "dispatch" in ogni dove durante l'esecuzione, pemettendoti di veicolare i
workflow della tua applicazione secondo i tuoi bisogni.

.. _zend.mvc.intro.bootstrapping-a-modular-application:

Bootstrap di una applicazione modulare
--------------------------------------

Mentre l'approccio visto funzione bene, da dove viene la configurazione? Quando costruiamo una applicazione
modulare le informazioni nascono proprio dai moduli. Come possiamo prendere queste informazioni e aggregarle fra di
loro?

La risposta è tramite ``Zend\Module\Manager``. Questo componente ti permette di specificare dove esistono i
moduli, allora localizzerà tutti i moduli e li inizializzerà. Se la classe ``Module`` di un modulo ha il suo
``getConfig()``, questo risponderà con la configurazione e sarà mischiata con quella della applicazione. Suona
complicato? Non lo è.

.. _zend.mvc.intro.bootstrapping-a-modular-application.configuring-the-module-manager:

Configurare il Module Manager
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Il primo passo è configurare il module manager. Il modo più semplice per farlo è utilizzare la classe
``Zend\Module\Listener\DefaultListenerAggregate``. Quindi è sufficiente informare il module manager dei moduli da
caricare e attaccare il listener aggregate.

Ricordi il ``application.config.php`` di prima? Stiamo per andare a realizzare qualche configurazione.

.. code-block:: php
   :linenos:

   <?php
   // config/application.config.php
   return array(
       'modules' => array(
           /* ... */
       ),
       'module_listener_options' => array(
           'module_paths' => array(
               './module',
               './vendor',
           ),
       ),
   );

Come aggiungiamo moduli al sistema, aggiungiamo anche elementi all'array ``modules``.

Ora con il nostro ``public/index.php`` possiamo configurare il ``DefaultListenerAggregate``:

.. code-block:: php
   :linenos:

   use Zend\Module\Listener;

   $moduleConfig     = include __DIR__ . '/../configs/application.config.php';
   $listenerOptions  = new Listener\ListenerOptions($moduleConfig['module_listener_options']);
   $defaultListeners = new Listener\DefaultListenerAggregate($listenerOptions);

Una volta fatto, possiamo istanziare il nostro module manager:

.. code-block:: php
   :linenos:

   use Zend\Module\Manager as ModuleManager;

   $moduleManager = new ModuleManager(
       $moduleConfig['modules']
   );
   $moduleManager->getEventManager()->attachAggregate($defaultListeners);

Ogni classe ``Module`` ha la sua configurazione e la ``Application`` dovrebbe conoscere come è presente tramite il
metodo ``getConfig()``. Questo metodo deve ritornare un array oppure un oggetto di tipo ``Traversable`` come un
``Zend\Config\Config``. Un esempio:

.. code-block:: php
   :linenos:

   namespace ZendUser;

   class Module
   {
       public function getConfig()
       {
           return include __DIR__ . '/config/module.config.php'
       }
   }

.. _zend.mvc.intro.conclusion:

Conclusioni
-----------

Il layer ZF2 è incredibilmente flessibile, offrendo un punto di ingresso semplice per creare infrastrutture
modulari, così come fornire l'abilità di realizzare workflow personali della nostra applicazione tramite il
sistema EventManager. Il Bootstrap, largamente lasciato allo sviluppatore, è lineare e permette una semplice
metodologia per configurare l'applicazione e realizzare diverse "route" e servizi. Il module manager è di poco
rilevante impatto e con un approccio semplice forza una architettura modulare che incoraggia una pulita separazione
delle responsabilità ed il riutilizzo del codice.



.. _`directory con struttura PSR-0 compatibile`: https://github.com/php-fig/fig-standards/blob/master/accepted/PSR-0.md
.. _`PHPUnit`: http://phpunit.de
