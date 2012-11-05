.. _zendsearch.lucene.query-api:

Query Construction API
======================

In addition to parsing a string query automatically it's also possible to construct them with the query *API*.

User queries can be combined with queries created through the query *API*. Simply use the query parser to construct
a query from a string:

.. code-block:: php
   :linenos:

   $query = Zend\Search\Lucene\Search\QueryParser::parse($queryString);

.. _zendsearch.lucene.queries.exceptions:

Query Parser Exceptions
-----------------------

The query parser may generate two types of exceptions:



   - ``Zend\Search\Lucene\Exception`` is thrown if something goes wrong in the query parser itself.

   - ``Zend\Search\Lucene\Search\QueryParserException`` is thrown when there is an error in the query syntax.

It's a good idea to catch ``Zend\Search\Lucene\Search\QueryParserException``\ s and handle them appropriately:

.. code-block:: php
   :linenos:

   try {
       $query = Zend\Search\Lucene\Search\QueryParser::parse($queryString);
   } catch (Zend\Search\Lucene\Search\QueryParserException $e) {
       echo "Query syntax error: " . $e->getMessage() . "\n";
   }

The same technique should be used for the find() method of a ``Zend\Search\Lucene`` object.

Starting in 1.5, query parsing exceptions are suppressed by default. If query doesn't conform query language, then
it's tokenized using current default analyzer and all tokenized terms are used for searching. Use
``Zend\Search\Lucene\Search\QueryParser::dontSuppressQueryParsingExceptions()`` method to turn exceptions on.
``Zend\Search\Lucene\Search\QueryParser::suppressQueryParsingExceptions()`` and
``Zend\Search\Lucene\Search\QueryParser::queryParsingExceptionsSuppressed()`` methods are also intended to manage
exceptions handling behavior.

.. _zendsearch.lucene.queries.term-query:

Term Query
----------

Term queries can be used for searching with a single term.

Query string:

.. code-block:: text
   :linenos:

   word1

or

Query construction by *API*:

.. code-block:: php
   :linenos:

   $term  = new Zend\Search\Lucene\Index\Term('word1', 'field1');
   $query = new Zend\Search\Lucene\Search\Query\Term($term);
   $hits  = $index->find($query);

The term field is optional. ``Zend\Search\Lucene`` searches through all indexed fields in each document if the
field is not specified:

.. code-block:: php
   :linenos:

   // Search for 'word1' in all indexed fields
   $term  = new Zend\Search\Lucene\Index\Term('word1');
   $query = new Zend\Search\Lucene\Search\Query\Term($term);
   $hits  = $index->find($query);

.. _zendsearch.lucene.queries.multiterm-query:

Multi-Term Query
----------------

Multi-term queries can be used for searching with a set of terms.

Each term in a set can be defined as **required**, **prohibited**, or **neither**.



   - **required** means that documents not matching this term will not match the query;

   - **prohibited** means that documents matching this term will not match the query;

   - **neither**, in which case matched documents are neither prohibited from, nor required to, match the term. A
     document must match at least 1 term, however, to match the query.



If optional terms are added to a query with required terms, both queries will have the same result set but the
optional terms may affect the score of the matched documents.

Both search methods can be used for multi-term queries.

Query string:

.. code-block:: text
   :linenos:

   +word1 author:word2 -word3

- '+' is used to define a required term.

- '-' is used to define a prohibited term.

- 'field:' prefix is used to indicate a document field for a search. If it's omitted, then all fields are searched.

or

Query construction by *API*:

.. code-block:: php
   :linenos:

   $query = new Zend\Search\Lucene\Search\Query\MultiTerm();

   $query->addTerm(new Zend\Search\Lucene\Index\Term('word1'), true);
   $query->addTerm(new Zend\Search\Lucene\Index\Term('word2', 'author'),
                   null);
   $query->addTerm(new Zend\Search\Lucene\Index\Term('word3'), false);

   $hits  = $index->find($query);

It's also possible to specify terms list within MultiTerm query constructor:

.. code-block:: php
   :linenos:

   $terms = array(new Zend\Search\Lucene\Index\Term('word1'),
                  new Zend\Search\Lucene\Index\Term('word2', 'author'),
                  new Zend\Search\Lucene\Index\Term('word3'));
   $signs = array(true, null, false);

   $query = new Zend\Search\Lucene\Search\Query\MultiTerm($terms, $signs);

   $hits  = $index->find($query);

