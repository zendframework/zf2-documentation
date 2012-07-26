.. _zend.log.filters:

过滤器
===

一个Filter对象阻塞一个消息被写入到日志.

.. _zend.log.filters.all-writers:

对所有Writer过滤
-----------

要在所有writer之前过滤消息,你可以使用 *addFilter()*\ 方法添加任意数量的Filter到Log对象:

   .. code-block:: php
      :linenos:

      $logger = new Zend_Log();

      $writer = new Zend_Log_Writer_Stream('php://output');
      $logger->addWriter($writer);

      $filter = new Zend_Log_Filter_Priority(Zend_Log::CRIT);
      $logger->addFilter($filter);

      // blocked
      $logger->info('Informational message');

      // logged
      $logger->emerg('Emergency message');


当你添加一个或多个Filter到Log对象后,消息在任何Writer接收之前必须通过所有的Filter.

.. _zend.log.filters.single-writer:

过滤一个Writer实例
------------

要在一个特定的Writer上进行消息过滤,使用该Writer对象的 *addFilter()*\ 方法:

   .. code-block:: php
      :linenos:

      $logger = new Zend_Log();

      $writer1 = new Zend_Log_Writer_Stream('/path/to/first/logfile');
      $logger->addWriter($writer1);

      $writer2 = new Zend_Log_Writer_Stream('/path/to/second/logfile');
      $logger->addWriter($writer2);

      // add a filter only to writer2
      $filter = new Zend_Log_Filter_Priority(Zend_Log::CRIT);
      $writer2->addFilter($filter);

      // logged to writer1, blocked from writer2
      $logger->info('Informational message');

      // logged by both writers
      $logger->emerg('Emergency message');





