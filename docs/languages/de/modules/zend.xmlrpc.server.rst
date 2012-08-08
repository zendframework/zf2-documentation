.. EN-Revision: none
.. _zend.xmlrpc.server:

Zend_XmlRpc_Server
==================

.. _zend.xmlrpc.server.introduction:

Einführung
----------

``Zend_XmlRpc_Server`` ist als vollständiger *XML-RPC* Server geplant, der den `Spezifikationen auf
www.xmlrpc.com`_ folgt. Des Weiteren implementiert er die Methode ``system.multicall()``, welche dem Entwickler
erlaubt, mehrere Anfragen aufzureihen.

.. _zend.xmlrpc.server.usage:

Grundlegende Benutzung
----------------------

Ein Beispiel der grundlegendsten Benutzung:

.. code-block:: php
   :linenos:

   $server = new Zend_XmlRpc_Server();
   $server->setClass('My_Service_Class');
   echo $server->handle();

.. _zend.xmlrpc.server.structure:

Server-Struktur
---------------

``Zend_XmlRpc_Server`` ist aus einer Vielfalt von Komponenten zusammengesetzt, die vom Server selbst über
Anfrage-, Antwort- und bis hin zu Fehler-Objekten reicht.

Um den ``Zend_XmlRpc_Server`` zu erstellen, muss der Entwickler dem Server eine oder mehrere Klassen oder
Funktionen durch die Methoden ``setClass()`` und ``addFunction()`` hinzufügen.

Wenn dieses erstmal erledigt wurde, kann man entweder der Methode ``Zend_XmlRpc_Server::handle()`` ein
``Zend_XmlRpc_Request``-Objekt übergeben oder es wird ein ``Zend_XmlRpc_Request_Http`` instanziert, falls keines
angegeben wurde - die Anfrage wird also aus ``php://input`` geladen.

``Zend_XmlRpc_Server::handle()`` versucht daraufhin, den zuständigen Handler, der durch die angeforderte Methode
bestimmt wird, auszuführen. Es wird entweder ein ``Zend_XmlRpc_Response``- oder ein
``Zend_XmlRpc_Server_Fault``-Objekt zurückgegeben. Beide Objekte besitzen eine Methode ``__toString()``, die eine
gültige *XML-RPC* Antwort im *XML*-Format zurückgibt, die direkt ausgegeben werden kann.

.. _zend.xmlrpc.server.anatomy:

Anatomie eines Webservices
--------------------------

.. _zend.xmlrpc.server.anatomy.general:

Generelle Annahmen
^^^^^^^^^^^^^^^^^^

Für eine maximale Performance ist es Notwendig eine einfache Bootstrap Datei für die Server Komponente zu
verwenden. Der Verwendung von ``Zend_XmlRpc_Server`` innerhalb von :ref:`Zend_Controller <zend.controller>` wird
strengstens abgeraten um den Overhead zu vermeiden.

Services ändern sich mit der Zeit, und wärend sich Webservices generell weniger intensiv ändern wie Code-native
*APIs*, wird empfohlen den eigenen Service zu versionieren. Das legt den Grundstein für die Kompatibilität zu
Clients welche eine ältere Version des eigenen Services verwenden und managt den Lebenszyklus des Services. Um das
zu tun sollte eine Versionsnummer in die *URI* eingefügt werden. Es wird auch empfohlen den Namen des Remote
Protokolls in der *URI* einzufügen um eine einfache Integration von zukünftigen Remote Technologien zu erlauben.
http://myservice.ws/**1.0/XMLRPC/**.

.. _zend.xmlrpc.server.anatomy.expose:

Was kann man freigeben?
^^^^^^^^^^^^^^^^^^^^^^^

Meistens ist es nicht sensibel Business Objekte direkt freizugeben. Business Objekte sind normalerweise klein und
werden häufig geändert, da die Änderung in diesem Layer der Anwendung sehr billig ist. Sobald Webservices
bekanntgegeben und verwendet werden ist eine Änderung sehr hart. Andere Vorbehalte sind *I/O* und Latenz: die
besten Aufrufe von Webservices sind jene die nicht stattfinden. Deswegen müssen Aufrufe zu Services grob körniger
sein als die normale Business Logik selbst. Oft macht ein zusätzlicher Layer vor der Business Logik sinn. Dieser
Layer wird manchmal als `Remote Facade`_ bezeichnet. Solch ein Service Layer fügt ein grob körniges Interface
über der Business Logik hinzu und gruppiert langatmige Operationen zu kleineren.

