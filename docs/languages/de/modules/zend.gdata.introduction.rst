.. EN-Revision: none
.. _zend.gdata.introduction:

Einführung
==========

Die *API*\ s von Google Data bieten ein programmtechnisches Interface zu einigen von Google's Online Services. Das
Google Data Protokoll basiert auf dem `Atom Publishing Protokoll`_ und erlaubt Client Anwendungen das Empfangen von
passenden Anfragen zu Daten, senden von Daten, modifizieren von Daten und löschen von Daten wobei Standard *HTTP*
und das Atom Syndication Format verwendet wird. Die ``Zend_Gdata`` Komponente ist ein *PHP* 5 Interface für den
Zugriff auf Daten von Google von *PHP* aus. Die ``Zend_Gdata`` Komponente unterstützt auch den Zugriff auf andere
Services die das Atom Publishing Protokoll implementieren.

Siehe `http://code.google.com/apis/gdata/`_ für mehr Informationen über die Google Data *API*.

Die Services auf die durch ``Zend_Gdata`` zugegriffen werden kann beinhalten unter anderem:



   - :ref:`Google Kalender <zend.gdata.calendar>` ist eine populäre online Kalender Anwendung.

   - :ref:`Google Tabellenkalkulation <zend.gdata.spreadsheets>` bietet ein gemeinschaftliches online
     Tabellenkalkulations Tool welches als einfacher Datenspeicher für eigene Anwendungen verwendet werden kann.

   - :ref:`Google Dokumenten Liste <zend.gdata.docs>` bietet eine online Liste von allen Tabellenkalkulationen,
     Wortbearbeitungs Dokumenten, und Präsentationen die in einem Google Account gespeichert sind.

   - :ref:`Google Versorgung <zend.gdata.gapps>` bietet die Möglichkeit Benutzerdaten, Spitznamen, Gruppen und
     Emaillisten auf einer Google Apps gehosten Domain zu erstellen, erhalten, aktualisieren und zu löschen.

   - :ref:`YouTube <zend.gdata.youtube>` bietet die Möglichkeit Videos, Kommentare, Favoriten, Einschreibungen,
     Benutzerprofile und vieles mehr zu Suchen und zu Empfangen.

   - :ref:`Picasa Web Album <zend.gdata.photos>` bietet eine online Photo Sharing Anwendung.

   - `Google Blogger`_ ist ein populärer Internet Provider von "push-button Veröffentlichung" und Verbreitung.

   - Google CodeSearch erlaubt das Suchen von öffentlichem Source Code für viele Projekte.

   - Google Notebook erlaubt das sehen von veröffentlichten Notebook Inhalten.



.. note::

   **Nicht unterstützte Services**

   ``Zend_Gdata`` bietet kein Interface zu irgendwelchen anderen Google Services wie Search, Gmail, Translation
   oder Maps. Nur Services die das Google Data *API* unterstützen werden unterstützt.

.. _zend.gdata.introduction.structure:

Struktur von Zend_Gdata
-----------------------

