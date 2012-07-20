.. _zend.db.table:

Zend_Db_Table
=============

.. _zend.db.table.introduction:

導入
--

``Zend_Db_Table`` クラスは、データベースのテーブルへの
オブジェクト指向のインターフェイスです。
テーブルに対するさまざまな共通操作のためのメソッドを提供します。
基底クラスは拡張可能なので、独自のロジックを組み込むこともできます。

``Zend_Db_Table`` は、 `テーブルデータゲートウェイ`_
パターンを実装したものです。また、そのほかにも `行データゲートウェイ`_
パターンを実装したクラスも含んでいます。

.. _zend.db.table.concrete:

Zend_Db_Table を具象クラスとして使用する方法
-----------------------------

Zend Framework 1.9 以降では、 ``Zend_Db_Table`` のインスタンスを作成できます。
つまり、一つのテーブルに対して select、insert、update、delete
などといった単純な操作を行うためだけにわざわざ基底クラスを継承して設定する必要がなくなるということです。
以下に、もっとも単純な使用例を示します。

.. _zend.db.table.defining.concrete-instantiation.example1:

.. rubric:: 文字列で名前を指定するだけのテーブルクラスの宣言

.. code-block:: php
   :linenos:

   Zend_Db_Table::setDefaultAdapter($dbAdapter);
   $bugTable = new Zend_Db_Table('bug');

これが、もっとも単純な使用例です。 以下で説明する ``Zend_Db_Table``
のオプションはまったく設定していません。
具象クラスの使用例に加えてより複雑なリレーション機能を使いたくなったときは
``Zend_Db_Table_Definition`` のドキュメントを参照ください。

.. _zend.db.table.defining:

テーブルクラスの定義
----------

データベース内でアクセスしたいテーブルそれぞれについて、 ``Zend_Db_Table_Abstract``
を継承したクラスを定義します。

.. _zend.db.table.defining.table-schema:

テーブル名およびスキーマの定義
^^^^^^^^^^^^^^^

そのクラスが定義しているデータベースのテーブルを定義するには、 protected な変数
``$_name`` を使用します。
これは文字列で、データベースでのテーブル名を指定する必要があります。

.. _zend.db.table.defining.table-schema.example1:

.. rubric:: テーブル名を明示的に指定することによるテーブルクラスの宣言

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';
   }

テーブル名を指定しなかった場合のデフォルトは、クラス名となります。
このデフォルトを使用する場合は、クラス名をデータベースでのテーブル名と一致させる必要があります。

.. _zend.db.table.defining.table-schema.example:

.. rubric:: テーブル名を暗黙的に指定することによるテーブルクラスの宣言

.. code-block:: php
   :linenos:

   class bugs extends Zend_Db_Table_Abstract
   {
       // テーブル名とクラス名が一致します
   }

テーブルのスキーマについても、protected 変数 ``$_schema`` で宣言できます。 あるいは
``$_name``
プロパティでテーブル名の前にスキーマ名をつなげて指定することもできます。
``$_name`` で指定したスキーマのほうが、 ``$_schema``
プロパティで指定したスキーマよりも優先されます。 *RDBMS*
によってはスキーマのことを「データベース」や「表領域」
などということもありますが、同じように使用できます。
スキーマを、テーブル名の一部として宣言することもできます。

.. _zend.db.table.defining.table-schema.example3:

.. rubric:: テーブルクラスでのスキーマの宣言

.. code-block:: php
   :linenos:

   // 一つ目の方法
   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_schema = 'bug_db';
       protected $_name   = 'bugs';
   }

   // 二つ目の方法
   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bug_db.bugs';
   }

   // スキーマを $_name と $_schema の両方で指定した場合は、
   // $_name で指定したものが優先されます

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name   = 'bug_db.bugs';
       protected $_schema = 'ignored';
   }

スキーマ名とテーブル名は、コンストラクタの設定ディレクティブでも指定できます。
これは、 ``$_name`` や ``$_schema``
といったプロパティで設定したデフォルト値を上書きします。 ``name``
ディレクティブで指定したスキーマ名は、 ``schema``
オプションで指定したスキーマ名より優先されます。

.. _zend.db.table.defining.table-schema.example.constructor:

.. rubric:: インスタンス作成時のテーブル名とスキーマ名の指定

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
   }

   // 最初の方法

   $tableBugs = new Bugs(array('name' => 'bugs', 'schema' => 'bug_db'));

   // もうひとつの方法

   $tableBugs = new Bugs(array('name' => 'bug_db.bugs'));

   // スキーマを 'name' と 'schema' の両方で指定した場合は、
   // 'name' で指定したものが優先されます

   $tableBugs = new Bugs(array('name' => 'bug_db.bugs',
                               'schema' => 'ignored'));

スキーマ名を指定しなかった場合のデフォルトは、
そのデータベースアダプタが接続しているスキーマとなります。

.. _zend.db.table.defining.primary-key:

テーブルの主キーの定義
^^^^^^^^^^^

すべてのテーブルは主キーを持たなければなりません。
主キーカラムを宣言するには、protected 変数 ``$_primary`` を使用します。
これは、単一のカラムの名前を表す文字列か、
もし主キーが複合キーの場合はカラム名の配列となります。

.. _zend.db.table.defining.primary-key.example:

.. rubric:: 主キーを指定する例

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';
       protected $_primary = 'bug_id';
   }

主キーを指定しなかった場合は、 ``Zend_Db_Table_Abstract`` は ``describeTable()``
メソッドの情報に基づいて主キーを見つけます。

.. note::

   すべてのテーブルクラスは、行を一意に決定するために
   どのカラムを使用するのかを知っている必要があります。
   テーブルクラスの定義やコンストラクタの引数、 あるいは ``describeTable()``
   によるメタデータで主キーカラムが定義されていない場合は、 そのテーブルを
   Zend_Db_Table で使用することはできません。

