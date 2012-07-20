.. _zend.search.lucene.query-api:

クエリ作成用の API
===========

文字列のクエリを自動的にパースするだけではなく、クエリを *API*
で作成することもできます。

ユーザクエリは、 *API* で作成したクエリを組み合わせて作成できます。
クエリパーサを使用して、文字列からクエリを作成します。

   .. code-block:: php
      :linenos:

      $query = Zend_Search_Lucene_Search_QueryParser::parse($queryString);



.. _zend.search.lucene.queries.exceptions:

クエリパーサの例外
---------

クエリパーサは、二種類の例外を発生させます。

   - ``Zend_Search_Lucene_Exception`` がスローされるのは、
     クエリパーサ自体に何らかの問題が発生した場合です。

   - ``Zend_Search_Lucene_Search_QueryParserException``
     がスローされるのは、クエリの構文エラーが発生した場合です。

つまり、 ``Zend_Search_Lucene_Search_QueryParserException``
を捕捉して適切なメッセージを表示させるようにしておくことが大切です。

   .. code-block:: php
      :linenos:

      try {
          $query = Zend_Search_Lucene_Search_QueryParser::parse($queryString);
      } catch (Zend_Search_Lucene_Search_QueryParserException $e) {
          echo "クエリの構文エラー: " . $e->getMessage() . "\n";
      }



``Zend_Search_Lucene`` オブジェクトの find() メソッドでも同様のテクニックを使えます。

バージョン 1.5
以降では、クエリのパース時の例外はデフォルトで抑制されるようになります。
クエリ言語に反するクエリが渡された場合は、現在のデフォルトの解析器を用いてそれをトークン化し、
トークン化された単語で検索します。 例外を有効にするには
``Zend_Search_Lucene_Search_QueryParser::dontSuppressQueryParsingExceptions()`` メソッドを使用します。
``Zend_Search_Lucene_Search_QueryParser::suppressQueryParsingExceptions()`` メソッドおよび
``Zend_Search_Lucene_Search_QueryParser::queryParsingExceptionsSuppressed()``
メソッドも、例外処理の振る舞いを変更するためのものです。

.. _zend.search.lucene.queries.term-query:

単一の単語のクエリ
---------

ひとつの単語を使用した検索を行うためのものです。

文字列によるクエリ

.. code-block:: text
   :linenos:

   word1

あるいは

*API* で作成するクエリ

.. code-block:: php
   :linenos:

   $term  = new Zend_Search_Lucene_Index_Term('word1', 'field1');
   $query = new Zend_Search_Lucene_Search_Query_Term($term);
   $hits  = $index->find($query);

単語のフィールドは任意で指定します。 指定しなかった場合は、 ``Zend_Search_Lucene``
は全フィールドを対象に検索します。

   .. code-block:: php
      :linenos:

      // インデックス化されている全フィールドから 'word1' を探します
      $term  = new Zend_Search_Lucene_Index_Term('word1');
      $query = new Zend_Search_Lucene_Search_Query_Term($term);
      $hits  = $index->find($query);



.. _zend.search.lucene.queries.multiterm-query:

複数の単語のクエリ
---------

複数の単語の組み合わせによる検索を行うためのものです。

各単語は、 **required (必須)**\ ・ **prohibited (禁止)**\ ・ **neither (どちらでもない)**
のいずれかを指定できます。



   - **required** を指定した場合、
     この単語を含まないドキュメントはクエリにマッチしません。

   - **prohibited** を指定した場合、
     この単語を含むドキュメントはクエリにマッチしません。

   - **neither** を指定した場合、
     この単語を含むドキュメントは除外されるわけでもなく、
     この単語を含まなければマッチしないというわけでもありません。
     ただし、クエリにマッチするためには、
     この単語のうち最低ひとつを含まなければなりません。



