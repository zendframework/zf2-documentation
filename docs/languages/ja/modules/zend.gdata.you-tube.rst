.. _zend.gdata.youtube:

YouTube Data API の使用法
=====================

YouTube data *API* は、YouTube のコンテンツを読み書きする機能を提供します。
認証済みでないリクエストを Google Data フィードに実行し、
人気のある動画やコメント、YouTube 登録ユーザの公開情報
(たとえばプレイリストや購読内容、コンタクトなど) を取得できます。

YouTube Data *API* についての詳細は、code.google.com の `PHP Developer's Guide`_ を参照ください。

.. _zend.gdata.youtube.authentication:

認証
--

YouTube Data *API* は、公開データへの読み取り専用アクセス機能を提供しており、
認証は不要です。書き込みリクエストを行う場合は、ClientLogin あるいは AuthSub
でのユーザ認証が必要となります。詳細は `PHP Developer's Guide の認証のセクション`_
を参照ください。

.. _zend.gdata.youtube.developer_key:

Developer Keys および Client ID
----------------------------

デベロッパーキーは、 *API* リクエストを行う YouTube
開発者を識別するためのものです。クライアント ID
は、ログの記録やデバッグなどの際にアプリケーションを識別するものです。
`http://code.google.com/apis/youtube/dashboard/`_ でデベロッパーキーとクライアント ID
を取得できます。 下の例は、デベロッパーキーとクライアント ID を `Zend_Gdata_YouTube`_
サービスオブジェクトに渡すものです。

.. _zend.gdata.youtube.developer_key.example:

.. rubric:: Developer Key と ClientID を Zend_Gdata_YouTube に渡す

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube($httpClient,
                                $applicationId,
                                $clientId,
                                $developerKey);

.. _zend.gdata.youtube.videos:

公開動画フィードの取得
-----------

YouTube data *API* はさまざまなフィードを提供しており、
たとえば標準の動画一覧や関連する動画一覧、動画への返信一覧、
アップロードした動画の一覧、お気に入りの動画一覧などを取得できます。
たとえばアップロードした動画一覧のフィードは、
指定したユーザがアップロードしたすべての動画を返します。
どのようなフィードが取得できるのかについては `YouTube API リファレンスガイド`_
を参照ください。

.. _zend.gdata.youtube.videos.searching:

メタデータによる動画の検索
^^^^^^^^^^^^^

指定した条件にマッチする動画の一覧を、YouTubeQuery クラスを用いて取得できます。
たとえば次のクエリは、メタデータに "cat" という単語を含む動画を探し、
その結果の 10 番目から 1 ページあたり 20 件ずつ表示します。
また、閲覧回数順に表示します。

.. _zend.gdata.youtube.videos.searching.example:

.. rubric:: 動画の検索

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube();
   $query = $yt->newVideoQuery();
   $query->videoQuery = 'cat';
   $query->startIndex = 10;
   $query->maxResults = 20;
   $query->orderBy = 'viewCount';

   echo $query->queryUrl . "\n";
   $videoFeed = $yt->getVideoFeed($query);

   foreach ($videoFeed as $videoEntry) {
       echo "---------動画----------\n";
       echo "タイトル: " . $videoEntry->getVideoTitle() . "\n";
       echo "\n説明:\n";
       echo $videoEntry->getVideoDescription();
       echo "\n\n\n";
   }

その他のクエリパラメータの詳細は `リファレンスガイド`_\ を参照ください。
`Zend_Gdata_YouTube_VideoQuery`_
には、これらのパラメータ用のヘルパー関数もあります。詳細は `PHP Developer's Guide`_
を参照ください。

.. _zend.gdata.youtube.videos.searchingcategories:

カテゴリやタグ/キーワードによる動画の検索
^^^^^^^^^^^^^^^^^^^^^

