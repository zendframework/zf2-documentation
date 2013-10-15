.. _zendservice.delicious:

ZendService\\Delicious
======================

.. _zendservice.delicious.introduction:

Introduction
------------

``ZendService\Delicious\Delicious`` is simple *API* for using `del.icio.us`_ *XML* and *JSON* web services. This component
gives you read-write access to posts at del.icio.us if you provide credentials. It also allows read-only access to
public data of all users.

.. _zendservice.delicious.introduction.getAllPosts:

.. rubric:: Get all posts

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('username', 'password');
   $posts = $delicious->getAllPosts();

   foreach ($posts as $post) {
       echo "--\n";
       echo "Title: {$post->getTitle()}\n";
       echo "Url: {$post->getUrl()}\n";
   }

.. _zendservice.delicious.retrieving_posts:

Retrieving posts
----------------

``ZendService\Delicious\Delicious`` provides three methods for retrieving posts: ``getPosts()``, ``getRecentPosts()`` and
``getAllPosts()``. All of these methods return an instance of ``ZendService\Delicious\PostList``, which holds all
retrieved posts.

.. code-block:: php
   :linenos:

   /**
    * Get posts matching the arguments. If no date or url is given,
    * most recent date will be used.
    *
    * @param string $tag Optional filtering by tag
    * @param DateTime $dt Optional filtering by date
    * @param string $url Optional filtering by url
    * @return ZendService\Delicious\PostList
    */
   public function getPosts($tag = null, $dt = null, $url = null);

   /**
    * Get recent posts
    *
    * @param string $tag   Optional filtering by tag
    * @param string $count Maximal number of posts to be returned
    *                      (default 15)
    * @return ZendService\Delicious\PostList
    */
   public function getRecentPosts($tag = null, $count = 15);

   /**
    * Get all posts
    *
    * @param string $tag Optional filtering by tag
    * @return ZendService\Delicious\PostList
    */
   public function getAllPosts($tag = null);

.. _zendservice.delicious.postlist:

ZendService\\Delicious\\PostList
--------------------------------

Instances of this class are returned by the ``getPosts()``, ``getAllPosts()``, ``getRecentPosts()``, and
``getUserPosts()`` methods of ``ZendService\Delicious\Delicious``.

For easier data access this class implements the *Countable*, *Iterator*, and *ArrayAccess* interfaces.

.. _zendservice.delicious.postlist.accessing_post_lists:

.. rubric:: Accessing post lists

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('username', 'password');
   $posts = $delicious->getAllPosts();

   // count posts
   echo count($posts);

   // iterate over posts
   foreach ($posts as $post) {
       echo "--\n";
       echo "Title: {$post->getTitle()}\n";
       echo "Url: {$post->getUrl()}\n";
   }

   // get post using array access
   echo $posts[0]->getTitle();

.. note::

   The ``ArrayAccess::offsetSet()`` and ``ArrayAccess::offsetUnset()`` methods throw exceptions in this
   implementation. Thus, code like *unset($posts[0]);* and *$posts[0] = 'A';* will throw exceptions because these
   properties are read-only.

Post list objects have two built-in filtering capabilities. Post lists may be filtered by tags and by *URL*.

.. _zendservice.delicious.postlist.example.withTags:

.. rubric:: Filtering a Post List with Specific Tags

Posts may be filtered by specific tags using ``withTags()``. As a convenience, ``withTag()`` is also provided for
when only a single tag needs to be specified.

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('username', 'password');
   $posts = $delicious->getAllPosts();

   // Print posts having "php" and "zend" tags
   foreach ($posts->withTags(array('php', 'zend')) as $post) {
       echo "Title: {$post->getTitle()}\n";
       echo "Url: {$post->getUrl()}\n";
   }

.. _zendservice.delicious.postlist.example.byUrl:

.. rubric:: Filtering a Post List by URL

Posts may be filtered by *URL* matching a specified regular expression using the ``withUrl()`` method:

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('username', 'password');
   $posts = $delicious->getAllPosts();

   // Print posts having "help" in the URL
   foreach ($posts->withUrl('/help/') as $post) {
       echo "Title: {$post->getTitle()}\n";
       echo "Url: {$post->getUrl()}\n";
   }

.. _zendservice.delicious.editing_posts:

Editing posts
-------------

.. _zendservice.delicious.editing_posts.post_editing:

.. rubric:: Post editing

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('username', 'password');
   $posts = $delicious->getPosts();

   // set title
   $posts[0]->setTitle('New title');
   // save changes
   $posts[0]->save();

.. _zendservice.delicious.editing_posts.method_call_chaining:

.. rubric:: Method call chaining

Every setter method returns the post object so that you can chain method calls using a fluent interface.

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('username', 'password');
   $posts = $delicious->getPosts();

   $posts[0]->setTitle('New title')
            ->setNotes('New notes')
            ->save();

.. _zendservice.delicious.deleting_posts:

Deleting posts
--------------

There are two ways to delete a post, by specifying the post *URL* or by calling the ``delete()`` method upon a post
object.

.. _zendservice.delicious.deleting_posts.deleting_posts:

.. rubric:: Deleting posts

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('username', 'password');

   // by specifying URL
   $delicious->deletePost('http://framework.zend.com');

   // or by calling the method upon a post object
   $posts = $delicious->getPosts();
   $posts[0]->delete();

   // another way of using deletePost()
   $delicious->deletePost($posts[0]->getUrl());

