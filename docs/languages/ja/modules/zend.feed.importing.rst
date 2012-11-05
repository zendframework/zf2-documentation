.. EN-Revision: none
.. _zend.feed.importing:

フィードの読み込み
=========

``Zend_Feed`` を使用すると、フィードの取得が非常に簡単に行えます。 フィードの *URI*
がわかれば、単に ``Zend\Feed\Feed::import()`` メソッドを使用すればよいのです。

.. code-block:: php
   :linenos:

   $feed = Zend\Feed\Feed::import('http://feeds.example.com/feedName');

``Zend_Feed`` を使用して、ファイルや *PHP*
文字列変数からフィードを読み込むこともできます。

.. code-block:: php
   :linenos:

   // テキストファイルからフィードを読み込みます
   $feedFromFile = Zend\Feed\Feed::importFile('feed.xml');

   // PHP の文字列変数からフィードを読み込みます
   $feedFromPHP = Zend\Feed\Feed::importString($feedString);

上のすべての例では、成功した場合に返されるのは ``Zend\Feed\Abstract``
を実装したクラスのオブジェクトで、
フィードの形式によって異なります。もし上のメソッドで *RSS*
フィードを取得したのなら、 返されるオブジェクトは ``Zend\Feed\Rss`` です。一方、Atom
フィードを読み込んだのなら ``Zend\Feed\Atom``
オブジェクトが返されます。読み込みに失敗したりフィードの形式がおかしかったりした場合は
``Zend\Feed\Exception`` がスローされます。

.. _zend.feed.importing.custom:

独自のフィード
-------

``Zend_Feed`` を使用すると、独自のフィードを簡単に作成できます。
単に、配列を作成してそれを ``Zend_Feed`` で読み込むだけでいいのです。
配列を読み込むには ``Zend\Feed\Feed::importArray()`` あるいは ``Zend\Feed\Feed::importBuilder()``
を使用します。 この場合、 ``Zend\Feed_Builder\Interface``
を実装した独自のデータソースによって配列がその場で算出されます。

.. _zend.feed.importing.custom.importarray:

独自の配列の読み込み
^^^^^^^^^^

.. code-block:: php
   :linenos:

   // フィードを配列から読み込みます
   $atomFeedFromArray = Zend\Feed\Feed::importArray($array);

   // この行は、上と同じ意味です。
   // デフォルトで Zend\Feed\Atom のインスタンスを返します
   $atomFeedFromArray = Zend\Feed\Feed::importArray($array, 'atom');

   // rss フィードを配列から読み込みます
   $rssFeedFromArray = Zend\Feed\Feed::importArray($array, 'rss');

配列の書式は、次のような構造になっていなければなりません。

.. code-block:: php
   :linenos:

   array(
       // 必須
       'title' => 'フィードのタイトル',
       'link'  => 'フィードへの正式な url',

       // 任意
       'lastUpdate' => '更新日のタイムスタンプ',
       'published'  => '公開日のタイムスタンプ',

       // 必須
       'charset' => 'テキストデータの文字セット',

       // 任意
       'description' => 'フィードについての短い説明',
       'author'      => 'フィードの作者/公開者',
       'email'       => '作者のメールアドレス',

       // 任意、atom を使用している場合は無視されます
       'webmaster' => '技術的な問題の担当者のメールアドレス',

       // 任意
       'copyright' => '著作権に関する情報',
       'image'     => '画像への url',
       'generator' => '作成したツール',
       'language'  => 'フィードで使用している言語',

       // 任意、atom を使用している場合は無視されます
       'ttl'    => 'フィードを何分間キャッシュするか',
       'rating' => 'チャネルの PICS レート',

       // 任意、atom を使用している場合は無視されます
       // 更新を通知するクラウド
       'cloud'       => array(
           // 必須
           'domain' => 'クラウドのドメイン、たとえば rpc.sys.com',

           // 任意、デフォルトは 80
           'port' => '接続するポート',

           // 必須
           'path'              => 'クラウドのパス、たとえば /RPC2',
           'registerProcedure' => 'コールするプロシージャ、たとえば myCloud.rssPleaseNotify',
           'protocol'          => '使用するプロトコル、たとえば soap や xml-rpc'
       ),

       // 任意、atom を使用している場合は無視されます
       // フィードとともに表示させるテキスト入力ボックス
       'textInput'   => array(
           // 必須
           'title'       => 'テキスト入力欄の Submit ボタンのラベル',
           'description' => 'テキスト入力欄についての説明',
           'name'        => 'テキスト入力欄のテキストオブジェクトの名前',
           'link'        => '入力内容を処理する CGI スクリプトの URL'
       ),

       // 任意、atom を使用している場合は無視されます
       // アグリゲータに対して、特定の時間に処理を飛ばすように伝えるヒント
       'skipHours' => array(
           // 最大 24 行までで、値は 0 から 23 までの数値
           // たとえば 13 (午後一時)
           '24 時間形式の時間'
       ),

       // 任意、atom を使用している場合は無視されます
       // アグリゲータに対して、特定の日に処理を飛ばすように伝えるヒント
       'skipDays ' => array(
           // 最大 7 行まで
           // 値は Monday、Tuesday、Wednesday、Thursday、Friday、Saturday あるいは Sunday
           // たとえば Monday
           'スキップする曜日'
       ),

       // 任意、atom を使用している場合は無視されます
       // Itunes 拡張データ
       'itunes' => array(
           // 任意、デフォルトは本体の author の値
           'author' => 'Artist 列',

           // 任意、デフォルトは本体の author の値
           // ポッドキャストのオーナー
           'owner' => array(
               'name'  => 'オーナーの名前',
               'email' => 'オーナーのメールアドレス'
           ),

           // 任意、デフォルトは本体の image の値
           'image' => 'アルバム/ポッドキャストの画像',

           // 任意、デフォルトは本体の description の値
           'subtitle' => '短い説明',
           'summary'  => '長い説明',

           // 任意
           'block' => 'エピソードを表示しないようにする (yes|no)',

           // 必須、Category 列および iTunes Music Store Browse での値
           'category' => array(
               // 最大 3 行まで
               array(
                   // 必須
                   'main' => 'メインカテゴリ',

                   // 任意
                   'sub'  => 'サブカテゴリ'
               )
           ),

           // 任意
           'explicit'     => 'ペアレンタルコントロールの警告グラフィック (yes|no|clean)',
           'keywords'     => '最大 12 件までのキーワードのカンマ区切りリスト',
           'new-feed-url' => 'iTunes に対して新しいフィード URL の場所を通知するために使用する'
       ),

       'entries' => array(
           array(
               // 必須
               'title' => 'フィードエントリのタイトル',
               'link'  => 'フィードエントリへの url',

               // 必須、テキストのみで html を含まない
               'description' => 'フィードエントリの短いバージョン',

               // 任意
               'guid' => '記事の id。'
                      .  '存在しない場合は link の値を使用します',

               // 任意、html を含めることが可能
               'content' => '長いバージョン',

               // 任意
               'lastUpdate' => '公開日のタイムスタンプ',
               'comments'   => 'フィードエントリに対するコメントページ',
               'commentRss' => '関連するコメントへのフィードの url',

               // 任意、フィードエントリの元のソース
               'source' => array(
                   // 必須
                   'title' => '元ソースのタイトル',
                   'url'   => '元ソースへの url'
               ),

               // 任意、関連付けるカテゴリの一覧
               'category' => array(
                   array(
                       // 必須
                       'term' => '最初のカテゴリのラベル',

                       // 任意
                       'scheme' => 'カテゴリのスキームを表す url'
                   ),

                   array(
                       // 二番目以降のカテゴリのデータ
                   )
               ),

               // 任意、フィードエントリのエンクロージャの一覧
               'enclosure'    => array(
                   array(
                       // 必須
                       'url' => 'リンクされたエンクロージャの url',

                       // 任意
                       'type' => 'エンクロージャの mime タイプ',
                       'length' => 'リンクされたコンテンツのサイズを表すオクテット数'
                   ),

                   array(
                       // 二番目以降のエンクロージャのデータ
                   )
               )
           ),

           array(
               // 二番目のエントリ以降のデータ
           )
       )
   );

