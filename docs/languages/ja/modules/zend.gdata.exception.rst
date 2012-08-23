.. EN-Revision: none
.. _zend.gdata.exception:

Gdata の例外処理
===========

``Zend_Gdata_App_Exception`` は、 ``Zend_Gdata`` がスローする例外の基底クラスです。 *Zedn_Gdata*
がスローする例外は、すべて ``Zend_Gdata_App_Exception`` でキャッチできます。

.. code-block:: php
   :linenos:

   try {
       $client =
           Zend_Gdata_ClientLogin::getHttpClient($username, $password);
   } catch(Zend_Gdata_App_Exception $ex) {
       // 例外の内容をユーザに報告します
       die($ex->getMessage());
   }

``Zend_Gdata`` では、以下のような例外サブクラスを使用しています。



   - ``Zend_Gdata_App_AuthException``
     は、ユーザのアカウントの情報が無効であることを表します。

   - ``Zend_Gdata_App_BadMethodCallException``
     は、そのサービスがサポートしていないメソッドをコールしたことを表します。
     たとえば、CodeSearch サービスは ``post()`` をサポートしていません。

   - ``Zend_Gdata_App_HttpException`` は、 *HTTP* リクエストが失敗したことを表します。
     ``Zend_Http_Response`` オブジェクトの中身を調べることで、
     実際の原因がわかります。この場合は ``$e->getMessage()``
     の情報だけでは不十分です。

   - ``Zend_Gdata_App_InvalidArgumentException``
     は、その状況では無効な値を指定したことを表します。
     たとえば、カレンダーの可視性に "banana" を指定したり、blog の名前を省略して
     Blogger のフィードを取得したりといった場合です。

   - ``Zend_Gdata_App_CaptchaRequiredException`` は、ClientLogin を試みた際に認証サービスから
     CAPTCHA(tm) チャレンジを受け取った場合にスローされます。
     この例外の中には、トークン ID および CAPTCHA(tm) チャレンジ画像への *URL*
     が含まれています。この画像はパズルのようなもので、
     これをユーザに対して表示させる必要があります。
     チャレンジ画像に対するユーザからの応答を受け取ったら、 それを用いて再度
     ClientLogin を試みることができます。 あるいは、ユーザが直接
     `https://www.google.com/accounts/DisplayUnlockCaptcha`_
     を使用することもできます。詳細な情報は :ref:`ClientLogin のドキュメント
     <zend.gdata.clientlogin>` を参照ください。



これらの例外サブクラスを使用すると、より細やかな例外処理を行なえます。 どの
``Zend_Gdata`` のメソッドがどんな例外サブクラスをスローするのかについては、 *API*
ドキュメントを参照ください。

.. code-block:: php
   :linenos:

   try {
       $client = Zend_Gdata_ClientLogin::getHttpClient($username,
                                                       $password,
                                                       $service);
   } catch(Zend_Gdata_App_AuthException $authEx) {
       // ユーザの認証に失敗しました
       // もう一度認証を行うなどの処置が適切でしょう
       ...
   } catch(Zend_Gdata_App_HttpException $httpEx) {
       // Google Data のサーバに接続できませんでした
       die($httpEx->getMessage);}



.. _`https://www.google.com/accounts/DisplayUnlockCaptcha`: https://www.google.com/accounts/DisplayUnlockCaptcha
