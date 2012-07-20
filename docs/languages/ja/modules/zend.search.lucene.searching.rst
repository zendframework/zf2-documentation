.. _zend.search.lucene.searching:

インデックスの検索
=========

.. _zend.search.lucene.searching.query_building:

クエリの作成
------

インデックスを検索するには二通りの方法があります。
クエリパーサを使用して文字列からクエリを作成する方法と、 ``Zend_search_Lucene`` *API*
を使用して独自のクエリを作成する方法です。

提供されているクエリパーサを使用する前に、以下の点を考慮してください。



   . プログラムで生成したクエリ文字列をクエリパーサに渡そうとしているなら、
     クエリ *API* を使用してクエリを直接作成すべきです。言い換えると、
     クエリパーサというのは人間が入力したテキストのために設計されたものであり、
     プログラムが生成したテキストのためのものではないのです。

   . トークン化されていないフィールドについては、
     クエリパーサを使用するよりも直接クエリに追加するほうが適しています。
     フィールドの値がアプリケーションによって生成されるのなら、
     フィールドのクエリ条件についても自動処理で作成すべきです。
     クエリパーサが使用している解析器は、人間が入力したテキストを
     単語に分解するために設計されています。
     日付やキーワードなどのプログラムが生成した値は、 クエリ *API*
     で追加しなければなりません。

   . 検索フォームにおいては、
     テキストで入力された内容はクエリパーサを使用すべきでしょう。
     その他のフィールド、例えば範囲指定やキーワードなどについては、 クエリ *API*
     に直接渡すようにしましょう。
     限られた内容、例えばプルダウンメニューで選択するフィールドは、
     クエリ文字列に追加すべきではありません。 その代わりに、TermQuery
     条件として使用します。

   . 論理クエリにより、複数のクエリをひとつにまとめることができます。
     これは、クエリ文字列で定義されるユーザ検索に条件を追加するための最良な方法です。



どちらの方法を使用したとしても、インデックスを検索する *API*
メソッドは同じです。

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::open('/data/my_index');

   $index->find($query);

``Zend_Search_Lucene::find()`` メソッドは、
入力の型を自動的に判別し、クエリパーサを使用して文字列から
``Zend_Search_Lucene_Search_Query`` オブジェクトを作成します。

重要なのは、クエリパーサは標準の解析器を使用してクエリ文字列をトークン化するということです。
インデックス化されたテキストに対するすべての変換は、クエリ文字列エントリに対しても行われます。

小文字変換を行うことで大文字小文字を区別しない検索を行えるようにしたり、
ストップワードを取り除いたりといったさまざまなことを行います。

それに対して、 *API* メソッドは単語の変換やフィルタリングを行いません。これは、
コンピュータが生成したフィールドやトークン化されていないフィールドに適しています。

.. _zend.search.lucene.searching.query_building.parsing:

クエリのパース
^^^^^^^

``Zend_Search_Lucene_Search_QueryParser::parse()`` メソッドを使用してクエリ文字列をパースし、
クエリオブジェクトに格納します。

このオブジェクトをクエリ作成 *API* メソッドで使用し、
ユーザが入力したクエリと機械が生成したクエリを結合します。

実際のところ、これが
トークン化されたいないフィールドを検索する唯一の方法となることもあります。

   .. code-block:: php
      :linenos:

      $userQuery = Zend_Search_Lucene_Search_QueryParser::parse($queryStr);

      $pathTerm  = new Zend_Search_Lucene_Index_Term(
                           '/data/doc_dir/' . $filename, 'path'
                       );
      $pathQuery = new Zend_Search_Lucene_Search_Query_Term($pathTerm);

      $query = new Zend_Search_Lucene_Search_Query_Boolean();
      $query->addSubquery($userQuery, true /* required */);
      $query->addSubquery($pathQuery, true /* required */);

      $hits = $index->find($query);



``Zend_Search_Lucene_Search_QueryParser::parse()``
メソッドはオプションのパラメータでエンコーディングを受け取ることができます。
ここで、クエリ文字列のエンコーディングを指定します。

   .. code-block:: php
      :linenos:

      $userQuery = Zend_Search_Lucene_Search_QueryParser::parse($queryStr,
                                                                'iso-8859-5');



