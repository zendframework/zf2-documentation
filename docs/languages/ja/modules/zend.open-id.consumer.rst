.. EN-Revision: none
.. _zend.openid.consumer:

Zend_OpenId_Consumer の基本
========================

``Zend_OpenId_Consumer`` を使用して、 ウェブサイト上の OpenID 認証スキーマを実装します。

.. _zend.openid.consumer.authentication:

OpenID Authentication
---------------------

サイト開発者の視点で見ると、OpenID の認証手続きは次の三段階となります。

. OpenID 認証フォームを表示する。

. OpenID の識別子を受け取り、それを OpenID プロバイダに渡す。

. OpenID プロバイダからの応答を検証する。

実際のところ、OpenID 認証プロトコルはもう少し複雑な手順を踏んでいます。
しかしその大半は ``Zend_OpenId_Consumer``
の中にカプセル化されており、開発者側が意識する必要はありません。

OpenID 認証手続きはエンドユーザ側から始まるもので、
まず認証情報を適切な形式で入力してそれを送信するところから始まります。
次の例は、OpenID 識別子を受け付けるシンプルなフォームを表示するものです。
このサンプルはログイン画面を表示するだけのものであることに注意しましょう。

.. _zend.openid.consumer.example-1:

.. rubric:: シンプルな OpenID ログインフォーム

.. code-block:: php
   :linenos:

   <html><body>
   <form method="post" action="example-1_2.php"><fieldset>
   <legend>OpenID ログイン</legend>
   <input type="text" name="openid_identifier">
   <input type="submit" name="openid_action" value="login">
   </fieldset></form></body></html>

このフォームを送信すると、OpenID 識別子が継ぎの *PHP*
スクリプトに渡されます。このスクリプトが、 認証の第二段階を処理します。 この
*PHP* スクリプトで必要なのは、 ``Zend_OpenId_Consumer::login()``
メソッドをコールすることだけです。 このメソッドの最初の引数は OpenID 識別子で、
2 番目の引数はスクリプトの *URL* となります。
ここで指定したスクリプトが認証の第三段階を処理します。

.. _zend.openid.consumer.example-1_2:

.. rubric:: 認証リクエストのハンドラ

.. code-block:: php
   :linenos:

   $consumer = new Zend_OpenId_Consumer();
   if (!$consumer->login($_POST['openid_identifier'], 'example-1_3.php')) {
       die("OpenID でのログインに失敗しました。");
   }

``Zend_OpenId_Consumer::login()``
は指定された識別子を調べ、成功した場合には識別プロバイダのアドレスと
そのローカル識別子を取得します。そして、 そのプロバイダとの関連付けを行い、
サイトとプロバイダが同じ秘密情報を共有するようにします。
この情報を使用してそれ以降のメッセージの署名を行います。
それから、認証リクエストをプロバイダに渡します。
このリクエストは、エンドユーザ側のウェブブラウザから OpenID
サーバサイトにリダイレクトされることに注意しましょう。
ユーザは、その後も認証手続きを進めることができます。

OpenID サーバがユーザに通常たずねるのは、 パスワード
(ユーザがまだログインしていない場合) や
ユーザがこのサイトを信頼しているかどうか、
そしてそのサイトからどんな情報を返すかといった内容です。
これらのやりとりは、OpenID 対応のサイトからは見えない状態になるので、
ユーザのパスワードやその他の情報はオープンにはなりません。

成功した場合は ``Zend_OpenId_Consumer::login()`` は何も返さずに *HTTP*
リダイレクトを行います。 エラーが発生した場合は ``FALSE`` を返します。
エラーが発生するのは、たとえば識別子が無効だったり
プロバイダが死んでいたり、通信障害が発生したりした場合などです。

認証の第三段階の処理は、ユーザのパスワードによる認証を終えた OpenID
プロバイダからの応答によって始まります。 この応答は、ウェブブラウザの *HTTP*
リダイレクトによって間接的に渡されます。
サイト側では、この応答が正しいものであるかどうかだけを確認することになります。

.. _zend.openid.consumer.example-1_3:

.. rubric:: 認証の応答の検証

.. code-block:: php
   :linenos:

   $consumer = new Zend_OpenId_Consumer();
   if ($consumer->verify($_GET, $id)) {
       echo "有効 " . htmlspecialchars($id);
   } else {
       echo "無効 " . htmlspecialchars($id);
   }

