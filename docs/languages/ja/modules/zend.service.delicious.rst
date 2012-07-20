.. _zend.service.delicious:

Zend_Service_Delicious
======================

.. _zend.service.delicious.introduction:

導入
--

``Zend_Service_Delicious`` は、 `del.icio.us`_ の *XML* および *JSON*
ウェブサービスを使用するためのシンプルな *API* です。
このコンポーネントによって、del.icio.us への投稿のうち、
権限を持っているものについての読み書きが可能になります。
全ユーザの公開データへの読み込み専用のアクセスも可能です。

.. _zend.service.delicious.introduction.getAllPosts:

.. rubric:: すべての投稿の取得

.. code-block:: php
   :linenos:

   $delicious = new Zend_Service_Delicious('ユーザ名', 'パスワード');
   $posts = $delicious->getAllPosts();

   foreach ($posts as $post) {
       echo "--\n";
       echo "タイトル: {$post->getTitle()}\n";
       echo "URL: {$post->getUrl()}\n";
   }

.. _zend.service.delicious.retrieving_posts:

投稿の取得
-----

``Zend_Service_Delicious`` には、投稿を取得するメソッドとして ``getPosts()``\ 、
``getRecentPosts()`` および ``getAllPosts()`` の三種類があります。 これらはすべて
``Zend_Service_Delicious_PostList``
のインスタンスを返します。ここに、取得したすべての投稿が含まれます。

.. code-block:: php
   :linenos:

   /**
    * 引数にマッチする投稿を取得する。日付や url を省略した場合は
    * 直近の日付を使用する
    *
    * @param string $tag オプションで、タグによる絞込みを行う
    * @param Zend_Date $dt オプションで、日付による絞込みを行う
    * @param string $url オプションで、url による絞込みを行う
    * @return Zend_Service_Delicious_PostList
    */
   public function getPosts($tag = null, $dt = null, $url = null);

   /**
    * 直近の投稿を取得する
    *
    * @param string $tag   オプションで、タグによる絞込みを行う
    * @param string $count 返す投稿の最大数 (デフォルトは 15)
    * @return Zend_Service_Delicious_PostList
    */
   public function getRecentPosts($tag = null, $count = 15);

   /**
    * すべての投稿を取得する
    *
    * @param string $tag オプションで、タグによる絞込みを行う
    * @return Zend_Service_Delicious_PostList
    */
   public function getAllPosts($tag = null);

.. _zend.service.delicious.postlist:

Zend_Service_Delicious_PostList
-------------------------------

``Zend_Service_Delicious`` のメソッド ``getPosts()``\ 、 ``getAllPosts()``\ 、 ``getRecentPosts()``
および ``getUserPosts()`` が、このクラスのインスタンスを返します。

データへのアクセスを簡単に行うため、このクラスは *Countable*\ 、 *Iterator* および
*ArrayAccess* の三つのインターフェイスを実装しています。

.. _zend.service.delicious.postlist.accessing_post_lists:

.. rubric:: 投稿一覧へのアクセス

.. code-block:: php
   :linenos:

   $delicious = new Zend_Service_Delicious('ユーザ名', 'パスワード');
   $posts = $delicious->getAllPosts();

   // 投稿数を数えます
   echo count($posts);

   // 投稿を順次処理します
   foreach ($posts as $post) {
       echo "--\n";
       echo "タイトル: {$post->getTitle()}\n";
       echo "URL: {$post->getUrl()}\n";
   }

   // 配列風のアクセス方式で投稿を取得します
   echo $posts[0]->getTitle();

.. note::

   メソッド ``ArrayAccess::offsetSet()`` および ``ArrayAccess::offsetUnset()``
   は、この実装では例外をスローします。つまり、 ``unset($posts[0]);`` や *$posts[0] = 'A';*
   といったコードを書くと例外が発生するということです。
   というのも、これらのプロパティは読み込み専用だからです。

投稿一覧オブジェクトには、二種類のフィルタリング機能が組み込まれています。
タグによるフィルタリングと、 *URL* によるフィルタリングです。

.. _zend.service.delicious.postlist.example.withTags:

.. rubric:: タグの指定による投稿一覧のフィルタリング

特定のタグで投稿を絞り込むには、 ``withTags()`` を使用します。
ひとつのタグでだけ絞り込みを行う際に便利なように、 ``withTag()``
も用意されています。

.. code-block:: php
   :linenos:

   $delicious = new Zend_Service_Delicious('ユーザ名', 'パスワード');
   $posts = $delicious->getAllPosts();

   // タグ "php" および "zend" が指定されている投稿のみを表示します
   foreach ($posts->withTags(array('php', 'zend')) as $post) {
       echo "タイトル: {$post->getTitle()}\n";
       echo "URL: {$post->getUrl()}\n";
   }

