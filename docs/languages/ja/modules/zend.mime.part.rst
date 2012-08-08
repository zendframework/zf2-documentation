.. EN-Revision: none
.. _zend.mime.part:

Zend_Mime_Part
==============

.. _zend.mime.part.introduction:

導入
--

このクラスは、 *MIME* メッセージのひとつのパートを表します。
実際のメッセージの内容に加え、エンコーディングや Content Type、
そして元のファイル名などの情報も含まれます。
保存されたデータから文字列を生成するためのメソッドが用意されています。
``Zend_Mime_Part`` オブジェクトを :ref:`Zend_Mime_Message <zend.mime.message>`
に追加することで、完全なマルチパートメッセージを作成できます。

.. _zend.mime.part.instantiation:

インスタンスの作成
---------

``Zend_Mime_Part`` のインスタンスを作成する際には、
新しいパートの内容を表す文字列を使用します。新しいパートの型は
OCTET-STREAM、エンコーディングは 8Bit であるとして作成されます。 ``Zend_Mime_Part``
のインスタンスを作成した後で、
その属性に直接アクセスすることでメタ情報を設定できます。

.. code-block:: php
   :linenos:

   public $type = Zend_Mime::TYPE_OCTETSTREAM;
   public $encoding = Zend_Mime::ENCODING_8BIT;
   public $id;
   public $disposition;
   public $filename;
   public $description;
   public $charset;
   public $boundary;
   public $location;
   public $language;

.. _zend.mime.part.methods:

メッセージパートを文字列にレンダリングするためのメソッド
----------------------------

``getContent()`` は、MimePart の内容をエンコードし、文字列で返します。
使用するエンコーディングは属性 $encoding で指定します。 使用可能な値は
Zend_Mime::ENCODING_* です。 文字セットの変換は行いません。

``getHeaders()`` は、アクセス可能な属性の情報から生成した MimePart の Mime
ヘッダを返します。
このメソッドをコールする前に、オブジェクトの属性を正しく設定しておく必要があります。


   - *$charset* テキスト型 (Text あるいは *HTML*)
     の場合は、実際の文字セットを設定しなければなりません。

   - *$id* *HTML* メールにおけるインライン画像のための ID を設定します。

   - *$filename* ダウンロードする際に使用されるファイル名を含めます。

   - *$disposition* ファイルを添付として扱うのか、あるいは (HTML-) メールに埋め込む
     (インライン) のかを指定します。

   - *$description* 情報を提供するためだけの目的で使用されます。

   - *$boundary* バウンダリ文字列を指定します。

   - *$location* コンテンツに関連するリソース *URI* として使用します。

   - *$language* コンテンツで使用する言語を指定します。