参考

- *RSS* 2.0 の仕様: `RSS 2.0`_

- Atom の仕様: `RFC 4287`_

- *WFW* の仕様: `Well Formed Web`_

- iTunes の仕様: `iTunes Technical Specifications`_

.. _zend.feed.importing.custom.importbuilder:

独自のデータソースの読み込み
^^^^^^^^^^^^^^

``Zend\Feed_Builder\Interface`` を実装した任意のデータソースから、 ``Zend_Feed``
のインスタンスを作成できます。単に ``getHeader()`` メソッドおよび ``getEntries()``
メソッドを実装するだけで、自分で作成したオブジェクトが ``Zend\Feed\Feed::importBuilder()``
で使用できるようになります。 ``Zend\Feed\Builder``
は、これを単純に実装したものです。
コンストラクタで配列を受け取り、ちょっとした検証を行い、 そして ``importBuilder()``
メソッドで使用できるようにします。 ``getHeader()`` メソッドは ``Zend\Feed_Builder\Header``
のインスタンスを返さなければなりません。また ``getEntries()`` は ``Zend\Feed_Builder\Entry``
のインスタンスの配列を返さなければなりません。

.. note::

   ``Zend\Feed\Builder`` は、使用法を説明するための具体的な実装例です。
   実際に使用する際には、 ``Zend\Feed_Builder\Interface``
   を実装した独自のクラスを作成することを推奨します。

これが、 ``Zend\Feed\Feed::importBuilder()`` の使用例です。

.. code-block:: php
   :linenos:

   // 独自のビルダソースからフィードを読み込みます
   $atomFeedFromArray =
       Zend\Feed\Feed::importBuilder(new Zend\Feed\Builder($array));

   // この行は、上と同じ意味です。
   // デフォルトで Zend\Feed\Atom のインスタンスを返します
   $atomFeedFromArray =
       Zend\Feed\Feed::importBuilder(new Zend\Feed\Builder($array), 'atom');

   // 独自のビルダ配列から rss フィードを読み込みます
   $rssFeedFromArray =
       Zend\Feed\Feed::importBuilder(new Zend\Feed\Builder($array), 'rss');

.. _zend.feed.importing.custom.dump:

フィードの内容の出力
^^^^^^^^^^

``Zend\Feed\Abstract`` インスタンスの内容を出力するには、 *send()* メソッドあるいは
*saveXml()* メソッドを使用します。

.. code-block:: php
   :linenos:

   assert($feed instanceof Zend\Feed\Abstract);

   // フィードを標準出力に出力します
   print $feed->saveXML();

   // http ヘッダを送信し、フィードを出力します
   $feed->send();



.. _`RSS 2.0`: http://blogs.law.harvard.edu/tech/rss
.. _`RFC 4287`: http://tools.ietf.org/html/rfc4287
.. _`Well Formed Web`: http://wellformedweb.org/news/wfw_namespace_elements
.. _`iTunes Technical Specifications`: http://www.apple.com/itunes/store/podcaststechspecs.html
