.. EN-Revision: none
.. _zend.service.audioscrobbler:

Zend_Service_Audioscrobbler
===========================

.. _zend.service.audioscrobbler.introduction:

Einführung
----------

``Zend_Service_Audioscrobbler`` ist eine einfache *API* für die Verwendung des Audioscrobbler REST Web Services.
Der Audioscrobbler Web Service bietet Zugang zu seinen Datenbanken von Benutzern, Artisten, Albums, Lieder, tags,
Gruppen und Foren. Die Methoden der ``Zend_Service_Audioscrobbler`` Klasse beginnt mit einem dieser Bezeichner. Der
Syntax und der Namensraum des Audioscrobbler Web Services sind in ``Zend_Service_Audioscrobbler`` gespiegelt. Für
weitere Informationen über das Audioscrobbler REST Web Service, siehe die `Audioscrobbler Web Service Seite`_.

.. _zend.service.audioscrobbler.users:

Benutzer
--------

Um Informationen über einen bestimmten Benutzer zu erhalten, wird zuerst die ``setUser()`` Methode verwendet um
den Benutzer zu selektieren für den Daten empfangen werden sollen. ``Zend_Service_Audioscrobbler`` bietet
verschiedene Methoden für das Empfangen von Daten eines einzelnen Benutzers:



   - ``userGetProfileInformation()``: Gibt ein SimpleXML Objekt zurück das die aktuellen Profilinformationen des
     Benutzers enthält.

   - ``userGetTopArtists()``: Gibt ein SimpleXML Objekt zurück das eine Liste der aktuell am meisten gelisteten
     Artisten des Benutzers enthält.

   - ``userGetTopAlbums()``: Gibt ein SimpleXML Objekt zurück das eine Liste der aktuell am meisten gelisteten
     Alben des Benutzer enthält.

   - ``userGetTopTracks()``: Gibt ein SimpleXML Objekt zurück welches das aktuell am meisten gelistete Lied des
     Benutzers enthält.

   - ``userGetTopTags()``: Gibt ein SimpleXML Objekt zurück das eine Liste der Tags enthält die am meisten vom
     aktuellen Benutzer zugeordnet wurden.

   - ``userGetTopTagsForArtist()``: Erfordert das ein Artist über ``setArtist()`` gesetzt wurde. Gibt ein
     SimpleXML Objekt zurück das die Tags enthält die am meisten dem aktuellen Artisten durch den aktuellen
     Benutzer zugeordnet worden sind.

   - ``userGetTopTagsForAlbum()``: Erfordert das ein Album über ``setAlbum()`` gesetzt wurde. Gibt ein SimpleXML
     Objekt zurück das die Tags enthält die am meisten dem aktuellen Album durch den aktuellen Benutzer
     zugeordnet worden sind.

   - ``userGetTopTagsForTrack()``: Erfordert das ein Lied über ``setTrack()`` gesetzt wurde. Gibt ein SimpleXML
     Objekt zurück das die Tags enthält die am meisten dem aktuellen Lied vom aktuellen Benutzer zugeordnet
     worden sind.

   - ``userGetFriends()``: Gibt ein SimpleXML Objekt zurück das die Benutzernamen der Freunde des aktuellen
     Benutzers enthält.

   - ``userGetNeighbours()``: Gibt ein SimpleXML Objekt zurück das die Benutzernamen der Personen enthält die
     ähnliche Unterhaltungs-Gewohnheiten wie der aktuelle Benutzer haben.

   - ``userGetRecentTracks()``: Gibt ein SimpleXML Objekt zurück das eine Liste der 10 zuletzt gespielten Lieder
     des aktuellen Benutzers enthält.

   - ``userGetRecentBannedTracks()``: Gibt ein SimpleXML Objekt zurück das eine Liste der 10 zuletzt verbannten
     Lieder des aktuellen Benutzers enthält.

   - ``userGetRecentLovedTracks()``: Gibt ein SimpleXML Objekt zurück das eine Liste der 10 zuletzt geliebten
     Lieder des aktuellen Benutzers enthält.

   - ``userGetRecentJournals()``: Gibt ein SimpleXML Objekt zurück das eine Liste der letzten Journaleintröge des
     aktuellen Benutzers enthält.

   - ``userGetWeeklyChartList()``: Gibt ein SimpleXML Objekt zurück das eine Liste der Wochen enthält für die
     ein Wochenchart des aktuellen Benutzers existiert.

   - ``userGetRecentWeeklyArtistChart()``: Gibt ein SimpleXML Objekt zurück das die letzten wöchentlichen
     Artistencharts des aktuellen Benutzers enthält.

   - ``userGetRecentWeeklyAlbumChart()``: Gibt ein SimpleXML Objekt zurück das die letzten wöchentlichen
     Albumcharts des aktuellen Benutzers enthält.

   - ``userGetRecentWeeklyTrackChart()``: Gibt ein SimpleXML Objekt zurück das die letzten wöchentlichen
     Liedercharts des aktuellen Benutzers enthält.

   - ``userGetPreviousWeeklyArtistChart($fromDate, $toDate)``: Gibt ein SimpleXML Objekt zurück das die
     wöchentliche Artistencharts von ``$fromDate`` bis ``$toDate`` für den aktuellen Benutzer enthält.

   - ``userGetPreviousWeeklyAlbumChart($fromDate, $toDate)``: Gibt ein SimpleXML Objekt zurück das die
     wöchentlichen Albumcharts von ``$fromDate`` bis ``$toDate`` für den aktuellen Benutzer enthält.

   - ``userGetPreviousWeeklyTrackChart($fromDate, $toDate)``: Gibt ein SimpleXML Objekt zurück das die
     wöchentlichen Liedercharts von ``$fromDate`` bis ``$toDate`` für den aktuellen Benutzer enthält.



