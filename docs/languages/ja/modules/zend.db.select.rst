.. _zend.db.select:

Zend_Db_Select
==============

.. _zend.db.select.introduction:

導入
--

``Zend_Db_Select`` オブジェクトは、 *SQL* の *SELECT* 文を表すものです。
このクラスには、クエリの各部分を追加するためのメソッドが用意されています。
*PHP* のメソッドやデータをもとにクエリの各部分を指定すると、 このクラスが正確な
*SQL* 文を作成してくれます。クエリを作成したら、
あとは通常の文字列と同じようにそれを用いてクエリを実行できます。

``Zend_Db_Select`` は次のような機能を提供します。

- *SQL* クエリを少しずつ組み立てていくための オブジェクト指向のメソッド

- *SQL* クエリの一部について、データベースに依存しない抽象化

- 大半のメタデータ識別子の自動クォート処理による、 予約語や特殊文字を含む *SQL*
  のサポート

- 識別子や値のクォートによる、 *SQL* インジェクション攻撃対策

必ず ``Zend_Db_Select`` を使わなければならないというわけではありません。 単純な SELECT
クエリを実行するのなら、 *SQL* クエリ全体を文字列で指定し、 アダプタの ``query()``
メソッドや ``fetchAll()`` メソッドを使用したほうがずっとシンプルになるでしょう。
``Zend_Db_Select`` を使うと便利なのは、
何らかの条件にもとづいて、アプリケーション内で SELECT
クエリを動的に組み立てていく必要があるような場合です。

.. _zend.db.select.creating:

Select オブジェクトの作成
----------------

``Zend_Db_Select`` オブジェクトのインスタンスを作成するには、 ``Zend_Db_Adapter_Abstract``
オブジェクトの ``select()`` メソッドを使用します。

.. _zend.db.select.creating.example-db:

.. rubric:: データベースアダプタの select() メソッドの例

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory( ...options... );
   $select = $db->select();

``Zend_Db_Select`` オブジェクトを作成するもうひとつの方法は、
コンストラクタの引数でデータベースアダプタを指定することです。

.. _zend.db.select.creating.example-new:

.. rubric:: 新しい Select オブジェクトの作成の例

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory( ...options... );
   $select = new Zend_Db_Select($db);

.. _zend.db.select.building:

Select クエリの作成
-------------

クエリを作成する際に、クエリの句を個別に追加していくことができます。
``Zend_Db_Select`` オブジェクトには、
個々の句を追加していくメソッドが用意されています。

.. _zend.db.select.building.example:

.. rubric:: メソッドを使用して句を追加する例

.. code-block:: php
   :linenos:

   // Zend_Db_Select オブジェクトを作成します
   $select = $db->select();

   // FROM 句を追加します
   $select->from( ...テーブルとカラムを指定します... )

   // WHERE 句を追加します
   $select->where( ...検索条件を指定します... )

   // ORDER BY 句を追加します
   $select->order( ...ソート条件を指定します... );

``Zend_Db_Select`` オブジェクトの大半のメソッドで、便利な
「流れるようなインターフェイス」形式を利用できます。これは、
各メソッドが、自分自身への参照を結果として返すということです。
つまり、その結果を使用してすぐに別のメソッドをコールできるのです。

.. _zend.db.select.building.example-fluent:

.. rubric:: 流れるようなインターフェイスの使用例

.. code-block:: php
   :linenos:

   $select = $db->select()
       ->from( ...テーブルとカラムを指定します... )
       ->where( ...検索条件を指定します... )
       ->order( ...ソート条件を指定します... );

この節の例では流れるようなインターフェイスを使用しますが、
この方式を使用せずに使用することも可能です。
そうしなければならないこともよくあるでしょう。たとえば、
クエリに句を追加する前にアプリケーションで何らかの処理が必要な場合などです。

.. _zend.db.select.building.from:

FROM 句の追加
^^^^^^^^^

このクエリのテーブルを指定するために ``from()``
メソッドを使用します。テーブル名は、単純に文字列で指定できます。 ``Zend_Db_Select``
はテーブル名を識別子としてクォートするので、
特殊文字を使用することもできます。

.. _zend.db.select.building.from.example:

.. rubric:: from() メソッドの例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT *
   //   FROM "products"

   $select = $db->select()
                ->from( 'products' );

テーブルの相関名 (あるいは "エイリアス" とも言われます)
を指定することもできます。その場合は、
単純な文字列ではなく連想配列を使用し、相関名とテーブル名の対応を指定します。
*SQL* のその他の句で、この相関名を使用できるようになります。
複数のテーブルを結合したクエリを作成する場合は、 ``Zend_Db_Select``
はそのテーブル名に基づいた一意な相関名を作成します。

