.. _zendgdata.youtube:

Using the YouTube Data API
==========================

The YouTube Data *API* offers read and write access to YouTube's content. Users can perform unauthenticated
requests to Google Data feeds to retrieve feeds of popular videos, comments, public information about YouTube user
profiles, user playlists, favorites, subscriptions and so on.

For more information on the YouTube Data *API*, please refer to the official `PHP Developer's Guide`_ on
code.google.com.

.. _zendgdata.youtube.authentication:

Authentication
--------------

The YouTube Data *API* allows read-only access to public data, which does not require authentication. For any write
requests, a user needs to authenticate either using ClientLogin or AuthSub authentication. Please refer to the
`Authentication section in the PHP Developer's Guide`_ for more detail.

.. _zendgdata.youtube.developer_key:

Developer Keys and Client ID
----------------------------

A developer key identifies the YouTube developer that is submitting an *API* request. A client ID identifies your
application for logging and debugging purposes. Please visit http://code.google.com/apis/youtube/dashboard/ to
obtain a developer key and client ID. The example below demonstrates how to pass the developer key and client ID to
the `ZendGData\YouTube`_ service object.

.. _zendgdata.youtube.developer_key.example:

.. rubric:: Passing a Developer Key and ClientID to ZendGData\YouTube

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube($httpClient,
                                $applicationId,
                                $clientId,
                                $developerKey);

.. _zendgdata.youtube.videos:

Retrieving public video feeds
-----------------------------

The YouTube Data *API* provides numerous feeds that return a list of videos, such as standard feeds, related
videos, video responses, user's uploads, and user's favorites. For example, the user's uploads feed returns all
videos uploaded by a specific user. See the `YouTube API reference guide`_ for a detailed list of available feeds.

.. _zendgdata.youtube.videos.searching:

Searching for videos by metadata
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can retrieve a list of videos that match specified search criteria, using the YouTubeQuery class. The following
query looks for videos which contain the word "cat" in their metadata, starting with the 10th video and displaying
20 videos per page, ordered by the view count.

.. _zendgdata.youtube.videos.searching.example:

.. rubric:: Searching for videos

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $query = $yt->newVideoQuery();
   $query->videoQuery = 'cat';
   $query->startIndex = 10;
   $query->maxResults = 20;
   $query->orderBy = 'viewCount';

   echo $query->queryUrl . "\n";
   $videoFeed = $yt->getVideoFeed($query);

   foreach ($videoFeed as $videoEntry) {
       echo "---------VIDEO----------\n";
       echo "Title: " . $videoEntry->getVideoTitle() . "\n";
       echo "\nDescription:\n";
       echo $videoEntry->getVideoDescription();
       echo "\n\n\n";
   }

For more details on the different query parameters, please refer to the `Reference Guide`_. The available helper
functions in `ZendGData\YouTube\VideoQuery`_ for each of these parameters are described in more detail in the `PHP
Developer's Guide`_.

.. _zendgdata.youtube.videos.searchingcategories:

Searching for videos by categories and tags/keywords
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Searching for videos in specific categories is done by generating a `specially formatted URL`_. For example, to
search for comedy videos which contain the keyword dog:

.. _zendgdata.youtube.videos.searchingcategories.example:

.. rubric:: Searching for videos in specific categories

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $query = $yt->newVideoQuery();
   $query->category = 'Comedy/dog';

   echo $query->queryUrl . "\n";
   $videoFeed = $yt->getVideoFeed($query);

.. _zendgdata.youtube.videos.standard:

Retrieving standard feeds
^^^^^^^^^^^^^^^^^^^^^^^^^

The YouTube Data *API* has a number of `standard feeds`_. These standard feeds can be retrieved as
`ZendGData\YouTube\VideoFeed`_ objects using the specified *URL*\ s, using the predefined constants within the
`ZendGData\YouTube`_ class (ZendGData\YouTube::STANDARD_TOP_RATED_URI for example) or using the predefined helper
methods (see code listing below).

To retrieve the top rated videos using the helper method:

.. _zendgdata.youtube.videos.standard.example-1:

.. rubric:: Retrieving a standard video feed

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $videoFeed = $yt->getTopRatedVideoFeed();

There are also query parameters to specify the time period over which the standard feed is computed.

For example, to retrieve the top rated videos for today:

.. _zendgdata.youtube.videos.standard.example-2:

.. rubric:: Using a ZendGData\YouTube\VideoQuery to Retrieve Videos

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $query = $yt->newVideoQuery();
   $query->setTime('today');
   $videoFeed = $yt->getTopRatedVideoFeed($query);

Alternatively, you could just retrieve the feed using the *URL*:

.. _zendgdata.youtube.videos.standard.example-3:

.. rubric:: Retrieving a video feed by URL

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $url = 'http://gdata.youtube.com/feeds/standardfeeds/top_rated?time=today'
   $videoFeed = $yt->getVideoFeed($url);

.. _zendgdata.youtube.videos.user:

Retrieving videos uploaded by a user
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can retrieve a list of videos uploaded by a particular user using a simple helper method. This example
retrieves videos uploaded by the user 'liz'.

.. _zendgdata.youtube.videos.user.example:

.. rubric:: Retrieving videos uploaded by a specific user

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $videoFeed = $yt->getUserUploads('liz');

.. _zendgdata.youtube.videos.favorites:

Retrieving videos favorited by a user
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can retrieve a list of a user's favorite videos using a simple helper method. This example retrieves videos
favorited by the user 'liz'.

.. _zendgdata.youtube.videos.favorites.example:

.. rubric:: Retrieving a user's favorite videos

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $videoFeed = $yt->getUserFavorites('liz');

.. _zendgdata.youtube.videos.responses:

Retrieving video responses for a video
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can retrieve a list of a video's video responses using a simple helper method. This example retrieves video
response for a video with the ID 'abc123813abc'.

.. _zendgdata.youtube.videos.responses.example:

.. rubric:: Retrieving a feed of video responses

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $videoFeed = $yt->getVideoResponseFeed('abc123813abc');

.. _zendgdata.youtube.comments:

Retrieving video comments
-------------------------

The comments for each YouTube video can be retrieved in several ways. To retrieve the comments for the video with
the ID 'abc123813abc', use the following code:

.. _zendgdata.youtube.videos.comments.example-1:

.. rubric:: Retrieving a feed of video comments from a video ID

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $commentFeed = $yt->getVideoCommentFeed('abc123813abc');

   foreach ($commentFeed as $commentEntry) {
       echo $commentEntry->title->text . "\n";
       echo $commentEntry->content->text . "\n\n\n";
   }

Comments can also be retrieved for a video if you have a copy of the `ZendGData\YouTube\VideoEntry`_ object:

.. _zendgdata.youtube.videos.comments.example-2:

.. rubric:: Retrieving a Feed of Video Comments from a ZendGData\YouTube\VideoEntry

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $videoEntry = $yt->getVideoEntry('abc123813abc');
   // we don't know the video ID in this example, but we do have the URL
   $commentFeed = $yt->getVideoCommentFeed(null,
                                           $videoEntry->comments->href);

.. _zendgdata.youtube.playlists:

Retrieving playlist feeds
-------------------------

The YouTube Data *API* provides information about users, including profiles, playlists, subscriptions, and more.

.. _zendgdata.youtube.playlists.user:

Retrieving the playlists of a user
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The library provides a helper method to retrieve the playlists associated with a given user. To retrieve the
playlists for the user 'liz':

.. _zendgdata.youtube.playlists.user.example:

.. rubric:: Retrieving the playlists of a user

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $playlistListFeed = $yt->getPlaylistListFeed('liz');

   foreach ($playlistListFeed as $playlistEntry) {
       echo $playlistEntry->title->text . "\n";
       echo $playlistEntry->description->text . "\n";
       echo $playlistEntry->getPlaylistVideoFeedUrl() . "\n\n\n";
   }

