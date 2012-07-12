
Searching
=========

Searching is performed by using the ``find()`` method:

This example demonstrates the usage of two special search hit properties - ``id`` and ``score`` .

``id`` is an internal document identifier used within a Lucene index. It may be used for a variety of operations, including deleting a document from the index:

Or retrieving the document from the index:

.. note::
    **Internal Document Identifiers**

    Important note! Internal document identifiers may be changed by index optimization or the auto-optimization process, but it's never changed within a single script's execution unless the ``addDocument()`` (which may involve an auto-optimization procedure) or ``optimize()`` methods are called.

The ``score`` field is a hit score. Search results are ordered by score by default (best results returned first).

It's also possible to order result sets by specific field values. See the :ref:`Zend_Search_Lucene documentation <zend.search.lucene.searching.sorting>` for more details about this possibility.

The example also demonstrates an ability to access stored fields (e.g., ``$hit->title`` ). At the first access to any hit property other than ``id`` or ``score`` , document stored fields are loaded, and the corresponding field value is returned.

This causes an ambiguity for documents having their own ``id`` or ``score`` fields; as a result, it's not recommended to use these field names within stored documents. Nevertheless, they still can be accessed via the ``getDocument()`` method:


