.. EN-Revision: none
.. _zend.feed.reader:

Zend\Feed\Reader
================

.. _zend.feed.reader.introduction:

Einführung
----------

``Zend\Feed\Reader`` ist eine Komponente die verwendet wird um *RSS* und Atom Feeds jeder Version zu konsumieren,
inklusive *RDF*/*RSS* 1.0, *RSS* 2.0, Atom 0.3 und Atom 1.0. Die *API* für das Empfangen von Feed Daten ist
relativ einfach da ``Zend\Feed\Reader`` in der Lage ist jeden Feed eines jeden Typs mit Hilfe der *API* nach den
angefragten Informationen zu durchsuchen. Wenn die typischen Elemente die diese Informationen enthalten nicht
vorhanden sind, werden diese adaptiert und statt dessen auf eine Vielzahl von alternativen Elementen zurück
gegriffen. Diese Fähigkeit, von Alternativen auszuwählen, verhindert das Benutzer Ihren eigenen astrakten Layer
über die Komponente legen müssen damit Sie nützlich ist, oder beliebig tiefes Wissen des zugrundeliegenden
Standard, aktueller alternativen und namespaces Erweiterungen haben müssen.

Intern arbeitet ``Zend\Feed\Reader`` fast komplett auf Basis der Erstellung von XPath Abfragen gegen das Dokument
Objekt Modell des Feed *XML*'s. Das *DOM* wird nicht durch eine gekettete Eigenschaften *API* wie bei ``Zend_Feed``
bekannt gegeben und durch die darunterliegenden DOMDocument, DOMElement und DOMXPath Objekte für eine externe
Manipulation bekannt gegeben. Dieser Singular Weg des Parsens ist konsistent und die Komponente bietet ein Plugin
System um dem Feed hinzuzufügen und eine Eintrags Level *API* durch das Schreiben von Erweiterungen auf einer
ähnlichen Basis.

Geschwindigkeit wird auf drei Wegen bereitgestellt. Erstens unterstützt ``Zend\Feed\Reader`` das Cachen durch
Verwendung von ``Zend_Cache`` um eine Kopie des Originalen Feed *XML* zu halten. Das erlaubt es Netzwerk Anfragen
für eine Feed *URI* zu überspringen wenn der Cache gültig ist. Zweitens wird die Feed und Eintrag- Level *API*
durch einen internen Cache gesichert (nicht persistent) damit wiederholte *API* Aufrufe für den gleichen Feed eine
zusätzliche Verwendung von *DOM* oder XPath verhindert. Drittens erlaubt das Importieren von Feeds von einer *URI*
den Vorteil von konditionellen *HTTP* ``GET`` Anfragen welche es Servern erlauben eine leere 304 Anfrage
auszulösen wenn der angefragte Feed seit der Zeit zu der er das letzte Mal angefragt wurde, nicht verändert
wurde. Im letzten Fall hält eine Instanz von ``Zend_Cache`` den zuletzt empfangenen Feed zusammen mit dem ETag und
dem Last-Modified Header Werten die in der *HTTP* Antwort gesendet wurde.

Relativ zu ``Zend_Feed`` wurde ``Zend\Feed\Reader`` als frei stehender Ersatz für ``Zend_Feed`` formuliert der
aber nicht mit ``Zend_Feed`` rückwärts kompatibel ist. Aber es ist eine Alternative die einer anderen Ideologie
folgt die darin fokusiert ist einfach verwendbar zu sein, flexibel, konsistent und durch das Plugin System
erweiterbar. ``Zend\Feed\Reader`` ist auch nicht dazu fähig Feeds zu erstellen, delegiert diese Aufgabe aber an
``Zend\Feed\Writer``, seinen Bruder.

.. _zend.feed.reader.import:

Feeds importieren
-----------------

Das importieren eines Feeds mit ``Zend\Feed\Reader`` ist zu ``Zend_Feed`` nicht sehr unterschiedlich. Feeds können
von einem String, einer Datei, *URI* oder einer Instanz des Typs ``Zend\Feed\Abstract`` importiert werden. Das
importieren von einer *URI* kann zusätzlich eine konditionelle *HTTP* ``GET`` Anfrage benützen. Wenn das
importieren fehlschlägt, wird eine Exception geworfen. Das Endergebnis wird ein Objekt des Typs
``Zend\Feed_Reader\FeedInterface`` sein, die Core Implementation von ``Zend\Feed\Reader\Feed\Rss`` und
``Zend\Feed\Reader\Feed\Atom`` (``Zend_Feed`` hat alle kurzen Namen genommen!). Beide Objekte unterstützen mehrere
(alle existierenden) Versionen dieser breiten Feed Typen.

Im folgenden Beispiel importieren wir einen *RDF*/*RSS* 1.0 Feed und extrahieren einige grundsätzliche Information
die dann in einer Datenbank oder wo anders gespeichert werden können.

.. code-block:: php
   :linenos:

   $feed = Zend\Feed\Reader::import('http://www.planet-php.net/rdf/');
   $data = array(
       'title'        => $feed->getTitle(),
       'link'         => $feed->getLink(),
       'dateModified' => $feed->getDateModified(),
       'description'  => $feed->getDescription(),
       'language'     => $feed->getLanguage(),
       'entries'      => array(),
   );

   foreach ($feed as $entry) {
       $edata = array(
           'title'        => $entry->getTitle(),
           'description'  => $entry->getDescription(),
           'dateModified' => $entry->getDateModified(),
           'authors'      => $entry->getAuthors(),
           'link'         => $entry->getLink(),
           'content'      => $entry->getContent()
       );
       $data['entries'][] = $edata;
   }

Das obige Beispiel demonstriert die *API* von ``Zend\Feed\Reader`` und es demonstriert auch einige seiner internen
Operationen. In Wirklichkeit hat der ausgewählte *RDF* Feed keine nativen Daten oder Author Elemente, trotzdem
verwendet er das Dublin Core 1.1 Modul welches Namespaced Ersteller und Datums Elemente anbietet.
``Zend\Feed\Reader`` fällt auf diese und ähnliche Operationen zurück wenn keine relativ nativen Elemente
existieren. Wenn es absolut keine alternative finden kann wird es ``NULL`` zurückgeben, was anzeigt das die
Informationen nicht im Feed gefunden werden können. Man sollte beachten das Klassen die
``Zend\Feed_Reader\FeedInterface`` implementieren auch die *SPL* Interfaces ``Iterator`` und ``Countable``
implementieren.

Feeds können auch von Strings, Dateien und sogar Objekten des Typs ``Zend\Feed\Abstract`` importiert werden.

.. code-block:: php
   :linenos:

   // von einer URI
   $feed = Zend\Feed\Reader::import('http://www.planet-php.net/rdf/');

   // von einem String
   $feed = Zend\Feed\Reader::importString($feedXmlString);

   // von einer Datei
   $feed = Zend\Feed\Reader::importFile('./feed.xml');

   // von einem abstrakten Zend\Feed\Abstract Objekt
   $zfeed = Zend\Feed\Feed::import('http://www.planet-php.net/atom/');
   $feed  = Zend\Feed\Reader::importFeed($zfeed);

.. _zend.feed.reader.sources:

Empfangen darunterliegender Quellen von Feeds und Einträgen
-----------------------------------------------------------

