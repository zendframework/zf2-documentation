.. EN-Revision: none
.. _zend.gdata.calendar:

Google Calendar の使用法
====================

``Zend_Gdata_Calendar`` クラスを使うと、Google Calendar サービスで
イベントの閲覧や作成、更新、削除ができるようになります。

Google Calendar *API* についての詳細な情報は `http://code.google.com/apis/calendar/overview.html`_
を参照ください。

.. _zend.gdata.calendar.connecting:

Calendar サービスへの接続
-----------------

Google Calendar *API* は、その他の GData *API* と同様に Atom Publishing Protocol (APP)
を使用しています。これは、 *XML*
ベースのフォーマットでウェブのリソースを管理するための仕組みです。
クライアントと Google Calendar サーバとの間のやり取りは *HTTP*
で行われ、認証済みの接続と未認証の接続の両方が利用できます。

何らかのトランザクションが発生する際には、 必ず接続を確立する必要があります。
カレンダーサーバとの接続は、まず *HTTP* クライアントを作成して ``Zend_Gdata_Calendar``
サービスのインスタンスをそこにバインドするという手順で行います。

.. _zend.gdata.calendar.connecting.authentication:

認証
^^

Google Calendar *API* を使用すると、公開カレンダーだけでなく
プライベートカレンダーのフィードにもアクセスできます。
公開フィードには認証は不要ですが、
認証しない場合は読み込み専用となり、機能が制限されます。
プライベートフィードでは完全な機能が使用できますが、
カレンダーサーバとの認証が必要になります。 Google Calendar
がサポートしている認証方式は、次の 3 通りです。

- **ClientAuth** は、カレンダーサーバとの間で直接 ユーザ名/パスワード
  による認証を行います。この方式では
  ユーザ自身がアプリケーションにパスワードを教える必要があるので、
  これは他の方式が使えない場合にのみ使用するようにしましょう。

- **AuthSub** は、Gooble
  のプロキシサーバを経由してカレンダーサーバとの認証を行ないます。 これは
  ClientAuth と同じくらい便利に使用でき、 セキュリティリスクもありません。
  ウェブベースのアプリケーションでは、 これは最適な選択肢となります。

- **MagicCookie** は、Google Calendar インターフェイス内の 半ランダムな *URL*
  にもとづいた認証を行なう方法です。
  この方法は、実装するのが一番簡単です。しかし、 ユーザ自身が安全な *URL*
  を事前に取得しないと認証できません またカレンダーリストにはアクセスできず、
  アクセスは読み込み専用に制限されます。

``Zend_Gdata`` ライブラリは、 これらのすべての方式に対応しています。
これ以降の説明は、認証方式については理解しており
適切な認証方式で接続できるようになっていることを前提として進めていきます。
詳細な情報は、このマニュアルの :ref:`認証に関するセクション
<zend.gdata.introduction.authentication>` か、あるいは `Google Data API Developer's Guide の Authentication
Overview`_ を参照ください。

.. _zend.gdata.calendar.connecting.service:

サービスのインスタンスの作成
^^^^^^^^^^^^^^

Google Calendar を使用するためのクラスとして、このライブラリでは ``Zend_Gdata_Calendar``
を用意しています。 このクラスは Google Data や Atom Publishing Protocol
モデルへの共通インターフェイスを提供し、
カレンダーサーバとのリクエストのやりとりを支援します。

使用する認証方式を決めたら、次に ``Zend_Gdata_Calendar`` のインスタンスを作成します。
このクラスのコンストラクタには、引数として ``Zend_Http_Client``
のインスタンスを渡します。 これは、AuthSub 認証および ClientAuth
認証へのインターフェイスを提供します。
これらの認証を使用する場合には、認証済みの *HTTP* クライアントが必要です。
引数を省略した場合は、未認証の ``Zend_Http_Client``
のインスタンスを自動的に作成して使用します。

以下の例は、ClientAuth 認証を使用して Calendar サービスを作成するものです。