``Zend_Gata`` besteht aus verschiedenen Typen von Klassen:



   - Service Klassen - abgeleitet von ``Zend_Gdata_App``. Diese beinhalten auch andere Klassen wie ``Zend_Gdata``,
     ``Zend_Gdata_Spreadsheeps``, usw. Diese Klassen erlauben die Interaktion mit APP oder GData Services und
     bieten die Möglichkeit Feeds und Einträge zu empfangen, Einträge zu senden, zu aktualisieren und zu
     löschen.

   - Abfrage Klassen - abgeleitet von ``Zend_Gdata_Query``. Diese beinhalten auch andere Klassen für spezielle
     Services, wie ``Zend_Gdata_Spreadsheet_ListQuery`` und ``Zend_Gdata_Spreadsheets_CellQuery``. Abfrage Klassen
     bieten Methoden die verwendet werden können um Abfragen für Daten zu erstellen die von GData Services
     empfangen werden. Die Methoden inkludieren Getter und Setter wie ``setUpdatedMin()``, ``setStartIndex()``, und
     ``getPublishedMin()``. Die Abfrage Klassen haben auch eine Methode um eine *URL* zu erhalten welche die
     erstellte Abfrage repräsentieren. --``getQueryUrl()``. Alternativ kann man die Abfrage String Komponente der
     *URL* erhalten indem die ``getQueryString()`` Methode verwendet wird.

   - Feed Klassen - abgeleitet von ``Zend_Gdata_App_Feed``. Diese beinhalten auch andere Klassen wie
     ``Zend_Gdata_Feed``, ``Zend_Gdata_Spreadsheets_SpreadsheetFeed``, und ``Zend_Gdata_Spreadsheets_ListFeed``.
     Diese Klassen repräsentieren Feeds von Einträgen die von Services empfangen wurden. Sie werden primär
     verwendet um Daten die von Services zurückgegeben werden zu erhalten.

   - Eingabe Klassen - abgeleitet von ``Zend_Gdata_App_Entry``. Diese beinhalten auch andere Klassen wie
     ``Zend_Gdata_Entry``, und ``Zend_Gdata_Spreadsheets_ListEntry``. Diese Klassen repräsentieren Einträge die
     von Services empfangen oder für die Erstellung von Daten, die an Services geschickt werden, verwendet werden.
     Zusätzlich zur Möglichkeit die Eigenschaften eines Eintrages (wie den Zellen Wert der Tabellenkalkulation)
     zu setzen, kann das Objekt des Eintrages verwendet werden um Aktualisierungs- oder Löschanfragen an ein
     Service zu senden. Zum Beispiel kann ``$entry->save()`` aufgerufen werden um Änderungen die an einem Eintrage
     durchgeführt wurden zu einem Service zurück zu Speichern von welche der Eintrag initiiert wurde, oder
     ``$entry->delete()`` um einen Eintrag von einem Server zu Löschen.

   - Andere Daten Modell Klassen - abgeleitet von ``Zend_Gdata_App_Extension``. Diese beinhalten Klassen wie
     ``Zend_Gdata_App_Extension_Title`` (repräsentiert das atom:title *XML* Element),
     ``Zend_Gdata_Extension_When`` (repräsentiert das gd:when *XML* Element das von dem GData Event "Kind"
     verwendet wird), und ``Zend_Gdata_Extension_Cell`` (repräsentiert das gs:cell *XML* Element das von Google
     Tabellenkalkulation verwendet wird). Diese Klassen werden pur verwendet um von den Server zurückgegebene
     Daten zu speichern und für die Erstellung von Daten die an Services gesendet werden. Diese beinhalten Getter
     und Setter wie ``setText()`` um den Kindtext Node eines Elements zu setzen, ``getText()`` um den Text Node
     eines Elements zu erhalten, ``getStartTime()`` um das Startzeit Attribut eines When Elements oder anderen
     ähnlichen Methoden zu empfangen. Die Daten Modell Klassen beinhalten auch Methoden wie ``getDOM()`` um eine
     DOM Repräsentation des Elements und aller Kinder zu erhalten, und ``transferFromDOM()`` um eine Daten Modell
     Repräsentation des DOM Baumes zu erstellen.



.. _zend.gdata.introduction.services:

Mit Google Services interagieren
--------------------------------

Google Daten Services basieren auf dem Atom Publishing Protokoll (APP) und dem Atom Syndication Format. Um mit APP
oder den Google Services zu interagieren indem ``Zend_Gdata`` verwendet wird, müssen Service Klassen wie
``Zend_Gdata_App``, ``Zend_Gdata``, ``Zend_Gdata_Spreadsheets``, usw. verwendet werden. Diese Service Klassen
bieten Methoden um Daten von Services als Feeds zu empfangen, neue Einträge in Feeds einzufügen, Einträge zu
aktuslieieren und Einträge zu löschen.

Achtung: Ein komplettes Beispiel davon wie mit ``Zend_Gdata`` gearbeitet werden kann ist im ``demos/Zend/Gdata``
Verzeichnis vorhanden. Dieses Beispiel läuft von der Kommandozeile aus, aber die enthaltenen Methoden sind einfach
in einem Web Anwendung zu portieren.

.. _zend.gdata.introduction.magicfactory:

Instanzen von Zend_Gdata Klassen erhalten
-----------------------------------------

Der Zend Framework Namensstandard erzwingt das alle Klassen nach der Verzeichnis Struktur benannt werden in welcher
sie vorhanden sind. Zum Beispiel eine Erweiterung die zu Tabellenkalkulation gehört und in
``Zend/Gdata/Spreadsheets/Extension/...`` gespeichert ist, muß als Ergebnis
``Zend_Gdata_Spreadsheets_Extension_...`` benannt werden. Das verursacht eine Menge an Tipparbeit wenn versucht
wird eine neue Instanz eines Zellen Elements zu erstellen!

