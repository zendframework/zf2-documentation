.. _zendgdata.photos:

Using Picasa Web Albums
=======================

Picasa Web Albums is a service which allows users to maintain albums of their own pictures, and browse the albums
and pictures of others. The *API* offers a programmatic interface to this service, allowing users to add to,
update, and remove from their albums, as well as providing the ability to tag and comment on photos.

Access to public albums and photos is not restricted by account, however, a user must be logged in for
non-read-only access.

For more information on the *API*, including instructions for enabling *API* access, refer to the `Picasa Web
Albums Data API Overview`_.

.. note::

   **Authentication**

   The *API* provides authentication via AuthSub (recommended) and ClientAuth. *HTTP* connections must be
   authenticated for write support, but non-authenticated connections have read-only access.

.. _zendgdata.photos.connecting:

Connecting To The Service
-------------------------

The Picasa Web Albums *API*, like all GData *API*\ s, is based off of the Atom Publishing Protocol (APP), an *XML*
based format for managing web-based resources. Traffic between a client and the servers occurs over *HTTP* and
allows for both authenticated and unauthenticated connections.

Before any transactions can occur, this connection needs to be made. Creating a connection to the Picasa servers
involves two steps: creating an *HTTP* client and binding a ``ZendGData\Photos`` service instance to that client.

.. _zendgdata.photos.connecting.authentication:

Authentication
^^^^^^^^^^^^^^

The Google Picasa *API* allows access to both public and private photo feeds. Public feeds do not require
authentication, but are read-only and offer reduced functionality. Private feeds offers the most complete
functionality but requires an authenticated connection to the Picasa servers. There are three authentication
schemes that are supported by Google Picasa :

- **ClientAuth** provides direct username/password authentication to the Picasa servers. Since this scheme requires
  that users provide your application with their password, this authentication is only recommended when other
  authentication schemes are insufficient.

- **AuthSub** allows authentication to the Picasa servers via a Google proxy server. This provides the same level
  of convenience as ClientAuth but without the security risk, making this an ideal choice for web-based
  applications.

The ``ZendGData`` library provides support for both authentication schemes. The rest of this chapter will assume
that you are familiar the authentication schemes available and how to create an appropriate authenticated
connection. For more information, please see section the :ref:`Authentication section
<zendgdata.introduction.authentication>` of this manual or the `Authentication Overview in the Google Data API
Developer's Guide`_.

.. _zendgdata.photos.connecting.service:

Creating A Service Instance
^^^^^^^^^^^^^^^^^^^^^^^^^^^

In order to interact with the servers, this library provides the ``ZendGData\Photos`` service class. This class
provides a common interface to the Google Data and Atom Publishing Protocol models and assists in marshaling
requests to and from the servers.

Once deciding on an authentication scheme, the next step is to create an instance of ``ZendGData\Photos``. The
class constructor takes an instance of ``Zend\Http\Client`` as a single argument. This provides an interface for
AuthSub and ClientAuth authentication, as both of these require creation of a special authenticated *HTTP* client.
If no arguments are provided, an unauthenticated instance of ``Zend\Http\Client`` will be automatically created.

The example below shows how to create a service class using ClientAuth authentication:

.. code-block:: php
   :linenos:

   // Parameters for ClientAuth authentication
   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $user = "sample.user@gmail.com";
   $pass = "pa$$w0rd";

   // Create an authenticated HTTP client
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);

   // Create an instance of the service
   $service = new ZendGData\Photos($client);

A service instance using AuthSub can be created in a similar, though slightly more lengthy fashion:

.. code-block:: php
   :linenos:

   session_start();

   /**
    * Returns the full URL of the current page, based upon env variables
    *
    * Env variables used:
    * $_SERVER['HTTPS'] = (on|off|)
    * $_SERVER['HTTP_HOST'] = value of the Host: header
    * $_SERVER['SERVER_PORT'] = port number (only used if not http/80,https/443)
    * $_SERVER['REQUEST_URI'] = the URI after the method of the HTTP request
    *
    * @return string Current URL
    */
   function getCurrentUrl()
   {
       global $_SERVER;

       /**
        * Filter php_self to avoid a security vulnerability.
        */
       $php_request_uri = htmlentities(substr($_SERVER['REQUEST_URI'], 0,
       strcspn($_SERVER['REQUEST_URI'], "\n\r")), ENT_QUOTES);

       if (isset($_SERVER['HTTPS']) && strtolower($_SERVER['HTTPS']) == 'on') {
           $protocol = 'https://';
       } else {
           $protocol = 'http://';
       }
       $host = $_SERVER['HTTP_HOST'];
       if ($_SERVER['SERVER_PORT'] != '' &&
           (($protocol == 'http://' && $_SERVER['SERVER_PORT'] != '80') ||
           ($protocol == 'https://' && $_SERVER['SERVER_PORT'] != '443'))) {
               $port = ':' . $_SERVER['SERVER_PORT'];
       } else {
           $port = '';
       }
       return $protocol . $host . $port . $php_request_uri;
   }

   /**
    * Returns the AuthSub URL which the user must visit to authenticate requests
    * from this application.
    *
    * Uses getCurrentUrl() to get the next URL which the user will be redirected
    * to after successfully authenticating with the Google service.
    *
    * @return string AuthSub URL
    */
   function getAuthSubUrl()
   {
       $next = getCurrentUrl();
       $scope = 'http://picasaweb.google.com/data';
       $secure = false;
       $session = true;
       return ZendGData\AuthSub::getAuthSubTokenUri($next, $scope, $secure,
           $session);
   }

   /**
    * Returns a HTTP client object with the appropriate headers for communicating
    * with Google using AuthSub authentication.
    *
    * Uses the $_SESSION['sessionToken'] to store the AuthSub session token after
    * it is obtained. The single use token supplied in the URL when redirected
    * after the user successfully authenticated to Google is retrieved from the
    * $_GET['token'] variable.
    *
    * @return Zend\Http\Client
    */
   function getAuthSubHttpClient()
   {
       global $_SESSION, $_GET;
       if (!isset($_SESSION['sessionToken']) && isset($_GET['token'])) {
           $_SESSION['sessionToken'] =
               ZendGData\AuthSub::getAuthSubSessionToken($_GET['token']);
       }
       $client = ZendGData\AuthSub::getHttpClient($_SESSION['sessionToken']);
       return $client;
   }

   /**
    * Create a new instance of the service, redirecting the user
    * to the AuthSub server if necessary.
    */
   $service = new ZendGData\Photos(getAuthSubHttpClient());

Finally, an unauthenticated server can be created for use with public feeds:

.. code-block:: php
   :linenos:

   // Create an instance of the service using an unauthenticated HTTP client
   $service = new ZendGData\Photos();

.. _zendgdata.photos.queries:

Understanding and Constructing Queries
--------------------------------------

The primary method to request data from the service is by constructing a query. There are query classes for each of
the following types:

- **User** is used to specify the user whose data is being searched for, and is specified as a username. if no user
  is provided, "default" will be used instead to indicate the currently authenticated user (if authenticated).

- **Album** is used to specify the album which is being searched for, and is specified as either an id, or an album
  name.

- **Photo** is used to specify the photo which is being searched for, and is specified as an id.

A new ``UserQuery`` can be constructed as followed:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\UserQuery();
   $query->setUser("sample.user");

for each query, a number of parameters limiting the search can be requested, or specified, with get(Parameter) and
set(Parameter), respectively. They are as follows:

- **Projection** sets the format of the data returned in the feed, as either "api" or "base". Normally, "api" is
  desired. The default is "api".

- **Type** sets the type of element to be returned, as either "feed" or "entry". The default is "feed".

- **Access** sets the visibility of items to be returned, as "all", "public", or "private". The default is "all".
  Non-public elements will only be returned if the query is searching for the authenticated user.

- **Tag** sets a tag filter for returned items. When a tag is set, only items tagged with this value will return.

- **Kind** sets the kind of elements to return. When kind is specified, only entries that match this value will be
  returned.

- **ImgMax** sets the maximum image size for entries returned. Only image entries smaller than this value will be
  returned.

- **Thumbsize** sets the thumbsize of entries that are returned. Any retrieved entry will have a thumbsize equal to
  this value.

- **User** sets the user whose data is being searched for. The default is "default".

- **AlbumId** sets the id of the album being searched for. This element only applies to album and photo queries. In
  the case of photo queries, this specifies the album that contains the requested photo. The album id is mutually
  exclusive with the album's name. Setting one unsets the other.

- **AlbumName** sets the name of the album being searched for. This element only applies to the album and photo
  queries. In the case of photo queries, this specifies the album that contains the requested photo. The album name
  is mutually exclusive with the album's id. Setting one unsets the other.

- **PhotoId** sets the id of the photo being searched for. This element only applies to photo queries.

.. _zendgdata.photos.retrieval:

Retrieving Feeds And Entries
----------------------------

The service has functions to retrieve a feed, or individual entries, for users, albums, and individual photos.

.. _zendgdata.photos.user_retrieval:

Retrieving A User
^^^^^^^^^^^^^^^^^

The service supports retrieving a user feed and list of the user's content. If the requested user is also the
authenticated user, entries marked as "**hidden**" will also be returned.

