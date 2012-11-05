.. EN-Revision: none
.. _zend.gdata.introduction:

導入
==

Google Data *API* は、Google
のオンラインサービスに対するプログラマ向けのインターフェイスです。 Google data
Protocol は `Atom Publishing Protocol`_
に基づいており、クライアントアプリケーションからのデータの問い合わせ、
データの投稿、更新、削除などを標準の *HTTP* と Atom syndication formation で行います。
``ZendGData`` コンポーネントは *PHP* 5 用のインターフェイスで、Google Data に *PHP*
からアクセスするためのものです。 ``ZendGData`` コンポーネントは、Atom Publishing Protocol
を実装したその他のサービスへのアクセスもサポートしています。

Google Data *API* についての詳細な情報は `http://code.google.com/apis/gdata/`_ を参照ください。

``ZendGData`` でアクセスできるサービスには次のようなものがあります。



   - :ref:`Google Calendar <zend.gdata.calendar>`
     は、オンラインカレンダーアプリケーションです。

   - :ref:`Google Spreadsheets <zend.gdata.spreadsheets>`
     は、オンラインで共同作業を行えるスプレッドシートツールです。
     アプリケーションで使用するデータの保存場所としても使用できます。

   - :ref:`Google Documents List <zend.gdata.docs>` は、その Google
     アカウントに保存されているすべてのスプレッドシートやワープロ文書、
     プレゼンテーションの一覧を取得します。

   - :ref:`Google Provisioning <zend.gdata.gapps>` は、Google Apps がホストするドメイン上の
     ユーザアカウントやニックネーム、グループ、そしてメーリングリストの
     作成、取得、更新、削除を行うものです。

   - :ref:`YouTube <zend.gdata.youtube>` は、動画やコメント、お気に入り、登録チャンネル、
     ユーザのプロファイルといった情報を検索して取得できます。

   - :ref:`Picasa Web Albums <zend.gdata.photos>`
     は、オンラインの写真共有アプリケーションです。

   - `Google Blogger`_ は、人気のあるインターネットプロバイダです。
     "ボタンひとつで簡単に" 記事を配信できます。

   - Google CodeSearch
     を使用すると、さまざまなプロジェクトが公開しているソースコードを検索できます。

   - Google Notebook は、メモ帳の内容を一般に公開できます。



.. note::

   **サポートしていないサービス**

   ``ZendGData`` には、これら以外の Google のサービス
   (例えば検索、Gmail、翻訳、マップなど)
   に対するインターフェイスは含まれていません。 Google Data *API*
   をサポートしているサービスにのみ対応しています。

.. _zend.gdata.introduction.structure:

ZendGData の構造
--------------

``Zend_Gata`` は、いくつかの型のクラスを組み合わせたものです。

   - サービスクラス - これは ``ZendGData\App`` を継承したものです。 ``ZendGData`` や
     ``ZendGData\Spreadsheets`` といったその他のクラスもここに含まれます。
     これらのクラスは APP や GData サービス とのやり取りを行うもので、
     フィードを取得したりエントリを取得したり、
     あるいはエントリを投稿したり更新したり削除したりといったことができます。

   - クエリクラス - これは ``ZendGData\Query`` を継承したものです。
     各サービス専用のクラス、たとえば ``ZendGData_Spreadsheets\ListQuery`` や
     ``ZendGData_Spreadsheets\CellQuery`` もここに含まれます。 クエリクラスは、GData
     サービスからデータを取得するためのクエリを作成するものです。 ``setUpdatedMin()``
     や ``setStartIndex()``\ 、そして ``getPublishedMin()`` といったメソッドが存在します。
     クエリクラスには、出来上がったクエリの *URL* を生成するためのメソッド
     *getQueryUrl* もあります。 また、 ``getQueryString()`` メソッドを使用すると、 *URL*
     のクエリ文字列部分を取得できます。

   - フィードクラス - これは ``ZendGData_App\Feed`` を継承したものです。 ``ZendGData\Feed``
     や ``ZendGData_Spreadsheets\SpreadsheetFeed``\ 、 ``ZendGData_Spreadsheets\ListFeed``
     といったその他のクラスもここに含まれます。
     これらのクラスはサービスから取得したエントリのフィードを表すものです。
     サービスから返されたデータを取得するために使用します。

   - エントリクラス - これは ``ZendGData_App\Entry`` を継承したものです。 ``ZendGData\Entry``
     や ``ZendGData_Spreadsheets\ListEntry`` といったその他のクラスもここに含まれます。
     これらのクラスは、サービスから取得したエントリを表すものです。また、
     サービスに送信するデータを作成するためにも用います。
     エントリのプロパティの値（たとえばスプレッドシートのセルの値など）
     を設定できるだけでなく、このオブジェクトを使用して
     既存エントリの更新や削除のリクエストを送信することもできます。 たとえば
     ``$entry->save()``
     をコールすると、変更した内容を元のエントリに書き戻します。また
     ``$entry->delete()`` はそのエントリをサーバから削除します。

   - その他のデータモデルクラス - これは ``ZendGData_App\Extension``
     を継承したものです。ここには、 ``ZendGData\App\Extension\Title`` (atom:title *XML*
     要素を表します) や ``ZendGData_Extension\When`` (GData Event "Kind" で使用する gd:when *XML*
     要素を表します)、そして ``ZendGData_Extension\Cell`` (Google Spreadsheets で使用する gs:cell
     *XML* 要素を表します) といったクラスが含まれます。
     これらのクラスは、サービスから取得したデータを保存したり
     サービスに送信するデータを構築したりするために用いるものです。
     プロパティへのアクセス用のメソッドが用意されています。たとえば ``setText()``
     はその要素の子テキストノードの内容を設定し、 ``getText()``
     はその要素のテキストノードの内容を取得します。 また ``getStartTime()`` は When
     要素の開始時刻属性を取得します。 そのほかにも同様のメソッドがあります。
     データモデルクラスには、その他のメソッドもあります。 ``getDOM()``
     は、その要素とすべての子要素を DOM 形式で表したものを返し、 ``transferFromDOM()``
     は DOM ツリーをもとにしたデータモデルを作成します。



