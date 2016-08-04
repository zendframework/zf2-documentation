.. _zendservice.audioscrobbler:

ZendService\\Audioscrobbler
===========================

.. _zendservice.audioscrobbler.introduction:

Introduction
------------

``ZendService\Audioscrobbler\Audioscrobbler`` is a simple *API* for using the Audioscrobbler REST Web Service. The Audioscrobbler
Web Service provides access to its database of Users, Artists, Albums, Tracks, Tags, Groups, and Forums. The
methods of the ``ZendService\Audioscrobbler\Audioscrobbler`` class begin with one of these terms. The syntax and namespaces of
the Audioscrobbler Web Service are mirrored in ``ZendService\Audioscrobbler\Audioscrobbler``. For more information about the
Audioscrobbler REST Web Service, please visit the `Audioscrobbler Web Service site`_.

.. _zendservice.audioscrobbler.users:

Users
-----

In order to retrieve information for a specific user, the ``setUser()`` method is first used to select the user for
which data are to be retrieved. ``ZendService\Audioscrobbler\Audioscrobbler`` provides several methods for retrieving data
specific to a single user:



   - ``userGetProfileInformation()``: Returns a SimpleXML object containing the current user's profile information.

   - ``userGetTopArtists()``: Returns a SimpleXML object containing a list of the current user's most listened to
     artists.

   - ``userGetTopAlbums()``: Returns a SimpleXML object containing a list of the current user's most listened to
     albums.

   - ``userGetTopTracks()``: Returns a SimpleXML object containing a list of the current user's most listened to
     tracks.

   - ``userGetTopTags()``: Returns a SimpleXML object containing a list of tags most applied by the current user.

   - ``userGetTopTagsForArtist()``: Requires that an artist be set via ``setArtist()``. Returns a SimpleXML object
     containing the tags most applied to the current artist by the current user.

   - ``userGetTopTagsForAlbum()``: Requires that an album be set via ``setAlbum()``. Returns a SimpleXML object
     containing the tags most applied to the current album by the current user.

   - ``userGetTopTagsForTrack()``: Requires that a track be set via ``setTrack()``. Returns a SimpleXML object
     containing the tags most applied to the current track by the current user.

   - ``userGetFriends()``: Returns a SimpleXML object containing the user names of the current user's friends.

   - ``userGetNeighbours()``: Returns a SimpleXML object containing the user names of people with similar listening
     habits to the current user.

   - ``userGetRecentTracks()``: Returns a SimpleXML object containing the 10 tracks most recently played by the
     current user.

   - ``userGetRecentBannedTracks()``: Returns a SimpleXML object containing a list of the 10 tracks most recently
     banned by the current user.

   - ``userGetRecentLovedTracks()``: Returns a SimpleXML object containing a list of the 10 tracks most recently
     loved by the current user.

   - ``userGetRecentJournals()``: Returns a SimpleXML object containing a list of the current user's most recent
     journal entries.

   - ``userGetWeeklyChartList()``: Returns a SimpleXML object containing a list of weeks for which there exist
     Weekly Charts for the current user.

   - ``userGetRecentWeeklyArtistChart()``: Returns a SimpleXML object containing the most recent Weekly Artist
     Chart for the current user.

   - ``userGetRecentWeeklyAlbumChart()``: Returns a SimpleXML object containing the most recent Weekly Album Chart
     for the current user.

   - ``userGetRecentWeeklyTrackChart()``: Returns a SimpleXML object containing the most recent Weekly Track Chart
     for the current user.

   - ``userGetPreviousWeeklyArtistChart($fromDate, $toDate)``: Returns a SimpleXML object containing the Weekly
     Artist Chart from ``$fromDate`` to ``$toDate`` for the current user.

   - ``userGetPreviousWeeklyAlbumChart($fromDate, $toDate)``: Returns a SimpleXML object containing the Weekly
     Album Chart from ``$fromDate`` to ``$toDate`` for the current user.

   - ``userGetPreviousWeeklyTrackChart($fromDate, $toDate)``: Returns a SimpleXML object containing the Weekly
     Track Chart from ``$fromDate`` to ``$toDate`` for the current user.



.. _zendservice.audioscrobbler.users.example.profile_information:

.. rubric:: Retrieving User Profile Information

In this example, we use the ``setUser()`` and ``userGetProfileInformation()`` methods to retrieve a specific user's
profile information:

.. code-block:: php
   :linenos:

   $as = new ZendService\Audioscrobbler\Audioscrobbler();
   // Set the user whose profile information we want to retrieve
   $as->setUser('BigDaddy71');
   // Retrieve BigDaddy71's profile information
   $profileInfo = $as->userGetProfileInformation();
   // Display some of it
   print "Information for $profileInfo->realname "
       . "can be found at $profileInfo->url";

.. _zendservice.audioscrobbler.users.example.weekly_artist_chart:

.. rubric:: Retrieving a User's Weekly Artist Chart

