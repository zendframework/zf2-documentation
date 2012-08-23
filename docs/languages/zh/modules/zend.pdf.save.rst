.. EN-Revision: none
.. _zend.pdf.save:

保存修改到 PDF 文档
============

有两个方法来保存修改到 PDF 文档： *Zend_Pdf::save()* 和 *Zend_Pdf::render()*\ 。

*Zend_Pdf::save($filename, $updateOnly = false)* 保存 PDF 文档到一个文件。如果 $updateOnly 是
true，那么只有新的 PDF 文件段被追加到文件，否则，重写文件。

*Zend_Pdf::render($newSegmentOnly = false)* 把 PDF 文档当作字符串返回。如果 $newSegmentOnly 是
true，那么只有新的 PDF 文件段返回。

.. _zend.pdf.save.example-1:

.. rubric:: Save PDF document.

.. code-block:: php
   :linenos:

   ...
   // Load PDF document.
   $pdf = Zend_Pdf::load($fileName);
   ...
   // Update document
   $pdf->save($fileName, true);
   // Save document as a new file
   $pdf->save($newFileName);

   // Return PDF document as a string.
   $pdfString = $pdf->render();

   ...



