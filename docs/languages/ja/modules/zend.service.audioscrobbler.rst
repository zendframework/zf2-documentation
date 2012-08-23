.. EN-Revision: none
.. _zend.service.audioscrobbler:

Zend_Service_Audioscrobbler
===========================

.. _zend.service.audioscrobbler.introduction:

導入
--

``Zend_Service_Audioscrobbler`` は、Audioscrobbler REST ウェブサービス
を使用するためのシンプルな *API* です。Audioscrobbler Web Service は、ユーザ (Users)
やアーティスト (Artists)、アルバム (Albums)、曲 (Tracks)、 タグ (Tags)、グループ (Groups)
そしてフォーラム (Forums) といったデータへの アクセス機能を提供します。
``Zend_Service_Audioscrobbler`` クラスのメソッドは、
これらの単語のいずれかで始まります。Audioscrobbler Web Service
の文法および名前空間が、 ``Zend_Service_Audioscrobbler``
にまとめられています。Audioscrobbler REST ウェブサービスについての詳細は `Audioscrobbler
Web Service のサイト`_ を参照ください。

.. _zend.service.audioscrobbler.users:

ユーザ (Users)
-----------

特定のユーザについての情報を取得するには、 まず ``setUser()`` メソッドを使用して
データを取得したいユーザを選択します。 ``Zend_Service_Audioscrobbler`` では、
指定したユーザについての情報を取得するためのいくつかのメソッドを提供しています。


   - ``userGetProfileInformation()``: 現在のユーザのプロファイル情報を含む SimpleXML
     オブジェクトを返します。

   - ``userGetTopArtists()``: 現在のユーザが一番よく聴いているアーティストの一覧を含む
     SimpleXML オブジェクトを返します。

   - ``userGetTopAlbums()``: 現在のユーザが一番よく聴いているアルバムの一覧を含む
     SimpleXML オブジェクトを返します。

   - ``userGetTopTracks()``: 現在のユーザが一番よく聴いている曲の一覧を含む SimpleXML
     オブジェクトを返します。

   - ``userGetTopTags()``: 現在のユーザが一番よく指定しているタグの一覧を含む SimpleXML
     オブジェクトを返します。

   - ``userGetTopTagsForArtist()``: アーティストを ``setArtist()``
     で設定している必要があります。
     現在のユーザが、そのアーティストに対して一番よく指定しているタグを含む
     SimpleXML オブジェクトを返します。

   - ``userGetTopTagsForAlbum()``: アルバムを ``setAlbum()`` で設定している必要があります。
     現在のユーザが、そのアルバムに対して一番よく指定しているタグを含む SimpleXML
     オブジェクトを返します。

   - ``userGetTopTagsForTrack()``: 曲を ``setTrack()`` で設定している必要があります。
     現在のユーザが、その曲に対して一番よく指定しているタグを含む SimpleXML
     オブジェクトを返します。

   - ``userGetFriends()``: 現在のユーザの友人のユーザ名を含む SimpleXML
     オブジェクトを返します。

   - ``userGetNeighbours()``: 現在のユーザと同じようなものを聴いているユーザ名を含む
     SimpleXML オブジェクトを返します。

   - ``userGetRecentTracks()``: 現在のユーザが最近聴いた 10 曲の情報を含む SimpleXML
     オブジェクトを返します。

   - ``userGetRecentBannedTracks()``: 現在のユーザが最近拒否した 10 曲の一覧を含む SimpleXML
     オブジェクトを返します。

   - ``userGetRecentLovedTracks()``: 現在のユーザが最近お気に入りにした 10 曲の一覧を含む
     SimpleXML オブジェクトを返します。

   - ``userGetRecentJournals()``: 現在のユーザの直近の記事エントリの一覧を含む SimpleXML
     オブジェクトを返します。

   - ``userGetWeeklyChartList()``: 現在のユーザの週間チャートが存在する週の一覧を含む
     SimpleXML オブジェクトを返します。

   - ``userGetRecentWeeklyArtistChart()``:
     現在のユーザの直近の週間アーティストチャートを含む SimpleXML
     オブジェクトを返します。

   - ``userGetRecentWeeklyAlbumChart()``: 現在のユーザの直近の週間アルバムチャートを含む
     SimpleXML オブジェクトを返します。

   - ``userGetRecentWeeklyTrackChart()``: 現在のユーザの直近の週間曲チャートを含む SimpleXML
     オブジェクトを返します。

   - ``userGetPreviousWeeklyArtistChart($fromDate, $toDate)``: 現在のユーザの *$fromDate* から *$toDate*
     までの週間アーティストチャートを含む SimpleXML オブジェクトを返します。

   - ``userGetPreviousWeeklyAlbumChart($fromDate, $toDate)``: 現在のユーザの *$fromDate* から *$toDate*
     までの週間アルバムチャートを含む SimpleXML オブジェクトを返します。

   - ``userGetPreviousWeeklyTrackChart($fromDate, $toDate)``: 現在のユーザの *$fromDate* から *$toDate*
     までの週間曲チャートを含む SimpleXML オブジェクトを返します。