エンコーディングを省略した場合は、現在のロケールを使用します。

デフォルトのクエリ文字列エンコーディングを
``Zend_Search_Lucene_Search_QueryParser::setDefaultEncoding()`` メソッドで指定することもできます。


   .. code-block:: php
      :linenos:

      Zend_Search_Lucene_Search_QueryParser::setDefaultEncoding('iso-8859-5');
      ...
      $userQuery = Zend_Search_Lucene_Search_QueryParser::parse($queryStr);



``Zend_Search_Lucene_Search_QueryParser::getDefaultEncoding()``
は、デフォルトのクエリ文字列エンコーディングを返します (空文字列は
"現在のロケール" を表します)。

.. _zend.search.lucene.searching.results:

検索結果
----

検索結果は ``Zend_Search_Lucene_Search_QueryHit`` オブジェクトの配列となります。
各オブジェクトは、2 つのプロパティを保持しています。 *$hit->id*
がインデックス内のドキュメント番号、 *$hit->score* が検索結果のスコアを表します。
結果はスコア順に並べられます (スコアの高い結果が最初になります)。

``Zend_Search_Lucene_Search_QueryHit`` オブジェクトでは、 検索結果としてヒットした
``Zend_Search_Lucene_Document`` の各フィールドも公開しています。
この例で、ヒットしたドキュメントには title と author の 2
つのフィールドが含まれています。

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::open('/data/my_index');

   $hits = $index->find($query);

   foreach ($hits as $hit) {
       echo $hit->score;
       echo $hit->title;
       echo $hit->author;
   }

保存されたフィールドは、常に UTF-8 エンコーディングで返されます。

オプションで、 ``Zend_Search_Lucene_Search_QueryHit`` から元の ``Zend_Search_Lucene_Document``
を取得できます。 保存されたドキュメントを取得するには、
インデックスオブジェクトの *getDocument()* メソッドを使用し、その *getFieldValue()*
メソッドでフィールドの値を取得します。

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::open('/data/my_index');

   $hits = $index->find($query);
   foreach ($hits as $hit) {
       // ヒットした結果の Zend_Search_Lucene_Document オブジェクトを返します
       echo $document = $hit->getDocument();

       // Zend_Search_Lucene_Document から
       // Zend_Search_Lucene_Field オブジェクトを返します
       echo $document->getField('title');

       // Zend_Search_Lucene_Field オブジェクトを値を文字列で返します
       echo $document->getFieldValue('title');

       // getFieldValue() と同じです
       echo $document->title;
   }

``Zend_Search_Lucene_Document`` オブジェクトで使用可能なフィールドは、
インデックス化の際に決まります。ドキュメントのフィールドは、
インデックス化用アプリケーション (例えば LuceneIndexCreation.jar)
によってインデックス化、あるいはインデックス化して保存されます。

ドキュメントを識別するフィールド (例では 'path')
もインデックス化して取得できるようにしなければならないことに注意しましょう。

.. _zend.search.lucene.searching.results-limiting:

結果の制限
-----

検索処理の中でいちばん時間がかかるのが、スコアの計算です。 検索結果の数が多い
(数万件程度) 場合、これには数秒程度かかることもあります。

``Zend_Search_Lucene`` では、結果セットの件数を制限するためのメソッドとして
*getResultSetLimit()* と *setResultSetLimit()* を用意しています。

   .. code-block:: php
      :linenos:

      $currentResultSetLimit = Zend_Search_Lucene::getResultSetLimit();

      Zend_Search_Lucene::setResultSetLimit($newLimit);

0 (デフォルト値) は、'制限しない' という意味です。

このメソッドが返す結果は、'スコアの高いほうから N 件' ではなく あくまで '最初の
N 件'[#]_ です。

.. _zend.search.lucene.searching.results-scoring:

結果の重み付け
-------

