.. _zendsearch.lucene.query-language:

Query Language
==============

Java Lucene and ``Zend\Search\Lucene`` provide quite powerful query languages.

These languages are mostly the same with some minor differences, which are mentioned below.

Full Java Lucene query language syntax documentation can be found `here`_.

.. _zendsearch.lucene.query-language.terms:

Terms
-----

A query is broken up into terms and operators. There are three types of terms: Single Terms, Phrases, and
Subqueries.

A Single Term is a single word such as "test" or "hello".

A Phrase is a group of words surrounded by double quotes such as "hello dolly".

A Subquery is a query surrounded by parentheses such as "(hello dolly)".

Multiple terms can be combined together with boolean operators to form complex queries (see below).

.. _zendsearch.lucene.query-language.fields:

Fields
------

Lucene supports fields of data. When performing a search you can either specify a field, or use the default field.
The field names depend on indexed data and default field is defined by current settings.

The first and most significant difference from Java Lucene is that terms are searched through **all fields** by
default.

There are two static methods in the ``Zend\Search\Lucene`` class which allow the developer to configure these
settings:

.. code-block:: php
   :linenos:

   $defaultSearchField = Zend\Search\Lucene::getDefaultSearchField();
   ...
   Zend\Search\Lucene::setDefaultSearchField('contents');

The ``NULL`` value indicated that the search is performed across all fields. It's the default setting.

You can search specific fields by typing the field name followed by a colon ":" followed by the term you are
looking for.

As an example, let's assume a Lucene index contains two fields- title and text- with text as the default field. If
you want to find the document entitled "The Right Way" which contains the text "don't go this way", you can enter:

.. code-block:: text
   :linenos:

   title:"The Right Way" AND text:go

or

.. code-block:: text
   :linenos:

   title:"Do it right" AND go

Because "text" is the default field, the field indicator is not required.

Note: The field is only valid for the term, phrase or subquery that it directly precedes, so the query

.. code-block:: text
   :linenos:

   title:Do it right

Will only find "Do" in the title field. It will find "it" and "right" in the default field (if the default field is
set) or in all indexed fields (if the default field is set to ``NULL``).

.. _zendsearch.lucene.query-language.wildcard:

Wildcards
---------

Lucene supports single and multiple character wildcard searches within single terms (but not within phrase
queries).

To perform a single character wildcard search use the "?" symbol.

To perform a multiple character wildcard search use the "\*" symbol.

The single character wildcard search looks for string that match the term with the "?" replaced by any single
character. For example, to search for "text" or "test" you can use the search:

.. code-block:: text
   :linenos:

   te?t

Multiple character wildcard searches look for 0 or more characters when matching strings against terms. For
example, to search for test, tests or tester, you can use the search:

.. code-block:: text
   :linenos:

   test*

You can use "?", "\*" or both at any place of the term:

.. code-block:: text
   :linenos:

   *wr?t*

It searches for "write", "wrote", "written", "rewrite", "rewrote" and so on.

