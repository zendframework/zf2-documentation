.. _zend.search.lucene.best-practice:

ベストプラクティス
=========

.. _zend.search.lucene.best-practice.field-names:

フィールド名
------

``Zend_Search_Lucene`` では、フィールド名に関する制限は特にありません。

しかし、できれば '**id**' および '**score**'
という名前は使用を控えるようにしましょう。 これらを使用すると、 *QueryHit*
のプロパティ名と区別しにくくなります。

``Zend_Search_Lucene_Search_QueryHit`` のプロパティ *id* と *score* はそれぞれ、Lucene
ドキュメントが内部で使用する ID、検索結果の :ref:`スコア
<zend.search.lucene.searching.results-scoring>`
を表します。もしドキュメントでこれらと同じ名前のフィールドを使っているのなら、
そのフィールドにアクセスするには ``getDocument()`` メソッドを使う必要があります。

   .. code-block:: php
      :linenos:

      $hits = $index->find($query);

      foreach ($hits as $hit) {
          // 'title' フィールドを取得します
          $title = $hit->title;

          // 'contents' フィールドを取得します
          $contents = $hit->contents;

          // Lucene ドキュメントの内部 ID を取得します
          $id = $hit->id;

          // 検索結果のスコアを取得します
          $score = $hit->score;

          // 'id' フィールドを取得します
          $docId = $hit->getDocument()->id;

          // 'score' フィールドを取得します
          $docId = $hit->getDocument()->score;

          // 'title' フィールドもこの方法で取得できます
          $title = $hit->getDocument()->title;
      }



.. _zend.search.lucene.best-practice.indexing-performance:

インデックス作成のパフォーマンス
----------------

インデックス作成のパフォーマンスは、 リソースの消費量と所要時間、
そしてインデックスの品質との兼ね合いで決まります。

インデックスの品質とは、要するにインデックスセグメントの数のことです。

各インデックスセグメントはデータ部とは独立しています。
つまり、インデックスに含まれるセグメントが多くなればなるほど
検索に要するメモリと時間は増加します。

インデックスの最適化を行うと、
複数のセグメントをまとめて新しいひとつのセグメントを作成します。
完全に最適化されたインデックスは、セグメントひとつだけで構成されます。

インデックスの最適化を行うには ``optimize()`` メソッドを使用します。

   .. code-block:: php
      :linenos:

      $index = Zend_Search_Lucene::open($indexPath);

      $index->optimize();



インデックスの最適化はデータストリーム上で行われるので、
それほどメモリは消費しません。ただ、CPU
リソースをかなり消費し、時間もかかります。

Lucene のインデックスセグメントは、その性質上 更新はできません (更新するには、
セグメントファイルを新たに作りなおす必要があります)。
したがって、新しいドキュメントがインデックスに追加されるたびに
新しいセグメントが作成されることになります。
その結果、インデックスの品質は下がっていきます。

セグメントが作成されるたびにインデックスの自動最適化が行われ、
一部のセグメントは自動的にマージされます。

自動最適化の設定は、次の 3 つのオプションで変更できます
(:ref:`インデックスの最適化 <zend.search.lucene.index-creation.optimization>` を参照ください)。

   - **MaxBufferedDocs** は、メモリ内のバッファに保持されるドキュメントの最大数です。
     この数を超えると、新しいセグメントを作成して
     ハードディスクに書き込みます。

   - **MaxMergeDocs**
     は、自動最適化によって新しいセグメントへのマージを行う基準となる
     ドキュメント数です。

   - **MergeFactor** は、自動最適化を行う頻度を指定します。



   .. note::

      これらのオプションはすべて ``Zend_Search_Lucene``
      オブジェクトのプロパティであり、インデックスのプロパティではありません。
      したがって、この設定は現在使用中の ``Zend_Search_Lucene``
      オブジェクトに対してのみ働くようになり、
      スクリプトによって設定は異なります。



**MaxBufferedDocs** は、
スクリプトを一回実行するたびにひとつのドキュメントしか扱わない場合は
何の影響も及ぼしません。
逆に、バッチ処理の場合にはこの設定が非常に重要になります。
値を大きくするとインデックス作成の速度が上がりますが、
同時に大量のメモリを消費するようになります。

