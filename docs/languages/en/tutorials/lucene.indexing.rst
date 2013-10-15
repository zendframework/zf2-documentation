.. _learning.lucene.indexing:

Indexing
========

Indexing is performed by adding a new document to an existing or new index:

.. code-block:: php
   :linenos:

   $index->addDocument($doc);

There are two ways to create document object. The first is to do it manually.

.. _learning.lucene.indexing.doc-creation:

.. rubric:: Manual Document Construction

.. code-block:: php
   :linenos:

   $doc = new Zend\Search\Lucene\Document();
   $doc->addField(Zend\Search\Lucene\Field::Text('url', $docUrl));
   $doc->addField(Zend\Search\Lucene\Field::Text('title', $docTitle));
   $doc->addField(Zend\Search\Lucene\Field::unStored('contents', $docBody));
   $doc->addField(Zend\Search\Lucene\Field::binary('avatar', $avatarData));

The second method is to load it from *HTML* or Microsoft Office 2007 files:

.. _learning.lucene.indexing.doc-loading:

.. rubric:: Document loading

.. code-block:: php
   :linenos:

   $doc = Zend\Search\Lucene\Document\Html::loadHTML($htmlString);
   $doc = Zend\Search\Lucene\Document\Docx::loadDocxFile($path);
   $doc = Zend\Search\Lucene\Document\Pptx::loadPptFile($path);
   $doc = Zend\Search\Lucene\Document\Xlsx::loadXlsxFile($path);

If a document is loaded from one of the supported formats, it still can be extended manually with new user defined
fields.

.. _learning.lucene.indexing.policy:

Indexing Policy
---------------

You should define indexing policy within your application architectural design.

You may need an on-demand indexing configuration (something like *OLTP* system). In such systems, you usually add
one document per user request. As such, the **MaxBufferedDocs** option will not affect the system. On the other
hand, **MaxMergeDocs** is really helpful as it allows you to limit maximum script execution time. **MergeFactor**
should be set to a value that keeps balance between the average indexing time (it's also affected by average
auto-optimization time) and search performance (index optimization level is dependent on the number of segments).

If you will be primarily performing batch index updates, your configuration should use a **MaxBufferedDocs** option
set to the maximum value supported by the available amount of memory. **MaxMergeDocs** and **MergeFactor** have to
be set to values reducing auto-optimization involvement as much as possible [#]_. Full index optimization should be
applied after indexing.

.. _learning.lucene.indexing.optimization:

.. rubric:: Index optimization

.. code-block:: php
   :linenos:

   $index->optimize();

In some configurations, it's more effective to serialize index updates by organizing update requests into a queue
and processing several update requests in a single script execution. This reduces index opening overhead, and
allows utilizing index document buffering.



.. [#] An additional limit is the maximum file handlers supported by the operation system for concurrent open
       operations