.. _zend.db.table.defining.setup:

テーブルの設定メソッドのオーバーライド
^^^^^^^^^^^^^^^^^^^

テーブルクラスのインスタンスを作成する際に、 コンストラクタ内でいくつかの
protected メソッドをコールします。
これにより、テーブルのメタデータを初期化します。
これらのメソッドを拡張して、メタデータを明示的に定義することも可能です。
その場合は、メソッドの最後で親クラスの同名のメソッドをコールすることを忘れないようにしましょう。

.. _zend.db.table.defining.setup.example:

.. rubric:: \_setupTableName() メソッドのオーバーライドの例

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected function _setupTableName()
       {
           $this->_name = 'bugs';
           parent::_setupTableName();
       }
   }

オーバーライドできるメソッドは、次のとおりです。

- ``_setupDatabaseAdapter()`` は、アダプタが設定されているかどうかを調べ、
  必要に応じてレジストリからデフォルトのアダプタを取得します。
  このメソッドをオーバーライドすると、
  データベースアダプタを別の場所から取得できます。

- ``_setupTableName()`` は、デフォルトのテーブル名をクラス名に設定します。
  このメソッドをオーバーライドすると、
  この処理の前にテーブル名を指定できます。

- ``_setupMetadata()`` はテーブル名が "schema.table" 形式の場合にスキーマを設定し、
  ``describeTable()`` をコールしてメタデータ情報を取得します。
  このメソッドが返す配列のカラム ``$_cols`` の情報をデフォルトで使用します。
  このメソッドをオーバーライドすると、カラムを指定できます。

- ``_setupPrimaryKey()`` はデフォルトの主キーを ``describeTable()``
  から取得した内容に設定し、配列 ``$_cols``
  に主キーカラムが含まれているかどうかを調べます。
  このメソッドをオーバーライドすると、主キーカラムを指定できます。

.. _zend.db.table.initialization:

テーブルの初期化
^^^^^^^^

テーブルクラスの作成時にアプリケーション固有のロジックを初期化したい場合は、
その作業を ``init()`` メソッドで行います。
これは、テーブルのメタデータがすべて処理された後にコールされます。
メタデータを変更するつもりがないのなら、 ``__construct``
メソッドよりもこちらを使用することを推奨します。

.. _zend.db.table.defining.init.usage.example:

.. rubric:: init() メソッドの使用例

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_observer;

       public function init()
       {
           $this->_observer = new MyObserverClass();
       }
   }

.. _zend.db.table.constructing:

テーブルのインスタンスの作成
--------------

テーブルクラスを使用する前に、コンストラクタでそのインスタンスを作成します。
コンストラクタの引数はオプションの配列となります。
テーブルのコンストラクタのオプションのうち、最も重要なのは
データベースアダプタのインスタンスとなります。 これは *RDBMS*
への有効な接続を表します。
データベースアダプタをテーブルクラスに指定する方法は三通りあります。
それぞれについて、以下で説明します。

.. _zend.db.table.constructing.adapter:

データベースアダプタの指定
^^^^^^^^^^^^^

データベースアダプタをテーブルクラスに指定する最初の方法は、
``Zend_Db_Adapter_Abstract`` 型のオブジェクトをオプションの配列で渡すことです。
配列のキーは '``db``' となります。

.. _zend.db.table.constructing.adapter.example:

.. rubric:: アダプタオブジェクトを使用した、テーブルの作成の例

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory('PDO_MYSQL', $options);

   $table = new Bugs(array('db' => $db));

.. _zend.db.table.constructing.default-adapter:

デフォルトのデータベースアダプタの設定
^^^^^^^^^^^^^^^^^^^

データベースアダプタをテーブルクラスに指定する二番目の方法は、
デフォルトのデータベースアダプタとして ``Zend_Db_Adapter_Abstract``
型のオブジェクトを宣言することです。そのアプリケーション内で、
これ以降に作成したテーブルインスタンスについてこれが用いられます。
これを行うには、静的メソッド ``Zend_Db_Table_Abstract::setDefaultAdapter()``
を使用します。引数は、 ``Zend_Db_Adapter_Abstract`` 型のオブジェクトとなります。

.. _zend.db.table.constructing.default-adapter.example:

.. rubric:: デフォルトアダプタを使用した、テーブルの作成の例

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory('PDO_MYSQL', $options);
   Zend_Db_Table_Abstract::setDefaultAdapter($db);

   // その後...

   $table = new Bugs();

これは、たとえば起動ファイルなどでデータベースアダプタオブジェクトを作成し、
それをデフォルトのアダプタとして保存しておく場合などに便利です。
これにより、アプリケーション全体で共通のアダプタを使用することが保証されます。
しかし、デフォルトのアダプタのインスタンスは、ひとつだけしか設定できません。

.. _zend.db.table.constructing.registry:

データベースアダプタのレジストリへの保存
^^^^^^^^^^^^^^^^^^^^

データベースアダプタをテーブルクラスに指定する三番目の方法は、
文字列ををオプションの配列で渡すことです。 配列のキーは、この場合も '``db``'
となります。 この文字列は、静的な ``Zend_Registry``
インスタンスのキーとして使用します。 このキーのエントリが ``Zend_Db_Adapter_Abstract``
型のオブジェクトとなります。

.. _zend.db.table.constructing.registry.example:

.. rubric:: レジストリのキーを使用した、テーブルの作成の例

.. code-block:: php
   :linenos:

   $db = Zend_Db::factory('PDO_MYSQL', $options);
   Zend_Registry::set('my_db', $db);

   // その後...

   $table = new Bugs(array('db' => 'my_db'));

