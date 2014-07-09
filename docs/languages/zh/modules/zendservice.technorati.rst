.. _zendservice.technorati:

ZendService\\Technorati
=======================

.. _zendservice.technorati.introduction:

Introduction
------------

``ZendService\Technorati\Technorati`` provides an easy, intuitive and object-oriented interface for using the Technorati
*API*. It provides access to all available `Technorati API queries`_ and returns the original *XML* response as a
friendly *PHP* object.

`Technorati`_ is one of the most popular blog search engines. The *API* interface enables developers to retrieve
information about a specific blog, search blogs matching a single tag or phrase and get information about a
specific author (blogger). For a full list of available queries please see the `Technorati API documentation`_ or
the :ref:`Available Technorati queries <zendservice.technorati.queries>` section of this document.

.. _zendservice.technorati.getting-started:

Getting Started
---------------

Technorati requires a valid *API* key for usage. To get your own *API* Key you first need to `create a new
Technorati account`_, then visit the `API Key section`_.

.. note::

   **API Key limits**

   You can make up to 500 Technorati *API* calls per day, at no charge. Other usage limitations may apply,
   depending on the current Technorati *API* license.

Once you have a valid *API* key, you're ready to start using ``ZendService\Technorati\Technorati``.

.. _zendservice.technorati.making-first-query:

Making Your First Query
-----------------------

In order to run a query, first you need a ``ZendService\Technorati\Technorati`` instance with a valid *API* key. Then choose
one of the available query methods, and call it providing required arguments.

.. _zendservice.technorati.making-first-query.example-1:

.. rubric:: Sending your first query

.. code-block:: php
   :linenos:

   // create a new ZendService\Technorati\Technorati
   // with a valid API_KEY
   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');

   // search Technorati for PHP keyword
   $resultSet = $technorati->search('PHP');

Each query method accepts an array of optional parameters that can be used to refine your query.

.. _zendservice.technorati.making-first-query.example-2:

.. rubric:: Refining your query

.. code-block:: php
   :linenos:

   // create a new ZendService\Technorati\Technorati
   // with a valid API_KEY
   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');

   // filter your query including only results
   // with some authority (Results from blogs with a handful of links)
   $options = array('authority' => 'a4');

   // search Technorati for PHP keyword
   $resultSet = $technorati->search('PHP', $options);

A ``ZendService\Technorati\Technorati`` instance is not a single-use object. That is, you don't need to create a new instance
for each query call; simply use your current ``ZendService\Technorati\Technorati`` object as long as you need it.

.. _zendservice.technorati.making-first-query.example-3:

.. rubric:: Sending multiple queries with the same ZendService\Technorati\Technorati instance

.. code-block:: php
   :linenos:

   // create a new ZendService\Technorati\Technorati
   // with a valid API_KEY
   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');

   // search Technorati for PHP keyword
   $search = $technorati->search('PHP');

   // get top tags indexed by Technorati
   $topTags = $technorati->topTags();

.. _zendservice.technorati.consuming-results:

Consuming Results
-----------------

You can get one of two types of result object in response to a query.

The first group is represented by ``ZendService\Technorati\*ResultSet`` objects. A result set object is basically
a collection of result objects. It extends the basic ``ZendService\Technorati\ResultSet`` class and implements the
``SeekableIterator`` *PHP* interface. The best way to consume a result set object is to loop over it with the *PHP*
``foreach()`` statement.

.. _zendservice.technorati.consuming-results.example-1:

.. rubric:: Consuming a result set object

.. code-block:: php
   :linenos:

   // create a new ZendService\Technorati\Technorati
   // with a valid API_KEY
   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');

   // search Technorati for PHP keyword
   // $resultSet is an instance of ZendService\Technorati\SearchResultSet
   $resultSet = $technorati->search('PHP');

   // loop over all result objects
   foreach ($resultSet as $result) {
       // $result is an instance of ZendService\Technorati\SearchResult
   }

Because ``ZendService\Technorati\ResultSet`` implements the ``SeekableIterator`` interface, you can seek a
specific result object using its position in the result collection.

.. _zendservice.technorati.consuming-results.example-2:

.. rubric:: Seeking a specific result set object

