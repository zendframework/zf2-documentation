.. EN-Revision: none
.. _zend.mvc.controllers:

Controller disponibili
======================

I controller del layer MVC semplicemente devono essere oggetti che implementano l'interfaccia
``Zend\Stdlib\DispatchableInterface``. Questa interfaccia descrive un singolo metodo:

.. code-block:: php
   :linenos:

   use Zend\Stdlib\DispatchableInterface;
   use Zend\Stdlib\RequestInterface as Request;
   use Zend\Stdlib\ResponseInterface as Response;

   class Foo implements DispatchableInterface
   {
       public function dispatch(Request $request, Response $response = null)
       {
           // ... do something, and preferably return a Response ...
       }
   }

Benchè questo pattern sia molto semplice, è probabile che tu non voglia cambiare implementare una logica
personalizzata per ogni controller (in particolare non è usuale per un singolo controller implementare diversi
tipi di richieste).

Lo MVC definisce molte interfacce che, quando sono implementate, possono fornire ai controller molte capacità
addizionali.

.. _zend.mvc.controllers.interfaces:

Interfacce comuni usate con i controller
----------------------------------------

.. _zend.mvc.controllers.interfaces.inject-application-event:

InjectApplicationEvent
^^^^^^^^^^^^^^^^^^^^^^

L'interfaccia ``Zend\Mvc\IbjectApplicationEvent`` informa l'instanza ``Application`` che dovrebbe iniettare il suo
``MvcEvent`` dentro il suo controller. Perchè potrebbe essere utile questo?

