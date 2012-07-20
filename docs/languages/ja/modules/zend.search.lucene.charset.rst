.. _zend.search.lucene.charset:

文字セット
=====

.. _zend.search.lucene.charset.description:

UTF-8 およびシングルバイト文字セットのサポート
--------------------------

``Zend_Search_Lucene`` は、内部的には UTF-8 文字セットで動作します。
インデックスファイルには、unicode のデータが Java の "modified UTF-8 encoding"
で保存されます。 ``Zend_Search_Lucene``
はこの文字セットを完全にサポートしていますが、 ひとつだけ例外があります。 [#]_

実際の入力データのエンコーディングを指定するには ``Zend_Search_Lucene`` の *API*
を使用します。 データは、自動的に UTF-8 エンコーディングに変換されます。

.. _zend.search.lucene.charset.default_analyzer:

デフォルトのテキスト解析器
-------------

しかし、デフォルトのテキスト解析器 (クエリパーサの中でもこれが用いられます)
は、 テキストやクエリのトークン化に ctype_alpha() を使用しています。

ctype_alpha() は UTF-8 と互換性がありません。 したがって、この解析器は
テキストをインデックス化する前に 'ASCII//TRANSLIT' エンコーディングに変換します。
同じ処理がクエリのパース時にも透過的に行われます。 [#]_

.. note::

   デフォルトの解析器は、数字は単語の一部として扱いません。
   数字で単語を分断されたくない場合は、'Num' 解析器を使用しましょう。

.. _zend.search.lucene.charset.utf_analyzer:

UTF-8 互換のテキスト解析器
----------------

``Zend_Search_Lucene`` には、 ``Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8``\ 、
``Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8Num``\ 、
``Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8_CaseInsensitive``\ 、
``Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8Num_CaseInsensitive`` といった UTF-8
解析器も含まれています。

これを有効にするには、以下のようなコードを使用します。

   .. code-block:: php
      :linenos:

      Zend_Search_Lucene_Analysis_Analyzer::setDefault(
          new Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8());



.. warning::

   UTF-8 互換の解析器は Zend Framework 1.5 で改良されました。
   以前のバージョンの解析器は非アスキーキャラクタをすべて文字とみなしていましたが、
   新しい解析器の実装ではより正確な挙動となります。

   そのため、インデックスを再ビルドして
   データと検索クエリのトークン化方法を統一することになるでしょう。
   そうしないと、検索エンジンの返す結果セットがおかしなものになってしまいます。

これらの解析器を使用するには、PCRE (Perl 互換正規表現) ライブラリを UTF-8
サポート込みでコンパイルしておく必要があります。 *PHP*
のソースコードに同梱されている PCRE ライブラリのソースでは PCRE の UTF-8
サポートは有効になっているのですが、
バンドル版でなく共有ライブラリを使用している場合などは、 OS によって UTF-8
サポートの状態が異なるかもしれません。

PCRE が UTF-8 に対応しているかどうかを調べるには、次のコードを使用します。

   .. code-block:: php
      :linenos:

      if (@preg_match('/\pL/u', 'a') == 1) {
          echo "PCRE は unicode をサポートしています。\n";
      } else {
          echo "PCRE は unicode をサポートしていません。\n";
      }



大文字小文字を区別しないバージョンの UTF-8 互換解析器を使用する場合は、さらに
`mbstring`_ 拡張モジュールが必要です。

「mbstring
拡張モジュールは使いたくないけれど、大文字小文字を区別しない検索はしたい」
という場合は、次のようにします。
まず、インデックス化の前に元データを正規化し、
検索の際にはクエリ文字列を小文字に変換します。

   .. code-block:: php
      :linenos:

      // インデックス化
      setlocale(LC_CTYPE, 'de_DE.iso-8859-1');

      ...

      Zend_Search_Lucene_Analysis_Analyzer::setDefault(
          new Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8());

      ...

      $doc = new Zend_Search_Lucene_Document();

      $doc->addField(Zend_Search_Lucene_Field::UnStored('contents',
                                                        strtolower($contents)));

      // 検索用の Title フィールド (インデックス化しますが保存しません)
      $doc->addField(Zend_Search_Lucene_Field::UnStored('title',
                                                        strtolower($title)));

      // 取得用の Title フィールド (インデックス化せず、保存します)
      $doc->addField(Zend_Search_Lucene_Field::UnIndexed('_title', $title));



   .. code-block:: php
      :linenos:

      // 検索
      setlocale(LC_CTYPE, 'de_DE.iso-8859-1');

      ...

      Zend_Search_Lucene_Analysis_Analyzer::setDefault(
          new Zend_Search_Lucene_Analysis_Analyzer_Common_Utf8());

      ...

      $hits = $index->find(strtolower($query));





.. _`mbstring`: http://www.php.net/manual/ja/ref.mbstring.php

.. [#] ``Zend_Search_Lucene`` では Basic Multilingual Plane (BMP) 文字 (0x0000 から 0xFFFF まで)
       のみをサポートしており、 "supplementary characters" (コードポイントが 0xFFFF
       より大きい文字) はサポートしていません。

       Java 2 では、これらを文字 (16 ビット)
       のペアで表します。最初の文字が上位サロゲート (0xD800-0xDBFF)、 2
       番目の文字が下位サロゲート (0xDC00-0xDFFF) となります。 その後、これらが 6
       バイトの UTF-8 文字にエンコードされます。 標準的な UTF-8 では、supplementary
       characters を 4 バイトで表します。
.. [#] 'ASCII//TRANSLIT' への変換は、現在のロケールおよび OS に依存します。