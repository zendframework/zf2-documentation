.. _zend.http.client.adapters:

Zend_Http_Client - Verbindungsadapter
=====================================

.. _zend.http.client.adapters.overview:

Verbindungsadapter
------------------

``Zend_Http_Client`` basiert auf einem Design mit Verbindungsadaptern. Der Verbindungsadapter ist das Objekt,
welches für die Ausführung der aktuellen Verbindung zum Server sowie für das Schreiben der Anfragen und Lesen
von Antworten verantwortlich ist. Dieser Verbindungsadapter kann ersetzt werden und man kann den Standard
Verbindungsadapter durch seinen eigenen Adapter erweitern, um ihn mit dem selben Interface auf seine eigenen
Bedürfnisse anzupassen, ohne dass man die gesamte *HTTP* Client Klasse erweitern oder ersetzen muss.

Derzeit stellt die ``Zend_Http_Client`` Klasse vier eingebaute Verbindungsadapter bereit:



   - ``Zend_Http_Client_Adapter_Socket`` (Standard)

   - ``Zend_Http_Client_Adapter_Proxy``

   - ``Zend_Http_Client_Adapter_Curl``

   - ``Zend_Http_Client_Adapter_Test``



Der Verbindungsadapter für das ``Zend_Http_Client`` Objekt wird durch Verwendung der 'adapter'
Konfigurationsoption gesetzt. Beim Instanzieren des Client Objektes kann man die 'adapter' Konfigurationsoption
setzen mit einem String, der den Adapternamen (z.B. 'Zend_Http_Client_Adapter_Socket') enthält, oder mit eine
Variable, die ein Adapterobjekt (z.B. ``new Zend_Http_Client_Adapter_Test``) enthält. Man kann den Adapter auch
danach setzen, indem man die ``Zend_Http_Client->setConfig()`` Methode verwendet.

.. _zend.http.client.adapters.socket:

Der Socket Adapter
------------------

Der Standard-Adapter ist ``Zend_Http_Client_Adapter_Socket``. Dieser wird benutzt, wenn kein anderer angegeben
wird. Der Socket Adapter benutzt die native *PHP* Funktion fsockopen(), um die Verbindung aufzubauen, dafür werden
keine besonderen Extensions oder Einstellungen benötigt.

Der Socket Adapter erlaubt verschiedene zusätzliche Konfigurations Optionen die gesetzt werden können durch
Verwendung von ``Zend_Http_Client->setConfig()`` oder deren Übergabe an den Konstruktor des Clients.



      .. _zend.http.client.adapter.socket.configuration.table:

      .. table:: Zend_Http_Client_Adapter_Socket Konfigurations Parameter

         +-------------+---------------------------------------------------------------------------------------------------+--------------+------------+
         |Parameter    |Beschreibung                                                                                       |Erwarteter Typ|Standardwert|
         +=============+===================================================================================================+==============+============+
         |persistent   |Ob eine persistente TCP Verbindung verwendet werden soll oder nicht                                |boolean       |FALSE       |
         +-------------+---------------------------------------------------------------------------------------------------+--------------+------------+
         |ssltransport |Der Transport Layer für SSL (z.B. 'sslv2', 'tls')                                                  |string        |ssl         |
         +-------------+---------------------------------------------------------------------------------------------------+--------------+------------+
         |sslcert      |Pfad zu einem PEM verschlüsselten SSL Zertifikat                                                   |string        |NULL        |
         +-------------+---------------------------------------------------------------------------------------------------+--------------+------------+
         |sslpassphrase|Die PassPhrase für die SSL zertifizierte Datei                                                     |string        |NULL        |
         +-------------+---------------------------------------------------------------------------------------------------+--------------+------------+
         |sslusecontext|Aktiviert das Proxy Verbindungen SSL verwenden sogar wenn die Proxy Verbindung selbst es nicht tut.|boolean       |FALSE       |
         +-------------+---------------------------------------------------------------------------------------------------+--------------+------------+



   .. note::

      **Persistente TCP Verbindungen**

      Die Verwendung persistenter *TCP* Verbindungen kann *HTTP* Anfragen potentiell schneller machen - aber in den
      meisten Fällen, wird es nur einen kleinen positiven Effekt haben und könnte den *HTTP* Server überladen zu
      dem man sich verbindet.

      Es wird empfohlen persistente *TCP* Verbindungen nur dann zu verwenden wenn man sich zu dem gleichen Server
      sehr oft verbindet, und man sicher ist das der Server eine große Anzahl an gleichzeitigen Verbindungen
      behandeln kann. In jedem Fall wird empfohlen das der Effekt von persistenten Verbindungen auf beiden, der
      Geschwindigkeit des Clients und dem Serverload gemessen wird bevor diese Option verwendet wird.

      Zusätzlich, wenn persistente Verbindungen verwendet werden, sollte man Keep-Alive *HTTP* Anfragen aktivieren
      wie im :ref:`Abschnitt für Konfiguration <zend.http.client.configuration>` beschrieben - andernfalls werden
      persistente Verbindungen nur wenig oder gar keinen Effekt haben.



   .. note::

      **HTTPS SSL Stream Parameter**

      ``ssltransport``, ``sslcert`` und ``sslpassphrase`` sind nur relevant wenn *HTTPS* für die Verbindung
      verwendet wird.

      Wärend die Standard *SSL* Einstellungen für die meisten Anwendungen funktionieren, kann es notwendig sein
      diese zu Ändern wenn der Server zu dem man sich verbindet ein spezielles Client Setup benötigt. Wenn dem so
      ist, sollte man das Kapitel über *SSL* Transport Layer und Optionen lesen das `hier`_ zu finden ist.



