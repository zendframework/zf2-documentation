
.. _zend.feed.reader:

Zend_Feed_Reader
================


.. _zend.feed.reader.introduction:

Introduction
------------

``Zend_Feed_Reader`` is a component used to consume *RSS* and Atom feeds of any version, including *RDF*/*RSS* 1.0, *RSS* 2.0, Atom 0.3 and Atom 1.0. The *API* for retrieving feed data is deliberately simple since ``Zend_Feed_Reader`` is capable of searching any feed of any type for the information requested through the *API*. If the typical elements containing this information are not present, it will adapt and fall back on a variety of alternative elements instead. This ability to choose from alternatives removes the need for users to create their own abstraction layer on top of the component to make it useful or have any in-depth knowledge of the underlying standards, current alternatives, and namespaced extensions.

Internally, ``Zend_Feed_Reader`` works almost entirely on the basis of making XPath queries against the feed *XML*'s Document Object Model. The *DOM* is not exposed though a chained property *API* like ``Zend_Feed`` though the underlying DOMDocument, DOMElement and DOMXPath objects are exposed for external manipulation. This singular approach to parsing is consistent and the component offers a plugin system to add to the Feed and Entry level *API* by writing Extensions on a similar basis.

Performance is assisted in three ways. First of all, ``Zend_Feed_Reader`` supports caching using ``Zend_Cache`` to maintain a copy of the original feed *XML*. This allows you to skip network requests for a feed *URI* if the cache is valid. Second, the Feed and Entry level *API* is backed by an internal cache (non-persistant) so repeat *API* calls for the same feed will avoid additional *DOM* or XPath use. Thirdly, importing feeds from a *URI* can take advantage of *HTTP* Conditional ``GET`` requests which allow servers to issue an empty 304 response when the requested feed has not changed since the last time you requested it. In the final case, an instance of ``Zend_Cache`` will hold the last received feed along with the ETag and Last-Modified header values sent in the *HTTP* response.

In relation to ``Zend_Feed``, ``Zend_Feed_Reader`` was formulated as a free standing replacement for ``Zend_Feed`` but it is not backwards compatible with ``Zend_Feed``. Rather it is an alternative following a different ideology focused on being simple to use, flexible, consistent and extendable through the plugin system. ``Zend_Feed_Reader`` is also not capable of constructing feeds and delegates this responsibility to ``Zend_Feed_Writer``, its sibling in arms.


.. _zend.feed.reader.import:

Importing Feeds
---------------

Importing a feed with ``Zend_Feed_Reader`` is not that much different to ``Zend_Feed``. Feeds can be imported from a string, file, *URI* or an instance of type ``Zend_Feed_Abstract``. Importing from a *URI* can additionally utilise a *HTTP* Conditional ``GET`` request. If importing fails, an exception will be raised. The end result will be an object of type ``Zend_Feed_Reader_FeedInterface``, the core implementations of which are ``Zend_Feed_Reader_Feed_Rss`` and ``Zend_Feed_Reader_Feed_Atom`` (``Zend_Feed`` took all the short names!). Both objects support multiple (all existing) versions of these broad feed types.

In the following example, we import an *RDF*/*RSS* 1.0 feed and extract some basic information that can be saved to a database or elsewhere.

.. code-block:: php
   :linenos:

   $feed = Zend_Feed_Reader::import('http://www.planet-php.net/rdf/');
   $data = array(
       'title'        => $feed->getTitle(),
       'link'         => $feed->getLink(),
       'dateModified' => $feed->getDateModified(),
       'description'  => $feed->getDescription(),
       'language'     => $feed->getLanguage(),
       'entries'      => array(),
   );

   foreach ($feed as $entry) {
       $edata = array(
           'title'        => $entry->getTitle(),
           'description'  => $entry->getDescription(),
           'dateModified' => $entry->getDateModified(),
           'authors'       => $entry->getAuthors(),
           'link'         => $entry->getLink(),
           'content'      => $entry->getContent()
       );
       $data['entries'][] = $edata;
   }

The example above demonstrates ``Zend_Feed_Reader``'s *API*, and it also demonstrates some of its internal operation. In reality, the *RDF* feed selected does not have any native date or author elements, however it does utilise the Dublin Core 1.1 module which offers namespaced creator and date elements. ``Zend_Feed_Reader`` falls back on these and similar options if no relevant native elements exist. If it absolutely cannot find an alternative it will return ``NULL``, indicating the information could not be found in the feed. You should note that classes implementing ``Zend_Feed_Reader_FeedInterface`` also implement the *SPL* ``Iterator`` and ``Countable`` interfaces.

Feeds can also be imported from strings, files, and even objects of type ``Zend_Feed_Abstract``.

.. code-block:: php
   :linenos:

   // from a URI
   $feed = Zend_Feed_Reader::import('http://www.planet-php.net/rdf/');

   // from a String
   $feed = Zend_Feed_Reader::importString($feedXmlString);

   // from a file
   $feed = Zend_Feed_Reader::importFile('./feed.xml');

   // from a Zend_Feed_Abstract object
   $zfeed = Zend_Feed::import('http://www.planet-php.net/atom/');
   $feed  = Zend_Feed_Reader::importFeed($zfeed);


