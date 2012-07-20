.. _zend.xmlrpc.client:

Zend_XmlRpc_Client
==================

.. _zend.xmlrpc.client.introduction:

Einführung
----------

Zend Framework bietet Unterstützung, als Client - durch das ``Zend_XmlRpc_Client`` Paket - entfernte *XML-RPC*
Dienste zu nutzen. Seine wichtigsten Möglichkeiten beinhalten das automatische Umwandeln zwischen *PHP* und
*XML-RPC*, ein Server Proxy-Objekt und den Zugriff auf Server-Prüfungsmöglichkeiten.

.. _zend.xmlrpc.client.method-calls:

Methodenaufrufe
---------------

Der Konstruktor von ``Zend_XmlRpc_Client`` erhält den *URL* des Endpunktes des entfernten *XML-RPC* Server als
ersten Parameter. Die zurückgegebene Instanz kann genutzt werden, um eine beliebige Anzahl von entfernten Methoden
(des Endpunktes) aufzurufen.

Um eine entfernte Methode mittels des *XML-RPC* Clients aufzurufen, muss man den Client instanzieren und dessen
Methode ``call()`` aufrufen. Das hierunter gegebene Codebeispiel demonstriert den *XML-RPC* Server der Zend
Framework Webseite. Es kann benutzen, um ``Zend_XmlRpc``-Komponenten zu testen oder auszuprobieren.

.. _zend.xmlrpc.client.method-calls.example-1:

.. rubric:: XML-RPC Methodenaufruf

.. code-block:: php
   :linenos:

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   echo $client->call('test.sayHello');

   // hello

Der - durch den Aufruf einer entfernten Methode - zurückgegebene, typenlose *XML-RPC* Wert wird automatisch zu
dessen nativen *PHP* Äquivalent umgeformt. In obigem Beispiel wird ein *PHP* ``String`` zurückgegeben und ist
sofort benutzbar.

Der erste Parameter the Methode ``call()`` ist der Name der aufzurufenden Methode. Wenn die entfernte Methode
weitere Parameter benötigt, können diese durch einen zweiten, optionalen Parameter des Typs ``Array`` an
``call()`` angegeben werden, wie folgendes Beispiel zeigt:

.. _zend.xmlrpc.client.method-calls.example-2:

.. rubric:: XML-RPC Methodenaufruf mit Parametern

.. code-block:: php
   :linenos:

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   $arg1 = 1.1;
   $arg2 = 'foo';

   $result = $client->call('test.sayHello', array($arg1, $arg2));

   // $result ist ein nativer PHP-Typ

Wenn die entfernte Methode keine Parameter erwartet, kann der optionale Parameter weggelassen oder stattdessen ein
leeres ``array()`` übergeben werden. Das, die Parameter - für die entfernte Methode - enthaltende, Array kann
native *PHP* Typen, ``Zend_XmlRpc_Value``-Objekte oder eine Mischung aus Beidem enthalten.

Die ``call()``-Methode konvertiert automatisch die *XML-RPC* Antwort in dessen äquivalenten nativen *PHP* Typen
und gibt sie zurück. Ein ``Zend_XmlRpc_Response`` Objekt als Rückgabewert ist auch verfübar durch das Aufrufen
der Methode ``getLastResponse()`` nach dem Aufruf (der entfernten Methode).

.. _zend.xmlrpc.value.parameters:

Typen und Konvertierung
-----------------------

Einige entfernte Methodenaufrufe benötigen Parameter. Diese werden an die Methode ``call()`` des
``Zend_XmlRpc_Client``\ s als Array im zweiten Parameter übergeben. Jeder Parameter kann entweder ein nativer
*PHP* Typ sein, der automatisch konvertiert wird, oder ein Objekt, das einem speziellen *XML-RPC* Typen (eines der
``Zend_XmlRpc_Value``-Objekte) entspricht.

.. _zend.xmlrpc.value.parameters.php-native:

Native PHP-Typen als Parameter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Parameter können der Methode ``call()`` als native *PHP* Variablen übergeben werden, also als ``String``,
``Integer``, ``Float``, ``Boolean``, ``Array`` oder als ``Object``. In diesem Fall wird jeder native *PHP* Typ
automatisch erkannt und dann in einen der folgenden *XML-RPC* Typen konvertiert, welche in dieser Tabelle
ersichtlich ist:

.. _zend.xmlrpc.value.parameters.php-native.table-1:

.. table:: PHP- und XML-RPC-Typkonvertierungen

   +--------------------------+----------------+
   |Nativer PHP Typ           |XML-RPC Typ     |
   +==========================+================+
   |integer                   |int             |
   +--------------------------+----------------+
   |Zend_Crypt_Math_BigInteger|i8              |
   +--------------------------+----------------+
   |double                    |double          |
   +--------------------------+----------------+
   |boolean                   |boolean         |
   +--------------------------+----------------+
   |string                    |string          |
   +--------------------------+----------------+
   |null                      |nil             |
   +--------------------------+----------------+
   |array                     |array           |
   +--------------------------+----------------+
   |associative array         |struct          |
   +--------------------------+----------------+
   |object                    |array           |
   +--------------------------+----------------+
   |Zend_Date                 |dateTime.iso8601|
   +--------------------------+----------------+
   |DateTime                  |dateTime.iso8601|
   +--------------------------+----------------+

.. note::

   **Auf welchen Typ werden leere Arrays gecastet?**

   Die Übergabe eines leeren Array an eine *XML-RPC* Methode ist problematisch, da es entweder ein Array oder ein
   Struct repräsentieren könnte. ``Zend_XmlRpc_Client`` erkennt solche Konditionen und führt eine Abfrage zur
   ``system.methodSignature`` Methode des Servers aus, um den richtigen *XML-RPC* Typ festzustellen auf den
   gecastet werden soll.

   Trotzdem kann das selbst sogar zu Problemen führen. Erstens werden Server die ``system.methodSignature`` nicht
   unterstützen fehlerhafte Anfragen protokollieren, und ``Zend_XmlRpc_Client`` wird selbst einen Ausweg nehmen
   und den Wert auf einen *XML-RPC* Arraytyp casten. Zusätzlich bedeutet dass das jeder Aufruf mit einem Array
   Argument zu einem zusätzlichen Aufruf beim Remote Server führt.

   Um das Nachsehen komplett abzuschalten kann die ``setSkipSystemLookup()`` Methode aufgerufen werden bevor der
   *XML-RPC* Aufruf durchgeführt wird:

   .. code-block:: php
      :linenos:

      $client->setSkipSystemLookup(true);
      $result = $client->call('foo.bar', array(array()));

.. _zend.xmlrpc.value.parameters.xmlrpc-value:

Zend_XmlRpc_Value-Objekte als Parameter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Parameter können auch direkt als ``Zend_XmlRpc_Value``-Instanzen erstellt werden, um einen exakten *XML-RPC* Typen
darzustellen. Die wichtigsten Gründe dafür sind:



   - Wenn sichergestellt werden soll, dass der Prozedur der korrekte Parametertyp übergeben wird (z.B. braucht die
     Prozedur einen integer, während diese vielleicht von einer Datenbank als String zurückgegeben wird).

   - Wenn die Prozedur einen ``base64``- oder einen ``dateTime.iso8601``-Typ benötigt, da diese nicht als native
     *PHP* Typen existieren.

   - Wenn eine automatische Konvertierung fehlschlägt. Zum Beispiel wenn eine leere *XML-RPC* Struktur als
     Parameter für die Prozedur gewünscht ist. Leere Strukturen werden jedoch als leere Arrays in *PHP*
     gehandhabt, aber wenn man ein leeres Array als Parameter übergeben will, dann wird es automatisch zu einem
     *XML-RPC* Array konvertiert, da es kein assoziatives Array ist.



Es gibt zwei Möglichkeiten ein ``Zend_XmlRpc_Value``-Objekt zu erstellen: Direkte Instanzierung einer
``Zend_XmlRpc_Value``-Subklasse oder das Nutzen der statischen Fabrikmethode
``Zend_XmlRpc_Value::getXmlRpcValue()``.

