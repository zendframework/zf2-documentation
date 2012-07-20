.. _zend.db.table.rowset:

Zend_Db_Table_Rowset
====================

.. _zend.db.table.rowset.introduction:

導入
--

テーブルクラスに対して ``find()`` あるいは ``fetchAll()``
メソッドでクエリを実行すると、 返される結果は ``Zend_Db_Table_Rowset_Abstract``
型のオブジェクトとなります。 行セットには、 ``Zend_Db_Table_Row_Abstract``
を継承したオブジェクトが含まれます。
行セットを使用して各行オブジェクトに対して順にアクセスし、
行のデータを読み込んだり変更したりできます。

.. _zend.db.table.rowset.fetch:

行セットの取得
-------

``Zend_Db_Table_Abstract`` には ``find()`` と ``fetchAll()`` というメソッドがあります。
これらはどちらも ``Zend_Db_Table_Rowset_Abstract`` 型のオブジェクトを返します。

.. _zend.db.table.rowset.fetch.example:

.. rubric:: 行セットの取得の例

.. code-block:: php
   :linenos:

   $bugs   = new Bugs();
   $rowset = $bugs->fetchAll("bug_status = 'NEW'");

.. _zend.db.table.rowset.rows:

行セットからの行の取得
-----------

通常は、行セットそのものよりもその中に含まれる行のほうが重要になります。
この節では、行セットを構成する行の情報を取得する方法について説明します。

正しい形式のクエリであっても、結果がゼロ行となることがありえます。
たとえば、抽出条件に一致する行がデータベース内に存在しない場合などです。
したがって、行セットオブジェクトの中身の行オブジェクトの個数がゼロになることもあります。
``Zend_Db_Table_Rowset_Abstract`` は ``Countable`` インターフェイスを実装しているので、
``count()`` を使用すると行セット内の行の数を調べられます。

.. _zend.db.table.rowset.rows.counting.example:

.. rubric:: 行セット内の行の数を数える

.. code-block:: php
   :linenos:

   $rowset   = $bugs->fetchAll("bug_status = 'FIXED'");

   $rowCount = count($rowset);

   if ($rowCount > 0) {
       echo "見つかった行数は $rowCount です";
   } else {
       echo 'クエリにマッチする行がありません';
   }

.. _zend.db.table.rowset.rows.current.example:

.. rubric:: 行セットからの単一の行の読み込み

行セットから行にアクセスするための一番簡単な方法は ``current()``
メソッドを使用することです。
これは、行セットに含まれる行数がひとつである場合に最適です。

.. code-block:: php
   :linenos:

   $bugs   = new Bugs();
   $rowset = $bugs->fetchAll("bug_id = 1");
   $row    = $rowset->current();

行セットに含まれる行数がゼロの場合、 ``current()`` が返す値は *PHP* の ``NULL``
値となります。

.. _zend.db.table.rowset.rows.iterate.example:

.. rubric:: 行セットの順次処理

``Zend_Db_Table_Rowset_Abstract`` を継承したオブジェクトは ``SeekableIterator``
インターフェイスを実装しています。つまり、 ``foreach()``
ループを使用できるということです。 これを使用して取得した個々の値は
``Zend_Db_Table_Row_Abstract`` オブジェクトとなり、これがテーブルの各行に対応します。

.. code-block:: php
   :linenos:

   $bugs = new Bugs();

   // テーブルのすべてのレコードを取得します
   $rowset = $bugs->fetchAll();

   foreach ($rowset as $row) {

       // 出力は 'Zend_Db_Table_Row' あるいはそれに似たものとなります
       echo get_class($row) . "\n";

       // 行のカラムを読み込みます
       $status = $row->bug_status;

       // 現在の行のカラムの値を変更します
       $row->assigned_to = 'mmouse';

       // 変更をデータベースに書き出します
       $row->save();
   }

.. _zend.db.table.rowset.rows.seek.example:

.. rubric:: 行セット内の既知の位置への移動

``SeekableIterator`` は、 イテレータ内の特定の位置に移動できます。
そのために使用するのが ``seek()`` メソッドです。
行番号を渡すと、行セット内のその次の位置に移動できます。 行番号は 0
から始まることに注意しましょう。
インデックスが間違っている場合、あるいは存在しない場合は例外がスローされます。
``count()`` を使って結果の行数を確認してから移動するようにしましょう。

.. code-block:: php
   :linenos:

   $bugs = new Bugs();

   // テーブルのすべてのレコードを取得します
   $rowset = $bugs->fetchAll();

   // イテレータを 9 番目の要素に移動します (最初の要素がゼロです)
   $rowset->seek(8);

   // それを取得します
   $row9 = $rowset->current();

   // そして使用します
   $row9->assigned_to = 'mmouse';
   $row9->save();

``getRow()`` は、位置がわかっている場合に
行セット内の特定の行を取得するためのメソッドです。
しかし、この位置はゼロから数え始めることを忘れないようにしましょう。 ``getRow()``
の最初のパラメータは、位置を表す整数値です。 2
番目のパラメータはオプションで、boolean 値を指定します。 これは、Rowset
イテレータも同時にその場所に移動させるのかどうかを表します (デフォルトは
``FALSE`` です)。このメソッドはデフォルトでは ``Zend_Db_Table_Row``
オブジェクトを返します。 指定した位置が存在しない場合は例外をスローします。
例を示します。

.. code-block:: php
   :linenos:

   $bugs = new Bugs();

   // テーブルのすべてのレコードを取得します
   $rowset = $bugs->fetchAll();

   // 9 番目の要素を取得します
   $row9->getRow(8);

   // そして使用します
   $row9->assigned_to = 'mmouse';
   $row9->save();

個々の行オブジェクトにアクセスすると、後は :ref:`Zend_Db_Table_Row <zend.db.table.row>`
で説明しているメソッド群を用いて行を操作できます。

.. _zend.db.table.rowset.to-array:

行セットの配列としての取得
-------------

行セット内のすべてのデータに対して配列としてアクセスするには、
行セットオブジェクトの ``toArray()`` メソッドを使用します。
これは、各行単位でひとつの要素となる配列を返します。
各エントリは連想配列となり、カラム名とその値が関連付けられています。

.. _zend.db.table.rowset.to-array.example:

.. rubric:: toArray() の使用法

.. code-block:: php
   :linenos:

   $bugs   = new Bugs();
   $rowset = $bugs->fetchAll();

   $rowsetArray = $rowset->toArray();

   $rowCount = 1;
   foreach ($rowsetArray as $rowArray) {
       echo "row #$rowCount:\n";
       foreach ($rowArray as $column => $value) {
           echo "\t$column => $value\n";
       }
       ++$rowCount;
       echo "\n";
   }

``toArray()`` が返す配列は、更新できません。
つまり、配列内の値を変更することは可能ですが、
それをデータベースに反映させることはできません。

.. _zend.db.table.rowset.serialize:

行セットのシリアライズと復元
--------------

``Zend_Db_Table_Rowset_Abstract`` 型のオブジェクトはシリアライズ可能です。
個別の行オブジェクトをシリアライズするのと同じような方式で、
行セットをシリアライズして後ほどそれを復元できます。

.. _zend.db.table.rowset.serialize.example.serialize:

.. rubric:: 行セットのシリアライズ

*PHP* の ``serialize()`` 関数を使用して、
行セットオブジェクトのバイトストリームを含む文字列を作成します。

.. code-block:: php
   :linenos:

   $bugs   = new Bugs();
   $rowset = $bugs->fetchAll();

   // オブジェクトをシリアライズします
   $serializedRowset = serialize($rowset);

   // これで、$serializedRowset をファイルなどに書き出すことができます

.. _zend.db.table.rowset.serialize.example.unserialize:

.. rubric:: シリアライズした行セットの復元

*PHP* の ``unserialize()`` 関数を使用して、
オブジェクトのバイトストリームを含む文字列を復元します。
この関数は、もとのオブジェクトを返します。

返された行セットオブジェクトは、 **接続が切断された**
状態であることに注意しましょう。
行セットオブジェクトやその内部の行オブジェクト、そしてそのプロパティを読み込むことはできますが、
その値を変更することはできません。また、データベース接続を必要とするようなメソッド
(たとえば従属テーブルに対するクエリなど) も実行できません。

.. code-block:: php
   :linenos:

   $rowsetDisconnected = unserialize($serializedRowset);

   // これでオブジェクトのプロパティを使用できますが、読み込み専用です
   $row = $rowsetDisconnected->current();
   echo $row->bug_description;

.. note::

   **復元した行セットは、なぜ切断された状態なのですか?**

   シリアライズしたオブジェクトは、可読形式の文字列となります。
   データベースのアカウントやパスワードといった情報を
   暗号化せずにプレーンテキストにシリアライズして保存すると、
   セキュリティ上問題となります。
   そのようなデータを無防備な状態でテキストファイルに保存したりしたくはないでしょう。
   またメールなどで攻撃者に覗き見られることも好まないはずです。
   シリアライズされたオブジェクトは、
   正しい認証情報を知らない限りデータベースにアクセスすることはできません。

切断された行セットの接続を復活させるには、 ``setTable()``
メソッドを使用します。このメソッドへの引数としては、 ``Zend_Db_Table_Abstract``
型のオブジェクトを作成して渡します。
テーブルオブジェクトを作成するには、データベースとの接続が必要です。
そのテーブルと行セットを関連付けることで、行セットがデータベースにアクセスできるようになります。
それ以降は、行オブジェクトの値を変更してデータベースに保存できるようになります。

.. _zend.db.table.rowset.serialize.example.set-table:

.. rubric:: 生きたデータとしての行セットの復活

.. code-block:: php
   :linenos:

   $rowset = unserialize($serializedRowset);

   $bugs = new Bugs();

   // この行セットをテーブルに再接続し、
   // データベースとの接続を復活させます
   $rowset->setTable($bugs);

   $row = $rowset->current();

   // これで、行の内容を変更して保存できます
   $row->bug_status = 'FIXED';
   $row->save();

行セットを ``setTable()`` で復活させると、
その中に含まれる行オブジェクトもすべて復活した状態になります。

.. _zend.db.table.rowset.extending:

行セットクラスの拡張
----------

``Zend_Db_Table_Rowset_Abstract`` を継承した新たな具象クラスを作成し、
それを用いて行セットのインスタンスを作成できます。
独自の行クラスを指定するには、テーブルクラスの protected メンバである
``$_rowsetClass`` を使用するか、
テーブルオブジェクトのコンストラクタの引数の配列で指定します。

.. _zend.db.table.rowset.extending.example:

.. rubric:: 独自の行セットクラスの指定

.. code-block:: php
   :linenos:

   class MyRowset extends Zend_Db_Table_Rowset_Abstract
   {
       // ...独自の処理
   }

   // 独自の行セットを、テーブルクラスの全インスタンスで
   // デフォルトとして使用するように設定します
   class Products extends Zend_Db_Table_Abstract
   {
       protected $_name = 'products';
       protected $_rowsetClass = 'MyRowset';
   }

   // あるいは、テーブルクラスの特定のインスタンスでのみ
   // 独自の行セットクラスを使用するように設定します
   $bugs = new Bugs(array('rowsetClass' => 'MyRowset'));

一般的には、標準の具象クラス ``Zend_Db_Rowset``
でたいていの場合は十分でしょう。しかし、
特定のテーブルに固有の処理を行セットに追加したくなることもあります。
たとえば、行セット内のすべての行の内容の集計用のメソッドなどです。

.. _zend.db.table.rowset.extending.example-aggregate:

.. rubric:: 行セットクラスに新しいメソッドを追加する例

.. code-block:: php
   :linenos:

   class MyBugsRowset extends Zend_Db_Table_Rowset_Abstract
   {
       /**
        * 現在の行セットのなかで、'updated_at' カラムの値が
        * 最大である行を見つけます
        */
       public function getLatestUpdatedRow()
       {
           $max_updated_at = 0;
           $latestRow = null;
           foreach ($this as $row) {
               if ($row->updated_at > $max_updated_at) {
                   $latestRow = $row;
               }
           }
           return $latestRow;
       }
   }

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';
       protected $_rowsetClass = 'MyBugsRowset';
   }