Wir haben eine magische Fabriksmethode in alle Service Klassen (wie ``Zend_Gdata_App``, ``Zend_Gdata``,
``Zend_Gdata_Spreadsheets``) implementiert welche die Erstellung neuer Instanzen von Daten Modellen, Abfragen und
anderen Klassen viel einfacher macht. Diese magische Fabriksmethode ist durch die Verwendung der magischen
``__call()`` Methode implementiert um auf alle Versuche ``$service->newXXX(arg1, arg2, ...)`` aufzurufen,
angewendet zu werden. Basieren auf dem Wert von XXX, wird eine Suche in allen registrierten 'Paketen', für die
gewünschte Klasse, durchgeführt. Hier sind einige Beispiele:

.. code-block:: php
   :linenos:

   $ss = new Zend_Gdata_Spreadsheets();

   // Erstellt ein Zend_Gdata_App_Spreadsheets_CellEntry
   $entry = $ss->newCellEntry();

   // Erstellt ein Zend_Gdata_App_Spreadsheets_Extension_Cell
   $cell = $ss->newCell();
   $cell->setText('Mein Zellenwert');
   $cell->setRow('1');
   $cell->setColumn('3');
   $entry->cell = $cell;

   // ... $entry kann dann verwendet werden um eine Aktualisierung
   // an eine Google Tabellenkalkulation zu senden

Jede Service Klasse im abgeleiteten Baum ist dafür verantwortlich das die richtigen 'Pakete' (Verzeichnisse)
registriert werden, in welchen dann durch den Aufruf der matischen Fabriksmethode, gesucht wird.

.. _zend.gdata.introduction.authentication:

Google Data Client Authentifizierung
------------------------------------

Die meisten Google Daten Services erfordern das sich die Client Anwendung auf dem Google Server authentifiziert
bevor auf private Daten zugegriffen, oder Daten gespeichert oder gelöscht werden können. Es gibt zwei
Implementationen der Authentifizierung für Google Daten: :ref:`AuthSub <zend.gdata.authsub>` und :ref:`ClientLogin
<zend.gdata.clientlogin>`. ``Zend_Gdata`` bietet Klassen Interfaces für beide dieser Methoden.

Die meisten anderen Typen von Abfragen auf Google Daten Servicen benötigen keine Authentifizierung.

.. _zend.gdata.introduction.dependencies:

Abhängigkeiten
--------------

``Zend_Gdata`` verwendet :ref:`Zend_Http_Client <zend.http.client>` um Anfragen an google.com zu senden und
Ergebnisse zu erhalten. Die Antworter der meisten Google Data Anfragen werden als Subklasse von
``Zend_Gdata_App_Feed`` oder ``Zend_Gdata_App_Entry`` Klassen zurückgegeben.

``Zend_Gdata`` nimmt an das die *PHP* Anwendung auf einem Host läuft der eine direkte Verbindung zum Internet hat.
Der ``Zend_Gdata`` Client arbeitet indem er zu Google Daten Servern Kontakt aufnimmt.

.. _zend.gdata.introduction.creation:

Erstellen eines neuen Gdata Klienten
------------------------------------

Man muß ein neues Objekt der Klasse ``Zend_Gdata_App``, ``Zend_Gdata``, oder einer dessen Subklassen erstellen die
Helfer Methoden für servicespezifische Verhaltensweisen anbieten.

Der einzige optionale Parameter für den Konstruktor von ``Zend_Gdata_App`` ist eine Instanz von
:ref:`Zend_Http_Client <zend.http.client>`. Wenn dieser Parameter nicht übergeben wird, erstellt ``Zend_Gdata``
ein standardmäßiges ``Zend_Http_Client`` Objekt, welches keine Zugangsdaten zugeordnet hat um auf private Feeds
zugreifen zu können. Die Spezifizierung des ``Zend_Http_Client`` Objektes erlaubt es auch Konfigurationsoptionen
an das Client Objekt zu übergeben.

.. code-block:: php
   :linenos:

   $client = new Zend_Http_Client();
   $client->setConfig( ...options... );

   $gdata = new Zend_Gdata($client);