The user feed can be accessed by passing the username to the ``getUserFeed()`` method:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   try {
       $userFeed = $service->getUserFeed("sample.user");
   } catch (ZendGData\App\Exception $e) {
       echo "Error: " . $e->getMessage();
   }

Or, the feed can be accessed by constructing a query, first:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\UserQuery();
   $query->setUser("sample.user");

   try {
       $userFeed = $service->getUserFeed(null, $query);
   } catch (ZendGData\App\Exception $e) {
       echo "Error: " . $e->getMessage();
   }

Constructing a query also provides the ability to request a user entry object:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\UserQuery();
   $query->setUser("sample.user");
   $query->setType("entry");

   try {
       $userEntry = $service->getUserEntry($query);
   } catch (ZendGData\App\Exception $e) {
       echo "Error: " . $e->getMessage();
   }

.. _zendgdata.photos.album_retrieval:

Retrieving An Album
^^^^^^^^^^^^^^^^^^^

The service supports retrieving an album feed and a list of the album's content.

The album feed is accessed by constructing a query object and passing it to ``getAlbumFeed()``:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\AlbumQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");

   try {
       $albumFeed = $service->getAlbumFeed($query);
   } catch (ZendGData\App\Exception $e) {
       echo "Error: " . $e->getMessage();
   }

Alternatively, the query object can be given an album name with ``setAlbumName()``. Setting the album name is
mutually exclusive with setting the album id, and setting one will unset the other.

Constructing a query also provides the ability to request an album entry object:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\AlbumQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setType("entry");

   try {
       $albumEntry = $service->getAlbumEntry($query);
   } catch (ZendGData\App\Exception $e) {
       echo "Error: " . $e->getMessage();
   }

.. _zendgdata.photos.photo_retrieval:

Retrieving A Photo
^^^^^^^^^^^^^^^^^^

The service supports retrieving a photo feed and a list of associated comments and tags.

The photo feed is accessed by constructing a query object and passing it to ``getPhotoFeed()``:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");

   try {
       $photoFeed = $service->getPhotoFeed($query);
   } catch (ZendGData\App\Exception $e) {
       echo "Error: " . $e->getMessage();
   }

Constructing a query also provides the ability to request a photo entry object:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");
   $query->setType("entry");

   try {
       $photoEntry = $service->getPhotoEntry($query);
   } catch (ZendGData\App\Exception $e) {
       echo "Error: " . $e->getMessage();
   }

.. _zendgdata.photos.comment_retrieval:

Retrieving A Comment
^^^^^^^^^^^^^^^^^^^^

The service supports retrieving comments from a feed of a different type. By setting a query to return a kind of
"comment", a feed request can return comments associated with a specific user, album, or photo.

Performing an action on each of the comments on a given photo can be accomplished as follows:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");
   $query->setKind("comment");

   try {
       $photoFeed = $service->getPhotoFeed($query);

       foreach ($photoFeed as $entry) {
           if ($entry instanceof ZendGData\Photos\CommentEntry) {
               // Do something with the comment
           }
       }
   } catch (ZendGData\App\Exception $e) {
       echo "Error: " . $e->getMessage();
   }

.. _zendgdata.photos.tag_retrieval:

Retrieving A Tag
^^^^^^^^^^^^^^^^

The service supports retrieving tags from a feed of a different type. By setting a query to return a kind of "tag",
a feed request can return tags associated with a specific photo.

Performing an action on each of the tags on a given photo can be accomplished as follows:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $query = new ZendGData\Photos\PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");
   $query->setKind("tag");

   try {
       $photoFeed = $service->getPhotoFeed($query);

       foreach ($photoFeed as $entry) {
           if ($entry instanceof ZendGData\Photos\TagEntry) {
               // Do something with the tag
           }
       }
   } catch (ZendGData\App\Exception $e) {
       echo "Error: " . $e->getMessage();
   }

.. _zendgdata.photos.creation:

Creating Entries
----------------

The service has functions to create albums, photos, comments, and tags.

.. _zendgdata.photos.album_creation:

Creating An Album
^^^^^^^^^^^^^^^^^

The service supports creating a new album for an authenticated user:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $entry = new ZendGData\Photos\AlbumEntry();
   $entry->setTitle($service->newTitle("test album"));

   $service->insertAlbumEntry($entry);

.. _zendgdata.photos.photo_creation:

Creating A Photo
^^^^^^^^^^^^^^^^

