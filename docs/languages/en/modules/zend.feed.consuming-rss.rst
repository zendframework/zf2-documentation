.. _zend.feed.consuming-rss:

Consuming an RSS Feed
=====================

.. _zend.feed.consuming-rss.reading-feed:

Reading a feed
--------------

Reading an *RSS* feed is as simple as passing the *URL* of the feed to ``Zend\Feed\Reader\Reader``'s ``import``
method.

.. code-block:: php
   :linenos:

   $channel = Zend\Feed\Reader\Reader::import('http://rss.example.com/channelName');

If any errors occur fetching the feed, a ``Zend\Feed\Reader\Exception\RuntimeException`` will be thrown.

.. _zend.feed.consuming-rss.get-properties:

Get properties
--------------

Once you have a feed object, you can access any of the standard *RSS* "channel" properties directly on the object:

.. code-block:: php
   :linenos:

   echo $channel->getTitle();

Properties of the channel can be accessed via getter methods, such as ``getTitle``, ``getAuthor`` ...

If channel properties have attributes, the getter method will return a key/value pair, where the key is the
attribute name, and the value is the attribute value.

.. code-block:: php
   :linenos:

   $author = $channel->getAuthor();
   echo $author['name'];

Most commonly you'll want to loop through the feed and do something with its entries. ``Zend\Feed\Reader\Feed\Rss``
internally converts all entries to a ``Zend\Feed\Reader\Entry\Rss``. Entry properties, similarly to channel
properties, can be accessed via getter methods, such as ``getTitle``, ``getDescription`` ...

An example of printing all titles of articles in a channel is:

.. code-block:: php
   :linenos:

   foreach ($channel as $item) {
       echo $item->getTitle() . "\n";
   }

If you are not familiar with *RSS*, here are the standard elements you can expect to be available in an *RSS*
channel and in individual *RSS* items (entries).

Required channel elements:

- ``title``- The name of the channel

- ``link``- The *URL* of the web site corresponding to the channel

- ``description``- A sentence or several describing the channel

Common optional channel elements:

- ``pubDate``- The publication date of this set of content, in *RFC* 822 date format

- ``language``- The language the channel is written in

- ``category``- One or more (specified by multiple tags) categories the channel belongs to

*RSS* **<item>** elements do not have any strictly required elements. However, either ``title`` or ``description``
must be present.

Common item elements:

- ``title``- The title of the item

- ``link``- The *URL* of the item

- ``description``- A synopsis of the item

- ``author``- The author's email address

- ``category``- One more categories that the item belongs to

- ``comments``-*URL* of comments relating to this item

- ``pubDate``- The date the item was published, in *RFC* 822 date format

In your code you can always test to see if an element is non-empty with:

.. code-block:: php
   :linenos:

   if ($item->getPropname()) {
       // ... proceed.
   }

Where relevant, ``Zend\Feed`` supports a number of common RSS extensions including Dublin Core, Atom (inside RSS)
and the Content, Slash, Syndication, Syndication/Thread and several other extensions or modules.

For further information, the official *RSS* 2.0 specification is available at:
http://blogs.law.harvard.edu/tech/rss

