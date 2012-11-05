.. EN-Revision: none
.. _zend.xmlrpc.server:

Zend\XmlRpc\Server
==================

.. _zend.xmlrpc.server.introduction:

介绍
--

Zend\XmlRpc\Server 依照 `www.xmlrpc.com 上的规格描述`_ 实现了一个全功能 XML-RPC
服务器。同时，它还实现了允许批量传输（boxcarring）的 system.multicall() 方法。

.. _zend.xmlrpc.server.usage:

基本使用
----

最基本的使用实例：

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/XmlRpc/Server.php';
   require_once 'My/Service/Class.php';

   $server = new Zend\XmlRpc\Server();
   $server->setClass('My_Service_Class');
   echo $server->handle();

.. _zend.xmlrpc.server.structure:

服务器结构
-----

Zend\XmlRpc\Server
是由各种不同组件组成，包括服务器自身用于接收请求或进行相应的组件，
以及错误对象。

为了启动 Zend\XmlRpc\Server，开发人员必须通过 *setClass()* 和 *addFunction()*
方法附加一个或者多个类或函数到服务器。

完成附加操作后，则可以向 *Zend\XmlRpc\Server::handle()* 传递 *Zend\XmlRpc\Request*
对象，如果没有提供它将实例化一个 *Zend\XmlRpc_Request\Http* 对象用于从 *php://input*
获取请求。

这时 *Zend\XmlRpc\Server::handle()* 将基于请求尝试调度合适的处理程序。 它将返回基于
*Zend\XmlRpc\Response* 的对象或者 *Zend\XmlRpc_Server\Fault* 对象。这些对象都有 *__toString()*
用来创建合法的，允许直接返回的 XML-RPC 的 XML 响应文本。

.. _zend.xmlrpc.server.conventions:

转换
--

Zend\XmlRpc\Server 允许开发人员附加函数和类方法作为 XML-RPC 方法来调度。通过
Zend\Server\Reflection 自省所有附加的方法，使用函数和方法的文档部分(docblocks)
决定方法的帮助文档和方法标识。

XML-RPC 类型不可能与 PHP 类型一一对应。然而程序仍然利用 @param 和 @return
的值列表尽可能的猜测最合适的类型。一些 XML-RPC 类型没有合适的 PHP 中的匹配，
所以应当在 phpdoc 中对 XML-RPC 类型给予提示。这些包括：

- dateTime.iso8601，字符串格式 YYYYMMDDTHH:mm:ss

- base64, base64 编码数据

- struct, 结构匹配的数组

下面的例子演示了如何增加这样的提示：

.. code-block::
   :linenos:
   <?php
   /**
   * 这是一个演示函数
   *
   * @param base64 $val1 Base64-encoded data
   * @param dateTime.iso8601 $val2 An ISO date
   * @param struct $val3 An associative array
   * @return struct
   */
   function myFunc($val1, $val2, $val3)
   {
   }

PhpDocumentor 不会验证参数和返回值的类型，所以这对 API 文档没有任何影响。
而且当服务器验证调用方法所提供的参数时，就必须提供提示。

最有效的办法是未参数和返回值指定多个类型；XML-RPC 文档甚至建议 system.methodSignature
应当返回一个数组，含有所有可能的方法标识（例如，参数和返回值的所有可能的组合）。
你可以像通常那样在 PhpDocumentor 中使用“|”符号做到这点：

.. code-block::
   :linenos:
   <?php
   /**
   * 这是一个演示函数
   *
   * @param string|base64 $val1 String or base64-encoded data
   * @param string|dateTime.iso8601 $val2 String or an ISO date
   * @param array|struct $val3 Normal indexed array or an associative array
   * @return boolean|struct
   */
   function myFunc($val1, $val2, $val3)
   {
   }

需要注意的是，允许多个标识可能干扰使用服务的开发人员；一般来说，一个 XML-RPC
方法只应该有一个标识。

.. _zend.xmlrpc.server.namespaces:

使用命名空间
------

XML-RPC 有名字空间的概念；通常，它允许使用“.”分割 XML-RPC 方法到各个命名空间。
这有助于防止不同类提供的不同服务方法之间的命名冲突。例如，XML-RPC
服务在命名空间“system”中保留了一些方法：

- system.listMethods

- system.methodHelp

- system.methodSignature

从内部来讲，这些方法映射到 Zend\XmlRpc\Server 的同名方法上。

如果想要为服务方法增加命名空间，只要在附加一个函数或类时，添加命名空间到适当的方法上：

.. code-block::
   :linenos:
   <?php
   // My_Service_Class 类的公共方法将被映射为 myservice.METHODNAME
   $server->setClass('My_Service_Class', 'myservice');

   // 函数“somefunc”将被映射为 funcs.somefunc
   $server->addFunction('somefunc', 'funcs');

