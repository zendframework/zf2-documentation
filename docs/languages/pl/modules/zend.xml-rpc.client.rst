.. _zend.xmlrpc.client:

Zend_XmlRpc_Client
==================

.. _zend.xmlrpc.client.introduction:

Wprowadzenie
------------

Zend Framework zapewnia obsługę wywoływania zdalnych serwisów XML-RPC jako klient w pakiecie
*Zend_XmlRpc_Client*. Do głównych funkcjonalności należą: automatyczna konwersja typów pomiędzy PHP a
XML-RPC, obiekt serwera proxy oraz dostęp do możliwości introspekcji serwerów.

.. _zend.xmlrpc.client.method-calls:

Wywołania metod
---------------

Konstruktor klasy *Zend_XmlRpc_Client* odbiera w pierwszym parametrze adres URL zdalnego serwera XML-RPC. Nowa
zwrócona instancja może być użyta do wywołania dowolnej ilości zdalnych metod tego serwera.

Aby wywołać zdalną metodę za pomocą klienta XML-RPC, utwórz instancję i użyj metody *call()*. Przykładowy
kod poniżej używa demonstracyjnego serwera XML-RPC na stronie Zend Framework. Możesz go użyć do testowania lub
eksplorowania komponentów *Zend_XmlRpc*.

.. _zend.xmlrpc.client.method-calls.example-1:

.. rubric:: Wywołanie metody XML-RPC

.. code-block:: php
   :linenos:

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   echo $client->call('test.sayHello');

   // hello


Wartość XML-RPC zwracana przez wywołanie zdalnej metody jest automatycznie konwertowana do odpowiedniego
natywnego typu PHP. W powyższym przykładzie, zwraca jest wartość typu *string* i jest ona natychmiast gotowa do
użycia.

Pierwszy parametr metody *call()* to nazwa zdalnej metody do wywołania. Jeśli zdalna metoda wymaga jakichkolwiek
parametrów, mogą być one wysłane przez podanie do metody *call()* drugiego opcjonalnego parametru w postaci
tablicy wartości do przekazania do zdalnej metody:

.. _zend.xmlrpc.client.method-calls.example-2:

.. rubric:: Wywołanie metody XML-RPC z parametrem

.. code-block:: php
   :linenos:

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   $arg1 = 1.1;
   $arg2 = 'foo';

   $result = $client->call('test.sayHello', array($arg1, $arg2));

   // zmienna $result jest natywnego typu PHP


Jeśli zdalna metoda nie wymaga parametrów, ten opcjonalony parametr może pozostać pusty, lub może być pustą
tablicą *array()*. Tablica parametrów dla zdalnej metody może zawierać natywne typy PHP, obiekty
*Zend_XmlRpc_Value*, lub ich kombinacje.

Metoda *call()* automatycznie skonwertuje odpowiedź XML-RPC i zwróci wartość odpowiedniego natywnego typu PHP.
Obiekt *Zend_XmlRpc_Response* ze zwróconą wartością będzie także dostępny po wywołaniu poprzez wywołanie
metody *getLastResponse()*.

.. _zend.xmlrpc.value.parameters:

Typy i konwersje
----------------

Niektóre zdalne wywołania metod wymagają parametrów. Są one przekazywane do metody *call()* obiektu
*Zend_XmlRpc_Client* jako tablica w drugim parametrze. Każdy podany parametr może być natywnego typu PHP, wtedy
będzie automatycznie skonwertowany, lub może być obiektem reprezentującym specyficzny typ XML-RPC (jeden z
obiektów *Zend_XmlRpc_Value*).

.. _zend.xmlrpc.value.parameters.php-native:

Natywne typy PHP jako parametry
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Parametry mogą być przekazane do metody *call()* jako natywne zmienne PHP, czyli jako *string*, *integer*,
*float*, *boolean*, *array*, lub *object*. W tym przypadku każda natywna wartość zostanie automatycznie wykryta
i skonwertowana do jednego z typów XML-RPC, zgodnie z tą tabelą:

.. _zend.xmlrpc.value.parameters.php-native.table-1:

.. table:: Konwersje między typami PHP oraz XML-RPC

   +-----------------+-----------+
   |Natywny typ PHP  |Typ XML-RPC|
   +=================+===========+
   |integer          |int        |
   +-----------------+-----------+
   |double           |double     |
   +-----------------+-----------+
   |boolean          |boolean    |
   +-----------------+-----------+
   |string           |string     |
   +-----------------+-----------+
   |array            |array      |
   +-----------------+-----------+
   |associative array|struct     |
   +-----------------+-----------+
   |object           |array      |
   +-----------------+-----------+

