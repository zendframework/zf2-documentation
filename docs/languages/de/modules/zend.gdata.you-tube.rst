.. EN-Revision: none
.. _zend.gdata.youtube:

Verwenden der YouTube Daten API
===============================

Die YouTube Daten *API* bietet einen Lese- und Schreibzugriff auf YouTube Inhalte. Benutzer können nicht
authentifizierte Anfragen zu Google Daten Feeds durchführen um Feeds von populären Videos, Kommentare,
öffentliche Informationen über YouTube Benutzerprofilen, Benutzer PlayListen, Favoriten, Einschreibungen und so
weiter zu erhalten.

Für weitere Informationen über die YouTube Daten *API* schauen Sie in die offizielle `PHP Entwickler
Dokumentation`_ auf code.google.com.

.. _zend.gdata.youtube.authentication:

Authentifizierung
-----------------

Die YouTube Daten *API* erlaubt aktuell einen nur-lesenden Zugriff auf öffentliche Daten, welcher keine
Authentifizierung benötigt. Für alle schreibenden Anfragen muß sich ein Benutzer entweder mit ClientLogin oder
AuthSub authentifizieren. Schauen Sie bitte in das `Kapitel über Authentifizierung in der PHP Entwickler
Dokumentation`_ für weitere Details.

.. _zend.gdata.youtube.developer_key:

Entwickler Schlüssel und Client ID
----------------------------------

Ein Entwickler Schlüssel identifiziert den QouTube Entwickler der die *API* Anfrage schickt. Eine Client ID
identifiziert die Anwendung für Logging und Debugging Zwecke. Schauen Sie bitte auf
`http://code.google.com/apis/youtube/dashboard/`_ um einen Entwickler Schlüssel und eine Client ID zu erhalten.
Das angefügte Beispiel demonstriert wie der Entwickler Schlüssel und die Client ID an das `ZendGData\YouTube`_
Service Pbjekt übergeben werden.

.. _zend.gdata.youtube.developer_key.example:

.. rubric:: Einen Entwicklerschlüssel und eine ClientID an ZendGData\YouTube übergeben

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube($httpClient,
                                $applicationId,
                                $clientId,
                                $developerKey);

.. _zend.gdata.youtube.videos:

Öffentliche Video Feeds empfangen
---------------------------------

Die YouTube Daten *API* bietet eine Vielzahl von Feeds die eine Liste von Videos zurückgeben, wie zum Beispiel
Standard Feeds, Abhängige Videos, Antworten auf Videos, Videobewertungen, Benutzer Uploads, und Benutzer
Favoriten. Zum Beispiel gibt der Benutzer Upload Feed alle Videos zurück die von einem speziellen Benutzer
hochgeladen wurden. Sehen Sie in den `You Tube API Referenz Guide`_ für eine detailierte Liste aller vorhandenen
Feeds.

.. _zend.gdata.youtube.videos.searching:

Suchen nach Videos durch Metadaten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Man kann eine Liste von Videos erhalten die einem speziellen Suchkriterium entsprechen, indem die YouTubeQuery
Klasse verwendet wird. Die folgende Abfrage schaut nach Videos welche das Wort "Katze" in Ihren Metadaten
enthalten, beginnend mit dem 10ten Video und 20 Videos pro Seite anzeigt, sortiert nach der Anzahl der Ansichten.

.. _zend.gdata.youtube.videos.searching.example:

.. rubric:: Suchen nach Videos

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
       echo "Titel: " . $videoEntry->mediaGroup->title->text . "\n";
       echo "\nBeschreibung:\n";
       echo $videoEntry->mediaGroup->description->text;
       echo "\n\n\n";
   }

Für weitere Details über die verschiedenen Abfrageparameter, kann der `Referenz Guide`_ hilfreich sein. Die
vorhandenen Hilfsfunktionen in `ZendGData_YouTube\VideoQuery`_ für jeden dieser Parameter werden im `PHP
Entwickler Guide`_ detailierter beschrieben.

.. _zend.gdata.youtube.videos.searchingcategories:

Suchen nach Videos durch Kategorien und Tags/Schlüsselwörter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Suche nach Videos in speziellen Kategorien wird durch die Erstellung einer `speziell formatierten URL`_
durchgeführt. Um, zum Beispiel, nach Komödien-Videos zu suchen die das Schlüsselwort Hund enthalten:

.. _zend.gdata.youtube.videos.searchingcategories.example:

.. rubric:: Suchen nach Videos in speziellen Kategorien

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $query = $yt->newVideoQuery();
   $query->category = 'Comedy/Hund';

   echo $query->queryUrl . "\n";
   $videoFeed = $yt->getVideoFeed($query);

.. _zend.gdata.youtube.videos.standard:

Standard Feeds empfangen
^^^^^^^^^^^^^^^^^^^^^^^^

Die YouTube Daten *API* hat eine Anzahl an `Standard Feeds`_. Diese Standard Feeds können als
`ZendGData_YouTube\VideoFeed`_ Objekte empfangen werden indem die spezifizierten *URL*\ s und die in der
`ZendGData\YouTube`_ Klasse vordefinierten Konstanten (zum Beispiel ZendGData\YouTube::STANDARD_TOP_RATED_URI)
oder die vordefinierten Hilfsmethoden verwendet verwendet werden (siehe das Codebeispiel anbei).

Um die Top gereihten Videos zu erhalten kann die folgende Helfermethode verwendet werden:

.. _zend.gdata.youtube.videos.standard.example-1:

.. rubric:: Empfangen eines Standard Videofeeds

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $videoFeed = $yt->getTopRatedVideoFeed();

Es gibt auch Abfrageparameter um eine Zeitperiode zu spezifizieren über die der Standardfeed berechnet wird.

Um zum Beispiel die Top gereihten Videos von Heute zu erhalten:

.. _zend.gdata.youtube.videos.standard.example-2:

.. rubric:: Verwenden von ZendGData_YouTube\VideoQuery um Videos zu empfangen

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $query = $yt->newVideoQuery();
   $query->setTime('today');
   $videoFeed = $yt->getTopRatedVideoFeed($query);

Alternativ kann man den Feed erhalten indem die *URL* verwendet wird:

.. _zend.gdata.youtube.videos.standard.example-3:

.. rubric:: Empfangen eines Video Feeds durch die URL

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $url = 'http://gdata.youtube.com/feeds/standardfeeds/top_rated?time=today'
   $videoFeed = $yt->getVideoFeed($url);

.. _zend.gdata.youtube.videos.user:

Videos erhalten die von einem Benutzer hochgeladen wurden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Man kann eine Liste von Videos erhalten die von einem bestimmten Benutzer hochgeladen wurden indem eine einfache
Helfermethode verwendet wird. Dieses Beispiel empfängt Videos die vom Benutzer 'liz' hochgeladen wurden.

.. _zend.gdata.youtube.videos.user.example:

.. rubric:: Empfangen von Videos die von einem spezifischen Benutzer hochgeladen wurden

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $videoFeed = $yt->getUserUploads('liz');

.. _zend.gdata.youtube.videos.favorites:

Videos empfangen die von einem Benutzer bevorzugt werden
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Man kann eine Liste von bevorzugten Videos eines Benutzer erhalten indem eine einfache Helfermethode verwendet
wird. Dieses Beispiel empfängt Videos die vom Benutzer 'liz' bevorzugt werden.

.. _zend.gdata.youtube.videos.favorites.example:

.. rubric:: Empfangen von den bevorzugten Videos eines Benutzers

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $videoFeed = $yt->getUserFavorites('liz');

.. _zend.gdata.youtube.videos.responses:

Videobewertungen für ein Video erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Man kann eine Liste von Videobewertungen eines Videos erhalten indem eine einfache Helfermethode verwendet wird.
Dieses Beispiel empfängt Videobewertungen für ein Video mit der ID 'abc123813abc'.

.. _zend.gdata.youtube.videos.responses.example:

.. rubric:: Empfangen eines Feeds von Video Antworten

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $videoFeed = $yt->getVideoResponseFeed('abc123813abc');

.. _zend.gdata.youtube.comments:

Videokommentare erhalten
------------------------

Die Kommentare für jedes YouTube Video können auf unterschiedlichen Wegen empfangen werden. Um die Kommentare
für das Video mit der ID 'abc123813abc' zu empfangen kann der folgende Code verwendet werden:

.. _zend.gdata.youtube.videos.comments.example-1:

.. rubric:: Empfangen eines Feeds von Videokommentaren von einer Video ID

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $commentFeed = $yt->getVideoCommentFeed('abc123813abc');

   foreach ($commentFeed as $commentEntry) {
       echo $commentEntry->title->text . "\n";
       echo $commentEntry->content->text . "\n\n\n";
   }

Kommentare können für ein Video auch empfangen werden wenn man eine Kopie des `ZendGData_YouTube\VideoEntry`_
Objektes hat:

.. _zend.gdata.youtube.videos.comments.example-2:

.. rubric:: Empfangen eines Feeds von Videokommentaren von einem ZendGData_YouTube\VideoEntry

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $videoEntry = $yt->getVideoEntry('abc123813abc');
   // Die ID des Videos in diesem Beispiel ist unbekannt, aber wir haben die URL
   $commentFeed = $yt->getVideoCommentFeed(null,
                                           $videoEntry->comments->href);

.. _zend.gdata.youtube.playlists:

PlayList Feeds erhalten
-----------------------

Die YouTube Daten *API* bietet Informationen über Benutzer, inklusive Profile, PlayListen, Einschreibungen, und
weitere.

.. _zend.gdata.youtube.playlists.user:

Die PlayListen eines Benutzer erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Bibliothek bietet eine Helfermethode um die PlayListen, die einem angegebenen Benutzer zugeordnet sind, zu
erhalten. Um die PlayListen des Benutzers 'liz' zu erhalten kann der folgende Code verwendet werden:

.. _zend.gdata.youtube.playlists.user.example:

.. rubric:: Empfangen von Playlisten eines Benutzers

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $playlistListFeed = $yt->getPlaylistListFeed('liz');

   foreach ($playlistListFeed as $playlistEntry) {
       echo $playlistEntry->title->text . "\n";
       echo $playlistEntry->description->text . "\n";
       echo $playlistEntry->getPlaylistVideoFeedUrl() . "\n\n\n";
   }

.. _zend.gdata.youtube.playlists.special:

Eine spezielle PlayListe erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Bibliothek bietet eine Helfermethode um Videos zu erhalten die mit einer gegebenen PlayListe assoziiert sind.
Um die PlayListe für einen speziellen PlayList Eintrag zu erhalten kann der folgende Code verwendet werden:

.. _zend.gdata.youtube.playlists.special.example:

.. rubric:: Empfangen von speziellen Playlisten

.. code-block:: php
   :linenos:

   $feedUrl = $playlistEntry->getPlaylistVideoFeedUrl();
   $playlistVideoFeed = $yt->getPlaylistVideoFeed($feedUrl);

.. _zend.gdata.youtube.subscriptions:

Eine Liste von Einschreibungen eines Benutzers erhalten
-------------------------------------------------------

Ein Benutzer kann verschiedene Arten von Einschreibungen besitzen: Kanal Einschreibungen, Tag Einschreibungen, oder
Favoriten Einschreibungen. Ein `ZendGData_YouTube\SubscriptionEntry`_ wird verwendet um individuelle
Einschreibungen zu repräsentieren.

Um alle Einschreibungen für den Benutzer 'liz' zu erhalten kann der folgende Code verwendet werden:

.. _zend.gdata.youtube.subscriptions.example:

.. rubric:: Empfangen aller Einschreibungen eines Benutzers

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $subscriptionFeed = $yt->getSubscriptionFeed('liz');

   foreach ($subscriptionFeed as $subscriptionEntry) {
       echo $subscriptionEntry->title->text . "\n";
   }

.. _zend.gdata.youtube.profile:

Ein Benutzerprofil erhalten
---------------------------

Die öffentlichen Profil Informationen kann man für jeden YouTube Benutzer erhalten. Um das Profil für den
Benutzer 'liz' zu erhalten kann der folgende Code verwendet werden:

.. _zend.gdata.youtube.profile.example:

.. rubric:: Empfangen des Profils eines Benutzers

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube();
   $userProfile = $yt->getUserProfile('liz');
   echo "Benutzername: " . $userProfile->username->text . "\n";
   echo "Alter: " . $userProfile->age->text . "\n";
   echo "Heimatstadt: " . $userProfile->hometown->text . "\n";

.. _zend.gdata.youtube.uploads:

Videos auf YouTube hochladen
----------------------------

Stellen Sie sicher das Sie die Diagramme im `Protokoll Guide`_ auf code.google.com für eine Übersicht des Upload
Prozesses betrachtet haben. Das Hochladen von Videos kann auf 2 Wegen durchgeführt werden: Entweder durch das
direkte Hochladen des Videos oder durch das Senden der Video Meta-Daten und indem der Benutzer das Video über ein
*HTML* Formular hochlädt.

Um ein Video direkt hochzuladen, muß zuerst ein neues `ZendGData_YouTube\VideoEntry`_ Objekt erstellt und einige
benötigte Meta-Daten spezifiziert werden. Das folgende Beispiel zeigt das Hochladen des Quicktime Videos
"mytestmovie.mov" auf YouTube mit den folgenden Eigenschaften:

.. _zend.gdata.youtube.uploads.metadata:

.. table:: Metadaten die im folgenden Code-Beispiel verwendet werden

   +--------------+-----------------------------------+
   |Eigenschaft   |Wert                               |
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

Der folgende Code erzeugt einen leeren `ZendGData_YouTube\VideoEntry`_ der Hochgeladen werden kann. Ein
`ZendGData_App\MediaFileSource`_ wird dann verwendet um die aktuelle Video Datei zu speichern. Unter der Hand wird
ein `ZendGData\YouTube\Extension\MediaGroup`_ Objekt verwendet um alle Metadaten des Videos zu speichern. Die
anbei beschriebenen Helfermethoden erlauben es die Metadaten des Videos zu setzen ohne das man sich um das Medien
Gruppen Objekt kümmern muß. $uploadUrl ist der Ort an den der neue Eintrag gepostet wird. Er kann entweder durch
$userName des aktuell authentifizierten Benutzers spezifiziert werden, oder, alternativ indem einfach der String
'default' verwendet wird um auf den aktuell authentifizierten Benutzer zu verweisen.

.. _zend.gdata.youtube.uploads.example:

.. rubric:: Ein Video hochladen

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube($httpClient);
   $myVideoEntry = new ZendGData_YouTube\VideoEntry();

   $filesource = $yt->newMediaFileSource('mytestmovie.mov');
   $filesource->setContentType('video/quicktime');
   $filesource->setSlug('mytestmovie.mov');

   $myVideoEntry->setMediaSource($filesource);

   $myVideoEntry->setVideoTitle('My Test Movie');
   $myVideoEntry->setVideoDescription('My Test Movie');
   // Beachte das category eine gültige YouTube Kategorie sein muß !
   $myVideoEntry->setVideoCategory('Comedy');

   // Setzt Keywords, beachte das es ein Komma getrennter String ist
   // und das keines der Schlüsselwörter ein Leerzeichen enthalten darf
   $myVideoEntry->SetVideoTags('cars, funny');

   // Optional Entwickler Tags setzen
   $myVideoEntry->setVideoDeveloperTags(array('mydevelopertag',
                                              'anotherdevelopertag'));

   // Optional den Ort des Videos setzen
   $yt->registerPackage('ZendGData\Geo');
   $yt->registerPackage('ZendGData_Geo\Extension');
   $where = $yt->newGeoRssWhere();
   $position = $yt->newGmlPos('37.0 -122.0');
   $where->point = $yt->newGmlPoint($position);
   $myVideoEntry->setWhere($where);

   // URI hochladen für den aktuell authentifizierten Benutzer
   $uploadUrl =
       'http://uploads.gdata.youtube.com/feeds/users/default/uploads';

   // Versuch das Video hochzuladen, eine ZendGData_App\HttpException fangen wenn
   // Sie vorhanden ist oder nur eine reguläre ZendGData_App\Exception

   try {
       $newEntry = $yt->insertEntry($myVideoEntry,
                                    $uploadUrl,
                                    'ZendGData_YouTube\VideoEntry');
   } catch (ZendGData_App\HttpException $httpException) {
       echo $httpException->getRawResponseBody();
   } catch (ZendGData_App\Exception $e) {
       echo $e->getMessage();
   }