デフォルトアダプタの指定と同様、これにより、
アプリケーション全体で共通のアダプタを使用することが保証されます。
レジストリには複数のアダプタインスタンスを保存できるため、
より柔軟に使用できます。指定したアダプタインスタンスは 特定の *RDBMS*
やデータベースインスタンスに固有のものとなります。
複数のデータベースにアクセスする必要がある場合は、 複数のアダプタが必要です。

.. _zend.db.table.insert:

テーブルへの行の挿入
----------

テーブルオブジェクトを使用して、そのオブジェクトの元になっているテーブルに
行を挿入できます。そのためには、テーブルオブジェクトの ``insert()``
メソッドを使用します。引数は連想配列で、 カラム名と値の対応を指定します。

.. _zend.db.table.insert.example:

.. rubric:: テーブルへの挿入の例

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $data = array(
       'created_on'      => '2007-03-22',
       'bug_description' => '何かおかしい',
       'bug_status'      => 'NEW'
   );

   $table->insert($data);

デフォルトでは、配列内の値はリテラル値として扱われ、
パラメータを使用して挿入されます。これを *SQL* の式として扱いたい場合は、
文字列ではない形式で指定する必要があります。その際には ``Zend_Db_Expr``
型のオブジェクトを使用します。

.. _zend.db.table.insert.example-expr:

.. rubric:: 式をテーブルに挿入する例

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $data = array(
       'created_on'      => new Zend_Db_Expr('CURDATE()'),
       'bug_description' => '何かおかしい',
       'bug_status'      => 'NEW'
   );

上の例では、テーブルには自動インクリメントの主キーがあるものとします。 これは
``Zend_Db_Table_Abstract`` のデフォルトの挙動ですが、
それ以外の形式の主キーも扱えます。以下の節では、
さまざまな形式の主キーを扱う方法を説明します。

.. _zend.db.table.insert.key-auto:

自動インクリメントのキーを持つテーブルの使用
^^^^^^^^^^^^^^^^^^^^^^

自動インクリメントの主キーは、 *SQL* の ``INSERT``
文で主キー列を省略した場合に一意な整数値を生成します。

``Zend_Db_Table_Abstract`` で protected 変数 ``$_sequence`` の値を boolean の ``TRUE``
にすると、そのテーブルは自動インクリメントの主キーを持つものとみなされます。

.. _zend.db.table.insert.key-auto.example:

.. rubric:: 自動インクリメントの主キーを持つテーブルを宣言する例

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';

       // これは Zend_Db_Table_Abstract クラスのデフォルト設定です。
       // 特に定義する必要はありません。
       protected $_sequence = true;
   }

MySQL、Microsoft SQL Server そして SQLite などの *RDBMS*
が、主キーの自動インクリメントをサポートしています。

PostgreSQL の ``SERIAL`` 記法を使用すると、
テーブル名とカラム名をもとにして暗黙的にシーケンスを定義します。
新しい行を作成した際にはこのシーケンスを用いてキーの値を生成します。 IBM DB2
には、これと同等の動作をする ``IDENTIFY`` という記法があります。
これらの記法を使用する場合は、 ``Zend_Db_Table`` クラスで ``$_sequence`` を ``TRUE``
と設定し、 自動インクリメントを有効にしてください。

.. _zend.db.table.insert.key-sequence:

シーケンスを持つテーブルの使用
^^^^^^^^^^^^^^^

シーケンスとはデータベースのオブジェクトの一種で、
一意な値を生成するものです。これを、
ひとつあるいは複数のテーブルの主キーの値として使用できます。

``$_sequence`` に文字列を設定すると、 ``Zend_Db_Table_Abstract`` は、それがデータベースの
シーケンスオブジェクトの名前であるとみなします。
シーケンスを実行して新しい値を生成し、その値を ``INSERT`` 操作で使用します。

.. _zend.db.table.insert.key-sequence.example:

.. rubric:: シーケンスを用いたテーブルを宣言する例

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';

       protected $_sequence = 'bug_sequence';
   }

Oracle、PostgreSQL そして IBM DB2 などの *RDBMS* が、
データベースでのシーケンスオブジェクトをサポートしています。

PostgreSQL および IBM DB2 は、
暗黙的にシーケンスを定義してカラムに関連付ける構文もサポートしています。
この記法を使う場合は、
そのテーブルで自動インクリメントキーのカラムを使用するようにします。
シーケンスのキーの次の値を取得することがある場合にのみ
シーケンス名を文字列で定義します。

.. _zend.db.table.insert.key-natural:

自然キーを持つテーブルの使用
^^^^^^^^^^^^^^

自然キーを持つテーブルもあります。自然キーとは、
テーブルやシーケンスによって自動生成されるもの以外のキーということです。
この場合は、主キーの値を指定する必要があります。

``$_sequence`` の値を boolean の ``FALSE`` にすると、 ``Zend_Db_Table_Abstract``
はそのテーブルが自然キーを持つものとみなします。 ``insert()``
メソッドを使用する際には、
主キーカラムの値をデータの配列で指定する必要があります。
指定しなかった場合、このメソッドは ``Zend_Db_Table_Exception`` をスローします。

.. _zend.db.table.insert.key-natural.example:

.. rubric:: 自然キーを用いたテーブルを宣言する例

.. code-block:: php
   :linenos:

   class BugStatus extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bug_status';

       protected $_sequence = false;
   }

.. note::

   自然キーのテーブルは、すべての *RDBMS* がサポートしています。
   自然キーを使用するテーブルの例としては、
   ルックアップテーブルや多対多リレーションの中間テーブル、
   そして複合主キーを持つ大半のテーブルなどがあります。

.. _zend.db.table.update:

テーブルの行の更新
---------

データベースのテーブルの行を更新するには、テーブルクラスの ``update``
メソッドを使用します。
このメソッドには二つの引数を指定します。変更するカラムと
それらのカラムに代入する新しい値を表す連想配列、 そして ``UPDATE``
操作の対象となる行を指定する ``WHERE`` 句で使用する *SQL* 式です。

