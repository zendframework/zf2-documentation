.. EN-Revision: none
.. _zend.log.overview:

概述
==

*Zend_Log* 是一个通用日志组件.
它支持多个日志后端,格式化发送给日志的消息,过滤被纪录的消息.这些功能被划分为如下的对象:




   - 一个Log (*Zend_Log*\
     的实例)是应用程序使用最多的对象.如果你想你可以有任意多的Log对象;
     它们之间不会相互影响.一个Log对象必须至少包含一个Writer对象,可选的可以包含一个或多个Filter.

   - 一个 Writer (继承自 *Zend\Log_Writer\Abstract*) 负责向存储中保存数据.

   - 一个 Filter (实现 *Zend\Log_Filter\Interface*\
     接口)阻塞数据被保存.一个Filter可以应用到个别的Writer,
     或则在所有Writer之前应用到一个Log.这样Filter是串联起来的.

   - 一个 Formatter (实现了 *Zend\Log_Formatter\Interface*\ 接口)
     在由Writer写入数据之前可以对日志数据进行格式化.每一个Writer只能有一个Formatter.



.. _zend.log.overview.creating-a-logger:

创建Log
-----

如要启动日志纪录,实例化一个Writer并把它传递给Log实例:

   .. code-block:: php
      :linenos:

      $logger = new Zend\Log\Log();
      $writer = new Zend\Log_Writer\Stream('php://output');

      $logger->addWriter($writer);


注意Log必须至少有一个Writer.你可以用 *addWriter*\ 方法添加任意数量的Writer.

你也可以直接把Writer传递给Log的构造函数:

   .. code-block:: php
      :linenos:

      $writer = new Zend\Log_Writer\Stream('php://output');
      $logger = new Zend\Log\Log($writer);


现在Log就可以使用了.

.. _zend.log.overview.logging-messages:

日志消息
----

要纪录消息,调用Log实例的 *log()*\ 方法,并向其传递消息和消息等级.

   .. code-block:: php
      :linenos:

      $logger->log('Informational message', Zend\Log\Log::INFO);


*log()*\ 方法的第一个参数是是一个字符串 *message*,第二个参数是一个整数 *priority*.
priortiy必须是一个可以被Log实例识别的消息等级之一.这会在下一节解释.

有快捷的方法可以使用.而不是调用 *log()*\ 方法,你可以调用于消息等级同名的方法:

   .. code-block:: php
      :linenos:

      $logger->log('Informational message', Zend\Log\Log::INFO);
      $logger->info('Informational message');

      $logger->log('Emergency message', Zend\Log\Log::EMERG);
      $logger->emerg('Emergency message');




.. _zend.log.overview.destroying-a-logger:

销毁Log
-----

如果Log对象不再需要,设置包含Log实例的变量为 *null*\ 即可销毁它.
这会在Log对象被销毁前自动地调用每个附加在Log上的Writer的 *shutdown()*\ 方法:

   .. code-block:: php
      :linenos:

      $logger = null;


在此方法中明确的销毁日志是可选的,并且在PHP关闭是自动执行.

.. _zend.log.overview.builtin-priorities:

使用内建的消息等级
---------

*Zend_Log* 类定义了下面的消息等级:

   .. code-block:: php
      :linenos:

      EMERG   = 0;  // Emergency: 系统不可用
      ALERT   = 1;  // Alert: 报警
      CRIT    = 2;  // Critical: 紧要
      ERR     = 3;  // Error: 错误
      WARN    = 4;  // Warning: 警告
      NOTICE  = 5;  // Notice: 通知
      INFO    = 6;  // Informational: 一般信息
      DEBUG   = 7;  // Debug: 小时消息

这些属性总是可用的.同样还可以使用其对应的快捷方法.

消息等级不是任意的,它们来自BSD的 *syslog*\ 协议,它们在 `RFC-3164`_
RFC文档中有阐述.名字和对应的消息等级号于其他PHP日志系统是兼容的, 例如 `PEAR Log`_,
它也许能够和 *Zend_Log*\ 进行互操作.

消息等级号以重要性顺序排序. *EMERG* (0)是最重要的消息等级. *DEBUG* (7)
是内建属性中的次重要的消息等级.你可以定义重要性低于 *DEBUG*\ 的属性.
当在日志消息中选择消息等级时,要知道消息等级的层次并选择合适的消息等级.

.. _zend.log.overview.user-defined-priorities:

添加用户定义的日志等级
-----------

用户定义的消息等级可以在运行时通过Log对象的 *addPriority()*\ 方法添加:

   .. code-block:: php
      :linenos:

      $logger->addPriority('FOO', 8);


上面的代码片断创建了一个新的日志消息等级, *FOO*,它的值为 *8*,
这个新的消息等级可以被用于日志:

   .. code-block:: php
      :linenos:

      $logger->log('Foo message', 8);
      $logger->foo('Foo Message');


新的消息等级不能覆盖已有的.

.. _zend.log.overview.understanding-fields:

理解日志事件
------

当你调用 *log()*\ 方法或它们的快捷方式时,日志事件即被创建.这是一个简单的关联数组,
它描述了传递给Writer的事件.下面的数组键总是在数组中创建: *timestamp*, *message*,
*priority*, and *priorityName*.

*event*\ 数组的创建是完全透明的.但是对于添加上面默认设置中不存在的项, 对 *event*\
数组的了解是必须的.

给每个将来的事件添加新项,用给定的键值调用 *setEventItem()*\ 方法:

   .. code-block:: php
      :linenos:

      $logger->setEventItem('pid', getmypid());


上面的例子设置了一个名为 *pid*\
的新项并设置它为当前进程的PID.一旦一个新的项被设置,
在日志纪录中,它自动对其他所有writer和所有事件数据可用.一个项可以在任何时候再次调用
*setEventItem()* 方法被覆盖.

用 *setEventItem()*\ 设置一个新的事件项将导致新项发送给Logger的所有Writer.但是
这不能保证writer实际地纪录了该项.这是由于writer并不知道该怎么做,除非formatter通告了一个新项.
要了解更多,请查看Formatter.



.. _`RFC-3164`: http://tools.ietf.org/html/rfc3164
.. _`PEAR Log`: http://pear.php.net/package/log
