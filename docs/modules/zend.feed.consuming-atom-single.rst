.. _zend.feed.consuming-atom-single-entry:

Consuming a Single Atom Entry
=============================

Single Atom ``<entry>`` elements are also valid by themselves. Usually the *URL* for an entry is the feed's *URL*
followed by ``/<entryId>``, such as ``http://atom.example.com/feed/1``, using the example *URL* we used above.

If you read a single entry, you will still have a ``Zend_Feed_Atom`` object, but it will automatically create an
"anonymous" feed to contain the entry.

.. _zend.feed.consuming-atom-single-entry.example.atom:

.. rubric:: Reading a Single-Entry Atom Feed

.. code-block:: php
   :linenos:

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/1');
   echo 'The feed has: ' . $feed->count() . ' entry.';

   $entry = $feed->current();

Alternatively, you could instantiate the entry object directly if you know you are accessing an ``<entry>``-only
document:

.. _zend.feed.consuming-atom-single-entry.example.entryatom:

.. rubric:: Using the Entry Object Directly for a Single-Entry Atom Feed

.. code-block:: php
   :linenos:

   $entry = new Zend_Feed_Entry_Atom('http://atom.example.com/feed/1');
   echo $entry->title();


