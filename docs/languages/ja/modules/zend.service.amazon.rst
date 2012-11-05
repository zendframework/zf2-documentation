.. EN-Revision: none
.. _zend.service.amazon:

Zend\Service\Amazon
===================

.. _zend.service.amazon.introduction:

導入
--

``Zend\Service\Amazon`` は Amazon ウェブサービスを使用するためのシンプルな *API* です。
``Zend\Service\Amazon`` は、ふたつの *API* を実装しています。 Amazon 自身の *API*
に従った伝統的な *API* と、
複雑な検索クエリを簡単に作成するためのシンプルな「クエリ *API*\ 」です。

``Zend\Service\Amazon`` を使用すると、開発者が Amazon Web Services *API*
を直接使用して、Amazon.com の情報を取得できるようになります。
取得できる情報には以下のようなものがあります。

   - 商品の情報、例えば画像や説明や価格など

   - カスタマーレビュー

   - 似た製品やアクセサリの情報

   - Amazon.com のおすすめ

   - リストマニアのリスト



``Zend\Service\Amazon`` を使用するには、 Amazon デベロッパ *API*
キーとシークレットキーが必要です。 このキーを取得するには、 `Amazon Web Services`_
のウェブサイトを参照ください。 2009年8月15日以降、Amazon Product Advertising *API* を
``Zend\Service\Amazon`` で使うにはシークレットキーが必要となります。

.. note::

   **注意**

   Amazon デベロッパ *API* キーおよびシークレットキーは Amazon
   のアカウントと関連付けられます。 取得した *API*
   キーは自分自身でのみ使用するようにしましょう。

.. _zend.service.amazon.introduction.example.itemsearch:

.. rubric:: 伝統的な API を使用した Amazon 検索

この例では、Amazon で PHP に関する書籍を検索し、 結果の一覧を表示します。

.. code-block:: php
   :linenos:

   $amazon = new Zend\Service\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $results = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                        'Keywords' => 'php'));
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

.. _zend.service.amazon.introduction.example.query_api:

.. rubric:: クエリ API を使用した Amazon 検索

ここでも Amazon で PHP に関する書籍を検索します。 しかし、ここではクエリ *API*
を使用します。この *API* は、Fluent Interface パターンと似た形式です。

.. code-block:: php
   :linenos:

   $query = new Zend\Service_Amazon\Query('AMAZON_API_KEY',
                                          'US',
                                          'AMAZON_SECRET_KEY');
   $query->category('Books')->Keywords('PHP');
   $results = $query->search();
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

.. _zend.service.amazon.countrycodes:

国コード
----

デフォルトでは、 ``Zend\Service\Amazon`` は米国 ("*US*") の Amazon Web Service
に接続します。他の国のサービスに接続するには、 コンストラクタの 2
番目のパラメータとして、適切な国コード文字列を指定するだけです。

.. _zend.service.amazon.countrycodes.example.country_code:

.. rubric:: Amazon Web Service の国の選択

.. code-block:: php
   :linenos:

   // 日本の Amazon に接続します
   $amazon = new Zend\Service\Amazon('AMAZON_API_KEY', 'JP', 'AMAZON_SECRET_KEY');

.. note::

   **国コード**

   使用できる国コードは *CA*\ 、 *DE*\ 、 *FR*\ 、 *JP*\ 、 *UK* および *US* です。

.. _zend.service.amazon.itemlookup:

ASIN を使用した商品の検索
---------------

*ASIN* がわかっている場合は、 ``itemLookup()`` メソッドを使用すると Amazon
の商品を検索できます。

.. _zend.service.amazon.itemlookup.example.asin:

.. rubric:: ASIN を使用した Amazon の商品検索

.. code-block:: php
   :linenos:

   $amazon = new Zend\Service\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $item = $amazon->itemLookup('B0000A432X');

``itemLookup()`` メソッドにオプションの第 2 パラメータを渡すことで、
検索オプションを指定できます。使用可能なオプションを含む詳細は、 `関連する
Amazon の文書`_ を参照ください。

.. note::

   **画像の情報**

   検索結果の画像情報を取得するには、オプション *ResponseGroup* を *Medium* あるいは
   *Large* に設定しなければなりません。

.. _zend.service.amazon.itemsearch:

Amazon の商品検索の実行
---------------