.. _zend.gdata.introduction.services:

Google サービスの使用法
---------------

Google データサービスは、Atom Publishing Protocol (APP) および Atom syndication format
に基づいたサービスです。 ``ZendGData`` コンポーネントを用いて APP や Google
サービスを扱うには、 ``ZendGData\App`` や ``ZendGData`` そして ``ZendGData\Spreadsheets``
などのサービスクラスを使用する必要があります。
サービスクラスには、サービスからデータのフィードを取得したり
新しいエントリをフィードに挿入したり
既存のエントリを更新したり削除したりといったメソッドがあります。

注意: ``ZendGData`` を用いた実際に動作するサンプルプログラムが *demos/Zend/Gdata*
ディレクトリにあります。
このサンプルはコマンドラインで動かすように作られていますが、
ウェブアプリケーション版にも簡単に書き換えられるでしょう。

.. _zend.gdata.introduction.magicfactory:

ZendGData クラスのインスタンスの取得
------------------------

Zend Framework の命名規約では、すべてのクラスは
その存在位置のディレクトリ構造に基づいた名前をつける必要があります。 たとえば
Spreadsheets に関する拡張クラスは *Zend/Gdata/Spreadsheets/Extension/...* 配下に置かれ、
その結果、クラス名は ``ZendGData\Spreadsheets\Extension\...``
となります。ということは、スプレッドシートのセル要素のインスタンスを作成しようとしたら、
恐ろしく長い名前をタイプすることになるということです!

ということで、すべてのサービスクラス (``ZendGData\App``\ 、 ``ZendGData``\ 、
``ZendGData\Spreadsheets`` など) に特別なファクトリメソッドを用意するようにしました。
これを用いることで、データモデルやクエリ、
その他のクラスのインスタンスをより簡単に作成できるようになります。
このファクトリメソッドは、マジックメソッド *__call*
を用いて実装しています。このメソッドで、 *$service->newXXX(arg1, arg2, ...)*
というコールをすべて処理しています。 XXX
の値に基づいて、登録されているすべての 'パッケージ' からクラスを探します。
以下に例を示します。

.. code-block:: php
   :linenos:

   $ss = new ZendGData\Spreadsheets();

   // ZendGData\App\Spreadsheets\CellEntry を作成します
   $entry = $ss->newCellEntry();

   // ZendGData\App\Spreadsheets\Extension\Cell を作成します
   $cell = $ss->newCell();
   $cell->setText('My cell value');
   $cell->setRow('1');
   $cell->setColumn('3');
   $entry->cell = $cell;

   // ... $entry を使用して、Google Spreadsheet の内容を更新します

継承ツリー内にある各サービス用クラス内で、 適切な 'パッケージ' (ディレクトリ)
を登録します。 ファクトリメソッドは、これを使用してクラスを探します。

.. _zend.gdata.introduction.authentication:

Google Data クライアント認証
--------------------