.. code-block:: php
   :linenos:

   // create a new ZendService\Technorati\Technorati
   // with a valid API_KEY
   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');

   // search Technorati for PHP keyword
   // $resultSet is an instance of ZendService\Technorati\SearchResultSet
   $resultSet = $technorati->search('PHP');

   // $result is an instance of ZendService\Technorati\SearchResult
   $resultSet->seek(1);
   $result = $resultSet->current();

.. note::

   ``SeekableIterator`` works as an array and counts positions starting from index 0. Fetching position number 1
   means getting the second result in the collection.

The second group is represented by special standalone result objects. ``ZendService\Technorati\GetInfoResult``,
``ZendService\Technorati\BlogInfoResult`` and ``ZendService\Technorati\KeyInfoResult`` act as wrappers for
additional objects, such as ``ZendService\Technorati\Author`` and ``ZendService\Technorati\Weblog``.

.. _zendservice.technorati.consuming-results.example-3:

.. rubric:: Consuming a standalone result object

.. code-block:: php
   :linenos:

   // create a new ZendService\Technorati\Technorati
   // with a valid API_KEY
   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');

   // get info about weppos author
   $result = $technorati->getInfo('weppos');

   $author = $result->getAuthor();
   echo '<h2>Blogs authored by ' . $author->getFirstName() . " " .
             $author->getLastName() . '</h2>';
   echo '<ol>';
   foreach ($result->getWeblogs() as $weblog) {
       echo '<li>' . $weblog->getName() . '</li>';
   }
   echo "</ol>";

Please read the :ref:`ZendService\Technorati\Technorati Classes <zendservice.technorati.classes>` section for further
details about response classes.

.. _zendservice.technorati.handling-errors:

Handling Errors
---------------

Each ``ZendService\Technorati\Technorati`` query method throws a ``ZendService\Technorati\Exception`` exception on failure
with a meaningful error message.

There are several reasons that may cause a ``ZendService\Technorati\Technorati`` query to fail. ``ZendService\Technorati\Technorati``
validates all parameters for any query request. If a parameter is invalid or it contains an invalid value, a new
``ZendService\Technorati\Exception`` exception is thrown. Additionally, the Technorati *API* interface could be
temporally unavailable, or it could return a response that is not well formed.

You should always wrap a Technorati query with a ``try ... catch`` block.

.. _zendservice.technorati.handling-errors.example-1:

.. rubric:: Handling a Query Exception

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');
   try {
       $resultSet = $technorati->search('PHP');
   } catch(ZendService\Technorati\Exception $e) {
       echo "An error occurred: " $e->getMessage();
   }

.. _zendservice.technorati.checking-api-daily-usage:

Checking Your API Key Daily Usage
---------------------------------

From time to time you probably will want to check your *API* key daily usage. By default Technorati limits your
*API* usage to 500 calls per day, and an exception is returned by ``ZendService\Technorati\Technorati`` if you try to use it
beyond this limit. You can get information about your *API* key usage using the
``ZendService\Technorati\Technorati::keyInfo()`` method.

``ZendService\Technorati\Technorati::keyInfo()`` returns a ``ZendService\Technorati\KeyInfoResult`` object. For full details
please see the `API reference guide`_.

.. _zendservice.technorati.checking-api-daily-usage.example-1:

.. rubric:: Getting API key daily usage information

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');
   $key = $technorati->keyInfo();

   echo "API Key: " . $key->getApiKey() . "<br />";
   echo "Daily Usage: " . $key->getApiQueries() . "/" .
        $key->getMaxQueries() . "<br />";

.. _zendservice.technorati.queries:

Available Technorati Queries
----------------------------

``ZendService\Technorati\Technorati`` provides support for the following queries:



   - :ref:`Cosmos <zendservice.technorati.queries.cosmos>`

   - :ref:`Search <zendservice.technorati.queries.search>`

   - :ref:`Tag <zendservice.technorati.queries.tag>`

   - :ref:`DailyCounts <zendservice.technorati.queries.dailycounts>`

   - :ref:`TopTags <zendservice.technorati.queries.toptags>`

   - :ref:`BlogInfo <zendservice.technorati.queries.bloginfo>`

   - :ref:`BlogPostTags <zendservice.technorati.queries.blogposttags>`

   - :ref:`GetInfo <zendservice.technorati.queries.getinfo>`



.. _zendservice.technorati.queries.cosmos:

Technorati Cosmos
^^^^^^^^^^^^^^^^^

`Cosmos`_ query lets you see what blogs are linking to a given *URL*. It returns a
:ref:`ZendService\Technorati\CosmosResultSet <zendservice.technorati.classes.cosmosresultset>` object. For full
details please see ``ZendService\Technorati\Technorati::cosmos()`` in the `API reference guide`_.

.. _zendservice.technorati.queries.cosmos.example-1:

.. rubric:: Cosmos Query

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');
   $resultSet = $technorati->cosmos('http://devzone.zend.com/');

   echo "<p>Reading " . $resultSet->totalResults() .
        " of " . $resultSet->totalResultsAvailable() .
        " available results</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getWeblog()->getName() . "</li>";
   }
   echo "</ol>";

.. _zendservice.technorati.queries.search:

Technorati Search
^^^^^^^^^^^^^^^^^

The `Search`_ query lets you see what blogs contain a given search string. It returns a
:ref:`ZendService\Technorati\SearchResultSet <zendservice.technorati.classes.searchresultset>` object. For full
details please see ``ZendService\Technorati\Technorati::search()`` in the `API reference guide`_.

.. _zendservice.technorati.queries.search.example-1:

.. rubric:: Search Query

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');
   $resultSet = $technorati->search('zend framework');

   echo "<p>Reading " . $resultSet->totalResults() .
        " of " . $resultSet->totalResultsAvailable() .
        " available results</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getWeblog()->getName() . "</li>";
   }
   echo "</ol>";

.. _zendservice.technorati.queries.tag:

Technorati Tag
^^^^^^^^^^^^^^

The `Tag`_ query lets you see what posts are associated with a given tag. It returns a
:ref:`ZendService\Technorati\TagResultSet <zendservice.technorati.classes.tagresultset>` object. For full details
please see ``ZendService\Technorati\Technorati::tag()`` in the `API reference guide`_.

.. _zendservice.technorati.queries.tag.example-1:

.. rubric:: Tag Query

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');
   $resultSet = $technorati->tag('php');

   echo "<p>Reading " . $resultSet->totalResults() .
        " of " . $resultSet->totalResultsAvailable() .
        " available results</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getWeblog()->getName() . "</li>";
   }
   echo "</ol>";

.. _zendservice.technorati.queries.dailycounts:

Technorati DailyCounts
^^^^^^^^^^^^^^^^^^^^^^

The `DailyCounts`_ query provides daily counts of posts containing the queried keyword. It returns a
:ref:`ZendService\Technorati\DailyCountsResultSet <zendservice.technorati.classes.dailycountsresultset>` object.
For full details please see ``ZendService\Technorati\Technorati::dailyCounts()`` in the `API reference guide`_.

.. _zendservice.technorati.queries.dailycounts.example-1:

.. rubric:: DailyCounts Query

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');
   $resultSet = $technorati->dailyCounts('php');

   foreach ($resultSet as $result) {
       echo "<li>" . $result->getDate() .
            "(" . $result->getCount() . ")</li>";
   }
   echo "</ol>";

.. _zendservice.technorati.queries.toptags:

Technorati TopTags
^^^^^^^^^^^^^^^^^^

The `TopTags`_ query provides information on top tags indexed by Technorati. It returns a
:ref:`ZendService\Technorati\TagsResultSet <zendservice.technorati.classes.tagsresultset>` object. For full
details please see ``ZendService\Technorati\Technorati::topTags()`` in the `API reference guide`_.

.. _zendservice.technorati.queries.toptags.example-1:

.. rubric:: TopTags Query

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');
   $resultSet = $technorati->topTags();

   echo "<p>Reading " . $resultSet->totalResults() .
        " of " . $resultSet->totalResultsAvailable() .
        " available results</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getTag() . "</li>";
   }
   echo "</ol>";

.. _zendservice.technorati.queries.bloginfo:

Technorati BlogInfo
^^^^^^^^^^^^^^^^^^^

The `BlogInfo`_ query provides information on what blog, if any, is associated with a given *URL*. It returns a
:ref:`ZendService\Technorati\BlogInfoResult <zendservice.technorati.classes.bloginforesult>` object. For full
details please see ``ZendService\Technorati\Technorati::blogInfo()`` in the `API reference guide`_.