.. _zend.db.select.building.from.example-cname:

.. rubric:: テーブルの相関名を指定する例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT p.*
   //   FROM "products" AS p

   $select = $db->select()
                ->from( array('p' => 'products') );

*RDBMS*
によっては、テーブル名の前にスキーマ名をつなげる方式をサポートしているものもあります。
テーブル名として、"*schemaName.tableName*" のように指定できます。この場合、
``Zend_Db_Select`` は各部分を個別にクォートします。
あるいはスキーマ名とテーブル名を別々に指定することもできます。
もし両方でスキーマ名を指定した場合は、
テーブル名と同時に指定したもののほうが優先されます。

.. _zend.db.select.building.from.example-schema:

.. rubric:: スキーマ名の指定の例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT *
   //   FROM "myschema"."products"

   $select = $db->select()
                ->from( 'myschema.products' );

   // あるいは

   $select = $db->select()
                ->from('products', '*', 'myschema');

.. _zend.db.select.building.columns:

カラムの追加
^^^^^^

``from()`` メソッドの二番目の引数で、
対応するテーブルから取得するカラムを指定できます。
カラムを指定しなかった場合のデフォルトは "***" で、これは "すべてのカラム"
を表す *SQL* のワイルドカードです。

カラム名を指定するには、単純な文字列の配列を使用するか、
あるいは連想配列でエイリアスとカラム名を対応させます。
取得したいカラムがひとつだけの場合でエイリアスを使用しない場合は、
配列ではなく単純な文字列で指定することもできます。

空の配列をカラムの引数として指定すると、
対応するテーブルからのカラムは結果セットに含まれなくなります。 ``join()``
メソッドの :ref:`コード例 <zend.db.select.building.join.example-no-columns>` を参照ください。

カラム名を "*correlationName.columnName*" の形式で指定することもできます。この場合、
``Zend_Db_Select`` は各部分を個別にクォートします。 カラムの correlationName (相関名)
を指定しなかった場合は、 現在の ``from()``
メソッドで指定したテーブルの名前を使用します。

.. _zend.db.select.building.columns.example:

.. rubric:: カラムを指定する例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'));

   // 同じクエリを、相関名を指定して作成します
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('p.product_id', 'p.product_name'));

   // このクエリを、カラムのひとつにエイリアスを指定して作成します
   //   SELECT p."product_id" AS prodno, p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('prodno' => 'product_id', 'product_name'));

.. _zend.db.select.building.columns-expr:

式によるカラムの追加
^^^^^^^^^^

*SQL* クエリでは、単にテーブルのカラムを使用するだけでなく
何らかの式をカラムとして使用することもあります。
このような場合は、相関名をつけたりクォートを適用したりしてはいけません。
カラム文字列に括弧が含まれている場合に、 ``Zend_Db_Select``
はそれを式として扱います。

``Zend_Db_Expr`` 型のオブジェクトを明示的に作成し、
文字列がカラム名と解釈されてしまうことを防ぐこともできます。 ``Zend_Db_Expr``
は、文字列をひとつだけ含む最小限のクラスです。 ``Zend_Db_Select`` は *Zend_Db_Expr*
型のオブジェクトを認識し、 それを文字列に変換しますが、
その際にクォートや相関名などの処理を適用しません。

.. note::

   カラムとして使用する式に括弧が含まれている場合は、 カラム名で ``Zend_Db_Expr``
   を指定する必要はありません。 ``Zend_Db_Select``
   は、括弧を発見すると自動的にその文字列を式として扱います。
   クォートや相関名の設定はされません。

.. _zend.db.select.building.columns-expr.example:

.. rubric:: 式を含むカラムの指定の例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT p."product_id", LOWER(product_name)
   //   FROM "products" AS p
   // 括弧つきの式は、暗黙のうちに
   // Zend_Db_Expr として扱われます

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'LOWER(product_name)'));

   // できあがるクエリは、このようになります
   //   SELECT p."product_id", (p.cost * 1.08) AS cost_plus_tax
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id',
                             'cost_plus_tax' => '(p.cost * 1.08)')
                      );

   // このクエリを、明示的に Zend_Db_Expr を指定して作成します
   //   SELECT p."product_id", p.cost * 1.08 AS cost_plus_tax
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id',
                             'cost_plus_tax' =>
                                 new Zend_Db_Expr('p.cost * 1.08'))
                       );

