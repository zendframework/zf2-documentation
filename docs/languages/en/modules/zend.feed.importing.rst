.. _zend.feed.importing:

Importing Feeds
===============

``Zend\Feed`` enables developers to retrieve feeds very easily, by using ``Zend\Feader\Reader``.
If you know the *URI* of a feed, simply use the ``Zend\Feed\Reader\Reader::import()`` method:

.. code-block:: php
   :linenos:

   $feed = Zend\Feed\Reader\Reader::import('http://feeds.example.com/feedName');

You can also use ``Zend\Feed\Reader\Reader`` to fetch the contents of a feed from a file or the contents of a *PHP*
string variable:

.. code-block:: php
   :linenos:

   // importing a feed from a text file
   $feedFromFile = Zend\Feed\Reader\Reader::importFile('feed.xml');

   // importing a feed from a PHP string variable
   $feedFromPHP = Zend\Feed\Reader\Reader::importString($feedString);

In each of the examples above, an object of a class that extends ``Zend\Feed\Reader\Feed\AbstractFeed`` is
returned upon success, depending on the type of the feed. If an *RSS* feed were retrieved via one of the 
import methods above, then a ``Zend\Feed\Reader\Feed\Rss`` object would be returned. On the other hand,
if an Atom feed were imported, then a ``Zend\Feed\Reader\Feed\Atom`` object is returned. The import methods
will also throw a ``Zend\Feed\Exception\Reader\RuntimeException`` object upon failure, such as an unreadable
or malformed feed.

.. _zend.feed.importing.custom.dump:

Dumping the contents of a feed
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To dump the contents of a ``Zend\Feed\Reader\Feed\AbstractFeed`` instance, you may use the ``saveXml()`` method.

.. code-block:: php
   :linenos:

   assert($feed instanceof Zend\Feed\Reader\Feed\AbstractFeed);

   // dump the feed to standard output
   print $feed->saveXml();


.. _`RSS 2.0`: http://blogs.law.harvard.edu/tech/rss
.. _`RFC 4287`: http://tools.ietf.org/html/rfc4287
.. _`Well Formed Web`: http://wellformedweb.org/news/wfw_namespace_elements
.. _`iTunes Technical Specifications`: http://www.apple.com/itunes/store/podcaststechspecs.html
