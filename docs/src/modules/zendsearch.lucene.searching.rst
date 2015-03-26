.. _zendsearch.lucene.searching:

Searching an Index
==================

.. _zendsearch.lucene.searching.query_building:

Building Queries
----------------

There are two ways to search the index. The first method uses query parser to construct a query from a string. The
second is to programmatically create your own queries through the ``Zend\Search\Lucene`` *API*.

Before choosing to use the provided query parser, please consider the following:



   . If you are programmatically creating a query string and then parsing it with the query parser then you should
     consider building your queries directly with the query *API*. Generally speaking, the query parser is designed
     for human-entered text, not for program-generated text.

   . Untokenized fields are best added directly to queries and not through the query parser. If a field's values
     are generated programmatically by the application, then the query clauses for this field should also be
     constructed programmatically. An analyzer, which the query parser uses, is designed to convert human-entered
     text to terms. Program-generated values, like dates, keywords, etc., should be added with the query *API*.

   . In a query form, fields that are general text should use the query parser. All others, such as date ranges,
     keywords, etc., are better added directly through the query *API*. A field with a limited set of values that
     can be specified with a pull-down menu should not be added to a query string that is subsequently parsed but
     instead should be added as a TermQuery clause.

   . Boolean queries allow the programmer to logically combine two or more queries into new one. Thus it's the best
     way to add additional criteria to a search defined by a query string.



Both ways use the same *API* method to search through the index:

.. code-block:: php
   :linenos:

   $index = Zend\Search\Lucene::open('/data/my_index');

   $index->find($query);

The ``Zend\Search\Lucene::find()`` method determines the input type automatically and uses the query parser to
construct an appropriate ``Zend\Search\Lucene\Search\Query`` object from an input of type string.

It is important to note that the query parser uses the standard analyzer to tokenize separate parts of query
string. Thus all transformations which are applied to indexed text are also applied to query strings.

The standard analyzer may transform the query string to lower case for case-insensitivity, remove stop-words, and
stem among other transformations.

The *API* method doesn't transform or filter input terms in any way. It's therefore more suitable for computer
generated or untokenized fields.

.. _zendsearch.lucene.searching.query_building.parsing:

Query Parsing
^^^^^^^^^^^^^

``Zend\Search\Lucene\Search\QueryParser::parse()`` method may be used to parse query strings into query objects.

This query object may be used in query construction *API* methods to combine user entered queries with
programmatically generated queries.

Actually, in some cases it's the only way to search for values within untokenized fields:

.. code-block:: php
   :linenos:

   $userQuery = Zend\Search\Lucene\Search\QueryParser::parse($queryStr);

   $pathTerm  = new Zend\Search\Lucene\Index\Term(
                        '/data/doc_dir/' . $filename, 'path'
                    );
   $pathQuery = new Zend\Search\Lucene\Search\Query\Term($pathTerm);

   $query = new Zend\Search\Lucene\Search\Query\Boolean();
   $query->addSubquery($userQuery, true /* required */);
   $query->addSubquery($pathQuery, true /* required */);

   $hits = $index->find($query);

``Zend\Search\Lucene\Search\QueryParser::parse()`` method also takes an optional encoding parameter, which can
specify query string encoding:

.. code-block:: php
   :linenos:

   $userQuery = Zend\Search\Lucene\Search\QueryParser::parse($queryStr,
                                                             'iso-8859-5');

If the encoding parameter is omitted, then current locale is used.

It's also possible to specify the default query string encoding with
``Zend\Search\Lucene\Search\QueryParser::setDefaultEncoding()`` method:

.. code-block:: php
   :linenos:

   Zend\Search\Lucene\Search\QueryParser::setDefaultEncoding('iso-8859-5');
   ...
   $userQuery = Zend\Search\Lucene\Search\QueryParser::parse($queryStr);

``Zend\Search\Lucene\Search\QueryParser::getDefaultEncoding()`` returns the current default query string encoding
(the empty string means "current locale").

.. _zendsearch.lucene.searching.results:

Search Results
--------------

The search result is an array of ``Zend\Search\Lucene\Search\QueryHit`` objects. Each of these has two properties:
*$hit->id* is a document number within the index and *$hit->score* is a score of the hit in a search result. The
results are ordered by score (descending from highest score).

The ``Zend\Search\Lucene\Search\QueryHit`` object also exposes each field of the ``Zend\Search\Lucene\Document``
found in the search as a property of the hit. In the following example, a hit is returned with two fields from the
corresponding document: title and author.