.. _zend.db.table.update.example:

.. rubric:: テーブルの行の更新の例

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $where = $table->getAdapter()->quoteInto('bug_id = ?', 1234);

   $table->update($data, $where);

テーブルの ``update()`` メソッドはデータベースアダプタの :ref:`update()
<zend.db.adapter.write.update>` メソッドへのプロキシなので、 二番目の引数は、 *SQL*
式の配列にできます。 その場合、それぞれの式が論理演算子 ``AND`` で連結されます。

.. note::

   *SQL* 式の中の値や識別子は、自動的にはクォートされません。
   クォートが必要な値や識別子を使用する場合は、自分でクォートする必要があります。
   データベースアダプタの ``quote()``\ 、 ``quoteInto()`` および ``quoteIdentifier()``
   を使用してください。

.. _zend.db.table.delete:

テーブルからの行の削除
-----------

データベースのテーブルから行を削除するには、テーブルクラスの ``delete()``
メソッドを使用します。 このメソッドにはひとつの引数を指定します。この引数は
``WHERE`` 句で使用する *SQL* 式で、 これにより、削除対象となる行を指定します。

.. _zend.db.table.delete.example:

.. rubric:: テーブルからの行の削除の例

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $where = $table->getAdapter()->quoteInto('bug_id = ?', 1235);

   $table->delete($where);

テーブルの ``delete()`` メソッドはデータベースアダプタの :ref:`delete()
<zend.db.adapter.write.delete>` メソッドへのプロキシなので、 引数は *SQL*
式の配列とすることもできます。 その場合、それぞれの式が論理演算子 ``AND``
で連結されます。

.. note::

   *SQL* 式の中の値や識別子は、自動的にはクォートされません。
   クォートが必要な値や識別子を使用する場合は、自分でクォートする必要があります。
   データベースアダプタの ``quote()``\ 、 ``quoteInto()`` および ``quoteIdentifier()``
   を使用してください。

.. _zend.db.table.find:

主キーによる行の検索
----------

データベースのテーブルに対して、指定した主キーの値に対応する行を問い合わせるには
``find()`` メソッドを使用します。
このメソッドの最初の引数は、テーブルの主キーに対応する
単一の値か、あるいは複数の値の配列となります。

.. _zend.db.table.find.example:

.. rubric:: 主キーの値によって行を捜す例

.. code-block:: php
   :linenos:

   $table = new Bugs();

   // 単一の行を探し、
   // Rowset を返します
   $rows = $table->find(1234);

   // 複数の行を探し、
   // こちらも Rowset を返します
   $rows = $table->find(array(1234, 5678));

単一の値を指定した場合は、このメソッドが返す行数は最大でも一行になります。
主キーの値が重複することはないので、指定した値に対応する行は
テーブル内で最大でも一行だけだからです。
複数の値を配列で指定した場合は、このメソッドが返す結果の最大数は
配列で指定した値の数となります。

``find()``
メソッドの返す行数は、主キーで指定した値より少なくなるかもしれません。
たとえば指定した値に対応する行がデータベースのテーブルに存在しなかった場合などです。
このメソッドが返す行数がゼロになる可能性もあります。
このように結果の行数が可変なので、 ``find()`` メソッドが返すオブジェクトの型は
``Zend_Db_Table_Rowset_Abstract`` となります。

主キーが複合キーの場合、つまり複数のカラムから構成されるキーの場合は、
追加のカラムを ``find()`` メソッドの引数で指定します。
テーブルの主キーのカラム数と同じ数の引数を指定しなければなりません。

複合主キーのテーブルから複数行を取得するには、
各引数を配列で指定します。これらすべての配列の要素数は同じでなければなりません。
各配列の値が、その順にキー列の値として用いられます。
たとえば、すべての配列の最初の要素で複合主キーの最初の値を指定し、
すべての配列の二番目の要素で複合主キーの二番目の値を設定し、……
というようになります。

.. _zend.db.table.find.example-compound:

.. rubric:: 複合主キーの値の指定による行の取得の例

以下の ``find()`` メソッドは、データベース内のふたつの行にマッチします。
最初の行の主キーの値は (1234, 'ABC') で、次の行の主キーの値は (5678, 'DEF')
となります。

.. code-block:: php
   :linenos:

   class BugsProducts extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs_products';
       protected $_primary = array('bug_id', 'product_id');
   }

   $table = new BugsProducts();

   // 単一の行を複合主キーで探し、
   // Rowset を返します
   $rows = $table->find(1234, 'ABC');

   // 複数の行を複合主キーで探し、
   // こちらも Rowset を返します
   $rows = $table->find(array(1234, 5678), array('ABC', 'DEF'));

.. _zend.db.table.fetch-all:

行セットの問い合わせ
----------

.. _zend.db.table.fetch-all.select:

Select API
^^^^^^^^^^

