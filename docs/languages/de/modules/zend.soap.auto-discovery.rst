.. _zend.soap.autodiscovery:

AutoDiscovery
=============

.. _zend.soap.autodiscovery.introduction:

AutoDiscovery Einführung
------------------------

Die *SOAP* Funktionalität die im Zend Framework implementiert ist, ist dazu gedacht alle benötigten Schritte für
die *SOAP* Kommunikation einfacher zu gestalten.

*SOAP* ist ein von der Sprache unabhängiges Protokoll. Deshalb kann es nicht nur für *PHP*-zu-PHP Kommunikation
verwendet werden.

Es gibt drei Konfigurationen für *SOAP* Anwendungen wo Zend Framework verwendet werden kann:



   . SOAP Server *PHP* Anwendung <---> *SOAP* Client *PHP* Anwendung

   . *SOAP* Server nicht-PHP Anwendung <---> *SOAP* Client *PHP* Anwendung

   . SOAP Server *PHP* Anwendung <---> *SOAP* Client nicht-PHP Anwendung



Wir müssen immer wissen, welche Funktionalität vom *SOAP* Server angeboten wird um mit Ihm zu arbeiten. `WSDL`_
wird verwendet um die Netzwerk Service *API* im Detail zu beschreiben.

Die WSDL Sprache ist komplex genug (siehe `http://www.w3.org/TR/wsdl`_ für die Details). Es ist also kompliziert
genug die richtige WSDL Beschreibung vorzubereiten.

Ein anderes Problem ist die Synchronisation von Änderungen in der Netzwerk Service *API* mit schon existierendem
WSDL.

Aber dieses Problem kann durch WSDL Autogeneration gelöst werden. Eine Vorbedingung dafür ist ein *SOAP* Server
Autodiscovery. Es erzeugt ein Objekt ähnlich dem Objekt das in der *SOAP* Server Anwendung verwendet wird,
extrahiert notwendige Informationen und erzeugt ein korrektes WSDL indem es die Information verwendet.

Es gibt zwei Wege für die Verwendung des Zend Framworks für *SOAP* Server Anwendungen:



   - Verwendung von eigenen Klassen.

   - Verwendung eines Sets von Funktionen



Beide Methoden werden von der Zend Framework Autodiscovery Funktionalität unterstützt.

Die ``Zend_Soap_AutoDiscovery`` Klasse unterstützt auch das Mapping von Datentypen von *PHP* zu `XSD Typen`_.

Hier ist ein Beispiel einer üblichen Verwendung der Autodiscovery Funktionalität. Die Funktion ``handle()``
erzeugt die WSDL Datei und postet Sie an den Browser.

.. code-block:: php
   :linenos:

   class My_SoapServer_Class {
   ...
   }

   $autodiscover = new Zend_Soap_AutoDiscover();
   $autodiscover->setClass('My_SoapServer_Class');
   $autodiscover->handle();

Wenn man auf die erzeugte WSDL Datei zugreifen muß um Sie in eine Datei oder als *XML* String abzuspeichern, kann
man die Funktionen ``dump($filename)`` oder ``toXml()`` verwenden welche die AutoDiscovery Klasse anbietet.

.. note::

   **Zend_Soap_Autodiscover ist kein Soap Server**

   Es ist wichtig anzumerken, das die Klasse ``Zend_Soap_Autodiscover`` nicht für sich selbst als *SOAP* Server
   agiert. Sie erzeugt nur den WSDL und bietet Ihn jedem an der auf die URL zugreift auf die geschaut wird.

   Als Endpunkt der *SOAP* URI verwendet es den Standard *'http://' .$_SERVER['HTTP_HOST'] .
   $_SERVER['SCRIPT_NAME']*, der aber mit der ``setUri()`` Funktion oder dem Contructor Parameter der
   ``Zend_Soap_AutoDiscover`` Klasse verändert werden kann. Der Endpunkt muß an einen ``Zend_Soap_Server``
   übergeben werden der auf die Anfragen hört.

   .. code-block:: php
      :linenos:

      if(isset($_GET['wsdl'])) {
          $autodiscover = new Zend_Soap_AutoDiscover();
          $autodiscover->setClass('HelloWorldService');
          $autodiscover->handle();
      } else {
          // zeigt auf diese aktuelle Datei
          $soap = new Zend_Soap_Server("http://example.com/soap.php?wsdl");
          $soap->setClass('HelloWorldService');
          $soap->handle();
      }