Beginnend mit Zend Framework 1.7, wurde die Unterstützung für die Versionierung des Protkolls hinzugefügt. Das
erlaut dem Client und Server neue Fesatures zu unterstützen, wärend die Rückwärts Kompatibilität gewahrt
bleibt. Wärend die meisten Services das für dich selbst durchführen, wenn man eine ``Zend_Gdata`` Instanz direkt
erstellt (als Gegensatz zu einer Ihrer Unterklassen), kann es sein das man die gewünschte Version des Protokolls
spezifizieren will um auf spezielle Serverfunktionalitäten zugreifen zu können.

.. code-block:: php
   :linenos:

   $client = new Zend_Http_Client();
   $client->setConfig( ...options... );

   $gdata = new Zend_Gdata($client);
   $gdata->setMajorProtocolVersion(2);
   $gdata->setMinorProtocolVersion(null);

Siehe auch die Sektion über Authentifizierung für Methoden, um ein authentifiziertes ``Zend_Http_Client`` Objekt
zu erstellen.

.. _zend.gdata.introduction.parameters:

Übliche Abfrage Parameter
-------------------------

Es können Parameter spezifiziert werden um Abfragen mit ``Zend_Gdata`` anzupassen. Abfrageparameter werden
spezifiziert indem Subklassen von ``Zend_Gdata_Query`` verwendet werden. Die ``Zend_Gdata_Query`` Klasse beinhaltet
Methoden um alle Abfrageparameter zu setzen die von Gdata Services verwendet werden. Individuelle Services, wie
Tabellenkalkulationen, bieten auch Abfrageklassen zu definierten Parametern welche an das spezielle Service und die
Feeds angepasst sind. Tabellenkalkulationen beinhalten eine CellQuery Klasse um den Zellen Feed abzufragen und eine
ListQuery Klasse um den Listen Feed abzufragen, da verschiedene Abfrageparameter für jeder dieser Feedtypen
möglich sind. Die GData-weiten Parameter werden anbei beschrieben.

- Der ``q`` Parameter spezifiziert eine komplette Textabfrage. Der Wert dieses Parameters ist ein String.

  Dieser Parameter kann mit der ``setQuery()`` Methode gesetzt werden.

- Der ``alt`` Parameter spezifiziert den Feed Typ. Der Wert dieses Parameters kann ``atom``, ``rss``, ``json``,
  oder ``json-in-script`` sein. Wenn dieser Parameter nicht spezifiziert wird, ist der Standard Feedtyp ``atom``.
  ``Zend_Http_Client`` könnte verwendet werden um Feeds in anderen Formaten zu empfangen, indem die von der
  ``Zend_Gdata_Query`` Klasse oder deren Subklassen erzeugten Abfrage *URL*\ s verwendet werden.

  Dieser Parameter kann mit der ``setAlt()`` Methode gesetzt werden.

- Der ``maxResults`` Parameter begrenzt die Anzahl an Einträgen im Feed. Der Wert dieses Parameters ist ein
  Integer. Die zurückgegebene Anzahl an Einträgen im Feed wird diesen Wert nicht überschreiten.

  Dieser Parameter kann mit der ``setMaxResults()`` Methode gesetzt werden.

- Der ``startIndex`` Parameter spezifiziert die ordinale Nummer des ersten Eintrags der im Feed zurückgegeben
  wird. Einträge vor dieser Nummer werden übergangen.

  Dieser Parameter kann mit der ``setStartIndex()`` Methode gesetzt werden.

- Die Parameter ``updatedMin`` und ``updatedMax`` spezifizieren Grenzen für das Datum der Einträge. Wenn ein Wert
  für ``updatedMin`` spezifiziert wird, werden keine Einträge die vor dem spezifizierten Datum aktualisiert
  wurden, im Feed inkludiert. Genauso werden keine Einträge inkludiert die nach einem Datum aktualisiert wurden
  wenn ``updatedMax`` spezifiziert wird.

  Es können nummerische Zeitstempel, oder eine Variation von Datum/Zeit String Repräsentationen als Wert für
  diese Parameter verwendet werden.

  Diese Parameter kkönnen mit den ``setUpdatedMin()`` und ``setUpdatedMax()`` Methoden gesetzt werden.

Es gibt eine ``get*()`` Funktion für jede ``set*()`` Funktion.

.. code-block:: php
   :linenos:

   $query = new Zend_Gdata_Query();
   $query->setMaxResults(10);
   echo $query->getMaxResults();   // gibt 10 zurück

