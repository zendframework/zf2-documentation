.. EN-Revision: none
.. _zend.http.cookies:

Zend_Http_Cookie und Zend_Http_CookieJar
========================================

.. _zend.http.cookies.introduction:

Einführung
----------

Wie erwartet ist ``Zend_Http_Cookie`` eine Klasse, die einen *HTTP* Cookie darstellt. Sie stellt Methoden zum
Verarbeiten von *HTTP* Antwort-Strings, Sammeln von Cookies und dem einfachen Zugriff auf deren Eigenschaften zur
Verfügung. So ist es auch möglich verschiedene Zustände eines Cookies zu überprüfen, z.B. den Anfrage *URL*,
die Ablaufzeit, das Vorliegen einer sicheren Verbindung, etc.

``Zend_Http_CookieJar`` ist ein Objekt, das normalerweise von der Klasse ``Zend_Http_Client`` genutzt wird und
einen Satz von ``Zend_Http_Cookie`` Objekten beinhaltet. Die Idee ist das wenn ein ``Zend_Http_CookieJar`` an ein
``Zend_Http_Client`` Objekt angehängt wird, alle ein- und ausgehenden Cookies der *HTTP* Anfragen und -Antworten
im CookieJar Objekt gespeichert werden. Bei einer neuen Anfrage seitens des Clients wird nach allen Cookies, die
auf diese Anfrage zutreffen, gesucht. Diese werden automatisch zum Anfrage-Header hinzugefügt, was besonders
nützlich ist, wenn man eine Benutzersession über aufeinander folgende *HTTP* Anfragen beibehalten muss; die
Session-ID wird automatisch gesendet, wenn es notwendig ist. Ferner ist es möglich, ``Zend_Http_CookieJar``
Objekte zu serialisieren und, wenn nötig, in $_SESSION zu speichern.

.. _zend.http.cookies.cookie.instantiating:

Instanzieren von Zend_Http_Cookie Objekten
------------------------------------------

Es gibt zwei Möglichkeiten ein Cookie Objekt zu erstellen:



   - Mithilfe des Konstruktors und der folgenden Syntax: *new Zend_Http_Cookie(string $name, string $value, string
     $domain, [int $expires, [string $path, [boolean $secure]]]);*

     - ``$name``: Name des Cookies (notwendig)

     - ``$value``: Inhalt des Cookies (notwendig)

     - ``$domain``: Die Domain des Cookies (z.B. '.example.com') (notwendig)

     - ``$expires``: Ablaufzeit des Cookies als UNIX Zeitstempel (optional, standardmäßig ``FALSE``). Ein Nicht
       setzen führt zu einer Behandlung als 'Session-Cookie', das keine Ablaufzeit enthält.

     - ``$path``: Pfad des Cookies, z.B. '/foo/bar/' (optional, standardmäßig '/')

     - ``$secure``: Boolean, ob der Cookie nur über sichere Verbindungen (HTTPS) gesendet werden darf (optional,
       standardmäßig boolean ``FALSE``)

   - Durch das Aufrufen der statischen fromString($cookieStr, [$refUri, [$encodeValue]])-Methode mit einem
     Cookie-String, wie er unter 'Set-Cookie' in einer *HTTP* Antwort und 'Cookie' in einer *HTTP* Anfrage zu
     finden ist. In diesem Fall muss der Cookie-Inhalt bereits kodiert sein. Falls der Cookie-String keinen
     'domain'-Teil enthält, muss man selbst einen Referenz *URI* angeben, aus dem die Domain und der Pfad des
     Cookies bestimmt wird.

     Die Methode ``fromString()`` akzeptiert die folgenden Parameter:

     - ``$cookieStr``: Ein Cookie String wie im *HTTP* Response Header 'Set-Cookie' oder im *HTTP* Request Header
       'Cookie' (wird dort benötigt) dargestellt

     - ``$refUri``: Eine Referenz *URI* auf welche die Domain und der Pfad von Cookies gesetzt werden. (Optional
       wird standardmäßig dieser Wert von $cookieStr geparst)

     - ``$encodeValue``: Ob der Wert über urldecode übergeben werden soll.Hat auch Einfluss auf der Verhalten des
       Cookies wenn es in einen Cookie String zurück konvertiert wird. (Optional ist er standardmäßig true)





      .. _zend.http.cookies.cookie.instantiating.example-1:

      .. rubric:: Instanzieren eines Zend_Http_Cookie-Objekts

      .. code-block:: php
         :linenos:

         // Zuerst nutzen wir den Konstruktor. Der Cookie wird in zwei Stunden ablaufen
         $cookie = new Zend_Http_Cookie('foo',
                                        'bar',
                                        '.example.com',
                                        time() + 7200,
                                        '/path');

         // Man kann auch den HTTP-Antwort 'Set-Cookie'-header dafür nutzen.
         // Dieser Cookie ist ähnlich zum vorangegangenen, allerdings wird
         // er nicht ablaufen und nur über sichere Verbindungen gesendet.
         $cookie = Zend_Http_Cookie::fromString('foo=bar; domain=.example.com; ' .
                                                'path=/path; secure');

         // Wenn die Domain des Cookies nicht gesetzt ist, muss man ihn selbst angeben.
         $cookie = Zend_Http_Cookie::fromString('foo=bar; secure;',
                                                'http://www.example.com/path');



   .. note::

      Beim Instanzieren eines Cookie Objekts mit der ``Zend_Http_Cookie``::fromString()-Methode wird erwartet, dass
      der Cookie-Inhalt *URL* kodiert ist, wie es bei Cookie-Strings sein sollte. Allerdings wird angenommen, dass
      der Inhalt bei Verwendung des Konstruktors in seiner eigentlichen Form, d.h. nicht URL-kodiert, übergeben
      wird.