.. warning::

   取得操作用の *API* は変更され、 ``Zend_Db_Table_Select``
   オブジェクトでクエリを変更できるようになりました。
   しかし、昔ながらの方法である ``fetchRow()`` や ``fetchAll()``
   は今でも同じように使用できます。

   次の文は、どれも正しくて同じ動作をします。
   しかし、新しい使用法に対応するためにもできるだけ新しい書き方に変更することをお勧めします。



      .. code-block:: php
         :linenos:

         /**
          * 行セットを取得します
          */
         $rows = $table->fetchAll(
             'bug_status = "NEW"',
             'bug_id ASC',
             10,
             0
             );
         $rows = $table->fetchAll(
             $table->select()
                 ->where('bug_status = ?', 'NEW')
                 ->order('bug_id ASC')
                 ->limit(10, 0)
             );
         // またはバインディングを用いて
         $rows = $table->fetchAll(
             $table->select()
                 ->where('bug_status = :status')
                 ->bind(array(':status'=>'NEW')
                 ->order('bug_id ASC')
                 ->limit(10, 0)
             );

         /**
          * 単一の行を取得します
          */
         $row = $table->fetchRow(
             'bug_status = "NEW"',
             'bug_id ASC'
             );
         $row = $table->fetchRow(
             $table->select()
                 ->where('bug_status = ?', 'NEW')
                 ->order('bug_id ASC')
             );
         // またはバインディングを用いて
         $row = $table->fetchRow(
             $table->select()
                 ->where('bug_status = :status')
                 ->bind(array(':status'=>'NEW')
                 ->order('bug_id ASC')
             );





``Zend_Db_Table_Select`` オブジェクトは ``Zend_Db_Select`` を継承したものであり、
クエリにはいくつか制限があります。追加された機能や制限事項を以下にまとめます。

- fetchRow あるいは fetchAll のクエリで、カラムのサブセットを返すことが **できます**\
  。 結果が巨大なものになるけれどもその中には使用しないカラムもある
  といった場合に有用です。

- select する際に、式の結果をカラムとして指定することが **できます**\ 。
  しかし、この場合は行 (あるいは行セット) は ``readOnly`` となり、save()
  することはできません。 ``readOnly`` な ``Zend_Db_Table_Row`` に対して ``save()``
  を実行しようとすると、例外がスローされます。

- select で JOIN 句を使用して、複数テーブルからの検索を行うことが **できます**\ 。

- JOIN したテーブルのカラムを結果の行や行セットに指定することは **できません**\
  。 そうすると、PHP のエラーが発生します。 これにより、 ``Zend_Db_Table``
  の整合性が保証されます。つまり、 ``Zend_Db_Table_Row``
  はその親のテーブルのカラムしか参照しないということです。





      .. _zend.db.table.qry.rows.set.simple.usage.example:

      .. rubric:: 単純な使用法

      .. code-block:: php
         :linenos:

         $table = new Bugs();

         $select = $table->select();
         $select->where('bug_status = ?', 'NEW');

         $rows = $table->fetchAll($select);



このコンポーネントでは「流れるようなインターフェイス」
を実装しているので、この例はもっと省略して書くこともできます。





      .. _zend.db.table.qry.rows.set.fluent.interface.example:

      .. rubric:: 流れるようなインターフェイスの例

      .. code-block:: php
         :linenos:

         $table = new Bugs();

         $rows =
             $table->fetchAll($table->select()->where('bug_status = ?', 'NEW'));



.. _zend.db.table.fetch-all.usage:

行セットの取得
^^^^^^^

主キーの値以外を条件として行のセットを問い合わせるには、 テーブルクラスの
``fetchAll()`` メソッドを使用します。 このメソッドは、 ``Zend_Db_Table_Rowset_Abstract``
型のオブジェクトを返します。

.. _zend.db.table.qry.rows.set.finding.row.example:

.. rubric:: 式から行を取得する例

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $select = $table->select()->where('bug_status = ?', 'NEW');

   $rows = $table->fetchAll($select);

``ORDER BY`` での並べ替えの条件句やオフセットを表す整数値を指定して、
クエリの返す結果を絞りこむことができます。 これらの値は ``LIMIT``
句で用いられます。 ``LIMIT`` 構文をサポートしていない *RDBMS*
では、それと同等のロジックで用いられます。

.. _zend.db.table.fetch-all.example2:

.. rubric:: 式を使用した行の検索の例

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $order  = 'bug_id';

   // 21 番目から 30 番目の行を返します
   $count  = 10;
   $offset = 20;

   $select = $table->select()->where('bug_status = ?', 'NEW')
                             ->order($order)
                             ->limit($count, $offset);

   $rows = $table->fetchAll($select);

これらのオプションはどれも、必須ではありません。 ORDER
句を省略した場合は、結果セットに複数の行が含まれる場合の並び順は予測不可能です。
LIMIT 句を省略した場合は、WHERE
句にマッチするすべての行を取得することになります。

.. _zend.db.table.advanced.usage:

高度な使用法
^^^^^^

リクエストの内容をより明確に指定して最適化するために、
行/行セットが返すカラムの数を絞り込みたいこともあるでしょう。 これは、select
オブジェクトの FROM 句で行います。 FROM 句の最初の引数は ``Zend_Db_Select``
オブジェクトと同じですが、 さらに ``Zend_Db_Table_Abstract``
のインスタンスを渡すこともでき、テーブル名を自動的に検出します。





      .. _zend.db.table.qry.rows.set.retrieving.a.example:

      .. rubric:: 指定したカラムの取得

      .. code-block:: php
         :linenos:

         $table = new Bugs();

         $select = $table->select();
         $select->from($table, array('bug_id', 'bug_description'))
                ->where('bug_status = ?', 'NEW');

         $rows = $table->fetchAll($select);



.. important::

   この状態でも、行セット自体は '正しい' 形式です。
   単にひとつのテーブルの中の一部のカラムを含んでいるというだけです。
   この中の行に対して save() メソッドをコールすると、
   そこに含まれているフィールドだけを更新します。

FROM 句で式を指定すると、その結果を readOnly の行/行セット として返します。この例では、bugs テーブルを検索して 個人別のバグの報告件数を取得しています。 GROUP 句に注目しましょう。これで、返される行に 'count' というカラムが含まれるようになり、 スキーマの他のカラムと同じようにアクセスできるようになります。





      .. _zend.db.table.qry.rows.set.retrieving.b.example:

      .. rubric:: 式の結果をカラムとして取得する

      .. code-block:: php
         :linenos:

         $table = new Bugs();

         $select = $table->select();
         $select->from($table,
                       array('COUNT(reported_by) as `count`', 'reported_by'))
                ->where('bug_status = ?', 'NEW')
                ->group('reported_by');

         $rows = $table->fetchAll($select);

クエリの一部にルックアップテーブルを使用し、
より絞り込んで取得することもできます。 この例では、検索時に accounts
テーブルを使用して 'Bob' が報告したすべてのバグを探しています。





      .. _zend.db.table.qry.rows.set.refine.example:

      .. rubric:: ルックアップテーブルによる fetchAll() の結果の絞込み

      .. code-block:: php
         :linenos:

         $table = new Bugs();

         // join する際には、from 部を指定して取得するのが重要です
         $select = $table->select(Zend_Db_Table::SELECT_WITH_FROM_PART);
         $select->setIntegrityCheck(false)
                ->where('bug_status = ?', 'NEW')
                ->join('accounts', 'accounts.account_name = bugs.reported_by')
                ->where('accounts.account_name = ?', 'Bob');

         $rows = $table->fetchAll($select);



``Zend_Db_Table_Select`` の主な使用目的は、 制約を強要して正しい形式の SELECT
クエリを作成することです。 しかし時には、 ``Zend_Db_Table_Row``
の柔軟性が必要であって
行を更新したり削除したりすることはないということもあります。
そんな場合には、setIntegrityCheck に ``FALSE`` を渡して行/行セットを取得できます。
この場合に返される行/行セットは 'ロックされた' 行 (save()、delete()
やフィールドの設定用メソッドを実行すると例外が発生する) となります。

.. _zend.db.table.qry.rows.set.integrity.example:

.. rubric:: Zend_Db_Table_Select の整合性チェックを削除し、JOIN した行を許可する

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $select = $table->select(Zend_Db_Table::SELECT_WITH_FROM_PART)
                   ->setIntegrityCheck(false);
   $select->where('bug_status = ?', 'NEW')
          ->join('accounts',
                 'accounts.account_name = bugs.reported_by',
                 'account_name')
          ->where('accounts.account_name = ?', 'Bob');

   $rows = $table->fetchAll($select);

.. _zend.db.table.fetch-row:

単一の行の問い合わせ
----------

``fetchAll()`` と同じような条件を指定して、 単一の行を問い合わせることができます。

.. _zend.db.table.fetch-row.example1:

.. rubric:: 式から単一の行を取得する例

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $select  = $table->select()->where('bug_status = ?', 'NEW')
                              ->order('bug_id');

   $row = $table->fetchRow($select);

このメソッドは、 ``Zend_Db_Table_Row_Abstract`` 型のオブジェクトを返します。
指定した検索条件に一致する行がデータベースのテーブルにない場合は、 ``fetchRow()``
は *PHP* の ``NULL`` 値を返します。

.. _zend.db.table.info:

テーブルのメタデータ情報の取得
---------------

``Zend_Db_Table_Abstract`` クラスは、メタデータに関するいくつかの情報を提供します。
``info()`` メソッドは配列を返し、その中には
テーブルについての情報、カラムや主キー、その他のメタデータが含まれます。

.. _zend.db.table.info.example:

.. rubric:: テーブル名を取得する例

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $info = $table->info();

   echo "テーブル名は " . $info['name'] . " です\n";

``info()`` メソッドが返す配列のキーについて、 以下にまとめます。

- **name** => テーブルの名前。

- **cols** => テーブルのカラム名を表す配列。

- **primary** => 主キーのカラム名を表す配列。

- **metadata** => カラム名とカラムに関する情報を関連付けた連想配列。 これは
  ``describeTable()`` メソッドが返す情報です。

- **rowClass** => このテーブルインスタンスのメソッドが返す行オブジェクトで使用する
  具象クラス名。デフォルトは ``Zend_Db_Table_Row`` です。

- **rowsetClass** =>
  このテーブルインスタンスのメソッドが返す行セットオブジェクトで使用する
  具象クラス名。デフォルトは ``Zend_Db_Table_Rowset`` です。

- **referenceMap** =>
  このテーブルから任意の親テーブルに対する参照の情報を含む連想配列。 :ref:`
  <zend.db.table.relationships.defining>` を参照ください。

- **dependentTables** => このテーブルを参照しているテーブルのクラス名の配列。 :ref:`
  <zend.db.table.relationships.defining>` を参照ください。

- **schema** => テーブルのスキーマ (あるいはデータベース、あるいは表領域) の名前。

.. _zend.db.table.metadata.caching:

テーブルのメタデータのキャッシュ
----------------

デフォルトでは ``Zend_Db_Table_Abstract`` の問合せ先は
テーブルオブジェクトのインスタンスの :ref:`テーブルメタデータ <zend.db.table.info>`
が指すデータベースとなります。
つまり、テーブルオブジェクトを作成する際にデフォルトで行われれることは、アダプタの
``describeTable()``
メソッドによってデータベースからテーブルのメタデータを取得するということになります。
これを必要とする操作には次のようなものがあります。

- ``insert()``

- ``find()``

- ``info()``

同一のテーブルに対して複数のテーブルオブジェクトを作成する場合などに、
毎回テーブルのめたデータをデータベースに問い合わせることは
パフォーマンスの観点からも好ましくありません。
このような場合のために、データベースから取得したテーブルメタデータをキャッシュしておくことができます。

テーブルのメタデータをキャッシュする主な方法は、次のふたつです。



   - **Zend_Db_Table_Abstract::setDefaultMetadataCache() をコールする**-
     これは、すべてのテーブルクラスで使用するデフォルトのキャッシュオブジェクトを一度で設定できます。

   - **Zend_Db_Table_Abstract::__construct() を設定する**-
     これは、特定のテーブルクラスのインスタンスでh使用するキャッシュオブジェクトを設定できます。

どちらの場合においても、メソッドの引数はひとつで、 ``NULL``
(キャッシュを使用しない) あるいは :ref:`Zend_Cache_Core <zend.cache.frontends.core>`
のインスタンスを指定します。これらを組み合わせることで、
デフォルトのメタデータキャッシュを指定した上で
特定のテーブルオブジェクトについてのみ別のキャッシュを使用させることができます。

.. _zend.db.table.metadata.caching-default:

.. rubric:: すべてのテーブルオブジェクトでのデフォルトのメタデータキャッシュの使用

次のコードは、デフォルトのメタデータキャッシュをすべてのテーブルオブジェクトで使用する方法を示すものです。

.. code-block:: php
   :linenos:

   // まずキャッシュを作成します
   $frontendOptions = array(
       'automatic_serialization' => true
       );

   $backendOptions  = array(
       'cache_dir'                => 'cacheDir'
       );

   $cache = Zend_Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   // 次に、それをすべてのテーブルオブジェクトで使用するように設定します
   Zend_Db_Table_Abstract::setDefaultMetadataCache($cache);

   // テーブルクラスも必要です
   class Bugs extends Zend_Db_Table_Abstract
   {
       // ...
   }

   // Bugs の各インスタンスは、これでデフォルトのメタデータキャッシュを用いるようになります
   $bugs = new Bugs();

.. _zend.db.table.metadata.caching-instance:

.. rubric:: 特定のテーブルオブジェクトでのメタデータキャッシュの使用

次のコードは、メタデータキャッシュを特定のテーブルオブジェクトに設定する方法を示すものです。

.. code-block:: php
   :linenos:

   // まずキャッシュを作成します
   $frontendOptions = array(
       'automatic_serialization' => true
       );

   $backendOptions  = array(
       'cache_dir'                => 'cacheDir'
       );

   $cache = Zend_Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   // テーブルクラスも必要です
   class Bugs extends Zend_Db_Table_Abstract
   {
       // ...
   }

   // インスタンスを設定します
   $bugs = new Bugs(array('metadataCache' => $cache));

.. note::

   **キャッシュのフロントエンドにおける自動シリアライズ**

   アダプタの ``describeTable()`` メソッドの返す内容は配列なので、 ``Zend_Cache_Core``
   フロントエンドのオプション ``automatic_serialization`` は ``TRUE`` と設定しましょう。

上の例では ``Zend_Cache_Backend_File`` を使用していますが、
状況に応じて適切なバックエンドを使い分けることができます。詳細な情報は
:ref:`Zend_Cache <zend.cache>` を参照ください。

.. _zend.db.table.metadata.caching.hardcoding:

テーブルのメタデータのハードコーディング
^^^^^^^^^^^^^^^^^^^^

メタデータのキャッシュをより高速にするために、
メタデータをハードコーディングすることもできます。 しかし、そうすると、
テーブルのスキーマが変わるたびにコードを変更しなければならなくなります。
この方法をおすすめできるのは、 実運用環境で最適化が必要となった場合のみです。

メタデータの構造は次のようになります。

.. code-block:: php
   :linenos:

   protected $_metadata = array(
       '<column_name>' => array(
           'SCHEMA_NAME'      => <string>,
           'TABLE_NAME'       => <string>,
           'COLUMN_NAME'      => <string>,
           'COLUMN_POSITION'  => <int>,
           'DATA_TYPE'        => <string>,
           'DEFAULT'          => NULL|<value>,
           'NULLABLE'         => <bool>,
           'LENGTH'           => <string - length>,
           'SCALE'            => NULL|<value>,
           'PRECISION'        => NULL|<value>,
           'UNSIGNED'         => NULL|<bool>,
           'PRIMARY'          => <bool>,
           'PRIMARY_POSITION' => <int>,
           'IDENTITY'         => <bool>,
       ),
       // さらなるカラム...
   );

適切な値を知るには、メタデータキャッシュを使用するのが簡単でしょう。
キャッシュに格納された値をデシリアライズするのです。

この最適化を無効にするには、 ``metadataCacheInClass`` フラグをオフにします。

.. code-block:: php
   :linenos:

   // インスタンス作成時
   $bugs = new Bugs(array('metadataCacheInClass' => false));

   // その後
   $bugs->setMetadataCacheInClass(false);

このフラグはデフォルトで有効になっています。この場合は、 ``$_metadata``
配列はインスタンスの作成時にのみ作成されます。

.. _zend.db.table.extending:

テーブルクラスのカスタマイズおよび拡張
-------------------

.. _zend.db.table.extending.row-rowset:

独自の行クラスあるいは行セットクラスの使用
^^^^^^^^^^^^^^^^^^^^^

デフォルトでは、テーブルクラスが返す行セットは 具象クラス ``Zend_Db_Table_Rowset``
のインスタンスであり、 行セットには具象クラス ``Zend_Db_Table_Row``
のインスタンスの集合が含まれます。
これらのいずれについても、別のクラスを使用することが可能です。
しかし、使用するクラスはそれぞれ ``Zend_Db_Table_Rowset_Abstract`` および
``Zend_Db_Table_Row_Abstract`` を継承したものでなければなりません。

行クラスおよび行セットクラスを指定するには、
テーブルのコンストラクタのオプション配列を使用します。
対応するキーは、それぞれ '``rowClass``' および '``rowsetClass``' となります。
ここには、クラスの名前を文字列で指定します。

.. _zend.db.table.extending.row-rowset.example:

.. rubric:: 行クラスおよび行セットクラスの指定の例

.. code-block:: php
   :linenos:

   class My_Row extends Zend_Db_Table_Row_Abstract
   {
       ...
   }

   class My_Rowset extends Zend_Db_Table_Rowset_Abstract
   {
       ...
   }

   $table = new Bugs(
       array(
           'rowClass'    => 'My_Row',
           'rowsetClass' => 'My_Rowset'
       )
   );

   $where = $table->getAdapter()->quoteInto('bug_status = ?', 'NEW')

   // My_Rowset 型のオブジェクトを返します。
   // その中には My_Row 型のオブジェクトの配列が含まれます。
   $rows = $table->fetchAll($where);

クラスを変更するには、 ``setRowClass()`` メソッドおよび ``setRowsetClass()``
メソッドを使用します。
これは、それ以降に作成される行および行セットに適用されます。
すでに出来上がっている行オブジェクトや行セットオブジェクトには
何の影響も及ぼしません。

.. _zend.db.table.extending.row-rowset.example2:

.. rubric:: 行クラスおよび行セットクラスの変更の例

.. code-block:: php
   :linenos:

   $table = new Bugs();

   $where = $table->getAdapter()->quoteInto('bug_status = ?', 'NEW')

   // Zend_Db_Table_Rowset 型のオブジェクトを返します。
   // その中には Zend_Db_Table_Row 型のオブジェクトの配列が含まれます。
   $rowsStandard = $table->fetchAll($where);

   $table->setRowClass('My_Row');
   $table->setRowsetClass('My_Rowset');

   // My_Rowset 型のオブジェクトを返します。
   // その中には My_Row 型のオブジェクトの配列が含まれます。
   $rowsCustom = $table->fetchAll($where);

   // $rowsStandard オブジェクトはまだ存在しますが、なにも変更されていません

行クラスおよび行セットクラスについての詳細は :ref:` <zend.db.table.row>` および :ref:`
<zend.db.table.rowset>` を参照ください。

.. _zend.db.table.extending.insert-update:

Insert、Update および Delete 時の独自ロジックの定義
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

テーブルクラスの ``insert()`` メソッドや ``update()``
メソッドをオーバーライドできます。
これにより、データベース操作の前に実行される独自のコードを実装できます。
最後に親クラスのメソッドをコールすることを忘れないようにしましょう。

.. _zend.db.table.extending.insert-update.example:

.. rubric:: タイムスタンプを処理する独自ロジック

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';

       public function insert(array $data)
       {
           // タイムスタンプを追加します
           if (empty($data['created_on'])) {
               $data['created_on'] = time();
           }
           return parent::insert($data);
       }

       public function update(array $data, $where)
       {
           // タイムスタンプを追加します
           if (empty($data['updated_on'])) {
               $data['updated_on'] = time();
           }
           return parent::update($data, $where);
       }
   }

``delete()`` メソッドをオーバーライドすることもできます。

.. _zend.db.table.extending.finders:

Zend_Db_Table における独自の検索メソッドの定義
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

もし特定の条件によるテーブルの検索を頻繁に行うのなら、
独自の検索メソッドをテーブルクラスで実装できます。 大半の問い合わせは
``fetchAll()`` を用いて書くことができますが、
アプリケーション内の複数の箇所でクエリを実行する場合には
問い合わせ条件を指定するコードが重複してしまいます。
そんな場合は、テーブルクラスでメソッドを実装し、
よく使う問い合わせを定義しておいたほうが便利です。

.. _zend.db.table.extending.finders.example:

.. rubric:: 状況を指定してバグを検索する独自メソッド

.. code-block:: php
   :linenos:

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs';

       public function findByStatus($status)
       {
           $where = $this->getAdapter()->quoteInto('bug_status = ?', $status);
           return $this->fetchAll($where, 'bug_id');
       }
   }