カテゴリを指定して動画を検索するには、 `専用の URL を作成します`_\
。たとえば、dog
というキーワードを含むコメディーの動画を検索するには次のようにします。

.. _zend.gdata.youtube.videos.searchingcategories.example:

.. rubric:: 指定したカテゴリの動画の検索

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube();
   $query = $yt->newVideoQuery();
   $query->category = 'Comedy/dog';

   echo $query->queryUrl . "\n";
   $videoFeed = $yt->getVideoFeed($query);

.. _zend.gdata.youtube.videos.standard:

標準のフィード
^^^^^^^

YouTube Data *API* が提供する `標準フィード`_ にはさまざまなものがあります。
これらの標準フィードは、 *URL* を指定することで `Zend_Gdata_YouTube_VideoFeed`_
オブジェクトとして取得できます。 *URL* の指定には `Zend_Gdata_YouTube`_
クラスの定義済み定数 (たとえば Zend_Gdata_YouTube::STANDARD_TOP_RATED_URI)
を使用するか、あるいは定義済みヘルパーメソッド (下のコードを参照ください)
を使用します。

評価の高い動画を取得するヘルパーメソッドは次のようになります。

.. _zend.gdata.youtube.videos.standard.example-1:

.. rubric:: 標準の動画フィードの取得

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube();
   $videoFeed = $yt->getTopRatedVideoFeed();

取得する標準フィードの期間を指定するクエリパラメータもあります。

たとえば、今日いちばん評価の高い動画を取得するには次のようにします。

.. _zend.gdata.youtube.videos.standard.example-2:

.. rubric:: Zend_Gdata_YouTube_VideoQuery を使用した動画の取得

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube();
   $query = $yt->newVideoQuery();
   $query->setTime('today');
   $videoFeed = $yt->getTopRatedVideoFeed($query);

あるいは、次のように *URL* を使用してフィードを取得することもできます。

.. _zend.gdata.youtube.videos.standard.example-3:

.. rubric:: URL からの動画フィードの取得

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube();
   $url = 'http://gdata.youtube.com/feeds/standardfeeds/top_rated?time=today'
   $videoFeed = $yt->getVideoFeed($url);

.. _zend.gdata.youtube.videos.user:

指定したユーザがアップロードした動画の取得
^^^^^^^^^^^^^^^^^^^^^

指定したユーザがアップロードした動画の一覧を取得するヘルパーメソッドもあります。
次の例は、ユーザ 'liz' がアップロードした動画の一覧を取得します。

.. _zend.gdata.youtube.videos.user.example:

.. rubric:: 指定したユーザがアップロードした動画の取得

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube();
   $videoFeed = $yt->getUserUploads('liz');

.. _zend.gdata.youtube.videos.favorites:

指定したユーザのお気に入り動画の取得
^^^^^^^^^^^^^^^^^^

指定したユーザのお気に入り動画の一覧を取得するヘルパーメソッドもあります。
次の例は、ユーザ 'liz' のお気に入り動画の一覧を取得します。

.. _zend.gdata.youtube.videos.favorites.example:

.. rubric:: 指定したユーザのお気に入り動画の取得

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube();
   $videoFeed = $yt->getUserFavorites('liz');

.. _zend.gdata.youtube.videos.responses:

動画に対する返信動画の取得
^^^^^^^^^^^^^

指定した動画に対する動画の返信の一覧を取得するヘルパーメソッドもあります。
次の例は、ID 'abc123813abc' の動画に対する返信動画を取得します。

.. _zend.gdata.youtube.videos.responses.example:

.. rubric:: 動画への返信のフィードの取得

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube();
   $videoFeed = $yt->getVideoResponseFeed('abc123813abc');

.. _zend.gdata.youtube.comments:

動画のコメントの取得
----------

YouTube の動画に対するコメントを取得するにはいくつかの方法があります。 ID
'abc123813abc' の動画に対するコメントを取得するコードは、次のようになります。

