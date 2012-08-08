.. EN-Revision: none
.. _zend.gdata.photos:

Picasa Web Albums の使用法
======================

Picasa Web Albums は、自分の写真のアルバムを管理したり
他人のアルバムや写真を閲覧したりするサービスです。 *API*
を使用すると、このサービスをプログラムから操作できるようになります。
たとえばアルバムへの追加や更新、削除、
そして写真へのタグ付けやコメントを行うことができます。

公開されているアルバムや写真へのアクセスについては、
アカウントによる制限はありません。
しかし、読み込み専用以外のアクセスを行うにはログインする必要があります。

*API* についての詳細な情報、 たとえば *API* へのアクセスを有効にする方法などは
`Picasa Web Albums Data API の概要`_ を参照ください。

.. note::

   **認証**

   この *API* は、AuthSub (推奨) および ClientAuth による認証に対応しています。
   書き込みを行うには認証済みの *HTTP* 接続が必須ですが、
   認証していない接続でも読み込み専用のアクセスは可能です。

.. _zend.gdata.photos.connecting:

サービスへの接続
--------

Picasa Web Albums *API* は、その他の GData *API* と同様に Atom Publishing Protocol (APP)
を使用しています。これは、 *XML*
ベースのフォーマットでウェブのリソースを管理するための仕組みです。
クライアントと Google Calendar サーバとの間のやり取りは *HTTP*
で行われ、認証済みの接続と未認証の接続の両方が利用できます。

何らかのトランザクションが発生する際には、 必ず接続を確立する必要があります。
Picasa サーバとの接続は、まず *HTTP* クライアントを作成して ``Zend_Gdata_Photos``
サービスのインスタンスをそこにバインドするという手順で行います。

.. _zend.gdata.photos.connecting.authentication:

認証
^^

Google Picasa *API* を使用すると、公開カレンダーだけでなく
プライベートカレンダーのフィードにもアクセスできます。
公開フィードには認証は不要ですが、
認証しない場合は読み込み専用となり、機能が制限されます。
プライベートフィードでは完全な機能が使用できますが、 Picasa
サーバとの認証が必要になります。 Google Picasa がサポートしている認証方式は、次の
3 通りです。

- **ClientAuth** は、Picasa サーバとの間で直接 ユーザ名/パスワード
  による認証を行います。この方式では
  ユーザ自身がアプリケーションにパスワードを教える必要があるので、
  これは他の方式が使えない場合にのみ使用するようにしましょう。

- **AuthSub** は、Gooble のプロキシサーバを経由して Picasa
  サーバとの認証を行ないます。 これは ClientAuth と同じくらい便利に使用でき、
  セキュリティリスクもありません。 ウェブベースのアプリケーションでは、
  これは最適な選択肢となります。

``Zend_Gdata`` ライブラリは、 これらのすべての方式に対応しています。
これ以降の説明は、認証方式については理解しており
適切な認証方式で接続できるようになっていることを前提として進めていきます。
詳細な情報は、このマニュアルの :ref:`認証に関するセクション
<zend.gdata.introduction.authentication>` か、あるいは `Google Data API Developer's Guide の Authentication
Overview`_ を参照ください。

.. _zend.gdata.photos.connecting.service:

サービスのインスタンスの作成
^^^^^^^^^^^^^^

サーバとのやりとりを行うためのクラスとして、このライブラリでは ``Zend_Gdata_Photos``
サービスクラスを用意しています。 このクラスは Google Data や Atom Publishing Protocol
モデルへの共通インターフェイスを提供し、
サーバとのリクエストのやりとりを支援します。

使用する認証方式を決めたら、次に ``Zend_Gdata_Photos`` のインスタンスを作成します。
このクラスのコンストラクタには、引数として ``Zend_Http_Client``
のインスタンスを渡します。 これは、AuthSub 認証および ClientAuth
認証へのインターフェイスを提供します。
これらの認証を使用する場合には、認証済みの *HTTP* クライアントが必要です。
引数を省略した場合は、未認証の ``Zend_Http_Client``
のインスタンスを自動的に作成して使用します。

