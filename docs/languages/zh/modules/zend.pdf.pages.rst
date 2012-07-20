.. _zend.pdf.pages:

文档页面
============

.. _zend.pdf.pages.creation:

页面生成
------------

PDF 文档页面摘要由 *Zend_Pdf_Page* 类来描绘。

PDF 页面或者从 PDF 加载，或者生成新的。

新页面可以通过创建 *Zend_Pdf_Page* 对象或调用 *Zend_Pdf::newPage()* 方法来获得，它返回
*Zend_Pdf_Page* 对象。 *Zend_Pdf::newPage()*
方法生成已经附加到文档的页面，和未附加的页面不同的是它不能和若干个 PDF
文档一起用，但是性能会稍好一些。 [#]_. 选择那种方式是你的自由。

*Zend_Pdf::newPage()* 方法和 *Zend_Pdf_Page*
构造器带有相同的指定页面尺寸的参数。它或者是以点（1/72
英寸）来计算的页面的尺寸（$x,$y），或者以预先定义的常数来计算，常数就是页面类型：


   - Zend_Pdf_Page::SIZE_A4

   - Zend_Pdf_Page::SIZE_A4_LANDSCAPE

   - Zend_Pdf_Page::SIZE_LETTER

   - Zend_Pdf_Page::SIZE_LETTER_LANDSCAPE



文档存储在 *Zend_Pdf* 类的 public 成员 *$pages* 里，它是 *Zend_Pdf_Page*
对象的一个数组。它完整地定义了设置和文档页面的顺序并可以以普通的数组来处理：

.. _zend.pdf.pages.example-1:

.. rubric:: PDF 文档页面管理

.. code-block::
   :linenos:
   <?php
       ...
       // Reverse page order
       $pdf->pages = array_reverse($pdf->pages);
       ...
       // Add new page
       $pdf->pages[] = new Zend_Pdf_Page(Zend_Pdf_Page::SIZE_A4);
       // Add new page
       $pdf->pages[] = $pdf->newPage(Zend_Pdf_Page::SIZE_A4);

       // Remove specified page.
       unset($pdf->pages[$id]);

       ...

.. _zend.pdf.pages.cloning:

页面克隆
------------

通过用页面为参数创建 *Zend_Pdf_Page* 对象 PDF 页面可以被克隆：

.. _zend.pdf.pages.example-2:

.. rubric:: Cloning existing page.

.. code-block::
   :linenos:
   <?php
       ...
       // Store template page in a separate variable
       $template = $pdf->pages[$templatePageIndex];
       ...
       // Add new page
       $page1 = new Zend_Pdf_Page($template);
       $pdf->pages[] = $page1;
       ...

       // Add another page
       $page2 = new Zend_Pdf_Page($template);
       $pdf->pages[] = $page2;
       ...

       // Remove source template page from the documents.
       unset($pdf->pages[$templatePageIndex]);

       ...

如果你需要用同一个模板生成若干页面，这很有用。

.. caution::

   重要！克隆页面用模板页面来共享一些 PDF
   资源，它只可以用于使用模板页的同一个文档内。修改后的文档可当作新文件来保存。



.. [#] Zend_Pdf 模块的 V1.0
       有点限制，会在将来的版本中改善。但未附加的页面总是为在文档间共享提供更好（更多的优化）的结果。