.. EN-Revision: none
.. _zend.gdata.photos:

Picasa Web Alben verwenden
==========================

Picasa Web Alben ist ein Service der es Benutzer erlaubt Alben von Ihren eigenen Bildern zu verwalten, und die
Alben und Bilder von anderen anzusehen. Die *API* bietet ein programmtechnisches Interface für diesen Service, der
es Benutzer erlaubt hinzuzufügen, zu aktualisieren, und von Ihren Alben zu löschen, genauso wie die Möglichkeit
Tags und Kommentare auf Fotos zu gestatten.

Der Zugriff auf öffentliche Alben und Photos ist nicht durch einen Zugang beschränkt. Trotzdem muß ein Benutzer
angemeldet sein für einen nicht-nur-lesenden Zugriff.

Für weitere Informationen über die *API*, inklusive Anleitungen für das Aktivieren des *API* Zugriffs, sollte in
die `Picasa Web Alben Daten API Übersicht`_ gesehen werden.

.. note::

   **Authentifizierung**

   Die *API* bietet Authentifizierung über AuthSub (vorgeschlagen) und ClientAuth. *HTTP* Verbindungen müssen
   für einen Lesezugriff authentifiziert sein, aber nicht-authentifizierte Verbindungen haben nur-lesenden
   Zugriff.

.. _zend.gdata.photos.connecting:

Zum Service verbinden
---------------------

Die Picasa Web Album *API* basiert, wie alle GData *API*\ s, auf dem Atom Publishing Protokoll (APP), einem *XML*
basierenden Format für gemanagte web-basierende Ressourcen. Der Verkehr zwischen Client und den Servers tritt
über *HTTP* auf, und erlaubt sowohl authentifizierte als auch nicht authentifizierte Verbindungen.

Bevor irgendeine Transaktion stattfinden kann muß diese Verbindung hergestellt werden. Die Erstellung einer
Verbindung zum Picasa Servern beinhaltet zwei Schritte: Erstellung eines *HTTP* Clients und Binden einer
``ZendGData\Photos`` Instanz an diesen Client.

.. _zend.gdata.photos.connecting.authentication:

Authentifikation
^^^^^^^^^^^^^^^^

Die Google Picasa *API* erlaubt erlaubt den Zugriff sowohl auf öffentliche als auch auf private Kalender Feeds.
Öffentliche Feeds benötigen keine Authentifizierung sind aber nur-lesend und bieten eine reduzierte
Funktionalität. Private Feeds bieten die kompletteste Funktionalität benötigen aber eine authentifizierte
Verbindung zum Picasa Server. Es gibt drei Authentifizierungs Schemata die von Google Picasa unterstützt werden:

- **ClientAuth** bietet direkte Benutzername/Passwort Authentifizierung zu den Picasa Servern. Da dieses Schema
  erfordert das Benutzer die Anwendung mit Ihrem Passwort versorgen, ist diese Authentifizierung nur zu empfehlen
  wenn andere Authentifizierungs Schemas nicht anwendbar sind.

- **AuthSub** erlaubt die Authentifizierung zu den Picasa Servern über einen Google Proxy Server. Das bietet den
  gleichen Level von Bequemlichkeit wie ClientAuth aber ohne die Sicherheits Risiken, was es zu einer idealen Wahl
  für Web basierende Anwendungen macht.

Die ``ZendGData`` Bibliothek bietet Unterstützung für beide Authentifizierungs Schemas. Der Rest dieses Kapitels
nimmt an das die vorhandenen Authentifizierungs Schemas geläufig sind und wie eine korrekte Authentifizierte
Verbindung erstellt wird. Für weitere Details kann in die :ref:`Authentifizierungs Sektion
<zend.gdata.introduction.authentication>` dieses Handbuches, oder in die `Authentifizierungs Übersicht im Google
Data API Entwickler Guide`_ gesehen werden.

.. _zend.gdata.photos.connecting.service:

Erstellen einer Service Instanz
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um mit den Servern zu interagieren, bietet diese Bibliothek die ``ZendGData\Photos`` Service Klasse. Diese Klasse
bietet ein übliches Interface zu den Google Data und Atom Publishing Protocol Modellen und assistiert in der
Behandlung der Anfragen zum und von den Kalender Servern.