ほとんどの Google Data サービスは、
個人データへのアクセスやデータの保存、削除の前に Google
サーバに対する認証を要求します。 Google Data の認証用に提供される実装は :ref:`AuthSub
<zend.gdata.authsub>` および :ref:`ClientLogin <zend.gdata.clientlogin>` の二種類があります。
``ZendGData`` ではこれら両方の方式に対するインターフェイスを用意しています。

Google Data サービスに対するその他大半の問い合わせは、 認証を必要としません。

.. _zend.gdata.introduction.dependencies:

依存性
---

``ZendGData`` は :ref:`Zend\Http\Client <zend.http.client>` を用いてリクエストを google.com
に送信し、結果を取得します。 ほとんどの Google Data リクエストに対する応答は
``ZendGData_App\Feed`` あるいは ``ZendGData_App\Entry`` クラスのサブクラスで返されます。

``ZendGData`` は、 *PHP* アプリケーションの稼動しているホストが
インターネットに直接つながっていることを想定しています。 ``ZendGData``
クライアントは Google Data サーバへの接続を行います。

.. _zend.gdata.introduction.creation:

新しい Gdata クライアントの作成
-------------------

``ZendGData\App`` クラス、 ``ZendGData`` クラス、
あるいはそのサブクラスのひとつのオブジェクトを作成します。
各サブクラスではサービス固有のヘルパーメソッドを提供します。

``ZendGData\App`` のコンストラクタに渡すオプションの引数は :ref:`Zend\Http\Client
<zend.http.client>` のインスタンスです。このパラメータを渡さなかった場合は、
``ZendGData`` はデフォルトの ``Zend\Http\Client`` オブジェクトを作成します。
これには、プライベートフィードにアクセスするための認証データは設定されていません。
``Zend\Http\Client`` オブジェクトを自分で指定すると、
クライアントオブジェクトに対する設定オプションを指定できます。

.. code-block:: php
   :linenos:

   $client = new Zend\Http\Client();
   $client->setConfig( ...オプション... );

   $gdata = new ZendGData\Gdata($client);

Zend Framework 1.7 以降、プロトコルのバージョン管理のサポートが追加されました。
これにより、クライアントおよびサーバで新機能をサポートしつつ、
過去との互換性を保持できるようになります。
ほとんどのサービスはバージョン管理を自前で行う必要はありませんが、 ``ZendGData``
のインスタンスを直接作成する場合 (サブクラスを使わない場合)
は、必要なプロトコルのバージョンを指定してサーバの機能にアクセスする必要があります。

.. code-block:: php
   :linenos:

   $client = new Zend\Http\Client();
   $client->setConfig( ...オプション... );

   $gdata = new ZendGData\Gdata($client);
   $gdata->setMajorProtocolVersion(2);
   $gdata->setMinorProtocolVersion(null);

認証済みの ``Zend\Http\Client`` オブジェクトを作成する方法については、
認証のセクションも参照ください。

.. _zend.gdata.introduction.parameters:

共通のクエリパラメータ
-----------

パラメータを指定することで、 ``ZendGData`` での問い合わせをカスタマイズできます。
クエリのパラメータは、 ``ZendGData\Query`` のサブクラスを使用して指定します。
``ZendGData\Query`` クラスにはクエリパラメータを設定するメソッドが含まれ、
これを用いて GData サービスにアクセスします。 たとえば Spreadsheets
のような個々のサービスでも
クエリクラスを用意しており、そのサービスやフィードに合わせた独自のパラメータを定義しています。
Spreadsheets の CellQuery クラスは Cell Feed に対する問い合わせを行い、ListQuery クラスは
List Feed に対する問い合わせを行います。
それぞれのフィードに対して別々のパラメータを指定できます。 GData
全体で使用できるパラメータについて、 以下で説明します。



- *q* パラメータはテキストのクエリ文字列を指定します。
  パラメータの値は文字列となります。

  このパラメータを設定するには ``setQuery()`` 関数を使用します。

- *alt* パラメータはフィードの形式を指定します。 このパラメータには *atom*\ 、 *rss*\
  、 *json*\ 、 あるいは *json-in-script* のいずれかを指定します。
  このパラメータを指定しなかった場合、デフォルトのフィードの形式は *atom*
  となります。 注意: ``ZendGData`` で処理できるのは、 atom
  フィード形式の出力だけであることに注意しましょう。 ``Zend\Http\Client``
  を使用するとその他の形式のフィードも取得できます。 その際は、 ``ZendGData\Query``
  クラスやそのサブクラスが作成したクエリ *URL* を使用します。

  このパラメータを設定するには ``setAlt()`` 関数を使用します。

