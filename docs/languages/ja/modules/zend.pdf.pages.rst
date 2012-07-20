.. _zend.pdf.pages:

ページの操作
======

.. _zend.pdf.pages.creation:

ページの作成
------

*PDF* ドキュメントのページは、 ``Zend_Pdf`` の ``Zend_Pdf_Page`` クラスで表されます。

*PDF* ページは既存の *PDF* から読み込むこともできますし、
新しく作成することもできます。

新しいページを取得するには、直接 ``Zend_Pdf_Page`` オブジェクトを作成するか、
``Zend_Pdf::newPage()`` メソッドをコールします。このメソッドは ``Zend_Pdf_Page``
オブジェクトを返します。 ``Zend_Pdf::newPage()``
の場合は、すでにドキュメントにアタッチされているページを作成するという点が異なります。
こうするとそのページを複数の *PDF* ドキュメントで使いまわすことができませんが、
多少高速になります [#]_\ 。どちらの手法を使用するかはあなたしだいです。

``Zend_Pdf::newPage()`` メソッドおよび ``Zend_Pdf_Page``
のコンストラクタは、どちらも同じ形式のパラメータを受け取ります。
ページサイズを ($x, $y) 形式のポイント数 (1/72 インチ)
で表したものか、定義済みの定数のうちのいずれかになります。
以下の定数が定義されています。

   - Zend_Pdf_Page::SIZE_A4

   - Zend_Pdf_Page::SIZE_A4_LANDSCAPE

   - Zend_Pdf_Page::SIZE_LETTER

   - Zend_Pdf_Page::SIZE_LETTER_LANDSCAPE



ドキュメントのページは、 ``Zend_Pdf`` クラスの public メンバである ``$pages``
に保存されます。これは ``Zend_Pdf_Page``
オブジェクトの配列です。これによってページの並び順も定義され、
一般的な配列と同じように操作できます。

.. _zend.pdf.pages.example-1:

.. rubric:: PDF ドキュメントのページの操作

.. code-block:: php
   :linenos:

   ...
   // ページの並び順を反転します
   $pdf->pages = array_reverse($pdf->pages);
   ...
   // 新しいページを追加します
   $pdf->pages[] = new Zend_Pdf_Page(Zend_Pdf_Page::SIZE_A4);
   // 新しいページを追加します
   $pdf->pages[] = $pdf->newPage(Zend_Pdf_Page::SIZE_A4);

   // 指定したページを削除します
   unset($pdf->pages[$id]);

   ...

.. _zend.pdf.pages.cloning:

ページの複製
------

既存の *PDF* ページを複製するには、新しい ``Zend_Pdf_Page``
オブジェクトを作成する際に既存のページをパラメータとして指定します。

.. _zend.pdf.pages.example-2:

.. rubric:: 既存のページの複製

.. code-block:: php
   :linenos:

   ...
   // テンプレートページを別の変数に格納します
   $template = $pdf->pages[$templatePageIndex];
   ...
   // 新しいページを追加します
   $page1 = new Zend_Pdf_Page($template);
   $pdf->pages[] = $page1;
   ...

   // 別のページを追加します
   $page2 = new Zend_Pdf_Page($template);
   $pdf->pages[] = $page2;
   ...

   // テンプレートページをドキュメントから削除します
   unset($pdf->pages[$templatePageIndex]);

   ...

これは、ひとつのテンプレートから複数のページを作成したい場合に便利です。

.. caution::

   注意! 複製されたページは、テンプレートページと同じ *PDF*
   リソースを共有します。つまり、
   テンプレートページと同じドキュメントしか使用できません。
   ドキュメントを修正したら、新しいページとして保存できます。



.. [#] これは現在のバージョンの Zend Framework の制限事項であり、
       将来のバージョンではなくなる予定です。
       しかし、ドキュメント間でページを共有するには、
       アタッチされていないページのほうが常によい結果となるでしょう。