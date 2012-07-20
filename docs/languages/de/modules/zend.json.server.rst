.. _zend.json.server:

Zend_Json_Server - JSON-RPC Server
==================================

``Zend_Json_Server`` ist eine `JSON-RPC`_ Server Implementierung. Sie unterstützt sowohl `die Spezifikation von
JSON-RPC Version 1`_ als auch die `Spezifikation der Version 2`_; zusätzlich bietet Sie eine *PHP* Implementierung
der `Spezifikation für Service Mapping Description (SMD)`_ Um Kunden von Services deren Metadaten anzubieten.

JSON-RPC ist ein leichgewichtiges Remoce Procedure Call Protokoll das *JSON* für seine Nachrichten verwendet.
Diese JSON-RPC Implementierung folgt *PHP*'s `SoapServer`_ *API*. Das bedeutet das in einer typischen Situation
einfach folgendes getan wird:

- Instanzieren des Server Objekts

- Eine oder mehrere Funktionen und/oder Klassen/Objekte dem Server Objekt hinzufügen

- Die Anfrage mit handle() ausführen

``Zend_Json_Server`` verwendet :ref:`Zend_Server_Reflection <zend.server.reflection>` um Reflektion durchzuführen
um den SMD zu erstellen und die Signaturen der Methodenaufrufe zu erzwingen. Als solche, ist es zwingend notwendig
das alle hinzugefügten Funktionen und/oder Klassenmethoden komplette *PHP* Docblocks dokumentiert haben mindestens
aber:

- Alle Parameter und deren erwarteter Variablentypen

- Den Variablentyp des Rückgabewertes

``Zend_Json_Server`` hört aktuell nur auf POST Anfragen; glücklicherweise bieten die meisten JSON-RPC Client
Implementierungen die zur aktuell vorhanden sind nur POST Anfragen. Das macht es einfach den gleichen Endpunkt des
Servers so zu verwenden das er beide Anfragen behandelt sowie die Service SMD liefert, wie im nächsten Beispiel
gezeigt.

.. _zend.json.server.usage:

.. rubric:: Zend_Json_Server Verwendung

Zuerst müssen wir eine Klasse definieren die wir über den JSON-RPC Server ausliefern wollen. Wir nennen die
Klasse 'Calculator', und definieren die Methoden 'add', 'substract', 'multiple', und 'divide':

.. code-block:: php
   :linenos:

   /**
    * Calculator - Einfache Klasse zur Auslieferung über JSON-RPC
    */
   class Calculator
   {
       /**
        * Summe von zwei Variablen zurückgeben
        *
        * @param  int $x
        * @param  int $y
        * @return int
        */
       public function add($x, $y)
       {
           return $x + $y;
       }

       /**
        * Differenz von zwei Variablen zurückgeben
        *
        * @param  int $x
        * @param  int $y
        * @return int
        */
       public function subtract($x, $y)
       {
           return $x - $y;
       }

       /**
        * Produkt von zwei Variablen zurückgeben
        *
        * @param  int $x
        * @param  int $y
        * @return int
        */
       public function multiply($x, $y)
       {
           return $x * $y;
       }

       /**
        * Division von zwei Variablen zurückgeben
        *
        * @param  int $x
        * @param  int $y
        * @return float
        */
       public function divide($x, $y)
       {
           return $x / $y;
       }
   }

Es ist zu beachten das jede Methode einen Docblock mit Einträgen besitzt die jeden Parameter und seinen Typ
beschreiben, sowie einen Eintrag für den Rückgabewert. Das ist **absolut kritisch** wenn ``Zend_Json_Server``
verwendet wird, oder auch jede andere Server Komponente für diesen Zweck im Zend Framework.

Erstellen wir also ein Skript um die Anfrage zu behandeln:

.. code-block:: php
   :linenos:

   $server = new Zend_Json_Server();

   // Zeigt welche Funktionalität vorhanden ist:
   $server->setClass('Calculator');

   // Behandelt die Anfrage:
   $server->handle();

