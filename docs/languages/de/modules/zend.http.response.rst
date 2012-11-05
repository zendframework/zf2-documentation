.. EN-Revision: none
.. _zend.http.response:

Zend\Http\Response
==================

.. _zend.http.response.introduction:

Einführung
----------

``Zend\Http\Response`` stellt den einfachen Zugriff auf eine *HTTP* Rückantwort sowie einige statische Methoden
zum Analysieren der *HTTP* Rückantworten bereit. Normalerweise wird ``Zend\Http\Response`` als ein Objekt
verwendet, dass von einer ``Zend\Http\Client`` Anfrage zurückgegeben wurde.

In den meisten Fällen wird ein ``Zend\Http\Response`` Objekt über die fromString() Methode instanziert, die einen
String liest, der eine *HTTP* Rückantwort enthält und ein ``Zend\Http\Response`` Objekt zurückgibt.



      .. _zend.http.response.introduction.example-1:

      .. rubric:: Ein Zend\Http\Response Object über die factory Methode instanzieren

      .. code-block:: php
         :linenos:

         $str = '';
         $sock = fsockopen('www.example.com', 80);
         $req =     "GET / HTTP/1.1\r\n" .
                 "Host: www.example.com\r\n" .
                 "Connection: close\r\n" .
                 "\r\n";

         fwrite($sock, $req);
         while ($buff = fread($sock, 1024))
             $str .= $sock;

         $response = Zend\Http\Response::fromString($str);



Man kann auch die Konstruktormethode verwenden, um ein neues Response Objekt zu erstellen, indem man alle Parameter
für die Antwort angibt:

``public function __construct($code, $headers, $body = null, $version = '1.1', $message = null)``

- ``$code``: Der *HTTP* Antwortcode(eg. 200, 404, etc.)

- ``$headers``: Ein assoziatives Array mit *HTTP* Antwort Headers (z.B. 'Host' => 'example.com')

- ``$body``: Der Hauptteil der Antwort als String

- ``$version``: Der Version der *HTTP* Antwort (normalerweise 1.0 oder 1.1)

- ``$message``: Die *HTTP* Rückantwort (z.B. 'OK', 'Internal Server Error'). Falls nicht angegeben, wird die
  Rückantwort anhand des Antwortcode gesetzt.

.. _zend.http.response.testers:

Boolesche Testmethoden
----------------------

Sobald ein ``Zend\Http\Response`` Objekt instantiert ist, stellt es mehrere Methoden bereit, die zum Testen des
Typs der Antwort verwendet werden können. Diese geben alle ein boolesches ``TRUE`` oder ``FALSE`` zurück:



   - ``isSuccessful()``: Ob die Anfrage erfolgreoch war oder nicht. Gibt ``TRUE`` für *HTTP* 1xx und 2xx
     Antwortcodes zurück.

   - ``isError()``: Ob der Antwortcode auf einen Fehler rückschließen lässt oder nicht. Gibt ``TRUE`` für
     *HTTP* 4xx (Client Fehler) und 5xx (Server Fehler) Antwortcodes zurück.

   - ``isRedirect()``: Ob die Antwort eine Weiterleitung ist oder nicht. Gibt ``TRUE`` für *HTTP* 3xx Antwortcodes
     zurück.





      .. _zend.http.response.testers.example-1:

      .. rubric:: Die isError() Method verwenden, um eine Antwort zu validieren

      .. code-block:: php
         :linenos:

         if ($response->isError()) {
           echo "Error transmitting data.\n"
           echo "Server reply was: " . $response->getStatus() .
                " " . $response->getMessage() . "\n";
         }
         // .. verarbeite die Antwort hier...



.. _zend.http.response.acessors:

Zugriffsmethoden
----------------