.. _zendservice.technorati.queries.bloginfo.example-1:

.. rubric:: BlogInfo Query

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');
   $result = $technorati->blogInfo('http://devzone.zend.com/');

   echo '<h2><a href="' . (string) $result->getWeblog()->getUrl() . '">' .
        $result->getWeblog()->getName() . '</a></h2>';

.. _zendservice.technorati.queries.blogposttags:

Technorati BlogPostTags
^^^^^^^^^^^^^^^^^^^^^^^

The `BlogPostTags`_ query provides information on the top tags used by a specific blog. It returns a
:ref:`ZendService\Technorati\TagsResultSet <zendservice.technorati.classes.tagsresultset>` object. For full
details please see ``ZendService\Technorati\Technorati::blogPostTags()`` in the `API reference guide`_.

.. _zendservice.technorati.queries.blogposttags.example-1:

.. rubric:: BlogPostTags Query

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');
   $resultSet = $technorati->blogPostTags('http://devzone.zend.com/');

   echo "<p>Reading " . $resultSet->totalResults() .
        " of " . $resultSet->totalResultsAvailable() .
        " available results</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getTag() . "</li>";
   }
   echo "</ol>";

.. _zendservice.technorati.queries.getinfo:

Technorati GetInfo
^^^^^^^^^^^^^^^^^^

The `GetInfo`_ query tells you things that Technorati knows about a member. It returns a
:ref:`ZendService\Technorati\GetInfoResult <zendservice.technorati.classes.getinforesult>` object. For full
details please see ``ZendService\Technorati\Technorati::getInfo()`` in the `API reference guide`_.

.. _zendservice.technorati.queries.getinfo.example-1:

.. rubric:: GetInfo Query

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');
   $result = $technorati->getInfo('weppos');

   $author = $result->getAuthor();
   echo "<h2>Blogs authored by " . $author->getFirstName() . " " .
        $author->getLastName() . "</h2>";
   echo "<ol>";
   foreach ($result->getWeblogs() as $weblog) {
       echo "<li>" . $weblog->getName() . "</li>";
   }
   echo "</ol>";

.. _zendservice.technorati.queries.keyinfo:

Technorati KeyInfo
^^^^^^^^^^^^^^^^^^

The KeyInfo query provides information on daily usage of an *API* key. It returns a
:ref:`ZendService\Technorati\KeyInfoResult <zendservice.technorati.classes.keyinforesult>` object. For full
details please see ``ZendService\Technorati\Technorati::keyInfo()`` in the `API reference guide`_.

.. _zendservice.technorati.classes:

ZendService\\Technorati Classes
-------------------------------

The following classes are returned by the various Technorati queries. Each ``ZendService\Technorati\*ResultSet``
class holds a type-specific result set which can be easily iterated, with each result being contained in a type
result object. All result set classes extend ``ZendService\Technorati\ResultSet`` class and implement the
``SeekableIterator`` interface, allowing for easy iteration and seeking to a specific result.



   - :ref:`ZendService\Technorati\ResultSet <zendservice.technorati.classes.resultset>`

   - :ref:`ZendService\Technorati\CosmosResultSet <zendservice.technorati.classes.cosmosresultset>`

   - :ref:`ZendService\Technorati\SearchResultSet <zendservice.technorati.classes.searchresultset>`

   - :ref:`ZendService\Technorati\TagResultSet <zendservice.technorati.classes.tagresultset>`

   - :ref:`ZendService\Technorati\DailyCountsResultSet <zendservice.technorati.classes.dailycountsresultset>`

   - :ref:`ZendService\Technorati\TagsResultSet <zendservice.technorati.classes.tagsresultset>`

   - :ref:`ZendService\Technorati\Result <zendservice.technorati.classes.result>`

   - :ref:`ZendService\Technorati\CosmosResult <zendservice.technorati.classes.cosmosresult>`

   - :ref:`ZendService\Technorati\SearchResult <zendservice.technorati.classes.searchresult>`

   - :ref:`ZendService\Technorati\TagResult <zendservice.technorati.classes.tagresult>`

   - :ref:`ZendService\Technorati\DailyCountsResult <zendservice.technorati.classes.dailycountsresult>`

   - :ref:`ZendService\Technorati\TagsResult <zendservice.technorati.classes.tagsresult>`

   - :ref:`ZendService\Technorati\GetInfoResult <zendservice.technorati.classes.getinforesult>`

   - :ref:`ZendService\Technorati\BlogInfoResult <zendservice.technorati.classes.bloginforesult>`

   - :ref:`ZendService\Technorati\KeyInfoResult <zendservice.technorati.classes.keyinforesult>`