.. _zend.xmlrpc.server.request:

自定义请求对象
-------

多数情况下，只需要使用 Zend\XmlRpc\Server 默认提供的请求类型
Zend\XmlRpc_Request\Http。然而，仍然有可能在 CLI、GUI 或者其他环境使用
XML-RPC，亦或需要记录每个请求。需要从 Zend\XmlRpc\Request
继承，创建自定义的对象来完成这个工作。最重要的是记得确保实现 getMethod() 和
getParams() 方法，这样 XML-RPC 服务器就可以获取必要的信息进行调度。

.. _zend.xmlrpc.server.response:

自定义响应对象
-------

和请求对象一样，Zend\XmlRpc\Server 可以返回自定义响应对象；默认情况下，
Zend\XmlRpc_Response\Http 对象被返回，这个对象包含一个合适的用于 XML-RPC 的 HTTP Content-Type
头。使用自定义对象的情况可能是需要记录响应，或需要发送响应到 STDOUT。

在调用 handle() 之前使用 Zend\XmlRpc\Server::setResponseClass() 指定自定义的响应类。

.. _zend.xmlrpc.server.fault:

处理错误产生的异常
---------

Zend\XmlRpc\Server 会捕获调度方法产生的一场，同时生成 XML-RPC 失败响应。
然而，默认情况下，异常消息和代码不出现在失败响应中。有意设计成如此形式主要是为了保护代码；
许多异常会暴露超出预期的大量关于代码和开发环境的信息（常见的例子如数据库抽象层或访问层一场）。

异常类也可以加入白名单中作为失败响应。要做到这点，只需使用
Zend\XmlRpc_Server\Fault::attachFaultException() 添加一个异常类到白名单即可：

.. code-block::
   :linenos:
   <?php
   Zend\XmlRpc_Server\Fault::attachFaultException('My_Project_Exception');

如果你使用的是一个继承于其他项目的异常，可以一次将整个类树加入白名单。
Zend\XmlRpc_Server\Exceptions
总是在白名单中，用于报告指定的内部错误（如未定义的方法等）。

一个未在白名单中指定的异常将会返回错误代码“404”，错误消息“Unknown
error”（未知错误）。

.. _zend.xmlrpc.server.caching:

在请求之间缓存服务器定义
------------

附加多个类到 XML-RPC 服务器实例可能消耗大量的资源；每一个类必须使用反射 API
进行自省（通过
Zend\Server\Reflection），生成一个包含有所有可用方法的列表用于服务器调用。

为了减少这种性能污点，可以使用 Zend\XmlRpc_Server\Cache 来缓存请求之间的服务器定义。
联合 \__autoload() 使用，可以极大的提高性能。

实例如下：

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Loader.php';
   require_once 'Zend/XmlRpc/Server.php';
   require_once 'Zend/XmlRpc/Server/Cache.php';

   function __autoload($class)
   {
       Zend\Loader\Loader::loadClass($class);
   }

   $cacheFile = dirname(__FILE__) . '/xmlrpc.cache';
   $server = new Zend\XmlRpc\Server();

   if (!Zend\XmlRpc_Server\Cache::get($cacheFile, $server)) {
       require_once 'My/Services/Glue.php';
       require_once 'My/Services/Paste.php';
       require_once 'My/Services/Tape.php';

       $server->setClass('My_Services_Glue', 'glue');   // glue. namespace
       $server->setClass('My_Services_Paste', 'paste'); // paste. namespace
       $server->setClass('My_Services_Tape', 'tape');   // tape. namespace

       Zend\XmlRpc_Server\Cache::save($cacheFile, $server);
   }

   echo $server->handle();

上面的例子尝试从当前脚本所在目录下的 xmlrpc.cache 文件获取服务器定义。
如果失败的话就加载需要的服务类，附加他们到服务器实例，并尝试使用服务器定义创建新的缓存文件。

.. _zend.xmlrpc.server.use:

使用实例
----

下面有一些有用的例子，向开发人员展示了可能用到的各种情况。
每一个实例都是建立在前一个实例基础上的扩充。

.. _zend.xmlrpc.server.use.case1:

基本使用
^^^^

下面的例子演示了附加一个函数作为 XML-RPC 的调度方法，并用其处理请求。

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/XmlRpc/Server.php';

   /**
    * 返回 MD5 值
    *
    * @param string $value Value to md5sum
    * @return string MD5 sum of value
    */
   function md5Value($value)
   {
       return md5($value);
   }

   $server = new Zend\XmlRpc\Server();
   $server->addFunction('md5Value');
   echo $server->handle();

.. _zend.xmlrpc.server.use.case2:

附加一个类
^^^^^

