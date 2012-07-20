.. _zend.search.lucene.best-practice:

Die besten Anwendungen
======================

.. _zend.search.lucene.best-practice.field-names:

Feldnamen
---------

Es gibt keine Begrenzungen für Feldnamen in ``Zend_Search_Lucene``.

Trotzdem ist es eine gute Idee die '**id**' und '**score**' Namen nicht zu verwenden um Doppeldeutigkeiten in den
Namen der ``QueryHit`` Eigenschaften zu verhindern.

Die ``Zend_Search_Lucene_Search_QueryHit`` ``id`` und ``score`` Eigenschaften referieren immer zur internen Lucene
Dokumenten Id und Treffer-:ref:`Anzahl <zend.search.lucene.searching.results-scoring>`. Wenn ein indiziertes
Dokument die gleichen Felder gespeichert hat, muß die ``getDocument()`` Methode verwendet werden um auf Sie
zuzugreifen:

.. code-block:: php
   :linenos:

   $hits = $index->find($query);

   foreach ($hits as $hit) {
       // Das 'title' Dokumentfeld erhalten
       $title = $hit->title;

       // Das 'contents' Dokumentfeld erhalten
       $contents = $hit->contents;

       // Die interne Lucene Dokument ID erhalten
       $id = $hit->id;

       // Die Anzahl der Abfragetreffer erhalten
       $score = $hit->score;

       // Das 'id' Dokumentfeld erhalten
       $docId = $hit->getDocument()->id;

       // Das 'score' Dokumentfeld erhalten
       $docId = $hit->getDocument()->score;

       // Ein anderer Weg um das 'title' Dokumentfeld zu erhalten
       $title = $hit->getDocument()->title;
   }

.. _zend.search.lucene.best-practice.indexing-performance:

Geschwindigkeit von Indezes
---------------------------

Die Geschwindigkeit von Indezes ist ein Kompromiss zwischen verwendeten Ressourcen, der Zeit für das Indizieren
und die Qualität des Index.

Die Qualität des Index wird komplett eruiert durch die Anzahl an Indexsegmenten.

Jedes Indexsegment ist ein komplett unabhängiger Teil von Daten. Deshalb benötigt ein Index der mehr Segmente
hat, auch mehr Speicher und mehr Zeit für das Suchen.

Indexoptimierung ist ein Prozess der mehrere Segmente in ein neues zusammenfügt. Ein komplett optimierter Index
enthält nur ein Segment.

Komplette Indexoptimierung kann mit der ``optimize()`` Methode durchgeführt werden:

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::open($indexPath);

   $index->optimize();

Index Optimierung arbeitet mit Daten Streams und benötigt nicht viel Speicher dafür aber Prozessorzessourcen und
Zeit.

Lucene Index Segmente sind nicht aktualisierbar durch Ihre Natur (eine Aktualisierung erfordert das die Segment
Datei komplett neu geschrieben wird). Deshalb erzeugt das Hinzufügen neuer Dokumente zu einem Index auch immer ein
neues Segment. Das verkleinert natürlich die Qualität des Index.

Der automatische Optimierungsprozess des Index wird nach jeder Erstellung eines Segments durchgeführt und besteht
darin das Teilsegmente zusammengeführt werden.

Es gibt drei Optionen um das Verhalten der automatischen Optimierung zu beeinflussen (siehe das Kapitel :ref:`Index
Optimierung <zend.search.lucene.index-creation.optimization>`):



   - **MaxBufferedDocs** ist die Anzahl an Dokumenten die im Speicher gepuffert werden bevor ein neues Segment
     erstellt und auf die Festplatte geschrieben wird.

   - **MaxMergeDocs** ist die maximale Anzahl an Dokumenten die durch den automatischen Optimierungsprozess in ein
     neues Segment zusamengeführt werden.

   - **MergeFactor** ermittelt wie oft die automatische Optimierung durchgeführt wird.



   .. note::

      Alle diese Optionen sind Objekteigenschaften von ``Zend_Search_Lucene``, aber keine Indexeigenschaften. Sie
      beeinflussen nur das Verhalten des aktuellen ``Zend_Search_Lucene`` Objekts und können sich für
      verschiedene Skripte unterscheiden.



**MaxBufferedDocs** hat keinen Effekt wenn nur ein Dokument pro Skriptausführung indiziert wird. Auf der anderen
Seite ist das sehr wichtig für die Indizierung per Batch. Größere Werte erhöhen die Geschwindigkeit des
Indizierens, benötigen aber auch mehr Speicher.

Es gibt einfach keinen Weg um den besten Wert für den **MaxBufferedDocs** Parameter zu berechnen weil es von der
durchschnittlichen Größe des Dokuments abhängt, dem verwendeten Analysator und dem erlaubten Speicher.