**MaxBufferedDocs** パラメータの値として最適なものを計算する公式はありません。
これはドキュメントのサイズや解析器、使用できるメモリ量などに依存するからです。

最適な設定値を取得するには、
扱うであろうドキュメントの中で最もサイズが大きいものを用いて
何度かテストをしてみましょう [#]_\ 。
使用可能なメモリのうち半分を超えない程度のメモリ消費量に抑えておくことをお勧めします。

**MaxMergeDocs** はセグメントの大きさ
(これはドキュメントの大きさによって決まります) を制限します。
これにより、自動最適化の時間を短縮できます。 つまり、 ``addDocument()`` メソッドが
ある時間以上は実行されなくなります。
これは、対話的なアプリケーションで重要になります。

**MaxMergeDocs** の設定値を小さくすると、 バッチ処理のパフォーマンスもあがります。
インデックスの自動最適化は対話的な処理であり、
ひとつひとつ順を追って実行していきます。
小さなセグメントたちがひとつの大きなセグメントにまとめられ、
さらにまたそれが他のセグメントとまとまってより大きなセグメントになり、
といった具合です。インデックスの最適化を完全に行うと、
処理が非常に効率的になります。

セグメントのサイズを小さくするとインデックスの品質が下がり、
大量のセグメントができあがってしまいます。場合によっては、OS
の制限に引っかかって "オープンしているファイルが多すぎる"
というエラーが発生するかもしれません [#]_\ 。

したがって、バックグラウンドでのインデックスの最適化は対話モードで行い、
バッチ処理用の **MaxMergeDocs**
はあまり小さくしすぎないようにしなければなりません。

**MergeFactor** は自動最適化の頻度に影響を及ぼします。
値を小さくすると、最適化されていないインデックスの品質が上がります。
値を大きくするとインデックス作成の策度が上がりますが、
セグメントの数も増えます。何度も言いますが、これは
"オープンしているファイルが多すぎる" エラーの原因となりえます。

**MergeFactor** は、以下の条件を満たす大きさで
インデックスセグメントをグループ化します。

   . **MaxBufferedDocs** 以下

   . **MaxBufferedDocs** より大きいが **MaxBufferedDocs**\ * **MergeFactor** を超えない

   . **MaxBufferedDocs**\ * **MergeFactor** より大きいが **MaxBufferedDocs**\ * **MergeFactor**\ *
     **MergeFactor** を超えない

   . ...



Zend_Search_Lucene は、 ``addDocument()`` をコールするたびにセグメントの状況を調べ、
いくつかのセグメントをまとめて次のグループの新しいセグメントに移動できるかどうかを確認します。
できる場合はマージを行います。

つまり、N 個のグループからなるインデックスには **MaxBufferedDocs** + (N-1)* **MergeFactor**
のセグメントが含まれ、少なくとも **MaxBufferedDocs**\ * **MergeFactor** :sup:`(N-1)`
のドキュメントが存在することになります。

この式で、インデックス内のセグメントの概数を求めることができます。

**NumberOfSegments** <= **MaxBufferedDocs** + **MergeFactor**\ *log **MergeFactor**
(**NumberOfDocuments**/**MaxBufferedDocs**)

**MaxBufferedDocs** は、使用できるメモリ量によって決まります。 MergeFactor
を適切に設定することで、セグメントの数を調整できます。

バッチ処理においては、 **MergeFactor** パラメータを調整するほうが **MaxMergeDocs**
を調整するよりも効率的です。しかし、微調整はできず大雑把なものとなります。
そこで、まず上の公式をもとに **MergeFactor** を調整し、 それから **MaxMergeDocs**
を微調整してパフォーマンスを最適化しましょう。

.. _zend.search.lucene.best-practice.shutting-down:

インデックスの終了時処理
------------

``Zend_Search_Lucene`` オブジェクトは、 終了時にちょっとした作業を行います。
これは、インデックスにドキュメントが追加されたけれども
新しいセグメントに書き込まれていないという場合に行われます。

また、場合によっては自動最適化も行います。

インデックスオブジェクトは、自分自身および QueryHit
オブジェクトがすべてスコープ外に出た時点で自動的に終了処理を行います。

インデックスオブジェクトがグローバル変数に格納されている場合は、
スクリプトの終了時に破棄されます [#]_\ 。

*PHP* の例外処理もここで終了します。

これは通常のインデックス終了処理を妨げることはありませんが、
何かエラーが発生した際に正しいエラー情報を取得できなくなる可能性があります。

この問題を回避する方法はふたつあります。

まずは、強制的にスコープ外に出す方法です。

   .. code-block:: php
      :linenos:

      $index = Zend_Search_Lucene::open($indexPath);

      ...

      unset($index);


そしてもうひとつは、スクリプトの終了前にコミット操作を行うことです。

   .. code-block:: php
      :linenos:

      $index = Zend_Search_Lucene::open($indexPath);

      $index->commit();

これについては、このドキュメントの ":ref:`応用:
静的プロパティとしてのインデックスの使用 <zend.search.lucene.advanced.static>`"
でも説明しています。

.. _zend.search.lucene.best-practice.unique-id:

一意な ID によるドキュメントの取得
-------------------

ドキュメントの一意な ID、たとえば URL やパス、データベース上の ID
などをインデックスに保存しておくとよいでしょう。

``Zend_Search_Lucene`` には ``termDocs()``
というメソッドがあり、指定した単語を含むドキュメントを取得できます。

これは ``find()`` メソッドよりも効率的です。

   .. code-block:: php
      :linenos:

      // find() メソッドでクエリ文字列を指定することによるドキュメントの取得
      $query = $idFieldName . ':' . $docId;
      $hits  = $index->find($query);
      foreach ($hits as $hit) {
          $title    = $hit->title;
          $contents = $hit->contents;
          ...
      }
      ...

      // find() メソッドでクエリ API を使用することによるドキュメントの取得
      $term = new Zend_Search_Lucene_Index_Term($docId, $idFieldName);
      $query = new Zend_Search_Lucene_Search_Query_Term($term);
      $hits  = $index->find($query);
      foreach ($hits as $hit) {
          $title    = $hit->title;
          $contents = $hit->contents;
          ...
      }

      ...

      // termDocs() メソッドによるドキュメントの取得
      $term = new Zend_Search_Lucene_Index_Term($docId, $idFieldName);
      $docIds  = $index->termDocs($term);
      foreach ($docIds as $id) {
          $doc = $index->getDocument($id);
          $title    = $doc->title;
          $contents = $doc->contents;
          ...
      }



.. _zend.search.lucene.best-practice.memory-usage:

メモリの使用法
-------

``Zend_Search_Lucene`` は、比較的メモリを消費するモジュールです。

各種の情報をキャッシュしたり、検索やインデックス作成の速度を上げたりするために、メモリを使用しています。

メモリに関する挙動は、モードによって異なります。

単語辞書のインデックスは、検索時にメモリに読み込まれます。
これは、実際の辞書に登録されている単語が 128件 [#]_ に達するごとに作成されます。

したがって、単語の数が増えれば増えるほどメモリの消費量も増加します。
トークン化していないフレーズをフィールドの値として使用したり、
テキスト以外の情報を大量にインデックスとして使用したりすると、
単語の数が増えることになります。

最適化されていないインデックスは、複数のセグメントで構成されます。
これも、メモリ消費量の増加の要因となります。
各セグメントは独立しているので、それぞれ独自に単語辞書と辞書インデックスを持っています。
ひとつのインデックスの中に **N** 個のセグメントがあったとすると、
メモリの消費量は最悪で **N** 倍になってしまいます。
インデックスの最適化を行ない、セグメントをひとつにまとめましょう。

インデックスは、検索処理とドキュメントのバッファリングに同じメモリを使用します。
このメモリの使用量は、パラメータ **MaxBufferedDocs** で指定します。

インデックスの最適化 (完全最適化、部分最適化の両方)
はストリーム上で行なわれるので、あまりメモリを消費しません。

.. _zend.search.lucene.best-practice.encoding:

エンコーディング
--------

``Zend_Search_Lucene`` は、内部で UTF-8 文字列を使用しています。
したがって、Zend_Search_Lucene が返す文字列は、すべて UTF-8
でエンコードされています。

単なる *ASCII*
データのみを扱うのであればエンコーディングを気にする必要はありません。
しかしそれ以外の場合は要注意です。

間違ったエンコーディングを使用すると、
エンコーディングの変換時にエラーが発生したりデータを失ってしまったりする可能性があります。

``Zend_Search_Lucene``
は、ドキュメントやクエリのエンコーディングとしてさまざまなものに対応しています。

フィールドを作成するメソッドで、エンコーディングをオプションのパラメータによって指定できます。


   .. code-block:: php
      :linenos:

      $doc = new Zend_Search_Lucene_Document();
      $doc->addField(Zend_Search_Lucene_Field::Text('title',
                                                    $title,
                                                    'iso-8859-1'));
      $doc->addField(Zend_Search_Lucene_Field::UnStored('contents',
                                                        $contents,
                                                        'utf-8'));

エンコーディングの指定をはっきりさせるという意味で、これが最も良い方法です。

このエンコーディング指定を省略すると、現在のロケールをもとに判断を行ないます。
ロケールの指定時に、言語だけでなく文字セットも指定できます。

   .. code-block:: php
      :linenos:

      setlocale(LC_ALL, 'fr_FR');
      ...

      setlocale(LC_ALL, 'de_DE.iso-8859-1');
      ...

      setlocale(LC_ALL, 'ja_JP.UTF-8');
      ...



クエリ文字列のエンコーディングも、同じ方式で指定します。

エンコーディングを何らかの方法で指定しなかった場合は、
現在のロケールにもとづいて判断を行ないます。

検索の前にクエリのパースを行なう場合、
エンコーディングはオプションのパラメータとして指定できます。

   .. code-block:: php
      :linenos:

      $query =
          Zend_Search_Lucene_Search_QueryParser::parse($queryStr, 'iso-8859-5');
      $hits = $index->find($query);
      ...



デフォルトのエンコーディングを指定するには ``setDefaultEncoding()``
メソッドを使用します。

   .. code-block:: php
      :linenos:

      Zend_Search_Lucene_Search_QueryParser::setDefaultEncoding('iso-8859-1');
      $hits = $index->find($queryStr);
      ...

空の文字列は、'現在のロケール' を意味します。

正しいエンコーディングを指定すれば、解析器はそれを正しく処理できます。
実際の挙動は、使用する解析器によって異なります。詳細は :ref:`文字セット
<zend.search.lucene.charset>` についての説明を参照ください。

.. _zend.search.lucene.best-practice.maintenance:

インデックスの保守
---------

まずはっきりさせておくべきなのは、 ``Zend_Search_Lucene`` やその他の Lucene
実装は決して "データベース" ではないということです。

つまり、データを保存するものとして使用してはいけません。
通常のデータベース管理システムのように、バックアップ/リストア
やジャーナル処理、ログの記録、トランザクションといった機能は持っていません。

しかし、 ``Zend_Search_Lucene``
はインデックスの一貫性を保持するための機能は持っています。

インデックスのバックアップ/リストアは、オフラインでインデックスフォルダをコピーすることで行ないます。

何らかの理由でインデックスが壊れてしまった場合は、
インデックスをリストアするか再構築しなければなりません。

そこで、大きなインデックスは、どこかに手動でバックアップしておき、
何かあったときに手動で復元できるようにしておきましょう。
そうすれば、障害からの復旧にかかる時間が短縮できます。



.. [#] ``memory_get_usage()`` や ``memory_get_peak_usage()`` で、メモリの使用量を確認します。
.. [#] ``Zend_Search_Lucene``
       は、セグメントファイルをずっとオープンしたままにしておきます。
       これによって検索の効率を上げています。
.. [#] インデックスや QueryHit
       オブジェクトが複合データ型から参照されている場合にもこれは起こりえます。
       たとえば、循環参照を含むオブジェクトはスクリプトの終了時まで破棄されません。
.. [#] Lucene
       のファイルフォーマットでは、この件数を変更することもできます。しかし
       ``Zend_Search_Lucene`` の *API* ではそれをサポートしていません。 別の Lucene
       実装を使用してインデックスをサポートすれば、
       この値を変更することも可能です。