.. _zend.service.delicious.postlist.example.byUrl:

.. rubric:: URL の指定による投稿一覧のフィルタリング

指定した正規表現にマッチする *URL* で投稿を絞り込むには ``withUrl()``
メソッドを使用します。

.. code-block:: php
   :linenos:

   $delicious = new Zend_Service_Delicious('ユーザ名', 'パスワード');
   $posts = $delicious->getAllPosts();

   // URL に "help" を含む投稿のみを表示します
   foreach ($posts->withUrl('/help/') as $post) {
       echo "タイトル: {$post->getTitle()}\n";
       echo "URL: {$post->getUrl()}\n";
   }

.. _zend.service.delicious.editing_posts:

投稿の編集
-----

.. _zend.service.delicious.editing_posts.post_editing:

.. rubric:: 投稿の編集

.. code-block:: php
   :linenos:

   $delicious = new Zend_Service_Delicious('ユーザ名', 'パスワード');
   $posts = $delicious->getPosts();

   // タイトルを設定します
   $posts[0]->setTitle('新しいタイトル');
   // 変更を保存します
   $posts[0]->save();

.. _zend.service.delicious.editing_posts.method_call_chaining:

.. rubric:: メソッドコールの連結

すべての設定用メソッドは post オブジェクトを返すので、
「流れるようなインターフェイス」を使用してメソッドコールを連結できます。

.. code-block:: php
   :linenos:

   $delicious = new Zend_Service_Delicious('ユーザ名', 'パスワード');
   $posts = $delicious->getPosts();

   $posts[0]->setTitle('新しいタイトル')
            ->setNotes('新しいメモ')
            ->save();

.. _zend.service.delicious.deleting_posts:

投稿の削除
-----

投稿を削除する方法は二通りあります。 投稿の URL を指定するか、post
オブジェクトの ``delete()`` メソッドを実行するかのいずれかです。

.. _zend.service.delicious.deleting_posts.deleting_posts:

.. rubric:: 投稿の削除

.. code-block:: php
   :linenos:

   $delicious = new Zend_Service_Delicious('ユーザ名', 'パスワード');

   // URL を指定します
   $delicious->deletePost('http://framework.zend.com');

   // あるいは、post オブジェクトのメソッドをコールします
   $posts = $delicious->getPosts();
   $posts[0]->delete();

   // deletePost() を使用する、もうひとつの方法
   $delicious->deletePost($posts[0]->getUrl());

.. _zend.service.delicious.adding_posts:

新しい投稿の追加
--------

投稿を追加するには ``createNewPost()`` メソッドをコールする必要があります。
このメソッドは ``Zend_Service_Delicious_Post`` オブジェクトを返します。
投稿を編集したら、それを del.icio.us のデータベースに保存するために ``save()``
メソッドをコールします。

.. _zend.service.delicious.adding_posts.adding_a_post:

.. rubric:: 投稿の追加

.. code-block:: php
   :linenos:

   $delicious = new Zend_Service_Delicious('ユーザ名', 'パスワード');

   // 新しい投稿を作成し、保存します (メソッドコールの連結を使用します)
   $delicious->createNewPost('Zend Framework', 'http://framework.zend.com')
             ->setNotes('Zend Framework Homepage')
             ->save();

   // 新しい投稿を作成し、保存します (メソッドコールの連結を使用しません)
   $newPost = $delicious->createNewPost('Zend Framework',
                                        'http://framework.zend.com');
   $newPost->setNotes('Zend Framework Homepage');
   $newPost->save();

.. _zend.service.delicious.tags:

タグ
--

.. _zend.service.delicious.tags.tags:

.. rubric:: タグ

.. code-block:: php
   :linenos:

   $delicious = new Zend_Service_Delicious('ユーザ名', 'パスワード');

   // すべてのタグを取得します
   print_r($delicious->getTags());

   // タグ ZF の名前を zendFramework に変更します
   $delicious->renameTag('ZF', 'zendFramework');

.. _zend.service.delicious.bundles:

バンドル
----

.. _zend.service.delicious.bundles.example:

.. rubric:: バンドル

.. code-block:: php
   :linenos:

   $delicious = new Zend_Service_Delicious('ユーザ名', 'パスワード');

   // すべてのバンドルを取得します
   print_r($delicious->getBundles());

   // someBundle というバンドルを削除します
   $delicious->deleteBundle('someBundle');

   // バンドルを追加します
   $delicious->addBundle('newBundle', array('tag1', 'tag2'));

