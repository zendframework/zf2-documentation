.. _zend.xmlrpc.server:

Zend_XmlRpc_Server
==================

.. _zend.xmlrpc.server.introduction:

Wprowadzenie
------------

Klasa Zend_XmlRpc_Server jest przeznaczona do użycia jako pełnofunkcjonalny serwer XML-RPC, zgodny ze
`specyfikacją przedstawioną na www.xmlrpc.com`_. Dodatkowo implementuje ona metodę system.multicall(),
pozwalającą na wywołanie wielu metod podczas jednego żądania.

.. _zend.xmlrpc.server.usage:

Podstawowe użycie
-----------------

Przykład najbardziej podstawowego przypadku użycia:

.. code-block:: php
   :linenos:

   $server = new Zend_XmlRpc_Server();
   $server->setClass('My_Service_Class');
   echo $server->handle();


.. _zend.xmlrpc.server.structure:

Struktura serwera
-----------------

Zend_XmlRpc_Server składa się z wielu różnych komponentów, od samego serwera, przez obiekty żądania, obiekty
odpowiedzi aż do obiektów błędów.

Aby uruchomić serwer Zend_XmlRpc_Server, programista musi dołączyć jedną lub więcej klas albo funkcji do
serwera, za pomocą metod *setClass()* oraz *addFunction()*.

Kiedy jest to już zrobione, możesz przekazać obiekt *Zend_XmlRpc_Request* do metody
*Zend_XmlRpc_Server::handle()*, lub zostanie utworzona instancja obiektu *Zend_XmlRpc_Request_Http* w przypadku gdy
nie zostanie zapewniony żaden obiekt -- spowoduje to pobieranie żądań z *php://input*.

*Zend_XmlRpc_Server::handle()* próbuje wtedy uruchomić odpowiednią klasę obsługującą, zależnie od użytej
metody dostępu. Zwraca wtedy obiekt oparty na *Zend_XmlRpc_Response* lub obiekt *Zend_XmlRpc_Server_Fault*. Oba te
obiekty mają dostępne metody *__toString()*, ktore tworzą poprawne odpowiedzi XML-RPC, pozwalając na
bezpośrednie ich wyświetlenie.

.. _zend.xmlrpc.server.conventions:

Konwencje
---------

Zend_XmlRpc_Server pozwala programiście dołączać funkcje oraz metody klas jako uruchamialne metody XML-RPC.
Poprzez Zend_Server_Reflection, przeprowadzana jest introspekcja dla wszystkich dołączanych metod, używając
bloków dokumentacji funkcji i metod do określenia opisów pomocy dla metod oraz sygnatur metod.

XML-RPC nie mają w typach PHP dokładnych odpowiedników. Jednak skrypt spróbuje dopasować najlepszy typ na
podstawie wartości znajdujących się w polach @param oraz @return. Niektóre typy XML-RPC nie mają dokładnych
odpowiedników w typach PHP, więc powinny być rzutowane używając typów XML-RPC w komentarzach phpdoc. Są to:

- dateTime.iso8601, łańcuch znaków sformatowany jako YYYYMMDDTHH:mm:ss

- base64, dane zakodowane jako base64

- struct, dowolna tablica asocjacyjna

Przykład wywołania przykładowej funkcji:

.. code-block:: php
   :linenos:

   /**
   * To jest przykładowa funkcja
   *
   * @param base64 $val1 Dane zakodowane jako Base64
   * @param dateTime.iso8601 $val2 Data ISO
   * @param struct $val3 Tablica asocjacyjna
   * @return struct
   */
   function myFunc($val1, $val2, $val3)
   {
   }


PhpDocumentor nie przeprowadza weryfikacji typów określonych dla parametrów lub zwracanych wartości, więc nie
będzie to miało wpływu na twoją dokumentację API Providing the hinting is necessary, however, when the server
is validating the parameters provided to the method call.

Poprawne jest określenie wielu typów zarówno dla parametrów jak i dla zwracanych wartości; specyfikacja
XML-RPC sugeruje nawet, że metoda system.methodSignature powinna zwracać tablicę wszystkich możliwych sygnatur
metody (np. wszystkie możliwe kombinacje parametrów i zwracanych wartości). Możesz to zrobić tak jak robisz to
w PhpDocumentor, używając operatora '\|':

