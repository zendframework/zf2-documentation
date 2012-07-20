.. _zend.search.lucene.extending:

拡張性
===

.. _zend.search.lucene.extending.analysis:

テキスト解析
------

``Zend_Search_Lucene_Analysis_Analyzer`` クラスは、
ドキュメントのテキストフィールドをトークン化 (単語に分解)
する際にインデクサが使用します。

``Zend_Search_Lucene_Analysis_Analyzer::getDefault()`` および
``Zend_Search_Lucene_Analysis_Analyzer::setDefault()``
メソッドで、デフォルトの解析器を取得あるいは設定します。

したがって、独自のテキスト解析器を指定したり、 定義済みの解析器である
``Zend_Search_Lucene_Analysis_Analyzer_Common_Text`` および
``Zend_Search_Lucene_Analysis_Analyzer_Common_Text_CaseInsensitive`` (デフォルト)
の中から選んだものを指定したりできることになります。
これらの解析器はどちらもトークンを文字列として解釈しますが、
``Zend_Search_Lucene_Analysis_Analyzer_Common_Text_CaseInsensitive``
はトークンを小文字に変換します。

解析器を変更するには、以下のようにします。

.. code-block:: php
   :linenos:

   Zend_Search_Lucene_Analysis_Analyzer::setDefault(
       new Zend_Search_Lucene_Analysis_Analyzer_Common_Text());
   ...
   $index->addDocument($doc);

ユーザ定義の解析器のための共通の親クラスとして設計されているのが
``Zend_Search_Lucene_Analysis_Analyzer_Common`` です。 ユーザが定義しなければならないのは
``reset()`` および ``nextToken()`` メソッドのみで、 これは文字列を $_input
から受け取って順に返します (``NULL`` が最後のデータを表します)。

``nextToken()`` メソッドでは、各トークンに対して ``normalize()``
メソッドを適用しなければなりません。
これにより、作成した解析器をトークンフィルタとして使用できるようになります。

独自のテキスト解析器の例を示します。
これは、数字つきの単語をひとつの言葉として扱います。



      .. _zend.search.lucene.extending.analysis.example-1:

      .. rubric:: 独自のテキスト解析器

      .. code-block:: php
         :linenos:

         /**
          * これは独自のテキスト解析器で、数字つきの単語をひとつの言葉として
          * 扱います
          */

         class My_Analyzer extends Zend_Search_Lucene_Analysis_Analyzer_Common
         {
             private $_position;

             /**
              * トークンストリームをリセットします
              */
             public function reset()
             {
                 $this->_position = 0;
             }

             /**
              * トークンストリーム API
              * 次のトークンを取得します。
              * ストリームの最後に達すると null を返します。
              *
              * @return Zend_Search_Lucene_Analysis_Token|null
              */
             public function nextToken()
             {
                 if ($this->_input === null) {
                     return null;
                 }

                 while ($this->_position < strlen($this->_input)) {
                     // 空白を読み飛ばします
                     while ($this->_position < strlen($this->_input) &&
                            !ctype_alnum( $this->_input[$this->_position] )) {
                         $this->_position++;
                     }

                     $termStartPosition = $this->_position;

                     // トークンを読み込みます
                     while ($this->_position < strlen($this->_input) &&
                            ctype_alnum( $this->_input[$this->_position] )) {
                         $this->_position++;
                     }

                     // 空のトークン、あるいはストリームが終了
                     if ($this->_position == $termStartPosition) {
                         return null;
                     }

                     $token = new Zend_Search_Lucene_Analysis_Token(
                                               substr($this->_input,
                                                      $termStartPosition,
                                                      $this->_position -
                                                      $termStartPosition),
                                               $termStartPosition,
                                               $this->_position);
                     $token = $this->normalize($token);
                     if ($token !== null) {
                         return $token;
                     }
                     // トークンがスキップされた場合は継続します
                 }

                 return null;
             }
         }

         Zend_Search_Lucene_Analysis_Analyzer::setDefault(
             new My_Analyzer());



.. _zend.search.lucene.extending.filters:

トークンのフィルタリング
------------

``Zend_Search_Lucene_Analysis_Analyzer_Common``
解析器には、トークンをフィルタリングする仕組みもあります。 mechanism.

``Zend_Search_Lucene_Analysis_TokenFilter``
クラスは、このフィルタリングの仕組みを抽象化したものです。
自分でフィルタを作成する際には、これを継承します。

独自に作成するフィルタは、 ``normalize()`` メソッドを実装する必要があります。
このメソッドは、入力トークンを変換したり
トークンを読み飛ばす指示を出したりします。