Sobald ein Authentifizierung Schema ausgewählt wurde, besteht der nächste Schritt darin eine Instanz von
``ZendGData\Photos`` zu erstellen. Der Klassen Konstruktor nimmt eine Instanz von ``Zend\Http\Client`` als
einzelnes Argument. Das bietet ein Interface für AuthSub und ClientAuth Authentifizierungen, da beide von Ihnen
die Erstellung eines speziellen authentifizierten *HTTP* Clients benötigen. Wenn keine Argumente angegeben werden,
wird automatisch eine unauthentifizierte Instanz von ``Zend\Http\Client`` erstellt.

Das folgende Beispiel zeigt wie man eine Service Klasse erstellt und dabei die ClientAuth Authentifizierung
verwendet:

.. code-block:: php
   :linenos:

   // Parameter für die ClientAuth Authentifizierung
   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $user = "sample.user@gmail.com";
   $pass = "pa$$w0rd";

   // Erstellt einen authentifizierten HTTP Client
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);

   // Erstellt eine Instanz des Kalender Services
   $service = new ZendGData\Photos($client);

Eine Service Instanz die AuthSub verwendet, kann ähnlich erstellt werden, aber durch eine etwas längere
Schreibweise:

.. code-block:: php
   :linenos:

   session_start();

   /**
    * Gibt die komplette URL der aktuellen Seite zurück, basierend auf den env Variablen
    *
    * Verwendete Env Variablen:
    * $_SERVER['HTTPS'] = (on|off|)
    * $_SERVER['HTTP_HOST'] = Wert des Hosts: header
    * $_SERVER['SERVER_PORT'] = Port Nummer (nur verwendet wenn nicht http/80,https/443)
    * $_SERVER['REQUEST_URI'] = Die URI nach der Methode der HTTP Anfrage
    *
    * @return string Current URL
    */
   function getCurrentUrl()
   {
       global $_SERVER;

       /**
        * php_self filtern um Sicherheits Lücken zu vermeiden.
        */
       $php_request_uri = htmlentities(substr($_SERVER['REQUEST_URI'], 0,
       strcspn($_SERVER['REQUEST_URI'], "\n\r")), ENT_QUOTES);

       if (isset($_SERVER['HTTPS']) && strtolower($_SERVER['HTTPS']) == 'on') {
           $protocol = 'https://';
       } else {
           $protocol = 'http://';
       }
       $host = $_SERVER['HTTP_HOST'];
       if ($_SERVER['SERVER_PORT'] != '' &&
           (($protocol == 'http://' && $_SERVER['SERVER_PORT'] != '80') ||
           ($protocol == 'https://' && $_SERVER['SERVER_PORT'] != '443'))) {
               $port = ':' . $_SERVER['SERVER_PORT'];
       } else {
           $port = '';
       }
       return $protocol . $host . $port . $php_request_uri;
   }

   /**
    * Gibt die AuthSub URL zurück welche der Benutzer besuchen muß um Anfrage
    * dieser Anwendung zu authentifizieren
    *
    * Verwendet getCurrentUrl() um die nächste URL zu erhalten zu welcher der
    * Benutzer weitergeleitet wird nachdem er
    * sich erfolgreich beim Google Service authentifiziert hat.
    *
    * @return string AuthSub URL
    */
   function getAuthSubUrl()
   {
       $next = getCurrentUrl();
       $scope = 'http://picasaweb.google.com/data';
       $secure = false;
       $session = true;
       return ZendGData\AuthSub::getAuthSubTokenUri($next, $scope, $secure,
           $session);
   }

   /**
    * Gibt ein HTTP Client Objekt mit den richtigen Headern für die Kommunikation
    * with Google zurück wobei
    * AuthSub Authentifizierung verwendet wird
    *
    * Verwendet $_SESSION['sessionToken'] um das AuthSub Session Token zu
    * speichern nachdem es erhalten wurde.
    * Das einmal verwendbare Token das in der URL bei der Umleitung angeboten wird
    * nachdem der Benutzer auf
    * Google erfolgreich authentifiziert wurde, wird von der $_GET['token']
    * Variable empfangen.
    *
    * @return Zend\Http\Client
    */
   function getAuthSubHttpClient()
   {
       global $_SESSION, $_GET;
       if (!isset($_SESSION['sessionToken']) && isset($_GET['token'])) {
           $_SESSION['sessionToken'] =
               ZendGData\AuthSub::getAuthSubSessionToken($_GET['token']);
       }
       $client = ZendGData\AuthSub::getHttpClient($_SESSION['sessionToken']);
       return $client;
   }

   /**
    * Erstellt eine neue Instant des Services und leitet den Benutzer zum AuthSub
    * Server um wenn das notwendig ist.
    */
   $service = new ZendGData\Photos(getAuthSubHttpClient());