.. _zend.soap.autodiscovery.class:

Automatische Erkennung von Klassen
----------------------------------

Wenn eine Klasse verwendet wird um SOAP Server Funktionalitäten anzubieten, dann sollte die selbe Klasse an
``Zend_Soap_AutoDiscover`` für die WSDL Erzeugung übergeben werden:

.. code-block:: php
   :linenos:

   $autodiscover = new Zend_Soap_AutoDiscover();
   $autodiscover->setClass('My_SoapServer_Class');
   $autodiscover->handle();

Die folgenden Regeln werden wärend der WSDL Erzeugung verwendet:



   - Erzeugtes WSDL beschreibt einen RPC srtigen Web Service.

   - Klassen Namen werden als Name des Web Services verwendet der beschrieben wird.

   - *'http://' .$_SERVER['HTTP_HOST'] . $_SERVER['SCRIPT_NAME']* wird als *URI* verwendet wenn das WSDL
     standardmäßig vorhanden ist und kann über die ``setUri()`` Methode überschrieben werden.

     Es wird auch als Ziel Namespace für alle Service bezogenen Namen verwendet (inklusive der beschriebenen
     komplexen Typen).

   - Klassen Methoden werden in einen `Port Typ`_ übernommen.

     *$className . 'Port'* wird als Port Typ Name verwendet.

   - Jede Klassen Methode wird als korrespondierende Port Operation registriert.

   - Jeder Methoden Prototyp erzeugt korrespondierende Anfrage/Antwort Nachrichten.

     Eine Methode kann verschiedene Prototypen haben wenn einige Parameter der Methode optional sind.



.. note::

   **Wichtig!**

   WSDL Autodiscovery verwendet *PHP* Docblocks die vom Entwickler angeboten werden um die Parameter und Return
   Typen zu erkennen. Faktisch ist das, für skalare Typen, der einzige Weg um die Parameter Typen zu erkennen und
   für Return Typen ist das der einzige Weg um Sie zu erkennen.

   Das bedeutet, das Anbieten von richtigen und komplett detailierten Docblocks ist nicht nur beste Praxis, sondern
   wird für das erkunden der Klasse benötigt.

.. _zend.soap.autodiscovery.functions:

Funktionen für Autodiscovery
----------------------------

Wenn ein Set von Funktionen verwendet wird um SOAP Server Funktionalität anzubieten, dann sollte das selbe Set mit
``Zend_Soap_AutoDiscovery`` für die WSDL Erzeugung verwendet werden:

.. code-block:: php
   :linenos:

   $autodiscover = new Zend_Soap_AutoDiscover();
   $autodiscover->addFunction('function1');
   $autodiscover->addFunction('function2');
   $autodiscover->addFunction('function3');
   ...
   $autodiscover->handle();

Die folgenden Regeln werden wärend der WSDL Erzeugung verwendet:



   - Ein erstelltes WSDL beschreibt einen RPC artigen Web Service.

   - Der aktuelle Skriptname wird als Name des Web Services verwendet der beschrieben wird.

   - *'http://' .$_SERVER['HTTP_HOST'] . $_SERVER['SCRIPT_NAME']* wird als *URI* verwendet wo WSDL vorhanden ist.

     Wird als Ziel Namespace für alle Service bezogenen Namen verwendet (inklusive der beschriebenen komplexen
     Typen).

   - Funktionen werden in einem `Port Typ`_ verbunden.

     *$functionName . 'Port'* wird als Port Typ Name verwendet.

   - Jede Funktion wird als korrespondierende Port Operation registriert.

   - Jeder Funktions Prototyp erzeugt eine korrespondierende Anfrage/Antwort Nachricht.

     Funktionen können verschiedene Prototypen haben wenn einige Parameter der Methode optional sind.