この検証は ``Zend_OpenId_Consumer::verify`` メソッドで行います。このメソッドは、 *HTTP*
リクエストの引数の配列全体を受け取って、 そのレスポンスが適切な OpenID
プロバイダによって署名されたものかどうかを調べます。
また、エンドユーザが最初に入力した OpenID 識別子を 2 番目の (オプションの)
引数として渡します。

.. _zend.openid.consumer.combine:

すべての処理をひとつのページにまとめる
-------------------

次の例は、これらの三段階をひとつにまとめたものです。
それ以外に特別な付加機能はありません。
唯一の利点は、次の段階を処理するスクリプトの *URL*
を指定しなくてもよくなるということです。 デフォルトでは、すべての段階を同じ
*URL* で処理します。
ただ、このスクリプトの内部にはディスパッチ用のコードが含まれており、
認証の各段階に応じて適切なコードに処理を振り分けるようになっています。

.. _zend.openid.consumer.example-2:

.. rubric:: 完全な OpenID ログインスクリプト

.. code-block:: php
   :linenos:

   <?php
   $status = "";
   if (isset($_POST['openid_action']) &&
       $_POST['openid_action'] == "login" &&
       !empty($_POST['openid_identifier'])) {

       $consumer = new Zend_OpenId_Consumer();
       if (!$consumer->login($_POST['openid_identifier'])) {
           $status = "OpenID でのログインに失敗しました。";
       }
   } else if (isset($_GET['openid_mode'])) {
       if ($_GET['openid_mode'] == "id_res") {
           $consumer = new Zend_OpenId_Consumer();
           if ($consumer->verify($_GET, $id)) {
               $status = "有効 " . htmlspecialchars($id);
           } else {
               $status = "無効 " . htmlspecialchars($id);
           }
       } else if ($_GET['openid_mode'] == "cancel") {
           $status = "キャンセル";
       }
   }
   ?>
   <html><body>
   <?php echo "$status<br>" ?>
   <form method="post">
   <fieldset>
   <legend>OpenID ログイン</legend>
   <input type="text" name="openid_identifier" value=""/>
   <input type="submit" name="openid_action" value="login"/>
   </fieldset>
   </form>
   </body></html>

さらに、このコードでは
キャンセルされた場合と認証の応答が間違っていた場合を区別しています。
プロバイダの応答がキャンセルとなるのは、
識別プロバイダがその識別子について知らなかった場合や
ユーザがログインしていない場合、
あるいはユーザがそのサイトを信頼しない場合などです。 応答が間違っているのは、
署名が間違っている場合などです。

.. _zend.openid.consumer.realm:

コンシューマレルム
---------

OpenID 対応のサイトがプロバイダへの認証リクエストを通過すると、
自分自身をレルム *URL* で識別するようになります。 この *URL*
は、信頼済みサイトのルートとみなされます。 ユーザがその *URL* を信頼すると、
その配下の *URL* も同様に信頼することになります。

デフォルトでは、レルム *URL* は自動的にログインスクリプトがあるディレクトリの
*URL* に設定されます。大半の場合はこれで大丈夫ですが、
そうではない場合もあります。
際と全体で共通のログインスクリプトを使用している場合や、
ひとつのドメインで複数のサーバを組み合わせて使用している場合などです。

このような場合は、レルムの値を ``Zend_OpenId_Consumer::login`` メソッドの 3
番目の引数として渡すことができます。 次の例は、すべての php.net
サイトへの信頼済みアクセスを一度に確認するものです。

.. _zend.openid.consumer.example-3_2:

.. rubric:: 指定したレルムへの認証リクエスト

.. code-block:: php
   :linenos:

   $consumer = new Zend_OpenId_Consumer();
   if (!$consumer->login($_POST['openid_identifier'],
                         'example-3_3.php',
                         'http://*.php.net/')) {
       die("OpenID でのログインに失敗しました。");
   }

以下の例では、認証の第二段階のみを実装しています。
それ以外の段階については最初の例と同じです。

.. _zend.openid.consumer.check:

即時確認
----

場合によっては、信頼済み OpenID サーバにそのユーザがログインしているかどうかを
ユーザとのやりとりなしに知りたいこともあります。
そのような場合に最適なメソッドが ``Zend_OpenId_Consumer::check``
です。このメソッドの引数は ``Zend_OpenId_Consumer::login``
とまったく同じですが、ユーザ側には OpenID サーバのページを一切見せません。
したがって、ユーザ側から見れば処理は透過的に行われ、
まるで他のサイトに一切移動していないように見えるようになります。
そのユーザがすでにログインしており、かつそのサイトを信頼している場合に
第三段階の処理が成功し、それ以外の場合は失敗します。