Die ``Zend_Gdata`` Klasse implementiert auch "magische" Getter und Setter Methoden, es kann also der Name des
Parameters als virtuelles Mitglied der Klasse verwendet werden.

.. code-block:: php
   :linenos:

   $query = new Zend_Gdata_Query();
   $query->maxResults = 10;
   echo $query->maxResults;        // gibt 10 zurück

Es können alle Parameter mit der ``resetParameters()`` Funktion gelöscht werden. Das ist nützlich wenn ein
``Zend_Gdata`` Objekt für mehrfache Abfragen wiederverwendet werden soll.

.. code-block:: php
   :linenos:

   $query = new Zend_Gdata_Query();
   $query->maxResults = 10;
   // ...den Feed empfangen...

   $query->resetParameters();      // löscht alle Parameter
   // ...einen anderen Feed empfangen...

.. _zend.gdata.introduction.getfeed:

Einen Feed empfangen
--------------------

Die ``getFeed()`` Funktion kann verwendet werden um einen Feed von einer spezifizierten *URI* zu empfangen. Diese
Funktion gibt eine Instanz der Klasse, die als zweites Argument an getFeed übergeben wurde, zurück, welche
standardmäßig Zend_Gdata_Feed ist.

.. code-block:: php
   :linenos:

   $gdata = new Zend_Gdata();
   $query = new Zend_Gdata_Query(
           'http://www.blogger.com/feeds/blogID/posts/default');
   $query->setMaxResults(10);
   $feed = $gdata->getFeed($query);

Siehe spätere Sektionen für spezielle Funktionen in jeder Helfer Klasse für Google Daten Services. Diese
Funktionen helfen Feeds von einer *URI* zu empfangen die für das angeforderte Service zuständig ist.

.. _zend.gdata.introduction.paging:

Mit Mehrfach-Seiten Feeds arbeiten
----------------------------------

Wenn man einen Feed empfängt der eine große Anzahl an Einträgen enthält, kann dieser Feed in viele kleinere
"Seiten" von Feeds gebrochen werden. Wenn das passiert, enthält jede Seite einen Link zur nächsten Seite der
Serie. Auf diesen Link kann mit Hilfe von ``getLink('next')`` zugegriffen werden. Das folgende Beispiel zeigt wie
auf die nächste Seite eines Feeds empfangen werden kann:

.. code-block:: php
   :linenos:

   function getNextPage($feed) {
       $nextURL = $feed->getLink('next');
       if ($nextURL !== null) {
           return $gdata->getFeed($nextURL);
       } else {
           return null;
       }
   }

Wenn man es vorzieht nicht mit Seiten in der eigenen Anwendung zu arbeiten, kann die erste Seite des Feeds an
``Zend_Gdata_App::retrieveAllEntriesForFeed()`` übergeben werden, welche alle Einträge von jeder Seite in einen
einzelnen Feed zusammenfasst. Dieses Beispiel zeigt wie diese Funktion verwendet werden kann:

.. code-block:: php
   :linenos:

   $gdata = new Zend_Gdata();
   $query = new Zend_Gdata_Query(
           'http://www.blogger.com/feeds/blogID/posts/default');
   $feed = $gdata->retrieveAllEntriesForFeed($gdata->getFeed($query));

Es gilt zu beachten das wenn diese Funktion aufgerufen wird, dies eine sehr lange Zeit benötigen kann im große
Feeds zu komplettieren. Es kann notwendig sein *PHP*'s Limit der Ausführungszeit zu vergrößern mithilfe von
``set_time_limit()`` zu vergrößern.

.. _zend.gdata.introduction.usefeedentry:

Arbeiten mit Daten in Feeds und Einträgen
-----------------------------------------

Nachdem ein Feed empfangen wurde, können die Daten von dem Feed oder den Einträgen die in dem Feed enthalten
sind, gelesen werden, indem entweder die in jeder Daten Modell Klasse definierten Zugriffsmethoden oder die
magischen Zugriffsmethoden verwendet werden. Hier ist ein Beispiel:

.. code-block:: php
   :linenos:

   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $gdata = new Zend_Gdata($client);
   $query = new Zend_Gdata_Query(
           'http://www.blogger.com/feeds/blogID/posts/default');
   $query->setMaxResults(10);
   $feed = $gdata->getFeed($query);
   foreach ($feed as $entry) {
       // Die magischen Zugriffsmethoden verwenden
       echo 'Titel: ' . $entry->title->text;
       // Die definierten Zugriffsmethoden verwenden
       echo 'Inhalt: ' . $entry->getContent()->getText();
   }

