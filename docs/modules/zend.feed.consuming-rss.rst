.. _zend.feed.consuming-rss:

Consuming an RSS Feed
=====================

Reading an *RSS* feed is as simple as instantiating a ``Zend_Feed_Rss`` object with the *URL* of the feed:

.. code-block:: php
   :linenos:

   $channel = new Zend_Feed_Rss('http://rss.example.com/channelName');

If any errors occur fetching the feed, a ``Zend_Feed_Exception`` will be thrown.

Once you have a feed object, you can access any of the standard *RSS*"channel" properties directly on the object:

.. code-block:: php
   :linenos:

   echo $channel->title();

Note the function syntax. ``Zend_Feed`` uses a convention of treating properties as *XML* object if they are
requested with variable "getter" syntax (``$obj->property``) and as strings if they are access with method syntax
(``$obj->property()``). This enables access to the full text of any individual node while still allowing full
access to all children.

If channel properties have attributes, they are accessible using *PHP*'s array syntax:

.. code-block:: php
   :linenos:

   echo $channel->category['domain'];

Since *XML* attributes cannot have children, method syntax is not necessary for accessing attribute values.

Most commonly you'll want to loop through the feed and do something with its entries. ``Zend_Feed_Abstract``
implements *PHP*'s ``Iterator`` interface, so printing all titles of articles in a channel is just a matter of:

.. code-block:: php
   :linenos:

   foreach ($channel as $item) {
       echo $item->title() . "\n";
   }

If you are not familiar with *RSS*, here are the standard elements you can expect to be available in an *RSS*
channel and in individual *RSS* items (entries).

Required channel elements:

- ``title``- The name of the channel

- ``link``- The *URL* of the web site corresponding to the channel

- ``description``- A sentence or several describing the channel

Common optional channel elements:

- ``pubDate``- The publication date of this set of content, in *RFC* 822 date format

- ``language``- The language the channel is written in

- ``category``- One or more (specified by multiple tags) categories the channel belongs to

*RSS* **<item>** elements do not have any strictly required elements. However, either ``title`` or ``description``
must be present.

Common item elements:

- ``title``- The title of the item

- ``link``- The *URL* of the item

- ``description``- A synopsis of the item

- ``author``- The author's email address

- ``category``- One more categories that the item belongs to

- ``comments``-*URL* of comments relating to this item

- ``pubDate``- The date the item was published, in *RFC* 822 date format

In your code you can always test to see if an element is non-empty with:

.. code-block:: php
   :linenos:

   if ($item->propname()) {
       // ... proceed.
   }

If you use ``$item->propname`` instead, you will always get an empty object which will evaluate to ``TRUE``, so
your check will fail.

For further information, the official *RSS* 2.0 specification is available at:
`http://blogs.law.harvard.edu/tech/rss`_



.. _`http://blogs.law.harvard.edu/tech/rss`: http://blogs.law.harvard.edu/tech/rss
