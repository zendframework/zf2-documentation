.. _zend.service.recaptcha:

Zend_Service_ReCaptcha
======================

.. _zend.service.recaptcha.introduction:

導入
--

``Zend_Service_ReCaptcha`` は `reCAPTCHA Web Service`_ 用のクライアントです。reCAPTCHA
のサイトによると、 "reCAPTCHA is a free CAPTCHA service that helps to digitize books (reCAPTCHA
はフリーな CAPTCHA サービスで、 書籍の電子化を支援しています)" とのことです。
reCAPTCHA は、ユーザにふたつの単語を入力させます。 ひとつは実際の CAPTCHA
で、もうひとつはスキャンされたテキスト (OCR ソフトウェアで認識できないもの)
の単語です。 ユーザが最初の単語を正しく入力したら、 おそらく 2
番目の単語も正しく入力してくれるものとみなせます。 その入力内容を使って、OCR
ソフトウェアの能力を向上させるわけです。

reCAPTCHA サービスを使用するには、 `アカウントのサインアップ`_
が必要です。また公開鍵と秘密鍵を作成するには、
サービスを使用するドメインを登録しなければなりません。

.. _zend.service.recaptcha.simplestuse:

単純な使用法
------

``Zend_Service_ReCaptcha`` オブジェクトのインスタンスを作成し、
公開鍵と秘密鍵を渡します。

.. _zend.service.recaptcha.example-1:

.. rubric:: reCAPTCHA サービスのインスタンスの作成

.. code-block:: php
   :linenos:

   $recaptcha = new Zend_Service_ReCaptcha($pubKey, $privKey);

reCAPTCHA をレンダリングするには、 ``getHTML()`` メソッドをコールするだけです。

.. _zend.service.recaptcha.example-2:

.. rubric:: reCAPTCHA の表示

.. code-block:: php
   :linenos:

   echo $recaptcha->getHTML();

フォームから送信されてきた内容のうち、 'recaptcha_challenge_field' と
'recaptcha_response_field' のふたつのフィールドの内容を受け取らなければなりません。
これらを、reCAPTCHA オブジェクトの ``verify()`` メソッドに渡します。

.. _zend.service.recaptcha.example-3:

.. rubric:: フォームフィールドの検証

.. code-block:: php
   :linenos:

   $result = $recaptcha->verify(
       $_POST['recaptcha_challenge_field'],
       $_POST['recaptcha_response_field']
   );

結果が得られたら、正しいものだったかどうかを確認します。結果は
``Zend_Service_ReCaptcha_Response`` オブジェクトとなり、 このオブジェクトは ``isValid()``
メソッドを提供しています。

.. _zend.service.recaptcha.example-4:

.. rubric:: reCAPTCHA の検証

.. code-block:: php
   :linenos:

   if (!$result->isValid()) {
       // 検証に失敗
   }

:ref:`reCAPTCHA <zend.captcha.adapters.recaptcha>` ``Zend_Captcha``
アダプタを使うか、そのアダプタを :ref:`CAPTCHA フォーム要素
<zend.form.standardElements.captcha>` のバックエンドとして使うことがもっと簡単です。
どちらの場合でも、reCAPTCHA のレンダリングや検証は自動化されます。

.. _zend.service.recaptcha.mailhide:

メールアドレスの隠蔽
----------

``Zend_Service_ReCaptcha_MailHide`` を使うと、
メールアドレスを隠蔽できます。メールアドレスの一部分を、 reCAPTCHA
チャレンジのポップアップウィンドウに置き換えます。
チャレンジを解決すると、完全なメールアドレスがあらわれるというわけです。

このコンポーネントを使うには、 mailhide *API*
用の公開キーと秘密キーを生成するための `アカウント`_ が必要です。

.. _zend.service.recaptcha.mailhide.example-1:

.. rubric:: mail hide コンポーネントの使用法

.. code-block:: php
   :linenos:

   // 隠したいメールアドレス
   $mail = 'mail@example.com';

   // mailhide コンポーネントのインスタンスを作成し、公開キーと秘密キー
   // そして隠したいメールアドレスを渡します
   $mailHide = new Zend_Service_ReCaptcha_Mailhide();
   $mailHide->setPublicKey($pubKey);
   $mailHide->setPrivateKey($privKey);
   $mailHide->setEmail($mail);

   // 表示します
   print($mailHide);

上の例の表示は "m...@example.com" のようになり、 "..." のリンクは reCAPTCHA
チャレンジのポップアップウィンドウを表示します。

公開キーと秘密キーそしてメールアドレスは、クラスのコンストラクタで指定することもできます。
4 番目の引数も存在し、ここでコンポーネントのオプションを設定できます。
使用できるオプションは次の表のとおりです。



      .. _zend.service.recaptcha.mailhide.options.table:

      .. table:: Zend_Service_ReCaptcha_MailHide のオプション

         +---------------+------------------------------------------------+---------------+----------------------------+
         |オプション          |説明                                              |期待する値          |デフォルト値                      |
         +===============+================================================+===============+============================+
         |linkTitle      |リンクの title 属性                                   |文字列            |'Reveal this e=mail address'|
         +---------------+------------------------------------------------+---------------+----------------------------+
         |linkHiddenText |ポップアップリンクを含める文字列                                |文字列            |'...'                       |
         +---------------+------------------------------------------------+---------------+----------------------------+
         |popupWidth     |ポップアップウィンドウの幅                                   |int            |500                         |
         +---------------+------------------------------------------------+---------------+----------------------------+
         |popupHeight    |ポップアップウィンドウの高さ                                  |int            |300                         |
         +---------------+------------------------------------------------+---------------+----------------------------+



オプションの設定は、コンストラクタの 4 番目の引数で指定する以外にも
``setOptions($options)`` メソッドで行うこともできます。
このメソッドには、連想配列あるいは :ref:`Zend_Config <zend.config>`
のインスタンスを渡します。

.. _zend.service.recaptcha.mailhide.example-2:

.. rubric:: 多数の隠しメールアドレスの作成

.. code-block:: php
   :linenos:

   // mailhide コンポーネントのインスタンスを作成し、公開キーと秘密キー
   // そして隠したいメールアドレスを渡します
   $mailHide = new Zend_Service_ReCaptcha_Mailhide();
   $mailHide->setPublicKey($pubKey);
   $mailHide->setPrivateKey($privKey);
   $mailHide->setOptions(array(
       'linkTitle' => 'Click me',
       'linkHiddenText' => '+++++',
   ));

   // 隠したいメールアドレス
   $mailAddresses = array(
       'mail@example.com',
       'johndoe@example.com',
       'janedoe@example.com',
   );

   foreach ($mailAddresses as $mail) {
       $mailHide->setEmail($mail);
       print($mailHide);
   }



.. _`reCAPTCHA Web Service`: http://recaptcha.net/
.. _`アカウントのサインアップ`: http://recaptcha.net/whyrecaptcha.html
.. _`アカウント`: http://recaptcha.net/whyrecaptcha.html