.. _zendgdata.youtube.playlists.special:

Retrieving a specific playlist
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The library provides a helper method to retrieve the videos associated with a given playlist. To retrieve the
playlists for a specific playlist entry:

.. _zendgdata.youtube.playlists.special.example:

.. rubric:: Retrieving a specific playlist

.. code-block:: php
   :linenos:

   $feedUrl = $playlistEntry->getPlaylistVideoFeedUrl();
   $playlistVideoFeed = $yt->getPlaylistVideoFeed($feedUrl);

.. _zendgdata.youtube.subscriptions:

Retrieving a list of a user's subscriptions
-------------------------------------------

A user can have several types of subscriptions: channel subscription, tag subscription, or favorites subscription.
A `ZendGData\YouTube\SubscriptionEntry`_ is used to represent individual subscriptions.

To retrieve all subscriptions for the user 'liz':

.. _zendgdata.youtube.subscriptions.example:

.. rubric:: Retrieving all subscriptions for a user

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $subscriptionFeed = $yt->getSubscriptionFeed('liz');

   foreach ($subscriptionFeed as $subscriptionEntry) {
       echo $subscriptionEntry->title->text . "\n";
   }

.. _zendgdata.youtube.profile:

Retrieving a user's profile
---------------------------

You can retrieve the public profile information for any YouTube user. To retrieve the profile for the user 'liz':

.. _zendgdata.youtube.profile.example:

.. rubric:: Retrieving a user's profile

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $userProfile = $yt->getUserProfile('liz');
   echo "username: " . $userProfile->username->text . "\n";
   echo "age: " . $userProfile->age->text . "\n";
   echo "hometown: " . $userProfile->hometown->text . "\n";

.. _zendgdata.youtube.uploads:

Uploading Videos to YouTube
---------------------------

Please make sure to review the diagrams in the `protocol guide`_ on code.google.com for a high-level overview of
the upload process. Uploading videos can be done in one of two ways: either by uploading the video directly or by
sending just the video meta-data and having a user upload the video through an *HTML* form.

In order to upload a video directly, you must first construct a new `ZendGData\YouTube\VideoEntry`_ object and
specify some required meta-data. The following example shows uploading the Quicktime video "mytestmovie.mov" to
YouTube with the following properties:

.. _zendgdata.youtube.uploads.metadata:

.. table:: Metadata used in the code-sample below

   +--------------+-----------------------------------+
   |Property      |Value                              |
   +==============+===================================+
   |Title         |My Test Movie                      |
   +--------------+-----------------------------------+
   |Category      |Autos                              |
   +--------------+-----------------------------------+
   |Keywords      |cars, funny                        |
   +--------------+-----------------------------------+
   |Description   |My description                     |
   +--------------+-----------------------------------+
   |Filename      |mytestmovie.mov                    |
   +--------------+-----------------------------------+
   |File MIME type|video/quicktime                    |
   +--------------+-----------------------------------+
   |Video private?|FALSE                              |
   +--------------+-----------------------------------+
   |Video location|37, -122 (lat, long)               |
   +--------------+-----------------------------------+
   |Developer Tags|mydevelopertag, anotherdevelopertag|
   +--------------+-----------------------------------+

The code below creates a blank `ZendGData\YouTube\VideoEntry`_ to be uploaded. A `ZendGData\App\MediaFileSource`_
object is then used to hold the actual video file. Under the hood, the `ZendGData\YouTube\Extension\MediaGroup`_
object is used to hold all of the video's meta-data. Our helper methods detailed below allow you to just set the
video meta-data without having to worry about the media group object. The $uploadUrl is the location where the new
entry gets posted to. This can be specified either with the $userName of the currently authenticated user, or,
alternatively, you can simply use the string 'default' to refer to the currently authenticated user.

.. _zendgdata.youtube.uploads.example:

.. rubric:: Uploading a video

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube($httpClient);
   $myVideoEntry = new ZendGData\YouTube\VideoEntry();

   $filesource = $yt->newMediaFileSource('mytestmovie.mov');
   $filesource->setContentType('video/quicktime');
   $filesource->setSlug('mytestmovie.mov');

   $myVideoEntry->setMediaSource($filesource);

   $myVideoEntry->setVideoTitle('My Test Movie');
   $myVideoEntry->setVideoDescription('My Test Movie');
   // Note that category must be a valid YouTube category !
   $myVideoEntry->setVideoCategory('Comedy');

   // Set keywords, note that this must be a comma separated string
   // and that each keyword cannot contain whitespace
   $myVideoEntry->SetVideoTags('cars, funny');

   // Optionally set some developer tags
   $myVideoEntry->setVideoDeveloperTags(array('mydevelopertag',
                                              'anotherdevelopertag'));

   // Optionally set the video's location
   $yt->registerPackage('ZendGData\Geo');
   $yt->registerPackage('ZendGData\Geo\Extension');
   $where = $yt->newGeoRssWhere();
   $position = $yt->newGmlPos('37.0 -122.0');
   $where->point = $yt->newGmlPoint($position);
   $myVideoEntry->setWhere($where);

   // Upload URI for the currently authenticated user
   $uploadUrl =
       'http://uploads.gdata.youtube.com/feeds/users/default/uploads';

   // Try to upload the video, catching a ZendGData\App\HttpException
   // if availableor just a regular ZendGData\App\Exception

   try {
       $newEntry = $yt->insertEntry($myVideoEntry,
                                    $uploadUrl,
                                    'ZendGData\YouTube\VideoEntry');
   } catch (ZendGData\App\HttpException $httpException) {
       echo $httpException->getRawResponseBody();
   } catch (ZendGData\App\Exception $e) {
       echo $e->getMessage();
   }

To upload a video as private, simply use: $myVideoEntry->setVideoPrivate(); prior to performing the upload.
$videoEntry->isVideoPrivate() can be used to check whether a video entry is private or not.

.. _zendgdata.youtube.uploads.browser:

Browser-based upload
--------------------

Browser-based uploading is performed almost identically to direct uploading, except that you do not attach a
`ZendGData\App\MediaFileSource`_ object to the `ZendGData\YouTube\VideoEntry`_ you are constructing. Instead you
simply submit all of your video's meta-data to receive back a token element which can be used to construct an
*HTML* upload form.

.. _zendgdata.youtube.uploads.browser.example-1:

.. rubric:: Browser-based upload

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube($httpClient);

   $myVideoEntry= new ZendGData\YouTube\VideoEntry();
   $myVideoEntry->setVideoTitle('My Test Movie');
   $myVideoEntry->setVideoDescription('My Test Movie');

   // Note that category must be a valid YouTube category
   $myVideoEntry->setVideoCategory('Comedy');
   $myVideoEntry->SetVideoTags('cars, funny');

   $tokenHandlerUrl = 'http://gdata.youtube.com/action/GetUploadToken';
   $tokenArray = $yt->getFormUploadToken($myVideoEntry, $tokenHandlerUrl);
   $tokenValue = $tokenArray['token'];
   $postUrl = $tokenArray['url'];

The above code prints out a link and a token that is used to construct an *HTML* form to display in the user's
browser. A simple example form is shown below with $tokenValue representing the content of the returned token
element, as shown being retrieved from $myVideoEntry above. In order for the user to be redirected to your website
after submitting the form, make sure to append a $nextUrl parameter to the $postUrl above, which functions in the
same way as the $next parameter of an AuthSub link. The only difference is that here, instead of a single-use
token, a status and an id variable are returned in the *URL*.

.. _zendgdata.youtube.uploads.browser.example-2:

.. rubric:: Browser-based upload: Creating the HTML form

