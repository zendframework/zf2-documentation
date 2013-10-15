.. _learning.lucene.intro:

Zend\Search\Lucene Introduction
===============================

The ``Zend\Search\Lucene`` component is intended to provide a ready-for-use full-text search solution. It doesn't
require any *PHP* extensions [#]_ or additional software to be installed, and can be used immediately after Zend
Framework installation.

``Zend\Search\Lucene`` is a pure *PHP* port of the popular open source full-text search engine known as Apache
Lucene. See http://lucene.apache.org/ for the details.

Information must be indexed to be available for searching. ``Zend\Search\Lucene`` and Java Lucene use a document
concept known as an "atomic indexing item."

Each document is a set of fields: <name, value> pairs where name and value are *UTF-8* strings [#]_. Any subset of
the document fields may be marked as "indexed" to include field data in the text indexing process.

Field values may or may not be tokenized while indexing. If a field is not tokenized, then the field value is
stored as one term; otherwise, the current analyzer is used for tokenization.

Several analyzers are provided within the ``Zend\Search\Lucene`` package. The default analyzer works with *ASCII*
text (since the *UTF-8* analyzer needs the **mbstring** extension to be turned on). It is case insensitive, and it
skips numbers. Use other analyzers or create your own analyzer if you need to change this behavior.

.. note::

   **Using analyzers during indexing and searching**

   Important note! Search queries are also tokenized using the "current analyzer", so the same analyzer must be set
   as the default during both the indexing and searching process. This will guarantee that source and searched text
   will be transformed into terms in the same way.

Field values are optionally stored within an index. This allows the original field data to be retrieved from the
index while searching. This is the only way to associate search results with the original data (internal document
IDs may be changed after index optimization or auto-optimization).

The thing that should be remembered is that a Lucene index is not a database. It doesn't provide index backup
mechanisms except backup of the file system directory. It doesn't provide transactional mechanisms though
concurrent index update as well as concurrent update and read are supported. It doesn't compare with databases in
data retrieving speed.

So it's good idea:

- **Not** to use Lucene index as a storage since it may dramatically decrease search hit retrieving performance.
  Store only unique document identifiers (doc paths, *URL*\ s, database unique IDs) and associated data within an
  index. E.g. title, annotation, category, language info, avatar. (Note: a field may be included in indexing, but
  not stored, or stored, but not indexed).

- To write functionality that can rebuild an index completely if it's corrupted for any reason.

Individual documents in the index may have completely different sets of fields. The same fields in different
documents don't need to have the same attributes. E.g. a field may be indexed for one document and skipped from
indexing for another. The same applies for storing, tokenizing, or treating field value as a binary string.




.. [#] Though some *UTF-8* processing functionality requires the **mbstring** extension to be turned on
.. [#] Binary strings are also allowed to be used as field values