Ein Cookie Objekt kann durch die magische \__toString()-Methode zurück in einen String umgewandelt werden. Diese
Methode erstellt einen *HTTP*-Anfrage "Cookie"-Header String, der den Namen sowie den Inhalt des Cookies enthält
und durch ein Semikolon (';') abgeschlossen ist. Der Inhalt wird URL-kodiert, wie es für einen Cookie-Header
vorgeschrieben ist:



      .. _zend.http.cookies.cookie.instantiating.example-2:

      .. rubric:: Transformation eines Zend_Http_Cookie-Objekts zu einem String

      .. code-block:: php
         :linenos:

         // Erstellt einen neuen Cookie
         $cookie = new Zend_Http_Cookie('foo',
                                        'two words',
                                        '.example.com',
                                        time() + 7200,
                                        '/path');

         // Gibt 'foo=two+words;' aus
         echo $cookie->__toString();

         // Bezweckt dasselbe
         echo (string) $cookie;

         // Ab PHP 5.2 funktioniert auch diese Variante
         echo $cookie;



.. _zend.http.cookies.cookie.accessors:

Zend_Http_Cookie getter-Methoden
--------------------------------

Sobald ein ``Zend_Http_Cookie`` instanziert wurde, stellt es diverse getter-Methoden zur Verfügung, die es einem
ermöglichen, auf die verschiedenen Eigenschaften des *HTTP* Cookies zuzugreifen:



   - ``getName()``: Gibt den Namen des Cookies zurück

   - ``getValue()``: Gibt den wirklichen, also nicht kodierten, Inhalt zurück

   - ``getDomain()``: Gibt die Domain des Cookies zurück

   - ``getPath()``: Gibt den Pfad des Cookies zurück; dessen Standardwert ist '/'

   - ``getExpiryTime()``: Gibt die Ablaufzeit des Cookies als UNIX-Timestamp zurück. Falls der Cookie keine
     Ablaufzeit besitzt, wird ``NULL`` zurückgegeben.



