.. _learning.lucene.pagination:

Pagination de résultat de recherche
===================================

Comme :ref:`mentionné plus haut <learning.lucene.searching.identifiers>`, les objets de résultats de recherche
utilisent le lazy loading pour les champs de documents stockés. Lorsque l'on accède à l'un des champs stockés,
le document complet est chargé.

Ne récupérez pas tous les documents si vous avez seulement besoin de travailler sur une partie. Parcourez les
résultats de recherche et stockez l'ID du document (et éventuellement son score) afin de récupérer les
documents depuis l'index pendant la prochaine exécution du script.

.. _learning.lucene.pagination.example:

.. rubric:: Exemple de pagination de résultat de recherche

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