Trotzdem behandelt das noch immer nicht das Problem der Rückgabe eines SMD damit der JSON-RPC Client die Methoden
selbstständig erkennen kann. Das kann getan werden indem die *HTTP* Anfragemethode erkannt wird, und anschließend
einige Metadaten des Servers spezifiziert werden:

.. code-block:: php
   :linenos:

   $server = new Zend_Json_Server();
   $server->setClass('Calculator');

   if ('GET' == $_SERVER['REQUEST_METHOD']) {
       // Zeigt den Endpunkt der URL, und die verwendete JSON-RPC Version:
       $server->setTarget('/json-rpc.php')
              ->setEnvelope(Zend_Json_Server_Smd::ENV_JSONRPC_2);

       // Den SMD holen
       $smd = $server->getServiceMap();

       // Den SMD an den Client zurückgeben
       header('Content-Type: application/json');
       echo $smd;
       return;
   }

   $server->handle();

Wenn der JSON-RPC Server mit dem Dojo Toolkit verwendet wird muß auch ein spezielles Kompatibilitätsflag gesetzt
werden um sicherzustellen das die zwei korrekt miteinander arbeiten:

.. code-block:: php
   :linenos:

   $server = new Zend_Json_Server();
   $server->setClass('Calculator');

   if ('GET' == $_SERVER['REQUEST_METHOD']) {
       $server->setTarget('/json-rpc.php')
              ->setEnvelope(Zend_Json_Server_Smd::ENV_JSONRPC_2);
       $smd = $server->getServiceMap();

       // Die Kompatibilität zu Dojo setzen:
       $smd->setDojoCompatible(true);

       header('Content-Type: application/json');
       echo $smd;
       return;
   }

   $server->handle();

.. _zend.json.server.details:

Fortgescrittene Details
-----------------------

Obwohl das meiste an Funktionalität für ``Zend_Json_Server`` in :ref:`diesem Abschnitt <zend.json.server.usage>`
beschrieben wurde, ist noch weitere fortgeschrittenere Funktionalität vorhanden.

.. _zend.json.server.details.zendjsonserver:

Zend_Json_Server
^^^^^^^^^^^^^^^^

``Zend_Json_Server`` ist die Kernklasse von JSON-RPC; die bearbeitet alle Anfragen und gibt den Antwort Payload
zurück. Sie hat die folgenden Methoden:

- ``addFunction($function)``: Spezifiziert eine benutzerdefinierte Funktion die dem Server hinzugefügt werden
  soll.

- ``setClass($class)``: Spezifiziert eine Klasse oder ein Objekt das dem Server hinzugefügt werden soll; alle
  öffentlichen Methoden dieses Elemente werden als JSON-RPC Methoden bekanntgegeben.

- ``fault($fault = null, $code = 404, $data = null)``: Erstellt und retourniert ein ``Zend_Json_Server_Error``
  Objekt.

- ``handle($request = false)``: Behandelt eine JSON-RPC Anfrage; optional kann ein ``Zend_Json_Server_Request``
  Objekt für die Anpassung übergeben werden (standardmäßig wird eines erstellt).

- ``getFunctions()``: Gibt eine Liste aller hinzugefügten Methoden zurück.

- ``setRequest(Zend_Json_Server_Request $request)``: Spezifiziert ein Anfrageobjekt um es für den Server zu
  verwenden.

- ``getRequest()``: Empfängt das Anfrageobjekt das vom Server verwendet wird.

- ``setResponse(Zend_Json_Server_Response $response)``: Setzt das Antwort Objekt das der Server verwendet.

- ``getResponse()``: Empfängt das Anfrageobjekt das vom Server verwendet wird.

- ``setAutoEmitResponse($flag)``: Zeigt ob der Server die Antworten und alle Header automatisch ausgeben sollte;
  standardmäßig ist sie ``TRUE``.

- ``autoEmitResponse()``: Stellt fest ob das automatische senden der Antwort eingeschaltet ist.

- ``getServiceMap()``: Empfängt die Service Map Description in der Form eines ``Zend_Json_Server_Smd`` Objekts

.. _zend.json.server.details.zendjsonserverrequest:

Zend_Json_Server_Request
^^^^^^^^^^^^^^^^^^^^^^^^

Die JSON-RPC Anfrageumgebung ist in ein ``Zend_Json_Server_Request`` Objekt eingekapselt. Diese Objekt erlaubt es
die notwendigen Teile der JSON-RPC Anfrage zu setzen, inklusive der Anfrage ID, Parametern, und der JSON-RPC
spezifischen Version. Es hat die Möglichkeit sich selbst über *JSON* zu laden oder ein Set von Optionen, und kann
sich selbst über die ``toJson()`` Methode als *JSON* darstellen.

Das Anfrage Objekt enthält die folgenden Methoden:

- ``setOptions(array $options)``: Spezifiziert die Konfiguration des Objektes. ``$options`` kann Schlüssel
  enthalten die jeglicher 'set' Methode entsprechen: ``setParams()``, ``setMethod()``, ``setId()`` und
  ``setVersion()``.

- ``addParam($value, $key = null)``: Fügt einen Parameter hinzu der mit einem Methodenaufruf verwendet wird.
  Parameter können nur Werte sein, oder optional auch den Parameternamen enthalten.

- ``addParams(array $params)``: Mehrere Parameter auf einmal hinzufügen; Ruft ``addParam()`` auf

- ``setParams(array $params)``: Setzt alle Parameter auf einmal; überschreibt jeden existierenden Parameter.

- ``getParam($index)``: Empfängt einen Parameter durch seine Position oder seinen Namen.

- ``getParams()``: Empfängt alle Parameter auf einmal.

- ``setMethod($name)``: Setzt die Methode die aufgerufen wird.

- ``getMethod()``: Empfängt die Methode die aufgerufen wird.

- ``isMethodError()``: Erkennt ob eine Anfrage fehlerhaft ist und einen Fehler produzieren würde, oder nicht.

- ``setId($name)``: Setzt den Identifikator der Anfrage (durch den Client verwendet um Anfragen auf Antworten
  abzubilden).

- ``getId()``: Empfängt den Anfrage Identifikator.

- ``setVersion($version)``: Setzt die Version der JSON-RPC Spezifikation der die Anfrage entspricht. Kann entweder
  '1.0' oder '2.0' sein.

- ``getVersion()``: Empfängt die Version der JSON-RPC Spezifikation die von der Anfrage verwendetwird.

- ``loadJson($json)``: Lädt das Anfrageobjekt von einem *JSON* String.

- ``toJson()``: Stellt den *JSON* String als Anfrage dar.

Eine *HTTP* spezifische Version ist über ``Zend_Json_Server_Request_Http`` vorhanden. Diese Klasse empfängt eine
Anfrage über ``php://input`` und erlaubt den Zugriff auf die rohen *JSON* Daten über die ``getRawJson()``
Methode.

.. _zend.json.server.details.zendjsonserverresponse:

Zend_Json_Server_Response
^^^^^^^^^^^^^^^^^^^^^^^^^

Der JSON-RPC Antwort Payload ist in ein ``Zend_Json_Server_Response`` Objekt gekapselt. Diese Objekt erlaubt es den
Rückgabewert der Anfrage zu setzen, ob die Antwort ein Fehler ist oder nicht, den Anfrageindentifikator, die
Version der JSON-RPC Spezifikation der die Antwort entspricht, und optional die Servicemap.

Das Antwortobjekt bietet die folgenden Methoden:

- ``setResult($value)``: Setzt das Ergebnis der Antwort.

- ``getResult()``: Empfängt das Antwortergebnis.

- ``setError(Zend_Json_Server_Error $error)``: Setzt ein Fehlerobjekt. Wenn es gesetzt wird, wird es als Antwort
  verwendet wenn *JSON* serialisiert wird.

- ``getError()``: Empfängt das Fehlerobjekt, wenn vorhanden.

- ``isError()``: Ob die Antwort eine Fehlerantwort ist oder nicht.

- ``setId($name)``: Setzt den Antwortindentifikator (damit der Client die Antwort mit der Originalanfrage in
  Verbindung bringt).

- ``getId()``: Empfängt den Antwortidentifikator.

- ``setVersion($version)``: Setzt die JSON-RPC Version der die Antwort entspricht.

- ``getVersion()``: Empfängt die JSON-RPC Version der die Antwort entspricht.

- ``toJson()``: Serialisiert die Antwort auf *JSON*. Wenn die Antwort eine Fehlerantwort ist, wird das Fehlerobjekt
  serialisiert.

- ``setServiceMap($serviceMap)``: Setzt das Servicemap Objekt für die Antwort.

- ``getServiceMap()``: Empfängt das Servicemap Objekt, wenn es vorhanden ist.

Eine *HTTP* spezifische Version ist über ``Zend_Json_Server_Response_Http`` vorhanden. Diese Klasse wird
entsprechende *HTTP* Header senden als auch die Antwort auf *JSON* zu serialisieren.

.. _zend.json.server.details.zendjsonservererror:

Zend_Json_Server_Error
^^^^^^^^^^^^^^^^^^^^^^

JSON-RPC hat ein spezielles Format für das Melden von Fehlerzuständen. Alle Fehler müssen mindestens, eine
Fehlermeldung und einen Fehlercode anbieten; optional können Sie zusätzliche Daten, wie ein Backtrace, anbieten.

Fehlercodes sind von jenen abgeleitet die vom `vom XML-RPC EPI Projekt`_ empfohlen werden. ``Zend_Json_Server``
fügt den richtigen Code basierend auf der Fehlerkondition zu. Für Anwendungsausnahmen wird der Code '-32000'
verwendet.

``Zend_Json_Server_Error`` bietet die folgenden Methoden:

- ``setCode($code)``: Setzt den Fehlercode: Wenn der Code nicht im akzeptierten Bereich der XML-RPC Fehlercodes
  ist, wird -32000 hinzugefügt.

- ``getCode()``: Empfängt den aktuellen Fehlercode.

- ``setMessage($message)``: Setzt die Fehlernachricht.

- ``getMessage()``: Empfängt die aktuelle Fehlernachricht.

- ``setData($data)``: Setzt zusätzliche Daten die den Fehler genauer qualifizieren, wie ein Backtrace.

- ``getData()``: Empfängt alle aktuellen zusätzlichen Fehlerdaten.

- ``toArray()``: Weist den Fehler einem Array zu. Das Array enthält die Schlüssel 'code', 'message' und 'data'.

- ``toJson()``: Weist den Fehler einer JSON-RPC Fehlerrepräsentation zu.

.. _zend.json.server.details.zendjsonserversmd:

Zend_Json_Server_Smd
^^^^^^^^^^^^^^^^^^^^

SMD steht für Service Mapping Description, ein *JSON* Schema das definiert wie ein Client mit einem speziellen Web
Service interagieren kann. Zu der Zeit wie das geschrieben wurde, wurde die `Spezifikation`_ noch nicht formell
ratifiziert, aber Sie ist bereits im Dojo Toolkit in Verwendung sowie in anderen JSON-RPC Kundenclients.

Grundsätzlich bezeichnet eine Service Mapping Description die Methode des Transports (POST, ``GET``, *TCP*/IP,
usw.), den Envelopetyp der Anfrage (normalerweise basierend auf dem Protokoll des Servers), die Ziel *URL* des
Service Providers, und eine Mappe der vorhandenen Services. Im Fall von JSON-RPC ist die Service Mappe eine Liste
von vorhandenen Methoden wobei jede Methode die vorhandenen Parameter und deren Typen beschreibt, sowie den
erwarteten Typ des Rückgabewerts.

``Zend_Json_Server_Smd`` bietet einen Objektorientierten Weg um Service Mappen zu erstellen. Grundsätzlich werden
Ihm Metadaten übergeben die den Service beschreiben indem Mutatoren verwendet und Services (Methoden und
Funktionen) spezifiziert werden.

Die Servicebeschreibungen selbst sind typischerweise Instanzen von ``Zend_Json_Server_Smd_Service``; man kann
genauso alle Informationen als Array an die verschiedenen Servicemutatoren in ``Zend_Json_Server_Smd`` übergeben,
und es wird für einen ein Serviceobjekt instanziieren. Die Serviceobjekte enthalten Informationen wie den Namen
des Services (typischerweise die Funktion oder den Methodennamen), die Parameter (Namen, Typen und Position), und
den Typ des Rückgabewerts. Optionen kann jedes Service sein eigenes Ziel und Envelope haben, obwohl diese
Funktionalität selten verwendet wird.

``Zend_Json_Server`` führt all das im Hintergrund durch, indem Reflektion auf den hinzugefügten Klassen und
Funktionen verwendet wird; man sollte seine eigenen Service Maps erstellen wenn man eigene Funktionalitäten
anbieten will welche die Introspektion von Klassen und Funktionen nicht bieten kann.

Die vorhandenen Methoden in ``Zend_Json_Server_Smd`` enthalten:

- ``setOptions(array $options)``: Erstellt ein SMD Objekt von einem Array an Optionen. Alle Mutatoren (Methoden die
  mit 'set' beginnen) können als Schlüssel verwendet werden.

- ``setTransport($transport)``: Setzt den Transport der für den Zugriff auf das Service verwendet werden soll;
  aktuell wird nur POST unterstützt.

- ``getTransport()``: Empfängt den aktuellen Transport des Services.

- ``setEnvelope($envelopeType)``: Setzt den aktuelle Anfrageenvelope der verwendet werden sollte um auf den Service
  zuzugreifen. Aktuell werden die Konstanten ``Zend_Json_Server_Smd::ENV_JSONRPC_1`` und
  ``Zend_Json_Server_Smd::ENV_JSONRPC_2`` verwendet.

- ``getEnvelope()``: Empfängt den aktuellen Anfrageenvelope.

- ``setContentType($type)``: Setzt den Contenttype den Anfragen verwenden sollten (standardmäßig ist das
  'application/json').

- ``getContentType()``: Empfängt den aktuellen Contenttype für Anfragen an den Service.

- ``setTarget($target)``: Setzt den aktuellen *URL* Endpunkt für den Service.

- ``getTarget()``: Empfängt den *URL* Endpunkt für den Service.

- ``setId($id)``: Tpischerweise ist das der *URL* Endpunkt des Services (der selbe wie das Ziel).

- ``getId()``: Empfängt die ServiceID (typischerweise der *URL* Endpunkt des Services).

- ``setDescription($description)``: Setzt eine Servicebeschreibung (typischerweise nähere Informationen die den
  Zweck des Services beschreiben).

- ``getDescription()``: Empfängt die Servicebeschreibung.

- ``setDojoCompatible($flag)``: Setzt ein Flag das indiziert ob das SMD mit dem Dojo Toolkit kompatibel ist oder
  nicht. Wenn es ``TRUE`` ist, dann ist das erzeugte *JSON* SMD so formatiert das es dem Format entspricht das
  Dojo's JSON-RPC Client erwartet.

- ``isDojoCompatible()``: Gibt den Wert des Dojokompatibilitätsflags zurück (Standardmäßig ``FALSE``).

- ``addService($service)``: Fügt ein Service der Mappe hinzu. Kann ein Array von Informationen sein die an den
  Konstruktor von ``Zend_Json_Server_Smd_Service`` übergeben werden, oder eine Instanz dieser Klasse.

- ``addServices(array $services)``: Fügt mehrere Services auf einmal hinzu.

- ``setServices(array $services)``: Fügt mehrere Serices auf einmal hinzu, und überschreibt alle vorher gesetzten
  Services.

