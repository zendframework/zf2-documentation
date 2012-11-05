.. EN-Revision: none
.. _zend.pdf.info:

ドキュメントの情報およびメタデータ
=================

*PDF* ドキュメントには、そのドキュメントに関する情報
(たとえばタイトルや作者、作成日、更新日など) を含められます。

歴史的に、この情報は特別な Info 構造体に格納されるようになっています。
この構造体を読み書きするには、 ``ZendPdf`` オブジェクトの public プロパティ
*properties* の連想配列を使用します。

   .. code-block:: php
      :linenos:

      $pdf = ZendPdf\Pdf::load($pdfPath);

      echo $pdf->properties['Title'] . "\n";
      echo $pdf->properties['Author'] . "\n";

      $pdf->properties['Title'] = 'New Title.';
      $pdf->save($pdfPath);



*PDF* v1.4 (Acrobat 5) の標準規格では、次のようなキーが定義されています。



   - **Title**- 文字列 (任意)。ドキュメントのタイトル。

   - **Author**- 文字列 (任意)。 ドキュメントの作成者。

   - **Subject**- 文字列 (任意)。 ドキュメントのサブタイトル。

   - **Keywords**- 文字列 (任意)。 ドキュメントに関連するキーワード。

   - **Creator**- 文字列 (任意)。 他の形式から *PDF*
     に変換されたドキュメントである場合に、
     変換元のドキュメントを作成したアプリケーションの名前 (たとえば Adobe
     FrameMaker®) が格納されます。

   - **Producer**- 文字列 (任意)。 他の形式から *PDF*
     に変換されたドキュメントである場合に、 *PDF*
     への変換に使用したアプリケーションの名前 (たとえば Acrobat Distiller)
     が格納されます。

   - **CreationDate**- 文字列 (任意)。 ドキュメントの作成日時を "D:YYYYMMDDHHmmSSOHH'mm'"
     形式で表したもの。

        - **YYYY** は年です。

        - **MM** は月です。

        - **DD** は日 (01–31) です。

        - **HH** は時 (00–23) です。

        - **mm** は分 (00–59) です。

        - **SS** は秒 (00–59) です。

        - **O** は地方時と標準時 (UT) との関連です。+, −, あるいは Z で表します
          (以下を参照ください)。

        - **HH** の後に ' を続けたものは、 UT との時差 (時) の絶対値 (00–23) です。

        - **mm** の後に ' を続けたものは、 UT との時差 (分) の絶対値 (00–59) です。

     HH および mm の後に続くアポストロフィ (')
     は、それぞれのパーツの一部となります。
     年以外のすべてのフィールドはオプションです (先頭の D: もオプションですが、
     これは省略しないことを強くお勧めします)。MM と DD のデフォルト値はともに 01
     で、その他のすべての数値フィールドのデフォルト値はゼロです。 O
     フィールドのプラス記号 (+) は、地方時が UT より遅れていることを表し、
     マイナス記号 (−) は地方時のほうが UT より進んでいることを表します。 UT
     情報を省略した場合は、その時刻と UT との関係は未知となります。
     タイムゾーンの指定の有無にかかわらず、日付は地方時で指定しなければなりません。

     たとえば、太平洋標準時の 1998 年 12 月 23 日午後 7 時 52 分は、 "D:199812231952−08'00'"
     となります。

   - **ModDate**- 文字列 (任意)。 ドキュメントの最終更新日時。形式は **CreationDate**
     と同じ。

   - **Trapped**- boolean (任意)。
     ドキュメントにトラッピング情報を含むよう修正されているかどうか。

        - **TRUE**- ドキュメントは完全にトラッピングされています。
          これ以上のトラッピングは不要です。

        - **FALSE**- ドキュメントはまだトラッピングされていません。
          必要なトラッピングを行わなければなりません。

        - **NULL**- ドキュメントがトラッピングされているかどうかが判別不可能、
          あるいは一部だけトラッピングされている状態です。
          さらなるトラッピングが必要かもしれません。





*PDF* v 1.6 以降では、メタデータを特別な *XML* 形式 (XMP -`Extensible Metadata Platform`_)
で表して *PDF* に添付できます。

この *XML* ドキュメントを *PDF* から取得したり *PDF* に添付したりするには、それぞれ
``ZendPdf\Pdf::getMetadata()`` メソッドおよび ``ZendPdf\Pdf::setMetadata($metadata)``
メソッドを使用します。

   .. code-block:: php
      :linenos:

      $pdf = ZendPdf\Pdf::load($pdfPath);
      $metadata = $pdf->getMetadata();
      $metadataDOM = new DOMDocument();
      $metadataDOM->loadXML($metadata);

      $xpath = new DOMXPath($metadataDOM);
      $pdfPreffixNamespaceURI = $xpath->query('/rdf:RDF/rdf:Description')
                                      ->item(0)
                                      ->lookupNamespaceURI('pdf');
      $xpath->registerNamespace('pdf', $pdfPreffixNamespaceURI);

      $titleNode = $xpath->query('/rdf:RDF/rdf:Description/pdf:Title')->item(0);
      $title = $titleNode->nodeValue;
      ...

      $titleNode->nodeValue = 'New title';
      $pdf->setMetadata($metadataDOM->saveXML());
      $pdf->save($pdfPath);



標準的なドキュメントのプロパティは、Info 構造体とメタデータドキュメント
(存在する場合) の両方に重複して存在することになります。
これらをきちんと同期させるのは、アプリケーション側の責任となります。



.. _`Extensible Metadata Platform`: http://www.adobe.com/products/xmp/