.. code-block:: php
   :linenos:

   $index = Zend\Search\Lucene::open('/data/my_index');

   $hits = $index->find($query);

   foreach ($hits as $hit) {
       echo $hit->score;
       echo $hit->title;
       echo $hit->author;
   }

Stored fields are always returned in UTF-8 encoding.

Optionally, the original ``Zend\Search\Lucene\Document`` object can be returned from the
``Zend\Search\Lucene\Search\QueryHit``. You can retrieve stored parts of the document by using the
``getDocument()`` method of the index object and then get them by ``getFieldValue()`` method:

.. code-block:: php
   :linenos:

   $index = Zend\Search\Lucene::open('/data/my_index');

   $hits = $index->find($query);
   foreach ($hits as $hit) {
       // return Zend\Search\Lucene\Document object for this hit
       echo $document = $hit->getDocument();

       // return a Zend\Search\Lucene\Field object
       // from the Zend\Search\Lucene\Document
       echo $document->getField('title');

       // return the string value of the Zend\Search\Lucene\Field object
       echo $document->getFieldValue('title');

       // same as getFieldValue()
       echo $document->title;
   }

The fields available from the ``Zend\Search\Lucene\Document`` object are determined at the time of indexing. The
document fields are either indexed, or index and stored, in the document by the indexing application (e.g.
LuceneIndexCreation.jar).

Note that the document identity ('path' in our example) is also stored in the index and must be retrieved from it.

.. _zendsearch.lucene.searching.results-limiting:

Limiting the Result Set
-----------------------

The most computationally expensive part of searching is score calculation. It may take several seconds for large
result sets (tens of thousands of hits).

``Zend\Search\Lucene`` gives the possibility to limit result set size with ``getResultSetLimit()`` and
``setResultSetLimit()`` methods:

.. code-block:: php
   :linenos:

   $currentResultSetLimit = Zend\Search\Lucene::getResultSetLimit();

   Zend\Search\Lucene::setResultSetLimit($newLimit);

The default value of 0 means 'no limit'.

It doesn't give the 'best N' results, but only the 'first N'[#]_.

.. _zendsearch.lucene.searching.results-scoring:

Results Scoring
---------------

``Zend\Search\Lucene`` uses the same scoring algorithms as Java Lucene. All hits in the search result are ordered
by score by default. Hits with greater score come first, and documents having higher scores should match the query
more precisely than documents having lower scores.

Roughly speaking, search hits that contain the searched term or phrase more frequently will have a higher score.

A hit's score can be retrieved by accessing the *score* property of the hit:

.. code-block:: php
   :linenos:

   $hits = $index->find($query);

   foreach ($hits as $hit) {
       echo $hit->id;
       echo $hit->score;
   }

The ``Zend\Search\Lucene\Search\Similarity`` class is used to calculate the score for each hit. See
:ref:`Extensibility. Scoring Algorithms <zendsearch.lucene.extending.scoring>` section for details.

.. _zendsearch.lucene.searching.sorting:

Search Result Sorting
---------------------

By default, the search results are ordered by score. The programmer can change this behavior by setting a sort
field (or a list of fields), sort type and sort order parameters.

*$index->find()* call may take several optional parameters:

.. code-block:: php
   :linenos:

   $index->find($query [, $sortField [, $sortType [, $sortOrder]]]
                       [, $sortField2 [, $sortType [, $sortOrder]]]
                ...);

A name of stored field by which to sort result should be passed as the ``$sortField`` parameter.

``$sortType`` may be omitted or take the following enumerated values: ``SORT_REGULAR`` (compare items normally-
default value), ``SORT_NUMERIC`` (compare items numerically), ``SORT_STRING`` (compare items as strings).

``$sortOrder`` may be omitted or take the following enumerated values: ``SORT_ASC`` (sort in ascending order-
default value), ``SORT_DESC`` (sort in descending order).

Examples:

.. code-block:: php
   :linenos:

   $index->find($query, 'quantity', SORT_NUMERIC, SORT_DESC);

.. code-block:: php
   :linenos:

   $index->find($query, 'fname', SORT_STRING, 'lname', SORT_STRING);

.. code-block:: php
   :linenos:

   $index->find($query, 'name', SORT_STRING, 'quantity', SORT_NUMERIC, SORT_DESC);

Please use caution when using a non-default search order; the query needs to retrieve documents completely from an
index, which may dramatically reduce search performance.

.. _zendsearch.lucene.searching.highlighting:

Search Results Highlighting
---------------------------

``Zend\Search\Lucene`` provides two options for search results highlighting.

