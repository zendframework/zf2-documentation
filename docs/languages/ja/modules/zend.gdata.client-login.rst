.. _zend.gdata.clientlogin:

ClientLogin による認証
=================

ClientLogin を使用すると、 *PHP* アプリケーションで Google Data
サービスへのアクセスのための認証ができるようになります。 ユーザの認証情報を、
*HTTP* クライアントに指定します。

Google Data ClientLogin 認証についての詳細は、
`http://code.google.com/apis/accounts/AuthForInstalledApps.html`_ を参照ください。

Google のドキュメントでは、ClientLogin 方式は "インストールするアプリケーション"
に適しており、一方 AuthSub は "ウェブアプリケーション"
に適しているとされています。 これらの違いは、AuthSub
はユーザとのやりとりが発生するということです。
ブラウザのインターフェイスを用いて、リクエストのリダイレクトを行います。
ClientLogin では *PHP* のコードでアカウント情報を提供します。
ユーザが直接認証情報を入力する必要がなくなります。

ClientLogin で使用する認証情報は、Google
サービスの正当な認証情報でなければなりません。 しかし、それは *PHP*
アプリケーションを使用するユーザ自身のものである必要はありません。

.. _zend.gdata.clientlogin.login:

ClientLogin 認証済みの Http クライアントの作成
--------------------------------

ClientLogin を使用した認証済みの *HTTP* クライアントを作成するには、 静的関数
``Zend_Gdata_ClientLogin::getHttpClient()`` をコールし、Google
アカウントの認証情報をプレーンテキストで渡します。 この関数の返り値は、
``Zend_Http_Client`` クラスのオブジェクトとなります。

オプションの三番目のパラメータには、Google Data
サービスの名前が指定できます。たとえば、'cl' は Google Calendar
を表します。デフォルトは 'xapi' で、 これは Google Data
サーバの汎用的なサービス名を表します。

オプションの四番目のパラメータには ``Zend_Http_Client``
のインスタンスを指定できます。これによって、
たとえばプロキシサーバなどのクライアント設定を行うことができます。
このパラメータに ``NULL`` を渡すと、 汎用的な ``Zend_Http_Client``
オブジェクトが作成されます。

オプションの五番目のパラメータには、Google Data
サーバがクライアントアプリケーションを識別するための短い文字列
(これはログ記録の際に使用します) を指定できます。 デフォルトでは、これは
"Zend-ZendFramework" となります。

オプションの六番目のパラメータには、サーバが発行する CAPTCHA(tm)
チャレンジ用の文字列 ID を設定します。
これが必要となるのは、一度ログインを試みた際にサーバから CAPTCHA(tm)
チャレンジを受け取った後の再ログイン時のみです。

オプションの七番目のパラメータには、サーバが発行する CAPTCHA(tm)
チャレンジに対するユーザからの応答を設定します。
これが必要となるのは、一度ログインを試みた際にサーバから CAPTCHA(tm)
チャレンジを受け取った後の再ログイン時のみです。

以下の例は、 *PHP* のウェブアプリケーションのコードです。 Google Calendar
サービスに対する認証を行い、 認証済みの ``Zend_Http_Client`` を使用して ``Zend_Gdata``
クライアントオブジェクトを作成します。

.. code-block:: php
   :linenos:

   // Google アカウントの情報を指定します
   $email = 'johndoe@gmail.com';
   $passwd = 'xxxxxxxx';
   try {
      $client = Zend_Gdata_ClientLogin::getHttpClient($email, $passwd, 'cl');
   } catch (Zend_Gdata_App_CaptchaRequiredException $cre) {
       echo 'CAPTCHA 画像の URL: ' . $cre->getCaptchaUrl() . "\n";
       echo 'トークン ID: ' . $cre->getCaptchaToken() . "\n";
   } catch (Zend_Gdata_App_AuthException $ae) {
      echo '認証に失敗: ' . $ae->exception() . "\n";
   }

   $cal = new Zend_Gdata_Calendar($client);

.. _zend.gdata.clientlogin.terminating:

Http クライアントの ClientLogin 認証の解除
------------------------------

ClientLogin 認証を解除する方法はありません。というのは、これは AuthSub
のようにトークンを使用した認証ではないからです。 ClientLogin 認証に使用する情報は
Google アカウントのユーザ名とパスワードであり、
これらは将来も繰り返し使用できます。



.. _`http://code.google.com/apis/accounts/AuthForInstalledApps.html`: http://code.google.com/apis/accounts/AuthForInstalledApps.html
