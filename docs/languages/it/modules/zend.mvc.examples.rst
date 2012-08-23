.. EN-Revision: none
.. _zend.mvc.examples:

Esempi
======

.. _zend.mvc.examples.controllers:

I Controller
------------

.. _zend.mvc.examples.controllers.accessing-the-request-and-response:

Accedere alle Request e Response (richieste e risposte)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Quando utilizzi ``AbstractActionController`` oppure ``AbstractRestfulController`` la gli oggetti richiesta e la
risposta sono costruiti direttamente dentro il controller prima dei chiamare il metodo ``dispatch()``. Puoi
accedere a queste variabili nei seguenti modi:

.. code-block:: php
   :linenos:

   // Using explicit accessor methods
   $request  = $this->getRequest();
   $response = $this->getResponse();

   // Using direct property access
   $request  = $this->request;
   $response = $this->response;

In aggiunta, il tuo controller implementa ``InjectApplicationEvent`` (come anche ``AbstractActionController`` e
``AbstractRestfulController`` fanno) e puoi accedere a questi oggetti dal collegamento con ``MvcEvent``

.. code-block:: php
   :linenos:

   $event    = $this->getEvent();
   $request  = $event->getRequest();
   $response = $event->getResponse();

Gli snippet precedenti possono essere utili quando componi gli event listener dentro al tuo controller.

.. _zend.mvc.examples.controllers.accessing-routing-parameters:

Accedere ai parametri di instradamento
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

I parametri di ritorno quando un intradamento è completo sono incapsulati in un oggetto
``Zend\Mvc\Router\RouteMatch``. Questo oggetto è spiegato in dettaglio nella sezione sull'instradamento (routing).

In aggiunta, il tuo controller implementa ``InjectApplicationEvent`` (come anche ``AbstractActionController`` e
``AbstractRestfulController`` fanno) e puoi accedere a questi oggetti dal collegamento con ``MvcEvent``

.. code-block:: php
   :linenos:

   $event   = $this->getEvent();
   $matches = $event->getRouteMatch();

Finchè hai l'oggetto ``RouteMatch``, puoi ricevere i parametri da lui.

.. _zend.mvc.examples.controllers.returning-early:

Returning early
^^^^^^^^^^^^^^^

Puoi effettivamente cortocircuitare l'esecuzione dell'applicazione ad un qualunque momento ritornando una
``Response`` fal tuo controller o da un qualunque evento. Quando un valore viene scoperto, si ferma una qualunque
esecuzione dell'event manager, una istanza ``Application`` bella e pronta viene immeditamente restituita.

Un esempio, il plugin ``Redirect`` ritorna una ``Response`` che può essere restituita immeditamente per completare
la richiesta il più in fretta possibile. Altri casi d'uso possono essere: la risposta di un JSON o di un XML da un
web service, ritornare "401 Forbidden", etc.

.. _zend.mvc.examples.bootstrapping:

Bootstrapping
-------------

.. _registering-module-specific-listeners:

Registrare listener specifici per un modulo
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Spesso si vogliono dei listener specifici per un modulo. Un esempio potrebbe essere un metodo semplice ed efficace
per introdurre le autorizzazioni, il logging oppure il caching nella tua applicazione.

Ogni class ``Module`` può avere un metodo ``init()`` opzionale. Tipicamente configurerai gli event listener per il
tuo modulo qui. Il metodo ``init()`` è chiamato per **ogni** modulo su **ogni** pagina richiesta e dovrebbe essere
utilizzato **solo** per eseguire compiti **leggeri** come registrare eventi nei listener.

La base della classe ``Bootstrap`` fornita con il framework ha un ``EventManager`` associato, un locator e un
istanza del router inizializzate, questo innesca l'evento "bootstrap", con i parametri "application" e "modules".

Quindi, un modo per risolvere i listener specifici per modulo è di mettersi in ascolto per quell'evento e di
registrare i listener in quel momento. Un esempio:

.. code-block:: php
   :linenos:

   namespace SomeCustomModule;

   use Zend\EventManager\StaticEventManager;

   class Module
   {
       public function init()
       {
           // Remember to keep the init() method as lightweight as possible
           $events = StaticEventManager::getInstance();
           $events->attach('bootstrap', 'bootstrap', array($this, 'registerListeners'));
       }

       public function registerListeners($e)
       {
           $application = $e->getParam('application');
           $config      = $e->getParam('config');
           $view        = $application->getLocator()->get('view');
           $view->headTitle($config['view']['base_title']);

           $listeners   = new Listeners\ViewListener();
           $listeners->setView($view);
           $application->getEventManager()->attachAggregate($listeners);
       }
   }

Questo dimostra molte cose. Primo, mostra come registrare un callback sull'evento "bootstrap" del bootstrap (con il
metodo ``init()``). Secondo, mostra che il listener e come può essere usato per registrare listener con
l'applicazione. Usa l'istanza ``Application`` come l'istanza del module manager. Dalla ``Application`` è capace di
attaccare il locator e dal ``Manager`` ne prende la configurazione. Questo sono spesso utilizzate per prendere la
vista, configurare alcuni helper e allora registrare un listener aggregato con l'event manager dell'applicazione.