.. _zend.http.client.adapters.socket.example-1:

.. rubric:: Den Stream-Typen für eine HTTPS Verbindung einstellen

.. code-block:: php
   :linenos:

   // Konfigurationsparameter setzen
   $config = array(
       'adapter'      => 'Zend_Http_Client_Adapter_Socket',
       'ssltransport' => 'tls'
   );

   // Client-Instanz erzeugen
   $client = new Zend_Http_Client('https://www.example.com', $config);

   // Jetzt wird der Request über eine verschlüsselte Verbindung verschickt
   $response = $client->request();

Ein ähnliches Ergebnis erzielt man mit folgendem Code:

``fsockopen('tls://www.example.com', 443)``

.. _zend.http.client.adapters.socket.streamcontext:

Anpassen und Zugreifen auf den Socket Adapter Stream Kontext
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Beginnend mit Zend Framework 1.9 bietet ``Zend_Http_Client_Adapter_Socket`` direkten Zugriff auf den
darunterliegenden `Stream Kontext`_ der für die Verbindung zum entfernten Server verwendet wird. Das erlaubt es
Benutzern spezielle Optionen und Parameter an den *TCP* Stream zu übergeben und an den *SSL* Wrapper im Falle
einer *HTTPS* Verbindung.

Man kann auf den Stream Kontext zugreifen indem die folgenden Methoden von ``Zend_Http_Client_Adapter_Socket``
verwendet werden:



   - **setStreamContext($context)** Setzt den Stream Kontext der vom Adapter verwendet werden soll. Akzeptiert
     entweder eine Stream Kontext Ressource von durch die Verwendung der *PHP* Funktion `stream_context_create()`_
     erstellt wurde, oder ein Array von Stream Kontext Optionen im gleichen Format wie es an diese Funktion
     übergeben wird. Wenn ein Array übergeben wird, dann wird ein neuer Stream Kontext mit Hilfe dieser Optionen
     erstellt, und gesetzt.

   - **getStreamContext()** Empfängt den Stream Kontext des Adapters. Wenn kein Stream Kontext gesetzt ist, wird
     ein standardmäßiger Stream Kontext erstellt und zurückgegeben. Man kann anschließend den Wert
     verschiedener Kontext Optionen setzen oder empfangen indem die regulären *PHP* Stream Kontext Funktionen
     verwendet werden.



.. _zend.http.client.adapters.socket.streamcontext.example-1:

.. rubric:: Setzen von Stream Kontext Optionen für den Socket Adapter

.. code-block:: php
   :linenos:

   // Array von Optionen
   $options = array(
       'socket' => array(
           // Bindet die lokale Socket Seite an ein spezifisches Interface
           'bindto' => '10.1.2.3:50505'
       ),
       'ssl' => array(
           // Prüft das Server Side Zertifikat, akzeptiert keine
           // ungültigen oder selbst-signierten SSL Zertifikate
           'verify_peer' => true,
           'allow_self_signed' => false,

           // Holt das Peer Zertifikat
           'capture_peer_cert' => true
       )
   );

   // Erstellt ein Adapter Objekt und hängt es an den HTTP Client
   $adapter = new Zend_Http_Client_Adapter_Socket();
   $client = new Zend_Http_Client();
   $client->setAdapter($adapter);

   // Methode 1: Ein Options Array an setStreamContext() übergeben
   $adapter->setStreamContext($options);

   // Methode 2: Einen Stream Kontext erstellen und an setStreamContext() übergeben
   $context = stream_context_create($options);
   $adapter->setStreamContext($context);

   // Methode 3: Den Standardmäßigen Stream Kontext holen und Optionen auf Ihm setzen
   $context = $adapter->getStreamContext();
   stream_context_set_option($context, $options);

   // Jetzt die Anfrage durchführen
   $response = $client->request();

   // Wenn alles gut ging, kann auf den Kontext jetzt zugegriffen werden
   $opts = stream_context_get_options($adapter->getStreamContext());
   echo $opts['ssl']['peer_certificate'];

