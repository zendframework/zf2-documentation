.. EN-Revision: none
.. _zend.mail.smtp-authentication:

SMTP 認証
=======

``Zend_Mail`` は SMTP 認証の使用をサポートしています。 これを使用するには、
``Zend\Mail_Transport\Smtp`` のコンストラクタに渡す設定配列で、パラメータ 'auth'
を指定します。 組み込みの認証方式は PLAIN、LOGIN および CRAM-MD5 で、
これらはすべて、設定配列に 'username' および 'password'
が指定されていることを想定しています。

.. _zend.mail.smtp-authentication.example-1:

.. rubric:: Zend\Mail_Transport\Smtp での認証の有効化

.. code-block:: php
   :linenos:

   $config = array('auth' => 'login',
                   'username' => 'myusername',
                   'password' => 'password');

   $transport = new Zend\Mail_Transport\Smtp('mail.server.com', $config);

   $mail = new Zend\Mail\Mail();
   $mail->setBodyText('This is the text of the mail.');
   $mail->setFrom('sender@test.com', 'Some Sender');
   $mail->addTo('recipient@test.com', 'Some Recipient');
   $mail->setSubject('TestSubject');
   $mail->send($transport);

.. note::

   **認証方式**

   認証方式は大文字小文字を区別しませんが、区切り文字は含めません。 たとえば
   CRAM-MD5 を使用する場合は、 ``Zend\Mail_Transport\Smtp`` のコンストラクタに渡す値は 'auth'
   => 'crammd5' となります。