- *maxResults* パラメータはフィード内のエントリ数を制限します。
  整数値を指定します。返されるフィード内のエントリの数は、
  この値を超えることはありません。

  このパラメータを設定するには ``setMaxResults()`` 関数を使用します。

- *startIndex* パラメータは、 フィードで返される最初のエントリの番号を指定します。
  それ以前の番号のエントリは読み飛ばされます。

  このパラメータを設定するには ``setStartIndex()`` 関数を使用します。

- *updatedMin* パラメータおよび *updatedMax*
  パラメータは、エントリの日付の範囲を指定します。 *updatedMin* を指定すると、
  それより前に更新されたエントリはフィードに含まれません。 同様に、 *updatedMax*
  で指定した日付より後で更新されたエントリもフィードに含まれません。

  これらのパラメータには、タイムスタンプを表す数値を指定します。 あるいは
  日付/時刻 を表す文字列を指定することもできます。

  これらのパラメータを設定するには ``setUpdatedMin()`` および ``setUpdatedMax()``
  関数を使用します。

これらの *set* 関数に対応する *get* 関数もあります。

.. code-block:: php
   :linenos:

   $query = new ZendGData\Query();
   $query->setMaxResults(10);
   echo $query->getMaxResults();   // 10 を返します

``ZendGData`` クラスでは、
特別なゲッターメソッドおよびセッターメソッドも実装しています。
つまり、パラメータの名前をクラスの仮想的なメンバとして扱うことができます。

.. code-block:: php
   :linenos:

   $query = new ZendGData\Query();
   $query->maxResults = 10;
   echo $query->maxResults;        // 10 を返します

すべてのパラメータを消去するには ``resetParameters()`` を使用します。複数のクエリで
``ZendGData`` を使いまわす場合などに便利です。

.. code-block:: php
   :linenos:

   $query = new ZendGData\Query();
   $query->maxResults = 10;
   // ...フィードを取得します...

   $gdata->resetParameters();      // すべてのパラメータを消去します
   // ...別のフィードを取得します...

.. _zend.gdata.introduction.getfeed:

フィードの取得
-------

``getFeed()`` を使用して、指定した *URI* からフィードを取得します。
この関数は、getFeed の二番目の引数で指定したクラスのインスタンスを返します。
このクラスのデフォルトは ``ZendGData\Feed`` です。

.. code-block:: php
   :linenos:

   $gdata = new ZendGData\Gdata();
   $query = new ZendGData\Query(
           'http://www.blogger.com/feeds/blogID/posts/default');
   $query->setMaxResults(10);
   $feed = $gdata->getFeed($query);

この後の節で、各 Google Data
サービス用のヘルパークラス固有の関数について説明します。これらの関数により、
対応するサービスにあわせた適切な *URI* からフィードを取得できるようになります。

.. _zend.gdata.introduction.paging:

複数ページのフィードの扱い方
--------------

多くのエントリが含まれるフィードを取得した場合、
そのフィードはいくつかの「ページ」に分かれていることがあるかもしれません。
そのような場合には、各ページには次のページへのリンクが含まれることになります。
このリンクにアクセスするには ``getLink('next')`` を使用します。
この例は、フィードの次のページを取得する方法を示すものです。

.. code-block:: php
   :linenos:

   function getNextPage($feed) {
       $nextURL = $feed->getLink('next');
       if ($nextURL !== null) {
           return $gdata->getFeed($nextURL);
       } else {
           return null;
       }
   }

もしこのようにページに分かれているのが気に入らない場合は、
フィードの最初のページを ``ZendGData\App::retrieveAllEntriesForFeed()``
に渡しましょう。そうすると、
すべてのエントリの内容をひとつのフィードにまとめてくれます。
この関数の使用法を、次の例で示します。

.. code-block:: php
   :linenos:

   $gdata = new ZendGData\Gdata();
   $query = new ZendGData\Query(
           'http://www.blogger.com/feeds/blogID/posts/default');
   $feed = $gdata->retrieveAllEntriesForFeed($gdata->getFeed($query));

大きなフィードに対してこの関数をコールすると、
処理に時間がかかるということに注意しましょう。 ``set_time_limit()`` で *PHP*
の実行時間制限を拡大する必要があるかもしれません。

.. _zend.gdata.introduction.usefeedentry:

フィードやエントリ内のデータの操作
-----------------

