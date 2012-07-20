.. _zend.db.statement:

Zend_Db_Statement
=================

:ref:` <zend.db.adapter>` で説明した ``fetchAll()`` や ``insert()``
のような便利なメソッド以外にも、 ステートメントオブジェクトを使用することで、
より柔軟にクエリの実効や結果の取得ができるようになります。
ここでは、ステートメントオブジェクトを取得してそのメソッドを使用する方法を説明します。

``Zend_Db_Statement`` は、 `PHP Data Objects`_ 拡張モジュールの PDOStatement
オブジェクトをもとにしたものです。

.. _zend.db.statement.creating:

ステートメントの作成
----------

通常は、ステートメントオブジェクトはデータベースアダプタクラスの ``query()``
メソッドの返り値として取得します。 このメソッドは、任意の *SQL*
文を実行できます。 最初の引数には *SQL* 文を指定し、
オプションの二番目の引数には *SQL* 文中のプレースホルダを置き換える
バインド変数の配列を指定します。

.. _zend.db.statement.creating.example1:

.. rubric:: query() による SQL ステートメントオブジェクトの作成

.. code-block:: php
   :linenos:

   $stmt = $db->query(
               'SELECT * FROM bugs WHERE reported_by = ? AND bug_status = ?',
               array('goofy', 'FIXED')
           );

ステートメントオブジェクトは、準備された *SQL* 文に対して
変数の値をバインドして一度実行したものに対応します。 そのステートメントが
SELECT クエリあるいは何らかの結果セットを返すものであった場合は、
すでに結果を取得する準備ができています。

ステートメントオブジェクトをコンストラクタから作成することもできますが、
あまり一般的ではありません。このオブジェクトを作成するための
ファクトリメソッドはないので、特定のステートメントクラスを読み込んで
そのコンストラクタをコールすることになります。
コンストラクタの最初の引数にはアダプタオブジェクトを指定し、 二番目の引数には
*SQL* 文を文字列で指定します。
このステートメントは、準備されただけでまだ実行されていない状態となります。

.. _zend.db.statement.creating.example2:

.. rubric:: SQL ステートメントのコンストラクタの使用

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE reported_by = ? AND bug_status = ?';

   $stmt = new Zend_Db_Statement_Mysqli($db, $sql);

.. _zend.db.statement.executing:

ステートメントの実行
----------

ステートメントをコンストラクタから作成した場合や、
一度実行したステートメントをもう一度実行したい場合などは、
ステートメントオブジェクトを自分で実行する必要があります。
その場合は、ステートメントオブジェクトの ``execute()``
メソッドを使用します。このメソッドに渡す引数は、
ステートメント中のプレースホルダにバインドする変数の値の配列となります。

**位置指定によるパラメータ**\ 、 つまりクエスチョンマーク (**?**)
でパラメータを指定している場合は、 バインドする値は通常の配列で渡します。

.. _zend.db.statement.executing.example1:

.. rubric:: 位置指定パラメータによるステートメントの実行

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE reported_by = ? AND bug_status = ?';

   $stmt = new Zend_Db_Statement_Mysqli($db, $sql);

   $stmt->execute(array('goofy', 'FIXED'));

**名前つきパラメータ**\ 、 つまり先頭にコロン (**:**) をつけた識別子で
パラメータを指定している場合は、バインドする値を連想配列で渡します。
配列のキーが、パラメータの名前に対応します。

.. _zend.db.statement.executing.example2:

.. rubric:: 名前つきパラメータによるステートメントの実行

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE ' .
          'reported_by = :reporter AND bug_status = :status';

   $stmt = new Zend_Db_Statement_Mysqli($db, $sql);

   $stmt->execute(array(':reporter' => 'goofy', ':status' => 'FIXED'));

*PDO*
のステートメントは位置指定パラメータと名前つきパラメータの両方をサポートしています。
しかし、ひとつの *SQL* の中で両方を使用することはできません。 ``Zend_Db_Statement``
クラスの中には *PDO* を使用していないものもありますが、
それらの中にはいずれか一種類の形式のパラメータしかサポートしないものもあるかもしれません。

.. _zend.db.statement.fetching:

SELECT 文からの結果の取得
----------------

ステートメントオブジェクトのメソッドをコールすることで、 *SQL*
文の結果セットから行を取得できます。 SELECT、SHOW、DESCRIBE そして EXPLAIN
などのステートメントが結果セットを返します。 INSERT、UPDATE そして DELETE
などのステートメントは結果セットを返しません。 後者のような *SQL* 文も
``Zend_Db_Statement`` で実行できますが、
その結果から行を取得するメソッドをコールすることはできません。

.. _zend.db.statement.fetching.fetch:

結果セットからの単一の行の取得
^^^^^^^^^^^^^^^

結果セットから単一の行を取得するには、ステートメントオブジェクトの ``fetch()``
メソッドを使用します。 このメソッドの三つの引数は、いずれも省略可能です。

- 最初の引数は **取得形式**
  を指定します。これは、返り値の構造を決めるものです。
  ここで指定できる値と対応する返り値については :ref:` <zend.db.adapter.select.fetch-mode>`
  を参照ください。

- 二番目の引数で指定するのは、 **カーソルの種類** です。デフォルトは
  Zend_Db::FETCH_ORI_NEXT で、 ``fetch()`` をコールするたびに *RDBMS*
  が返す順で次の行を返すというものです。

- 三番目の引数で指定するのは **オフセット** です。 カーソルの種類が
  Zend_Db::FETCH_ORI_ABS の場合、 これは結果セットの中の何行目を返すのかを表します。
  カーソルの種類が Zend_Db::FETCH_ORI_REL の場合、 これは直前に ``fetch()``
  をコールした際の位置からの相対位置を表します。

すでに結果セットのすべての行が取得済みである場合は ``fetch()`` は ``FALSE``
を返します。

.. _zend.db.statement.fetching.fetch.example:

.. rubric:: ループ内での fetch() の使用

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT * FROM bugs');

   while ($row = $stmt->fetch()) {
       echo $row['bug_description'];
   }

`PDOStatement::fetch()`_ のマニュアルも参照ください。

.. _zend.db.statement.fetching.fetchall:

結果セット全体の取得
^^^^^^^^^^

結果セットのすべての行を一度に取得するには、 ``fetchAll()`` メソッドを使用します。
これは、ループ内で ``fetch()``
メソッドを繰り返し使用してすべての行を配列に格納するのと同じことです。
``fetchAll()`` メソッドにはふたつの引数を指定できます。
最初の引数は、先ほど説明したのと同じ取得形式です。
二番目の引数は、返すカラム番号を指定します。これは最初の引数が Zend_Db::FETCH_COLUMN
である場合に使用します。

.. _zend.db.statement.fetching.fetchall.example:

.. rubric:: fetchAll() の使用法

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT * FROM bugs');

   $rows = $stmt->fetchAll();

   echo $rows[0]['bug_description'];

`PDOStatement::fetchAll()`_ のマニュアルも参照ください。

.. _zend.db.statement.fetching.fetch-mode:

取得形式の変更
^^^^^^^

デフォルトでは、ステートメントオブジェクトが結果セットの行を返す形式は連想配列で、
カラム名とそのカラムの値を関連付けたものとなります。
結果を別の形式で返すように指定する方法は、アダプタクラスの場合と同じです。
ステートメントオブジェクトの ``setFetchMode()``
メソッドで、取得形式を指定します。指定できる値は、 ``Zend_Db`` クラスの定数
FETCH_ASSOC、FETCH_NUM、FETCH_BOTH、FETCH_COLUMN そして FETCH_OBJ です。 これらについての詳細は
:ref:` <zend.db.adapter.select.fetch-mode>` を参照ください。 これを指定すると、それ以降の
``fetch()`` メソッドや ``fetchAll()`` メソッドでその形式を使用するようになります。

.. _zend.db.statement.fetching.fetch-mode.example:

.. rubric:: 取得形式の設定

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT * FROM bugs');

   $stmt->setFetchMode(Zend_Db::FETCH_NUM);

   $rows = $stmt->fetchAll();

   echo $rows[0][0];

`PDOStatement::setFetchMode()`_ のマニュアルも参照ください。

.. _zend.db.statement.fetching.fetchcolumn:

結果セットからの単一のカラムの取得
^^^^^^^^^^^^^^^^^

結果セットの次の行から単一のカラムの値を取得するには ``fetchColumn()``
を使用します。 取得するカラムの位置を表すインデックスを引数で指定します。
省略した場合のデフォルトは 0 となります。このメソッドは、
スカラー値を返します。もし結果セットのすべての行が既に取得済みである場合は
``FALSE`` を返します。

このメソッドの動作は、アダプタクラスの ``fetchCol()``
メソッドとは異なることに注意しましょう。 ステートメントクラスの ``fetchColumn()``
メソッドは、 単一の行の単一の値を返します。アダプタの ``fetchCol()``
メソッドは、値の配列を返します。
これは、結果セットのすべての行の、最初のカラムの値をまとめたものです。

.. _zend.db.statement.fetching.fetchcolumn.example:

.. rubric:: fetchColumn() の使用法

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT bug_id, bug_description, bug_status FROM bugs');

   $bug_status = $stmt->fetchColumn(2);

`PDOStatement::fetchColumn()`_ のマニュアルも参照ください。

.. _zend.db.statement.fetching.fetchobject:

オブジェクト形式での行の取得
^^^^^^^^^^^^^^

結果セットの行をオブジェクトとして取得するには ``fetchObject()``
を使用します。このメソッドの引数は二つで、
いずれも省略可能です。最初の引数には、返り値のオブジェクトのクラス名を指定します。
デフォルトは 'stdClass' です。二番目の引数には配列を指定します。
これは、最初の引数で指定したクラスのコンストラクタに渡す引数となります。

.. _zend.db.statement.fetching.fetchobject.example:

.. rubric:: fetchObject() の使用法

.. code-block:: php
   :linenos:

   $stmt = $db->query('SELECT bug_id, bug_description, bug_status FROM bugs');

   $obj = $stmt->fetchObject();

   echo $obj->bug_description;

`PDOStatement::fetchObject()`_ のマニュアルも参照ください。



.. _`PHP Data Objects`: http://www.php.net/pdo
.. _`PDOStatement::fetch()`: http://www.php.net/PDOStatement-fetch
.. _`PDOStatement::fetchAll()`: http://www.php.net/PDOStatement-fetchAll
.. _`PDOStatement::setFetchMode()`: http://www.php.net/PDOStatement-setFetchMode
.. _`PDOStatement::fetchColumn()`: http://www.php.net/PDOStatement-fetchColumn
.. _`PDOStatement::fetchObject()`: http://www.php.net/PDOStatement-fetchObject