.. _zend.gdata.youtube.videos.comments.example-1:

.. rubric:: 動画 ID からの動画へのコメントのフィードの取得

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube();
   $commentFeed = $yt->getVideoCommentFeed('abc123813abc');

   foreach ($commentFeed as $commentEntry) {
       echo $commentEntry->title->text . "\n";
       echo $commentEntry->content->text . "\n\n\n";
   }

もし既にその動画を表す `Zend_Gdata_YouTube_VideoEntry`_
オブジェクトがあるのなら、それを用いてその動画のコメントを取得することもできます。

.. _zend.gdata.youtube.videos.comments.example-2:

.. rubric:: Zend_Gdata_YouTube_VideoEntry からの動画へのコメントのフィードの取得

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube();
   $videoEntry = $yt->getVideoEntry('abc123813abc');
   // 動画の ID がわからなくても、このようにして URL を取得できます
   $commentFeed = $yt->getVideoCommentFeed(null,
                                           $videoEntry->comments->href);

.. _zend.gdata.youtube.playlists:

プレイリストフィードの取得
-------------

YouTube data *API* を使用すると、
プロファイルやプレイリスト、購読内容といったユーザ情報を取得できます。

.. _zend.gdata.youtube.playlists.user:

指定したユーザのプレイリストの取得
^^^^^^^^^^^^^^^^^

このライブラリには、指定したユーザのプレイリストを取得するためのヘルパーメソッドがあります。
ユーザ 'liz' のプレイリストを取得するには、次のようにします。

.. _zend.gdata.youtube.playlists.user.example:

.. rubric:: 指定したユーザのプレイリストの取得

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube();
   $playlistListFeed = $yt->getPlaylistListFeed('liz');

   foreach ($playlistListFeed as $playlistEntry) {
       echo $playlistEntry->title->text . "\n";
       echo $playlistEntry->description->text . "\n";
       echo $playlistEntry->getPlaylistVideoFeedUrl() . "\n\n\n";
   }

.. _zend.gdata.youtube.playlists.special:

指定したプレイリストの取得
^^^^^^^^^^^^^

このライブラリには、
指定したプレイリストの動画一覧を取得するヘルパーメソッドがあります。
指定したプレイリストエントリの動画一覧を取得するには、次のようにします。

.. _zend.gdata.youtube.playlists.special.example:

.. rubric:: 指定したプレイリストの取得

.. code-block:: php
   :linenos:

   $feedUrl = $playlistEntry->getPlaylistVideoFeedUrl();
   $playlistVideoFeed = $yt->getPlaylistVideoFeed($feedUrl);

.. _zend.gdata.youtube.subscriptions:

指定したユーザの購読内容の一覧の取得
------------------

ユーザは、チャンネルやタグ、お気に入りなどの内容を購読できます。
`Zend_Gdata_YouTube_SubscriptionEntry`_ を使用して、それらの購読内容を表します。

ユーザ 'liz' のすべての購読内容を取得するには、次のようにします。

.. _zend.gdata.youtube.subscriptions.example:

.. rubric:: 指定したユーザのすべての購読の取得

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube();
   $subscriptionFeed = $yt->getSubscriptionFeed('liz');

   foreach ($subscriptionFeed as $subscriptionEntry) {
       echo $subscriptionEntry->title->text . "\n";
   }

.. _zend.gdata.youtube.profile:

ユーザのプロファイルの取得
-------------

任意の YouTube ユーザの公開プロファイル情報を取得できます。 ユーザ 'liz'
のプロファイルを取得するには、次のようにします。

.. _zend.gdata.youtube.profile.example:

.. rubric:: ユーザのプロファイルの取得

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube();
   $userProfile = $yt->getUserProfile('liz');
   echo "ユーザ名: " . $userProfile->username->text . "\n";
   echo "年齢: " . $userProfile->age->text . "\n";
   echo "出身地: " . $userProfile->hometown->text . "\n";

