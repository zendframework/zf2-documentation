.. _zend.db.select:

Zend_Db_Select
==============

.. _zend.db.select.简介:

简介
--

使用Zend_Db_Select方法是一种不受数据库约束构建select的sql语句的工具
（ares注：用户可以使用该方法生成查询的sql语句，而不需要考虑各种数据
库sql语句的差别）。虽然该方法明显还不完善，但是的确为我们提供一种方
法，帮助我们在不同的后台数据库进行相同的查询工作。除此之外，它还可
以避免sql语句攻击。

创建一个zend_db_select实例最简单的方法就是使用zend_db_adapter::select()方法

.. code-block::
   :linenos:
   <?php

   require_once 'Zend/Db.php';

   $params = array (
       'host'     => '127.0.0.1',
       'username' => 'malory',
       'password' => '******',
       'dbname'   => 'camelot'
   );

   $db = Zend_Db::factory('PDO_MYSQL', $params);

   $select = $db->select();
   // $select现在是一个Zend_Db_Select_PdoMysql对象

   ?>
你可以使用该对象和它的相应方法构建一个select查询语句，然后生成
字符串符用来传送给zend_db_adapter进行查询或者读取结果。

.. code-block::
   :linenos:
   <?php

   //
   // SELECT *
   //     FROM round_table
   //     WHERE noble_title = "Sir"
   //     ORDER BY first_name
   //     LIMIT 10 OFFSET 20
   //

   // 你可以使用一种重复定义的方式...
   $select->from('round_table', '*');
   $select->where('noble_title = ?', 'Sir');
   $select->order('first_name');
   $select->limit(10,20);

   // ...或者使用一种连续定义的方式:
   $select->from('round_table', '*')
          ->where('noble_title = ?', 'Sir')
          ->order('first_name')
          ->limit(10,20);

   // 但是，读取数据的方法相同
   $sql = $select->__toString();
   $result = $db->fetchAll($sql);

   // 对于以上任一种方式，你都可以传送$select对象本身
   // 使用Zend_Db_Select对象的 __toString()方法就可以得到查询语句

   $result = $db->fetchAll($select);

   ?>
你也可以在你的查询语句中使用绑定的参数，而不需要自己为参数加引号。

.. code-block::
   :linenos:
   <?php

   //
   // SELECT *
   //     FROM round_table
   //     WHERE noble_title = "Sir"
   //     ORDER BY first_name
   //     LIMIT 10 OFFSET 20
   //

   $select->from('round_table', '*')
          ->where('noble_title = :title')
          ->order('first_name')
          ->limit(10,20);

   // 读取结果使用绑定的参数
   $params = array('title' => 'Sir');
   $result = $db->fetchAll($select, $params);

   ?>
.. _zend.db.select.fromcols:

同一表中查询多列数据
----------

当需要从某一个指定的表查询某几列时，可以使用from()方法，将需要
查询的表名和列名都在该方法中指定。表名和列名都可以通过别名代替
，而且也可以根据需要多次使用from()方法。