``Zend\Feed\Reader`` macht sein bestes um Ihnen die Details abzunehmen. Wenn man an einem Feed ausserhalb von
``Zend\Feed\Reader`` arbeiten muß, kann man das grundsätzliche DOMDocument oder DOMElement von jeder Klasse
extrahieren, oder sogar einen *XML* String der sie enthält. Es werden auch Methoden angeboten um das aktuelle
DOMXPath Objekt (mit allen registrierten Kern und Erweiterungs Namespaces) zu extrahieren, und den richtigen
Präfix der in allen XPath Anfragen für den aktuellen Feed oder Eintrag verwendet wird. Die grundsätzlich zu
verwenden Methoden (für jedes Objekt) sind ``saveXml()``, ``getDomDocument()``, ``getElement()``, ``getXpath()``
und ``getXpathPrefix()``. Diese erlauben es sich von ``Zend\Feed\Reader`` zu lösen und das zu tun was man selbst
machen will.

- ``saveXml()`` gibt einen *XML* String zurück der nur das Element enthält welches das aktuelle Objekt
  repräsentiert.

- ``getDomDocument()`` gibt das DOMDocument Objekt zurück das den kompletten Feed repräsentiert (sogar wenn es
  von einem Entry Objekt aus aufgerufen wird).

- ``getElement()`` gibt das DOMElement des aktuellen Objekts zurück (z.B. den Feed oder aktuellen Eintrag).

- ``getXpath()`` gibt das aktuelle DOMXPath Objekt für den aktuellen Feed zurück (sogar wenn es von einem Entry
  Objekt aus aufgerufen wird) mit den Namespaces des aktuellen Feed Typs und allen vor-registrierten geladenen
  Erweiterungen.

- ``getXpathPrefix()`` gibt den Präfix der Abfrage für das aktuelle Objekt zurück (z.B. den Feed oder den
  aktuellen Eintrag) welcher den richtigen XPath Query Pfad für den spezifizierten Feed oder Eintrag enthält.

Hier ist ein Beispiel bei dem ein Feed eine *RSS* Erweiterung enthalten können die von ``Zend\Feed\Reader`` nicht
out of the Box unterstützt wird. Beachtenswert ist, das man eine Erweiterungen schreiben und registrieren könnte
(wird später behandelt) um das zu bewerkstelligen, aber das ist nicht immer eine Garantie für einen schnellen
Check. Man muß jeden neuen Namespace beim DOMXPath Objekt registrieren bevor es verwendet wird ausser Sie werden
vorab von ``Zend\Feed\Reader`` oder einer Erweiterung registriert.

.. code-block:: php
   :linenos:

   $feed        = Zend\Feed\Reader::import('http://www.planet-php.net/rdf/');
   $xpathPrefix = $feed->getXpathPrefix();
   $xpath       = $feed->getXpath();
   $xpath->registerNamespace('admin', 'http://webns.net/mvcb/');
   $reportErrorsTo = $xpath->evaluate('string('
                                    . $xpathPrefix
                                    . '/admin:errorReportsTo)');

.. warning::

   Wenn man einen bereits registrierten Namespace mit einem anderen Präfix Namen registriert als jenen der von
   ``Zend\Feed\Reader`` intern verwendet wird, zerstört das die Interne Arbeitsweise dieser Komponente.

.. _zend.feed.reader.cache-request:

Unterstützung für Caches und intelligente Anfragen
--------------------------------------------------

.. _zend.feed.reader.cache-request.cache:

Unterstützung für Caches in Zend\Feed\Reader hinzufügen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Feed\Reader`` unterstützt die Verwendung einer Instanz von ``Zend_Cache`` um Feeds zu cachen (als *XML*) um
unnötige Anfragen im Netzwerk zu vermeiden. Das Hinzufügen eines Caches ist hier so einfach wie bei anderen Zend
Framework Komponenten. Den Cache erstellen und konfigurieren und dann ``Zend\Feed\Reader`` mitteilen das er
verwendet werden soll! Der verwendete Cache Schlüssel ist "``Zend\Feed_Reader\``" gefolgt von dem *MD5* Hash der
*URI* des Feeds.

.. code-block:: php
   :linenos:

   $frontendOptions = array(
      'lifetime' => 7200,
      'automatic_serialization' => true
   );
   $backendOptions = array('cache_dir' => './tmp/');
   $cache = Zend\Cache\Cache::factory(
       'Core', 'File', $frontendOptions, $backendOptions
   );

   Zend\Feed\Reader::setCache($cache);

.. note::

   Auch wenn es etwas abseits ist, sollte man daran denken zu ``Zend\Loader\PluginLoader`` einen Cache
   hinzuzufügen der von ``Zend\Feed\Reader`` verwendet wird um Erweiterungen zu laden.

.. _zend.feed.reader.cache-request.http-conditional-get:

Unterstützung für HTTP Conditional GET
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die große Frage wenn man ofters einen Feed importiert, ist ob er sich geändert hat. Wenn ein Cache aktiviert ist,
kann man die Unterstützung für *HTTP* Conditional ``GET`` hinzufügen um diese Frage zu beantworten.

Durch Verwendung dieser Methode kann man Feeds von *URI* anfragen und deren letzte bekannte Werte der ETag und
Last-Modified Antwort Header mit der Anfrage inkludieren (wobei die If-None-Match und If-Modified-Since Header
verwendet werden). Wenn der Feed auf dem Server unverändert ist, sollte man eine 304 Antwort empfangen die
``Zend\Feed\Reader`` mitteilt das die gecachte Version zu verwenden ist. Wenn ein kompletter Feed in einer Antwort
mit einem Status Code von 200 geschickt wird, bedeutet dieses, das der Feed verändert wurde und
``Zend\Feed\Reader`` wird die neue Version parsen und Sie im Cache abspeichern. Es werden auch die neuen Werte der
ETag und Last-Modified Header für eine zukünftige Verwendung gespeichert.

Bei diesen "konditionalen" Abfragen ist nicht garantiert das Sie, vom Server von dem man eine *URI* abfragt,
unterstützt werden, können aber trotzdem angefragt werden. Die meisten Feed Quellen wie Blogs sollten hierfür
eine Unterstützung haben. Um konditionale Anfragen zu erlauben, muss man einen Cache bei ``Zend\Feed\Reader``
angeben.

.. code-block:: php
   :linenos:

   $frontendOptions = array(
      'lifetime' => 86400,
      'automatic_serialization' => true
   );
   $backendOptions = array('cache_dir' => './tmp/');
   $cache = Zend\Cache\Cache::factory(
       'Core', 'File', $frontendOptions, $backendOptions
   );

   Zend\Feed\Reader::setCache($cache);
   Zend\Feed\Reader::useHttpConditionalGet();

   $feed = Zend\Feed\Reader::import('http://www.planet-php.net/rdf/');

Im obige Beispiel werden, bei aktivierten *HTTP* Conditional ``GET`` Anfragen, die Werte der Antwort Header für
ETag und Last-Modified mit dem Feed gecacht. Für die nächsten 24 Stunden (die Lebenszeit des Caches) werden Feed
am Cache nur dann aktualisiert wenn eine nicht-304 Antwort empfangen wird, die ein gültiges *RSS* oder Atom *XML*
Dokument enthält.

Wenn man darauf anzielt die Antwort Header ausserhalb von ``Zend\Feed\Reader`` zu managen, kann man die relevanten
If-None-Matches und If-Modified-Since Antwort Header über die *URI* Import Methode setzen.

.. code-block:: php
   :linenos:

   $lastEtagReceived = '5e6cefe7df5a7e95c8b1ba1a2ccaff3d';
   $lastModifiedDateReceived = 'Wed, 08 Jul 2009 13:37:22 GMT';
   $feed = Zend\Feed\Reader::import(
       $uri, $lastEtagReceived, $lastModifiedDateReceived
   );

