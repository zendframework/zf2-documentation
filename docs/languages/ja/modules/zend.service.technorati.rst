.. EN-Revision: none
.. _zend.service.technorati:

Zend\Service\Technorati
=======================

.. _zend.service.technorati.introduction:

導入
--

``Zend\Service\Technorati`` は、Technorati *API*
を使うための簡単で直感的なオブジェクト指向インターフェイスを提供します。
利用可能なすべての `Technorati API クエリ`_ にアクセスすることができ、 *API* が返す XML
形式のレスポンスを *PHP* で扱いやすいオブジェクトで返します。

`Technorati`_ は、人気のあるブログ検索エンジンのひとつです。その *API*
を使用すると、 特定のブログについての情報を取得したり、
指定したタグやフレーズにマッチするブログの著者の情報を取得したりできます。
使用できるクエリの一覧は、 `Technorati API ドキュメント`_
あるいはこのドキュメントの :ref:`使用できる Technorati クエリ
<zend.service.technorati.queries>` を参照ください。

.. _zend.service.technorati.getting-started:

さあ始めましょう
--------

Technorati *API* を使用するには、キーが必要です。 *API*
キーを取得するには、まず最初に `Technorati アカウントを作成`_ し、それから `API
キーのセクション`_ に行ってください。

.. note::

   **API キーの制限**

   一日あたり最大 500 までの Technorati *API* コールを無料で行うことができます。
   現在の Technorati *API*
   のライセンスによってはその他の使用制限が適用されるかもしれません。

*API* キーを取得したら、いよいよ ``Zend\Service\Technorati`` を使うことができます。

.. _zend.service.technorati.making-first-query:

はじめてのクエリ
--------

クエリを実行するにはまず最初に *API* キーを使用して ``Zend\Service\Technorati``
のインスタンスを作成します。
そしてクエリの形式を選択し、引数を指定したうえでそれをコールします。

.. _zend.service.technorati.making-first-query.example-1:

.. rubric:: はじめてのクエリの実行

.. code-block:: php
   :linenos:

   // API_KEY を指定して
   // Zend\Service\Technorati を作成します
   $technorati = new Zend\Service\Technorati('VALID_API_KEY');

   // Technorati で PHP というキーワードを検索します
   $resultSet = $technorati->search('PHP');

検索用のメソッドにはオプションパラメータの配列を渡すことができます。
これを使用すると、クエリをさらに絞り込むことができます。

.. _zend.service.technorati.making-first-query.example-2:

.. rubric:: クエリの精度の向上

.. code-block:: php
   :linenos:

   // API_KEY を指定して
   // Zend\Service\Technorati を作成します
   $technorati = new Zend\Service\Technorati('VALID_API_KEY');

   // クエリをフィルタリングし、あまり影響力のない
   // (あまり他からリンクされていない) ブログを結果から除外します
   $options = array('authority' => 'a4');

   // Technorati で PHP というキーワードを検索します
   $resultSet = $technorati->search('PHP', $options);

``Zend\Service\Technorati`` のインスタンスは使い捨てのオブジェクトではありません。
したがって、クエリをコールするたびに毎回新たなインスタンスを作成するなどということは不要です。
一度作成した ``Zend\Service\Technorati``
オブジェクトを、気の済むまで使い回せばいいのです。

.. _zend.service.technorati.making-first-query.example-3:

.. rubric:: ひとつの Zend\Service\Technorati インスタンスでの複数のクエリの送信

.. code-block:: php
   :linenos:

   // API_KEY を指定して
   // Zend\Service\Technorati を作成します
   $technorati = new Zend\Service\Technorati('VALID_API_KEY');

   // Technorati で PHP というキーワードを検索します
   $search = $technorati->search('PHP');

   // Technorati で一番よく登録されているタブを取得します
   $topTags = $technorati->topTags();

.. _zend.service.technorati.consuming-results:

結果の取得
-----

クエリの結果は、二種類の結果オブジェクトのうちのいずれかの形式で取得できます。

まず最初の形式は ``Zend\Service_Technorati\*ResultSet``
オブジェクトで表されるものです。結果セットオブジェクトは、
基本的には結果オブジェクトのコレクションとなります。これは基底クラス
``Zend\Service_Technorati\ResultSet`` を継承したもので、 *PHP* の *SeekableIterator*
インターフェイスを実装しています。
この結果セットを使用するいちばんよい方法は、 *PHP* の *foreach*
文を用いてループ処理することです。