.. _zend.service.audioscrobbler.users.example.profile_information:

.. rubric:: Informationen von Benutzerprofilen erhalten

In diesem Beispiel werden die ``setUser()`` und ``userGetProfileInformation()`` Methoden verwendet um Informationen
über ein spezielles Benutzerprofil zu erhalten:

.. code-block:: php
   :linenos:

   $as = new Zend_Service_Audioscrobbler();
   // Den Benutzer setzen dessen Profilinformationen man empfangen will
   $as->setUser('BigDaddy71');
   // Informationen von BigDaddy71's Profil erhalten
   $profileInfo = $as->userGetProfileInformation();
   // Einige von Ihnen darstellen
   print "Informationen für $profileInfo->realname können unter "
       . "$profileInfo->url gefunden werden";

.. _zend.service.audioscrobbler.users.example.weekly_artist_chart:

.. rubric:: Die wöchentlichen Artistencharts eines Benutzers erhalten

.. code-block:: php
   :linenos:

   $as = new Zend_Service_Audioscrobbler();
   // Den Benutzer setzen dessen wöchentliche Artistencharts man empfangen will
   $as->setUser('lo_fye');
   // Eine Liste von vorherigen Wochen erhalten in denen Chartdaten vorhanden sind
   $weeks = $as->userGetWeeklyChartList();
   if (count($weeks) < 1) {
       echo 'Keine Daten vorhanden';
   }
   sort($weeks); // Die Liste der Wochen sortieren

   $as->setFromDate($weeks[0]); // Das Startdatum setzen
   $as->setToDate($weeks[0]); // Das Enddatum setzen

   $previousWeeklyArtists = $as->userGetPreviousWeeklyArtistChart();

   echo 'Artisten Chart für Woche '
      . date('Y-m-d h:i:s', $as->from_date)
      . '<br />';

   foreach ($previousWeeklyArtists as $artist) {
       // Artistennamen mit Links zu Ihrem Profil darstellen
       print '<a href="' . $artist->url . '">' . $artist->name . '</a><br />';
   }

.. _zend.service.audioscrobbler.artists:

Artisten
--------

``Zend_Service_Audioscrobbler`` bietet verschiedene Methoden um Daten über einen speziellen Artisten zu empfangen,
der über die ``setArtist()`` Methode spezifiziert wurde:



   - ``artistGetRelatedArtists()``: Gibt ein SimpleXML Objekt zurück das eine Liste von Artisten enthält die dem
     aktuellen Artisten ähnlich sind.

   - ``artistGetTopFans()``: Gibt ein SimpleXML Objekt zurück das eine Liste von Benutzern enthält die den
     aktuellen Artisten am meisten hören.

   - ``artistGetTopTracks()``: Gibt ein SimpleXML Objekt zurück das eine Liste der am meisten gewählten Lieder
     des aktuellen Artisten enthält.

   - ``artistGetTopAlbums()``: Gibt ein SimpleXML Objekt zurück das eine Liste der aktuell am meisten gewählten
     Alben des aktuellen Artisten enthält.

   - ``artistGetTopTags()``: Gibt ein SimpleXML Objekt zurück das eine Liste der Tags enthält die dem aktuellen
     Artisten am meisten zugeordnet werden.



.. _zend.service.audioscrobbler.artists.example.related_artists:

.. rubric:: Ähnliche Artisten erhalten

.. code-block:: php
   :linenos:

   $as = new Zend_Service_Audioscrobbler();
   // Den Artisten setzen für den man ähnliche Artisten bekommen will
   $as->setArtist('LCD Soundsystem');
   // Ähnliche Artisten erhalten
   $relatedArtists = $as->artistGetRelatedArtists();
   foreach ($relatedArtists as $artist) {
       // Die ähnlichen Artisten anzeigen
       print '<a href="' . $artist->url . '">' . $artist->name . '</a><br />';
   }