.. _zend.feed.reader.sources:

Retrieving Underlying Feed and Entry Sources
--------------------------------------------

``Zend_Feed_Reader`` does its best not to stick you in a narrow confine. If you need to work on a feed outside of ``Zend_Feed_Reader``, you can extract the base DOMDocument or DOMElement objects from any class, or even an *XML* string containing these. Also provided are methods to extract the current DOMXPath object (with all core and Extension namespaces registered) and the correct prefix used in all XPath queries for the current Feed or Entry. The basic methods to use (on any object) are ``saveXml()``, ``getDomDocument()``, ``getElement()``, ``getXpath()`` and ``getXpathPrefix()``. These will let you break free of ``Zend_Feed_Reader`` and do whatever else you want.

- ``saveXml()`` returns an *XML* string containing only the element representing the current object.

- ``getDomDocument()`` returns the DOMDocument object representing the entire feed (even if called from an Entry object).

- ``getElement()`` returns the DOMElement of the current object (i.e. the Feed or current Entry).

- ``getXpath()`` returns the DOMXPath object for the current feed (even if called from an Entry object) with the namespaces of the current feed type and all loaded Extensions pre-registered.

- ``getXpathPrefix()`` returns the query prefix for the current object (i.e. the Feed or current Entry) which includes the correct XPath query path for that specific Feed or Entry.

Here's an example where a feed might include an *RSS* Extension not supported by ``Zend_Feed_Reader`` out of the box. Notably, you could write and register an Extension (covered later) to do this, but that's not always warranted for a quick check. You must register any new namespaces on the DOMXPath object before use unless they are registered by ``Zend_Feed_Reader`` or an Extension beforehand.

.. code-block:: php
   :linenos:

   $feed        = Zend_Feed_Reader::import('http://www.planet-php.net/rdf/');
   $xpathPrefix = $feed->getXpathPrefix();
   $xpath       = $feed->getXpath();
   $xpath->registerNamespace('admin', 'http://webns.net/mvcb/');
   $reportErrorsTo = $xpath->evaluate('string('
                                    . $xpathPrefix
                                    . '/admin:errorReportsTo)');

.. warning::
   If you register an already registered namespace with a different prefix name to that used internally by ``Zend_Feed_Reader``, it will break the internal operation of this component.



.. _zend.feed.reader.cache-request:

Cache Support and Intelligent Requests
--------------------------------------


.. _zend.feed.reader.cache-request.cache:

Adding Cache Support to Zend_Feed_Reader
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Feed_Reader`` supports using an instance of ``Zend_Cache`` to cache feeds (as *XML*) to avoid unnecessary network requests. Adding a cache is as simple here as it is for other Zend Framework components, create and configure your cache and then tell ``Zend_Feed_Reader`` to use it! The cache key used is "``Zend_Feed_Reader_``" followed by the *MD5* hash of the feed's *URI*.

.. code-block:: php
   :linenos:

   $frontendOptions = array(
      'lifetime' => 7200,
      'automatic_serialization' => true
   );
   $backendOptions = array('cache_dir' => './tmp/');
   $cache = Zend_Cache::factory(
       'Core', 'File', $frontendOptions, $backendOptions
   );

   Zend_Feed_Reader::setCache($cache);

.. note::
   While it's a little off track, you should also consider adding a cache to ``Zend_Loader_PluginLoader`` which is used by ``Zend_Feed_Reader`` to load Extensions.



.. _zend.feed.reader.cache-request.http-conditional-get:

HTTP Conditional GET Support
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The big question often asked when importing a feed frequently, is if it has even changed. With a cache enabled, you can add *HTTP* Conditional ``GET`` support to your arsenal to answer that question.

Using this method, you can request feeds from *URI*\ s and include their last known ETag and Last-Modified response header values with the request (using the If-None-Match and If-Modified-Since headers). If the feed on the server remains unchanged, you should receive a 304 response which tells ``Zend_Feed_Reader`` to use the cached version. If a full feed is sent in a response with a status code of 200, this means the feed has changed and ``Zend_Feed_Reader`` will parse the new version and save it to the cache. It will also cache the new ETag and Last-Modified header values for future use.

These "conditional" requests are not guaranteed to be supported by the server you request a *URI* of, but can be attempted regardless. Most common feed sources like blogs should however have this supported. To enable conditional requests, you will need to provide a cache to ``Zend_Feed_Reader``.

.. code-block:: php
   :linenos:

   $frontendOptions = array(
      'lifetime' => 86400,
      'automatic_serialization' => true
   );
   $backendOptions = array('cache_dir' => './tmp/');
   $cache = Zend_Cache::factory(
       'Core', 'File', $frontendOptions, $backendOptions
   );

   Zend_Feed_Reader::setCache($cache);
   Zend_Feed_Reader::useHttpConditionalGet();

   $feed = Zend_Feed_Reader::import('http://www.planet-php.net/rdf/');

In the example above, with *HTTP* Conditional ``GET`` requests enabled, the response header values for ETag and Last-Modified will be cached along with the feed. For the next 24hrs (the cache lifetime), feeds will only be updated on the cache if a non-304 response is received containing a valid *RSS* or Atom *XML* document.