.. _zend.openid.consumer.example-4:

.. rubric:: 対話形式でない即時確認

.. code-block:: php
   :linenos:

   $consumer = new Zend_OpenId_Consumer();
   if (!$consumer->check($_POST['openid_identifier'], 'example-4_3.php')) {
       die("OpenID でのログインに失敗しました。");
   }

以下の例では、認証の第二段階のみを実装しています。
それ以外の段階については最初の例と同じです。

.. _zend.openid.consumer.storage:

Zend_OpenId_Consumer_Storage
----------------------------

OpenID の認証手続きは三段階に分かれており、 それぞれで別々の *HTTP*
リクエストを使用します。 それらのリクエスト間で情報を保存するため、
``Zend_OpenId_Consumer`` では内部ストレージを使用します。

開発者は特にこのストレージを気にする必要はありません。 デフォルトで、
``Zend_OpenId_Consumer`` は /tmp 配下のファイルベースのストレージを使用するからです。
これは *PHP* のセッションと同じ挙動です。
しかし、このストレージがあらゆる場合にうまく使えるというわけではありません。
たとえばその手の情報はデータベースに保存したいという人もいるでしょうし、
大規模なウェブファームで共通のストレージを使用したいこともあるでしょう。
幸いなことに、このデフォルトのストレージは簡単に変更できます。
そのために必要なのは、 ``Zend_OpenId_Consumer_Storage``
クラスを継承した独自のストレージクラスを実装して それを ``Zend_OpenId_Consumer``
のコンストラクタへの最初の引数として渡すことだけです。

次の例は、バックエンドとして ``Zend_Db``
を使用するシンプルなストレージです。三種類の機能を持っています。
最初の機能は関連付けの情報、そして 2 番目が確認した内容のキャッシュ、 そして 3
番目が応答の一意性の確認です。このクラスは、
既存のデータベースや新しいデータベースで簡単に使用できるように実装されています。
必要に応じて、もしまだテーブルが存在しなければ自動的にテーブルを作成します。

.. _zend.openid.consumer.example-5:

.. rubric:: データベースストレージ

