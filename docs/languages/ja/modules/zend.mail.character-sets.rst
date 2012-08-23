.. EN-Revision: none
.. _zend.mail.character-sets:

文字セット
=====

``Zend_Mail`` はメールの現在の文字セットをチェックしません。 ``Zend_Mail``
のインスタンスを作成する際に、メールの文字セットを指定します。 デフォルトは
*iso-8859-1* です。
メールに追加する内容は、すべて正しい文字セットでエンコードされている必要があります。
新しいメールパートを作成する際には、
個々のパートについて異なる文字セットを指定できます。

.. note::

   **テキスト形式限定**

   文字セットが適用されるのは、プレーンテキストのメッセージについてのみです。

.. _zend.mail.character-sets.cjk:

.. rubric:: CJK 言語での利用

下記の例は日本語での ``Zend_Mail`` の使い方です。 これは *CJK* (別名 *CJKV*)
言語のひとつです。 もしあなたが中国語を使うなら、 *ISO-2022-JP* の代わりに
*HZ-GB-2312* を使うでしょう。

.. code-block:: php
   :linenos:

   //PHP スクリプト上で文字列の文字エンコードが UTF-8 と仮定します。
   function myConvert($string) {
       return mb_convert_encoding($string, 'ISO-2022-JP', 'UTF-8');
   }

   $mail = new Zend_Mail('ISO-2022-JP');
   //この場合、 ISO-2022-JP は MSB を使わないので、
   // ENCODING_7BIT を使えます。
   $mail->setBodyText(
       myConvert('This is the text of the mail.'),
       null,
       Zend_Mime::ENCODING_7BIT
   );
   $mail->setHeaderEncoding(Zend_Mime::ENCODING_BASE64);
   $mail->setFrom('somebody@example.com', myConvert('Some Sender'));
   $mail->addTo('somebody_else@example.com', myConvert('Some Recipient'));
   $mail->setSubject(myConvert('TestSubject'));
   $mail->send();


