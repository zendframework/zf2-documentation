.. _zend.feed.consuming-atom:

Consuming an Atom Feed
======================

``Zend_Feed_Atom`` is used in much the same way as ``Zend_Feed_Rss``. It provides the same access to feed-level
properties and iteration over entries in the feed. The main difference is in the structure of the Atom protocol
itself. Atom is a successor to *RSS*; it is more generalized protocol and it is designed to deal more easily with
feeds that provide their full content inside the feed, splitting *RSS*'``description`` tag into two elements,
``summary`` and ``content``, for that purpose.

.. _zend.feed.consuming-atom.example.usage:

.. rubric:: Basic Use of an Atom Feed

Read an Atom feed and print the ``title`` and ``summary`` of each entry:

.. code-block:: php
   :linenos:

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/');
   echo 'The feed contains ' . $feed->count() . ' entries.' . "\n\n";
   foreach ($feed as $entry) {
       echo 'Title: ' . $entry->title() . "\n";
       echo 'Summary: ' . $entry->summary() . "\n";
       echo 'URL: ' . $entry->link['href'] . "\n\n";
   }

In an Atom feed you can expect to find the following feed properties:

- ``title``- The feed's title, same as *RSS*'s channel title

- ``id``- Every feed and entry in Atom has a unique identifier

- ``link``- Feeds can have multiple links, which are distinguished by a ``type`` attribute

  The equivalent to *RSS*'s channel link would be ``type="text/html"``. if the link is to an alternate version of
  the same content that's in the feed, it would have a ``rel="alternate"`` attribute.

- ``subtitle``- The feed's description, equivalent to *RSS*' channel description

  ``author->name()``- The feed author's name

  ``author->email()``- The feed author's email address

Atom entries commonly have the following properties:

- ``id``- The entry's unique identifier

- ``title``- The entry's title, same as *RSS* item titles

- ``link``- A link to another format or an alternate view of this entry

  The link property of an atom entry typically has an ``href`` attribute. Attributes can be accessed using array
  notation. For example, ``$entry->link['rel']`` and ``$entry->link['href']``.

- ``summary``- A summary of this entry's content

- ``content``- The full content of the entry; can be skipped if the feed just contains summaries

- ``author``- with ``name`` and ``email`` sub-tags like feeds have

- ``published``- the date the entry was published, in *RFC* 3339 format

- ``updated``- the date the entry was last updated, in *RFC* 3339 format

For more information on Atom and plenty of resources, see `http://www.atomenabled.org/`_.



.. _`http://www.atomenabled.org/`: http://www.atomenabled.org/