フィードを取得したら、次はそのデータを読み込んだり
そこに含まれるエントリを読み込んだりする番です。
これには各データモデルクラスのアクセス用メソッドを使用するか、
あるいはマジックメソッドを使用します。以下に例を示します。

.. code-block:: php
   :linenos:

   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $gdata = new ZendGData\Gdata($client);
   $query = new ZendGData\Query(
           'http://www.blogger.com/feeds/blogID/posts/default');
   $query->setMaxResults(10);
   $feed = $gdata->getFeed($query);
   foreach ($feed as $entry) {
       // マジックメソッドを使用します
       echo 'Title: ' . $entry->title->text;
       // 定義されているアクセス用メソッドを使用します
       echo 'Content: ' . $entry->getContent()->getText();
   }

.. _zend.gdata.introduction.updateentry:

エントリの更新
-------

エントリを取得したら、それを更新してサーバに保存できます。以下に例を示します。

.. code-block:: php
   :linenos:

   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $gdata = new ZendGData\Gdata($client);
   $query = new ZendGData\Query(
           'http://www.blogger.com/feeds/blogID/posts/default');
   $query->setMaxResults(10);
   $feed = $gdata->getFeed($query);
   foreach ($feed as $entry) {
       // タイトルに 'NEW' を追加します
       echo 'Old Title: ' . $entry->title->text;
       $entry->title->text = $entry->title->text . ' NEW';

       // エントリの内容を更新します
       $newEntry = $entry->save();
       echo 'New Title: ' . $newEntry->title->text;
   }

.. _zend.gdata.introduction.post:

Google サーバへのエントリの送信
-------------------

``ZendGData`` オブジェクトの関数 ``insertEntry()`` にアップロードしたいデータを指定し、
新しいエントリを Google Data サービスに保存します。

各サービス用のデータモデルクラスを使用して適切なエントリを作成し、 Google
のサービスに投稿できます。 ``insertEntry()`` 関数には、 ``ZendGData_App\Entry``
の子クラスに投稿内容を格納して渡します。 このメソッドは ``ZendGData_App\Entry``
の子クラスを返します。 これは、サーバから返されたエントリの状態を表します。

もうひとつの方法として、そのエントリの内容を *XML* 構造の文字列として作成して
``insertEntry()`` 関数に渡すこともできます。

.. code-block:: php
   :linenos:

   $gdata = new ZendGData\Gdata($authenticatedHttpClient);

   $entry = $gdata->newEntry();
   $entry->title = $gdata->newTitle('Playing football at the park');
   $content =
       $gdata->newContent('We will visit the park and play football');
   $content->setType('text');
   $entry->content = $content;

   $entryResult = $gdata->insertEntry($entry,
           'http://www.blogger.com/feeds/blogID/posts/default');

   echo 'この結果のエントリの <id> は、' . $entryResult->id->text;

エントリを送信するには、認証済みの ``Zend\Http\Client``
を使用する必要があります。これは、 ``ZendGData\AuthSub`` クラスあるいは
``ZendGData\ClientLogin`` クラスを使用して作成します。

.. _zend.gdata.introduction.delete:

Google サーバからのデータの削除
-------------------

方法 1: ``ZendGData`` オブジェクトの関数 ``delete()``
に削除したいエントリを指定して、Google Data サービスからデータを削除します。
フィードエントリの編集用 *URL* を ``delete()`` メソッドに渡します。

方法 2: あるいは、Google サービスから取得したエントリに対して ``$entry->delete()``
をコールすることもできます。

.. code-block:: php
   :linenos:

   $gdata = new ZendGData\Gdata($authenticatedHttpClient);
   // Google Data のフィード
   $feedUri = ...;
   $feed = $gdata->getFeed($feedUri);
   foreach ($feed as $feedEntry) {
       // 方法 1 - エントリを直接削除します
       $feedEntry->delete();
       // 方法 2 - 編集用 URL を $gdata->delete()
       // に渡してエントリを削除します
       // $gdata->delete($feedEntry->getEditLink()->href);
   }

エントリを削除するには、認証済みの ``Zend\Http\Client``
を使用する必要があります。これは、 ``ZendGData\AuthSub`` クラスあるいは
``ZendGData\ClientLogin`` クラスを使用して作成します。



.. _`Atom Publishing Protocol`: http://ietfreport.isoc.org/idref/draft-ietf-atompub-protocol/
.. _`http://code.google.com/apis/gdata/`: http://code.google.com/apis/gdata/
.. _`Google Blogger`: http://code.google.com/apis/blogger/developers_guide_php.html
