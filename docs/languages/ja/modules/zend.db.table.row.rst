.. _zend.db.table.row:

Zend_Db_Table_Row
=================

.. _zend.db.table.row.introduction:

導入
--

``Zend_Db_Table_Row`` は、 ``Zend_Db_Table`` オブジェクトの個々の行を含むクラスです。
テーブルクラスに対してクエリを実行すると、返される結果は ``Zend_Db_Table_Row``
オブジェクトのセットとなります。 このオブジェクトを使用して新しい行を作成し、
それをデータベースのテーブルに追加することもできます。

``Zend_Db_Table_Row`` は、 `行データゲートウェイ`_\ パターンを実装したものです。

.. _zend.db.table.row.read:

行の取得
----

``Zend_Db_Table_Abstract`` は ``find()`` や ``fetchAll()`` といったメソッドを提供します。
これらはそれぞれ ``Zend_Db_Table_Rowset`` 型のオブジェクトを返します。 また ``fetchRow()``
メソッドは、 ``Zend_Db_Table_Row`` 型のオブジェクトを返します。

.. _zend.db.table.row.read.example:

.. rubric:: 行の取得の例

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()->where('bug_id = ?', 1));

``Zend_Db_Table_Rowset`` オブジェクトには、複数の ``Zend_Db_Table_Row``
オブジェクトが含まれます。 詳細については :ref:`table rowset <zend.db.table.rowset>`
についての章を参照ください。

.. _zend.db.table.row.read.example-rowset:

.. rubric:: 行セット内の行を読み込む例

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $rowset = $bugs->fetchAll($bugs->select()->where('bug_status = ?', 1));
   $row = $rowset->current();

.. _zend.db.table.row.read.get:

行からのカラムの値の読み込み
^^^^^^^^^^^^^^

``Zend_Db_Table_Row_Abstract`` にはアクセサがあり、
行のカラムをオブジェクトのプロパティとして参照できます。

.. _zend.db.table.row.read.get.example:

.. rubric:: 行からカラムを読み込む例

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()->where('bug_id = ?', 1));

   // bug_description カラムの値を出力します
   echo $row->bug_description;

.. note::

   初期のバージョンの ``Zend_Db_Table_Row`` では、
   これらのアクセサをデータベースのカラムと対応させる際に **inflection (変形)**
   と呼ばれる文字列変換を行っていました。

   現在の ``Zend_Db_Table_Row`` では変形を実装していません。
   使用するアクセサ名は、データベース内のカラム名と正確に一致します。

.. _zend.db.table.row.read.to-array:

行データの配列としての取得
^^^^^^^^^^^^^

行のデータに対して配列としてアクセスするには、行オブジェクトの ``toArray()``
メソッドを使用します。
これは、カラム名とその値を関連付けた連想配列を返します。

.. _zend.db.table.row.read.to-array.example:

.. rubric:: toArray() メソッドの使用例

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()->where('bug_id = ?', 1));

   // 行オブジェクトから カラム名/値 の連想配列を取得します
   $rowArray = $row->toArray();

   // 通常の配列と同様に使用します
   foreach ($rowArray as $column => $value) {
       echo "カラム: $column\n";
       echo "値:  $value\n";
   }

``toArray()`` が返す配列は、更新できません。
配列内の値を変更することは可能ですが、
それをデータベースに保存することはできません。

.. _zend.db.table.row.read.relationships:

関連するテーブルからのデータの取得
^^^^^^^^^^^^^^^^^

``Zend_Db_Table_Row_Abstract`` クラスには、関連するテーブルから
行や行セットを取得するメソッドが存在します。
テーブルのリレーションについての詳細な情報は :ref:`リレーションシップ
<zend.db.table.relationships>` を参照ください。

.. _zend.db.table.row.write:

データベースへの行の書き込み
--------------

.. _zend.db.table.row.write.set:

行のカラムの値の変更
^^^^^^^^^^

個々のカラムの値をアクセサで設定する方法は、
カラムを読み込む場合と同様で、オブジェクトのプロパティを使用します。

カラムのアクセサによる値の設定は、アプリケーション内の行データのカラムの値は変更しますが、
それだけではまだデータベースにコミットされていません。コミットするには
``save()`` メソッドを使用します。

.. _zend.db.table.row.write.set.example:

.. rubric:: 行のカラムの内容を変更する例

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow($bugs->select()->where('bug_id = ?', 1));

   // ひとつあるいは複数のカラムの値を変更します
   $row->bug_status = 'FIXED';

   // データベース内の行を、新しい値で UPDATE します
   $row->save();

