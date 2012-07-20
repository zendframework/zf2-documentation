.. _zend.search.lucene.queries:

查询类型
============

.. _zend.search.lucene.queries.term-query:

单项查询
------------

单项查询用于搜索一个搜索项。

两种搜索方式都可以用于单项查询。

查询字串：

   .. code-block::
      :linenos:

          $hits = $index->find('word1');



或者

通过 API 创建查询：

   .. code-block::
      :linenos:
      <?php

          $term  = new Zend_Search_Lucene_Index_Term('word1');
          $query = new Zend_Search_Lucene_Search_Query_Term($term);
          $hits  = $index->find($query);

      ?>


.. _zend.search.lucene.queries.multiterm-query:

多项查询
------------

多项查询用于搜索一组搜索项。

每一个搜索项可以被定义为必须的、禁止的或者既不必须也不禁止(可选)的。



   - 必须的意思是文档如果不匹配这个搜索项，那么它就不匹配整个查询；

   - 禁止的意思是文档如果匹配这个搜索项，那么它就不匹配整个查询；

   - 可选的，这种情况下文档对搜索项的匹配既不是必须的也不是禁止的。无论如何，文档必须匹配至少一个搜索项才能匹配整个查询。



这意味着，如果一个包含必须的搜索项的查询中加入了可选的搜索项，返回的搜索结果集合是一样的，但是那些包含可选搜索项的搜索结果，将会上升到结果清单的前面。

两种搜索方式都可以用于单项查询。

查询字串：

   .. code-block::
      :linenos:
      <?php

      $hits = $index->find('+word1 author:word2 -word3');

      ?>




   - '+' 用于定义必须的搜索项。

   - '-' 用于定义禁止的搜索项。

   - 'field:' 用于指明要搜索的字段。如果没有提供，则默认的是'contents'。



或者

通过 API 创建查询：

   .. code-block::
      :linenos:
      <?php

          $query = new Zend_Search_Lucene_Search_Query_MultiTerm();

          $query->addTerm(new Zend_Search_Lucene_Index_Term('word1'), true);
          $query->addTerm(new Zend_Search_Lucene_Index_Term('word2'), null);
          $query->addTerm(new Zend_Search_Lucene_Index_Term('word3'), false);

          $hits  = $index->find($query);

      ?>


*$signs* 数组包含了搜索项的类型：

   - true 用于定义必须的搜索项。

   - false 用于定义禁止的搜索项。

   - null 用于定义既不必须也不禁止的搜索项。



.. _zend.search.lucene.queries.phrase-query:

短语查询
------------

短语查询用于搜索短语。

短语查询非常灵活，既可以搜索精确的短语，也可以搜索模糊的短语。精确短语可以包含搜索项和空隙(译注，所谓空隙也就是支持形如“word1
...
word2”的短语)。(可以使用分需程序生成以用于不同的用途。此外，搜索项可以被复制以提升该搜索项的权重或着一些同义词可以放在相同的地方。)因此目前短语查询只能通过
API 创建：

.. code-block::
   :linenos:
   <?php
   $query1 = new Zend_Search_Lucene_Search_Query_Phrase();

   // Add 'word1' at 0 relative position.
   $query1->addTerm(new Zend_Search_Lucene_Index_Term('word1'));

   // Add 'word2' at 1 relative position.
   $query1->addTerm(new Zend_Search_Lucene_Index_Term('word2'));

   // Add 'word3' at 3 relative position.
   $query1->addTerm(new Zend_Search_Lucene_Index_Term('word3'), 3);

   ...

   $query2 = new Zend_Search_Lucene_Search_Query_Phrase(
                   array('word1', 'word2', 'word3'), array(0,1,3));

   ...

   // Query without a gap.
   $query3 = new Zend_Search_Lucene_Search_Query_Phrase(
                   array('word1', 'word2', 'word3'));

   ...

   $query4 = new Zend_Search_Lucene_Search_Query_Phrase(
                   array('word1', 'word2'), array(0,1), 'annotation');

   ?>
短语查询可以使用类的构造方法一次性创建，也可以使用
*Zend_Search_Lucene_Search_Query_Phrase::addTerm()* 方法一步步的创建。