以下の例は、ClientAuth 認証を使用してサービスクラスを作成するものです。

.. code-block:: php
   :linenos:

   // ClientAuth 認証用のパラメータ
   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $user = "sample.user@gmail.com";
   $pass = "pa$$w0rd";

   // 認証済みの HTTP クライアントを作成します
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);

   // サービスのインスタンスを作成します
   $service = new Zend_Gdata_Photos($client);

AuthSub を使用するサービスを作成するのもほぼ同様ですが、 少々長めになります。

.. code-block:: php
   :linenos:

   session_start();

   /**
    * 現在のページの完全な URL を、環境変数をもとにして返します
    *
    * 次の環境変数を使用します
    * $_SERVER['HTTPS'] = (on|off|)
    * $_SERVER['HTTP_HOST'] = Host: ヘッダの値
    * $_SERVER['SERVER_PORT'] = ポート番号 (http/80,https/443 以外の場合に使用します)
    * $_SERVER['REQUEST_URI'] = HTTP リクエストのメソッドのあとに続く URI
    *
    * @return string 現在の URL
    */
   function getCurrentUrl()
   {
       global $_SERVER;

       /**
        * php_self をフィルタリングしてセキュリティ脆弱性を防ぎます
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
    * 認証後のリダイレクト先を伝えられるようにします
    * AuthSub URL を返します
    *
    * getCurrentUrl() を使用して次の URL を取得し、
    * Google サービスでの認証に成功したらそこにリダイレクトします
    *
    * @return string AuthSub URL
    */
   function getAuthSubUrl()
   {
       $next = getCurrentUrl();
       $scope = 'http://picasaweb.google.com/data';
       $secure = false;
       $session = true;
       return Zend_Gdata_AuthSub::getAuthSubTokenUri($next, $scope, $secure,
           $session);
   }

   /**
    * AuthSub 認証を使用して Google と通信するための適切なヘッダを設定した
    * HTTP クライアントオブジェクトを返します
    *
    * $_SESSION['sessionToken'] を使用して、取得した AuthSub セッショントークンを
    * 保存します。Google での認証に成功したユーザのリダイレクト先 URL
    * に含まれる一回限りのトークンは、$_GET['token'] から取得します
    *
    * @return Zend_Http_Client
    */
   function getAuthSubHttpClient()
   {
       global $_SESSION, $_GET;
       if (!isset($_SESSION['sessionToken']) && isset($_GET['token'])) {
           $_SESSION['sessionToken'] =
               Zend_Gdata_AuthSub::getAuthSubSessionToken($_GET['token']);
       }
       $client = Zend_Gdata_AuthSub::getHttpClient($_SESSION['sessionToken']);
       return $client;
   }

   /**
    * サービスのインスタンスを作成し、
    * 必要に応じてユーザを AuthSub サーバにリダイレクトします
    */
   $service = new Zend_Gdata_Photos(getAuthSubHttpClient());

未認証のサーバを作成して、公開フィードへのアクセスに使用できます。

.. code-block:: php
   :linenos:

   // サービスのインスタンスを、未認証の HTTP クライアントで作成します
   $service = new Zend_Gdata_Photos();

.. _zend.gdata.photos.queries:

クエリの仕組みと作成方法
------------

サービスに対してデータを要求するために最初にやることは、
クエリを作成することです。以下の形式用のクエリクラスが用意されています。

- **User** は、誰のデータを探すのかをユーザ名で指定します。 省略した場合は "default"
  を使用します。 これは、現在認証されているユーザ (認証済みの場合) を表します。

- **Album** は、検索対象のアルバムを ID あるいはアルバム名で指定します。

- **Photo** は、検索対象の写真を ID で指定します。

新しい *UserQuery* を作成するには次のようにします。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_UserQuery();
   $query->setUser("sample.user");

各クエリで検索結果を絞り込むために使用するパラメータを取得したり設定したりするには、
それぞれ get(Parameter) および set(Parameter) を使用して次のようにします。

- **Projection** は、フィードで返されるデータのフォーマットを指定します。 "api"
  あるいは "base" のいずれかです。通常は "api"
  を指定することになるでしょう。デフォルトは "api" です。

- **Type** は返される要素の型を指定します。"feed" あるいは "entry"
  のいずれかで、デフォルトは "feed" です。

- **Access** は、返されるアイテムの可視性を指定します。 "all"、"public" あるいは
  "private" のいずれかで、 デフォルトは "all" です。 public 以外の要素が返されるのは、
  認証済みのユーザに対するクエリの場合のみです。

- **Tag** は、返されるアイテムのタグを指定します。
  タグを指定した場合は、その内容のタグがつけられている項目のみを返します。

- **Kind** は、返される要素の種類を指定します。
  指定した場合は、この値にマッチするエントリのみを返します。

- **ImgMax** は、返されるエントリの最大画像サイズを指定します。
  この値より小さい画像エントリのみを返します。

- **Thumbsize** は、返されるエントリのサムサイズを指定します。
  返されたエントリのサムサイズはこの値に等しくなります。

- **User** は、検索対象のユーザを指定します。 デフォルトは "default" です。

- **AlbumId** は、検索対象のアルバムの ID を指定します。
  この要素は、アルバムや写真の問い合わせに対してのみ適用されます。
  写真に対するクエリの場合、
  ここで指定したアルバムに含まれる写真が対象となります。 アルバム ID は
  アルバム名とは互いに排他的です。
  一方を指定すると、もう一方は取り消されます。

- **AlbumName** は、検索対象のアルバムの名前を指定します。
  この要素は、アルバムや写真の問い合わせに対してのみ適用されます。
  写真に対するクエリの場合、
  ここで指定したアルバムに含まれる写真が対象となります。 アルバム名は アルバム
  ID とは互いに排他的です。 一方を指定すると、もう一方は取り消されます。

- **PhotoId** は、検索対象の写真の ID を指定します。
  この要素は、写真の問い合わせに対してのみ適用されます。

.. _zend.gdata.photos.retrieval:

フィードやエントリの取得
------------

このサービスには、ユーザやアルバムそして写真に関する
フィードや個々のエントリを取得する機能があります。

.. _zend.gdata.photos.user_retrieval:

ユーザの取得
^^^^^^

このサービスは、ユーザのフィードおよびユーザのコンテンツ一覧の取得をサポートしています。
指定したユーザが認証済みユーザである場合は、 "*hidden*"
とマークされているエントリも返されます。

ユーザのフィードにアクセスするには、ユーザ名を *getUserFeed* メソッドに渡します。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   try {
       $userFeed = $service->getUserFeed("sample.user");
   } catch (Zend_Gdata_App_Exception $e) {
       echo "エラー: " . $e->getMessage();
   }

あるいは、クエリを作成してフィードにアクセスすることもできます。この場合は、まず次のようにします。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_UserQuery();
   $query->setUser("sample.user");

   try {
       $userFeed = $service->getUserFeed(null, $query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "エラー: " . $e->getMessage();
   }

クエリを作成すると、ユーザエントリオブジェクトも取得できるようになります。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_UserQuery();
   $query->setUser("sample.user");
   $query->setType("entry");

   try {
       $userEntry = $service->getUserEntry($query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "エラー: " . $e->getMessage();
   }

.. _zend.gdata.photos.album_retrieval:

アルバムの取得
^^^^^^^

このサービスには、アルバムのフィードやアルバムのコンテンツ一覧を取得する機能があります。

アルバムのフィードにアクセスするには、クエリオブジェクトを作成してそれを
*getAlbumFeed* に渡します。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_AlbumQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");

   try {
       $albumFeed = $service->getAlbumFeed($query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "エラー: " . $e->getMessage();
   }

あるいは、 *setAlbumName*
でクエリオブジェクトにアルバム名を指定することもできます。 アルバム名は
アルバム ID とは互いに排他的です。
一方を指定すると、もう一方は取り消されます。

クエリを作成すると、アルバムエントリオブジェクトも取得できるようになります。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_AlbumQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setType("entry");

   try {
       $albumEntry = $service->getAlbumEntry($query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "エラー: " . $e->getMessage();
   }

.. _zend.gdata.photos.photo_retrieval:

写真の取得
^^^^^

このサービスには、写真のフィードやコメント・タグ一覧を取得する機能があります。

写真のフィードにアクセスするには、クエリオブジェクトを作成してそれを
*getPhotoFeed* に渡します。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");

   try {
       $photoFeed = $service->getPhotoFeed($query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "エラー: " . $e->getMessage();
   }

クエリを作成すると、写真エントリオブジェクトも取得できるようになります。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");
   $query->setType("entry");

   try {
       $photoEntry = $service->getPhotoEntry($query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "エラー: " . $e->getMessage();
   }

.. _zend.gdata.photos.comment_retrieval:

コメントの取得
^^^^^^^

このサービスには、さまざまな形式のフィードからのコメントの取得をサポートしています。
クエリが返す結果の種類として "comment" を指定することで、
指定したユーザやアルバム、写真に関連づけられたコメントを取得できるようになります。

指定した写真のコメントを処理するには、次のようにします。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");
   $query->setKind("comment");

   try {
       $photoFeed = $service->getPhotoFeed($query);

       foreach ($photoFeed as $entry) {
           if ($entry instanceof Zend_Gdata_Photos_CommentEntry) {
               // コメントに対して何らかの処理をします
           }
       }
   } catch (Zend_Gdata_App_Exception $e) {
       echo "エラー: " . $e->getMessage();
   }

.. _zend.gdata.photos.tag_retrieval:

タグの取得
^^^^^

このサービスには、さまざまな形式のフィードからのタグの取得をサポートしています。
クエリが返す結果の種類として "tag" を指定することで、
指定した写真に関連づけられたタグを取得できるようになります。

指定した写真のタグを処理するには、次のようにします。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $query = new Zend_Gdata_Photos_PhotoQuery();
   $query->setUser("sample.user");
   $query->setAlbumId("1");
   $query->setPhotoId("100");
   $query->setKind("tag");

   try {
       $photoFeed = $service->getPhotoFeed($query);

       foreach ($photoFeed as $entry) {
           if ($entry instanceof Zend_Gdata_Photos_TagEntry) {
               // タグに対して何らかの処理をします
           }
       }
   } catch (Zend_Gdata_App_Exception $e) {
       echo "エラー: " . $e->getMessage();
   }

.. _zend.gdata.photos.creation:

エントリの作成
-------

このサービスには、アルバムや写真、コメント、そしてタグを作成する機能があります。

.. _zend.gdata.photos.album_creation:

アルバムの作成
^^^^^^^

このサービスは、認証済みユーザ用の新しいアルバムの作成をサポートしています。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $entry = new Zend_Gdata_Photos_AlbumEntry();
   $entry->setTitle($service->newTitle("test album"));

   $service->insertAlbumEntry($entry);

.. _zend.gdata.photos.photo_creation:

写真の作成
^^^^^

このサービスは、認証済みユーザ用の新しい写真の作成をサポートしています。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   // $photo は、HTML フォームからアップロードされたファイルの名前です

   $fd = $service->newMediaFileSource($photo["tmp_name"]);
   $fd->setContentType($photo["type"]);

   $entry = new Zend_Gdata_Photos_PhotoEntry();
   $entry->setMediaSource($fd);
   $entry->setTitle($service->newTitle($photo["name"]));

   $albumQuery = new Zend_Gdata_Photos_AlbumQuery;
   $albumQuery->setUser("sample.user");
   $albumQuery->setAlbumId("1");

   $albumEntry = $service->getAlbumEntry($albumQuery);

   $service->insertPhotoEntry($entry, $albumEntry);

.. _zend.gdata.photos.comment_creation:

コメントの作成
^^^^^^^

このサービスは、写真への新しいコメントの作成をサポートしています。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $entry = new Zend_Gdata_Photos_CommentEntry();
   $entry->setTitle($service->newTitle("comment"));
   $entry->setContent($service->newContent("comment"));

   $photoQuery = new Zend_Gdata_Photos_PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $photoEntry = $service->getPhotoEntry($photoQuery);

   $service->insertCommentEntry($entry, $photoEntry);

.. _zend.gdata.photos.tag_creation:

タグの作成
^^^^^

このサービスは、写真への新しいタグの作成をサポートしています。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $entry = new Zend_Gdata_Photos_TagEntry();
   $entry->setTitle($service->newTitle("tag"));

   $photoQuery = new Zend_Gdata_Photos_PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $photoEntry = $service->getPhotoEntry($photoQuery);

   $service->insertTagEntry($entry, $photoEntry);

.. _zend.gdata.photos.deletion:

エントリの削除
-------

このサービスには、アルバムや写真、コメント、そしてタグを削除する機能があります。

.. _zend.gdata.photos.album_deletion:

アルバムの削除
^^^^^^^

このサービスは、認証済みユーザ用のアルバムの削除をサポートしています。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $albumQuery = new Zend_Gdata_Photos_AlbumQuery;
   $albumQuery->setUser("sample.user");
   $albumQuery->setAlbumId("1");
   $albumQuery->setType('entry');

   $entry = $service->getAlbumEntry($albumQuery);

   $service->deleteAlbumEntry($entry, true);

.. _zend.gdata.photos.photo_deletion:

写真の削除
^^^^^

このサービスは、認証済みユーザ用の写真の削除をサポートしています。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $photoQuery = new Zend_Gdata_Photos_PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $entry = $service->getPhotoEntry($photoQuery);

   $service->deletePhotoEntry($entry, true);

.. _zend.gdata.photos.comment_deletion:

コメントの削除
^^^^^^^

このサービスは、認証済みユーザのコメントの削除をサポートしています。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $photoQuery = new Zend_Gdata_Photos_PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setType('entry');

   $path = $photoQuery->getQueryUrl() . '/commentid/' . "1000";

   $entry = $service->getCommentEntry($path);

   $service->deleteCommentEntry($entry, true);

.. _zend.gdata.photos.tag_deletion:

タグの削除
^^^^^

このサービスは、認証済みユーザのタグの削除をサポートしています。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Photos::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Photos($client);

   $photoQuery = new Zend_Gdata_Photos_PhotoQuery;
   $photoQuery->setUser("sample.user");
   $photoQuery->setAlbumId("1");
   $photoQuery->setPhotoId("100");
   $photoQuery->setKind("tag");
   $query = $photoQuery->getQueryUrl();

   $photoFeed = $service->getPhotoFeed($query);

   foreach ($photoFeed as $entry) {
       if ($entry instanceof Zend_Gdata_Photos_TagEntry) {
           if ($entry->getContent() == $tagContent) {
               $tagEntry = $entry;
           }
       }
   }

   $service->deleteTagEntry($tagEntry, true);

.. _zend.gdata.photos.optimistic_concurrenty:

楽観的な同時並行性 (削除時の注意)
^^^^^^^^^^^^^^^^^^

Picasa Web Albums サービスを含めた GData のフィードは、 楽観的な同時並行性 (optimistic
concurrency) を実装しています。
これは、変更内容を不意に上書きしてしまうことを防ぐバージョン管理システムです。
サービスクラスでエントリを削除する際に、
もし最後に取得した後でそのエントリが変更されていた場合は例外がスローされます。
ただし明示的にその他の設定をしている場合は別です
(この場合、更新後のエントリに対して削除を試みます)。

削除時のバージョン管理の処理方法については *deleteAlbumEntry*
で見ることができます。

.. code-block:: php
   :linenos:

   // $album は、削除したい albumEntry です
   try {
       $this->delete($album);
   } catch (Zend_Gdata_App_HttpException $e) {
       if ($e->getMessage()->getStatus() === 409) {
           $entry =
               new Zend_Gdata_Photos_AlbumEntry($e->getMessage()->getBody());
           $this->delete($entry->getLink('edit')->href);
       } else {
           throw $e;
       }
   }



.. _`Picasa Web Albums Data API の概要`: http://code.google.com/apis/picasaweb/overview.html
.. _`Google Data API Developer's Guide の Authentication Overview`: http://code.google.com/apis/gdata/auth.html