.. _zend.feed.reader.locate:

Feed URIs von Webseiten erkennen
--------------------------------

Dieser Tage ist vielen Webseiten bekannt das der Ort Ihrer *XML* Feeds nicht immer eindeutig ist. Eine kleine
*RDF*, *RSS* oder Atom Grafik hilft wenn der Benutzer die Seite liest, aber was wenn eine Maschine kommt und
versucht herauszufinden So die Feed sind? Um hierbei zu helfen, zeigen viele Webseiten zu Ihren Feeds indem <link>
Tags in der <head> Sektion Ihres *HTML*\ s verwendet werden. Um diesen Vorteil zu nutzen, kann man
``Zend\Feed\Reader`` verwenden diese Feeds zu erkennen, indem die statische ``findFeedLinks()`` Methode verwendet
wird.

Diese Methode ruft irgendeine *URI* auf und sucht nach dem Ort der *RSS*, *RDF* und Atom Feeds mit der Annahme dass
das *HTML* der Webseite nur die relevanten Links enthält. Sie gibt dann ein Wert Objekt zurück indem man die
Existenz einer *RSS*, *RDF* oder Atom Feed *URI* prüfen kann.

Das zurückgegebene Objekt ist eine Unterklasse von ``ArrayObject`` welche ``Zend\Feed\Reader\Collection\FeedLink``
heisst, damit es in ein Array gecastet werden kann, oder damit man es iterieren kann um auf alle erkannten Links
zuzugreifen. Trotzdem kann man, als einfache Abkürzung, den ersten *RSS*, *RDF* oder Atom Link holen indem dessen
öffentliche Eigenschaft wie im beiliegenden Beispiel verwendet wird. Andernfalls ist jedes Element von
``ArrayObject`` ein einfaches Array mit den Schlüsseln "type" und "uri" wobei der Typ "rdf", "rss" oder "atom"
sein kann.

.. code-block:: php
   :linenos:

   $links = Zend\Feed\Reader::findFeedLinks('http://www.planet-php.net');

   if (isset($links->rdf)) {
       echo $links->rdf, "\n"; // http://www.planet-php.org/rdf/
   }
   if (isset($links->rss)) {
       echo $links->rss, "\n"; // http://www.planet-php.org/rss/
   }
   if (isset($links->atom)) {
       echo $links->atom, "\n"; // http://www.planet-php.org/atom/
   }

Basierend auf diesen Links kann man dann, von welchen Quellen man auch immer will, importieren indem die übliche
Vorgehensweise verwendet wird.

Diese schnelle Methode gibt nur einen Link für jeden Feed Typ zurück, aber Webseiten können viele Links von
jedem Typ enthalten. Möglicherweise ist es eine News Site mit einem *RSS* Feed für jede News Kategorie. Man kann
durch alle Links iterieren indem der ArrayObject Iterator verwendet wird.

.. code-block:: php
   :linenos:

   $links = Zend\Feed\Reader::findFeedLinks('http://www.planet-php.net');

   foreach ($links as $link) {
       echo $link['uri'], "\n";
   }

.. _zend.feed.reader.attribute-collections:

Attribut Sammlungen
-------------------

In einem Versuch die Rückgabetypen zu vereinfachen, können Rückgabetypen für die verschiedenen Feed und Entry
Level Methoden ab Zend Framework 1.10 ein Objekt vom Typ ``Zend\Feed\Reader\Collection\CollectionAbstract``
enthalten. Abgesehen vom speziellen Klassennamen der anbei erklärt wird, ist es nur eine einfache Subklasse von
*SPL*'s ``ArrayObject``.

Der Hauptzweck hierbei besteht darin, die Präsentation von so vielen Daten wie möglich von den angefragten
Elementen zu erlauben, wärend trotzdem der Zugriff auf die meisten relevanten Daten über ein einfaches Array
erlaubt wird. Das erzwingt auch einen Standardweg um solche Daten zurückzugeben, was vorher zwischen Arrays und
Objekten gewandert ist.

Der neue Klassentyp arbeitet identisch zu ``ArrayObject``, mit der gleichen kleinen Änderung dass eine neue
Methode ``getValues()`` existiert welche ein einfaches flaches Array zurückgibt dass die meisten relevanten
Informationen enthält.

Ein einfaches Beispiel hiervon ist ``Zend\Feed_Reader\FeedInterface::getCategories()``. Wenn es in irgendeinem
*RSS* oder Atom Feed verwendet wird, gibt diese Methode Daten der Kategorie als Container Objekt zurück welches
``Zend\Feed\Reader\Collection\Category`` genannt wird. Das Container Objekt wird, für jede Kategorie, drei Felder
an Daten enthalten: term, schema und label. "term" ist der grundsätzliche Name der Kategorie, oft Maschinen lesbar
(normalerweise ein *URI* Identifikator) und in *RSS* 2.0 auch bekannt als "domain". "label" ist ein menschlich
lesbarer Kategorie Name welcher *HTML* Entities unterstützt. In *RSS* 2.0 gibt es kein Label Attribut deshalb wird
es der Bequemlichkeit halber immer auf den selben Wert gesetzt wie der Ausdruck.

Um auf die Label der Kategorie selbst als einfache Array Werte zuzugreifen könnte man das folgende verwenden:

.. code-block:: php
   :linenos:

   $feed = Zend\Feed\Reader::import('http://www.example.com/atom.xml');
   $categories = $feed->getCategories();
   $labels = array();
   foreach ($categories as $cat) {
       $labels[] = $cat['label']
   }

Es ist ein erfundenes Beispiel, aber der Punkt ist, dass Label zusammen mit anderen Informationen gebunden sind.

Trotzdem erlaubt die Container Klasse den Zugriff auf die "relevantesten" Daten als einfaches Array indem die
Methode ``getValues()`` verwendet wird. Das Konzept der "relevantesten" Daten ist offensichtlich ein beurteilter
Aufruf. Für Kategorien bedeutet es die Label der Kategorien (nicht die Typen oder Schemata) wärend es für
Autoren der Name des Autors wäre (nicht deren Email Adressen oder die *URI*\ s). Das einfache Array ist flach (nur
Werte) und durchläuft ``array_unique`` um doppelte Werte zu entfernen.

.. code-block:: php
   :linenos:

   $feed = Zend\Feed\Reader::import('http://www.example.com/atom.xml');
   $categories = $feed->getCategories();
   $labels = $categories->getValues();

Das obige Beispiel zeigt wie nur die Label und sonst nichts extrahiert wird. Das gibt einen einfachen Zugriff auf
die Label der Kategorie ohne zusätzliche Arbeit die Daten selbst zu extrahieren.

.. _zend.feed.reader.retrieve-info:

Empfangen von Feed Informationen
--------------------------------

Das Empfangen von Informationen von einem Feed (wir reden über Einträge und Elemente in der nächsten Sektion da
Sie identischen Prinzipien folgen) verwendet eine klar definierte *API* welche exakt die gleiche ist, unabhängig
davon ob der angefragte Feed *RSS*, *RDF* oder Atom ist. Das selbe gilt für Sub-Versionen dieser Standards da wir
jede einzelne *RSS* und Atom Version getestet haben. Wärend sich der darunterliegende *XML* Feed substantiell
unterscheiden kann, im Sinne von Tags und Elementen die vorhanden sind, versuchen trotzdem alle ähnliche
Informationen zu geben und um das alles zu reflektieren werden unterschiede und das Hanteln durch alternative Tags
intern von ``Zend\Feed\Reader`` behandelt welche einem ein identisches Interface für jeden anzeigt. Idealerweise
sollte man sich nicht darum kümmern ob ein Feed *RSS* oder Atom ist, solange man die Informationen extrahieren
kann die man benötigt.

