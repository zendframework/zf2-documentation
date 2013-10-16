.. EN-Revision: none
.. _zend.http.client:

Einführung
==========

``Zend\Http\Client`` stellt eine einfache Schnittstelle für das Durchführen von Hyper-Text Transfer Protocol
(HTTP) Anfragen. ``Zend\Http\Client`` unterstützt die meisten einfachen Funktionen, die man von einem *HTTP*
Client erwartet, sowie einige komplexere Funktionen, wie z.B. *HTTP* Authentifizierung und Dateiuploads.
Erfolgreiche Anfragen (und die meisten nicht erfolgreichen ebenfalls) liefern ein ``Zend\Http\Response`` Objekt
zurück, welches den Zugriff auf die Header und den Hauptteil der Antwort ermöglichen (siehe :ref:`diesen
Abschnitt <zend.http.response>`).

.. _zend.http.client.usage:

Zend\Http\Client verwenden
--------------------------

Der Klassenkonstruktor akzeptiert optional eine URL als seinen ersten Parameter (kann entweder ein String oder ein
``Zend\Uri\Http`` Objekt sein) und ein Array oder ``Zend_Config`` Objekt welches Konfigurationsparameter enthält.
Beides kann ausgelassen und später durch Verwendung der setUri() and setConfig() Methoden gesetzt werden.



      .. _zend.http.client.introduction.example-1:

      .. rubric:: Ein Zend\Http\Client Objekt instanzieren

      .. code-block:: php
         :linenos:

         $client = new Zend\Http\Client('http://example.org', array(
             'maxredirects' => 0,
             'timeout'      => 30));

         // Dies macht genau das selbe:
         $client = new Zend\Http\Client();
         $client->setUri('http://example.org');
         $client->setConfig(array(
             'maxredirects' => 0,
             'timeout'      => 30));

         // Man kann auch ein Zend_Config Objekt verwenden um die Konfiguration
         // des Clients zu setzen
         $config = new Zend\Config\Ini('httpclient.ini', 'secure');
         $client->setConfig($config);



   .. note::

      ``Zend\Http\Client`` verwendet ``Zend\Uri\Http`` um URLs zu prüfen. Das bedeutet das einige spezielle
      Zeichen wie das Pipe-Symbol ('\|') oder das Karet Symbol ('^') in der URL standardmäßig nicht akzeptiert
      werden. Das kann geändert werden indem die 'allow_unwise' Option von ``Zend_Uri`` auf '``TRUE``' gesetzt
      wird. Siehe :ref:`diesen Abschnitt <zend.uri.validation.allowunwise>` für mehr Informationen.



.. _zend.http.client.configuration:

Konfigurationsparameter
-----------------------

Der Konstruktor und die setConfig() Methode akzeptieren ein assoziatives Array mit Konfigurationsparametern oder
ein ``Zend_Config`` Objekt. Das Setzen dieser Parameter ist optional, da alle einen Standardwert haben.



      .. _zend.http.client.configuration.table:

      .. table:: Zend\Http\Client Konfigurationsparameter

         +---------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |Parameter      |Beschreibung                                                                                                                                                                                                                                  |Erwartete Werte|Standardwert                     |
         +===============+==============================================================================================================================================================================================================================================+===============+=================================+
         |maxredirects   |Maximale Anzahl von zu folgenden Umleitungen (0 = keine)                                                                                                                                                                                      |integer        |5                                |
         +---------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |strict         |Ob Prüfungen an Headernamen durchzuführen sind. Einige Prüf-Funktionen werden übersprungen wenn auf FALSE gesetzt. Sollte normalerweise nicht geändert werden                                                                                 |boolean        |TRUE                             |
         +---------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |strictredirects|Ob beim Umleiten genau dem RFC zu folgen ist (siehe diesen Abschnitt)                                                                                                                                                                         |boolean        |FALSE                            |
         +---------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |useragent      |String zur Identifizierung des User Agents (gesendet in den Anfrageheadern)                                                                                                                                                                   |string         |'Zend\Http\Client'               |
         +---------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |timeout        |Zeitüberschreitung für Verbindungen (Sekunden)                                                                                                                                                                                                |integer        |10                               |
         +---------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |httpversion    |Version des HTTP Protokolls (normalerweise '1.1' oder '1.0')                                                                                                                                                                                  |string         |'1.1'                            |
         +---------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |adapter        |Zu verwendene Adapterklasse für die Verbindung (siehe diesen Abschnitt)                                                                                                                                                                       |mixed          |'Zend\Http\Client\Adapter\Socket'|
         +---------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |keepalive      |Ob keep-alive Verbindungen mit dem Server aktiviert werden sollen. Nützlich und kann die Performance verbessern, wenn mehrere aufeinanderfolgend Anfragen an den selben Server ausgeführt werden.                                             |boolean        |FALSE                            |
         +---------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |storeresponse  |Ob die letzte Antwort für einen späteren Aufruf von getLastResponse() gespeichert werden soll. Wird sie auf FALSE gesetzt, gibt getLastResponse() NULL zurück.                                                                                |boolean        |TRUE                             |
         +---------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+
         |encodecookies  |Ob der Cookie Wert über urlencode oder urldecode übergeben werden soll oder nicht. Dessen Aktivierung verhindert die Unterstützung bei einigen Web Servern. Dessen Deaktivierung limitiert den Bereich der Werte die Cookies enthalten können.|boolean        |TRUE                             |
         +---------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------+---------------------------------+



