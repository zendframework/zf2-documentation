.. EN-Revision: none
.. _zend.http.client.advanced:

Zend_Http_Client - Fortgeschrittende Nutzung
============================================

.. _zend.http.client.redirections:

HTTP Umleitungen
----------------

Standardmäßig verarbeitet ``Zend_Http_Client`` *HTTP* Umleitungen automatisch und folgt bis zu 5 Umleitungen.
Dies kann durch Setzen des 'maxredirects' Konfigurationsparameters gändert werden.

Gemäß dem *HTTP*/1.1 RFC sollten *HTTP* 301 und 302 Antworten vom Client behandelt werden, indem die selbe
Anfrage erneut an die angebene Stelle versendet wird - unter Verwendung der selben Anfragemethode. Allerdings haben
dies die meisten Clients nicht implementiert und verwenden beim Umleiten eine ``GET`` Anfrage. Standardmäßig
macht ``Zend_Http_Client`` genau dasselbe - beim Umleiten einer 301 oder 302 Antwort, werden alle ``GET`` und POST
Parameter zurückgesetzt und eine ``GET`` Anfrage wird an die neue Stelle versandt. Dieses Verhalten kann durch
Setzen des 'strictredirects' Konfigurationsparameters auf das boolesche ``TRUE`` geändert werden.



      .. _zend.http.client.redirections.example-1:

      .. rubric:: Strikte Umleitung von 301 und 302 Antworten nach RFC 2616 erzwingen

      .. code-block:: php
         :linenos:

         // Strikte Umleitungen
         $client->setConfig(array('strictredirects' => true);

         // Nicht strikte Umleitungen
         $client->setConfig(array('strictredirects' => false);



Man kann immer die Anzahl der durchgeführten Umleitungen nach dem Senden einer Anfrage durch Verwendung der
getRedirectionsCount() Methoden erhalten.

.. _zend.http.client.cookies:

Hinzufügen von Cookies und Verwendung von persistenten Cookies
--------------------------------------------------------------

``Zend_Http_Client`` stellt eine einfache Schnittstelle zum Hinzufügen von Cookies zu einer Anfrage bereit, so
dass keine direkten Header Änderungen notwendig sind. Dies wird durch Verwendung der setCookie() Methode erledigt.
Diese Methode kann auf mehrere Arten verwendet werden:



      .. _zend.http.client.cookies.example-1:

      .. rubric:: Cookies setzen durch Verwendung von setCookie()

      .. code-block:: php
         :linenos:

         // Ganz einfach: durch Übergabe von Namen und Wert für den Cookie
         $client->setCookie('flavor', 'chocolate chips');

         // Durch direktes Übergeben eines unverarbeiteten Cookie Strings (Name=Wert)
         // Beachte, dass der Wert bereits URL kodiert sein muss
         $client->setCookie('flavor=chocolate%20chips');

         // Durch Übergabe eins Zend_Http_Cookie Objekts
         $cookie = Zend_Http_Cookie::fromString('flavor=chocolate%20chips');
         $client->setCookie($cookie);

Für weitere Informationen über ``Zend_Http_Cookie`` Objekte, siehe :ref:`diesen Abschnitt <zend.http.cookies>`.

``Zend_Http_Client`` stellt außerdem die Möglichkeiten für "Cookie Stickiness" bereit - das bedeutet, dass der
Client intern alle gesendeten und erhaltenen Cookies speichert und bei nachfolgenden Anfragen automatisch wieder
mit sendet. Dies ist z.B. nützlich, wenn man sich bei einer entfernten Site zuerst einloggen muss und einen
Authentifizierungs- oder Session-Cookie erhält, bevor man weitere Anfragen versenden kann.



      .. _zend.http.client.cookies.example-2:

      .. rubric:: Cookie Stickiness aktivieren

      .. code-block:: php
         :linenos:

         // Um die Cookie Stickiness einzuschalten, setze eine Cookie Jar (Keksdose)
         $client->setCookieJar();

         // Erste Anfrage: einloggen und eine Session starten
         $client->setUri('http://example.com/login.php');
         $client->setParameterPost('user', 'h4x0r');
         $client->setParameterPost('password', '1337');
         $client->request('POST');

         // Die Cookie Jar speichert die Cookies automatisch in der Antwort
         // wie z.B. ein Session ID Cookie.

         // Nun können wir die nächste Anfrage senden - die gespeicherten Cookies
         // werden automatisch mit gesendet
         $client->setUri('http://example.com/read_member_news.php');
         $client->request('GET');

Für weitere Informationen über die ``Zend_Http_CookieJar`` Klasse, siehe :ref:`diesen Abschnitt
<zend.http.cookies.cookiejar>`.

.. _zend.http.client.custom_headers:

Setzen von individuellen Anfrageheadern
---------------------------------------

Das Setzen von individuellen Headern kann durch Verwendung der setHeaders() Methode erledigt werden. Diese Methode
ist sehr facettenreich und kann auf verschiedene Arten verwendet werden, wie das folgende Beispiel zeigt:



      .. _zend.http.client.custom_headers.example-1:

      .. rubric:: Setzen eines einzelnen individuellen Anfrageheaders

      .. code-block:: php
         :linenos:

         // Setzen eines einzelnen Headers, vorherige werden überschrieben
         $client->setHeaders('Host', 'www.example.com');

         // Ein anderer Weg um genau das Gleiche zu erreichen
         $client->setHeaders('Host: www.example.com');

         // Setzen von verschiedenen Werten für den selben Header
         // (besonders für Cookie Header nützlich):
         $client->setHeaders('Cookie', array(
             'PHPSESSID=1234567890abcdef1234567890abcdef',
             'language=he'
         ));



setHeader() kann genauso einfach für das Setzen mehrerer Header in einem Aufruf durch Übergabe eines Array mit
Headern als einzigen Parameter verwendet werden:



      .. _zend.http.client.custom_headers.example-2:

      .. rubric:: Setzen eines mehreren individuellen Anfrageheaders

      .. code-block:: php
         :linenos:

         // Setzen von mehreren Headern, vorherige werden überschrieben
         $client->setHeaders(array(
             'Host' => 'www.example.com',
             'Accept-encoding' => 'gzip,deflate',
             'X-Powered-By' => 'Zend Framework'));

         // Das Array kann auch komplette Array Strings enthalten:
         $client->setHeaders(array(
             'Host: www.example.com',
             'Accept-encoding: gzip,deflate',
             'X-Powered-By: Zend Framework'));



.. _zend.http.client.file_uploads:

Dateiuploads
------------

Man kann Dateien über *HTTP* hochladen, indem man die setFileUpload Methode verwendet. Diese Methode nimmt einen
Dateinamen als ersten Parameter, einen Formularnamen als zweiten Parameter und Daten als einen dritten, optionalen
Parameter entgegen. Wenn der dritte Parameter ``NULL`` ist, wird angenommen, dass der erste Dateinamen Parameter
auf eine echte Datei auf der Platte verweist, und ``Zend_Http_Client`` wird versuchen die Datei zu lesen und
hochzuladen. Wenn der Daten Parameter nicht ``NULL`` ist, wird der erste Dateinamen Parameter als der Dateiname
versendet, aber die Datei muss nicht wirklich auf der Platte existieren. Der zweite Formularnamen Parameter wird
immer benötigt und ist gleichbedeutend mit dem "name" Attribut eines >input< Tags, wenn die Datei durch ein *HTML*
Formular hochgeladen worden ist. Ein vierter optionaler Parameter gibt den Content-type der Datei an. Wenn er nicht
angegeben wird, liest ``Zend_Http_Client`` die Datei von der Platte und verwendet die mime_content_type Funktion,
um den Content-type der Datei zu erraten, wenn er verfügbar ist. Auf jeden Fall ist der Standard MIME Typ
'application/octet-stream'.



      .. _zend.http.client.file_uploads.example-1:

      .. rubric:: Verwendung von setFileUpload um Dateien hochzuladen

      .. code-block:: php
         :linenos:

         // Hochladen beliebiger Daten als Datei
         $text = 'this is some plain text';
         $client->setFileUpload('some_text.txt', 'upload', $text, 'text/plain');

         // Hochladen einer vorhandenen Datei
         $client->setFileUpload('/tmp/Backup.tar.gz', 'bufile');

         // Dateien absenden
         $client->request('POST');

Im ersten Beispiel, wird die Variable $text hochgeladen und als $_FILES['upload'] auf der Serverseite verfügbar
sein. Im zweiten Beispiel wird die vorhandene Datei /tmp/Backup.tar.gz auf den Server geladen und als
$_FILES['bufile'] verfügbar sein. Der Content-type wird automatisch erraten, wenn möglich - und wenn nicht, wird
der Content-type auf 'application/octet-stream' gesetzt.

.. note::

   **Dateien hochladen**

   Beim Hochladen von Dateien wird der Content-type der *HTTP* Anfrage automatisch auf 'multipart/form-data'
   gesetzt. Man sollte beachten, dass man eine POST oder PUT Anfrage absenden muss, um Dateien hochzuladen. Die
   meisten Server werden den Hauptteil der Anfrage bei anderen Anfragetypen ignorieren.

.. _zend.http.client.raw_post_data:

Unverarbeitete POST Daten versenden
-----------------------------------

Man kann ``Zend_Http_Client`` verwenden, um mit der setRawData() Methode unverarbeitete POST Daten zu versenden.
Diese Methode nimmt zwei Parameter entgegen: der erste ist die im Anfrage Hauptteil zu versendenen Daten. Der
zweite optionale Parameter ist der Content-type der Daten. Obwohl dieser Parameter optional ist, sollte man ihn
normalerweise vor dem Absenden der Anfrage setzen - entweder durch Verwendung von setRawData() oder durch eine
andere Methode: setEncType().



      .. _zend.http.client.raw_post_data.example-1:

      .. rubric:: Unverarbeitete POST Daten versenden

      .. code-block:: php
         :linenos:

         $xml = '<book>' .
                '  <title>Islands in the Stream</title>' .
                '  <author>Ernest Hemingway</author>' .
                '  <year>1970</year>' .
                '</book>';

         $client->setRawData($xml, 'text/xml')->request('POST');

         // Ein anderer Weg, um das selbe zu tun:
         $client->setRawData($xml)->setEncType('text/xml')->request('POST');

Die Daten sollten auf der Serverseite über die *PHP* Variable $HTTP_RAW_POST_DATA oder über den php://input
stream verfügbar sein.

.. note::

   **Unverarbeitete POST Daten verwenden**

   Das Setzen von unverarbeiteten POST Daten für eine Anfrage überschreibt jeden POST Parameter oder
   Dateiuploads. Man sollte nicht beides in der selben Anfrage verwenden. Es ist zu beachten, dass die meisten
   Server den Hauptteil der Anfrage ignorieren, wenn keine POST Anfrage gesendet wird.

.. _zend.http.client.http_authentication:

HTTP Authentifizierung
----------------------

Derzeit unterstützt ``Zend_Http_Client`` nur die Basis *HTTP* Authentifizierung. Diese Funktion kann durch
Verwendung der ``setAuth()`` Methode oder durch Spezifikation von Benutzername und Passwort in der URI genutzt
werden. Die ``setAuth()`` Methode nimmt 3 Parameter entgegen: den Benutzernamen, das Passwort und einen optionalen
Authentifizierungstyp Parameter. Wie gesagt, wird derzeit nur die Basis Authentifizierung unterstützt
(Unterstützung für eine Digest Authentifizierung ist geplant).



      .. _zend.http.client.http_authentication.example-1:

      .. rubric:: Setzen von Benutzer und Password für eine HTTP Authentifizierung

      .. code-block:: php
         :linenos:

         // Verwende die Basis Authentifizierung
         $client->setAuth('shahar', 'myPassword!', Zend_Http_Client::AUTH_BASIC);

         // Da Basis Authentifizierung Standard ist, kann man auch dies verwenden:
         $client->setAuth('shahar', 'myPassword!');

         // Man kann auch den Benutzernamen und das Passwort in der URI spezifizieren
         $client->setUri('http://christer:secret@example.com');



.. _zend.http.client.multiple_requests:

Versenden mehrerer Anfragen mit dem selben Client
-------------------------------------------------

``Zend_Http_Client`` wurde zusätzlich besonders dafür entwickelt, um mehrere, aufeinander folgende Abfragen durch
das selbe Objekt verarbeiten zu können. Dies ist nützlich, wenn z.B. ein Skript es erfordert, Daten von
verschiedenen Stellen abzurufen, oder wenn eine spezielle *HTTP* Ressource das Einloggen und Erhalten eines Session
Cookies erfordert.

Beim Ausführen mehrere Anfrage an den selben Host, wird es besonders empfohlen, den Konfigurationsschalter
'keepalive' zu aktivieren. Wenn der Server keep-alive Verbindungen unterstützt, wird auf diesem Weg die Verbindung
zum Server nur beendet, sobald alle Anfragen abgeschlossen sind und das Client Objekt zerstört wird. Dies
verhindert den Overhead beim Öffnen und Schließen von *TCP* Verbindungen zum Server.

Wenn man verschiedene Anfragen mit dem selben Client durchführt, aber sicherstellen möchte, dass alle
anfragespezifischen Parameter entfernt werden, sollte man die resetParameters() Methode verwenden. Dies stellt
sicher, dass ``GET`` und POST Parameter, Anfragehauptteil und anfragespezifischen Header zurückgesetzt und nicht
bei der nächsten Anfrage wiederverwendet werden.

.. note::

   **Parameter zurück setzen**

   Bitte beachten, dass Header, die nicht anfragespezifisch sind, standardmäßig nicht zurück gesetzt werden,
   wenn die ``resetParameters()`` Methode verwendet wird. Nur die 'Content-length' und 'Content-type' Header werden
   zurück gesetzt. Dies erlaubt das Setzen und Vergessen von Headern wie 'Accept-language' und 'Accept-encoding'.

   Um alle Header und Daten aus der URI und der Methode zu löschen kann ``resetParameters(true)`` verwendet
   werden.

Ein weiteres Feature, welches speziell für aufeinander folgende Anfragen entwickelt worden ist, ist das Cookie Jar
Objekt (Keksdose). Cookie Jars erlauben das automatische Speichern von Cookies, die vom Server bei der ersten
Anfrage gesetzt worden sind, und das Versenden bei nachfolgenden Anfragen. Dies erlaubt es z.B. eine
Authentifizierungsanfrage zu durchlaufen, bevor die eigentliche Anfrage zum Erhalten der Daten gesendet wird.

Wenn die Applikation eine Authentifizierungsanfrage pro Benutzer erfordert und nachfolgende Anfragen in mehr als
einem Skript in der Applikation durchgeführt werden könnten, könnte es eine gute Idee sein, das Cookie Jar
Objekt in der Benutzersession zu speichern. Auf diese Weise muß der Benutzer nur einmal pro Session
authentifiziert werden.

.. _zend.http.client.multiple_requests.example-1:

.. rubric:: Durchführen von aufeinander folgenden Anfrage mit einem Client

.. code-block:: php
   :linenos:

   // Zuerst den Client instanzieren
   $client = new Zend_Http_Client('http://www.example.com/fetchdata.php', array(
       'keepalive' => true
   ));

   // Haben wir die Cookies in unserer Session gespeichert?
   if (isset($_SESSION['cookiejar']) &&
       $_SESSION['cookiejar'] instanceof Zend_Http_CookieJar) {

       $client->setCookieJar($_SESSION['cookiejar']);
   } else {
       // Falls nicht, authentifiziere und speichere die Cookies
       $client->setCookieJar();
       $client->setUri('http://www.example.com/login.php');
       $client->setParameterPost(array(
           'user' => 'shahar',
           'pass' => 'somesecret'
       ));
       $client->request(Zend_Http_Client::POST);

       // Nun entferne die Parameter und setze die URI auf das Original
       // (Bitte beachten, dass der Cookie, der vom Server gesetzt worden ist,
       // nun in der Dose ist)
       $client->resetParameters();
       $client->setUri('http://www.example.com/fetchdata.php');
   }

   $response = $client->request(Zend_Http_Client::GET);

   // Speichere die Cookies in der Session für die nächste Seite
   $_SESSION['cookiejar'] = $client->getCookieJar();

.. _zend.http.client.streaming:

Daten Streaming
---------------

Standardmäßig akzeptiert ``Zend_Http_Client`` Daten als *PHP* Strings und gibt diese auch zurück. Trotzdem sind
in vielen Fällen große Dateien zu Senden oder zu Empfangen. Diese im Speicher zu halten könnte unnötig oder zu
teuer sein. Für diese Fälle unterstützt ``Zend_Http_Client`` das Lesen von Daten aus Dateien (und generell auch
*PHP* Streams) und das Schreiben von Daten in Dateien (Streams).

Um Streams für die Übergabe von Daten zu ``Zend_Http_Client`` zu verwenden, muss die Methode ``setRawData()``
verwendet werden, wobei das Daten Argument eine Stream Ressource ist (z.B. das Ergebnis von ``fopen()``).



      .. _zend.http.client.streaming.example-1:

      .. rubric:: Senden von Dateien zum HTTP Server durch Streamen

      .. code-block:: php
         :linenos:

         $fp = fopen("mybigfile.zip", "r");
         $client->setRawData($fp, 'application/zip')->request('PUT');



Aktuell unterstützen nur PUT Anfragen das Senden von Streams zum *HTTP* Server.

Um Daten vom Server als Stream zu Empfangen kann ``setStream()`` verwendet werden. Das optionale Argument
spezifiziert den Dateinamen unter dem die Daten gespeichert werden. Wenn das Argument einfach nur ``TRUE`` ist
(Standard), wird eine temporäre Datei verwenden und gelöscht sobald das Antwort Objekt zerstört wird. Wenn das
Argument auf ``FALSE`` gesetzt wird, ist die Streaming-Funktionalität ausgeschaltet.

Wenn Streaming verwendet wird, gibt die Methode ``request()`` ein Objekt der Klasse
``Zend_Http_Client_Response_Stream`` zurück, welches zwei nützliche Methoden hat: ``getStreamName()`` gibt den
Namen der Datei zurück in welcher die Antwort gespeichert wird, und ``getStream()`` gibt den Stream zurück von
dem die Antwort gelesen werden könnte.

Man kann die Antwort entweder in eine vordefinierte Datei schreiben, oder eine temporäre Datei hierfür verwenden
und Sie woanders hinsenden, oder Sie durch Verwendung von regulären Streaming Funktionen an eine andere Datei
Senden.



      .. _zend.http.client.streaming.example-2:

      .. rubric:: Empfangen von Dateien vom HTTP Server durch Streamen

      .. code-block:: php
         :linenos:

         $client->setStream(); // will use temp file
         $response = $client->request('GET');
         // Datei kopieren
         copy($response->getStreamName(), "my/downloads/file");
         // Stream verwenden
         $fp = fopen("my/downloads/file2", "w");
         stream_copy_to_stream($response->getStream(), $fp);
         // Kann auch in eine bekannte Datei schreiben
         $client->setStream("my/downloads/myfile")->request('GET');




