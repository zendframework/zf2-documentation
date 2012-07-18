.. _zend.feed.modifying-feed:

Modifying Feed and Entry structures
===================================

``Zend_Feed``'s natural syntax extends to constructing and modifying feeds and entries as well as reading them. You can easily turn your new or modified objects back into well-formed *XML* for saving to a file or sending to a server.

.. _zend.feed.modifying-feed.example.modifying:

.. rubric:: Modifying an Existing Feed Entry

.. code-block:: php
   :linenos:

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/1');
   $entry = $feed->current();

   $entry->title = 'This is a new title';
   $entry->author->email = 'my_email@example.com';

   echo $entry->saveXML();

This will output a full (includes ``<?xml ... >`` prologue) *XML* representation of the new entry, including any necessary *XML* namespaces.

Note that the above will work even if the existing entry does not already have an author tag. You can use as many levels of ``->`` access as you like before getting to an assignment; all of the intervening levels will be created for you automatically if necessary.

If you want to use a namespace other than ``atom:``, ``rss:``, or ``osrss:`` in your entry, you need to register the namespace with ``Zend_Feed`` using ``Zend_Feed::registerNamespace()``. When you are modifying an existing element, it will always maintain its original namespace. When adding a new element, it will go into the default namespace if you do not explicitly specify another namespace.

.. _zend.feed.modifying-feed.example.creating:

.. rubric:: Creating an Atom Entry with Elements of Custom Namespaces

.. code-block:: php
   :linenos:

   $entry = new Zend_Feed_Entry_Atom();
   // id is always assigned by the server in Atom
   $entry->title = 'my custom entry';
   $entry->author->name = 'Example Author';
   $entry->author->email = 'me@example.com';

   // Now do the custom part.
   Zend_Feed::registerNamespace('myns', 'http://www.example.com/myns/1.0');

   $entry->{'myns:myelement_one'} = 'my first custom value';
   $entry->{'myns:container_elt'}->part1 = 'first nested custom part';
   $entry->{'myns:container_elt'}->part2 = 'second nested custom part';

   echo $entry->saveXML();


