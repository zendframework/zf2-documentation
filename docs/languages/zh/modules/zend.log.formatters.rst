.. _zend.log.formatters:

Formatters
==========

Formatter是一个负责取得一个描述日志事件的 *event*\
数组并输出一个格式化的日志行的对象.

有些Writer不是面向行的并且不能使用Formatter.一个例子是数据库Writer,它向数据库中直接插入一个事件项.
对于这样的Writer不支持Formatter,如果你对这样的Writer设置一个Formatter将抛出一个异常.

.. _zend.log.formatters.simple:

简单格式化
-----

*Zend_Log_Formatter_Simple* 是默认的.当未指定任何formatter时使用.
默认的配置等同于下面的配置:

   .. code-block:: php
      :linenos:

      <?php
      $format = '%timestamp% %priorityName% (%priority%): %message%' . PHP_EOL;
      $formatter = new Zend_Log_Formatter_Simple($format);



使用Writer的 *steFormatter()*\ 方法在个别的Writer上设置Formatter:

   .. code-block:: php
      :linenos:

      <?php
      $writer = new Zend_Log_Writer_Stream('php://output');
      $formatter = new Zend_Log_Formatter_Simple('hello %message%' . PHP_EOL);
      $writer->setFormatter($formatter);

      $logger = new Zend_Log();
      $logger->addWriter($writer);

      $logger->info('there');

      // outputs "hello there"



*Zend_Log_Formatter_Simple*\ 的构造函数接受单个参数:
格式化字符串.该字符串包含有单个百分号包裹的键(例如, *%message%*).
格式化字符串可以包含来自于任何事件数据数组的键。在 *Zend_Log_Formatter_Simple* 里使用
DEFAULT_FORMAT 常量，可以获取缺省键。

.. _zend.log.formatters.xml:

格式化到XML
-------

*Zend_Log_Formatter_Xml*\ 格式化日志数据到XML字符串中.
默认,它自动地纪录在事件数据数组中的所有项.

   .. code-block:: php
      :linenos:

      <?php
      $writer = new Zend_Log_Writer_Stream('php://output');
      $formatter = new Zend_Log_Formatter_Xml();
      $writer->setFormatter($formatter);

      $logger = new Zend_Log();
      $logger->addWriter($writer);

      $logger->info('informational message');



上面的代码输出下面的XML(为清晰添加了空格):

   .. code-block:: php
      :linenos:

      <logEntry>
        <timestamp>2007-04-06T07:24:37-07:00</timestamp>
        <message>informational message</message>
        <priority>6</priority>
        <priorityName>INFO</priorityName>
      </logEntry>



可以定制根元素并指定一个到事件数据数组的XML元素映射. *Zend_Log_Formatter_Xml*\
的构造函数接受一个根元素名字
的字符串作为第一个参数和一个元素映射的关联数组作为第二个参数:

   .. code-block:: php
      :linenos:

      <?php
      $writer = new Zend_Log_Writer_Stream('php://output');
      $formatter = new Zend_Log_Formatter_Xml('log', array('msg' => 'message', 'level' => 'priorityName'));
      $writer->setFormatter($formatter);

      $logger = new Zend_Log();
      $logger->addWriter($writer);

      $logger->info('informational message');

上面的代码改变默认的根元素 *logEntry*\ 为 *log*. 还可以映射元素 *msg*\ 到事件数据项
*message*,下面是输出结果:

   .. code-block:: php
      :linenos:

      <log>
        <msg>informational message</msg>
        <level>INFO</level>
      </log>