.. note::

   Es ist zu beachten das alle Stream Kontext Optionen gesetzt sein müssen bevor der Adapter Anfragen durchführt.
   Wenn kein Kontext gesetzt ist bevor *HTTP* Anfragen mit dem Socket Adapter durchgeführt werden, wird ein
   standardmäßiger Stream Kontext erstellt. Auf diese Kontext Ressource kann zugegriffen werden nachdem Anfragen
   durchgeführt werden indem die ``getStreamContext()`` Methode verwendet wird.

.. _zend.http.client.adapters.proxy:

Der Proxy Adapter
-----------------

Der Proxy Adapter ``Zend_Http_Client_Adapter_Proxy`` verhält sich wie der standard
``Zend_Http_Client_Adapter_Socket``, mit dem Unterschied, dass die Verbindung über einen *HTTP* Proxy-Server
aufgebaut wird statt den Server direkt zu kontaktieren. Das erlaubt die Verwendung von ``Zend_Http_Client`` hinter
Proxy Servern - was manchmal wegen der Sicherheit und Geschwindigkeit notwendig ist.

Der Proxy Adapter benötigt zusätzliche Konfigurationsvariablen, die nachfolgend gelistet sind.



      .. _zend.http.client.adapters.proxy.table:

      .. table:: Zend_Http_Client Konfigurationsparameter

         +----------+----------------------------------------------+--------+-------------------------------------------------+
         |Parameter |Beschreibung                                  |Datentyp|Beispielwert                                     |
         +==========+==============================================+========+=================================================+
         |proxy_host|Proxy Server Adresse                          |string  |zum Beispiel 'proxy.myhost.com' oder '10.1.2.3'  |
         +----------+----------------------------------------------+--------+-------------------------------------------------+
         |proxy_port|TCP Port des Proxy-Servers                    |integer |8080 (Standardwert) oder 81                      |
         +----------+----------------------------------------------+--------+-------------------------------------------------+
         |proxy_user|Benutzername für die Proxynutzung, falls nötig|string  |'wulli' oder '' für keinen Namen (Standardwert)  |
         +----------+----------------------------------------------+--------+-------------------------------------------------+
         |proxy_pass|Passwort für die Proxynutzung, falls nötig    |string  |'geheim' oder '' für kein Passwort (Standardwert)|
         +----------+----------------------------------------------+--------+-------------------------------------------------+
         |proxy_auth|Proxy HTTP Authentifizierungs-Typ             |string  |Zend_Http_Client::AUTH_BASIC (Standardwert)      |
         +----------+----------------------------------------------+--------+-------------------------------------------------+



proxy_host muss immer gesetzt werden, ansonsten wird der Proxy-Adapter auf ``Zend_Http_Client_Adapter_Socket``
zurückgreifen und keinen Proxy Server benutzen. Wird kein Prot mit übergeben, so versucht der Proxy-Adapter sich
auf den Standardport '8080' zu verbinden.

proxy_user und proxy_pass werden nur dann benötigt, wenn der Proxy-Server tatsächlich eine Authentifizierung
erwartet. Werden diese Parameter mit übergeben, setzt der Proxy-Adapter zusätzlich den 'Proxy-Authentication'
Header bei Anfragen. Wird keine Authentifizierung benötigt, sollten die beiden Parameter weggelassen werden.

proxy_auth setzt den Authentifizierungs-Typ. Dies ist nur nötig, wenn der Proxy-Server eine Authentifizierung
erwartet. Mögliche Werte entsprechen denen der Zend_Http_Client::setAuth() Methode. Zur Zeit wird nur die
BASIC-Authentifizierung (Zend_Http_Client::AUTH_BASIC) unterstützt.

.. _zend.http.client.adapters.proxy.example-1:

.. rubric:: Zend_Http_Client hinter einem Proxy-Server nutzen