.. code-block:: php
   :linenos:

   $as = new ZendService\Audioscrobbler\Audioscrobbler();
   // Set the user whose profile weekly artist chart we want to retrieve
   $as->setUser('lo_fye');
   // Retrieves a list of previous weeks for which there are chart data
   $weeks = $as->userGetWeeklyChartList();
   if (count($weeks) < 1) {
       echo 'No data available';
   }
   sort($weeks); // Order the list of weeks

   $as->setFromDate($weeks[0]); // Set the starting date
   $as->setToDate($weeks[0]); // Set the ending date

   $previousWeeklyArtists = $as->userGetPreviousWeeklyArtistChart();

   echo 'Artist Chart For Week Of '
      . date('Y-m-d h:i:s', $as->from_date)
      . '<br />';

   foreach ($previousWeeklyArtists as $artist) {
       // Display the artists' names with links to their profiles
       print '<a href="' . $artist->url . '">' . $artist->name . '</a><br />';
   }

.. _zendservice.audioscrobbler.artists:

Artists
-------

``ZendService\Audioscrobbler\Audioscrobbler`` provides several methods for retrieving data about a specific artist, specified via
the ``setArtist()`` method:



   - ``artistGetRelatedArtists()``: Returns a SimpleXML object containing a list of Artists similar to the current
     Artist.

   - ``artistGetTopFans()``: Returns a SimpleXML object containing a list of Users who listen most to the current
     Artist.

   - ``artistGetTopTracks()``: Returns a SimpleXML object containing a list of the current Artist's top-rated
     Tracks.

   - ``artistGetTopAlbums()``: Returns a SimpleXML object containing a list of the current Artist's top-rated
     Albums.

   - ``artistGetTopTags()``: Returns a SimpleXML object containing a list of the Tags most frequently applied to
     current Artist.



.. _zendservice.audioscrobbler.artists.example.related_artists:

.. rubric:: Retrieving Related Artists

.. code-block:: php
   :linenos:

   $as = new ZendService\Audioscrobbler\Audioscrobbler();
   // Set the artist for whom you would like to retrieve related artists
   $as->setArtist('LCD Soundsystem');
   // Retrieve the related artists
   $relatedArtists = $as->artistGetRelatedArtists();
   foreach ($relatedArtists as $artist) {
       // Display the related artists
       print '<a href="' . $artist->url . '">' . $artist->name . '</a><br />';
   }

.. _zendservice.audioscrobbler.tracks:

Tracks
------

``ZendService\Audioscrobbler\Audioscrobbler`` provides two methods for retrieving data specific to a single track, specified via
the ``setTrack()`` method:



   - ``trackGetTopFans()``: Returns a SimpleXML object containing a list of Users who listen most to the current
     Track.

   - ``trackGetTopTags()``: Returns a SimpleXML object containing a list of the Tags most frequently applied to the
     current Track.



.. _zendservice.audioscrobbler.tags:

Tags
----

``ZendService\Audioscrobbler\Audioscrobbler`` provides several methods for retrieving data specific to a single tag, specified
via the ``setTag()`` method:



   - ``tagGetOverallTopTags()``: Returns a SimpleXML object containing a list of Tags most frequently used on
     Audioscrobbler.

   - ``tagGetTopArtists()``: Returns a SimpleXML object containing a list of Artists to whom the current Tag was
     most frequently applied.

   - ``tagGetTopAlbums()``: Returns a SimpleXML object containing a list of Albums to which the current Tag was
     most frequently applied.

   - ``tagGetTopTracks()``: Returns a SimpleXML object containing a list of Tracks to which the current Tag was
     most frequently applied.



.. _zendservice.audioscrobbler.groups:

Groups
------

``ZendService\Audioscrobbler\Audioscrobbler`` provides several methods for retrieving data specific to a single group, specified
via the ``setGroup()`` method:



   - ``groupGetRecentJournals()``: Returns a SimpleXML object containing a list of recent journal posts by Users in
     the current Group.

   - ``groupGetWeeklyChart()``: Returns a SimpleXML object containing a list of weeks for which there exist Weekly
     Charts for the current Group.

   - ``groupGetRecentWeeklyArtistChart()``: Returns a SimpleXML object containing the most recent Weekly Artist
     Chart for the current Group.

   - ``groupGetRecentWeeklyAlbumChart()``: Returns a SimpleXML object containing the most recent Weekly Album Chart
     for the current Group.

   - ``groupGetRecentWeeklyTrackChart()``: Returns a SimpleXML object containing the most recent Weekly Track Chart
     for the current Group.

   - ``groupGetPreviousWeeklyArtistChart($fromDate, $toDate)``: Requires ``setFromDate()`` and ``setToDate()``.
     Returns a SimpleXML object containing the Weekly Artist Chart from the current fromDate to the current toDate
     for the current Group.

   - ``groupGetPreviousWeeklyAlbumChart($fromDate, $toDate)``: Requires ``setFromDate()`` and ``setToDate()``.
     Returns a SimpleXML object containing the Weekly Album Chart from the current fromDate to the current toDate
     for the current Group.

   - ``groupGetPreviousWeeklyTrackChart($fromDate, $toDate)``: Returns a SimpleXML object containing the Weekly
     Track Chart from the current fromDate to the current toDate for the current Group.



.. _zendservice.audioscrobbler.forums:

Forums
------

``ZendService\Audioscrobbler\Audioscrobbler`` provides a method for retrieving data specific to a single forum, specified via the
``setForum()`` method:

   - ``forumGetRecentPosts()``: Returns a SimpleXML object containing a list of recent posts in the current forum.



.. _`Audioscrobbler Web Service site`: http://www.audioscrobbler.net/data/webservices/