.. EN-Revision: none
.. _zend.soap.wsdl:

WSDL Zugriffsmethoden
=====================

.. note::

   Die ``Zend\Soap\Wsdl`` Klasse wird von der ``Zend\Soap\Server`` Komponente intern verwendet um mit WSDL
   Dokumenten zu arbeiten. Trotzdem könnte man die Funktionalität die von dieser Klasse angeboten wird auch für
   eigene Zwecke verwendet werden. Das ``Zend\Soap\Wsdl`` Paket enthält sowohl einen Parser als auch einen
   Ersteller für WSDL Dokumente.

   Wenn man nicht plant das zu tun, kann dieses Kapitel der Dokumentation übersprungen werden.

.. _zend.soap.wsdl.constructor:

Zend\Soap\Wsdl Konstruktor
--------------------------

Der ``Zend\Soap\Wsdl`` Konstruktor nimmt drei Parameter:



   . ``$name``- Name des Web Services der beschrieben wird.

   . ``$uri``-*URI* wo das WSDL vorhanden sein wird (könnte auch eine Referenz zu einer Datei auf dem Dateisystem
     sein).

   . ``$strategy``- Optionales Flag das verwendet wird um die Strategie für die Erkennung von komplexen Typen
     (Objekte) zu identifizieren. Das war vor der Version 1.7 ein boolscher ``$extractComplexTypes`` und kann aus
     Gründen der Rückwärtskompatibilität noch immer als Boolean gesetzt werden. Standardmäßig ist das
     Erkennungsverhalten von 1.6 gesetzt. Um mit Strategien für komplexe Typenerkennung weiterzumachen lesen wie
     weiter im Kapitel: :ref:`Komplexe Typen hinzufügen <zend.soap.wsdl.types.add_complex>`.



.. _zend.soap.wsdl.addmessage:

Die addMessage() Methode
------------------------

Die ``addMessage($name, $parts)`` Methode fügt eine neue Nachrichten Beschreibung zu einem WSDL Dokumetn hinzu
(/definitions/message Element).

Jede Nachricht korrespondiert zu einer Methode im Sinne von ``Zend\Soap\Server`` und ``Zend\Soap\Client``
Funktionalität.

Der ``$name`` Parameter repräsentiert den Namen der Nachricht.

Der ``$parts`` Parameter ist ein Array von Nachrichten Teilen welche *SOAP* Aufruf Parameter beschreiben. Es ist
ein assoziatives Array: 'part name' (SOAP Aufruf Parameter Name) => 'part type'.

Das Typ Mapping Management wird durchgeführt indem die ``addTypes()``, ``addTypes()`` und ``addComplexType()``
Methoden ausgeführt werden (siehe anbei).

.. note::

   Nachrichten Teile können entweder 'element' oder 'type' Attribute für das typisieren verwenden (siehe
   `http://www.w3.org/TR/wsdl#_messages`_).

   'element' Attribute müssen zu einem entsprechenden Element von Daten Typ Definition referieren. 'type' zu einem
   entsprechenden complexType Eintrag.

   Alle standardmäßigen XSD Typen haben beide 'element' und 'complexType' Definitionen (siehe
   `http://schemas.xmlsoap.org/soap/encoding/`_).

   Alle nicht-standardmäßigen Typen, welche hinzugefügt werden können durch verwenden der
   ``Zend\Soap\Wsdl::addComplexType()`` Methode, sind beschrieben durch Verwendung des 'complexType' Nodes des
   '/definitions/types/schema/' Abschnitts des WSDL Dokuments.

   ``addMessage()`` Methoden verwenden also immer das 'type' Attribut um Typen zu beschreiben.

.. _zend.soap.wsdl.add_port_type:

Die addPortType() Methode
-------------------------

Die ``addPortType($name)`` Methode fügt neue Port Typen zu einem WSDL Dokument (/definitions/portType) mit dem
spezifizierten Port Typ Namen hinzu.

