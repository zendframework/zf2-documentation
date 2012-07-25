.. _zend.db.tablerowset:

Zend_Db_Table_Rowset
====================

.. _zend.db.table.rowset.introduction:

简介
--

Zend_Db_Table_Rowset是
Zend_Db_Table_Row对象集合的迭代器.通常来说,你不可以自己实例化Zend_Db_Table_Rowset,
而是通过调用Zend_Db_Table::find()方法或者fetchAll()方法将Zend_Db_Table_Rowset作为
结果数据返回过来.接下来就可以遍历Zend_Db_Table_Row对象集合并进行修改.

.. _zend.db.table.rowset.fetch:

取回结果集
-----

首先,需要实例化一个Zend_Db_Table类.

.. code-block:: php
   :linenos:

   <?php
   // 设置一个 adapter
   require_once 'Zend/Db.php';
   $params = array (
       'host'     => '127.0.0.1',
       'username' => 'malory',
       'password' => '******',
       'dbname'   => 'camelot'
   );

   $db = Zend_Db::factory('PDO_MYSQL', $params);

   // 为所有的Zend_Db_Table对象设置默认
   require_once 'Zend/Db/Table.php';
   Zend_Db_Table::setDefaultAdapter($db);

   // 连接数据库表
   class RoundTable extends Zend_Db_Table {}
   $table = new RoundTable();
   ?>

接下来,可以使用Zend_Db_Table::find()方法和多个键值,或者使用Zend_Db_Table::fetchAll()方法对数据库进行查询,
返回的结果是一个Zend_Db_Table_Rowset对象,可以通过该对象遍历结果集中的每一个Zend_Db_Table_Row对象.

.. code-block:: php
   :linenos:

   <?php
   // 从表中取回多条记录
   $rowset = $table->fetchAll();

   //
   // $rowset现在是一个Zend_Db_Table_Rowset对象,该对象中每条记录就是一个Zend_Db_Table_Row对象
   //
   ?>

.. _zend.db.table.rowset.iterate:

遍历结果集
-----

Zend_Db_Table_Rowset实现了简单程序设计语言的迭代器接口,也就是说,可以对Zend_Db_Table_Rowset
对象进行循环处理,就像使用foreach()函数处理数组一样.使用这种方法取回的每一个值都是一个对应表
中数据的Zend_Db_Table_Row对象,你可以查看,修改和保存该对象的属性(即表中的字段值.)

.. code-block:: php
   :linenos:

   <?php
   // 连接到数据库中的表
   class RoundTable extends Zend_Db_Table {}
   $table = new RoundTable();

   // 从表中取回多条记录
   $rowset = $table->fetchAll();

   // 显示所有的记录
   foreach ($rowset as $row) {
       // $row 是一个 Zend_Db_Table_Row 对象
       echo "<p>" . htmlspecialchars($row->nobleTitle) . " "
          . htmlspecialchars($row->firstName) . "'s "
          . "favorite color is " . htmlspecialchars($row->favoriteColor)
          . ".</p>\n";

       // 更新我们显示改行的次数
       // (对应表中的"times_displayed"字段)
       $row->timesDisplayed ++;

       // 保存新记录.
       $row->save();
   }
   ?>


