.. EN-Revision: none
.. _zend.feed.writer:

Zend\Feed\Writer
================

.. _zend.feed.writer.introduction:

Einführung
----------

``Zend\Feed\Writer`` ist die Bruderkomponente zu ``Zend\Feed\Reader`` und verantwortlich für die Erzeugung von
Feeds für die Ausgabe. Sie unterstützt die Atom 1.0 Spezifikation (*RFC* 4287) und *RSS* 2.0 wie vom *RSS*
Advisory Board (*RSS* 2.0.11) spezifiziert. Es weicht nicht von diesen Standards ab. Trotzdem bietet es ein
einfaches System der Erweiterung, welches es erlaubt jede Erweiterung und jedes Modul für jede der zwei
Spezifikationen zu implementieren, wenn diese nicht von Haus aus angeboten werden.

In vieler Hinsicht ist ``Zend\Feed\Writer`` das Gegenteil von ``Zend\Feed\Reader``. Während ``Zend\Feed\Reader``
darauf abzielt, eine einfach zu verwendende Architektur zur Verfügung zu stellen, die sich durch Getter-Methoden
auszeichnet, stellt ``Zend\Feed\Writer`` ähnlich benannte Setter oder Mutatoren bereit. Das stellt sicher, dass
die *API* keine weitere Lernkurve aufwirft, wenn sich jemand bereits mit ``Zend\Feed\Reader`` auskennt.

Als Ergebnis dieses Designs ist der Rest nämlich einleuchtend. Hinter den Kulissen wird jedes Datenset eines
``Zend\Feed\Writer``-Daten-Containers während der Darstellungszeit in ein DOMDocument-Objekt übersetzt, indem die
notwendigen Feed-Elemente verwendet werden. Für jeden unterstützten Feed-Typen gibt es beide, sowohl einen Atom
1.0 als auch einen *RSS* 2.0 Renderer. Die Verwendung der DOMDocument-Klasse statt einer Templatelösung hat viele
Vorteile. Der offensichtlichste ist die Möglichkeit das DOMDocument zu exportieren, um es weiter zu bearbeiten und
sich auf *PHP* *DOM* für die korrekte und richtige Darstellung zu verlassen.

Wie bei ``Zend\Feed\Reader`` ist ``Zend\Feed\Writer`` ein alleinstehender Ersatz für ``Zend_Feed``\ s
Builder-Architektur und nicht kompatibel mit diesen Klassen.

.. _zend.feed.writer.architecture:

Architektur
-----------

Die Architektur von ``Zend\Feed\Writer`` ist sehr einfach. Es hat zwei Kernsets von Klassen: Daten-Container und
Renderer.

Der Container enthält die Klassen ``Zend\Feed\Writer\Feed`` und ``Zend\Feed\Writer\Entry``. Die Einstiegsklassen
können bei jeder Feed-Klasse angehängt werden. Der einzige Zweck dieses Containers ist es, Daten über den zu
erstellenden Feed zu sammeln, indem ein einfaches Interface von Setter-Methoden verwendet wird. Diese Methoden
führen einige Test zur Datenprüfung durch. Zum Beispiel prüft er übergebene *URI*\ s, Datum, usw. Diese
Prüfungen sind nicht an einen der Feed-Standarddefinitionen gebunden. Das Container-Objekt enthält auch Methoden,
welche die schnelle Darstellung und den Export des endgültigen Feeds erlauben und sie können auf Wunsch
wiederverwendet werden.

Zusätzlich zu den hauptsächlichen Datencontainerklassen gibt es zwei Atom 2.0 spezifische Klassen.
``Zend\Feed\Writer\Source`` und ``Zend\Feed\Writer\Deleted``. Die erstere implementiert Atom 2.0 Quell-Elemente,
welche Feed-Metadaten der Quelle für spezielle Einträge im verwendeten Feed enthalten (z.B. wenn der aktuelle
Feed nicht die originale Quelle des Eintrags enthält). Die letztere implementiert Atom Tombstones *RFC* und
erlaubt es Feeds, Referenzen zu Einträgen zu haben, welche bereits gelöscht wurden.