Zusätzlich gibt es einige boolesche Tester-Methoden:



   - ``isSecure()``: Gibt zurück, ob der Cookie nur über sichere Verbindungen gesendet werden kann. Wenn ``TRUE``
     zurückgegeben wird, wird der Cookie also nur über *HTTPS* versendet.

   - ``isExpired(int $time = null)``: Überprüft, ob der Cookie bereits abgelaufen ist. Wenn der Cookie keine
     Ablaufzeit besitzt, wird diese Methode immer ``FALSE`` zurückgegeben. Wenn $time übergeben wurde, wird der
     aktuelle Zeitstempel überschrieben und der übergebene Zeitstempel zur Überprüfung genutzt.

   - ``isSessionCookie()``: Überprüft, ob der Cookie ein "Session-Cookie" ist, der keine Ablaufzeit besitzt und
     erst abläuft, wenn die Session beendet wird.







      .. _zend.http.cookies.cookie.accessors.example-1:

      .. rubric:: Nutzen der getter-Methoden von Zend_Http_Cookie

      .. code-block:: php
         :linenos:

         // Zuerst wird der Cookie erstellt
         $cookie = Zend_Http_Cookie::fromString(
             'foo=two+words; ' +
             'domain=.example.com; ' +
             'path=/somedir; ' +
             'secure; ' +
             'expires=Wednesday, 28-Feb-05 20:41:22 UTC');

         echo $cookie->getName();   // Gibt 'foo' aus
         echo $cookie->getValue();  // Gibt 'two words' aus
         echo $cookie->getDomain(); // Gibt '.example.com' aus
         echo $cookie->getPath();   // Gibt '/' aus

         echo date('Y-m-d', $cookie->getExpiryTime());
         // Gibt '2005-02-28' aus

         echo ($cookie->isExpired() ? 'Ja' : 'Nein');
         // Gibt 'Ja' aus

         echo ($cookie->isExpired(strtotime('2005-01-01') ? 'Ja' : 'Nein');
         // Gibt 'Nein' aus

         echo ($cookie->isSessionCookie() ? 'Ja' : 'Nein');
         // Gibt 'Nein' aus



.. _zend.http.cookies.cookie.matching:

Zend_Http_Cookie: Überprüfen von Szenarien
------------------------------------------

Die einzige wirkliche Logik in einem ``Zend_Http_Cookie`` Objekt befindet sich in der match()-Methode. Sie wird
genutzt um zu Überprüfen, ob ein Cookie auf eine *HTTP* Anfrage zutrifft, um zu entscheiden, ob der Cookie in der
Anfrage gesendet werden soll. Die Methode hat folgende Syntax und Parameter: ``Zend_Http_Cookie->match(mixed $uri,
[boolean $matchSessionCookies, [int $now]]);``

   - ``$uri``: Ein zu überprüfendes ``Zend_Uri_Http`` Objekt mit einer Domain und einem Pfad. Wahlweise kann
     stattdessen jedoch auch ein String, der einen validen *HTTP* *URL* darstellt, übergeben werden. Der Cookie
     ist zutreffend, wenn das *URL* Schema (HTTP oder *HTTPS*), die Domain sowie der Pfad passen.

   - ``$matchSessionCookies``: Gibt an, ob Session-Cookies zutreffen sollen. Standardmäßig ist dieser Parameter
     ``TRUE``. Wenn ``FALSE`` stattdessen übergeben wird, werden Cookies ohne Ablaufzeit nie zutreffen.

   - ``$now``: Ablaufzeit (in Form eines UNIX-Zeitstempels) auf welche der Cookie überprüft wird. Wenn sie nicht
     angegeben wird, wird die gegenwärtige Zeit genutzt.





      .. _zend.http.cookies.cookie.matching.example-1:

      .. rubric:: Zutreffen von Cookies

      .. code-block:: php
         :linenos:

         // Erstellen eines Cookie Objekts - zuerst ein sicherer Cookie ohne Ablaufzeit
         $cookie = Zend_Http_Cookie::fromString('foo=two+words; ' +
                                                'domain=.example.com; ' +
                                                'path=/somedir; ' +
                                                'secure;');

         $cookie->match('https://www.example.com/somedir/foo.php');
         // Gibt true zurück

         $cookie->match('http://www.example.com/somedir/foo.php');
         // Gibt false zurück, da die Verbindung nicht sicher ist

         $cookie->match('https://otherexample.com/somedir/foo.php');
         // Gibt false zurück, da die Domain falsch ist

         $cookie->match('https://example.com/foo.php');
         // Gibt false zurück, da der Pfad falsch ist

         $cookie->match('https://www.example.com/somedir/foo.php', false);
         // Gibt false zurück, da keine Session-Cookies akzeptiert werden

         $cookie->match('https://sub.domain.example.com/somedir/otherdir/foo.php');
         // Gibt true zurück

         // Erstellen eines anderen Cookie-Objekts - diesmal unsicher und
         // einer Ablaufzeit die zwei Stunden in der Zukunft liegt
         $cookie = Zend_Http_Cookie::fromString('foo=two+words; ' +
                                                'domain=www.example.com; ' +
                                                'expires='
                                                . date(DATE_COOKIE, time() + 7200));

         $cookie->match('http://www.example.com/');
         // Gibt true zurück

         $cookie->match('https://www.example.com/');
         // Gibt true zurück, da unsichere Cookies genauso gut über sichere
         // Verbindungen übertragen werden können

         $cookie->match('http://subdomain.example.com/');
         // Gibt false zurück, da die Domain unzutreffend ist

         $cookie->match('http://www.example.com/', true, time() + (3 * 3600));
         // Gibt false zurück, da die Ablaufzeit drei Stunden in der Zukunft
         // liegt



.. _zend.http.cookies.cookiejar:

Die Zend_Http_CookieJar Klasse: Instanzierung
---------------------------------------------

In den meisten Fällen ist es nicht notwendig, ein ``Zend_Http_CookieJar`` Objekt direkt zu erstellen. Wenn man ein
neues CookieJar zum ``Zend_Http_Client`` Objekts hinzufügen will, muss man lediglich die Methode
Zend_Http_Client->setCookieJar( aufrufen, die ein neues und leeres CookieJar zum Client hinzufügt. Später kann
man dieses CookieJar via Zend_Http_Client->getCookieJar() holen.

Wenn dennoch ein CookieJar Objekt manuell erstellen werden soll, kann man dies direkt durch "new
Zend_Http_CookieJar()" erreichen - der Konstruktor benötigt keine Parameter. Ein anderer Weg zum Instanzieren
eines CookieJar Objekts ist es, die statische Methode Zend_Http_CookieJar::fromResponse() zu nutzen. Diese Methode
benötigt zwei Parameter: ein ``Zend_Http_Response`` Objekt und einen Referenz *URI*, entweder in Form eines
Strings oder eines ``Zend_Uri_Http`` Objekts. Es wird ein ``Zend_Http_CookieJar`` Objekt zurückgegeben, das
bereits die Cookies, die durch die *HTTP* Antwort gesetzt wurden, enthält. Der Referenz *URI* wird genutzt um die
Domain und den Pfad des Cookies zu setzen, sofern sie nicht in den Set-Cookie-Headern definiert wurden.

.. _zend.http.cookies.cookiejar.adding_cookies:

Hinzufügen von Cookies zu einem Zend_Http_CookieJar Objekt
----------------------------------------------------------

Normalerweise werden die, durch *HTTP* Antworten gesetzen, Cookies vom ``Zend_Http_Client`` Objekt automatisch zu
dessen CookieJar hinzugefügt. Wenn man es wünscht, kann man Cookies auch manuell zum CookieJar hinzufügen, was
durch Nutzen zweier Methoden erreicht werden kann:



   - ``Zend_Http_CookieJar->addCookie($cookie[, $ref_uri])``: Hinzufügen eines einzelnen Cookies zum CookieJar.
     $cookie kann entweder ein ``Zend_Http_Cookie`` Objekt oder ein String, der automatisch zu einem Cookie Objekt
     transformiert wird, sein. Wenn ein String übergeben wird, sollte man jedoch zusätzlich immer $ref_uri
     übergeben, da dieser einen Referenz *URI* darstellt - in Form eines Strings oder eines ``Zend_Uri_Http``
     Objekts - dessen Werte als Standard für die Domain und den Pfad des Cookies genutzt werden.

   - ``Zend_Http_CookieJar->addCookiesFromResponse($response, $ref_uri)``: Fügt alle Cookies zum CookieJar hinzu,
     die in einer einzelnen *HTTP* Antwort gesetzt wurden. Es wird erwartet, dass $response ein
     ``Zend_Http_Response`` Objekt mit Set-Cookie-Headern ist. $ref_uri ist ein Anfrage *URI* in Form eines Strings
     oder eines ``Zend_Uri_Http`` Objekts dessen Inhalt die Standarddomain und den -pfad des Cookies bestimmt.



.. _zend.http.cookies.cookiejar.getting_cookies:

Abrufen der Cookies von einem Zend_Http_CookieJar-Objekts
---------------------------------------------------------

Wie beim Hinzufügen von Cookies ist es normalerweise nicht notwendig, die Cookies manuell von einem CookieJar
Objekt zu holen. Das ``Zend_Http_Client`` Objekt holt automatisch alle benötigten Cookies für eine *HTTP*
Anfrage. Allerdings gibt es drei Methoden die Cookies aus einem CookieJar zu holen: ``getCookie()``,
``getAllCookies()``, und ``getMatchingCookies()``. Zusätzlich erhält man alle ``Zend_Http_Cookie`` Objekte von
CookieJar wenn man durch Ihn iteriert.

Es ist wichtig anzumerken, dass jede dieser Methoden einen speziellen Parameter verlangt, der den Rückgabetyp der
Methode festlegt. Dieser Parameter kann drei verschiedene Werte annehmen:



   - ``Zend_Http_CookieJar::COOKIE_OBJECT``: Gibt ein ``Zend_Http_Cookie`` Objekt zurück. Wenn diese Methode mehr
     als einen Cookie zurückgeben sollte, wird stattdessen ein Array aus Objekten zurückgegeben.

   - ``Zend_Http_CookieJar::COOKIE_STRING_ARRAY``: Gibt Cookies als Strings - im Format "foo=bar" - zurück, welche
     passend für das Senden im "Cookie"-Header einer *HTTP*\ Anfrage sind. Wenn mehr als ein Cookie zurückgegeben
     werden sollte, wird stattdessen ein Array solcher Strings zurückgegeben.

   - ``Zend_Http_CookieJar::COOKIE_STRING_CONCAT``: Ähnlich zu COOKIE_STRING_ARRAY; allerdings gibt diese Methode,
     falls mehr als ein Cookie zurückgegeben wird, einen einzelnen, langen String zurück, der die Cookies anhand
     eines Semikolons (;) trennt. Dieses Prozedere ist besonders hilfreich, wenn man alle zutreffenden Cookies in
     einem einzelnen "Cookie"-Header einer *HTTP* Anfrage zurückgeben will.



Die Struktur der unterschiedlichen Cookie-Abrufmethoden wird unterhalb beschrieben:



   - ``Zend_Http_CookieJar->getCookie($uri, $cookie_name[, $ret_as])``: Gibt einen einzelnen Cookie von dem
     CookieJar zurück, dessen *URI* (Domain und Pfad) und Name zu den Parametern passen. $uri ist entweder ein
     String oder ein ``Zend_Http_Uri`` Objekt, die den *URI* darstellen. $cookie_name ist ein String zum
     Identifizieren des Cookie-Namens. $ret_as ist ein optionaler Parameter, der angibt, von welchem Typ der
     zurückgegebene Wert ist. Der Standardwert ist COOKIE_OBJECT.

   - ``Zend_Http_CookieJar->getAllCookies($ret_as)``: Holt alle Cookies aus dem CookieJar. $ret_as gibt den
     Rückgabetyp - wie oben bereits beschrieben - an. Wenn er nicht angegeben wird, nimmt er COOKIE_OBJECT an.

   - ``Zend_Http_CookieJar->getMatchingCookies($uri[, $matchSessionCookies[, $ret_as[, $now]]])``: Gibt alle
     Cookies vom CookieJar zurück, die mit der Ablaufzeit und dem *URI* übereinstimmen.



        - ``$uri`` ist entweder ein ``Zend_Uri_Http`` Objekt oder ein String, der den Verbindungstyp (sicher oder
          unsicher), die Domain und den Pfad angibt. Nach diesen Informationen wird im CookieJar gesucht.

        - ``$matchSessionCookies`` ist ein boolescher Ausdruck, der festlegt, ob nach Session-Cookies gesucht
          werden soll. Session-Cookies sind Cookies, die keine Ablaufzeit enthalten. Standardmäßig ist dieser
          Wert ``TRUE``.

        - ``$ret_as`` gibt den Rückgabetyp - wie oben beschrieben - an. Wenn keiner angegeben wird, wird
          COOKIE_OBJECT angenommen.

        - ``$now`` ist ein Integer der einen UNIX-Zeitstempel darstellt. Cookies, die vor der angegeben Zeit
          ablaufen, werden nicht zurückgegeben. Wenn dieser Parameter nicht angegeben wird, wird stattdessen die
          aktuelle Zeit gewählt.

     Mehr über das Zutreffen von Cookies gibt es in :ref:`diesem Abschnitt <zend.http.cookies.cookie.matching>`.




