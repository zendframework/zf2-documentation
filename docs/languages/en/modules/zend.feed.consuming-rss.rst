.. _zend.feed.consuming-rss:

Consuming an RSS Feed
=====================

Reading an *RSS* feed is as simple as passing the *URL* of the feed to ``Zend\Feed\Reader\Reader``'s ``import``
method.

.. code-block:: php
   :linenos:

   $channel = new Zend\Feed\Reader\Reader::import('http://rss.example.com/channelName');

If any errors occur fetching the feed, a ``Zend\Feed\Reader\Exception\RuntimeException`` will be thrown.

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
internally converts all entries to a ``Zend\Feed\Reader\Entry\Rss``. Entry properties, similary to channel
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

For further information, the official *RSS* 2.0 specification is available at:
`http://blogs.law.harvard.edu/tech/rss`_

Channel element getter methods
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Feed\Reader\Feed\Rss`` has the following getter methods for accessing common channel elements:


- ``getAuthor`` - Get one channel author. This method accepts an index to access a single author.

- ``getAuthors`` - Get all channel authors.

- ``getCopyright`` - Get the copyright entry of the channel.

- ``getDateCreated`` - Get the feed creation date.

- ``getDateModified`` - Get the feed modification date.

- ``getLastBuildDate`` - Get the feed last build date.

- ``getDescription`` - Get the feed description.

- ``getId`` - Get the feed ID.

- ``getImage`` - Get the feed image data.

- ``getLanguage`` - Get the feed language.

- ``getLink`` - Get a link to the feed.

- ``getFeedLink`` - Get a link to the feed XML.

- ``getGenerator`` - Get the feed generator entry.

- ``getTitle`` - Get the title of the channel.

- ``getHubs`` - Get an array of any supported Pusubhubbub endpoints.

- ``getCategories`` - Get all channel categories.

Entry element getter methods
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Feed\Reader\Feed\Entry\Rss`` has the following getter methods for accessing common entry elements:

- ``getAuthor`` - Get one entry author. This method accepts an index to access a single author.

- ``getAuthors`` - Get all entry authors.

- ``getContent`` - Get the entry content.

- ``getDateCreated`` - Get the entry creation date.

- ``getDateModified`` - Get the entry modification date.

- ``getDescription`` - Get the entry description.

- ``getEnclosure`` - Get the entry enclosure.

- ``getId`` - Get the entry ID.

- ``getLink`` - Get a specific link.  This method accepts an index to access a single link.

- ``getLinks`` - Get all links.

- ``getCategories`` - Get all entry categories.

- ``getPermalink`` - Get a permalink to the entry.

- ``getTitle`` - Get the entry title.

- ``getCommentCount`` - Get the number of comments for the entry.

- ``getCommentLink`` - Returns a URI pointing to the HTML page where comments can be made on an entry.

- ``getCommentFeedLink`` - Returns a URI pointing to a feed of all comments for an entry.


.. _`http://blogs.law.harvard.edu/tech/rss`: http://blogs.law.harvard.edu/tech/rss