Der Hauptzweck eines Response Okjektes ist der einfache Zugriff auf diverse Antwortparameter.



   - ``getStatus()``: Erhalte den *HTTP* Antwortstatuscode (z.B. 200, 504, etc.) zurück

   - ``getMessage()``: Erhalte die *HTTP* Antwortstatus Meldung (z.B. "Not Found", "Authorization Required")
     zurück.

   - ``getBody()``: Erhalte den kompletten dekodierten Hauptteil der *HTTP* Antwort zurück

   - ``getRawBody()``: Erhalte die rohen, möglicherweise kodierten Hauptteil der *HTTP* Antwort zurück. Wenn der
     Hauptteil z.B. mittels GZIP kodiert wurde, wird er nicht dekodiert.

   - ``getHeaders()``: Erhalte die *HTTP* Antwort Header als assoziatives Array (z.B. 'Content-type' =>
     'text/html') zurück.

   - ``getHeader($header)``: Erhalte einen spezifischen *HTTP* Antwort Header zurück, der durch $header angegeben
     wird.

   - ``getHeadersAsString($status_line, $br)``: Erhalte den kompletten Header Satz als String zurück. Wenn
     ``$status_line`` auf ``TRUE`` gesetzt ist (Standardwert), wird die erste Statuszeile (z.B. "HTTP/1.1 200 OK")
     ebenfalls zurück gegeben. Die Zeilen werden durch den ``$br`` Parameter umgebrochen (kann z.B. "<br />" sein.
     Standardwert ist "\\n").

   - ``asString($br)``: Erhalte die komplette Rückantwort als String zurück. Die Zeilen werden durch den $br
     Parameter umgebrochen (kann z.B. "<br />" sein. Standardwert ist "\\n"). Man kann auch die magische
     ``__toString()`` Methode verwenden wenn man das Objekt in einen String casten will. Diese wird dann auf
     ``asString()`` weiterleiten





      .. _zend.http.response.acessors.example-1:

      .. rubric:: Zend\Http\Response Zugriffsmethoden verwenden

      .. code-block:: php
         :linenos:

         if ($response->getStatus() == 200) {
           echo "The request returned the following information:<br />";
           echo $response->getBody();
         } else {
           echo "An error occurred while fetching data:<br />";
           echo $response->getStatus() . ": " . $response->getMessage();
         }



   .. note::

      **Immer die Rückgabewerte prüfen**

      Weil eine Antwort mehrere Instanzen des selben Headers beinhalten kann, können die getHeader() Methode und
      getHeaders() Methode entweder einen einzelnen String oder ein Array mit Strings für jeden Header
      zurückgeben. Man sollte immer prüfen, ob der Rückgabewert ein String oder ein Array ist.





      .. _zend.http.response.acessors.example-2:

      .. rubric:: Auf Antwort Header zugreifen

      .. code-block:: php
         :linenos:

         $ctype = $response->getHeader('Content-type');
         if (is_array($ctype)) $ctype = $ctype[0];

         $body = $response->getBody();
         if ($ctype == 'text/html' || $ctype == 'text/xml') {
           $body = htmlentities($body);
         }

         echo $body;



.. _zend.http.response.static_parsers:

Statische HTTP Antwortanalysierer
---------------------------------

Die ``Zend\Http\Response`` Klasse beinhaltet auch verschiedene, intern verwendete Methoden für die Verarbeitung
und Analyse der *HTTP* Rückantworten bereit. Diese Methoden sind alle als statische Methoden eingerichtet, so dass
man sie extern verwenden kann, ohne dass man ein Response Objekt instanzierebn muss und nur einen bestimmten Teil
der Antwort extrahieren möchte.



   - ``Zend\Http\Response::extractCode($response_str)``: Extrahiere den *HTTP* Antwortcode (z.B. 200 oder 404) von
     ``$response_str`` und gebe ihn zurück.

   - ``Zend\Http\Response::extractMessage($response_str)``: Extrahiere die *HTTP* Rückantwort (z.B. "OK" oder
     "File Not Found") von ``$response_str`` und gebe sie zurück.

   - ``Zend\Http\Response::extractVersion($response_str)``: Extrahiere die *HTTP* Version (z.B. 1.1 oder 1.0) von
     ``$response_str`` und gebe sie zurück.

   - ``Zend\Http\Response::extractHeaders($response_str)``: Extrahiere die *HTTP* Antwort Header von
     ``$response_str`` und gebe sie in einem Array zurück.

   - ``Zend\Http\Response::extractBody($response_str)``: Extrahiere den *HTTP* Antworthauptteil aus
     ``$response_str`` und gebe ihn zurück.

   - ``Zend\Http\Response::responseCodeAsText($code, $http11)``: Erhalte die Standard *HTTP* Rückantwort für
     einen Antwortcode $code. Zum Beispiel wird "Internal Server Error" zurückgegeben, wenn ``$code`` gleich 500
     ist. Wenn ``$http11`` gleich ``TRUE`` ist (Standard), werden die *HTTP*/1.1 Standardantworten zurück gegeben,
     andernfalls die *HTTP*/1.0 Antworten. Wird ``$code`` nicht angegeben, wird diese Methode alle bekannten *HTTP*
     Antwortcodes als assoziatives Array (code => message) zurückgeben.



Neben der Analysemethoden beinhaltet die Klasse auch einen Satz von Dekodieren für allgemein *HTTP* Antwort
Transferkodierungen:



   - ``Zend\Http\Response::decodeChunkedBody($body)``: Dekodiere einen kompletten "Content-Transfer-Encoding:
     Chunked" Hauptteil

   - ``Zend\Http\Response::decodeGzip($body)``: Dekodiere einen "Content-Encoding: gzip" Hauptteil

   - ``Zend\Http\Response::decodeDeflate($body)``: Dekodiere einen "Content-Encoding: deflate" Hauptteil




