.. EN-Revision: none
.. _zend.feed.importing:

导入Feeds
=======

*Zend_Feed* 能让开发者轻松获得 Feeds 。如果你知道 Feeds 的URI，用 *Zend\Feed\Feed::import()*\
方法就可以非常容易的获得它:

.. code-block:: php
   :linenos:

   <?php
   $feed = Zend\Feed\Feed::import('http://feeds.example.com/feedName');

你也能用 *Zend_Feed*\ 从一个文件或者一个PHP字符串变量来获得一个feed的内容:

.. code-block:: php
   :linenos:

   <?php
   // importing a feed from a text file
   $feedFromFile = Zend\Feed\Feed::importFile('feed.xml');

   // importing a feed from a PHP string variable
   $feedFromPHP = Zend\Feed\Feed::importString($feedString);

在上面的例子中，根据feed类型的不同，一个从 *Zend\Feed\Abstract*\
继承而来的类对象被返回。如果导入方法获得的是一个RSS feed，那么一个 *Zend\Feed\Rss*\
对象将被返回(Seateng译注:以Factory模式实现)。另一方面，如果一个Atom
feed被导入，那么将返回一个 *Zend\Feed\Atom*\
对象。如果feed不可读或者不符合规范，导致导入失败那么Zend_Feed将抛出一个
*Zend\Feed\Exception*\ 异常。

.. _zend.feed.importing.custom:

定制 feeds
--------

*Zend_Feed* 能让开发者轻松创建定制 feeds，只需要创建一个数组用 Zend_Feed
导入它。这个数组可以用 *Zend\Feed\Feed::importArray()* 或 *Zend\Feed\Feed::importBuilder()*
导入。最后数组用定制的实现了 *Zend\Feed_Builder\Interface* 数据源来处理。

.. _zend.feed.importing.custom.importarray:

导入定制的数组
^^^^^^^

.. code-block:: php
   :linenos:

   <?php
   // 从数组导入 feed
   $atomFeedFromArray = Zend\Feed\Feed::importArray($array);

   // 下面一行和上面相同；缺省地 Zend\Feed\Atom 实例被返回
   $atomFeedFromArray = Zend\Feed\Feed::importArray($array, 'atom');

   // 从数组导入 rss feed
   $rssFeedFromArray = Zend\Feed\Feed::importArray($array, 'rss');

数组格式必须和这个结构一致：

.. code-block:: php
   :linenos:

   <?php
   array(
         'title'       => 'title of the feed', //required
         'link'        => 'canonical url to the feed', //required
         'lastUpdate'  => 'timestamp of the update date', // optional
         'published'   => 'timestamp of the publication date', //optional
         'charset'     => 'charset of the textual data', // required
         'description' => 'short description of the feed', //optional
         'author'      => 'author/publisher of the feed', //optional
         'email'       => 'email of the author', //optional
         'webmaster'   => 'email address for person responsible for technical issues' // optional, ignored if atom is used
         'copyright'   => 'copyright notice', //optional
         'image'       => 'url to image', //optional
         'generator'   => 'generator', // optional
         'language'    => 'language the feed is written in', // optional
         'ttl'         => 'how long in minutes a feed can be cached before refreshing', // optional, ignored if atom is used
         'rating'      => 'The PICS rating for the channel.', // optional, ignored if atom is used
         'cloud'       => array(
                                'domain'            => 'domain of the cloud, e.g. rpc.sys.com' // required
                                'port'              => 'port to connect to' // optional, default to 80
                                'path'              => 'path of the cloud, e.g. /RPC2' //required
                                'registerProcedure' => 'procedure to call, e.g. myCloud.rssPleaseNotify' // required
                                'protocol'          => 'protocol to use, e.g. soap or xml-rpc' // required
                                ), // a cloud to be notified of updates // optional, ignored if atom is used
         'textInput'   => array(
                                'title'       => 'the label of the Submit button in the text input area' // required,
                                'description' => 'explains the text input area' // required
                                'name'        => 'the name of the text object in the text input area' // required
                                'link'        => 'the URL of the CGI script that processes text input requests' // required
                                ) // a text input box that can be displayed with the feed // optional, ignored if atom is used
         'skipHours'   => array(
                                'hour in 24 format', // e.g 13 (1pm)
                                // up to 24 rows whose value is a number between 0 and 23
                                ) // Hint telling aggregators which hours they can skip // optional, ignored if atom is used
         'skipDays '   => array(
                                'a day to skip', // e.g Monday
                                // up to 7 rows whose value is a Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday
                                ) // Hint telling aggregators which days they can skip // optional, ignored if atom is used
         'itunes'      => array(
                                'author'       => 'Artist column' // optional, default to the main author value
                                'owner'        => array(
                                                        'name' => 'name of the owner' // optional, default to main author value
                                                        'email' => 'email of the owner' // optional, default to main email value
                                                        ) // Owner of the podcast // optional
                                'image'        => 'album/podcast art' // optional, default to the main image value
                                'subtitle'     => 'short description' // optional, default to the main description value
                                'summary'      => 'longer description' // optional, default to the main description value
                                'block'        => 'Prevent an episode from appearing (yes|no)' // optional
                                'category'     => array(
                                                        array('main' => 'main category', // required
                                                              'sub'  => 'sub category' // optional
                                                              ),
                                                        // up to 3 rows
                                                        ) // 'Category column and in iTunes Music Store Browse' // required
                                'explicit'     => 'parental advisory graphic (yes|no|clean)' // optional
                                'keywords'     => 'a comma separated list of 12 keywords maximum' // optional
                                'new-feed-url' => 'used to inform iTunes of new feed URL location' // optional
                                ) // Itunes extension data // optional, ignored if atom is used
         'entries'     => array(
                                array(
                                      'title'        => 'title of the feed entry', //required
                                      'link'         => 'url to a feed entry', //required
                                      'description'  => 'short version of a feed entry', // only text, no html, required
                                      'guid'         => 'id of the article, if not given link value will used', //optional
                                      'content'      => 'long version', // can contain html, optional
                                      'lastUpdate'   => 'timestamp of the publication date', // optional
                                      'comments'     => 'comments page of the feed entry', // optional
                                      'commentRss'   => 'the feed url of the associated comments', // optional
                                      'source'       => array(
                                                              'title' => 'title of the original source' // required,
                                                              'url' => 'url of the original source' // required
                                                              ) // original source of the feed entry // optional
                                      'category'     => array(
                                                              array(
                                                                    'term' => 'first category label' // required,
                                                                    'scheme' => 'url that identifies a categorization scheme' // optional
                                                                    ),
                                                              array(
                                                                    //data for the second category and so on
                                                                    )
                                                              ) // list of the attached categories // optional
                                      'enclosure'    => array(
                                                              array(
                                                                    'url' => 'url of the linked enclosure' // required
                                                                    'type' => 'mime type of the enclosure' // optional
                                                                    'length' => 'length of the linked content in octets' // optional
                                                                    ),
                                                              array(
                                                                    //data for the second enclosure and so on
                                                                    )
                                                              ) // list of the enclosures of the feed entry // optional
                                      ),
                                array(
                                      //data for the second entry and so on
                                      )
                                )
          );

