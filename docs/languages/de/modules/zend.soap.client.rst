.. EN-Revision: none
.. _zend.soap.client:

Zend_Soap_Client
================

Die ``Zend_Soap_Client`` Klasse vereinfacht die Entwicklung von *SOAP* Clients für *PHP* Programmierern.

Sie kann im WSDL oder im nicht-WSDL Modus verwendet werden.

Im WSDL Modus verwendet die ``Zend_Soap_Client`` Komponente ein bereits vorbereitetes WSDL Dokument um die Optionen
des Transport Layers zu definieren.

Die WSDL Beschreibung wird normalerweise vom Web Service bereitgestellt auf das der Client zugreift. Wenn die WSDL
Beschreibung nicht verfügbar gemacht wurde, kann man ``Zend_Soap_Client`` im nicht-WSDL Modus verwenden. In diesem
Modus müssen alle *SOAP* Protokolloptionen explizit an der ``Zend_Soap_Client`` Klasse gesetzt werden.

.. _zend.soap.client.constructor:

Der Zend_Soap_Client Konstruktor
--------------------------------

Der ``Zend_Soap_Client`` Konstruktor nimmt zwei Parameter:



   - ``$wsdl``- eine *URI* einer WSDL Datei.

   - ``$options``- Optionen um ein *SOAP* Client Objekt zu erstellen.

Beide Parameter können später gesetzt werden indem die ``setWsdl($wsdl)`` und ``setOptions($options)`` Methoden
verwendet werden.

.. note::

   **Wichtig!**

   Wenn die ``Zend_Soap_Client`` Komponente im nicht-WSDL Modus verwendet wird, **müssen** die 'location' und
   'uri' Optionen gesetzt werden.

Die folgenden Optionen werden erkannt:



   - 'soap_version' ('soapVersion') - Die zu verwendende SOAP Version (SOAP_1_1 oder *SOAP*\ _1_2).

   - 'classmap' ('classMap') welche verwendet werden kann um einige WSDL Typen auf *PHP* Klassen zu mappen.

     Die Option muß ein Array mit WSDL Typen als Schlüssel und Namen von *PHP* Klassen als Werte sein.

   - 'encoding' - Interne Zeichen Kodierung (UTF-8 wird immer als externe Kodierung verwendet).

   - 'wsdl' welcher dem Aufruf von ``setWsdl($wsdlValue)`` entspricht.

     Das Ändern dieser Option kann das ``Zend_Soap_Client`` Objekt von oder zum WSDL Modus wechseln.

   - 'uri' - Der Ziel-Namespace für den *SOAP* Service (benötigt im nicht-WSDL Modus, funktioniert nicht im WSDL
     Modus).

   - 'location' - Die *URL* der Anfrage (benötigt im nicht-WSDL Modus, funktioniert nicht im WSDL Modus).

   - 'style' - Anfrage Stil (funktioniert nicht im WSDL Modus): ``SOAP_RPC`` oder ``SOAP_DOCUMENT``.

   - 'use' - Methode zum Verschlüsseln von Nachrichten (funktioniert nicht im WSDL Modus): ``SOAP_ENCODED`` oder
     ``SOAP_LITERAL``.

   - 'login' und 'password' - Login und Passwort für eine *HTTP* Authentifizierung.

   - 'proxy_host', 'proxy_port', 'proxy_login', und 'proxy_password' - Eine *HTTP* Verbindung über einen Proxy
     Server.

   - 'local_cert' und 'passphrase' -*HTTPS* Client Authentifizierungs Optionen für Zertifikate.

   - 'compression' - Komprimierungs Optionen; das ist eine Kombination von ``SOAP_COMPRESSION_ACCEPT``,
     ``SOAP_COMPRESSION_GZIP`` und ``SOAP_COMPRESSION_DEFLATE`` Optionen welche wie folgt verwendet werden können:

     .. code-block:: php
        :linenos:

        // Komprimierung der Antworten akzeptieren
        $client = new Zend_Soap_Client("some.wsdl",
          array('compression' => SOAP_COMPRESSION_ACCEPT));
        ...

        // Anfragen komprimieren durch Verwendung von gzip mit Komprimierungs-Level 5
        $client = new Zend_Soap_Client("some.wsdl",
          array('compression' => SOAP_COMPRESSION_ACCEPT | SOAP_COMPRESSION_GZIP | 5));
        ...

        // Anfragen komprimieren durch Verwendung der Deflate Komprimierung
        $client = new Zend_Soap_Client("some.wsdl",
          array('compression' => SOAP_COMPRESSION_ACCEPT | SOAP_COMPRESSION_DEFLATE));



.. _zend.soap.client.calls:

SOAP Anfragen durchführen
-------------------------

Nachdem ein ``Zend_Soap_Client`` Objekt erstellt wurde sind wir bereit um *SOAP* Anfragen durchzuführen.

Jede Methode des Web Services wird auf eine virtuelle ``Zend_Soap_Client`` Objekt-Methode gemappt welche Parameter
mit üblichen *PHP* Typen entgegen nimmt.

Es ist wie im folgenden Beispiel zu verwenden:

.. code-block:: php
   :linenos:

   //****************************************************************
   //                Server Code
   //****************************************************************
   // class MyClass {
   //     /**
   //      * Diese Methode nimmt ...
   //      *
   //      * @param integer $inputParam
   //      * @return string
   //      */
   //     public function method1($inputParam) {
   //         ...
   //     }
   //
   //     /**
   //      * Diese Methode nimmt ...
   //      *
   //      * @param integer $inputParam1
   //      * @param string  $inputParam2
   //      * @return float
   //      */
   //     public function method2($inputParam1, $inputParam2) {
   //         ...
   //     }
   //
   //     ...
   // }
   // ...
   // $server = new Zend_Soap_Server(null, $options);
   // $server->setClass('MyClass');
   // ...
   // $server->handle();
   //
   //****************************************************************
   //                Ende des Server Codes
   //****************************************************************

   $client = new Zend_Soap_Client("MyService.wsdl");
   ...

   // $result1 ist ein String
   $result1 = $client->method1(10);
   ...

   // $result2 ist ein Float
   $result2 = $client->method2(22, 'irgendein String');


