.. _zend.feed.consuming-atom:

Consuming an Atom Feed
======================

``Zend\Feed\Reader\Feed\Atom`` is used in much the same way as ``Zend\Feed\Reader\Feed\Rss``. It provides the
same access to feed-level properties and iteration over entries in the feed. The main difference is in the 
structure of the Atom protocol itself. Atom is a successor to *RSS*; it is more generalized protocol and it is
designed to deal more easily with feeds that provide their full content inside the feed, splitting *RSS*'
``description`` tag into two elements, ``summary`` and ``content``, for that purpose.

.. _zend.feed.consuming-atom.example.usage:

.. rubric:: Basic Use of an Atom Feed

Read an Atom feed and print the ``title`` and ``summary`` of each entry:

.. code-block:: php
   :linenos:

   $feed = Zend\Feed\Reader\Reader::import('http://atom.example.com/feed/');
   echo 'The feed contains ' . $feed->count() . ' entries.' . "\n\n";
   foreach ($feed as $entry) {
       echo 'Title: ' . $entry->getTitle() . "\n";
       echo 'Description: ' . $entry->getDescription() . "\n";
       echo 'URL: ' . $entry->getLink() . "\n\n";
   }

In an Atom feed you can expect to find the following feed properties:

- ``title``- The feed's title, same as *RSS*'s channel title

- ``id``- Every feed and entry in Atom has a unique identifier

- ``link``- Feeds can have multiple links, which are distinguished by a ``type`` attribute

  The equivalent to *RSS*'s channel link would be ``type="text/html"``. if the link is to an alternate version of
  the same content that's in the feed, it would have a ``rel="alternate"`` attribute.

- ``subtitle``- The feed's description, equivalent to *RSS*' channel description

- ``author``- The feed's author, with ``name`` and ``email`` sub-tags

Atom entries commonly have the following properties:

- ``id``- The entry's unique identifier

- ``title``- The entry's title, same as *RSS* item titles

- ``link``- A link to another format or an alternate view of this entry

  The link property of an atom entry typically has an ``href`` attribute.

- ``summary``- A summary of this entry's content

- ``content``- The full content of the entry; can be skipped if the feed just contains summaries

- ``author``- with ``name`` and ``email`` sub-tags like feeds have

- ``published``- the date the entry was published, in *RFC* 3339 format

- ``updated``- the date the entry was last updated, in *RFC* 3339 format

For more information on Atom and plenty of resources, see `http://www.atomenabled.org/`_.

Feed element getter methods
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Feed\Reader\Feed\Atom`` has the following getter methods for accessing common feed elements:


- ``getAuthor`` - Get one channel author. This method accepts an index to access a single author.

- ``getAuthors`` - Get all channel authors.

- ``getCopyright`` - Get the copyright entry of the channel.

- ``getDateCreated`` - Get the feed creation date.

- ``getDateModified`` - Get the feed modification date.

- ``getDescription`` - Get the feed description.

- ``getId`` - Get the feed ID.

- ``getImage`` - Get the feed image data.

- ``getLanguage`` - Get the feed language.

- ``getBaseUrl`` - Get a link to the source website.

- ``getLink`` - Get a link to the feed.

- ``getFeedLink`` - Get a link to the feed XML.

- ``getGenerator`` - Get the feed generator entry.

- ``getTitle`` - Get the title of the channel.

- ``getHubs`` - Get an array of any supported Pusubhubbub endpoints.

- ``getCategories`` - Get all channel categories.

Entry element getter methods
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Feed\Reader\Feed\Entry\Atom`` has the following getter methods for accessing common entry elements:

- ``getAuthor`` - Get one entry author. This method accepts an index to access a single author.

- ``getAuthors`` - Get all entry authors.

- ``getContent`` - Get the entry content.

- ``getDateCreated`` - Get the entry creation date.

- ``getDateModified`` - Get the entry modification date.

- ``getDescription`` - Get the entry summary, description.

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

- ``getSource`` - Get source feed metadata from the entry.


.. _`http://www.atomenabled.org/`: http://www.atomenabled.org/