类 Zend_Search_Lucene_Search_Query_Phrase 的构造方法有三个可选的参数：

   .. code-block::
      :linenos:
      Zend_Search_Lucene_Search_Query_Phrase([array $terms[, array $offsets[, string $field]]]);


*$terms* 是字符串数组，包含一组短语搜索项。如果它被省略或者为
null，那么将会创建一个空查询。

*$offsets* 是一个整数数组，包含短语搜索项的偏移值。如果它被省略或者为
null，那么搜索项的位置被认为是 *array(0, 1, 2, 3, ...)*\ 。

*$field* 是一个字符串，表示要搜索的文档字段。如果它被省略或者为
null，那么默认的字段会被搜索。在这个版本的 Zend_Search_Lucene
中是“contents”，但是下个版本中计划变更为“any field”。

因此：

   .. code-block::
      :linenos:
      $query = new Zend_Search_Lucene_Search_Query_Phrase(array('zend', 'framework'));
将会搜索短语'zend framework'。

   .. code-block::
      :linenos:
      <$query = new Zend_Search_Lucene_Search_Query_Phrase(array('zend', 'download'), array(0, 2));
将会搜索短语“zend ????? download”并匹配'zend platform download'、 'zend studio download'、 'zend
core download'、 'zend framework download'这样的内容。

   .. code-block::
      :linenos:
      $query = new Zend_Search_Lucene_Search_Query_Phrase(array('zend', 'framework'), null, 'title');
将会搜索在'title'字段中搜索短语“zend framework”。

方法 *Zend_Search_Lucene_Search_Query_Phrase::addTerm()* 有两个参数。必须的
*Zend_Search_Lucene_Index_Term* 对象和可选的位置：

   .. code-block::
      :linenos:
      Zend_Search_Lucene_Search_Query_Phrase::addTerm(Zend_Search_Lucene_Index_Term $term[, integer $position]);


*$term*
描述了短语中的下一个搜索项。它必须位于上一个搜索项同样的字段中。否则将会抛出异常。

*$position* 指出了它的位置。

因此：

   .. code-block::
      :linenos:
      $query = new Zend_Search_Lucene_Search_Query_Phrase();
      $query->addTerm(new Zend_Search_Lucene_Index_Term('zend'));
      $query->addTerm(new Zend_Search_Lucene_Index_Term('framework'));
将会搜索短语'zend framework'。

   .. code-block::
      :linenos:
      $query = new Zend_Search_Lucene_Search_Query_Phrase();
      $query->addTerm(new Zend_Search_Lucene_Index_Term('zend'), 0);
      $query->addTerm(new Zend_Search_Lucene_Index_Term('framework'), 2);
将会搜索短语'zend ????? download'并匹配'zend platform download'、 'zend studio download'、 'zend core
download'、 'zend framework download'这样的内容。

   .. code-block::
      :linenos:
      $query = new Zend_Search_Lucene_Search_Query_Phrase();
      $query->addTerm(new Zend_Search_Lucene_Index_Term('zend', 'title'));
      $query->addTerm(new Zend_Search_Lucene_Index_Term('framework', 'title'));
将会搜索在'title'字段中搜索短语“zend framework”。

模糊因子设置了查询短语中两个词之间允许出现的其它词的数量。如果是
0，那么这是一个精确短语搜索。如果是一个较大的值，那么这工作起来像是具有(WITHIN)或者附近(NEAR)操作。

模糊因子事实上是一个“编辑距离”，表示移动搜索项移动到查询短语以外的位置上相对应的移动单位。例如，交换两个词的顺序需要两次移动(一次把一个词放到另一个前面)，因此要允许短语的重新排序，模糊因子至少必须为
2。

更精确的匹配相比更模糊的匹配得分更高，因此搜索结果将按照精确度排序。模糊因子默认为
0，也就是需要精确匹配。

模糊因子可以在查询创建后赋值：

.. code-block::
   :linenos:
   <?php

   // Query without a gap.
   $query = new Zend_Search_Lucene_Search_Query_Phrase(array('word1', 'word2'));

   // Search for 'word1 word2', 'word1 ... word2'
   $query->setSlop(1);
   $hits1 = $index->find($query);

   // Search for 'word1 word2', 'word1 ... word2',
   // 'word1 ... ... word2', 'word2 word1'
   $query->setSlop(2);
   $hits2 = $index->find($query);

   ?>

