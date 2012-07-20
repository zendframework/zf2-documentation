.. _zend.openid.provider:

Zend_OpenId_Provider
====================

``Zend_OpenId_Provider`` は、OpenID サーバを実装するために使用するものです。
本章では、とりあえず動作するサーバを作成するための初歩的な例を説明します。
しかし、実際に運用する OpenID サーバ (`www.myopenid.com`_ などのようなもの)
を実装するには、より複雑な問題に対応する必要があります。

.. _zend.openid.provider.start:

クイックスタート
--------

以下の識別子は、 ``Zend_OpenId_Provider::register``
を使用してユーザアカウントを作成するコードを含みます。 *rel="openid.server"*
が指定されているリンク要素は、
自前のサーバスクリプトを指しています。この識別子を OpenID
対応のサイトに送信すると、このサーバ上での認証を行います。

<html> より前のコードは、
自動的にユーザアカウントを作成するためのちょっとしたおまじないです。
実際の識別子を使用する場合は、このようなコードは不要です。

.. _zend.openid.provider.example-1:

.. rubric:: 識別子

.. code-block:: php
   :linenos:

   <?php
   // テスト用の識別子を準備します
   define("TEST_SERVER", Zend_OpenId::absoluteURL("example-8.php"));
   define("TEST_ID", Zend_OpenId::selfURL());
   define("TEST_PASSWORD", "123");
   $server = new Zend_OpenId_Provider();
   if (!$server->hasUser(TEST_ID)) {
       $server->register(TEST_ID, TEST_PASSWORD);
   }
   ?>
   <html><head>
   <link rel="openid.server" href="<?php echo TEST_SERVER;?>" />
   </head><body>
   <?php echo TEST_ID;?>
   </body></html>

次の識別サーバスクリプトは、OpenID 対応のサイトからの二種類のリクエスト
(関連付けと認証) を処理します。どちらについても、同じメソッド
``Zend_OpenId_Provider::handle`` で処理します。 ``Zend_OpenId_Provider`` へ渡すふたつの引数は
ログイン *URL* と信頼済みページの *URL* で、
これらはエンドユーザから指定されたものです。

成功した場合、 ``Zend_OpenId_Provider::handle``
メソッドは文字列を返します。これはそのまま OpenID
対応のサイトに戻さなければなりません。 失敗した場合は ``FALSE`` を返します。
この例では、失敗した場合に *HTTP* 403 レスポンスを返しています。
このページをウェブブラウザで表示しようとすると、 *HTTP* 403
レスポンスが返されます。リクエストが OpenID 形式ではなかったからです。

.. _zend.openid.provider.example-2:

.. rubric:: シンプルな識別プロバイダ

.. code-block:: php
   :linenos:

   $server = new Zend_OpenId_Provider("example-8-login.php",
                                      "example-8-trust.php");
   $ret = $server->handle();
   if (is_string($ret)) {
       echo $ret;
   } else if ($ret !== true) {
       header('HTTP/1.0 403 Forbidden');
       echo 'Forbidden';
   }

.. note::

   この処理、そしてその後の対話形式のスクリプトではセキュアな接続 (HTTPS)
   を使うことをお勧めします。 これは、パスワードの漏洩を防ぐためです。

次のスクリプトは、識別サーバ ``Zend_OpenId_Provider``
用のログイン画面を実装したものです。
ユーザがまだログインしていない場合は、このページにリダイレクトします。
このページでユーザがパスワードを入力してログインを行います。

この識別子スクリプトからのユーザ登録時のパスワードは "123" です。

送信すると、このスクリプトは ``Zend_OpenId_Provider::login``
にエンドユーザの識別子とパスワードを渡し、識別プロバイダのスクリプトにリダイレクトします。
成功した場合、 ``Zend_OpenId_Provider::login``
はエンドユーザと識別プロバイダの間のセッションを確立し、
ログインしたユーザの情報を保存します。
それ以降、同一ユーザからのリクエストでは (別の OpenID
対応ウェブサイトからのものであったとしても) 認証処理が不要となります。

.. note::

   このセッションは、エンドユーザと識別プロバイダの間だけのものであることに注意しましょう。
   OpenID 対応のサイトは、このセッションについて何も知ることができません。

.. _zend.openid.provider.example-3:

.. rubric:: シンプルなログイン画面

.. code-block:: php
   :linenos:

   <?php
   $server = new Zend_OpenId_Provider();

   if ($_SERVER['REQUEST_METHOD'] == 'POST' &&
       isset($_POST['openid_action']) &&
       $_POST['openid_action'] === 'login' &&
       isset($_POST['openid_identifier']) &&
       isset($_POST['openid_password'])) {
       $server->login($_POST['openid_identifier'],
                      $_POST['openid_password']);
       Zend_OpenId::redirect("example-8.php", $_GET);
   }
   ?>
   <html>
   <body>
   <form method="post">
   <fieldset>
   <legend>OpenID ログイン</legend>
   <table border=0>
   <tr>
   <td>Name:</td>
   <td>
   <input type="text"
          name="openid_identifier"
          value="<?php echo htmlspecialchars($_GET['openid_identity']);?>">
   </td>
   </tr>
   <tr>
   <td>Password:</td>
   <td>
   <input type="text"
          name="openid_password"
          value="">
   </td>
   </tr>
   <tr>
   <td> </td>
   <td>
   <input type="submit"
          name="openid_action"
          value="login">
   </td>
   </tr>
   </table>
   </fieldset>
   </form>
   </body>
   </html>