.. code-block:: php
   :linenos:

   /**
   * To jest przykładowa funkcja
   *
   * @param string|base64 $val1 Łańcuch znaków lub dane zakodowane jako base64
   * @param string|dateTime.iso8601 $val2 Łańcuch znaków lub data ISO
   * @param array|struct $val3 Normalnie indeksowana tablica lub tablica asocjacyjna
   * @return boolean|struct
   */
   function myFunc($val1, $val2, $val3)
   {
   }


Jedna uwaga: dopuszczanie do utworzenia wielu różnych sygnatur może doprowadzić do dezorientacji programistów
używających serwisów; W zasadzie metoda XML-RPC powinna mieć tylko jedną sygnaturę.

.. _zend.xmlrpc.server.namespaces:

Używanie przestrzeni nazw
-------------------------

XML-RPC posiada system przestrzeni nazw; najprościej mówiąc, pozwala to na grupowanie metod XML-RPC w
przestrzenie nazw oddzielone znakiem kropki. Ułatwia to zapobieganie konfliktom pomiędzy metodami pochodzącymi z
rożnych klas. Przykładowo, serwer XML-RPC powinien udostępniać kilka metod w przestrzeni nazw 'system':

- system.listMethods

- system.methodHelp

- system.methodSignature

Wewnątrz odpowiada to metodom o tych samych w obiekcie Zend_XmlRpc_Server.

Jeśli chcesz dodać przestrzenie nazw do metod, które oferujesz, po prostu podaj przestrzeń nazw do odpowiedniej
metody wtedy, gdy dołączasz funkcję lub klasę:

.. code-block:: php
   :linenos:

   // Wszystkie publiczne metody klasy My_Service_Class będą dostępne jako
   // myservice.METHODNAME
   $server->setClass('My_Service_Class', 'myservice');

   // Funkcja 'somefunc' będzie dostępna jako funcs.somefunc
   $server->addFunction('somefunc', 'funcs');


.. _zend.xmlrpc.server.request:

Własny obiekt żądania
---------------------

W większości przypadków będziesz używał domyślnego obiektu żądania dostarczanego przez Zend_XmlRpc_Server,
którym jest obiekt Zend_XmlRpc_Request_Http. Jednak czasem możesz chcieć aby usługa XML-RPC była dostępna
przez CLI, GUI lub inne środowisko, lub możesz chcieć zapisywać informacje o przychodzących żądaniach. Aby
to zrobić, możesz utworzyć własny obiekt żądania, który rozszerza obiekt Zend_XmlRpc_Request.
Najważniejszą rzeczą jest zapamiętanie aby zawsze implementować metody getMethod() oraz getParams() co pozwoli
na to, że serwer XML-RPC będzie mógł pobrać te informacje w celu uruchomienia żądania.

.. _zend.xmlrpc.server.response:

Własne odpowiedzi
-----------------

Podobnie jak obiekty żądania, Zend_XmlRpc_Server może zwracać własne obiekty odpowiedzi; domyślnie zwracany
jest obiekt Zend_XmlRpc_Response_Http, który wysyła odpowiedni nagłówek HTPP Content-Type do użycia z XML-RPC.
Możliwym powodem użycia własnego obiektu może być potrzeba logowania odpowiedzi, lub wysyłanie odpowiedzi
spowrotem do STDOUT.

Aby użyć własnej klasy odpowiedzi, użyj metody Zend_XmlRpc_Server::setResponseClass() przed wywołaniem
handle().

.. _zend.xmlrpc.server.fault:

Obsługa wyjątków poprzez odpowiedzi błędów
------------------------------------------

Obiekt Zend_XmlRpc_Server łapie wyjątki wyrzucone przez uruchomioną metodę i generuje odpowiedź błędu
(fault) wtedy gdy taki wyjątek zostanie złapany. Domyślnie informacje o wyjątkach i ich kody nie są używane w
odpowiedzi błędu. Jest to celowe zachowanie chroniące twój kod; wiele wyjątków ujawnia dużo informacji o
kodzie oraz środowisku, czemu programista powinien zapobiec (dobrym przykładem mogą być informacje o wyjątkach
związanych z bazą danych)