.. _zend.service.technorati.consuming-results.example-1:

.. rubric:: 結果セットオブジェクトの取得

.. code-block:: php
   :linenos:

   // API_KEY を指定して
   // Zend\Service\Technorati を作成します
   $technorati = new Zend\Service\Technorati('VALID_API_KEY');

   // Technorati で PHP というキーワードを検索します
   // $resultSet は Zend\Service_Technorati\SearchResultSet のインスタンスです
   $resultSet = $technorati->search('PHP');

   // 結果オブジェクトをループします
   foreach ($resultSet as $result) {
       // $result は Zend\Service_Technorati\SearchResult のインスタンスです
   }

``Zend\Service_Technorati\ResultSet`` は *SeekableIterator*
インターフェイスを実装しているので、結果コレクション内での位置を指定して
特定の結果オブジェクトを取得することもできます。

.. _zend.service.technorati.consuming-results.example-2:

.. rubric:: 特定の結果セットオブジェクトの取得

.. code-block:: php
   :linenos:

   // API_KEY を指定して
   // Zend\Service\Technorati を作成します
   $technorati = new Zend\Service\Technorati('VALID_API_KEY');

   // Technorati で PHP というキーワードを検索します
   // $resultSet は Zend\Service_Technorati\SearchResultSet のインスタンスです
   $resultSet = $technorati->search('PHP');

   // $result は Zend\Service_Technorati\SearchResult のインスタンスです
   $resultSet->seek(1);
   $result = $resultSet->current();

.. note::

   *SeekableIterator* は配列として動作し、 そのインデックスは 0
   から始まります。インデックス 1 を指定すると、コレクション内の 2
   番目の結果を取得することになります。

2 番目の形式は、単体の特別な結果オブジェクトで表されるものです。
``Zend\Service_Technorati\GetInfoResult``\ 、 ``Zend\Service_Technorati\BlogInfoResult`` および
``Zend\Service_Technorati\KeyInfoResult`` は、 ``Zend\Service_Technorati\Author`` や
``Zend\Service_Technorati\Weblog`` といったオブジェクトのラッパーとして働きます。

.. _zend.service.technorati.consuming-results.example-3:

.. rubric:: 単体の結果オブジェクトの取得

.. code-block:: php
   :linenos:

   // API_KEY を指定して
   // Zend\Service\Technorati を作成します
   $technorati = new Zend\Service\Technorati('VALID_API_KEY');

   // weppos についての情報を取得します
   $result = $technorati->getInfo('weppos');

   $author = $result->getAuthor();
   echo '<h2>' . $author->getFirstName() . ' ' . $author->getLastName() .
        ' のブログ</h2>';
   echo '<ol>';
   foreach ($result->getWeblogs() as $weblog) {
       echo '<li>' . $weblog->getName() . '</li>';
   }
   echo "</ol>";

レスポンスクラスの詳細については :ref:`Zend\Service\Technorati クラス
<zend.service.technorati.classes>` のセクションを参照ください。

.. _zend.service.technorati.handling-errors:

エラー処理
-----

``Zend\Service\Technorati`` のクエリメソッドは、失敗したときには
``Zend\Service_Technorati\Exception`` をスローします。
またその際にはわかりやすいエラーメッセージを提供します。

``Zend\Service\Technorati`` のクエリが失敗する原因は、いくつか考えられます。
``Zend\Service\Technorati`` は、クエリを送信する際にすべてのパラメータを検証します。
もし無効なパラメータや無効な値を指定していた場合は ``Zend\Service_Technorati\Exception``
をスローします。 さらに、Technorati *API* が一時的に使用できなくなっていたり、
そのレスポンスが整形式でない場合もあり得るでしょう。

Technorati のクエリは、常に *try*... *catch* ブロック内に記述するようにしましょう。

.. _zend.service.technorati.handling-errors.example-1:

.. rubric:: クエリの例外処理

.. code-block:: php
   :linenos:

   $technorati = new Zend\Service\Technorati('VALID_API_KEY');
   try {
       $resultSet = $technorati->search('PHP');
   } catch(Zend\Service_Technorati\Exception $e) {
       echo "エラーが発生しました: " $e->getMessage();
   }

.. _zend.service.technorati.checking-api-daily-usage:

API キーの使用限度の確認
--------------