.. _zend.db.table.row.write.insert:

新しい行の挿入
^^^^^^^

指定したテーブルに新しい行を作成するには、テーブルクラスの ``createRow()``
メソッドを使用します。
取得した行のフィールドに対してはオブジェクト指向のインターフェイスでアクセスできますが、
``save()`` メソッドをコールするまでは
実際にデータベースの内容が変更されることはありません。

.. _zend.db.table.row.write.insert.example:

.. rubric:: テーブルに新しい行を作成する例

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $newRow = $bugs->createRow();

   // アプリケーションに応じて適切にカラムの値を設定します
   $newRow->bug_description = '...説明...';
   $newRow->bug_status = 'NEW';

   // 新しい行をデータベースに INSERT します
   $newRow->save();

``createRow()`` メソッドのオプションの引数として、連想配列を渡すことができます。
この連想配列では、新しい行のフィールドに代入する値を指定します。

.. _zend.db.table.row.write.insert.example2:

.. rubric:: テーブルに新しい行を作成し、値を代入する例

.. code-block:: php
   :linenos:

   $data = array(
       'bug_description' => '...説明...',
       'bug_status'      => 'NEW'
   );

   $bugs = new Bugs();
   $newRow = $bugs->createRow($data);

   // 新しい行をデータベースに INSERT します
   $newRow->save();

.. note::

   ``Zend_Db_Table`` の初期のリリースでは、 ``createRow()`` メソッドは ``fetchNew()``
   という名前でした。 今後は新しい名前を用いることを推奨しますが、
   過去との互換性を確保するため古い名前も使用できるようになっています。

.. _zend.db.table.row.write.set-from-array:

複数のカラムの値の変更
^^^^^^^^^^^

``Zend_Db_Table_Row_Abstract`` の ``setFromArray()`` メソッドを使用すると、
ひとつの行の複数のカラムを一度に設定できます。
このメソッドには、カラム名と値を関連付けた連想配列を指定します。
このメソッドは、新しい行の値を設定する場合や
既存の行を更新する場合のどちらでも有用でしょう。

.. _zend.db.table.row.write.set-from-array.example:

.. rubric:: setFromArray() で新しい行の値を設定する例

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $newRow = $bugs->createRow();

   // データを連想配列形式にします
   $data = array(
       'bug_description' => '...説明...',
       'bug_status'      => 'NEW'
   );

   // すべてのカラムの値を一度に設定します
   $newRow->setFromArray($data);

   // 新しい行をデータベースに INSERT します
   $newRow->save();

.. _zend.db.table.row.write.delete:

行の削除
^^^^

行オブジェクトで ``delete()`` メソッドをコールできます。
これは、その行オブジェクトの主キーに対応するデータベースの行を削除します。

.. _zend.db.table.row.write.delete.example:

.. rubric:: 行の削除の例

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow('bug_id = 1');

   // この行を DELETE します
   $row->delete();

変更を適用するのに ``save()`` をコールする必要はありません。
これは、データベースに対して即時に適用されます。

.. _zend.db.table.row.serialize:

行のシリアライズと復元
-----------

データベースの行の内容を保存しておき、
あとで使用するということはよくありがちです。
オブジェクトの内容を、オフラインで保存しやすい形式 (たとえばファイルなど)
に変換するような処理のことを **シリアライズ** といいます。 ``Zend_Db_Table_Row_Abstract``
型のオブジェクトは、 シリアライズできます。

.. _zend.db.table.row.serialize.serializing:

行のシリアライズ
^^^^^^^^

*PHP* の ``serialize()`` 関数を使用して、
行オブジェクトのバイトストリームを含む文字列を作成します。

.. _zend.db.table.row.serialize.serializing.example:

.. rubric:: 行のシリアライズの例

.. code-block:: php
   :linenos:

   $bugs = new Bugs();
   $row = $bugs->fetchRow('bug_id = 1');

   // オブジェクトをシリアライズします
   $serializedRow = serialize($row);

   // これで、$serializedRow をファイルなどに書き出すことができます

.. _zend.db.table.row.serialize.unserializing:

シリアライズした行データの復元
^^^^^^^^^^^^^^^

*PHP* の ``unserialize()`` 関数を使用して、
オブジェクトのバイトストリームを含む文字列を復元します。
この関数は、もとのオブジェクトを返します。

返された行オブジェクトは、 **接続が切断された**
状態であることに注意しましょう。
行オブジェクトやそのプロパティを読み込むことはできますが、
その値を変更することはできません。また、データベース接続を必要とするようなメソッド
(たとえば従属テーブルに対するクエリなど) も実行できません。

