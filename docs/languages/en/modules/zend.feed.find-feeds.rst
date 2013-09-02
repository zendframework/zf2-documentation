.. _zend.feed.findFeeds:

Retrieving Feeds from Web Pages
===============================

.. _zend.feed.findFeeds.introduction:

Find Feed Links
---------------

Web pages often contain **<link>** tags that refer to feeds with content relevant to the particular page.
``Zend\Feed\Reader\Reader`` enables you to retrieve all feeds referenced by a web page with one simple method call:

.. code-block:: php
   :linenos:

   $feedLinks = Zend\Feed\Reader\Reader::findFeedLinks('http://www.example.com/news.html');

Here the ``findFeedLinks()`` method returns a ``Zend\Feed\Reader\FeedSet`` object, that is in turn, a collection
of other ``Zend\Feed\Reader\FeedSet`` objects, that are referenced by **<link>** tags on the ``news.html`` web page.
``Zend\Feed\Reader\Reader`` will throw a ``Zend\Feed\Reader\Exception\RuntimeException`` upon failure, such as
an *HTTP* 404 response code or a malformed feed.

You can examine all feed links located by iterating across the collection:

.. code-block:: php
    :linenos:

    $rssFeed = null;
    $feedLinks = Zend\Feed\Reader\Reader::findFeedLinks('http://www.example.com/news.html');
    foreach ($feedLinks as $link) {
        if (stripos($link['type'], 'application/rss+xml') !== false) {
            $rssFeed = $link['href'];
            break;
    }

Each ``Zend\Feed\Reader\FeedSet`` object will expose the rel, href, type and title properties of detected links for
all *RSS*, *Atom* or *RDF* feeds. You can always select the first encountered link of each type by using a shortcut:

.. code-block:: php
    :linenos:

    $rssFeed = null;
    $feedLinks = Zend\Feed\Reader\Reader::findFeedLinks('http://www.example.com/news.html');
    $firstAtomFeed = $feedLinks->atom;