今日は後何回 *API* キーが使えるのかを調べたいことも多々あるでしょう。
デフォルトでは、Technorati の *API* は 1 日あたり 500
回までしか使用することができません。 それを超えて使用しようとすると、
``Zend\Service\Technorati`` は例外を返します。自分の *API* キーの使用状況を取得するには
``Zend\Service\Technorati::keyInfo()`` メソッドを使用します。

``Zend\Service\Technorati::keyInfo()`` は ``Zend\Service_Technorati\KeyInfoResult``
オブジェクトを返します。 詳細は `API リファレンスガイド`_ を参照ください。

.. _zend.service.technorati.checking-api-daily-usage.example-1:

.. rubric:: API キーの使用状況の取得

.. code-block:: php
   :linenos:

   $technorati = new Zend\Service\Technorati('VALID_API_KEY');
   $key = $technorati->keyInfo();

   echo "API Key: " . $key->getApiKey() . "<br />";
   echo "Daily Usage: " . $key->getApiQueries() . "/" .
        $key->getMaxQueries() . "<br />";

.. _zend.service.technorati.queries:

使用できる Technorati クエリ
--------------------

``Zend\Service\Technorati`` は以下のクエリをサポートしています。

   - :ref:`Cosmos <zend.service.technorati.queries.cosmos>`

   - :ref:`Search <zend.service.technorati.queries.search>`

   - :ref:`Tag <zend.service.technorati.queries.tag>`

   - :ref:`DailyCounts <zend.service.technorati.queries.dailycounts>`

   - :ref:`TopTags <zend.service.technorati.queries.toptags>`

   - :ref:`BlogInfo <zend.service.technorati.queries.bloginfo>`

   - :ref:`BlogPostTags <zend.service.technorati.queries.blogposttags>`

   - :ref:`GetInfo <zend.service.technorati.queries.getinfo>`



.. _zend.service.technorati.queries.cosmos:

Technorati Cosmos
^^^^^^^^^^^^^^^^^

`Cosmos`_ クエリは、指定した URL にリンクしているブログを探します。このクエリは
:ref:`Zend\Service_Technorati\CosmosResultSet <zend.service.technorati.classes.cosmosresultset>`
オブジェクトを返します。詳細は `API リファレンスガイド`_ の
``Zend\Service\Technorati::cosmos()`` を参照ください。

.. _zend.service.technorati.queries.cosmos.example-1:

.. rubric:: Cosmos クエリ

.. code-block:: php
   :linenos:

   $technorati = new Zend\Service\Technorati('VALID_API_KEY');
   $resultSet = $technorati->cosmos('http://devzone.zend.com/');

   echo "<p>Reading " . $resultSet->totalResults() .
        " of " . $resultSet->totalResultsAvailable() .
        " available results</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getWeblog()->getName() . "</li>";
   }
   echo "</ol>";

.. _zend.service.technorati.queries.search:

Technorati Search
^^^^^^^^^^^^^^^^^

`Search`_ クエリは、指定した検索文字列を含むブログを探します。このクエリは
:ref:`Zend\Service_Technorati\SearchResultSet <zend.service.technorati.classes.searchresultset>`
オブジェクトを返します。詳細は `API リファレンスガイド`_ の
``Zend\Service\Technorati::search()`` を参照ください。

.. _zend.service.technorati.queries.search.example-1:

.. rubric:: Search クエリ

.. code-block:: php
   :linenos:

   $technorati = new Zend\Service\Technorati('VALID_API_KEY');
   $resultSet = $technorati->search('zend framework');

   echo "<p>Reading " . $resultSet->totalResults() .
        " of " . $resultSet->totalResultsAvailable() .
        " available results</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getWeblog()->getName() . "</li>";
   }
   echo "</ol>";

.. _zend.service.technorati.queries.tag:

Technorati Tag
^^^^^^^^^^^^^^

`Tag`_ クエリは、指定したタグがつけられている投稿を探します。このクエリは
:ref:`Zend\Service_Technorati\TagResultSet <zend.service.technorati.classes.tagresultset>`
オブジェクトを返します。詳細は `API リファレンスガイド`_ の
``Zend\Service\Technorati::tag()`` を参照ください。

.. _zend.service.technorati.queries.tag.example-1:

.. rubric:: Tag クエリ

.. code-block:: php
   :linenos:

   $technorati = new Zend\Service\Technorati('VALID_API_KEY');
   $resultSet = $technorati->tag('php');

   echo "<p>Reading " . $resultSet->totalResults() .
        " of " . $resultSet->totalResultsAvailable() .
        " available results</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getWeblog()->getName() . "</li>";
   }
   echo "</ol>";