.. note::

   Wärend die Erkennung von Gemeinsamkeiten zwischen den Feed Typen selbst sehr komplex ist, sollte erwähnt
   werden das *RSS* selbst eine konstant strittige "Spezifikation". Das hat seine Wurzeln im originalen *RSS* 2.0
   Dokument welches Doppeldeutigkeiten enthält und die richtige Behandlung alle Elemente nicht im Detail erklärt.
   Als Ergebnis verwendet diese Komponente riguros die *RSS* 2.0.11 Spezifikation welche vom *RSS* Advisory Board
   veröffentlicht wurde und dessen beigefügtes *RSS* Best Practices Profil. Keine andere Interpretation von *RSS*
   2.0 wird unterstützt wobei Ausnahmen erlaubt sein können wo es die anwendung der zwei vorher erwähnten
   Dokumente nicht direkt verhindert.

Natürlich leben wir nicht in einer idealen Welt sodas es Zeiten gibt in denen die *API* einfach nicht das bietet
wonach man sucht. Um hierbei zu helfen bietet ``Zend\Feed\Reader`` ein Plugin System an das es erlaubt
Erweiterungen zu schreiben und die Kern *API* zu erweitern sowie alle zusätzliche Daten abzudecken die man von
Feeds extrahieren will. Wenn das schreiben einer weiteren Erweiterung zu problematisch ist, kann man einfach das
darunterliegende *DOM* oder die XPath Objekte holen und das von Hand in der Anwendung machen. Natürlich sollte
wirklich eine Erweiterung geschrieben werden, einfach um es portabler und wiederverwendbarer zu machen. Und
nützliche Erweiterungen können für den Framework vorgeschlagen werden um Sie formal hinzuzufügen.

Hier ist eine Zusammenfassung der Kern *API* für Feeds. Man sollte beachten das es nicht nur die grundsätzlichen
*RSS* und Atom Standard abdeckt, sondern das es auch eine Anzahl von mitgelieferten Erweiterungen gibt die mit
``Zend\Feed\Reader`` gebündelt sind. Die Benennung dieser Methoden von Erweiterungen ist recht generisch - alle
erweiterten Methoden arbeiten auf dem gleichen Level wie die Kern *API* da wir es erlauben alle spefizischen
Erweiterungs Objekte separat zu empfangen wenn das notwendig ist.

.. table:: API Methoden auf dem Level des Feeds

   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getId()                      |Gibt eine eindeutige ID zurück die mit dem Feed assoziiert ist                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getTitle()                   |Gibt den Titel des Feeds zurück                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDescription()             |Gibt die textuelle Beschreibung des Feeds zurück                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getLink()                    |Gibt eine URI zu der HTML Webseite zurück welche die gleiche oder ähnliche Informationen wie dieser Feed enthält (z.B. wenn der Feed von einem Blog ist, sollte die URI des Blogs enthalten sein indem die HTML Version des Eintrags gelesen werden kann)                                                                                                                                                                                                                                                                                   |
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getFeedLink()                |Gibt die URI dieses Feeds zurück, welche die gleiche sein kann wie die URI welche verwendet wurde um den Feed zu importieren. Es gibt wichtige Fälle in denen sich der Feed Link unterscheiden kann weil die Quell URI aktualisiert wird und geplant ist Sie in Zukunft zu entfernen.                                                                                                                                                                                                                                                       |
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getAuthors()                 |Gibt ein Objekt vom Typ Zend\Feed\Reader\Collection\Author zurück welches ein ArrayObject ist dessen Elemente einfach Arrays sind die eine Kombination der Schlüssel "name", "email" und uri" enthalten. Wo es wegen der Quelldaten irrelevant ist können einige dieser Schlüssel unterdrückt werden.                                                                                                                                                                                                                                       |
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getAuthor(integer $index = 0)|Gibt entweder den ersten bekannten Author zurück, oder mit dem optionalen Parameter $index jeden spezifischen Index des Arrays von Authoren wie vorher beschrieben (gibt NULL bei einem ungültigen Index zurück).                                                                                                                                                                                                                                                                                                                           |
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDateCreated()             |Gibt das Datum zurück zu dem dieser Feed erstellt wurde. Generell nur anwendbar bei Atom da es das Datum repräsentiert zu der das Atom 1.0 Dokument erstellt wurde das die Ressource beschreibt. Das zurückgegebene Datum ist ein Zend_Date Objekt.                                                                                                                                                                                                                                                                                         |
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDateModified()            |Gibt das Datum zurück zu dem der Feed das letzte mal geändert wurde. Das zurückgegebene Datum ist ein Zend_Date Objekt.                                                                                                                                                                                                                                                                                                                                                                                                                     |
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getLastBuildDate()           |Gibt das Datum zurück an dem der Feed das letzte Mal erstellt wurde. Das zurückgegebene Datum ist ein Zend_Date Objekt. Das wird nur von RSS unterstützt - Atom Feeds geben immer NULL zurück.                                                                                                                                                                                                                                                                                                                                              |
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getLanguage()                |Gibt die Sprache des Feeds zurüc (wenn definiert) oder einfach die Sprache die im XML Dokument notiert wurde                                                                                                                                                                                                                                                                                                                                                                                                                                |
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getGenerator()               |Gibt den Erzeuger des Feeds zurück, z.B. die Software die Ihn erzeugt hat. Das kann sich zwischen RSS und Atom unterscheiden, da Atom eine andere Schreibweise definiert.                                                                                                                                                                                                                                                                                                                                                                   |
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getCopyright()               |Gibt alle Copyright Notizen zurück die mit dem Feed assoziiert sind                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getHubs()                    |Gibt ein Array der URI Endpunkte aller Hub Server zurück welche vom Feed für die Berwendung mit dem Pubsubhubbub Protokoll bekanntgegeben werden, und erlaubt damit das Einschreiben für Feeds für Real-Time Updates.                                                                                                                                                                                                                                                                                                                       |
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getCategories()              |Gibt ein Zend\Feed\Reader\Collection\Category Objekt zurück welches die Details aller Kategorien enthält die im kompletten Feed enthalten sind. Die unterstützten Felder enthalten "term" (den Maschinen lesbaren Namen der Kategorie), "scheme" (dem Schema der Kategorisierung für diese Kategorie), und "label" (ein HTML dekodierter menschlich lesbarer Kategoriename). Wenn irgendeines der drei Felder abwesend ist, werden Sie entweder auf die näheste vorhandene Alternative gesetzt, oder im Fall von "scheme", auf NULL gesetzt.|
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getImage()                   |Gibt ein Array zurück welches Daten enthält die jedem Feed Bild oder Logo angehören oder NULL wenn kein Bild gefunden wurde. Das resultierende Array kann die folgenden Schlüssel enthalten: uri, link, title, description, height, und width. Nur Atom Logos enthalten eine URI so dass die anderen Metadaten nur von RSS Feeds angehören.                                                                                                                                                                                                 |
   +-----------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Angehend von der Vielzahl von Feeds in der Wildnis, werden einige dieser Methoden erwartungsgemäßg ``NULL``