.. note::

   **Na co zamieniane są puste tablice?**

   Przekazanie pustej tablicy do metody XML-RPC jest problematyczne, ponieważ może ona przedstawiać pustą
   tablicę lub strukturę. Obiekt *Zend_XmlRpc_Client* wykrywa takie przypadki i wywołuje metodę serwera
   *system.methodSignature* aby określić na jaki typ XML-RPC powinien tę tablicę zamienić

   Jednak może to powodować pewne problemy. Po pierwsze, serwery które nie obsługują metody
   *system.methodSignature* będą zapisywać nieudane żądania, a obiekt *Zend_XmlRpc_Client* będzie wtedy
   zamieniał puste tablice na puste tablice XML-RPC. Po drugie oznacza to, że każde wywołanie z argumentami w
   postaci tablic będą powodować konieczność przeprowadzenia dodatkowego żądania do zdalnego serwera.

   Aby całkowicie zablokować takie sprawdzanie, możesz wywołać metodę *setSkipSystemLookup()* przed
   wywołaniem metody XML-RPC call:

   .. code-block:: php
      :linenos:

      $client->setSkipSystemLookup(true);
      $result = $client->call('foo.bar', array(array()));


.. _zend.xmlrpc.value.parameters.xmlrpc-value:

Obiekty Zend_XmlRpc_Value jako parametry
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Parametry mogą być także tworzone jako instancje klasy *Zend_XmlRpc_Value* w celu określenia dokładnego typu
XML-RPC. Konieczne jest to gdy:



   - gdy chcesz być pewny, że parametr poprawnego typu jest przekazany do procedury (np. procedura wymaga liczby
     całkowitej, a ty możesz pobrać tę wartość z bazy jako łańcuch znaków).

   - Wtedy gdy procedura wymaga typu *base64* lub *dateTime.iso8601* (które nie istnieją jako natywne typy PHP)

   - Gdy automatyczna konwersja może nie zadziałać (np. gdy chcesz przekazać pustą strukturę XML-RPC jako
     parametr. Puste struktury są reprezentowane przez puste tablice w PHP, ale jeśli podasz pustą tablicę w
     parametrze będzie ona automatycznie skonwertowana do tablicy XML-RPC z tego powodu, że nie jest ona tablicą
     asocjacyjną)



Są dwa sposoby utworzenia obiektu *Zend_XmlRpc_Value*: bezpośrednie utworzenie instancji jednej z podklas klasy
*Zend_XmlRpc_Value*,lub użycie statycznej metody fabryki *Zend_XmlRpc_Value::getXmlRpcValue()*.

.. _zend.xmlrpc.value.parameters.xmlrpc-value.table-1:

.. table:: Obiekty Zend_XmlRpc_Value dla typów XML-RPC

   +----------------+---------------------------------------+-------------------------------+
   |Typ XML-RPC     |Stała Zend_XmlRpc_Value                |Obiekt Zend_XmlRpc_Value Object|
   +================+=======================================+===============================+
   |int             |Zend_XmlRpc_Value::XMLRPC_TYPE_INTEGER |Zend_XmlRpc_Value_Integer      |
   +----------------+---------------------------------------+-------------------------------+
   |double          |Zend_XmlRpc_Value::XMLRPC_TYPE_DOUBLE  |Zend_XmlRpc_Value_Double       |
   +----------------+---------------------------------------+-------------------------------+
   |boolean         |Zend_XmlRpc_Value::XMLRPC_TYPE_BOOLEAN |Zend_XmlRpc_Value_Boolean      |
   +----------------+---------------------------------------+-------------------------------+
   |string          |Zend_XmlRpc_Value::XMLRPC_TYPE_STRING  |Zend_XmlRpc_Value_String       |
   +----------------+---------------------------------------+-------------------------------+
   |base64          |Zend_XmlRpc_Value::XMLRPC_TYPE_BASE64  |Zend_XmlRpc_Value_Base64       |
   +----------------+---------------------------------------+-------------------------------+
   |dateTime.iso8601|Zend_XmlRpc_Value::XMLRPC_TYPE_DATETIME|Zend_XmlRpc_Value_DateTime     |
   +----------------+---------------------------------------+-------------------------------+
   |array           |Zend_XmlRpc_Value::XMLRPC_TYPE_ARRAY   |Zend_XmlRpc_Value_Array        |
   +----------------+---------------------------------------+-------------------------------+
   |struct          |Zend_XmlRpc_Value::XMLRPC_TYPE_STRUCT  |Zend_XmlRpc_Value_Struct       |
   +----------------+---------------------------------------+-------------------------------+