.. note::

   **Wichtig!**

   WSDL Autodiscovery verwendet *PHP* Docblocks die vom Entwickler angeboten werden um die Parameter und Return
   Typen zu erkennen. Faktisch ist das, für skalare Typen, der einzige Weg um die Parameter Typen zu erkennen und
   für Return Typen ist das der einzige Weg um Sie zu erkennen.

   Das bedeutet, das Anbieten von richtigen und komplett detailierten Docblocks ist nicht nur beste Praxis, sondern
   wird für das erkunden der Klasse benötigt.

.. _zend.soap.autodiscovery.datatypes:

Automatische Erkennung. Datentypen
----------------------------------

Eingabe/Ausgabe Datentypen werden in Netzwerk Service Typen konvertiert indem das folgende Mapping verwendet wird:



   - PHP Strings <-> *xsd:string*.

   - PHP Integer <-> *xsd:int*.

   - PHP Float und Double <-> *xsd:float*.

   - PHP Boolean <-> *xsd:boolean*.

   - PHP Arrays <-> *soap-enc:Array*.

   - PHP Objekt <-> *xsd:struct*.

   - *PHP* Klasse <-> basierend auf der Strategie der komplexen Typen (Siehe :ref:`diesen Abschnitt
     <zend.soap.wsdl.types.add_complex>`) [#]_.

   - type[] oder object[] (z.B. int[]) <-> basieren auf der Strategie der komplexen Typen

   - PHP Void <-> Leerer Typ.

   - Wenn der Typ aus irgendeinem Grund keinem dieser Typen entspricht, dann wird *xsd:anyType* verwendet.

Wo *xsd:* ein "http://www.w3.org/2001/XMLSchema" Namespace ist, ist *soap-enc:* ein
"http://schemas.xmlsoap.org/soap/encoding/" Namespace, und *tns:* ist ein "Ziel Namespace" für einen Service.

.. _zend.soap.autodiscovery.wsdlstyles:

Stile für das Binden von WSDL
-----------------------------

WSDL bietet verschiedene Transport Mechanismen und Stile. Das beeinträchtigt die *soap:binding* und *soap:body*
Tags in der Binding Sektion von WSDL. Unterschiedliche Clients haben unterschiedliche Anforderungen wie diese
Optionen wirklich arbeiten. Hierfür kann man die Stile setzen bevor man eine *setClass* oder *addFunction* Methode
auf der AutoDiscovery Klasse ausführt.

.. code-block:: php
   :linenos:

   $autodiscover = new Zend_Soap_AutoDiscover();
   // Standard ist 'use' => 'encoded' und
   // 'encodingStyle' => 'http://schemas.xmlsoap.org/soap/encoding/'
   $autodiscover->setOperationBodyStyle(
                       array('use' => 'literal',
                             'namespace' => 'http://framework.zend.com')
                   );

   // Standard ist 'style' => 'rpc' und
   // 'transport' => 'http://schemas.xmlsoap.org/soap/http'
   $autodiscover->setBindingStyle(
                       array('style' => 'document',
                             'transport' => 'http://framework.zend.com')
                   );
   ...
   $autodiscover->addFunction('myfunc1');
   $autodiscover->handle();



.. _`WSDL`: http://www.w3.org/TR/wsdl
.. _`http://www.w3.org/TR/wsdl`: http://www.w3.org/TR/wsdl
.. _`XSD Typen`: http://www.w3.org/TR/xmlschema-2/
.. _`Port Typ`: http://www.w3.org/TR/wsdl#_porttypes

.. [#] ``Zend_Soap_AutoDiscover`` wird mit der ``Zend_Soap_Wsdl_Strategy_DefaultComplexType`` Klasse als
       Erkennungsalgorithmus für komplexe Typen erstellt. Der erste Parameter des AutoDiscover Constructors
       nimmt jede Strategie für komplexe Typen die ``Zend_Soap_Wsdl_Strategy_Interface`` implementieren oder
       einen String mit dem Nmaen der Klasse. Um Backwards Compatibility mit ``$extractComplexType`` zu
       gewährleisten werden boolsche Variablen wie in ``Zend_Soap_Wsdl`` geparst. Siehe das
       :ref:`Zend_Soap_Wsdl Manual über das Hinzufügen von komplexen <zend.soap.wsdl.types.add_complex>`
       Typen für weitere Informationen.