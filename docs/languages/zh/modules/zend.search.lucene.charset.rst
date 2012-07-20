.. _zend.search.lucene.charset:

字符集
===

.. _zend.search.lucene.charset.description:

UTF-8 和单字节字符集支持
---------------

被设计于工作在 UTF-8 字符集下。索引文件在 Java 的"modified UTF-8
encoding"编码下保存文件。Zend_Search_Lucene 内核完全支持它，只有一处例外。 [#]_

然而，各类文本和查询分析程序使用 ctype_alpha() 来进行文本和查询的记号化处理。而
ctype_alpha() 不支持 UTF-8，在不久的将来需要被替换为别的什么机制。

在此之前我们强烈推荐将你的数据转化成 ASCII 表示 [#]_
(不管是存储原始文档，或者进行搜索)：

.. code-block::
   :linenos:
   <?php
   $doc = new Zend_Search_Lucene_Document();
   ...
   $docText = iconv('ISO-8859-1', 'ASCII//TRANSLIT', $docText);
   $doc->addField(Zend_Search_Lucene_Field::UnStored('contents', $docText));

   ...

   $query = iconv('', 'ASCII//TRANSLIT', $query);
   $hits = $index->find($query);
   ?>


.. [#] Zend_Search_Lucene 只支持基本多语言平面(Basic Multilingual Plane, BMP)字符集(从 0x0000 到
       0xFFFF)，不支持辅助字符集(supplementary characters)(那些代码指针大于 0xFFFF 的字符)

       Java 2 通过一对两个 16
       位字符的值来表示这些字符，第一个来自高半代理(high-surrogates)区(0xD800-0xDBFF)，第二个来自低半代理(low-
       surrogates)区(0xDC00-0xDFFF)。它们将常用的 UTF-8 字符编码为 6 个字节。而标准的 UTF-8
       通过四个字节来表示附加的字符。

       (译注：有关信息请参考 Unicode 标准。可能大家更想知道的是 BMP
       中是否支持中文，答案是肯定的。事实上 BMP 中 CJK 字符集所占的比例最高。)
.. [#] 如果数据包含非 ASCII 字符或者来自 UTF-8。