.. _zend.http.client.basic-requests:

Durchführen von einfachen HTTP Anfragen
---------------------------------------

Das Durchführen von einfachen *HTTP* Anfragen kann sehr leicht durch Verwendung der request() Methode gemacht
werden und benötigt selten mehr als drei Codezeilen:



      .. _zend.http.client.basic-requests.example-1:

      .. rubric:: Durchführen einer einfache GET Anfrage

      .. code-block:: php
         :linenos:

         $client = new Zend\Http\Client('http://example.org');
         $response = $client->request();

Die request() Methode akzeptiert einen optionalen Parameter - die Anfragemethode. Diese kann ``GET``, ``POST``,
``PUT``, ``HEAD``, ``DELETE``, ``TRACE``, ``OPTIONS`` oder ``CONNECT`` sein, wie im *HTTP* Protokoll definiert.
[#]_. Zur Erleichterung sind alle als Klassenkonstanten definiert: Zend\Http\Client::GET, Zend\Http\Client::POST
und so weiter.

Wenn keine Methode angegeben worden ist, wird die durch den letzten Aufruf von ``setMethod()`` gesetzte Methode
verwendet. Wenn ``setMethod()`` vorher nicht aufgerufen worden ist, wird als Standardmethode ``GET`` verwendet
(siehe obiges Beispiel).



      .. _zend.http.client.basic-requests.example-2:

      .. rubric:: Andere Anfragemethoden als GET verwenden

      .. code-block:: php
         :linenos:

         // Durchführen einer POST Anfrage
         $response = $client->request('POST');

         // Ein weiterer Weg, eine POST Anfrage durchzuführen
         $client->setMethod(Zend\Http\Client::POST);
         $response = $client->request();



.. _zend.http.client.parameters:

Hinzufügen von GET und POST Parametern
--------------------------------------

Das Hinzufügen von ``GET`` Parametern zu einer *HTTP* Anfrage ist recht einfach und kann entweder über die Angabe
als Teil der URL oder durch Verwendung der setParameterGet() Methode erfolgen. Diese Methode benötigt den Namen
des ``GET`` Parameter als seinen ersten Parameter und den Wert des ``GET`` Parameter als seinen zweiten Parameter.
Zur Erleichterung akzeptiert die setParameterGet() Methode auch ein einzelnes assoziatives Array mit ``GET``
Parameter als Name => Wert Variablen, was beim setzen von mehreren ``GET`` Parametern komfortabler sein kann.



      .. _zend.http.client.parameters.example-1:

      .. rubric:: Setzen von GET Parametern

      .. code-block:: php
         :linenos:

         // Setzen eines GET Parameter mit der setParameterGet Methode
         $client->setParameterGet('knight', 'lancelot');

         // Dies ist äquivalent durch Setzen der URL:
         $client->setUri('http://example.com/index.php?knight=lancelot');

         // Hinzufügen mehrerer Parameter durch einen Aufruf
         $client->setParameterGet(array(
             'first_name'  => 'Bender',
             'middle_name' => 'Bending'
             'made_in'     => 'Mexico',
         ));



Während ``GET`` Parameter bei jeder Anfragemethode gesetzt werden können, können POST Parameter nur im Hauptteil
von POST Anfragen versendet werden. Das Hinzufügen von POST Parameter zu einer Anfrage ist sehr ähnlich wie das
Hinzufügen von ``GET`` Parametern and kann mit der setParameterPost() Methode gemacht werden, die vom Aufbau der
setParameterGet() Methode ähnlich ist..



      .. _zend.http.client.parameters.example-2:

      .. rubric:: Setzen von POST Parametern

      .. code-block:: php
         :linenos:

         // Setzen eines POST Parameters
         $client->setParameterPost('language', 'fr');

         // Hinzufügen von mehreren POST Parametern, eines davon mit mehreren Werten
         $client->setParameterPost(array(
             'language'  => 'es',
             'country'   => 'ar',
             'selection' => array(45, 32, 80)
         ));

Beim Senden einer POST Anfrage ist zu beachten, dass man sowohl ``GET`` als auch POST Parameter setzen kann. Auf
der anderen Seite wird durch das Setzen von POST Parametern für andere Anfragen als POST kein Fehler ausgeworfen.
Solange eine Anfrage keine POST Anfrage ist, werden POST Parameter einfach ignoriert.

.. _zend.http.client.accessing_last:

Zugriff auf die Letzte Anfrage und Antwort
------------------------------------------

``Zend\Http\Client`` bietet Methoden um Zugriff auf die letzte gesendete Anfrage und die letzte empfangene Antwort
des Client Objekts zu bekommen. ``Zend\Http\Client->getLastRequest()`` hat keine Parameter und gibt die letzte
*HTTP* Anfrage als String zurück die der Client gesendet hat. Auf die gleiche Art und Weise gibt
``Zend\Http\Client->getLastResponse()`` die letzte *HTTP* Antwort als :ref:`Zend\Http\Response
<zend.http.response>` Objekt zurück die der Client empfangen hat.




.. [#] Siehe RFC 2616 -http://www.w3.org/Protocols/rfc2616/rfc2616.html.