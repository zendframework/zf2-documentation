.. _zendsearch.lucene.best-practice:

Best Practices
==============

.. _zendsearch.lucene.best-practice.field-names:

Field names
-----------

There are no limitations for field names in ``Zend\Search\Lucene``.

Nevertheless it's a good idea not to use '**id**' and '**score**' names to avoid ambiguity in ``QueryHit``
properties names.

The ``Zend\Search\Lucene\Search\QueryHit`` ``id`` and ``score`` properties always refer to internal Lucene document
id and hit :ref:`score <zendsearch.lucene.searching.results-scoring>`. If the indexed document has the same stored
fields, you have to use the ``getDocument()`` method to access them:

.. code-block:: php
   :linenos:

   $hits = $index->find($query);

   foreach ($hits as $hit) {
       // Get 'title' document field
       $title = $hit->title;

       // Get 'contents' document field
       $contents = $hit->contents;

       // Get internal Lucene document id
       $id = $hit->id;

       // Get query hit score
       $score = $hit->score;

       // Get 'id' document field
       $docId = $hit->getDocument()->id;

       // Get 'score' document field
       $docId = $hit->getDocument()->score;

       // Another way to get 'title' document field
       $title = $hit->getDocument()->title;
   }

.. _zendsearch.lucene.best-practice.indexing-performance:

Indexing performance
--------------------

Indexing performance is a compromise between used resources, indexing time and index quality.

Index quality is completely determined by number of index segments.

Each index segment is entirely independent portion of data. So indexes containing more segments need more memory
and time for searching.

Index optimization is a process of merging several segments into a new one. A fully optimized index contains only
one segment.

Full index optimization may be performed with the ``optimize()`` method:

.. code-block:: php
   :linenos:

   $index = Zend\Search\Lucene::open($indexPath);

   $index->optimize();

Index optimization works with data streams and doesn't take a lot of memory but does require processor resources
and time.

Lucene index segments are not updatable by their nature (the update operation requires the segment file to be
completely rewritten). So adding new document(s) to an index always generates a new segment. This, in turn,
decreases index quality.

An index auto-optimization process is performed after each segment generation and consists of merging partial
segments.

There are three options to control the behavior of auto-optimization (see :ref:`Index optimization
<zendsearch.lucene.index-creation.optimization>` section):



   - **MaxBufferedDocs** is the number of documents that can be buffered in memory before a new segment is
     generated and written to the hard drive.

   - **MaxMergeDocs** is the maximum number of documents merged by auto-optimization process into a new segment.

   - **MergeFactor** determines how often auto-optimization is performed.



   .. note::

      All these options are ``Zend\Search\Lucene`` object properties- not index properties. They affect only
      current ``Zend\Search\Lucene`` object behavior and may vary for different scripts.



**MaxBufferedDocs** doesn't have any effect if you index only one document per script execution. On the other hand,
it's very important for batch indexing. Greater values increase indexing performance, but also require more memory.

There is simply no way to calculate the best value for the **MaxBufferedDocs** parameter because it depends on
average document size, the analyzer in use and allowed memory.