Während es zwei hauptsächliche Datencontainer-Typen gibt, gibt es vier Renderer - zwei passende
Container-Renderer pro unterstütztem Feedtyp. Jeder Renderer akzeptiert einen Container, und basierend auf seinem
Container versucht er ein gültiges Feed-Markup zu erstellen. Wenn der Renderer nicht in der Lage ist, ein
gültiges Feed-Markup zu erstellen, möglicherweise weil dem Container ein obligatorischer Datenpunkt fehlt, dann
wird er dies melden, indem eine ``Exception`` geworfen wird. Während es möglich ist ``Exception``\ s zu
ignorieren, würde dies die standardmäßige Schutzvorrichtung entfernen, welche sicherstellt, dass gültige Daten
gesetzt wurden, um einen komplett gültigen Feed darzustellen.

Um dies etwas genauer zu erklären, kann man ein Set von Datencontainern für einen Feed erstellen, wobei es einen
Feed-Container gibt, in dem einige Entry-Container hinzugefügt wurden und ein Deleted (gelöschter) Container.
Dies formt eine Datenhierarchie, die einen normalen Feed nachstellt. Wenn die Darstellung durchgeführt wird, dann
übergibt diese Hierarchie ihre Teile den betreffenden Darstellern und die partiellen Feeds (alle DOMDocuments)
werden dann zusammen geworfen, um einen kompletten Feed zu erstellen. Im Falle von Source oder Deleted (Tomestone)
Containern werden diese nur für Atom 2.0 dargestellt und für *RSS* ignoriert.

Da das System in Datencontainer und Renderer aufgeteilt ist, sind Erweiterungen interessant. Eine typische
Erweiterung, welche Namespaced Feeds und Entry Level Elemente bietet, muss selbst exakt die gleiche Architektur
reflektieren, z.B. anbieten von Feed und Entry Level Daten Containern und passenden Renderern. Das ist
glücklicherweise keine komplexe Integrationsarbeit, da alle Erweiterungsklassen einfach registriert und
automatisch von den Kernklassen verwendet werden. Wir kommen später in diesem Kapitel im Detail zu den
Erweiterungen.

.. _zend.feed.writer.getting.started:

Beginnen
--------

Die Verwendung von ``Zend\Feed\Reader`` ist so einfach wie das Setzen von Daten und dem Ausführen des Renderers.
Hier ist ein Beispiel um einen minimalen Atom 1.0 Feed zu erstellen. Dies demonstriert dass jeder Feed oder Eintrag
einen eigenen Container verwendet.

.. code-block:: php
   :linenos:

   /**
    * Den Eltern Feed erstellen
    */
   $feed = new Zend\Feed\Writer\Feed;
   $feed->setTitle('Paddy\'s Blog');
   $feed->setLink('http://www.example.com');
   $feed->setFeedLink('http://www.example.com/atom', 'atom');
   $feed->addAuthor(array(
       'name'  => 'Paddy',
       'email' => 'paddy@example.com',
       'uri'   => 'http://www.example.com',
   ));
   $feed->setDateModified(time());
   $feed->addHub('http://pubsubhubbub.appspot.com/');

   /**
    * Einen oder mehrere Einträge hinzufügen. Beachten das Einträge
    * manuell hinzugefügt werden müssen sobald Sie erstellt wurden
    */
   $entry = $feed->createEntry();
   $entry->setTitle('All Your Base Are Belong To Us');
   $entry->setLink('http://www.example.com/all-your-base-are-belong-to-us');
   $entry->addAuthor(array(
       'name'  => 'Paddy',
       'email' => 'paddy@example.com',
       'uri'   => 'http://www.example.com',
   ));
   $entry->setDateModified(time());
   $entry->setDateCreated(time());
   $entry->setDescription(
       'Die Schwierigkeiten erklären Spiele ins englische zu portieren.'
   );
   $entry->setContent(
       'Ich schreibe diesen Artikel nicht. Das Beispiel ist lang genug ;).');
   $feed->addEntry($entry);

   /**
    * Den ergebenden Feed in Atom 1.0 darstellen und $out zuordnen. Man kann
    * "atom" mit "rss" ersetzen um einen RSS 2.0 feed zu erstellen
    */
   $out = $feed->export('atom');

Die dargestellt Ausgabe sollte folgende sein:

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="utf-8"?>
   <feed xmlns="http://www.w3.org/2005/Atom">
       <title type="text">Paddy's Blog</title>
       <subtitle type="text">Writing about PC Games since 176 BC.</subtitle>
       <updated>2009-12-14T20:28:18+00:00</updated>
       <generator uri="http://framework.zend.com" version="1.10.0alpha">
           Zend\Feed\Writer
       </generator>
       <link rel="alternate" type="text/html" href="http://www.example.com"/>
       <link rel="self" type="application/atom+xml"
           href="http://www.example.com/atom"/>
       <id>http://www.example.com</id>
       <author>
           <name>Paddy</name>
           <email>paddy@example.com</email>
           <uri>http://www.example.com</uri>
       </author>
       <link rel="hub" href="http://pubsubhubbub.appspot.com/"/>
       <entry>
           <title type="html"><![CDATA[All Your Base Are Belong To
               Us]]></title>
           <summary type="html">
               <![CDATA[Exposing the difficultly of porting games to
                   English.]]>
           </summary>
           <published>2009-12-14T20:28:18+00:00</published>
           <updated>2009-12-14T20:28:18+00:00</updated>
           <link rel="alternate" type="text/html"
               href="http://www.example.com/all-your-base-are-belong-to-us"/>
           <id>http://www.example.com/all-your-base-are-belong-to-us</id>
           <author>
               <name>Paddy</name>
               <email>paddy@example.com</email>
               <uri>http://www.example.com</uri>
           </author>
           <content type="html">
               <![CDATA[I am not writing the article.
                        The example is long enough as is ;).]]>
           </content>
       </entry>
   </feed>

Das ist ein vollkommen gültiges Beispiel für Atom 1.0. Es sollte erwähnt werden, dass das Weglassen von
obligatorischen Teilen der Daten, wie dem Titel, zu einer ``Exception`` führt, wenn diese als Atom 1.0 dargestellt
werden. Anders ist das bei *RSS* 2.0, wo ein Titel weggelassen werden kann, solange eine Beschreibung vorhanden
ist. Dadurch werden Exceptions geworfen, die sich zwischen beiden Standards abhängig vom Renderer unterscheiden,
der verwendet wird. Vom Design her wird ``Zend\Feed\Writer`` keinen ungültigen Feed für einen Standard
übersetzen, außer der End-Benutzer entscheidet sich bewusst, alle Exceptions zu ignorieren. Diese eingebaute
Sicherheit wurde hinzugefügt, um sicherzustellen, dass sich Benutzer ohne tiefe Kenntnisse der betreffenden
Spezifikationen keine Sorgen machen müssen.

.. _zend.feed.writer.setting.feed.data.points:

Die Datenpunkte eines Feeds setzen
----------------------------------

Bevor ein Feed dargestellt werden kann, müssen zuerst die dafür notwendigen Daten gesetzt werden. Hierbei wird
eine einfache Setter-artige *API* verwendet, welche auch als initiale Methode für die Prüfung von Daten herhält,
wenn diese gesetzt werden. Vom Design her entspricht die *API* stark der von ``Zend\Feed\Reader``, um Unklarheiten
und Unsicherheiten zu vermeiden.

.. note::

   Benutzer haben angemerkt, dass das Nichtvorhandensein einer einfachen Array-Schreibweise für Eingabedaten zu
   langen Codeabschnitten führt. Das wird in zukünftigen Versionen behoben.