上の例では、 ``Zend_Db_Select`` は
相関名の設定や識別子のクォートといった処理を行いません。
あいまいさを解決するためにそのような処理が必要な場合は、
手動で文字列を変更する必要があります。

カラム名が *SQL* キーワードや特殊文字を含んでいる場合は、 アダプタの
``quoteIdentifier()`` メソッドを使用して結果を操作する必要があります。
``quoteIdentifier()`` は、 識別子に対して *SQL* のクォート処理を行います。
これによりテーブルやカラムといった識別子を *SQL*
のそれ以外の部分と区別できるようになります。

クォート処理を直接文字列に埋め込んでしまわずに ``quoteIdentifier()``
メソッドを使用することで、
あなたのコードをデータベースに依存しないものにできます。 というのも、 *RDBMS*
によってはあまり標準的ではない文字でクォートを行うものもあるからです。
``quoteIdentifier()`` メソッドは、
アダプタの型に応じて適切なクォート文字を使用するように設計されています。
``quoteIdentifier()`` メソッドはまた、
識別子の名前の中に登場するクォート文字自体もエスケープします。

.. _zend.db.select.building.columns-quoteid.example:

.. rubric:: 式の中のカラムをクォートする例

.. code-block:: php
   :linenos:

   // このクエリを作成する際に、式の中にある特別なカラム名 "from" をクォートします
   //   SELECT p."from" + 10 AS origin
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('origin' =>
                                 '(p.' . $db->quoteIdentifier('from') . ' + 10)')
                      );

.. _zend.db.select.building.columns-atomic:

既存の FROM あるいは JOIN テーブルへのカラムの追加
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

既存の FROM や JOIN のテーブルに対して、それらのメソッドをコールした後で
カラムを追加したくなることもあるかもしれません。 ``columns()``
メソッドを使用すると、
クエリを実行する前ならいつでも好きなときに特定のカラムを追加できます。
カラムは、文字列あるいは ``Zend_Db_Expr``\ 、 あるいはその配列で指定します。
このメソッドの 2 番目の引数は省略可能です。 省略した場合は、FROM
テーブルにカラムが追加されます。
指定する場合は、既存の相関名を使用しなければなりません。

.. _zend.db.select.building.columns-atomic.example:

.. rubric:: columns() メソッドでカラムを追加する例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'), 'product_id')
                ->columns('product_name');

   // 同じクエリを、相関名を指定して作成します
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->from(array('p' => 'products'), 'p.product_id')
                ->columns('product_name', 'p');
                // あるいは columns('p.product_name')

.. _zend.db.select.building.join:

JOIN による、クエリへの別のテーブルの追加
^^^^^^^^^^^^^^^^^^^^^^^

有用なクエリの多くは、 *JOIN* を使用して複数テーブルの行を結合しています。
テーブルを ``Zend_Db_Select`` クエリに追加するには、 ``join()`` メソッドを使用します。
このメソッドの使用法は ``from()``
メソッドと似ていますが、ほとんどの場合に結合条件を指定するという点が異なります。

.. _zend.db.select.building.join.example:

.. rubric:: join() メソッドの例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT p."product_id", p."product_name", l.*
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id');

``join()`` の二番目の引数として、 結合条件を文字列で指定します。これは、
あるテーブルの行が別のテーブルのどの行と対応するのかを表す条件式です。
式の中では相関名を使用できます。

.. note::

   結合条件に指定した式に関しては、クォート処理は行われません。
   クォートする必要のあるカラム名を使用する場合は、
   結合条件の文字列を作成する際に ``quoteIdentifier()`` を使用しなければなりません。

``join()`` の三番目の引数はカラム名を表す配列です。 これは ``from()``
メソッドで使用する形式と似ています。 デフォルトは "***" です。 相関名や式、
``Zend_Db_Expr`` についての扱いは、 ``from()``
メソッドにおけるカラム名の配列と同じです。

テーブルからカラムを取得しない場合は、 カラムリストに空の配列を使用します。
これは ``from()`` メソッドでも同様に動作しますが、
普通は最初のテーブルからは何らかのカラムを取得するでしょう。
一方、連結するテーブルについてはカラムを取得しないこともありえます。

.. _zend.db.select.building.join.example-no-columns:

.. rubric:: カラムを指定しない例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array() ); // 空のカラムリスト

上の例で、連結したテーブルのカラム一覧の場所に 空の配列 ``array()``
を指定していることに注意しましょう。

*SQL* の結合にはいくつかの形式があります。 以下に、 ``Zend_Db_Select``
がサポートする結合の形式をまとめます。

