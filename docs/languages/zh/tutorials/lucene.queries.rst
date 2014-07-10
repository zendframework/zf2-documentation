.. _learning.lucene.queries:

Supported queries
=================

``Zend\Search\Lucene`` and Java Lucene support a powerful query language. It allows searching for individual terms,
phrases, ranges of terms; using wildcards and fuzzy search; combining queries using boolean operators; and so on.

A detailed query language description can be found in the :ref:`Zend\Search\Lucene component documentation
<zend.search.lucene.query-language>`.

What follows are examples of some common query types and strategies.

.. _learning.lucene.queries.keyword:

.. rubric:: Querying for a single word

.. code-block:: text
   :linenos:

   hello

Searches for the word "hello" through all document fields.

.. note::

   **Default search field**

   Important note! Java Lucene searches only through the "contents" field by default, but ``Zend\Search\Lucene``
   searches through **all** fields. This behavior can be modified using the
   ``Zend\Search\Lucene::setDefaultSearchField($fieldName)`` method.

.. _learning.lucene.queries.multiple-words:

.. rubric:: Querying for multiple words

.. code-block:: text
   :linenos:

   hello dolly

Searches for two words. Both words are optional; at least one of them must be present in the result.

.. _learning.lucene.queries.required-words:

.. rubric:: Requiring words in a query

.. code-block:: text
   :linenos:

   +hello dolly

Searches for two words; "hello" is required, "dolly" is optional.

.. _learning.lucene.queries.prohibited-words:

.. rubric:: Prohibiting words in queried documents

.. code-block:: text
   :linenos:

   +hello -dolly

Searches for two words; "hello" is required, 'dolly' is prohibited. In other words, if the document matches
"hello", but contains the word "dolly", it will not be returned in the set of matches.

.. _learning.lucene.queries.phrases:

.. rubric:: Querying for phrases

.. code-block:: text
   :linenos:

   "hello dolly"

Searches for the phrase "hello dolly"; a document only matches if that exact string is present.

.. _learning.lucene.queries.fields:

.. rubric:: Querying against specific fields

.. code-block:: text
   :linenos:

   title:"The Right Way" AND text:go

Searches for the phrase "The Right Way" within the ``title`` field and the word "go" within the ``text`` field.

.. _learning.lucene.queries.fields-and-document:

.. rubric:: Querying against specific fields as well as the entire document

.. code-block:: text
   :linenos:

   title:"The Right Way" AND  go

Searches for the phrase "The Right Way" within the ``title`` field and the word "go" word appearing in any field of
the document.

.. _learning.lucene.queries.fields-and-document-alt:

.. rubric:: Querying against specific fields as well as the entire document (alternate)

.. code-block:: text
   :linenos:

   title:Do it right

Searches for the word "Do" within the ``title`` field and the words "it" and "right" words through all fields; any
single one matching will result in a document match.

.. _learning.lucene.queries.wildcard-question:

.. rubric:: Querying with the wildcard "?"

.. code-block:: text
   :linenos:

   te?t

Search for words matching the pattern "te?t", where "?" is any single character.

.. _learning.lucene.queries.wildcard-asterisk:

.. rubric:: Querying with the wildcard "\*"

.. code-block:: text
   :linenos:

   test*

Search for words matching the pattern "test*", where "\*" is any sequence of zero or more characters.

.. _learning.lucene.queries.range-inclusive:

.. rubric:: Querying for an inclusive range of terms

.. code-block:: text
   :linenos:

   mod_date:[20020101 TO 20030101]

Search for the range of terms (inclusive).

.. _learning.lucene.queries.range-exclusive:

.. rubric:: Querying for an exclusive range of terms

.. code-block:: text
   :linenos:

   title:{Aida to Carmen}

Search for the range of terms (exclusive).

.. _learning.lucene.queries.fuzzy:

.. rubric:: Fuzzy searches

.. code-block:: text
   :linenos:

   roam~

Fuzzy search for the word "roam".

.. _learning.lucene.queries.boolean:

.. rubric:: Boolean searches

.. code-block:: text
   :linenos:

   (framework OR library) AND php

Boolean query.

All supported queries can be constructed through ``Zend\Search\Lucene``'s :ref:`query construction API
<zend.search.lucene.query-api>`. Moreover, query parsing and query constructing may be combined:

.. _learning.lucene.queries.combining:

.. rubric:: Combining parsed and constructed queries

.. code-block:: php
   :linenos:

   $userQuery = Zend\Search\Lucene\Search\QueryParser::parse($queryStr);

   $query = new Zend\Search\Lucene\Search\Query\Boolean();
   $query->addSubquery($userQuery, true  /* required */);
   $query->addSubquery($constructedQuery, true  /* required */);


