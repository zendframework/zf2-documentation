.. _zend.uri.chapter:

Zend_Uri
========

.. _zend.uri.overview:

概述
--

*Zend_Uri* 是一个辅助于操作和验证 `统一资源标识符`_ (URIs)的组件. *Zend_Uri*
的存在主要是为其他组件服务的,比如
*Zend_Http_Client*,但是作为一个独立的工具也是有用的.

URIs 总是以一个schema(模式,协议)开始,后跟一个冒号(colon). *Zend_Uri*\ 类提供一个工厂,
返回一个它本身的 适应于每种模式(scheme)的 子类,子类被命名为 *Zend_Uri_<scheme>*,
*<scheme>*\ 是首字母大写的模式名称.一个例外是HTTPS,它也是由 *Zend_Uri_Http*\ 处理的.

.. _zend.uri.creation:

新建一个URI
-------

如果仅有一个模式被传递给 *Zend_Uri::factory()*, *Zend_Uri*\ 将从头构造一个新的URI.

.. rubric:: 使用 *Zend_Uri::factory()*\ 创建一个新的URI

.. code-block:: php
   :linenos:

   <?php

   require_once 'Zend/Uri.php';

   // 重新创建一个新的URI,仅传递模式.
   $uri = Zend_Uri::factory('http');

   // $uri instanceof Zend_Uri_Http

   ?>
从头创建一个的新的URI,仅仅需要传递模式给 *Zend_Uri::factory()* [#]_.
如果传递了一个未支持的模式, *Zend_Uri_Exception*\ 异常将被抛出.

如果传递的模式或者URI被支持, *Zend_Uri::factory()*\ 返回一个它本身的
适应于特定模式(scheme)的 子类

.. _zend.uri.manipulation:

操作现有的URI
--------

要操作一个现有的URL,把整个URI传递给 *Zend_Uri::factory()*.

.. rubric:: 使用 *Zend_Uri::factory()*\ 操作一个现有的URI

.. code-block:: php
   :linenos:

   <?php

   require_once 'Zend/Uri.php';

   // 操作一个现有的URI,把他传入到Zend_Uri::factory().
   $uri = Zend_Uri::factory('http://www.zend.com');

   // $uri instanceof Zend_Uri_Http

   ?>
这个URI将被解析并且验证.如果发现它是无效的, *Zend_Uri_Exception*\ 异常立即抛出.否则
*Zend_Uri::factory()* 返回一个它本身的 适应于特定模式(scheme)的 子类

.. _zend.uri.validation:

URI 验证
------

*Zend_Uri::check()* 函数仅在需要验证一个现有的URI时使用.

.. rubric:: 使用 *Zend_Uri::check()*\ 进行URI 验证

.. code-block:: php
   :linenos:

   <?php

   require_once 'Zend/Uri.php';

   // 验证一个给定的URI是否是格式良好的
   $valid = Zend_Uri::check('http://uri.in.question');

   // 对于一个有效的URI,$valid为TRUE,否则为FALSE

   ?>
*Zend_Uri::check()* 返回布尔值,它比使用 *Zend_Uri::factory()*\ 更便捷,并且能够捕获异常.

.. _zend.uri.instance-methods:

公共实例方法
------

每个 *Zend_Uri*\ 子类的实例(如: *Zend_Uri_Http*)有多个 有用的 处理任何类型的
URI的实例方法.

.. _zend.uri.instance-methods.getscheme:

取得URI的Schema
^^^^^^^^^^^^

URI模式是冒号之前的部分.例如 *http://www.zend.com*\ 的模式是 *http*.

.. rubric:: 从 *Zend_Uri_** 对象取得模式

.. code-block:: php
   :linenos:

   <?php

   require_once 'Zend/Uri.php';

   $uri = Zend_Uri::factory('http://www.zend.com');

   $scheme = $uri->getScheme();  // "http"

   ?>
*getScheme()*\ 实例方法仅返回URI对象的模式部分.

.. _zend.uri.instance-methods.geturi:

取得整个URI
^^^^^^^

.. rubric:: 从一个 *Zend_Uri_** 对象取得整个URI

.. code-block:: php
   :linenos:

   <?php

   require_once 'Zend/Uri.php';

   $uri = Zend_Uri::factory('http://www.zend.com');

   echo $uri->getUri();  // "http://www.zend.com"

   ?>
*getUri()*\ 方法返回整个URI的字符串标识.

.. _zend.uri.instance-methods.valid:

验证URI
^^^^^

*Zend_Uri::factory()*\
总是验证传递给它的任何URI,如果给定的URI被认为是无效的,它将不会实例化一个新的
*Zend_Uri* 子类.但是 *Zend_Uri*\ 子类为 一个新URI 或者 一个现有的有效的URL
被实例化后,在操作后 该URI可能会变得无效.

.. rubric:: 验证一个 *Zend_Uri_** 对象

.. code-block:: php
   :linenos:

   <?php

   require_once 'Zend/Uri.php';

   $uri = Zend_Uri::factory('http://www.zend.com');

   $isValid = $uri->valid();  // TRUE

   ?>
*valid()*\ 实例方法检查URI对象是否仍是有效的.



.. _`统一资源标识符`: http://www.w3.org/Addressing/

.. [#] 在撰写本文时,Zend_Uri仅支持HTTP和HTTPS模式.