.. _zend.xmlrpc.value.parameters.xmlrpc-value.table-1:

.. table:: Zend_XmlRpc_Value Objekte als XML-RPC Typen

   +----------------+----------------------------------------+----------------------------+
   |XML-RPC Typ     |Zend_XmlRpc_Value Konstante             |Zend_XmlRpc_Value Objekt    |
   +================+========================================+============================+
   |int             |Zend_XmlRpc_Value::XMLRPC_TYPE_INTEGER  |Zend_XmlRpc_Value_Integer   |
   +----------------+----------------------------------------+----------------------------+
   |i8              |Zend_XmlRpc_Value::XMLRPC_TYPE_I8       |Zend_XmlRpc_Value_BigInteger|
   +----------------+----------------------------------------+----------------------------+
   |ex:i8           |Zend_XmlRpc_Value::XMLRPC_TYPE_APACHEI8 |Zend_XmlRpc_Value_BigInteger|
   +----------------+----------------------------------------+----------------------------+
   |double          |Zend_XmlRpc_Value::XMLRPC_TYPE_DOUBLE   |Zend_XmlRpc_Value_Double    |
   +----------------+----------------------------------------+----------------------------+
   |boolean         |Zend_XmlRpc_Value::XMLRPC_TYPE_BOOLEAN  |Zend_XmlRpc_Value_Boolean   |
   +----------------+----------------------------------------+----------------------------+
   |string          |Zend_XmlRpc_Value::XMLRPC_TYPE_STRING   |Zend_XmlRpc_Value_String    |
   +----------------+----------------------------------------+----------------------------+
   |nil             |Zend_XmlRpc_Value::XMLRPC_TYPE_NIL      |Zend_XmlRpc_Value_Nil       |
   +----------------+----------------------------------------+----------------------------+
   |ex:nil          |Zend_XmlRpc_Value::XMLRPC_TYPE_APACHENIL|Zend_XmlRpc_Value_Nil       |
   +----------------+----------------------------------------+----------------------------+
   |base64          |Zend_XmlRpc_Value::XMLRPC_TYPE_BASE64   |Zend_XmlRpc_Value_Base64    |
   +----------------+----------------------------------------+----------------------------+
   |dateTime.iso8601|Zend_XmlRpc_Value::XMLRPC_TYPE_DATETIME |Zend_XmlRpc_Value_DateTime  |
   +----------------+----------------------------------------+----------------------------+
   |array           |Zend_XmlRpc_Value::XMLRPC_TYPE_ARRAY    |Zend_XmlRpc_Value_Array     |
   +----------------+----------------------------------------+----------------------------+
   |struct          |Zend_XmlRpc_Value::XMLRPC_TYPE_STRUCT   |Zend_XmlRpc_Value_Struct    |
   +----------------+----------------------------------------+----------------------------+

.. note::

   **Automatische Konvertierung**

   Bei der Erstellung eines neuen ``Zend_XmlRpc_Value``-Objekts wird dessen Wert durch einen nativen *PHP* Typ
   gesetzt. Dieser *PHP* Typ wird durch *PHP* Casting in den gewünschten Typ umgewandelt. Beispielsweise wird ein
   String, der als Wert für ein ``Zend_XmlRpc_Value_Integer``-Objekt genutzt wird, durch ``(int)$value`` in ein
   Integer konvertiert.

.. _zend.xmlrpc.client.requests-and-responses:

Server-Proxy-Objekt
-------------------

Ein anderer Weg um entfernte Methoden mit *XML-RPC* Clients aufzurufen, ist die Verwendung eines Server-Proxys.
Dies ist ein *PHP* Objekt, das einen entfernten *XML-RPC* Namensraum umleitet, sodass es so weit wie möglich als
*PHP* Objekt arbeitet wie es möglich ist.

Um einen Server-Proxy zu instanzieren, muss die Methode ``getProxy()`` der Klasse ``Zend_XmlRpc_Client`` aufgerufen
werden. Das retourniert eine Instanz von ``Zend_XmlRpc_Client_ServerProxy``. Jeder Methodenaufruf wird zur
entsprechenden entfernten Methode weitergeleitet. Die Parameter können übergeben werden, wie bei jeder anderen
*PHP* Methode.

