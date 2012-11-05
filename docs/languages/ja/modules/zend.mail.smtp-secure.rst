.. EN-Revision: none
.. _zend.mail.smtp-secure:

セキュアな SMTP トランスポート
==================

``Zend_Mail`` は、TLS や *SSL* を使用したセキュアな SMTP
接続もサポートしています。これを有効にするには、 ``Zend\Mail_Transport\Smtp``
のコンストラクタに渡す設定配列で、 パラメータ 'ssl' を指定します。値は 'ssl'
あるいは 'tls' となります。
オプションでポートを指定することもできます。省略した場合のデフォルトは TLS
の場合は 25、 *SSL* の場合は 465 となります。

.. _zend.mail.smtp-secure.example-1:

.. rubric:: Zend\Mail_Transport\Smtp によるセキュアな接続の有効化

.. code-block:: php
   :linenos:

   $config = array('ssl' => 'tls',
                   'port' => 25); // オプションでポート番号を指定します

   $transport = new Zend\Mail_Transport\Smtp('mail.server.com', $config);

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('sender@test.com', 'Some Sender');
   $mail->addTo('recipient@test.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send($transport);


