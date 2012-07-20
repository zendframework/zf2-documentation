.. _zend.gdata.authsub:

AuthSub による認証
=============

AuthSub を使用すると、ウェブアプリケーションで Google Data
サービスへのアクセスのための認証ができるようになります。
ユーザの認証情報を処理するコードを自分で書く必要はありません。

Google Data AuthSub 認証についての詳細は、 `http://code.google.com/apis/accounts/AuthForWebApps.html`_
を参照ください。

Google のドキュメントでは、ClientLogin 方式は "インストールするアプリケーション"
に適しており、一方 AuthSub は "ウェブアプリケーション"
に適しているとされています。 これらの違いは、AuthSub
はユーザとのやりとりが発生するということです。
ブラウザのインターフェイスを用いて、リクエストのリダイレクトを行います。
ClientLogin では *PHP* のコードでアカウント情報を提供します。
ユーザが直接認証情報を入力する必要がなくなります。

AuthSub の場合の認証情報は、ウェブアプリケーションのユーザが入力します。
つまり、認証情報をユーザが知っておく必要があります。

.. note::

   **登録されたアプリケーション**

   ``Zend_Gdata`` は、現在はセキュアなトークンの使用をサポートしていません。
   なぜなら、デジタル証明書によるセキュアなトークンの取得を AuthSub
   認証がサポートしていないからです。

.. _zend.gdata.authsub.login:

AuthSub 認証済みの Http クライアントの作成
----------------------------

あなたの作成した *PHP* アプリケーションで、認証を行う Google *URL*
へのハイパーリンクを提供しなければなりません。そのためには 静的関数
``Zend_Gdata_AuthSub::getAuthSubTokenUri()``
を使用します。この関数の引数には、あなたの作成した *PHP* アプリケーションの *URL*
を指定します。それにより、ユーザ認証の後に Google
からもとの場所にリダイレクトされるようになります。

Google の認証サーバからアプリケーションに戻ってくる際に、 **token** という名前の GET
パラメータが設定されます。 このパラメータの値は、認証されたアクセスに使用する
single-use トークンとなります。 このトークンを multi-use
トークンに変換し、セッションに保存します。

そしてそのトークンの値は使用して ``Zend_Gdata_AuthSub::getHttpClient()``
をコールします。この関数は ``Zend_Http_Client``
のインスタンスを返します。このインスタンスには適切なヘッダが設定されており、
後でこの *HTTP*
クライアントを使用して送信したリクエストは認証済みのものとなります。

以下の例は、 *PHP* のウェブアプリケーションのコードです。 Google Calendar
サービスに対する認証を行い、 認証済みの *HTTP* クライアントを使用して ``Zend_Gdata``
クライアントオブジェクトを作成します。

.. code-block:: php
   :linenos:

   $my_calendar = 'http://www.google.com/calendar/feeds/default/private/full';

   if (!isset($_SESSION['cal_token'])) {
       if (isset($_GET['token'])) {
           // single-use トークンをセッショントークンに変換します
           $session_token =
               Zend_Gdata_AuthSub::getAuthSubSessionToken($_GET['token']);
           // セッショントークンをセッションに保存します
           $_SESSION['cal_token'] = $session_token;
       } else {
           // single-use トークンを生成するためのリンクを表示します
           $googleUri = Zend_Gdata_AuthSub::getAuthSubTokenUri(
               'http://'. $_SERVER['SERVER_NAME'] . $_SERVER['REQUEST_URI'],
               $my_calendar, 0, 1);
           echo "<a href='$googleUri'>ここ</a> " .
                "をクリックして認証を行います。";
           exit();
       }
   }

   // Google とやり取りするための、認証済み HTTP クライアントを作成します
   $client = Zend_Gdata_AuthSub::getHttpClient($_SESSION['cal_token']);

   // 認証済み Http クライアントを使用して Gdata オブジェクトを作成します
   $cal = new Zend_Gdata_Calendar($client);

.. _zend.gdata.authsub.logout:

AuthSub 認証の解除
-------------

指定したトークンによる認証状態を終わらせるには、静的関数
``Zend_Gdata_AuthSub::AuthSubRevokeToken()``
を使用します。そうしないと、このトークンはいつまでも有効なままになります。

.. code-block:: php
   :linenos:

   // アプリケーションのセキュリティ問題を避けるため、注意してこの値を作成します
   $php_self = htmlentities(substr($_SERVER['PHP_SELF'],
                            0,
                            strcspn($_SERVER['PHP_SELF'], "\n\r")),
                            ENT_QUOTES);

   if (isset($_GET['logout'])) {
       Zend_Gdata_AuthSub::AuthSubRevokeToken($_SESSION['cal_token']);
       unset($_SESSION['cal_token']);
       header('Location: ' . $php_self);
       exit();
   }

.. note::

   **セキュリティについて**

   上の例における ``$php_self`` の扱い方は、
   一般的なセキュリティ問題の対応法に従ったものです。 ``Zend_Gdata``
   に固有のものではありません。 *HTTP*
   ヘッダに出力する内容は、つねにフィルタリングするようにしましょう。

   認証トークンの解除については、ユーザが Google Data
   セッションを終わらせたときに行うのがお勧めです。
   だれかがトークンを盗んで悪用するという可能性は非常に小さいものです。
   とは言え、サービスの利用が終わったら認証も終了させておくことは大切です。



.. _`http://code.google.com/apis/accounts/AuthForWebApps.html`: http://code.google.com/apis/accounts/AuthForWebApps.html