.. _zend.service.technorati.queries.dailycounts:

Technorati DailyCounts
^^^^^^^^^^^^^^^^^^^^^^

`DailyCounts`_ クエリは、指定したキーワードを含む投稿の 1
日あたりの数を返します。このクエリは :ref:`Zend\Service_Technorati\DailyCountsResultSet
<zend.service.technorati.classes.dailycountsresultset>` オブジェクトを返します。詳細は `API
リファレンスガイド`_ の ``Zend\Service\Technorati::dailyCounts()`` を参照ください。

.. _zend.service.technorati.queries.dailycounts.example-1:

.. rubric:: DailyCounts クエリ

.. code-block:: php
   :linenos:

   $technorati = new Zend\Service\Technorati('VALID_API_KEY');
   $resultSet = $technorati->dailyCounts('php');

   foreach ($resultSet as $result) {
       echo "<li>" . $result->getDate() .
            "(" . $result->getCount() . ")</li>";
   }
   echo "</ol>";

.. _zend.service.technorati.queries.toptags:

Technorati TopTags
^^^^^^^^^^^^^^^^^^

`TopTags`_ クエリは、Technorati
にもっとも多く登録されているタグの情報を返します。このクエリは
:ref:`Zend\Service_Technorati\TagsResultSet <zend.service.technorati.classes.tagsresultset>`
オブジェクトを返します。詳細は `API リファレンスガイド`_ の
``Zend\Service\Technorati::topTags()`` を参照ください。

.. _zend.service.technorati.queries.toptags.example-1:

.. rubric:: TopTags タグ

.. code-block:: php
   :linenos:

   $technorati = new Zend\Service\Technorati('VALID_API_KEY');
   $resultSet = $technorati->topTags();

   echo "<p>Reading " . $resultSet->totalResults() .
        " of " . $resultSet->totalResultsAvailable() .
        " available results</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getTag() . "</li>";
   }
   echo "</ol>";

.. _zend.service.technorati.queries.bloginfo:

Technorati BlogInfo
^^^^^^^^^^^^^^^^^^^

`BlogInfo`_ は、指定した URL に関連するブログの情報を返します。このクエリは
:ref:`Zend\Service_Technorati\BlogInfoResult <zend.service.technorati.classes.bloginforesult>`
オブジェクトを返します。詳細は `API リファレンスガイド`_ の
``Zend\Service\Technorati::blogInfo()`` を参照ください。

.. _zend.service.technorati.queries.bloginfo.example-1:

.. rubric:: BlogInfo クエリ

.. code-block:: php
   :linenos:

   $technorati = new Zend\Service\Technorati('VALID_API_KEY');
   $result = $technorati->blogInfo('http://devzone.zend.com/');

   echo '<h2><a href="' . (string) $result->getWeblog()->getUrl() . '">' .
        $result->getWeblog()->getName() . '</a></h2>';

.. _zend.service.technorati.queries.blogposttags:

Technorati BlogPostTags
^^^^^^^^^^^^^^^^^^^^^^^

`BlogPostTags`_
クエリは、そのブログでよく使われているタグの情報を返します。このクエリは
:ref:`Zend\Service_Technorati\TagsResultSet <zend.service.technorati.classes.tagsresultset>`
オブジェクトを返します。詳細は `API リファレンスガイド`_ の
``Zend\Service\Technorati::blogPostTags()`` を参照ください。

.. _zend.service.technorati.queries.blogposttags.example-1:

.. rubric:: BlogPostTags クエリ

.. code-block:: php
   :linenos:

   $technorati = new Zend\Service\Technorati('VALID_API_KEY');
   $resultSet = $technorati->blogPostTags('http://devzone.zend.com/');

   echo "<p>Reading " . $resultSet->totalResults() .
        " of " . $resultSet->totalResultsAvailable() .
        " available results</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getTag() . "</li>";
   }
   echo "</ol>";

.. _zend.service.technorati.queries.getinfo:

Technorati GetInfo
^^^^^^^^^^^^^^^^^^

`GetInfo`_ クエリは、あるメンバーについて Technorati
が把握している情報を返します。このクエリは :ref:`Zend\Service_Technorati\GetInfoResult
<zend.service.technorati.classes.getinforesult>` オブジェクトを返します。詳細は `API
リファレンスガイド`_ の ``Zend\Service\Technorati::getInfo()`` を参照ください。