.. note::

   **Automatyczna konwersja**

   Kiedy tworzymy nowy obiekt *Zend_XmlRpc_Value*, jego wartość jest ustawiana jako typ PHP. Wartość będzie
   konwertowana do określonego typu używając rzytowania typów PHP. Na przykład, jeśli podany jest łańcuch
   znaków jako wartość do obiektu *Zend_XmlRpc_Value_Integer*, wartość ta będzie konwertowana za pomocą
   *(int)$value*.

.. _zend.xmlrpc.client.requests-and-responses:

Obiekt serwera proxy
--------------------

Innym sposobem wywołania zdalnych metod za pomocą klienta XML-RPC jest użycie serwera proxy. Jest to obiekt PHP,
który rozszerza zdalną przestrzeń nazw XML-RPC, powodując, że obiekt ten działa jak natywny obiekt PHP.

Aby utworzyć instancję serwera proxy, wywołaj metodę *getProxy()* instancji *Zend_XmlRpc_Client*. To zwróci
instancję obiektu *Zend_XmlRpc_Client_ServerProxy*. Wywołanie dowolnej metody na obiekcie serwera proxy będzie
przekazane do zdalnego serwera, a parametry będą przekazane jak do każdej innej metody PHP.

.. _zend.xmlrpc.client.requests-and-responses.example-1:

.. rubric:: Rozszerzanie domyślnej przestrzeni nazw

.. code-block:: php
   :linenos:

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   $server = $client->getProxy();           // Rozszerza domyślną przestrzeń nazw

   $hello = $server->test->sayHello(1, 2);  // test.Hello(1, 2) zwraca "hello"


Metoda *getProxy()* pobiera opcjonalny argument określający, która przestrzeń nazw zdalnego serwera chcemy
rozszerzyć. Jeśli przestrzeń nazwa nie zostanie określona, rozszerzona zostanie domyślna przestrzeń nazwa. W
następnym przykładzie będzie rozszerzona przestrzeń nazw *test*:

.. _zend.xmlrpc.client.requests-and-responses.example-2:

.. rubric:: Rozszerzanie dowolnej przestrzeni nazw

.. code-block:: php
   :linenos:

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   $test  = $client->getProxy('test');     // Rozszerza przestrzeń nazwa "test"

   $hello = $test->sayHello(1, 2);         // test.Hello(1,2) zwraca "hello"


Jeśli zdalny serwer obsługuje zagnieżdżone przestrzenie nazwa o dowolnej ilości zagnieżdżeń, mogą być
one także użyte przez serwer proxy. Na przykład, jeśli serwer w powyższym przykładzie posiada metodę
*test.foo.bar()*, może być ona wywołana jako *$test->foo->bar()*.

.. _zend.xmlrpc.client.error-handling:

Obsługa błędów
--------------

Dwa rodzaje błędów mogą wystąpić podczas wywoływania metod XML-RPC: błędy HTTP oraz błędy XML-RPC.
Klient *Zend_XmlRpc_Client* rozpoznaje te błędy i daje możliwośc wykrycia i złapania każdego z nich.

.. _zend.xmlrpc.client.error-handling.http:

Błędy HTTP
^^^^^^^^^^

Jeśli wystąpi jakiś błąd HTTP, na przykład gdy zdalny serwer HTTP zwróci błąd *404 Not Found*, wyrzucony
zostanie wyjątek *Zend_XmlRpc_Client_HttpException*.

.. _zend.xmlrpc.client.error-handling.http.example-1:

.. rubric:: Obsługa błędów HTTP

.. code-block:: php
   :linenos:

   $client = new Zend_XmlRpc_Client('http://foo/404');

   try {

       $client->call('bar', array($arg1, $arg2));

   } catch (Zend_XmlRpc_Client_HttpException $e) {

       // $e->getCode() zwraca 404
       // $e->getMessage() zwraca "Not found"

   }


Zależnie od tego jak używany jest klient XML-RPC, gdy wystąpi błąd HTTP zostanie wyrzucony wyjątek
*Zend_XmlRpc_Client_HttpException*.

.. _zend.xmlrpc.client.error-handling.faults:

Błędy XML-RPC
^^^^^^^^^^^^^

Błędy XML-RPC są analogiczne do wyjątków PHP. Jest to specjalny typ zwracany przez wywołanie metody XML-RPC,
który zawiera zarówno kod błędu jak i informacje o błędzie. Błędy XML-RPC są obsługiwane różnie,
zależnie od kontekstu w jakim użyty jest obiekt *Zend_XmlRpc_Client*.

