.. EN-Revision: none
.. _zend.mail.additional-headers:

追加のヘッダ
======

``Zend_Mail`` は追加のメールヘッダを設定するためのメソッドをいくつか提供します。



   - ``setReplyTo($email, $name=null)``: Reply-To: ヘッダを設定します。

   - ``setDate($date = null)``: Date: ヘッダを設定します。
     既定ではこのメソッドは現在のタイムスタンプを使用します。
     または、このメソッドにタイムスタンプ、日付文字列または ``Zend_Date``
     インスタンスを渡せます。

   - ``setMessageId($id = true)``: Message-Id: ヘッダを設定します。
     既定ではこのメソッドは自動的にメッセージ ID を生成できます。
     または、このメソッドにメッセージ ID 文字列を渡せます。
     このメソッドは内部的に ``createMessageId()`` を呼び出します。



.. note::

   **Return-Path**

   もしメールに Return-Path を設定する場合は、 :ref:`sendmail トランスポートの設定
   <zend.mail.introduction.sendmail>`\ をご覧ください。 残念ながら、 ``setReturnPath($email)``
   メソッドはこの目的を果たしません。

さらに、 ``addHeader()`` メソッドを使用して、
任意のヘッダを指定できます。ヘッダフィールドの名前、 そして設定する値の 2
つのパラメータが必須となります。 3
番目のパラメータはオプションで、ヘッダが複数の値をとるかどうかを指定します。

.. _zend.mail.additional-headers.example-1:

.. rubric:: メールヘッダの追加

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->addHeader('X-MailGenerator', 'MyCoolApplication');
   $mail->addHeader('X-greetingsTo', 'Mom', true); // 複数の値
   $mail->addHeader('X-greetingsTo', 'Dad', true);


