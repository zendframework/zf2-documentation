.. _zendservice.slideshare:

ZendService\\SlideShare
=======================

The ``ZendService\SlideShare\SlideShare`` component is used to interact with the `slideshare.net`_ web services for hosting
slide shows online. With this component, you can embed slide shows which are hosted on this web site within a web
site and even upload new slide shows to your account.

.. _zendservice.slideshare.basicusage:

Getting Started with ZendService\\SlideShare
--------------------------------------------

In order to use the ``ZendService\SlideShare\SlideShare`` component you must first create an account on the slideshare.net
servers (more information can be found `here`_) in order to receive an *API* key, username, password and shared
secret value -- all of which are needed in order to use the ``ZendService\SlideShare\SlideShare`` component.

Once you have setup an account, you can begin using the ``ZendService\SlideShare\SlideShare`` component by creating a new
instance of the ``ZendService\SlideShare\SlideShare`` object and providing these values as shown below:

.. code-block:: php
   :linenos:

   // Create a new instance of the component
   $ss = new ZendService\SlideShare\SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');

.. _zendservice.slideshare.slideshowobj:

The SlideShow object
--------------------

All slide shows in the ``ZendService\SlideShare\SlideShare`` component are represented using the
``ZendService\SlideShare\SlideShow`` object (both when retrieving and uploading new slide shows). For your
reference a pseudo-code version of this class is provided below.

.. code-block:: php
   :linenos:

   class ZendService\SlideShare\SlideShow {

       /**
        * Retrieves the location of the slide show
        */
       public function getLocation() {
           return $this->_location;
       }

       /**
        * Gets the transcript for this slide show
        */
       public function getTranscript() {
           return $this->_transcript;
       }

       /**
        * Adds a tag to the slide show
        */
       public function addTag($tag) {
           $this->_tags[] = (string) $tag;
           return $this;
       }

       /**
        * Sets the tags for the slide show
        */
       public function setTags(Array $tags) {
           $this->_tags = $tags;
           return $this;
       }

       /**
        * Gets all of the tags associated with the slide show
        */
       public function getTags() {
           return $this->_tags;
       }

       /**
        * Sets the filename on the local filesystem of the slide show
        * (for uploading a new slide show)
        */
       public function setFilename($file) {
           $this->_slideShowFilename = (string) $file;
           return $this;
       }

       /**
        * Retrieves the filename on the local filesystem of the slide show
        * which will be uploaded
        */
       public function getFilename() {
           return $this->_slideShowFilename;
       }

       /**
        * Gets the ID for the slide show
        */
       public function getId() {
           return $this->_slideShowId;
       }

       /**
        * Retrieves the HTML embed code for the slide show
        */
       public function getEmbedCode() {
           return $this->_embedCode;
       }

       /**
        * Retrieves the Thumbnail URi for the slide show
        */
       public function getThumbnailUrl() {
           return $this->_thumbnailUrl;
       }

       /**
        * Sets the title for the Slide show
        */
       public function setTitle($title) {
           $this->_title = (string) $title;
           return $this;
       }

       /**
        * Retrieves the Slide show title
        */
       public function getTitle() {
           return $this->_title;
       }

       /**
        * Sets the description for the Slide show
        */
       public function setDescription($desc) {
           $this->_description = (string) $desc;
           return $this;
       }

       /**
        * Gets the description of the slide show
        */
       public function getDescription() {
           return $this->_description;
       }

       /**
        * Gets the numeric status of the slide show on the server
        */
       public function getStatus() {
           return $this->_status;
       }

       /**
        * Gets the textual description of the status of the slide show on
        * the server
        */
       public function getStatusDescription() {
           return $this->_statusDescription;
       }

       /**
        * Gets the permanent link of the slide show
        */
       public function getPermaLink() {
           return $this->_permalink;
       }

       /**
        * Gets the number of views the slide show has received
        */
       public function getNumViews() {
           return $this->_numViews;
       }
   }

.. note::

   The above pseudo-class only shows those methods which should be used by end-user developers. Other available
   methods are internal to the component.