- ``join(table, join, [columns])`` メソッドあるいは ``joinInner(table, join, [columns])``
  メソッドによる ``INNER JOIN``

  これはもっとも一般的な結合形式です。各テーブルの行を、
  指定した結合条件に基づいて比較します。
  結果セットには、その結合条件を満たす行のみが含まれます。
  条件を満たす行がない場合は、結果セットが空になることもあります。

  すべての *RDBMS* が、この結合形式に対応しています。

- ``joinLeft(table, condition, [columns])`` メソッドによる ``LEFT JOIN``

  左側のテーブルのすべての行と
  右側のテーブルの条件にマッチする行が含まれます。
  右側のテーブルからのカラムのうち、
  左側のテーブルに対応する行がないものについては ``NULL`` で埋められます。

  すべての *RDBMS* が、この結合形式に対応しています。

- ``joinRight(table, condition, [columns])`` メソッドによる ``RIGHT JOIN``

  右外部結合は、左外部結合を補完するものです。 右側のテーブルのすべての行と
  左側のテーブルの条件にマッチする行が含まれます。
  左側のテーブルからのカラムのうち、
  右側のテーブルに対応する行がないものについては ``NULL`` で埋められます。

  *RDBMS* によっては、この結合形式に対応していないものもあります。
  しかし、一般に右外部結合は、
  テーブルの順番を入れ替えれば左外部結合として表すことが可能です。

- ``joinFull(table, condition, [columns])`` メソッドによる ``FULL JOIN``

  完全外部結合は、左外部結合と右外部結合を組み合わせたようなものです。
  両側のテーブルのすべての行が含まれます。
  結合条件を満たす組み合わせがあった場合はそれらが同一行にまとめられ、
  それ以外の場合は、対応するデータがないカラムについては ``NULL``
  で埋められます。

  *RDBMS* によっては、この結合形式に対応していないものもあります。

- ``joinCross(table, [columns])`` メソッドによる ``CROSS JOIN``

  クロス結合とは、デカルト積のことです。 最初のテーブルの各行に対して、
  二番目のテーブルのすべての行がマッチします。 つまり、結果セットの行数は、
  ふたつのテーブルの行数の積と等しくなります。
  結果セットをフィルタリングするには、WHERE 句で条件を指定します。
  この方法によるクロス結合は、昔の SQL-89 の結合構文と似ています。

  ``joinCross()`` メソッドには、 結合条件を指定するパラメータがありません。 *RDBMS*
  によっては、この結合形式に対応していないものもあります。

- ``joinNatural(table, [columns])`` メソッドによる ``NATURAL JOIN``

  自然結合は、両方のテーブルに同じ名前で登場するカラムを比較します。
  比較はすべてのカラムに対して行われます。 この *API*
  でサポートしているのは、自然内部結合のみです。 *SQL*
  で自然外部結合がサポートされていたとしても、使用できません。

  ``joinNatural()`` メソッドには、 結合条件を指定するパラメータはありません。

これらの結合メソッドに加え、クエリを単純にするために JoinUsing
メソッドを使用できます。完全な結合条件を渡すかわりに、
単純に結合するカラム名の配列を渡してやれば ``Zend_Db_Select``
オブジェクトが結合条件を作成してくれます。

.. _zend.db.select.building.joinusing.example:

.. rubric:: joinUsing() メソッドの例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT *
   //   FROM "table1"
   //   JOIN "table2"
   //   ON "table1".column1 = "table2".column1
   //   WHERE column2 = 'foo'

   $select = $db->select()
                ->from('table1')
                ->joinUsing('table2', 'column1')
                ->where('column2 = ?', 'foo');
``Zend_Db_Select`` の結合メソッドには、 それぞれ対応する 'using' メソッドがあります。

- ``joinUsing(table, join, [columns])`` および ``joinInnerUsing(table, join, [columns])``

- ``joinLeftUsing(table, join, [columns])``

- ``joinRightUsing(table, join, [columns])``

- ``joinFullUsing(table, join, [columns])``

.. _zend.db.select.building.where:

WHERE 句の追加
^^^^^^^^^^

結果セットの行を制限するための条件を指定するには ``where()``
メソッドを使用します。 このメソッドの最初の引数は *SQL* の式で、これをクエリの
*SQL* で *WHERE* 句として使用します。

.. _zend.db.select.building.where.example:

.. rubric:: where() メソッドの例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE price > 100.00

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('price > 100.00');
.. note::

   ``where()`` メソッドや ``orWhere()``
   メソッドで指定する式にはクォート処理は行われません。
   クォートする必要のあるカラム名を使用する場合は、 条件の文字列を作成する際に
   ``quoteIdentifier()`` を使用しなければなりません。