Um ein Video als privat hochzuladen muß einfach $myVideoEntry->setVideoPrivate(); verwendet werden; bevor das
Hochladen durchgeführt wird. $videoEntry->isVideoPrivate() kann verwendet werden um zu prüfen ob ein Video
Eintrag privat ist oder nicht.

.. _zend.gdata.youtube.uploads.browser:

Browser-basierender Upload
--------------------------

Browser-basierendes hochladen wird fast auf die gleiche Weise durchgeführt wie direktes Hochladen, ausser das man
kein `ZendGData_App\MediaFileSource`_ Objekt an den `ZendGData_YouTube\VideoEntry`_ anhängt den man erstellt.
Stattdessen überträgt man einfach alle Metadaten des Videos um ein Token Element zurück zu erhalten welches
verwendet werden kann um ein *HTML* Upload Formular zu erstellen.

.. _zend.gdata.youtube.uploads.browser.example-1:

.. rubric:: Browser-basierender Upload

.. code-block:: php
   :linenos:

   $yt = new ZendGData\YouTube($httpClient);

   $myVideoEntry= new ZendGData_YouTube\VideoEntry();
   $myVideoEntry->setVideoTitle('My Test Movie');
   $myVideoEntry->setVideoDescription('My Test Movie');

   // Beachte das die Kategorie eine gültige YouTube Kategorie sein muß !
   $myVideoEntry->setVideoCategory('Comedy');
   $myVideoEntry->SetVideoTags('cars, funny');

   $tokenHandlerUrl = 'http://gdata.youtube.com/action/GetUploadToken';
   $tokenArray = $yt->getFormUploadToken($myVideoEntry, $tokenHandlerUrl);
   $tokenValue = $tokenArray['token'];
   $postUrl = $tokenArray['url'];

Der obige Code gibt einen Link und ein Token aus das verwendet wird um ein *HTML* Formular zu erstellen und im
Browser des Benutzers anzuzeigen. Ein einfaches Beispielformular wird unten gezeigt mit $tokenValue welches den
Inhalt des zurückgegebenen Token Elements darstellt, welches wie gezeigt, oben von $myVideoEntry empfangen wird.
Damit der Benutzer, nachdem das Formular übermittelt wurde, auf die Website umgeleitet wird, muß ein $nextUrl
Parameter an die $postUrl von oben angehängt werden, was auf die gleiche Weise funktioniert wie der $next
Parameter eines AuthSub Links. Der einzige Unterschied ist hier das, statt eines einmal zu verwendenden Tokens, ein
Status und eine ID Variable in der *URL* zurückgegeben werden.

.. _zend.gdata.youtube.uploads.browser.example-2:

.. rubric:: Browser-basierender Upload: Erstellen des HTML Formulars

.. code-block:: php
   :linenos:

   // Platzieren um den Benutzer nach dem Upload umzuleiten
   $nextUrl = 'http://mysite.com/youtube_uploads';

   $form = '<form action="'. $postUrl .'?nexturl='. $nextUrl .
           '" method="post" enctype="multipart/form-data">'.
           '<input name="file" type="file"/>'.
           '<input name="token" type="hidden" value="'. $tokenValue .'"/>'.
           '<input value="Video Daten hochladen" type="submit" />'.
           '</form>';

.. _zend.gdata.youtube.uploads.status:

Den Upload Status prüfen
------------------------