さまざまな条件指定による商品検索を行うには ``itemSearch()`` メソッドを使用します。
以下に例を示します。

.. _zend.service.amazon.itemsearch.example.basic:

.. rubric:: Amazon の商品検索の実行

.. code-block:: php
   :linenos:

   $amazon = new Zend\Service\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $results = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                        'Keywords' => 'php'));
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

.. _zend.service.amazon.itemsearch.example.responsegroup:

.. rubric:: ResponseGroup オプションの使用法

*ResponseGroup* オプションを使用すると、 レスポンスで返される情報を制御できます。

.. code-block:: php
   :linenos:

   $amazon = new Zend\Service\Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $results = $amazon->itemSearch(array(
       'SearchIndex'   => 'Books',
       'Keywords'      => 'php',
       'ResponseGroup' => 'Small,ItemAttributes,Images,SalesRank,Reviews,' .
                          'EditorialReview,Similarities,ListmaniaLists'
       ));
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

``itemSearch()`` は配列のパラメータをひとつ受け取り、
このパラメータで検索オプションを指定します。使用可能なオプションを含む詳細は、
`関連する Amazon の文書`_ を参照ください。

.. tip::

   :ref:`Zend\Service_Amazon\Query <zend.service.amazon.query>`
   クラスを使用すると、これらのメソッドをより簡単に使用できるようになります。

.. _zend.service.amazon.query:

もうひとつのクエリ API の使用法
------------------

.. _zend.service.amazon.query.introduction:

導入
^^

``Zend\Service_Amazon\Query`` は、Amazon Web Service を使用するためのもうひとつの *API*
を提供します。 この *API* では Fluent Interface パターンを使用します。
つまり、すべてのコールはメソッド呼び出しを連結した形式になります (例:
*$obj->method()->method2($arg)*)。

商品検索の設定を行いやすく、また条件に基づく検索をしやすくするために、
``Zend\Service_Amazon\Query`` *API* ではオーバーロードを使用しています。
各オプションの設定はメソッドのコールで行い、メソッドの引数がオプションの値に対応します。

.. _zend.service.amazon.query.introduction.example.basic:

.. rubric:: もうひとつのクエリ API を使用した Amazon の検索

この例では、もうひとつのクエリ *API* のインターフェイスを使用して、
オプションとその値を設定します。

.. code-block:: php
   :linenos:

   $query = new Zend\Service_Amazon\Query('MY_API_KEY');
   $query->Category('Books')->Keywords('PHP');
   $results = $query->search();
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

これは、オプション *Category* の値を "Books"、 そして *Keywords* の値を "PHP"
に設定します。

使用可能なオプションについての詳細な情報は、 `関連する Amazon の文書`_
を参照ください。

.. _zend.service.amazon.classes:

Zend\Service\Amazon クラス群
------------------------

以下のクラスは、すべて :ref:`Zend\Service\Amazon::itemLookup() <zend.service.amazon.itemlookup>`
および :ref:`Zend\Service\Amazon::itemSearch() <zend.service.amazon.itemsearch>`
から返されるものです。

   - :ref:`Zend\Service_Amazon\Item <zend.service.amazon.classes.item>`

   - :ref:`Zend\Service_Amazon\Image <zend.service.amazon.classes.image>`

   - :ref:`Zend\Service_Amazon\ResultSet <zend.service.amazon.classes.resultset>`

   - :ref:`Zend\Service_Amazon\OfferSet <zend.service.amazon.classes.offerset>`

   - :ref:`Zend\Service_Amazon\Offer <zend.service.amazon.classes.offer>`

   - :ref:`Zend\Service_Amazon\SimilarProduct <zend.service.amazon.classes.similarproduct>`

   - :ref:`Zend\Service_Amazon\Accessories <zend.service.amazon.classes.accessories>`

   - :ref:`Zend\Service_Amazon\CustomerReview <zend.service.amazon.classes.customerreview>`

   - :ref:`Zend\Service_Amazon\EditorialReview <zend.service.amazon.classes.editorialreview>`

   - :ref:`Zend\Service_Amazon\ListMania <zend.service.amazon.classes.listmania>`



.. _zend.service.amazon.classes.item:

Zend\Service_Amazon\Item
^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Amazon\Item`` は、ウェブサービスから返される Amazon
の商品を表すために使用されるクラスです。
商品のタイトル、説明、レビューなどを含むすべての属性を包含します。