``where()`` メソッドの二番目の引数はオプションです。
これは式を置き換える値となります。 ``Zend_Db_Select`` は値をクォートし、式の中の
クエスチョンマーク ("*?*") をその値で置き換えます。

.. _zend.db.select.building.where.example-param:

.. rubric:: where() メソッドでのパラメータの例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price > 100.00)

   $minimumPrice = 100;

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('price > ?', $minimumPrice);

SQL の IN 演算子を使うとき、 ``where()`` メソッドに 第２引数として配列を渡せます。

.. _zend.db.select.building.where.example-array:

.. rubric:: where() メソッドでの配列パラメータ例

.. code-block:: php
   :linenos:

   // クエリをビルド
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (product_id IN (1, 2, 3))

   $productIds = array(1, 2, 3);

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('product_id IN (?)', $productIds);

``Zend_Db_Select`` オブジェクト上で、 ``where()``
メソッドを複数回実行することもできます。その結果のクエリは、 指定した条件を
*AND* でひとつにまとめたものとなります。

.. _zend.db.select.building.where.example-and:

.. rubric:: 複数の where() メソッドの例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price > 100.00)
   //     AND (price < 500.00)

   $minimumPrice = 100;
   $maximumPrice = 500;

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('price > ?', $minimumPrice)
                ->where('price < ?', $maximumPrice);

複数の条件を *OR* で連結したい場合は、 ``orWhere()`` メソッドを使用します。
このメソッドの使用法は ``where()`` メソッドとほとんど同じですが、条件の前には *AND*
ではなく *OR* がつくことになります。

.. _zend.db.select.building.where.example-or:

.. rubric:: orWhere() メソッドの例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price < 100.00)
   //     OR (price > 500.00)

   $minimumPrice = 100;
   $maximumPrice = 500;

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where('price < ?', $minimumPrice)
                ->orWhere('price > ?', $maximumPrice);

``Zend_Db_Select`` は、 ``where()`` メソッドや ``orWhere()`` メソッドで指定した式の両側に
自動的に括弧をつけます。これにより、
論理演算子が予期せぬ結果を引き起こすことを防ぎます。

.. _zend.db.select.building.where.example-parens:

.. rubric:: 論理式を括弧で囲む例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT product_id, product_name, price
   //   FROM "products"
   //   WHERE (price < 100.00 OR price > 500.00)
   //     AND (product_name = 'Apple')

   $minimumPrice = 100;
   $maximumPrice = 500;
   $prod = 'Apple';

   $select = $db->select()
                ->from('products',
                       array('product_id', 'product_name', 'price'))
                ->where("price < $minimumPrice OR price > $maximumPrice")
                ->where('product_name = ?', $prod);

上の例では、括弧がなければ結果はまったく異なるものとなります。 なぜなら、 *AND*
のほうが *OR* よりも優先順位が高いからです。 ``Zend_Db_Select``
は括弧をつけるので、それぞれの ``where()`` で指定された式の結合度が *AND*
より高くなります。

.. _zend.db.select.building.group:

GROUP BY 句の追加
^^^^^^^^^^^^^

*SQL* で ``GROUP BY`` 句を使用すると、 結果セットの行数を減らすことができます。
``GROUP BY`` 句で指定したカラムの一意な値ごとに、 結果が一行にまとめられます。

``Zend_Db_Select`` では、行のグループ化を行うためのカラムを ``group()``
メソッドで指定します。 このメソッドへの引数は、 ``GROUP BY``
句で使用するカラムあるいは複数カラムの配列となります。

.. _zend.db.select.building.group.example:

.. rubric:: group() メソッドの例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT p."product_id", COUNT(*) AS line_items_per_product
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id
   //   GROUP BY p.product_id

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array('line_items_per_product' => 'COUNT(*)'))
                ->group('p.product_id');

``from()`` メソッドでのカラムの配列と同様、
カラム名には相関名を使用できます。また、
カラム名は識別子としてクォートされます。 ただし、文字列に括弧が含まれたり
``Zend_Db_Expr`` 型のオブジェクトを指定したりした場合は別です。

.. _zend.db.select.building.having:

HAVING 句の追加
^^^^^^^^^^^

*SQL* で ``HAVING`` 句を使用すると、 グループ化した行に制約を適用します。これは、
``WHERE`` 句が行に対して制約を適用するのと同じです。
しかし、これらには相違点があります。 ``WHERE``
条件はグループ化の前に適用されますが、 ``HAVING``
条件はグループ化された後に適用されます。