つまり、必須単語のみのクエリに「どちらでもない (オプション)」
単語を追加しても、結果セットは変わりません。
ただ、オプションの単語にマッチした結果が結果セットの先頭に移動します。

以下の両方の方法が使用可能です。

文字列によるクエリ

.. code-block:: text
   :linenos:

   +word1 author:word2 -word3

- 必須の単語には '+' を使用します。

- 禁止する単語には '-' を使用します。

- 検索するドキュメントフィールドを指定するには 'field:'
  を先頭につけます。これが省略された場合は 'contents' が使用されます。

あるいは

*API* で作成するクエリ

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_MultiTerm();

   $query->addTerm(new Zend_Search_Lucene_Index_Term('word1'), true);
   $query->addTerm(new Zend_Search_Lucene_Index_Term('word2', 'author'),
                   null);
   $query->addTerm(new Zend_Search_Lucene_Index_Term('word3'), false);

   $hits  = $index->find($query);

MultiTerm クエリのコンストラクタで、単語のリストを指定することもできます。

   .. code-block:: php
      :linenos:

      $terms = array(new Zend_Search_Lucene_Index_Term('word1'),
                     new Zend_Search_Lucene_Index_Term('word2', 'author'),
                     new Zend_Search_Lucene_Index_Term('word3'));
      $signs = array(true, null, false);

      $query = new Zend_Search_Lucene_Search_Query_MultiTerm($terms, $signs);

      $hits  = $index->find($query);



``$signs`` 配列に、単語の種別についての情報を含めます。

   - 必須の単語には ``TRUE`` を使用します。

   - 禁止する単語には ``FALSE`` を使用します。

   - 必須・禁止のどちらでもない場合は ``NULL`` を使用します。



.. _zend.search.lucene.queries.boolean-query:

Boolean クエリ
-----------

Boolean クエリを使用すると、他のクエリや boolean
演算子を用いたクエリを作成できます。

セット内の各サブクエリは、 **required (必須)** か **prohibited (禁止)**\ 、あるいは
**optional (オプション)** として定義します。



   - **required**
     は、このサブクエリにマッチしないドキュメントはクエリにマッチしません。

   - **prohibited**
     は、このサブクエリにマッチするドキュメントはクエリにマッチしません。

   - **optional**
     の場合、このサブクエリにマッチしなければマッチしないというわけではなく、このサブクエリにマッチしたものをを除外するというわけでもありません。
     しかし、クエリにマッチするには少なくともひとつのサブクエリにマッチする必要があります。



必須サブクエリを含むクエリにオプションのサブクエリを追加しても結果は変わりません。
ただ、オプションのサブクエリを使用することで、マッチしたドキュメントのスコアが変わります。

boolean クエリには、両方の方式の検索メソッドが使用可能です。

文字列によるクエリ

.. code-block:: text
   :linenos:

   +(word1 word2 word3) (author:word4 author:word5) -(word6)

- 必須サブクエリには '+' を使用します。

- 禁止サブクエリには '-' を使用します。

- 検索するドキュメントフィールドを指定するには 'field:'
  省略した場合はすべてのフィールドを検索します。

あるいは

*API* で作成するクエリ

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Boolean();

   $subquery1 = new Zend_Search_Lucene_Search_Query_MultiTerm();
   $subquery1->addTerm(new Zend_Search_Lucene_Index_Term('word1'));
   $subquery1->addTerm(new Zend_Search_Lucene_Index_Term('word2'));
   $subquery1->addTerm(new Zend_Search_Lucene_Index_Term('word3'));

   $subquery2 = new Zend_Search_Lucene_Search_Query_MultiTerm();
   $subquery2->addTerm(new Zend_Search_Lucene_Index_Term('word4', 'author'));
   $subquery2->addTerm(new Zend_Search_Lucene_Index_Term('word5', 'author'));

   $term6 = new Zend_Search_Lucene_Index_Term('word6');
   $subquery3 = new Zend_Search_Lucene_Search_Query_Term($term6);

   $query->addSubquery($subquery1, true  /* required */);
   $query->addSubquery($subquery2, null  /* optional */);
   $query->addSubquery($subquery3, false /* prohibited */);

   $hits  = $index->find($query);