Gdy użyta jest metoda *call()* lub obiekt serwera proxy, błędy XML-RPC spowodują wyrzucenie wyjątku
*Zend_XmlRpc_Client_FaultException*. Kod oraz informacje o błędzie wyjątku będą bezpośrednio mapować do ich
odpowiednich wartości oryginalnej odpowiedzi błędu XML-RPC.

.. _zend.xmlrpc.client.error-handling.faults.example-1:

.. rubric:: Obsługa błędów XML-RPC

.. code-block:: php
   :linenos:

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   try {

       $client->call('badMethod');

   } catch (Zend_XmlRpc_Client_FaultException $e) {

       // $e->getCode() zwraca 1
       // $e->getMessage() zwraca "Unknown method"

   }


Gdy metoda *call()* jest użyta do przeprowadzenia żądania, przy wystąpieniu błędu zostanie wyrzucony wyjątek
*Zend_XmlRpc_Client_FaultException*. Obiekt *Zend_XmlRpc_Response* zawierający błąd będzie także dostępny
przez wywołanie metody *getLastResponse()*.

Gdy do przeprowadzenia żądania użyta jest metoda *doRequest()*, nie będzie wyrzucony żaden wyjątek. Zamiast
tego zwrócony zostanie obiekt *Zend_XmlRpc_Response* zawierający informacje o błędzie. Może to być sprawdzone
za pomocą metody *isFault()* obiektu *Zend_XmlRpc_Response*.

.. _zend.xmlrpc.client.introspection:

Introspekcja serwerów
---------------------

Niektóre serwery XML-RPC obsługują metody introspekcji w przestrzeni nazw XML-RPC *system.*.
*Zend_XmlRpc_Client* zapewnia specjalną obsługę dla serwerów z taką funkcjonalnością.

Instancja *Zend_XmlRpc_Client_ServerIntrospection* może być odebrana przez wywołanie metody *getIntrospector()*
obiektu *Zend_XmlRpcClient*. Następnie obiekt ten może być użyty do przeprowadzenia operacji introspekcji na
serwerze.

.. _zend.xmlrpc.client.request-to-response:

Od żądania do odpowiedzi
------------------------

Wewnątrz wygląda to tak, że metoda *call()* instancji obiektu *Zend_XmlRpc_Client* buduje obiekt żądania
(*Zend_XmlRpc_Request*) i wysyła go do innej metody, *doRequest()*, ktora zwraca obiekt odpowiedzi
(*Zend_XmlRpc_Response*).

Metoda *doRequest()* jest także dostępna dla bezpośredniego użycia:

.. _zend.xmlrpc.client.request-to-response.example-1:

.. rubric:: Przetwarzanie żądania do odpowiedzi

.. code-block:: php
   :linenos:

   $client = new Zend_XmlRpc_Client('http://framework.zend.com/xmlrpc');

   $request = new Zend_XmlRpc_Request();
   $request->setMethod('test.sayHello');
   $request->setParams(array('foo', 'bar'));

   $client->doRequest($request);

   // $server->getLastRequest() zwraca instancję Zend_XmlRpc_Request
   // $server->getLastResponse() zwraca instancję Zend_XmlRpc_Response


Zawsze po wywołaniu metody XML-RPC przez klienta, niezależnie od tego czy za pomocą metody *call()*, metody
*doRequest()* czy poprzez serwer proxy, ostatni obiekt żądania i odpowiadający mu obiekt odpowiedzi będą
zawsze dostępne odpowiednio za pomocą metod *getLastRequest()* oraz *getLastResponse()*.

.. _zend.xmlrpc.client.http-client:

Klient HTTP i testowanie
------------------------

We wszystkich poprzednich przykładach nie został określony żaden klient HTTP. W takim wypadku utworzona zostaje
nowa instancja *Zend_Http_Client* z jej domyślnymi opcjami i ta instancja zostaje użyta automatycznie przez
*Zend_XmlRpc_Client*.

Klient HTTP może być odebrany w dowolnej chwili za pomocą metody *getHttpClient()*. W większości przypadków
domyślny klient HTTP będzie wystarczający. Jakkolwiek, metoda *setHttpClient()* pozwala na ustawienie innego
klienta HTTP dla danej instancji.

Metoda *setHttpClient()* jest szczególnie przydatna dla testów jednostkowych. Gdy jest połączona z obiektem
*Zend_Http_Client_Adapter_Test*, zdalne serwisy mogą być zasymulowane dla naszego testowania. Zobacz testy
jednostkowe dla *Zend_XmlRpc_Client* aby zobaczyć jak można to zrobić.