.. code-block:: php
   :linenos:

   // ClientAuth 認証用のパラメータ
   $service = Zend_Gdata_Calendar::AUTH_SERVICE_NAME;
   $user = "sample.user@gmail.com";
   $pass = "pa$$w0rd";

   // 認証済みの HTTP クライアントを作成します
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);

   // Calendar サービスのインスタンスを作成します
   $service = new Zend_Gdata_Calendar($client);

AuthSub を使用する Calendar サービスを作成するのもほぼ同様ですが、
少々長めになります。

.. code-block:: php
   :linenos:

   /*
    * 現在の URL を取得し、AuthSub サーバに
    * 認証後のリダイレクト先を伝えられるようにします
    */
   function getCurrentUrl()
   {
       global $_SERVER;

       // php_self をフィルタリングし、セキュリティを確保します
       $php_request_uri =
           htmlentities(substr($_SERVER['REQUEST_URI'],
                               0,
                               strcspn($_SERVER['REQUEST_URI'], "\n\r")),
                               ENT_QUOTES);

       if (isset($_SERVER['HTTPS']) &&
           strtolower($_SERVER['HTTPS']) == 'on') {
           $protocol = 'https://';
       } else {
           $protocol = 'http://';
       }
       $host = $_SERVER['HTTP_HOST'];
       if ($_SERVER['HTTP_PORT'] != '' &&
           (($protocol == 'http://' && $_SERVER['HTTP_PORT'] != '80') ||
           ($protocol == 'https://' && $_SERVER['HTTP_PORT'] != '443'))) {
           $port = ':' . $_SERVER['HTTP_PORT'];
       } else {
           $port = '';
       }
       return $protocol . $host . $port . $php_request_uri;
   }

   /**
    * AuthSub 認証済みの HTTP クライアントを作成し、ログインが必要なら
    * ユーザを AuthSub サーバにリダイレクトします
    */
   function getAuthSubHttpClient()
   {
       global $_SESSION, $_GET;

       // AuthSub セッションあるいはワンタイムトークンがなければ、
       // AuthSub サーバにリダイレクトします
       if (!isset($_SESSION['sessionToken']) && !isset($_GET['token'])) {
           // AuthSub サーバへのパラメータ
           $next = getCurrentUrl();
           $scope = "http://www.google.com/calendar/feeds/";
           $secure = false;
           $session = true;

           // ユーザを AuthSub サーバにリダイレクトします

           $authSubUrl = Zend_Gdata_AuthSub::getAuthSubTokenUri($next,
                                                                $scope,
                                                                $secure,
                                                                $session);
            header("HTTP/1.0 307 Temporary redirect");

            header("Location: " . $authSubUrl);

            exit();
       }

       // AuthSub のワンタイムトークンを、必要に応じてセッショントークンに変換します
       if (!isset($_SESSION['sessionToken']) && isset($_GET['token'])) {
           $_SESSION['sessionToken'] =
               Zend_Gdata_AuthSub::getAuthSubSessionToken($_GET['token']);
       }

       // この時点で AuthSub による認証がすんでいるので、
       // 認証済みの HTTP クライアントのインスタンスを作成できます

       // 認証済みの HTTP クライアントを作成します
       $client = Zend_Gdata_AuthSub::getHttpClient($_SESSION['sessionToken']);
       return $client;
   }

   // -> スクリプトの実行はここから始まります <-

   // ユーザが有効なセッションを保持していることを確認し、
   // AuthSub セッショントークンを記録します
   session_start();

   // Calendar サービスのインスタンスを作成し、
   // 必要に応じてユーザを AuthSub サーバにリダイレクトします
   $service = new Zend_Gdata_Calendar(getAuthSubHttpClient());

未認証のサーバを作成して、公開フィードへのアクセスや MagicCookie
認証で使用できます。

.. code-block:: php
   :linenos:

   // Calendar サービスのインスタンスを、
   // 未認証の HTTP クライアントで作成します

   $service = new Zend_Gdata_Calendar();

MagicCookie 認証は *HTTP* 接続で提供するものではなく、
クエリを送信する際の可視性を指定するものです。
以下にあるイベント取得の例を見てみましょう。