.. _zend.service.audioscrobbler.users.example.profile_information:

.. rubric:: ユーザのプロファイル情報の取得

この例では、 ``setUser()`` メソッドおよび ``userGetProfileInformation()``
メソッドを使用して、 指定したユーザのプロファイル情報を取得します。

.. code-block:: php
   :linenos:

   $as = new Zend_Service_Audioscrobbler();
   // プロファイル情報を取得したいユーザを設定します
   $as->setUser('BigDaddy71');
   // BigDaddy71 のプロファイル情報を取得します
   $profileInfo = $as->userGetProfileInformation();
   // その一部を表示します
   print "$profileInfo->realname の情報は "
       . "$profileInfo->url にあります";

.. _zend.service.audioscrobbler.users.example.weekly_artist_chart:

.. rubric:: あるユーザの週間アーティストチャートの取得

.. code-block:: php
   :linenos:

   $as = new Zend_Service_Audioscrobbler();
   // 週間アーティストチャートを取得したいユーザを設定します
   $as->setUser('lo_fye');
   // チャートデータが存在する、過去の一覧を取得します
   $weeks = $as->userGetWeeklyChartList();
   if (count($weeks) < 1) {
       echo 'データが存在しません';
   }
   sort($weeks); // 週のリストを並べ替えます

   $as->setFromDate($weeks[0]); // 開始日を設定します
   $as->setToDate($weeks[0]); // 終了日を設定します

   $previousWeeklyArtists = $as->userGetPreviousWeeklyArtistChart();

   echo '週間アーティストチャート '
      . date('Y-m-d h:i:s', $as->from_date)
      . '<br />';

   foreach ($previousWeeklyArtists as $artist) {
       // アーティスト名と、プロファイルへのリンクを表示します
       print '<a href="' . $artist->url . '">' . $artist->name . '</a><br />';
   }

.. _zend.service.audioscrobbler.artists:

アーティスト (Artists)
----------------

``Zend_Service_Audioscrobbler`` は、 ``setArtist()``
で指定した特定のアーティストに関するデータを取得するためのいくつかのメソッドを提供しています。


   - ``artistGetRelatedArtists()``: 現在のアーティストと似たアーティストの一覧を含む
     SimpleXML オブジェクトを返します。

   - ``artistGetTopFans()``: 現在のアーティストを最もよく聴いているユーザの一覧を含む
     SimpleXML オブジェクトを返します。

   - ``artistGetTopTracks()``: 現在のアーティストの、高評価の曲の一覧を含む SimpleXML
     オブジェクトを返します。

   - ``artistGetTopAlbums()``: 現在のアーティストの、高評価のアルバムの一覧を含む
     SimpleXML オブジェクトを返します。

   - ``artistGetTopTags()``: 現在のアーティストによく指定されているタグの一覧を含む
     SimpleXML オブジェクトを返します。



.. _zend.service.audioscrobbler.artists.example.related_artists:

.. rubric:: 関連するアーティストの取得