.. _zend.gdata.youtube.uploads:

YouTube への動画のアップロード
-------------------

アップロードのおおまかな手順については、code.google.com の `プロトコルガイド`_\
の図を参照ください。 動画のアップロードには 2 通りの方法があります。
動画を直接送信するか、単に動画のメタデータだけを送信して動画は HTML
フォームでアップロードさせるかです。

動画を直接アップロードするには、まず新しい `Zend_Gdata_YouTube_VideoEntry`_
オブジェクトを作成して必須メタデータを指定しなければなりません。
次の例は、Quicktime 動画 "mytestmovie.mov" を以下のプロパティで YouTube
にアップロードするものです。

.. _zend.gdata.youtube.uploads.metadata:

.. table:: 以下のサンプルで使用するメタデータ

   +---------------+-----------------------------------+
   |プロパティ          |値                                  |
   +===============+===================================+
   |Title          |My Test Movie                      |
   +---------------+-----------------------------------+
   |Category       |Autos                              |
   +---------------+-----------------------------------+
   |Keywords       |cars, funny                        |
   +---------------+-----------------------------------+
   |Description    |My description                     |
   +---------------+-----------------------------------+
   |Filename       |mytestmovie.mov                    |
   +---------------+-----------------------------------+
   |File MIME type |video/quicktime                    |
   +---------------+-----------------------------------+
   |Video private? |FALSE                              |
   +---------------+-----------------------------------+
   |Video location |37, -122 (lat, long)               |
   +---------------+-----------------------------------+
   |Developer Tags |mydevelopertag, anotherdevelopertag|
   +---------------+-----------------------------------+

下のコードは、アップロード用に空の `Zend_Gdata_YouTube_VideoEntry`_ を作成します。次に
`Zend_Gdata_App_MediaFileSource`_
オブジェクトを使用して実際の動画ファイルを保持させます。水面下では、
`Zend_Gdata_YouTube_Extension_MediaGroup`_
オブジェクトを使用して動画のすべてのメタデータを保持します。
以下で説明するヘルパーメソッドを使用すると、
メディアグループオブジェクトのことを気にせず動画のメタデータを設定できます。
$uploadUrl は、新しいエントリを投稿する場所です。 これは、認証済みユーザの名前
$userName で指定することもできますし、 シンプルに 'default'
と指定して現在の認証済みユーザを自動的に利用することもできます。

.. _zend.gdata.youtube.uploads.example:

.. rubric:: 動画のアップロード

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube($httpClient);
   $myVideoEntry = new Zend_Gdata_YouTube_VideoEntry();

   $filesource = $yt->newMediaFileSource('mytestmovie.mov');
   $filesource->setContentType('video/quicktime');
   $filesource->setSlug('mytestmovie.mov');

   $myVideoEntry->setMediaSource($filesource);

   $myVideoEntry->setVideoTitle('My Test Movie');
   $myVideoEntry->setVideoDescription('My Test Movie');
   // カテゴリは YouTube のカテゴリとして妥当な形式でなければならないことに注意 !
   $myVideoEntry->setVideoCategory('Comedy');

   // キーワードを設定します。カンマ区切りの文字列であり、
   // 各キーワードには空白文字を含めてはいけないことに注意しましょう
   $myVideoEntry->SetVideoTags('cars, funny');

   // オプションで、デベロッパタグを指定します
   $myVideoEntry->setVideoDeveloperTags(array('mydevelopertag',
                                              'anotherdevelopertag'));

   // オプションで、動画の撮影場所を指定します
   $yt->registerPackage('Zend_Gdata_Geo');
   $yt->registerPackage('Zend_Gdata_Geo_Extension');
   $where = $yt->newGeoRssWhere();
   $position = $yt->newGmlPos('37.0 -122.0');
   $where->point = $yt->newGmlPoint($position);
   $myVideoEntry->setWhere($where);

   // 現在の認証済みユーザ用のアップロード URI
   $uploadUrl =
       'http://uploads.gdata.youtube.com/feeds/users/default/uploads';

   // 動画をアップロードし、Zend_Gdata_App_HttpException あるいは通常の
   // Zend_Gdata_App_Exception を捕捉します

   try {
       $newEntry = $yt->insertEntry($myVideoEntry,
                                    $uploadUrl,
                                    'Zend_Gdata_YouTube_VideoEntry');
   } catch (Zend_Gdata_App_HttpException $httpException) {
       echo $httpException->getRawResponseBody();
   } catch (Zend_Gdata_App_Exception $e) {
       echo $e->getMessage();
   }