.. _zend.service.technorati.queries.getinfo.example-1:

.. rubric:: GetInfo クエリ

.. code-block:: php
   :linenos:

   $technorati = new Zend\Service\Technorati('VALID_API_KEY');
   $result = $technorati->getInfo('weppos');

   $author = $result->getAuthor();
   echo "<h2>Blogs authored by " . $author->getFirstName() . " " .
        $author->getLastName() . "</h2>";
   echo "<ol>";
   foreach ($result->getWeblogs() as $weblog) {
       echo "<li>" . $weblog->getName() . "</li>";
   }
   echo "</ol>";

.. _zend.service.technorati.queries.keyinfo:

Technorati KeyInfo
^^^^^^^^^^^^^^^^^^

KeyInfo クエリは、 *API* キーの使用状況についての情報を返します。このクエリは
:ref:`Zend\Service_Technorati\KeyInfoResult <zend.service.technorati.classes.keyinforesult>`
オブジェクトを返します。詳細は `API リファレンスガイド`_ の
``Zend\Service\Technorati::keyInfo()`` を参照ください。

.. _zend.service.technorati.classes:

Zend\Service\Technorati クラス
---------------------------

以下のクラスは、Technorati の各種クエリから返されるものです。
``Zend\Service_Technorati\*ResultSet`` 系のクラスは、
それぞれの形式にあわせた結果セットを保持します。
その中身は形式にあわせた結果オブジェクトであり、容易に処理できます。
これらの結果セットクラスはすべて ``Zend\Service_Technorati\ResultSet``
クラスを継承しており、かつ *SeekableIterator* インターフェイスを実装しています。
これによって、結果のループ処理や特定の結果の取り出しが簡単にできるようになります。


   - :ref:`Zend\Service_Technorati\ResultSet <zend.service.technorati.classes.resultset>`

   - :ref:`Zend\Service_Technorati\CosmosResultSet <zend.service.technorati.classes.cosmosresultset>`

   - :ref:`Zend\Service_Technorati\SearchResultSet <zend.service.technorati.classes.searchresultset>`

   - :ref:`Zend\Service_Technorati\TagResultSet <zend.service.technorati.classes.tagresultset>`

   - :ref:`Zend\Service_Technorati\DailyCountsResultSet <zend.service.technorati.classes.dailycountsresultset>`

   - :ref:`Zend\Service_Technorati\TagsResultSet <zend.service.technorati.classes.tagsresultset>`

   - :ref:`Zend\Service_Technorati\Result <zend.service.technorati.classes.result>`

   - :ref:`Zend\Service_Technorati\CosmosResult <zend.service.technorati.classes.cosmosresult>`

   - :ref:`Zend\Service_Technorati\SearchResult <zend.service.technorati.classes.searchresult>`

   - :ref:`Zend\Service_Technorati\TagResult <zend.service.technorati.classes.tagresult>`

   - :ref:`Zend\Service_Technorati\DailyCountsResult <zend.service.technorati.classes.dailycountsresult>`

   - :ref:`Zend\Service_Technorati\TagsResult <zend.service.technorati.classes.tagsresult>`

   - :ref:`Zend\Service_Technorati\GetInfoResult <zend.service.technorati.classes.getinforesult>`

   - :ref:`Zend\Service_Technorati\BlogInfoResult <zend.service.technorati.classes.bloginforesult>`

   - :ref:`Zend\Service_Technorati\KeyInfoResult <zend.service.technorati.classes.keyinforesult>`



.. note::

   ``Zend\Service_Technorati\GetInfoResult``\ 、 ``Zend\Service_Technorati\BlogInfoResult`` そして
   ``Zend\Service_Technorati\KeyInfoResult``
   には上にあげたクラスと異なる点があります。これらは結果セットに属しておらず、
   インターフェイスを実装していません。これらは単一のレスポンスオブジェクトを表し、
   ``Zend\Service_Technorati\Author`` や ``Zend\Service_Technorati\Weblog`` といった
   ``Zend\Service\Technorati`` のオブジェクトのラッパーとして働きます。