Es verbindet ein Set von Web Service Methoden die im Sinne der ``Zend\Soap\Server`` Implementation definiert sind.

Siehe `http://www.w3.org/TR/wsdl#_porttypes`_ für Details.

.. _zend.soap.wsdl.add_port_operation:

Die addPortOperation() Methode
------------------------------

Die *addPortOperation($portType, $name, $input = false, $output = false, $fault = false)* Methode fügt eine neue
Port Operation zum spezifizierten Port Typ des WSDL Dokuments hinzu (/definitions/portType/operation).

Jede Port Operation korrespondiert zu einer Methode der Klasse (wenn der Web Service auf einer Klasse basiert) oder
Funktion (wenn der Web Service auf einem Set von Methoden basiert) im Sinne der ``Zend\Soap\Server``
Implementation.

Sie fügt auch eine korrespondierende Port Operations Nachricht hinzu anhängig von den spezifizierten ``$input``,
``$output`` und ``$fault`` Parametern.

   .. note::

      Die ``Zend\Soap\Server`` Komponente erzeugt zwei Nachrichten für jede Port Operation wärend das Service das
      auf der ``Zend\Soap\Server`` Klasse basiert beschrieben wird:



         - Eine Eingabe Nachricht mit dem Namen *$methodName . 'Request'*.

         - Eine Ausgabe Nachricht mit dem Namen *$methodName . 'Response'*.





Siehe `http://www.w3.org/TR/wsdl#_request-response`_ für Details.

.. _zend.soap.wsdl.add_binding:

Die addBinding() Methode
------------------------

Die ``addBinding($name, $portType)`` Methode fügt neue Bindungen in das WSDL Dokument ein (/definitions/binding).

Der 'binding' WSDL Dokument Knoten definiert das Nachrichtenformat und Protokolldetails für Operationen und
Nachrichten die von einem speziellen portType definiert sind (siehe `http://www.w3.org/TR/wsdl#_bindings`_).

Die Methode erzeugt einen Bindungsknoten und gibt diesen zurück. Dieser kann dann verwendet werden um mit
aktuellen Daten gefüllt zu werden.

Die ``Zend\Soap\Server`` Implementation verwendet den *$serviceName . 'Binding'* Namen für das 'binding' Element
eines WSDL Dokuments.

.. _zend.soap.wsdl.add_binding_operation:

Die addBindingOperation() Methode
---------------------------------

Die *addBindingOperation($binding, $name, $input = false, $output = false, $fault = false)* Methode fügt eine
Operation zu einem gebundenen Element mit dem spezifizierten Namen hinzu (/definitions/binding/operation).

Sie nimmt das *XML_Tree_Node* Objekt das von ``addBinding()`` zurückgegeben wird als Eingabe (``$binding``
Parameter) um ein 'operation' Element mit Eingabe/Ausgabe/Falsch Einträgen hinzuzufügen abhängig von den
spezifizierten Parametern.

Die ``Zend\Soap\Server`` Implementation fügt korrespondierende gebundene Einträge für jede Web Service Methode
mit Eingabe und Ausgabe Einträgen hinzu die ein 'soap:body' Element als '<soap:body use="encoded"
encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"/> definieren.

Siehe `http://www.w3.org/TR/wsdl#_bindings`_ für Details.

.. _zend.soap.wsdl.add_soap_binding:

Die addSoapBinding() Methode
----------------------------

Die *addSoapBinding($binding, $style = 'document', $transport = 'http://schemas.xmlsoap.org/soap/http')* Methode
fügt einen *SOAP* Bindung Eintrag ('soap:binding') zum Bindung Element (welches bereits zu einigen Port Typen
verbunden ist) mit dem spezifizierten Stil und Transport hinzu (Die Zend\Soap\Server Implementation verwendet RPC
Stil über *HTTP*).