``Zend_Db_Select`` では、グループに対する制約を指定するには ``having()``
メソッドを使用します。 このメソッドの使用法は ``where()`` メソッドと似ています。
最初の引数が *SQL* の式を含む文字列です。二番目の引数はオプションで、 *SQL*
式の中のパラメータプレースホルダを置き換える値となります。 ``having()``
を複数回実行すると、それらの条件が 論理演算子 ``AND`` で連結されます。 ``orHaving()``
メソッドを使用した場合は、論理演算子 *OR* で連結されます。

.. _zend.db.select.building.having.example:

.. rubric:: having() メソッドの例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT p."product_id", COUNT(*) AS line_items_per_product
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id
   //   GROUP BY p.product_id
   //   HAVING line_items_per_product > 10

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array('line_items_per_product' => 'COUNT(*)'))
                ->group('p.product_id')
                ->having('line_items_per_product > 10');

.. note::

   ``having()`` メソッドや ``orHaving()``
   メソッドで指定する式にはクォート処理は行われません。
   クォートする必要のあるカラム名を使用する場合は、 条件の文字列を作成する際に
   ``quoteIdentifier()`` を使用しなければなりません。

.. _zend.db.select.building.order:

ORDER BY 句の追加
^^^^^^^^^^^^^

*SQL* の *ORDER BY* 句では、
クエリの結果セットの並べ替えの基準となるカラムや式を指定します。
複数のカラムを指定すると、最初のカラムの値が同じだった場合に
二番目のカラムを用いて並べ替えを行います。
デフォルトでは、小さいほうから大きいほうに向かって並べ替えます。
逆に大きいほうから小さいほうに向かって並べ替えるには、
カラムリストの中のそのカラム名の後に、キーワード ``DESC`` を指定します。

``Zend_Db_Select`` では、 ``order()`` メソッドを使用して
並べ替えの基準となるカラムあるいはカラムの配列を指定します。
配列の各要素はカラム名を表す文字列です。オプションとして、
スペースをはさんでキーワード ``ASC`` や ``DESC`` を続けます。

``from()`` メソッドや ``group()``
メソッドと同様、カラム名は識別子としてクォートされます。
ただし、文字列に括弧が含まれたり ``Zend_Db_Expr``
型のオブジェクトを指定したりした場合は別です。

.. _zend.db.select.building.order.example:

.. rubric:: order() メソッドの例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT p."product_id", COUNT(*) AS line_items_per_product
   //   FROM "products" AS p JOIN "line_items" AS l
   //     ON p.product_id = l.product_id
   //   GROUP BY p.product_id
   //   ORDER BY "line_items_per_product" DESC, "product_id"

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id'))
                ->join(array('l' => 'line_items'),
                       'p.product_id = l.product_id',
                       array('line_items_per_product' => 'COUNT(*)'))
                ->group('p.product_id')
                ->order(array('line_items_per_product DESC',
                              'product_id'));

.. _zend.db.select.building.limit:

LIMIT 句の追加
^^^^^^^^^^

*RDBMS* によっては、 *SQL* を拡張して、いわゆる ``LIMIT``
句を使用できるようにしているものもあります。
これは、結果セットの行数を、最大でも指定した数までに制限します。
また、出力を始める前に読み飛ばす行数を指定することもできます。
この機能を使用すると、結果セットの一部だけを取得することが簡単になります。
たとえば、クエリの結果をページに分けて出力する場合などに便利です。

``Zend_Db_Select`` では、 ``limit()``
メソッドを使用して結果の行数および読み飛ばしの行数を指定します。
このメソッドの **最初**\ の引数は取得したい行数、 そして **二番目**\
の引数は読み飛ばす行数となります。

.. _zend.db.select.building.limit.example:

.. rubric:: limit() メソッドの例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p
   //   LIMIT 10, 20
   // 以下に相当します
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p
   //   LIMIT 20 OFFSET 10
   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->limit(20, 10);

.. note::

   ``LIMIT`` 構文は、すべての *RDBMS* でサポートされているわけではありません。 *RDBMS*
   によっては、 似た機能を別の構文でサポートしているものもあります。 各
   ``Zend_Db_Adapter_Abstract`` クラスには、 その *RDBMS* に対応した適切な *SQL*
   を作成するメソッドが用意されています。

