.. _zend.feed.consuming-atom:

Consuming an Atom Feed
======================

``Zend\Feed\Reader\Feed\Atom`` is used in much the same way as ``Zend\Feed\Reader\Feed\Rss``. It provides the
same access to feed-level properties and iteration over entries in the feed. The main difference is in the 
structure of the Atom protocol itself. Atom is a successor to *RSS*; it is a more generalized protocol and it is
designed to deal more easily with feeds that provide their full content inside the feed, splitting *RSS*'
``description`` tag into two elements, ``summary`` and ``content``, for that purpose.

.. _zend.feed.consuming-atom.example.usage:

Basic Use of an Atom Feed
-------------------------

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

Where relevant, ``Zend\Feed`` supports a number of common RSS extensions including Dublin Core and the Content,
Slash, Syndication, Syndication/Thread and several other extensions in common use on blogs.

For more information on Atom and plenty of resources, see http://www.atomenabled.org/.