zurückgeben, was anzeigt das die relevanten Informationen nicht gefunden wurden. Wo es möglich ist wird
``Zend\Feed\Reader`` wärend der Suche auf alternative Elemente zurück greifen. Zum Beispiel ist das Durchsuchen
eines *RSS* Feeds nach einem Modifikations Datum komplizierter als es aussieht. *RSS* Feeds sollten ein
``<lastBuildDate>`` Tag und (oder) ein ``<pubDate>`` Element enthalten. Aber was wenn Sie es nicht tun, weil es
z.B. ein *RSS* 1.0 Feed ist? Vielleicht ist stattdessen ein ``<atom:updated>`` Element mit identischen
Informationen vorhanden (Atom kann verwendet werden um die *RSS* Syntax anzubieten)? Bei einem Fehlschlag können
wir einfach auf die Einträge sehen, den aktuellsten herausholen, und sein ``<pubDate>`` Element verwenden. In der
Annahme das es existiert... viele Feeds verwenden auch Dublin Core 1.0 oder 1.1 ``<dc:date>`` Elemente für Feeds
und Einträge. Oder wir können wieder ein Atom finden das herumliegt.

Der Punkt ist, das ``Zend\Feed\Reader`` entwickelt wurde um das zu wissen. Wenn man nach dem Änderungsdatum fragt
(oder irgendwas anderes), wird er starten und alle diese Alternativen suchen bis er entweder aufgibt und ``NULL``
zurückgibt, oder eine Alternative findet welche die richtige Antwort hat.

Zusätzlich zu den obigen Methoden, implementieren alle Feed Objekte Methoden für das empfangen der *DOM* und
XPath Objekte für die aktuellen Feeds wie vorher beschrieben. Feed Objekte implementieren auch die Interfaces für
*SPL* Iterator und Countable. Die erweiterte *API* wird anbei zusammengefasst.

.. table:: Erweiterte API Methoden auf Level des Feeds

   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDomDocument()          |Gibt das elterliche DOMDocument Objekt für das komplette XML Quelldokument zurück                                                                                                                                                                                                               |
   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getElement()              |Gibt das aktuelle DOMElement Objekt des Feed Levels zurück                                                                                                                                                                                                                                      |
   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |saveXml()                 |Gibt einen String zurück der ein XML Dokument zurück welches das komplette Feed Element enthält (das ist nicht das originale Dokument sondern eine nachgebaute Version)                                                                                                                         |
   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getXpath()                |Gibt das intern verwendete DOMXPath Objekt zurück mit dem Abfragen auf das DOMDocument Objekt durchgeführt werden (das enthält die Kern und Erweiterungs Namespaces die vor-registriert sind)                                                                                                   |
   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getXpathPrefix()          |Gibt den gültigen DOM Pfad Präfix zurück der bei allen XPath Abfragen passt die dem Feed entsprechen der abgefragt wird.                                                                                                                                                                        |
   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getEncoding()             |Gibt die Kodierung des XML Quelldokuments zurück (Beachte: Das kann nicht verwendet werden für Fehler wie einen Server der Dokumente in einer anderen Kodierung verschickt). Wo diese nicht definiert ist, wird die Standardkodierung UTF-8 von Unicode angewendet.                             |
   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |count()                   |Gibt eine Zahl von Einträgen oder Elementen zurück welche dieser Feed enthält (implementiert das SPL Interface Countable)                                                                                                                                                                       |
   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |current()                 |Gibt nur den aktuellen Eintrag zurück (verwendet den aktuellen Index von key())                                                                                                                                                                                                                 |
   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |key()                     |Gibt den aktuellen Index für Einträge zurück                                                                                                                                                                                                                                                    |
   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |next()                    |Addiert den Wert des Index für Einträge um Eins                                                                                                                                                                                                                                                 |
   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |rewind()                  |Setzt den Index für Einträge auf 0 zurück                                                                                                                                                                                                                                                       |
   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |valid()                   |Prüft ob der aktuelle Index für Einträge gültig ist, z.B. ob er nicht unter 0 fällt und die Anzahl der existierenden Einträge nicht übersteigt.                                                                                                                                                 |
   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getExtensions()           |Gibt ein Array aller Erweiterungs Objekte zurück die für den aktuellen Feed geladen sind (Beachte: sowohl Feel-Level als auch Element-Level Erweiterungen exstieren, aber nur Feed-Level Erweiterungen werden hier zurückgegeben). Die Array Schlüssel sind in der Form (ErweiterungsName)_Feed.|
   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getExtension(string $name)|Gibt ein Erweiterungs Objekt für den Feed zurück der unter dem angegebenen Namen registriert ist. Das erlaubt einen feiner gestaffelten Zugriff auf Erweiterungen welche andernfalls in der Implementation der standardmäßigen API Methoden versteckt wären.                                    |
   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getType()                 |Gibt eine statische Klassenkonstante zurück (z.B. Zend\Feed\Reader::TYPE_ATOM_03, z.B. Atom 0.3) welche exakt anzeigt welche Art von Feed gerade konsumiert wird.                                                                                                                               |
   +--------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.feed.reader.entry:

Empfangen von Informationen aus Einträgen/Elementen
---------------------------------------------------

Das Empfangen von Informationen für spezifische Einträge oder Elemente (abhängig davon ob man Atom oder *RSS*
spricht) ist identisch wie bei den Daten auf Feed Level. Der Zugriff auf Einträge ist einfach ein Fall von
Iteration über ein Feed Objekt oder durch Verwendung des *SPL* Interfaces ``Iterator`` welches Feed Objekte
implementieren und durch Aufruf der betreffenden Methoden auf Ihnen.

