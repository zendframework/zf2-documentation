.. _zend.auth.adapter.openid:

Open ID 認証
==========

.. _zend.auth.adapter.openid.introduction:

導入
--

``Zend_Auth_Adapter_OpenId`` は、リモートの OpenID サーバを使用したユーザ認証を行います。
この認証方式では、ユーザがウェブアプリケーションに対して送信するのは OpenID
の識別子のみとなります。その識別子は OpenID
プロバイダにリダイレクトされ、そこでパスワードなどを用いて識別子の所有者情報を確認します。
ここで入力したパスワードは、ウェブアプリケーション側には知られることはありません。

OpenID の識別子は単なる *URI* で、
指し示す先のウェブページにはそのユーザに関する情報や特別なタグが含まれます。
タグに記述されているのは、どのサーバに対してどの情報を送信するのかという情報です。
OpenID についての詳細は `OpenID の公式サイト`_ を参照ください。

``Zend_Auth_Adapter_OpenId`` クラスは ``Zend_OpenId_Consumer`` コンポーネントのラッパーで、
OpenID の認証プロトコルを実装しています。

.. note::

   ``Zend_OpenId`` は、 `GMP 拡張モジュール`_ が使用可能な場合はそれを使用します。
   ``Zend_Auth_Adapter_OpenId`` を使う場合は、 *GMP*
   拡張モジュールを有効にしておくとよりよいパフォーマンスが得られるでしょう。

.. _zend.auth.adapter.openid.specifics:

仕様
--

他の ``Zend_Auth`` アダプタ同様、 ``Zend_Auth_Adapter_OpenId`` クラスは
``Zend_Auth_Adapter_Interface`` を実装しています。
このインターフェイスで定義されているメソッドは ``authenticate()`` です。
このメソッドは認証そのものを行います。
このメソッドをコールする前にオブジェクトを準備しておく必要があります。
「準備」とは、OpenID の識別子を設定したりその他の ``Zend_OpenId``
固有のオプションを設定したりということです。

しかし、他の ``Zend_Auth`` アダプタとは異なり、
このアダプタは認証処理を外部のサーバで行います。 また認証は二段階の *HTTP*
リクエストで行います。 したがって、 ``Zend_Auth_Adapter_OpenId::authenticate()``
を二度コールする必要があります。
一度目のコールでは、このメソッドは何も返さずに OpenID
サーバにリダイレクトします。
認証が終わってリダイレクト先から戻ってきたら、もう一度
``Zend_Auth_Adapter_OpenId::authenticate()``
をコールしてサーバから戻されたリクエストのシグネチャを検証し、
認証手続きを進めます。このときは、このメソッドは ``Zend_Auth_Result``
オブジェクトを返します。

次の例は、 ``Zend_Auth_Adapter_OpenId`` の使用方法を示すものです。
先ほど説明したように、 ``Zend_Auth_Adapter_OpenId::authenticate()`` が 2
回コールされています。一度目、つまり *HTML* フォームから送信されたときは
``$_POST['openid_action']`` が **"login"** となっており、二度目、つまり OpenID サーバから
*HTTP* リダイレクトで戻ってきたときは ``$_GET['openid_mode']`` あるいは *$_POST['openid_mode']*
が設定されています。

.. code-block:: php
   :linenos:

   <?php
   $status = "";
   $auth = Zend_Auth::getInstance();
   if ((isset($_POST['openid_action']) &&
        $_POST['openid_action'] == "login" &&
        !empty($_POST['openid_identifier'])) ||
       isset($_GET['openid_mode']) ||
       isset($_POST['openid_mode'])) {
       $result = $auth->authenticate(
           new Zend_Auth_Adapter_OpenId(@$_POST['openid_identifier']));
       if ($result->isValid()) {
           $status = "You are logged in as "
                   . $auth->getIdentity()
                   . "<br>\n";
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
           $status = "You are logged in as "
                   . $auth->getIdentity()
                   . "<br>\n";
       }
   }
   ?>
   <html><body>
   <?php echo htmlspecialchars($status);?>
   <form method="post"><fieldset>
   <legend>OpenID Login</legend>
   <input type="text" name="openid_identifier" value="">
   <input type="submit" name="openid_action" value="login">
   <input type="submit" name="openid_action" value="logout">
   </fieldset></form></body></html>
   */

OpenID 認証手続きをカスタマイズして、 OpenID
サーバからリダイレクトで戻ってくる先を別のページ (そのウェブサイトの "ルート"
ページなど) にすることもできます。 この場合は、独自の ``Zend_OpenId_Consumer_Storage``
あるいは ``Zend_Controller_Response`` を使用します。 また、Simple Registration Extension
を使用して OpenID サーバからユーザ情報を取得することも可能です。
これらについての詳細は ``Zend_OpenId_Consumer`` のマニュアルを参照ください。



.. _`OpenID の公式サイト`: http://www.openid.net/
.. _`GMP 拡張モジュール`: http://php.net/gmp
