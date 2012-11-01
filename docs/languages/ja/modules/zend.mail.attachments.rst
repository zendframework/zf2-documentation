.. EN-Revision: none
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

   $mail = new Zend\Mail\Mail();
   // メッセージを作成します...
   $mail->createAttachment($someBinaryString);
   $mail->createAttachment($myImage,
                           'image/gif',
                           Zend\Mime\Mime::DISPOSITION_INLINE,
                           Zend\Mime\Mime::ENCODING_BASE64);

添付ファイル用の *MIME* パートを細かく制御するには、 ``createAttachment()``
の返す値を使用してその属性を変更します。 ``createAttachment()`` メソッドの返す値は
``Zend\Mime\Part`` オブジェクトです。

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Mail();

   $at = $mail->createAttachment($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend\Mime\Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend\Mime\Mime::ENCODING_BASE64;
   $at->filename    = 'test.gif';

   $mail->send();

もうひとつの方法は、 ``Zend\Mime\Part`` のインスタンスを作成して それを
``addAttachment()`` で追加するものです。

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Mail();

   $at = new Zend\Mime\Part($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend\Mime\Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend\Mime\Mime::ENCODING_BASE64;
   $at->filename    = 'test.gif';

   $mail->addAttachment($at);

   $mail->send();