Das '/definitions/binding/soap:binding' Element wird verwendet um zu signieren dass das Bindung zum *SOAP*
Protokoll Format gebunden ist.

Siehe `http://www.w3.org/TR/wsdl#_bindings`_ für Details.

.. _zend.soap.wsdl.add_soap_operation:

Die addSoapOperation() Methode
------------------------------

Die ``addSoapOperation($binding, $soap_action)`` Methode fügt einen *SOAP* Operations Eintrag ('soap:operation')
zum Bindungs Element mit den spezifizierten Aktionen hinzu. Das 'style' Attribut des 'soap:operation' Elements wird
nicht verwendet seit das Programmier Modell (RPC-orientiert oder Dokument-orientiert) die ``addSoapBinding()``
Methode verwenden kann.

Das 'soapAction' Attribut des '/definitions/binding/soap:operation' Elements spezifiziert den Wert des *SOAP*\
Action Headers für diese Operation. Dieses Attribut wird für *SOAP* über *HTTP* benötigt und **darf in keinem
Fall** für andere Transporte spezifiziert werden.

Die ``Zend\Soap\Server`` Implementation verwendet *$serviceUri . '#' . $methodName* für den *SOAP* Operations
Action Namen.

Siehe `http://www.w3.org/TR/wsdl#_soap:operation`_ für Details.

.. _zend.soap.wsdl.add_service:

Die addService() Methode
------------------------

Die ``addService($name, $port_name, $binding, $location)`` Methode fügt dem WSDL Dokument ein
'/definitions/service' Element mit dem spezifizierten Web Service Namen, Port Namen, Bindung und Ort hinzu.

WSDL 1.1 erlaubt es verschiedene Port Typen pro Service zu haben (Sets von Operationen). Diese Fähigkeit wird von
der ``Zend\Soap\Server`` Implementation nicht verwendet und von der ``Zend\Soap\Wsdl`` Klasse nicht unterstützt.

