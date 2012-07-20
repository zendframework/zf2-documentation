.. _zend.mail.attachments:

ファイルの添付
=======

メールにファイルを添付するには ``createAttachment()`` メソッドを使用します。
``Zend_Mail`` のデフォルト設定では、添付ファイルは base64
エンコードされたバイナリオブジェクト (``application/octet-stream``)
として添付されます。この挙動を変更するには、 ``createAttachment()``
に追加のパラメータを指定します。

.. _zend.mail.attachments.example-1:

.. rubric:: ファイルを添付したメール

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   // メッセージを作成します...
   $mail->createAttachment($someBinaryString);
   $mail->createAttachment($myImage,
                           'image/gif',
                           Zend_Mime::DISPOSITION_INLINE,
                           Zend_Mime::ENCODING_BASE64);

添付ファイル用の *MIME* パートを細かく制御するには、 ``createAttachment()``
の返す値を使用してその属性を変更します。 ``createAttachment()`` メソッドの返す値は
``Zend_Mime_Part`` オブジェクトです。

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();

   $at = $mail->createAttachment($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend_Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend_Mime::ENCODING_BASE64;
   $at->filename    = 'test.gif';

   $mail->send();

もうひとつの方法は、 ``Zend_Mime_Part`` のインスタンスを作成して それを
``addAttachment()`` で追加するものです。

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();

   $at = new Zend_Mime_Part($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend_Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend_Mime::ENCODING_BASE64;
   $at->filename    = 'test.gif';

   $mail->addAttachment($at);

   $mail->send();


