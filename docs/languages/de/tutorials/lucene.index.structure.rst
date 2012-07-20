.. _learning.lucene.index-structure:

Lucene Index Struktur
=====================

Um ``Zend_Search_Lucene``'s Mögichkeiten mit maximaler Performance kompett anzuwenden, muss man die interne
Struktur des Index verstehen.

Ein **index** wird als Set von Dateien in einem einzelnen Verzeichnis gespeichert.

Ein **index** besteht auf einer beliebigen Anzahl von unabhängigen **Segmenten** welche Informationen über ein
Subset von indizierten Dokumenten speichern. Jedes **Segment** hat sein eigenes **Wörterbuch an Ausdrücken**,
Ausdrucks Wörterbuch Indezes, und Dokument Speicher (speichert Feld Werte) [#]_. Alle Segmentdaten werden in
``_xxxxx.cfs`` Dateien gespeichert, wobei **xxxxx** der Name des Segments ist.

Sobald die Index Segment Datei erstellt wurde kann Sie nicht mehr aktualisiert werden. Neue Dokumente werden in
neuen Segmenten hinzugefügt. Gelöschte Dokumente werden nur in einer optionalen ``<segmentname>.del`` Datei als
gelöscht markiert.

Die Aktualisierung von Dokumenten wird als seperate Lösch- und Hinzufüge Operation durchgeführt selbst wenn Sie
als *API* Aufruf mit ``update()`` durchgeführt wird [#]_. Das vereinfacht das hinzufügen neuer Dokumente und
erlaubt das Aktualisieren gleichzeitig mit Such Operationen.

Auf der anderen Seite verlängert die Verwendung mehrerer Segmente (ein Dokument pro Segment als extremster Fall)
die Suchzeit:

- Das Empfangen von Ausdrücken von einem Verzeichnis wird für jedes Segment durchgeführt;

- Der Index des Ausdrucks Verzeichnisses wird für jedes Segment vorgeladen (dieser Prozess nimmt für einfache
  Abfragen die meiste Zeit in Anspruch, und er benötigt auch zusätzlichen Speicher).

Wenn das Ausdrucks Verzeichnis einen Wendepunkt erreicht, dann ist die Suche durch ein Segment **N** in den meisten
Fällen mal schneller als die Suche durch **N** Segmente.

**Index Optimierung** verbindet zwei oder mehr Segmente in ein einzelnes Segment. Ein neues Segment wird der Liste
der Index Segmente hinzugefügt, und alte Segmente werden ausgeschlossen.

Aktualisierungen von Segment Listen werden als atomsche Operation durchgeführt. Das gibt die Möglichkeit
gleichzeitig neue Dokumente hinzuzufügen, Index Operationen durchzuführen, und den Index zu durchsuchen.

Die automatische Optimierung des Index wird nach jeder Segment Erzeugung durchgeführt. Sie verbindet Sets der
kleinsten Segmente in größere Segmente, und größere Segmente in noch größere Segmente, wenn wir genug
Segmente zum verbinden haben.

Die automatische Optimierung wird von drei Optionen kontrolliert:

- **MaxBufferedDocs** (die minimale Anzahl an notwendigen Dokumenten bevor die im Speicher gepufferten Dokumente in
  ein neues Segment geschrieben werden);

- **MaxMergeDocs** (die größte Anzahl an Dokumenten die von einer Optimierungs Operation verbunden werden); und

- **MergeFactor** (welcher definiert wie oft Segment Indezes von automatischen Optimierungs Operationen verbunden
  werden).

Wenn wir pro Skript Ausführung ein Dokument hinzufügen, wird **MaxBufferedDocs** nicht verwendet (es wird nur ein
neues Segmente mit nur einem Dokument am Ende der Skript Ausführung erstellt, zu einer Zeit zu welcher der
automatische Optimierungs Prozess startet).



.. [#] Beginnend mit Lucene 2.3, können Dokument Speicherdateien zwischen Segmenten geteilt werden; trotzdem
       verwendet ``Zend_Search_Lucene`` diese Möglichkeit nicht
.. [#] Dieser Aufruf wird aktuell nur von Java Lucene unterstützt, es ist aber geplant die ``Zend_Search_Lucene``
       *API* mit Ähnlicher Funktionalität zu erweitern