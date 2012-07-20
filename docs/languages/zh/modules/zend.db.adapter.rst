.. _zend.db.adapter:

Zend_Db_Adapter
===============

.. _zend.db.adapter.introduction:

简介
--

*Zend_Db_Adapter*\ 是zendfrmaeword的数据库抽象层api. 基于pdo, 你可以使用 *Zend_Db_Adapter*
连接和处理多种 数据库,包括:microsoft SQL Server,MySql,SQLite等等.

要针对不同的数据库实例化一个 *Zend_Db_Adapter* 对象, 需要
将adapter的名字和描述数据库连接的参数数组作为参数，静态调用 *Zend_Db::factory()*\
方法。例如，连接到一个数据库名称为
“camelot”，用户名为“malory”的本地mysql数据库，可以进行如下操作:

.. code-block::
   :linenos:
   <?php

   require_once 'Zend/Db.php';

   $params = array ('host'     => '127.0.0.1',
                    'username' => 'malory',
                    'password' => '******',
                    'dbname'   => 'camelot');

   $db = Zend_Db::factory('PDO_MYSQL', $params);

   ?>
同样，连接到一个库名为“camelot”的SQLite数据库:

.. code-block::
   :linenos:
   <?php

   require_once 'Zend/Db.php';

   $params = array ('dbname' => 'camelot');

   $db = Zend_Db::factory('PDO_SQLITE', $params);

   ?>
任一种方法都可以让你使用同样的api查询数据库。

.. _zend.db.adapter.quoting:

添加引号防止数据库攻击
-----------

你应该处理将在sql语句中使用的条件值；这对于防止sql语句攻击是很有好处的。
*Zend_Db_Adapter* (通过pdo)提供了两种方法帮助你手动的为条件值加上引号。

第一种是 *quote()* 方法. 该方法会根据数据库adapter为标量加上
合适的引号;假如你试图对一个数组做quote操作, 它将为数组中
每个元素加上引号,并用","分隔返回. (对于参数很多的函数来说,这点是很有帮助的).

