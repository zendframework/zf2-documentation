
Search result pagination
========================

As :ref:`mentioned above <learning.lucene.searching.identifiers>` , search result hit objects use lazy loading for stored document fields. When any stored field is accessed, the complete document is loaded.

Do not retrieve all documents if you actually need to work only with some portion of them. Go through the search results and store document IDs (and optionally the score) somewhere to retrive documents from the index during the next script execution.