- ``getService($name)``: Gibt ein Service durch seinen Namen zurück.

- ``getServices()``: Gibt alle hinzugefügten Services zurück.

- ``removeService($name)``: Entfernt ein Service von der Mappe.

- ``toArray()``: Weißt die Service Mappe einem Array zu.

- ``toDojoArray()``: Weißt die Service Mappe einem Array zu das mit dem Dojo Toolkit kompatibel ist.

- ``toJson()``: Weißt die Service Mappe einer *JSON* Repräsentation zu.

``Zend_Json_Server_Smd_Service`` hat die folgenden Methoden:

- ``setOptions(array $options)``: Setzt den Objektstatus durch ein Array. Jeder Mutator (Methoden die mit 'set'
  beginnen, kann als Schlüssel verwendet und über diese Methode gesetzt werden.

- ``setName($name)``: Setzt den Namen des Services (typischerweise die Funktion oder den Methodennamen).

- ``getName()``: Empfängt den Servicenamen.

- ``setTransport($transport)``: Setzt den Transport des Services (aktuell werden nur Transporte unterstützt die in
  ``Zend_Json_Server_Smd`` erlaubt sind).

- ``getTransport()``: Empfängt den aktuellen Transport.

- ``setTarget($target)``: Setzt den *URL* Endpunkt des Services (typischerweise ist das der selbe wir im gesamten
  SMD welchem der Service hinzugefügt wird).

- ``getTarget()``: Gibt den *URL* Endpunkt des Services zurück.

- ``setEnvelope($envelopeType)``: Setzt den Serviceenvelope (aktuell werden nur Envelopes unterstützt die in
  ``Zend_Json_Server_Smd`` erlaubt sind).

- ``getEnvelope()``: Empfängt den Typ des Serviceenvelopes.

- ``addParam($type, array $options = array(), $order = null)``: Fügt dem Service einen Parameter hinzu.
  Standardmäßig ist nur der Parametertyp notwendig. Trotzdem kann die Reihenfolge spezifiziert werden sowie auch
  Optionen wie:

  - **name**: Der Name des Parameters

  - **optional**: Ob der Parameter optional ist oder nicht

  - **default**: Ein Standardwert für diesen Parameter

  - **description**: Ein Text der den Parameter beschreibt

- ``addParams(array $params)``: Fügt verschiedene Parameter auf einmal hinzu; jeder Parameter sollte ein
  Assoziatives Array sein das mindestens den Schlüssel 'type' enthält welches den Typ des Parameters beschreibt,
  und optinal den Schlüssel 'order'; jeden andere Schlüssel wird als ``$options`` an ``addOption()`` übergeben.

- ``setParams(array $params)``: Setzt viele Parameter aus einmal, überschreibt alle aktuellen Parameter auf
  einmal.

- ``getParams()``: Empfängt alle aktuell gesetzten Parameter.

- ``setReturn($type)``: Setzt den Type des Rückgabewertes des Services.

- ``getReturn()``: Empfängt den Typ des Rückgabewertes des Services.

- ``toArray()``: Weist das Service an ein Array zu.

- ``toJson()``: Weist das Service einer *JSON* Repräsentation zu.



.. _`JSON-RPC`: http://groups.google.com/group/json-rpc/
.. _`die Spezifikation von JSON-RPC Version 1`: http://json-rpc.org/wiki/specification
.. _`Spezifikation der Version 2`: http://groups.google.com/group/json-rpc/web/json-rpc-1-2-proposal
.. _`Spezifikation für Service Mapping Description (SMD)`: http://groups.google.com/group/json-schema/web/service-mapping-description-proposal
.. _`SoapServer`: http://www.php.net/manual/en/class.soapserver.php
.. _`vom XML-RPC EPI Projekt`: http://xmlrpc-epi.sourceforge.net/specs/rfc.fault_codes.php
.. _`Spezifikation`: http://groups.google.com/group/json-schema/web/service-mapping-description-proposal