Ein guter Weg um den richtigen Wert herauszufinden, ist die Durchführung von verschiedenen Tests mit den größten
Dokumenten von denen man erwartet das Sie indiziert werden. [#]_ Es ist eine gute Praxis nicht mehr als die Hälfte
des erlaubten Speichers zu verwenden.

**MaxMergeDocs** limitiert die Größe des Segments (in Dokumenten). Es begrenzt also die Zeit für die
automatische Optimierung indem es garantiert das die ``addDocument()`` Methode nur eine bestimmte Anzahl oft
ausgeführt wird. Das ist für interaktive Anwendungen sehr wichtig.

Das Verkleinern des **MaxMergeDocs** Parameters kann auch die Geschwindigkeit des Batchinzieierens beeinflussen.
Automatische Optimierung des Index ist ein iterativer Prozess und wird Schritt für Schritt durchgeführt. Kleine
Segmente werden in größere zusammengeführt, und irgendwann werden Sie in sogar noch größere zusammengeführt
und so weiter. Komplette Optimierung des Index wird durchgeführt wenn nur mehr ein großes Segment überbleibt.

Kleinere Segmente verkleinern generell die Qualität des Index. Viele kleine Segmente können auch zu einem "Too
many open files" Fehler führen, ausgelöst durch die Beschränkungen des Betriebsystems. [#]_

Generell sollte die Optimierung des Index für einen interaktiven Modus des Indizierens im Hintergrund
durchgeführt werden und **MaxMergeDocs** sollte für die nicht zu klein für die Indizierung per Batch sein.

**MergeFactor** beeinflußt die Frequenz der automatischen Optimierung. Kleinere Werte erhöhen die Qualität des
nicht optimierten Index. Größere Werte erhöhen die Geschwindigkeit des Indizierens, aber auch die Anzahl an
Segmenten. Das wiederum kann wieder zu einem "Too many open files" Fehler führen.

**MergeFactor** gruppiert Indexsegmente anhand Ihrer Größe:



   . Nicht größer als **MaxBufferedDocs**.

   . Größer als **MaxBufferedDocs**, aber nicht größer als **MaxBufferedDocs**\ * **MergeFactor**.

   . Größer als **MaxBufferedDocs**\ * **MergeFactor**, aber nicht größer als **MaxBufferedDocs**\ *
     **MergeFactor**\ * **MergeFactor**.

   . ...



``Zend_Search_Lucene`` prüft wärend jedem Aufruf von ``addDocument()`` ob das Zusammenführen von Segmentgruppen
dazu führt das neu erstellte Segmente in die nächste Gruppe verschoben werden. Wenn ja, wird das Zusammenführen
durchgeführt.

Also kann ein Index mit N Gruppen **MaxBufferedDocs** + (N-1)* **MergeFactor** Segmente und zumindest
**MaxBufferedDocs**\ * **MergeFactor** :sup:`(N-1)`  Dokumente enthalten.

Das gibt eine gute Annäherung für die Anzahl an Segmenten im Index:

**NumberOfSegments** <= **MaxBufferedDocs** + **MergeFactor**\ *log **MergeFactor**
(**NumberOfDocuments**/**MaxBufferedDocs**)

**MaxBufferedDocs** wird durch den erlaubten Speicher eruiert. Das erlaubt es dem gewünschten Faktor für das
Zusammenführen eine erwünschte Anzahl an Segmenten zu erhalten.

Das Tunen des **MergeFactor** Parameters ist effektiver für die Geschwindigkeit der Indizierens per Batch als
**MaxMergeDocs**. Aber es ist auch gröber. Deshalb sollte die obige Annäherung für das Tunen des
**MergeFactor**'s verwendet werden und anschließend mit **MaxMergeDocs** herumgespielt werden um die beste
Geschwindigkeit für die Indizieren per Batch zu erhalten.

.. _zend.search.lucene.best-practice.shutting-down:

Index wärend des Herunterfahrens
--------------------------------

Die ``Zend_Search_Lucene`` Instanz führt einiges an Arbeit während des Herunterfahrens durch, wenn Dokumente zum
Index hinzugefügt aber nicht in ein neues Segment geschrieben wurden.

Das kann auch einen automatischen Optimierungsprozess anwerfen.

Das Indexobjekt wird automatisch geschlossen wenn es, und alle zurückgegebenen QueryHit Objekte, ausserhalb des
Sichtbereichs sind.

Wenn das Indexobjekt in einer globalen Variable gespeichert wird, wird es nur am Ende der Skriptausführung
zerstört [#]_.

Die Behandlung von *PHP* Ausnahmen wird in diesem Moment auch Herunterfahren.

Das beeinflußt den normalen Shutdown Prozess des Index nicht, kann aber eine akurate Diagnostik von Fehlern
verhindern wenn ein Fehler wärend des herunterfahrens stattfindet.

Es gibt zwei Wege mit denen dieses Problem verhindert werden kann.

Der erste ist, dass das Herausgehen aus dem Sichtbereich erzwungen wird:

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::open($indexPath);

   ...

   unset($index);

Und der zweite ist, das eine commit Operation vor dem Ausführungsende des Skripts durchgeführt wird:

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::open($indexPath);

   $index->commit();

Diese Möglichkeit wird auch im Kapitel ":ref:`Fortgeschrittene Verwendung von Indezes als statische Eigenschaften
<zend.search.lucene.advanced.static>`" beschrieben.

.. _zend.search.lucene.best-practice.unique-id:

Dokumente anhand der eindeutigen Id erhalten
--------------------------------------------

Eine übliche Praxis ist es eindeutige Dokument Id's im Index zu speichern. Beispiele beinhalten URL, Pfad,
Datenbank Id.

``Zend_Search_Lucene`` bietet eine ``termDocs()`` Methode um Dokumente zu empfangen die spezielle Terme enthalten.

Das ist effizienter als die Verwendung der ``find()`` Methode:

.. code-block:: php
   :linenos:

   // Dokumente mit find() empfangen durch verwenden eines Abfragestrings
   $query = $idFieldName . ':' . $docId;
   $hits  = $index->find($query);
   foreach ($hits as $hit) {
       $title    = $hit->title;
       $contents = $hit->contents;
       ...
   }
   ...

   // Dokumente mit der find() Methode empfangen durch verwenden der Anfrage API
   $term = new Zend_Search_Lucene_Index_Term($docId, $idFieldName);
   $query = new Zend_Search_Lucene_Search_Query_Term($term);
   $hits  = $index->find($query);
   foreach ($hits as $hit) {
       $title    = $hit->title;
       $contents = $hit->contents;
       ...
   }

   ...

   // Dokumente mit der termDocs() Methode empfangen
   $term = new Zend_Search_Lucene_Index_Term($docId, $idFieldName);
   $docIds  = $index->termDocs($term);
   foreach ($docIds as $id) {
       $doc = $index->getDocument($id);
       $title    = $doc->title;
       $contents = $doc->contents;
       ...
   }

.. _zend.search.lucene.best-practice.memory-usage:

Speicherverwendung
------------------

``Zend_Search_Lucene`` ist ein relativ speicherintensives Modul.

Es verwendet Speicher um Informationen zu Cachen, das Suchen zu optimieren und das Indizieren zu beschleunigen.

Der benötigte Speicher ist für unterschiedliche Modi verschieden.

Der Verzeichnisindex der Ausdrücke wird während der Suche geladen. Das ist aktuelle jeder 128\ :sup:`te`
Ausdruck des kompletten Verzeichnisses. [#]_

Deswegen ist der Speicherverbrauch erhöht wenn man eine große Anzahl an eindeutigen Ausdrücke hat. Das kann
passieren wenn man ungeteilte Phrasen als Feld Werte verwendet, oder ein großes Volumen von nicht-textuellen
Informationen hat.

Ein nicht optimierter Index besteht aus verschiedenen Segmenten. Er erhöht auch den Speicherverbrauch. Segmente
sind voneinander unabhängig, sodas jedes Segment sein eigenes Verzeichnis an Ausdrücken enthält und den
Verzeichnisindex der Ausdrücke. Wenn der Index aus **N** Segmenten besteht kann der Speicherverbrauch im
schlimmsten Fall **N** mal so groß sein. Eine Optimierung des Index kann durchgeführt werden um alle Segmente in
eines zusammenzuführen um diesen Speicherverbrauch zu verhindern.

Indizierung verwendet den gleichen Speicher wie das Suchen und zusätzlich Speicher für das Puffern von
Dokumenten. Die Größe des Speichers der hierfür verwendet wird kann mit dem **MaxBufferedDocs** Parameter
verwaltet werden.

Index Optimierung (komplett oder teilweise) verwendet stream-artiges Bearbeiten von Daten und benötigt nicht viel
Speicher.

.. _zend.search.lucene.best-practice.encoding:

Verschlüsselung
---------------

``Zend_Search_Lucene`` arbeitet intern mit UTF-8 Strings. Das bedeutet also das alle von ``Zend_Search_Lucene``
zurückgegebenen Strings UTF-8 verschlüsselt sind.

Man sollte sich keine Gedanken über Verschlüsselung machen solange man mit reinen *ASCII* Daten arbeitet, sollte
aber vorsichtig sein wenn das nicht der Fall ist.

Eine falsche Verschlüsselung kann Fehlernotizen wärend der Konvertierung oder den Verlust von Daten verursachen.

``Zend_Search_Lucene`` bietet einen breite Palette von Möglichkeiten für die Verschlüsselung von indizierten
Dokumenten und analysierten Abfragen.

Verschlüsselung kann explizit als optionaler Parameter bei den Felderstellung Methoden spezifiziert werden:

.. code-block:: php
   :linenos:

   $doc = new Zend_Search_Lucene_Document();
   $doc->addField(Zend_Search_Lucene_Field::Text('title',
                                                 $title,
                                                 'iso-8859-1'));
   $doc->addField(Zend_Search_Lucene_Field::UnStored('contents',
                                                     $contents,
                                                     'utf-8'));

Das ist der beste Weg um Problemen bei der verwendeten Verschlüsselung vorzubeugen.

Wenn der optionale Parameter der Verschlüsselung unterdrückt wird, wird das aktuelle Gebietsschema verwendet. Das
aktuelle Gebietsschema kann Daten zur Zeichenverschlüsselung, zusätzlich zur Spezifikation der Sprache,
enthalten.

.. code-block:: php
   :linenos:

   setlocale(LC_ALL, 'fr_FR');
   ...

   setlocale(LC_ALL, 'de_DE.iso-8859-1');
   ...

   setlocale(LC_ALL, 'ru_RU.UTF-8');
   ...

Der selbe Weg wird verwendet um die Verschlüsselung beim Abfragestring zu setzen.

Wenn die Verschlüsselung nicht definiert wird, wird das aktuelle Gebietsschema verwendet um die Verschlüsselung
zu ermitteln.

Verschlüsselung kann als optionaler Parameter übergeben werden, wenn die Abfrage explizit vor der Suche geparsed
wird:

.. code-block:: php
   :linenos:

   $query =
       Zend_Search_Lucene_Search_QueryParser::parse($queryStr, 'iso-8859-5');
   $hits = $index->find($query);
   ...

Die Standardverschlüsselung kann auch mit der ``setDefaultEncoding()`` Methode spezifiziert werden:

.. code-block:: php
   :linenos:

   Zend_Search_Lucene_Search_QueryParser::setDefaultEncoding('iso-8859-1');
   $hits = $index->find($queryStr);
   ...

Ein leerer String impliziert das 'aktuelle Gebietsschema'.

Wenn die richtige Verschlüsselung spezifiziert wurde, kann Sie vom Analysator richtig bearbeitet werden. Das
aktuelle Verhalten hängt vom verwendeten Analysator ab. Siehe das Kapitel :ref:`Zeichensatz
<zend.search.lucene.charset>` der Dokumentation für Details.

.. _zend.search.lucene.best-practice.maintenance:

Index Wartung
-------------

Es sollte klar sein das ``Zend_Search_Lucene``, genauso wie jede andere Lucene Implementation, keine "Datenbank"
ersetzt.

Indizes sollten nicht als Datenspeicher verwendet werden. Sie bieten keine partiellen Backup/Wiederherstellungs
Funktionen, Journal, Logging, Transactions und viele andere Features die mit Datenbank Management Systemen
assoziiert werden.

Trotzdem versucht ``Zend_Search_Lucene`` Indizes jederzeit in einem gültigen Status zu halten.

Index Backup/Wiederherstellung sollte durch Kopieren des Inhalts des Index Verzeichnisses durchgeführt werden.

Wenn der Index durch irgendeinen Grund beschädigt wird, sollte der beschädigte Index wiederhergestellt oder
komplett neu gebaut werden.

Es ist also eine gute Idee von großen Indizes ein Backup zu machen und ein Änderungslog zu speichern um manuelle
Wiederherstellung + Roll-Forward Operationen durchzuführen wenn es notwendig ist. Diese Praxis reduziert die
Wiederherstellungszeit des Index dramatisch.



.. [#] ``memory_get_usage()`` und ``memory_get_peak_usage()`` können verwendet werden um die Verwendung des
       Speichers zu kontrollieren.
.. [#] ``Zend_Search_Lucene`` hält jedes Segment offen um die Geschwindigkeit des Suchens zu erhöhen.
.. [#] Das kann auch vorkommen wenn der Index oder die QueryHit Instanzen in zyklischen Datenstrukturen
       referenziert werden, weil *PHP* Objekte mit zyklischen Referenzen nur am Ende der Skriptausführung
       beseitigt.
.. [#] Das Lucene Dateiformat erlaubt es diese Zahl zu ändern, aber ``Zend_Search_Lucene`` bietet keine
       Möglichkeit das über seine *API* durchzuführen. Trotzdem gibt es die Möglichkeit diesen Wert zu ändern
       wenn er mit einer anderen Lucene Implementation vorbereitet wird.