Starting from ZF 1.7.7 wildcard patterns need some non-wildcard prefix. Default prefix length is 3 (like in Java
Lucene). So "\*", "te?t", "\*wr?t*" terms will cause an exception [#]_.

It can be altered using ``Zend\Search\Lucene\Search\Query\Wildcard::getMinPrefixLength()`` and
``Zend\Search\Lucene\Search\Query\Wildcard::setMinPrefixLength()`` methods.

.. _zendsearch.lucene.query-language.modifiers:

Term Modifiers
--------------

Lucene supports modifying query terms to provide a wide range of searching options.

"~" modifier can be used to specify proximity search for phrases or fuzzy search for individual terms.

.. _zendsearch.lucene.query-language.range:

Range Searches
--------------

Range queries allow the developer or user to match documents whose field(s) values are between the lower and upper
bound specified by the range query. Range Queries can be inclusive or exclusive of the upper and lower bounds.
Sorting is performed lexicographically.

.. code-block:: text
   :linenos:

   mod_date:[20020101 TO 20030101]

This will find documents whose mod_date fields have values between 20020101 and 20030101, inclusive. Note that
Range Queries are not reserved for date fields. You could also use range queries with non-date fields:

.. code-block:: text
   :linenos:

   title:{Aida TO Carmen}

This will find all documents whose titles would be sorted between Aida and Carmen, but not including Aida and
Carmen.

Inclusive range queries are denoted by square brackets. Exclusive range queries are denoted by curly brackets.

If field is not specified then ``Zend\Search\Lucene`` searches for specified interval through all fields by
default.

.. code-block:: text
   :linenos:

   {Aida TO Carmen}

.. _zendsearch.lucene.query-language.fuzzy:

Fuzzy Searches
--------------

``Zend\Search\Lucene`` as well as Java Lucene supports fuzzy searches based on the Levenshtein Distance, or Edit
Distance algorithm. To do a fuzzy search use the tilde, "~", symbol at the end of a Single word Term. For example
to search for a term similar in spelling to "roam" use the fuzzy search:

.. code-block:: text
   :linenos:

   roam~

This search will find terms like foam and roams. Additional (optional) parameter can specify the required
similarity. The value is between 0 and 1, with a value closer to 1 only terms with a higher similarity will be
matched. For example:

.. code-block:: text
   :linenos:

   roam~0.8

The default that is used if the parameter is not given is 0.5.

.. _zendsearch.lucene.query-language.matched-terms-limitations:

Matched terms limitation
------------------------

Wildcard, range and fuzzy search queries may match too many terms. It may cause incredible search performance
downgrade.

So ``Zend\Search\Lucene`` sets a limit of matching terms per query (subquery). This limit can be retrieved and set
using ``Zend\Search\Lucene::getTermsPerQueryLimit()`` and ``Zend\Search\Lucene::setTermsPerQueryLimit($limit)``
methods.

Default matched terms per query limit is 1024.

.. _zendsearch.lucene.query-language.proximity-search:

Proximity Searches
------------------

Lucene supports finding words from a phrase that are within a specified word distance in a string. To do a
proximity search use the tilde, "~", symbol at the end of the phrase. For example to search for a "Zend" and
"Framework" within 10 words of each other in a document use the search:

.. code-block:: text
   :linenos:

   "Zend Framework"~10

.. _zendsearch.lucene.query-language.boosting:

Boosting a Term
---------------

Java Lucene and ``Zend\Search\Lucene`` provide the relevance level of matching documents based on the terms found.
To boost the relevance of a term use the caret, "^", symbol with a boost factor (a number) at the end of the term
you are searching. The higher the boost factor, the more relevant the term will be.

Boosting allows you to control the relevance of a document by boosting individual terms. For example, if you are
searching for

.. code-block:: text
   :linenos:

   PHP framework

and you want the term "PHP" to be more relevant boost it using the ^ symbol along with the boost factor next to the
term. You would type:

.. code-block:: text
   :linenos:

   PHP^4 framework

This will make documents with the term *PHP* appear more relevant. You can also boost phrase terms and subqueries
as in the example:

.. code-block:: text
   :linenos:

   "PHP framework"^4 "Zend Framework"

By default, the boost factor is 1. Although the boost factor must be positive, it may be less than 1 (e.g. 0.2).

.. _zendsearch.lucene.query-language.boolean:

Boolean Operators
-----------------

Boolean operators allow terms to be combined through logic operators. Lucene supports AND, "+", OR, NOT and "-" as
Boolean operators. Java Lucene requires boolean operators to be ALL CAPS. ``Zend\Search\Lucene`` does not.

AND, OR, and NOT operators and "+", "-" defines two different styles to construct boolean queries. Unlike Java
Lucene, ``Zend\Search\Lucene`` doesn't allow these two styles to be mixed.

If the AND/OR/NOT style is used, then an AND or OR operator must be present between all query terms. Each term may
also be preceded by NOT operator. The AND operator has higher precedence than the OR operator. This differs from
Java Lucene behavior.

.. _zendsearch.lucene.query-language.boolean.and:

AND
^^^

The AND operator means that all terms in the "AND group" must match some part of the searched field(s).

To search for documents that contain "PHP framework" and "Zend Framework" use the query:

.. code-block:: text
   :linenos:

   "PHP framework" AND "Zend Framework"

.. _zendsearch.lucene.query-language.boolean.or:

OR
^^

The OR operator divides the query into several optional terms.

To search for documents that contain "PHP framework" or "Zend Framework" use the query:

.. code-block:: text
   :linenos:

   "PHP framework" OR "Zend Framework"

.. _zendsearch.lucene.query-language.boolean.not:

NOT
^^^

The NOT operator excludes documents that contain the term after NOT. But an "AND group" which contains only terms
with the NOT operator gives an empty result set instead of a full set of indexed documents.

To search for documents that contain "PHP framework" but not "Zend Framework" use the query:

.. code-block:: text
   :linenos:

   "PHP framework" AND NOT "Zend Framework"

.. _zendsearch.lucene.query-language.boolean.other-form:

&&, \||, and ! operators
^^^^^^^^^^^^^^^^^^^^^^^^

&&, \||, and ! may be used instead of AND, OR, and NOT notation.

.. _zendsearch.lucene.query-language.boolean.plus:

\+
^^

The "+" or required operator stipulates that the term after the "+" symbol must match the document.

To search for documents that must contain "Zend" and may contain "Framework" use the query:

.. code-block:: text
   :linenos:

   +Zend Framework

.. _zendsearch.lucene.query-language.boolean.minus:

\-
^^

The "-" or prohibit operator excludes documents that match the term after the "-" symbol.

To search for documents that contain "PHP framework" but not "Zend Framework" use the query:

.. code-block:: text
   :linenos:

   "PHP framework" -"Zend Framework"

.. _zendsearch.lucene.query-language.boolean.no-operator:

No Operator
^^^^^^^^^^^

If no operator is used, then the search behavior is defined by the "default boolean operator".

This is set to 'OR' by default.

That implies each term is optional by default. It may or may not be present within document, but documents with
this term will receive a higher score.

To search for documents that requires "PHP framework" and may contain "Zend Framework" use the query:

.. code-block:: text
   :linenos:

   +"PHP framework" "Zend Framework"

The default boolean operator may be set or retrieved with the
``Zend\Search\Lucene\Search\QueryParser::setDefaultOperator($operator)`` and
``Zend\Search\Lucene\Search\QueryParser::getDefaultOperator()`` methods, respectively.

These methods operate with the ``Zend\Search\Lucene\Search\QueryParser::B_AND`` and
``Zend\Search\Lucene\Search\QueryParser::B_OR`` constants.

.. _zendsearch.lucene.query-language.grouping:

Grouping
--------

Java Lucene and ``Zend\Search\Lucene`` support using parentheses to group clauses to form sub queries. This can be
useful if you want to control the precedence of boolean logic operators for a query or mix different boolean query
styles:

.. code-block:: text
   :linenos:

   +(framework OR library) +php

``Zend\Search\Lucene`` supports subqueries nested to any level.

.. _zendsearch.lucene.query-language.field-grouping:

Field Grouping
--------------

Lucene also supports using parentheses to group multiple clauses to a single field.

To search for a title that contains both the word "return" and the phrase "pink panther" use the query:

.. code-block:: text
   :linenos:

   title:(+return +"pink panther")

.. _zendsearch.lucene.query-language.escaping:

Escaping Special Characters
---------------------------

Lucene supports escaping special characters that are used in query syntax. The current list of special characters
is:

\+ - && \|| ! ( ) { } [ ] ^ " ~ * ? : \\

\+ and - inside single terms are automatically treated as common characters.

For other instances of these characters use the \\ before each special character you'd like to escape. For example
to search for (1+1):2 use the query:

.. code-block:: text
   :linenos:

   \(1\+1\)\:2



.. _`here`: http://lucene.apache.org/java/2_3_0/queryparsersyntax.html

.. [#] Please note, that it's not a ``Zend\Search\Lucene\Search\QueryParserException``, but a
       ``Zend\Search\Lucene\Exception``. It's thrown during query rewrite (execution) operation.