.. _zend.gdata.introduction.updateentry:

Einträge aktualisieren
----------------------

Nachdem ein Eintrag empfangen wurde, kann dieser Eintrag aktualisiert und die Änderungen an den Server zurück
gespeichert werden. Hier ist ein Beispiel:

.. code-block:: php
   :linenos:

   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $gdata = new Zend_Gdata($client);
   $query = new Zend_Gdata_Query(
           'http://www.blogger.com/feeds/blogID/posts/default');
   $query->setMaxResults(10);
   $feed = $gdata->getFeed($query);
   foreach ($feed as $entry) {
       // Dem Titel 'NEU' hinzufügen
       echo 'Alter Titel: ' . $entry->title->text;
       $entry->title->text = $entry->title->text . ' NEU';

       // Den Eintrag auf dem Server aktualisieren
       $newEntry = $entry->save();
       echo 'New Title: ' . $newEntry->title->text;
   }

.. _zend.gdata.introduction.post:

Einträge an Google Server schicken
----------------------------------

Das ``Zend_Gdata`` Objekt hat eine ``insertEntry()`` Funktion mit der man Daten hochladen kann um neue Einträge in
Google Data Services zu speichern.

Die Daten Modell Klassen jedes Services kann verwendet werden um einen entsprechenden Eintrag zu erstellen und an
Google's Services zu schicken. Die ``insertEntry()`` Funktion akzeptiert ein Kind von ``Zend_Gdata_App_Entry`` als
Daten die an den Service geschickt werden. Die Methode gibt ein Kind von ``Zend_Gdata_App_Entry`` zurück welches
den Status des Eintrages repräsentiert der vom Server zurückgegeben wurde.

Alternativ, kann die *XML* Struktur eines Eintrages als String konstruiert und dieser String an die
``insertEntry()`` Funktion übergeben werden.

.. code-block:: php
   :linenos:

   $gdata = new Zend_Gdata($authenticatedHttpClient);

   $entry = $gdata->newEntry();
   $entry->title = $gdata->newTitle('Füßball im Park spielen');
   $content =
       $gdata->newContent('Wir besuchen den Part und spielen Fußball');
   $content->setType('text');
   $entry->content = $content;

   $entryResult = $gdata->insertEntry($entry,
           'http://www.blogger.com/feeds/blogID/posts/default');

   echo 'Die <id> des resultierenden Eintrages ist: ' . $entryResult->id->text;

Um Einträge zu senden, muß ein authentifizierter ``Zend_Http_Client`` verwendet werden der mit Hilfe der
``Zend_Gdata_AuthSub`` oder ``Zend_Gdata_ClientLogin`` Klassen erstellt wurde.

.. _zend.gdata.introduction.delete:

Einträge auf einem Google Server löschen
----------------------------------------

Option 1: Das ``Zend_Gdata`` Objekt hat eine ``delete()`` Funktion mit der Einträge von Google Daten Services
gelöscht werden können. Der bearbeitete *URL* Wert eines Feed Eintrages kann der ``delete()`` Methode übergeben
werden.

Option 2: Alternativ kann ``$entry->delete()`` an einem Eintrag der von einem Google Service empfangen wurde,
aufgerufen werden.

.. code-block:: php
   :linenos:

   $gdata = new Zend_Gdata($authenticatedHttpClient);
   // ein Google Daten Feed
   $feedUri = ...;
   $feed = $gdata->getFeed($feedUri);
   foreach ($feed as $feedEntry) {
       // Option 1 - den Eintrag direkt löschen
       $feedEntry->delete();
       // Option 2 - den eintrag durch Übergabe der bearbeiteten URL an
       // $gdata->delete() löschen
       // $gdata->delete($feedEntry->getEditLink()->href);
   }

Um Einträge zu löschen, muß ein authentifizierter ``Zend_Http_Client`` verwendet werden der mit Hilfe der
``Zend_Gdata_AuthSub`` oder ``Zend_Gdata_ClientLogin`` Klassen erstellt wurde.



.. _`Atom Publishing Protokoll`: http://ietfreport.isoc.org/idref/draft-ietf-atompub-protocol/
.. _`http://code.google.com/apis/gdata/`: http://code.google.com/apis/gdata/
.. _`Google Blogger`: http://code.google.com/apis/blogger/developers_guide_php.html