The service supports creating a new photo for an authenticated user:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   // $photo is the name of a file uploaded via an HTML form

   $fd = $service->newMediaFileSource($photo["tmp_name"]);
   $fd->setContentType($photo["type"]);

   $entry = new ZendGData\Photos\PhotoEntry();
   $entry->setMediaSource($fd);
   $entry->setTitle($service->newTitle($photo["name"]));

   $albumQuery = new ZendGData\Photos\AlbumQuery;
   $albumQuery->setUser("sample.user");
   $albumQuery->setAlbumId("1");

   $albumEntry = $service->getAlbumEntry($albumQuery);

   $service->insertPhotoEntry($entry, $albumEntry);

.. _zendgdata.photos.comment_creation:

Creating A Comment
^^^^^^^^^^^^^^^^^^

The service supports creating a new comment for a photo:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $entry = new ZendGData\Photos\CommentEntry();
   $entry->setTitle($service->newTitle("comment"));
   $entry->setContent($service->newContent("comment"));

   $photoQuery = new ZendGData\Photos\PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $photoEntry = $service->getPhotoEntry($photoQuery);

   $service->insertCommentEntry($entry, $photoEntry);

.. _zendgdata.photos.tag_creation:

Creating A Tag
^^^^^^^^^^^^^^

The service supports creating a new tag for a photo:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $entry = new ZendGData\Photos\TagEntry();
   $entry->setTitle($service->newTitle("tag"));

   $photoQuery = new ZendGData\Photos\PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $photoEntry = $service->getPhotoEntry($photoQuery);

   $service->insertTagEntry($entry, $photoEntry);

.. _zendgdata.photos.deletion:

Deleting Entries
----------------

The service has functions to delete albums, photos, comments, and tags.

.. _zendgdata.photos.album_deletion:

Deleting An Album
^^^^^^^^^^^^^^^^^

The service supports deleting an album for an authenticated user:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $albumQuery = new ZendGData\Photos\AlbumQuery;
   $albumQuery->setUser("sample.user");
   $albumQuery->setAlbumId("1");
   $albumQuery->setType('entry');

   $entry = $service->getAlbumEntry($albumQuery);

   $service->deleteAlbumEntry($entry, true);

.. _zendgdata.photos.photo_deletion:

Deleting A Photo
^^^^^^^^^^^^^^^^

The service supports deleting a photo for an authenticated user:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $photoQuery = new ZendGData\Photos\PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $entry = $service->getPhotoEntry($photoQuery);

   $service->deletePhotoEntry($entry, true);

.. _zendgdata.photos.comment_deletion:

Deleting A Comment
^^^^^^^^^^^^^^^^^^

The service supports deleting a comment for an authenticated user:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $photoQuery = new ZendGData\Photos\PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $path = $photoQuery->getQueryUrl() . '/commentid/' . "1000";

   $entry = $service->getCommentEntry($path);

   $service->deleteCommentEntry($entry, true);

.. _zendgdata.photos.tag_deletion:

Deleting A Tag
^^^^^^^^^^^^^^

The service supports deleting a tag for an authenticated user:

.. code-block:: php
   :linenos:

   $service = ZendGData\Photos::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $service = new ZendGData\Photos($client);

   $photoQuery = new ZendGData\Photos\PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setKind("tag");
   $query = $photoQuery->getQueryUrl();

   $photoFeed = $service->getPhotoFeed($query);

   foreach ($photoFeed as $entry) {
       if ($entry instanceof ZendGData\Photos\TagEntry) {
           if ($entry->getContent() == $tagContent) {
               $tagEntry = $entry;
           }
       }
   }

   $service->deleteTagEntry($tagEntry, true);

.. _zendgdata.photos.optimistic_concurrency:

Optimistic Concurrency (Notes On Deletion)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

GData feeds, including those of the Picasa Web Albums service, implement optimistic concurrency, a versioning
system that prevents users from overwriting changes, inadvertently. When deleting a entry through the service
class, if the entry has been modified since it was last fetched, an exception will be thrown, unless explicitly set
otherwise (in which case the deletion is retried on the updated entry).

An example of how to handle versioning during a deletion is shown by ``deleteAlbumEntry()``:

.. code-block:: php
   :linenos:

   // $album is the albumEntry to be deleted
   try {
       $this->delete($album);
   } catch (ZendGData\App\HttpException $e) {
       if ($e->getMessage()->getStatus() === 409) {
           $entry =
               new ZendGData\Photos\AlbumEntry($e->getMessage()->getBody());
           $this->delete($entry->getLink('edit')->href);
       } else {
           throw $e;
       }
   }



.. _`Picasa Web Albums Data API Overview`: http://code.google.com/apis/picasaweb/overview.html
.. _`Authentication Overview in the Google Data API Developer's Guide`: http://code.google.com/apis/gdata/auth.html
