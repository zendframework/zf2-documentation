.. _learning.lucene.intro:

Einführung in Zend_Search_Lucene
================================

Die Komponente ``Zend_Search_Lucene`` ist dazu gedacht eine sofort verwendbare Volltext Suchlösung anzubieten. Es
benötigt keine *PHP* Erweiterungen [#]_ und auch keine zusätzlich installierte Software, und kann sofort nach der
Installation von Zend Framework verwendet werden.

``Zend_Search_Lucene`` ist eine reine *PHP* Portierung der populären Open Source Volltext Such Maschine auch
bekannt als Apache Lucene. Siehe `http://lucene.apache.org/`_ für Details.

Die Information vor einer Suche muss indiziert werden. ``Zend_Search_Lucene`` und Java Lucene verwenden ein
Dokumenten Konzept welches als "atomar indiziertes Element" bekannt ist.

Jedes Dokument ist ein Set von Feldern: <name, value> Paaren wobei Name und Wert *UTF-8* String [#]_ sind. Jedes
Subset von Dokumentfeldern kann als "indiziert" markiert werden um Felddaten in den Text-Indizierungs Prozess
einzufügen.

Feldwerte können wärend des Indizierens in Token übersetzt werden. Wenn ein Feld nicht in Token übersetzt wird,
dann wird der Feldwert als ein Ausdruck gespeichert; andernfalls wird der aktuelle Analysator für die Übersetzung
in Token verwendet.

Verschiedene Analysatoren werden im ``Zend_Search_Lucene`` Paket angeboten. Der Standard Analysator arbeitet mit
*ASCII* Text (da der *UTF-8* Analysator die Aktivierung der **mbstring** Erweiterung benötigt). Er ist unabhängig
von der Schreibweise und überspringt Nummern. Um dieses Verhalten zu verändern kann entweder ein anderer
Analysator verwendet, oder ein eigener Analysator erstellt werden.

.. note::

   **Verwendung von Analysatoren wärend der Indizierung und Suche**

   Wichtiger Hinweis! Suchabfragen werden auch durch Verwendung des "aktuellen Analysators" in Token übersetzt, so
   dass der selbe Analysator als Standard gesetzt sein muss, sowohl für die Indizierung als auch den Suchprozess.
   Das garantiert das Quelle und durchsuchter Text auf die selbe Art und Weise in Ausdrücke umgewandelt werden.

Feldwerte werden optional in einem Index gespeichert. Das erlaubt es die originalen Felddaten vom Index zu
empfangen wärend gesucht wird. Das ist der einzige Weg um Suchregebnisse mit den originalen Daten zu assoziieren
(die interne Dokumenten ID kann sich wärend einer Indexoptimierung oder einer automatischen Optimierung
verändern).

Es sollte daran gedacht werden das ein Lucene Index keine Datenbank ist. Er bietet keinen Index Backup Mechanismus
ausser dem Backup des Dateisystem Verzeichnisses. Er bietet keinen Transaktions Mechanismus aber gleichzeitigen
Indexupdates sowie gleichzeitiges Aktualisieren und Lesen wird unterstützt. Er kann auch nicht mit Datenbanken in
Bezug auf die Geschwindigkeit beim Empfangen von Daten verglichen werden.

Deshalb ist es eine gute Idee: So it's good idea:

- den Lucene Index **nicht** als Speicher zu verwenden da sich hierbei die Geschwindigkeit für das Empfangen von
  Suchtreffern dramatisch verringern kann. Nur eindeutige Dokument Identifikatoren (Dokumentenpfade, *URL*\ s, und
  eindeutige Datenbank IDs) sollen gespeichert und Daten in einem Index assoziiert werden, z.B. Titel, Hinweise,
  Kategorie, Sprachinfos, Avatar. (Zu beachten: Ein Feld kann beim Indizieren eingefügt werden, aber nicht
  gespeichert, oder gespeichert, aber nicht indiziert).

- Um Funktionalitäten zu schreiben die einen Index komplett neu erstellen können wenn er aus irgendeinem Grund
  korrupt ist.

Individuelle Dokumente in einem Index können komplett unterschiedliche Sets an Feldern haben. Die selben Felder in
unterschiedlichen Dokumenten müssen nicht die gleichen Attribute haben. Z.B. kann ein Feld für ein Dokument
indiziert sein und für ein anderes wird die Indizierung übersprungen. Das gleiche trifft auch für das Speicher,
die Umwandlung in Token oder der Behandlung von Feldwerten als binärer String zu.



.. _`http://lucene.apache.org/`: http://lucene.apache.org

.. [#] Obwohl einige *UTF-8* bearbeitenden Funktionalitäten die **mbstring** Erweiterung aktiviert benötigen
.. [#] Binäre String können auch als Feldwerte verwendet werden