一方、 ``limitPage()``
メソッドを用いることによっても行数とオフセットを指定できます。
このメソッドは、クエリの結果セット全体から特定の箇所の連続した行のみを取得するものです。
つまり、結果の「ページ」を指定することで、
そのページに該当する部分の結果のみを取得するというわけです。 ``limitPage()``
メソッドの最初の引数にページ数、 2
番目の引数にページあたりの行数を指定します。
どちらの引数も必須で、デフォルト値はありません。

.. _zend.db.select.building.limit.example2:

.. rubric:: limitPage() メソッドの例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT p."product_id", p."product_name"
   //   FROM "products" AS p
   //   LIMIT 10, 20

   $select = $db->select()
                ->from(array('p' => 'products'),
                       array('product_id', 'product_name'))
                ->limitPage(2, 10);

.. _zend.db.select.building.distinct:

クエリ修飾子 DISTINCT の追加
^^^^^^^^^^^^^^^^^^^

``distinct()`` メソッドを使用すると、 *SQL* クエリに ``DISTINCT``
キーワードを追加できます。

.. _zend.db.select.building.distinct.example:

.. rubric:: distinct() メソッドの例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT DISTINCT p."product_name"
   //   FROM "products" AS p

   $select = $db->select()
                ->distinct()
                ->from(array('p' => 'products'), 'product_name');

.. _zend.db.select.building.for-update:

クエリ修飾子 FOR UPDATE の追加
^^^^^^^^^^^^^^^^^^^^^

``forUpdate()`` メソッドを使用すると、 *SQL* クエリに *FOR UPDATE* 修飾子を追加できます。

.. _zend.db.select.building.for-update.example:

.. rubric:: forUpdate() メソッドの例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT FOR UPDATE p.*
   //   FROM "products" AS p

   $select = $db->select()
                ->forUpdate()
                ->from(array('p' => 'products'));

.. _zend.db.select.building.union:

UNION クエリの構築
^^^^^^^^^^^^

``union()``\ メソッドに ``Zend_Db_Select``\ の配列、 または SQL
クエリ文字列を渡すことによって、 ``Zend_Db_Select``\ で結合クエリを構築できます。
どの種類の結合を実行したいか指定するために、 第２引数として、
``Zend_Db_Select::SQL_UNION``\ 、 または ``Zend_Db_Select::SQL_UNION_ALL``\ 定数を渡せます。

.. _zend.db.select.building.union.example:

.. rubric:: union() メソッド例

.. code-block:: php
   :linenos:

   $sql1 = $db->select();
   $sql2 = "SELECT ...";

   $select = $db->select()
       ->union(array($sql1, $sql2))
       ->order("id");

.. _zend.db.select.execute:

Select クエリの実行
-------------

この節では、 ``Zend_Db_Select``
オブジェクトが表すクエリを実行する方法を説明します。

.. _zend.db.select.execute.query-adapter:

Db アダプタからの Select クエリの実行
^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Db_Select`` オブジェクトが表すクエリを実行するには、それを
``Zend_Db_Adapter_Abstract`` オブジェクトの ``query()``
メソッドの最初の引数として渡します。すると、 文字列のクエリのかわりに
``Zend_Db_Select`` オブジェクトを使用するようになります。

``query()`` メソッドは、アダプタの型によって ``Zend_Db_Statement`` あるいは PDOStatement
型のオブジェクトを返します。

.. _zend.db.select.execute.query-adapter.example:

.. rubric:: Db アダプタの query() メソッドの使用例

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products');

   $stmt = $db->query($select);
   $result = $stmt->fetchAll();

.. _zend.db.select.execute.query-select:

オブジェクトからの Select クエリの実行
^^^^^^^^^^^^^^^^^^^^^^^

アダプタオブジェクトの ``query()`` メソッドを使用する以外の方法としては、
``Zend_Db_Select`` オブジェクトの ``query()`` メソッドを使用するものがあります。
どちらのメソッドも、アダプタの型によって ``Zend_Db_Statement`` あるいは PDOStatement
型のオブジェクトを返します。

.. _zend.db.select.execute.query-select.example:

.. rubric:: Select オブジェクトの query メソッドの使用例

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products');

   $stmt = $select->query();
   $result = $stmt->fetchAll();

.. _zend.db.select.execute.tostring:

Select オブジェクトから SQL 文字列への変換
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Db_Select`` オブジェクトに対応する *SQL* クエリ文字列にアクセスしたい場合は、
``__toString()`` メソッドを使用します。

.. _zend.db.select.execute.tostring.example:

.. rubric:: \__toString() メソッドの例

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products');

   $sql = $select->__toString();
   echo "$sql\n";

   // 出力は、次のような文字列になります
   //   SELECT * FROM "products"