.. _zend.gdata.calendar_retrieval:

カレンダーリストの取得
-----------

カレンダーサービスには、
認証済みのユーザのカレンダーの一覧を取得する機能があります。 これは Google
Calendar の画面に表示される一覧と同じですが、 "*hidden*"
とマークされているものも取得できるという点が異なります。

カレンダーリストは常に非公開なので、認証済み接続でアクセスする必要があります。
別のユーザのカレンダーリストを取得したり、MagicCookie
認証でアクセスしたりすることはできません。
適切な認証情報を持たずにカレンダーリストにアクセスしようとすると、
その処理は失敗し、ステータスコード 401 (Authentication Required) を返します。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Calendar::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $service = new Zend_Gdata_Calendar($client);

   try {
       $listFeed= $service->getCalendarListFeed();
   } catch (Zend_Gdata_App_Exception $e) {
       echo "エラー: " . $e->getMessage();
   }

``getCalendarListFeed()`` をコールすると ``Zend_Gdata_Calendar_ListFeed``
の新しいインスタンスを作成します。この中には、使用できるカレンダーの一覧が
``Zend_Gdata_Calendar_ListEntry`` のインスタンスとして格納されています。
フィードを取得したら、それを使用して中身を取得できます。

.. code-block:: php
   :linenos:

   echo "<h1>カレンダーリストのフィード</h1>";
   echo "<ul>";
   foreach ($listFeed as $calendar) {
       echo "<li>" . $calendar->title .
            " (Event Feed: " . $calendar->id . ")</li>";
   }
   echo "</ul>";

.. _zend.gdata.event_retrieval:

イベントの取得
-------

カレンダーリストと同様、イベントも ``Zend_Gdata_Calendar`` クラスで取得できます。
返されるイベントリストの型は ``Zend_Gdata_Calendar_EventFeed`` で、各イベントは
``Zend_Gdata_Calendar_EventEntry`` のインスタンスとして格納されています。
先ほどの例と同様の方法で、個々のイベントの情報を取得できます。

.. _zend.gdata.event_retrieval.queries:

クエリ
^^^

Calendar *API* でイベントを取得する際には、 クエリ *URL*
を用いてほしいイベントを指定します。 ``Zend_Gdata_Calendar_EventQuery`` クラスは、
指定したパラメータに基づいたクエリ *URL*
を自動的に作成することでこの作業の手間を軽減します。
使用できるパラメータの一覧は `Google Data APIs Protocol Reference の Queries セクション`_
にあります。ここでは、そのうち特に重要な 3 つのパラメータについて説明します。

- **User** は、誰のカレンダーを検索するのかをメールアドレスで指定します。
  省略した場合は "default" を使用します。 これは、現在認証されているユーザ
  (認証済みの場合) を表します。

- **Visibility** は、公開カレンダーと非公開カレンダーの
  どちらを検索するのかを指定します。 未認証のセッションを使用していて MagicCookie
  もない場合は、 公開フィードのみしか使用できません。

- **Projection** は、サーバから返されるデータの件数とフォーマットを指定します。
  たいていの場合は "full" を指定することになるでしょう。 "basic"
  を指定すると、ほとんどのメタデータ情報を 各イベントの content
  フィールドの可読形式で格納します。 "composite"
  を指定すると、各イベントについてのコメントも情報に付加します。 "composite"
  は、"full" よりも巨大になることもあります。

.. _zend.gdata.event_retrieval.start_time:

開始時刻順によるイベントの取得
^^^^^^^^^^^^^^^

以下の例は、 ``Zend_Gdata_Query`` を使用して非公開フィードを指定しています。
つまり、認証済みの接続が必要となります。 認証に MagicCookie
を使用している場合は、可視性は "*private-magicCookieValue*"
としなければなりません。magicCookieValue のところは、Google Calendar で非公開 *XML*
アドレスを閲覧した際に取得したランダムな文字列となります。
イベントは開始時刻の順に取得され、 過去のイベントは返されません。

