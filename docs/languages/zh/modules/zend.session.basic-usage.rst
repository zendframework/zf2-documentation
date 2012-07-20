.. _zend.session.basic_usage:

基本用法
====

在Zend Framework中， *Zend_Session_Namespace*\
实例提供了操作会话数据主要的API。命名空间常用于隔离所有的会话数据，尽管也为所有会话数据只需要一个命名空间的情况提供了一个默认的命名空间。Zend_Session利用了PHP内置的会话模块（ext/session），以及它特有的
*$_SESSION*\ 全局数组做为会话状态数据的存储机制。虽然 *$_SESSION*\
在PHP的全局命名空间内仍然可以访问，但是开发者不应该直接访问它，这样 *Zend_Session*
和 *Zend_Session_Namespace*\ 可以提供一组最可靠、安全的处理会话相关的功能。

每个 *Zend_Session_Namespace*\ 的实例对应于 *$_SESSION*\
全局数组的一个条目，在那里命名空间被用作键。

   .. code-block::
      :linenos:
      <?php
      require_once 'Zend/Session/Namespace.php';

      $myNamespace = new Zend_Session_Namespace('myNamespace');

      // $myNamespace corresponds to $_SESSION['myNamespace']

用Zend_Session直接和其它使用 *$_SESSION*\
的代码协同工作是可能的。然而，为避免问题，强烈建议这样的代码只使用 *$_SESSION*\
中不和 *Zend_Session_Namespace*\ 的实例想对应的部分。

.. _zend.session.basic_usage.basic_examples:

实例教程
----

在初始化Zend_Session时，如果没有指定命名空间，所有的数据将被透明地储存在 *'Default'*\
命名空间下。 *Zend_Session*\
不打算直接处理会话命名空间容器的内容，取而代之，我们可以使用
*Zend_Session_Namespace*\
。下面的例子演示了缺省命名空间的使用，和怎样计算用户访问页面的次数：

.. _zend.session.basic_usage.basic_examples.example.counting_page_views:

.. rubric:: 页面浏览计数

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Session/Namespace.php';

   $defaultNamespace = new Zend_Session_Namespace('Default');

   if (isset($defaultNamespace->numberOfPageRequests)) {
       $defaultNamespace->numberOfPageRequests++; // 每次页面加载，这个将递增
   } else {
       $defaultNamespace->numberOfPageRequests = 1; // 第一次
   }

   echo "Page requests this session: ", $defaultNamespace->numberOfPageRequests;

当多个模块使用 *Zend_Session_Namespace*\
的实例拥有不同的命名空间，每个模块为它自己的会话数据获得数据封装。可以传递给
*Zend_Session_Namespace*\ 构造函数一个可选的 *$namespace*\
参数，它允许开发者分割会话数据到分离的命名空间。命名空间机制提供了一个有效的、流行的方法来确保处于命名空间之下的会话数据不遭到意外地改变。

命名空间的名称被限定为字符序列，它表示为不以下划线("*_*")开头的非空PHP字符串。只有Zend
Framework的核心模块可使用以"*Zend*"开头的命名空间的名称。

.. _zend.session.basic_usage.basic_examples.example.namespaces.new:

.. rubric:: 新方法： 使用命名空间避免冲突

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Session/Namespace.php';

   // in the Zend_Auth component
   $authNamespace = new Zend_Session_Namespace('Zend_Auth');
   $authNamespace->user = "myusername";

   // in a web services component
   $webServiceNamespace = new Zend_Session_Namespace('Some_Web_Service');
   $webServiceNamespace->user = "mywebusername";

上述例子中的代码与下面的代码有相同的效果，不过，上述例子中的会话对象把会话数据封装进了各自的命名空间。

.. _zend.session.basic_usage.basic_examples.example.namespaces.old:

.. rubric:: 老方法: PHP会话访问

.. code-block::
   :linenos:
   <?php
   $_SESSION['Zend_Auth']['user'] = "myusername";
   $_SESSION['Some_Web_Service']['user'] = "mywebusername";

.. _zend.session.basic_usage.iteration:

迭代会话命名空间
--------

*Zend_Session_Namespace*\ 提供了 `IteratorAggregate接口`_\ 所有的能力，包括对 *foreach*\
语句的支持：

.. _zend.session.basic_usage.iteration.example:

.. rubric:: 会话迭代

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Session/Namespace.php';

   $aNamespace = new Zend_Session_Namespace('some_namespace_with_data_present');

   foreach ($aNamespace as $index => $value) {
       echo "aNamespace->$index = '$value';\n";
   }

.. _zend.session.basic_usage.accessors:

会话命名空间的访问器
----------

*Zend_Session_Namespace*\ 实现 *__get()*, *__set()*, *__isset()*, and *__unset()*\ 这些 `魔术方法`_\
，除了在一个子类里，这些魔术方法不能被直接调用。相反，正常的操作符自动调用这些方法，如下例所示：

.. _zend.session.basic_usage.accessors.example:

.. rubric:: 访问会话数据

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Session/Namespace.php';

   $namespace = new Zend_Session_Namespace(); // 缺省的命名空间

   $namespace->foo = 100;

   echo "\$namespace->foo = $namespace->foo\n";

   if (!isset($namespace->bar)) {
       echo "\$namespace->bar not set\n";
   }

   unset($namespace->foo);



.. _`IteratorAggregate接口`: http://www.php.net/~helly/php/ext/spl/interfaceIteratorAggregate.html
.. _`魔术方法`: http://www.php.net/manual/en/language.oop5.overloading.php
