.. _zend.pdf.introduction:

简介
==

Zend_Pdf module 是个完全用 PHP 5 编写的 PDF (Portable Document Format)
处理引擎。它可加载存在的文档，生成新的、修改和保存修改后的文档。这样，它可帮助任何
PHP 程序通过修改存在的模板或生成新的文档来动态地准备 PDF 格式的文档。 Zend_Pdf
模块支持下列功能：



   - 生成新文档或加载已存在的文档。 [#]_

   - 读取指定版本的文档。

   - 在文档中处理页面。修改页顺序、添加新的页和删除页。

   - 生成不同的图案（线、矩形、多边形、圆、椭圆和扇形）。

   - 使用任何 14 标准（内置）字体或自己定制的 TrueType 字体来生成文本（Text drawing）。

   - 旋转。

   - 生成图像。 [#]_

   - 增量式 PDF 文件更新。





.. [#] 现在支持 PDF V1.4 (Acrobat 5) 文档。
.. [#] 支持 JPG、 PNG [最多 8bit per channel+Alpha] 和 TIFF 图像。