Klasy wyjątków, które mają być użyte jako odpowiedzi błędów mogą być dodane do listy dozwolonych
wyjątków. Aby to zrobić wystarczy użyć metody Zend_XmlRpc_Server_Fault::attachFaultException() w celu
przekazania klasy wyjątku do listy dozwolonych wyjątków:

.. code-block:: php
   :linenos:

   Zend_XmlRpc_Server_Fault::attachFaultException('My_Project_Exception');


Jeśli dodasz do listy wyjątków klasę wyjątku z którego dziedziczą inne wyjątki, możesz w ten sposób
dodać do listy całą rodzinę wyjątków za jednym razem. Wyjątki Zend_XmlRpc_Server_Exceptions zawsze znajdują
się na liście dozwolonych wyjątków, aby pozwolić na informowanie o specyficznych wewnętrznych błędach
(niezdefiniowanie metody itp.).

Każdy wyjątek spoza listy dozwolonych wyjątków spowoduje wygenerowanie odpowiedzi błędu o kodzie '404' i
informacji 'Unknown error' (Nieznany błąd).

.. _zend.xmlrpc.server.caching:

Buforowanie definicji serwera pomiędzy żądaniami
------------------------------------------------

Dołączanie wielu klas do instancji serwera XML-RPC może zajmować wiele zasobów; za pomocą Reflection API
(przez Zend_Server_Reflection) musi być dokonana introspekcja każdej klasy co w rezultacie wygeneruje listę
wszystkich możliwych sygnatur metod w celu przekazania jej do klasy serwera.

Aby zredukować straty wydajności, możemy użyć obiektu Zend_XmlRpc_Server_Cache do buforowania definicji
serwera pomiędzy żądaniami. Gdy połączymy to z funkcją \__autoload(), może to mocno zwiększyć wydajność.

Przykładowe użycie:

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

       $server->setClass('My_Services_Glue', 'glue');   // przestrzeń nazw glue
       $server->setClass('My_Services_Paste', 'paste'); // przestrzeń nazw paste
       $server->setClass('My_Services_Tape', 'tape');   // przestrzeń nazw tape

       Zend_XmlRpc_Server_Cache::save($cacheFile, $server);
   }

   echo $server->handle();


Powyższy przykład próbuje pobrać definicję serwera z pliku bufora xmlrpc.cache znajdującego się w tym samym
katalogu co skrypt. Jeśli się to nie uda, załaduje on potrzebne klasy serwisu, dołączy do instancji serwera i
spróbuje utworzyć nowy plik bufora z definicją sderwera.

.. _zend.xmlrpc.server.use:

Przykład użycia
---------------

Poniżej znajduje się kilka przykładów użycia, pokazując pełne spektrum opcji dostępnych dla programistów.
Każdy z przykładów użycia jest oparty na poprzednich przykładach.

.. _zend.xmlrpc.server.use.case1:

Podstawowe użycie
^^^^^^^^^^^^^^^^^

Poniższy przykład dołącza funkcję jaką uruchamialną przez XML-RPC metodę i obsługuje przychodzące
wywołania.

.. code-block:: php
   :linenos:

   /**
    * Zwraca sumę MD5 zadanej wartości
    *
    * @param string $value wartość do obliczenia sumy md5
    * @return string MD5 suma wartości
    */
   function md5Value($value)
   {
       return md5($value);
   }

   $server = new Zend_XmlRpc_Server();
   $server->addFunction('md5Value');
   echo $server->handle();


.. _zend.xmlrpc.server.use.case2:

Dołączanie klasy
^^^^^^^^^^^^^^^^

Poniższy przykład pokazuje dołączanie publicznych metod klasy jako uruchamialnych metod XML-RPC.

.. code-block:: php
   :linenos:

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb');
   echo $server->handle();


.. _zend.xmlrpc.server.use.case3:

Dołączanie wielu klas używając przestrzeni nazw
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Poniższy przykład pokazuje dołączanie kilku klas, każdej z własną przestrzenią nazw.

.. code-block:: php
   :linenos:

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb', 'comb');   // metody wywoływane jako comb.*
   $server->setClass('Services_Brush', 'brush'); // metody wywoływane jako brush.*
   $server->setClass('Services_Pick', 'pick');   // metody wywoływane jako pick.*
   echo $server->handle();


.. _zend.xmlrpc.server.use.case4:

Określenie wyjątków dla odpowiedzi błędów
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Poniższy przykład pozwala dowolnej klasie pochodzącej od Services_Exception na przekazywanie informacji o
wyjątkach w postaci kodu i wiadomości w odpowiedzi błędu.

.. code-block:: php
   :linenos:

   // Pozwala na wyrzucanie wyjątku Services_Exceptions dla odpowiedzi błędu
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb', 'comb');   // metody wywoływane jako comb.*
   $server->setClass('Services_Brush', 'brush'); // metody wywoływane jako brush.*
   $server->setClass('Services_Pick', 'pick');   // metody wywoływane jako pick.*
   echo $server->handle();


.. _zend.xmlrpc.server.use.case5:

Użycie własnego obiektu żądania
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Poniższy przykład tworzy instancję własnego obiektu żądania i przekazuje go do obiektu serwera.

.. code-block:: php
   :linenos:

   // Pozwala na wyrzucanie wyjątku Services_Exceptions dla odpowiedzi błędu
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb', 'comb');   // metody wywoływane jako comb.*
   $server->setClass('Services_Brush', 'brush'); // metody wywoływane jako brush.*
   $server->setClass('Services_Pick', 'pick');   // metody wywoływane jako pick.*

   // Tworzenie obiektu żądania
   $request = new Services_Request();

   echo $server->handle($request);


.. _zend.xmlrpc.server.use.case6:

Użycie własnego obiektu odpowiedzi
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Poniższy przykład pokazuje określanie własnej klasy odpowiedzi dla zwracanej odpowiedzi.

.. code-block:: php
   :linenos:

   // Pozwala na wyrzucanie wyjątku Services_Exceptions dla odpowiedzi błędu
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();
   $server->setClass('Services_Comb', 'comb');   // metody wywoływane jako comb.*
   $server->setClass('Services_Brush', 'brush'); // metody wywoływane jako brush.*
   $server->setClass('Services_Pick', 'pick');   // metody wywoływane jako pick.*

   // Utwórz obiekt żądania
   $request = new Services_Request();

   // Użyj własnego obiektu żądania
   $server->setResponseClass('Services_Response');

   echo $server->handle($request);


.. _zend.xmlrpc.server.use.case7:

Buforowanie definicji serwera pomiędzy żądaniami
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Poniższy przykład pokazuje buforowanie definicji serwera pomiędzy żądaniami.

.. code-block:: php
   :linenos:

   // Określ plik cache
   $cacheFile = dirname(__FILE__) . '/xmlrpc.cache';

   // Pozwala na wyrzucanie wyjątku Services_Exceptions dla odpowiedzi błędu
   Zend_XmlRpc_Server_Fault::attachFaultException('Services_Exception');

   $server = new Zend_XmlRpc_Server();

   // Spróbuj pobrać definicje serwera z bufora
   if (!Zend_XmlRpc_Server_Cache::get($cacheFile, $server)) {
       $server->setClass('Services_Comb', 'comb');   // metody wywoływane jako comb.*
       $server->setClass('Services_Brush', 'brush'); // metody wywoływane jako brush.*
       $server->setClass('Services_Pick', 'pick');   // metody wywoływane jako pick.*

       // Zapisz cache
       Zend_XmlRpc_Server_Cache::save($cacheFile, $server));
   }

   // Utwórz obiekt żądania
   $request = new Services_Request();

   // Użyj własnej klasy odpowiedzi
   $server->setResponseClass('Services_Response');

   echo $server->handle($request);




.. _`specyfikacją przedstawioną na www.xmlrpc.com`: http://www.xmlrpc.com/spec
