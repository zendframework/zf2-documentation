.. _zend.service.slideshare:

Zend_Service_SlideShare
=======================

``Zend_Service_SlideShare`` コンポーネントは、 `slideshare.net`_
ウェブサービスを操作するためのものです。
これは、スライドショーをオンラインで公開するためのサービスです。
このコンポーネントを使用すると、
公開されているスライドをウェブサイトに埋め込んだり
新しいスライドショーを自分のアカウントにアップロードしたりできます。

.. _zend.service.slideshare.basicusage:

Zend_Service_SlideShare の使い方
----------------------------

``Zend_Service_SlideShare`` コンポーネントを使うには、まず slideshare.net
のアカウントを作成して (詳細は `こちら`_ を参照ください) *API*
キーやユーザ名、パスワード、そして共有する秘密の値を取得しなければなりません。
``Zend_Service_SlideShare`` コンポーネントを使用するには、これらすべてが必要です。

アカウントを取得したら、 ``Zend_Service_SlideShare`` を使い始めることができます。
``Zend_Service_SlideShare``
オブジェクトのインスタンスを作成し、それぞれの値を次のように指定しましょう。

.. code-block:: php
   :linenos:

   // このコンポーネントの新しいインスタンスを作成します
   $ss = new Zend_Service_SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');

.. _zend.service.slideshare.slideshowobj:

SlideShow オブジェクト
----------------

``Zend_Service_SlideShare`` コンポーネントのすべてのスライドショーは
``Zend_Service_SlideShare_SlideShow`` オブジェクトで表されます
(取得する際も新規スライドショーのアップロードの際も同じです)。
このクラスの構造を擬似コードで表すと次のようになります。

.. code-block:: php
   :linenos:

   class Zend_Service_SlideShare_SlideShow {

       /**
        * スライドショーの場所を取得します
        */
       public function getLocation() {
           return $this->_location;
       }

       /**
        * スライドショーのトランスクリプトを取得します
        */
       public function getTranscript() {
           return $this->_transcript;
       }

       /**
        * スライドショーにタグを追加します
        */
       public function addTag($tag) {
           $this->_tags[] = (string)$tag;
           return $this;
       }

       /**
        * スライドショーにタグを設定します
        */
       public function setTags(Array $tags) {
           $this->_tags = $tags;
           return $this;
       }

       /**
        * スライドショーに関連付けられているすべてのタグを取得します
        */
       public function getTags() {
           return $this->_tags;
       }

       /**
        * ローカルファイルシステム上でのスライドショーのファイル名を設定します
        * (新規スライドショーのアップロード用)
        */
       public function setFilename($file) {
           $this->_slideShowFilename = (string)$file;
           return $this;
       }

       /**
        * アップロードしようとしているスライドショーの
        * ローカルファイルシステム上でのファイル名を取得します
        */
       public function getFilename() {
           return $this->_slideShowFilename;
       }

       /**
        * スライドショーの ID を取得します
        */
       public function getId() {
           return $this->_slideShowId;
       }

       /**
        * スライドショーの HTML 埋め込み用のコードを取得します
        */
       public function getEmbedCode() {
           return $this->_embedCode;
       }

       /**
        * スライドショーのサムネイルの URL を取得します
        */
       public function getThumbnailUrl() {
           return $this->_thumbnailUrl;
       }

       /**
        * スライドショーのタイトルを設定します
        */
       public function setTitle($title) {
           $this->_title = (string)$title;
           return $this;
       }

       /**
        * スライドショーのタイトルを取得します
        */
       public function getTitle() {
           return $this->_title;
       }

       /**
        * スライドショーの説明を設定します
        */
       public function setDescription($desc) {
           $this->_description = (string)$desc;
           return $this;
       }

       /**
        * スライドショーの説明を取得します
        */
       public function getDescription() {
           return $this->_description;
       }

       /**
        * サーバ上でのスライドショーの状態を表す数値を取得します
        */
       public function getStatus() {
           return $this->_status;
       }

       /**
        * サーバ上でのスライドショーの状態を表す説明テキストを取得します
        */
       public function getStatusDescription() {
           return $this->_statusDescription;
       }

       /**
        * スライドショーのパーマネントリンクを取得します
        */
       public function getPermaLink() {
           return $this->_permalink;
       }

       /**
        * スライドショーの閲覧回数を取得します
        */
       public function getNumViews() {
           return $this->_numViews;
       }
   }

.. note::

   上の擬似クラスは、開発者がどんなメソッドを使えるのかを示すためだけのものです。
   それ以外に、内部で用いられているメソッドもあります。