Zuletzt kann ein nicht authentifizierter Server für die Verwendung mit öffentlichen Feeds erstellt werden:

.. code-block:: php
   :linenos:

   // Erstellt eine Instanz des Services und verwendet einen nicht authentifizierten HTTP Client
   $service = new ZendGData\Photos();

.. _zend.gdata.photos.queries:

Verstehen und Erstellen von Abfragen
------------------------------------

Die primäre Methode um Daten vom Service anzufragen ist die Erstellung einer Abfrage. Es gibt Abfrage Klassen für
jede der folgenden Typen:

- **User** wird verwendet um den Benutzer zu spezifizieren dessen Daten gesucht werden, und wird als EMail Adresse
  spezifiziert. Wenn kein Benutzer angegeben wurde, wird stattdessen "default" verwendet um den aktuellen
  authentifizierten Benutzer zu bezeichnen (wenn er authentifiziert wurde).

- **Album** wird verwendet um das Album zu spezifizieren das gesucht werden soll, und wird entweder als ID oder als
  Name des Albums spezifiziert.

- **Photo** wird verwendet um das Photo zu spezifizieren das gesucht werden soll, und wird als ID spezifiziert.

Eine neue ``UserQuery`` kann wie folgt erstellt werden:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\UserQuery();
   $query->setUser("sample.user");

Für jede Abfrage kann eine Anzahl an Parameter, welche die Suche limitieren, abgefragt, oder mit get(Parameter)
und set(Parameter) spezifiziert werden. Diese sind wie folgt:

- **Projection** setzt das Format der im Feed zurückgegebenen Daten entweder "api" oder "base". Normal wird "api"
  gewählt. "api" ist auch der Standardwert.

- **Type** setzt den Typ der Elemente die zurückgegeben werden, entweder "feed" oder "entry". Der Standardwert ist
  "feed".

- **Access** setzt die Sichtbarkeit von Teilen die zurückgegeben werden, mit "all", "public", oder "private". Der
  Standardwert ist "all". Nicht-öffentliche Elemente werden nur zurückgegeben wenn die Abfrage durch
  authentifizierte Benutzer gesucht wird.

- **Tag** setzt einen Tag Filter für zurückgegebenen Teile. Wenn ein Tag gesetzt ist werden nur Teile mit so
  einem Tag im Wert zurückgegeben.

- **Kind** setzt die Art von Elementen die zurückgegeben wird. Wenn eine Art spezifiziert wird, werden nur
  Einträge zurückgegeben die auf diesen Wert passen.

- **ImgMax** setzt das Maximum der Bildgröße für zurückgegebene Einträge. Nur Bildeinträge die kleiner als
  dieser Wert sind werden zurückgegeben.

- **Thumbsize** setzt die Vorschaugröße von Einträgen die zurückgegeben werden. Jeder empfangene Eintrag wird
  eine Vorschaugröße haben die diesem Wert entspricht.

- **User** setzt den Benutzer nach dessen Daten gesucht werden soll. Der Standardwert ist "default".

- **AlbumId** setzt die ID des Albums nachdem gesucht wird. Dieses Element ist nur für Album und Photo Abfragen
  gültig. Im Fall von Photo Abfragen spezifiziert dieser Wert das Album das die angefragten Photos enthält. Die
  Album ID schließt sich gegenseitig mit dem Album Namen aus. Das Setzen des einen Entfernt den anderen.