``Zend\Feed\Writer`` bietet diese *API* über seine Datencontainerklassen ``Zend\Feed\Writer\Feed`` und
``Zend\Feed\Writer\Entry`` an (nicht zu erwähnen die Atom 2.0 spezifischen Erweiterungsklassen). Diese Klassen
speichern nahezu alle Feed-Daten in einer vom Typ unabhängigen Art, was bedeutet, dass man jeden Datencontainer
mit jedem Renderer wiederverwenden kann, ohne dass zusätzliche Arbeit notwendig ist. Beide Klassen sind auch offen
für Erweiterungen, was bedeutet, dass eine Erweiterung ihre eigenen Containerklassen definieren kann, welche bei
den Basis-Containerklassen als Erweiterung registriert sind und geprüft werden, sobald irgendein Methodenaufruf
die ``__call()`` Methode des Basiscontainers auslöst.

Hier ist eine Zusammenfassung der Kern-*API* für Feeds. Man sollte beachten, dass sie nicht nur die Standards für
*RSS* und Atom umfasst, sondern auch eine Anzahl von Erweiterungen, welche in ``Zend\Feed\Writer`` enthalten sind.
Die Benennung dieser Erweiterungsmethoden ist recht generisch - alle Erweiterungsmethoden arbeiten auf dem gleichen
Level wie die Kern-*API*, da wir es erlauben, jedes Erweiterungsobjekt separat zu empfangen wenn das notwendig ist.

Die *API* für Daten auf Level des Feeds ist in ``Zend\Feed\Writer\Feed`` enthalten. Zusätzlich zu der anbei
beschriebenen *API*, implementiert die Klasse auch die Interfaces ``Countable`` und ``Iterator``.