.. _zend.xmlrpc.client.requests-and-responses.example-1:

.. rubric:: Umleitung zum Standard-Namenraum

.. code-block:: php
   :linenos:

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   $service = $client->getProxy();          // Umleitung im Standard-Namenraum

   $hello = $service->test->sayHello(1, 2); // test.Hello(1, 2) gibt "hello" zurück

Die Methode ``getProxy()`` erhält ein optionales Argument, welches den Namensraum des entfernten Servers
definiert, zu welchem die Methodenaufrufe umgeleitet werden. Wenn kein Namensraum übergeben wird, wird zum
Standard-Namensraum umgeleitet. Im nächsten Beispiel wird zum 'test'-Namespace umgeleitet:

.. _zend.xmlrpc.client.requests-and-responses.example-2:

.. rubric:: Umleitung zu einem beliebigen Namensraum

.. code-block:: php
   :linenos:

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   $test  = $client->getProxy('test');     // Leitet zum "test"-Namensraum um

   $hello = $test->sayHello(1, 2);         // test.Hello(1,2) gibt "hello" zurück

Wenn der entfernte Server verschachtelte Namensräume jeglicher Tiefe erlaubt, können diese auch durch den
Server-Proxy genutzt werden. Wenn der Server in obigem Beispiel eine Methode ``test.foo.bar()`` hätte, könnte es
durch ``$test->foo->bar()`` aufgerufen werden.

.. _zend.xmlrpc.client.error-handling:

Fehlerbehandlung
----------------

Es gibt zwei Arten von Fehlern, die während eines *XML-RPC* Methodenaufruf autreten können: *HTTP* und *XML-RPC*
Fehler. Der ``Zend_XmlRpc_Client`` erkennt beide und ermöglicht es, diese unabhängig voneinander zu entdecken und
abzufangen.

.. _zend.xmlrpc.client.error-handling.http:

HTTP-Fehler
^^^^^^^^^^^

Wenn ein *HTTP* Fehler auftritt, wie z.B. wenn der entfernte *HTTP* Server einen **404 Not Found** zurückgibt,
wird eine ``Zend_XmlRpc_Client_HttpException`` geworfen.

.. _zend.xmlrpc.client.error-handling.http.example-1:

.. rubric:: Verarbeiten von HTTP-Fehlern

.. code-block:: php
   :linenos:

   $client = new Zend_XmlRpc_Client('http://foo/404');

   try {

       $client->call('bar', array($arg1, $arg2));

   } catch (Zend_XmlRpc_Client_HttpException $e) {

       // $e->getCode() gibt 404 zurück
       // $e->getMessage() gibt "Not Found" zurück

   }

Ungeachtet des benutzten *XML-RPC* Clients wird immer eine ``Zend_XmlRpc_Client_HttpException`` geworfen, wenn ein
*HTTP* Fehler auftritt.

.. _zend.xmlrpc.client.error-handling.faults:

XML-RPC-Fehler
^^^^^^^^^^^^^^

Ein *XML-RPC* Fehler wird analog zu einer *PHP* Exception verwendet. Es ist ein spezieller Typ, der durch einen
*XML-RPC* Methodenaufruf zurückgegeben wurden und einen Fehlercode sowie eine Fehlermeldung enthält. *XML-RPC*
Fehler werden unterschiedlich behandelt, was von der Benutzung des ``Zend_XmlRpc_Client``\ s abhängt.

Wenn die Methode ``call()`` oder der Server-Proxy genutzt wird, würde durch einen *XML-RPC* Fehler eine
``Zend_XmlRpc_Client_FaultException`` geworfen werden. Der Fehlercode und die -meldung der Exception zeigen auf
deren zugehörige Werte in der originalen *XML-RPC* Fehlerantwort.

.. _zend.xmlrpc.client.error-handling.faults.example-1:

.. rubric:: Verarbeiten von XML-RPC Fehlern