.. _zend.db.select.other:

その他のメソッド
--------

この節では、これまでにあげてこなかった ``Zend_Db_Select`` クラスのメソッドである
``getPart()`` および ``reset()`` について説明します。

.. _zend.db.select.other.get-part:

Select オブジェクトの一部の取得
^^^^^^^^^^^^^^^^^^^

``getPart()`` メソッドは、 *SQL* クエリの一部を返します。
たとえば、このメソッドを使用すると、 ``WHERE`` 句の式を表す配列や ``SELECT``
するカラム (あるいは式) の配列、または ``LIMIT``
句のカウントやオフセットを取得できます。

返り値は、 *SQL* の一部を抜き取った文字列ではありません。
オブジェクトでの内部表現で、通常は値と式を含む配列となります。
クエリの各部分によって、その構造は異なります。

``getPart()`` メソッドの引数はひとつで、 Select
クエリのどの部分を返すのかをここで指定します。 たとえば、文字列 *'from'*
を指定すると、 Select オブジェクトが ``FROM``
句として保持しているテーブルの情報を返します。
ここには結合している他のテーブルも含まれます。

``Zend_Db_Select`` クラスでは、 *SQL*
クエリの各部分を指定するための定数を定義しています。
これらの定数、あるいはリテラル文字列のいずれかで指定できます。

.. _zend.db.select.other.get-part.table:

.. table:: getPart() および reset() で使用する定数

   +----------------------------+-------------+
   |定数                          |文字列値         |
   +============================+=============+
   |Zend_Db_Select::DISTINCT    |'distinct'   |
   +----------------------------+-------------+
   |Zend_Db_Select::FOR_UPDATE  |'forupdate'  |
   +----------------------------+-------------+
   |Zend_Db_Select::COLUMNS     |'columns'    |
   +----------------------------+-------------+
   |Zend_Db_Select::FROM        |'from'       |
   +----------------------------+-------------+
   |Zend_Db_Select::WHERE       |'where'      |
   +----------------------------+-------------+
   |Zend_Db_Select::GROUP       |'group'      |
   +----------------------------+-------------+
   |Zend_Db_Select::HAVING      |'having'     |
   +----------------------------+-------------+
   |Zend_Db_Select::ORDER       |'order'      |
   +----------------------------+-------------+
   |Zend_Db_Select::LIMIT_COUNT |'limitcount' |
   +----------------------------+-------------+
   |Zend_Db_Select::LIMIT_OFFSET|'limitoffset'|
   +----------------------------+-------------+

.. _zend.db.select.other.get-part.example:

.. rubric:: getPart() メソッドの例

.. code-block:: php
   :linenos:

   $select = $db->select()
                ->from('products')
                ->order('product_id');

   // 文字列リテラルを使用して指定できます
   $orderData = $select->getPart( 'order' );

   // 同じことを、定数を用いて指定することもできます
   $orderData = $select->getPart( Zend_Db_Select::ORDER );

   // 返り値は、文字列ではなく配列となります。
   // 各部分が異なる構造になっています。
   print_r( $orderData );

.. _zend.db.select.other.reset:

Select オブジェクトの一部のリセット
^^^^^^^^^^^^^^^^^^^^^

``reset()`` メソッドを使用すると、 *SQL* クエリの指定した部分のみを消去できます。
引数を省略した場合は、すべての部分を消去します。

引数はひとつで、これは省略可能です。 消去したい *SQL* の部分を、 ``getPart()``
メソッドの引数と同じ文字列で指定します。
クエリの指定した部分が、デフォルトの状態に戻ります。

パラメータを省略すると、 ``reset()``
はクエリのすべての部分をデフォルトの状態に戻します。 これにより、
``Zend_Db_Select`` オブジェクトは初期状態と同等になります。
つまり、最初にインスタンスを作成したときと同じ状態ということです。

.. _zend.db.select.other.reset.example:

.. rubric:: reset() メソッドの例

.. code-block:: php
   :linenos:

   // できあがるクエリは、このようになります
   //   SELECT p.*
   //   FROM "products" AS p
   //   ORDER BY "product_name"

   $select = $db->select()
                ->from(array('p' => 'products')
                ->order('product_name');

   // 条件を変更し、別のカラムで並べ替えます
   //   SELECT p.*
   //   FROM "products" AS p
   //   ORDER BY "product_id"

   // 再定義するため、いちどこの部分を消去します
   $select->reset( Zend_Db_Select::ORDER );

   // そして異なるカラムを指定します
   $select->order('product_id');

   // クエリ全体を消去します
   $select->reset();


