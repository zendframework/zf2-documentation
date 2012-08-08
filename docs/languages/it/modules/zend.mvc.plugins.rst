.. EN-Revision: none
.. _zend.mvc.controller-plugins:

Controller Plugins
==================

Quando usi l'``AbstractActionController`` o ``AbstractRestfulController``, o se tu utilizzi il
``Zend\Mvc\Controller\PluginBroker`` nei tuoi controller custom, puoi avere accesso ad un numero di plugin
precostruiti. In aggiunta, puoi registrare dei tuoi plugin custom con il broker, sempre se vuoi con
``Zend\Loader\PluginBroker``.

I plugin precostruiti sono:

- ``Zend\Mvc\Controller\Plugin\FlashMessenger``

- ``Zend\Mvc\Controller\Plugin\Forward``

- ``Zend\Mvc\Controller\Plugin\Redirect``

- ``Zend\Mvc\Controller\Plugin\Url``

Se il tuo controller implementa l'interfaccia ``Zend\Loader\Pluggable``, puoi accedere a quei plugin utilizzando il
loro nome corto attraverso il metodo ``plugin()``:

.. code-block:: php
   :linenos:

   $plugin = $this->plugin('url');

Per un ulteriore strato di convenienza, entrambi i ``AbstractActionController`` e ``AbstractRestfulController``
hanno l'implementazione ``__call()`` che ti permette di ottenere i plugin attraverso le chiamate al metodo:

.. code-block:: php
   :linenos:

   $plugin = $this->url();

.. _zend.mvc.controller-plugins.flashmessenger:

Il FlashMessenger
-----------------

Il ``FlashMessenger`` è un plugin disegnato per creare e ricevere messaggi, basati sulla sessione, che "scadono"
da soli. Questo espone diversi metodi:

- ``setSessionManager()`` ti permette di specificare un sistema alternativo di session manager, se lo desideri.

- ``getSessionManager()`` ti permette di ricevere il session manager registrato.

- ``getContainer()`` ritorna l'instanza ``Zend\Session\Container`` dove sono salvati i messaggi del flash
  messenger.

- ``setNamespace()`` ti permette di specificare un namespace specifico nel container che ti permette di salvare e
  ricevere messaggi flash.

- ``getNamespace()`` ti permette di ricevere il nome del namespace dei messaggi flash.

- ``addMessage()`` ti permette di aggiungere un messaggio al namespace corrente del tuo session container.

- ``hasMessages()`` ti permette di determinare se sono presente messaggi flash dal namespace corrente nel session
  container.

- ``getMessages()`` ricevi i messaggi flash dal namespace corrente del tuo session controller.

- ``clearMessages()`` cancella tutti i messaggi nel namespsace corrente del tuo session container.

- ``hasCurrentMessages()`` indica se sono stati aggiunti dei messaggi durante la richiesta corrente.

- ``getCurrentMessages()`` riceve qualunque messaggi aggiunto durante la richiesta corrente.

- ``clearCurrentMessages()`` rimuove qualunque messaggi aggiunto durante la richiesta corrente.

In aggiunta, il ``FlashMessenger`` implementa sia ``IteratorAggregate`` che ``Countable``, permettendoti di iterare
i contenuti e contare i messaggi flash nel namespace corrente contenuti all'interno del tuo session container.

.. _zend.mvc.controller-plugins.examples:

Esempi
^^^^^^

.. code-block:: php
   :linenos:

   public function processAction()
   {
       // ... do some work ...
       $this->flashMessenger()->addMessage('You are now logged in.');
       return $this->redirect()->toRoute('user-success');
   }

   public function successAction()
   {
       $return = array('success' => true);
       $flashMessenger = $this->flashMessenger();
       if ($flashMessenger->hasMessages()) {
           $return['messages'] = $flashMessenger->getMessages();
       }
       return $return;
   }

.. _zend.mvc.controller-plugins.forward:

Il Forward Plugin
-----------------

Occasionalmente, vuoi eseguire controller addizionali a partire da un controller in uso -- per esempio, potresti
utilizzare questo approccio quando stai contruendo dei contenuti tipo "widget". Il ``Forward`` plugin ti aiuta a
lavorare su questo.

Per lavorare con il ``Forward`` plugin, il controller che lo chiame deve essere un ``LocatorAware``; altrimenti, il
plugin non sarà in grado di ricevere una configurata istanza del controller richiesto ed iniettarla.

Il plugin espone un solo metodo, ``dispatch()``, che accetta due argomenti:

- ``$name``, il nome del controller da invocare. Questo dovrebbe essere un nome di classe completamente
  identificabile, oppure un alias definito e riconoscibile dall'istanza Locator attaccata al controller invocante.

- ``$params`` è un array di parametri opzionale che mostra un oggetto ``RouteMatch`` specifico per la richiesta.

``Forward`` ritorna il risultato dell'esecuzione del controller richiesto; è compito dello sviluppatore
determinare cosa fare, se presente, con questa risposta. Una raccomandazione è di aggregare questa in un valore di
ritorno dal controller invocato.

Come per esempio:

.. code-block:: php
   :linenos:

   $foo = $this->forward()->dispatch('foo', array('action' => 'process'));
   return array(
       'somekey' => $somevalue,
       'foo'     => $foo,
   );

.. _zend.mvc.controller-plugins.redirect:

Il Redirect Plugin
------------------

Ridirezionamenti sono un'operazione tipica in una applicazione. Se viene realizzato manualmente, ci sarà bisogno
di fare questi step:

- Assemblare una URL utilizzando il router

- Creare ed iniettare un header "Location" all'interno dell'oggetto ``Response``, puntando all'URL assemblato.

- Impostare lo status code (codice di stato) dell'oggetto ``Response`` ad uno degli stati 3xx del protocollo HTTP.

Il ``Redirect`` plugin fa questo lavoro per te. Questo offre due metodi:

- ``toRoute($route, array $params = array(), array $options = array())``: Ridireziona verso una strada conosciuta,
  utilizzando i ``$params`` e ``$options`` forniti per assemblare un URL.

- ``toUrl($url)``: Semplicemente ridireziona verso una URL fornita.

In tutti i casi, l'oggetto ``Response`` è ritornato. Se rispondi con questo immediatamente, stai effettivamente
cortocircuitando l'esecuzione della richiesta.

Una nota: questo plugin richiede che il controller che lo invoca deve implementare ``InjectApplicationEvent``, e
così ha un ``MvcEvent`` composto, così come riceve il rute dall'oggetto evento.

Un esempio:

.. code-block:: php
   :linenos:

   return $this->redirect()->toRoute('login-success');

.. _zend.mvc.controller-plugins.url:

L'Url Plugin
------------

Spesso vuoi generare gli URL da una strada definita insieme ai tuoi controller -- per riuscire a realizzare una
view, generare gli header, etc. Finchè l'oggetto ``MvcEvent`` compone il router, farlo manualmente richiede questo
workflow:

.. code-block:: php
   :linenos:

   $router = $this->getEvent()->getRouter();
   $url    = $router->assemble($params, array('name' => 'route-name'));

L'helper ``Url`` fa qualcosa di più conveniente:

.. code-block:: php
   :linenos:

   $url = $this->url()->fromRoute('route-name', $params);

Il metodo ``fromRoute()`` è l'unico metodo pubblico, ed ha la seguente firma:

.. code-block:: php
   :linenos:

   public function fromRoute($route, array $params = array(), array $options = array())

Un'osservazione: questo plugin richiede che il controller che lo invoca implementi ``InjectApplicationEvent``,
così da avere un ``MvcEvent`` composto, così riceve il router da un oggetto evento.