If you intend on managing request headers from outside ``Zend_Feed_Reader``, you can set the relevant If-None-Matches and If-Modified-Since request headers via the *URI* import method.

.. code-block:: php
   :linenos:

   $lastEtagReceived = '5e6cefe7df5a7e95c8b1ba1a2ccaff3d';
   $lastModifiedDateReceived = 'Wed, 08 Jul 2009 13:37:22 GMT';
   $feed = Zend_Feed_Reader::import(
       $uri, $lastEtagReceived, $lastModifiedDateReceived
   );


.. _zend.feed.reader.locate:

Locating Feed URIs from Websites
--------------------------------

These days, many websites are aware that the location of their *XML* feeds is not always obvious. A small *RDF*, *RSS* or Atom graphic helps when the user is reading the page, but what about when a machine visits trying to identify where your feeds are located? To assist in this, websites may point to their feeds using <link> tags in the <head> section of their *HTML*. To take advantage of this, you can use ``Zend_Feed_Reader`` to locate these feeds using the static ``findFeedLinks()`` method.

This method calls any *URI* and searches for the location of *RSS*, *RDF* and Atom feeds assuming the website's *HTML* contains the relevant links. It then returns a value object where you can check for the existence of a *RSS*, *RDF* or Atom feed *URI*.

The returned object is an ``ArrayObject`` subclass called ``Zend_Feed_Reader_Collection_FeedLink`` so you can cast it to an array, or iterate over it, to access all the detected links. However, as a simple shortcut, you can just grab the first *RSS*, *RDF* or Atom link using its public properties as in the example below. Otherwise, each element of the ``ArrayObject`` is a simple array with the keys "type" and "uri" where the type is one of "rdf", "rss" or "atom".

.. code-block:: php
   :linenos:

   $links = Zend_Feed_Reader::findFeedLinks('http://www.planet-php.net');

   if(isset($links->rdf)) {
       echo $links->rdf, "\n"; // http://www.planet-php.org/rdf/
   }
   if(isset($links->rss)) {
       echo $links->rss, "\n"; // http://www.planet-php.org/rss/
   }
   if(isset($links->atom)) {
       echo $links->atom, "\n"; // http://www.planet-php.org/atom/
   }

Based on these links, you can then import from whichever source you wish in the usual manner.

This quick method only gives you one link for each feed type, but websites may indicate many links of any type. Perhaps it's a news site with a *RSS* feed for each news category. You can iterate over all links using the ArrayObject's iterator.

.. code-block:: php
   :linenos:

   $links = Zend_Feed_Reader::findFeedLinks('http://www.planet-php.net');

   foreach ($links as $link) {
       echo $link['uri'], "\n";
   }


.. _zend.feed.reader.attribute-collections:

Attribute Collections
---------------------

In an attempt to simplify return types, with Zend Framework 1.10 return types from the various feed and entry level methods may include an object of type ``Zend_Feed_Reader_Collection_CollectionAbstract``. Despite the special class name which I'll explain below, this is just a simple subclass of *SPL*'s ``ArrayObject``.

The main purpose here is to allow the presentation of as much data as possible from the requested elements, while still allowing access to the most relevant data as a simple array. This also enforces a standard approach to returning such data which previously may have wandered between arrays and objects.

The new class type acts identically to ``ArrayObject`` with the sole addition being a new method ``getValues()`` which returns a simple flat array containing the most relevant information.

A simple example of this is ``Zend_Feed_Reader_FeedInterface::getCategories()``. When used with any *RSS* or Atom feed, this method will return category data as a container object called ``Zend_Feed_Reader_Collection_Category``. The container object will contain, per category, three fields of data: term, scheme and label. The "term" is the basic category name, often machine readable (i.e. plays nice with *URI*\ s). The scheme represents a categorisation scheme (usually a *URI* identifier) also known as a "domain" in *RSS* 2.0. The "label" is a human readable category name which supports *HTML* entities. In *RSS* 2.0, there is no label attribute so it is always set to the same value as the term for convenience.

To access category labels by themselves in a simple value array, you might commit to something like:

.. code-block:: php
   :linenos:

   $feed = Zend_Feed_Reader::import('http://www.example.com/atom.xml');
   $categories = $feed->getCategories();
   $labels = array();
   foreach ($categories as $cat) {
       $labels[] = $cat['label']
   }

It's a contrived example, but the point is that the labels are tied up with other information.

However, the container class allows you to access the "most relevant" data as a simple array using the ``getValues()`` method. The concept of "most relevant" is obviously a judgement call. For categories it means the category labels (not the terms or schemes) while for authors it would be the authors' names (not their email addresses or *URI*\ s). The simple array is flat (just values) and passed through ``array_unique()`` to remove duplication.

.. code-block:: php
   :linenos:

   $feed = Zend_Feed_Reader::import('http://www.example.com/atom.xml');
   $categories = $feed->getCategories();
   $labels = $categories->getValues();

The above example shows how to extract only labels and nothing else thus giving simple access to the category labels without any additional work to extract that data by itself.


.. _zend.feed.reader.retrieve-info:

Retrieving Feed Information
---------------------------