Boolean クエリのコンストラクタで、単語のリストを指定することもできます。

   .. code-block:: php
      :linenos:

      ...
      $subqueries = array($subquery1, $subquery2, $subquery3);
      $signs = array(true, null, false);

      $query = new Zend_Search_Lucene_Search_Query_Boolean($subqueries, $signs);

      $hits  = $index->find($query);



``$signs`` 配列に、サブクエリの種別についての情報を含めます。

   - 必須のサブクエリには ``TRUE`` を使用します。

   - 禁止するサブクエリには ``FALSE`` を使用します。

   - 必須・禁止のどちらでもないサブクエリには ``NULL`` を使用します。



boolean 演算子を使用する各クエリは、符号記法や *API*
を用いて書き換えることができます。たとえば

   .. code-block:: text
      :linenos:

      word1 AND (word2 AND word3 AND NOT word4) OR word5

は次のクエリと同等です。

   .. code-block:: text
      :linenos:

      (+(word1) +(+word2 +word3 -word4)) (word5)



.. _zend.search.lucene.queries.wildcard:

ワイルドカードクエリ
----------

ワイルドカードクエリは、指定したパターンに一致する複数の単語を探すためのものです。

'?' は、ひとつの文字を表すワイルドカードです。

'\*' は、複数の文字を表すワイルドカードです。

文字列によるクエリ

   .. code-block:: text
      :linenos:

      field1:test*



あるいは

*API* で作成するクエリ

   .. code-block:: php
      :linenos:

      $pattern = new Zend_Search_Lucene_Index_Term('test*', 'field1');
      $query = new Zend_Search_Lucene_Search_Query_Wildcard($pattern);
      $hits  = $index->find($query);



フィールドの指定はオプションです。省略した場合は、 ``Zend_Search_Lucene``
は全フィールドを対象に検索を行います。

   .. code-block:: php
      :linenos:

      $pattern = new Zend_Search_Lucene_Index_Term('test*');
      $query = new Zend_Search_Lucene_Search_Query_Wildcard($pattern);
      $hits  = $index->find($query);



.. _zend.search.lucene.queries.fuzzy:

あいまいクエリ
-------

あいまいクエリは、指定した単語に似た単語を含むドキュメントを探すためのものです。

文字列によるクエリ

   .. code-block:: text
      :linenos:

      field1:test~

このクエリは、'test' 'text' 'best' といった単語を含むドキュメントにマッチします。

or

*API* で作成するクエリ

   .. code-block:: php
      :linenos:

      $term = new Zend_Search_Lucene_Index_Term('test', 'field1');
      $query = new Zend_Search_Lucene_Search_Query_Fuzzy($term);
      $hits  = $index->find($query);



オプションの類似度は、"~" 記号の後に指定します。

文字列によるクエリ

   .. code-block:: text
      :linenos:

      field1:test~0.4



or

*API* で作成するクエリ

   .. code-block:: php
      :linenos:

      $term = new Zend_Search_Lucene_Index_Term('test', 'field1');
      $query = new Zend_Search_Lucene_Search_Query_Fuzzy($term, 0.4);
      $hits  = $index->find($query);



単語のフィールドはオプションです。 このフィールドを省略した場合、
``Zend_Search_Lucene`` は各ドキュメントのすべてのフィールドを検索します。

   .. code-block:: php
      :linenos:

      $term = new Zend_Search_Lucene_Index_Term('test');
      $query = new Zend_Search_Lucene_Search_Query_Fuzzy($term);
      $hits  = $index->find($query);



.. _zend.search.lucene.queries.phrase-query:

フレーズクエリ
-------