The ``$signs`` array contains information about the term type:



   - ``TRUE`` is used to define required term.

   - ``FALSE`` is used to define prohibited term.

   - ``NULL`` is used to define a term that is neither required nor prohibited.



.. _zendsearch.lucene.queries.boolean-query:

Boolean Query
-------------

Boolean queries allow to construct query using other queries and boolean operators.

Each subquery in a set can be defined as **required**, **prohibited**, or **optional**.



   - **required** means that documents not matching this subquery will not match the query;

   - **prohibited** means that documents matching this subquery will not match the query;

   - **optional**, in which case matched documents are neither prohibited from, nor required to, match the
     subquery. A document must match at least 1 subquery, however, to match the query.



If optional subqueries are added to a query with required subqueries, both queries will have the same result set
but the optional subqueries may affect the score of the matched documents.

Both search methods can be used for boolean queries.

Query string:

.. code-block:: text
   :linenos:

   +(word1 word2 word3) (author:word4 author:word5) -(word6)

- '+' is used to define a required subquery.

- '-' is used to define a prohibited subquery.

- 'field:' prefix is used to indicate a document field for a search. If it's omitted, then all fields are searched.

or

Query construction by *API*:

.. code-block:: php
   :linenos:

   $query = new Zend\Search\Lucene\Search\Query\Boolean();

   $subquery1 = new Zend\Search\Lucene\Search\Query\MultiTerm();
   $subquery1->addTerm(new Zend\Search\Lucene\Index\Term('word1'));
   $subquery1->addTerm(new Zend\Search\Lucene\Index\Term('word2'));
   $subquery1->addTerm(new Zend\Search\Lucene\Index\Term('word3'));

   $subquery2 = new Zend\Search\Lucene\Search\Query\MultiTerm();
   $subquery2->addTerm(new Zend\Search\Lucene\Index\Term('word4', 'author'));
   $subquery2->addTerm(new Zend\Search\Lucene\Index\Term('word5', 'author'));

   $term6 = new Zend\Search\Lucene\Index\Term('word6');
   $subquery3 = new Zend\Search\Lucene\Search\Query\Term($term6);

   $query->addSubquery($subquery1, true  /* required */);
   $query->addSubquery($subquery2, null  /* optional */);
   $query->addSubquery($subquery3, false /* prohibited */);

   $hits  = $index->find($query);

It's also possible to specify subqueries list within Boolean query constructor:

.. code-block:: php
   :linenos:

   ...
   $subqueries = array($subquery1, $subquery2, $subquery3);
   $signs = array(true, null, false);

   $query = new Zend\Search\Lucene\Search\Query\Boolean($subqueries, $signs);

   $hits  = $index->find($query);

The ``$signs`` array contains information about the subquery type:



   - ``TRUE`` is used to define required subquery.

   - ``FALSE`` is used to define prohibited subquery.

   - ``NULL`` is used to define a subquery that is neither required nor prohibited.



Each query which uses boolean operators can be rewritten using signs notation and constructed using *API*. For
example:

.. code-block:: text
   :linenos:

   word1 AND (word2 AND word3 AND NOT word4) OR word5

is equivalent to

.. code-block:: text
   :linenos:

   (+(word1) +(+word2 +word3 -word4)) (word5)

.. _zendsearch.lucene.queries.wildcard:

Wildcard Query
--------------

Wildcard queries can be used to search for documents containing strings matching specified patterns.

The '?' symbol is used as a single character wildcard.

The '\*' symbol is used as a multiple character wildcard.

Query string:

.. code-block:: text
   :linenos:

   field1:test*

or

Query construction by *API*:

.. code-block:: php
   :linenos:

   $pattern = new Zend\Search\Lucene\Index\Term('test*', 'field1');
   $query = new Zend\Search\Lucene\Search\Query\Wildcard($pattern);
   $hits  = $index->find($query);

The term field is optional. ``Zend\Search\Lucene`` searches through all fields on each document if a field is not
specified:

.. code-block:: php
   :linenos:

   $pattern = new Zend\Search\Lucene\Index\Term('test*');
   $query = new Zend\Search\Lucene\Search\Query\Wildcard($pattern);
   $hits  = $index->find($query);

.. _zendsearch.lucene.queries.fuzzy:

Fuzzy Query
-----------

Fuzzy queries can be used to search for documents containing strings matching terms similar to specified term.

Query string:

.. code-block:: text
   :linenos:

   field1:test~

This query matches documents containing 'test' 'text' 'best' words and others.

or

Query construction by *API*:

.. code-block:: php
   :linenos:

   $term = new Zend\Search\Lucene\Index\Term('test', 'field1');
   $query = new Zend\Search\Lucene\Search\Query\Fuzzy($term);
   $hits  = $index->find($query);

Optional similarity can be specified after "~" sign.

Query string:

.. code-block:: text
   :linenos:

   field1:test~0.4

or

Query construction by *API*:

.. code-block:: php
   :linenos:

   $term = new Zend\Search\Lucene\Index\Term('test', 'field1');
   $query = new Zend\Search\Lucene\Search\Query\Fuzzy($term, 0.4);
   $hits  = $index->find($query);

The term field is optional. ``Zend\Search\Lucene`` searches through all fields on each document if a field is not
specified:

.. code-block:: php
   :linenos:

   $term = new Zend\Search\Lucene\Index\Term('test');
   $query = new Zend\Search\Lucene\Search\Query\Fuzzy($term);
   $hits  = $index->find($query);

.. _zendsearch.lucene.queries.phrase-query:

Phrase Query
------------

Phrase Queries can be used to search for a phrase within documents.

Phrase Queries are very flexible and allow the user or developer to search for exact phrases as well as 'sloppy'
phrases.

Phrases can also contain gaps or terms in the same places; they can be generated by the analyzer for different
purposes. For example, a term can be duplicated to increase the term its weight, or several synonyms can be placed
into a single position.

.. code-block:: php
   :linenos:

   $query1 = new Zend\Search\Lucene\Search\Query\Phrase();

   // Add 'word1' at 0 relative position.
   $query1->addTerm(new Zend\Search\Lucene\Index\Term('word1'));

   // Add 'word2' at 1 relative position.
   $query1->addTerm(new Zend\Search\Lucene\Index\Term('word2'));

   // Add 'word3' at 3 relative position.
   $query1->addTerm(new Zend\Search\Lucene\Index\Term('word3'), 3);

   ...

   $query2 = new Zend\Search\Lucene\Search\Query\Phrase(
                   array('word1', 'word2', 'word3'), array(0,1,3));

   ...

   // Query without a gap.
   $query3 = new Zend\Search\Lucene\Search\Query\Phrase(
                   array('word1', 'word2', 'word3'));

   ...

   $query4 = new Zend\Search\Lucene\Search\Query\Phrase(
                   array('word1', 'word2'), array(0,1), 'annotation');

A phrase query can be constructed in one step with a class constructor or step by step with
``Zend\Search\Lucene\Search\Query\Phrase::addTerm()`` method calls.

``Zend\Search\Lucene\Search\Query\Phrase`` class constructor takes three optional arguments:

.. code-block:: php
   :linenos:

   Zend\Search\Lucene\Search\Query\Phrase(
       [array $terms[, array $offsets[, string $field]]]
   );

The ``$terms`` parameter is an array of strings that contains a set of phrase terms. If it's omitted or equal to
``NULL``, then an empty query is constructed.

The ``$offsets`` parameter is an array of integers that contains offsets of terms in a phrase. If it's omitted or
equal to ``NULL``, then the terms' positions are assumed to be sequential with no gaps.

The ``$field`` parameter is a string that indicates the document field to search. If it's omitted or equal to
``NULL``, then the default field is searched.

Thus:

.. code-block:: php
   :linenos:

   $query =
       new Zend\Search\Lucene\Search\Query\Phrase(array('zend', 'framework'));

will search for the phrase 'zend framework' in all fields.

.. code-block:: php
   :linenos:

   $query = new Zend\Search\Lucene\Search\Query\Phrase(
                    array('zend', 'download'), array(0, 2)
                );

will search for the phrase 'zend ????? download' and match 'zend platform download', 'zend studio download', 'zend
core download', 'zend framework download', and so on.

.. code-block:: php
   :linenos:

   $query = new Zend\Search\Lucene\Search\Query\Phrase(
                    array('zend', 'framework'), null, 'title'
                );

will search for the phrase 'zend framework' in the 'title' field.

