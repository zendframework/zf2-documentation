.. EN-Revision: none
.. _zend.log.writers:

Writers
=======

一个Writer是继承自 *Zend\Log_Writer\Abstract*\
类的一个对象.Writer的职责是向存储后端纪录日志数据.

.. _zend.log.writers.stream:

写入到流(Streams)
-------------

*Zend\Log_Writer\Stream* 写入日志数据到 `PHP 流`_\ 中.

要把日志写入到输出缓冲区,使用URL *php:://output*. 或则你可以直接发送日志数据到像
*STDERR* 这样的流中(php://stderr).

   .. code-block:: php
      :linenos:

      $writer = new Zend\Log_Writer\Stream('php://output');
      $logger = new Zend\Log\Log($writer);

      $logger->info('Informational message');




写入日志数据到一个文件,使用 `Filesystem URLs`_\ 之一:

   .. code-block:: php
      :linenos:

      $writer = new Zend\Log_Writer\Stream('/path/to/logfile');
      $logger = new Zend\Log\Log($writer);

      $logger->info('Informational message');


默认情况流一个追加(*"a"*)的方式打开.要以不同的模式打开,Zend\Log_Writer\Stream
构造函数接受第二个参数作为可选的模式参数.

*Zend\Log_Writer\Stream*\ 还接受一个现有的流资源:

   .. code-block:: php
      :linenos:

      $stream = @fopen('/path/to/logfile', 'a', false);
      if (! $stream) {
          throw new Exception('Failed to open stream');
      }

      $writer = new Zend\Log_Writer\Stream($stream);
      $logger = new Zend\Log\Log($writer);

      $logger->info('Informational message');


你不能给现有的流资源指定模式.这样作将导致抛出一个 *Zend\Log\Exception*\ 异常.

.. _zend.log.writers.database:

写入到数据库
------

*Zend\Log_Writer\Db*\ 使用 *Zend_Db*\ 写入日志信息到数据库表中. *Zend\Log_Writer\Db*\
的构造函数接受一个 *Zend\Db\Adapter*
实例,一个表名,和一个数据库字段到事件数据项的映射:

   .. code-block:: php
      :linenos:

      $params = array ('host'     => '127.0.0.1',
                       'username' => 'malory',
                       'password' => '******',
                       'dbname'   => 'camelot');
      $db = Zend\Db\Db::factory('PDO_MYSQL', $params);

      $columnMapping = array('lvl' => 'priority', 'msg' => 'message');
      $writer = new Zend\Log_Writer\Db($db, 'log_table_name', $columnMapping);

      $logger = new Zend\Log\Log($writer);

      $logger->info('Informational message');


上面的例子写入单个行到名称为 *log_table_name*\ 的数据库表中.数据库字段 *lvs*
接收优先级号,名为 *msg*\ 的字段接收日志消息.

.. include:: zend.log.writers.firebug.rst
.. _zend.log.writers.null:

踩熄Writer
--------

*Zend\Log_Writer\Null*\ 是一个不向任何地方写入任何数据的存根.
用于在测试期间关闭或踩熄日志.

   .. code-block:: php
      :linenos:

      $writer = new Zend\Log_Writer\Null;
      $logger = new Zend\Log\Log($writer);

      // goes nowhere
      $logger->info('Informational message');




.. _zend.log.writers.mock:

测试 Mock
-------

*Zend\Log_Writer\Mock*\
是一个非常简单的Writer,它纪录所接收到的原始的数据到到作为public属性的 数组中.

   .. code-block:: php
      :linenos:

      $mock = new Zend\Log_Writer\Mock;
      $logger = new Zend\Log\Log($mock);

      $logger->info('Informational message');

      var_dump($mock->events[0]);

      // Array
      // (
      //    [timestamp] => 2007-04-06T07:16:37-07:00
      //    [message] => Informational message
      //    [priority] => 6
      //    [priorityName] => INFO
      // )




清空有mock记录的日志,设置 *$mock->events = array()*\ 即可.

.. _zend.log.writers.compositing:

组合Writers
---------

没有复合Writer对象,但是一个Log实例可以有任意个Writer.使用 *addWriter*\ 方法 添加Writer:

   .. code-block:: php
      :linenos:

      $writer1 = new Zend\Log_Writer\Stream('/path/to/first/logfile');
      $writer2 = new Zend\Log_Writer\Stream('/path/to/second/logfile');

      $logger = new Zend\Log\Log();
      $logger->addWriter($writer1);
      $logger->addWriter($writer2);

      // goes to both writers
      $logger->info('Informational message');






.. _`PHP 流`: http://www.php.net/stream
.. _`Filesystem URLs`: http://www.php.net/manual/en/wrappers.php#wrappers.file
