
Supported queries
=================

``Zend_Search_Lucene`` and Java Lucene support a powerful query language. It allows searching for individual terms, phrases, ranges of terms; using wildcards and fuzzy search; combining queries using boolean operators; and so on.

A detailed query language description can be found in the :ref:`Zend_Search_Lucene component documentation <zend.search.lucene.query-language>` .

What follows are examples of some common query types and strategies.

.. note::
    **Default search field**

    Important note! Java Lucene searches only through the "contents" field by default, but ``Zend_Search_Lucene`` searches throughallfields. This behavior can be modified using the ``Zend_Search_Lucene::setDefaultSearchField($fieldName)`` method.

All supported queries can be constructed through ``Zend_Search_Lucene`` 's :ref:`query construction API <zend.search.lucene.query-api>` . Moreover, query parsing and query constructing may be combined:


