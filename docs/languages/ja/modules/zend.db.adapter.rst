.. _zend.db.adapter:

Zend_Db_Adapter
===============

``Zend_Db`` とその関連クラス群は、Zend Framework において *SQL*
データベースとのインターフェイスを担当します。 ``Zend_Db_Adapter`` は、 *PHP*
アプリケーションから *RDBMS* に接続する際に使用する基本クラスです。 *RDBMS*
の種類に応じて、それぞれ個別のアダプタクラスがあります。

``Zend_Db`` のアダプタは、 ベンダ固有の *PHP*
拡張モジュールを共通インターフェイスにとりまとめる役割を果たします。
これにより、いちど書いた *PHP* アプリケーションが ほんの少しの手間で複数 *RDBMS*
に対応するようになります。

アダプタクラスのインターフェイスは、 `PHP Data Objects`_
拡張モジュールのインターフェイスと似ています。 ``Zend_Db`` では、次の *RDBMS* 用の
*PDO* ドライバに対するアダプタクラスを用意しています。

- IBM DB2 および Informix Dynamic Server (IDS) (`pdo_ibm`_ *PHP* 拡張モジュールを使用)

- MySQL (`pdo_mysql`_ *PHP* 拡張モジュールを使用)

- Microsoft SQL Server (`pdo_dblib`_ *PHP* 拡張モジュールを使用)

- Oracle (`pdo_oci`_ *PHP* 拡張モジュールを使用)

- PostgreSQL (`pdo_pgsql`_ *PHP* 拡張モジュールを使用)

- SQLite (`pdo_sqlite`_ *PHP* 拡張モジュールを使用)

さらに、 ``Zend_Db`` では、 以下の *RDBMS*
用の拡張モジュールを使用するアダプタクラスも用意しています。

- MySQL (`mysqli`_ を使用します)

- Oracle (`oci8`_ を使用します)

- IBM DB2 および DB2/i5 (`ibm_db2`_ を使用します)

- Firebird/Interbase (`php_interbase`_ を使用します)

.. note::

   ``Zend_Db`` のアダプタは、どれも *PHP* の拡張モジュールを使用しています。 ``Zend_Db``
   のアダプタを使用するには、 対応する *PHP*
   拡張モジュールが使用できる環境でなければなりません。 たとえば、 *PDO* 系の
   Zend_Db アダプタを使用するのなら、 *PDO* 拡張モジュールが必要で、 また使用する
   *RDBMS* 用の *PDO* ドライバも必要となります。

.. _zend.db.adapter.connecting:

アダプタを使用したデータベース接続
-----------------

ここでは、データベースアダプタのインスタンスを作成する方法を説明します。
これは、 *PHP* アプリケーションから *RDBMS*
サーバへの接続を確立することに対応します。

.. _zend.db.adapter.connecting.constructor:

Zend_Db アダプタのコンストラクタの使用
^^^^^^^^^^^^^^^^^^^^^^^

コンストラクタを使用して、アダプタのインスタンスを作成できます。
アダプタのコンストラクタが受け取る引数はひとつで、
接続を確立するために必要なパラメータを配列で渡します。

.. _zend.db.adapter.connecting.constructor.example:

.. rubric:: アダプタのコンストラクタの使用

.. code-block:: php
   :linenos:

   $db = new Zend_Db_Adapter_Pdo_Mysql(array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

.. _zend.db.adapter.connecting.factory:

Zend_Db のファクトリの使用
^^^^^^^^^^^^^^^^^

コンストラクタを直接使用する以外の方法として、静的メソッド ``Zend_Db::factory()``
を使用することもできます。 このメソッドは、必要に応じて :ref:`Zend_Loader::loadClass()
<zend.loader.load.class>` を使用して動的にアダプタクラスを読み込みます。

最初の引数には、アダプタクラスのベース名を文字列で指定します。
たとえば、文字列 '``Pdo_Mysql``' は ``Zend_Db_Adapter_Pdo_Mysql``
クラスに対応します。その次の引数は、
アダプタのコンストラクタに指定するのと同じ形式の配列となります。

.. _zend.db.adapter.connecting.factory.example:

.. rubric:: ファクトリメソッドの使用

.. code-block:: php
   :linenos:

   // 次の文は不要です。Zend_Db_Adapter_Pdo_Mysql ファイルは
   // Zend_Db の factory メソッドが読み込みます。

   // require_once 'Zend/Db/Adapter/Pdo/Mysql.php';

   // 自動的に Zend_Db_Adapter_Pdo_Mysql クラスを読み込み、
   // そのインスタンスを作成します
   $db = Zend_Db::factory('Pdo_Mysql', array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

独自に ``Zend_Db_Adapter_Abstract``
の派生クラスを作成し、そのクラス名のプレフィックスが "``Zend_Db_Adapter``"
でない場合に ``factory()`` でそのアダプタを読み込むには、
作成したクラス名の先頭の部分をパラメータ配列のキー 'adapterNamespace'
で指定します。

.. _zend.db.adapter.connecting.factory.example2:

.. rubric:: 自作のアダプタクラスをアダプタのファクトリメソッドで使用する方法

.. code-block:: php
   :linenos:

   // アダプタのクラスファイルの読み込みは不要です
   // Zend_Db の factory メソッドが読み込みます

   // 自動的に MyProject_Db_Adapter_Pdo_Mysql クラスを読み込み、
   // インスタンスを作成します
   $db = Zend_Db::factory('Pdo_Mysql', array(
       'host'             => '127.0.0.1',
       'username'         => 'webuser',
       'password'         => 'xxxxxxxx',
       'dbname'           => 'test',
       'adapterNamespace' => 'MyProject_Db_Adapter'
   ));

.. _zend.db.adapter.connecting.factory-config:

Zend_Db ファクトリでの Zend_Config の使用
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``factory()`` メソッドの引数として、 :ref:`Zend_Config <zend.config>`
のオブジェクトを渡すこともできます。

最初の引数に config オブジェクトを渡す場合は、そのプロパティに ``adapter``
が含まれているものとします。
そこに、アダプタクラス名を表す文字列を指定します。 また、オプションで ``params``
というプロパティも指定することができ、
その配下のサブプロパティとしてアダプタのパラメータ名を指定します。 これは、
``factory()`` メソッドの 2 番目のパラメータを省略した場合にのみ読み込まれます。

.. _zend.db.adapter.connecting.factory.example1:

.. rubric:: アダプタのファクトリメソッドでの Zend_Config オブジェクトの使用

次の例では、配列から ``Zend_Config`` オブジェクトを作成します。 それ以外にも、
:ref:`Zend_Config_Ini <zend.config.adapters.ini>` や :ref:`Zend_Config_Xml <zend.config.adapters.xml>`
などを用いて外部ファイルからデータを読み込むこともできます。

.. code-block:: php
   :linenos:

   $config = new Zend_Config(
       array(
           'database' => array(
               'adapter' => 'Mysqli',
               'params'  => array(
                   'host'     => '127.0.0.1',
                   'dbname'   => 'test',
                   'username' => 'webuser',
                   'password' => 'secret',
               )
           )
       )
   );

   $db = Zend_Db::factory($config->database);

``factory()`` メソッドの 2 番目の引数には、
アダプタのパラメータに対応するエントリをもつ連想配列となります。
この引数はオプションです。最初の引数が ``Zend_Config``
である場合は、そこにすべてのパラメータが含まれているものとみなし、 2
番目の引数は無視されます。

.. _zend.db.adapter.connecting.parameters:

アダプタのパラメータ
^^^^^^^^^^

``Zend_Db`` のアダプタクラスで使用できるパラメータを以下にまとめます。

- **host**: データベースサーバのホスト名あるいは IP アドレス。 データベースが *PHP*
  アプリケーションと同じホスト上で動いている場合は、 'localhost' あるいは '127.0.0.1'
  を指定します。

- **username**: *RDBMS* サーバへの接続時に使用する認証用アカウントの ID。

- **password**: *RDBMS* サーバへの接続時に使用する認証用パスワード。

- **dbname**: *RDBMS* サーバ上のデータベースインスタンス名。

- **port**: *RDBMS* サーバによっては、管理者が指定した
  ポート番号によるネットワーク接続を許可しているものもあります。
  このパラメータを使用すると、 *PHP*
  アプリケーションが接続時に使用するポート番号を指定できます。 これは *RDBMS*
  サーバの設定にあわせなければなりません。

- **charset**: 接続に使用する文字セットを指定します。

- **options**: このパラメータは、すべての ``Zend_Db_Adapter``
  クラスで共通のオプションを連想配列で指定します。

- **driver_options**: このパラメータは、各データベース拡張モジュールに固有の
  追加オプションを連想配列で指定します。 典型的な使用例としては、 *PDO*
  ドライバの属性などがあります。

- **adapterNamespace**: アダプタクラスの名前の先頭が '``Zend_Db_Adapter``'
  以外である場合に、それを指定します。これは、 Zend
  以外が作成したアダプタクラスを ``factory()``
  メソッドで使いたい場合に指定します。

.. _zend.db.adapter.connecting.parameters.example1:

.. rubric:: ファクトリでの大文字小文字変換オプションの指定

このオプションは、定数 ``Zend_Db::CASE_FOLDING`` で指定します。 これは、 *PDO* や IBM DB2
データベースドライバにおける ``ATTR_CASE`` 属性に対応するもので、
結果セットの文字列キーの大文字小文字変換を指定します。 設定できる値は
``Zend_Db::CASE_NATURAL`` (デフォルト)、 ``Zend_Db::CASE_UPPER`` および ``Zend_Db::CASE_LOWER``
のいずれかです。

.. code-block:: php
   :linenos:

   $options = array(
       Zend_Db::CASE_FOLDING => Zend_Db::CASE_UPPER
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend_Db::factory('Db2', $params);

.. _zend.db.adapter.connecting.parameters.example2:

.. rubric:: ファクトリでの自動クォートオプションの指定

このオプションは、定数 ``Zend_Db::AUTO_QUOTE_IDENTIFIERS`` で指定します。 この値が ``TRUE``
(デフォルト) の場合は、 アダプタが生成する *SQL* 文中のテーブル名やカラム名、
エイリアスといった識別子をすべてクォートします。これにより、 *SQL*
のキーワードや特殊文字を含む識別子を使用できるようになります。 この値が
``FALSE`` の場合は、 識別子の自動クォートは行いません。
クォートすべき文字を使用している場合は、自分で ``quoteIdentifier()``
メソッドをコールする必要があります。

.. code-block:: php
   :linenos:

   $options = array(
       Zend_Db::AUTO_QUOTE_IDENTIFIERS => false
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend_Db::factory('Pdo_Mysql', $params);

.. _zend.db.adapter.connecting.parameters.example3:

.. rubric:: ファクトリでの PDO ドライバのオプションの指定

.. code-block:: php
   :linenos:

   $pdoParams = array(
       PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => true
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'driver_options' => $pdoParams
   );

   $db = Zend_Db::factory('Pdo_Mysql', $params);

   echo $db->getConnection()
           ->getAttribute(PDO::MYSQL_ATTR_USE_BUFFERED_QUERY);

.. _zend.db.adapter.connecting.parameters.example4:

.. rubric:: ファクトリでのシリアライズオプションの指定

.. code-block:: php
   :linenos:

   $options = array(
       Zend_Db::ALLOW_SERIALIZATION => false
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend_Db::factory('Pdo_Mysql', $params);

.. _zend.db.adapter.connecting.getconnection:

遅延接続の管理
^^^^^^^

アダプタクラスのインスタンスを作成した時点では、 まだ *RDBMS*
サーバへの接続は行われません。 接続用のパラメータを内部で保持しておき、
実際にクエリを実行することになった時点で初めて接続を確立します。
これにより、アダプタオブジェクトをすばやく作成できるようになっています。
つまり、そのリクエストの中で
実際にデータベースクエリを発行するかどうかが確定していなくても、
とりあえずアダプタのインスタンスを作成しておくということもできます。

強制的に *RDBMS* との接続を確立する必要がある場合は、 ``getConnection()``
メソッドを使用します。 このメソッドは、対応する *PHP*
拡張モジュール用の接続オブジェクトを返します。 たとえば、 *PDO*
ドライバ系のアダプタクラスを使った場合は、 ``getConnection()`` は
データベースとの接続を確立してから *PDO* オブジェクトを返します。

データベースへの接続時に発生する例外、 すなわち ID
やパスワードの間違いなどを捕捉したい場合に、 これは役立つでしょう。
実際に接続を行うまで例外はスローされないので、
どこか一か所に例外処理をまとめておいたほうが
アプリケーションがシンプルになって便利でしょう。

さらに、アダプタをシリアライズしてたとえばセッション変数などに格納することもできます。
これは、アダプタだけでなくアダプタを利用する側 (``Zend_Db_Select`` オブジェクトなど)
にとっても有用です。 デフォルトではアダプタのシリアライズが許可されています。
シリアライズをしたくない場合は、上の例のように ``Zend_Db::ALLOW_SERIALIZATION``
オプションに ``FALSE`` を渡します。
遅延接続の理念を尊重し、アンシリアライズされたアダプタの
自動再接続は行いません。つまり、自分で ``getConnection()``
をコールしなければなりません。
自動再接続を有効にするには、アダプタのオプションとして
``Zend_Db::AUTO_RECONNECT_ON_UNSERIALIZE`` に ``TRUE`` を渡します。

.. _zend.db.adapter.connecting.getconnection.example:

.. rubric:: 接続時の例外処理

.. code-block:: php
   :linenos:

   try {
       $db = Zend_Db::factory('Pdo_Mysql', $parameters);
       $db->getConnection();
   } catch (Zend_Db_Adapter_Exception $e) {
       // ID かパスワードが間違っている、あるいは RDBMS が起動していないなど……
   } catch (Zend_Exception $e) {
       // factory() が指定したアダプタクラスを読み込めなかったなど……
   }

.. _zend.db.adapter.example-database:

サンプルデータベース
----------

``Zend_Db`` クラスのドキュメントでは、
クラスやメソッドの使用法を説明するために単純なデータベースを使用します。
これは、とあるソフトウェア開発プロジェクトにおけるバグ管理を想定したものです。
次の 4 つのテーブルで構成されています。

- **accounts** テーブルには、
  バグ管理データベースを使用するユーザについての情報を格納します。

- **products** テーブルには、
  バグを記録する対象となる製品についての情報を格納します。

- **bugs** テーブルには、 バグについての情報を格納します。
  バグの状態や報告者、修正担当者、検証担当者などの情報が含まれます。

- **bugs_products** テーブルには、 バグと製品の関連付け情報を格納します。
  これは、いわゆる多対多のリレーションシップを実装するものです。
  ひとつのバグが複数の製品に関連するものであることもあれば、
  当然ひとつの製品には複数のバグが存在するからです。

このサンプルデータベースを作成するための *SQL*
の擬似コードは、次のようになります。 これらのテーブルは、 ``Zend_Db``
自体のユニットテストでも使用します。

.. code-block:: sql
   :linenos:

   CREATE TABLE accounts (
     account_name      VARCHAR(100) NOT NULL PRIMARY KEY
   );

   CREATE TABLE products (
     product_id        INTEGER NOT NULL PRIMARY KEY,
     product_name      VARCHAR(100)
   );

   CREATE TABLE bugs (
     bug_id            INTEGER NOT NULL PRIMARY KEY,
     bug_description   VARCHAR(100),
     bug_status        VARCHAR(20),
     reported_by       VARCHAR(100) REFERENCES accounts(account_name),
     assigned_to       VARCHAR(100) REFERENCES accounts(account_name),
     verified_by       VARCHAR(100) REFERENCES accounts(account_name)
   );

   CREATE TABLE bugs_products (
     bug_id            INTEGER NOT NULL REFERENCES bugs,
     product_id        INTEGER NOT NULL REFERENCES products,
     PRIMARY KEY       (bug_id, product_id)
   );

また、'bugs' テーブルには 'accounts'
テーブルを指す外部キー参照が複数含まれることにも注意しましょう。
それぞれの外部キーは、そのバグに対して 'accounts'
テーブルの別々の行を参照することもあります。

サンプルデータベースの物理データモデルは、次の図のようになります。

.. image:: ../images/zend.db.adapter.example-database.png
   :width: 387
   :align: center

.. _zend.db.adapter.select:

クエリ結果の読み込み
----------

ここでは、 *SELECT* クエリを実行してその結果を取得するための
アダプタのメソッドについて説明します。

.. _zend.db.adapter.select.fetchall:

結果セット全体の取得
^^^^^^^^^^

*SQL* の *SELECT* クエリの実行とその結果の取得を一度に行うには ``fetchAll()``
メソッドを使用します。

このメソッドの最初の引数には、 *SELECT* 文を文字列で指定します。
あるいは、文字列ではなく :ref:`Zend_Db_Select <zend.db.select>`
クラスのオブジェクトを指定することもできます。
オブジェクトを渡した場合は、アダプタの内部でそれを自動的に *SELECT*
文の文字列に変換します。

``fetchAll()`` でその次に指定する引数は、 *SQL*
文中のパラメータプレースホルダを置換する値の配列となります。

.. _zend.db.adapter.select.fetchall.example:

.. rubric:: fetchAll() の使用

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE bug_id = ?';

   $result = $db->fetchAll($sql, 2);

.. _zend.db.adapter.select.fetch-mode:

フェッチモードの変更
^^^^^^^^^^

デフォルトでは、 ``fetchAll()``
は行の配列を返します。各行のデータは連想配列となります。
連署配列のキーは、列名かあるいは SELECT クエリで指定した列の別名となります。

返り値の形式を別のものにするには ``setFetchMode()`` メソッドを使用します。
対応しているモードは、以下の定数で表されるものです。

- **Zend_Db::FETCH_ASSOC**: データを、連想配列の配列として返します。
  配列のキーは、カラム名を文字列で表したものとなります。 これは、
  ``Zend_Db_Adapter`` クラスのデフォルトのフェッチモードです。

  select で取得する一覧の中に同名のカラムが含まれている場合
  (たとえば複数テーブルを *JOIN* した場合など)
  は、その名前のエントリはひとつしか含まれません。 *FETCH_ASSOC*
  モードを使用する場合は、 *SELECT* クエリでカラムの別名を指定するなどして、
  結果の配列におけるキーが一意になるようにしなければなりません。

  デフォルトでは、これらの文字列はデータベースドライバから返されるものをそのまま使用します。
  通常は、これは *RDBMS* サーバでのカラム名となるでしょう。
  大文字小文字を指定するには、 ``Zend_Db::CASE_FOLDING``
  オプションを使用します。これは、
  アダプタのインスタンスを作成する際に使用します。 :ref:`
  <zend.db.adapter.connecting.parameters.example1>` を参照ください。

- **Zend_Db::FETCH_NUM**: データを、配列の配列で返します。
  配列は数値添字形式となり、クエリで指定した順番での位置がキーとなります。

- **Zend_Db::FETCH_BOTH**: データを、配列の配列で返します。 配列のキーは、FETCH_ASSOC
  モードで用いる文字列と FETCH_NUM
  モードで用いる数値の両方を含んだものとなります。 配列の要素数が、FETCH_ASSOC や
  FETCH_NUM の場合の倍になることに注意しましょう。

- **Zend_Db::FETCH_COLUMN**: データを、値の配列で返します。
  配列の各要素の値は、結果セットのあるひとつのカラムの値となります。
  デフォルトでは、これは最初の (0 番目の) カラムとなります。

- **Zend_Db::FETCH_OBJ**: データを、オブジェクトの配列で返します。
  デフォルトのクラスは、 *PHP* の組み込みクラス stdClass
  となります。結果セットのカラムは、このクラスのプロパティとしてアクセスできます。

.. _zend.db.adapter.select.fetch-mode.example:

.. rubric:: setFetchMode() の使用

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchAll('SELECT * FROM bugs WHERE bug_id = ?', 2);

   // $result はオブジェクトの配列となります
   echo $result[0]->bug_description;

.. _zend.db.adapter.select.fetchassoc:

連想配列形式での結果セットの取得
^^^^^^^^^^^^^^^^

``fetchAssoc()`` メソッドは、 フェッチモードの設定にかかわらず、
最初のカラムを配列のインデックスとして使って、
結果のデータを連想配列の配列で返します。

.. _zend.db.adapter.select.fetchassoc.example:

.. rubric:: fetchAssoc() の使用

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchAssoc('SELECT bug_id, bug_description, bug_status FROM bugs');

   // $result は、フェッチモードの指定とは関係なく連想配列の配列となります
   echo $result[2]['bug_description']; // Description of Bug #2
   echo $result[1]['bug_description']; // Description of Bug #1

.. _zend.db.adapter.select.fetchcol:

結果セットの単一のカラムの取得
^^^^^^^^^^^^^^^

``fetchCol()`` メソッドは、 フェッチモードの設定にかかわらず、
結果のデータを値の配列で返します。
これは、クエリの最初のカラムのみを返します。
それ以外のカラムの内容は破棄されます。 別のカラムが必要な場合は :ref:`
<zend.db.statement.fetching.fetchcolumn>` を参照ください。

.. _zend.db.adapter.select.fetchcol.example:

.. rubric:: fetchCol() の使用

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchCol(
       'SELECT bug_description, bug_id FROM bugs WHERE bug_id = ?', 2);

   // bug_description を含み、bug_id は含みません
   echo $result[0];

.. _zend.db.adapter.select.fetchpairs:

結果セットからの キー/値 のペアの取得
^^^^^^^^^^^^^^^^^^^^

``fetchPairs()`` メソッドは、データを キー/値 のペア (連想配列) の配列で返します。
この連想配列のキーは、 *SELECT* クエリが返す最初のカラムの値となります。
また、連想配列の値は、 *SELECT* クエリが返す二番目のカラムの値となります。
クエリから返されるその他のカラムは破棄されます。

*SELECT*
クエリをうまく設計し、最初のカラムの値が一意になるようにしなければなりません。
もし最初のカラムに重複する値があれば、連想配列のエントリが上書きされてしまいます。

.. _zend.db.adapter.select.fetchpairs.example:

.. rubric:: fetchPairs() の例

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchPairs('SELECT bug_id, bug_status FROM bugs');

   echo $result[2];

.. _zend.db.adapter.select.fetchrow:

結果セットからの単一の行の取得
^^^^^^^^^^^^^^^

``fetchRow()`` メソッドは、 結果のデータを現在のフェッチモードで返します。
ただ、返すのは結果セットから取得した最初の行のみです。

.. _zend.db.adapter.select.fetchrow.example:

.. rubric:: fetchRow() の使用

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchRow('SELECT * FROM bugs WHERE bug_id = 2');

   // $result はオブジェクトの配列ではなく、単なるオブジェクトとなります
   echo $result->bug_description;

.. _zend.db.adapter.select.fetchone:

結果セットからの単一のスカラー値の取得
^^^^^^^^^^^^^^^^^^^

``fetchOne()`` メソッドは ``fetchRow()`` と ``fetchCol()`` を組み合わせたようなものです。
結果セットからの最初の行から、最初のカラムの値のみを返します。
したがって、このメソッドの返り値は配列やオブジェクトではなく単一のスカラー値となります。

.. _zend.db.adapter.select.fetchone.example:

.. rubric:: fetchOne() の使用法

.. code-block:: php
   :linenos:

   $result = $db->fetchOne('SELECT bug_status FROM bugs WHERE bug_id = 2');

   // これは単なる文字列となります
   echo $result;

.. _zend.db.adapter.write:

データベースへの変更の書き出し
---------------

アダプタクラスを使用して、 新しいデータをデータベースに書き込んだり
既存のデータに変更を加えたりできます。
ここでは、そのためのメソッドについて説明します。

.. _zend.db.adapter.write.insert:

データの挿入
^^^^^^

データベースのテーブルに新しい行を追加するには、 ``insert()``
メソッドを使用します。 最初の引数はテーブル名を表す文字列で、
その次の引数はカラム名とデータの値を関連付けた連想配列となります。

.. _zend.db.adapter.write.insert.example:

.. rubric:: テーブルへのデータの挿入

.. code-block:: php
   :linenos:

   $data = array(
       'created_on'      => '2007-03-22',
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

データの配列で指定しなかったカラムについてはデータベースに対して何も指示しません。
つまり、 *SQL* の *INSERT* 文で列を指定しなかった場合と同じ挙動となります。 *DEFAULT*
句が設定されていればその値が追加され、 設定されていなければ ``NULL``
のままとなります。

デフォルトでは、データ配列の値を挿入する際にはパラメータを使用します。
これにより、ある種のセキュリティ問題が発生する可能性を軽減します。
データ配列で指定するデータについては、
エスケープやクォート処理を考慮する必要はありません。

データ配列の中の値を *SQL* の式として扱い、
クォートしたくない場合もあるかもしれません。
デフォルトでは、文字列として渡した値はすべて文字列リテラルとして扱われます。
その値が *SQL*
の式であること、つまりクォートしてはいけないということを指定するには、
文字列ではなく ``Zend_Db_Expr`` 型のオブジェクトをデータ配列に渡します。

.. _zend.db.adapter.write.insert.example2:

.. rubric:: テーブルへの式の挿入

.. code-block:: php
   :linenos:

   $data = array(
       'created_on'      => new Zend_Db_Expr('CURDATE()'),
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

.. _zend.db.adapter.write.lastinsertid:

生成された値の取得
^^^^^^^^^

*RDBMS*
によっては、主キーの自動インクリメントをサポートしているものもあります。
この方法で定義したテーブルに新しい行を *INSERT* すると、
主キーの値が自動的に生成されます。 ``insert()``
メソッドの返り値は、最後に追加された ID では **ありません**\ 。
そのテーブルには自動インクリメントのカラムがないかもしれないからです。
返り値は、変更された行数 (通常は 1 です) となります。

そのテーブルで自動インクリメントの主キーを定義している場合は、
データを追加した後で ``lastInsertId()`` メソッドを使用できます。このメソッドは、
現在のデータベース接続において最後に自動生成された値を返します。

.. _zend.db.adapter.write.lastinsertid.example-1:

.. rubric:: 自動インクリメントのキーにおける lastInsertId() の使用法

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // 自動インクリメントのカラムで最後に生成された値を返します
   $id = $db->lastInsertId();

*RDBMS* によっては、シーケンスをサポートしているものもあります。
シーケンスを使用して、主キー用の一意な値を生成できます。
シーケンスをサポートするために、 ``lastInsertId()`` ではオプションの文字列引数を 2
つ受け取れるようにしています。
これらの引数には、それぞれテーブル名とカラム名を指定します。
シーケンスの名前は、このテーブル名とカラム名をつなげたものの後に "\_seq"
を付加したものとなります。これは、PostgreSQL が SERIAL
型のカラムに対して自動生成するシーケンス名の規約にもとづいています。
たとえば、"bugs" テーブルの主キーカラムが "bug_id" である場合は、"bugs_bug_id_seq"
という名前のシーケンスを使用することになります。

.. _zend.db.adapter.write.lastinsertid.example-2:

.. rubric:: シーケンスにおける lastInsertId() の使用法

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // シーケンス 'bugs_bug_id_seq' が最後に生成した値を返します
   $id = $db->lastInsertId('bugs', 'bug_id');

   // これは、シーケンス 'bugs_seq' が最後に生成した値を返します
   $id = $db->lastInsertId('bugs');

もしこの命名規約とは異なる名前のシーケンスを使用している場合は、代わりに
``lastSequenceId()`` メソッドを使用します。
このメソッドの引数には、シーケンスの名前を直接指定します。

.. _zend.db.adapter.write.lastinsertid.example-3:

.. rubric:: lastSequenceId() の使用法

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // シーケンス 'bugs_id_gen' が最後に生成した値を返します
   $id = $db->lastSequenceId('bugs_id_gen');

シーケンスをサポートしていない *RDBMS*\ 、たとえば MySQL や Microsoft SQL Server、SQLite
などの場合、 ``lastInsertId()`` メソッドの引数は無視されます。
このメソッドの返り値は、現在の接続で最後に実行された *INSERT*
操作が生成した値となります。また、これらの *RDBMS* では ``lastSequenceId()``
メソッドの返り値は常に ``NULL`` となります。

.. note::

   **"SELECT MAX(id) FROM table" じゃあダメなんですか?**

   たしかにこのクエリは、最後にテーブルに追加された主キーの値を返すこともあります。
   しかしこれは、複数のクライアントがデータベースにレコードを追加するという環境では
   安全ではありません。 つまり、データを追加してから ``MAX(id)``
   の値を取得するまでの間に
   他のクライアントが別のデータを追加する可能性があるということです。
   この場合、クエリが返す結果はあなたが実際に追加した行の ID とは異なり、
   誰か他の人が追加した行の ID となってしまいます。
   しかも、もしそのような状況になっていたとしても
   あなたにはそれを知ることはできません。

   たとえば "repeatable read" のようなトランザクション分離モードを使用すれば、
   この危険性を減らせます。しかし、
   このレベルのトランザクション分離をサポートしていない *RDBMS*
   もあります。また、そのアプリケーション自体がもっと緩いレベルの
   トランザクション分離モードを想定して作成されているかもしれません。

   さらに、新しい主キーの値を生成する際に "MAX(id)+1"
   のような式を使うのも同様に危険です。ふたつのクライアントから同時にこのクエリを実行すると、
   どちらも同じ値を取得することになり、同じ値で *INSERT*
   を行なうことになってしまいます。

   どんな *RDBMS* でも、一意な値を生成する機能や
   最後に生成した値を返す機能は持っています。
   この機能はトランザクション分離レベルとは無関係に機能するはずなので、
   ふたつのクライアントで同じ値が重複してしまうことはありません。
   また、他のクライアントで作成した値が
   あなたの接続で「最後に生成した値」として返されることもありません。

.. _zend.db.adapter.write.update:

データの更新
^^^^^^

データベースのテーブルの行を更新するには、アダプタの ``update()``
メソッドを使用します。このメソッドへの引数は 3
つです。まず最初はテーブルの名前、
その次はカラム名と新しい値を関連づけた連想配列となります。

配列で指定した値は、文字列リテラルとして扱われます。 データ配列で *SQL*
の式を扱う方法については :ref:` <zend.db.adapter.write.insert>` を参照ください。

三番目の引数は、 *SQL* の式を文字列で指定します。
これが、変更する行を絞り込むための条件となります。
ここで指定した値や識別子に対しては、クォートやエスケープは行ないません。
何らかの動的な値を使用する場合は、その内容が安全であることを確認するようにしましょう。
:ref:` <zend.db.adapter.quoting>` で説明しているメソッドを使用するといいでしょう。

このメソッドの返り値は、更新操作によって変更された行の数となります。

.. _zend.db.adapter.write.update.example:

.. rubric:: 行の更新

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $n = $db->update('bugs', $data, 'bug_id = 2');

三番目の引数を省略した場合は、テーブルのすべての行が指定した値で更新されます。

三番目の引数に文字列の配列を指定すると、各要素の内容を ``AND``
演算子で連結して使用します。

三番目の引数に配列の配列を提示すると、
値は自動的に引用符で囲まれてキーに入れられます。
そしてこれらは条件として結合され、 ``AND`` 演算子で区切られます。

.. _zend.db.adapter.write.update.example-array:

.. rubric:: 式の配列を指定することによる行の更新

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $where[] = "reported_by = 'goofy'";
   $where[] = "bug_status = 'OPEN'";

   $n = $db->update('bugs', $data, $where);

   // 実行される SQL は、このようになります
   //  UPDATE "bugs" SET "update_on" = '2007-03-23', "bug_status" = 'FIXED'
   //  WHERE ("reported_by" = 'goofy') AND ("bug_status" = 'OPEN')

.. _zend.db.adapter.write.update.example-arrayofarrays:

.. rubric:: 配列の配列を使う行の更新

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $where['reported_by = ?'] = 'goofy';
   $where['bug_status = ?']  = 'OPEN';

   $n = $db->update('bugs', $data, $where);

   // 実行される SQL は、このようになります
   //  UPDATE "bugs" SET "update_on" = '2007-03-23', "bug_status" = 'FIXED'
   //  WHERE ("reported_by" = 'goofy') AND ("bug_status" = 'OPEN')

.. _zend.db.adapter.write.delete:

行の削除
^^^^

データベースのテーブルから行を削除するには ``delete()``
メソッドを使用します。このメソッドに渡す引数は 2 つで、
最初の引数はテーブル名を表す文字列です。

二番目の引数は、 *SQL* の式を文字列で指定します。
これが、削除する行を絞り込むための条件となります。
ここで指定した値や識別子に対しては、クォートやエスケープは行ないません。
何らかの動的な値を使用する場合は、その内容が安全であることを確認するようにしましょう。
:ref:` <zend.db.adapter.quoting>` で説明しているメソッドを使用するといいでしょう。

このメソッドの返り値は、削除操作によって変更された行の数となります。 　

.. _zend.db.adapter.write.delete.example:

.. rubric:: 行の削除

.. code-block:: php
   :linenos:

   $n = $db->delete('bugs', 'bug_id = 3');

二番目の引数を省略した場合は、テーブルのすべての行を削除します。

二番目の引数に文字列の配列を指定すると、各要素の内容を ``AND``
演算子で連結して使用します。

三番目の引数に配列の配列を提示すると、
値は自動的に引用符で囲まれてキーに入れられます。
そしてこれらは条件として結合され、 ``AND`` 演算子で区切られます。

.. _zend.db.adapter.quoting:

値や識別子のクォート
----------

*SQL* を作成する際には、 *PHP* の変数の値を *SQL*
の式で使用しなければならないこともあるでしょう。
これは危険な処理です。なぜなら、 *PHP* の文字列の中には
たとえばクォート記号のような特殊文字が含まれていることがあり、 できあがる *SQL*
がおかしなものになってしまう可能性があるからです。
たとえば、以下のコードで作成した *SQL*
は、クォート文字の対応がおかしいものになります。

   .. code-block:: php
      :linenos:

      $name = "O'Reilly";
      $sql = "SELECT * FROM bugs WHERE reported_by = '$name'";

      echo $sql;
      // SELECT * FROM bugs WHERE reported_by = 'O'Reilly'



さらに悪いことに、このようなコードを悪用されると
あなたのアプリケーションが攻撃の被害を受けることになるかもしれません。 *PHP*
の変数の値を HTTP パラメータなどで指定することができれば、 *SQL*
クエリを操作して予期せぬことをされてしまう可能性があります
(たとえば、その人の権限では見えないはずのデータを見られてしまうなど)。
これは、アプリケーションのセキュリティ問題としては非常に有名な手法で、 "*SQL*
インジェクション" と呼ばれています
(`http://ja.wikipedia.org/wiki/SQL%E3%82%A4%E3%83%B3%E3%82%B8%E3%82%A7%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3`_
を参照ください)。

``Zend_Db`` Adapter クラスの提供する便利な関数を使用すると、 あなたの *PHP* コードが
*SQL* インジェクション攻撃を受ける危険性を軽減できます。
この攻撃を回避する方法は、 *PHP* のクォート文字のような特殊文字を
正しくエスケープしてから *SQL* に使用することです。 これにより、不意に
(あるいは故意に) *SQL* に特殊文字が埋め込まれてしまうことを防ぎます。

.. _zend.db.adapter.quoting.quote:

quote() の使用法
^^^^^^^^^^^^

``quote()`` メソッドは、引数として文字列を受け取ります。
そしてその文字列の中の特殊文字をエスケープした上で、
両端を区切り文字で囲んだものを返します。 エスケープ処理は、使用している *RDBMS*
にあわせて適切に行われます。 文字列の両端に使用する区切り文字は、標準の *SQL*
ではシングルクォート (') となります。

.. _zend.db.adapter.quoting.quote.example:

.. rubric:: quote() の使用法

.. code-block:: php
   :linenos:

   $name = $db->quote("O'Reilly");
   echo $name;
   // 'O\'Reilly'

   $sql = "SELECT * FROM bugs WHERE reported_by = $name";

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

``quote()``
の返り値には、文字列の両端に区切り文字が追加されていることに注意しましょう。
これは、たとえば `mysql_real_escape_string()`_
のようなエスケープ用関数の挙動とは異なります。

値をクォートするかしないかは、 *SQL* のデータ型によって異なります。
たとえば、整数値をクォートしてしまうと
数値型カラムや計算式で利用できなくなってしまうという *RDBMS*
もあります。つまり、次のような *SQL*
がエラーになってしまう実装があるということです。 ここで、 ``intColumn``
のデータ型は ``INTEGER`` であるものとします。

   .. code-block:: php
      :linenos:

      SELECT * FROM atable WHERE intColumn = '123'



``quote()`` メソッドでオプションの 2 番目の引数を使用すると、 *SQL*
のデータ型に応じてクォートするかどうかを選択できます。

.. _zend.db.adapter.quoting.quote.example-2:

.. rubric:: quote() での SQL データ型の指定

.. code-block:: php
   :linenos:

   $value = '1234';
   $sql = 'SELECT * FROM atable WHERE intColumn = '
        . $db->quote($value, 'INTEGER');

各 ``Zend_Db_Adapter`` クラスでは、その *RDBMS* 用の *SQL*
数値データ型の名前がコード化されています。 それら以外にも ``Zend_Db::INT_TYPE`` や
``Zend_Db::BIGINT_TYPE``\ 、そして ``Zend_Db::FLOAT_TYPE`` といった定数が用意されており、
これらを使用すると *RDBMS* に依存しないコードを書くことができます。

``Zend_Db_Table`` は、テーブルのキーとなるカラムを使用する際には 自動的に *SQL*
データ型を ``quote()`` に指定します。

.. _zend.db.adapter.quoting.quote-into:

quoteInto() の使用法
^^^^^^^^^^^^^^^^

クォートを使用する場面としていちばんよくあるのが、 *PHP* の変数の値を *SQL*
の式や文中で使用するということです。 ``quoteInto()``
メソッドを使用すると、この処理を一度でできるようになります。
このメソッドが受け取る引数はふたつです。
まず最初の引数としてプレースホルダ記号 (?) を含む文字列を指定し、次の引数で
*PHP* の変数などの値を指定します。
ここで指定した値で、プレースホルダの部分を置き換えます。

プレースホルダ用の記号は、多くの *RDBMS*
でパラメータとして使用している記号と同じです。しかし、 ``quoteInto()``
メソッドはあくまでパラメータをエミュレートしているだけです。
このメソッドは単純に文字列の中に値を放り込み、
特殊文字をエスケープして両端をクォートするという処理だけを行います。 *RDBMS*
におけるパラメータのように、 *SQL* 文字列と値を分離して *SQL* だけを事前に *RDBMS*
サーバでパースするといったことは行いません。

.. _zend.db.adapter.quoting.quote-into.example:

.. rubric:: quoteInto() の使用法

.. code-block:: php
   :linenos:

   $sql = $db->quoteInto("SELECT * FROM bugs WHERE reported_by = ?", "O'Reilly");

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

``quoteInto()`` のオプションの 3 番目のパラメータを使用すると、 *SQL*
のデータ型を指定できます。
数値型はクォートをせず、それ以外の型についてはクォートを行います。

.. _zend.db.adapter.quoting.quote-into.example-2:

.. rubric:: quoteInto() での SQL データ型の指定

.. code-block:: php
   :linenos:

   $sql = $db
       ->quoteInto("SELECT * FROM bugs WHERE bug_id = ?", '1234', 'INTEGER');

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 1234

.. _zend.db.adapter.quoting.quote-identifier:

quoteIdentifier() の使用法
^^^^^^^^^^^^^^^^^^^^^^

変数を使用する可能性があるのは、 *SQL* 文中の値だけとは限りません。 *SQL*
文中でのテーブル名やカラム名などの識別子として *PHP*
の変数を使用する場合も、同様にクォートする必要があります。 デフォルトでは、
*SQL* の識別子に使用できる文字は *PHP*
などのプログラミング言語の規則と似ています。
たとえば、識別子には空白文字や記号を使用することはできませんし、
またアルファベット以外の文字も使えません。 *SQL*
の文法上特別な意味を持つ単語として予約されているものも、
そのままでは識別子として使用できません。

しかし、適切な区切り文字でクォートすれば、
識別子として使用できる文字の幅が広がります。
本来識別子として使用できない文字を含んでいても、
適切な形式でクォートすることで *SQL* の識別子として使用できるようになります。
たとえば、空白や記号などを使うこともできますし、 *SQL*
で予約語として指定されている単語であっても使用可能です。

``quoteIdentifier()`` メソッドの働きは ``quote()`` と似ていますが、
このメソッドは使用しているアダプタの型に応じた識別子区切り文字を付加します。
たとえば、標準 *SQL* ではダブルクォート (") を区切り文字として使用します。 多くの
*RDBMS* がこれにしたがっています。 MySQL の場合は、デフォルトではバッククォート
(\`) を使用します。 ``quoteIdentifier()`` メソッドはまた、
文字列引数内の特殊文字のエスケープも行います。

.. _zend.db.adapter.quoting.quote-identifier.example:

.. rubric:: quoteIdentifier() の使用法

.. code-block:: php
   :linenos:

   // テーブル名に、SQL の予約語を使用します
   $tableName = $db->quoteIdentifier("order");

   $sql = "SELECT * FROM $tableName";

   echo $sql
   // SELECT * FROM "order"

クォートしていない場合とは異なり、
クォートした識別子は大文字小文字を区別するようになります。
したがって、クォートした識別子を使用する場合は
大文字小文字の指定も含めて識別子をきちんと記述する必要があります。

たいていの場合は ``Zend_Db`` クラスで自動的に *SQL*
を生成することになるでしょう。デフォルトでは、
すべての識別子が自動的にクォートされます。 この挙動を変更するには、オプション
``Zend_Db::AUTO_QUOTE_IDENTIFIERS``
を変更します。これは、アダプタのインスタンスを作成する際に指定します。 :ref:`
<zend.db.adapter.connecting.parameters.example2>` を参照ください。

.. _zend.db.adapter.transactions:

データベースのトランザクションの制御
------------------

データベースには「トランザクション」と呼ばれる論理的な作業単位があります。
複数のテーブルにまたがる操作などを一括して更新 (コミット) したり、
一括して取消 (ロールバック) したりできるようになります。
データベースドライバがトランザクションを暗黙的にサポートしている場合は、
すべてのクエリがトランザクション内で実行されます。 これを **自動コミット**\
モードといいます。 このモードでは、あらゆるクエリを実行する前に
ドライバが自動的にトランザクションを開始し、
実行が完了したら自動的にトランザクションをコミットします。
デフォルトでは、すべての ``Zend_Db``
アダプタクラスは自動コミットモードで動作します。

一方、トランザクションの始点と終点を自分で指定することにより、 複数の *SQL*
クエリをひとつのトランザクション内ですることもできます。
トランザクションを開始する際には ``beginTransaction()``
メソッドを使用します。それ以降に実行した *SQL*
文は、明示的に指定するまではすべて同じトランザクション内で動作します。

トランザクションを終了するには、 ``commit()`` あるいは ``rollBack()``
のいずれかを使用します。 ``commit()`` メソッドは、
そのトランザクションでの変更内容をコミットします。
つまり、そのトランザクションで行った変更が、
他のトランザクションからも見えるようにするということです。

``rollBack()`` メソッドはその反対の動作をします。
このメソッドは、そのトランザクションでの変更内容をすべて破棄します。
変更は一切なかったことになり、トランザクションを開始する前の状態にデータを戻します。
しかし、あるトランザクションをロールバックしたとしても、
その間に他のトランザクションで行った変更には何の影響も与えません。

トランザクションを終了すると、 ``Zend_Db_Adapter``
は再び自動コミットモードに戻ります。
手動でのトランザクション管理を使用したい場合は、 ``beginTransaction()``
をもう一度コールします。

.. _zend.db.adapter.transactions.example:

.. rubric:: 一貫性を保持するためのトランザクション管理

.. code-block:: php
   :linenos:

   // トランザクションを明示的に開始します
   $db->beginTransaction();

   try {
       // いくつかクエリを実行します
       $db->query(...);
       $db->query(...);
       $db->query(...);

       // すべて成功したら、トランザクションをコミットして
       // すべての変更を一度に適用します
       $db->commit();

   } catch (Exception $e) {
       // いずれかのクエリが失敗して例外が発生したら、
       // もし他に成功しているクエリがあったとしても
       // それも含めてすべての処理をロールバックします。
       // すべて適用されるか、ひとつも適用されないかのいずれかです。
       $db->rollBack();
       echo $e->getMessage();
   }

.. _zend.db.adapter.list-describe:

テーブルの情報の取得
----------

``listTables()`` メソッドは文字列の配列を返します。
この配列には、データベース内のすべてのテーブルの名前が格納されています。

``describeTable()`` メソッドは、 テーブルのメタデータを格納した連想配列を返します。
このメソッドの最初の引数に、テーブル名を文字列で指定します。
二番目の引数はオプションで、そのテーブルが存在するスキーマの名前を指定します。

連想配列のキーは、テーブルのカラムの名前となります。
各キーに関連付けられた値も連想配列で、以下のキーが存在します。

.. _zend.db.adapter.list-describe.metadata:

.. table:: describeTable() が返す連想配列のフィールド

   +----------------+---------+----------------------------------------------------------------+
   |キー              |型        |説明                                                              |
   +================+=========+================================================================+
   |SCHEMA_NAME     |(string) |このテーブルが属するデータベーススキーマの名前。                                        |
   +----------------+---------+----------------------------------------------------------------+
   |TABLE_NAME      |(string) |このカラムが属するテーブルの名前。                                               |
   +----------------+---------+----------------------------------------------------------------+
   |COLUMN_NAME     |(string) |カラム名。                                                           |
   +----------------+---------+----------------------------------------------------------------+
   |COLUMN_POSITION |(integer)|テーブル内でのそのカラムの位置。                                                |
   +----------------+---------+----------------------------------------------------------------+
   |DATA_TYPE       |(string) |RDBMS で定義されている、そのカラムのデータ型。                                      |
   +----------------+---------+----------------------------------------------------------------+
   |DEFAULT         |(string) |もし存在すれば、そのカラムのデフォルト値。                                           |
   +----------------+---------+----------------------------------------------------------------+
   |NULLABLE        |(boolean)|そのカラムが SQL の NULL を許可している場合は TRUE 、 NOTNULL 制約が指定されている場合は FALSE。|
   +----------------+---------+----------------------------------------------------------------+
   |LENGTH          |(integer)|RDBMS で定義されている、そのカラムの長さ (サイズ)。                                  |
   +----------------+---------+----------------------------------------------------------------+
   |SCALE           |(integer)|SQL の NUMERIC 型あるいは DECIMAL 型での桁数。                              |
   +----------------+---------+----------------------------------------------------------------+
   |PRECISION       |(integer)|SQL の NUMERIC 型あるいは DECIMAL 型での精度。                              |
   +----------------+---------+----------------------------------------------------------------+
   |UNSIGNED        |(boolean)|整数系の型で、符号なし (UNSIGNED) である場合に TRUE。                             |
   +----------------+---------+----------------------------------------------------------------+
   |PRIMARY         |(boolean)|そのカラムが主キーの一部である場合に TRUE。                                        |
   +----------------+---------+----------------------------------------------------------------+
   |PRIMARY_POSITION|(integer)|主キーカラムの中での順序 (最初は 1)。                                           |
   +----------------+---------+----------------------------------------------------------------+
   |IDENTITY        |(boolean)|そのカラムが自動生成の値を使用している場合に TRUE。                                    |
   +----------------+---------+----------------------------------------------------------------+

.. note::

   **各 RDBMS における IDENTITY メタデータフィールドの対応**

   IDENTITY メタデータフィールドの名前は、サロゲートキーを表す '慣用的な'
   名前として選択されたものです。 このフィールドは、それぞれの *RDBMS*
   においては以下のような名前で知られています。

   - ``IDENTITY``- DB2, MSSQL

   - ``AUTO_INCREMENT``- MySQL

   - ``SERIAL``- PostgreSQL

   - ``SEQUENCE``- Oracle

指定したテーブル名とスキーマ名に対応するテーブルが存在しない場合は、
``describeTable()`` は空の配列を返します。

.. _zend.db.adapter.closing:

接続の終了
-----

通常は、データベースとの接続を閉じる必要はありません。
リクエストの処理が終了した時点で、 *PHP*
が自動的にリソースの後始末を行うからです。
データベース関連の拡張モジュールは、
リソースオブジェクトへの参照がなくなった時点で接続を閉じるように設計されています。

しかし、実行時間が長くかかり、 多くのデータベース接続を扱うような *PHP*
スクリプトの場合は、自分で接続を閉じる必要があるかもしれません。 これにより、
*RDBMS* サーバが限界に達してしまうことを防ぎます。
データベース接続を明示的に閉じるには、アダプタの ``closeConnection()``
メソッドを使用します。

リリース 1.7.2 以降でしゃ、現在 *RDBMS* に接続しているかどうかを ``isConnected()``
メソッドで取得できます。
これは、コネクションリソースが初期化されたまままだ閉じられていないことを確認します。
現在のところ、たとえばサーバ側で接続が切断された場合などは検出することができません。
内部的に、接続を閉じる際にこれを使用しています。
接続を複数回閉じてもエラーにはなりません。 1.7.2 より前でも *PDO*
アダプタは同じ挙動でしたが、それ以外のアダプタは違いました。

.. _zend.db.adapter.closing.example:

.. rubric:: データベースとの接続の解除

.. code-block:: php
   :linenos:

   $db->closeConnection();

.. note::

   **Zend_Db は持続的な接続をサポートしていますか？**

   はい。 ``Zend_Db`` のアダプタの設定 (driver_configuration ではありません) で、
   ``persistent`` フラグを ``TRUE`` に設定することで対応します。

   .. _zend.db.adapter.connecting.persistence.example:

   .. rubric:: Oracle アダプタでの持続的接続の使用

   .. code-block:: php
      :linenos:

      $db = Zend_Db::factory('Oracle', array(
          'host'       => '127.0.0.1',
          'username'   => 'webuser',
          'password'   => 'xxxxxxxx',
          'dbname'     => 'test',
          'persistent' => true
      ));

   持続的な接続を使用すると、 *RDBMS*
   サーバに余計な接続がたまってしまうことに注意しましょう。
   接続作成時のオーバーヘッドが減ることによるパフォーマンスの向上よりも、
   それによって引き起こされる問題のほうが多くなりえます。

   データベース接続は、その状態を管理しています。 つまり、 *RDBMS*
   サーバのオブジェクトの中には
   セッションスコープで存在するものがあるということです。
   セッションスコープで管理される情報の例としては、
   ロックやユーザ変数、一時テーブル、直近に実行したクエリの情報
   (変更された行数、自動生成された ID) などが挙げられます。
   持続的な接続を使用すると、 別の *PHP* リクエストが作成したデータに
   誤ってアクセスしてしまう危険が生じてしまいます。

   現在、 ``Zend_Db`` が持続的接続をサポートしているのは Oracle、DB2 そして *PDO*
   アダプタ (*PHP* が指定します) のみです。

.. _zend.db.adapter.other-statements:

その他のステートメントの実行
--------------

*PHP* のデータベース関連拡張モジュールが提供する接続オブジェクトを、
直接操作したくなることがあるかもしれません。 ``Zend_Db_Adapter_Abstract``
が対応していないような そのデータベース固有の機能を使用したい場合などです。

``Zend_Db`` で *SQL* 文を実行する場合は、
常にプリペア/実行の二段階に分けて処理されます。
しかし、データベースの機能の中には
プリペアドステートメントに対応していないようなものもあります。 たとえば、CREATE
や ALTER のような DDL は、 MySQL
ではプリペアドステートメントとすることができません。 また、MySQL 5.1.17
より前のバージョンでは `MySQL クエリキャッシュ`_
の機能を活用することができません。

たいていの拡張モジュールには、 プリペアドステートメントではなく直接 *SQL*
を実行するためのメソッドが用意されています。 たとえば *PDO* なら ``exec()``
がそれにあたります。 接続オブジェクトに直接アクセスするには、 ``getConnection()``
を使用します。

.. _zend.db.adapter.other-statements.example:

.. rubric:: PDO アダプタによる、プリペアド形式ではないクエリの実行

.. code-block:: php
   :linenos:

   $result = $db->getConnection()->exec('DROP TABLE bugs');

同様にして、 拡張モジュールが提供するその他のメソッドやプロパティにも
アクセスできます。ただ、注意が必要です。
このようなことをすると、あなたの作成したアプリケーションが特定の *RDBMS*
用の拡張モジュールに依存してしまうようになります。

将来のバージョンの ``Zend_Db`` では、
データベースの拡張モジュールがサポートする機能への
メソッドエントリポイントを追加できるようにする予定です。
これは、過去のバージョンとの互換性を損なうことはありません。

.. _zend.db.adapter.server-version:

サーバのバージョンの取得
------------

リリース 1.7.2 以降では、サーバのバージョンを取得できます。これは、 *PHP* の
``version_compare()`` で使用できる形式となります。 情報が取得できない場合は ``NULL``
が返されます。

.. _zend.db.adapter.server-version.example:

.. rubric:: サーバのバージョンを取得してからクエリを実行する

.. code-block:: php
   :linenos:

   $version = $db->getServerVersion();
   if (!is_null($version)) {
       if (version_compare($version, '5.0.0', '>=')) {
           // 何かを行います
       } else {
           // 何か別のことを行います
       }
   } else {
       // サーバのバージョンを取得できませんでした
   }

.. _zend.db.adapter.adapter-notes:

各アダプタ固有の注意点
-----------

ここでは、使用するアダプタごとに 注意すべき点をまとめます。

.. _zend.db.adapter.adapter-notes.ibm-db2:

IBM DB2
^^^^^^^

- このアダプタを ``factory()`` で指定する場合は、名前を 'Db2' とします。

- このアダプタは、 *PHP* の ibm_db2 拡張モジュールを使用します。

- IBM DB2 は、シーケンスも自動インクリメントのキーも 両方サポートしています。
  したがって、 ``lastInsertId()``
  への引数は指定してもしなくてもかまいません。引数を省略した場合は、
  自動インクリメントのキーが最後に生成した値を返します。
  引数を指定した場合は、 '**テーブル名**\ _ **カラム名**\ _seq'
  という名前のシーケンスが最後に生成した値を返します。

.. _zend.db.adapter.adapter-notes.mysqli:

MySQLi
^^^^^^

- このアダプタを ``factory()`` で指定する場合は、 名前を 'Mysqli' とします。

- このアダプタは、 *PHP* の mysqli 拡張モジュールを使用します。

- MySQL はシーケンスをサポートしていません。したがって、 ``lastInsertId()``
  に引数を指定してもそれは無視されます。
  返り値は、常に自動インクリメントのキーの最後の値となります。 ``lastSequenceId()``
  メソッドの返り値は ``NULL`` となります。

.. _zend.db.adapter.adapter-notes.oracle:

Oracle
^^^^^^

- このアダプタを ``factory()`` で指定する場合は、 名前を 'Oracle' とします。

- このアダプタは、 *PHP* の oci8 拡張モジュールを使用します。

- Oracle は自動インクリメントのキーをサポートしていません。 したがって、
  ``lastInsertId()`` や ``lastSequenceId()`` にはシーケンス名を指定する必要があります。

- Oracle 拡張モジュールは位置指定によるパラメータをサポートしていません。
  名前つきパラメータを使用する必要があります。

- 現在、Oracle アダプタでは ``Zend_Db::CASE_FOLDING``
  オプションをサポートしていません。Oracle でこの機能を使用したい場合は、 *PDO* OCI
  アダプタを使用する必要があります。

- デフォルトでは、LOB フィールドは OCI-Lob オブジェクトで返されます。
  すべてのリクエストでこれを文字列として取得したい場合は、
  ドライバのオプション '``lob_as_string``' を使用します。
  特定のリクエストでだけそうしたい場合は、アダプタあるいはステートメントで
  ``setLobAsString(boolean)`` を使用します。

.. _zend.db.adapter.adapter-notes.sqlsrv:

Microsoft SQL Server
^^^^^^^^^^^^^^^^^^^^

- このアダプタを ``factory()`` で指定する場合は、 名前を 'Sqlsrv' とします。

- このアダプタは、 *PHP* の sqlsrv 拡張モジュールを使用します。

- Microsoft *SQL* Server はシーケンスをサポートしていません。 したがって、
  ``lastInsertId()`` に指定した主キー引数は無視されます。
  テーブル名を指定した場合は自動インクリメントキーで最後に生成した値を返し、
  そうでない場合は最後に実行した挿入クエリが返した ID を返します。
  ``lastSequenceId()`` メソッドの返り値は ``NULL`` となります。

- ``Zend_Db_Adapter_Sqlsrv`` は、 *SQL* Server データベースに接続した直後に ``QUOTED_IDENTIFIER
  ON`` を設定します。 これは、ドライバで使用する識別子区切り文字を、標準 *SQL*
  形式 (**"**) に設定するものです。 *SQL* Server
  は独自形式の角括弧構文を使用していますが、 それは使わないようになります。

- オプション配列のキーに ``driver_options`` を指定できます。この値は
  `http://msdn.microsoft.com/ja-jp/library/cc296161(SQL.90).aspx`_ に書かれているものとなります。

- ``setTransactionIsolationLevel()`` で、現在の接続の分離レベルを設定できます。値は
  ``SQLSRV_TXN_READ_UNCOMMITTED``\ 、 ``SQLSRV_TXN_READ_COMMITTED``\ 、 ``SQLSRV_TXN_REPEATABLE_READ``\ 、
  ``SQLSRV_TXN_SNAPSHOT`` あるいは ``SQLSRV_TXN_SERIALIZABLE`` のいずれかとなります。

- Zend Framework 1.9 以降は、Microsoft の *PHP* *SQL* Server 拡張モジュール 1.0.1924.0 以降と
  *MSSQL* Server Native Client バージョン 9.00.3042.00 以降をサポートします。

.. _zend.db.adapter.adapter-notes.pdo-ibm:

PDO for IBM DB2 and Informix Dynamic Server (IDS)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- このアダプタを ``factory()`` で指定する場合は、 名前を '``Pdo_Ibm``' とします。

- このアダプタは、 *PHP* の pdo および pdo_ibm 拡張モジュールを使用します。

- PDO_IBM 拡張モジュールのバージョン 1.2.2 以降が必要です。
  これより古いバージョンを使っている場合は、PDO_IBM 拡張モジュールを *PECL*
  で更新する必要があります。

.. _zend.db.adapter.adapter-notes.pdo-mssql:

PDO Microsoft SQL Server
^^^^^^^^^^^^^^^^^^^^^^^^

- このアダプタを ``factory()`` で指定する場合は、 名前を '``Pdo_Mssql``' とします。

- このアダプタは、 *PHP* の pdo および pdo_dblib 拡張モジュールを使用します。

- Microsoft SQL Server はシーケンスをサポートしていません。 したがって、 ``lastInsertId()``
  に引数を指定してもそれは無視されます。
  返り値は、常に自動インクリメントのキーの最後の値となります。 ``lastSequenceId()``
  メソッドの返り値は ``NULL`` となります。

- unicode 文字列を UCS-2 以外のエンコーディング (UTF-8 など)
  で使用する場合は、アプリケーションのコード内での変換処理
  あるいはバイナリカラムへのデータ格納が必要となります。 詳細な情報は `Microsoft's
  Knowledge Base`_ を参照ください。

- ``Zend_Db_Adapter_Pdo_Mssql`` は、SQL Server に接続した直後に ``QUOTED_IDENTIFIER ON``
  を設定します。これにより、 *SQL* の識別子をクォートする際に 標準の区切り文字
  (") を使用するようになります。 SQL Server
  の独自仕様である角括弧によるクォートは使用しません。

- オプションの配列で、キーとして ``pdoType`` を指定できます。この値は "mssql"
  (デフォルト)、 "dblib"、"freetds" あるいは "sybase" のいずれかとなります。
  このオプションは、 *DSN* 文字列を作成する際に使用する *DSN*
  プレフィックスに影響を与えます。"freetds" および "sybase"
  を指定した場合のプレフィックスは "sybase:" となります。これは `FreeTDS`_
  系のライブラリで用いられるものです。 このドライバで使用できる *DSN*
  プレフィックスの詳細は `http://www.php.net/manual/ja/ref.pdo-dblib.connection.php`_
  を参照ください。

.. _zend.db.adapter.adapter-notes.pdo-mysql:

PDO MySQL
^^^^^^^^^

- このアダプタを ``factory()`` で指定する場合は、 名前を '``Pdo_Mysql``' とします。

- このアダプタは、 *PHP* の pdo および pdo_mysql 拡張モジュールを使用します。

- MySQL はシーケンスをサポートしていません。したがって、 ``lastInsertId()``
  に引数を指定してもそれは無視されます。
  返り値は、常に自動インクリメントのキーの最後の値となります。 ``lastSequenceId()``
  メソッドの返り値は ``NULL`` となります。

.. _zend.db.adapter.adapter-notes.pdo-oci:

PDO Oracle
^^^^^^^^^^

- このアダプタを ``factory()`` で指定する場合は、 名前を '``Pdo_Oci``' とします。

- このアダプタは、 *PHP* の pdo および pdo_oci 拡張モジュールを使用します。

- Oracle は自動インクリメントのキーをサポートしていません。 したがって、
  ``lastInsertId()`` や ``lastSequenceId()`` にはシーケンス名を指定する必要があります。

.. _zend.db.adapter.adapter-notes.pdo-pgsql:

PDO PostgreSQL
^^^^^^^^^^^^^^

- このアダプタを ``factory()`` で指定する場合は、 名前を '``Pdo_Pgsql``' とします。

- このアダプタは、 *PHP* の pdo および pdo_pgsql 拡張モジュールを使用します。

- PostgreSQL は、シーケンスも自動インクリメントのキーも 両方サポートしています。
  したがって、 ``lastInsertId()``
  への引数は指定してもしなくてもかまいません。引数を省略した場合は、
  自動インクリメントのキーが最後に生成した値を返します。
  引数を指定した場合は、 '**テーブル名**\ _ **カラム名**\ _seq'
  という名前のシーケンスが最後に生成した値を返します。

.. _zend.db.adapter.adapter-notes.pdo-sqlite:

PDO SQLite
^^^^^^^^^^

- このアダプタを ``factory()`` で指定する場合は、 名前を '``Pdo_Sqlite``' とします。

- このアダプタは、 *PHP* の pdo および pdo_sqlite 拡張モジュールを使用します。

- SQLite はシーケンスをサポートしていません。したがって、 ``lastInsertId()``
  に引数を指定してもそれは無視されます。
  返り値は、常に自動インクリメントのキーの最後の値となります。 ``lastSequenceId()``
  メソッドの返り値は ``NULL`` となります。

- SQLite2 データベースに接続するには、 ``Pdo_Sqlite``
  アダプタのインスタンスを作成する際に パラメータの配列で ``'sqlite2' => true``
  を指定します。

- メモリ上の SQLite データベースに接続するには、 ``Pdo_Sqlite``
  アダプタのインスタンスを作成する際に パラメータの配列で ``'dbname' => ':memory:'``
  を指定します。

- *PHP* 用の SQLite ドライバの古いバージョンでは、
  結果セットで短いカラム名を使用するための PRAGMA
  コマンドがサポートされていないようです。 join
  クエリを実行した際の結果セットのカラム名が "テーブル名.カラム名"
  形式になる場合は、 *PHP* のバージョンをアップグレードする必要があります。

.. _zend.db.adapter.adapter-notes.firebird:

Firebird/Interbase
^^^^^^^^^^^^^^^^^^

- このアダプタは、 *PHP* の php_interbase 拡張モジュールを使用します。

- Firebird/interbase は自動インクリメントのキーをサポートしていません。
  シーケンスの名前を ``lastInsertId()`` あるいは ``lastSequenceId()``
  に指定する必要があります。

- 現在、Firebird/interbase アダプタでは ``Zend_Db::CASE_FOLDING``
  オプションをサポートしていません。
  クォートしていない識別子は、自動的に大文字で返されます。

- アダプタ名は ``ZendX_Db_Adapter_Firebird`` です。

  パラメータ adapterNamespace の値を ``ZendX_Db_Adapter`` とすることを覚えておきましょう。

  php にバンドルされている ``gds32.dll`` (あるいは linux 環境でそれに相当するもの)
  をアップデートし、 サーバと同じバージョンにしておくことを推奨します。 Firebird
  で ``gds32.dll`` に相当するものは ``fbclient.dll`` です。

  デフォルトでは、すべての識別子 (テーブル名やフィールド)
  は大文字で返されます。



.. _`PHP Data Objects`: http://www.php.net/pdo
.. _`pdo_ibm`: http://www.php.net/pdo-ibm
.. _`pdo_mysql`: http://www.php.net/pdo-mysql
.. _`pdo_dblib`: http://www.php.net/pdo-dblib
.. _`pdo_oci`: http://www.php.net/pdo-oci
.. _`pdo_pgsql`: http://www.php.net/pdo-pgsql
.. _`pdo_sqlite`: http://www.php.net/pdo-sqlite
.. _`mysqli`: http://www.php.net/mysqli
.. _`oci8`: http://www.php.net/oci8
.. _`ibm_db2`: http://www.php.net/ibm_db2
.. _`php_interbase`: http://www.php.net/ibase
.. _`http://ja.wikipedia.org/wiki/SQL%E3%82%A4%E3%83%B3%E3%82%B8%E3%82%A7%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3`: http://ja.wikipedia.org/wiki/SQL%E3%82%A4%E3%83%B3%E3%82%B8%E3%82%A7%E3%82%AF%E3%82%B7%E3%83%A7%E3%83%B3
.. _`mysql_real_escape_string()`: http://www.php.net/mysqli_real_escape_string
.. _`MySQL クエリキャッシュ`: http://dev.mysql.com/doc/refman/5.1/en/query-cache-how.html
.. _`http://msdn.microsoft.com/ja-jp/library/cc296161(SQL.90).aspx`: http://msdn.microsoft.com/ja-jp/library/cc296161(SQL.90).aspx
.. _`Microsoft's Knowledge Base`: http://support.microsoft.com/kb/232580
.. _`FreeTDS`: http://www.freetds.org/
.. _`http://www.php.net/manual/ja/ref.pdo-dblib.connection.php`: http://www.php.net/manual/ja/ref.pdo-dblib.connection.php
