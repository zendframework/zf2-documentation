.. _zend.feed.findFeeds:

Retrieving Feeds from Web Pages
===============================

Web pages often contain **<link>** tags that refer to feeds with content relevant to the particular page.
``Zend_Feed`` enables you to retrieve all feeds referenced by a web page with one simple method call:

.. code-block:: php
   :linenos:

   $feedArray = Zend_Feed::findFeeds('http://www.example.com/news.html');

Here the ``findFeeds()`` method returns an array of ``Zend_Feed_Abstract`` objects that are referenced by
**<link>** tags on the ``news.html`` web page. Depending on the type of each feed, each respective entry in the
``$feedArray`` array may be a ``Zend_Feed_Rss`` or ``Zend_Feed_Atom`` instance. ``Zend_Feed`` will throw a
``Zend_Feed_Exception`` upon failure, such as an *HTTP* 404 response code or a malformed feed.