.. code-block:: php
   :linenos:

   $as = new Zend_Service_Audioscrobbler();
   // 関連アーティストを取得したいアーティストを設定します
   $as->setArtist('LCD Soundsystem');
   // 関連アーティストを取得します
   $relatedArtists = $as->artistGetRelatedArtists();
   foreach ($relatedArtists as $artist) {
       // 関連アーティストを表示します
       print '<a href="' . $artist->url . '">' . $artist->name . '</a><br />';
   }

.. _zend.service.audioscrobbler.tracks:

曲 (Tracks)
----------

``Zend_Service_Audioscrobbler`` は、 ``setTrack()``
メソッドで指定した曲についてのデータを取得する、ふたつのメソッドを提供しています。


   - ``trackGetTopFans()``: 現在の曲を最もよく聴いているユーザの一覧を含む SimpleXML
     オブジェクトを返します。

   - ``trackGetTopTags()``: 現在の曲に最もよく適用されているタグの一覧を含む SimpleXML
     オブジェクトを返します。



.. _zend.service.audioscrobbler.tags:

タグ (Tags)
---------

``Zend_Service_Audioscrobbler`` は、 ``setTag()``
メソッドで指定したタグに関するデータを取得するためのいくつかのメソッドを提供しています。


   - ``tagGetOverallTopTags()``: Audioscrobbler で最もよく使用されているタグの一覧を含む
     SimpleXML オブジェクトを返します。

   - ``tagGetTopArtists()``:
     現在のタグが最もよく適用されているアーティストの一覧を含む SimpleXML
     オブジェクトを返します。

   - ``tagGetTopAlbums()``: 現在のタグが最もよく適用されているアルバムの一覧を含む
     SimpleXML オブジェクトを返します。

   - ``tagGetTopTracks()``: 現在のタグが最もよく適用されている曲の一覧を含む SimpleXML
     オブジェクトを返します。



.. _zend.service.audioscrobbler.groups:

グループ (Groups)
-------------

``Zend_Service_Audioscrobbler`` は、 ``setGroup()``
メソッドで指定したグループに関するデータを取得するためのいくつかのメソッドを提供しています。


   - ``groupGetRecentJournals()``: 現在のグループのユーザが最近投稿した記事の一覧を含む
     SimpleXML オブジェクトを返します。

   - ``groupGetWeeklyChart()``: 現在のグループの週間チャートが存在する週の一覧を含む
     SimpleXML オブジェクトを返します。

   - ``groupGetRecentWeeklyArtistChart()``:
     現在のグループの直近の週間アーティストチャートを含む SimpleXML
     オブジェクトを返します。

   - ``groupGetRecentWeeklyAlbumChart()``: 現在のグループの直近の週間アルバムチャートを含む
     SimpleXML オブジェクトを返します。

   - ``groupGetRecentWeeklyTrackChart()``: 現在のグループの直近の週間曲チャートを含む
     SimpleXML オブジェクトを返します。

   - ``groupGetPreviousWeeklyArtistChart($fromDate, $toDate)``: ``setFromDate()`` および ``setToDate()``
     が必要です。現在のグループの、fromDate から toDate
     までの週間アーティストチャートを含む SimpleXML オブジェクトを返します。

   - ``groupGetPreviousWeeklyAlbumChart($fromDate, $toDate)``: ``setFromDate()`` および ``setToDate()``
     が必要です。現在のグループの、fromDate から toDate
     までの週間アルバムチャートを含む SimpleXML オブジェクトを返します。

   - ``groupGetPreviousWeeklyTrackChart($fromDate, $toDate)``: 現在のグループの、fromDate から toDate
     までの週間曲チャートを含む SimpleXML オブジェクトを返します。



.. _zend.service.audioscrobbler.forums:

フォーラム (Forums)
--------------

``Zend_Service_Audioscrobbler`` は、 ``setForum()``
メソッドで指定した特定のフォーラムの情報を取得するメソッドを提供しています。

   - ``forumGetRecentPosts()``: 現在のフォーラムの最近の投稿一覧を含む SimpleXML
     オブジェクトを返します。





.. _`Audioscrobbler Web Service のサイト`: http://www.audioscrobbler.net/data/webservices/
