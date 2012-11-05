.. EN-Revision: none
.. _zend.pdf.create:

PDF ドキュメントの作成および読み込み
====================

``ZendPdf`` クラスは *PDF* ドキュメントを表すもので、
ドキュメントレベルの機能を提供します。

新しいドキュメントを作成するには、新しい ``ZendPdf``
オブジェクトを作成しなければなりません。

``ZendPdf`` クラスでは、既存の *PDF* を読み込むための 2
つの静的メソッドも提供しています。 ``ZendPdf\Pdf::load()`` および ``ZendPdf\Pdf::parse()`` です。
これらは両方とも ``ZendPdf`` オブジェクトを返します。
エラーが発生した場合には例外がスローされます。

.. _zend.pdf.create.example-1:

.. rubric:: 新しい PDF ドキュメントの作成あるいは既存の PDF ドキュメントの読み込み

.. code-block:: php
   :linenos:

   ...
   // 新しい PDF ドキュメントを作成します。
   $pdf1 = new ZendPdf\Pdf();

   // ファイルから PDF ドキュメントを読み込みます。
   $pdf2 = ZendPdf\Pdf::load($fileName);

   // 文字列から PDF ドキュメントを読み込みます。
   $pdf3 = ZendPdf\Pdf::parse($pdfString);
   ...

*PDF*
ファイルでは、ドキュメントのインクリメンタルな更新がサポートされています。
つまり、ドキュメントを更新するたびに、そのドキュメントの新しい版が作成されます。
``ZendPdf`` モジュールには、指定した版を取得する機能も含まれています。

版を指定するには ``ZendPdf\Pdf::load()`` および ``ZendPdf\Pdf::parse()`` メソッドの第 2
引数を使用するか、 ``ZendPdf\Pdf::rollback()`` を使用します。 [#]_ call.

.. _zend.pdf.create.example-2:

.. rubric:: 指定した版の PDF ドキュメントの取得

.. code-block:: php
   :linenos:

   ...
   // 前の版の PDF ドキュメントを読み込みます。
   $pdf1 = ZendPdf\Pdf::load($fileName, 1);

   // 前の版の PDF ドキュメントを読み込みます。
   $pdf2 = ZendPdf\Pdf::parse($pdfString, 1);

   // ドキュメントの最初の版を読み込みます。
   $pdf3 = ZendPdf\Pdf::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...



.. [#] ``ZendPdf\Pdf::rollback()`` メソッドは、
       変更がドキュメントに適用される前に起動しなければなりません。
       それ以外の場合の挙動は未定義です。