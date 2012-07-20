.. _learning.lucene.searching:

Suchen
======

Suchen wird durch Verwendung der ``find()`` Methode durchgeführt:

.. _learning.lucene.searching.search-example:

.. rubric:: Den Index durchsuchen

.. code-block:: php
   :linenos:

   $hits = $index->find($query);

   foreach ($hits as $hit) {
       printf("%d %f %s\n", $hit->id, $hit->score, $hit->title);
   }

Dieses Beispiel demonstriert die Verwendung von zwei speziellen Suchtreffer Eigenschaften -``id`` und ``score``.

``id`` ist ein interner Dokument Identifikator der im Lucene Index verwendet wird. Er kann in unterschiedlichen
Operationen verwendet werden, inklusive dem Löschen eines Dokuments vom Index:

.. _learning.lucene.searching.delete-example:

.. rubric:: Löschen eines indizierten Dokuments

.. code-block:: php
   :linenos:

   $index->delete($id);

Oder Empfangen eines Dokuments vom Index:

.. _learning.lucene.searching.retrieve-example:

.. rubric:: Empfangen eines indizierten Dokuments

.. code-block:: php
   :linenos:

   $doc = $index->getDocument($id);

.. note::

   **Interne Dokument Identifikatoren**

   Wichtiger Hinweis! Interne Dokument Identifikatoren können durch eine Index Optimierung oder den automatischen
   Optimierungsprozess geändert werden, aber Sie werden niemals bei der Ausführung eines einzelnen Skripts
   geändert solange die ``addDocument()`` (welche eine automatische Optimierungsprozedur beinhalten kann) oder die
   ``optimize()`` Methoden aufgerufen werden.

Das ``score`` Feld sind Trefferpunkte. Such Ergebnisse werden standardmäßig nach Trefferpunkten sortiert (die
besten Ergebnisse werden als erstes zurückgegeben).

Es ist auch möglich Ergebnissets anhand von spezifischen Feldwerten zu sortieren. Siehe die
:ref:`Zend_Search_Lucene Dokumentation <zend.search.lucene.searching.sorting>` für mehr Details über diese
Möglichkeit.

Das Beispiel demonstriert auch eine Möglichkeit um auf gespeicherte Felder zugreifen zu können (z.B.
``$hit->title``). Beim ersten Zugriff auf jede Treffer-Eigenschaft, die sich von ``id`` oder ``score``
unterscheidet, wird jedes dokumentierte gespeicherte Feld geladen, und die korrespondierenden Feldwerte werden
zurückgegeben.

Das verursacht eine Doppeldeutigkeit für Dokumente die Ihre eigenen ``id`` oder ``score`` Felder haben; als
Ergebnis wird empfohlen diese Feldnamen nicht in gespeicherten Dokumenten zu verwenden. Trotzdem kann auf Sie über
die ``getDocument()`` Methode zugegriffen werden:

.. _learning.lucene.searching.id-score-fields:

.. rubric:: Zugriff auf die originalen "id" und "score" Felder von Dokumenten

.. code-block:: php
   :linenos:

   $id    = $hit->getDocument()->id;
   $score = $hit->getDocument()->score;