.. _zend.service.amazon.classes.item.asxml:

Zend\Service_Amazon\Item::asXML()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

string:``asXML()``


商品情報を、元の XML で返します。

.. _zend.service.amazon.classes.item.properties:

プロパティ
^^^^^

``Zend\Service_Amazon\Item`` が持つプロパティは、 それぞれが標準の Amazon *API*
に直接対応しています。

.. _zend.service.amazon.classes.item.properties.table-1:

.. table:: Zend\Service_Amazon\Item のプロパティ

   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |名前              |型                           |説明                                                                                                                                                                                 |
   +================+============================+===================================================================================================================================================================================+
   |ASIN            |string                      |Amazon の商品 ID                                                                                                                                                                      |
   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |DetailPageURL   |string                      |商品の詳細情報ページの URL                                                                                                                                                                    |
   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |SalesRank       |int                         |商品の売上ランキング                                                                                                                                                                         |
   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |SmallImage      |Zend\Service_Amazon\Image   |商品の画像 (小)                                                                                                                                                                          |
   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |MediumImage     |Zend\Service_Amazon\Image   |商品の画像 (中)                                                                                                                                                                          |
   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |LargeImage      |Zend\Service_Amazon\Image   |商品の画像 (大)                                                                                                                                                                          |
   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Subjects        |array                       |商品のテーマ                                                                                                                                                                             |
   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Offers          |Zend\Service_Amazon\OfferSet|提供内容の概要および商品の提供情報                                                                                                                                                                  |
   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |CustomerReviews |array                       |Zend\Service_Amazon\CustomerReview オブジェクトの配列で表されるカスタマーレビュー                                                                                                                         |
   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |EditorialReviews|array                       |Zend\Service_Amazon\EditorialReview オブジェクトの配列で表される、出版社/著者からの内容紹介                                                                                                                   |
   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |SimilarProducts |array                       |Zend\Service_Amazon\SimilarProduct オブジェクトの配列で表される、似た商品の情報                                                                                                                          |
   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Accessories     |array                       |Zend\Service_Amazon\Accessories オブジェクトの配列で表される、関連アクセサリの情報                                                                                                                          |
   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Tracks          |array                       |音楽 CD や DVD の、トラック番号と曲名の配列                                                                                                                                                         |
   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |ListmaniaLists  |array                       |Item related Listmania Lists as an array of Zend\Service_Amazon\ListmainList オブジェクトの配列で表される、この商品に関連するリストマニアのリスト                                                                    |
   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |PromotionalTag  |string                      |商品の販売促進用のタグ                                                                                                                                                                        |
   +----------------+----------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

:ref:`クラス一覧に戻る <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.image:

Zend\Service_Amazon\Image
^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Amazon\Image`` は、商品の画像を表します。

.. _zend.service.amazon.classes.image.properties:

プロパティ
^^^^^

.. _zend.service.amazon.classes.image.properties.table-1:

.. table:: Zend\Service_Amazon\Image のプロパティ

   +------+--------+------------------------------------+
   |名前    |型       |説明                                  |
   +======+========+====================================+
   |Url   |Zend_Uri|画像のリモート URL                         |
   +------+--------+------------------------------------+
   |Height|int     |画像の高さ (ピクセル単位)                      |
   +------+--------+------------------------------------+
   |Width |int     |画像の幅 (ピクセル単位)                       |
   +------+--------+------------------------------------+

:ref:`クラス一覧に戻る <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.resultset:

Zend\Service_Amazon\ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\Service_Amazon\ResultSet`` オブジェクトは :ref:`Zend\Service\Amazon::itemSearch()
<zend.service.amazon.itemsearch>`
から返され、結果が複数返された場合に簡単に処理できるようにします。

.. note::

   **SeekableIterator**

   操作性を高めるため、 *SeekableIterator* を実装しています。
   これにより、一般的な順次処理 (例えば *foreach* など) だけでなく ``seek()``
   を使用した特定の結果への直接アクセスも可能です。

.. _zend.service.amazon.classes.resultset.totalresults:

Zend\Service_Amazon\ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``
検索結果の総数を返します。