Nachdem ein Video hochgeladen wurde, wird es im Upload Feed des authentifizierten Benutzer unmittelbar sichtbar
sein. Trotzdem wird es auf der Site nicht öffentlich sein solange es nicht bearbeitet wurde. Videos die
ausgeschlossen oder nicht erfolgreich hochgeladen wurden werden auch nur im Upload Feed des authentifizierten
Benutzers sichtbar sein. Der folgende Code prüft den Status eines `ZendGData_YouTube\VideoEntry`_ um zu sehen ob
er jetzt noch nicht live ist oder ob er nicht akzeptiert wurde.

.. _zend.gdata.youtube.uploads.status.example:

.. rubric:: Den Status von Video Uploads checken

.. code-block:: php
   :linenos:

   try {
       $control = $videoEntry->getControl();
   } catch (ZendGData_App\Exception $e) {
       echo $e->getMessage();
   }

   if ($control instanceof ZendGData\App\Extension\Control) {
       if ($control->getDraft() != null &&
           $control->getDraft()->getText() == 'yes') {
           $state = $videoEntry->getVideoState();

           if ($state instanceof ZendGData\YouTube\Extension\State) {
               print 'Upload Status: '
                     . $state->getName()
                     .' '. $state->getText();
           } else {
               print 'Die Status Informationen des Videos konnten bis jetzt nicht'
                   . ' empfangen werden. Bitte versuchen Sie es etwas später'
                   . ' nochmals.\n";
           }
       }
   }

.. _zend.gdata.youtube.other:

Andere Funktionen
-----------------

Zusätzlich zur oben beschriebenen Funktionalität, enthält die YouTube *API* viele andere Funktionen die es
erlauben Video Metadaten zu verändern, Video Einträge zu löschen und den kompletten Bereich an Community
Features der Site zu verwenden. Einige der Community Features die durch die *API* verändert werden können
enthalten: Ratings, Kommentare, Playlisten, Einschreibungen, Benutzer Profile, Kontakte und Nachrichten.

Bitte schauen Sie in die komplette Dokumentation die im `PHP Entwickler Guide`_ auf code.google.com zu finden ist.



.. _`PHP Entwickler Dokumentation`: http://code.google.com/apis/youtube/developers_guide_php.html
.. _`Kapitel über Authentifizierung in der PHP Entwickler Dokumentation`: http://code.google.com/apis/youtube/developers_guide_php.html#Authentication
.. _`http://code.google.com/apis/youtube/dashboard/`: http://code.google.com/apis/youtube/dashboard/
.. _`ZendGData\YouTube`: http://framework.zend.com/apidoc/core/ZendGData/ZendGData\YouTube.html
.. _`You Tube API Referenz Guide`: http://code.google.com/apis/youtube/reference.html#Video_Feeds
.. _`Referenz Guide`: http://code.google.com/apis/youtube/reference.html#Searching_for_videos
.. _`ZendGData_YouTube\VideoQuery`: http://framework.zend.com/apidoc/core/ZendGData/ZendGData_YouTube\VideoQuery.html
.. _`PHP Entwickler Guide`: http://code.google.com/apis/youtube/developers_guide_php.html
.. _`speziell formatierten URL`: http://code.google.com/apis/youtube/reference.html#Category_Search
.. _`Standard Feeds`: http://code.google.com/apis/youtube/reference.html#Standard_feeds
.. _`ZendGData_YouTube\VideoFeed`: http://framework.zend.com/apidoc/core/ZendGData/ZendGData_YouTube\VideoFeed.html
.. _`ZendGData_YouTube\VideoEntry`: http://framework.zend.com/apidoc/core/ZendGData/ZendGData_YouTube\VideoEntry.html
.. _`ZendGData_YouTube\SubscriptionEntry`: http://framework.zend.com/apidoc/core/ZendGData/ZendGData_YouTube\SubscriptionEntry.html
.. _`Protokoll Guide`: http://code.google.com/apis/youtube/developers_guide_protocol.html#Process_Flows_for_Uploading_Videos
.. _`ZendGData_App\MediaFileSource`: http://framework.zend.com/apidoc/core/ZendGData/ZendGData_App\MediaFileSource.html
.. _`ZendGData\YouTube\Extension\MediaGroup`: http://framework.zend.com/apidoc/core/ZendGData/ZendGData\YouTube\Extension\MediaGroup.html
