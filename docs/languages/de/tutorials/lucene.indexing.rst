.. EN-Revision: none
.. _learning.lucene.indexing:

Indizierung
===========

Indizierung wird durch das Hinzufügen eines neuen Dokuments zu einem bestehenden oder neuen Index durchgeführt:

.. code-block:: php
   :linenos:

   $index->addDocument($doc);

Es gibt zwei Wege Dokument Objekte zu erstellen. Der erste ist es manuell zu tun.

.. _learning.lucene.indexing.doc-creation:

.. rubric:: Manuelle Dokument Erstellung

.. code-block:: php
   :linenos:

   $doc = new Zend\Search_Lucene\Document();
   $doc->addField(Zend\Search_Lucene\Field::Text('url', $docUrl));
   $doc->addField(Zend\Search_Lucene\Field::Text('title', $docTitle));
   $doc->addField(Zend\Search_Lucene\Field::unStored('contents', $docBody));
   $doc->addField(Zend\Search_Lucene\Field::binary('avatar', $avatarData));

Die zweite Methode ist das Laden von *HTML* oder von Microsoft Office 2007 Dateien:

.. _learning.lucene.indexing.doc-loading:

.. rubric:: Laden vom Dokument

.. code-block:: php
   :linenos:

   $doc = Zend\Search\Lucene\Document\Html::loadHTML($htmlString);
   $doc = Zend\Search\Lucene\Document\Docx::loadDocxFile($path);
   $doc = Zend\Search\Lucene\Document\Pptx::loadPptFile($path);
   $doc = Zend\Search\Lucene\Document\Xlsx::loadXlsxFile($path);

Wenn ein Dokument von einem der unterstützten Formate geladen wird, kann es trotzdem noch manuell mit einem neuen
benutzerdefinierten Feld erweitert werden.

.. _learning.lucene.indexing.policy:

Indizierungs Policy
-------------------

Man sollte eine Indizierungs Policy im Architektur Design der eigenen Anwendung definieren.

Man könnte eine auf-Wunsch Index Konfiguration benötigen (etwas wie ein *OLTP* System). In solchen Systemen wird
pro Benutzeranfrage normalerweise ein Dokument hinzugefügt. Daher beeinflusst die **MaxBufferedDocs** Option das
System nicht. Auf der anderen Seite ist **MaxMergeDocs** wirklich nützlich da es erlaubt die maximale
Ausführungszeit des Skripts zu begrenzen. **MergeFactor** sollte auf einen Wert gesetzt werden der die Balance
zwischen der durchschnittlichen Indizierungszeit (sie beeinflusst auch die durchschnittliche automatische
Optimierungszeit) und der Geschwindigkeit der Suche hält (Das Level der Index Optimierung ist abhängig von der
Anzahl der Segmente).

Wenn man primär Batch Indexaktualisierungen durchführt sollte die eigene Konfiguration eine **MaxBufferedDocs**
Option setzen welche auf den maximalen Wert gesetzt wird der vom vorhandenen Speicherplatz unterstützt wird.
**MaxMergeDocs** und **MergeFactor** müssen auf Werte gesetzt werden welche die Einflussnahme durch automatische
Optimierung so stark wie möglich reduziert [#]_. Die komplette Indexoptimierung sollte nach der Indizierung
durchgeführt werden.

.. _learning.lucene.indexing.optimization:

.. rubric:: Index Optimierung

.. code-block:: php
   :linenos:

   $index->optimize();

In einigen Konfigurationen ist es effizienter Indexaktualisierungen zu serialisieren indem Updateanfragen in einer
Queue organisiert werden und verschiedene Updateanfragen in einer einzelnen Skriptausführung bearbeitet werden.
Das reduziert den Overhead des öffnens vom Index und erlaubt die Verwendung von Buffern für die Index Dokumente.



.. [#] Ein zusätzliches Limit sind die maximal vom Betriebssystem unterstützten Dateihandler für gleichzeitig
       geöffnete Operationen