.. code-block:: php
   :linenos:

   // place to redirect user after upload
   $nextUrl = 'http://mysite.com/youtube_uploads';

   $form = '<form action="'. $postUrl .'?nexturl='. $nextUrl .
           '" method="post" enctype="multipart/form-data">'.
           '<input name="file" type="file"/>'.
           '<input name="token" type="hidden" value="'. $tokenValue .'"/>'.
           '<input value="Upload Video File" type="submit" />'.
           '</form>';

.. _zendgdata.youtube.uploads.status:

Checking upload status
----------------------

After uploading a video, it will immediately be visible in an authenticated user's uploads feed. However, it will
not be public on the site until it has been processed. Videos that have been rejected or failed to upload
successfully will also only be in the authenticated user's uploads feed. The following code checks the status of a
`ZendGData\YouTube\VideoEntry`_ to see if it is not live yet or if it has been rejected.

.. _zendgdata.youtube.uploads.status.example:

.. rubric:: Checking video upload status

.. code-block:: php
   :linenos:

   try {
       $control = $videoEntry->getControl();
   } catch (ZendGData\App\Exception $e) {
       echo $e->getMessage();
   }

   if ($control instanceof ZendGData\App\Extension\Control) {
       if ($control->getDraft() != null &&
           $control->getDraft()->getText() == 'yes') {
           $state = $videoEntry->getVideoState();

           if ($state instanceof ZendGData\YouTube\Extension\State) {
               print 'Upload status: '
                     . $state->getName()
                     .' '. $state->getText();
           } else {
               print 'Not able to retrieve the video status information'
                     .' yet. ' . "Please try again shortly.\n";
           }
       }
   }

.. _zendgdata.youtube.other:

Other Functions
---------------

In addition to the functionality described above, the YouTube *API* contains many other functions that allow you to
modify video meta-data, delete video entries and use the full range of community features on the site. Some of the
community features that can be modified through the *API* include: ratings, comments, playlists, subscriptions,
user profiles, contacts and messages.

Please refer to the full documentation available in the `PHP Developer's Guide`_ on code.google.com.



.. _`PHP Developer's Guide`: http://code.google.com/apis/youtube/developers_guide_php.html
.. _`Authentication section in the PHP Developer's Guide`: http://code.google.com/apis/youtube/developers_guide_php.html#Authentication
.. _`ZendGData\YouTube`: http://framework.zend.com/apidoc/core/ZendGData/ZendGData\YouTube.html
.. _`YouTube API reference guide`: http://code.google.com/apis/youtube/reference.html#Video_Feeds
.. _`Reference Guide`: http://code.google.com/apis/youtube/reference.html#Searching_for_videos
.. _`ZendGData\YouTube\VideoQuery`: http://framework.zend.com/apidoc/core/ZendGData/ZendGData\YouTube\VideoQuery.html
.. _`specially formatted URL`: http://code.google.com/apis/youtube/reference.html#Category_search
.. _`standard feeds`: http://code.google.com/apis/youtube/reference.html#Standard_feeds
.. _`ZendGData\YouTube\VideoFeed`: http://framework.zend.com/apidoc/core/ZendGData/ZendGData\YouTube\VideoFeed.html
.. _`ZendGData\YouTube\VideoEntry`: http://framework.zend.com/apidoc/core/ZendGData/ZendGData\YouTube\VideoEntry.html
.. _`ZendGData\YouTube\SubscriptionEntry`: http://framework.zend.com/apidoc/core/ZendGData/ZendGData\YouTube\SubscriptionEntry.html
.. _`protocol guide`: http://code.google.com/apis/youtube/developers_guide_protocol.html#Process_Flows_for_Uploading_Videos
.. _`ZendGData\App\MediaFileSource`: http://framework.zend.com/apidoc/core/ZendGData/ZendGData\App\MediaFileSource.html
.. _`ZendGData\YouTube\Extension\MediaGroup`: http://framework.zend.com/apidoc/core/ZendGData/ZendGData\YouTube\Extension\MediaGroup.html