``Zend_Service_SlideShare`` コンポーネントを使う際には、
このデータクラスを使用してスライドショーの閲覧や追加を行うことになります。

.. _zend.service.slideshare.getslideshow:

単一のスライドショーの取得
-------------

``Zend_Service_SlideShare`` コンポーネントのもっともシンプルな使用法は、 slideshare.net
が提供するスライドショー ID を指定して単一のスライドショーを取得することです。
これは、 ``Zend_Service_SlideShare`` オブジェクトの ``getSlideShow()`` メソッドで行います。
そして、返された ``Zend_Service_SlideShare_SlideShow``
オブジェクトをこのように使用します。

.. code-block:: php
   :linenos:

   // このコンポーネントの新しいインスタンスを作成します
   $ss = new Zend_Service_SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');

   $slideshow = $ss->getSlideShow(123456);

   print "スライドショーのタイトル: {$slideshow->getTitle()}<br/>\n";
   print "閲覧回数: {$slideshow->getNumViews()}<br/>\n";

.. _zend.service.slideshare.getslideshowlist:

スライドショーのグループの取得
---------------

取得したいスライドショーの ID がわからない場合は、 以下の 3
つのうちのいずれかの方法でスライドショーのグループを取得します。

- **特定のアカウントでアップロードしたスライドショー**

  特定のアカウントのスライドショーを取得するには ``getSlideShowsByUsername()``
  メソッドを使用します。 スライドショーを取得したいユーザ名を指定します。

- **特定のタグを含むスライドショー**

  特定の (ひとつあるいは複数の) タグを含むスライドショーを取得するには
  ``getSlideShowsByTag()`` メソッドを使用します。 スライドショーを取得したい
  (ひとつあるいは複数の) タグを指定します。

- **特定のグループに属するスライドショー**

  特定のグループに属するスライドショーを取得するには ``getSlideShowsByGroup()``
  メソッドを使用します。
  取得したいスライドショーが属しているグループの名前を指定します。

これらの方法で複数のスライドショーを取得するやりかたは、どれもよく似ています。
各メソッドの使用例を以下に示します。

.. code-block:: php
   :linenos:

   // このコンポーネントの新しいインスタンスを作成します
   $ss = new Zend_Service_SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');

   $starting_offset = 0;
   $limit = 10;

   // それぞれの方法で最初の 10 件を取得します
   $ss_user = $ss->getSlideShowsByUser('username', $starting_offset, $limit);
   $ss_tags = $ss->getSlideShowsByTag('zend', $starting_offset, $limit);
   $ss_group = $ss->getSlideShowsByGroup('mygroup', $starting_offset, $limit);

   // 個々のスライドショーを処理します
   foreach($ss_user as $slideshow) {
      print "スライドショーのタイトル: {$slideshow->getTitle}<br/>\n";
   }

.. _zend.service.slideshare.caching:

Zend_Service_SlideShare のキャッシュ処理のポリシー
-------------------------------------

デフォルトでは、 ``Zend_Service_SlideShare``
はウェブサービスに対する任意のリクエストを自動的にキャッシュします。
キャッシュは、ファイルシステム上 (デフォルトのパスは */tmp*) に 12
時間保存されます。この振る舞いを変更したい場合は、独自の :ref:` <zend.cache>`
オブジェクトを作成してそれを ``setCacheObject()`` メソッドでこのように指定します。

.. code-block:: php
   :linenos:

   $frontendOptions = array(
                           'lifetime' => 7200,
                           'automatic_serialization' => true);
   $backendOptions  = array(
                           'cache_dir' => '/webtmp/');

   $cache = Zend_Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   $ss = new Zend_Service_SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');
   $ss->setCacheObject($cache);

   $ss_user = $ss->getSlideShowsByUser('username', $starting_offset, $limit);

.. _zend.service.slideshare.httpclient:

HTTP クライアントの振る舞いの変更
-------------------

何らかの理由でウェブサービスにリクエストを送る *HTTP*
クライアントの振る舞いを変更したくなったとしましょう。 そんな場合は、独自の
``Zend_Http_Client`` オブジェクトのインスタンスを作成します (:ref:` <zend.http>`
を参照ください)。これは、
たとえば接続のタイムアウト秒数をデフォルトから変更したい場合などに便利です。

.. code-block:: php
   :linenos:

   $client = new Zend_Http_Client();
   $client->setConfig(array('timeout' => 5));

   $ss = new Zend_Service_SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');
   $ss->setHttpClient($client);
   $ss_user = $ss->getSlideShowsByUser('username', $starting_offset, $limit);



.. _`slideshare.net`: http://www.slideshare.net/
.. _`こちら`: http://www.slideshare.net/developers/