.. _zend.xmlrpc.server.conventions:

Konventionen
------------

``Zend_XmlRpc_Server`` ermöglicht es dem Entwickler, Funktionen und Methodenaufrufe als ausführbare *XML-RPC*
Methoden anzufügen. Durch ``Zend_Server_Reflection`` wird die Überwachung aller angefügten Methoden - durch
Nutzung der DocBlocks der Methoden und Funktionen werden deren Hilfstexte und Signaturen ermittelt - ermöglicht.

*XML-RPC* Typen werden nicht zwingend 1:1 zu *PHP* Typen konvertiert. Dennoch wird versucht, einen passenden Typ,
anhand der in @param- und @return-Zeilen enthaltenen Werte, zu ermitteln. Einige *XML-RPC* Typen besitzen jedoch
kein direktes Äquivalent und sollten deshalb mittels *PHP*\ doc auf einen *XML-RPC* Typen hinweisen. Diese
beinhalten:

- **dateTime.iso8601**, ein String, der das Format ``YYYYMMDDTHH:mm:ss`` besitzt

- **base64**, base64-kodierte Daten

- **struct**, jegliches assoziatives Array

'Anbei ein Beispiel für einen solchen Hinweis:

.. code-block:: php
   :linenos:

   /**
   * Dies ist eine Beispielfunktion.
   *
   * @param base64 $val1 Base64-kodierte Daten
   * @param dateTime.iso8601 $val2 Ein ISO-Datum
   * @param struct $val3 ein assoziatives Array
   * @return struct
   */
   function myFunc($val1, $val2, $val3)
   {
   }

PhpDocumentor validiert keine Typen, die in Parameter- oder Rückgabewerten angegeben sind, weshalb dies keinen
Einfluss auf die *API* Dokumentation hat. Das Angeben der Hinweise ist notwendig, da der Server die, dem
Methodenaufruf zugewiesenen, Parameter validiert.

Es ist genauso gut möglich, mehrere Werte als Parameter oder für die Rückgabe anzugeben; die *XML-RPC*
Spezifikation schlägt sogar vor, dass system.methodeSignatur ein Array, das alle möglichen Methodensignaturen
(d.h. jegliche Kombination aus Parametern und Rückgabewerten) enthält, zurückgibt. Um dies zu erreichen, kann
man, wie man es normalerweise auch beim PhpDocumentor auch tun würde, einfach den '\|'-Operator nutzen.

.. code-block:: php
   :linenos:

   /**
   * Dies ist eine Beispiel-Funktion.
   *
   * @param string|base64 $val1 String oder base64-kodierte Daten
   * @param string|dateTime.iso8601 $val2 String oder ein ISO-Datum
   * @param array|struct $val3 Normal indiziertes oder assoziatives Array
   * @return boolean|struct
   */
   function myFunc($val1, $val2, $val3)
   {
   }

.. note::

   Wenn man viele Signaturen erlaubt kann dies zu Verwirrung bei Entwicklern führen, welche diese Services nutzen;
   um die Dinge einfach zu halten sollte eine *XML-RPC* Methode deshalb nur eine Signatur haben.

.. _zend.xmlrpc.server.namespaces:

Nutzen von Namensräumen
-----------------------

*XML-RPC* besitzt ein Konzept für Namensräume; Grundlegend erlaubt es das Gruppieren von *XML-RPC* Methoden durch
Punkt-separierte Namensräume. Dies hilft, Namenkollisionen zwischen Methoden, die durch verschiedene Klassen
offeriert werden, zu verhindern. Beispielsweise kann der *XML-RPC* Server mehrere Methoden im 'system'-Namensraum
nutzen:

- system.listMethods

- system.methodHelp

- system.methodSignature

Intern werden die Methoden zu Methoden desselben Namens in der Klasse ``Zend_XmlRpc_Server`` umgeleitet.

Um angebotenen Methoden Namensräume hinzuzufügen, muss man lediglich beim Hinzufügen der gewünschten Klasse
oder Funktion einen Namensraum angeben:

.. code-block:: php
   :linenos:

   // Alle öffentlichten Methoden in My_Service_Class sind als
   // myservice.METHODNAME verfügbar
   $server->setClass('My_Service_Class', 'myservice');

   // Funktion 'somefunc' ist als funcs.somefunc ansprechbar.
   $server->addFunction('somefunc', 'funcs');

