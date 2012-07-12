
Zend_Service_Technorati
=======================

.. _zend.service.technorati.introduction:

Introduction
------------

``Zend_Service_Technorati`` provides an easy, intuitive and object-oriented interface for using the Technorati *API* . It provides access to all available `Technorati API queries`_ and returns the original *XML* response as a friendly *PHP* object.

`Technorati`_ is one of the most popular blog search engines. The *API* interface enables developers to retrieve information about a specific blog, search blogs matching a single tag or phrase and get information about a specific author (blogger). For a full list of available queries please see the `Technorati API documentation`_ or the :ref:`Available Technorati queries <zend.service.technorati.queries>` section of this document.

.. _zend.service.technorati.getting-started:

Getting Started
---------------

Technorati requires a valid *API* key for usage. To get your own *API* Key you first need to `create a new Technorati account`_ , then visit the `API Key section`_ .

.. note::
    **API Key limits**

    You can make up to 500 Technorati *API* calls per day, at no charge. Other usage limitations may apply, depending on the current Technorati *API* license.

Once you have a valid *API* key, you're ready to start using ``Zend_Service_Technorati`` .

.. _zend.service.technorati.making-first-query:

Making Your First Query
-----------------------

In order to run a query, first you need a ``Zend_Service_Technorati`` instance with a valid *API* key. Then choose one of the available query methods, and call it providing required arguments.

.. _zend.service.technorati.making-first-query.example-1:

Sending your first query
------------------------

.. code-block:: php
    :linenos:
    
    // create a new Zend_Service_Technorati
    // with a valid API_KEY
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    
    // search Technorati for PHP keyword
    $resultSet = $technorati->search('PHP');
    

Each query method accepts an array of optional parameters that can be used to refine your query.

.. _zend.service.technorati.making-first-query.example-2:

Refining your query
-------------------

.. code-block:: php
    :linenos:
    
    // create a new Zend_Service_Technorati
    // with a valid API_KEY
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    
    // filter your query including only results
    // with some authority (Results from blogs with a handful of links)
    $options = array('authority' => 'a4');
    
    // search Technorati for PHP keyword
    $resultSet = $technorati->search('PHP', $options);
    

A ``Zend_Service_Technorati`` instance is not a single-use object. That is, you don't need to create a new instance for each query call; simply use your current ``Zend_Service_Technorati`` object as long as you need it.

.. _zend.service.technorati.making-first-query.example-3:

Sending multiple queries with the same Zend_Service_Technorati instance
-----------------------------------------------------------------------

.. code-block:: php
    :linenos:
    
    // create a new Zend_Service_Technorati
    // with a valid API_KEY
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    
    // search Technorati for PHP keyword
    $search = $technorati->search('PHP');
    
    // get top tags indexed by Technorati
    $topTags = $technorati->topTags();
    

.. _zend.service.technorati.consuming-results:

Consuming Results
-----------------

You can get one of two types of result object in response to a query.

The first group is represented by ``Zend_Service_Technorati_*ResultSet`` objects. A result set object is basically a collection of result objects. It extends the basic ``Zend_Service_Technorati_ResultSet`` class and implements the ``SeekableIterator``  *PHP* interface. The best way to consume a result set object is to loop over it with the *PHP*  ``foreach()`` statement.

.. _zend.service.technorati.consuming-results.example-1:

Consuming a result set object
-----------------------------

.. code-block:: php
    :linenos:
    
    // create a new Zend_Service_Technorati
    // with a valid API_KEY
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    
    // search Technorati for PHP keyword
    // $resultSet is an instance of Zend_Service_Technorati_SearchResultSet
    $resultSet = $technorati->search('PHP');
    
    // loop over all result objects
    foreach ($resultSet as $result) {
        // $result is an instance of Zend_Service_Technorati_SearchResult
    }
    

Because ``Zend_Service_Technorati_ResultSet`` implements the ``SeekableIterator`` interface, you can seek a specific result object using its position in the result collection.

.. _zend.service.technorati.consuming-results.example-2:

Seeking a specific result set object
------------------------------------

.. code-block:: php
    :linenos:
    
    // create a new Zend_Service_Technorati
    // with a valid API_KEY
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    
    // search Technorati for PHP keyword
    // $resultSet is an instance of Zend_Service_Technorati_SearchResultSet
    $resultSet = $technorati->search('PHP');
    
    // $result is an instance of Zend_Service_Technorati_SearchResult
    $resultSet->seek(1);
    $result = $resultSet->current();
    

.. note::
    ****

     ``SeekableIterator`` works as an array and counts positions starting from index 0. Fetching position number 1 means getting the second result in the collection.

The second group is represented by special standalone result objects. ``Zend_Service_Technorati_GetInfoResult`` , ``Zend_Service_Technorati_BlogInfoResult`` and ``Zend_Service_Technorati_KeyInfoResult`` act as wrappers for additional objects, such as ``Zend_Service_Technorati_Author`` and ``Zend_Service_Technorati_Weblog`` .

.. _zend.service.technorati.consuming-results.example-3:

Consuming a standalone result object
------------------------------------

.. code-block:: php
    :linenos:
    
    // create a new Zend_Service_Technorati
    // with a valid API_KEY
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    
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
    

Please read the :ref:`Zend_Service_Technorati Classes <zend.service.technorati.classes>` section for further details about response classes.

.. _zend.service.technorati.handling-errors:

Handling Errors
---------------

Each ``Zend_Service_Technorati`` query method throws a ``Zend_Service_Technorati_Exception`` exception on failure with a meaningful error message.

There are several reasons that may cause a ``Zend_Service_Technorati`` query to fail. ``Zend_Service_Technorati`` validates all parameters for any query request. If a parameter is invalid or it contains an invalid value, a new ``Zend_Service_Technorati_Exception`` exception is thrown. Additionally, the Technorati *API* interface could be temporally unavailable, or it could return a response that is not well formed.

You should always wrap a Technorati query with a ``try ... catch`` block.

.. _zend.service.technorati.handling-errors.example-1:

Handling a Query Exception
--------------------------

.. code-block:: php
    :linenos:
    
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    try {
        $resultSet = $technorati->search('PHP');
    } catch(Zend_Service_Technorati_Exception $e) {
        echo "An error occurred: " $e->getMessage();
    }
    

.. _zend.service.technorati.checking-api-daily-usage:

Checking Your API Key Daily Usage
---------------------------------

From time to time you probably will want to check your *API* key daily usage. By default Technorati limits your *API* usage to 500 calls per day, and an exception is returned by ``Zend_Service_Technorati`` if you try to use it beyond this limit. You can get information about your *API* key usage using the ``Zend_Service_Technorati::keyInfo()`` method.

``Zend_Service_Technorati::keyInfo()`` returns a ``Zend_Service_Technorati_KeyInfoResult`` object. For full details please see the `API reference guide`_ .

.. _zend.service.technorati.checking-api-daily-usage.example-1:

Getting API key daily usage information
---------------------------------------

.. code-block:: php
    :linenos:
    
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    $key = $technorati->keyInfo();
    
    echo "API Key: " . $key->getApiKey() . "<br />";
    echo "Daily Usage: " . $key->getApiQueries() . "/" .
         $key->getMaxQueries() . "<br />";
    

.. _zend.service.technorati.queries:

Available Technorati Queries
----------------------------

``Zend_Service_Technorati`` provides support for the following queries:
    - CosmosSearchTagDailyCountsTopTagsBlogInfoBlogPostTagsGetInfo



.. _zend.service.technorati.queries.cosmos:

Technorati Cosmos
-----------------

`Cosmos`_ query lets you see what blogs are linking to a given *URL* . It returns a :ref:`Zend_Service_Technorati_CosmosResultSet <zend.service.technorati.classes.cosmosresultset>` object. For full details please see ``Zend_Service_Technorati::cosmos()`` in the `API reference guide`_ .

.. _zend.service.technorati.queries.cosmos.example-1:

Cosmos Query
------------

