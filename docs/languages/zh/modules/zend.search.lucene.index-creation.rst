.. _zend.search.lucene.index-creation:

建立索引
============

.. _zend.search.lucene.index-creation.creating:

创建新索引
---------------

在 Zend_Search_Lucene 模块和 Java Lucene 中实现了索引的创建和更新机制。你都可以使用。

下面的 PHP 代码提供了一个如何使用 Zend_Search_Lucene 索引 API 的例子：

.. code-block::
   :linenos:
   <?php

   // Setting the second argument to TRUE creates a new index
   $index = new Zend_Search_Lucene('/data/my-index', true);

   $doc = new Zend_Search_Lucene_Document();

   // Store document URL to identify it in search result.
   $doc->addField(Zend_Search_Lucene_Field::Text('url', $docUrl));

   // Index document content
   $doc->addField(Zend_Search_Lucene_Field::UnStored('contents', $docContent));

   // Add document to the index.
   $index->addDocument($doc);

   // Write changes to the index.
   $index->commit();
   ?>
在进行了 commit 提交操作之后，新添加的文档就可以被检索了。

*Zend_Search_Lucene::commit()* 会在脚本执行结束前以及任意搜索请求开始之前被自动调用。

每一次 commit()
调用产生新的索引分段。因此尽可能少的请求它。当然另一方面，在一步中提交大量的文档需要更多的内存。

字段分段管理优化是 Zend_Search_Lucene 未来要增强的内容。

.. _zend.search.lucene.index-creation.updating:

更新索引
------------

同样的过程可以用于更新现存的索引。唯一的区别是打开相应的索引是不需要第二个参数：

.. code-block::
   :linenos:
   <?php

   // Open existing index
   $index = new Zend_Search_Lucene('/data/my-index');

   $doc = new Zend_Search_Lucene_Document();
   // Store document URL to identify it in search result.
   $doc->addField(Zend_Search_Lucene_Field::Text('url', $docUrl));
   // Index document content
   $doc->addField(Zend_Search_Lucene_Field::UnStored('contents', $docContent));

   // Add document to the index.
   $index->addDocument($doc);

   // Write changes to the index.
   $index->commit();
   ?>
每一次 commit() 调用(显式的或者隐式的)产生新的索引分段。

Zend_Search_Lucene
不会自动管理分段。因此你应该关注分段的大小。一方面一个大的分段可能更加理想，另一方面在创建时需要更大的内存。

Lucene Java 和 Luke (Lucene Index Toolbox -`http://www.getopt.org/luke/`_)可以用于优化这个版本的
Zend_Search_Lucene 产生的索引。



.. _`http://www.getopt.org/luke/`: http://www.getopt.org/luke/