.. _zend.db.table.extending.inflection:

Zend_Db_Table における語尾変化の定義
^^^^^^^^^^^^^^^^^^^^^^^^^

テーブルのクラス名を *RDBMS* のテーブル名とあわせるために、 **inflection (語尾変化)**
と呼ばれる文字列変換を使用することを好む方もいます。

たとえば、テーブルのクラス名が "BugsProducts" だとすると、クラスのプロパティ
``$_name`` を明示的に宣言しなかった場合は データベース内の物理的なテーブル
"bugs_products" にマッチします。この関連付けでは、 "CamelCase"
形式のクラス名が小文字に変換され、単語の区切りがアンダースコアに変わります。

データベースのテーブル名を、クラス名とは独立したものにすることもできます。
その場合は、テーブルクラスのプロパティ ``$_name`` に、そのクラス名を指定します。

``Zend_Db_Table_Abstract``
は、クラス名とテーブル名を関連付けるための語尾変化は行いません。
テーブルクラスで ``$_name`` の宣言を省略すると、
そのクラス名に正確に一致する名前のテーブルと関連付けられます。

データベースの識別子を変換することは、適切ではありません。
なぜなら、それは不明確な状態を引き起こし、
時には識別子にアクセスできなくなってしまうからです。 *SQL*
の識別子をデータベース内にあるそのままの形式で扱うことで、 ``Zend_Db_Table_Abstract``
はシンプルで柔軟なものになっています。

語尾変化を行いたい場合は、その変換を独自に実装しなければなりません。そのためには
テーブルクラスで ``_setupTableName()`` メソッドをオーバーライドします。
これを行うひとつの方法としては、 ``Zend_Db_Table_Abstract``
を継承した抽象クラスを作成し、さらにそれを継承したテーブルクラスを作成するという方法があります。

.. _zend.db.table.extending.inflection.example:

.. rubric:: 語尾変化を実装した抽象テーブルクラスの例

.. code-block:: php
   :linenos:

   abstract class MyAbstractTable extends Zend_Db_Table_Abstract
   {
       protected function _setupTableName()
       {
           if (!$this->_name) {
               $this->_name = myCustomInflector(get_class($this));
           }
           parent::_setupTableName();
       }
   }

   class BugsProducts extends MyAbstractTable
   {
   }

語尾変化を行う関数を書くのはあなたの役割です。 Zend Framework
にはそのような関数はありません。



.. _`テーブルデータゲートウェイ`: http://www.martinfowler.com/eaaCatalog/tableDataGateway.html
.. _`行データゲートウェイ`: http://www.martinfowler.com/eaaCatalog/rowDataGateway.html