.. _zend.service.delicious.public_data:

公開データ
-----

del.icio.us のウェブ *API*
を使用すると、全ユーザの公開データにアクセスできるようになります。

.. _zend.service.delicious.public_data.functions_for_retrieving_public_data:

.. table:: 公開データを取得するためのメソッド

   +----------------+------------------------------------------------------+-------------------------------+
   |名前              |説明                                                    |返り値の型                          |
   +================+======================================================+===============================+
   |getUserFans()   |あるユーザのファンを取得します                                       |Array                          |
   +----------------+------------------------------------------------------+-------------------------------+
   |getUserNetwork()|あるユーザのネットワークを取得します                                    |Array                          |
   +----------------+------------------------------------------------------+-------------------------------+
   |getUserPosts()  |あるユーザの投稿を取得します                                        |Zend_Service_Delicious_PostList|
   +----------------+------------------------------------------------------+-------------------------------+
   |getUserTags()   |あるユーザのタグを取得します                                        |Array                          |
   +----------------+------------------------------------------------------+-------------------------------+

.. note::

   これらのメソッドを使用するだけなら、 ``Zend_Service_Delicious``
   オブジェクトの作成時に ユーザ名とパスワードを指定する必要はありません。

.. _zend.service.delicious.public_data.retrieving_public_data:

.. rubric:: 公開データの取得

.. code-block:: php
   :linenos:

   // ユーザ名とパスワードは不要です
   $delicious = new Zend_Service_Delicious();

   // someUser のファンを取得します
   print_r($delicious->getUserFans('someUser'));

   // someUser のネットワークを取得します
   print_r($delicious->getUserNetwork('someUser'));

   // someUser のタグを取得します
   print_r($delicious->getUserTags('someUser'));

.. _zend.service.delicious.public_data.posts:

公開投稿
^^^^

公開投稿を ``getUserPosts()`` メソッドで取得すると、 ``Zend_Service_Delicious_PostList``
オブジェクトが返されます。ここには ``Zend_Service_Delicious_SimplePost``
オブジェクトが含まれ、 その中には *URL*
やタイトル、メモ、タグといった投稿に関する基本情報が含まれます。

.. _zend.service.delicious.public_data.posts.SimplePost_methods:

.. table:: Zend_Service_Delicious_SimplePost クラスのメソッド

   +----------+------------------------------------+---------------+
   |名前        |説明                                  |返り値の型          |
   +==========+====================================+===============+
   |getNotes()|投稿のメモを返します                          |String         |
   +----------+------------------------------------+---------------+
   |getTags() |投稿のタグを返します                          |Array          |
   +----------+------------------------------------+---------------+
   |getTitle()|投稿のタイトルを返します                        |String         |
   +----------+------------------------------------+---------------+
   |getUrl()  |投稿の URL を返します                       |String         |
   +----------+------------------------------------+---------------+

.. _zend.service.delicious.httpclient:

HTTP クライアント
-----------

``Zend_Service_Delicious`` は、 *Zend_Rest_Client* を使用して del.icio.us ウェブサービスへの *HTTP*
リクエストを作成します。 ``Zend_Service_Delicious`` が使用する *HTTP*
クライアントを変更するには、 ``Zend_Rest_Client`` の *HTTP*
クライアントを変更する必要があります。

.. _zend.service.delicious.httpclient.changing:

.. rubric:: Zend_Rest_Client の HTTP クライアントの変更

.. code-block:: php
   :linenos:

   $myHttpClient = new My_Http_Client();
   Zend_Rest_Client::setHttpClient($myHttpClient);

``Zend_Service_Delicious`` で複数のリクエストを作成する際に
それを高速化するなら、接続をキープするように *HTTP*
クライアントを設定するとよいでしょう。

.. _zend.service.delicious.httpclient.keepalive:

.. rubric:: HTTP クライアントを、接続を保持し続けるように設定する

.. code-block:: php
   :linenos:

   Zend_Rest_Client::getHttpClient()->setConfig(array(
           'keepalive' => true
   ));

.. note::

   ``Zend_Service_Delicious`` オブジェクトを作成する際に、 ``Zend_Rest_Client`` の *SSL*
   トランスポートは *'ssl'* と設定されます。デフォルトの *'ssl2'*
   ではありません。これは、del.icio.us 側の問題で、 *'ssl2'*
   を使用するとリクエストの処理に時間がかかる (ほぼ 2 秒くらい) ためです。



.. _`del.icio.us`: http://del.icio.us