.. code-block:: php
   :linenos:

   $query = $service->newEventQuery();
   $query->setUser('default');
   // MagicCookie 認証の場合は
   // $query->setVisibility('private-magicCookieValue') とします
   $query->setVisibility('private');
   $query->setProjection('full');
   $query->setOrderby('starttime');
   $query->setFutureevents('true');

   // カレンダーサーバからイベントの一覧を取得します
   try {
       $eventFeed = $service->getCalendarEventFeed($query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "エラー: " . $e->getMessage();
   }

   // リストの内容を順に取得し、HTML のリストとして出力します
   echo "<ul>";
   foreach ($eventFeed as $event) {
       echo "<li>" . $event->title . " (Event ID: " . $event->id . ")</li>";
   }
   echo "</ul>";

ID や author、when、event status、visibility、web content、 そして content
などのさまざまなプロパティが ``Zend_Gdata_Calendar_EventEntry``
で使用できます。プロパティの一覧は `Zend Framework API ドキュメント`_ や `Calendar Protocol
Reference`_ を参照ください。

.. _zend.gdata.event_retrieval.date_range:

指定した日付の範囲からのイベントの取得
^^^^^^^^^^^^^^^^^^^

指定した範囲、たとえば 2006 年 12 月 1 日から 2006 年 12 月 15
日までのすべてのイベントを表示するには、 先ほどのサンプルに次の 2
行を追加します。 "*$query->setFutureevents('true')*" を削除することを忘れないでください。
*futureevents* を指定すると *startMin* や *startMax* を上書きしてしまうからです。

.. code-block:: php
   :linenos:

   $query->setStartMin('2006-12-01');
   $query->setStartMax('2006-12-16');

*startMin* は範囲に含まれますが、 *startMax*
は含まれないことに注意しましょう。上の例の場合、 2006-12-15 23:59:59
までのイベントが対象となります。

.. _zend.gdata.event_retrieval.fulltext:

全文検索によるイベントの取得
^^^^^^^^^^^^^^

指定した単語、たとえば "dogfood" を含むすべてのイベントを表示するには、
``setQuery()`` メソッドでクエリを作成します。

.. code-block:: php
   :linenos:

   $query->setQuery("dogfood");

.. _zend.gdata.event_retrieval.individual:

特定のイベントの取得
^^^^^^^^^^

特定のイベントを取得する場合は、そのイベントの ID をクエリで指定します。そして
``getCalendarEventFeed()`` ではなく ``getCalendarEventEntry()`` をコールします。

.. code-block:: php
   :linenos:

   $query = $service->newEventQuery();
   $query->setUser('default');
   $query->setVisibility('private');
   $query->setProjection('full');
   $query->setEvent($eventId);

   try {
       $event = $service->getCalendarEventEntry($query);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "エラー: " . $e->getMessage();
   }

同様に、もしそのイベントの *URL* がわかっているのなら、 それを直接
``getCalendarEntry()`` に渡して特定のイベントを取得することもできます。
この場合はクエリオブジェクトは不要です。 必要な情報は、イベントの *URL*
にすべて含まれているからです。

.. code-block:: php
   :linenos:

   $eventURL = "http://www.google.com/calendar/feeds/default/private"
             . "/full/g829on5sq4ag12se91d10uumko";

   try {
       $event = $service->getCalendarEventEntry($eventURL);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "エラー: " . $e->getMessage();
   }

.. _zend.gdata.calendar.creating_events:

イベントの作成
-------

.. _zend.gdata.calendar.creating_events.single:

一度だけのイベントの作成
^^^^^^^^^^^^

イベントをカレンダーに追加するには、 ``Zend_Gdata_EventEntry``
のインスタンスを作成して
そこに適切なデータを代入します。カレンダーサービスのインスタンス
(``Zend_Gdata_Calendar``) はそのデータを *XML* に変換し、カレンダーサーバに POST します。
イベントを作成するには、AuthSub 認証あるいは ClientAuth
認証でカレンダーサーバと接続する必要があります。

最低限設定しなければならない属性は、次のとおりです。

- **Title** は、Google Calendar でイベントの見出しとして表示される内容です。

- **When** は、そのイベントの期間を表します。
  オプションで、リマインダーを関連付けることができます。
  この属性については、次のセクションで詳しく説明します。

その他、オプションで設定できる属性は次のようになります。

- **Author** は、そのイベントを作成したユーザについての情報です。

- **Content** は、イベントの詳細情報です。 Google Calendar
  でそのイベントの詳細情報を開いたときに表示されます。

- **EventStatus** はそのイベントが確認済み (confirmed) なのか仮の予定 (tentative) なのか、
  あるいは取り消された (canceled) を表します。

- **Hidden** は、そのイベントを Google Calendar 上で非表示にします。

- **Transparency**
  は、そのイベントをユーザの予定表に反映させるかどうかを指定します。

- **WebContent** は、そのイベント内で外部のコンテンツへのリンクを指定します。

- **Where** は、そのイベントの場所を指定します。

- **Visibility** は、そのイベントを公開リスト上では非表示にします。

イベントの属性の一覧は、 `Zend Framework API ドキュメント`_ および `Calendar Protocol
Reference`_ を参照ください。 where
のように複数の値を持つことのある属性は配列で実装しています。
それにあわせて適切な形式にする必要があります。これらの属性には、
パラメータとしてオブジェクトを渡さなければならないことに注意しましょう。
文字列などを渡そうとすると、 *XML* への変換時にエラーとなります。

イベントの情報を設定したら、それをカレンダーサーバにアップロードします。
アップロードするには、カレンダーサーバの ``insertEvent()``
関数の引数としてそのイベントを渡します。

.. code-block:: php
   :linenos:

   // カレンダーサービスのマジックメソッドで、新規エントリを作成します
   $event= $service->newEventEntry();

   // イベントの情報を設定します
   // 各属性は、対応するクラスのインスタンスとして作成されることに注意しましょう
   $event->title = $service->newTitle("My Event");
   $event->where = array($service->newWhere("Mountain View, California"));
   $event->content =
       $service->newContent(" This is my awesome event. RSVP required.");

   // RFC 3339 形式で日付を指定します
   $startDate = "2008-01-20";
   $startTime = "14:00";
   $endDate = "2008-01-20";
   $endTime = "16:00";
   $tzOffset = "-08";

   $when = $service->newWhen();
   $when->startTime = "{$startDate}T{$startTime}:00.000{$tzOffset}:00";
   $when->endTime = "{$endDate}T{$endTime}:00.000{$tzOffset}:00";
   $event->when = array($when);

   // イベントをカレンダーサーバにアップロードします
   // サーバに記録したイベントのコピーが返されます
   $newEvent = $service->insertEvent($event);

.. _zend.gdata.calendar.creating_events.schedulers_reminders:

イベントのスケジュールおよびリマインダー
^^^^^^^^^^^^^^^^^^^^

イベントの開始時刻と期間は *when* プロパティによって決まります。 この中には
*startTime*\ 、 *endTime* および *valueString* というプロパティが含まれます。 *StartTime*
および *EndTime* がイベントの期間を表します。一方 *valueString*
は現在使われていません。

全日のイベントを作成するには、 *startTime* および *endTime*
で日付のみを指定し、時刻は省略します。
同様に、期間がゼロのイベントを作成する場合は *endTime* を省略します。
すべての場合について、日付や時刻は `RFC3339`_ 形式で指定しなければなりません。

.. code-block:: php
   :linenos:

   // 2007 年 12 月 5 日の午後 2 時 (UTC-8) から
   // 1 時間のイベントを設定します
   $when = $service->newWhen();
   $when->startTime = "2007-12-05T14:00:00-08:00";
   $when->endTime="2007-12-05T15:00:00:00-08:00";

   // when プロパティをイベントに追加します
   $event->when = array($when);

*when* 属性では、
ユーザへのリマインダーをいつ送信するかを指定することもできます。
リマインダーは配列形式で保存し、各イベントには 5
つまでのリマインダーを関連づけることができます。

*reminder* を指定するには、少なくともふたつの属性 *method* と time
を指定する必要があります。 *method* には "alert"、"email" あるいは "sms"
を文字列で指定します。time は整数値で指定します。 *minutes*\ 、 *hours*\ 、 *days*
を指定するか、あるいは *absoluteTime* を指定します。
しかし、指定するのはこれらの中のどれかひとつのみとしなければなりません。
複数の単位が必要な場合は、一番小さい単位に換算して指定します。 たとえば、1
時間 30 分の場合は 90 分と指定しなければなりません。

.. code-block:: php
   :linenos:

   // 新しいリマインダーオブジェクトを作成します。
   // 予定の 10 分前に、メールでメッセージを送るようにします
   $reminder = $service->newReminder();
   $reminder->method = "email";
   $reminder->minutes = "10";

   // 既存のイベントの when プロパティにリマインダーを適用します
   $when = $event->when[0];
   $when->reminders = array($reminder);

.. _zend.gdata.calendar.creating_events.recurring:

繰り返し発生するイベントの作成
^^^^^^^^^^^^^^^

繰り返し発生するイベントの作成方法は、
一回しか発生しないイベントの場合と同じです。 ただ、when 属性の代わりに recurrence
属性を指定する必要があります。 recurrence
属性は、そのイベントの繰り返しパターンを文字列で指定します。
この文字列は、iCalendar の標準規格 (`RFC 2445`_) で定義されているものを使用します。

繰り返しパターンの例外は、別途 *recurrenceException* 属性で指定します。
しかし、iCalendar の標準規格では第二の繰り返しパターンを定義できます。
どちらかを使用するといいでしょう。

繰り返しパターンの解析は複雑なので、詳細はこのドキュメントでは扱いません。
詳細な情報を知りたい場合は、 `Google Data APIs Developer Guide の Common Elements セクション`_
あるいは *RFC* 2445 を参照ください。

.. code-block:: php
   :linenos:

    // カレンダーサービスのマジックメソッドで、新規エントリを作成します
   $event= $service->newEventEntry();

   // イベントの情報を設定します
   // 各属性は、対応するクラスのインスタンスとして作成されることに注意しましょう
   $event->title = $service->newTitle("My Recurring Event");
   $event->where = array($service->newWhere("Palo Alto, California"));
   $event->content =
       $service->newContent(' This is my other awesome event, ' .
                            ' occurring all-day every Tuesday from ' .
                            '2007-05-01 until 207-09-04. No RSVP required.');

   // 繰り返しパターンの期間と頻度を指定します

   $recurrence = "DTSTART;VALUE=DATE:20070501\r\n" .
           "DTEND;VALUE=DATE:20070502\r\n" .
           "RRULE:FREQ=WEEKLY;BYDAY=Tu;UNTIL=20070904\r\n";

   $event->recurrence = $service->newRecurrence($recurrence);

   // イベントをカレンダーサーバにアップロードします
   // サーバに記録したイベントのコピーが返されます
   $newEvent = $service->insertEvent($event);

.. _zend.gdata.calendar.creating_events.quickadd:

QuickAdd の使用法
^^^^^^^^^^^^^

QuickAdd とは、自由形式のテキストでイベントを作成する機能のことです。
たとえば、"Dinner at Joe's Diner on Thursday" という文字列を指定すると、 タイトルが
"Dinner"、場所が "Joe's Diner"、日付が "Thursday" のイベントが作成されます。QuickAdd
機能を使用するには、 *QuickAdd* プロパティを ``TRUE`` に設定し、 任意のテキストを
*content* プロパティに指定します。

.. code-block:: php
   :linenos:

   // カレンダーサービスのマジックメソッドで、新規エントリを作成します
   $event= $service->newEventEntry();

   // イベントの情報を設定します
   $event->content= $service->newContent("Dinner at Joe's Diner on Thursday");
   $event->quickAdd = $service->newQuickAdd("true");

   // イベントをカレンダーサーバにアップロードします
   // サーバに記録したイベントのコピーが返されます
   $newEvent = $service->insertEvent($event);

.. _zend.gdata.calendar.modifying_events:

イベントの変更
-------

イベントのインスタンスを取得したら、
新しいイベントを作成する場合と同じようにしてその属性を変更できます。
変更が完了したら、そのイベントの ``save()``
メソッドをコールすると、変更内容をカレンダーサーバにアップロードします。
そして、更新後のイベントのコピーを返します。

イベントを取得した後で別のユーザがそのイベントを変更していた場合、 ``save()``
は失敗し、ステータスコード 409 (Conflict) を返します。これを解決するには、
変更を加える直前に最新のコピーを取得する必要があります。

.. code-block:: php
   :linenos:

   // ユーザのイベントリストから最初のイベントを取得します
   $event = $eventFeed[0];

   // タイトルを変更します
   $event->title = $service->newTitle("Woof!");

   // 変更をサーバにアップロードします
   try {
       $event->save();
   } catch (Zend_Gdata_App_Exception $e) {
       echo "エラー: " . $e->getMessage();
   }

.. _zend.gdata.calendar.deleting_events:

イベントの削除
-------

カレンダーのイベントを削除する方法には二通りあります。
ひとつはカレンダーサービスの ``delete()`` メソッドにそのイベントの編集用 *URL*
を指定する方法、 もうひとつはそのイベント自身の ``delete()``
メソッドをコールすることです。

どちらの場合も、クエリのパラメータ *updateMin*
を指定した場合は削除後もそのイベントが
プライベートイベントフィードとして残ります。
削除されたイベントと通常のイベントを区別するには *eventStatus*
プロパティを確認します。 削除されたイベントは、このプロパティが
"http://schemas.google.com/g/2005#event.canceled" に設定されています。

.. code-block:: php
   :linenos:

   // 方法 1: イベントを直接削除します
   $event->delete();

.. code-block:: php
   :linenos:

   // 方法 2: カレンダーサービスに、
   // 削除したいイベントの編集 URL を渡します
   $service->delete($event->getEditLink()->href);

.. _zend.gdata.calendar.comments:

イベントのコメントへのアクセス
---------------

full イベントビューでは、コメントはイベントのエントリに保存されません。
その代わりとして、各イベントにはコメントの *URL* が含まれており、
それを使用して手動でコメントを取得することになります。

コメントの操作方法は、イベントの場合とよく似ています。
ただ、使用するフィードクラスやエントリクラスは異なります。
またイベントのメタデータにある where や when
といったプロパティはコメントにはありません。コメントの発言者は *author*
プロパティに、そしてコメントの本文は *content* プロパティに格納されます。

.. code-block:: php
   :linenos:

   // コメントの URL を、フィードリストの最初のイベントから取得します
   $event = $eventFeed[0];
   $commentUrl = $event->comments->feedLink->url;

   // そのイベントのコメント一覧を取得します
   try {
   $commentFeed = $service->getFeed($commentUrl);
   } catch (Zend_Gdata_App_Exception $e) {
       echo "エラー: " . $e->getMessage();
   }

   // 各コメントを HTML のリストで出力します
   echo "<ul>";
   foreach ($commentFeed as $comment) {
       echo "<li><em>Comment By: " . $comment->author->name "</em><br/>" .
            $comment->content . "</li>";
   }
   echo "</ul>";



.. _`http://code.google.com/apis/calendar/overview.html`: http://code.google.com/apis/calendar/overview.html
.. _`Google Data API Developer's Guide の Authentication Overview`: http://code.google.com/apis/gdata/auth.html
.. _`Google Data APIs Protocol Reference の Queries セクション`: http://code.google.com/apis/gdata/reference.html#Queries
.. _`Zend Framework API ドキュメント`: http://framework.zend.com/apidoc/core/
.. _`Calendar Protocol Reference`: http://code.google.com/apis/gdata/reference.html
.. _`RFC3339`: http://www.ietf.org/rfc/rfc3339.txt
.. _`RFC 2445`: http://www.ietf.org/rfc/rfc2445.txt
.. _`Google Data APIs Developer Guide の Common Elements セクション`: http://code.google.com/apis/gdata/elements.html#gdRecurrence