熟語による検索を行うためのものです。

フレーズクエリはとても柔軟性の高いもので、
完全な熟語だけでなく曖昧な熟語の検索も可能になります。

熟語の途中で隙間をあけたり、複数の単語を同じ位置に指定したりもできます
(これは、解析器によって別の目的で作成されます。
例えば、単語の重みを増すためにある単語を重複させたり、
類義語をひとつの位置にまとめたりします)。

.. code-block:: php
   :linenos:

   $query1 = new Zend_Search_Lucene_Search_Query_Phrase();

   // 'word1' を 0 番目の位置に追加します。
   $query1->addTerm(new Zend_Search_Lucene_Index_Term('word1'));

   // 'word2' を 1 番目の位置に追加します。
   $query1->addTerm(new Zend_Search_Lucene_Index_Term('word2'));

   // 'word3' を 3 番目の位置に追加します。
   $query1->addTerm(new Zend_Search_Lucene_Index_Term('word3'), 3);

   ...

   $query2 = new Zend_Search_Lucene_Search_Query_Phrase(
                   array('word1', 'word2', 'word3'), array(0,1,3));

   ...

   // 隙間をあけないクエリ
   $query3 = new Zend_Search_Lucene_Search_Query_Phrase(
                   array('word1', 'word2', 'word3'));

   ...

   $query4 = new Zend_Search_Lucene_Search_Query_Phrase(
                   array('word1', 'word2'), array(0,1), 'annotation');

フレーズクエリを作成するには、コンストラクタで一気に構築してしまう方法と
``Zend_Search_Lucene_Search_Query_Phrase::addTerm()`` メソッドでひとつひとつ作成する方法に 2
通りがあります。

``Zend_Search_Lucene_Search_Query_Phrase`` クラスのコンストラクタで、 オプションの 3
つの引数を指定できます。

.. code-block:: php
   :linenos:

   Zend_Search_Lucene_Search_Query_Phrase(
       [array $terms[, array $offsets[, string $field]]]
   );

``$terms`` は文字列の配列で、
フレーズを構成する単語が含まれます。指定しなかったり null
を渡したりした場合は、空のクエリが作成されます。

``$offsets`` は整数の配列で、
フレーズ内の単語の位置を指定します。指定しなかったり null
を渡したりした場合は、単語の位置はシーケンシャルであり、
すきまはないと解釈されます。

``$field`` は文字列で、検索対象となるドキュメントのフィールドを指定します。
指定しなかったり ``NULL``
を渡したりした場合は、デフォルトのフィールドが対象となります。

したがって、

.. code-block:: php
   :linenos:

   $query =
       new Zend_Search_Lucene_Search_Query_Phrase(array('zend', 'framework'));

は 'zend framework' を検索します。

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Phrase(
                    array('zend', 'download'), array(0, 2)
                );

は 'zend ????? download' を検索し、'zend platform download' や 'zend studio download'、 'zend core
download'、'zend framework download' などがマッチします

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Phrase(
                    array('zend', 'framework'), null, 'title'
                );

は 'title' フィールドから 'zend framework' を検索します。

``Zend_Search_Lucene_Search_Query_Phrase::addTerm()`` メソッドは 2 つの引数をとります。
``Zend_Search_Lucene_Index_Term`` オブジェクトが必須で、position はオプションです。

.. code-block:: php
   :linenos:

   Zend_Search_Lucene_Search_Query_Phrase::addTerm(
       Zend_Search_Lucene_Index_Term $term[, integer $position]
   );

``$term`` はフレーズ内の次の単語を指定します。
前の単語と同じフィールドを指していなければなりません。
そうでない場合は例外がスローされます。

``$position`` は単語の位置を指定します。

したがって、

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Phrase();
   $query->addTerm(new Zend_Search_Lucene_Index_Term('zend'));
   $query->addTerm(new Zend_Search_Lucene_Index_Term('framework'));

