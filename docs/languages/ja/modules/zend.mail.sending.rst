.. _zend.mail.sending:

SMTP 経由での送信
===========

SMTP 経由でメールを送信するには、 ``send()`` をコールする前に ``Zend_Mail_Transport_Smtp``
を作成し、それを ``Zend_Mail`` に登録しなければなりません。スクリプト内でその後に
``Zend_Mail::send()`` がコールされると、 SMTP による転送が使用されます。

.. _zend.mail.sending.example-1:

.. rubric:: SMTP によるメールの送信

.. code-block:: php
   :linenos:

   $tr = new Zend_Mail_Transport_Smtp('mail.example.com');
   Zend_Mail::setDefaultTransport($tr);

``setDefaultTransport()`` メソッドや ``Zend_Mail_Transport_Smtp`` のコンストラクタは、
そんなに大げさなものではありません。この 2 行をスクリプトのセットアップ時
(config.inc など) に設定し、スクリプト内での ``Zend_Mail``
の挙動を決めることができます。 これにより、メール送信を SMTP 経由で行うのか
`mail()`_ を使用するのか、
そしてどのメールサーバを使用するのかなどといった設定情報を、
アプリケーションから分離できます。



.. _`mail()`: http://php.net/mail