.. _zend.xmlrpc.server.request:

Eigene Request-Objekte
----------------------

Die meiste Zeit wird man einfach den Standard-Anfragetyp ``Zend_XmlRpc_Request_Http``, welcher im
``Zend_XmlRpc_Server`` enthalten ist, nutzen. Jedoch gibt es gelegentlich Fälle, in denen *XML-RPC* über die
Kommandozeile (*CLI*), ein grafisches Benutzerinterface (*GUI*), eine andere Umgebung oder beim Protokollieren von
ankommenden Anfragen erreichbar sein muss. Um dies zu bewerkstelligen, muss man ein eigenes Anfrage-Objekt
kreieren, das ``Zend_XmlRpc_Request`` erweitert. Die wichtigste Sache, die man sich merken muss, ist
sicherzustellen, dass die Methoden ``getMethod()`` und ``getParams()`` implementiert sind, so dass der *XML-RPC*
Server Informationen erhält, die er für das Abfertigen einer Anfrage benötigt.

.. _zend.xmlrpc.server.response:

Eigene Antwort-Objekte
----------------------

Ähnlich wie bei den Anfrage-Objekten, kann der ``Zend_XmlRpc_Server`` auch eigene Antwortobjekte ausliefern;
standardmäßig ist dies ein ``Zend_XmlRpc_Response_Http-Objekt``, das einen passenden Content-Type *HTTP*-Header
sendet, der für *XML-RPC* genutzt wird. Mögliche Nutzungen eines eigenen Objekts sind z.B. das Protokollieren von
Antworten oder das Senden der Antworten zu ``STDOUT``.

Um eine eigene Antwortklasse zu nutzen, muss ``Zend_XmlRpc_Server::setResponseClass()`` vor dem Aufruf von
``handle()`` aufgerufen werden.

.. _zend.xmlrpc.server.fault:

Verarbeiten von Exceptions durch Fehler
---------------------------------------

``Zend_XmlRpc_Server`` fängt die, durch eine ausgeführte Methode erzeugten, Exceptions and generiert daraus einen
*XML-RPC* Fehler als Antwort, wenn eine Exception gefangen wurde. Normalerweise werden die Exceptionnachrichten und
-codes nicht in der Fehler-Antwort genutzt. Dies ist eine gewollte Entscheidung um den Code zu schützen; viele
Exceptions entblößen mehr Informationen über den Code oder die Umgebung als der Entwickler wünscht (ein
Paradebeispiel beinhaltet Datenbankabstraktion- oder die Zugriffsschichten-Exceptions).

Exception-Klassen können jedoch anhand einer Weißliste (Whitelist) als Fehler-Antworten zurückgegeben werden.
Dazu muss man lediglich die gewünschte Exception mittels ``Zend_XmlRpc_Server_Fault::attachFaultException()`` zur
Weißliste hinzufügen:

.. code-block:: php
   :linenos:

   Zend_XmlRpc_Server_Fault::attachFaultException('My_Project_Exception');

Abgeleitete Exceptions lassen sich als ganze Familie von Exceptions hinzufügen, indem man deren Basisklasse
angibt. ``Zend_XmlRpc_Server_Exception``'s sind immer auf der Weißliste zu finden, da sie spezielle Serverfehler
berichten (undefinierte Methoden, etc.).

Jede Exception, die nicht auf der Weißliste zu finden ist, generiert eine Antwort mit dem '404' Code und der
Nachricht 'Unknown error'.

.. _zend.xmlrpc.server.caching:

Zwischenspeichern von Serverdefinitionen zwischen den Anfragen
--------------------------------------------------------------

Das Hinzufügen einer Vielzahl von Klassen zu einer *XML-RPC* Server Instanz kann zu einem großen
Ressourcenverbrauch führen; jede Klasse muss via Reflection *API* (``Zend_Server_Reflection``) inspiziert werden,
welche eine Liste von allen möglichen Signaturen, die der Server verwenden kann, zurückgibt.

Um die Einbußen zu reduzieren, kann ``Zend_XmlRpc_Server_Cache`` genutzt werden, welche die Serverdefinitionen
zwischen den Anfragen zwischenspeichert. Wenn dies mit ``__autoload()`` kombiniert wird, kann es zu einem großen
Geschwindigkeitsschub kommen.

Ein Beispiel folgt:

.. code-block:: php
   :linenos:

   function __autoload($class)
   {
       Zend_Loader::loadClass($class);
   }

   $cacheFile = dirname(__FILE__) . '/xmlrpc.cache';
   $server = new Zend_XmlRpc_Server();

   if (!Zend_XmlRpc_Server_Cache::get($cacheFile, $server)) {
       require_once 'My/Services/Glue.php';
       require_once 'My/Services/Paste.php';
       require_once 'My/Services/Tape.php';

       $server->setClass('My_Services_Glue', 'glue');   // glue. Namensraum
       $server->setClass('My_Services_Paste', 'paste'); // paste. Namensraum
       $server->setClass('My_Services_Tape', 'tape');   // tape. Namensraum

       Zend_XmlRpc_Server_Cache::save($cacheFile, $server);
   }

   echo $server->handle();

Obiges Beispiel zeigt, wie der Server versucht, eine Definition aus der Datei ``xmlrpc.cache``, welches sich im
selben Ordner wie das Skript befindet, zu laden. Wenn dies nicht erfolgreich ist, lädt es die Server-Klassen, die
es benötigt, und fügt sie zum Server hinzu. Danach wird versucht, die Cache-Datei mit der Serverdefinition zu
erstellen.

.. _zend.xmlrpc.server.use:

Nutzungsbeispiele
-----------------

Unten finden sich etliche Beispiele für eine Nutzung, die das gesamte Spektrum der verfügbaren Optionen für den
Entwickler darstellen. These Beispiele bauen immer auf den vorangegangenen Beispielen auf.

.. _zend.xmlrpc.server.use.attach-function:

.. rubric:: Grundlegende Benutzung

Folgendes Beispiel fügt eine Funktion als ausführbare *XML-RPC* Methode hinzu und verarbeitet eingehende Aufrufe.

.. code-block:: php
   :linenos:

   /**
    * Gibt die MD5-Summe eines Strings zurück.
    *
    * @param string $value Wert aus dem die MD5-Summe errechnet wird
    * @return string MD5-Summe des Werts
    */
   function md5Value($value)
   {
       return md5($value);
   }

   $server = new Zend_XmlRpc_Server();
   $server->addFunction('md5Value');
   echo $server->handle();

.. _zend.xmlrpc.server.use.attach-class:

.. rubric:: Hinzufügen einer Klasse

Das nächste Beispiel illustriert, wie man die öffentlichen Methoden eienr Klasse als ausführbare *XML-RPC*
Methoden hinzufügt.

.. code-block:: php
   :linenos:

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb');
   echo $server->handle();

.. _zend.xmlrpc.server.use.attach-class-with-arguments:

.. rubric:: Hinzufügen einer Klasse mit Argumenten

Das folgende Beispiel zeigt wie öffentliche Methoden einer Klasse hinzugefügt werden und an deren Methoden
Argumente übergeben werden können. Das kann verwendet werden um spezielle Standardwerte zu spezifizieren wenn
Serviceklassen registriert werden.

.. code-block:: php
   :linenos:

   class Services_PricingService
   {
       /**
        * Calculate current price of product with $productId
        *
        * @param ProductRepository $productRepository
        * @param PurchaseRepository $purchaseRepository
        * @param integer $productId
        */
       public function calculate(ProductRepository $productRepository,
                                 PurchaseRepository $purchaseRepository,
                                 $productId)
       {
           ...
       }
   }

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_PricingService',
                     'pricing',
                     new ProductRepository(),
                     new PurchaseRepository());

Die Argumente welche an ``setClass()`` wärend der Erstellungszeit des Servers übergeben werden, werden dem
Methodenaufruf ``pricing.calculate()`` injiziert, wenn er aufgerufen wird. Im obigen Beispiel wird vom Client nur
das Argument ``$purchaseId`` erwartet.

.. _zend.xmlrpc.server.use.attach-class-with-arguments-constructor:

.. rubric:: Argumente nur dem Constructor übergeben

``Zend_XmlRpc_Server`` erlaubt es die Übergabe von Argumenten nur für den Constructor zu limitieren. Das kann
für Dependency Injection beim Constructor verwendet werden. Um die Injektion auf Constructoren zu begrenzen muss
``sendArgumentsToAllMethods`` aufgerufen und ``FALSE`` als Argument übergeben werden. Dies deaktiviert das
Standardverhalten mit dem alle Argumente in die entfernte Methode injiziert werden. Im nächsten Beispiel werden
die Instanzen von ``ProductRepository`` und ``PurchaseRepository`` nur in dem Constructor von
``Services_PricingService2`` injiziert.