は 'zend framework' を検索します。

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Phrase();
   $query->addTerm(new Zend_Search_Lucene_Index_Term('zend'), 0);
   $query->addTerm(new Zend_Search_Lucene_Index_Term('framework'), 2);

は 'zend ????? download' を検索し、'zend platform download' や 'zend studio download'、 'zend core
download'、'zend framework download' などがマッチします

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Phrase();
   $query->addTerm(new Zend_Search_Lucene_Index_Term('zend', 'title'));
   $query->addTerm(new Zend_Search_Lucene_Index_Term('framework', 'title'));

は 'title' フィールドから 'zend framework' を検索します。

曖昧度は、フレーズの間に別の単語が何個まで入ることを許すのかを設定します。
ゼロの場合は、完全な熟語検索となります。大きな値を指定すると、 WITHIN 演算子や
NEAR 演算子と同様な動作となります。

曖昧度とは、クエリの中で各単語の位置を何段階移動させられるかを表します。
例えば、2 つの単語の順番を入れ替えるには 2 段階の移動が必要です
(最初の単語を、次の単語のもうひとつ先まで移動させます)。
そのため、語順を入れ替えることを許可したいのなら、曖昧度は少なくとも 2
以上にしなければなりません。

正確にマッチしているほうが、曖昧に (sloppy)
マッチしているものより高スコアとなります。そのため、
検索結果は正確度の順に並べ替えられます。曖昧度のデフォルトはゼロで、
これは完全に一致するもののみを対象とします。

曖昧度は、クエリを作成した後で設定できます。

.. code-block:: php
   :linenos:

   // 隙間をあけないクエリ
   $query =
       new Zend_Search_Lucene_Search_Query_Phrase(array('word1', 'word2'));

   // 'word1 word2'、'word1 ... word2' を検索します
   $query->setSlop(1);
   $hits1 = $index->find($query);

   // 'word1 word2'、'word1 ... word2'、
   // 'word1 ... ... word2'、'word2 word1' を検索します
   $query->setSlop(2);
   $hits2 = $index->find($query);

.. _zend.search.lucene.queries.range:

範囲クエリ
-----

:ref:`範囲クエリ <zend.search.lucene.query-language.range>`
は、指定した範囲にある単語を探すためのものです。

文字列によるクエリ

   .. code-block:: text
      :linenos:

      mod_date:[20020101 TO 20030101]
      title:{Aida TO Carmen}



あるいは

*API* で作成するクエリ

   .. code-block:: php
      :linenos:

      $from = new Zend_Search_Lucene_Index_Term('20020101', 'mod_date');
      $to   = new Zend_Search_Lucene_Index_Term('20030101', 'mod_date');
      $query = new Zend_Search_Lucene_Search_Query_Range(
                       $from, $to, true // inclusive
                   );
      $hits  = $index->find($query);



フィールドの指定はオプションです。省略した場合は、 ``Zend_Search_Lucene``
は全フィールドを対象に検索を行います。

   .. code-block:: php
      :linenos:

      $from = new Zend_Search_Lucene_Index_Term('Aida');
      $to   = new Zend_Search_Lucene_Index_Term('Carmen');
      $query = new Zend_Search_Lucene_Search_Query_Range(
                       $from, $to, false // non-inclusive
                   );
      $hits  = $index->find($query);



上限あるいは下限のどちらか一方を ``NULL`` にできます (両方を ``NULL``
にすることはできません)。この場合、Zend_Search_Lucene
は「先頭から指定した値まで」あるいは「指定した値から最後まで」
という条件で検索します。

   .. code-block:: php
      :linenos:

      // searches for ['20020101' TO ...]
      $from = new Zend_Search_Lucene_Index_Term('20020101', 'mod_date');
      $query = new Zend_Search_Lucene_Search_Query_Range(
                       $from, null, true // inclusive
                   );
      $hits  = $index->find($query);




