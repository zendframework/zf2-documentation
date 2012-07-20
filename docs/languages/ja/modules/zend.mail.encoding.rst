.. _zend.mail.encoding:

エンコーディング
========

テキストおよび HTML メッセージの本文は、デフォルトでは quotedprintable
方式でエンコードされます。 メッセージヘッダーもbase64を ``setHeaderEncoding()``
で指定しなければ quotedprintable 方式でエンコードされます。
もしあなたがラテン文字ベースではない言語を使う場合、 base64
がより適切でしょう。 その他の添付ファイルは、デフォルトでは base64
でエンコードされますが、 ``addAttachment()`` のコール時に変更したり *MIME*
パートオブジェクトに後から代入して変更することもできます。 7Bit
エンコーディングおよび 8Bit エンコーディングは、
現在はバイナリデータにのみ適用可能です。

ヘッダ、特に subject のエンコーディングは、油断のならない話題です。 ``Zend_Mime``
は現在、quoted printable ヘッダを RFC-2045
にもとづいてエンコードするアルゴリズムを自前で実装しています。 *iconv_mime_encode*
および *mb_encode_mimeheader* には、特定の文字セットにおける問題があるからです。
このアルゴリズムではヘッダを空白文字でのみ区切るので、 推奨される長さである 76
文字を超えるヘッダができてしまう可能性があります。
そんな場合は、次の例と同様にヘッダのエンコード方式を BASE64 に変更しましょう。

.. code-block:: php
   :linenos:

   // デフォルトは Zend_Mime::ENCODING_QUOTEDPRINTABLE です
   $mail = new Zend_Mail('KOI8-R');

   // KOI8-R で表現されるロシア語はラテン文字ベースの言語と
   // 大きく異なるので、Base64 エンコーディングに変更します
   $mail->setHeaderEncoding(Zend_Mime::ENCODING_BASE64);

``Zend_Mail_Transport_Smtp`` は、行頭がドット 1 文字あるいはドット 2
文字の場合にその行をエンコードします。これにより、 SMTP
プロトコルに違反するメールを作成しないようにします。


