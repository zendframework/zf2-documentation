
Consuming an Atom Feed
======================

``Zend_Feed_Atom`` is used in much the same way as ``Zend_Feed_Rss`` . It provides the same access to feed-level properties and iteration over entries in the feed. The main difference is in the structure of the Atom protocol itself. Atom is a successor to *RSS* ; it is more generalized protocol and it is designed to deal more easily with feeds that provide their full content inside the feed, splitting *RSS* ' ``description`` tag into two elements, ``summary`` and ``content`` , for that purpose.

In an Atom feed you can expect to find the following feed properties:

Atom entries commonly have the following properties:

For more information on Atom and plenty of resources, see `http://www.atomenabled.org/`_ .


.. _`http://www.atomenabled.org/`: http://www.atomenabled.org/
