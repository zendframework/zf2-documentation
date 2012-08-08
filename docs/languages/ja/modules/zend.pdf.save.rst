.. EN-Revision: none
.. _zend.pdf.save:

PDF ドキュメントへの変更内容の保存
===================

*PDF* ドキュメントの変更内容を保存するには 2 種類の方法があります。
``Zend_Pdf::save()`` および ``Zend_Pdf::render()`` メソッドです。

``Zend_Pdf::save($filename, $updateOnly = false)`` は、
ドキュメントをファイルに保存します。$updateOnly が ``TRUE`` の場合は、 新しい *PDF*
ファイルセグメントがファイルに追記されます。
それ以外の場合はファイルが上書きされます。

``Zend_Pdf::render($newSegmentOnly = false)`` は、 *PDF*
ドキュメントを文字列として返します。$newSegmentOnly が ``TRUE`` の場合は、 新しい *PDF*
ファイルセグメントのみが返されます。

.. _zend.pdf.save.example-1:

.. rubric:: PDF ドキュメントの保存

.. code-block:: php
   :linenos:

   ...
   // PDF ドキュメントを読み込みます。
   $pdf = Zend_Pdf::load($fileName);
   ...
   // ドキュメントを更新します。
   $pdf->save($fileName, true);
   // ドキュメントを新しいファイルに保存します。
   $pdf->save($newFileName);

   // PDF ドキュメントを文字列で返します。
   $pdfString = $pdf->render();

   ...


