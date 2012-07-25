.. _zend.db.table:

Zend_Db_Table
=============

.. _zend.db.table.简介:

简介
--

Zend_Db_Table 是Zend Framework的表模块.它通过zend_db_adapter连接到
数据库,为数据库模式检查表对象,并对该表进行操作和查询.

.. _zend.db.table.getting-started:

开始
--

首先需要为抽象类zend_db_table(ares注:该类为抽象类,所以不能直接实例
化,只能先继承该类,然后实例化子类)设定一个默认对数据库adapter;除非你
指定其他类型数据库adapter,否则,所有的zend_db_table类实例都会使用 默认adapter.

.. code-block:: php
   :linenos:

   <?php
   // 建立一个 adapter
   require_once 'Zend/Db.php';
   $params = array (
       'host'     => '127.0.0.1',
       'username' => 'malory',
       'password' => '******',
       'dbname'   => 'camelot'
   );

   $db = Zend_Db::factory('PDO_MYSQL', $params);

   // 为所有的Zend_Db_Table对象设定默认的adapter
   require_once 'Zend/Db/Table.php';
   Zend_Db_Table::setDefaultAdapter($db);
   ?>

接下来,我们假定数据库中存在一个名为”round_table”的表.要对该表
使用zend_db_table,只需继承zend_db_table类创建一个名为RoundTable的
新类.然后我就可以通过该类在数据库中的round_table表中检查,操作数据
行并且取得数据结果.

.. code-block:: php
   :linenos:

   <?php
   class RoundTable extends Zend_Db_Table {}
   $table = new RoundTable();
   ?>

.. _zend.db.table.name-and-key:

表名和主键
-----

默认情况下,zend_db_table类会将其类名当作数据库中表名(大小写不同
的地方需要添加"\_").例如,一个名为SomeTableName的zend_db_table类在
数据库中就对应表”some_table_name”.假如不希望将类名与数据库表名以
这种添加下划线的形式进行对应,可以在定义该类时对$_name进行重构.

.. code-block:: php
   :linenos:

   <?php
   class ClassName extends Zend_Db_Table
   {
       // 默认表名为 'class_name'
       // 但是我们也可以对应其它表
       protected $_name = 'another_table_name';
   }
   ?>

zend_db_table类默认字段”id”为表的主键(该字段最好为自增的,但并不
是必须的).假如该表的主键并不是名为”$id”,你可以在定义表实体类时
对$_primary进行重构

.. code-block:: php
   :linenos:

   <?php
   class ClassName extends Zend_Db_Table
   {
       // 默认主键为’id’
       // 但我们也可以设定其他列名为主键
       protected $_primary = 'another_column_name';
   }
   ?>

你也可以通过表实体类中_setup()方法设定这些变量;但是需要确保在修改
后再执行一次parent::\_setup()方法.

.. code-block:: php
   :linenos:

   <?php
   class ClassName extends Zend_Db_Table
   {
       protected function _setup()
       {
           $this->_name = 'another_table_name';
           $this->_primary = 'another_column_name';
           parent::_setup();
       }
   }
   ?>

.. _zend.db.table.insert:

插入数据
----

要在表中插入一行新数据,只需要将列名:数据的关联数组作为参数,调
用insert()方法即可.(zend framework)会自动对数据进行加引号处理,
并返回插入的最后一行的id值(注意:这里不同于
zend_db_adapter::insert方法,后者返回的是插入的行数).

.. code-block:: php
   :linenos:

   <?php
   //
   // INSERT INTO round_table
   //     (noble_title, first_name, favorite_color)
   //     VALUES ("King", "Arthur", "blue")
   //

   class RoundTable extends Zend_Db_Table {}

   $table = new RoundTable();

   $data = array(
       'noble_title' => 'King',
       'first_name'  => 'Arthur',
       'favorite_color' => 'blue',
   )

   $id = $table->insert($data);
   ?>

.. _zend.db.table.udpate:

更新数据
----

要修改表中的任意行数据,我们可以设定一个列名:数据的关联数组作为参数,调
用update()方法,同是通过一个where条件从句来决定需要改变的行.该方法将会
修改表中数据并返回被修改的行数.

(Zend frameword)将会自动对修改对数据进行加引号处理,但是这种检查不包括
条件分句,所以你需要使用该表的zend_db_adapter对象完成该工作.

.. code-block:: php
   :linenos:

   <?php
   //
   // UPDATE round_table
   //     SET favorite_color = "yellow"
   //     WHERE first_name = "Robin"
   //

   class RoundTable extends Zend_Db_Table {}

   $table = new RoundTable();
   $db = $table->getAdapter();

   $set = array(
       'favorite_color' => 'yellow',
   )

   $where = $db->quoteInto('first_name = ?', 'Robin');

   $rows_affected = $table->update($set, $where);
   ?>