.. note::

   ``ZendService\Technorati\GetInfoResult``, ``ZendService\Technorati\BlogInfoResult`` and
   ``ZendService\Technorati\KeyInfoResult`` represent exceptions to the above because they don't belong to a
   result set and they don't implement any interface. They represent a single response object and they act as a
   wrapper for additional ``ZendService\Technorati\Technorati`` objects, such as ``ZendService\Technorati\Author`` and
   ``ZendService\Technorati\Weblog``.

The ``ZendService\Technorati\Technorati`` library includes additional convenient classes representing specific response
objects. ``ZendService\Technorati\Author`` represents a single Technorati account, also known as a blog author or
blogger. ``ZendService\Technorati\Weblog`` represents a single weblog object, along with all specific weblog
properties such as feed *URL*\ s or blog name. For full details please see ``ZendService\Technorati\Technorati`` in the `API
reference guide`_.

.. _zendservice.technorati.classes.resultset:

ZendService\\Technorati\\ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\ResultSet`` is the most essential result set. The scope of this class is to be extended
by a query-specific child result set class, and it should never be used to initialize a standalone object. Each of
the specific result sets represents a collection of query-specific :ref:`ZendService\Technorati\Result
<zendservice.technorati.classes.result>` objects.

``ZendService\Technorati\ResultSet`` implements the *PHP* ``SeekableIterator`` interface, and you can iterate all
result objects via the *PHP* ``foreach()`` statement.

.. _zendservice.technorati.classes.resultset.example-1:

.. rubric:: Iterating result objects from a resultset collection

.. code-block:: php
   :linenos:

   // run a simple query
   $technorati = new ZendService\Technorati\Technorati('VALID_API_KEY');
   $resultSet = $technorati->search('php');

   // $resultSet is now an instance of
   // ZendService\Technorati\SearchResultSet
   // it extends ZendService\Technorati\ResultSet
   foreach ($resultSet as $result) {
       // do something with your
       // ZendService\Technorati\SearchResult object
   }

.. _zendservice.technorati.classes.cosmosresultset:

ZendService\\Technorati\\CosmosResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\CosmosResultSet`` represents a Technorati Cosmos query result set.

.. note::

   ``ZendService\Technorati\CosmosResultSet`` extends :ref:`ZendService\Technorati\ResultSet
   <zendservice.technorati.classes.resultset>`.

.. _zendservice.technorati.classes.searchresultset:

ZendService\\Technorati\\SearchResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\SearchResultSet`` represents a Technorati Search query result set.

.. note::

   ``ZendService\Technorati\SearchResultSet`` extends :ref:`ZendService\Technorati\ResultSet
   <zendservice.technorati.classes.resultset>`.

.. _zendservice.technorati.classes.tagresultset:

ZendService\\Technorati\\TagResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\TagResultSet`` represents a Technorati Tag query result set.

.. note::

   ``ZendService\Technorati\TagResultSet`` extends :ref:`ZendService\Technorati\ResultSet
   <zendservice.technorati.classes.resultset>`.

.. _zendservice.technorati.classes.dailycountsresultset:

ZendService\\Technorati\\DailyCountsResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\DailyCountsResultSet`` represents a Technorati DailyCounts query result set.

.. note::

   ``ZendService\Technorati\DailyCountsResultSet`` extends :ref:`ZendService\Technorati\ResultSet
   <zendservice.technorati.classes.resultset>`.

.. _zendservice.technorati.classes.tagsresultset:

ZendService\\Technorati\\TagsResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\TagsResultSet`` represents a Technorati TopTags or BlogPostTags queries result set.

.. note::

   ``ZendService\Technorati\TagsResultSet`` extends :ref:`ZendService\Technorati\ResultSet
   <zendservice.technorati.classes.resultset>`.

.. _zendservice.technorati.classes.result:

ZendService\\Technorati\\Result
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\Result`` is the most essential result object. The scope of this class is to be extended
by a query specific child result class, and it should never be used to initialize a standalone object.