.. _zendservice.delicious.adding_posts:

Adding new posts
----------------

To add a post you first need to call the ``createNewPost()`` method, which returns a
``ZendService\Delicious\Post`` object. When you edit the post, you need to save it to the del.icio.us database by
calling the ``save()`` method.

.. _zendservice.delicious.adding_posts.adding_a_post:

.. rubric:: Adding a post

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('username', 'password');

   // create a new post and save it (with method call chaining)
   $delicious->createNewPost('Zend Framework', 'http://framework.zend.com')
             ->setNotes('Zend Framework Homepage')
             ->save();

   // create a new post and save it  (without method call chaining)
   $newPost = $delicious->createNewPost('Zend Framework',
                                        'http://framework.zend.com');
   $newPost->setNotes('Zend Framework Homepage');
   $newPost->save();

.. _zendservice.delicious.tags:

Tags
----

.. _zendservice.delicious.tags.tags:

.. rubric:: Tags

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('username', 'password');

   // get all tags
   print_r($delicious->getTags());

   // rename tag ZF to zendFramework
   $delicious->renameTag('ZF', 'zendFramework');

.. _zendservice.delicious.bundles:

Bundles
-------

.. _zendservice.delicious.bundles.example:

.. rubric:: Bundles

.. code-block:: php
   :linenos:

   $delicious = new ZendService\Delicious\Delicious('username', 'password');

   // get all bundles
   print_r($delicious->getBundles());

   // delete bundle someBundle
   $delicious->deleteBundle('someBundle');

   // add bundle
   $delicious->addBundle('newBundle', array('tag1', 'tag2'));

.. _zendservice.delicious.public_data:

Public data
-----------

The del.icio.us web *API* allows access to the public data of all users.

.. _zendservice.delicious.public_data.functions_for_retrieving_public_data:

.. table:: Methods for retrieving public data

   +----------------+---------------------------+-------------------------------+
   |Name            |Description                |Return type                    |
   +================+===========================+===============================+
   |getUserFans()   |Retrieves fans of a user   |Array                          |
   +----------------+---------------------------+-------------------------------+
   |getUserNetwork()|Retrieves network of a user|Array                          |
   +----------------+---------------------------+-------------------------------+
   |getUserPosts()  |Retrieves posts of a user  |ZendService\Delicious\PostList |
   +----------------+---------------------------+-------------------------------+
   |getUserTags()   |Retrieves tags of a user   |Array                          |
   +----------------+---------------------------+-------------------------------+

.. note::

   When using only these methods, a username and password combination is not required when constructing a new
   ``ZendService\Delicious\Delicious`` object.

.. _zendservice.delicious.public_data.retrieving_public_data:

.. rubric:: Retrieving public data

.. code-block:: php
   :linenos:

   // username and password are not required
   $delicious = new ZendService\Delicious\Delicious();

   // get fans of user someUser
   print_r($delicious->getUserFans('someUser'));

   // get network of user someUser
   print_r($delicious->getUserNetwork('someUser'));

   // get tags of user someUser
   print_r($delicious->getUserTags('someUser'));

.. _zendservice.delicious.public_data.posts:

Public posts
^^^^^^^^^^^^

When retrieving public posts with the ``getUserPosts()`` method, a ``ZendService\Delicious\PostList`` object is
returned, and it contains ``ZendService\Delicious\SimplePost`` objects, which contain basic information about the
posts, including *URL*, title, notes, and tags.

.. _zendservice.delicious.public_data.posts.SimplePost_methods:

.. table:: Methods of the ZendService\Delicious\SimplePost class

   +----------+-----------------------+-----------+
   |Name      |Description            |Return type|
   +==========+=======================+===========+
   |getNotes()|Returns notes of a post|String     |
   +----------+-----------------------+-----------+
   |getTags() |Returns tags of a post |Array      |
   +----------+-----------------------+-----------+
   |getTitle()|Returns title of a post|String     |
   +----------+-----------------------+-----------+
   |getUrl()  |Returns URL of a post  |String     |
   +----------+-----------------------+-----------+

.. _zendservice.delicious.httpclient:

HTTP client
-----------

``ZendService\Delicious\Delicious`` uses ``Zend\Rest\Client`` for making *HTTP* requests to the del.icio.us web service. To
change which *HTTP* client ``ZendService\Delicious\Delicious`` uses, you need to change the *HTTP* client of
``Zend\Rest\Client``.

.. _zendservice.delicious.httpclient.changing:

.. rubric:: Changing the HTTP client of Zend\Rest\Client

.. code-block:: php
   :linenos:

   $myHttpClient = new My_Http_Client();
   Zend\Rest\Client::setHttpClient($myHttpClient);

When you are making more than one request with ``ZendService\Delicious\Delicious`` to speed your requests, it's better to
configure your *HTTP* client to keep connections alive.

.. _zendservice.delicious.httpclient.keepalive:

.. rubric:: Configuring your HTTP client to keep connections alive

.. code-block:: php
   :linenos:

   Zend\Rest\Client::getHttpClient()->setConfig(array(
           'keepalive' => true
   ));

.. note::

   When a ``ZendService\Delicious\Delicious`` object is constructed, the *SSL* transport of ``Zend\Rest\Client`` is set to
   *'ssl'* rather than the default of *'ssl2'*. This is because del.icio.us has some problems with *'ssl2'*, such
   as requests taking a long time to complete (around 2 seconds).



.. _`del.icio.us`: http://del.icio.us