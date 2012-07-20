.. _zend.gdata.calendar:

Google Kalender verwenden
=========================

Die ``Zend_Gdata_Calendar`` Klasse kann verwendet werden um Events im Online Google Kalender Service zu sehen,
erstellen, updaten und löschen.

Siehe `http://code.google.com/apis/calendar/overview.html`_ für weitere Informationen über die Google Kalender
*API*.

.. _zend.gdata.calendar.connecting:

Zum Kalender Service verbinden
------------------------------

Die Google Kalender *API* basiert, wie alle GData *API*\ s, auf dem Atom Publishing Protocol (APP), einem *XML*
basierenden Format für gemanagte Web-basierte Ressourcen. Verkehr zwischen einem Client und den Google Kalender
Servern läuft über *HTTP* und erlaubt sowohl authentifizierte als auch unauthentifizierte Verbindungen.

Bevor irgendeine Transaktion stattfinden kann, muß diese Verbindung erstellt werden. Die Erstellung einer
Verbindung zu den Kalender Server beinhaltet zwei Schritte: Erstellung eines *HTTP* Clients und das binden einer
``Zend_Gdata_Calendar`` Instanz an diesen Client.

.. _zend.gdata.calendar.connecting.authentication:

Authentifizierung
^^^^^^^^^^^^^^^^^

Die Google Kalender *API* erlaubt den Zugriff auf beide, öffentliche und private, Kalender Feeds. Öfentliche
Foods benötigen keine Authentifizierung, aber sie können nur gelesen werden und bieten reduzierte
Funktionalitäten. Private Feeds bieten die kompletteste Funktionalität benötigen aber eine authentifizierte
Verbindung zu den Kalender Servern. Es gibt drei Authentifizierungs Schemas die von Google Kalender unterstützt
werden:

- **ClientAuth** bietet direkte Benutzername/Passwort Authentifizierung zu den Kalender Servern. Da dieses Schema
  erfordert das Benutzer die Anwendung mit Ihrem Passwort versorgen, ist diese Authentifizierung nur zu empfehlen
  wenn andere Authentifizierungs Schemas nicht anwendbar sind.

- **AuthSub** erlaubt die Authentifizierung zu den Kalender Servern über einen Google Proxy Server. Das bietet den
  gleichen Level von Bequemlichkeit wie ClientAuth aber ohne die Sicherheits Risiken, was es zu einer idealen Wahl
  für Web basierende Anwendungen macht.

- **MagicCookie** erlaubt die Authentifizierung basieren auf einer semi-zufälligen *URL* von immerhalb des Google
  Kalender Interfaces. Das ist das einfachste Authentifizierungs Schema das implmentiert werden kann, erzwingt aber
  das Benutzer ihre Sicherheits *URL* manuell empfangen, bevor sie sich authentifizieren können, und ist limitiert
  auf nur-lesenden Zugriff.

Die ``Zend_Gdata`` Bibliothek bietet Unterstützung für alle drei Authentifizierungs Schemas. Der Rest dieses
Kapitels nimmt an das die vorhandenen Authentifizierungs Schemas geläufig sind und wie eine korrekte
Authentifizierte Verbindung erstellt wird. Für weitere Details kann in die :ref:`Authentifizierungs Sektion
<zend.gdata.introduction.authentication>` dieses Handbuches, oder in die `Authentifizierungs Übersicht im Google
Data API Entwickler Guide`_ gesehen werden.

.. _zend.gdata.calendar.connecting.service:

Eine Service Instanz erstellen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um mit dem Google Kalender zu interagieren, bietet diese Bibliothek die ``Zend_Gdata_Calendar`` Service Klasse.
Diese Klasse bietet ein übliches Interface zu den Google Data und Atom Publishing Protocol Modellen und assistiert
in der Behandlung der Anfragen zum und von den Kalender Servern.

Sobald ein Authentifizierung Schema ausgewählt wurde, besteht der nächste Schritt darin eine Instanz von
``Zend_Gdata_Calendar`` zu erstellen. Der Klassen Konstruktor nimmt eine Instanz von ``Zend_Http_Client`` als
einzelnes Argument. Das bietet ein Interface für AuthSub und ClientAuth Authentifizierungen, da beide von Ihnen
die Erstellung eines speziellen authentifizierten *HTTP* Clients benötigen. Wenn keine Argumente angegeben werden,
wird automatisch eine unauthentifizierte Instanz von ``Zend_Http_Client`` erstellt.