- **AlbumName** setzt den Namen des Albums nachdem gesucht wird. Dieses Element ist nur für Album und Photo
  Abfragen gültig. Im Fall von Photo Abfragen spezifiziert dieser Wert das Album das die angefragten Photos
  enthält. Der Album Name schließt sich gegenseitig mit der Album ID aus. Das Setzen des einen Entfernt den
  anderen.

- **PhotoId** setzt die ID des Photos nachdem gesucht wird. Dieses Element ist nur für Photo Abfragen gültig.

.. _zend.gdata.photos.retrieval:

Feeds und Einträge erhalten
---------------------------

Das Service besitzt Funktionen um einen Feed oder individuelle Einträge für Benutzer, Alben, und individuelle
Photos zu erhalten.

.. _zend.gdata.photos.user_retrieval:

Einen Benutzer erhalten
^^^^^^^^^^^^^^^^^^^^^^^

Dieser Service unterstützt das Erhalten eines Benutzer Feeds und Listen von Benutzer Inhalten. Wenn der abgefragte
Benutzer auch der authentifizierter Benutzer ist, werden auch Einträge die als "**hidden**" markiert sind,
zurückgegeben.

Auf den Benutzer Feed kann durch die Übergabe eines Benutzernamens an die ``getUserFeed()`` Methode zugegriffen
werden:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   try {
       $userFeed = $service->getUserFeed("sample.user");
   } catch (ZendGData\App\Exception $e) {
       echo "Fehler: " . $e->getMessage();
   }

Oder, der auf den Feed kann zugegriffen werden indem zuerst eine Abfrage erstellt wird:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\UserQuery();
   $query->setUser("sample.user");

   try {
       $userFeed = $service->getUserFeed(null, $query);
   } catch (ZendGData\App\Exception $e) {
       echo "Fehler: " . $e->getMessage();
   }

Die Erstellung einer Abfrage bietet auch die Möglichkeit ein Benutzer Eintrags Objekt abzufragen:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\UserQuery();
   $query->setUser("sample.user");
   $query->setType("entry");

   try {
       $userEntry = $service->getUserEntry($query);
   } catch (ZendGData\App\Exception $e) {
       echo "Fehler: " . $e->getMessage();
   }

.. _zend.gdata.photos.album_retrieval:

Ein Album erhalten
^^^^^^^^^^^^^^^^^^

Der Service unterstützt auch das erhalten eines Album Feeds und von Listen des Inhalts von Alben.

Auf einen Album Feed wird durch die Erstellung eines Abfrage Objekts zugegriffen und dessen Übergabe an
``getAlbumFeed()``:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\AlbumQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");

   try {
       $albumFeed = $service->getAlbumFeed($query);
   } catch (ZendGData\App\Exception $e) {
       echo "Fehler: " . $e->getMessage();
   }

Alternativ kann dem Abfrage Objekt ein Album Name mit ``setAlbumName()`` angegeben werden. Das Setzen des Album
Namens schließt sich gegenseitig mit der Album ID aus und das Setzen des einen entfernt den anderen Wert.

Die Erstellung einer Abfragen bietet auch die Möglichkeit ein Album Eintrags Objekt abzufragen:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\AlbumQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setType("entry");

   try {
       $albumEntry = $service->getAlbumEntry($query);
   } catch (ZendGData\App\Exception $e) {
       echo "Fehler: " . $e->getMessage();
   }

.. _zend.gdata.photos.photo_retrieval:

Ein Photo erhalten
^^^^^^^^^^^^^^^^^^

Der Service unterstützt auch das erhalten eines Photo Feeds und von Listen von zugeordneten Kommentaren und Tags.

Auf einen Photo Feed wird durch die Erstellung eines Abfrage Objekts zugegriffen und dessen Übergabe an
``getPhotoFeed()``:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");

   try {
       $photoFeed = $service->getPhotoFeed($query);
   } catch (ZendGData\App\Exception $e) {
       echo "Fehler: " . $e->getMessage();
   }