.. _zend.service.audioscrobbler.tracks:

Lieder
------

``Zend_Service_Audioscrobbler`` bietet zwei Methoden für das Empfangen von Daten für ein einzelnes Lied, das
über die ``setTrack()`` Methode spezifiziert wurde:



   - ``trackGetTopFans()``: Gibt ein SimpleXML Objekt zurück das eine Liste mit den Benutzern enthält die das
     aktuelle Lied am meisten gehört haben.

   - ``trackGetTopTags()``: Gibt ein SimpleXML Objekt zurück das eine Liste der Tags enthält die dem aktuellen
     Tag am meisten hinzugefügt werden.



.. _zend.service.audioscrobbler.tags:

Tags
----

``Zend_Service_Audioscrobbler`` bietet verschiedene Methoden für das Empfangen von Daten die einem einzelnen Tag
zugeordnet sind, welches über die ``setTag()`` Methode zugeordnet werden:



   - ``tagGetOverallTopTags()``: Gibt ein SimpleXML Objekt zurück das eine Liste von Tags enthält die am meisten
     in Audioscrobbler verwendet werden.

   - ``tagGetTopArtists()``: Gibt ein SimpleXML Objekt zurück das eine Liste von Artisten enthält denen das
     aktuelle Tag am meisten zugeordnet wurden.

   - ``tagGetTopAlbums()``: Gibt ein SimpleXML Objekt zurück das eine Liste von Alben enthält die dem aktuellen
     Tag am meisten zugeordnet wurden.

   - ``tagGetTopTracks()``: Gibt ein SimpleXML Objekt zurück das eine Liste von Liedern enthält die dem aktuellen
     Tag am meisten zugeordnet wurden.



.. _zend.service.audioscrobbler.groups:

Gruppen
-------

``Zend_Service_Audioscrobbler`` bietet verschiedene Methoden um Daten zu erhalten die einer speziellen Gruppe
gehören, die über die ``setGroup()`` Methode zugeordnet wurde:



   - ``groupGetRecentJournals()``: Gibt ein SimpleXML Objekt zurück das eine Liste der letzten Journalbeiträge
     der Benutzer der aktuellen Gruppe enthält.

   - ``groupGetWeeklyChart()``: Gibt ein SimpleXML Objekt zurück das eine Liste der Wochen enthält für die ein
     wöchentliches Chart der aktuellen Gruppe existiert.

   - ``groupGetRecentWeeklyArtistChart()``: Gibt ein SimpleXML Objekt zurück das die letzten wöchentlichen
     Artistencharts der aktuellen Gruppe enthält.

   - ``groupGetRecentWeeklyAlbumChart()``: Gibt ein SimpleXML Objekt zurück das die letzten wöchentlichen
     Albumcharts der aktuellen Gruppe enthält.

   - ``groupGetRecentWeeklyTrackChart()``: Gibt ein SimpleXML Objekt zurück das die letzten wöchentlichen
     Liedercharts der aktuellen Gruppe enthält.

   - ``groupGetPreviousWeeklyArtistChart($fromDate, $toDate)``: Erfordert ``setFromDate()`` und ``setToDate()``.
     Gibt ein SimpleXML Objekt zurück das die wöchentlichen Artistencharts vom aktuellen fromDate bis zum
     aktuellen toDate der aktuellen Gruppe enthält.

   - ``groupGetPreviousWeeklyAlbumChart($fromDate, $toDate)``: Erfordert ``setFromDate()`` und ``setToDate()``.
     Gibt ein SimpleXML Objekt zurück das die wöchentlichen Albumcharts vom aktuellen fromDate bis zum aktuellen
     toDate der aktuellen Gruppe enthält.

   - ``groupGetPreviousWeeklyTrackChart($fromDate, $toDate)``: Gibt ein SimpleXML Objekt zurück das die
     wöchentlichen Liedercharts vom aktuellen fromDate bis zum aktuellen toDate für die aktuelle Gruppe enthält.



.. _zend.service.audioscrobbler.forums:

Foren
-----

``Zend_Service_Audioscrobbler`` bietet eine Methode für das Empfangen von Daten eines einzelnen Forums, das über
die ``setForum()`` Methode spezifiziert wurde:



   - ``forumGetRecentPosts()``: Gibt ein SimpleXML Objekt zurück das eine Liste der letzten Beiträge im aktuellen
     Forum enthält.





.. _`Audioscrobbler Web Service Seite`: http://www.audioscrobbler.net/data/webservices/