.. _zend.db.table.row.serialize.unserializing.example:

.. rubric:: シリアライズした行の復元の例

.. code-block:: php
   :linenos:

   $rowClone = unserialize($serializedRow);

   // これでオブジェクトのプロパティを使用できますが、読み込み専用です
   echo $rowClone->bug_description;

.. note::

   **復元した行は、なぜ切断された状態なのですか?**

   シリアライズしたオブジェクトは、可読形式の文字列となります。
   データベースのアカウントやパスワードといった情報を
   暗号化せずにプレーンテキストにシリアライズして保存すると、
   セキュリティ上問題となります。
   そのようなデータを無防備な状態でテキストファイルに保存したりしたくはないでしょう。
   またメールなどで攻撃者に覗き見られることも好まないはずです。
   シリアライズされたオブジェクトは、
   正しい認証情報を知らない限りデータベースにアクセスすることはできません。

.. _zend.db.table.row.serialize.set-table:

生きたデータとしての行の復活
^^^^^^^^^^^^^^

切断された行の接続を復活させるには、 ``setTable()``
メソッドを使用します。このメソッドへの引数としては、 ``Zend_Db_Table_Abstract``
型のオブジェクトを作成して渡します。
テーブルオブジェクトを作成するには、データベースとの接続が必要です。
そのテーブルと行を関連付けることで、行がデータベースにアクセスできるようになります。
それ以降は、行オブジェクトの値を変更してデータベースに保存できるようになります。

.. _zend.db.table.row.serialize.set-table.example:

.. rubric:: 行の復活の例

.. code-block:: php
   :linenos:

   $rowClone = unserialize($serializedRow);

   $bugs = new Bugs();

   // この行をテーブルに再接続し、
   // データベースとの接続を復活させます
   $rowClone->setTable($bugs);

   // これで、行の内容を変更して保存できます
   $rowClone->bug_status = 'FIXED';
   $rowClone->save();

.. _zend.db.table.row.extending:

行クラスの拡張
-------

``Zend_Db_Table_Row`` は、 ``Zend_Db_Table_Row_Abstract``
を継承したデフォルトの具象クラスです。 ``Zend_Db_Table_Row_Abstract``
を継承した具象クラスを新たに作成し、
それを用いて行のインスタンスを作成できます。
独自の行クラスを指定するには、テーブルクラスの protected メンバである ``$_rowClass``
を使用するか、 テーブルオブジェクトのコンストラクタの引数の配列で指定します。

.. _zend.db.table.row.extending.example:

.. rubric:: 独自の行クラスの指定

.. code-block:: php
   :linenos:

   class MyRow extends Zend_Db_Table_Row_Abstract
   {
       // ...独自の処理
   }

   // 独自の行を、テーブルクラスの全インスタンスで
   // デフォルトとして使用するように設定します
   class Products extends Zend_Db_Table_Abstract
   {
       protected $_name = 'products';
       protected $_rowClass = 'MyRow';
   }

   // あるいは、テーブルクラスの特定のインスタンスでのみ
   // 独自の行クラスを使用するように設定します
   $bugs = new Bugs(array('rowClass' => 'MyRow'));

.. _zend.db.table.row.extending.overriding:

行の初期化
^^^^^

行を作成する際にアプリケーション固有のロジックを初期化したい場合は、
その作業を ``init()`` メソッドに移動します。
このメソッドは、行のメタデータの処理がすべて終わった後にコールされます。
メタデータを変更するつもりがないのなら、 ``__construct()``
メソッドを使うよりもこちらのほうを推奨します。

.. _zend.db.table.row.init.usage.example:

.. rubric:: init() メソッドの使用例

.. code-block:: php
   :linenos:

   class MyApplicationRow extends Zend_Db_Table_Row_Abstract
   {
       protected $_role;

       public function init()
       {
           $this->_role = new MyRoleClass();
       }
   }

.. _zend.db.table.row.extending.insert-update:

Zend_Db_Table_Row における Insert、Update および Delete の独自ロジックの定義
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

行クラスは、 ``INSERT`` や ``UPDATE``\ 、 ``DELETE`` の操作の前に、対応する protected
メソッド ``_insert()``\ 、 ``_update()`` および ``_delete()`` をコールします。
行クラスのサブクラスで、これらのメソッドに独自ロジックを追加できます。

