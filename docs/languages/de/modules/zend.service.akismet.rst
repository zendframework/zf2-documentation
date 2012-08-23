.. EN-Revision: none
.. _zend.service.akismet:

Zend_Service_Akismet
====================

.. _zend.service.akismet.introduction:

Einführung
----------

``Zend_Service_Akismet`` bietet einen Client für die `Akismet API`_. Der Akismet Service wird verwendet um
herauszufinden ob hereinkommende Daten potentieller Spam sind. Er bietet auch Methoden für das Übertragen von
Daten als bekannter Spam oder als falsch Positiv (ham). Original war es dazu gedacht um für Wordpress zu
kategorisieren und Spam zu identifizieren, aber es für alle Arten von Daten verwendet werden.

Akismet benötigt einen *API* Schlüssel um verwendet zu werden. Man kann einen bekommen indem man sich für einen
`WordPress.com`_ Zugang einschreibt. Man muß keinen Blog aktivieren. Nur das Erstellen des Accounts reicht um den
*API* Schlüssel zu erhalten.

Akismet erfordert dass alle Anfragen eine *URL* zu der Ressource enthalten für welche die Daten gefiltert werden.
Weil Akismeth's Ursprung Wordpress ist, wird diese Ressource die Blog *URL* genannt. Dieser Wert sollte als zweites
Argument an den Konstruktor übergeben werden; aber er kann zu jeder Zeit zurückgesetzt werden in dem der
``setBlogUrl()`` Methode verwendet wird, oder überschrieben durch die Spezifizierung eines 'blog' Schlüssels in
den verschiedenen Methodenaufrufen.

.. _zend.service.akismet.verifykey:

Prüfen eines API Schlüssels
---------------------------

``Zend_Service_Akismet::verifyKey($key)`` wird verwendet um zu prüfen ob ein Akismet *API* Schlüssel gültig ist.
In den meisten Fällen, besteht keine Notwendigkeit ihn zu prüfen, aber wenn eine Qualitätssicherung
durchgeführt werden soll, oder eruiert werden soll ob ein neuerer erhaltener Schlüssel aktiv ist, kann das mit
dieser Methode gemacht werden.

.. code-block:: php
   :linenos:

   // Instanzieren mit dem API Schlüssel und einer URL zur Anwendung oder
   // Ressource die verwendet wird
   $akismet = new Zend_Service_Akismet($apiKey,
                                       'http://framework.zend.com/wiki/');
   if ($akismet->verifyKey($apiKey) {
       echo "Schlüssel ist gültig.\n";
   } else {
       echo "Schlüssel ist ungültig\n";
   }

Wenn ``verifyKey()`` ohne Argumente aufgerufen wird, verwendet es den *API* Schlüssel der im Konstruktor angegeben
wurde.

``verifyKey()`` implementiert Akismet's *verify-key* REST Methode.

.. _zend.service.akismet.isspam:

Auf Spam prüfen
---------------

``Zend_Service_Akismet::isSpam($data)`` wird verwendet um zu prüfen ob die übergebenen Daten von Akismet als Spam
erkannt werden. Es wird ein assoziatives Array als Basisargument akzeptiert. Das Array erfordert das die folgenden
Schlüssel gesetzt werden:

- *user_ip*, die IP Adresse des Benutzer der die Daten übermittelt (nicht die eigene IP Adresse, aber die des
  Benutzers der eigenen Seite).

- *user_agent*, der mitgeteilte String des BenutzerAgenten (Browser und Version) oder der Benutzer der die Daten
  überträgt.

Die folgenden Schlüssel werden im speziellen auch von der *API* erkannt:

- *blog*, die komplett qualifizierte *URL* zur Ressource oder Anwendung. Wenn nicht angegeben, wird die *URL*
  verwendet die beim Konstruktor angegeben wurde.

- *referrer*, der Inhalt des HTTP_REFERER Headers zur Zeit der Übertragung. (Beachte die Schreibweise; sie folgt
  nicht dem Header Namen)

- *permalink*, Der Ort des Permalinks vom Eintrag der Daten die übertragen wurden, wenn vorhanden.

- *comment_type*, der Typ von Daten die angegeben wurden. In der *API* spezifizierte Werte enthalten 'comment',
  'trackback', 'pingback', und einen leeren String (''), können aber beliebige Werte sein.

- *comment_author*, der Name der Person welche die Daten überträgt.

- *comment_author_email*, die Email der Person welche die Daten überträgt.

- *comment_author_url*, die *URL* oder Homepage der Person welche die Daten überträgt.

- *comment_content*, der aktuell übertragene Dateninhalt.

Es können auch beliebige andere Umgebungsvariablen übermittelt werden von denen angenommen wird, das Sie bei er
Ermittlung helfen ob Daten Spam sind. Akismet empfiehlt den Inhalt des kompletten $_SERVER Arrays.

Die ``isSpam()`` Methode gibt ``TRUE`` oder ``FALSE`` zurück, oder wirft eine Exception wenn der *API* Schlüssel
nicht gültig ist.

.. _zend.service.akismet.isspam.example-1:

.. rubric:: Verwendung von isSpam()

.. code-block:: php
   :linenos:

   $data = array(
       'user_ip'              => '111.222.111.222',
       'user_agent'           => 'Mozilla/5.0 (Windows; U; Windows NT ' .
                                 '5.2; en-GB; rv:1.8.1) Gecko/20061010 ' .
                                 'Firefox/2.0',
       'comment_type'         => 'contact',
       'comment_author'       => 'John Doe',
       'comment_author_email' => 'nospam@myhaus.net',
       'comment_content'      => "Ich bin kein Spammer, ehrlich!"
   );
   if ($akismet->isSpam($data)) {
       echo "Sorry, aber wir denken das Du ein Spammer bist.";
   } else {
       echo "Willkommen auf unserer Seite!";
   }

``isSpam()`` implementiert die *comment-check* Methode der Akismet *API*.

.. _zend.service.akismet.submitspam:

Bekannten Spam übertragen
-------------------------

Spam Daten kommen gelegentlich durch den Filter. Wenn in der Begutachtung der hereinkommenden Daten Spam erkannt
wird, und man das Gefühl hat das er gefunden werden sollte, kann er an Akismet übertragen werden um deren Filter
zu verbessern.

``Zend_Service_Akismet::submitSpam()`` nimmt das selbe Datenarray entgegen wie es der ``isSpam()`` übergeben wird,
aber es wird kein Wert zurückgegeben. Eine Ausnahme wird geworfen wenn der *API* Schlüssel ungültig ist.

.. _zend.service.akismet.submitspam.example-1:

.. rubric:: Verwendung von submitSpam()

.. code-block:: php
   :linenos:

   $data = array(
       'user_ip'              => '111.222.111.222',
       'user_agent'           => 'Mozilla/5.0 (Windows; U; Windows NT 5.2;' .
                                 'en-GB; rv:1.8.1) Gecko/20061010 Firefox/2.0',
       'comment_type'         => 'contact',
       'comment_author'       => 'John Doe',
       'comment_author_email' => 'nospam@myhaus.net',
       'comment_content'      => "Ich bin kein Spammer, ehrlich!"
   );
   $akismet->submitSpam($data));

