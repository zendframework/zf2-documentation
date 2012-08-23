.. _zend.search.lucene.index-creation:

Building Indexes
================

.. _zend.search.lucene.index-creation.creating:

Creating a New Index
--------------------

Index creation and updating capabilities are implemented within the ``Zend_Search_Lucene`` component, as well as
the Java Lucene project. You can use either of these options to create indexes that ``Zend_Search_Lucene`` can
search.

The *PHP* code listing below provides an example of how to index a file using ``Zend_Search_Lucene`` indexing
*API*:

.. code-block:: php
   :linenos:

   // Create index
   $index = Zend_Search_Lucene::create('/data/my-index');

   $doc = new Zend_Search_Lucene_Document();

   // Store document URL to identify it in the search results
   $doc->addField(Zend_Search_Lucene_Field::Text('url', $docUrl));

   // Index document contents
   $doc->addField(Zend_Search_Lucene_Field::UnStored('contents', $docContent));

   // Add document to the index
   $index->addDocument($doc);

Newly added documents are immediately searchable in the index.

.. _zend.search.lucene.index-creation.updating:

Updating Index
--------------

The same procedure is used to update an existing index. The only difference is that the open() method is called
instead of the create() method:

.. code-block:: php
   :linenos:

   // Open existing index
   $index = Zend_Search_Lucene::open('/data/my-index');

   $doc = new Zend_Search_Lucene_Document();
   // Store document URL to identify it in search result.
   $doc->addField(Zend_Search_Lucene_Field::Text('url', $docUrl));
   // Index document content
   $doc->addField(Zend_Search_Lucene_Field::UnStored('contents',
                                                     $docContent));

   // Add document to the index.
   $index->addDocument($doc);

.. _zend.search.lucene.index-creation.document-updating:

Updating Documents
------------------

The Lucene index file format doesn't support document updating. Documents should be removed and re-added to the
index to effectively update them.

``Zend_Search_Lucene::delete()`` method operates with an internal index document id. It can be retrieved from a
query hit by 'id' property:

.. code-block:: php
   :linenos:

   $removePath = ...;
   $hits = $index->find('path:' . $removePath);
   foreach ($hits as $hit) {
       $index->delete($hit->id);
   }

.. _zend.search.lucene.index-creation.counting:

Retrieving Index Size
---------------------

There are two methods to retrieve the size of an index in ``Zend_Search_Lucene``.

``Zend_Search_Lucene::maxDoc()`` returns one greater than the largest possible document number. It's actually the
overall number of the documents in the index including deleted documents, so it has a synonym:
``Zend_Search_Lucene::count()``.

``Zend_Search_Lucene::numDocs()`` returns the total number of non-deleted documents.

.. code-block:: php
   :linenos:

   $indexSize = $index->count();
   $documents = $index->numDocs();

``Zend_Search_Lucene::isDeleted($id)`` method may be used to check if a document is deleted.

.. code-block:: php
   :linenos:

   for ($count = 0; $count < $index->maxDoc(); $count++) {
       if ($index->isDeleted($count)) {
           echo "Document #$id is deleted.\n";
       }
   }

Index optimization removes deleted documents and squeezes documents' IDs in to a smaller range. A document's
internal id may therefore change during index optimization.

.. _zend.search.lucene.index-creation.optimization:

Index optimization
------------------

A Lucene index consists of many segments. Each segment is a completely independent set of data.