.. code-block:: php
    :linenos:
    
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    $resultSet = $technorati->cosmos('http://devzone.zend.com/');
    
    echo "<p>Reading " . $resultSet->totalResults() .
         " of " . $resultSet->totalResultsAvailable() .
         " available results</p>";
    echo "<ol>";
    foreach ($resultSet as $result) {
        echo "<li>" . $result->getWeblog()->getName() . "</li>";
    }
    echo "</ol>";
    

.. _zend.service.technorati.queries.search:

Technorati Search
-----------------

The `Search`_ query lets you see what blogs contain a given search string. It returns a :ref:`Zend_Service_Technorati_SearchResultSet <zend.service.technorati.classes.searchresultset>` object. For full details please see ``Zend_Service_Technorati::search()`` in the `API reference guide`_ .

.. _zend.service.technorati.queries.search.example-1:

Search Query
------------

.. code-block:: php
    :linenos:
    
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    $resultSet = $technorati->search('zend framework');
    
    echo "<p>Reading " . $resultSet->totalResults() .
         " of " . $resultSet->totalResultsAvailable() .
         " available results</p>";
    echo "<ol>";
    foreach ($resultSet as $result) {
        echo "<li>" . $result->getWeblog()->getName() . "</li>";
    }
    echo "</ol>";
    

.. _zend.service.technorati.queries.tag:

Technorati Tag
--------------

The `Tag`_ query lets you see what posts are associated with a given tag. It returns a :ref:`Zend_Service_Technorati_TagResultSet <zend.service.technorati.classes.tagresultset>` object. For full details please see ``Zend_Service_Technorati::tag()`` in the `API reference guide`_ .

.. _zend.service.technorati.queries.tag.example-1:

Tag Query
---------

.. code-block:: php
    :linenos:
    
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    $resultSet = $technorati->tag('php');
    
    echo "<p>Reading " . $resultSet->totalResults() .
         " of " . $resultSet->totalResultsAvailable() .
         " available results</p>";
    echo "<ol>";
    foreach ($resultSet as $result) {
        echo "<li>" . $result->getWeblog()->getName() . "</li>";
    }
    echo "</ol>";
    

.. _zend.service.technorati.queries.dailycounts:

Technorati DailyCounts
----------------------

The `DailyCounts`_ query provides daily counts of posts containing the queried keyword. It returns a :ref:`Zend_Service_Technorati_DailyCountsResultSet <zend.service.technorati.classes.dailycountsresultset>` object. For full details please see ``Zend_Service_Technorati::dailyCounts()`` in the `API reference guide`_ .

.. _zend.service.technorati.queries.dailycounts.example-1:

DailyCounts Query
-----------------

.. code-block:: php
    :linenos:
    
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    $resultSet = $technorati->dailyCounts('php');
    
    foreach ($resultSet as $result) {
        echo "<li>" . $result->getDate() .
             "(" . $result->getCount() . ")</li>";
    }
    echo "</ol>";
    

.. _zend.service.technorati.queries.toptags:

Technorati TopTags
------------------

The `TopTags`_ query provides information on top tags indexed by Technorati. It returns a :ref:`Zend_Service_Technorati_TagsResultSet <zend.service.technorati.classes.tagsresultset>` object. For full details please see ``Zend_Service_Technorati::topTags()`` in the `API reference guide`_ .

.. _zend.service.technorati.queries.toptags.example-1:

TopTags Query
-------------

.. code-block:: php
    :linenos:
    
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    $resultSet = $technorati->topTags();
    
    echo "<p>Reading " . $resultSet->totalResults() .
         " of " . $resultSet->totalResultsAvailable() .
         " available results</p>";
    echo "<ol>";
    foreach ($resultSet as $result) {
        echo "<li>" . $result->getTag() . "</li>";
    }
    echo "</ol>";
    

.. _zend.service.technorati.queries.bloginfo:

Technorati BlogInfo
-------------------

