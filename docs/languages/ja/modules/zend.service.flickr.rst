.. _zend.service.flickr:

Zend_Service_Flickr
===================

.. _zend.service.flickr.introduction:

導入
--

``Zend_Service_Flickr`` は、Flickr の REST Web Service を使用するためのシンプルな *API* です。
Flickr ウェブサービスを使用するには *API* キーが必要です。 キーを取得したり Flickr
REST Web Service の詳細情報を取得したりするには `Flickr API Documentation`_ を参照ください。

以下の例では、"php" というタグがつけられた写真を ``tagSearch()``
メソッドを使用して検索します。

.. _zend.service.flickr.introduction.example-1:

.. rubric:: 単純な Flickr 検索

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MY_API_KEY');

   $results = $flickr->tagSearch("php");

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }

.. note::

   **オプションのパラメータ**

   ``tagSearch()`` は、オプションの 二番目の引数に検索オプションを指定できます。

.. _zend.service.flickr.finding-users:

Flickr ユーザの写真や情報の検索
-------------------

``Zend_Service_Flickr`` では、いくつかの方法で Flickr
ユーザについての情報を取得できます。

- ``userSearch()``: タグをスペースで区切ったクエリ文字列、
  そしてオプションの二番目のパラメータで検索オプションの配列を指定して検索し、
  結果の写真を ``Zend_Service_Flickr_ResultSet`` オブジェクトで返します。

- ``getIdByUsername()``: 指定したユーザ名に対応するユーザ ID を文字列で返します。

- ``getIdByEmail()``: 指定したメールアドレスに対応するユーザ ID を文字列で返します。

.. _zend.service.flickr.finding-users.example-1:

.. rubric:: メールアドレスからの Flickr ユーザの公開している写真の検索

この例では、メールアドレスがわかっている Flickr ユーザが公開している写真を
``userSearch()`` メソッドを用いて探します。

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MY_API_KEY');

   $results = $flickr->userSearch($userEmail);

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }

.. _zend.service.flickr.grouppoolgetphotos:

グループプールからの写真の検索
---------------

``Zend_Service_Flickr`` は、 グループにプールされている写真をグループ ID
を指定して取得できます。 ``groupPoolGetPhotos()`` メソッドを使用します。

.. _zend.service.flickr.grouppoolgetphotos.example-1:

.. rubric:: グループ ID を指定し、グループにプールされている写真を取得する

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MY_API_KEY');

       $results = $flickr->groupPoolGetPhotos($groupId);

       foreach ($results as $result) {
           echo $result->title . '<br />';
       }

.. note::

   **オプションのパラメータ**

   ``groupPoolGetPhotos()`` は、オプションの 二番目の引数に設定の配列を指定できます。

.. _zend.service.flickr.getimagedetails:

Flickr 画像の詳細の取得
---------------

``Zend_Service_Flickr`` を使用すると、指定した画像 ID
の画像についての詳細情報をすばやく簡単に取得できます。
そのためには、以下の例のように単純に ``getImageDetails()`` メソッドを使用します。

.. _zend.service.flickr.getimagedetails.example-1:

.. rubric:: Flickr 画像の詳細の取得

Flickr 画像 ID を使用すると、簡単に画像の情報が取得できます。

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MY_API_KEY');

   $image = $flickr->getImageDetails($imageId);

   echo "画像 ID $imageId は $image->width x $image->height ピクセルです。<br />\n";
   echo "<a href=\"$image->clickUri\">クリックすると画像を表示します</a>\n";

.. _zend.service.flickr.classes:

Zend_Service_Flickr 結果クラス群
--------------------------

``tagSearch()`` あるいは ``userSearch()`` から返されるのは、以下のクラスのいずれかです。


   - :ref:`Zend_Service_Flickr_ResultSet <zend.service.flickr.classes.resultset>`

   - :ref:`Zend_Service_Flickr_Result <zend.service.flickr.classes.result>`

   - :ref:`Zend_Service_Flickr_Image <zend.service.flickr.classes.image>`



.. _zend.service.flickr.classes.resultset:

Zend_Service_Flickr_ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Flickr 検索からの結果セットを表します。

.. note::

   操作性を高めるため、 ``SeekableIterator`` インターフェイスを実装しています。
   これにより、一般的な順次処理 (例えば ``foreach()`` など) だけでなく ``seek()``
   を使用した特定の結果への直接アクセスも可能です。

.. _zend.service.flickr.classes.resultset.properties:

プロパティ
^^^^^

.. _zend.service.flickr.classes.resultset.properties.table-1:

.. table:: Zend_Service_Flickr_ResultSet のプロパティ

   +---------------------+---+-----------------------+
   |名前                   |型  |説明                     |
   +=====================+===+=======================+
   |totalResultsAvailable|int|使用可能な結果の総数             |
   +---------------------+---+-----------------------+
   |totalResultsReturned |int|返された結果の総数              |
   +---------------------+---+-----------------------+
   |firstResultPosition  |int|すべての結果セットの中でのこの結果セットの位置|
   +---------------------+---+-----------------------+

.. _zend.service.flickr.classes.resultset.totalResults:

Zend_Service_Flickr_ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``


この結果セット内の結果の数を返します。

:ref:`クラス一覧に戻る <zend.service.flickr.classes>`

.. _zend.service.flickr.classes.result:

Zend_Service_Flickr_Result
^^^^^^^^^^^^^^^^^^^^^^^^^^

Flickr クエリから返される結果の画像情報を表します。

.. _zend.service.flickr.classes.result.properties:

プロパティ
^^^^^

.. _zend.service.flickr.classes.result.properties.table-1:

.. table:: Zend_Service_Flickr_Result のプロパティ

   +----------+-------------------------+--------------------------+
   |名前        |型                        |説明                        |
   +==========+=========================+==========================+
   |id        |string                   |画像 ID                     |
   +----------+-------------------------+--------------------------+
   |owner     |string                   |画像の所有者の NSID              |
   +----------+-------------------------+--------------------------+
   |secret    |string                   |URL の作成に使用されるキー           |
   +----------+-------------------------+--------------------------+
   |server    |string                   |URL の作成に使用されるサーバ名         |
   +----------+-------------------------+--------------------------+
   |title     |string                   |写真のタイトル                   |
   +----------+-------------------------+--------------------------+
   |ispublic  |string                   |写真が公開されているかどうか            |
   +----------+-------------------------+--------------------------+
   |isfriend  |string                   |画像の所有者の友達であるかどうか          |
   +----------+-------------------------+--------------------------+
   |isfamily  |string                   |画像の所有者の家族であるかどうか          |
   +----------+-------------------------+--------------------------+
   |license   |string                   |写真についてのライセンス情報            |
   +----------+-------------------------+--------------------------+
   |dateupload|string                   |写真がアップロードされた日付            |
   +----------+-------------------------+--------------------------+
   |datetaken |string                   |写真が撮影された日付                |
   +----------+-------------------------+--------------------------+
   |ownername |string                   |所有者のスクリーンネーム              |
   +----------+-------------------------+--------------------------+
   |iconserver|string                   |アイコンの URL を組み立てるために使用するサーバ|
   +----------+-------------------------+--------------------------+
   |Square    |Zend_Service_Flickr_Image|75x75 の、画像のサムネイル          |
   +----------+-------------------------+--------------------------+
   |Thumbnail |Zend_Service_Flickr_Image|100 ピクセルの、画像のサムネイル        |
   +----------+-------------------------+--------------------------+
   |Small     |Zend_Service_Flickr_Image|240 ピクセル版の画像              |
   +----------+-------------------------+--------------------------+
   |Medium    |Zend_Service_Flickr_Image|500 ピクセル版の画像              |
   +----------+-------------------------+--------------------------+
   |Large     |Zend_Service_Flickr_Image|640 ピクセル版の画像              |
   +----------+-------------------------+--------------------------+
   |Original  |Zend_Service_Flickr_Image|元の画像                      |
   +----------+-------------------------+--------------------------+

:ref:`クラス一覧に戻る <zend.service.flickr.classes>`

.. _zend.service.flickr.classes.image:

Zend_Service_Flickr_Image
^^^^^^^^^^^^^^^^^^^^^^^^^

Flickr 検索が返す画像を表します。

.. _zend.service.flickr.classes.image.properties:

プロパティ
^^^^^

.. _zend.service.flickr.classes.image.properties.table-1:

.. table:: Zend_Service_Flickr_Image のプロパティ

   +--------+------+--------------------------------+
   |名前      |型     |説明                              |
   +========+======+================================+
   |uri     |string|元の画像の URI                       |
   +--------+------+--------------------------------+
   |clickUri|string|もとの画像 (Flickr のページ) へのリンク用 URIac|
   +--------+------+--------------------------------+
   |width   |int   |画像の幅                            |
   +--------+------+--------------------------------+
   |height  |int   |画像の高さ                           |
   +--------+------+--------------------------------+

:ref:`クラス一覧に戻る <zend.service.flickr.classes>`



.. _`Flickr API Documentation`: http://www.flickr.com/services/api/