.. table:: API Methoden auf Feed Level

   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setId()           |Setzt eine eindeutige ID, die mit diesem Feed assoziiert ist. Für Atom 1.0 ist das ein atom:id Element, und für RSS 2.0 wird es als guid Element hinzugefügt. Diese sind optional, solange ein Link hinzugefügt wird, wenn z.B. der Link als ID gesetzt ist.                                                                                                                                                                                                                                                                                                                                                               |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setTitle()        |Setzt den Titel des Feeds.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setDescription()  |Setzt die textuelle Beschreibung des Feeds.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setLink()         |Setzt eine URI zur HTML-Website, welche die gleichen oder ähnliche Informationen wie dieser Feed enthält (z.B. wenn der Feed von einem Blog ist, sollte er die URI des Blogs anbieten, unter der die HTML-Version der Einträge gelesen werden können).                                                                                                                                                                                                                                                                                                                                                                     |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setFeedLinks()    |Fügt einen Link zu einem XML-Feed hinzu, entweder der erzeugte Feed oder eine alternative URI zeigen auf den gleichen Feed, aber in einem anderen Format. Es ist mindestens notwendig einen Link zum erstellten Feed zu inkludieren, damit dieser eine identifizierbare endgültige URI hat, welche es dem Client erlaubt, Änderungen des Orts mitzubekommen, ohne dass dauernde Umleitungen notwendig sind. Dieser Parameter ist ein Array von Arrays, wobei jedes Unter-Array die Schlüssel "type" und "uri" enthält. Der Typ sollte "atom", "rss" oder "rdf" sein.                                                       |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addAuthors()      |Setzt die Daten für Autoren. Der Parameter ist ein Array von Arrays, wobei jedes Unter-Array die Schlüssel "name", "email" und "uri" enthalten kann. Der Wert "uri" ist nur für Atom Feeds anwendbar, da RSS keine Möglichkeit enthält diese anzuzeigen. Für RSS 2.0 werden bei der Darstellung zwei Elemente erzeugt - ein Autorelement, welches die Referenz zur Email und dem Namen in Klammern enthält und ein Dublin Core Creator Element, welches nur den Namen enthält.                                                                                                                                             |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addAuthor()       |Setzt die Daten für einen einzelnen Autor und folgt demselben Array-Format wie vorher für ein einzelnes Unter-Array beschrieben.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setDateCreated()  |Setzt das Datum, an dem dieser Feed erstellt wurde. Generell nur für Atom anwendbar, wo es das Datum beschreibt, zu der die Ressource, die von dem Atom 1.0 Dokument beschrieben wird, erstellt wurde. Der erwartete Parameter muss ein UNIX-Timestamp oder ein Zend_Date-Objekt sein.                                                                                                                                                                                                                                                                                                                                     |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setDateModified() |Setzt das Datum, an dem dieser Feed das letzte Mal geändert wurde. Der erwartete Parameter muss ein UNIX-Timestamp oder ein Zend_Date-Objekt sein.                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setLastBuildDate()|Setzt das Datum an dem der Feed das letzte mal erstellt wurde. Der erwartete Parameter kann ein UNIX Timestamp oder ein Zend_Date Objekt sein. Das wird nur für RSS 2.0 Feeds dargestellt und wird automatisch als aktuelles Datum dargestellt wenn er nicht explizit gesetzt wird.                                                                                                                                                                                                                                                                                                                                        |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setLanguage()     |Setzt die Sprache des Feeds. Diese wird unterdrückt, solange sie nicht gesetzt ist.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setGenerator()    |Erlaubt es einen Generator zu setzen. Der Parameter sollte ein Array sein, welches die Schlüssel "name", "version" und "uri" enthält. Wenn er unterdrückt wird, wird ein standardmäßiger Generator hinzugefügt, welcher auf Zend\Feed\Writer, die aktuelle Version des Zend Framework und die URI des Frameworks verweist.                                                                                                                                                                                                                                                                                                 |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setCopyright()    |Setzt eine Copyright-Notiz, die mit dem Feed assoziiert ist.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addHubs()         |Akzeptiert ein Array von Pubsubhubbub Hub Endpunkten, die im Feed als Atom-Links dargestellt werden, damit PuSH-Abonnenten den eigenen Feed abbonieren können. Es ist zu beachten, dass man einen Pubsubhubbub Herausgeber implementieren muss, damit Real-Time-Updates ermöglicht werden. Ein Herausgeber kann implementiert werden, indem Zend\Feed\Pubsubhubbub\Publisher verwendet wird. Die Methode addHub() erlaubt es gleichzeitig nur einen Hub hinzuzufügen.                                                                                                                                                      |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addCategories()   |Akzeptiert ein Array an Kategorien für die Darstellung, wobei jedes Element selbst ein Array ist, dessen mögliche Schlüssel "term", "label" und "scheme" enthalten. "term" ist typischerweise der Name einer Kategorie, welche für die Aufnahme in einer URI passen. "label" kann ein menschenlesbarer Name einer Kategorie sein, der spezielle Zeichen unterstützt (er wird während der Darstellung kodiert) und ist ein benötigter Schlüssel. "scheme" (im RSS auch die Domain genannt) ist optional, muss aber eine gültige URI sein. Die Methode addCategory() erlaubt es gleichzeitig nur eine Kategorie hinzuzufügen.|
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setImage()        |Akzeptiert ein Array an Metadaten für Bilder für ein RSS Bild oder ein Atom Logo. Atom 1.0 benötigt nur eine URI. RSS 2.0 benötigt eine URI, einen HTML Link, und einen Bildtitel. RSS 2.0 kann optional eine Breite, eine Höhe und eine Beschreibung des Bildes senden. Die Array Parameter können Sie enthalten indem die folgenden Schlüssel verwendet werden: uri, link, title, description, height und width. Der RSS 2.0 HTML Link sollte auf die HTML Quellseite des Feeds zeigen.                                                                                                                                  |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |createEntry()     |Gibt eine neue Instanz von Zend\Feed\Writer\Entry zurück. Das ist der Daten Container auf der Ebene des Eintrags. Neue Einträge müssen addEntry() explizit aufrufen, um Einträge für die Darstellung hinzuzufügen.                                                                                                                                                                                                                                                                                                                                                                                                         |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addEntry()        |Fügt eine Instanz von Zend\Feed\Writer\Entry zum aktuellen Feed Container für die Darstellung hinzu.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |createTombstone() |Gibt eine neue Instanz von Zend\Feed\Writer\Deleted zurück. Das ist der Daten Container auf Level des Atom 2.0 Tombstone. Neue Einträge werden dem aktuellen Feed nicht automatisch zugeordnet. Man muss also addTombstone() explizit aufrufen um den gelöschten Eintrag für die Darstellung hinzuzufügen.                                                                                                                                                                                                                                                                                                                 |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addTombstone()    |Fügt dem aktuellen Feed Container eine Instanz von Zend\Feed\Writer\Deleted für die Darstellung hinzu.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |removeEntry()     |Akzeptiert einen Parameter, der den Array-Index eines Eintrags bestimmt, welcher vom Feed zu entfernen ist.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |export()          |Exportiert die komplette Datenhierarchie in einen XML Feed. Die Methode has zwei Parameter. Der erste ist der Feedtyp, entweder "atom" oder "rss". Der zweite in ein optionaler Boolean-Wert, der zeigt ob Exceptions geworfen werden oder nicht. Er ist standardmäßig TRUE.                                                                                                                                                                                                                                                                                                                                               |
   +------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. note::

   Zusätzlich zu diesen Settern gibt es passende Getter, um Daten von den Eintrags-Daten-Containern zu erhalten.
   Zum Beispiel gibt es zu ``setImage()`` eine passende