:ref:`クラス一覧に戻る <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.offerset:

Zend\Service_Amazon\OfferSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Each result returned by :ref:`Zend\Service\Amazon::itemSearch() <zend.service.amazon.itemsearch>` および
:ref:`Zend\Service\Amazon::itemLookup() <zend.service.amazon.itemlookup>` から返される各結果には
``Zend\Service_Amazon\OfferSet`` オブジェクトが含まれており、
ここから商品の販売情報が取得できます。

.. _zend.service.amazon.classes.offerset.parameters:

プロパティ
^^^^^

.. _zend.service.amazon.classes.offerset.parameters.table-1:

.. table:: Zend\Service_Amazon\OfferSet のプロパティ

   +----------------------+------+-----------------------------------------------------+
   |名前                    |型     |説明                                                   |
   +======================+======+=====================================================+
   |LowestNewPrice        |int   |"新品" の最低価格                                           |
   +----------------------+------+-----------------------------------------------------+
   |LowestNewPriceCurrency|string|LowestNewPrice の通貨単位                                 |
   +----------------------+------+-----------------------------------------------------+
   |LowestOldPrice        |int   |"ユーズド商品" の最低価格                                       |
   +----------------------+------+-----------------------------------------------------+
   |LowestOldPriceCurrency|string|LowestOldPrice の通貨単位                                 |
   +----------------------+------+-----------------------------------------------------+
   |TotalNew              |int   |"新品" の在庫数                                            |
   +----------------------+------+-----------------------------------------------------+
   |TotalUsed             |int   |"ユーズド商品" の在庫数                                        |
   +----------------------+------+-----------------------------------------------------+
   |TotalCollectible      |int   |"コレクター商品" の在庫数                                       |
   +----------------------+------+-----------------------------------------------------+
   |TotalRefurbished      |int   |"refurbished" の在庫数                                   |
   +----------------------+------+-----------------------------------------------------+
   |Offers                |array |Zend\Service_Amazon\Offer オブジェクトの配列                  |
   +----------------------+------+-----------------------------------------------------+

:ref:`クラス一覧に戻る <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.offer:

Zend\Service_Amazon\Offer
^^^^^^^^^^^^^^^^^^^^^^^^^

商品の個々の販売情報が ``Zend\Service_Amazon\Offer`` オブジェクトとして返されます。

.. _zend.service.amazon.classes.offer.properties:

Zend\Service_Amazon\Offer のプロパティ
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.service.amazon.classes.offer.properties.table-1:

.. table:: プロパティ

   +-------------------------------+-------+------------------------------------------------------------------------------------------+
   |名前                             |型      |説明                                                                                        |
   +===============================+=======+==========================================================================================+
   |MerchantId                     |string |出品者の Amazon ID                                                                            |
   +-------------------------------+-------+------------------------------------------------------------------------------------------+
   |MerchantName                   |string |Merchants Amazon Name. Requires setting the ResponseGroup option to OfferFull to retrieve.|
   +-------------------------------+-------+------------------------------------------------------------------------------------------+
   |GlancePage                     |string |出品者の概要が掲載されているページの URL                                                                    |
   +-------------------------------+-------+------------------------------------------------------------------------------------------+
   |Condition                      |string |商品のコンディション                                                                                |
   +-------------------------------+-------+------------------------------------------------------------------------------------------+
   |OfferListingId                 |string |販売情報リストの ID                                                                               |
   +-------------------------------+-------+------------------------------------------------------------------------------------------+
   |Price                          |int    |商品の価格                                                                                     |
   +-------------------------------+-------+------------------------------------------------------------------------------------------+
   |CurrencyCode                   |string |商品価格の通貨コード                                                                                |
   +-------------------------------+-------+------------------------------------------------------------------------------------------+
   |Availability                   |string |商品の在庫状況                                                                                   |
   +-------------------------------+-------+------------------------------------------------------------------------------------------+
   |IsEligibleForSuperSaverShipping|boolean|Super Saver Shipping に対応しているか否か                                                           |
   +-------------------------------+-------+------------------------------------------------------------------------------------------+