.. code-block:: php
   :linenos:

   // Konfigurationsparameter setzen
   $config = array(
       'adapter'    => 'Zend_Http_Client_Adapter_Proxy',
       'proxy_host' => 'proxy.int.zend.com',
        'proxy_port' => 8000,
       'proxy_user' => 'shahar.e',
       'proxy_pass' => 'bananashaped'
   );

   // Client-Objekt instanziieren
   $client = new Zend_Http_Client('http://www.example.com', $config);

   // $client kann jetzt wie gewohnt benutzt werden

Wie vorher erwähnt, nutzt der Proxy-Adapter eine einfache Socket-Verbindung, wenn proxy_host nicht gesetzt oder
leer gelassen wurde. Dies ermöglicht die optionale Nutzung eines Proxy-Servers, abhängig von dem proxy_host
Parameter.

.. note::

   Da der Proxy Adapter von ``Zend_Http_Client_Adapter_Socket`` abgeleitet ist, kann die Stream Kontext
   Zugriffsmethode verwendet werden (siehe :ref:`den Abschnitt für Konfiguration
   <zend.http.client.adapters.socket.streamcontext>`) um Stream Kontext Optionen auf Proxy Verbindungen zu setzen
   wie es oben demonstriert wurde.

.. _zend.http.client.adapters.curl:

Der cURL Adapter
----------------

cURL ist eine Standard *HTTP* Client Bibliothek die mit vielen Betriebssystemen ausgeliefert wird, und kann in
*PHP* über die cURL Erweiterung verwendet werden. Sie bietet Funktionalitäten für viele spezielle Fälle die
für einen *HTTP* Client auftreten können und machen sie zu einer perfekten Wahl für einen *HTTP* Adapter. Sie
unterstützt sichere Verbindungen, Proxies, alle Arten von Authentifizierungsmechanismen und glänzt in Anwendungen
die große Dateien zwischen Servern bewegen müssen.

.. _zend.http.client.adapters.curl.example-1:

.. rubric:: Setzen von cURL Optionen

.. code-block:: php
   :linenos:

   $config = array(
       'adapter'   => 'Zend_Http_Client_Adapter_Curl',
       'curloptions' => array(CURLOPT_FOLLOWLOCATION => true),
   );
   $client = new Zend_Http_Client($uri, $config);

Standardmäßig ist der cURL Adapter so konfiguriert das er sich genauso wie der Socket Adapter verhält und er
akzeptiert auch die gleichen Konfigurationsparameter wie die Socket und Proxy Adapter. Man kann die cURL Optionen
entweder durch den 'curloptions' Schlüssel im Konstruktor des Adapters, oder durch den Aufruf von
``setCurlOption($name, $value)``, verändern. Der ``$name`` Schlüssel entspricht den CURL_* Konstanten der cURL
Erweiterung. Man kann auf den CURL Handler durch den Aufruf von ``$adapter->getHandle();`` Zugriff erhalten.

.. _zend.http.client.adapters.curl.example-2:

.. rubric:: Dateien von Hand übertragen

Man kan cURL verwenden um große Dateien über *HTTP* durch einen Dateihandle zu übertragen.

.. code-block:: php
   :linenos:

   $putFileSize   = filesize("filepath");
   $putFileHandle = fopen("filepath", "r");

   $adapter = new Zend_Http_Client_Adapter_Curl();
   $client = new Zend_Http_Client();
   $client->setAdapter($adapter);
   $adapter->setConfig(array(
       'curloptions' => array(
           CURLOPT_INFILE => $putFileHandle,
           CURLOPT_INFILESIZE => $putFileSize
       )
   ));
   $client->request("PUT");

.. _zend.http.client.adapters.test:

Der Test Adapter
----------------

Manchmal ist es sehr schwer Code zu testen, der von *HTTP* Verbindungen abhängig ist. Zum Beispiel verlangt das
Testen einer Applikation, die einen *RSS* Feed von einem fremden Server anfordert, eine Netzwerkverbindung, die
nicht immer verfügbar ist.

Aus diesem Grund wird der ``Zend_Http_Client_Adapter_Test`` Adapter bereit gestellt. Man kann seine eigenen
Applikationen schreiben, um ``Zend_Http_Client`` zu verwenden, und nur zu Testzwecken, z.B. in der Unit Test Suite,
den Standardadapter durch den Testadapter (ein Mock Objekt) austauschen, um Tests ohne direkte Serverbindungen
auszuführen.