Lucene index segment files can't be updated by design. A segment update needs full segment reorganization. See
Lucene index file formats for details (`http://lucene.apache.org/java/2_3_0/fileformats.html`_) [#]_. New documents
are added to the index by creating new segment.

Increasing number of segments reduces quality of the index, but index optimization restores it. Optimization
essentially merges several segments into a new one. This process also doesn't update segments. It generates one new
large segment and updates segment list ('segments' file).

Full index optimization can be trigger by calling the ``Zend_Search_Lucene::optimize()`` method. It merges all
index segments into one new segment:

.. code-block:: php
   :linenos:

   // Open existing index
   $index = Zend_Search_Lucene::open('/data/my-index');

   // Optimize index.
   $index->optimize();

Automatic index optimization is performed to keep indexes in a consistent state.

Automatic optimization is an iterative process managed by several index options. It merges very small segments into
larger ones, then merges these larger segments into even larger segments and so on.

.. _zend.search.lucene.index-creation.optimization.maxbuffereddocs:

MaxBufferedDocs auto-optimization option
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**MaxBufferedDocs** is a minimal number of documents required before the buffered in-memory documents are written
into a new segment.

**MaxBufferedDocs** can be retrieved or set by *$index->getMaxBufferedDocs()* or
*$index->setMaxBufferedDocs($maxBufferedDocs)* calls.

Default value is 10.

.. _zend.search.lucene.index-creation.optimization.maxmergedocs:

MaxMergeDocs auto-optimization option
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**MaxMergeDocs** is a largest number of documents ever merged by addDocument(). Small values (e.g., less than
10.000) are best for interactive indexing, as this limits the length of pauses while indexing to a few seconds.
Larger values are best for batched indexing and speedier searches.

**MaxMergeDocs** can be retrieved or set by *$index->getMaxMergeDocs()* or *$index->setMaxMergeDocs($maxMergeDocs)*
calls.

Default value is PHP_INT_MAX.

.. _zend.search.lucene.index-creation.optimization.mergefactor:

MergeFactor auto-optimization option
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**MergeFactor** determines how often segment indices are merged by addDocument(). With smaller values, less *RAM*
is used while indexing, and searches on unoptimized indices are faster, but indexing speed is slower. With larger
values, more *RAM* is used during indexing, and while searches on unoptimized indices are slower, indexing is
faster. Thus larger values (> 10) are best for batch index creation, and smaller values (< 10) for indices that are
interactively maintained.

**MergeFactor** is a good estimation for average number of segments merged by one auto-optimization pass. Too large
values produce large number of segments while they are not merged into new one. It may be a cause of "failed to
open stream: Too many open files" error message. This limitation is system dependent.

**MergeFactor** can be retrieved or set by *$index->getMergeFactor()* or *$index->setMergeFactor($mergeFactor)*
calls.

Default value is 10.

Lucene Java and Luke (Lucene Index Toolbox -`http://www.getopt.org/luke/`_) can also be used to optimize an index.
Latest Luke release (v0.8) is based on Lucene v2.3 and compatible with current implementation of
``Zend_Search_Lucene`` component (Zend Framework 1.6). Earlier versions of ``Zend_Search_Lucene`` implementations
need another versions of Java Lucene tools to be compatible:



   - Zend Framework 1.5 - Java Lucene 2.1 (Luke tool v0.7.1 -`http://www.getopt.org/luke/luke-0.7.1/`_)

   - Zend Framework 1.0 - Java Lucene 1.4 - 2.1 (Luke tool v0.6 -`http://www.getopt.org/luke/luke-0.6/`_)



.. _zend.search.lucene.index-creation.permissions:

Permissions
-----------

By default, index files are available for reading and writing by everyone.

It's possible to override this with the
``Zend_Search_Lucene_Storage_Directory_Filesystem::setDefaultFilePermissions()`` method:

.. code-block:: php
   :linenos:

   // Get current default file permissions
   $currentPermissions =
       Zend_Search_Lucene_Storage_Directory_Filesystem::getDefaultFilePermissions();

   // Give read-writing permissions only for current user and group
   Zend_Search_Lucene_Storage_Directory_Filesystem::setDefaultFilePermissions(0660);

.. _zend.search.lucene.index-creation.limitations:

Limitations
-----------

.. _zend.search.lucene.index-creation.limitations.index-size:

Index size
^^^^^^^^^^

Index size is limited by 2GB for 32-bit platforms.

Use 64-bit platforms for larger indices.

.. _zend.search.lucene.index-creation.limitations.filesystems:

Supported Filesystems
^^^^^^^^^^^^^^^^^^^^^

``Zend_Search_Lucene`` uses ``flock()`` to provide concurrent searching, index updating and optimization.

According to the *PHP* `documentation`_, "``flock()`` will not work on NFS and many other networked file systems".

Do not use networked file systems with ``Zend_Search_Lucene``.



.. _`http://lucene.apache.org/java/2_3_0/fileformats.html`: http://lucene.apache.org/java/2_3_0/fileformats.html
.. _`http://www.getopt.org/luke/`: http://www.getopt.org/luke/
.. _`http://www.getopt.org/luke/luke-0.7.1/`: http://www.getopt.org/luke/luke-0.7.1/
.. _`http://www.getopt.org/luke/luke-0.6/`: http://www.getopt.org/luke/luke-0.6/
.. _`documentation`: http://www.php.net/manual/en/function.flock.php

.. [#] The currently supported Lucene index file format is version 2.3 (starting from Zend Framework 1.6).