非公開で動画をアップロードするには、アップロードの前に $myVideoEntry->setVideoPrivate();
を実行します。 $videoEntry->isVideoPrivate() を使用すると、
その動画エントリが非公開かどうかを調べることができます。

.. _zend.gdata.youtube.uploads.browser:

ブラウザベースのアップロード
--------------

ブラウザベースのアップロードも直接のアップロードとほとんど同じ処理ですが、
作成した `Zend_Gdata_YouTube_VideoEntry`_ に `Zend_Gdata_App_MediaFileSource`_
オブジェクトをアタッチしないという点が異なります。
そのかわりに、動画のすべてのメタデータを送信してトークン要素を受け取り、
それを用いて HTML アップロードフォームを作成します。

.. _zend.gdata.youtube.uploads.browser.example-1:

.. rubric:: ブラウザベースのアップロード

.. code-block:: php
   :linenos:

   $yt = new Zend_Gdata_YouTube($httpClient);

   $myVideoEntry= new Zend_Gdata_YouTube_VideoEntry();
   $myVideoEntry->setVideoTitle('My Test Movie');
   $myVideoEntry->setVideoDescription('My Test Movie');

   // YouTube のカテゴリとして妥当な形式でなければならないことに注意
   $myVideoEntry->setVideoCategory('Comedy');
   $myVideoEntry->SetVideoTags('cars, funny');

   $tokenHandlerUrl = 'http://gdata.youtube.com/action/GetUploadToken';
   $tokenArray = $yt->getFormUploadToken($myVideoEntry, $tokenHandlerUrl);
   $tokenValue = $tokenArray['token'];
   $postUrl = $tokenArray['url'];

上のコードは、リンクとトークンを表示します。
これらを元に、ユーザのブラウザに表示させる HTML フォームを構築します。
シンプルなフォームの例を以下に示します。 $tokenValue
が返されたトークン要素の中身をあらわしており、 これは上の $myVideoEntry
から取得したものです。
フォームを送信したあとであなたのサイトにリダイレクトさせるには、 パラメータ
$nextUrl を上の $postUrl に追加します。 これは、AuthSub リンクにおけるパラメータ $next
と同じように機能します。 唯一の違いは、一度きりのトークンではなく status と id を
*URL* の中に含めて返すということです。

.. _zend.gdata.youtube.uploads.browser.example-2:

.. rubric:: ブラウザベースのアップロード: HTML フォームの作成

.. code-block:: php
   :linenos:

   // アップロード後のリダイレクト先
   $nextUrl = 'http://mysite.com/youtube_uploads';

   $form = '<form action="'. $postUrl .'?nexturl='. $nextUrl .
           '" method="post" enctype="multipart/form-data">'.
           '<input name="file" type="file"/>'.
           '<input name="token" type="hidden" value="'. $tokenValue .'"/>'.
           '<input value="動画のアップロード" type="submit" />'.
           '</form>';

.. _zend.gdata.youtube.uploads.status:

アップロード状況のチェック
-------------