Der ``Zend_Http_Client_Adapter_Test`` Adapter stellt die zusätzliche Methode setResponse() bereit. Diese Methode
nimmt einen Parameter entgegen, der eine *HTTP* Antwort entweder als Text oder als ``Zend_Http_Response`` Objekt
repräsentiert. Einmal eingerichtet, wird der Testadapter immer diese Antwort zurückgeben, ohne tatsächlich eine
*HTTP* Anfrage auszuführen.

.. _zend.http.client.adapters.test.example-1:

.. rubric:: Testen gegen einen einfachen HTTP Response Stumpf

.. code-block:: php
   :linenos:

   // Instanziere einen neuen Adapter und Client
   $adapter = new Zend_Http_Client_Adapter_Test();
   $client = new Zend_Http_Client('http://www.example.com', array(
       'adapter' => $adapter
   ));

   // Setze die erwartete Antwort
   $adapter->setResponse(
       "HTTP/1.1 200 OK"        . "\r\n" .
       "Content-type: text/xml" . "\r\n" .
                                  "\r\n" .
       '<?xml version="1.0" encoding="UTF-8"?>' .
       '<rss version="2.0" ' .
       '     xmlns:content="http://purl.org/rss/1.0/modules/content/"' .
       '     xmlns:wfw="http://wellformedweb.org/CommentAPI/"' .
       '     xmlns:dc="http://purl.org/dc/elements/1.1/">' .
       '  <channel>' .
       '    <title>Premature Optimization</title>' .
       // und so weiter...
       '</rss>');

   $response = $client->request('GET');
   // .. setze die Verarbeitung von $response fort...

Das obige Beispiel zeigt, wie man einen *HTTP* Client voreinstellen kann, damit er die benötigte Antwort
zurückgibt. Danach kann man mit den Testen des eigenen Codes weiter machen, ohne von einer Netzwerkverbindung, der
Serverantwort, etc. abhängig zu sein. In diesem Fall würde der Test mit der Prüfung fortfahren, wie die
Applikation das *XML* aus der Antwort verarbeitet..

Manchmal erfordert ein einziger Methoden-Aufruf mehrere *HTTP* Übertragungen. In diesem Fall ist es nicht möglich
setResponse() alleine zu verwenden weil es keine Möglichkeit gibt die nächste Antwort zu setzen die das Programm
benötigt bevor es zum Aufrufer zurückkommt.

.. _zend.http.client.adapters.test.example-2:

.. rubric:: Test mit mehreren HTTP-Antworten

.. code-block:: php
   :linenos:

   // Instanzen vom Adapter und Client erzeugen
   $adapter = new Zend_Http_Client_Adapter_Test();
   $client = new Zend_Http_Client('http://www.example.com', array(
       'adapter' => $adapter
   ));

   // mit setResponse() die erste Antwort setzen
   $adapter->setResponse(
       "HTTP/1.1 302 Found"      . "\r\n" .
       "Location: /"             . "\r\n" .
       "Content-Type: text/html" . "\r\n" .
                                   "\r\n" .
       '<html>' .
       '  <head><title>Moved</title></head>' .
       '  <body><p>This page has moved.</p></body>' .
       '</html>');

   // mit addResponse() nachfolgende Antworten setzen
   $adapter->addResponse(
       "HTTP/1.1 200 OK"         . "\r\n" .
       "Content-Type: text/html" . "\r\n" .
                                       "\r\n" .
       '<html>' .
       '  <head><title>Meine Haustierseite</title></head>' .
       '  <body><p>...</p></body>' .
       '</html>');

   // Das $client Objekt kann jetzt zu testzwecken herangezogen werden,
   // indem es wie ein normales Client-Objekt benutzt wird.

Die setResponse() Methode löscht alle Antworten im Buffer von ``Zend_Http_Client_Adapter_Test`` und setzt die
erste Antwort die zurückgegeben wird. Die addResponse() Methode fügt dann weitere Antworten sukzessiv hinzu.

Die HTTP-Antworten werden in der Reihenfolge zurückgegeben, in der sie angelegt worden sind. Gibt es mehr Anfragen
als Antworten, so wird wieder bei der ersten Antwort angefangen.

