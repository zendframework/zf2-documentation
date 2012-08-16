.. EN-Revision: none
.. _migration.06:

Zend Framework 0.6
==================

Wenn man von einem älteren Release auf Zend Framework 0.6 oder höher hochrüstet sollte man die folgenden
Migrations Hinweise beachten.

.. _migration.06.zend.controller:

Zend_Controller
---------------

Die grundlegende Verwendung der *MVC* Komponenten hat sich nicht verändert; man kann immer noch das folgende
machen:

.. code-block:: php
   :linenos:

   require_once 'Zend/Controller/Front.php';
   Zend_Controller_Front::run('/path/to/controllers');

.. code-block:: php
   :linenos:

   /* -- Erstelle einen Router -- */
   $router = new Zend_Controller_RewriteRouter();
   $router->addRoute('user',
                     'user/:username',
                     array('controller' => 'user', 'action' => 'info')
   );

   /* -- Setze ihn im Controller -- */
   $ctrl = Zend_Controller_Front::getInstance();
   $ctrl->setRouter($router);

   /* -- Setze da Controller Verzeichnis und starte die Verarbeitung -- */
   $ctrl->setControllerDirectory('/path/to/controllers');
   $ctrl->dispatch();

Wir empfehlen die Verwendung des Response Objektes, um Inhalte und Header zu sammeln. Dies erlaubt den flexibleren
Wechsel von Ausgabeformaten (z.B. *JSON* oder *XML* statt *XHTML*) in deiner Applikation. Standardmäßig
verarbeitet ``dispatch()`` die Antwort, sendet Header und gibt die Inhalte aus. Man kann den Front Controller auch
auffordern, die Antwort durch ``returnResponse()`` zurückzugeben und die Antwort dann auf eigene Weise ausgeben.
Eine zukünftige Version des Front Controllers könnte die Verwendung des Response Objektes durch Output Buffering
erzwingen.

Es gibt viele weitere zusätzliche Funktionalitäten, welche die vorherige *API* erweitern. Diese sind in der
Dokumentation aufgeführt.

Die meisten Änderungen, die man beachten muss, betreffen das Erweitern der diversen Komponenten. Die wichtigsten
davon sind:

- ``Zend_Controller_Front::dispatch()`` fängt standardmäßig die Ausnahmen im Response Objekt ab und gibt sie
  nicht aus, um sicherzugehen, dass keine sensitiven Systeminformationen ausgegeben werden. Man kann dies auf
  mehrere Arten überschreiben:

  - Setzen von ``throwExceptions()`` im Front Controller:

    .. code-block:: php
       :linenos:

       $front->throwExceptions(true);

  - Setzen von ``renderExceptions()`` im Response Objekt:

    .. code-block:: php
       :linenos:

       $response->renderExceptions(true);
       $front->setResponse($response);
       $front->dispatch();

       // oder:
       $front->returnResponse(true);
       $response = $front->dispatch();
       $response->renderExceptions(true);
       echo $response;

- ``Zend_Controller_Dispatcher_Interface::dispatch()`` akzeptiert und gibt nun ein :ref:`Anfrage Objekt
  <zend.controller.request>` anstelle eines Dispatcher Token zurück.

- ``Zend_Controller_Router_Interface::route()`` akzeptiert und gibt nun ein :ref:`Anfrage Objekt
  <zend.controller.request>` anstelle eines Dispatcher Token zurück.