The `BlogInfo`_ query provides information on what blog, if any, is associated with a given *URL* . It returns a :ref:`Zend_Service_Technorati_BlogInfoResult <zend.service.technorati.classes.bloginforesult>` object. For full details please see ``Zend_Service_Technorati::blogInfo()`` in the `API reference guide`_ .

.. _zend.service.technorati.queries.bloginfo.example-1:

BlogInfo Query
--------------

.. code-block:: php
    :linenos:
    
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    $result = $technorati->blogInfo('http://devzone.zend.com/');
    
    echo '<h2><a href="' . (string) $result->getWeblog()->getUrl() . '">' .
         $result->getWeblog()->getName() . '</a></h2>';
    

.. _zend.service.technorati.queries.blogposttags:

Technorati BlogPostTags
-----------------------

The `BlogPostTags`_ query provides information on the top tags used by a specific blog. It returns a :ref:`Zend_Service_Technorati_TagsResultSet <zend.service.technorati.classes.tagsresultset>` object. For full details please see ``Zend_Service_Technorati::blogPostTags()`` in the `API reference guide`_ .

.. _zend.service.technorati.queries.blogposttags.example-1:

BlogPostTags Query
------------------

.. code-block:: php
    :linenos:
    
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    $resultSet = $technorati->blogPostTags('http://devzone.zend.com/');
    
    echo "<p>Reading " . $resultSet->totalResults() .
         " of " . $resultSet->totalResultsAvailable() .
         " available results</p>";
    echo "<ol>";
    foreach ($resultSet as $result) {
        echo "<li>" . $result->getTag() . "</li>";
    }
    echo "</ol>";
    

.. _zend.service.technorati.queries.getinfo:

Technorati GetInfo
------------------

The `GetInfo`_ query tells you things that Technorati knows about a member. It returns a :ref:`Zend_Service_Technorati_GetInfoResult <zend.service.technorati.classes.getinforesult>` object. For full details please see ``Zend_Service_Technorati::getInfo()`` in the `API reference guide`_ .

.. _zend.service.technorati.queries.getinfo.example-1:

GetInfo Query
-------------

.. code-block:: php
    :linenos:
    
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    $result = $technorati->getInfo('weppos');
    
    $author = $result->getAuthor();
    echo "<h2>Blogs authored by " . $author->getFirstName() . " " .
         $author->getLastName() . "</h2>";
    echo "<ol>";
    foreach ($result->getWeblogs() as $weblog) {
        echo "<li>" . $weblog->getName() . "</li>";
    }
    echo "</ol>";
    

.. _zend.service.technorati.queries.keyinfo:

Technorati KeyInfo
------------------

The KeyInfo query provides information on daily usage of an *API* key. It returns a :ref:`Zend_Service_Technorati_KeyInfoResult <zend.service.technorati.classes.keyinforesult>` object. For full details please see ``Zend_Service_Technorati::keyInfo()`` in the `API reference guide`_ .

.. _zend.service.technorati.classes:

Zend_Service_Technorati Classes
-------------------------------

The following classes are returned by the various Technorati queries. Each ``Zend_Service_Technorati_*ResultSet`` class holds a type-specific result set which can be easily iterated, with each result being contained in a type result object. All result set classes extend ``Zend_Service_Technorati_ResultSet`` class and implement the ``SeekableIterator`` interface, allowing for easy iteration and seeking to a specific result.
    - Zend_Service_Technorati_ResultSetZend_Service_Technorati_CosmosResultSetZend_Service_Technorati_SearchResultSetZend_Service_Technorati_TagResultSetZend_Service_Technorati_DailyCountsResultSetZend_Service_Technorati_TagsResultSetZend_Service_Technorati_ResultZend_Service_Technorati_CosmosResultZend_Service_Technorati_SearchResultZend_Service_Technorati_TagResultZend_Service_Technorati_DailyCountsResultZend_Service_Technorati_TagsResultZend_Service_Technorati_GetInfoResultZend_Service_Technorati_BlogInfoResultZend_Service_Technorati_KeyInfoResult