References:

   - RSS 2.0 规范： `RSS 2.0`_

   - Atom 规范： `RFC 4287`_

   - WFW 规范： `Well Formed Web`_

   - iTunes 规范： `iTunes Technical Specifications`_



.. _zend.feed.importing.custom.importbuilder:

导入定制的数据源
^^^^^^^^

你可以从任何实现 *Zend\Feed_Builder\Interface* 的数据源创建 Zeed_Feed 实例，只需要实现
*getHeader()* 和 *getEntries()* 方法来和 *Zend\Feed\Feed::importBuilder()*
一起使用你的对象。作为一个简单的参考实现，你可以使用 *Zend\Feed\Builder*
它在构造器里带有一个数组，执行一些校验，然后可以在 *importBuilder()* 方法中使用。
*getHeader()* 方法必须返回 *Zend\Feed_Builder\Header* 的实例， *getEntries()* 必须返回
*Zend\Feed_Builder\Entry* 实例的数组。

.. note::

   *Zend\Feed\Builder* 作为具体实现来实现它的用法，（我们）鼓励用户写自己的类来实现
   *Zend\Feed_Builder\Interface*\ 。

*Zend\Feed\Feed::importBuilder()* 用法的例子：

.. code-block:: php
   :linenos:

   <?php
   // 从定制的 builder 源导入 feed
   $atomFeedFromArray = Zend\Feed\Feed::importBuilder(new Zend\Feed\Builder($array));

   // 和上面一样，缺省地 Zend\Feed\Atom 实例被返回
   $atomFeedFromArray = Zend\Feed\Feed::importArray(new Zend\Feed\Builder($array), 'atom');

   // 从定制的 builder 数组导入 rss feed
   $rssFeedFromArray = Zend\Feed\Feed::importArray(new Zend\Feed\Builder($array), 'rss');

.. _zend.feed.importing.custom.dump:

Dumping feed 内容
^^^^^^^^^^^^^^^

为了 dump *Zend\Feed\Abstract* 实例的内容，使用 *send()* 或 *saveXml()* 方法。

.. code-block:: php
   :linenos:

   <?php
   assert($feed instanceof Zend\Feed\Abstract);

   // dump feed 到标准输出
   print $feed->saveXML();

   // 发送 http 头和 dump the feed
   $feed->send();



.. _`RSS 2.0`: http://blogs.law.harvard.edu/tech/rss
.. _`RFC 4287`: http://tools.ietf.org/html/rfc4287
.. _`Well Formed Web`: http://wellformedweb.org/news/wfw_namespace_elements
.. _`iTunes Technical Specifications`: http://www.apple.com/itunes/store/podcaststechspecs.html