``Zend\Search\Lucene\Search\Query\Phrase::addTerm()`` takes two arguments, a required
``Zend\Search\Lucene\Index\Term`` object and an optional position:

.. code-block:: php
   :linenos:

   Zend\Search\Lucene\Search\Query\Phrase::addTerm(
       Zend\Search\Lucene\Index\Term $term[, integer $position]
   );

The ``$term`` parameter describes the next term in the phrase. It must indicate the same field as previous terms,
or an exception will be thrown.

The ``$position`` parameter indicates the term position in the phrase.

Thus:

.. code-block:: php
   :linenos:

   $query = new Zend\Search\Lucene\Search\Query\Phrase();
   $query->addTerm(new Zend\Search\Lucene\Index\Term('zend'));
   $query->addTerm(new Zend\Search\Lucene\Index\Term('framework'));

will search for the phrase 'zend framework'.

.. code-block:: php
   :linenos:

   $query = new Zend\Search\Lucene\Search\Query\Phrase();
   $query->addTerm(new Zend\Search\Lucene\Index\Term('zend'), 0);
   $query->addTerm(new Zend\Search\Lucene\Index\Term('framework'), 2);

will search for the phrase 'zend ????? download' and match 'zend platform download', 'zend studio download', 'zend
core download', 'zend framework download', and so on.

.. code-block:: php
   :linenos:

   $query = new Zend\Search\Lucene\Search\Query\Phrase();
   $query->addTerm(new Zend\Search\Lucene\Index\Term('zend', 'title'));
   $query->addTerm(new Zend\Search\Lucene\Index\Term('framework', 'title'));

will search for the phrase 'zend framework' in the 'title' field.

The slop factor sets the number of other words permitted between specified words in the query phrase. If set to
zero, then the corresponding query is an exact phrase search. For larger values this works like the WITHIN or NEAR
operators.

The slop factor is in fact an edit distance, where the edits correspond to moving terms in the query phrase. For
example, to switch the order of two words requires two moves (the first move places the words atop one another), so
to permit re-orderings of phrases, the slop factor must be at least two.

More exact matches are scored higher than sloppier matches; thus, search results are sorted by exactness. The slop
is zero by default, requiring exact matches.

The slop factor can be assigned after query creation:

.. code-block:: php
   :linenos:

   // Query without a gap.
   $query =
       new Zend\Search\Lucene\Search\Query\Phrase(array('word1', 'word2'));

   // Search for 'word1 word2', 'word1 ... word2'
   $query->setSlop(1);
   $hits1 = $index->find($query);

   // Search for 'word1 word2', 'word1 ... word2',
   // 'word1 ... ... word2', 'word2 word1'
   $query->setSlop(2);
   $hits2 = $index->find($query);

.. _zendsearch.lucene.queries.range:

Range Query
-----------

:ref:`Range queries <zendsearch.lucene.query-language.range>` are intended for searching terms within specified
interval.

Query string:

.. code-block:: text
   :linenos:

   mod_date:[20020101 TO 20030101]
   title:{Aida TO Carmen}

or

Query construction by *API*:

.. code-block:: php
   :linenos:

   $from = new Zend\Search\Lucene\Index\Term('20020101', 'mod_date');
   $to   = new Zend\Search\Lucene\Index\Term('20030101', 'mod_date');
   $query = new Zend\Search\Lucene\Search\Query\Range(
                    $from, $to, true // inclusive
                );
   $hits  = $index->find($query);

Term fields are optional. ``Zend\Search\Lucene`` searches through all fields if the field is not specified:

.. code-block:: php
   :linenos:

   $from = new Zend\Search\Lucene\Index\Term('Aida');
   $to   = new Zend\Search\Lucene\Index\Term('Carmen');
   $query = new Zend\Search\Lucene\Search\Query\Range(
                    $from, $to, false // non-inclusive
                );
   $hits  = $index->find($query);

Either (but not both) of the boundary terms may be set to ``NULL``. ``Zend\Search\Lucene`` searches from the
beginning or up to the end of the dictionary for the specified field(s) in this case:

.. code-block:: php
   :linenos:

   // searches for ['20020101' TO ...]
   $from = new Zend\Search\Lucene\Index\Term('20020101', 'mod_date');
   $query = new Zend\Search\Lucene\Search\Query\Range(
                    $from, null, true // inclusive
                );
   $hits  = $index->find($query);