動画をアップロードしたら、認証済みユーザのアップロードフィードにすぐに反映されます。
しかし、公開手続きがすむまではサイト上では公開されません。
却下された動画やアップロードが正常終了しなかった動画についても、
認証ユーザのアップロードフィードのみに現れるようになります。 次のコードは、
`Zend_Gdata_YouTube_VideoEntry`_
の状態をチェックして、公開されているかいないか、また却下されたのかどうかを調べます。

.. _zend.gdata.youtube.uploads.status.example:

.. rubric:: 動画のアップロード状況のチェック

.. code-block:: php
   :linenos:

   try {
       $control = $videoEntry->getControl();
   } catch (Zend_Gdata_App_Exception $e) {
       echo $e->getMessage();
   }

   if ($control instanceof Zend_Gdata_App_Extension_Control) {
       if ($control->getDraft() != null &&
           $control->getDraft()->getText() == 'yes') {
           $state = $videoEntry->getVideoState();

           if ($state instanceof Zend_Gdata_YouTube_Extension_State) {
               print 'アップロード状況: '
                     . $state->getName()
                     .' '. $state->getText();
           } else {
               print 'まだ動画の状況についての情報を取得できません。'
                     . "また後で試してみてください。\n";
           }
       }
   }

.. _zend.gdata.youtube.other:

その他の関数
------

これまで説明してきたもの以外にも YouTube API にはさまざまな機能が存在し、
動画のメタデータを編集したり動画エントリを削除したり、
サイト上のコミュニティ機能を利用したりといったことが可能です。 API
で操作できるコミュニティ機能としては、
評価やコメント、プレイリスト、購読、ユーザプロファイル、コンタクト、メッセージなどがあります。

完全なドキュメントは、code.google.com の `PHP Developer's Guide`_ を参照ください。



.. _`PHP Developer's Guide`: http://code.google.com/apis/youtube/developers_guide_php.html
.. _`PHP Developer's Guide の認証のセクション`: http://code.google.com/apis/youtube/developers_guide_php.html#Authentication
.. _`http://code.google.com/apis/youtube/dashboard/`: http://code.google.com/apis/youtube/dashboard/
.. _`Zend_Gdata_YouTube`: http://framework.zend.com/apidoc/core/Zend_Gdata/Zend_Gdata_YouTube.html
.. _`YouTube API リファレンスガイド`: http://code.google.com/apis/youtube/reference.html#Video_Feeds
.. _`リファレンスガイド`: http://code.google.com/apis/youtube/reference.html#Searching_for_videos
.. _`Zend_Gdata_YouTube_VideoQuery`: http://framework.zend.com/apidoc/core/Zend_Gdata/Zend_Gdata_YouTube_VideoQuery.html
.. _`専用の URL を作成します`: http://code.google.com/apis/youtube/reference.html#Category_search
.. _`標準フィード`: http://code.google.com/apis/youtube/reference.html#Standard_feeds
.. _`Zend_Gdata_YouTube_VideoFeed`: http://framework.zend.com/apidoc/core/Zend_Gdata/Zend_Gdata_YouTube_VideoFeed.html
.. _`Zend_Gdata_YouTube_VideoEntry`: http://framework.zend.com/apidoc/core/Zend_Gdata/Zend_Gdata_YouTube_VideoEntry.html
.. _`Zend_Gdata_YouTube_SubscriptionEntry`: http://framework.zend.com/apidoc/core/Zend_Gdata/Zend_Gdata_YouTube_SubscriptionEntry.html
.. _`プロトコルガイド`: http://code.google.com/apis/youtube/developers_guide_protocol.html#Process_Flows_for_Uploading_Videos
.. _`Zend_Gdata_App_MediaFileSource`: http://framework.zend.com/apidoc/core/Zend_Gdata/Zend_Gdata_App_MediaFileSource.html
.. _`Zend_Gdata_YouTube_Extension_MediaGroup`: http://framework.zend.com/apidoc/core/Zend_Gdata/Zend_Gdata_YouTube_Extension_MediaGroup.html
