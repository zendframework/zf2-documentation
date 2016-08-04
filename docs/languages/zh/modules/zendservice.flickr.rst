.. _zendservice.flickr:

ZendService\\Flickr
===================

.. _zendservice.flickr.introduction:

Introduction
------------

``ZendService\Flickr\Flickr`` is a simple *API* for using the Flickr REST Web Service. In order to use the Flickr web
services, you must have an *API* key. To obtain a key and for more information about the Flickr REST Web Service,
please visit the `Flickr API Documentation`_.

In the following example, we use the ``tagSearch()`` method to search for photos having "php" in the tags.

.. _zendservice.flickr.introduction.example-1:

.. rubric:: Simple Flickr Photo Search

.. code-block:: php
   :linenos:

   $flickr = new ZendService\Flickr\Flickr('MY_API_KEY');

   $results = $flickr->tagSearch("php");

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }

.. note::

   **Optional parameter**

   ``tagSearch()`` accepts an optional second parameter as an array of options.

.. _zendservice.flickr.finding-users:

Finding Flickr Users' Photos and Information
--------------------------------------------

``ZendService\Flickr\Flickr`` provides several ways to get information about Flickr users:

- ``userSearch()``: Accepts a string query of space-delimited tags and an optional second parameter as an array of
  search options, and returns a set of photos as a ``ZendService\Flickr\ResultSet`` object.

- ``getIdByUsername()``: Returns a string user ID associated with the given username string.

- ``getIdByEmail()``: Returns a string user ID associated with the given email address string.

.. _zendservice.flickr.finding-users.example-1:

.. rubric:: Finding a Flickr User's Public Photos by E-Mail Address

In this example, we have a Flickr user's e-mail address, and we search for the user's public photos by using the
``userSearch()`` method:

.. code-block:: php
   :linenos:

   $flickr = new ZendService\Flickr\Flickr('MY_API_KEY');

   $results = $flickr->userSearch($userEmail);

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }

.. _zendservice.flickr.grouppoolgetphotos:

Finding photos From a Group Pool
--------------------------------

``ZendService\Flickr\Flickr`` allows to retrieve a group's pool photos based on the group ID. Use the
``groupPoolGetPhotos()`` method:

.. _zendservice.flickr.grouppoolgetphotos.example-1:

.. rubric:: Retrieving a Group's Pool Photos by Group ID

.. code-block:: php
   :linenos:

   $flickr = new ZendService\Flickr\Flickr('MY_API_KEY');

       $results = $flickr->groupPoolGetPhotos($groupId);

       foreach ($results as $result) {
           echo $result->title . '<br />';
       }

.. note::

   **Optional parameter**

   ``groupPoolGetPhotos()`` accepts an optional second parameter as an array of options.

.. _zendservice.flickr.getimagedetails:

Retrieving Flickr Image Details
-------------------------------

``ZendService\Flickr\Flickr`` makes it quick and easy to get an image's details based on a given image ID. Just use the
``getImageDetails()`` method, as in the following example:

.. _zendservice.flickr.getimagedetails.example-1:

.. rubric:: Retrieving Flickr Image Details

Once you have a Flickr image ID, it is a simple matter to fetch information about the image:

.. code-block:: php
   :linenos:

   $flickr = new ZendService\Flickr\Flickr('MY_API_KEY');

   $image = $flickr->getImageDetails($imageId);

   echo "Image ID $imageId is $image->width x $image->height pixels.<br />\n";
   echo "<a href=\"$image->clickUri\">Click for Image</a>\n";

.. _zendservice.flickr.classes:

ZendService\\Flickr Result Classes
----------------------------------

The following classes are all returned by ``tagSearch()`` and ``userSearch()``:



   - :ref:`ZendService\Flickr\ResultSet <zendservice.flickr.classes.resultset>`

   - :ref:`ZendService\Flickr\Result <zendservice.flickr.classes.result>`

   - :ref:`ZendService\Flickr\Image <zendservice.flickr.classes.image>`



.. _zendservice.flickr.classes.resultset:

ZendService\\Flickr\\ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Represents a set of Results from a Flickr search.

.. note::

   Implements the ``SeekableIterator`` interface for easy iteration (e.g., using ``foreach()``), as well as direct
   access to a specific result using ``seek()``.

.. _zendservice.flickr.classes.resultset.properties:

Properties
^^^^^^^^^^

.. _zendservice.flickr.classes.resultset.properties.table-1:

.. table:: ZendService\Flickr\ResultSet Properties

   +---------------------+----+-----------------------------------------------------+
   |Name                 |Type|Description                                          |
   +=====================+====+=====================================================+
   |totalResultsAvailable|int |Total Number of Results available                    |
   +---------------------+----+-----------------------------------------------------+
   |totalResultsReturned |int |Total Number of Results returned                     |
   +---------------------+----+-----------------------------------------------------+
   |firstResultPosition  |int |The offset in the total result set of this result set|
   +---------------------+----+-----------------------------------------------------+

.. _zendservice.flickr.classes.resultset.totalResults:

ZendService\\Flickr\\ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``


Returns the total number of results in this result set.

:ref:`Back to Class List <zendservice.flickr.classes>`

.. _zendservice.flickr.classes.result:

ZendService\\Flickr\\Result
^^^^^^^^^^^^^^^^^^^^^^^^^^^

A single Image result from a Flickr query

.. _zendservice.flickr.classes.result.properties:

Properties
^^^^^^^^^^

.. _zendservice.flickr.classes.result.properties.table-1:

.. table:: ZendService\Flickr\Result Properties

   +----------+-------------------------+------------------------------------------------------------------+
   |Name      |Type                     |Description                                                       |
   +==========+=========================+==================================================================+
   |id        |string                   |Image ID                                                          |
   +----------+-------------------------+------------------------------------------------------------------+
   |owner     |string                   |The photo owner's NSID.                                           |
   +----------+-------------------------+------------------------------------------------------------------+
   |secret    |string                   |A key used in url construction.                                   |
   +----------+-------------------------+------------------------------------------------------------------+
   |server    |string                   |The servername to use for URL construction.                       |
   +----------+-------------------------+------------------------------------------------------------------+
   |title     |string                   |The photo's title.                                                |
   +----------+-------------------------+------------------------------------------------------------------+
   |ispublic  |string                   |The photo is public.                                              |
   +----------+-------------------------+------------------------------------------------------------------+
   |isfriend  |string                   |The photo is visible to you because you are a friend of the owner.|
   +----------+-------------------------+------------------------------------------------------------------+
   |isfamily  |string                   |The photo is visible to you because you are family of the owner.  |
   +----------+-------------------------+------------------------------------------------------------------+
   |license   |string                   |The license the photo is available under.                         |
   +----------+-------------------------+------------------------------------------------------------------+
   |dateupload|string                   |The date the photo was uploaded.                                  |
   +----------+-------------------------+------------------------------------------------------------------+
   |datetaken |string                   |The date the photo was taken.                                     |
   +----------+-------------------------+------------------------------------------------------------------+
   |ownername |string                   |The screenname of the owner.                                      |
   +----------+-------------------------+------------------------------------------------------------------+
   |iconserver|string                   |The server used in assembling icon URLs.                          |
   +----------+-------------------------+------------------------------------------------------------------+
   |Square    |ZendService\Flickr\Image |A 75x75 thumbnail of the image.                                   |
   +----------+-------------------------+------------------------------------------------------------------+
   |Thumbnail |ZendService\Flickr\Image |A 100 pixel thumbnail of the image.                               |
   +----------+-------------------------+------------------------------------------------------------------+
   |Small     |ZendService\Flickr\Image |A 240 pixel version of the image.                                 |
   +----------+-------------------------+------------------------------------------------------------------+
   |Medium    |ZendService\Flickr\Image |A 500 pixel version of the image.                                 |
   +----------+-------------------------+------------------------------------------------------------------+
   |Large     |ZendService\Flickr\Image |A 640 pixel version of the image.                                 |
   +----------+-------------------------+------------------------------------------------------------------+
   |Original  |ZendService\Flickr\Image |The original image.                                               |
   +----------+-------------------------+------------------------------------------------------------------+

:ref:`Back to Class List <zendservice.flickr.classes>`

.. _zendservice.flickr.classes.image:

ZendService\\Flickr\\Image
^^^^^^^^^^^^^^^^^^^^^^^^^^

Represents an Image returned by a Flickr search.

.. _zendservice.flickr.classes.image.properties:

Properties
^^^^^^^^^^

.. _zendservice.flickr.classes.image.properties.table-1:

.. table:: ZendService\Flickr\Image Properties

   +--------+------+--------------------------------------------------+
   |Name    |Type  |Description                                       |
   +========+======+==================================================+
   |uri     |string|URI for the original image                        |
   +--------+------+--------------------------------------------------+
   |clickUri|string|Clickable URI (i.e. the Flickr page) for the image|
   +--------+------+--------------------------------------------------+
   |width   |int   |Width of the Image                                |
   +--------+------+--------------------------------------------------+
   |height  |int   |Height of the Image                               |
   +--------+------+--------------------------------------------------+

:ref:`Back to Class List <zendservice.flickr.classes>`



.. _`Flickr API Documentation`: http://www.flickr.com/services/api/