When using the ``ZendService\SlideShare\SlideShare`` component, this data class will be used frequently to browse or add new
slide shows to or from the web service.

.. _zendservice.slideshare.getslideshow:

Retrieving a single slide show
------------------------------

The simplest usage of the ``ZendService\SlideShare\SlideShare`` component is the retrieval of a single slide show by slide
show ID provided by the slideshare.net application and is done by calling the ``getSlideShow()`` method of a
``ZendService\SlideShare\SlideShare`` object and using the resulting ``ZendService\SlideShare\SlideShow`` object as shown.

.. code-block:: php
   :linenos:

   // Create a new instance of the component
   $ss = new ZendService\SlideShare\SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');

   $slideshow = $ss->getSlideShow(123456);

   print "Slide Show Title: {$slideshow->getTitle()}<br/>\n";
   print "Number of views: {$slideshow->getNumViews()}<br/>\n";

.. _zendservice.slideshare.getslideshowlist:

Retrieving Groups of Slide Shows
--------------------------------

If you do not know the specific ID of a slide show you are interested in retrieving, you can retrieving groups of
slide shows by using one of three methods:

- **Slide shows from a specific account**

  You can retrieve slide shows from a specific account by using the ``getSlideShowsByUsername()`` method and
  providing the username from which the slide shows should be retrieved

- **Slide shows which contain specific tags**

  You can retrieve slide shows which contain one or more specific tags by using the ``getSlideShowsByTag()`` method
  and providing one or more tags which the slide show must have assigned to it in order to be retrieved

- **Slide shows by group**

  You can retrieve slide shows which are a member of a specific group using the ``getSlideShowsByGroup()`` method
  and providing the name of the group which the slide show must belong to in order to be retrieved

Each of the above methods of retrieving multiple slide shows a similar approach is used. An example of using each
method is shown below:

.. code-block:: php
   :linenos:

   // Create a new instance of the component
   $ss = new ZendService\SlideShare\SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');

   $starting_offset = 0;
   $limit = 10;

   // Retrieve the first 10 of each type
   $ss_user = $ss->getSlideShowsByUser('username', $starting_offset, $limit);
   $ss_tags = $ss->getSlideShowsByTag('zend', $starting_offset, $limit);
   $ss_group = $ss->getSlideShowsByGroup('mygroup', $starting_offset, $limit);

   // Iterate over the slide shows
   foreach ($ss_user as $slideshow) {
      print "Slide Show Title: {$slideshow->getTitle}<br/>\n";
   }

.. _zendservice.slideshare.caching:

ZendService\\SlideShare Caching policies
----------------------------------------

By default, ``ZendService\SlideShare\SlideShare`` will cache any request against the web service automatically to the
filesystem (default path ``/tmp``) for 12 hours. If you desire to change this behavior, you must provide your own
:ref:`Zend\Cache\Cache <zend.cache>` object using the ``setCacheObject()`` method as shown:

.. code-block:: php
   :linenos:

   $frontendOptions = array(
                           'lifetime' => 7200,
                           'automatic_serialization' => true);
   $backendOptions  = array(
                           'cache_dir' => '/webtmp/');

   $cache = Zend\Cache\Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   $ss = new ZendService\SlideShare\SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');
   $ss->setCacheObject($cache);

   $ss_user = $ss->getSlideShowsByUser('username', $starting_offset, $limit);

.. _zendservice.slideshare.httpclient:

Changing the behavior of the HTTP Client
----------------------------------------

If for whatever reason you would like to change the behavior of the *HTTP* client when making the web service
request, you can do so by creating your own instance of the ``Zend\Http\Client`` object (see :ref:`Zend\Http
<zend.http>`). This is useful for instance when it is desirable to set the timeout for the connection to something
other then default as shown:

.. code-block:: php
   :linenos:

   $client = new Zend\Http\Client();
   $client->setConfig(array('timeout' => 5));

   $ss = new ZendService\SlideShare\SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');
   $ss->setHttpClient($client);
   $ss_user = $ss->getSlideShowsByUser('username', $starting_offset, $limit);



.. _`slideshare.net`: http://www.slideshare.net/
.. _`here`: http://www.slideshare.net/developers/
