.. _zend.search.lucene.index-creation:

Indexerstellung
===============

.. _zend.search.lucene.index-creation.creating:

Einen neuen Index erstellen
---------------------------

Die Funktionen für das Erstellen und Aktualisieren eines Index wurden innerhalb der ``Zend_Search_Lucene``
Komponente implementiert genau wie im Java Lucene Projekt. Man kann beide dieser Optionen verwenden um einen Index
zu erstellen der mit ``Zend_Search_Lucene`` durchsucht werden kann.

Der *PHP* Quellcode unten zeigt ein Beispiel, wie eine Datei durch Verwendung der ``Zend_Search_Lucene`` *API*
indiziert werden kann:

.. code-block:: php
   :linenos:

   // Index erstellen
   $index = Zend_Search_Lucene::create('/data/my-index');

   $doc = new Zend_Search_Lucene_Document();

   // Speichere die URL des Dokuments,
   // um sie in Suchergebnissen ermitteln zu können
   $doc->addField(Zend_Search_Lucene_Field::Text('url', $docUrl));

   // Inhalte des Dokumentenindex
   $doc->addField(Zend_Search_Lucene_Field::UnStored('contents', $docContent));

   // Füge das Dokument dem Index hinzu
   $index->addDocument($doc);

Neu hinzugefügte Dokumente können sofort im Index gesucht werden.

.. _zend.search.lucene.index-creation.updating:

Indexaktualisierung
-------------------

Der selbe Prozess wird verwendet, um einen vorhandenen Index zu aktualisieren. Der einzige Unterschied ist, dass
die open() Methode statt der create() Methode aufgerufen wird:

.. code-block:: php
   :linenos:

   // Öffnen einen vorhandenen Index
   $index = Zend_Search_Lucene::open('/data/my-index');

   $doc = new Zend_Search_Lucene_Document();

   // Speichere die URL des Dokuments, um es für Suchergebnisse ermitteln zu können
   $doc->addField(Zend_Search_Lucene_Field::Text('url', $docUrl));

   // Indiziere den Dokumenteninhalt
   $doc->addField(Zend_Search_Lucene_Field::UnStored('contents',
                                                     $docContent));

   // Füge das Dokument dem Index hinzu
   $index->addDocument($doc);

.. _zend.search.lucene.index-creation.document-updating:

Dokumente aktualisieren
-----------------------

Das Lucene Indexdateiformat unterstützt keine Aktualisierung von Dokumenten. Ein Dokument sollte entfernt und
wieder hinzugefügt werden um es effektiv zu Aktualisieren.

Die ``Zend_Search_Lucene::delete()`` Methode arbeitet mit einer internen Index Dokumentennummer. Sie kann aus dem
Ergebnistreffer über die 'id' Eigenschaft erhalten werden:

.. code-block:: php
   :linenos:

   $removePath = ...;
   $hits = $index->find('path:' . $removePath);
   foreach ($hits as $hit) {
       $index->delete($hit->id);
   }

.. _zend.search.lucene.index-creation.counting:

Die Größe des Index erhalten
----------------------------

Es gibt zwei Methoden um die Größe eines Index in ``Zend_Search_Lucene`` zu erhalten.

``Zend_Search_Lucene::maxDoc()`` gibt einen Mehr als die größte Anzahl an Dokumenten zurück. Das ist die
Gesamtanzahl der Dokumente im Index inklusive gelöschter Dokumente. Deswegen hat es das Synonym:
``Zend_Search_Lucene::count()``.

``Zend_Search_Lucene::numDocs()`` gibt die Gesamtanzahl an nicht gelöschten Dokumenten zurück.

.. code-block:: php
   :linenos:

   $indexSize = $index->count();
   $documents = $index->numDocs();

Die Methode ``Zend_Search_Lucene::isDeleted($id)`` kann verwendet werden um zu Prüfen ob ein Dokument gelöscht
ist.

.. code-block:: php
   :linenos:

   for ($count = 0; $count < $index->maxDoc(); $count++) {
       if ($index->isDeleted($count)) {
           echo "Dokument #$id ist gelöscht.\n";
       }
   }