Die ``Zend\Soap\Server`` Implementation verwendet:



   - *$name . 'Service'* als Name des Web Services,

   - *$name . 'Port'* als Name des Port Typs,

   - *'tns:' . $name . 'Binding'* [#]_ als Bindungs Name,

   - Die Skript *URI* [#]_ als eine Service URI für die Web Service Definition bei Verwendung von Klassen.

wobei ``$name`` der Klassenname für die Web Service Definition ist wenn Klassen verwendet werden und Skript Name
für die Web Service Definition wenn ein Set von Funktionen verwendet wird.

Siehe `http://www.w3.org/TR/wsdl#_services`_ für Details.

.. _zend.soap.wsdl.types:

Typ Entsprechung
----------------

Die ``Zend_Soap`` WSDL Implementation der Zugriffsmethoden verwendet die folgenden Typ Entsprechungen zwischen
*PHP* und *SOAP* Typen:



   - *PHP* Strings <-> *xsd:string*.

   - *PHP* Integer <-> *xsd:int*.

   - *PHP* Float (Fliesskomma) und Double <-> *xsd:float*.

   - *PHP* Boolean <-> *xsd:boolean*.

   - *PHP* Arrays <-> *soap-enc:Array*.

   - *PHP* Objekt <-> *xsd:struct*.

   - *PHP* Klasse <-> basierend auf der Strategie der komplexen Typen (Siehe: :ref:`diesen Abschnitt
     <zend.soap.wsdl.types.add_complex>`) [#]_.

   - PHP Void <-> Leerer Typ.

   - Wenn der Typ auf irgendeinem Grund zu keinem dieser Typen passt, dann wird *xsd:anyType* verwendet.

Wo *xsd:* ein "http://www.w3.org/2001/XMLSchema" Namespace ist, ist *soap-enc:* ein
"http://schemas.xmlsoap.org/soap/encoding/" Namespace, und *tns:* ist ein "Ziel Namespace" für das Service.

.. _zend.soap.wsdl.types.retrieve:

Empfangen von Typ Informationen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die ``getType($type)`` Methode kann verwendet werden um ein Mapping für einen spezifizierten *PHP* Typ zu
erhalten:

.. code-block:: php
   :linenos:

   ...
   $wsdl = new Zend\Soap\Wsdl('My_Web_Service', $myWebServiceUri);

   ...
   $soapIntType = $wsdl->getType('int');

   ...
   class MyClass {
       ...
   }
   ...
   $soapMyClassType = $wsdl->getType('MyClass');

.. _zend.soap.wsdl.types.add_complex:

Hinzufügen komplexer Typ Informationen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die ``addComplexType($type)`` Methode wird verwendet um komplexe Typen (PHP Klassen) zu einem WSDL Dokument
hinzuzufügen.

Es wird automatisch von der ``getType()`` Methode verwendet und fügt einen korrespondierenden komplexen Typen von
Methodenparametern oder Rückgabetypen hinzu.

Der Algorithmus für das Erkennen und Aufbauen basiert auf der aktuellen Strategie für die aktive Erkennung von
komplexen Typen. Man kann die Strategie für die Erkennung setzen indem entweder der Klassenname as String
spezifiziert wird, oder indem eine Instanz einer ``Zend\Soap\Wsdl\Strategy\Interface`` Implementation als dritter
Parameter des Konstruktors verwendet wird, oder indem die ``setComplexTypeStrategy($strategy)`` Funktion von
``Zend\Soap\Wsdl`` verwendet wird. Die folgenden Strategien für die Erkennung existieren aktuell:

- Klasse ``Zend\Soap\Wsdl\Strategy\DefaultComplexType``: Standardmäßig aktiviert (wenn dem Konstruktor kein
  dritter Parameter gesetzt wird). Er iteriert über die öffentlichen Attribute eines Klassentyps und registriert
  Sie als Untertypen des komplexen Objekttyps.

- Klasse ``Zend\Soap\Wsdl\Strategy\AnyType``: Castet alle komplexen Typen in einen einfachen XSD Typ xsd:anyType.
  Vorsicht ist angeraten da diese Abkürzung für die Erkennung von komplexen Typen kann warscheinlich nur von lose
  typisierten Sprachen wie *PHP* erfolgreich behandelt werden.

- Klasse ``Zend\Soap\Wsdl\Strategy\ArrayOfTypeSequence``: Diese Strategie erlaubt es die Rückgabeparameter mit
  diesen Typen zu spezifizieren: *int[]* oder *string[]*. Ab dem Zend Framework Version 1.9 können beide, sowohl
  einfache *PHP* Typen wie Int, String, Boolean, Float sowie Objekte und Arrays von Objekten behandelt werden.

- Klasse ``Zend\Soap\Wsdl\Strategy\ArrayOfTypeComplex``: Diese Strategie erlaubt die Erkennung von sehr komplexen
  Arrays von Objekten. Objekttypen werden basierend auf ``Zend\Soap\Wsdl\Strategy\DefaultComplexType`` erkannt und
  ein Array wird um diese Definition gewrappt.

- Klasse ``Zend\Soap\Wsdl\Strategy\Composite``: Diese Strategie kann alle Strategien kombinieren indem *PHP*
  komplexe Typen (Klassennamen) zu der gewünschten Strategie über die ``connectTypeToStrategy($type, $strategy)``
  Methode verbunden werden. Eine komplette Typemap kann dem Contructor als Array, mit ``$type``-> ``$strategy``
  Paaren angegeben werden. Der zweite Parameter spezifiziert die Standardstrategie die verwendet wird wenn ein
  unbekannter Typ hinzugefügt werden soll. Diese Parameter ist standardmäßig die
  ``Zend\Soap\Wsdl\Strategy\DefaultComplexType`` Strategie.

Die ``addComplexType()`` Methode erstellt ein '/definitions/types/xsd:schema/xsd:complexType' Element für jeden
beschriebenen komplexen Typen mit dem Namen der spezifizierten *PHP* Klasse.

Die Klassen Eigenschaften **MÜSSEN** ein Docblock Kapitel mit den beschriebenen *PHP* Typen haben damit die
Eigenschaft in die WSDL Beschreibung hinzugefügt wird.

``addComplexType()`` prüft ob der Typ bereits im Typ Kapitel des WSDL Dokuments beschrieben wird.

Es verhindert Duplikate wenn diese Methode zwei oder mehrmals aufgerufen wird und auch Rekursionen im Kapitel der
Typ Definitionen.

Siehe `http://www.w3.org/TR/wsdl#_types`_ für Details.

.. _zend.soap.wsdl.add_documentation:

Die addDocumentation() Methode
------------------------------

Die ``addDocumentation($input_node, $documentation)`` Methode fügt menschlich lesbare Dokumentation hinzu indem
das optionale 'wsdl:document' Element verwendet wird.

Das '/definitions/binding/soap:binding' Element wird verwendet um zu signieren das die Bindung zum *SOAP* Protokoll
Format gebunden wurde.

Siehe `http://www.w3.org/TR/wsdl#_documentation`_ für Details.

.. _zend.soap.wsdl.retrieve:

Das endgültige WSDL Dokument erhalten
-------------------------------------

Die ``toXML()``, ``toDomDocument()`` und *dump($filename = false)* Methoden können verwendet werden um das WSDL
Dokument als *XML*, DOM Struktur oder Datei zu erhalten.



.. _`http://www.w3.org/TR/wsdl#_messages`: http://www.w3.org/TR/wsdl#_messages
.. _`http://schemas.xmlsoap.org/soap/encoding/`: http://schemas.xmlsoap.org/soap/encoding/
.. _`http://www.w3.org/TR/wsdl#_porttypes`: http://www.w3.org/TR/wsdl#_porttypes
.. _`http://www.w3.org/TR/wsdl#_request-response`: http://www.w3.org/TR/wsdl#_request-response
.. _`http://www.w3.org/TR/wsdl#_bindings`: http://www.w3.org/TR/wsdl#_bindings
.. _`http://www.w3.org/TR/wsdl#_soap:operation`: http://www.w3.org/TR/wsdl#_soap:operation
.. _`http://www.w3.org/TR/wsdl#_services`: http://www.w3.org/TR/wsdl#_services
.. _`http://www.w3.org/TR/wsdl#_types`: http://www.w3.org/TR/wsdl#_types
.. _`http://www.w3.org/TR/wsdl#_documentation`: http://www.w3.org/TR/wsdl#_documentation

.. [#] *'tns:' namespace* wird als Skript *URI* definiert (*'http://' .$_SERVER['HTTP_HOST'] .
       $_SERVER['SCRIPT_NAME']*).
.. [#] *'http://' .$_SERVER['HTTP_HOST'] . $_SERVER['SCRIPT_NAME']*
.. [#] Standardmäßig wird ``Zend\Soap\Wsdl`` mit der Klasse ``Zend\Soap\Wsdl\Strategy\DefaultComplexType``
       als Erkennungsalgorithmus für komplexe Typen erstellt. Der erste Parameter des AutoDiscover
       Constructors nimmt jede Strategie für komplexe Typen die ``Zend\Soap\Wsdl\Strategy\Interface``
       implementiert oder einen String mit dem Namen dieser Klasse. Für Rückwärtskompatibilität mit den
       dem Boolean ``$extractComplexType`` werden Variablen auf dem folgenden Weg geparst: Bei ``TRUE``, wird
       ``Zend\Soap\Wsdl\Strategy\DefaultComplexType`` verwendet, und bei ``FALSE``
       ``Zend\Soap\Wsdl\Strategy\AnyType``.