.. table:: API Methoden auf Level des Eintrags

   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getId()                                           |Gibt eine eindeutige ID für den aktuellen Eintrag zurück.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getTitle()                                        |Gibt den Titel des aktuellen Eintrags zurück.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDescription()                                  |Gibt eine Beschreibung des aktuellen Eintrags zurück.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getLink()                                         |Gibt eine URI zur HTML Version des aktuellen Eintrags zurück.                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getPermaLink()                                    |Gibt einen permanenten Link zum aktuellen Eintrag zurück. In den meisten Fällen ist dies das selbe wie die Verwendung von getLink().                                                                                                                                                                                                                                                                                                                                                                                                        |
   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getAuthors()                                      |Gibt ein Objekt vom Typ Zend\Feed\Reader\Collection\Author zurück welches ein ArrayObject ist, dessen Elemente alle einfache Array sind welche beliebige Kombinationen der Schlüssel "name", "email" und "uri" enthalten können. Wo es für die Quelldaten irrelevant ist können einige dieser Schlüssel unterdrückt sein.                                                                                                                                                                                                                   |
   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getAuthor(integer $index = 0)                     |Gibt entweder den ersten bekannten Autor zurück, oder mit dem optionalen Parameter $index jeden spezifischen Index aus dem Array der Authoren wie vorher beschrieben (gibt NULL zurück wenn der Index ungültig ist).                                                                                                                                                                                                                                                                                                                        |
   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDateCreated()                                  |Gibt das Datum zurück an dem der aktuelle Eintrag erstellt wurde. Generell kann das nur auf Atom angewendet werden wo es das Datum der Ressource beschreibt zu welche das Atom 1.0 Dokument erstellt wurde.                                                                                                                                                                                                                                                                                                                                 |
   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDateModified()                                 |Gibt das Datum zurück an welchem der aktuelle Eintrag zuletzt geändert wurde.                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getContent()                                      |Gibt den Inhalt des aktuellen Eintrags zurück (das retourniert alle Entities wenn das möglich ist, mit der Annahme das der Content Type HTML ist). Die Beschreibung wird zurückgegeben wenn ein kein seperates Content Element existiert.                                                                                                                                                                                                                                                                                                   |
   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getEnclosure()                                    |Gibt ein Array zurück welches die Werte aller Attribute eines Multimedia <enclosure> Elements enthält, inklusive der Array Schlüssel: url, length, type. Basierend auf dem RSS Best Practices Profile des RSS Advisory Boards, wird keine Unterstützung für mehrere Enclosures angeboten da so eine Unterstützung kein Teil der RSS Spezifikation ist.                                                                                                                                                                                      |
   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getCommentCount()                                 |Gibt die Anzahl der Kommentare zurück die auf diesen Eintrag gemacht wurden seit der Zeit an welcher der Feed erstellt wurde                                                                                                                                                                                                                                                                                                                                                                                                                |
   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getCommentLink()                                  |Gibt eine URI zurück welche auf die HTML Seite zeigt, auf der Kommentare zu diesem Eintrag gemacht werden können                                                                                                                                                                                                                                                                                                                                                                                                                            |
   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getCommentFeedLink([string $type = 'atom'\|'rss'])|Gibt eine URI zurück die auf einen Feed zeigt welcher vom angegebenen Typ ist, und alle Kommentare für diesen Eintrag enthält (Der Typ ist standardmäßig Atom/RSS abhängig vom aktuellen Feed Typ).                                                                                                                                                                                                                                                                                                                                         |
   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getCategories()                                   |Gibt ein Zend\Feed\Reader\Collection\Category Objekt zurück welches die Details jeder Kategorie enthält welche mit dem Eintrag assoziiert ist. Die unterstützten Felder sind "term" (der Maschinen lesbare Name der Kategorie), "scheme" (der Name des Schemas der Kategorisierung für diese Kategorie), und "label" (ein HTML dekodierter menschlich lesbarer Name der Kategorie). Wenn eines der drei Felder nicht vorhanden ist, werden Sie entweder auf den näheste vorhandene Alternative, oder im Fall von "scheme", auf NULL gesetzt.|
   +--------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Die erweiterte *API* für Einträge ist identisch zu der für die Feed mit der Aufnahme der Iterator Methoden die
hier nicht benötigt werden.

.. caution::

   Es gibt oft Missverständnisse über die Konzepte vom Zeitpunkt der Änderung und des Erstellungsdatums. In
   Atom, sind diese zwei klar definierte Konzepte aber in *RSS* sind Sie vage. *RSS* 2.0 definiert ein einzelnes
   **<pubDate>** Element das typischerweise auf das Datum referiert an dem dieser Eintrag veröffentlicht wurde,
   z.B. etwas in der Art eines Erstellungsdatums. Das ist nicht immer das gleiche, und kann sich durch Updates
   ändern oder auch nicht. Als Resultat sollte man sich, wenn man wirklich prüfen will ob der Eintrag geändert
   wurde oder nicht, nicht auf das Ergebnis von ``getDateModified()`` verlassen. Stattdessen sollte man Erwägen
   den *MD5* Hash von drei anderen verknpüften Elementen zu beobachten, z.B. durch Verwendung von ``getTitle()``,
   ``getDescription()`` und ``getContent()``. Wenn der Eintrag wirklich geändert wurde, gibt diese Hash Berechnung
   ein anderes Ergebnis als die vorher gespeicherten Hashs für den gleichen Eintrag. Das ist natürlich
   Inhalts-Orientiert und hilft nicht bei der Erkennung von anderen relevanten Elementen. Atom Feeds sollten solche
   Schritte nicht benötigen.

   Weitere Schritte in diesen Wassern zeigen das die Daten von Feeds unterschiedlichen Standards folgen. Atom und
   Dublin Core Daten sollten *ISO* 86001 folgen und *RSS* Daten sollten *RFC* 822 oder *RFC* 2822 folgen welche
   auch üblicherweise verwendet werden. Datumsmethoden werfen eine Exception wenn ``Zend_Date``, oder die *PHP*
   basierenden Möglichkeiten für *RSS* Daten, das Datum durch Verwendung der obigen Standards nicht laden kann.

.. warning::

   Die Werte die von diesen Methoden zurückgegeben werden, sind nicht geprüft. Das bedeutet das der Benutzer
   Prüfungen auf allen empfangenen Daten durchführen muss inklusive filtern von jeglichem *HTML* wie von
   ``getContent()`` bevor es von der eigenen Anwendung ausgegeben wird. Es ist zu beachten das die meisten Feeds
   von externen Quellen kommen, und deshalb die normale Annahme sein sollte das man Ihnen nicht trauen kann.

.. table:: Erweiterte API Methoden auf Level des Eintrags

   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDomDocument()          |Gibt das elterliche DOMDocument Objekt für den kompletten Feed zurück (nicht nur den aktuellen Eintrag)                                                                                                                                                                                                                         |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getElement()              |Gibt das DOMDocument Objekt für den aktuellen Level des Eintrags zurück                                                                                                                                                                                                                                                         |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getXpath()                |Gibt das DOMXPath Objekt zurück welches intern verwendet wird um Abfragen auf dem DOMDocument Objekt durchzuführen (es enthält auch die vorregistrierten Kern und Erweiterungs Namespaces)                                                                                                                                      |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getXpathPrefix()          |Gibt einen gültigen DOM Pfad Präfix zurück der allen XPath Abfrage vorangestellt wird, welche dem Eintrag entsprechen der abgefragt wird.                                                                                                                                                                                       |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getEncoding()             |Gibt die Kodierung des XML Quelldokuments zurück (Achtung: Das kann nicht für Fehler genommen werden bei denen der Server eine andere Kodierung sendet als die Dokumente). Die Standard Kodierung welche bei Abwesenheit jeglicher anderen Kodierung angewendet wird, ist die UTF-8 Kodierung von Unicode.                      |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getExtensions()           |Gibt ein Array aller Erweiterungsobjekte zurück die für den aktuellen Eintrag geladen wurden (Achtung: Sowohl Erweiterung auf Level von Feeds als auch auf Level von Einträgen existieren, und nur Erweiterungen auf Level von Einträgen werden hier zurückgegeben). Die Arrayschlüssel sind im Format {ErweiterungsName}_Entry.|
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getExtension(string $name)|Gibt das Erweiterungsobjekt zurück für das der Eintrag mit dem angegebenen Namen registriert wurde. Das erlaubt einen feineren Zugriff auf Erweiterungen welche andernfalls innerhalb der Implementierung der standardmäßigen API Methoden versteckt wären.                                                                     |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getType()                 |Gibt eine statische Klassenkonstante zurück (z.B. Zend\Feed\Reader::TYPE_ATOM_03, z.B. Atom 0.3) die exakt anzeigt von welcher Art der Feed ist der gerade konsumiert wird.                                                                                                                                                     |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.feed.reader.extending:

Erweitern der APIs für Feeds und Einträge
-----------------------------------------

Die Erweiterung von ``Zend\Feed\Reader`` erlaubt es Methoden sowohl auf Level von Feeds als auch auf Level von
Einträgen hinzuzufügen, welche das Empfangen von Informationen abdecken die nicht bereits von
``Zend\Feed\Reader`` unterstützt werden. Bei der Anzahl an *RSS* und Atom Erweiterungen die existieren, ist das
ein guter Weg da ``Zend\Feed\Reader`` einfach nicht alles hinzufügen kann.

