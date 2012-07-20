.. _zend.pdf.create:

生成和加载 PDF 文档
============

*Zend_Pdf* 类描绘 PDF 文档自己和提供文档一级的功能。

要生成新文档，需要创建 *Zend_Pdf* 对象。

*Zend_Pdf* 类也提供两个静态方法来加载 PDF， *Zend_Pdf::load()* 和 *Zend_Pdf::parse()*\
。它们都返回 Zend_Pdf 对象作为结果或如果有错误发生就抛出异常。

.. _zend.pdf.create.example-1:

.. rubric:: 生成新的或加载 PDF 文档

.. code-block::
   :linenos:

   ...
   // Create new PDF document.
   $pdf1 = new Zend_Pdf();

   // Load PDF document from a file.
   $pdf2 = Zend_Pdf::load($fileName);

   // Load PDF document from a string.
   $pdf3 = Zend_Pdf::parse($pdfString);
   ...


PDF 文件格式支持增量式文档更新。这样每次文档更新，就产生新的版本。Zend_Pdf
模块支持指定版本的读取。

版本可以指定为 *Zend_Pdf::load()* 和 *Zend_Pdf::parse()*\ 的第二个参数或由 *Zend_Pdf::rollback()*
来请求。 [#]_ call.

.. _zend.pdf.create.example-2:

.. rubric:: 请求 PDF 文档的指定版本

.. code-block::
   :linenos:

   ...
   // Load PDF previouse revision of the document.
   $pdf1 = Zend_Pdf::load($fileName, 1);

   // Load PDF previouse revision of the document.
   $pdf2 = Zend_Pdf::parse($pdfString, 1);

   // Load first revision of the document.
   $pdf3 = Zend_Pdf::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...




.. [#] *Zend_Pdf::rollback()* 方法必需在任何修改前调用，否则它的行为就没有定义。