.. EN-Revision: none
.. _zend.pdf.create:

PDF ドキュメントの作成および読み込み
====================

``Zend_Pdf`` クラスは *PDF* ドキュメントを表すもので、
ドキュメントレベルの機能を提供します。

新しいドキュメントを作成するには、新しい ``Zend_Pdf``
オブジェクトを作成しなければなりません。

``Zend_Pdf`` クラスでは、既存の *PDF* を読み込むための 2
つの静的メソッドも提供しています。 ``Zend_Pdf::load()`` および ``Zend_Pdf::parse()`` です。
これらは両方とも ``Zend_Pdf`` オブジェクトを返します。
エラーが発生した場合には例外がスローされます。

.. _zend.pdf.create.example-1:

.. rubric:: 新しい PDF ドキュメントの作成あるいは既存の PDF ドキュメントの読み込み

.. code-block:: php
   :linenos:

   ...
   // 新しい PDF ドキュメントを作成します。
   $pdf1 = new Zend_Pdf();

   // ファイルから PDF ドキュメントを読み込みます。
   $pdf2 = Zend_Pdf::load($fileName);

   // 文字列から PDF ドキュメントを読み込みます。
   $pdf3 = Zend_Pdf::parse($pdfString);
   ...

*PDF*
ファイルでは、ドキュメントのインクリメンタルな更新がサポートされています。
つまり、ドキュメントを更新するたびに、そのドキュメントの新しい版が作成されます。
``Zend_Pdf`` モジュールには、指定した版を取得する機能も含まれています。

版を指定するには ``Zend_Pdf::load()`` および ``Zend_Pdf::parse()`` メソッドの第 2
引数を使用するか、 ``Zend_Pdf::rollback()`` を使用します。 [#]_ call.

.. _zend.pdf.create.example-2:

.. rubric:: 指定した版の PDF ドキュメントの取得

.. code-block:: php
   :linenos:

   ...
   // 前の版の PDF ドキュメントを読み込みます。
   $pdf1 = Zend_Pdf::load($fileName, 1);

   // 前の版の PDF ドキュメントを読み込みます。
   $pdf2 = Zend_Pdf::parse($pdfString, 1);

   // ドキュメントの最初の版を読み込みます。
   $pdf3 = Zend_Pdf::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...



.. [#] ``Zend_Pdf::rollback()`` メソッドは、
       変更がドキュメントに適用される前に起動しなければなりません。
       それ以外の場合の挙動は未定義です。