.. note::
    ****

     ``Zend_Service_Technorati_GetInfoResult`` , ``Zend_Service_Technorati_BlogInfoResult`` and ``Zend_Service_Technorati_KeyInfoResult`` represent exceptions to the above because they don't belong to a result set and they don't implement any interface. They represent a single response object and they act as a wrapper for additional ``Zend_Service_Technorati`` objects, such as ``Zend_Service_Technorati_Author`` and ``Zend_Service_Technorati_Weblog`` .

The ``Zend_Service_Technorati`` library includes additional convenient classes representing specific response objects. ``Zend_Service_Technorati_Author`` represents a single Technorati account, also known as a blog author or blogger. ``Zend_Service_Technorati_Weblog`` represents a single weblog object, along with all specific weblog properties such as feed *URL* s or blog name. For full details please see ``Zend_Service_Technorati`` in the `API reference guide`_ .

.. _zend.service.technorati.classes.resultset:

Zend_Service_Technorati_ResultSet
---------------------------------

``Zend_Service_Technorati_ResultSet`` is the most essential result set. The scope of this class is to be extended by a query-specific child result set class, and it should never be used to initialize a standalone object. Each of the specific result sets represents a collection of query-specific :ref:`Zend_Service_Technorati_Result <zend.service.technorati.classes.result>` objects.

``Zend_Service_Technorati_ResultSet`` implements the *PHP*  ``SeekableIterator`` interface, and you can iterate all result objects via the *PHP*  ``foreach()`` statement.

.. _zend.service.technorati.classes.resultset.example-1:

Iterating result objects from a resultset collection
----------------------------------------------------

.. code-block:: php
    :linenos:
    
    // run a simple query
    $technorati = new Zend_Service_Technorati('VALID_API_KEY');
    $resultSet = $technorati->search('php');
    
    // $resultSet is now an instance of
    // Zend_Service_Technorati_SearchResultSet
    // it extends Zend_Service_Technorati_ResultSet
    foreach ($resultSet as $result) {
        // do something with your
        // Zend_Service_Technorati_SearchResult object
    }
    

.. _zend.service.technorati.classes.cosmosresultset:

Zend_Service_Technorati_CosmosResultSet
---------------------------------------

``Zend_Service_Technorati_CosmosResultSet`` represents a Technorati Cosmos query result set.

.. note::
    ****

     ``Zend_Service_Technorati_CosmosResultSet`` extends :ref:`Zend_Service_Technorati_ResultSet <zend.service.technorati.classes.resultset>` .

.. _zend.service.technorati.classes.searchresultset:

Zend_Service_Technorati_SearchResultSet
---------------------------------------

``Zend_Service_Technorati_SearchResultSet`` represents a Technorati Search query result set.

.. note::
    ****

     ``Zend_Service_Technorati_SearchResultSet`` extends :ref:`Zend_Service_Technorati_ResultSet <zend.service.technorati.classes.resultset>` .

.. _zend.service.technorati.classes.tagresultset:

Zend_Service_Technorati_TagResultSet
------------------------------------

``Zend_Service_Technorati_TagResultSet`` represents a Technorati Tag query result set.

.. note::
    ****

     ``Zend_Service_Technorati_TagResultSet`` extends :ref:`Zend_Service_Technorati_ResultSet <zend.service.technorati.classes.resultset>` .

.. _zend.service.technorati.classes.dailycountsresultset:

Zend_Service_Technorati_DailyCountsResultSet
--------------------------------------------

``Zend_Service_Technorati_DailyCountsResultSet`` represents a Technorati DailyCounts query result set.

.. note::
    ****

     ``Zend_Service_Technorati_DailyCountsResultSet`` extends :ref:`Zend_Service_Technorati_ResultSet <zend.service.technorati.classes.resultset>` .

.. _zend.service.technorati.classes.tagsresultset:

Zend_Service_Technorati_TagsResultSet
-------------------------------------

``Zend_Service_Technorati_TagsResultSet`` represents a Technorati TopTags or BlogPostTags queries result set.

.. note::
    ****

     ``Zend_Service_Technorati_TagsResultSet`` extends :ref:`Zend_Service_Technorati_ResultSet <zend.service.technorati.classes.resultset>` .