.. _zendservice.technorati.classes.cosmosresult:

ZendService\\Technorati\\CosmosResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\CosmosResult`` represents a single Technorati Cosmos query result object. It is never
returned as a standalone object, but it always belongs to a valid :ref:`ZendService\Technorati\CosmosResultSet
<zendservice.technorati.classes.cosmosresultset>` object.

.. note::

   ``ZendService\Technorati\CosmosResult`` extends :ref:`ZendService\Technorati\Result
   <zendservice.technorati.classes.result>`.

.. _zendservice.technorati.classes.searchresult:

ZendService\\Technorati\\SearchResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\SearchResult`` represents a single Technorati Search query result object. It is never
returned as a standalone object, but it always belongs to a valid :ref:`ZendService\Technorati\SearchResultSet
<zendservice.technorati.classes.searchresultset>` object.

.. note::

   ``ZendService\Technorati\SearchResult`` extends :ref:`ZendService\Technorati\Result
   <zendservice.technorati.classes.result>`.

.. _zendservice.technorati.classes.tagresult:

ZendService\\Technorati\\TagResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\TagResult`` represents a single Technorati Tag query result object. It is never returned
as a standalone object, but it always belongs to a valid :ref:`ZendService\Technorati\TagResultSet
<zendservice.technorati.classes.tagresultset>` object.

.. note::

   ``ZendService\Technorati\TagResult`` extends :ref:`ZendService\Technorati\Result
   <zendservice.technorati.classes.result>`.

.. _zendservice.technorati.classes.dailycountsresult:

ZendService\\Technorati\\DailyCountsResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\DailyCountsResult`` represents a single Technorati DailyCounts query result object. It is
never returned as a standalone object, but it always belongs to a valid
:ref:`ZendService\Technorati\DailyCountsResultSet <zendservice.technorati.classes.dailycountsresultset>` object.

.. note::

   ``ZendService\Technorati\DailyCountsResult`` extends :ref:`ZendService\Technorati\Result
   <zendservice.technorati.classes.result>`.

.. _zendservice.technorati.classes.tagsresult:

ZendService\\Technorati\\TagsResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\TagsResult`` represents a single Technorati TopTags or BlogPostTags query result object.
It is never returned as a standalone object, but it always belongs to a valid
:ref:`ZendService\Technorati\TagsResultSet <zendservice.technorati.classes.tagsresultset>` object.

.. note::

   ``ZendService\Technorati\TagsResult`` extends :ref:`ZendService\Technorati\Result
   <zendservice.technorati.classes.result>`.

.. _zendservice.technorati.classes.getinforesult:

ZendService\\Technorati\\GetInfoResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\GetInfoResult`` represents a single Technorati GetInfo query result object.

.. _zendservice.technorati.classes.bloginforesult:

ZendService\\Technorati\\BlogInfoResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\BlogInfoResult`` represents a single Technorati BlogInfo query result object.

.. _zendservice.technorati.classes.keyinforesult:

ZendService\\Technorati\\KeyInfoResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\KeyInfoResult`` represents a single Technorati KeyInfo query result object. It provides
information about your :ref:`Technorati API Key daily usage <zendservice.technorati.checking-api-daily-usage>`.



.. _`Technorati API queries`: http://technorati.com/developers/api/
.. _`Technorati`: http://technorati.com/
.. _`Technorati API documentation`: http://technorati.com/developers/api/
.. _`create a new Technorati account`: http://technorati.com/signup/
.. _`API Key section`: http://technorati.com/developers/apikey.html
.. _`API reference guide`: http://framework.zend.com/apidoc/core/
.. _`Cosmos`: http://technorati.com/developers/api/cosmos.html
.. _`Search`: http://technorati.com/developers/api/search.html
.. _`Tag`: http://technorati.com/developers/api/tag.html
.. _`DailyCounts`: http://technorati.com/developers/api/dailycounts.html
.. _`TopTags`: http://technorati.com/developers/api/toptags.html
.. _`BlogInfo`: http://technorati.com/developers/api/bloginfo.html
.. _`BlogPostTags`: http://technorati.com/developers/api/blogposttags.html
.. _`GetInfo`: http://technorati.com/developers/api/getinfo.html