Das folgende Beispiel zeigt wie man eine Kalender Service Klasse erstellt und dabei die ClientAuth
Authentifizierung verwendet:

.. code-block:: php
   :linenos:

   // Parameter für die ClientAuth Authentifizierung
   $service = Zend_Gdata_Calendar::AUTH_SERVICE_NAME;
   $user = "sample.user@gmail.com";
   $pass = "pa$$w0rd";

   // Erstellt einen authentifizierten HTTP Client
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);

   // Erstellt eine Instanz des Kalender Services
   $service = new Zend_Gdata_Calendar($client);

Ein Kalender Service der AuthSub verwendet, kann ähnlich erstellt werden, durch eine etwas längere Schreibweise:

.. code-block:: php
   :linenos:

   /*
    * Empfängt die aktuelle URL so das der AuthSub Server weiß wohin er den
    * Benutzer umleiten soll nachdem die Authentifizierung komplett ist.
    */
   function getCurrentUrl()
   {
       global $_SERVER;

       // Filtert php_self um Sicherheitsprobleme zu vermeiden.
       $php_request_uri =
           htmlentities(substr($_SERVER['REQUEST_URI'],
                               0,
                               strcspn($_SERVER['REQUEST_URI'], "\n\r")),
                               ENT_QUOTES);

       if (isset($_SERVER['HTTPS']) &&
           strtolower($_SERVER['HTTPS']) == 'on') {
           $protocol = 'https://';
       } else {
           $protocol = 'http://';
       }
       $host = $_SERVER['HTTP_HOST'];
       if ($_SERVER['HTTP_PORT'] != '' &&
           (($protocol == 'http://' && $_SERVER['HTTP_PORT'] != '80') ||
           ($protocol == 'https://' && $_SERVER['HTTP_PORT'] != '443'))) {
           $port = ':' . $_SERVER['HTTP_PORT'];
       } else {
           $port = '';
       }
       return $protocol . $host . $port . $php_request_uri;
   }

   /**
    * Einen AuthSub authentifizierten HTTP Client nehmen, der den Benutzer
    * zum AuthSub Server zum Login umleitet wenn es notwendig ist.
    */
   function getAuthSubHttpClient()
   {
       global $_SESSION, $_GET;

       // Wenn es keine AuthSub Session oder einmal-benutzbares Token gibt die auf
       // uns warten, den Benutzer zum AuthSub Server umleiten um Ihn zu erhalten
       if (!isset($_SESSION['sessionToken']) && !isset($_GET['token'])) {
           // Parameter für den AuthSub Server
           $next = getCurrentUrl();
           $scope = "http://www.google.com/calendar/feeds/";
           $secure = false;
           $session = true;

           // Den Benutzer zum AuthSub server umleiten zur Anmeldung

           $authSubUrl = Zend_Gdata_AuthSub::getAuthSubTokenUri($next,
                                                                $scope,
                                                                $secure,
                                                                $session);
            header("HTTP/1.0 307 Temporary redirect");

            header("Location: " . $authSubUrl);

            exit();
       }

       // Konvertiert ein AuthSub einmal-benutzbares Token in ein Session
       // Token wenn das notwendig ist
       if (!isset($_SESSION['sessionToken']) && isset($_GET['token'])) {
           $_SESSION['sessionToken'] =
               Zend_Gdata_AuthSub::getAuthSubSessionToken($_GET['token']);
       }

       // An diesem Punkt sind wir authentifiziert über AuthSub und können
       // eine authentifizierte HTTP Client Instanz holen

       // Erstellt einen authentifizierte HTTP Client
       $client = Zend_Gdata_AuthSub::getHttpClient($_SESSION['sessionToken']);
       return $client;
   }

   // -> Skript Bearbeitung beginnt hier <-

   // Sicher stellen das der Benutzer eine gültige Session hat, sodas der
   // AuthSub Session Token gespeichert werden kann sobald er vorhanden ist
   session_start();

   // Erstellt eine Instanz des Kalender Services, und leitet den Benutzer
   // zum AuthSub Server um wenn das notwendig ist.
   $service = new Zend_Gdata_Calendar(getAuthSubHttpClient());

