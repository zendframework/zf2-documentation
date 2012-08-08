.. EN-Revision: none
.. _zend.soap.server:

Zend_Soap_Server
================

Die ``Zend_Soap_Server`` Klasse ist dazu gedacht den Web Service Teil der Entwicklung für *PHP* Programmierer zu
vereinfachen.

Sie kann in WSDL oder nicht-WSDL Modus verwendet werden, und verwendet Klassen oder Funktionen um eine Web Service
*API* zu definieren.

Wenn die ``Zend_Soap_Server`` Komponente im WSDL Modus arbeitet, verwendet Sie ein bereits vorbereitetes WSDL
Dokument um das Verhalten des Server Objekts und die Optionen des Transport Layers zu definieren.

Ein WSDL Dokument kann automatisch erzeugt werden mit der Funktionalität die von der :ref:`Zend_Soap_AutoDiscovery
Komponente <zend.soap.autodiscovery.introduction>` angeboten wird sollte händisch erzeugt werden durch Verwendung
der :ref:`Zend_Soap_Wsdl Klasse <zend.soap.wsdl>` oder irgendeinem anderen *XML* Erstellungstool.

Wenn der nicht-WSDL Modus verwendet wird, müssen alle Protokoll-Optionen gesetzt werden indem der
Options-Mechanismus verwendet wird.

.. _zend.soap.server.constructor:

Der Zend_Soap_Server Konstruktor
--------------------------------

Der Contructor von ``Zend_Soap_Server`` sollte für WSDL und nicht-WSDL Modi unterschiedlich verwendet werden.

.. _zend.soap.server.constructor.wsdl_mode:

Der Zend_Soap_Server Konstruktor für den WSDL Modus
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Der ``Zend_Soap_Server`` Konstruktor nimmt zwei optionale Parameter wenn er im WSDL Modus arbeitet:



   . ``$wsdl``, welcher eine *URI* einer WSDL Datei ist [#]_.

   . ``$options``- Optionen für die Erstellung eines *SOAP* Server Objektes [#]_.

     Die folgenden Optionen werden im WSDL Modus erkannt:



        - 'soap_version' ('soapVersion') - Die zu verwendende SOAP Version (SOAP_1_1 or *SOAP*\ _1_2).

        - 'actor' - Die Aktions-*URI* für den Server.

        - 'classmap' ('classMap') welche verwendet werden kann um einige WSDL Typen auf *PHP* Klassen zu mappen.

          Die Option muß ein Array mit WSDL Typen als Schlüssel und Namen von *PHP* Klassen als Werte sein.

        - 'encoding' - Interne Zeichen Kodierung (UTF-8 wird immer als externe Kodierung verwendet).

        - 'wsdl' welcher dem Aufruf von ``setWsdl($wsdlValue)`` entspricht.





.. _zend.soap.server.wsdl_mode:

Der Zend_Soap_Server Konstruktor für den nicht-WSDL Modus
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Der erste Parameter des Konstruktors **muß** auf ``NULL`` gesetzt werden wenn man plant die Funktionalität von
``Zend_Soap_Server`` im nicht-WSDL Modus zu verwenden.

Man muß in diesem Fall auch die 'uri' Option setzen (siehe anbei).

Der zweite Parameter des Konstruktors (``$options``) ist ein Array mit Optionen um ein *SOAP* Server Objekt zu
erstellen [#]_.

Die folgenden Optionen werden im nicht-WSDL Modus erkannt:



   - 'soap_version' ('soapVersion') - Die zu verwendende SOAP Version (SOAP_1_1 or *SOAP*\ _1_2).

   - 'actor' - Die Aktions-*URI* für den Server.

   - 'classmap' ('classMap') welche verwendet werden kann um einige WSDL Typen auf *PHP* Klassen zu mappen.

     Die Option muß ein Array mit WSDL Typen als Schlüssel und Namen von *PHP* Klassen als Werte sein.

   - 'encoding' - Interne Zeichen Kodierung (UTF-8 wird immer als externe Kodierung verwendet).

   - 'uri' (benötigt) -*URI* Namespace für den *SOAP* Server.



.. _zend.soap.server.api_define_methods:

Methoden um eine Web Service API zu definieren
----------------------------------------------

Es gibt zwei Wege um eine Web Service *API* zu definieren wenn man Zugriff auf den eigenen *PHP* Code über *SOAP*
geben will.

Der Erste ist das Anfügen einer Klasse zum ``Zend_Soap_Server`` Objekt welche eine Web Service *API* komplett
beschreibt:

.. code-block:: php
   :linenos:

   ...
   class MyClass {
       /**
        * Diese Methode nimmt ...
        *
        * @param integer $inputParam
        * @return string
        */
       public function method1($inputParam) {
           ...
       }

       /**
        * Diese Methode nimmt ...
        *
        * @param integer $inputParam1
        * @param string  $inputParam2
        * @return float
        */
       public function method2($inputParam1, $inputParam2) {
           ...
       }

       ...
   }
   ...
   $server = new Zend_Soap_Server(null, $options);
   // Die Klasse an den Soap Server binden
   $server->setClass('MyClass');
   // Binden eines bereits initialisierten Objekts an den Soap Server
   $server->setObject(new MyClass());
   ...
   $server->handle();

.. note::

   **Wichtig!**

   Jede Methode sollte komplett beschrieben sein indem Docblocks für Methoden verwendet werden wenn man plant die
   Autodiscovery Funktionalität zu verwenden um ein entsprechendes Web Service WSDL vorzubereiten.

Die zweite Methode der Definition einer Web Service *API* ist die Verwendung eines Sets von Funktionen und
``addFunction()`` oder ``loadFunctions()`` Methoden:

.. code-block:: php
   :linenos:

   ...
   /**
    * Diese Funktion ...
    *
    * @param integer $inputParam
    * @return string
    */
   function function1($inputParam) {
       ...
   }

   /**
    * Diese Funktion ...
    *
    * @param integer $inputParam1
    * @param string  $inputParam2
    * @return float
    */
   function function2($inputParam1, $inputParam2) {
       ...
   }
   ...
   $server = new Zend_Soap_Server(null, $options);
   $server->addFunction('function1');
   $server->addFunction('function2');
   ...
   $server->handle();

.. _zend.soap.server.request_response:

Anfragen und Antwort Objekte behandeln
--------------------------------------

.. note::

   **Fortgeschritten**

   Dieser Abschnitt beschreibt das fortgeschrittene bearbeiten von Anfrage-/Antwort-Optionen und kann übersprungen
   werden.

Die ``Zend_Soap_Server`` Komponente führt Anfrage/Antwort-Bearbeitung automatisch durch. Sie erlaubt es aber diese
zu fangen und Vor- und Nach-bearbeitungen durchzuführen.

.. _zend.soap.server.request_response.request:

Anfrage Bearbeitung
^^^^^^^^^^^^^^^^^^^

Die ``Zend_Soap_Server::handle()`` Methode nimmt Anfragen vom Standard-Eingabe Stream ('php://input') entgegen. Sie
kann übergangen werden durch die Angabe von optionalen Parametern an die ``handle()`` Methode oder durch setzen
einer Anfrage durch Verwendung der ``setRequest()`` Methode:

.. code-block:: php
   :linenos:

   ...
   $server = new Zend_Soap_Server(...);
   ...
   // Eine Anfrage setzen durch Verwendung des optionalen $request Parameters
   $server->handle($request);
   ...
   // Eine Anfrage setzen durch Verwendung der setRequest() Methode
   $server->setRequest();
   $server->handle();

Anfrage Objekte können dargestellt werden durch Verwendung der folgenden Dinge:



   - DOMDocument (gecastet zu *XML*)

   - DOMNode (Besitzer Dokument wird genommen und zu *XML* gecastet)

   - SimpleXMLElement (gecasted zu *XML*)

   - stdClass (\__toString() wird aufgerufen und geprüft ob es gültiges *XML* ist)

   - string (geprüft ob es gültiges *XML* ist)



Die zuletzt bearbeitete Anfrage kann durch Verwendung der ``getLastRequest()`` Methode als *XML* String empfangen
werden:

.. code-block:: php
   :linenos:

   ...
   $server = new Zend_Soap_Server(...);
   ...
   $server->handle();
   $request = $server->getLastRequest();

.. _zend.soap.server.request_response.response:

Antworten vor-bearbeiten
^^^^^^^^^^^^^^^^^^^^^^^^

Die ``Zend_Soap_Server::handle()`` Methode wirft die erzeugte Antwort automatisch auf den Ausgabe Stream aus. Das
kann durch Verwendung von ``setReturnResponse()`` mit ``TRUE`` oder ``FALSE`` als Parameter blockiert werden [#]_.
Die erzeugte Antwort wird in diesem Fall durch die ``handle()`` Methode zurückgegeben.

.. code-block:: php
   :linenos:

   ...
   $server = new Zend_Soap_Server(...);
   ...
   // Eine Antwort als Rückgabewert der handle() Methode
   // erhalten statt diese auf den Ausgabe Stream zu werfen
   $server->setReturnResponse(true);
   ...
   $response = $server->handle();
   ...

Die letzte Antwort kann auch mit der ``getLastResponse()`` Methode empfangen werden um Vor-Bearbeitungen
durchzuführen:

.. code-block:: php
   :linenos:

   ...
   $server = new Zend_Soap_Server(...);
   ...
   $server->handle();
   $response = $server->getLastResponse();
   ...



.. [#] Kann später gesetzt werden durch Verwendung der ``setWsdl($wsdl)`` Methode.
.. [#] Optionen können durch Verwendung der ``setOptions($options)`` Methode später gesetzt werden.
.. [#] Optionen können später gesetzt werden indem die ``setOptions($options)`` Methode verwendet wird.
.. [#] Der aktuelle Status des Rückgabe Antwort Flags kann mit der ``setReturnResponse()`` Methode abgefragt
       werden.