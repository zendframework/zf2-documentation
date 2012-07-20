.. _learning.lucene.pagination:

Seitendarstellung von Suchergebnissen
=====================================

Wie :ref:`vorher erwähnt <learning.lucene.searching.identifiers>`, verwenden die Hit Objekte von Suchergebnissen
Lazy Loading für gespeicherte Dokumentfelder. Wenn auf ein gespeichertes Feld zugegriffen wird, wird das komplette
Dokument geladen.

Man sollte nicht alle Dokumente empfangen wenn man nur mit einem Teil von Ihnen arbeiten muss. Man sollte durch die
Suchergebnisse gehen und die IDs der Dokumente irgendwo speichern (und optional die Bewertung) um die Dokumente vom
Index bei der nächsten Ausführung des Skripts zu erhalten.

.. _learning.lucene.pagination.example:

.. rubric:: Beispiel für die seitendarstellung von Suchergebnissen

.. code-block:: php
   :linenos:

   $cacheId = md5($query);

   if (!$resultSet = $cache->load($cacheId)) {
       $hits = $index->find($query);
       $resultSet = array();
       foreach ($hits as $hit) {
           $resultSetEntry          = array();
           $resultSetEntry['id']    = $hit->id;
           $resultSetEntry['score'] = $hit->score;

           $resultSet[] = $resultSetEntry;
       }

       $cache->save($resultSet, $cacheId);
   }

   $publishedResultSet = array();
   for ($resultId = $startId; $resultId < $endId; $resultId++) {
       $publishedResultSet[$resultId] = array(
           'id'    => $resultSet[$resultId]['id'],
           'score' => $resultSet[$resultId]['score'],
           'doc'   => $index->getDocument($resultSet[$resultId]['id']),
       );
   }