Retrieving information from a feed (we'll cover entries and items in the next section though they follow identical principals) uses a clearly defined *API* which is exactly the same regardless of whether the feed in question is *RSS*, *RDF* or Atom. The same goes for sub-versions of these standards and we've tested every single *RSS* and Atom version. While the underlying feed *XML* can differ substantially in terms of the tags and elements they present, they nonetheless are all trying to convey similar information and to reflect this all the differences and wrangling over alternative tags are handled internally by ``Zend_Feed_Reader`` presenting you with an identical interface for each. Ideally, you should not have to care whether a feed is *RSS* or Atom so long as you can extract the information you want.

.. note::
   While determining common ground between feed types is itself complex, it should be noted that *RSS* in particular is a constantly disputed "specification". This has its roots in the original *RSS* 2.0 document which contains ambiguities and does not detail the correct treatment of all elements. As a result, this component rigorously applies the *RSS* 2.0.11 Specification published by the *RSS* Advisory Board and its accompanying *RSS* Best Practices Profile. No other interpretation of *RSS* 2.0 will be supported though exceptions may be allowed where it does not directly prevent the application of the two documents mentioned above.


Of course, we don't live in an ideal world so there may be times the *API* just does not cover what you're looking for. To assist you, ``Zend_Feed_Reader`` offers a plugin system which allows you to write Extensions to expand the core *API* and cover any additional data you are trying to extract from feeds. If writing another Extension is too much trouble, you can simply grab the underlying *DOM* or XPath objects and do it by hand in your application. Of course, we really do encourage writing an Extension simply to make it more portable and reusable, and useful Extensions may be proposed to the Framework for formal addition.

Here's a summary of the Core *API* for Feeds. You should note it comprises not only the basic *RSS* and Atom standards, but also accounts for a number of included Extensions bundled with ``Zend_Feed_Reader``. The naming of these Extension sourced methods remain fairly generic - all Extension methods operate at the same level as the Core *API* though we do allow you to retrieve any specific Extension object separately if required.

.. table:: Feed Level API Methods

   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getId()                      |Returns a unique ID associated with this feed                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getTitle()                   |Returns the title of the feed                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDescription()             |Returns the text description of the feed.                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getLink()                    |Returns a URI to the HTML website containing the same or similar information as this feed (i.e. if the feed is from a blog, it should provide the blog's URI where the HTML version of the entries can be read).                                                                                                                                                                                                                                                                                    |
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getFeedLink()                |Returns the URI of this feed, which may be the same as the URI used to import the feed. There are important cases where the feed link may differ because the source URI is being updated and is intended to be removed in the future.                                                                                                                                                                                                                                                               |
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getAuthors()                 |Returns an object of type Zend_Feed_Reader_Collection_Author which is an ArrayObject whose elements are each simple arrays containing any combination of the keys "name", "email" and "uri". Where irrelevant to the source data, some of these keys may be omitted.                                                                                                                                                                                                                                |
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getAuthor(integer $index = 0)|Returns either the first author known, or with the optional $index parameter any specific index on the array of Authors as described above (returning NULL if an invalid index).                                                                                                                                                                                                                                                                                                                    |
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDateCreated()             |Returns the date on which this feed was created. Generally only applicable to Atom where it represents the date the resource described by an Atom 1.0 document was created. The returned date will be a DateTime object.                                                                                                                                                                                                                                                                            |
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDateModified()            |Returns the date on which this feed was last modified. The returned date will be a DateTime object.                                                                                                                                                                                                                                                                                                                                                                                                 |
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getLastBuildDate()           |Returns the date on which this feed was last built. The returned date will be a DateTime object. This is only supported by RSS - Atom feeds will always return NULL.                                                                                                                                                                                                                                                                                                                                |
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getLanguage()                |Returns the language of the feed (if defined) or simply the language noted in the XML document.                                                                                                                                                                                                                                                                                                                                                                                                     |
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getGenerator()               |Returns the generator of the feed, e.g. the software which generated it. This may differ between RSS and Atom since Atom defines a different notation.                                                                                                                                                                                                                                                                                                                                              |
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getCopyright()               |Returns any copyright notice associated with the feed.                                                                                                                                                                                                                                                                                                                                                                                                                                              |
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getHubs()                    |Returns an array of all Hub Server URI endpoints which are advertised by the feed for use with the Pubsubhubbub Protocol, allowing subscriptions to the feed for real-time updates.                                                                                                                                                                                                                                                                                                                 |
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getCategories()              |Returns a Zend_Feed_Reader_Collection_Category object containing the details of any categories associated with the overall feed. The supported fields include "term" (the machine readable category name), "scheme" (the categorisation scheme and domain for this category), and "label" (a HTML decoded human readable category name). Where any of the three fields are absent from the field, they are either set to the closest available alternative or, in the case of "scheme", set to NULL.|
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getImage()                   |Returns an array containing data relating to any feed image or logo, or NULL if no image found. The resulting array may contain the following keys: uri, link, title, description, height, and width. Atom logos only contain a URI so the remaining metadata is drawn from RSS feeds only.                                                                                                                                                                                                         |
   +-----------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+


Given the variety of feeds in the wild, some of these methods will undoubtedly return ``NULL`` indicating the relevant information couldn't be located. Where possible, ``Zend_Feed_Reader`` will fall back on alternative elements during its search. For example, searching an *RSS* feed for a modification date is more complicated than it looks. *RSS* 2.0 feeds should include a ``<lastBuildDate>`` tag and (or) a ``<pubDate>`` element. But what if it doesn't, maybe this is an *RSS* 1.0 feed? Perhaps it instead has an ``<atom:updated>`` element with identical information (Atom may be used to supplement *RSS*'s syntax)? Failing that, we could simply look at the entries, pick the most recent, and use its ``<pubDate>`` element. Assuming it exists... Many feeds also use Dublin Core 1.0 or 1.1 ``<dc:date>`` elements for feeds and entries. Or we could find Atom lurking again.

The point is, ``Zend_Feed_Reader`` was designed to know this. When you ask for the modification date (or anything else), it will run off and search for all these alternatives until it either gives up and returns ``NULL``, or finds an alternative that should have the right answer.

In addition to the above methods, all Feed objects implement methods for retrieving the *DOM* and XPath objects for the current feeds as described earlier. Feed objects also implement the *SPL* Iterator and Countable interfaces. The extended *API* is summarised below.

.. table:: Extended Feed Level API Methods

   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDomDocument()          |Returns the parent DOMDocument object for the entire source XML document                                                                                                                                                              |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getElement()              |Returns the current feed level DOMElement object                                                                                                                                                                                      |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |saveXml()                 |Returns a string containing an XML document of the entire feed element (this is not the original document but a rebuilt version)                                                                                                      |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getXpath()                |Returns the DOMXPath object used internally to run queries on the DOMDocument object (this includes core and Extension namespaces pre-registered)                                                                                     |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getXpathPrefix()          |Returns the valid DOM path prefix prepended to all XPath queries matching the feed being queried                                                                                                                                      |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getEncoding()             |Returns the encoding of the source XML document (note: this cannot account for errors such as the server sending documents in a different encoding). Where not defined, the default UTF-8 encoding of Unicode is applied.             |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |count()                   |Returns a count of the entries or items this feed contains (implements SPLCountable interface)                                                                                                                                        |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |current()                 |Returns either the current entry (using the current index from key())                                                                                                                                                                 |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |key()                     |Returns the current entry index                                                                                                                                                                                                       |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |next()                    |Increments the entry index value by one                                                                                                                                                                                               |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |rewind()                  |Resets the entry index to 0                                                                                                                                                                                                           |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |valid()                   |Checks that the current entry index is valid, i.e. it does fall below 0 and does not exceed the number of entries existing.                                                                                                           |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getExtensions()           |Returns an array of all Extension objects loaded for the current feed (note: both feed-level and entry-level Extensions exist, and only feed-level Extensions are returned here). The array keys are of the form {ExtensionName}_Feed.|
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getExtension(string $name)|Returns an Extension object for the feed registered under the provided name. This allows more fine-grained access to Extensions which may otherwise be hidden within the implementation of the standard API methods.                  |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getType()                 |Returns a static class constant (e.g. Zend_Feed_Reader::TYPE_ATOM_03, i.e. Atom 0.3) indicating exactly what kind of feed is being consumed.                                                                                          |
   +--------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _zend.feed.reader.entry:

Retrieving Entry/Item Information
---------------------------------

Retrieving information for specific entries or items (depending on whether you speak Atom or *RSS*) is identical to feed level data. Accessing entries is simply a matter of iterating over a Feed object or using the *SPL* ``Iterator`` interface Feed objects implement and calling the appropriate method on each.

.. table:: Entry Level API Methods

   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getId()                                           |Returns a unique ID for the current entry.                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getTitle()                                        |Returns the title of the current entry.                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDescription()                                  |Returns a description of the current entry.                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getLink()                                         |Returns a URI to the HTML version of the current entry.                                                                                                                                                                                                                                                                                                                                                                                                                                      |
   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getPermaLink()                                    |Returns the permanent link to the current entry. In most cases, this is the same as using getLink().                                                                                                                                                                                                                                                                                                                                                                                         |
   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getAuthors()                                      |Returns an object of type Zend_Feed_Reader_Collection_Author which is an ArrayObject whose elements are each simple arrays containing any combination of the keys "name", "email" and "uri". Where irrelevant to the source data, some of these keys may be omitted.                                                                                                                                                                                                                         |
   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getAuthor(integer $index = 0)                     |Returns either the first author known, or with the optional $index parameter any specific index on the array of Authors as described above (returning NULL if an invalid index).                                                                                                                                                                                                                                                                                                             |
   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDateCreated()                                  |Returns the date on which the current entry was created. Generally only applicable to Atom where it represents the date the resource described by an Atom 1.0 document was created.                                                                                                                                                                                                                                                                                                          |
   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDateModified()                                 |Returns the date on which the current entry was last modified                                                                                                                                                                                                                                                                                                                                                                                                                                |
   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getContent()                                      |Returns the content of the current entry (this has any entities reversed if possible assuming the content type is HTML). The description is returned if a separate content element does not exist.                                                                                                                                                                                                                                                                                           |
   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getEnclosure()                                    |Returns an array containing the value of all attributes from a multi-media <enclosure> element including as array keys: url, length, type. In accordance with the RSS Best Practices Profile of the RSS Advisory Board, no support is offers for multiple enclosures since such support forms no part of the RSS specification.                                                                                                                                                              |
   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getCommentCount()                                 |Returns the number of comments made on this entry at the time the feed was last generated                                                                                                                                                                                                                                                                                                                                                                                                    |
   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getCommentLink()                                  |Returns a URI pointing to the HTML page where comments can be made on this entry                                                                                                                                                                                                                                                                                                                                                                                                             |
   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getCommentFeedLink([string $type = 'atom'\|'rss'])|Returns a URI pointing to a feed of the provided type containing all comments for this entry (type defaults to Atom/RSS depending on current feed type).                                                                                                                                                                                                                                                                                                                                     |
   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getCategories()                                   |Returns a Zend_Feed_Reader_Collection_Category object containing the details of any categories associated with the entry. The supported fields include "term" (the machine readable category name), "scheme" (the categorisation scheme and domain for this category), and "label" (a HTML decoded human readable category name). Where any of the three fields are absent from the field, they are either set to the closest available alternative or, in the case of "scheme", set to NULL.|
   +--------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+


The extended *API* for entries is identical to that for feeds with the exception of the Iterator methods which are not needed here.

.. caution::
   There is often confusion over the concepts of modified and created dates. In Atom, these are two clearly defined concepts (so knock yourself out) but in *RSS* they are vague. *RSS* 2.0 defines a single **<pubDate>** element which typically refers to the date this entry was published, i.e. a creation date of sorts. This is not always the case, and it may change with updates or not. As a result, if you really want to check whether an entry has changed, don't rely on the results of ``getDateModified()``. Instead, consider tracking the *MD5* hash of three other elements concatenated, e.g. using ``getTitle()``, ``getDescription()`` and ``getContent()``. If the entry was truly updated, this hash computation will give a different result than previously saved hashes for the same entry. This is obviously content oriented, and will not assist in detecting changes to other relevant elements. Atom feeds should not require such steps.


   Further muddying the waters, dates in feeds may follow different standards. Atom and Dublin Core dates should follow *ISO* 8601, and *RSS* dates should follow *RFC* 822 or *RFC* 2822 which is also common. Date methods will throw an exception if ``DateTime`` cannot load the date string using one of the above standards, or the *PHP* recognised possibilities for *RSS* dates.


.. warning::
   The values returned from these methods are not validated. This means users must perform validation on all retrieved data including the filtering of any *HTML* such as from ``getContent()`` before it is output from your application. Remember that most feeds come from external sources, and therefore the default assumption should be that they cannot be trusted.


.. table:: Extended Entry Level API Methods

   +--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getDomDocument()          |Returns the parent DOMDocument object for the entire feed (not just the current entry)                                                                                                                                                         |
   +--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getElement()              |Returns the current entry level DOMElement object                                                                                                                                                                                              |
   +--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getXpath()                |Returns the DOMXPath object used internally to run queries on the DOMDocument object (this includes core and Extension namespaces pre-registered)                                                                                              |
   +--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getXpathPrefix()          |Returns the valid DOM path prefix prepended to all XPath queries matching the entry being queried                                                                                                                                              |
   +--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getEncoding()             |Returns the encoding of the source XML document (note: this cannot account for errors such as the server sending documents in a different encoding). The default encoding applied in the absence of any other is the UTF-8 encoding of Unicode.|
   +--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getExtensions()           |Returns an array of all Extension objects loaded for the current entry (note: both feed-level and entry-level Extensions exist, and only entry-level Extensions are returned here). The array keys are in the form {ExtensionName}_Entry.      |
   +--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getExtension(string $name)|Returns an Extension object for the entry registered under the provided name. This allows more fine-grained access to Extensions which may otherwise be hidden within the implementation of the standard API methods.                          |
   +--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |getType()                 |Returns a static class constant (e.g. Zend_Feed_Reader::TYPE_ATOM_03, i.e. Atom 0.3) indicating exactly what kind of feed is being consumed.                                                                                                   |
   +--------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _zend.feed.reader.extending:

Extending Feed and Entry APIs
-----------------------------

Extending ``Zend_Feed_Reader`` allows you to add methods at both the feed and entry level which cover the retrieval of information not already supported by ``Zend_Feed_Reader``. Given the number of *RSS* and Atom extensions that exist, this is a good thing since ``Zend_Feed_Reader`` couldn't possibly add everything.

There are two types of Extensions possible, those which retrieve information from elements which are immediate children of the root element (e.g. ``<channel>`` for *RSS* or ``<feed>`` for Atom) and those who retrieve information from child elements of an entry (e.g. ``<item>`` for *RSS* or ``<entry>`` for Atom). On the filesystem these are grouped as classes within a namespace based on the extension standard's name. For example, internally we have ``Zend_Feed_Reader_Extension_DublinCore_Feed`` and ``Zend_Feed_Reader_Extension_DublinCore_Entry`` classes which are two Extensions implementing Dublin Core 1.0 and 1.1 support.

Extensions are loaded into ``Zend_Feed_Reader`` using ``Zend_Loader_PluginLoader``, so their operation will be familiar from other Zend Framework components. ``Zend_Feed_Reader`` already bundles a number of these Extensions, however those which are not used internally and registered by default (so called Core Extensions) must be registered to ``Zend_Feed_Reader`` before they are used. The bundled Extensions include:

.. table:: Core Extensions (pre-registered)

   +---------------------------+-------------------------------------------------------------------------+
   |DublinCore (Feed and Entry)|Implements support for Dublin Core Metadata Element Set 1.0 and 1.1      |
   +---------------------------+-------------------------------------------------------------------------+
   |Content (Entry only)       |Implements support for Content 1.0                                       |
   +---------------------------+-------------------------------------------------------------------------+
   |Atom (Feed and Entry)      |Implements support for Atom 0.3 and Atom 1.0                             |
   +---------------------------+-------------------------------------------------------------------------+
   |Slash                      |Implements support for the Slash RSS 1.0 module                          |
   +---------------------------+-------------------------------------------------------------------------+
   |WellFormedWeb              |Implements support for the Well Formed Web CommentAPI 1.0                |
   +---------------------------+-------------------------------------------------------------------------+
   |Thread                     |Implements support for Atom Threading Extensions as described in RFC 4685|
   +---------------------------+-------------------------------------------------------------------------+
   |Podcast                    |Implements support for the Podcast 1.0 DTD from Apple                    |
   +---------------------------+-------------------------------------------------------------------------+


The Core Extensions are somewhat special since they are extremely common and multi-faceted. For example, we have a Core Extension for Atom. Atom is implemented as an Extension (not just a base class) because it doubles as a valid *RSS* module - you can insert Atom elements into *RSS* feeds. I've even seen *RDF* feeds which use a lot of Atom in place of more common Extensions like Dublin Core.

.. table:: Non-Core Extensions (must register manually)

   +---------------+-------------------------------------------------------------------------------------------------------------------------+
   |Syndication    |Implements Syndication 1.0 support for RSS feeds                                                                         |
   +---------------+-------------------------------------------------------------------------------------------------------------------------+
   |CreativeCommons|A RSS module that adds an element at the <channel> or <item> level that specifies which Creative Commons license applies.|
   +---------------+-------------------------------------------------------------------------------------------------------------------------+


The additional non-Core Extensions are offered but not registered to ``Zend_Feed_Reader`` by default. If you want to use them, you'll need to tell ``Zend_Feed_Reader`` to load them in advance of importing a feed. Additional non-Core Extensions will be included in future iterations of the component.

Registering an Extension with ``Zend_Feed_Reader``, so it is loaded and its *API* is available to Feed and Entry objects, is a simple affair using the ``Zend_Loader_PluginLoader``. Here we register the optional Slash Extension, and discover that it can be directly called from the Entry level *API* without any effort. Note that Extension names are case sensitive and use camel casing for multiple terms.

.. code-block:: php
   :linenos:

   Zend_Feed_Reader::registerExtension('Syndication');
   $feed = Zend_Feed_Reader::import('http://rss.slashdot.org/Slashdot/slashdot');
   $updatePeriod = $feed->current()->getUpdatePeriod();

In the simple example above, we checked how frequently a feed is being updated using the ``getUpdatePeriod()`` method. Since it's not part of ``Zend_Feed_Reader``'s core *API*, it could only be a method supported by the newly registered Syndication Extension.

As you can also notice, the new methods from Extensions are accessible from the main *API* using *PHP*'s magic methods. As an alternative, you can also directly access any Extension object for a similar result as seen below.

.. code-block:: php
   :linenos:

   Zend_Feed_Reader::registerExtension('Syndication');
   $feed = Zend_Feed_Reader::import('http://rss.slashdot.org/Slashdot/slashdot');
   $syndication = $feed->getExtension('Syndication');
   $updatePeriod = $syndication->getUpdatePeriod();


.. _zend.feed.reader.extending.feed:

Writing Zend_Feed_Reader Extensions
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Inevitably, there will be times when the ``Zend_Feed_Reader`` *API* is just not capable of getting something you need from a feed or entry. You can use the underlying source objects, like DOMDocument, to get these by hand however there is a more reusable method available by writing Extensions supporting these new queries.

As an example, let's take the case of a purely fictitious corporation named Jungle Books. Jungle Books have been publishing a lot of reviews on books they sell (from external sources and customers), which are distributed as an *RSS* 2.0 feed. Their marketing department realises that web applications using this feed cannot currently figure out exactly what book is being reviewed. To make life easier for everyone, they determine that the geek department needs to extend *RSS* 2.0 to include a new element per entry supplying the *ISBN*-10 or *ISBN*-13 number of the publication the entry concerns. They define the new ``<isbn>`` element quite simply with a standard name and namespace *URI*:

.. code-block:: php
   :linenos:

   JungleBooks 1.0:
   http://example.com/junglebooks/rss/module/1.0/

A snippet of *RSS* containing this extension in practice could be something similar to:

.. code-block:: php
   :linenos:

   <?xml version="1.0" encoding="utf-8" ?>
   <rss version="2.0"
      xmlns:content="http://purl.org/rss/1.0/modules/content/"
      xmlns:jungle="http://example.com/junglebooks/rss/module/1.0/">
   <channel>
       <title>Jungle Books Customer Reviews</title>
       <link>http://example.com/junglebooks</link>
       <description>Many book reviews!</description>
       <pubDate>Fri, 26 Jun 2009 19:15:10 GMT</pubDate>
       <jungle:dayPopular>
           http://example.com/junglebooks/book/938
       </jungle:dayPopular>
       <item>
           <title>Review Of Flatland: A Romance of Many Dimensions</title>
           <link>http://example.com/junglebooks/review/987</link>
           <author>Confused Physics Student</author>
           <content:encoded>
           A romantic square?!
           </content:encoded>
           <pubDate>Thu, 25 Jun 2009 20:03:28 -0700</pubDate>
           <jungle:isbn>048627263X</jungle:isbn>
       </item>
   </channel>
   </rss>

Implementing this new *ISBN* element as a simple entry level extension would require the following class (using your own class namespace outside of Zend).

.. code-block:: php
   :linenos:

   class My_FeedReader_Extension_JungleBooks_Entry
       extends Zend_Feed_Reader_Extension_EntryAbstract
   {
       public function getIsbn()
       {
           if (isset($this->_data['isbn'])) {
               return $this->_data['isbn'];
           }
           $isbn = $this->_xpath->evaluate(
               'string(' . $this->getXpathPrefix() . '/jungle:isbn)'
           );
           if (!$isbn) {
               $isbn = null;
           }
           $this->_data['isbn'] = $isbn;
           return $this->_data['isbn'];
       }

       protected function _registerNamespaces()
       {
           $this->_xpath->registerNamespace(
               'jungle', 'http://example.com/junglebooks/rss/module/1.0/'
           );
       }
   }

This extension is easy enough to follow. It creates a new method ``getIsbn()`` which runs an XPath query on the current entry to extract the *ISBN* number enclosed by the ``<jungle:isbn>`` element. It can optionally store this to the internal non-persistent cache (no need to keep querying the *DOM* if it's called again on the same entry). The value is returned to the caller. At the end we have a protected method (it's abstract so it must exist) which registers the Jungle Books namespace for their custom *RSS* module. While we call this an *RSS* module, there's nothing to prevent the same element being used in Atom feeds - and all Extensions which use the prefix provided by ``getXpathPrefix()`` are actually neutral and work on *RSS* or Atom feeds with no extra code.

Since this Extension is stored outside of Zend Framework, you'll need to register the path prefix for your Extensions so ``Zend_Loader_PluginLoader`` can find them. After that, it's merely a matter of registering the Extension, if it's not already loaded, and using it in practice.

.. code-block:: php
   :linenos:

   if(!Zend_Feed_Reader::isRegistered('JungleBooks')) {
       Zend_Feed_Reader::addPrefixPath(
           'My_FeedReader_Extension', '/path/to/My/FeedReader/Extension'
       );
       Zend_Feed_Reader::registerExtension('JungleBooks');
   }
   $feed = Zend_Feed_Reader::import('http://example.com/junglebooks/rss');

   // ISBN for whatever book the first entry in the feed was concerned with
   $firstIsbn = $feed->current()->getIsbn();

Writing a feed level Extension is not much different. The example feed from earlier included an unmentioned ``<jungle:dayPopular>`` element which Jungle Books have added to their standard to include a link to the day's most popular book (in terms of visitor traffic). Here's an Extension which adds a ``getDaysPopularBookLink()`` method to the feel level *API*.

.. code-block:: php
   :linenos:

   class My_FeedReader_Extension_JungleBooks_Feed
       extends Zend_Feed_Reader_Extension_FeedAbstract
   {
       public function getDaysPopularBookLink()
       {
           if (isset($this->_data['dayPopular'])) {
               return $this->_data['dayPopular'];
           }
           $dayPopular = $this->_xpath->evaluate(
               'string(' . $this->getXpathPrefix() . '/jungle:dayPopular)'
           );
           if (!$dayPopular) {
               $dayPopular = null;
           }
           $this->_data['dayPopular'] = $dayPopular;
           return $this->_data['dayPopular'];
       }

       protected function _registerNamespaces()
       {
           $this->_xpath->registerNamespace(
               'jungle', 'http://example.com/junglebooks/rss/module/1.0/'
           );
       }
   }

Let's repeat the last example using a custom Extension to show the method being used.

.. code-block:: php
   :linenos:

   if(!Zend_Feed_Reader::isRegistered('JungleBooks')) {
       Zend_Feed_Reader::addPrefixPath(
           'My_FeedReader_Extension', '/path/to/My/FeedReader/Extension'
       );
       Zend_Feed_Reader::registerExtension('JungleBooks');
   }
   $feed = Zend_Feed_Reader::import('http://example.com/junglebooks/rss');

   // URI to the information page of the day's most popular book with visitors
   $daysPopularBookLink = $feed->getDaysPopularBookLink();

   // ISBN for whatever book the first entry in the feed was concerned with
   $firstIsbn = $feed->current()->getIsbn();

Going through these examples, you'll note that we don't register feed and entry Extensions separately. Extensions within the same standard may or may not include both a feed and entry class, so ``Zend_Feed_Reader`` only requires you to register the overall parent name, e.g. JungleBooks, DublinCore, Slash. Internally, it can check at what level Extensions exist and load them up if found. In our case, we have a full set of Extensions now: ``JungleBooks_Feed`` and ``JungleBooks_Entry``.