``Zend\Service\Technorati`` には、これ以外にも
特定のレスポンスオブジェクトを表す便利なクラスが含まれています。
``Zend\Service_Technorati\Author`` は、Technorati のアカウント
(ブログの著者、いわゆるブロガー) を表します。 ``Zend\Service_Technorati\Weblog``
は単一のウェブログオブジェクトを表します。 ここには、フィードの URL
やブログ名などの情報が含まれます。詳細は `API リファレンスガイド`_ の
``Zend\Service\Technorati`` を参照ください。

.. _zend.service.technorati.classes.resultset:

Zend\Service_Technorati\ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Technorati\ResultSet`` は最も重要な結果セットです。
クエリ固有の結果セットクラス群はこのクラスを継承して作成しています。
このクラス自体のインスタンスを直接作成してはいけません。
各子クラスは、クエリの種類に応じた :ref:`Zend\Service_Technorati\Result
<zend.service.technorati.classes.result>` オブジェクトのコレクションを表します。

``Zend\Service_Technorati\ResultSet`` は *PHP* の *SeekableIterator*
インターフェイスを実装しており、 *foreach* 文で結果を処理できます。

.. _zend.service.technorati.classes.resultset.example-1:

.. rubric:: 結果セットコレクション内の結果オブジェクトの反復処理

.. code-block:: php
   :linenos:

   // 単純なクエリを実行します
   $technorati = new Zend\Service\Technorati('VALID_API_KEY');
   $resultSet = $technorati->search('php');

   // $resultSet は Zend\Service_Technorati\SearchResultSet
   // のインスタンスです
   // これは Zend\Service_Technorati\ResultSet を継承しています
   foreach ($resultSet as $result) {
       // Zend\Service_Technorati\SearchResult オブジェクトに対して
       // 何らかの操作をします
   }

.. _zend.service.technorati.classes.cosmosresultset:

Zend\Service_Technorati\CosmosResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Technorati\CosmosResultSet`` は Technorati Cosmos クエリの結果セットを表します。

.. note::

   ``Zend\Service_Technorati\CosmosResultSet`` は :ref:`Zend\Service_Technorati\ResultSet
   <zend.service.technorati.classes.resultset>` を継承しています。

.. _zend.service.technorati.classes.searchresultset:

Zend\Service_Technorati\SearchResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Technorati\SearchResultSet`` は Technorati Search クエリの結果セットを表します。

.. note::

   ``Zend\Service_Technorati\SearchResultSet`` は :ref:`Zend\Service_Technorati\ResultSet
   <zend.service.technorati.classes.resultset>` を継承しています。

.. _zend.service.technorati.classes.tagresultset:

Zend\Service_Technorati\TagResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Technorati\TagResultSet`` は Technorati Tag クエリの結果セットを表します。

.. note::

   ``Zend\Service_Technorati\TagResultSet`` は :ref:`Zend\Service_Technorati\ResultSet
   <zend.service.technorati.classes.resultset>` を継承しています。

.. _zend.service.technorati.classes.dailycountsresultset:

Zend\Service_Technorati\DailyCountsResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Technorati\DailyCountsResultSet`` は Technorati DailyCounts
クエリの結果セットを表します。

.. note::

   ``Zend\Service_Technorati\DailyCountsResultSet`` は :ref:`Zend\Service_Technorati\ResultSet
   <zend.service.technorati.classes.resultset>` を継承しています。

.. _zend.service.technorati.classes.tagsresultset:

Zend\Service_Technorati\TagsResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Technorati\TagsResultSet`` は Technorati TopTags あるいは BlogPostTags
クエリの結果セットを表します。

.. note::

   ``Zend\Service_Technorati\TagsResultSet`` は :ref:`Zend\Service_Technorati\ResultSet
   <zend.service.technorati.classes.resultset>` を継承しています。

.. _zend.service.technorati.classes.result:

Zend\Service_Technorati\Result
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Technorati\Result`` は最も重要な結果オブジェクトです。
クエリ固有の結果クラス群はこのクラスを継承して作成しています。
このクラス自体のインスタンスを直接作成してはいけません。

.. _zend.service.technorati.classes.cosmosresult:

Zend\Service_Technorati\CosmosResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Technorati\CosmosResult`` は Technorati Cosmos
クエリの単一の結果オブジェクトを表します。
単体のオブジェクトとして返されることはなく、常に
:ref:`Zend\Service_Technorati\CosmosResultSet <zend.service.technorati.classes.cosmosresultset>`
オブジェクトに含まれる形式で返されます。

