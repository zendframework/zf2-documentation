.. _zend.db.table.row:

Zend_Db_Table_Row
=================

.. _zend.db.table.row.introduction:

简介
------

Zend_Db_Table_Row是Zend Framework的行数据网关.通常来说,你不可以自己实例化Zend_Db_Table_Row,
而是通过调用Zend_Db_Table::find()方法或者Zend_Db_Table::fetchRow()方法将Zend_Db_Table_Row作为
结果数据返回过来.一旦你得到来一个Zend_Db_Table_Row对象,你可以修改记录值(体现为类的属性)然后
调用save()方法可以将更改保存到原表上.

.. _zend.db.table.row.fetch:

取回一条记录
------------------

首先,需要实例化一个Zend_Db_Table类.

.. code-block::
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

   // 为所有的Zend_Db_Table对象设置默认adapter
   require_once 'Zend/Db/Table.php';
   Zend_Db_Table::setDefaultAdapter($db);

   // 连接到数据库中的某一个表
   class RoundTable extends Zend_Db_Table {}
   $table = new RoundTable();
   ?>

接下来,使用Zend_Db_Table::find()方法和主键进行查询,或者使
用Zend_Db_Table::fetchRow()方法查询.得到的返回结果是一个Zend_Db_Table_Row
对象,该对象的属性名采用camelCaps的形式对应数据库中带下划线的表名.例如,表名
若为first_name,那么类中的改属性则为firstName.

.. code-block::
   :linenos:
   <?php
   // 从表中取回的结果数据是一个Zend_Db_Table_Row对象
   $row = $table->fetchRow('first_name = "Robin"');

   //
   // $row现在是一个带有多种公有属性的Zend_Db_Table_Row对象
   // that map to table columns:
   //
   // $row->id = '3'
   // $row->nobleTitle = 'Sir'
   // $row->firstName = 'Robin'
   // $row->favoriteColor = 'yellow'
   //

   ?>

.. _zend.db.table.row.modify:

修改数据
------------

修改行数据是一件很轻松的事情:只需要按照常规的方法修改类属性.然后调用save()方法
就将改变的结果保存到了数据表中.

.. code-block::
   :linenos:
   <?php
   // 连接到数据库中的表
   class RoundTable extends Zend_Db_Table {}
   $table = new RoundTable();

   // 从表中取回的结果数据是一个Zend_Db_Table_Row对象
   $row = $table->fetchRow('first_name = "Robin"');

   //
   // $row现在是一个带有多种公有属性的Zend_Db_Table_Row对象
   // that map to table columns:
   //
   // $row->id = '3'
   // $row->nobleTitle = 'Sir'
   // $row->firstName = 'Robin'
   // $row->favoriteColor = 'yellow'
   //
   // 改变favorite color字段,并且将变动存储到数据表中.
   $row->favoriteColor = 'blue';'
   $row->save();
   ?>

但是,你不能够修改主键的值.假如你试图进行改操作, Zend_Db_Table_Row将抛出一个异常.

.. code-block::
   :linenos:
   <?php
   // 连接到数据库中的表
   class RoundTable extends Zend_Db_Table {}
   $table = new RoundTable();

   // fetch a record from the table as a Zend_Db_Table_Row object
   $row = $table->fetchRow('first_name = "Robin"');

   // 我们尝试修改主键值
   try {
       $row->id = 5;
       echo "We should not see this message, as an exception was thrown.";
   } catch (Zend_Db_Table_RowException $e) {
       echo $e->getMessage();
   }
   ?>