Analysis のサブパッケージとして、これらの三つのフィルタが定義されています。

   - ``Zend_Search_Lucene_Analysis_TokenFilter_LowerCase``

   - ``Zend_Search_Lucene_Analysis_TokenFilter_ShortWords``

   - ``Zend_Search_Lucene_Analysis_TokenFilter_StopWords``



*LowerCase* フィルタは、既に ``Zend_Search_Lucene_Analysis_Analyzer_Common_Text_CaseInsensitive``
解析器で使用されています。これはデフォルトの解析器です。

*ShortWords* および *StopWords*
は、定義済み解析器あるいは独自の解析器でこのように使用します。

   .. code-block:: php
      :linenos:

      $stopWords = array('a', 'an', 'at', 'the', 'and', 'or', 'is', 'am');
      $stopWordsFilter =
          new Zend_Search_Lucene_Analysis_TokenFilter_StopWords($stopWords);

      $analyzer =
          new Zend_Search_Lucene_Analysis_Analyzer_Common_TextNum_CaseInsensitive();
      $analyzer->addFilter($stopWordsFilter);

      Zend_Search_Lucene_Analysis_Analyzer::setDefault($analyzer);



   .. code-block:: php
      :linenos:

      $shortWordsFilter = new Zend_Search_Lucene_Analysis_TokenFilter_ShortWords();

      $analyzer =
          new Zend_Search_Lucene_Analysis_Analyzer_Common_TextNum_CaseInsensitive();
      $analyzer->addFilter($shortWordsFilter);

      Zend_Search_Lucene_Analysis_Analyzer::setDefault($analyzer);



``Zend_Search_Lucene_Analysis_TokenFilter_StopWords``
のコンストラクタには、禁止単語の配列を入力として渡します。
この禁止単語はファイルから読み込ませることもできます。

   .. code-block:: php
      :linenos:

      $stopWordsFilter = new Zend_Search_Lucene_Analysis_TokenFilter_StopWords();
      $stopWordsFilter->loadFromFile($my_stopwords_file);

      $analyzer =
         new Zend_Search_Lucene_Analysis_Analyzer_Common_TextNum_CaseInsensitive();
      $analyzer->addFilter($stopWordsFilter);

      Zend_Search_Lucene_Analysis_Analyzer::setDefault($analyzer);

ファイル形式は一般的なテキストファイルで、各文字列にひとつの単語が含まれるものとなります。
'#' を指定すると、その文字列はコメントであるとみなします。

``Zend_Search_Lucene_Analysis_TokenFilter_ShortWords``
のコンストラクタには、オプションの引数をひとつ指定できます。
これは単語長の制限を表し、デフォルト値は 2 です。

.. _zend.search.lucene.extending.scoring:

重み付けのアルゴリズム
-----------

クエリ ``q`` の、ドキュメント ``d`` に対するスコアは以下のように定義されます。

*score(q,d) = sum( tf(t in d) * idf(t) * getBoost(t.field in d) * lengthNorm(t.field in d) ) * coord(q,d) *
queryNorm(q)*

tf(t in d) -``Zend_Search_Lucene_Search_Similarity::tf($freq)``-
ドキュメント内での単語あるいは熟語の出現頻度に基づく重み要素。

idf(t) -``Zend_Search_Lucene_Search_Similarity::idf($input, $reader)``-
指定したインデックスに対する単純な単語の重み要素。

getBoost(t.field in d) - 単語のフィールドの重み。

lengthNorm($term) - フィールド内に含まれる単語の総数を正規化した値。
この値はインデックスに保存されます。
これらの値はフィールドの重みとともにインデックスに保存され、
検索コードによってヒットした各フィールドのスコアに掛けられます。

長いフィールドでマッチした場合は、あまり的確であるとはいえません。
そのため、このメソッドの実装は通常、 numTokens が大きいときにはより小さな値、
numTokens が小さいときにはより大きな値を返すようになっています。

coord(q,d) -``Zend_Search_Lucene_Search_Similarity::coord($overlap, $maxOverlap)``-
ドキュメントに含まれる、検索対象の全単語の部分一致に基づく重み要素。

検索対象の単語のより多くの部分が存在しているほど、
検索結果としてよいものであるといえます。そのため、このメソッドの実装は通常、
これらのパラメータの割合が大きいときにはより大きな値、
割合が小さいときにはより小さな値を返すようになっています。

queryNorm(q) - 検索対象の各単語の重みの二乗の和で与えられる、クエリの正規化値。
この値は、検索対象の各単語の重みに掛けられます。

これは重み付けには影響しません。単に別のクエリの結果との差をなくすために使用されます。