Es gibt zwei Typen von Erweiterungen, jene welche Informationen von Elementen empfangen die unmittelbare Kunder des
Root Elements sind (z.B. ``<channel>`` für *RSS* oder ``<feed>`` für Atom), und jene die Informationen von
Kind-Elementen eines Eintrags empfangen (z.B. ``<item>`` für *RSS* oder ``<entry>`` für Atom). Auf dem Filesystem
sind Sie als Klassen in einem Namespace gruppiert, basierend auf dem Standardnamen der Erweiterung. Zum Beispiel
haben wir intern ``Zend\Feed\Reader\Extension\DublinCore\Feed`` und ``Zend\Feed\Reader\Extension\DublinCore\Entry``
Klassen welche zwei Klassen sind welche die Unterstützung für Dublin Core 1.0/1.1 implementieren.

Erweiterungen werden in ``Zend\Feed\Reader`` durch Verwendung von ``Zend\Loader\PluginLoader`` geladen, sodas
dessen Operationen ähnlich denen anderer Zend Framework Komponenten ist. ``Zend\Feed\Reader`` kommt bereits mit
einer Anzahl dieser Erweiterungen. Trotzdem müssen jene, die nicht intern verwendet und standardmäßig
registriert werden (sogenannte Core Erweiterungen), bei ``Zend\Feed\Reader`` registriert werden bevor Sie verwendet
werden. Die gebündelten Erweiterungen sind:

.. table:: Core Extensions (pre-registered)

   +-----------------------------+----------------------------------------------------------------------------------------+
   |DublinCore (Feed und Eintrag)|Implementiert die Unterstützung für das Dublin Core Metadata Element Set 1.0 und 1.1    |
   +-----------------------------+----------------------------------------------------------------------------------------+
   |Content (nur Eintrag)        |Implementiert Unterstützung für Content 1.0                                             |
   +-----------------------------+----------------------------------------------------------------------------------------+
   |Atom (Feed und Eintrag)      |Implementiert Unterstützung für Atom 0.3 und Atom 1.0                                   |
   +-----------------------------+----------------------------------------------------------------------------------------+
   |Slash                        |Implementiert Unterstützung für das Slash RSS 1.0 Modul                                 |
   +-----------------------------+----------------------------------------------------------------------------------------+
   |WellFormedWeb                |Implementiert Unterstützung für das Well Formed Web CommentAPI 1.0                      |
   +-----------------------------+----------------------------------------------------------------------------------------+
   |Thread                       |Implementiert Unterstützung für Atom Threading Erweiterungen wie in RFC 4685 beschrieben|
   +-----------------------------+----------------------------------------------------------------------------------------+
   |Podcast                      |Implementiert Unterstützung für das Podcast 1.0 DTD von Apple                           |
   +-----------------------------+----------------------------------------------------------------------------------------+

Die Core Erweiterungen sind irgendwie speziell da Sie extrem allgemein sind und viele Facetten haben. Zum Beispiel
haben wir eine Core Erweiterung für Atom. Atom ist als Erweiterung (und nicht nur als Basis Klasse) implementiert
weil es ein gültiges *RSS* Modul dupliziert - so kann man Atom Elemente in *RSS* Feeds einfügen. Wir haben sogar
*RDF* Feeds gesehen die viel von Atom verwenden statt den üblicheren Erweiterungen wie Dublin Core.

.. table:: Nicht-Core Erweiterungen (müssen per Hand registriert werden)

   +---------------+-------------------------------------------------------------------------------------------------------------------------------------------+
   |Syndication    |Implementiert Unterstützung für Syndication 1.0 RSS Feeds                                                                                  |
   +---------------+-------------------------------------------------------------------------------------------------------------------------------------------+
   |CreativeCommons|Ein RSS Modul das ein Element auf <channel> oder <item> Level hinzufügt welches spezifiziert welche Creative Commons Lizenz anzuwenden ist.|
   +---------------+-------------------------------------------------------------------------------------------------------------------------------------------+

Die zusätzlichen nicht-Core Erweiterungen werden angeboten aber standardmäßig bei ``Zend\Feed\Reader`` nicht
registriert. Wenn man Sie verwenden will, muß man ``Zend\Feed\Reader`` sagen dass Sie diese zusätzlich zum
Importieren eines Feeds laden soll. Zusätzliche nicht-Core Erweiterungen werden in zukünftigen Releases dieser
Komponente enthalten sein.

Das Registrieren einer Erweiterung bei ``Zend\Feed\Reader``, so dass diese geladen wird und dessen *API* für Feed
und Entry Objekte zur Verfügung steht, ist eine einfache Sache wenn der ``Zend\Loader\PluginLoader`` verwendet
wird. Hier registrieren wir die optionale Slash Erweiterung und finden heraus das Sie direkt von der Entry Level
*API* heraus aufgerufen werden kann, ohne große Dinge notwendig sind. Es ist zu beachten das die Namen der
Erweiterungen von der Schreibweise abhängig sind und Camel Casing für mehrere Ausdrücke verwenden.

.. code-block:: php
   :linenos:

   Zend\Feed\Reader::registerExtension('Syndication');
   $feed = Zend\Feed\Reader::import('http://rss.slashdot.org/Slashdot/slashdot');
   $updatePeriod = $feed->current()->getUpdatePeriod();

Im obigen Beispiel haben wir geprüft wie oft ein Feed aktualisiert wurde indem wir die ``getUpdatePeriod()``
Methode verwendet haben. Da das nicht Teil der Kern *API* von ``Zend\Feed\Reader`` ist, kann es nur eine Methode
sein die von der neu registrieren Syndication Erweiterung unterstützt wird.

Wie man auch sieht, kann man auf die neuen Methoden vlon Erweiterungen aus der Haupt *API* heraus zugreifen indem
*PHP*'s magische Methoden verwendet werden. Als Alternative kann man, für ein ähnliches Ergebnis, auf jedes
Erweiterungs Objekt auch direkt zugreifen, wie anbei gezeigt.

.. code-block:: php
   :linenos:

   Zend\Feed\Reader::registerExtension('Syndication');
   $feed = Zend\Feed\Reader::import('http://rss.slashdot.org/Slashdot/slashdot');
   $syndication = $feed->getExtension('Syndication');
   $updatePeriod = $syndication->getUpdatePeriod();

.. _zend.feed.reader.extending.feed:

Erweiterungen für Zend\Feed\Reader schreiben
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Unweigerlich gibt es Zeiten in denen die *API* von ``Zend\Feed\Reader`` einfach nicht in der Lage ist etwas das man
von einem Feed oder Eintrag benötigt zu erhalten. Man kann die darunterliegenden Quell Objekte, wie ein
DOMDocument, verwenden um Sie von Hand zu erhalten. Trotzdem sind weitere wiederverwendbare Methoden vorhanden
indem man Erweiterungen schreibt die diese neuen Abfragen unterstützen.

Als Beispiel nehmen wir den Fall eine komplett fiktiven Firma an die Jungle Books heißt. Jungle Books hat eine
Vielzahl an Reviews für Bücher veröffentlicht die Sie verkaufen (von externen Quellen und Kunden), welche als
*RSS* 2.0 Feed verteilt werden. Die Marketing Abteilung realisiert das Web Anwendungen welche diesen Feed
verwenden, aktuell nicht herausfinden können welches Buch exakt betrachtet wird. Um jedem das Leben leichter zu
machen entscheiden Sie dass die Streber Abteilung *RSS* 2.0 erweitern muß um ein neues Element pro Eintrag
hinzuzufügen das die *ISBN*-10 oder *ISBN*-13 Zahl der Veröffentlichung die der Eintrag betrifft unterstützt.
Sie definieren das neue ``<isbn>`` Element recht einfach mit dem standardmäßigen Namen und Namespace *URI*:

.. code-block:: php
   :linenos:

   JungleBooks 1.0:
   http://example.com/junglebooks/rss/module/1.0/

Ein Teil des *RSS* das diese Erweiterung in der Praxis enthält könnte in etwa so aussehen:

.. code-block:: php
   :linenos:

   <?xml version="1.0" encoding="utf-8" ?>
   <rss version="2.0"
      xmlns:content="http://purl.org/rss/1.0/modules/content/"
      xmlns:jungle="http://example.com/junglebooks/rss/module/1.0/">
   <channel>
       <title>Jungle Books Customer Reviews</title>
       <link>http://example.com/junglebooks</link>
       <description>Many book reviews!</description>
       <pubDate>Fri, 26 Jun 2009 19:15:10 GMT</pubDate>
       <jungle:dayPopular>
           http://example.com/junglebooks/book/938
       </jungle:dayPopular>
       <item>
           <title>Review Of Flatland: A Romance of Many Dimensions</title>
           <link>http://example.com/junglebooks/review/987</link>
           <author>Confused Physics Student</author>
           <content:encoded>
           A romantic square?!
           </content:encoded>
           <pubDate>Thu, 25 Jun 2009 20:03:28 -0700</pubDate>
           <jungle:isbn>048627263X</jungle:isbn>
       </item>
   </channel>
   </rss>

Die Implementierung dieses neuen *ISBN* Elements als eine einfache Eintrags Level Erweiterung wird die folgende
Klasse benötigen (und die Verwendung des eigenen Klassen Namespaces ausserhalb von Zend).

.. code-block:: php
   :linenos:

   class My_FeedReader_Extension_JungleBooks_Entry
       extends Zend\Feed\Reader\Extension\EntryAbstract
   {
       public function getIsbn()
       {
           if (isset($this->_data['isbn'])) {
               return $this->_data['isbn'];
           }
           $isbn = $this->_xpath->evaluate(
               'string(' . $this->getXpathPrefix() . '/jungle:isbn)'
           );
           if (!$isbn) {
               $isbn = null;
           }
           $this->_data['isbn'] = $isbn;
           return $this->_data['isbn'];
       }

       protected function _registerNamespaces()
       {
           $this->_xpath->registerNamespace(
               'jungle', 'http://example.com/junglebooks/rss/module/1.0/'
           );
       }
   }

Diese Erweiterung ist einfach genug um Ihr zu folgen. Sie erstellt eine neue Methode ``getIsbn()``, welche eine
XPath Abfrage auf dem aktuellen Eintrag durchführt, um die *ISBN* Nummer welche vom ``<jungle:isbn>`` Element
umhüllt ist, zu extrahieren. Das kann optional auch im internen nicht-persistenten Cache gespeichert werden (keine
Notwendigkeit den *DOM* abzufragen wenn es auf dem gleichen Eintrag nochmals aufgerufen wird). Der Wert wird dem
Anrufer zurückgegeben. Am Ende haben wir eine geschützte Methode (Sie ist abstrakt, muss also existieren) welche
den Jungle Books Namespace für Ihre eigenen *RSS* Module registriert. Wärend wir das ein *RSS* Modul nennen, gibt
es nichts das verhindert dass das gleiche Element in Atom Feeds verwendet wird - und alle Erweiterungen welche den
Prefix verwenden der von ``getXpathPrefix()`` angeboten wird, sind aktuell neutral und arbeiten auf *RSS* oder Atom
Feeds ohne zusätzlichen Code.

Da die Erweiterung ausserhalb vom Zend Framework gespeichert ist, muss man den Pfad Prefix für die eigenen
Erweiterungen registrieren damit ``Zend\Loader\PluginLoader`` diese finden kann. Danach ist es einfach ein Problem
der Registrierung der Erweiterung, wenn diese nicht bereits geladen wurde, und deren Verwendung in der Praxis.

.. code-block:: php
   :linenos:

   if(!Zend\Feed\Reader::isRegistered('JungleBooks')) {
       Zend\Feed\Reader::addPrefixPath(
           'My_FeedReader_Extension', '/path/to/My/FeedReader/Extension'
       );
       Zend\Feed\Reader::registerExtension('JungleBooks');
   }
   $feed = Zend\Feed\Reader::import('http://example.com/junglebooks/rss');

   // ISBN für irgendein Buch dem der erste Eintrag im Feed gewidmet war
   $firstIsbn = $feed->current()->getIsbn();

Das Schreiben einer Feed Level Erweiterung unterscheidet sich nicht sehr. Der Beispiel Feed von vorher enthält ein
nicht erwähntes ``<jungle:dayPopular>`` Element das Jungle Books bei Ihrem Standard hinzugefügt haben um einen
Link zum beliebtesten Buch des Tages hinzuzufügen (im Sinne von Verkehr der Besucher). Hier ist eine Erweiterung
welche eine ``getDaysPopularBookLink()`` Methode bei der Feed Level *API* hinzufügt.

.. code-block:: php
   :linenos:

   class My_FeedReader_Extension_JungleBooks_Feed
       extends Zend\Feed\Reader\Extension\FeedAbstract
   {
       public function getDaysPopularBookLink()
       {
           if (isset($this->_data['dayPopular'])) {
               return $this->_data['dayPopular'];
           }
           $dayPopular = $this->_xpath->evaluate(
               'string(' . $this->getXpathPrefix() . '/jungle:dayPopular)'
           );
           if (!$dayPopular) {
               $dayPopular = null;
           }
           $this->_data['dayPopular'] = $dayPopular;
           return $this->_data['dayPopular'];
       }

       protected function _registerNamespaces()
       {
           $this->_xpath->registerNamespace(
               'jungle', 'http://example.com/junglebooks/rss/module/1.0/'
           );
       }
   }

Wiederholen wir das letzte Beispiel der Verwendung einer eigenen Erweiterung um zu zeigen wie die Methode verwendet
wird.

.. code-block:: php
   :linenos:

   if (!Zend\Feed\Reader::isRegistered('JungleBooks')) {
       Zend\Feed\Reader::addPrefixPath(
           'My_FeedReader_Extension', '/path/to/My/FeedReader/Extension'
       );
       Zend\Feed\Reader::registerExtension('JungleBooks');
   }
   $feed = Zend\Feed\Reader::import('http://example.com/junglebooks/rss');

   // URI zur Informations-Seite des populärsten Buchs des Tages mit Besuchern
   $daysPopularBookLink = $feed->getDaysPopularBookLink();

   // ISBN für irgendein Buch dem der erste Eintrag im Feed gewidmet war
   $firstIsbn = $feed->current()->getIsbn();

Beim Betrachten dieser Beispiele, konnte man sehen das wir Feed und Eintrags Erweiterungen nicht separat
registriert haben. Erweiterungen im selben Standard können sowohl eine Feed und Entry Klasse enthalten oder auch
nicht, sodas ``Zend\Feed\Reader`` nur die Registrierung des darüberliegenden Eltern Namens benötigt, z.B.
JungleBooks, DublinCore, Slash. Intern kann sie prüfen für welchen Level Erweiterungen existieren und und diese
Laden wenn Sie gefunden werden. In unserem Fall haben wir jetzt ein komplettes Set von Erweiterungen:
``JungleBooks_Feed`` und ``JungleBooks_Entry``.


