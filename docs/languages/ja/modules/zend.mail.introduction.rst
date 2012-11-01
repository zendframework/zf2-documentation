.. EN-Revision: none
.. _zend.mail.introduction:

導入
==

.. _zend.mail.introduction.getting-started:

まずはじめに
------

``Zend_Mail`` は、テキストメールや *MIME*
マルチパートメールを作成・送信するための一般的な機能を提供します。 ``Zend_Mail``
を使用すると、デフォルトの ``Zend\Mail_Transport\Sendmail`` か、あるいは
``Zend\Mail_Transport\Smtp`` を使用してメールを送信できます。

.. _zend.mail.introduction.example-1:

.. rubric:: Zend_Mail を使用したシンプルなメール送信

受信者、表題、本文および送信者を指定しただけの単純なメールです。
このようなメールを ``Zend\Mail_Transport\Sendmail``
を用いて送信するには、次のようにします。

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('somebody@example.com', 'Some Sender');
   $mail->addTo('somebody_else@example.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send();

.. note::

   **最低限の定義**

   ``Zend_Mail`` でメールを送信するには、 最低 1 か所以上の受信者、送信者 (``setFrom()``
   を使用します)、 そして本文 (テキストや *HTML*) を指定しなければなりません。

大半の属性については、その情報を読み込むための "get"
メソッドが用意されています。詳細は、 *API* ドキュメントを参照ください。
``getRecipients()`` だけは特別で、
これまでに追加されたすべての受信者アドレスを配列で返します。

セキュリティの観点から、 ``Zend_Mail`` はすべてのヘッダフィールドの改行文字 (*\n*)
を取り除きます。 これにより、ヘッダインジェクションを防ぎます。
送信者名およびあて先名中の２重引用符は単一引用符に、山括弧は角括弧に変更されます。
もしその記号がメールアドレス中にある場合は除去されます。

``Zend_Mail`` オブジェクトのほとんどのメソッドは、
流れるようなインターフェイス形式でコールすることもできます。

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('This is the text of the mail.')
       ->setFrom('somebody@example.com', 'Some Sender')
       ->addTo('somebody_else@example.com', 'Some Recipient')
       ->setSubject('TestSubject')
       ->send();

.. _zend.mail.introduction.sendmail:

デフォルトの sendmail トランスポートの設定
--------------------------

``Zend_Mail`` がデフォルトで使用するのは ``Zend\Mail_Transport\Sendmail`` です。これは、単に
*PHP* の `mail()`_ 関数をラップしただけのものです。 `mail()`_
関数に追加のパラメータを渡したい場合は、
新しいインスタンスを作成する際のコンストラクタにパラメータを渡します。
新しく作成したインスタンスは、 ``Zend_Mail``
のデフォルトのトランスポートとすることができます。 あるいは ``Zend_Mail`` の
``send()`` メソッドに渡すこともできます。

.. _zend.mail.introduction.sendmail.example-1:

.. rubric:: Zend\Mail_Transport\Sendmail トランスポートへの追加パラメータの渡し方

この例は、 `mail()`_ 関数の Return-Path を変更する方法を示すものです。

.. code-block:: php
   :linenos:

   $tr = new Zend\Mail_Transport\Sendmail('-freturn_to_me@example.com');
   Zend\Mail\Mail::setDefaultTransport($tr);

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('somebody@example.com', 'Some Sender');
   $mail->addTo('somebody_else@example.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send();

.. note::

   **セーフモード時の制限**

   *PHP*
   をセーフモードで実行している場合、オプションの追加パラメータを指定すると
   `mail()`_ 関数の実行に失敗する可能性があります。

.. warning::

   **Sendmail トランスポートと Windows**

   *PHP* マニュアルでは、 ``mail()``\ 関数は Windows と \*nix ベースのシステムとでは、
   異なる振る舞いをすると述べています。 Windows で Sendmail
   トランスポートを利用すると、 ``addBcc()`` との連携は動作しません。
   他のすべての受信者が、受信者として彼を見られるように、 ``mail()`` 関数は BCC
   受信者に送ります。

   そのため、もし Windows サーバで BCC を使いたいなら、 SMTP
   トランスポートを送信に使ってください。



.. _`mail()`: http://php.net/mail