Ricorda che ``MvcEvent`` è composta da una serie di oggetti: la ``Request`` e ``Response``, ovvio, ma anche il
router, le strate trovate (l'instanza ``RouteMatch``) e potenzialmente anche il "risultato" dell'esecuzione.

Un controller che ha ``MvcEvent`` iniettata, allora può ricerverle ed iniettarle. Un esempio:

.. code-block:: php
   :linenos:

   $matches = $this->getEvent()->getRouteMatch();
   $id      = $matches->getParam('id', false);
   if (!$id) {
       $this->getResponse();
       $response->setStatusCode(500);
       $this->getEvent()->setResult('Invalid identifier; cannot complete request');
       return;
   }

L'interfaccia ``InjectApplicationEvent`` semplicemente definisce due metodi:

.. code-block:: php
   :linenos:

   use Zend\EventManager\EventDescription as Event;

   public function setEvent(Event $event);
   public function getEvent($event);

.. _zend.mvc.controllers.interfaces.locator-aware:

LocatorAware
^^^^^^^^^^^^

Nella maggior parte dei casi definirai i tuo controller e le dipendenze saranno iniettate tramite il Dependecy
Injection Container, attraverso gli argomenti del costruttore o i metodi setter.

Comunque, occasionalmente potresti avere oggetti che vorresti usare nel tuo controller che sono validi solo per
certe parti del codice. Per esempio includere form, paginatori, navigazione, etc. In questi casi potresti decidere
che non ha molto senso iniettare questi oggetti tutte le volte nel controller in uso.

L'interfaccia ``LocatorAware`` suggerisce alla ``Application`` dovrebbe iniettare la sua istanza Locator nel
controller (che sia un container DI oppure un Service Locator personalizzato). Semplicemente definendo due metodi:

.. code-block:: php
   :linenos:

   use Zend\Di\LocatorInterface;

   public function setLocator(LocatorInterface $locator);
   public function getLocator($locator);

.. _zend.mvc.controllers.interfaces.pluggable:

Pluggable
^^^^^^^^^

Riutilizzare il codice è un obiettivo comune per gli sviluppatori. Un altro obiettivo comune è la convenienza.
Comunque, questo è spesso difficile da raggiungere in modo pulito e astratto, nei sistemi generali.

All'interno dei tuoi controller, spesso ti accorgerai che ripeti operazioni tra un controller ad un altro. Esempi
tipici:

- Generazione degli URL

- Ridirezionamento

- Impostare e ricevere messaggi flash (messaggi che scadona soli sulla sessione)

- Invocazione ed esecuzione di controller addizionali

Per facilitare queste azioni mentre sono rese sempre disponibli ad altre implementazioni del controller, abbiamo
creato un implementazione ``PluginBroker`` per il layer del controller, ``Zend\Mvc\Controller\PluginBroken``
costruita sopra alle funzionalità di ``Zend\Loader\PluginBroken``. Per utilizzarla, semplicemente devi
implementare l'interfaccia ``Zend\Loader\Pluggable`` e configurare il tuo codice per usare una implementazione
specifica del controller di default:

.. code-block:: php
   :linenos:

   use Zend\Loader\Broker;
   use Zend\Mvc\Controller\PluginBroker;

   public function setBroker(Broker $broker)
   {
       $this->broker = $broker;
       return $this;
   }

   public function getBroker()
   {
       if (!$this->broker instanceof Broker) {
           $this->setBroker(new PluginBroker);
       }
       return $this->broker;
   }

   public function plugin($plugin, array $options = null)
   {
       return $this->getBroker()->load($plugin, $options);
   }

.. _zend.mvc.controllers.action-controller:

L'AbstractActionController
--------------------------

Implementare ognuna delle interfacce precedenti è molto ridondante; non avrete spesso voglia di farlo. Per questo
abbiamo sviluppato due controller base astratti e semplicemente puoi estenderli ed essere pronto per partire.

Il primo è ``Zend\Mvc\Controller\AbstractActionController``. Questo controller implementa ognuna delle interfacce
descritte precedentemente e usa le seguenti assuzioni:

- Un parametro "action" è atteso nell'oggetto ``RouteMatch`` composto ed attaccato nel ``MvcEvent``. Se non ne
  viene trovato nessuno, un ``notFoundAction()`` è invocato.

- Il parametro "action" è convertito nella forma camelCased (cammellata) ed appesa alla parola "Action" in modo da
  creare un nome del metodo. Ad esempio "foo" viene mappata a "fooAction", "foo-bar" o "foo.bar" oppure "foo_bar" a
  "fooBarAction". Il controller allora controlla se questo metodo esiste. Se non è presente il metodo
  ``notFoundAction()`` è invocato, altrimenti il metodo scoperto.

- I risultati di una esecuzione di una azione sono iniettati dentro la proprietà "result" del ``MvcEvent``
  (attraverso il metodo ``setResult()`` e disponibile attraverso ``getResult()``).

Essenzialmente, una mappatura della strada verso un ``AbstractActionController`` necessita di ritornare le chiavi
"controller" e "action" che combaciano.

La creazione degli action controller è principalmente semplice:

.. code-block:: php
   :linenos:

   namespace Foo\Controller;

   use Zend\Mvc\Controller\AbstractActionController;

   class BarController extends AbstractActionController
   {
       public function bazAction()
       {
           return array('title' => __METHOD__);
       }

       public function batAction()
       {
           return array('title' => __METHOD__);
       }
   }

.. _zend.mvc.controllers.action-controller.interfaces-and-collaborators:

Interfacce e collaboratori
^^^^^^^^^^^^^^^^^^^^^^^^^^

``AbstractActionController`` implementa ognuna di queste interfacce:

- ``Zend\Stdlib\DispatchableInterface``

- ``Zend\Loader\Pluggable``

- ``Zend\Mvc\InjectApplicationEvent``

- ``Zend\Mvc\LocatorAware``

In aggiunta è composto da ``Zend\EventManager\EventCollection``, esponendo i seguenti metodi

- ``setEventManager(EventCollection $events)``

- ``events()`` (restituisce l'``EventCollection`` attacato, ed un ``EventManager`` di default.

Di default creerà un ``EventManager`` che è in ascolto sui seguenti contesti:

- ``Zend\Stdlib\DispatchableInterface``

- ``Zend\Mvc\Controller\AbstractActionController``

In aggiunta, se estendi la classe, sarà in ascolto sul nome della classe che estende.

.. _zend.mvc.controllers.restful-controller:

Il AbstractRestfulController
----------------------------

Il secondo controller astratto che è fornito da ZF2 è ``Zend\Mvc\Controller\AbstractRestfulController``. Questo
controller fornisce una implementazione RESTful che semplicemente mappa le richieste HTTP nei metodi del controller
utilizzando la seguente matrice:

- **GET** mappa al metodo ``get()`` o ``getList()``, dipende se è presente o no il parametro "id" se trovato nella
  strada che combacia. Se è passato viene chiamato il metodo ``get()``; se no il metodo ``getList()`` viene
  chiamato. Nel primo caso, dovresti fornire una rappresentazione dell'id che è stato ottenuto; nell'altro
  dovresti fornire una lista di entità.

- **POST** mappato a ``create()``. Questo metodo si aspetta un argomento ``$data``, tipicamente nella variabile
  array superglobale ``$_POST``. Il dato dovrebbe esssere una nuova entità e la risposta dovrebbe tipicamente
  rispondere con un header HTTP 201 con l'header Location indicante l'URI della nuova entità create ed il body
  della risposta dovrebbe contenerne la rappresentazione.

- **PUT** mappa al metodo ``update()`` e richiede che un parametro id esista nella strada che viene combaciata;
  questo valore viene passato come argomento al metodo. Dovrebbe aspettarsi un aggiornamento dell'entita ottenuta,
  e, in caso di successo, ritornare un 200 o 202 header di risposta, come la rapresentazione dell'entità.

- **DELETE** mappa al metodo ``delete()`` e richiede che un parametro "id" esista nella strada che combacia; il
  valore passato p un argomento del metodo. Dovrebbe eseguire una cancellazione dell'entità ottenuta, e, in caso
  di successo rispondere con un header 200 o 204.

In aggiunta, puoi mappare metodi "action" nel ``AbstractRestfulController``, proprio come si farebbe
nell'``AbstractActionController``; questi metodi avranno il suffisso "Action", differenziandosi da metodi RESTful
descritti precendentemente. Questo ti permette di realizzare azioni come per esempio l'invio di form verso diversi
metodi RESTful o aggiungere metodi RPC alle tue API RESTful.

.. _zend.mvc.controllers.restful-controller.interfaces-and-collaborators:

Interfacce e collaboratori
^^^^^^^^^^^^^^^^^^^^^^^^^^

``AbstractRestfulController`` implementa ognuna delle seguenti interfacce:

- ``Zend\Stdlib\DispatchableInterface``

- ``Zend\Loader\Pluggable``

- ``Zend\Mvc\InjectApplicationEvent``

- ``Zend\Mvc\LocatorAware``

In aggiunta, è composto da , ``Zend\EventManager\EventCollection``, che espone i seguenti metodi:

- ``setEventManager(EventCollection $events)``

- ``events()`` (risponde con l'``EventCollection`` collegato, ed un ``EventManager`` di default.

Di default, crea un ``EventManager`` in ascolto sui seguenti contesti:

- ``Zend\Stdlib\DispatchableInterface``

- ``Zend\Mvc\Controller\AbstractRestfulController``

In aggiunta, puoi estendere la classe che sarà in ascolto sul nome della classe estesa.