ユーザがログインしているというだけでは、認証が成功したとは言い切れません。
個々の OpenID 対応サイトについて、
それを信頼するかどうかをユーザが決めることができます。
次の信頼画面は、エンドユーザにそれを選択させるものです。
この選択は、現在のリクエストのみ行うか、あるいは "永久に"
行うかのいずれかとなります。 後者の場合は、信頼するサイト/しないサイト
の情報が内部データベースに保存され、
このサイトからの次回以降の認証リクエストは自動的に処理されるようになります。

.. _zend.openid.provider.example-4:

.. rubric:: シンプルな信頼画面

.. code-block:: php
   :linenos:

   <?php
   $server = new Zend_OpenId_Provider();

   if ($_SERVER['REQUEST_METHOD'] == 'POST' &&
       isset($_POST['openid_action']) &&
       $_POST['openid_action'] === 'trust') {

       if (isset($_POST['allow'])) {
           if (isset($_POST['forever'])) {
               $server->allowSite($server->getSiteRoot($_GET));
           }
           $server->respondToConsumer($_GET);
       } else if (isset($_POST['deny'])) {
           if (isset($_POST['forever'])) {
               $server->denySite($server->getSiteRoot($_GET));
           }
           Zend_OpenId::redirect($_GET['openid_return_to'],
                                 array('openid.mode'=>'cancel'));
       }
   }
   ?>
   <html>
   <body>
   <p>
   <a href="<?php echo htmlspecialchars($server->getSiteRoot($_GET));?>">
   <?php echo htmlspecialchars($server->getSiteRoot($_GET));?>
   </a>
   というサイトが、あなたの識別 URL
   <a href="<?php echo htmlspecialchars($server->getLoggedInUser());?>">
   <?php echo htmlspecialchars($server->getLoggedInUser());?>
   </a>
   の確認を求めてきました。
   </p>
   <form method="post">
   <input type="checkbox" name="forever">
   <label for="forever">永久に</label><br>
   <input type="hidden" name="openid_action" value="trust">
   <input type="submit" name="allow" value="許可する">
   <input type="submit" name="deny" value="拒否する">
   </form>
   </body>
   </html>

実際に運用されている OpenID サーバは、通常は Simple Registration Extension
に対応しています。 これを使用すると、ユーザについての情報を
コンシューマがプロバイダに問い合わせることが可能となります。
この場合、信頼済みのページではユーザの情報を取得できるようになります。

.. _zend.openid.provider.all:

すべてを組み合わせる
----------

プロバイダのすべての関数をひとつのスクリプトにまとめることもできます。
この場合はログイン *URL* と信頼済み *URL* は省略され、 ``Zend_OpenId_Provider``
は同一ページに GET 引数 "openid.action" を追加した場所を指すことになります。

.. note::

   次の例は完全なものではありません。 エンドユーザ向けの GUI
   を提供していませんが、 ログインと信頼処理を自動的に行います。
   これはサンプルをできるだけシンプルにするための処置であり、
   実際のサーバでは、先ほどのサンプルのようなコードも必要となります。

.. _zend.openid.provider.example-5:

.. rubric:: すべてをまとめたもの

.. code-block:: php
   :linenos:

   $server = new Zend_OpenId_Provider();

   define("TEST_ID", Zend_OpenId::absoluteURL("example-9-id.php"));
   define("TEST_PASSWORD", "123");

   if ($_SERVER['REQUEST_METHOD'] == 'GET' &&
       isset($_GET['openid_action']) &&
       $_GET['openid_action'] === 'login') {
       $server->login(TEST_ID, TEST_PASSWORD);
       unset($_GET['openid_action']);
       Zend_OpenId::redirect(Zend_OpenId::selfUrl(), $_GET);
   } else if ($_SERVER['REQUEST_METHOD'] == 'GET' &&
       isset($_GET['openid_action']) &&
       $_GET['openid_action'] === 'trust') {
       unset($_GET['openid_action']);
       $server->respondToConsumer($_GET);
   } else {
       $ret = $server->handle();
       if (is_string($ret)) {
           echo $ret;
       } else if ($ret !== true) {
           header('HTTP/1.0 403 Forbidden');
           echo 'Forbidden';
       }
   }

この例を先ほどの複数ページ分割版と比べてみると、
振り分け処理のコード以外の違いは一か所だけであることに気づかれることでしょう。
そう。 ``unset($_GET['openid_action'])`` の部分です。 この *unset*
は、次のリクエストをメインハンドラにまわすために必要となります。

.. _zend.openid.provider.sreg:

Simple Registration Extension
-----------------------------