A good way to find the right value is to perform several tests with the largest document you expect to be added to
the index [#]_. It's a best practice not to use more than a half of the allowed memory.

**MaxMergeDocs** limits the segment size (in terms of documents). It therefore also limits auto-optimization time
by guaranteeing that the ``addDocument()`` method is not executed more than a certain number of times. This is very
important for interactive applications.

Lowering the **MaxMergeDocs** parameter also may improve batch indexing performance. Index auto-optimization is an
iterative process and is performed from bottom up. Small segments are merged into larger segment, which are in turn
merged into even larger segments and so on. Full index optimization is achieved when only one large segment file
remains.

Small segments generally decrease index quality. Many small segments may also trigger the "Too many open files"
error determined by OS limitations [#]_.

in general, background index optimization should be performed for interactive indexing mode and **MaxMergeDocs**
shouldn't be too low for batch indexing.

**MergeFactor** affects auto-optimization frequency. Lower values increase the quality of unoptimized indexes.
Larger values increase indexing performance, but also increase the number of merged segments. This again may
trigger the "Too many open files" error.

**MergeFactor** groups index segments by their size:



   . Not greater than **MaxBufferedDocs**.

   . Greater than **MaxBufferedDocs**, but not greater than **MaxBufferedDocs**\ * **MergeFactor**.

   . Greater than **MaxBufferedDocs**\ * **MergeFactor**, but not greater than **MaxBufferedDocs**\ *
     **MergeFactor**\ * **MergeFactor**.

   . ...



``Zend\Search\Lucene`` checks during each ``addDocument()`` call to see if merging any segments may move the newly
created segment into the next group. If yes, then merging is performed.

So an index with N groups may contain **MaxBufferedDocs** + (N-1)* **MergeFactor** segments and contains at least
**MaxBufferedDocs**\ * **MergeFactor** :sup:`(N-1)`  documents.

This gives good approximation for the number of segments in the index:

**NumberOfSegments** <= **MaxBufferedDocs** + **MergeFactor**\ *log **MergeFactor**
(**NumberOfDocuments**/**MaxBufferedDocs**)

**MaxBufferedDocs** is determined by allowed memory. This allows for the appropriate merge factor to get a
reasonable number of segments.

Tuning the **MergeFactor** parameter is more effective for batch indexing performance than **MaxMergeDocs**. But
it's also more course-grained. So use the estimation above for tuning **MergeFactor**, then play with
**MaxMergeDocs** to get best batch indexing performance.

.. _zendsearch.lucene.best-practice.shutting-down:

Index during Shut Down
----------------------

The ``Zend\Search\Lucene`` instance performs some work at exit time if any documents were added to the index but
not written to a new segment.

It also may trigger an auto-optimization process.

The index object is automatically closed when it, and all returned QueryHit objects, go out of scope.

If index object is stored in global variable than it's closed only at the end of script execution [#]_.

*PHP* exception processing is also shut down at this moment.

It doesn't prevent normal index shutdown process, but may prevent accurate error diagnostic if any error occurs
during shutdown.

There are two ways with which you may avoid this problem.

The first is to force going out of scope:

.. code-block:: php
   :linenos:

   $index = Zend\Search\Lucene::open($indexPath);

   ...

   unset($index);

And the second is to perform a commit operation before the end of script execution:

.. code-block:: php
   :linenos:

   $index = Zend\Search\Lucene::open($indexPath);

   $index->commit();

This possibility is also described in the ":ref:`Advanced. Using index as static property
<zendsearch.lucene.advanced.static>`" section.

.. _zendsearch.lucene.best-practice.unique-id:

Retrieving documents by unique id
---------------------------------

It's a common practice to store some unique document id in the index. Examples include url, path, or database id.

``Zend\Search\Lucene`` provides a ``termDocs()`` method for retrieving documents containing specified terms.

This is more efficient than using the ``find()`` method:

.. code-block:: php
   :linenos:

   // Retrieving documents with find() method using a query string
   $query = $idFieldName . ':' . $docId;
   $hits  = $index->find($query);
   foreach ($hits as $hit) {
       $title    = $hit->title;
       $contents = $hit->contents;
       ...
   }
   ...

   // Retrieving documents with find() method using the query API
   $term = new Zend\Search\Lucene\Index\Term($docId, $idFieldName);
   $query = new Zend\Search\Lucene\Search\Query\Term($term);
   $hits  = $index->find($query);
   foreach ($hits as $hit) {
       $title    = $hit->title;
       $contents = $hit->contents;
       ...
   }

   ...

   // Retrieving documents with termDocs() method
   $term = new Zend\Search\Lucene\Index\Term($docId, $idFieldName);
   $docIds  = $index->termDocs($term);
   foreach ($docIds as $id) {
       $doc = $index->getDocument($id);
       $title    = $doc->title;
       $contents = $doc->contents;
       ...
   }

.. _zendsearch.lucene.best-practice.memory-usage:

Memory Usage
------------

``Zend\Search\Lucene`` is a relatively memory-intensive module.

It uses memory to cache some information and optimize searching and indexing performance.

The memory required differs for different modes.

The terms dictionary index is loaded during the search. It's actually each 128\ :sup:`th`  [#]_ term of the full
dictionary.

Thus memory usage is increased if you have a high number of unique terms. This may happen if you use untokenized
phrases as a field values or index a large volume of non-text information.

An unoptimized index consists of several segments. It also increases memory usage. Segments are independent, so
each segment contains its own terms dictionary and terms dictionary index. If an index consists of **N** segments
it may increase memory usage by **N** times in worst case. Perform index optimization to merge all segments into
one to avoid such memory consumption.

Indexing uses the same memory as searching plus memory for buffering documents. The amount of memory used may be
managed with **MaxBufferedDocs** parameter.

Index optimization (full or partial) uses stream-style data processing and doesn't require a lot of memory.

.. _zendsearch.lucene.best-practice.encoding:

Encoding
--------

``Zend\Search\Lucene`` works with UTF-8 strings internally. So all strings returned by ``Zend\Search\Lucene`` are
UTF-8 encoded.

You shouldn't be concerned with encoding if you work with pure *ASCII* data, but you should be careful if this is
not the case.

Wrong encoding may cause error notices at the encoding conversion time or loss of data.

``Zend\Search\Lucene`` offers a wide range of encoding possibilities for indexed documents and parsed queries.

Encoding may be explicitly specified as an optional parameter of field creation methods:

.. code-block:: php
   :linenos:

   $doc = new Zend\Search\Lucene\Document();
   $doc->addField(Zend\Search\Lucene\Field::Text('title',
                                                 $title,
                                                 'iso-8859-1'));
   $doc->addField(Zend\Search\Lucene\Field::UnStored('contents',
                                                     $contents,
                                                     'utf-8'));

This is the best way to avoid ambiguity in the encoding used.

If optional encoding parameter is omitted, then the current locale is used. The current locale may contain
character encoding data in addition to the language specification:

.. code-block:: php
   :linenos:

   setlocale(LC_ALL, 'fr_FR');
   ...

   setlocale(LC_ALL, 'de_DE.iso-8859-1');
   ...

   setlocale(LC_ALL, 'ru_RU.UTF-8');
   ...

The same approach is used to set query string encoding.

If encoding is not specified, then the current locale is used to determine the encoding.

Encoding may be passed as an optional parameter, if the query is parsed explicitly before search:

.. code-block:: php
   :linenos:

   $query =
       Zend\Search\Lucene\Search\QueryParser::parse($queryStr, 'iso-8859-5');
   $hits = $index->find($query);
   ...

The default encoding may also be specified with ``setDefaultEncoding()`` method:

.. code-block:: php
   :linenos:

   Zend\Search\Lucene\Search\QueryParser::setDefaultEncoding('iso-8859-1');
   $hits = $index->find($queryStr);
   ...

The empty string implies 'current locale'.

If the correct encoding is specified it can be correctly processed by analyzer. The actual behavior depends on
which analyzer is used. See the :ref:`Character Set <zendsearch.lucene.charset>` documentation section for
details.

.. _zendsearch.lucene.best-practice.maintenance:

Index maintenance
-----------------

It should be clear that ``Zend\Search\Lucene`` as well as any other Lucene implementation does not comprise a
"database".

Indexes should not be used for data storage. They do not provide partial backup/restore functionality, journaling,
logging, transactions and many other features associated with database management systems.

Nevertheless, ``Zend\Search\Lucene`` attempts to keep indexes in a consistent state at all times.

Index backup and restoration should be performed by copying the contents of the index folder.

If index corruption occurs for any reason, the corrupted index should be restored or completely rebuilt.

So it's a good idea to backup large indexes and store changelogs to perform manual restoration and roll-forward
operations if necessary. This practice dramatically reduces index restoration time.



.. [#] ``memory_get_usage()`` and ``memory_get_peak_usage()`` may be used to control memory usage.
.. [#] ``Zend\Search\Lucene`` keeps each segment file opened to improve search performance.
.. [#] This also may occur if the index or QueryHit instances are referred to in some cyclical data structures,
       because *PHP* garbage collects objects with cyclic references only at the end of script execution.
.. [#] The Lucene file format allows you to configure this number, but ``Zend\Search\Lucene`` doesn't expose this
       in its *API*. Nevertheless you still have the ability to configure this value if the index is prepared with
       another Lucene implementation.