重み付けのアルゴリズムを変更するには、独自の Similatity
クラスを定義します。そのためには以下のように ``Zend_Search_Lucene_Search_Similarity``
クラスを継承し、 ``Zend_Search_Lucene_Search_Similarity::setDefault($similarity);``
メソッドでそれをデフォルトとして設定します。

.. code-block:: php
   :linenos:

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
        * 現在は使用しません。曖昧検索の曖昧度を計算します。
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

.. _zend.search.lucene.extending.storage:

保存先
---

抽象クラス Zend_Search_Lucene_Storage_Directory では、ディレクトリ機能を提供しています。

Zend_Search_Lucene のコンストラクタでは、文字列あるいは Zend_Search_Lucene_Storage_Directory
オブジェクトを入力として使用します。

Zend_Search_Lucene_Storage_Directory_Filesystem クラスは、
ファイルシステム用のディレクトリ機能を実装しています。

Zend_Search_Lucene コンストラクタの入力に文字列を使用すると、 インデックスリーダ
(Zend_Search_Lucene オブジェクト) はそれをファイルシステムのパスと解釈し、
Zend_Search_Lucene_Storage_Directory_Filesystem オブジェクトのインスタンスを作成します。

独自のディレクトリ機能を実装するには、 Zend_Search_Lucene_Storage_Directory
クラスを継承します。

Zend_Search_Lucene_Storage_Directory のメソッドは以下のとおりです。

.. code-block:: php
   :linenos:

   abstract class Zend_Search_Lucene_Storage_Directory {
   /**
    * 保存先を閉じます
    *
    * @return void
    */
   abstract function close();

   /**
    * $filename という名前の新しい空のファイルを、ディレクトリ内に作成します
    *
    * @param string $name
    * @return void
    */
   abstract function createFile($filename);

   /**
    * 既存の $filename をディレクトリから削除します
    *
    * @param string $filename
    * @return void
    */
   abstract function deleteFile($filename);

   /**
    * $filename で指定したファイルが存在する場合に true を返します
    *
    * @param string $filename
    * @return boolean
    */
   abstract function fileExists($filename);

   /**
    * ディレクトリ内の $filename の長さを返します
    *
    * @param string $filename
    * @return integer
    */
   abstract function fileLength($filename);

   /**
    * $filename の最終更新日時を UNIX タイムスタンプで返します
    *
    * @param string $filename
    * @return integer
    */
   abstract function fileModified($filename);

   /**
    * ディレクトリ内の既存のファイルの名前を変更します
    *
    * @param string $from
    * @param string $to
    * @return void
    */
   abstract function renameFile($from, $to);

   /**
    * $filename の更新時刻を現在の時刻にします
    *
    * @param string $filename
    * @return void
    */
   abstract function touchFile($filename);

   /**
    * ディレクトリ内の $filename についての
    * Zend_Search_Lucene_Storage_File オブジェクトを返します
    *
    * @param string $filename
    * @return Zend_Search_Lucene_Storage_File
    */
   abstract function getFileObject($filename);

   }

Zend_Search_Lucene_Storage_Directory クラスの ``getFileObject($filename)`` メソッドは、
Zend_Search_Lucene_Storage_File オブジェクトを返します。

抽象クラス Zend_Search_Lucene_Storage_File では、
ファイルの抽象化およびインデックスファイルの基本的な読み込み機能を実装しています。

ディレクトリ機能を実装するには Zend_Search_Lucene_Storage_File
クラスを継承しなければなりません。

Zend_Search_Lucene_Storage_File クラスを実装する際に
オーバーロードしなければならないメソッドは 2 つだけです。

.. code-block:: php
   :linenos:

   class MyFile extends Zend_Search_Lucene_Storage_File {
       /**
        * ファイル上の位置を指定し、そこにファイルポインタを進めます。
        * 新しい位置は、whence で指定した場所からオフセットのバイト数だけ
        * 進めた位置になります。whence に指定できる値は以下のいずれかです。
        * SEEK_SET - 先頭からオフセット分進めた位置に移動します。
        * SEEK_CUR - 現在位置からオフセット分だけ進めた位置に移動します。
        * SEEK_END - ファイルの終端からオフセット分だけ進めた位置に移動します。
        * (ファイルの終端から戻った位置を指定するには、オフセットに負の値を
        * 指定する必要があります)
        * 成功した場合に 0、それ以外の場合に -1 を返します。
        *
        * @param integer $offset
        * @param integer $whence
        * @return integer
        */
       public function seek($offset, $whence=SEEK_SET) {
           ...
       }

       /**
        * ファイルから $length バイトを読み込み、ファイルポインタを進めます。
        *
        * @param integer $length
        * @return string
        */
       protected function _fread($length=1) {
           ...
       }
   }


