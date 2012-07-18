.. _zend.feed.importing:

Importing Feeds
===============

``Zend_Feed`` enables developers to retrieve feeds very easily. If you know the *URI* of a feed, simply use the ``Zend_Feed::import()`` method:

.. code-block:: php
   :linenos:

   $feed = Zend_Feed::import('http://feeds.example.com/feedName');

You can also use ``Zend_Feed`` to fetch the contents of a feed from a file or the contents of a *PHP* string variable:

.. code-block:: php
   :linenos:

   // importing a feed from a text file
   $feedFromFile = Zend_Feed::importFile('feed.xml');

   // importing a feed from a PHP string variable
   $feedFromPHP = Zend_Feed::importString($feedString);

In each of the examples above, an object of a class that extends ``Zend_Feed_Abstract`` is returned upon success, depending on the type of the feed. If an *RSS* feed were retrieved via one of the import methods above, then a ``Zend_Feed_Rss`` object would be returned. On the other hand, if an Atom feed were imported, then a ``Zend_Feed_Atom`` object is returned. The import methods will also throw a ``Zend_Feed_Exception`` object upon failure, such as an unreadable or malformed feed.

.. _zend.feed.importing.custom:

Custom feeds
------------

``Zend_Feed`` enables developers to create custom feeds very easily. You just have to create an array and to import it with ``Zend_Feed``. This array can be imported with ``Zend_Feed::importArray()`` or with ``Zend_Feed::importBuilder()``. In this last case the array will be computed on the fly by a custom data source implementing ``Zend_Feed_Builder_Interface``.

.. _zend.feed.importing.custom.importarray:

Importing a custom array
^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // importing a feed from an array
   $atomFeedFromArray = Zend_Feed::importArray($array);

   // the following line is equivalent to the above;
   // by default a Zend_Feed_Atom instance is returned
   $atomFeedFromArray = Zend_Feed::importArray($array, 'atom');

   // importing a rss feed from an array
   $rssFeedFromArray = Zend_Feed::importArray($array, 'rss');

The format of the array must conform to this structure:

.. code-block:: php
   :linenos:

   array(
       //required
       'title' => 'title of the feed',
       'link'  => 'canonical url to the feed',

       // optional
       'lastUpdate' => 'timestamp of the update date',
       'published'  => 'timestamp of the publication date',

       // required
       'charset' => 'charset of the textual data',

       // optional
       'description' => 'short description of the feed',
       'author'      => 'author/publisher of the feed',
       'email'       => 'email of the author',

       // optional, ignored if atom is used
       'webmaster' => 'email address for person responsible '
                   .  'for technical issues',

       // optional
       'copyright' => 'copyright notice',
       'image'     => 'url to image',
       'generator' => 'generator',
       'language'  => 'language the feed is written in',

       // optional, ignored if atom is used
       'ttl'    => 'how long in minutes a feed can be cached '
                .  'before refreshing',
       'rating' => 'The PICS rating for the channel.',

       // optional, ignored if atom is used
       // a cloud to be notified of updates
       'cloud'       => array(
           // required
           'domain' => 'domain of the cloud, e.g. rpc.sys.com',

           // optional, defaults to 80
           'port' => 'port to connect to',

           // required
           'path'              => 'path of the cloud, e.g. /RPC2',
           'registerProcedure' => 'procedure to call, e.g. myCloud.rssPlsNotify',
           'protocol'          => 'protocol to use, e.g. soap or xml-rpc'
       ),

       // optional, ignored if atom is used
       // a text input box that can be displayed with the feed
       'textInput'   => array(
           // required
           'title'       => 'label of the Submit button in the text input area',
           'description' => 'explains the text input area',
           'name'        => 'the name of the text object in the text input area',
           'link'        => 'URL of the CGI script processing text input requests'
       ),

       // optional, ignored if atom is used
       // Hint telling aggregators which hours they can skip
       'skipHours' => array(
           // up to 24 rows whose value is a number between 0 and 23
           // e.g 13 (1pm)
           'hour in 24 format'
       ),

       // optional, ignored if atom is used
       // Hint telling aggregators which days they can skip
       'skipDays ' => array(
           // up to 7 rows whose value is
           // Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday
           // e.g Monday
           'a day to skip'
       ),

       // optional, ignored if atom is used
       // Itunes extension data
       'itunes' => array(
           // optional, default to the main author value
           'author' => 'Artist column',

           // optional, default to the main author value
           // Owner of the podcast
           'owner' => array(
               'name'  => 'name of the owner',
               'email' => 'email of the owner'
           ),

           // optional, default to the main image value
           'image' => 'album/podcast art',

           // optional, default to the main description value
           'subtitle' => 'short description',
           'summary'  => 'longer description',

           // optional
           'block' => 'Prevent an episode from appearing (yes|no)',

           // required, Category column and in iTunes Music Store Browse
           'category' => array(
               // up to 3 rows
               array(
                   // required
                   'main' => 'main category',

                   // optional
                   'sub'  => 'sub category'
               )
           ),

           // optional
           'explicit'     => 'parental advisory graphic (yes|no|clean)',
           'keywords'     => 'a comma separated list of 12 keywords maximum',
           'new-feed-url' => 'used to inform iTunes of new feed URL location'
       ),

       'entries' => array(
           array(
               //required
               'title' => 'title of the feed entry',
               'link'  => 'url to a feed entry',

               // required, only text, no html
               'description' => 'short version of a feed entry',

               // optional
               'guid' => 'id of the article, '
                      .  'if not given link value will used',

               // optional, can contain html
               'content' => 'long version',

               // optional
               'lastUpdate' => 'timestamp of the publication date',
               'comments'   => 'comments page of the feed entry',
               'commentRss' => 'the feed url of the associated comments',

               // optional, original source of the feed entry
               'source' => array(
                   // required
                   'title' => 'title of the original source',
                   'url'   => 'url of the original source'
               ),

               // optional, list of the attached categories
               'category' => array(
                   array(
                       // required
                       'term' => 'first category label',

                       // optional
                       'scheme' => 'url that identifies a categorization scheme'
                   ),

                   array(
                       // data for the second category and so on
                   )
               ),

               // optional, list of the enclosures of the feed entry
               'enclosure'    => array(
                   array(
                       // required
                       'url' => 'url of the linked enclosure',

                       // optional
                       'type' => 'mime type of the enclosure',
                       'length' => 'length of the linked content in octets'
                   ),

                   array(
                       //data for the second enclosure and so on
                   )
               )
           ),

           array(
               //data for the second entry and so on
           )
       )
   );

