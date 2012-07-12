
Introduction
============

``Zend_Feed`` provides functionality for consuming *RSS* and Atom feeds. It provides a natural syntax for accessing elements of feeds, feed attributes, and entry attributes. ``Zend_Feed`` also has extensive support for modifying feed and entry structure with the same natural syntax, and turning the result back into *XML* . In the future, this modification support could provide support for the Atom Publishing Protocol.

Programmatically, ``Zend_Feed`` consists of a base ``Zend_Feed`` class, abstract ``Zend_Feed_Abstract`` and ``Zend_Feed_Entry_Abstract`` base classes for representing Feeds and Entries, specific implementations of feeds and entries for *RSS* and Atom, and a behind-the-scenes helper for making the natural syntax magic work.

In the example below, we demonstrate a simple use case of retrieving an *RSS* feed and saving relevant portions of the feed data to a simple *PHP* array, which could then be used for printing the data, storing to a database, etc.

.. note::
    **Be aware**

    Many *RSS* feeds have different channel and item properties available. The *RSS* specification provides for many optional properties, so be aware of this when writing code to work with *RSS* data.