.. code-block:: php
   :linenos:

   class Services_PricingService2
   {
       /**
        * @param ProductRepository $productRepository
        * @param PurchaseRepository $purchaseRepository
        */
       public function __construct(ProductRepository $productRepository,
                                   PurchaseRepository $purchaseRepository)
       {
           ...
       }

       /**
        * Calculate current price of product with $productId
        *
        * @param integer $productId
        * @return double
        */
       public function calculate($productId)
       {
           ...
       }
   }

   $server = new Zend_XmlRpc_Server();
   $server->sendArgumentsToAllMethods(false);
   $server->setClass('Services_PricingService2',
                     'pricing',
                     new ProductRepository(),
                     new PurchaseRepository());

.. _zend.xmlrpc.server.use.attach-instance:

.. rubric:: Die Instanz einer Klasse anhängen

``setClass()`` erlaubt es ein vorher instanziertes Objekt beim Server zu registrieren. Man muss nur die Instanz
statt dem Namen der Klasse übergeben. Natürlich ist die Übergabe von Argumenten an den Constructor bei vorher
instanzierten Objekten nicht möglich.

.. _zend.xmlrpc.server.use.attach-several-classes-namespaces:

.. rubric:: Mehrere Klassen unter der Nutzung von Namensräumen hinzufügen

Das nächste Beispiel zeigt, wie man mehrer Klassen mit ihren eigenen Namensräumen hinzufügt.

.. code-block:: php
   :linenos:

   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   $server = new Zend_XmlRpc_Server();

   // Methoden werden als comb.* aufgerufen
   $server->setClass('Services_Comb', 'comb');

   // Methoden werden als brush.* aufgerufen
   $server->setClass('Services_Brush', 'brush');

   // Methoden werden als pick.* aufgerufen
   $server->setClass('Services_Pick', 'pick');
   echo $server->handle();

.. _zend.xmlrpc.server.use.exception-faults:

.. rubric:: Bestimmen von Exceptions als gültige Fehler-Antwort

Im nächsten Beispiel wird gezeigt, wie man jede Exception, die von ``Services_Exception`` abgeleitet wurde, als
Fehler-Antwort nutzen kann, dessen Nachricht und Code erhalten bleibt.

.. code-block:: php
   :linenos:

   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Services_Exceptions dürfen als Fehler-Antwort genutzt werden
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();

   // Methoden werden als comb.* aufgerufen
   $server->setClass('Services_Comb', 'comb');

   // Methoden werden als brush.* aufgerufen
   $server->setClass('Services_Brush', 'brush');

   // Methoden werden als pick.* aufgerufen
   $server->setClass('Services_Pick', 'pick');
   echo $server->handle();

.. _zend.xmlrpc.server.use.custom-request-object:

.. rubric:: Anpassen eigener Anfrage und Antwort Objekte

Einige Anwendungsfälle verlangen die Verwendung eines eigenen Request Objektes. Zum Beispiel ist *XML/RPC* nicht
an *HTTP* als Übertragungsprotokoll gebunden. Es ist möglich auch andere Übertragungsprotokolle wie *SSH* oder
Telnet zu verwenden um Anfrage und Antwort Daten über den Draht zu senden. Ein anderer Anwendungsfall ist die
Authentifizierung und Authorisierung. Im Falle eines anderen Übertragungsprotokolls muss die Implementation
geändert werden damit Anfrage Daten gelesen werden können.

Im folgenden Beispiel wird ein eigenes Anfrage-Objekt instanziert und durch den Server verarbeitet.

.. code-block:: php
   :linenos:

   require_once 'Services/Request.php';
   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Services_Exceptions dürfen als Fehler-Antwort genutzt werden
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();

   // Methoden werden als comb.* aufgerufen
   $server->setClass('Services_Comb', 'comb');

   // Methoden werden als brush.* aufgerufen
   $server->setClass('Services_Brush', 'brush');

   // Methoden werden als pick.* aufgerufen
   $server->setClass('Services_Pick', 'pick');

   // Ein neues Anfrage-Objekt wird erstellt
   $request = new Services_Request();

   echo $server->handle($request);

.. _zend.xmlrpc.server.use.custom-response-object:

.. rubric:: Eine eigene Antwort Klasse spezifizieren