Index Optimierung entfernt gelöschte Dokumente und quetscht die Dokument Ids in einen kleineren Bereich. Die
interne Id des Dokuments könnte also wärend der Indexoptinierung verändert werden.

.. _zend.search.lucene.index-creation.optimization:

Indexoptimierung
----------------

Ein Lucene Index besteht aus Segmenten. Jedes Segment ist ein komplett unabhängiges Set von Daten.

Lucene Indexsegmentdateien können aufgrund ihres Designs nicht aktualisiert werden. Eine Segmentaktualisierung
benötigt eine komplette Reorganisation der Segmente. Siehe auch die Lucene Indexdateiformate für weitere Details
(`http://lucene.apache.org/java/2_3_0/fileformats.html`_). [#]_. Neue Dokumente werden durch Erstellen neuer
Segmente zum Index hinzugefügt.

Eine steigende Anzahl an Segmente verringert die Qualität des Index, aber die Indexoptimierung stellt diese wieder
her. Die Optimierung verschiebt verschiedene Segmente in ein neues. Dieser Prozess aktualisiert die Segmente auch
nicht. Es erzeugt ein neues großes Segment und aktualisiert die Segmentliste (die 'sements' Datei).

Eine komplette Indexoptimierung kann durch einen Aufruf von ``Zend_Search_Lucene::optimize()`` getriggert werden.
Sie fügt alle Segmente in ein größeres zusammen.

.. code-block:: php
   :linenos:

   // Öffne bestehenden Index
   $index = new Zend_Search_Lucene('/data/my-index');

   // Optimiere Index
   $index->optimize();

Die automatische Indexoptimierung wird durchgeführt, um einen Index in einem konsistenten Status zu halten.

Die automatische Indexoptimierung ist ein schrittweise Prozess, der durch verschiedene Indexoptionen gesteuert
wird. Sie fasst sehr kleine Segmente in größere zusammen und fasst die größeren Segmente dann in noch größere
zusammen und so weiter.

.. _zend.search.lucene.index-creation.optimization.maxbuffereddocs:

MaxBufferedDocs Option für automatische Optimierung
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**MaxBufferedDocs** ist die minimale Anzahl an Dokumenten, die erforderlich ist, damit die im Hauptspeicher
zwischen gespeicherten Dokumente in ein neues Segment geschrieben werden.

**MaxBufferedDocs** kann abgefragt bzw. gesetzt werden durch Aufrufe von *$index->getMaxBufferedDocs()* oder
*$index->setMaxBufferedDocs($maxBufferedDocs)*.

Standardwert is 10.

.. _zend.search.lucene.index-creation.optimization.maxmergedocs:

MaxMergeDocs Option für automatische Optimierung
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**MaxMergeDocs** ist die höchste Anzahl an Dokumenten, die jemals mit addDocument() zusammengefasst werden kann.
Kleine Werte (z.B. unter 10.000) sind für die interaktive Indizierung am besten, da dies die Pausen für das
Indizieren auf wenige Sekunden begrenzen. Größere Werte sind am besten für Stapelverarbeitung oder schnellere
Suchabfragen.

**MaxMergeDocs** kann abgefragt bzw. gesetzt werden durch Aufrufe von *$index->getMaxMergeDocs()* oder
*$index->setMaxMergeDocs($maxMergeDocs)*.

Standardwert ist PHP_INT_MAX.

.. _zend.search.lucene.index-creation.optimization.mergefactor:

MergeFactor Option für automatische Optimierung
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**MergeFactor** legt fest, wie oft Segmentenindixes durch addDocument() zusammengefasst werden sollen. Bei
kleineren Werten wird beim Indizieren weniger *RAM* verbraucht und Suchabfragen auf nicht optimierte Indizes sind
schneller, aber die Indizierungsgeschwindigkeit ist langsamer. Bei größeren Werten, wird mehr beim Indizieren
*RAM* verbraucht und während Suchabfragen auf nicht optimierte Indizes langsamer sind, ist das Indizieren
schneller. Deshalb sind größere Werte (> 10) am besten für Stapelverarbeitung und kleinere Werte (< 10) sind
besser für Indizes, die interaktiv gepflegt werden.

**MergeFactor** ist eine gute Annahme für die durchschnittliche Anzahl an Segmenten die durch einen
Auto-Optimierungs Durchgang zusammengeführt werden. Zu große Werte produzieren eine große Anzahl an Segmenten
wärend diese nicht in einen neuen zusammengeführt werden. Das kann eine "failed to open stream: Too many open
files" Fehlernachricht sein. Diese Begrenzung ist Sytemabhängig.

**MergeFactor** kann abgefragt bzw. gesetzt werden durch Aufrufe von *$index->getMergeFactor()* oder
*$index->setMergeFactor($mergeFactor)*.

Standardwert ist 10.

Lucene Java und Luke (Lucene Index Toolbox -`http://www.getopt.org/luke/`_) können auch für die Optimierung eines
Index verwendet werden. Das letzte Luke Relese (v0.8) basiert auf Lucene v2.3 und ist kompatibel mit den aktuellen
Implementation der ``Zend_Search_Lucene`` Komponente (Zend Framework 1.6). Frühere Versionen der
``Zend_Search_Lucene`` Implementation benötigen andere Versionen des Java Lucene Tools um kompatibel zu sein:



   - Zend Framework 1.5 - Java Lucene 2.1 (Luke Tool v0.7.1 -`http://www.getopt.org/luke/luke-0.7.1/`_)

   - Zend Framework 1.0 - Java Lucene 1.4 - 2.1 (Luke Tool v0.6 -`http://www.getopt.org/luke/luke-0.6/`_)



.. _zend.search.lucene.index-creation.permissions:

Berechtigungen
--------------

Index Dateien sind standardmäßig für jeden lesbar und beschreibbar.

Es ist möglich das mit der ``Zend_Search_Lucene_Storage_Directory_Filesystem::setDefaultFilePermissions()``
Methode zu überschreiben.

.. code-block:: php
   :linenos:

   // Die aktuelle Datei Berechtigung erhalten
   $currentPermissions =
       Zend_Search_Lucene_Storage_Directory_Filesystem::getDefaultFilePermissions();

   // Nur für aktuellen Benutzer und Gruppe die Lese-Schreib Berechtigung setzen
   Zend_Search_Lucene_Storage_Directory_Filesystem::setDefaultFilePermissions(0660);

.. _zend.search.lucene.index-creation.limitations:

Einschränkungen
---------------

.. _zend.search.lucene.index-creation.limitations.index-size:

Indexgröße
^^^^^^^^^^

Die Indexgröße ist limitiert mit 2GB für 32-bit Platformen.

Verwende 64-bit Platformen für größere Indezes.

.. _zend.search.lucene.index-creation.limitations.filesystems:

Unterstützte Dateisysteme
^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Search_Lucene`` verwendet ``flock()`` um gleichzeitiges Suchen, Updaten und Optimierung des Index zu
unterstützen.

Entsprechend der *PHP* `Dokumentation`_, "funktioniert ``flock()`` nicht auf NFS und vielen anderen Netzwerk
Dateisystemen".

Verwende keine Netzwerk Dateisysteme mit ``Zend_Search_Lucene``.



.. _`http://lucene.apache.org/java/2_3_0/fileformats.html`: http://lucene.apache.org/java/2_3_0/fileformats.html
.. _`http://www.getopt.org/luke/`: http://www.getopt.org/luke/
.. _`http://www.getopt.org/luke/luke-0.7.1/`: http://www.getopt.org/luke/luke-0.7.1/
.. _`http://www.getopt.org/luke/luke-0.6/`: http://www.getopt.org/luke/luke-0.6/
.. _`Dokumentation`: http://www.php.net/manual/de/function.flock.php

.. [#] Die aktuell unterstützte Version des Lucene Index File Formats ist 2.3 (beginnend mit Zend Framework 1.6).