.. _zend.service.technorati.classes.result:

Zend_Service_Technorati_Result
------------------------------

``Zend_Service_Technorati_Result`` is the most essential result object. The scope of this class is to be extended by a query specific child result class, and it should never be used to initialize a standalone object.

.. _zend.service.technorati.classes.cosmosresult:

Zend_Service_Technorati_CosmosResult
------------------------------------

``Zend_Service_Technorati_CosmosResult`` represents a single Technorati Cosmos query result object. It is never returned as a standalone object, but it always belongs to a valid :ref:`Zend_Service_Technorati_CosmosResultSet <zend.service.technorati.classes.cosmosresultset>` object.

.. note::
    ****

     ``Zend_Service_Technorati_CosmosResult`` extends :ref:`Zend_Service_Technorati_Result <zend.service.technorati.classes.result>` .

.. _zend.service.technorati.classes.searchresult:

Zend_Service_Technorati_SearchResult
------------------------------------

``Zend_Service_Technorati_SearchResult`` represents a single Technorati Search query result object. It is never returned as a standalone object, but it always belongs to a valid :ref:`Zend_Service_Technorati_SearchResultSet <zend.service.technorati.classes.searchresultset>` object.

.. note::
    ****

     ``Zend_Service_Technorati_SearchResult`` extends :ref:`Zend_Service_Technorati_Result <zend.service.technorati.classes.result>` .

.. _zend.service.technorati.classes.tagresult:

Zend_Service_Technorati_TagResult
---------------------------------

``Zend_Service_Technorati_TagResult`` represents a single Technorati Tag query result object. It is never returned as a standalone object, but it always belongs to a valid :ref:`Zend_Service_Technorati_TagResultSet <zend.service.technorati.classes.tagresultset>` object.

.. note::
    ****

     ``Zend_Service_Technorati_TagResult`` extends :ref:`Zend_Service_Technorati_Result <zend.service.technorati.classes.result>` .

.. _zend.service.technorati.classes.dailycountsresult:

Zend_Service_Technorati_DailyCountsResult
-----------------------------------------

``Zend_Service_Technorati_DailyCountsResult`` represents a single Technorati DailyCounts query result object. It is never returned as a standalone object, but it always belongs to a valid :ref:`Zend_Service_Technorati_DailyCountsResultSet <zend.service.technorati.classes.dailycountsresultset>` object.

.. note::
    ****

     ``Zend_Service_Technorati_DailyCountsResult`` extends :ref:`Zend_Service_Technorati_Result <zend.service.technorati.classes.result>` .

.. _zend.service.technorati.classes.tagsresult:

Zend_Service_Technorati_TagsResult
----------------------------------

``Zend_Service_Technorati_TagsResult`` represents a single Technorati TopTags or BlogPostTags query result object. It is never returned as a standalone object, but it always belongs to a valid :ref:`Zend_Service_Technorati_TagsResultSet <zend.service.technorati.classes.tagsresultset>` object.

.. note::
    ****

     ``Zend_Service_Technorati_TagsResult`` extends :ref:`Zend_Service_Technorati_Result <zend.service.technorati.classes.result>` .

.. _zend.service.technorati.classes.getinforesult:

Zend_Service_Technorati_GetInfoResult
-------------------------------------

``Zend_Service_Technorati_GetInfoResult`` represents a single Technorati GetInfo query result object.

.. _zend.service.technorati.classes.bloginforesult:

Zend_Service_Technorati_BlogInfoResult
--------------------------------------

``Zend_Service_Technorati_BlogInfoResult`` represents a single Technorati BlogInfo query result object.

.. _zend.service.technorati.classes.keyinforesult:

Zend_Service_Technorati_KeyInfoResult
-------------------------------------

``Zend_Service_Technorati_KeyInfoResult`` represents a single Technorati KeyInfo query result object. It provides information about your :ref:`Technorati API Key daily usage <zend.service.technorati.checking-api-daily-usage>` .


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