``Zend_Search_Lucene`` は、Java Lucene と同じ重み付けアルゴリズムを使用します。
検索結果に一致したものが、デフォルトで重み順に並べ替えられます。スコアの高いものが先頭となり、
スコアの高いもののほうが低いものよりクエリにマッチするようになります。

大雑把に言うと、文書の中に検索語句が頻繁に登場するほどスコアが高くなります。

検索結果のスコアを取得するには *score* プロパティを使用します。

.. code-block:: php
   :linenos:

   $hits = $index->find($query);

   foreach ($hits as $hit) {
       echo $hit->id;
       echo $hit->score;
   }

重みを計算するために使用されるのが ``Zend_Search_Lucene_Search_Similarity``
クラスです。詳細は :ref:`拡張性 - 重み付けのアルゴリズム
<zend.search.lucene.extending.scoring>` を参照ください。

.. _zend.search.lucene.searching.sorting:

検索結果の並べ替え
---------

検索結果は、デフォルトではスコアで並べ替えられます。
これを変更するには、並べ替え用の (ひとつあるいは複数の)
フィールドと並べ替えの形式、そして並べ替えの方向をパラメータで指定します。

*$index->find()* のコール時に、オプションのパラメータを指定できます。

   .. code-block:: php
      :linenos:

      $index->find($query [, $sortField [, $sortType [, $sortOrder]]]
                          [, $sortField2 [, $sortType [, $sortOrder]]]
                   ...);



*$sortField* は、結果の並べ替えを行う保存されたフィールドの名前です。

*$sortType* は省略可能です。 *SORT_REGULAR* (通常の並べ替え。デフォルト)、 *SORT_NUMERIC*
(数値として並べ替え)、 *SORT_STRING* (文字列として並べ替え) のいずれかとなります。

*$sortOrder* は省略可能です。 *SORT_ASC* (昇順で並べ替え。デフォルト)、 *SORT_DESC*
(降順で並べ替え) のいずれかとなります。

例を以下に示します。

   .. code-block:: php
      :linenos:

      $index->find($query, 'quantity', SORT_NUMERIC, SORT_DESC);



   .. code-block:: php
      :linenos:

      $index->find($query, 'fname', SORT_STRING, 'lname', SORT_STRING);



   .. code-block:: php
      :linenos:

      $index->find($query, 'name', SORT_STRING, 'quantity', SORT_NUMERIC, SORT_DESC);



デフォルト以外の並び順を使用する際には注意しましょう。
並べ替えのためにはドキュメント全体をインデックスから読み込む必要があり、
検索のパフォーマンスが著しく低下してしまいます。

.. _zend.search.lucene.searching.highlighting:

検索結果の強調
-------

``Zend_Search_Lucene`` では、2 とおりの方法で検索結果を強調させることができます。

まず最初の方法が、 ``Zend_Search_Lucene_Document_Html`` クラス (詳細は :ref:`HTML
ドキュメントの節 <zend.search.lucene.index-creation.html-documents>` を参照ください)
を用いて次のようにすることです。

   .. code-block:: php
      :linenos:

      /**
       * テキストを指定した色で強調する
       *
       * @param string|array $words
       * @param string $colour
       * @return string
       */
      public function highlight($words, $colour = '#66ffff');



   .. code-block:: php
      :linenos:

      /**
       * テキストを、指定したビューヘルパーあるいはコールバック関数で強調する
       *
       * @param string|array $words  強調したい単語。配列あるいは文字列で指定します
       * @param callback $callback   コールバックメソッド。テキストの変換 (強調) に使用します
       * @param array    $params     コールバックのパラメータとして渡す配列
       *                             (最初の必須パラメータは、強調させる HTML 片となります)
       * @return string
       * @throws Zend_Search_Lucene_Exception
       */
      public function highlightExtended($words, $callback, $params = array())



