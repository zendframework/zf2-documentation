.. EN-Revision: none
.. _zend.mail.multiple-emails:

SMTP 接続による複数のメールの送信
===================

デフォルトでは、ひとつの SMTP トランスポートが
ひとつの接続を作成し、スクリプトの実行中はそれを使いまわします。 この SMTP
接続で、複数のメールを送信できます。 SMTP のハンドシェイクを正しく行うには、
メッセージの配送の前に RSET コマンドを発行します。

任意で、既定の reply-to ヘッダだけではなく、既定の email アドレスと名前も
定義できます。これは静的メソッド ``setDefaultFrom()`` 及び ``setDefaultReplyTo()``
を介して行なわれます。 これらの既定値は、既定値がリセット（消去）されるまで、
From/Reply-to のアドレスや 名前を指定しない場合に使われます。 既定値は
``clearDefaultFrom()`` 及び ``clearDefaultReplyTo`` を使って消去されます。

.. _zend.mail.multiple-emails.example-1:

.. rubric:: SMTP 接続による複数のメールの送信

.. code-block:: php
   :linenos:

   // トランスポートを作成します
   $config = array('name' => 'sender.example.com');
   $transport = new Zend\Mail_Transport\Smtp('mail.example.com', $config);

   // 送信するメール全てで使う From 及び Reply-To のアドレス及び名前を設定します
   Zend\Mail\Mail::setDefaultFrom('sender@example.com', 'John Doe');
   Zend\Mail\Mail::setDefaultReplyTo('replyto@example.com','Jane Doe');

   // メッセージをループ処理します
   for ($i = 0; $i < 5; $i++) {
       $mail = new Zend\Mail\Mail();
       $mail->addTo('studio@example.com', 'Test');
       $mail->setSubject(
           'Demonstration - Sending Multiple Mails per SMTP Connection'
       );
       $mail->setBodyText('...Your message here...');
       $mail->send($transport);
   }

   // 既定値をリセットします
   Zend\Mail\Mail::clearDefaultFrom();
   Zend\Mail\Mail::clearDefaultReplyTo();

各配送ごとに別々の接続を使用したい場合は、 ``send()`` メソッドのコールの前後に
トランスポートの作成と廃棄をする必要があります。
あるいは、トランスポートのプロトコルオブジェクトを用いて
各配送の接続を操作することもできます。

.. _zend.mail.multiple-emails.example-2:

.. rubric:: トランスポートの接続の手動制御

.. code-block:: php
   :linenos:

   // トランスポートを作成します
   $transport = new Zend\Mail_Transport\Smtp();

   $protocol = new Zend\Mail_Protocol\Smtp('mail.example.com');
   $protocol->connect();
   $protocol->helo('sender.example.com');

   $transport->setConnection($protocol);

   // メッセージをループ処理します
   for ($i = 0; $i < 5; $i++) {
       $mail = new Zend\Mail\Mail();
       $mail->addTo('studio@example.com', 'Test');
       $mail->setFrom('studio@example.com', 'Test');
       $mail->setSubject(
           'Demonstration - Sending Multiple Mails per SMTP Connection'
       );
       $mail->setBodyText('...Your message here...');

       // 手動で接続を制御します
       $protocol->rset();
       $mail->send($transport);
   }

   $protocol->quit();
   $protocol->disconnect();