Das oben angeführte Beispiel kann dazu benutzt werden, um die Reaktion der eigenen Anwendung auf einen 302
Redirect (Weiterleitung) zu testen. Abhängig von Ihrer Anwendung, kann es gewollt oder nicht gewollt sein, dass
dem Redirect gefolgt wird. In unserem Beispiel erwarten wir das der Umleitung gefolgt wird und wir konfigurieren
den Test Adapter um uns zu helfen das zu Testen. Die ursprüngliche 302 Antwort wird mit der setResponse() Methode
gesetzt und die 200 Antwort welche als nächstes zurückzugeben ist wird mit der addResponse() Methode
hinzugefügt. Nachdem der Test Adapter konfiguriert ist, wird der *HTTP* Client der den Adapter enthält unter test
in das eigene Objekt injiziert und sein Verhalten getestet.

Wenn man will das der Adapter auf Wunsch fehlschlägt kann man ``setNextRequestWillFail($flag)`` verwenden. Diese
Methode lässt den Nächsten Aufruf von ``connect()`` eine ``Zend_Http_Client_Adapter_Exception`` Exception
geworfen. Das kann dann nützlich sein wenn die eigene Anwendung Inhalte von einer externen Seite cacht (im Falle
das die Seite ausfällt) und man dieses Feature testen will.

.. _zend.http.client.adapters.test.example-3:

.. rubric:: Erzwingen das der Adapter fehlschlägt

.. code-block:: php
   :linenos:

   // Einen neuen Adapter und Client instanziieren
   $adapter = new Zend_Http_Client_Adapter_Test();
   $client = new Zend_Http_Client('http://www.example.com', array(
       'adapter' => $adapter
   ));

   // Erzwingen das die nächste Anfrage mit einer Exception fehlschlägt
   $adapter->setNextRequestWillFail(true);

   try {
       // Dieser Aufruf führt zu einer Zend_Http_Client_Adapter_Exception
       $client->request();
   } catch (Zend_Http_Client_Adapter_Exception $e) {
       // ...
   }

   // Weitere Aufrufe arbeiten wie erwartet bis man setNextRequestWillFail(true)
   // erneut aufruft

.. _zend.http.client.adapters.extending:

Einen eigenen Adapter erstellen
-------------------------------

Es ist möglich eigene Verbindungs-Adapter zu schreiben, die spezielle Bedürfnisse, wie persistente Sockets oder
gecachte Verbindungen, abdecken. Diese können dann, wie gewohnt in der eigenen Anwendung benutzt werden können.

Um einen neuen Adapter zu erstellen, muss eine neue Klasse angelegt werden, die das
``Zend_Http_Client_Adapter_Interface`` implementiert. Nachfolgend finden Sie ein Gerüst für einen neuen Adapter.
Die public-Methoden müssen unbedingt implementiert werden.

.. _zend.http.client.adapters.extending.example-1:

.. rubric:: Gerüst für einen eigenen Verbindungs-Adapter

.. code-block:: php
   :linenos:

   class MyApp_Http_Client_Adapter_BananaProtocol
       implements Zend_Http_Client_Adapter_Interface
   {
       /**
        * Konfigurationsarray für den Adapter
        *
        * @param array $config
        */
       public function setConfig($config = array())
       {
           // in den meisten Fällen kann die Implementierung von
           // Zend_Http_Client_Adapter_Socket eins zu eins übernommen werden
       }

       /**
        * Zum Server verbinden
        *
        * @param string  $host
        * @param int     $port
        * @param boolean $secure
        */
       public function connect($host, $port = 80, $secure = false)
       {
           // Verbindung zum Server herstellen
       }

       /**
        * Anfrage / Request an den Server stellen
        *
        * @param string        $method
        * @param Zend_Uri_Http $url
        * @param string        $http_ver
        * @param array         $headers
        * @param string        $body
        * @return string Request as text
        */
       public function write($method,
                             $url,
                             $http_ver = '1.1',
                             $headers = array(),
                             $body = '')
       {
           // Anfrage stellen
           // Diese Methode muss die komplette Antwort zurückliefern,
           // inklusive aller Header
       }

       /**
        * Antwort des Servers auslesen
        *
        * @return string
        */
       public function read()
       {
           // Antwort des Servers lesen und als String zurückgeben
       }

       /**
        * Verbindung zum Server beenden
        *
        */
       public function close()
       {
           // Verbindung beenden - wird zum Schluss aufgerufen
       }
   }

   // Jetzt kann der Adapter benutzt werden:
   $client = new Zend_Http_Client(array(
       'adapter' => 'MyApp_Http_Client_Adapter_BananaProtocol'
   ));



.. _`hier`: http://www.php.net/manual/en/transports.php#transports.inet
.. _`Stream Kontext`: http://php.net/manual/de/stream.contexts.php
.. _`stream_context_create()`: http://php.net/manual/de/function.stream-context-create.php