強調方法をカスタマイズするには *highlightExtended()*
メソッドにコールバックを指定して使用します。このコールバックは、ひとつ以上のパラメータを受け取ります
[#]_\ 。 あるいは、 ``Zend_Search_Lucene_Document_Html`` クラスを継承して
*applyColour($stringToHighlight, $colour)* メソッドを再定義することもできます。
このメソッドは、デフォルトの強調コールバックとして用いられるものです。 [#]_

:ref:`ビューヘルパー <zend.view.helpers>`
も、ビュースクリプトのコンテキストでコールバックとして使えます。

   .. code-block:: php
      :linenos:

      $doc->highlightExtended('word1 word2 word3...', array($this, 'myViewHelper'));



強調した結果を取得するには *Zend_Search_Lucene_Document_Html->getHTML()*
メソッドを使用します。

.. note::

   強調処理は、現在の解析器を使って行われます。つまり、解析器が理解するすべての形式の単語が強調されます。

   たとえば、大文字小文字を区別しない解析器を使っている場合に 'text'
   を強調するよう指定すると、 'text' や 'Text' そして 'TEXT'
   といった単語も強調されます。

   同様に、語幹抽出機能を持つ解析器を使っている場合に 'indexed'
   を強調するよう指定すると、 'index' や 'indexing' そして 'indices'
   といった単語も強調されます。

   一方、現在の解析器が処理をスキップするような単語
   (短い単語に対するフィルタが解析器に適用されている場合など)
   は、なにも強調されません。

もうひとつの方法は、 *Zend_Search_Lucene_Search_Query->highlightMatches(string $inputHTML[,
Zend_Search_Lucene_Search_Highlighter_Interface $highlighter])* メソッドを使うことです。

   .. code-block:: php
      :linenos:

      $query = Zend_Search_Lucene_Search_QueryParser::parse($queryStr);
      $highlightedHTML = $query->highlightMatches($sourceHTML);



オプションの 2 番目のパラメータは、 デフォルトの HTML
ドキュメントエンコーディングです。 省略した場合は、Content-type HTTP-EQUIV meta
タグを使用します。

オプションの 3 番目のパラメータは、 ``Zend_Search_Lucene_Search_Highlighter_Interface``
インターフェイスを実装したオブジェクトです。

   .. code-block:: php
      :linenos:

      interface Zend_Search_Lucene_Search_Highlighter_Interface
      {
          /**
           * 強調対象の文書を設定します
           *
           * @param Zend_Search_Lucene_Document_Html $document
           */
          public function setDocument(Zend_Search_Lucene_Document_Html $document);

          /**
           * 強調対象の文書を取得します
           *
           * @return Zend_Search_Lucene_Document_Html $document
           */
          public function getDocument();

          /**
           * 指定した単語を強調します (サブクエリ単位でこのメソッドが起動されます)
           *
           * @param string|array $words  強調したい単語。配列あるいは文字列で指定します
           */
          public function highlight($words);
      }

ここでの ``Zend_Search_Lucene_Document_Html`` オブジェクトは、
``Zend_Search_Lucene_Search_Query->highlightMatches()`` メソッドに渡された HTML
から作成されるオブジェクトです。

*$highlighter* パラメータを省略すると、 ``Zend_Search_Lucene_Search_Highlighter_Default``
オブジェクトのインスタンスを作成してそれを使用します。

*highlight()* メソッドはサブクエリ単位で起動されるので、
サブクエリ単位で異なる強調処理を行うことができます。

実際のところ、デフォルトの処理は定義済みの色テーブルを使用しているだけです。
自前の強調処理を実装することもできますし、デフォルトの処理を継承して色テーブルだけを再定義することもできます。

*Zend_Search_Lucene_Search_Query->htmlFragmentHighlightMatches()*
も同じような動きをします。唯一の違いは、入力を受け取って、 <>HTML>, <HEAD>, <BODY>
tags タグを含まない HTML 片を返すことです。 それでも、返される HTML
片は自動的に正しい *XHTML* に変換されます.



.. [#] しかし、返される結果はスコア順 (あるいはその他指定した順)
       で並べ替えられています。
.. [#] 最初のパラメータは強調対象の HTML 片、
       そしてその他のパラメータはコールバックの振る舞いによって変わります。
       返り値は、強調済みの HTML 片となります。
.. [#] どちらの場合についても、返される HTML は自動的に正しい *XHTML*
       形式に変換されます。