特定のテーブルに対して独自のロジックを必要とし、
それがそのテーブル上のすべての操作に対して発生するのなら、
その処理はテーブルクラスの ``insert()``\ 、 ``update()`` および ``delete()``
で実装したほうがよいでしょう。
しかし、独自のロジックを行クラスで実装したほうがよい場合もあります。

独自ロジックの実装を テーブルクラスよりも行クラスで行ったほうがよい例を、
以下にいくつか示します。

.. _zend.db.table.row.extending.overriding-example1:

.. rubric:: 行クラスでの独自ロジックの例

独自ロジックが、そのテーブルのすべての操作に適用されるとは限りません。
状況に応じて独自ロジックを適用するには、 そのロジックを行クラスで実装し、
その行クラスを指定してテーブルクラスのインスタンスを作成します。
指定しなければ、テーブルクラスはデフォルトの行クラスを使用します。

このテーブルでは、データに対する操作内容を ``Zend_Log``
オブジェクトに記録する必要があります。
ただし、それはアプリケーションの設定でログ記録を有効にしている場合のみとします。

.. code-block:: php
   :linenos:

   class MyLoggingRow extends Zend_Db_Table_Row_Abstract
   {
       protected function _insert()
       {
           $log = Zend_Registry::get('database_log');
           $log->info(Zend_Debug::dump($this->_data,
                                       "INSERT: $this->_tableClass",
                                       false)
                     );
       }
   }

   // $loggingEnabled はサンプルとして使用するプロパティで、
   // これはアプリケーションの設定によって決まるものとします
   if ($loggingEnabled) {
       $bugs = new Bugs(array('rowClass' => 'MyLoggingRow'));
   } else {
       $bugs = new Bugs();
   }

.. _zend.db.table.row.extending.overriding-example2:

.. rubric:: 挿入するデータの記録を複数のテーブルで行う行クラスの例

複数のテーブルで、共通の独自ロジックを使用することもあるでしょう。
同じロジックをすべてのテーブルクラスで実装するのではなく、
その場合はその動作を行クラスで定義しましょう。
そして各テーブルでその行クラスを使用するのです。

この例では、ログ記録用のコードは全テーブルクラスで同一です。

.. code-block:: php
   :linenos:

   class MyLoggingRow extends Zend_Db_Table_Row_Abstract
   {
       protected function _insert()
       {
           $log = Zend_Registry::get('database_log');
           $log->info(Zend_Debug::dump($this->_data,
                                       "INSERT: $this->_tableClass",
                                       false)
                     );
       }
   }

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';
       protected $_rowClass = 'MyLoggingRow';
   }

   class Products extends Zend_Db_Table_Abstract
   {
       protected $_name = 'products';
       protected $_rowClass = 'MyLoggingRow';
   }

.. _zend.db.table.row.extending.inflection:

Zend_Db_Table_Row における変形の定義
^^^^^^^^^^^^^^^^^^^^^^^^^^^

テーブルのクラス名を *RDBMS* のテーブル名とあわせるために、 **inflection (変形)**
と呼ばれる文字列変換を使用することを好む方もいます。

``Zend_Db`` クラス群は、デフォルトでは変形をサポートしていません。
この方針については :ref:`語尾変化の拡張 <zend.db.table.extending.inflection>` で説明します。

変形をさせたい場合は、変換処理を自前で実装する必要があります。そのためには、
独自の行クラスで ``_transformColumn()`` メソッドをオーバーライドし、
テーブルクラスでクエリを実行する際にその独自行クラスを使用します。

.. _zend.db.table.row.extending.inflection.example:

.. rubric:: 変換処理の定義例

これにより、カラム名を変形させたものでアクセスできるようになります。
行クラスの ``_transformColumn()``
メソッドを使用して、データベースのテーブル内のカラム名を変更しています。

.. code-block:: php
   :linenos:

   class MyInflectedRow extends Zend_Db_Table_Row_Abstract
   {
       protected function _transformColumn($columnName)
       {
           $nativeColumnName = myCustomInflector($columnName);
           return $nativeColumnName;
       }
   }

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';
       protected $_rowClass = 'MyInflectedRow';
   }

   $bugs = new Bugs();
   $row = $bugs->fetchNew();

   // キャメルケース形式のカラム名を使用します。
   // 変換関数により、これをデータベース内での実際の形式に
   // 変換します。
   $row->bugDescription = 'New description';

変換関数を書くのはあなたの役割です。 Zend Framework
では、そのような関数は用意していません。



.. _`行データゲートウェイ`: http://www.martinfowler.com/eaaCatalog/rowDataGateway.html