:ref:`クラス一覧に戻る <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.similarproduct:

Zend\Service_Amazon\SimilarProduct
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

商品を検索した際に、Amazon は検索結果の商品と似た商品の一覧も返します。
個々のデータは ``Zend\Service_Amazon\SimilarProduct`` オブジェクトとして返されます。

各オブジェクトに含まれる情報を元にして、
その商品の完全な情報を取得するリクエストを行うことができます。

.. _zend.service.amazon.classes.similarproduct.properties:

プロパティ
^^^^^

.. _zend.service.amazon.classes.similarproduct.properties.table-1:

.. table:: Zend\Service_Amazon\SimilarProduct のプロパティ

   +------+------+-----------------------+
   |名前    |型     |説明                     |
   +======+======+=======================+
   |ASIN  |string|Amazon 商品 ID (ASIN)    |
   +------+------+-----------------------+
   |Title |string|商品名                    |
   +------+------+-----------------------+

:ref:`クラス一覧に戻る <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.accessories:

Zend\Service_Amazon\Accessories
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

返される結果の中の「アクセサリ」については ``Zend\Service_Amazon\Accessories``
オブジェクトで表されます。

.. _zend.service.amazon.classes.accessories.properties:

プロパティ
^^^^^

.. _zend.service.amazon.classes.accessories.properties.table-1:

.. table:: Zend\Service_Amazon\Accessories のプロパティ

   +------+------+-----------------------+
   |名前    |型     |説明                     |
   +======+======+=======================+
   |ASIN  |string|Amazon 商品 ID (ASIN)    |
   +------+------+-----------------------+
   |Title |string|商品名                    |
   +------+------+-----------------------+

:ref:`クラス一覧に戻る <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.customerreview:

Zend\Service_Amazon\CustomerReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

カスタマーレビューのデータは ``Zend\Service_Amazon\CustomerReview``
オブジェクトで返されます。

.. _zend.service.amazon.classes.customerreview.properties:

プロパティ
^^^^^

.. _zend.service.amazon.classes.customerreview.properties.table-1:

.. table:: Zend\Service_Amazon\CustomerReview のプロパティ

   +------------+------+------------------------------------------------------+
   |名前          |型     |説明                                                    |
   +============+======+======================================================+
   |Rating      |string|商品のおすすめ度                                              |
   +------------+------+------------------------------------------------------+
   |HelpfulVotes|string|「このレビューが参考になった」の投票                                    |
   +------------+------+------------------------------------------------------+
   |CustomerId  |string|カスタマー ID                                              |
   +------------+------+------------------------------------------------------+
   |TotalVotes  |string|全投票数                                                  |
   +------------+------+------------------------------------------------------+
   |Date        |string|レビューされた日付                                             |
   +------------+------+------------------------------------------------------+
   |Summary     |string|レビューの概要                                               |
   +------------+------+------------------------------------------------------+
   |Content     |string|レビューの内容                                               |
   +------------+------+------------------------------------------------------+

:ref:`クラス一覧に戻る <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.editorialreview:

Zend\Service_Amazon\EditorialReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

出版社/著者からの内容紹介は ``Zend\Service_Amazon\EditorialReview``
オブジェクトで返されます。

.. _zend.service.amazon.classes.editorialreview.properties:

プロパティ
^^^^^

.. _zend.service.amazon.classes.editorialreview.properties.table-1:

.. table:: Zend\Service_Amazon\EditorialReview のプロパティ

   +-------+------+---------------------+
   |名前     |型     |説明                   |
   +=======+======+=====================+
   |Source |string|レビュー元                |
   +-------+------+---------------------+
   |Content|string|レビューの内容              |
   +-------+------+---------------------+

:ref:`クラス一覧に戻る <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.listmania:

Zend\Service_Amazon\Listmania
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

リストマニアのリストデータは ``Zend\Service_Amazon\Listmania``
オブジェクトで返されます。

.. _zend.service.amazon.classes.listmania.properties:

プロパティ
^^^^^

.. _zend.service.amazon.classes.listmania.properties.table-1:

.. table:: Zend\Service_Amazon\Listmania のプロパティ

   +--------+------+------------+
   |名前      |型     |説明          |
   +========+======+============+
   |ListId  |string|リスト ID      |
   +--------+------+------------+
   |ListName|string|リスト名        |
   +--------+------+------------+

:ref:`クラス一覧に戻る <zend.service.amazon.classes>`



.. _`Amazon Web Services`: http://aws.amazon.com/
.. _`関連する Amazon の文書`: http://www.amazon.com/gp/aws/sdk/main.html/102-9041115-9057709?s=AWSEcommerceService&v=2011-08-01&p=ApiReference/ItemSearchOperation