.. _zend.feed.writer.setting.entry.data.points:

Setzen der Datenpunkte für Einträge
-----------------------------------

Hier ist eine Zusammenfassung der Kern-*API* für Einträge und Elemente. Man sollte beachten, dass dies nicht nur
die Standards für *RSS* und Atom umfasst, sondern auch eine Anzahl von Erweiterungen, welche in
``Zend\Feed\Writer`` enthalten sind. Die Benennung dieser Erweiterungsmethoden ist recht generisch - alle
Erweiterungsmethoden arbeiten auf der gleichen Ebene wie die Kern-*API*, da wir es zulassen, jedes
Erweiterungsobjekt separat zu empfangen, wenn das notwendig ist.

Die *API* auf Level des Eintrags ist in ``Zend\Feed\Writer\Entry`` enthalten.

.. table:: API-Methoden auf Eintragsebene

   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setId()              |Setzt eine eindeutige ID, die mit diesem Eintrag assoziiert ist. Für Atom 1.0 ist das ein atom:id Element und für RSS 2.0 wird es als guid-Element hinzugefügt. Diese sind optional, solange ein Link hinzugefügt wird, wenn z.B. der Link als ID gesetzt ist.                                                                                                                                                                                                                                                                                                                                                                                                           |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setTitle()           |Setzt den Titel des Eintrags.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setDescription()     |Setzt die textuelle Beschreibung des Eintrags.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setContent()         |Setzt den Inhalt des Eintrags.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setLink()            |Setzt eine URI zur HTML-Website, welche die gleichen oder ähnliche Informationen wie dieser Eintrag enthält (z.B. wenn der Feed von einem Blog ist, sollte er die URI des Blog Artikels anbieten, unter welcher die HTML-Version des Eintrags gelesen werden kann).                                                                                                                                                                                                                                                                                                                                                                                                      |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setFeedLinks()       |Fügt einen Link zu einem XML-Feed hinzu, entweder der erzeugte Feed oder eine alternative URI, dieauf den gleichen Feed zeigt, aber in einem anderen Format. Es wird empfohlen, mindestens einen Link zum erstellten Feed zu aufzunehmen, damit dieser eine erkennbare endgültige URI hat, welche es dem Client erlaubt, Ortswechsel mitzubekommen, ohne dass dauernde Umleitungen notwendig sind. Dieser Parameter ist ein Array von Arrays, wobei jedes Unter-Array die Schlüssel "type" und "uri" enthält. Der Typ sollte "atom", "rss" oder "rdf" sein. Wenn der Typ weggelassen wird, ist er standardmäßig mit dem Typ identisch, mit dem der Feed dargestellt wird.|
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addAuthors()         |Setzt die Daten für Autoren. Der Parameter ist ein Array von Arrays wobei jedes Unter-Array die Schlüssel "name", "email" und "uri" enthalten kann. Der Wert "uri" ist nur für Atom-Feeds anwendbar, da RSS keine Möglichkeit enthält, diese anzuzeigen. Für RSS 2.0 werden bei der Darstellung zwei Elemente erzeugt - ein Autorelement, welches die Referenz zur Email und den Namen in Klammern enthält und ein Dublin Core Creator Element, welches nur den Namen enthält.                                                                                                                                                                                           |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addAuthor()          |Setzt die Daten für einen einzelnen Autor und folgt demselben Format wie vorher für ein einzelnes Unter-Array beschrieben.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setDateCreated()     |Setzt das Datum, an dem dieser Feed erstellt wurde. Generell nur für Atom anwendbar, wo es das Datum beschreibt an dem die Ressource, die von dem Atom 1.0 Dokument beschrieben wird, erstellt wurde. Der erwartete Parameter muss ein UNIX-Timestamp oder ein Zend_Date-Objekt sein. Wenn es nicht angegeben wird, dann wird das verwendete Datum das aktuelle Datum und die aktuelle Zeit sein.                                                                                                                                                                                                                                                                        |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setDateModified()    |Setzt das Datum, an dem dieser Feed das letzte Mal geändert wurde. Der erwartete Parameter muss ein UNIX-Timestamp oder ein Zend_Date-Objekt sein. Wenn es nicht angegeben wird, dann wird das verwendete Datum das aktuelle Datum und die aktuelle Zeit sein.                                                                                                                                                                                                                                                                                                                                                                                                           |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setCopyright()       |Setzt eine Copyright-Notiz, welche mit dem Feed assoziiert wird.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setCategories()      |Akzeptiert ein Array von Kategorien für die Darstellung, wobei jedes Element selbst ein Array ist, dessen möglich Schlüssel "term", "label" und "scheme" enthalten. "term" ist typischerweise der Name einer Kategorie, welche für die Aufnahme in einer URI passen. "label" kann ein menschenlesbarer Name einer Kategorie sein, der spezielle Zeichen unterstützt (er wird während der Darstellung kodiert) und ist ein benötigter Schlüssel. "scheme" (im RSS auch die Domain genannt) ist optional, muss aber eine gültige URI sein.                                                                                                                                 |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setCommentCount()    |Setzt die Anzahl an Kommentaren, welche mit diesem Eintrag verbunden sind. Die Darstellung unterscheidet sich zwischen RSS und Atom 2.0 abhängig vom benötigten Element oder Attribut.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setCommentLink()     |Setzt einen Link zu einer HTML Seite, welche Kommentare enthält, die mit diesem Eintrag assoziiert sind.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setCommentFeedLink() |Setzt einen Link zu einem XML-Feed, der Kommentare enthält, welche mit diesem Eintrag assoziiert sind. Der Parameter ist ein Array, welches die Schlüssel "uri" und "type" enthält, wobei der Typ entweder "rdf", "rss" oder "atom" ist.                                                                                                                                                                                                                                                                                                                                                                                                                                 |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setCommentFeedLinks()|Das gleiche wie setCommentFeedLink(), außer dass sie ein Array von Arrays akzeptiert, wobei jedes Unterarray die von setCommentFeedLink() erwarteten Parameter enthält.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |setEncoding()        |Setzt die Kodierung des Textes des Eintrags. Diese ist standardmäßig UTF-8, welche auch die bevorzugte Kodierung ist.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
   +---------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. note::

   Zusätzlich zu diesen Settern gibt es passende Getter, um Daten von den Eintrags-Daten-Containern zu erhalten.