Die Erstellung einer Abfragen bietet auch die Möglichkeit ein Photo Eintrags Objekt abzufragen:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");
   $query->setType("entry");

   try {
       $photoEntry = $service->getPhotoEntry($query);
   } catch (ZendGData\App\Exception $e) {
       echo "Fehler: " . $e->getMessage();
   }

.. _zend.gdata.photos.comment_retrieval:

Ein Kommentar erhalten
^^^^^^^^^^^^^^^^^^^^^^

Der Service unterstützt den Erhalt von Kommentaren von einem Feed eines anderen Typs. Durch das Setzen der Abfrage
das eine Art von "Kommentar" zurückgegeben wird, kann eine Feed Anfrage mit einem speziellen Benutzer, Album oder
Photo assoziierte Kommentare zurückgeben.

Die Durchführung von Aktionen auf jedem der Kommentare eines gegebenen Photos kann die folgt vollendet werden:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");
   $query->setKind("comment");

   try {
       $photoFeed = $service->getPhotoFeed($query);

       foreach ($photoFeed as $entry) {
           if ($entry instanceof ZendGData\Photos\CommentEntry) {
               // Mach irgendwas mit dem Kommentar
           }
       }
   } catch (ZendGData\App\Exception $e) {
       echo "Fehler: " . $e->getMessage();
   }

.. _zend.gdata.photos.tag_retrieval:

Ein Tag erhalten
^^^^^^^^^^^^^^^^

Der Service unterstützt den Erhalt von Tags von einem Feed eines anderen Typs. Durch das Setzen der Abfrage das
eine Art von "Tag" zurückgegeben wird, kann eine Feed Anfrage mit einem speziellen Photo assoziierte Tags
zurückgeben.

Das Ausführen einer Aktrion auf jedem Tag an gegebenen Photos kann wie folgt durchgeführt werden:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");
   $query->setKind("tag");

   try {
       $photoFeed = $service->getPhotoFeed($query);

       foreach ($photoFeed as $entry) {
           if ($entry instanceof ZendGData\Photos\TagEntry) {
               // Mach irgendwas mit dem Tag
           }
       }
   } catch (ZendGData\App\Exception $e) {
       echo "Fehler: " . $e->getMessage();
   }

.. _zend.gdata.photos.creation:

Einträge erstellen
------------------

Der Service hat Funktionen für die Erstellung von Alben, Photos, Kommentaren und Tags.

.. _zend.gdata.photos.album_creation:

Ein Album erstellen
^^^^^^^^^^^^^^^^^^^

Der Service unterstützt die Erstellung eines neues Albums für authentifizierte Benutzer:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $entry = new ZendGData\Photos\AlbumEntry();
   $entry->setTitle($service->newTitle("test album"));

   $service->insertAlbumEntry($entry);

.. _zend.gdata.photos.photo_creation:

Ein Photo erstellen
^^^^^^^^^^^^^^^^^^^

Der Service unterstützt die Erstellung eines neuen Photos für authentifizierte Benutzer:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   // $photo ist der Name der Datei die durch ein HTML Formular hochgeladen wurde

   $fd = $service->newMediaFileSource($photo["tmp_name"]);
   $fd->setContentType($photo["type"]);

   $entry = new ZendGData\Photos\PhotoEntry();
   $entry->setMediaSource($fd);
   $entry->setTitle($service->newTitle($photo["name"]));

   $albumQuery = new ZendGData\Photos\AlbumQuery;
   $albumQuery->setUser("sample.user");
   $albumQuery->setAlbumId("1");

   $albumEntry = $service->getAlbumEntry($albumQuery);

   $service->insertPhotoEntry($entry, $albumEntry);

.. _zend.gdata.photos.comment_creation:

Erstellen eines Kommentars
^^^^^^^^^^^^^^^^^^^^^^^^^^

Das Service unterstützt die Erstellung von neuen Kommentaren für ein Photo:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $entry = new ZendGData\Photos\CommentEntry();
   $entry->setTitle($service->newTitle("comment"));
   $entry->setContent($service->newContent("comment"));

   $photoQuery = new ZendGData\Photos\PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $photoEntry = $service->getPhotoEntry($photoQuery);

   $service->insertCommentEntry($entry, $photoEntry);

.. _zend.gdata.photos.tag_creation:

Erstellen eines Tags
^^^^^^^^^^^^^^^^^^^^

Das Service unterstützt die Erstellung von neuen Tags für ein Photo:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $entry = new ZendGData\Photos\TagEntry();
   $entry->setTitle($service->newTitle("tag"));

   $photoQuery = new ZendGData\Photos\PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $photoEntry = $service->getPhotoEntry($photoQuery);

   $service->insertTagEntry($entry, $photoEntry);

.. _zend.gdata.photos.deletion:

Einträge löschen
----------------

Der Service hat Funktionen um Alben, Photos, Kommentare und Tags zu löschen.

.. _zend.gdata.photos.album_deletion:

Ein Album löschen
^^^^^^^^^^^^^^^^^

Der Service unterstützt das Löschen von Alben für authentifizierte Benutzer:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $albumQuery = new ZendGData\Photos\AlbumQuery;
   $albumQuery->setUser("sample.user");
   $albumQuery->setAlbumId("1");
   $albumQuery->setType('entry');

   $entry = $service->getAlbumEntry($albumQuery);

   $service->deleteAlbumEntry($entry, true);

.. _zend.gdata.photos.photo_deletion:

Löschen eines Photos
^^^^^^^^^^^^^^^^^^^^

Der Service unterstützt das Löschen von Photos für authentifizierte Benutzer:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $photoQuery = new ZendGData\Photos\PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $entry = $service->getPhotoEntry($photoQuery);

   $service->deletePhotoEntry($entry, true);

.. _zend.gdata.photos.comment_deletion:

Ein Kommentar löschen
^^^^^^^^^^^^^^^^^^^^^

Der Service unterstützt das Löschen von Kommentaren für authentifizierte Benutzer:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $photoQuery = new ZendGData\Photos\PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $path = $photoQuery->getQueryUrl() . '/commentid/' . "1000";

   $entry = $service->getCommentEntry($path);

   $service->deleteCommentEntry($entry, true);

.. _zend.gdata.photos.tag_deletion:

Ein Tag löschen
^^^^^^^^^^^^^^^

Das Service unterstützt das Löschen eines Tags für authentifizierte Benutzer:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $photoQuery = new ZendGData\Photos\PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setKind("tag");
   $query = $photoQuery->getQueryUrl();

   $photoFeed = $service->getPhotoFeed($query);

   foreach ($photoFeed as $entry) {
       if ($entry instanceof ZendGData\Photos\TagEntry) {
           if ($entry->getContent() == $tagContent) {
               $tagEntry = $entry;
           }
       }
   }

   $service->deleteTagEntry($tagEntry, true);

.. _zend.gdata.photos.optimistic_concurrenty:

Optimistische Gleichzeitigkeit (Notizen für das Löschen)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

GData Feeds, inklusive denen des Picasa Web Album Services, implementieren optimistische Gleichzeitigkeit, ein
Versionsverwaltungs System das vermeidet das Benutzer irrtümlich Änderungen überschreiben. Wenn ein Eintrag
durch die Service Klasse gelöscht wird, wenn der Eintrag geändert wurde seit er zuletzt geholt wurde, wird eine
Ausnahme geworfen, solange das nicht explizit anders gesetzt wurde (in diesem Fall wird die Löschung auf dem
aktualisierten Eintrag durchgeführt).

Ein Beispiel davon wie die Versionierung wärend einer Löschung handzuhaben ist wird durch ``deleteAlbumEntry()``
gezeigt:

.. code-block:: php
   :linenos:

   // $album ist ein albumEntry der gelöscht werden soll
   try {
       $this->delete($album);
   } catch (ZendGData\App\HttpException $e) {
       if ($e->getMessage->getStatus() === 409) {
           $entry =
               new ZendGData\Photos\AlbumEntry($e->getMessage()->getBody());
           $this->delete($entry->getLink('edit')->href);
       } else {
           throw $e;
       }
   }



.. _`Picasa Web Alben Daten API Übersicht`: http://code.google.com/apis/picasaweb/overview.html
.. _`Authentifizierungs Übersicht im Google Data API Entwickler Guide`: http://code.google.com/apis/gdata/auth.html