.. code-block::
   :linenos:
   <?php

   // 创建一个$db对象,假设数据库adapter为mysql.

   // 为标量加引号
   $value = $db->quote('St John"s Wort');
   // $value 现在变成了 '"St John\"s Wort"' (注意两边的引号)

   // 为数组加引号
   $value = $db->quote(array('a', 'b', 'c');
   // $value 现在变成了 '"a", "b", "c"' (","分隔的字符串)

   ?>
第二种是 *quoteInto()* 方法. 你提供一个包含问号占 位符的基础字符串 ,
然后在该位置加入带引号的标量或者数组. 该
方法对于随需构建查询sql语句和条件语句是很有帮助的. 使用
quoteInto处理过的标量和数组返回结果与 *quote()* 方法相同.

.. code-block::
   :linenos:
   <?php

   // 创建一个$db对象,假设数据库adapter为mysql.

   // 在where语句中为标量加上引号
   $where = $db->quoteInto('id = ?', 1);
   // $where 现在为 'id = "1"' (注意两边的引号)

   // 在where语句中为数组加上引号
   $where = $db->quoteInto('id IN(?)', array(1, 2, 3));
   // $where 现在为 'id IN("1", "2", "3")' (一个逗号分隔的字符串)

   ?>
.. _zend.db.adapter.查询:

直接查询
----

一旦你得到了一个 *Zend_Db_Adapter* 实例, 你可以直接 执行sql语句进行查询. *Zend_Db_Adapter*
传送这些sql语 句到底层的PDO对象，由PDO对象组合并执行他们，在有查询结果的情况
下，返回一个PDOStatement对象以便对结果进行处理。

.. code-block::
   :linenos:
   <?php

   // 创建一个$db对象,然后查询数据库
   // 使用完整的sql语句直接进行查询.
   $sql = $db->quoteInto(
       'SELECT * FROM example WHERE date > ?',
       '2006-01-01'
   );
   $result = $db->query($sql);

   // 使用PDOStatement对象$result将所有结果数据放到一个数组中
   $rows = $result->fetchAll();

   ?>
你可以将数据自动的绑定到你的查询中。这意味着你在查询中可以设定
多个指定的占位符，然后传送一个数组数据以代替这些占位符。这些替
换的数据是自动进行加引号处理的，为防止数据库攻击提供了更强的安 全性。

.. code-block::
   :linenos:
   <?php

   // 创建一个$db对象,然后查询数据库.
   // 这一次，使用绑定的占位符.
   $result = $db->query(
       'SELECT * FROM example WHERE date > :placeholder',
       array('placeholder' => '2006-01-01')
   );

   // 使用PDOStatement对象$result将所有结果数据放到一个数组中
   $rows = $result->fetchAll();

   ?>
或者,你也可以手工设置sql语句和绑定数据到sql语句。这一功能通过 *prepare()*
方法得到一个设定好的PDOStatement对象，以便直 接进行数据库操作.

.. code-block::
   :linenos:
   <?php

   // 创建一个$db对象,然后查询数据库.
   // 这次, 设定一个 PDOStatement 对象进行手工绑定.
   $stmt = $db->prepare('SELECT * FROM example WHERE date > :placeholder');
   $stmt->bindValue('placeholder', '2006-01-01');
   $stmt->execute();

   // 使用PDOStatement对象$result将所有结果数据放到一个数组中
   $rows = $stmt->fetchAll();

   ?>
.. _zend.db.adapter.事务处理:

事务处理
----

默认情况下，PDO(因此 *Zend_Db_Adapter* 也是)是采用自动commit模式。
也就是说，所有的数据库操作执行时就做了commit操作。假如你试图执行事务处理，最
简单的是调用 *beginTransaction()*\ 方法，然后选择commit或者rollback。 之后, *Zend_Db_Adapter*\
会回到自动commit模式下，直到你再次调用 *beginTransaction()*\ 方法

.. code-block::
   :linenos:
   <?php

   // 创建一个 $db对象, 然后开始做一个事务处理.
   $db->beginTransaction();

   // 尝试数据库操作.
   // 假如成功,commit该操作;
   // 假如, roll back.
   try {
       $db->query(...);
       $db->commit();
   } catch (Exception $e) {
       $db->rollBack();
       echo $e->getMessage();
   }

   ?>
.. _zend.db.adapter.insert:

插入数据行
-----

为了方便起见，你可以使用 *insert()*\ 方法将要插入的数据绑定并创建
一个insert语句（绑定的数据是自动进行加引号处理以避免数据库攻击的）

返回值并 **不是** 最后插入的数据的id，这样做的原因在于一些表
并没有一个自增的字段；相反的，这个插入的返回值是改变的数据行数(通常情况为1)。
假如你需要最后插入的数据id，可以在insert执行后调用 *lastInsertId()*\ 方法。

.. code-block::
   :linenos:
   <?php

   //
   // INSERT INTO round_table
   //     (noble_title, first_name, favorite_color)
   //     VALUES ("King", "Arthur", "blue");
   //

   // 创建一个 $db对象, 然后...
   // 以"列名"=>"数据"的格式格式构造插入数组,插入数据行
   $row = array (
       'noble_title'    => 'King',
       'first_name'     => 'Arthur',
       'favorite_color' => 'blue',
   );

   // 插入数据的数据表
   $table = 'round_table';

   // i插入数据行并返回行数
   $rows_affected = $db->insert($table, $row);
   $last_insert_id = $db->lastInsertId();

   ?>
.. _zend.db.adapter.update:

更新数据行
-----

为了方便起见，你可以使用 *update()*\ 方法确定需要update的数据并且创建一个
update语句（确定的数据是自动加引号处理以避免数据库攻击的）。

你可以提供一个可选的where语句说明update的条件（注意：where语句并
不是一个绑定参数，所以你需要自己数据进行加引号的操作）。

.. code-block::
   :linenos:
   <?php

   //
   // UPDATE round_table
   //     SET favorite_color = "yellow"
   //     WHERE first_name = "Robin";
   //

   // 创建一个 $db对象, 然后...
   // 以"列名"=>"数据"的格式构造更新数组,更新数据行
   $set = array (
       'favorite_color' => 'yellow',
   );

   // 更新的数据表
   $table = 'round_table';

   // where语句
   $where = $db->quoteInto('first_name = ?', 'Robin');

   // 更新表数据,返回更新的行数
   $rows_affected = $db->update($table, $set, $where);

   ?>
.. _zend.db.adapter.delete:

删除数据行
-----

为了方便起见，你可以使用 *delete()*\ 方法创建一个delete语句；你
也可以提供一个where语句以说明数据的删除条件。（注意：where语句并不是一个绑
定参数，所以你需要自己进行数据加引号处理）。

.. code-block::
   :linenos:
   <?php

   //
   // 需要删除数据的表
   //     WHERE first_name = "Patsy";
   //

   // 创建一个 $db对象, 然后...
   // 设定需要删除数据的表
   $table = 'round_table';

   // where条件语句
   $where = $db->quoteInto('first_name = ?', 'Patsy');

   // 删除数据并得到影响的行数
   $rows_affected = $db->delete($table, $where);

   ?>
.. _zend.db.adapter.fetch:

取回查询结果
------

尽管你可以使用 *query()*\ 方法直接对数据库进行操作，但是通常情况
下，仍然还是需要选择数据行并返回结果。 *以fetch开头*\ 的一系列的
方法可以实现这个要求。对于每一种 *fetch系列*\ 的方法来说，你需
要传送一个select的sql语句；假如你在操作语句中使用指定的占位符，你也可以
传送一个绑定数据的数组对你的操作语句进行处理和替换。 *Fetch系列* 的方法包括：

- *fetchAll()*

- *fetchAssoc()*

- *fetchCol()*

- *fetchOne()*

- *fetchPairs()*

- *fetchRow()*

.. code-block::
   :linenos:
   <?php

   // 创建一个 $db对象, 然后...

   // 取回结果集中所有字段的值,作为连续数组返回
   $result = $db->fetchAll(
       "SELECT * FROM round_table WHERE noble_title = :title",
       array('title' => 'Sir')
   );

   // 取回结果集中所有字段的值,作为关联数组返回
   // 第一个字段作为码
   $result = $db->fetchAssoc(
       "SELECT * FROM round_table WHERE noble_title = :title",
       array('title' => 'Sir')
   );

   // 取回所有结果行的第一个字段名
   $result = $db->fetchCol(
       "SELECT first_name FROM round_table WHERE noble_title = :title",
       array('title' => 'Sir')
   );

   // 只取回第一个字段值
   $result = $db->fetchOne(
       "SELECT COUNT(*) FROM round_table WHERE noble_title = :title",
       array('title' => 'Sir')
   );

   // 取回一个相关数组,第一个字段值为码
   // 第二个字段为值
   $result = $db->fetchPairs(
       "SELECT first_name, favorite_color FROM round_table WHERE noble_title = :title",
       array('title' => 'Sir')
   );

   // 只取回结果集的第一行
   $result = $db->fetchRow(
       "SELECT * FROM round_table WHERE first_name = :name",
       array('name' => 'Lancelot')
   );

   ?>

