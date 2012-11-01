.. _zendservice.twitter.search:

ZendService\Twitter\Search
===========================

.. _zendservice.twitter.search.introduction:

Introduction
------------

``ZendService\Twitter\Search`` provides a client for the `Twitter Search API`_. The Twitter Search service is use
to search Twitter. Currently, it only returns data in Atom or *JSON* format, but a full *REST* service is in the
future, which will support *XML* responses.

.. _zendservice.twitter.search.trends:

Twitter Trends
--------------

Returns the top ten queries that are currently trending on Twitter. The response includes the time of the request,
the name of each trending topic, and the url to the Twitter Search results page for that topic. Currently the
search *API* for trends only supports a *JSON* return so the function returns an array.

.. code-block:: php
   :linenos:

   $twitterSearch  = new ZendService\Twitter\Search();
   $twitterTrends  = $twitterSearch->trends();

   foreach ($twitterTrends as $trend) {
       print $trend['name'] . ' - ' . $trend['url'] . PHP_EOL
   }

The return array has two values in it:

- *name* is the name of trend.

- *url* is the *URL* to see the tweets for that trend.

.. _zendservice.twitter.search.search:

Searching Twitter
-----------------

Using the search method returns tweets that match a specific query. There are a number of `Search Operators`_ that
you can use to query with.

The search method can accept six different optional *URL* parameters passed in as an array:

- *lang* restricts the tweets to a given language. *lang* must be given by an `ISO 639-1 code`_.

- *rpp* is the number of tweets to return per page, up to a maximum of 100.

- *page* specifies the page number to return, up to a maximum of roughly 1500 results (based on rpp * page).

- *since_id* returns tweets with status IDs greater than the given ID.

- *show_user* specifies whether to add ">user<:" to the beginning of the tweet. This is useful for readers that do
  not display Atom's author field. The default is "``FALSE``".

- *geocode* returns tweets by users located within a given radius of the given latitude/longitude, where the user's
  location is taken from their Twitter profile. The parameter value is specified by "latitude,longitude,radius",
  where radius units must be specified as either "mi" (miles) or "km" (kilometers).

.. _zendservice.twitter.search.search.json:

.. rubric:: JSON Search Example

The following code sample will return an array with the search results.

.. code-block:: php
   :linenos:

   $twitterSearch  = new ZendService\Twitter\Search('json');
   $searchResults  = $twitterSearch->search('zend', array('lang' => 'en'));

.. _zendservice.twitter.search.search.atom:

.. rubric:: ATOM Search Example

The following code sample will return a ``Zend_Feed_Atom`` object.

.. code-block:: php
   :linenos:

   $twitterSearch  = new ZendService\Twitter\Search('atom');
   $searchResults  = $twitterSearch->search('zend', array('lang' => 'en'));

.. _zendservice.twitter.search.accessors:

Zend-specific Accessor Methods
------------------------------

While the Twitter Search *API* only specifies two methods, ``ZendService\Twitter\Search`` has additional methods
that may be used for retrieving and modifying internal properties.

- ``getResponseType()`` and ``setResponseType()`` allow you to retrieve and modify the response type of the search
  between *JSON* and Atom.



.. _`Twitter Search API`: http://apiwiki.twitter.com/Search+API+Documentation
.. _`Search Operators`: http://search.twitter.com/operators
.. _`ISO 639-1 code`: http://en.wikipedia.org/wiki/ISO_639-1