.. code-block::
   :linenos:
   <?php

   // 创建一个$db对象，假定adapter为Mysql
   $select = $db->select();

   // 从some_table表中读取a,b,c三列
   $select->from('some_table', 'a, b, c');
   // 同样可以:
   $select->from('some_table', array('a', 'b', 'c');

   // 从foo AS bar表中读取列bar.col
   $select->from('foo AS bar', 'bar.col');

   // 从foo, bar两个表中读取foo.col 别名为col1，bar.col别名为col2
   $select->from('foo', 'foo.col AS col1');
   $select->from('bar', 'bar.col AS col2');

   ?>
.. _zend.db.select.表联合查询:

多表联合查询
------

当需要进行表联合查询时，可以使用join()方法。首先，设定进行表
联合查询的表名，然后是表联合的条件(ares注：该条件是针对多表
内部连接的条件)，最后是查询的列名。同样，你可以根据需要多次 使用join()方法。

.. code-block::
   :linenos:
   <?php

   // 创建一个$db对象，假定adapter为Mysql.
   $select = $db->select();

   //
   // SELECT foo.*, bar.*
   //     FROM foo
   //     JOIN bar ON foo.id = bar.id
   //
   $select->from('foo', '*');
   $select->join('bar', 'foo.id = bar.id', '*');

   ?>
目前为止，zend framework只支持普通的内部表结合语法，而不支持左结合
，右结合，等等外部连接方式。未来版本，将会更多的支持更多的连接方式。

.. _zend.db.select.where:

WHERE条件
-------

当需要要增加where条件时，可以使用where（）方法。你可以传送一个
普通的查询语句字符串，也可以传送一个使用？作为占位符的字符串,然
后在占位符处加入通过加引号处理后的数据(将使用Zend_Db_Adapter::quoteInto方法进行数据处理)

Multiple calls to where() will AND the conditions together; if you need to OR a condition, use orWhere().

.. code-block::
   :linenos:
   <?php

   // 创建一个$db对象，调用SELECT方法.
   $select = $db->select();

   //
   // SELECT *
   //     FROM round_table
   //     WHERE noble_title = "Sir"
   //     AND favorite_color = "yellow"
   //
   $select->from('round_table', '*');
   $select->where('noble_title = "Sir"'); // embedded value
   $select->where('favorite_color = ?', 'yellow'); // quoted value

   //
   // SELECT *
   //     FROM foo
   //     WHERE bar = "baz"
   //     OR id IN("1", "2", "3")
   //
   $select->from('foo', '*');
   $select->where('bar = ?', 'baz');
   $select->orWhere('id IN(?)', array(1, 2, 3);

   ?>
.. _zend.db.select.group:

GROUP BY分句
----------

根据需要，可以多次使用group()方法给查询到的数据进行分组

.. code-block::
   :linenos:
   <?php

   // 创建一个$db对象，调用SELECT方法.
   $select = $db->select();

   //
   // SELECT COUNT(id)
   //     FROM foo
   //     GROUP BY bar, baz
   //
   $select->from('foo', 'COUNT(id)');
   $select->group('bar');
   $select->group('baz');

   // 同样可以这样调用 group() 方法:
   $select->group('bar, baz');

   // 还可以:
   $select->group(array('bar', 'baz'));

   ?>
.. _zend.db.select.having:

HAVING 条件
---------

当需要在查询结果中加入having条件时，可以使用having()方法。
这种方法与where()方法的功能一样。.

当你多次调用having（）方法时，各个having的条件会“并”在一起进行操作；
假如你需要实现“或 ”操作，可以使用orHaving()方法

.. code-block::
   :linenos:
   <?php

   // 创建一个$db对象，调用SELECT方法.
   $select = $db->select();

   //
   // SELECT COUNT(id) AS count_id
   //     FROM foo
   //     GROUP BY bar, baz
   //     HAVING count_id > "1"
   //
   $select->from('foo', 'COUNT(id) AS count_id');
   $select->group('bar, baz');
   $select->having('count_id > ?', 1);

   ?>
.. _zend.db.select.order:

ORDER BY 分句
-----------

根据需要，可以多次使用order()方法给查询到的数据进行排序

.. code-block::
   :linenos:
   <?php

   // 创建一个$db对象，调用SELECT方法.
   $select = $db->select();

   //
   // SELECT * FROM round_table
   //     ORDER BY noble_title DESC, first_name ASC
   //
   $select->from('round_table', '*');
   $select->order('noble_title DESC');
   $select->order('first_name');

   // 同样可以这样调用 order() 方法:
   $select->order('noble_title DESC, first_name');

   // 还可以:
   $select->order(array('noble_title DESC', 'first_name'));

   ?>
.. _zend.db.select.limit:

通过总数和偏移量进行LIMIT限制
-----------------

Zend_db_select可以支持数据库层的limit语句限制。对于一些数据库，例如mysql
和postgresql，实现这些是相对容易的，因为这些数据库本身就支持“limit：count” 语法。

对于其他一些数据库来说，例如微软的sqlserver和oracle，要实现limit功能
就不那么简单了，因为他们本身就根本不支持limit语句。MS-SQL有一个top语
句来实现，而oracle要实现limit功能，查询语句的写法就更特殊一些。由于
zend_db_select内在地工作的方式，我们可以重写select语句以在oracle中
实现上述开源数据库系统的limit功能。

要通过设定查询的总数和偏移量对返回的结果进行限制,可以使用limit()方法，
总数值和一个可选的偏移量作为调用该方法的参数。

.. code-block::
   :linenos:
   <?php

   // 首先，一个简单的 "LIMIT :count"
   $select = $db->select();
   $select->from('foo', '*');
   $select->order('id');
   $select->limit(10);

   //
   // 在mysql/psotgreSql/SQLite,可以得到这样的语句：
   //
   // SELECT * FROM foo
   //     ORDER BY id ASC
   //     LIMIT 10
   //
   // 但是在Microsoft SQL下,可以得到这样的语句：
   //
   // SELECT TOP 10 * FROM FOO
   //     ORDER BY id ASC
   //
   //

   // 现在, 是更复杂的 "LIMIT :count OFFSET :offset"方法
   $select = $db->select();
   $select->from('foo', '*');
   $select->order('id');
   $select->limit(10, 20);

   //
   // 在mysql/psotgreSql/SQLite,可以得到这样的语句：
   //
   // SELECT * FROM foo
   //     ORDER BY id ASC
   //     LIMIT 10 OFFSET 20
   //
   // 但是在Microsoft SQL下,由于不支持偏移量功能,可以得到这样sql语句:
   //
   // SELECT * FROM (
   //     SELECT TOP 10 * FROM (
   //         SELECT TOP 30 * FROM foo ORDER BY id DESC
   //     ) ORDER BY id ASC
   // )
   //
   // Zend_Db_Adapter 可以自动的完成sql语句的动态创建.
   //

   ?>
.. _zend.db.select.分页:

通过页数和总数进行LIMIT限制
----------------

Zend_db_select同样也提供了翻页的limit功能。假如你想要从结果中找到
特定“页数”的结果，使用limitPage()方法；将你需要的页数值和每页显示
的数据值数作为参数传过去即可.

.. code-block::
   :linenos:
   <?php

   // 构造基础的select方法:
   $select = $db->select();
   $select->from('foo', '*');
   $select->order('id');

   // ... 限制到第三页,每页包括10行数据
   $select->limitPage(3, 10);

   //
   // 在MySQL/PostgreSQL/SQLite下, 可以得到:
   //
   // SELECT * FROM foo
   //     ORDER BY id ASC
   //     LIMIT 10 OFFSET 20
   //

   ?>

