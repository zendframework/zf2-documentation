.. _zend.search.lucene.searching:

搜索索引
====

.. _zend.search.lucene.searching.query-parser:

建立查询
----

有两种方式可以在索引中进行搜索。第一个方式是使用查询分析程序(Query
Parser)来从字符串中创建查询。第二个方式通过 Zend_Search_Lucene API
提供了创建自己的查询的可能。

在选择使用查询分析程序之前，请考虑下面问题：



   . 如果你使用程序生成查询字串并传递给查询分析程序，那么你最好考虑直接使用查询
     API
     来建立查询。换句话说，查询分析程序是为人为输入的文本设计的，而不是为程序生成的文本准备的。

   . 非记号化字段最好直接加入查询中，而不是通过查询分析程序。如果一个字段的值是应用程序生成的，那么它应该按照这个条款进行查询。查询分析程序使用的机制，是设计来转换人为输入的文本的。像日期、关键词等等，都可以认为是程序生成的信息。

   . 在查询表单中，用于产生文本的字段应该是用查询分析程序。所有其它的诸如日期范围、关键词等，最好通过查询
     API
     直接加入查询中。一个具有一组取之范围的字段，可以通过下拉菜单来实现而不应该加入需要被分析的查询字串中，而不是增加一个查询项。



两种途径都使用同样的 API 方法来搜索索引：

   .. code-block::
      :linenos:
      <?php

      require_once('Zend/Search/Lucene.php');

      $index = new Zend_Search_Lucene('/data/my_index');

      $index->find($query);

      ?>
方法 *Zend_Search_Lucene::find()* 自动检查输入类型并使用查询分析程序从字符串建立适当的
Zend_Search_Lucene_Search_Query 对象。

需要特别注意的是 *find()* 是大小写敏感的。默认的，LuceneIndexCreation.jar
标准化所有文档为小写。可以通过命令行来关闭这个设置(输入不带参数的
LuceneIndexCreation.jar 命令来获取帮助)。提供给 *find()*
的文本大小写必须和索引中的相匹配。如果索引被正常设置为全小写，那么提供给
*find()* 的文本必须用 *strtolower()*\ 处理，否则它可能无法被匹配。

.. _zend.search.lucene.searching.results:

搜索结果
----

搜索结果是一个 Zend_Search_Lucene_Search_QueryHit 对象数组。每一个数组元素具有两个属性：
*$hit->document* 是索引中的文档编号， *$hit->score*
是其在搜索结果中的分值。搜索结果是按照分值排序的(最高分的搜索结果位于最前面)。

Zend_Search_Lucene_Search_QueryHit 对象还能将 Zend_Search_Lucene_Document
中的各个字段作为属性陈列出来。在下面这个例子中，搜索结果相应的文档具有两个字段：title
和 author。

   .. code-block::
      :linenos:
      <?php

      require_once('Zend/Search/Lucene.php');

      $index = new Zend_Search_Lucene('/data/my_index');

      $hits = $index->find($query);

      foreach ($hits as $hit) {
          echo $hit->id;
          echo $hit->score;

          echo $hit->title;
          echo $hit->author;
      }

      ?>


可选的，原始的 Zend_Search_Lucene_Document 对象可以从 Zend_Search_Lucene_Search_QueryHit
获得。你可以使用索引对象的 *getDocument()*
方法来获取文档进行了索引的部分并接着使用 *getFieldValue()* 方法。

   .. code-block::
      :linenos:
      <?php

      require_once('Zend/Search/Lucene.php');

      $index = new Zend_Search_Lucene('/data/my_index');

      $hits = $index->find($query);
      foreach ($hits as $hit) {
          // return Zend_Search_Lucene_Document object for this hit
          echo $document = $hit->getDocument();

          // return a Zend_Search_Lucene_Field object
          // from the Zend_Search_Lucene_Document
          echo $document->getField('title');

          // return the string value of the Zend_Search_Lucene_Field object
          echo $document->getFieldValue('title');

          // same as getFieldValue()
          echo $document->title;
      }

      ?>
能够获取的 Zend_Search_Lucene_Document
对象的字段是在进行索引的时候决定的。由索引创建程序(例如：LuceneIndexCreation.jar)在文档中建立的文档字段要么是被索引的，要么是被索引并保存的。

请注意，文档标识(在本例中是'path')也保存在索引中，它必须被提取出来。

.. _zend.search.lucene.searching.results-scoring:

结果评分
----

Zend_Search_Lucene 使用和 Java Lucene
一样的评分算法。搜索结果是按照分值进行排序的。分值越大，相应的搜索结果点击排在排位越靠前。

不同的分值意味着一篇文档相比另一篇更能匹配查询要求。

粗略的说，包含更多的搜索项或短语的搜索结果，将会具有更高的分值。

可以通过 score 属性获取一个搜索结果的分值：

   .. code-block::
      :linenos:
      <?php
      $hits = $index->find($query);

      foreach ($hits as $hit) {
          echo $hit->id;
          echo $hit->score;
      }

      ?>


类 Zend_Search_Lucene_Search_Similarity 用于计算分值。请参阅 :ref:`“扩展性”中“评分算法”
<zend.search.lucene.extending.scoring>`\ 一节了解详情。


