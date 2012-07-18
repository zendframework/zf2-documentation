.. _learning.lucene.pagination:

Search result pagination
========================

As :ref:`mentioned above <learning.lucene.searching.identifiers>`, search result hit objects use lazy loading for stored document fields. When any stored field is accessed, the complete document is loaded.

Do not retrieve all documents if you actually need to work only with some portion of them. Go through the search results and store document IDs (and optionally the score) somewhere to retrive documents from the index during the next script execution.

.. _learning.lucene.pagination.example:

.. rubric:: Search result pagination example

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