``submitSpam()`` implementiert die *submit-spam* Methode der Akismet *API*.

.. _zend.service.akismet.submitham:

Falsche Positive (Ham) übermitteln
----------------------------------

Daten werden genegentlich fehlerhafterweise von Akismet als Spam erkannt. Für diesen Fall, sollte ein Log aller
Daten behalten werden, indem alle Daten die von Akismet als Spam erkannt, geloggt werden und dieses von Zeit zu
Zeit durchgesehen. Wenn solche Fülle gefunden werden, können die Daten an Akismet als "Ham", oder falsche
Positive übermittelt werden (Ham ist gut, Spam ist schlecht)

``Zend_Service_Akismet::submitHam()`` nimmt das selbe Datenarray entgegen wie ``isSpam()`` oder ``submitSpam()``,
und wie bei ``submitSpam()`` wird kein Wert zurückgegeben. Eine Ausnahme wird geworfen wenn der verwendete *API*
Schlüssel ungültig ist.

.. _zend.service.akismet.submitham.example-1:

.. rubric:: Verwenden von submitHam()

.. code-block:: php
   :linenos:

   $data = array(
       'user_ip'              => '111.222.111.222',
       'user_agent'           => 'Mozilla/5.0 (Windows; U; Windows NT 5.2;' .
                                 'en-GB; rv:1.8.1) Gecko/20061010 Firefox/2.0',
       'comment_type'         => 'contact',
       'comment_author'       => 'John Doe',
       'comment_author_email' => 'nospam@myhaus.net',
       'comment_content'      => "I'm not a spammer, honest!"
   );
   $akismet->submitHam($data));

``submitHam()`` implementiert die *submit-ham* Methode der Akismet *API*.

.. _zend.service.akismet.accessors:

Zend-spezifische Methoden
-------------------------

Wärend die Akismet *API* nur vier Methoden spezifiziert, hat ``Zend_Service_Akismet`` verschiedene zusätzliche
Methoden die für das Empfangen und Ändern von internen Eigenschaften verwendet werden können.

- ``getBlogUrl()`` und ``setBlogUrl()`` erlaubt das Empfangen und Ändern der Blog *URL* die in den Anfragen
  verwendet wird.

- ``getApiKey()`` und ``setApiKey()`` erlauben das Empfangen und Ändern des *API* Schlüssels der in Anfragen
  verwendet wird.

- ``getCharset()`` und ``setCharset()`` erlauben das Empfangen und Ändern des Zeichensatzes der verwendet wird um
  die Anfrage durchzuführen.

- ``getPort()`` und ``setPort()`` erlauben das Empfangen und Ändern des *TCP* Ports der verwendet wird um die
  Anfrage durchzuführen.

- ``getUserAgent()`` und ``setUserAgent()`` erlauben das Empfangen und Ändern des *HTTP* Benutzer Agenten der
  verwendet wird um die Anfrage durchzuführen. Beachte: Das ist nicht der user_agent der in den Daten verwendet
  wird die in den Service übertragen werden, aber der Wert der im *HTTP* User-Agent Header übergeben wird, wenn
  eine Anfrage an den Service durchgeführt wird.

  Der Wert der verwendet wird um den Benutzer Agenten zu setzen sollte die Form *ein Benutzer Agent/Version |
  Akismet/Version* haben. Der Standardwert ist *Zend Framework/ZF-VERSION | Akismet/1.11*, wobei *ZF-VERSION* die
  aktuelle Version des Zend Frameworks ist wie in der Konstante ``Zend_Framework::VERSION`` gespeichert.



.. _`Akismet API`: http://akismet.com/development/api/
.. _`WordPress.com`: http://wordpress.com/