次に示す識別子ページには、またもやおまじないが組み込まれています。
ここでは新たなユーザアカウントの作成を行い、それをプロファイル
(ニックネームとパスワード) と関連付けています。
実際の環境ではこのような処理は不要です。エンドユーザは OpenID
サーバ上でこれらの情報を登録するからです。 しかし、これらの登録用の GUI
の実装についてはこのマニュアルでは取り上げません。

.. _zend.openid.provider.example-6:

.. rubric:: プロファイルを関連付けた識別子

.. code-block:: php
   :linenos:

   <?php
   define("TEST_SERVER", Zend_OpenId::absoluteURL("example-10.php"));
   define("TEST_ID", Zend_OpenId::selfURL());
   define("TEST_PASSWORD", "123");
   $server = new Zend_OpenId_Provider();
   if (!$server->hasUser(TEST_ID)) {
       $server->register(TEST_ID, TEST_PASSWORD);
       $server->login(TEST_ID, TEST_PASSWORD);
       $sreg = new Zend_OpenId_Extension_Sreg(array(
           'nickname' =>'test',
           'email' => 'test@test.com'
       ));
       $root = Zend_OpenId::absoluteURL(".");
       Zend_OpenId::normalizeUrl($root);
       $server->allowSite($root, $sreg);
       $server->logout();
   }
   ?>
   <html>
   <head>
   <link rel="openid.server" href="<?php echo TEST_SERVER;?>" />
   </head>
   <body>
   <?php echo TEST_ID;?>
   </body>
   </html>

この識別子を OpenID 対応のサイト (ここでは、先ほどの章の Simple Registration Extension
のサンプルを使用します) に渡し、そのサイトは次の OpenID
サーバスクリプトを使用します。

これは、先ほどの "すべてを組み合わせる" 例を少し変更したものです。
自動ログインの仕組みは同様に使用していますが、
信頼済みページに関する情報は含んでいません。
ユーザは既に、このサンプルのスクリプトを "永久に" 信頼しています。
これを行っているのは、識別子スクリプトの ``Zend_OpenId_Provider::alowSite``
メソッドです。 同じメソッドでプロファイルと信頼済み *URL* を関連付け、 信頼済み
*URL* からリクエストがあった場合にこのプロファイルが自動的に返されます。

Simple Registration Extension を動作させるために唯一必要なのは、 ``Zend_OpenId_Extension_Sreg``
のオブジェクトを ``Zend_OpenId_Provider::handle`` の 2 番目の引数として渡すことです。

.. _zend.openid.provider.example-7:

.. rubric:: SREG を使用したプロバイダ

.. code-block:: php
   :linenos:

   $server = new Zend_OpenId_Provider();
   $sreg = new Zend_OpenId_Extension_Sreg();

   define("TEST_ID", Zend_OpenId::absoluteURL("example-10-id.php"));
   define("TEST_PASSWORD", "123");

   if ($_SERVER['REQUEST_METHOD'] == 'GET' &&
       isset($_GET['openid_action']) &&
       $_GET['openid_action'] === 'login') {
       $server->login(TEST_ID, TEST_PASSWORD);
       unset($_GET['openid_action']);
       Zend_OpenId::redirect(Zend_OpenId::selfUrl(), $_GET);
   } else if ($_SERVER['REQUEST_METHOD'] == 'GET' &&
       isset($_GET['openid_action']) &&
       $_GET['openid_action'] === 'trust') {
      echo "信頼されていないデータ" ;
   } else {
       $ret = $server->handle(null, $sreg);
       if (is_string($ret)) {
           echo $ret;
       } else if ($ret !== true) {
           header('HTTP/1.0 403 Forbidden');
           echo 'Forbidden';
       }
   }

.. _zend.openid.provider.else:

それ以外には?
-------

OpenID サーバの作成は、 OpenID
対応のサイトの作成ほど頻繁に行うものではありません。 そこで、
``Zend_OpenId_Consumer`` のマニュアルとは異なり ``Zend_OpenId_Provider``
のマニュアルではすべての機能を網羅することをやめます。

残っている機能について簡単にまとめると、次のようになります。

- エンドユーザ向けの GUI インターフェイスを作成するためのメソッド群。
  ユーザの登録、信頼済みサイトやプロファイルの設定などを行えるようにします。

- ユーザやサイト、プロファイルといった情報を格納するための抽象化された保存レイヤ。
  ここには、プロバイダと OpenID 対応サイトとの関連付け情報も保存します。
  このレイヤは ``Zend_OpenId_Consumer`` のものと非常によく似ています。
  デフォルトではファイルストレージを使用しますが、
  別の実装で置き換えることも可能です。

- エンドユーザのウェブブラウザとログイン識別子を関連付けるための、
  ユーザ関連付けの抽象化レイヤ。

``Zend_OpenId_Provider`` は、 OpenID
サーバが実装できる全機能をサポートしているわけではありません
(たとえばデジタル証明書など)。しかし、 ``Zend_OpenId_Extension``
を使用したり子クラスを作成したりして、 簡単に拡張することが可能です。



.. _`www.myopenid.com`: http://www.myopenid.com