.. note::

   ``Zend\Service_Technorati\CosmosResult`` は :ref:`Zend\Service_Technorati\Result
   <zend.service.technorati.classes.result>` を継承しています。

.. _zend.service.technorati.classes.searchresult:

Zend\Service_Technorati\SearchResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Technorati\SearchResult`` は Technorati Search
クエリの単一の結果オブジェクトを表します。
単体のオブジェクトとして返されることはなく、常に
:ref:`Zend\Service_Technorati\SearchResultSet <zend.service.technorati.classes.searchresultset>`
オブジェクトに含まれる形式で返されます。

.. note::

   ``Zend\Service_Technorati\SearchResult`` は :ref:`Zend\Service_Technorati\Result
   <zend.service.technorati.classes.result>` を継承しています。

.. _zend.service.technorati.classes.tagresult:

Zend\Service_Technorati\TagResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Technorati\TagResult`` は Technorati Tag
クエリの単一の結果オブジェクトを表します。
単体のオブジェクトとして返されることはなく、常に :ref:`Zend\Service_Technorati\TagResultSet
<zend.service.technorati.classes.tagresultset>` オブジェクトに含まれる形式で返されます。

.. note::

   ``Zend\Service_Technorati\TagResult`` は :ref:`Zend\Service_Technorati\Result
   <zend.service.technorati.classes.result>` を継承しています。

.. _zend.service.technorati.classes.dailycountsresult:

Zend\Service_Technorati\DailyCountsResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Technorati\DailyCountsResult`` は Technorati DailyCounts
クエリの単一の結果オブジェクトを表します。
単体のオブジェクトとして返されることはなく、常に
:ref:`Zend\Service_Technorati\DailyCountsResultSet <zend.service.technorati.classes.dailycountsresultset>`
オブジェクトに含まれる形式で返されます。

.. note::

   ``Zend\Service_Technorati\DailyCountsResult`` は :ref:`Zend\Service_Technorati\Result
   <zend.service.technorati.classes.result>` を継承しています。

.. _zend.service.technorati.classes.tagsresult:

Zend\Service_Technorati\TagsResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Technorati\TagsResult`` は Technorati TopTags あるいは BlogPostTags
クエリの単一の結果オブジェクトを表します。
単体のオブジェクトとして返されることはなく、常に
:ref:`Zend\Service_Technorati\TagsResultSet <zend.service.technorati.classes.tagsresultset>`
オブジェクトに含まれる形式で返されます。

.. note::

   ``Zend\Service_Technorati\TagsResult`` は :ref:`Zend\Service_Technorati\Result
   <zend.service.technorati.classes.result>` を継承しています。

.. _zend.service.technorati.classes.getinforesult:

Zend\Service_Technorati\GetInfoResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Technorati\GetInfoResult`` は Technorati GetInfo
クエリの単一の結果オブジェクトを表します。

.. _zend.service.technorati.classes.bloginforesult:

Zend\Service_Technorati\BlogInfoResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Technorati\BlogInfoResult`` は Technorati BlogInfo
クエリの単一の結果オブジェクトを表します。

.. _zend.service.technorati.classes.keyinforesult:

Zend\Service_Technorati\KeyInfoResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Technorati\KeyInfoResult`` は Technorati KeyInfo
クエリの単一の結果オブジェクトを表します。 これは :ref:`Technorati API
キーの使用状況 <zend.service.technorati.checking-api-daily-usage>`
についての情報を提供します。



.. _`Technorati API クエリ`: http://technorati.com/developers/api/
.. _`Technorati`: http://technorati.com/
.. _`Technorati API ドキュメント`: http://technorati.com/developers/api/
.. _`Technorati アカウントを作成`: http://technorati.com/signup/
.. _`API キーのセクション`: http://technorati.com/developers/apikey.html
.. _`API リファレンスガイド`: http://framework.zend.com/apidoc/core/
.. _`Cosmos`: http://technorati.com/developers/api/cosmos.html
.. _`Search`: http://technorati.com/developers/api/search.html
.. _`Tag`: http://technorati.com/developers/api/tag.html
.. _`DailyCounts`: http://technorati.com/developers/api/dailycounts.html
.. _`TopTags`: http://technorati.com/developers/api/toptags.html
.. _`BlogInfo`: http://technorati.com/developers/api/bloginfo.html
.. _`BlogPostTags`: http://technorati.com/developers/api/blogposttags.html
.. _`GetInfo`: http://technorati.com/developers/api/getinfo.html