.. code-block:: php
   :linenos:

   class DbStorage extends Zend_OpenId_Consumer_Storage
   {
       private $_db;
       private $_association_table;
       private $_discovery_table;
       private $_nonce_table;

       // Zend_Db_Adapter オブジェクトと
       // テーブル名を渡します
       public function __construct($db,
                                   $association_table = "association",
                                   $discovery_table = "discovery",
                                   $nonce_table = "nonce")
       {
           $this->_db = $db;
           $this->_association_table = $association_table;
           $this->_discovery_table = $discovery_table;
           $this->_nonce_table = $nonce_table;
           $tables = $this->_db->listTables();

           // アソシエーションテーブルが存在しない場合は作成します
           if (!in_array($association_table, $tables)) {
               $this->_db->getConnection()->exec(
                   "create table $association_table (" .
                   " url     varchar(256) not null primary key," .
                   " handle  varchar(256) not null," .
                   " macFunc char(16) not null," .
                   " secret  varchar(256) not null," .
                   " expires timestamp" .
                   ")");
           }

           // ディスカバリーテーブルが存在しない場合は作成します
           if (!in_array($discovery_table, $tables)) {
               $this->_db->getConnection()->exec(
                   "create table $discovery_table (" .
                   " id      varchar(256) not null primary key," .
                   " realId  varchar(256) not null," .
                   " server  varchar(256) not null," .
                   " version float," .
                   " expires timestamp" .
                   ")");
           }

           // ノンステーブルが存在しない場合は作成します
           if (!in_array($nonce_table, $tables)) {
               $this->_db->getConnection()->exec(
                   "create table $nonce_table (" .
                   " nonce   varchar(256) not null primary key," .
                   " created timestamp default current_timestamp" .
                   ")");
           }
       }

       public function addAssociation($url,
                                      $handle,
                                      $macFunc,
                                      $secret,
                                      $expires)
       {
           $table = $this->_association_table;
           $secret = base64_encode($secret);
           $this->_db->insert($table, array(
               'url'     => $url,
               'handle'  => $handle,
               'macFunc' => $macFunc,
               'secret'  => $secret,
               'expires' => $expires,
           ));
           return true;
       }

       public function getAssociation($url,
                                      &$handle,
                                      &$macFunc,
                                      &$secret,
                                      &$expires)
       {
           $table = $this->_association_table;
           $this->_db->delete(
               $table, $this->_db->quoteInto('expires < ?', time())
           );
           $select = $this-_db->select()
                   ->from($table, array('handle', 'macFunc', 'secret', 'expires'))
                   ->where('url = ?', $url);
           $res = $this->_db->fetchRow($select);

           if (is_array($res)) {
               $handle  = $res['handle'];
               $macFunc = $res['macFunc'];
               $secret  = base64_decode($res['secret']);
               $expires = $res['expires'];
               return true;
           }
           return false;
       }

       public function getAssociationByHandle($handle,
                                              &$url,
                                              &$macFunc,
                                              &$secret,
                                              &$expires)
       {
           $table = $this->_association_table;
           $this->_db->delete(
               $table, $this->_db->quoteInto('expires < ', time())
           );
           $select = $this->_db->select()
                   ->from($table, array('url', 'macFunc', 'secret', 'expires')
                   ->where('handle = ?', $handle);
           $res = $select->fetchRow($select);

           if (is_array($res)) {
               $url     = $res['url'];
               $macFunc = $res['macFunc'];
               $secret  = base64_decode($res['secret']);
               $expires = $res['expires'];
               return true;
           }
           return false;
       }

       public function delAssociation($url)
       {
           $table = $this->_association_table;
           $this->_db->query("delete from $table where url = '$url'");
           return true;
       }

       public function addDiscoveryInfo($id,
                                        $realId,
                                        $server,
                                        $version,
                                        $expires)
       {
           $table = $this->_discovery_table;
           $this->_db->insert($table, array(
               'id'      => $id,
               'realId'  => $realId,
               'server'  => $server,
               'version' => $version,
               'expires' => $expires,
           ));

           return true;
       }

       public function getDiscoveryInfo($id,
                                        &$realId,
                                        &$server,
                                        &$version,
                                        &$expires)
       {
           $table = $this->_discovery_table;
           $this->_db->delete($table, $this->quoteInto('expires < ?', time()));
           $select = $this->_db->select()
                   ->from($table, array('realId', 'server', 'version', 'expires'))
                   ->where('id = ?', $id);
           $res = $this->_db->fetchRow($select);

           if (is_array($res)) {
               $realId  = $res['realId'];
               $server  = $res['server'];
               $version = $res['version'];
               $expires = $res['expires'];
               return true;
           }
           return false;
       }

       public function delDiscoveryInfo($id)
       {
           $table = $this->_discovery_table;
           $this->_db->delete($table, $this->_db->quoteInto('id = ?', $id));
           return true;
       }

       public function isUniqueNonce($nonce)
       {
           $table = $this->_nonce_table;
           try {
               $ret = $this->_db->insert($table, array(
                   'nonce' => $nonce,
               ));
           } catch (Zend_Db_Statement_Exception $e) {
               return false;
           }
           return true;
       }

       public function purgeNonces($date=null)
       {
       }
   }

   $db = Zend_Db::factory('Pdo_Sqlite',
       array('dbname'=>'/tmp/openid_consumer.db'));
   $storage = new DbStorage($db);
   $consumer = new Zend_OpenId_Consumer($storage);

このサンプルには OpenID の認証コードそのものは含まれません。
しかし、先ほどの例やこの後の例と同じロジックに基づいています。

.. _zend.openid.consumer.sreg:

Simple Registration Extension
-----------------------------

認証に加えて、OpenID は軽量なプロファイル交換のためにも使用できます。
この機能は OpenID 認証の仕様ではカバーされておらず、 OpenID Simple Registration Extension
プロトコルで対応しています。 このプロトコルを使用すると、 OpenID
対応のサイトがエンドユーザに関する情報を OpenID
プロバイダから取得できるようになります。
取得できる情報には次のようなものがあります。

- **nickname**- ユーザがニックネームとして使用している UTF-8 文字列。

- **email**- エンドユーザのメールアドレス。RFC2822 のセクション 3.4.1 の形式。

- **fullname**- エンドユーザのフルネームを表す UTF-8 文字列。

- **dob**- エンドユーザの誕生日を YYYY-MM-DD 形式で表したもの。
  指定されている桁数より少ない場合は、ゼロ埋めされます。 この値は常に 10
  文字となります。 エンドユーザがこの情報の公開を希望しない場合は、
  その部分の値をゼロに設定する必要があります。 たとえば、1980
  年生まれであることは公開するが
  月や日は公開したくないというエンドユーザの場合、 返される値は "1980-00-00"
  となります。

- **gender**- エンドユーザの姓。"M" が男性で "F" が女性。

- **postcode**- エンドユーザの国の郵便システムに対応した UTF-8 文字列。

- **country**- エンドユーザの居住地 (国) を ISO3166 形式で表したもの。

- **language**- エンドユーザの使用言語を ISO639 形式で表したもの。

- **timezone**- TimeZone データベースの *ASCII* 文字列。 "Europe/Paris" あるいは
  "America/Los_Angeles" など。

OpenID 対応のウェブサイトからは、
これらのフィールドの任意の組み合わせについて問い合わせられます。
また、いくつかの情報についてのみ厳密に問い合わせを行い、
それ以外の情報については開示するかしないかをユーザに決めさせることもできます。
次の例は、 **nickname** およびオプションで **email** と **fullname** を要求する
``Zend_OpenId_Extension_Sreg`` クラスのオブジェクトを作成するものです。

.. _zend.openid.consumer.example-6_2:

.. rubric:: Simple Registration Extension のリクエストの送信

.. code-block:: php
   :linenos:

   $sreg = new Zend_OpenId_Extension_Sreg(array(
       'nickname'=>true,
       'email'=>false,
       'fullname'=>false), null, 1.1);
   $consumer = new Zend_OpenId_Consumer();
   if (!$consumer->login($_POST['openid_identifier'],
                         'example-6_3.php',
                         null,
                         $sreg)) {
       die("OpenID でのログインに失敗しました。");
   }

見てのとおり、 ``Zend_OpenId_Extension_Sreg``
のコンストラクタに渡すのは問い合わせたいフィールドの配列です。
この配列のインデックスはフィールド名、値はフラグとなります。 ``TRUE``
はそのフィールドが必須であること、そして ``FALSE``
はそのフィールドがオプションであることを表します。 ``Zend_OpenId_Consumer::login`` の 4
番目の引数には、 extension あるいは extension のリストを指定できます。

認証の第三段階で、 ``Zend_OpenId_Extension_Sreg`` オブジェクトが ``Zend_OpenId_Consumer::verify``
に渡されます。そして、認証に成功すると、 ``Zend_OpenId_Extension_Sreg::getProperties``
は要求されたフィールドの配列を返します。

.. _zend.openid.consumer.example-6_3:

.. rubric:: Simple Registration Extension の応答内容の検証

.. code-block:: php
   :linenos:

   $sreg = new Zend_OpenId_Extension_Sreg(array(
       'nickname'=>true,
       'email'=>false,
       'fullname'=>false), null, 1.1);
   $consumer = new Zend_OpenId_Consumer();
   if ($consumer->verify($_GET, $id, $sreg)) {
       echo "有効 " . htmlspecialchars($id) . "<br>\n";
       $data = $sreg->getProperties();
       if (isset($data['nickname'])) {
           echo "nickname: " . htmlspecialchars($data['nickname']) . "<br>\n";
       }
       if (isset($data['email'])) {
           echo "email: " . htmlspecialchars($data['email']) . "<br>\n";
       }
       if (isset($data['fullname'])) {
           echo "fullname: " . htmlspecialchars($data['fullname']) . "<br>\n";
       }
   } else {
       echo "無効 " . htmlspecialchars($id);
   }

引数を渡さずに ``Zend_OpenId_Extension_Sreg``
を作成した場合は、必要なデータが存在するかどうかを
ユーザ側のコードで調べなければなりません。
しかし、第二段階で必要となるフィールドと同じ内容のリストでオブジェクトを作成した場合は、
必要なデータの存在は自動的にチェックされます。
この場合、必須フィールドのいずれかが存在しなければ ``Zend_OpenId_Consumer::verify`` は
``FALSE`` を返します。

デフォルトでは ``Zend_OpenId_Extension_Sreg`` はバージョン 1.0 を使用します。バージョン
1.1 の仕様はまだ確定していないからです。 しかし、中にはバージョン 1.0
の機能では完全にはサポートしきれないライブラリもあります。 たとえば
www.myopenid.com ではリクエストに SREG 名前空間が必須となりますが、これは 1.1
にしか存在しません。 このサーバを使用する場合は、 ``Zend_OpenId_Extension_Sreg``
のコンストラクタで明示的にバージョン 1.1 を指定する必要があります。

``Zend_OpenId_Extension_Sreg`` のコンストラクタの 2 番目の引数は、 ポリシーの *URL*
です。これは、識別プロバイダがエンドユーザに提供する必要があります。

.. _zend.openid.consumer.auth:

Zend_Auth との統合
--------------

Zend Framework には、ユーザ認証用のクラスが用意されています。 そう、 ``Zend_Auth``
のことです。 このクラスを ``Zend_OpenId_Consumer``
と組み合わせて使うこともできます。次の例は、 *OpenIdAdapter* が
``Zend_Auth_Adapter_Interface`` の *authenticate* メソッドを実装する方法を示すものです。
これは、認証問い合わせと検証を行います。

このアダプタと既存のアダプタの大きな違いは、 このアダプタが 2 回の *HTTP*
リクエストで動作することと OpenID
認証の第二段階、第三段階用に処理を振り分けるコードがあることです。

.. _zend.openid.consumer.example-7:

.. rubric:: OpenID 用の Zend_Auth アダプタ

.. code-block:: php
   :linenos:

   <?php
   class OpenIdAdapter implements Zend_Auth_Adapter_Interface {
       private $_id = null;

       public function __construct($id = null) {
           $this->_id = $id;
       }

       public function authenticate() {
           $id = $this->_id;
           if (!empty($id)) {
               $consumer = new Zend_OpenId_Consumer();
               if (!$consumer->login($id)) {
                   $ret = false;
                   $msg = "認証に失敗しました。";
               }
           } else {
               $consumer = new Zend_OpenId_Consumer();
               if ($consumer->verify($_GET, $id)) {
                   $ret = true;
                   $msg = "認証に成功しました。";
               } else {
                   $ret = false;
                   $msg = "認証に失敗しました。";
               }
           }
           return new Zend_Auth_Result($ret, $id, array($msg));
       }
   }

   $status = "";
   $auth = Zend_Auth::getInstance();
   if ((isset($_POST['openid_action']) &&
        $_POST['openid_action'] == "login" &&
        !empty($_POST['openid_identifier'])) ||
       isset($_GET['openid_mode'])) {
       $adapter = new OpenIdAdapter(@$_POST['openid_identifier']);
       $result = $auth->authenticate($adapter);
       if ($result->isValid()) {
           Zend_OpenId::redirect(Zend_OpenId::selfURL());
       } else {
           $auth->clearIdentity();
           foreach ($result->getMessages() as $message) {
               $status .= "$message<br>\n";
           }
       }
   } else if ($auth->hasIdentity()) {
       if (isset($_POST['openid_action']) &&
           $_POST['openid_action'] == "logout") {
           $auth->clearIdentity();
       } else {
           $status = $auth->getIdentity() . " としてログインしました。<br>\n";
       }
   }
   ?>
   <html><body>
   <?php echo htmlspecialchars($status);?>
   <form method="post"><fieldset>
   <legend>OpenID ログイン</legend>
   <input type="text" name="openid_identifier" value="">
   <input type="submit" name="openid_action" value="login">
   <input type="submit" name="openid_action" value="logout">
   </fieldset></form></body></html>

``Zend_Auth`` と組み合わせた場合、
エンドユーザの識別子はセッションに保存されます。 これを取得するには
``Zend_Auth::hasIdentity`` および ``Zend_Auth::getIdentity`` を使用します。

.. _zend.openid.consumer.mvc:

Zend_Controller との統合
--------------------

最後に、Model-View-Controller
アプリケーションへの組み込みについて簡単に説明しておきます。 Zend Framework
のアプリケーションは ``Zend_Controller`` クラスを使用して実装されており、
エンドユーザのウェブブラウザに返す *HTTP* レスポンスは ``Zend_Controller_Response_Http``
クラスのオブジェクトを使用して準備しています。

``Zend_OpenId_Consumer`` には GUI 機能はありませんが、 ``Zend_OpenId_Consumer::login`` および
``Zend_OpenId_Consumer::check`` に成功した場合に *HTTP* リダイレクトを行います。
もしそれ以前に何らかの情報がウェブブラウザに送信されていると、
このリダイレクトがうまく動作しません。 *MVC* コードで *HTTP*
リダイレクトを正しく機能させるため、 ``Zend_OpenId_Consumer::login`` あるいは
``Zend_OpenId_Consumer::check`` の最後の引数に ``Zend_Controller_Response_Http``
を渡す必要があります。


