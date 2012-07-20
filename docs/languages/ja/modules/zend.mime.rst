.. _zend.mime.mime:

Zend_Mime
=========

.. _zend.mime.mime.introduction:

導入
--

``Zend_Mime`` は、マルチパート *MIME* メッセージを処理するためのサポートクラスです。
:ref:`Zend_Mail <zend.mail>` や :ref:`Zend_Mime_Message <zend.mime.message>`\ 、 そして *MIME*
サポートを必要とするその他のアプリケーションから使用されます。

.. _zend.mime.mime.static:

静的メソッドおよび定数
-----------

``Zend_Mime`` は、 *MIME*
を処理するための以下のような静的ヘルパーメソッドを提供しています。



   - ``Zend_Mime::isPrintable()``: 指定した文字列の中に表示できない文字がなければ ``TRUE``
     、 それ以外の場合に ``FALSE`` を返します。

   - ``Zend_Mime::encode()``: 指定されたエンコードで文字列を エンコードします。

   - ``Zend_Mime::encodeBase64()``: 文字列を base64 でエンコードします。

   - ``Zend_Mime::encodeQuotedPrintable()``: 文字列を quoted-printable でエンコードします。

   - ``Zend_Mime::encodeBase64Header()``: メールヘッダ用に文字列を base64
     でエンコードします。

   - ``Zend_Mime::encodeQuotedPrintableHeader()``: メールヘッダ用に文字列を quoted-printable
     でエンコードします。



``Zend_Mime`` では、 *MIME* メッセージでよく使われる定数を定義しています。



   - ``Zend_Mime::TYPE_OCTETSTREAM``: 'application/octet-stream'

   - ``Zend_Mime::TYPE_TEXT``: 'text/plain'

   - ``Zend_Mime::TYPE_HTML``: 'text/html'

   - ``Zend_Mime::ENCODING_7BIT``: '7bit'

   - ``Zend_Mime::ENCODING_8BIT``: '8bit'

   - ``Zend_Mime::ENCODING_QUOTEDPRINTABLE``: 'quoted-printable'

   - ``Zend_Mime::ENCODING_BASE64``: 'base64'

   - ``Zend_Mime::DISPOSITION_ATTACHMENT``: 'attachment'

   - ``Zend_Mime::DISPOSITION_INLINE``: 'inline'

   - ``Zend_Mime::MULTIPART_ALTERNATIVE``: 'multipart/alternative'

   - ``Zend_Mime::MULTIPART_MIXED``: 'multipart/mixed'

   - ``Zend_Mime::MULTIPART_RELATED``: 'multipart/related'



.. _zend.mime.mime.instatiation:

Zend_Mime インスタンスの作成
-------------------

``Zend_Mime`` オブジェクトのインスタンスを作成する際に、 *MIME*
バウンダリが作成されます。それ以降にこのオブジェクトの (静的でない)
メソッドがコールされるときには、このバウンダリが使用されます。
文字列パラメータを指定してコンストラクタがコールされた場合は、 その値が *MIME*
バウンダリとして使用されます。指定されなかった場合は、 ランダムな *MIME*
バウンダリがコンストラクタのコール時に生成されます。

``Zend_Mime`` オブジェクトには次のメソッドがあります。



   - ``boundary()``: *MIME* バウンダリ文字列を返します。

   - ``boundaryLine()``: 完全な *MIME* バウンダリ行を返します。

   - ``mimeEnd()``: 完全な *MIME* 最終バウンダリ行を返します。




