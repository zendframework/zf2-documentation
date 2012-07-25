.. _zend.search.lucene.extending:

扩展性
===

.. _zend.search.lucene.extending.analysis:

文本分析
----

*Zend_Search_Lucene_Analysis_Analyzer* 类被索引建立程序用于记号化文档的文本字段。

*Zend_Search_Lucene_Analysis_Analyzer::getDefault()* 方法和 *Zend_Search_Lucene_Analysis_Analyzer::setDefault()*
方法用于获取和设置默认的分析程序。

因此你可以使用你自己的文本分析程序或者从预设的分析程序中选择一个：
*Zend_Search_Lucene_Analysis_Analyzer_Common_Text* 和
*Zend_Search_Lucene_Analysis_Analyzer_Common_Text_CaseInsensitive*\
(缺省的)。两者都把记号解释为一个字母序列。
*Zend_Search_Lucene_Analysis_Analyzer_Common_Text_CaseInsensitive*\ 将记号转化为小写。

使用下面代码更换分析程序：

.. code-block::
   :linenos:
   <?php

   Zend_Search_Lucene_Analysis_Analyzer::setDefault(
       new Zend_Search_Lucene_Analysis_Analyzer_Common_Text());
   ...
   $index->addDocument($doc);

   ?>
*Zend_Search_Lucene_Analysis_Analyzer_Common*\
类设计来作为所有自定义分析程序的祖先。用户可以只定义 *tokenize()*\
方法，它将字符串输入数据变成记号数组并返回。

方法 *tokenize()* 应该针对所有记号应用方法 *normalize()*\
。这样可以在你的分析程序中允许使用记号过滤。

这里是一个自定义分析程序的例子，它将单词变成数字作为搜索项：

   .. rubric:: 自定义文本分析程序

   .. code-block::
      :linenos:
      <?php
      /** Here is a custome text analyser, which treats words with digits as one term */


      /** Zend_Search_Lucene_Analysis_Analyzer_Common */
      require_once 'Zend/Search/Lucene/Analysis/Analyzer/Common.php';

      class My_Analyzer extends Zend_Search_Lucene_Analysis_Analyzer_Common
      {
          /**
           * Tokenize text to a terms
           * Returns array of Zend_Search_Lucene_Analysis_Token objects
           *
           * @param string $data
           * @return array
           */
          public function tokenize($data)
          {
              $tokenStream = array();

              $position = 0;
              while ($position < strlen($data)) {
                  // skip white space
                  while ($position < strlen($data) && !ctype_alpha($data{$position}) && !ctype_digit($data{$position})) {
                      $position++;
                  }

                  $termStartPosition = $position;

                  // read token
                  while ($position < strlen($data) && (ctype_alpha($data{$position}) || ctype_digit($data{$position}))) {
                      $position++;
                  }

                  // Empty token, end of stream.
                  if ($position == $termStartPosition) {
                      break;
                  }

                  $token = new Zend_Search_Lucene_Analysis_Token(substr($data,
                                                   $termStartPosition,
                                                   $position-$termStartPosition),
                                            $termStartPosition,
                                            $position);
                  $tokenStream[] = $this->normalize($token);
              }

              return $tokenStream;
          }
      }

      Zend_Search_Lucene_Analysis_Analyzer::setDefault(
          new My_Analyzer());

      ?>


.. _zend.search.lucene.extending.scoring:

评分算法
----

查询 ``q`` 的在文档 ``d`` 中的分值 score 定义如下：

*score(q,d) = sum( tf(t in d) * idf(t) * getBoost(t.field in d) * lengthNorm(t.field in d) ) * coord(q,d) *
queryNorm(q)*

tf(t in d) -*Zend_Search_Lucene_Search_Similarity::tf($freq)*-
基于搜索项或者短语在文档中出现次数的分值因子。

idf(t) -*Zend_Search_Lucene_Search_SimilaritySimilarity::tf($term, $reader)*-
针对特定索引的简单搜索项的分值因子。

getBoost(t.field in d) - 针对搜索项字段的增益因子。

lengthNorm($term) -
对一个给定字段，其中包含的搜索项的总数的标准值。这个值保存在索引中。这些值和字段增益一起，保存在索引中，通过搜索代码和每一个搜索结果的每一个字段的分值相乘。

匹配较长的字段精度较低，所以这个实现方法通常在 numTikuns
较大时返回较小的分值，而在 numTokens 较小时返回较大的分值。

coord(q,d) -*Zend_Search_Lucene_Search_Similarity::coord($overlap, $maxOverlap)*-
基于文档包含的所有查询搜索项碎片的分值因子。

出现大部分的查询搜索项表示更好的匹配查询，所以这个实现方法通常当这些参数的比率较大时返回较大的分值，而这些比率较小时返回较小的分值。

queryNorm(q) -
对给定的查询，所有查询搜索项的权重的总和的标准值。这个值用于和每一个查询搜索项相乘。

这对于定级没有帮助，而仅仅是尝试为不同的查询建立可比较的评分。