The first one is utilizing ``Zend\Search\Lucene\Document\Html`` class (see :ref:`HTML documents section
<zendsearch.lucene.index-creation.html-documents>` for details) using the following methods:

.. code-block:: php
   :linenos:

   /**
    * Highlight text with specified color
    *
    * @param string|array $words
    * @param string $colour
    * @return string
    */
   public function highlight($words, $colour = '#66ffff');

.. code-block:: php
   :linenos:

   /**
    * Highlight text using specified View helper or callback function.
    *
    * @param string|array $words  Words to highlight. Words could be organized
                                  using the array or string.
    * @param callback $callback   Callback method, used to transform
                                  (highlighting) text.
    * @param array    $params     Array of additional callback parameters passed
                                  through into it (first non-optional parameter
                                  is an HTML fragment for highlighting)
    * @return string
    * @throws Zend\Search\Lucene\Exception
    */
   public function highlightExtended($words, $callback, $params = array())

To customize highlighting behavior use ``highlightExtended()`` method with specified callback, which takes one or
more parameters [#]_, or extend ``Zend\Search\Lucene\Document\Html`` class and redefine
``applyColour($stringToHighlight, $colour)`` method used as a default highlighting callback. [#]_

:ref:`View helpers <zend.view.helpers>` also can be used as callbacks in context of view script:

.. code-block:: php
   :linenos:

   $doc->highlightExtended('word1 word2 word3...', array($this, 'myViewHelper'));

The result of highlighting operation is retrieved by *Zend\Search\Lucene\Document\Html->getHTML()* method.

.. note::

   Highlighting is performed in terms of current analyzer. So all forms of the word(s) recognized by analyzer are
   highlighted.

   E.g. if current analyzer is case insensitive and we request to highlight 'text' word, then 'text', 'Text',
   'TEXT' and other case combinations will be highlighted.

   In the same way, if current analyzer supports stemming and we request to highlight 'indexed', then 'index',
   'indexing', 'indices' and other word forms will be highlighted.

   On the other hand, if word is skipped by current analyzer (e.g. if short words filter is applied to the
   analyzer), then nothing will be highlighted.

The second option is to use *Zend\Search\Lucene\Search\Query->highlightMatches(string $inputHTML[, $defaultEncoding
= 'UTF-8'[, Zend\Search\Lucene\Search\Highlighter\Interface $highlighter]])* method:

.. code-block:: php
   :linenos:

   $query = Zend\Search\Lucene\Search\QueryParser::parse($queryStr);
   $highlightedHTML = $query->highlightMatches($sourceHTML);

Optional second parameter is a default *HTML* document encoding. It's used if encoding is not specified using
Content-type HTTP-EQUIV meta tag.

Optional third parameter is a highlighter object which has to implement
``Zend\Search\Lucene\Search\Highlighter\Interface`` interface:

.. code-block:: php
   :linenos:

   interface Zend\Search\Lucene\Search\Highlighter\Interface
   {
       /**
        * Set document for highlighting.
        *
        * @param Zend\Search\Lucene\Document\Html $document
        */
       public function setDocument(Zend\Search\Lucene\Document\Html $document);

       /**
        * Get document for highlighting.
        *
        * @return Zend\Search\Lucene\Document\Html $document
        */
       public function getDocument();

       /**
        * Highlight specified words (method is invoked once per subquery)
        *
        * @param string|array $words  Words to highlight. They could be
                                      organized using the array or string.
        */
       public function highlight($words);
   }

Where ``Zend\Search\Lucene\Document\Html`` object is an object constructed from the source *HTML* provided to the
``Zend\Search\Lucene\Search\Query->highlightMatches()`` method.

If ``$highlighter`` parameter is omitted, then ``Zend\Search\Lucene\Search\Highlighter\Default`` class is
instantiated and used.

Highlighter ``highlight()`` method is invoked once per subquery, so it has an ability to differentiate highlighting
for them.

Actually, default highlighter does this walking through predefined color table. So you can implement your own
highlighter or just extend the default and redefine color table.

*Zend\Search\Lucene\Search\Query->htmlFragmentHighlightMatches()* has similar behavior. The only difference is that
it takes as an input and returns *HTML* fragment without <>HTML>, <HEAD>, <BODY> tags. Nevertheless, fragment is
automatically transformed to valid *XHTML*.



.. [#] Returned hits are still ordered by score or by the specified order, if given.
.. [#] The first is an *HTML* fragment for highlighting and others are callback behavior dependent. Returned value
       is a highlighted *HTML* fragment.
.. [#] In both cases returned *HTML* is automatically transformed into valid *XHTML*.