- ``Zend_Controller_Action`` Änderungen beinhalten:

  - Der Konstruktur akzeptiert nun genau drei Argumente, ``Zend_Controller_Request_Abstract`` ``$request``,
    ``Zend_Controller_Response_Abstract`` ``$response``, und ``Array`` ``$params`` (Optional).
    ``Zend_Controller_Action::__construct()`` verwendet diese, um die Request, Response und invokeArgs
    Eigenschaften für das Objekt zu setzen, und beim Überschreiben des Konstrukturs sollte man dies ebenfalls
    tun. Besser ist es, die ``init()`` Methode zu verwenden, um jedwede Instanzkonfiguration durchzuführen, weil
    diese Methode als letzte Methode des Konstrukturs aufgerufen wird.

  - ``run()`` ist nicht länger als final definiert, wird aber auch nicht länger vom Front Controller verwendet;
    sein einziger Zweck ist, dass die Klasse auch als Page Controller verwendet werden kann. Sie nimmt nun zwei
    optionale Argument an, ein ``Zend_Controller_Request_Abstract`` ``$request`` und ein
    ``Zend_Controller_Response_Abstract`` ``$response``.

  - ``indexAction()`` muss nicht mehr länger definiert werden, aber wird als Standardaktion empfohlen. Dies
    erlaubt dem RewriteRouter und den Action Controllern andere Standardaktionsmethoden zu definieren.

  - ``__call()`` sollte überschrieben werden, um jede undefinierte Aktion automatisch verarbeiten zu können.

  - ``_redirect()`` nimmt nun ein optionales zweites Argument entgegen, den *HTTP* Code, der mit dem Redirect
    zurückgegeben werden soll, und ein optionales drittes Argument ``$prependBase``, das angibt, dass die im
    Request Objekt registrierte Basis URL der übergebenen *URL* voran gestellt werden soll.

  - Die ``$_action`` Eigenschaft wird nicht mehr gesetzt. Diese Eigenschaft war ein
    ``Zend_Controller_Dispatcher_Token``, der in der aktuellen Inkarnation nicht mehr länger existiert. Der
    einzige Zweck des Tokens war, Informationen über angeforderte Controller, Aktion und *URL* Parameter bereit zu
    stellen. Diese Infrmationen ist nun im Request Objekt verfügbar und kann wie folgt abgerufen werden:

    .. code-block:: php
       :linenos:

       // Hole den angeforderten Controllernamen
       // Der Zugriff erfolgte bisher über: $this->_action->getControllerName().
       // Das Beispiel unten verwendet getRequest(), obwohl man auch direkt auf die
       // $_request Eigenschaft zugreifen kann; die Verwendung von getRequest() wird
       // empfohlen, da eine Elternklasse den Zugriff auf das Request Objekt
       // überschreiben könnte
       $controller = $this->getRequest()->getControllerName();

       // Hole den angeforderten Aktionsnamen
       // Der Zugriff erfolgte bisher über: $this->_action->getActionName().
       $action = $this->getRequest()->getActionName();

       // Hole die Anfrageparameter
       // Dies hat sich nicht verändert; die _getParams() und _getParam()
       // Methoden leiten nun einfach auf das Request Objekt weiter.
       $params = $this->_getParams();
       // fordere den 'foo' Parameter an und verwende
       // 'default', wenn kein Standardwert gefunden werden kann
       $foo = $this->_getParam('foo', 'default');

  - ``noRouteAction()`` wurde entfernt. Der geeignete Weg, um nicht vorhandene Aktionsmethoden abzufangen, wenn man
    sie an eine Standardaktion weiter leiten möchte, sollte die Verwendung von ``__call()`` sein:

    .. code-block:: php
       :linenos:

       public function __call($method, $args)
       {
           // Wenn eine nicht vorhandene 'Action' Methode angefordert wurde,
           // leite auf die Standard Aktionsmethode um:
           if ('Action' == substr($method, -6)) {
               return $this->defaultAction();
           }

           throw new Zend_Controller_Exception('Invalid method called');
       }

- ``Zend_Controller_RewriteRouter::setRewriteBase()`` wurde entfernt. Stattdessen soll
  ``Zend_Controller_Front::setBaseUrl()`` verwendet werden (oder ``Zend_Controller_Request_Http::setBaseUrl()``,
  wenn die Request Klasse verwendet wird).

- ``Zend_Controller_Plugin_Interface`` wurde durch ``Zend_Controller_Plugin_Abstract`` ersetzt. Alle Methoden
  nehmen nun ein :ref:`Request Objekt <zend.controller.request>` statt eines Dispatcher Tokens entgegen bzw. geben
  es zurück.