你可以通过自定义 Similatity 类来定制评分算法。可以按照下面的定义来扩展
Zend_Search_Lucene_Search_Similarity 类，然后使用
*Zend_Search_Lucene_Search_Similarity::setDefault($similarity);* 方法来将其设置为缺省的评分算法。

.. code-block::
   :linenos:
   <?php

   class MySimilarity extends Zend_Search_Lucene_Search_Similarity {
       public function lengthNorm($fieldName, $numTerms) {
           return 1.0/sqrt($numTerms);
       }

       public function queryNorm($sumOfSquaredWeights) {
           return 1.0/sqrt($sumOfSquaredWeights);
       }

       public function tf($freq) {
           return sqrt($freq);
       }

       /**
        * It's not used now. Computes the amount of a sloppy phrase match,
        * based on an edit distance.
        */
       public function sloppyFreq($distance) {
           return 1.0;
       }

       public function idfFreq($docFreq, $numDocs) {
           return log($numDocs/(float)($docFreq+1)) + 1.0;
       }

       public function coord($overlap, $maxOverlap) {
           return $overlap/(float)$maxOverlap;
       }
   }

   $mySimilarity = new MySimilarity();
   Zend_Search_Lucene_Search_Similarity::setDefault($mySimilarity);

   ?>
.. _zend.search.lucene.extending.storage:

存储容器
----

抽象类 Zend_Search_Lucene_Storage_Directory 定义了目录功能。

Zend_Search_Lucene 构造方法使用字符串或者 Zend_Search_Lucene_Storage_Directory 对象作为输入。

Zend_Search_Lucene_Storage_Directory_Filesystem 类实现了针对文件系统的目录功能。

如果字符串被用于 Zend_Search_Lucene 构造方法的输入，那么索引阅读程序(Zend_Search_Lucene
对象)认为它是一个文件系统路径并自行实例化 Zend_Search_Lucene_Storage_Directory_Filesystem
对象。

你可以通过扩展 Zend_Search_Lucene_Storage_Directory 类定义自己的目录实现。

Zend_Search_Lucene_Storage_Directory 的方法：

   .. code-block:: php
      :linenos:
      <?php

      abstract class Zend_Search_Lucene_Storage_Directory {
      /**
       * Closes the store.
       *
       * @return void
       */
      abstract function close();


      /**
       * Creates a new, empty file in the directory with the given $filename.
       *
       * @param string $name
       * @return void
       */
      abstract function createFile($filename);


      /**
       * Removes an existing $filename in the directory.
       *
       * @param string $filename
       * @return void
       */
      abstract function deleteFile($filename);


      /**
       * Returns true if a file with the given $filename exists.
       *
       * @param string $filename
       * @return boolean
       */
      abstract function fileExists($filename);


      /**
       * Returns the length of a $filename in the directory.
       *
       * @param string $filename
       * @return integer
       */
      abstract function fileLength($filename);


      /**
       * Returns the UNIX timestamp $filename was last modified.
       *
       * @param string $filename
       * @return integer
       */
      abstract function fileModified($filename);


      /**
       * Renames an existing file in the directory.
       *
       * @param string $from
       * @param string $to
       * @return void
       */
      abstract function renameFile($from, $to);


      /**
       * Sets the modified time of $filename to now.
       *
       * @param string $filename
       * @return void
       */
      abstract function touchFile($filename);


      /**
       * Returns a Zend_Search_Lucene_Storage_File object for a given $filename in the directory.
       *
       * @param string $filename
       * @return Zend_Search_Lucene_Storage_File
       */
      abstract function getFileObject($filename);

      }

      ?>


Zend_Search_Lucene_Storage_Directory 类的 *getFileObject($filename)* 方法返回 Zend_Search_Lucene_Storage_File
对象。

Zend_Search_Lucene_Storage_File 抽象类实现了文件抽象和原始的索引文件读取。

你还必须扩展 Zend_Search_Lucene_Storage_File 类以建立自己的目录实现。

Zend_Search_Lucene_Storage_File 类中只有两个方法是你必须重载的：

   .. code-block:: php
      :linenos:
      <?php

      class MyFile extends Zend_Search_Lucene_Storage_File {
          /**
           * Sets the file position indicator and advances the file pointer.
           * The new position, measured in bytes from the beginning of the file,
           * is obtained by adding offset to the position specified by whence,
           * whose values are defined as follows:
           * SEEK_SET - Set position equal to offset bytes.
           * SEEK_CUR - Set position to current location plus offset.
           * SEEK_END - Set position to end-of-file plus offset. (To move to
           * a position before the end-of-file, you need to pass a negative value
           * in offset.)
           * Upon success, returns 0; otherwise, returns -1
           *
           * @param integer $offset
           * @param integer $whence
           * @return integer
           */
          public function seek($offset, $whence=SEEK_SET) {
              ...
          }

          /**
           * Read a $length bytes from the file and advance the file pointer.
           *
           * @param integer $length
           * @return string
           */
          protected function _fread($length=1) {
              ...
          }
      }

      ?>