.. _zend.db.table.delete:

Deleting Rows
-------------

要删除表中的数据,我们可以调用delete()方法,同时通过一个where条件
分句来决定需要删除的行.该方法将会返回被删除的行数.

(zend framework)不会对条件分句进行加引号处理,所以你需要使用该表
的zend_db_adapter对象完成该工作.

.. code-block:: php
   :linenos:

   <?php
   //
   // DELETE FROM round_table
   //     WHERE first_name = "Patsy"
   //

   class RoundTable extends Zend_Db_Table {}

   $table = new RoundTable();
   $db = $table->getAdapter();

   $where = $db->quoteInto('first_name = ?', 'Patsy');

   $rows_affected = $table->delete($where);
   ?>

.. _zend.db.table.findbykey:

根据主键查找数据
--------

通过调用find()方法,可以使用主键值轻松地在表中检索数据.假如你只想要查询某
一条数据,该方法将回返回一个zend_db_table_row对象,而当你想要查询多条记录时
,将会返回一个zend_db_table_rowset对象.

.. code-block:: php
   :linenos:

   <?php
   class RoundTable extends Zend_Db_Table {}

   $table = new RoundTable();

   // SELECT * FROM round_table WHERE id = "1"
   $row = $table->find(1);

   // SELECT * FROM round_table WHERE id IN("1", "2", 3")
   $rowset = $table->find(array(1, 2, 3));
   ?>

.. _zend.db.table.fetchonerow:

取回一条记录
------

虽然通过主键找到相应数据行是很便利的事情,但是在更多的时候,我们是
通过其他一些非主键的条件来查找数据行的.zend_db_table提供了一个
fetchRow()方法可以实现这个功能.我们可以通过一个where条件语句(和一
个可选的order语句)调用fetchRow()方法,然后zend_db_tabel将会返回满
足条件的第一行数据的zend_db_table_row对象.

注意,(zend framework) 将不会对where语句进行加引号处理,所以你需要
通过zend_db_adapter进行数据处理.

.. code-block:: php
   :linenos:

   <?php
   //
   // SELECT * FROM round_table
   //     WHERE noble_title = "Sir"
   //     AND first_name = "Robin"
   //     ORDER BY favorite_color
   //

   class RoundTable extends Zend_Db_Table {}

   $table = new RoundTable();
   $db = $table->getAdapter();

   $where = $db->quoteInto('noble_title = ?', 'Sir')
          . $db->quoteInto('AND first_name = ?', 'Robin');

   $order = 'favorite_color';

   $row = $table->fetchRow($where, $order);
   ?>

.. _zend.db.table.fetchmultiple:

取回多条记录
------

假如需要一次检索多条记录.可以使用fetchAll()方法.和使用fetchRow()方法类
似,该方法不仅仅可以设定where和order分句,也可以设定limit-count和
limit-offset值来限制返回的结果数.执行该方法后,把选择的结果作为一个
Zend_Db_Table_Rowset对象返回.

注意,(zend framework) 将不会对where语句进行加引号处理,所以你需要
通过zend_db_adapter进行数据处理.

.. code-block:: php
   :linenos:

   <?php
   class RoundTable extends Zend_Db_Table {}

   $table = new RoundTable();
   $db = $table->getAdapter();

   // SELECT * FROM round_table
   //     WHERE noble_title = "Sir"
   //     ORDER BY first_name
   //     LIMIT 10 OFFSET 20

   $where = $db->quoteInto('noble_title = ?', 'Sir');
   $order = 'first_name';
   $count = 10;
   $offset = 20;

   $rowset = $table->fetchAll($where, $order, $count, $offset);
   ?>

.. _zend.db.table.domain-logic:

Adding Domain Logic
-------------------

作为Zend Framework的表模块,Zend_Db_Table将它自己很好的封装到独特的domain logic下.
例如,你可以重载insert()和update()方法,以实现在数据更改提交前的操作和验证.

.. code-block:: php
   :linenos:

   <?php
   class RoundTable extends Zend_Db_Table
   {
       public function insert($data)
       {
           // 添加一个时间戳
           if (empty($data['created_on'])) {
               $data['created_on'] = time();
           }
           return parent::insert($data);
       }

       public function update($data)
       {
           // 添加一个时间戳
           if (empty($data['updated_on'])) {
               $data['updated_on'] = time();
           }
           return parent::update($data);
       }
   }
   ?>

类似的,你也可以设定自己的find()方法,通过主键外的其他字段来查询数据.

.. code-block:: php
   :linenos:

   <?php
   class RoundTable extends Zend_Db_Table
   {
       public function findAllWithName($name)
       {
           $db = $this->getAdapter();
           $where = $db->quoteInto("name = ?", $name);
           $order = "first_name";
           return $this->fetchAll($where, $order);
       }
   }
   ?>