下面的例子演示了附加一个类的公共方法作为 XML-RPC 的调度方法。

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/XmlRpc/Server.php';
   require_once 'Services/Comb.php';

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services_Comb');
   echo $server->handle();

.. _zend.xmlrpc.server.use.case3:

利用命名空间附加多个类
^^^^^^^^^^^

下面的例子演示了附加多个类，每个类都有自己的命名空间。

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/XmlRpc/Server.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services_Comb', 'comb');   // methods called as comb.*
   $server->setClass('Services_Brush', 'brush'); // methods called as brush.*
   $server->setClass('Services_Pick', 'pick');   // methods called as pick.*
   echo $server->handle();

.. _zend.xmlrpc.server.use.case4:

指定异常作为合法的失败响应
^^^^^^^^^^^^^

下面的例子允许任何 Services_Exception 的派生类作为失败响应返回其代码和消息。

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/XmlRpc/Server.php';
   require_once 'Zend/XmlRpc/Server/Fault.php';
   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // 允许 Services_Exceptions 作为响应失败输出
   Zend\XmlRpc_Server\Fault::attachFaultException('Services_Exception');

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services_Comb', 'comb');   // methods called as comb.*
   $server->setClass('Services_Brush', 'brush'); // methods called as brush.*
   $server->setClass('Services_Pick', 'pick');   // methods called as pick.*
   echo $server->handle();

.. _zend.xmlrpc.server.use.case5:

设置自定义请求对象
^^^^^^^^^

下面的例子演示了实例化自定义请求对象并将其传递到服务器进行处理。

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/XmlRpc/Server.php';
   require_once 'Zend/XmlRpc/Server/Fault.php';
   require_once 'Services/Request.php';
   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // 允许 Services_Exceptions 作为响应失败输出
   Zend\XmlRpc_Server\Fault::attachFaultException('Services_Exception');

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services_Comb', 'comb');   // methods called as comb.*
   $server->setClass('Services_Brush', 'brush'); // methods called as brush.*
   $server->setClass('Services_Pick', 'pick');   // methods called as pick.*

   // 创建请求对象
   $request = new Services_Request();

   echo $server->handle($request);

.. _zend.xmlrpc.server.use.case6:

设置自定义响应对象
^^^^^^^^^

下面的例子演示了指定自定义类作为响应返回。

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/XmlRpc/Server.php';
   require_once 'Zend/XmlRpc/Server/Fault.php';
   require_once 'Services/Request.php';
   require_once 'Services/Response.php';
   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // 允许 Services_Exceptions 作为响应失败输出
   Zend\XmlRpc_Server\Fault::attachFaultException('Services_Exception');

   $server = new Zend\XmlRpc\Server();
   $server->setClass('Services_Comb', 'comb');   // methods called as comb.*
   $server->setClass('Services_Brush', 'brush'); // methods called as brush.*
   $server->setClass('Services_Pick', 'pick');   // methods called as pick.*

   // 创建请求对象
   $request = new Services_Request();

   // 设置自定义响应
   $server->setResponseClass('Services_Response');

   echo $server->handle($request);

.. _zend.xmlrpc.server.use.case7:

在请求之间缓存服务器定义
^^^^^^^^^^^^

下面的例子演示了在请求之间缓存服务器定义。

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/XmlRpc/Server.php';
   require_once 'Zend/XmlRpc/Server/Fault.php';
   require_once 'Zend/XmlRpc/Server/Cache.php';
   require_once 'Services/Request.php';
   require_once 'Services/Response.php';
   require_once 'Services/Exception.php';
   require_once 'Services/Comb.php';
   require_once 'Services/Brush.php';
   require_once 'Services/Pick.php';

   // 指定一个缓存文件
   $cacheFile = dirname(__FILE__) . '/xmlrpc.cache';

   // 允许 Services_Exceptions 作为响应失败输出
   Zend\XmlRpc_Server\Fault::attachFaultException('Services_Exception');

   $server = new Zend\XmlRpc\Server();

   // 尝试从缓存中获取服务器定义
   if (!Zend\XmlRpc_Server\Cache::get($cacheFile, $server)) {
       $server->setClass('Services_Comb', 'comb');   // methods called as comb.*
       $server->setClass('Services_Brush', 'brush'); // methods called as brush.*
       $server->setClass('Services_Pick', 'pick');   // methods called as pick.*

       // 保存缓存
       Zend\XmlRpc_Server\Cache::save($cacheFile, $server));
   }

   // 创建请求对象
   $request = new Services_Request();

   // 设置自定义响应
   $server->setResponseClass('Services_Response');

   echo $server->handle($request);



.. _`www.xmlrpc.com 上的规格描述`: http://www.xmlrpc.com/spec