Das nachstehende Beispiel zeigt, wie man eine eigene Antwort-Klasse als zurückgegebene Antwort für den Server
setzt.

.. code-block:: php
   :linenos:

   require_once 'Services/Request.php';
   require_once 'Services/Response.php';
   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // Services_Exceptions dürfen als Fehler-Antwort genutzt werden
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();

   // Methoden werden als comb.* aufgerufen
   $server->setClass('Services_Comb', 'comb');

   // Methoden werden als brush.* aufgerufen
   $server->setClass('Services_Brush', 'brush');

   // Methoden werden als pick.* aufgerufen
   $server->setClass('Services_Pick', 'pick');

   // Ein neues Anfrage-Objekt wird erstellt
   $request = new Services_Request();

   // Nutzen eigener Antwort-Klasse
   $server->setResponseClass('Services_Response');

   echo $server->handle($request);

.. _zend.xmlrpc.server.performance:

Performance Optimierung
-----------------------

.. _zend.xmlrpc.server.performance.caching:

.. rubric:: Zwischenspeichern von Serverdefinition zwischen den Anfragen

Dieses Beispiel zeigt, wie man Serverdefinitionen zwischen verschiedenen Anfragen zwischenspeichern kann.

.. code-block:: php
   :linenos:

   // Definieren einer Cache-Datei
   $cacheFile = dirname(__FILE__) . '/xmlrpc.cache';

   // Services_Exceptions dürfen als Fehler-Antwort genutzt werden
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();

   // Versucht die Serverdefinition aus dem Cache zu laden
   if (!Zend_XmlRpc_Server_Cache::get($cacheFile, $server)) {

       // Methoden werden als comb.* aufgerufen
       $server->setClass('Services_Comb', 'comb');

       // Methoden werden als brush.* aufgerufen
       $server->setClass('Services_Brush', 'brush');

       // Methoden werden als pick.* aufgerufen
       $server->setClass('Services_Pick', 'pick');

       // Speichern des Caches
       Zend_XmlRpc_Server_Cache::save($cacheFile, $server);
   }

   // Ein neues Anfrage-Objekt wird erstellt
   $request = new Services_Request();

   // Nutzen eigener Antwort-Klasse
   $server->setResponseClass('Services_Response');

   echo $server->handle($request);

.. note::

   Die Datei des Server Caches sollte ausserhalb des Document Roots platziert werden.

.. _zend.xmlrpc.server.performance.xmlgen:

.. rubric:: Optimizing XML generation

``Zend_XmlRpc_Server`` verwendet ``DOMDocument`` der *PHP* Erweiterung **ext/dom** um seine *XML* Ausgaben zu
erstellen. Wärend **ext/dom** auf vielen Hosts vorhanden ist, ist es nicht wirklich das schnellste. Benchmarks
haben gezeigt das ``XmlWriter`` von **ext/xmlwriter** schneller ist.

Wenn **ext/xmlwriter** auf dem eigenen Host vorhanden ist, kann ein ``XmlWriter``-basierter Generator ausgewählt
werden um die Performance Unterschiede auszunutzen.

.. code-block:: php
   :linenos:

   require_once 'Zend/XmlRpc/Server.php';
   require_once 'Zend/XmlRpc/Generator/XmlWriter.php';

   Zend_XmlRpc_Value::setGenerator(new Zend_XmlRpc_Generator_XmlWriter());

   $server = new Zend_XmlRpc_Server();
   ...

.. note::

   **Die eigene Anwendung benchmarken**

   Performance wird durch eine Vielzahl an Parametern und Benchmarks ermittelt welche nur für den speziellen
   Testfall angewendet werden. Unterschiede basieren auf der *PHP* Version, installierten Erweiterungen, dem
   Webserver und dem Betriebssystem um nur einige zu nennen. Man sollte darauf achten das man die eigene Anwendung
   selbst benchmarkt und anschließend auswählt welchen Generator man verwendet, aber basierend auf **eigenen**
   Zahlen.

.. note::

   **Den eigenen Client benchmarken**

   Diese Optimierung macht auch für die Client Seite Sinn. Man muss den alternativen *XML* Generator nur
   auswählen bevor man irgendeine Arbeit mit ``Zend_XmlRpc_Client`` durchführt.



.. _`Spezifikationen auf www.xmlrpc.com`: http://www.xmlrpc.com/spec
.. _`Remote Facade`: http://martinfowler.com/eaaCatalog/remoteFacade.html