References:

- *RSS* 2.0 specification: `RSS 2.0`_

- Atom specification: `RFC 4287`_

- *WFW* specification: `Well Formed Web`_

- iTunes specification: `iTunes Technical Specifications`_

.. _zend.feed.importing.custom.importbuilder:

Importing a custom data source
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can create a ``Zeed_Feed`` instance from any data source implementing ``Zend_Feed_Builder_Interface``. You just have to implement the ``getHeader()`` and ``getEntries()`` methods to be able to use your object with ``Zend_Feed::importBuilder()``. As a simple reference implementation, you can use ``Zend_Feed_Builder``, which takes an array in its constructor, performs some minor validation, and then can be used in the ``importBuilder()`` method. The ``getHeader()`` method must return an instance of ``Zend_Feed_Builder_Header``, and ``getEntries()`` must return an array of ``Zend_Feed_Builder_Entry`` instances.

.. note::

   ``Zend_Feed_Builder`` serves as a concrete implementation to demonstrate the usage. Users are encouraged to make their own classes to implement ``Zend_Feed_Builder_Interface``.

Here is an example of ``Zend_Feed::importBuilder()`` usage:

.. code-block:: php
   :linenos:

   // importing a feed from a custom builder source
   $atomFeedFromArray =
       Zend_Feed::importBuilder(new Zend_Feed_Builder($array));

   // the following line is equivalent to the above;
   // by default a Zend_Feed_Atom instance is returned
   $atomFeedFromArray =
       Zend_Feed::importBuilder(new Zend_Feed_Builder($array), 'atom');

   // importing a rss feed from a custom builder array
   $rssFeedFromArray =
       Zend_Feed::importBuilder(new Zend_Feed_Builder($array), 'rss');

.. _zend.feed.importing.custom.dump:

Dumping the contents of a feed
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To dump the contents of a ``Zend_Feed_Abstract`` instance, you may use ``send()`` or ``saveXml()`` methods.

.. code-block:: php
   :linenos:

   assert($feed instanceof Zend_Feed_Abstract);

   // dump the feed to standard output
   print $feed->saveXML();

   // send http headers and dump the feed
   $feed->send();



.. _`RSS 2.0`: http://blogs.law.harvard.edu/tech/rss
.. _`RFC 4287`: http://tools.ietf.org/html/rfc4287
.. _`Well Formed Web`: http://wellformedweb.org/news/wfw_namespace_elements
.. _`iTunes Technical Specifications`: http://www.apple.com/itunes/store/podcaststechspecs.html
