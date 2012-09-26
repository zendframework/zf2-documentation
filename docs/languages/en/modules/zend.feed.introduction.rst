.. _zend.feed.introduction:

Introduction
============

``Zend\Feed`` provides functionality for consuming *RSS* and *Atom* feeds. It provides a natural syntax for accessing
elements of feeds, feed attributes, and entry attributes. ``Zend\Feed`` also has extensive support for modifying
feed and entry structure with the same natural syntax, and turning the result back into *XML*. In the future, this
modification support could provide support for the Atom Publishing Protocol.

``Zend\Feed`` consists of ``Zend\Feed\Reader`` for reading *RSS* and *Atom* feeds, ``Zend\Feed\Writer``
for writing *RSS* and *Atom* feeds, and ``Zend\Feed\PubSubHubbub`` for working with Hub servers.
Further on, both ``Zend\Feed\Reader`` and ``Zend\Feed\Writer`` support extensions which allows for
working with additional data in feeds, not covered in the core *API*.

In the example below, we demonstrate a simple use case of retrieving an *RSS* feed and saving relevant portions of
the feed data to a simple *PHP* array, which could then be used for printing the data, storing to a database, etc.

.. note::

   **Be aware**

   Many *RSS* feeds have different channel and item properties available. The *RSS* specification provides for many
   optional properties, so be aware of this when writing code to work with *RSS* data.

.. _zend.feed.introduction.example.rss:

.. rubric:: Reading RSS Feed Data with Zend\\Feed\\Reader

.. code-block:: php
   :linenos:

   // Fetch the latest Slashdot headlines
   try {
       $slashdotRss =
           Zend\Feed\Reader\Reader::import('http://rss.slashdot.org/Slashdot/slashdot');
   } catch (Zend\Feed\Exception\Reader\RuntimeException $e) {
       // feed import failed
       echo "Exception caught importing feed: {$e->getMessage()}\n";
       exit;
   }

   // Initialize the channel data array
   $channel = array(
       'title'       => $slashdotRss->getTitle(),
       'link'        => $slashdotRss->getLink(),
       'description' => $slashdotRss->getDescription(),
       'items'       => array()
       );

   // Loop over each channel item and store relevant data
   foreach ($slashdotRss as $item) {
       $channel['items'][] = array(
           'title'       => $item->getTitle(),
           'link'        => $item->getLink(),
           'description' => $item->getDescription()
           );
   }