.. code-block:: php
   :linenos:

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   try {

       $client->call('badMethod');

   } catch (Zend_XmlRpc_Client_FaultException $e) {

       // $e->getCode() gibt 1 zurück
       // $e->getMessage() gibt "Unknown method" zurück

   }

Wenn die Methode ``call()`` genutzt wird, um eine Anfrage zu starten, wird die
``Zend_XmlRpc_Client_FaultException`` bei einem Fehler geworfen. Ein ``Zend_XmlRpc_Response``-Objekt, das den
Fehler enthält, ist allerdings auch verfübar durch die Methode ``getLastResponse()``.

Wenn die Methode ``doRequest()`` genutzt wird, um eine Anfrage zu starten, wird keine Exception geworfen.
Stattdessen wird ein ``Zend_XmlRpc_Response``-Objekt zurückgegeben, das den Fehler enthält. Dieses kann durch den
Aufruf der Methode ``isFault()`` der Klasse ``Zend_XmlRpc_Response`` überprüft werden.

.. _zend.xmlrpc.client.introspection:

Server Selbstüberprüfung
------------------------

Einige *XML-RPC* Server bieten de facto Überprüfungsmethoden unter dem *XML-RPC* Namesraum **system.**.
``Zend_XmlRpc_Client`` stellt spezielle Verfahren für Server mit diesen Möglichkeiten zur Verfügung.

Eine Instanz der Klasse ``Zend_XmlRpc_Client_ServerIntrospection`` kann über die Methode ``getIntrospector()`` der
Klasse ``Zend_XmlRpcClient`` zurückgegeben werden. Sie kann dann genutzt werden, um Überwachungsoperationen auf
dem Server auszuführen.

.. _zend.xmlrpc.client.request-to-response:

Von der Anfrage zur Antwort
---------------------------

Intern erstellt die Methode ``call()`` des ``Zend_XmlRpc_Client``-Objekts ein Anfrage-Objekt
(``Zend_XmlRpc_Request``) und sendet es zu einer anderen Methode, ``doRequest()``, die ein Antwort-Objekt
(``Zend_XmlRpc_Response``) zurückgibt.

Die Methode ``doRequest()`` kann auch direkt genutzt werden:

.. _zend.xmlrpc.client.request-to-response.example-1:

.. rubric:: Eine Anfrage zu einer Antwort verarbeiten

.. code-block:: php
   :linenos:

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   $request = new Zend_XmlRpc_Request();
   $request->setMethod('test.sayHello');
   $request->setParams(array('foo', 'bar'));

   $client->doRequest($request);

   // $client->getLastRequest() gibt ein Zend_XmlRpc_Request-Objekt zurück
   // $client->getLastResponse() gibt ein Zend_XmlRpc_Response-Objekt zurück

Immer wenn eine *XML-RPC* Methode vom Client aufgerufen wird, egal auf welche Weise - entweder über die Methode
``call()``, die Methode ``doRequest()`` oder den Server-Proxy -, ist das Objekt der letzten Anfrage, sowie dessen
resultierende Antwort-Objekte, immer durch die Methoden ``getLastRequest()`` und ``getLastResponse()`` verfügbar.

.. _zend.xmlrpc.client.http-client:

HTTP-Client und das Testen
--------------------------

In jedem der vorangegangenen Beispiele wurde kein *HTTP* Client bestimmt. In diesem Fall wird eine neue Instanz
eines ``Zend_Http_Client``\ s mit dessen standardmäßigen Einstellungen erstellt und automatisch vom
``Zend_XmlRpc_Client`` benutzt.

Der *HTTP* Client kann zu jeder Zeit mit der Methode ``getHttpClient()`` zurückgegeben werden. In den meisten
Fällen jedoch ist der Standard *HTTP* Client ausreichend. Allerdings erlaubt die Methode ``setHttpClient()`` das
Setzen eines anderen *HTTP* Clients.

Die Methode ``setHttpClient()`` ist besonders nützlich für UnitTests. Wenn es mit dem
``Zend_Http_Client_Adapter_Test`` kombiniert wird, können entfernte Services für das Testen nachgeahmt werden. In
den UnitTests für ``Zend_XmlRpc_Client`` sind Beispiele, wie so was erreicht werden kann.