Schlußendlich, kann ein nicht authentifizierter Server erstellt werden um Ihn entweder mit öffentlichen Feeds
oder MagicCookie Authentifizierung zu verwenden:

.. code-block:: php
   :linenos:

   // Erstellt eine Instanz des Kalender Services wobei ein nicht
   // authentifizierter HTTP Client verwendet wird

   $service = new Zend_Gdata_Calendar();

Es ist zu beachten das die MagicCookie Authentifizierung nicht mit der *HTTP* Verbindung unterstützt wird, sonder
stattdessen wärend der gewählten Sichtbarkeit spezifiziert wird, wärend Anfragen abgeschickt werden. Siehe die
folgende Sektion über das Empfangen von Events für ein Beispiel.

.. _zend.gdata.calendar_retrieval:

Eine Kalender Liste empfangen
-----------------------------

Der Kalender Service unterstützt den Empfang einer Liste von Kalendern für den authentifizierten Benutzer. Das
ist die gleiche Liste von Kalendern welche im Google Kalender UI angezeigt werden, ausser das jene die als
"**hidden**" markiert sind, auch vorhanden sind.

Die Kalender Liste ist immer privat und es muß über eine authentifizierte Verbindung darauf zugegriffen werden.
Es ist nicht möglich eine Kalender Liste eines anderen Benutzers zu erhalten und es kann nicht darauf zugegriffen
werden wenn die MagicCookie Authentifizierung verwendet wird. Der Versuch auf eine Kalender Liste zuzugreifen ohne
das die notwendigen Zugriffsrechte vorhanden sind, wird fehlschlagen und in einem 401 (Authentifizierung benötigt)
Statuc Code resultieren.

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Calendar::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Calendar($client);

   try {
       $listFeed= $service->getCalendarListFeed();
   } catch (Zend_Gdata_App_Exception $e) {
       echo "Fehler: " . $e->getMessage();
   }

Der Aufruf von ``getCalendarListFeed()`` erstellt eine neue Instanz von ``Zend_Gdata_Calendar_ListFeed`` die jeden
vorhandenen Kalender als Instanz von ``Zend_Gdata_Calendar_ListEntry`` enthält. Nachdem der Feed empfangen wurde,
können der Iterator und der Accessor die innerhalb des Feeds enthalten sind, verwendet werden um die enthaltenen
Kalender zu inspizieren.

.. code-block:: php
   :linenos:

   echo "<h1>Kalender Feed Liste</h1>";
   echo "<ul>";
   foreach ($listFeed as $calendar) {
       echo "<li>" . $calendar->title .
            " (Event Feed: " . $calendar->id . ")</li>";
   }
   echo "</ul>";

.. _zend.gdata.event_retrieval:

Events erhalten
---------------

Wie die Liste der Kalender können auch die Events empfangen werden durch Verwendung der ``Zend_Gdata_Calendar``
Service Klasse. Die zurückgegebene Event Liste ist vom Typ ``Zend_Gdata_Calendar_EventFeed`` und enthält jedes
Event als Instanz von ``Zend_Gdata_Calendar_EventEntry``. Wie vorher, erlauben die in der Instanz des Event Feeds
enthaltenen Accessoren und der Iterator das individuelle Events inspiziert werden können.

.. _zend.gdata.event_retrieval.queries:

Abfragen
^^^^^^^^

Wenn Events mit der Kalender *API* empfangen werden, werden speziell erstellte Abfrage *URL*\ s verwendet um zu
beschreiben welche Events zurückgegeben werden sollten. Die ``Zend_Gdata_Calendar_EventQuery`` Klasse vereinfacht
diese Aufgabe durch automatische Erstellung einer Abfrage *URL* basierend auf den gegebenen Parametern. Eine
komplette Liste dieser Parameter ist in der `Abfrage Sektion des Google Data API Protokoll Referenz`_ enthalten.
Trotzdem gibt es drei Parameter die es Wert sind speziell genannt zu werden:

- **User** wird verwendet um den Benutzer zu spezifizieren dessen Kalender gesucht wird, und wird als EMail Adresse
  spezifiziert. Wenn kein Benutzer angegeben wurde, wird stattdessen "default" verwendet um den aktuellen
  authentifizierten Benutzer anzuzeigen (wenn er authentifiziert wurde).

- **Visibility** spezifiziert ob der öffentliche oder private Kalender eines Benutzers gesucht werden soll. Wenn
  eine nicht authentifizierte Session verwendet wird und kein MagicCookie vorhanden ist, ist nur der öffentliche
  Feed vorhanden.

- **Projection** spezifiziert wieviele Daten vom Server zurückgegeben werden sollen, und in welchem Format. In den
  meisten Fällen wird man die komplette ("full") Projektion verwenden wollen. Auch die normale ("basic")
  Projektion ist vorhanden, welche die meisten Meta-Daten in jedem Inhaltsfeld der Events als menschlich lesbaren
  Text plaziert, und die kombinierte ("composite") Projketion welche den kompletten text für jedes Kommentar
  entlang jedes Events inkludiert. Die kombinierte ("composite") Ansicht ist oft viel größer als die komplette
  ("full") Ansicht.

.. _zend.gdata.event_retrieval.start_time:

Events in der Reihenfolge Ihres Startzeitpunktes erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Das folgende Beispiel zeigt die Verwendung der ``Zend_Gdata_Query`` Klasse und spezifiziert den privat sichtbaren
Feed, welcher eine vorhandene authentifizierte Verbindung zu den Kalender Servern benötigt. Wenn ein MagicCookie
für die Authentifizierung verwendet wird, sollte die Sichtbarkeit zuerst auf "**private-magicCookieValue**"
gesetzt werden, sobei magicCookieValue der zufälliger String ist, der erhalten wird, wenn man die private *XML*
Adresse im Google Kalender UI betrachtet. Events werden chronologisch anhand des Startzeitpunktes angefragt und nur
Events die in der Zukunft stattfinden werden zurückgegeben.

.. code-block:: php
   :linenos:

   $query = $service->newEventQuery();
   $query->setUser('default');
   // Setze $query->setVisibility('private-magicCookieValue') wenn
   // MagicCookie Authentifizierung verwendet wird
   $query->setVisibility('private');
   $query->setProjection('full');
   $query->setOrderby('starttime');
   $query->setFutureevents('true');

   // Empfängt die Event Liste vom Kalender Server
   try {
       $eventFeed = $service->getCalendarEventFeed($query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "Fehler: " . $e->getMessage();
   }

   // Iteriere durch die Liste der Events und gib Sie als HTML Liste aus
   echo "<ul>";
   foreach ($eventFeed as $event) {
       echo "<li>" . $event->title . " (Event ID: " . $event->id . ")</li>";
   }
   echo "</ul>";

Zusätzliche Eigenschaften wie ID, Autor, Wann, Event Status, Sichtbarkeit, Web Inhalt, und Inhalt, sowie andere
sind innerhalb von ``Zend_Gdata_Calendar_EventEntry`` vorhanden. Siehe die `Zend Framework API Dokumentation`_ und
die `Lalender Protokol Referenz`_ für eine komplette Liste.

.. _zend.gdata.event_retrieval.date_range:

Events in einem speziellen Datumsbereich empfangen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um alle Events in einem gewünschten Bereich auszugeben, zum Beispiel vom 1. Dezember 2006 bis zum 15. Dezember
2006, müssen die folgenden zwei Zeilen im vorhergehenden Beispiel hinzugefügt werden. Es ist zu beachten das
"``$query->setFutureevents('true')``" entfernt werden muß, da ``futureevents`` die Werte von ``startMin`` und
``startMax`` überschreibt.

.. code-block:: php
   :linenos:

   $query->setStartMin('2006-12-01');
   $query->setStartMax('2006-12-16');

Es ist zu beachten das ``startMin`` inklusive ist, wobei ``startMax`` exklusive ist. Als Ergebnis, werden nur die
Events bis 2006-12-15 23:59:59 zurückgegeben.

.. _zend.gdata.event_retrieval.fulltext:

Events durch eine Volltext Abfrage erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um alle Events auszugeben welche ein spezielles Wort, zum Beispiel "Hundefutter" enthalten, muß die ``setQuery()``
Methode verwendet werden wenn die Abfrage erstellt wird.

.. code-block:: php
   :linenos:

   $query->setQuery("Hundefutter");

.. _zend.gdata.event_retrieval.individual:

Individuelle Events erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Individuelle Events können empfangen werden indem deren Event ID als Teil der Abfrage spezifiziert wird. Statt
``getCalendarEventFeed()`` auszurufen, sollte ``getCalendarEventEntry()`` aufgerufen werden.

.. code-block:: php
   :linenos:

   $query = $service->newEventQuery();
   $query->setUser('default');
   $query->setVisibility('private');
   $query->setProjection('full');
   $query->setEvent($eventId);

   try {
       $event = $service->getCalendarEventEntry($query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "Fehler: " . $e->getMessage();
   }

In einer ähnlichen Weise kann Sie, wenn die Event *URL* bekannt ist, direkt an ``getCalendarEntry()`` übergeben
werden um ein spezielles Event zu erhalten. In diesem Fall wird kein Abfrage Objekt benötigt da die Event *URL*
alle notwendigen Informationen enthält um das Event zu erhalten.

.. code-block:: php
   :linenos:

   $eventURL = "http://www.google.com/calendar/feeds/default/private"
             . "/full/g829on5sq4ag12se91d10uumko";

   try {
       $event = $service->getCalendarEventEntry($eventURL);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "Fehler: " . $e->getMessage();
   }

.. _zend.gdata.calendar.creating_events:

Events erstellen
----------------

.. _zend.gdata.calendar.creating_events.single:

Ein einmal vorkommendes Event erstellen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Events werden einem Kalender hinzugefügt indem eine Instanz von ``Zend_Gdata_EventEntry`` erstellt wird, und diese
mit den richtigen Daten bekanntgegeben wird. Die Kalender Service Instanz (``Zend_Gdata_Calendar``) wird dann
verwendet um das Event transparent in *XML* zu konvertieren und diese an den Kalender Server zu senden.

Mindestens die folgenden Attribute sollten gesetzt werden:

- **Title** enthält die Kopfzeile die über jedem Event innerhalb der Google Kalender UI angezeigt wird.

- **When** zeigt die Dauer des Events und, optional, jede Erinnerung die mit Ihm assoziiert ist. Siehe in die
  nächste Sektion für mehr Informationen über dieses Attribut.

Andere nützliche Attribute die optional gesetzt werden können sind unter anderem:

- **Author** liefert Informationen über den Benutzer der das Event erstellt hat.

- **Content** liefert zusätzliche Information über das Event und wird angezeigt wenn die Event Details innerhalb
  des Google Kalenders angefragt werden.

- **EventStatus** zeigt an ob ein Event bestätigt, in Wartestellung oder abgebrochen wurde.

- **Hidden** entfernt das Event von der Google Kalender UI.

- **Transparency** zeigt ob das Event Zeit auf der Frei/Belegt Liste des Benutzers benötigt.

- **WebContent** erlaubt es externe Inhalte zu verlinken und innerhalb eines Events anzubieten.

- **Where** indiziert den Ort des Events.

- **Visibility** erlaubt es das Event vor der öffentlichen Event Liste zu verstecken.

Für eine komplette Liste an Event Attributen, kann in die `Zend Framework API Documentation`_ und die `Kalender
Protokol Referenz`_ gesehen werden. Attribute die mehrfache Werte enthalten können, wo wie "where", sind als
Arrays implementiert und müssen korrekt erstellt werden. Es ist zu beachten das alle diese Attribute Objekte als
Parameter benötigen. Der Versuch diese stattdessen als Strings oder Primitivvariablen bekanntzugeben wird in einem
Fehler wärend der Konvertierung in *XML* führen.

Sobald das Event bekanntgegeben wurde, kann es zum Kalender Server hochgeladen werden durch seine Übergabe als
Argument zur ``insertEvent()`` Funktion des Kalender Services.

.. code-block:: php
   :linenos:

   // Erstellt einen neuen Eintrag und verwendet die magische Factory
   // Methode vom Kalender Service
   $event= $service->newEventEntry();

   // Gibt das Event bekannt mit den gewünschten Informationen
   // Beachte das jedes Attribu als Instanz der zugehörenden Klasse erstellt wird
   $event->title = $service->newTitle("Mein Event");
   $event->where = array($service->newWhere("Berg Ansicht, Kalifornien"));
   $event->content =
       $service->newContent(" Das ist mein super Event. RSVP benötigt.");

   // Setze das Datum und verwende das RFC 3339 Format.
   $startDate = "2008-01-20";
   $startTime = "14:00";
   $endDate = "2008-01-20";
   $endTime = "16:00";
   $tzOffset = "-08";

   $when = $service->newWhen();
   $when->startTime = "{$startDate}T{$startTime}:00.000{$tzOffset}:00";
   $when->endTime = "{$endDate}T{$endTime}:00.000{$tzOffset}:00";
   $event->when = array($when);

   // Das Event an den Kalender Server hochladen
   // Eine Kopie des Events wird zurückgegeben wenn es am Server gespeichert wird
   $newEvent = $service->insertEvent($event);

.. _zend.gdata.calendar.creating_events.schedulers_reminders:

Event Planungen und Erinnerungen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Startzeit und Dauer eines Events werden durch die Werte seiner ``when`` Eigenschaften, ``startTime``,
``endTime``, und ``valueString`` ermittelt. **StartTime** und **EndTime** kontrollieren die Dauer des Events,
wärend die ``valueString`` Eigenschaft aktuell nicht verwendet wird.

Jeden Tag wiederkehrende Events können geplant werden indem nur das Datum spezifiziert und die Zeit ausgelassen
wird wenn ``startTime`` und ``endTime`` gesetzt werden. Genauso können Events die keine Dauer haben spezifiziert
werden indem ``endTime`` unterdrückt wird. In allen Fällen sollten Datums und Zeitwerte im `RFC3339`_ Format
angegeben werden.

.. code-block:: php
   :linenos:

   // Plane ein Event das am 05. Dezember 2007 um 14h PST stattfindet
   // (UTC-8) mit der Dauer einer Stunde.
   $when = $service->newWhen();
   $when->startTime = "2007-12-05T14:00:00-08:00";
   $when->endTime="2007-12-05T15:00:00:00-08:00";

   // Die "when" Eigenschaft an das Event binden
   $event->when = array($when);

Das ``when`` Attribut kontrolliert auch wann Erinnerungen an einen Benutzer gesendet werden. Erinnerungen werden in
einem Array gespeichert und jedes Event kann abgefragt werden um die Erinnerungen herauszufinden die mit Ihm
verbunden sind.

Damit ein **reminder** gültig ist, muß er zwei Attribute gesetzt haben: ``method`` und eine Zeit. **Method**
akzeptiert einen der folgenden Strings: "alert", "email" oder "sms". Die Zeit sollte als Integer eingegeben werden
und kann mit den Eigenschaften ``minutes``, ``hours``, ``days`` oder ``absoluteTime`` gesetzt werden. Trotzdem darf
eine gültige Anfrage nur eines dieser Attribute gesetzt haben. Wenn eine gemischte Zeit gewünscht wird, muß der
Wert in die am besten passende und vorhandene Einheit konvertiert werden. Zum Beispiel, 1 Stunde und 30 Minuten
sollten als 90 Minuten angegeben werden.

.. code-block:: php
   :linenos:

   // Erstellt ein Erinnerungs Objekt. Es sollte eine Email an den Benutzer
   // senden, 10 Minuten vor dem Event.
   $reminder = $service->newReminder();
   $reminder->method = "email";
   $reminder->minutes = "10";

   // Die Erinnerung einem existierenden Event als "when" Eigenschaft hinzufügen
   $when = $event->when[0];
   $when->reminders = array($reminder);

.. _zend.gdata.calendar.creating_events.recurring:

Wiederkehrende Events erstellen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wiederkehrende Events werden auf dem gleichen Weg erstellt wie einmal stattfindende Events, ausser das ein
Wiederholungs "recurrence" Attribut statt dem "where" Attribut angegeben werden muß. Das Wiederholungs Attribut
sollte einen String enthalten der das Wiederholungs Pattern des Events beschreibt und das mit Eigenschaften
definiert werden kann die im iCalender Standard (`RFC 2445`_) beschrieben sind.

Ausnahmen im Wiederholungs Pattern werden normalerweise durch ein ausgeprägtes ``recurrenceException`` Attribut
spezifiziert. Trotzdem bietet der iCalender Standard ein zweites Format für die Definition von Wiederholungen, und
die Möglichkeit das jedes von Ihnen verwendet werden kann und für jedes davon muß das gehandhabt werden.

Durch die Komplexität des analysierens des Wiederholungs Patterns, sind weitere Informationen hierüber ausserhalb
des Umfangs dieses Dokuments. Trotzdem können weitere Informationen im `Kapitel über normale Elemente des Google
Data API Entwickler Leitfadens`_ gefunden werden, sowie in der *RFC* 2445.

.. code-block:: php
   :linenos:

   // Erstelle einen neuen Eintrag und verwendet die magische
   // Factory Methode des Kalender Services
   $event= $service->newEventEntry();

   // Gibt das Event mit den gewünschten Informationen bekannt
   // Es ist zu beachten das jedes Attribut als Instanz
   // der betreffenden Klasse erstellt wird
   $event->title = $service->newTitle("Mein wiederkehrendes Event");
   $event->where = array($service->newWhere("Palo Alto, Kalifornien"));
   $event->content =
       $service->newContent('Das ist mein anderes super Event, ' .
                            'das jeden Dienstag von 01.05.2007 bis ' .
                            '04.09.2007 stattfinden. Kein RSVP benötigt.");

   // Setzt Dauer und Frequenz durch Spezifizierung des Wiederholungs Patterns

   $recurrence = "DTSTART;VALUE=DATE:20070501\r\n" .
           "DTEND;VALUE=DATE:20070502\r\n" .
           "RRULE:FREQ=WEEKLY;BYDAY=Tu;UNTIL=20070904\r\n";

   $event->recurrence = $service->newRecurrence($recurrence);

   // Das Event zum Kalender Server hochladen
   // Eine Kopie des Events wird zurückgegeben,
   // wenn es auf dem Server gespeichert wird
   $newEvent = $service->insertEvent($event);

.. _zend.gdata.calendar.creating_events.quickadd:

QuickAdd verwenden
^^^^^^^^^^^^^^^^^^

QuickAdd ist ein Feature das es erlaubt Events zu erstellen indem ein frei definierter Texteintrag verwendet wird.
Zum Beispie lwürde der String "Abendessen bei Joe's Dinner am Dienstag" ein Event erstellen mit dem Titel
"Abendessen", dem Ort "Joe's Dinner", und dem Datum "Dienstag". Um die Vorteile von QuickAdd zu verwenden, muß
eine neue ``QuickAdd`` Eigenschaft erstellt, auf ``TRUE`` gesetzt und der frei definierbare Text als ``content``
Eigenschaft gespeichert werden.

.. code-block:: php
   :linenos:

    // Erstelle einen neuen Eintrag und verwendet die magische
    // Factory Methode des Kalender Services
   $event= $service->newEventEntry();

   // Gibt das Event mit den gewünschten Informationen bekannt
   $event->content= $service->newContent("Dinner at Joe's Diner on Thursday");
   $event->quickAdd = $service->newQuickAdd("true");

   // Das Event zum Kalender Server hochladen
   // Eine Kopie des Events wird zurückgegeben,
   // wenn es auf dem Server gespeichert wird
   $newEvent = $service->insertEvent($event);

.. _zend.gdata.calendar.modifying_events:

Events bearbeiten
-----------------

Sobald eine Instanz eines Events erstellt wurde, können die Attribute des Events lokal auf dem selben Weg wie bei
der Erstellung des Events geänder werden. Sobald alle Änderungen komplett sind, schickt der Aufruf der ``save()``
Methode des Events die Änderungen an den Kalender Server und gibt eine Kopie des Events zurück wie es auf dem
Server erstellt wurde.

Im Fall das ein anderer Benutzer das Event modifiziert hat seitdem die lokale Kopie empfangen wurde, wird die
``save()`` Methode fehlschlagen und einen 409 (Konflikt) Status Code zurück geben. Um das zu beheben muß eine
neue Kopie des Events vom Server empfangen werden bevor ein erneuter Versuch stattfindet die Änderungen wieder zu
speichern.

.. code-block:: php
   :linenos:

   // Das erste Event auf der Liste der Events eines Benutzers erhalten
   $event = $eventFeed[0];

   // Den Titel zu einem neuen Wert ändern
   $event->title = $service->newTitle("Wuff!");

   // Die Änderungen an den Server hochladen
   try {
       $event->save();
   } catch (Zend_Gdata_App_Exception $e) {
       echo "Fehler: " . $e->getMessage();
   }

.. _zend.gdata.calendar.deleting_events:

Events löschen
--------------

Kalender Events können entweder durch den Aufruf der ``delete()`` Methode des Kalender Services, und des Angebens
der Bearbeitungs *URL* des Events durchgeführt werden, oder durch Aufruf der eigenen ``delete()`` Methode des
Events.

In jedem Fall, wird das gelöschte Event trotzdem noch am Privaten Event Feed des Benutzers aufscheinen wenn ein
``updateMin`` Abfrage Parameter angegeben wurde. Gelöschte Events können von normalen Events unterschieden werden
weil Sie Ihre eigene ``eventStatus`` Eigenschaft auf "http://schemas.google.com/g/2005#event.canceled" gesetzt
haben.

.. code-block:: php
   :linenos:

   // Option 1: Events können direkt gelöscht werden
   $event->delete();

.. code-block:: php
   :linenos:

   // Option 2: Events können gelöscht werden indem die Bearbeitungs URL
   // des Events zu diesem Kalender Service angegeben wird, wenn diese
   // bekannt ist
   $service->delete($event->getEditLink()->href);

.. _zend.gdata.calendar.comments:

Auf Event Kommentare zugreifen
------------------------------

Den die komplette Event Ansicht verwendet wird, werden Kommentare nicht direkt innerhalb eines Events gespeichert.
Stattdessen enthält jedes Event eine *URL* zum dazugehörigen Kommentar Feed welcher manuell angefragt werden
muß.

Das Arbeiten mit Kommentaren ist fundamental ähnlich zum Arbeiten mit Events, mit dem einzigen signifikanten
Unterschied das eine andere Feed und Event Klasse verwendet werden sollte, und das die zusätzlichen Meta-Daten
für Events wie zum Beispiel "where" und "when" für Kommentare nicht existieren. Speziell wird der Author des
Kommentars in der ``author`` Eigenschaft und der Kommentar Text in der ``content`` Eigenschaft gespeichert.

.. code-block:: php
   :linenos:

   // Die normale URL vom ersten Event der Feed Liste des Benutzers extrahieren
   $event = $eventFeed[0];
   $commentUrl = $event->comments->feedLink->url;

   // Die Kommentarliste für das Event erhalten
   try {
   $commentFeed = $service->getFeed($commentUrl);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "Fehler: " . $e->getMessage();
   }

   // Jedes Kommentar als HTML Liste ausgeben
   echo "<ul>";
   foreach ($commentFeed as $comment) {
       echo "<li><em>Kommentar von: " . $comment->author->name "</em><br/>" .
            $comment->content . "</li>";
   }
   echo "</ul>";



.. _`http://code.google.com/apis/calendar/overview.html`: http://code.google.com/apis/calendar/overview.html
.. _`Authentifizierungs Übersicht im Google Data API Entwickler Guide`: http://code.google.com/apis/gdata/auth.html
.. _`Abfrage Sektion des Google Data API Protokoll Referenz`: http://code.google.com/apis/gdata/reference.html#Queries
.. _`Zend Framework API Dokumentation`: http://framework.zend.com/apidoc/core/
.. _`Lalender Protokol Referenz`: http://code.google.com/apis/gdata/reference.html
.. _`Zend Framework API Documentation`: http://framework.zend.com/apidoc/core/
.. _`Kalender Protokol Referenz`: http://code.google.com/apis/gdata/reference.html
.. _`RFC3339`: http://www.ietf.org/rfc/rfc3339.txt
.. _`RFC 2445`: http://www.ietf.org/rfc/rfc2445.txt
.. _`Kapitel über normale Elemente des Google Data API Entwickler Leitfadens`: http://code.google.com/apis/gdata/elements.html#gdRecurrence
