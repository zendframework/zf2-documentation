.. EN-Revision: none
.. _zend.session.advanced_usage:

高级用法
====

虽然在基本用法中讲到的利用Zend框架的会话管理的方法是完全可以接受的，但还有些最佳实践需要去考虑。这一节讨论会话处理和示例Zend_Session架构的更高级用法的精彩细节。

.. _zend.session.advanced_usage.starting_a_session:

开启会话
----

如何你希望所有的请求都有个由Zend_Seesion管理的会话，那么请在程序的引导文件中开启它：

.. _zend.session.advanced_usage.starting_a_session.example:

.. rubric:: 开启全局会话

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Session.php';

   Zend\Session\Session::start();

在程序的引导文件中开启会话，可以避免引发会话开启之前已经有HTTP头发向用户浏览器的异常，那样可能会破坏web页面的美观。许多高级的特性需要先执行
*Zend\Session\Session::start()*\ （更多高级的特性之后会展开）。

使用Zend_Session组件，有4种开启会话的方法，其中2种是错误的。

. 错误的：不要开启PHP的 `session.auto_startsetting`_\ 。如果你使用mode_php(或等同）并在
  *php.ini*\ 中已经开启了该选项，而你又没有权限去关闭该选项，你可以在 *.htaccess*\
  文件（这个文件通常在HTML文档根目录下）中增加下面这一句：

     .. code-block::
        :linenos:
        php_value session.auto_start 0



. 错误的：不要直接使用PHP的 `session_start()`_\ 函数。如果你直接使用 *session_start()*\
  ，之后再使用 *Zend\Session\Namespace*\ ，那么 *Zend\Session\Session::start()*\
  会抛出（"会话已经开始"）的异常。如果你在使用 *Zend\Session\Namespace*\ 或使用
  *Zend\Session\Session::start()*\ 后调用 *session_start()*\ ，那么会产生一个 *E_NOTICE*\
  级别的错误，且该调用将会被忽略。

. 正确的：使用 *Zend\Session\Session::start()*\
  开启会话。如果你想让每个页面请求都开启会话，那么应该在ZF应用程序的引导文件（index.php）中尽早的调用这个函数。开启会话有些额外的开销，如果只有部分页面请求需要开启会话，那么就：

  - 在引导文件中，使用 *Zend\Session\Session::setOptions()*\ 无条件地设置 *strict*\ 选项为 *true*\ 。

  - 在任何 *Zend\Session\Namespace()*\ 对象初始化之前对需要使用会话的请求只调用
    *Zend\Session\Session::start()*\ 。

  - 象往常一样，在需要会话的地方，使用"*new
    Zend\Session\Namespace()*"，但必须确认先前已经调用过 *Zend\Session\Session::start()*\ 了。

  *strict* 选项防止 *new Zend\Session\Namespace()* 自动调用 *Zend\Session\Session::start()*\ 。
  这样，这个选项有利于应用程序的开发者强制执行一个设计原则以避免在某些页面请求中使用会话，
  因为在调用 *Zend\Session\Session::start()* 之前，实例化 *Zend\Session\Namespace*
  时，会抛出一个异常。开发者需小心地考虑使用 *Zend\Session\Session::setOptions()*
  所引起的冲突，由于它们对应于基本的ext/session这些具有全局作用选项。

. 正确的：只要有需要使用会话的地方，就初始化 *new Zend\Session\Namespace()*\
  ，并且基本的PHP会话将自动开启。这个极端简单的用法能在大多数的情形下很好地工作。然而，如果你使用地是默认的基于cookie的会话（强烈推荐使用这种方式），你必须确保在第一次调用
  *new Zend\Session\Namespace()*\ 在任何PHP发向向客户端输出（例如， `HTTP headers`_\ ） **之前**\
  。参见 :ref:` <zend.session.global_session_management.headers_sent>` 有更多的信息。

.. _zend.session.advanced_usage.locking:

锁住会话命名空间
--------

会话的命名空间可以加锁，以防止意外的变更该命名空间下的会话变量值。使用 *lock()*\
方法使某命名空间下会话变量为只读， *unlock()*\ 方法使一个只读的名空间为可读写，
*isLocked()*\
方法测试某命名空间是否已经被加锁。加锁是短暂的，且只在此页面请求内有效，不会持续到下一个页面请求。给命名空间加锁不会影响到存储在该命名空间下对象的setter方法，但是阻止了命名空间的setter方法的移除或替换对象。也就是说，虽给
*Zend\Session\Namespace*\
的实例加了锁，但还是不能阻止它处同样引用了命名空间下数据的对它的变更（参见
`PHP references`_)。

.. _zend.session.advanced_usage.locking.example.basic:

.. rubric:: 锁住会话命名空间

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Session/Namespace.php';

   $userProfileNamespace = new Zend\Session\Namespace('userProfileNamespace');

   // 标记会话设置为只读锁定
   $userProfileNamespace->lock();

   // 解锁只读锁定
   if ($userProfileNamespace->isLocked()) {
   $userProfileNamespace->unLock();
   }

.. _zend.session.advanced_usage.expiration:

命名空间过期
------

对于命名空间和在命名空间中的独立键，它们的寿命都是有限的。在授权后，普通用例包括在请求之间传递临时信息，和通过除去访问潜在的敏感信息来降低一定的安全风险的暴露时有发生。过期可以基于消逝的秒数或者跳步(hop)的个数，对每次初始化命名空间的成功请求，跳步至少发生一次。

.. _zend.session.advanced_usage.expiration.example:

.. rubric:: 过期的例子

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Session/Namespace.php';

   $s = new Zend\Session\Namespace('expireAll');
   $s->a = 'apple';
   $s->p = 'pear';
   $s->o = 'orange';

   $s->setExpirationSeconds(5, 'a'); // expire only the key "a" in 5 seconds

   // 5 次访问后，会话过期
   $s->setExpirationHops(5);

   $s->setExpirationSeconds(60);
   // 命名空间 "expireAll" 将在第一次访问后 60 秒，或者访问 5 次后过期。

在处理在当前请求中会话数据过期，需要小心来提取它们（会话数据）。尽管数据通过引用返回，修改数据将不使过期数据持续传递当前请求。为了“重置”过期时间，把数据放到临时变量，用命名空间来unset它们，然后再设置合适的键。

.. _zend.session.advanced_usage.controllers:

会话封装和控制器
--------

命名空间可以被用来分离控制器对会话的访问，以免被污染。例如，
一个认证控制器可以为会议安全请求保持它的会话状态数据与其他控制器分离。

.. _zend.session.advanced_usage.controllers.example:

.. rubric:: 带有生命期的控制器命名空间会话

下面的代码，作为显示一个测试问题的控制器的一部分，初始化一个布尔变量来表示是否一个提交的答案应该被接受。在此例中，给用户300秒时间来回答所显示的问题。

.. code-block::
   :linenos:
   <?php
   // ...
   // in the question view controller
   require_once 'Zend/Session/Namespace.php';
   $testSpace = new Zend\Session\Namespace('testSpace');
   $testSpace->setExpirationSeconds(300, 'accept_answer'); // expire only this variable
   $testSpace->accept_answer = true;
   //...

下面，处理测试问题答案的控制器根据用户是否在允许的时间内提交答案来决定是否接受答案：

.. code-block::
   :linenos:
   <?php
   // ...
   // in the answer processing controller
   require_once 'Zend/Session/Namespace.php';
   $testSpace = new Zend\Session\Namespace('testSpace');
   if ($testSpace->accept_answer === true) {
       // within time
   }
   else {
       // not within time
   }
   // ...

.. _zend.session.advanced_usage.single_instance:

防止每个命名空间有多重实例
-------------

尽管 :ref:`session locking <zend.session.advanced_usage.locking>`\
提供了很好的保护来防止意外的命名空间的会话数据的使用， *Zend\Session\Namespace*
也有能力防止给一个单个的命名空间创建多个实例。

为开启这个动作，当创建 *Zend\Session\Namespace*\ 的最后允许的实例，传递 *true*\
给第二个构造函数参数。任何后来的初始化同一个命名空间的企图都会导致一个异常的抛出。

.. _zend.session.advanced_usage.single_instance.example:

.. rubric:: 限制命名空间访问单一实例

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Session/Namespace.php';

   // create an instance of a namespace
   $authSpaceAccessor1 = new Zend\Session\Namespace('Zend_Auth');

   // create another instance of the same namespace, but disallow any new instances
   $authSpaceAccessor2 = new Zend\Session\Namespace('Zend_Auth', true);

   // making a reference is still possible
   $authSpaceAccessor3 = $authSpaceAccessor2;

   $authSpaceAccessor1->foo = 'bar';

   assert($authSpaceAccessor2->foo, 'bar');

   try {
       $aNamespaceObject = new Zend\Session\Namespace('Zend_Auth');
   } catch (Zend\Session\Exception $e) {
       echo "Cannot instantiate this namespace since \$authSpaceAccessor2 was created\n";
   }

上面构造函数的第二个参数告诉 *Zend\Session\Namespace*\
任何之后带有"*Zend_Auth*"实例的命名空间都是不允许的。企图创建这样的实例导致构造函数抛出一个异常。如果在相同的请求期间稍后需要访问会话的命名空间，开发者因此有责任在其它地方给一个实例对象（在上面的例子中
*$authSpaceAccessor1*\ ， *$authSpaceAccessor2* 或者 *$authSpaceAccessor3*\
）存储一个引用。例如，开发者可以存储引用到一个静态变量，添加一个引用给一个
`registry`_ （参见 :ref:` <zend.registry>`\
），或者使它对其它需要访问会话命名空间的方法可用。

.. _zend.session.advanced_usage.arrays:

使用数组
----

在PHP 5.2.1
版本之前，因为PHP魔术方法实现的历史，修改在命名空间里的数组是不可以的。如果你只使用PHP
5.2.1 或以后的版本，那么你可以 :ref:`跳到下一章节 <zend.session.advanced_usage.objects>`\ 。

.. _zend.session.advanced_usage.arrays.example.modifying:

.. rubric:: 修改带有会话命名空间的数组数据

下面来示例问题如何被复制：

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Session/Namespace.php';
   $sessionNamespace = new Zend\Session\Namespace();
   $sessionNamespace->array = array();
   $sessionNamespace->array['testKey'] = 1; // may not work as expected before PHP 5.2.1
   echo $sessionNamespace->array['testKey'];

.. _zend.session.advanced_usage.arrays.example.building_prior:

.. rubric:: 在会话存储之前构造数组

如果可能，通过只在所有期望的数组值被设置后存储数组到一个会话命名空间来完全避免问题的发生。

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Session/Namespace.php';
   $sessionNamespace = new Zend\Session\Namespace('Foo');
   $sessionNamespace->array = array('a', 'b', 'c');

如果你正使用有影响的PHP版本并需要在分配给一个会话命名空间的键之后修改数组，你可以用下面的其中之一或者全部的方案。

.. _zend.session.advanced_usage.arrays.example.workaround.reassign:

.. rubric:: 方案：重新分配一个被修改的数组

在下面的代码中，创建、修改了一个被存储的数组的拷贝，并且重新从被创建的拷贝分配位置、重写原数组。

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Session/Namespace.php';
   $sessionNamespace = new Zend\Session\Namespace();

   // assign the initial array
   $sessionNamespace->array = array('tree' => 'apple');

   // make a copy of the array
   $tmp = $sessionNamespace->array;

   // modfiy the array copy
   $tmp['fruit'] = 'peach';

   // assign a copy of the array back to the session namespace
   $sessionNamespace->array = $tmp;

   echo $sessionNamespace->array['fruit']; // prints "peach"

.. _zend.session.advanced_usage.arrays.example.workaround.reference:

.. rubric:: 方案：存储包括引用的数组

作为选择，存储一个包含引用的数组到期望的数组，然后直接访问它。

.. code-block::
   :linenos:
   <?php
   require_once 'Zend/Session/Namespace.php';
   $myNamespace = new Zend\Session\Namespace('myNamespace');
   $a = array(1, 2, 3);
   $myNamespace->someArray = array( &$a );
   $a['foo'] = 'bar';
   echo $myNamespace->someArray['foo']; // prints "bar"

.. _zend.session.advanced_usage.objects:

在对象中使用会话
--------

如果你计划在PHP会话中持久对象，要知道它们将为存储被 `系列化`_\
。这样，任何在PHP会话中持久的对象在取出时一定会从存储中被去系列化。这意味着开发者必须确保持久对象的类必须在对象从会话存储中被去系列化之前被定义。如果一个非系列化的对象的类没有被定义，那么它就变成一个
*stdClass*\ 的实例。

.. _zend.session.advanced_usage.testing:

在单元测试中使用会话
----------

Zend
Framework利用PHPUnit来促进自身代码的测试。大多数开发者在他们的应用程序中，扩展已有的一组单元测试，以覆盖测试他们的代码。在运行单元测试时，如果在结束会话之后使用了写相关的方法，那么会抛出"**当前Zend_Session被标记为只读**"的异常。在单元测试中使用Zend_Session需要额外的注意，因为在关闭会话(*Zend\Session\Session::writeClose()*)，或者摧毁一个会话(*Zend\Session\Session::destroy()*)之后，不允许再设置或注销任何一个
*Zend\Session\Namespace*\ 的实例的键名了。 这样是由底层PHP的会话机制 *session_destroy()*\ 和
*session_write_close()*\
所直接引起的，因为它未提供“撤销”机制以便单元测试setup/teardown。

围绕这一工作，参见 *tests/Zend/Session* 中 *SessionTest.php*\ 和 *SessionTestHelper.php*\
的单元测试 *testSetExpirationSeconds()*\ ，利用了PHP的 *exec()*\
发起一个独立的过程。新的过程准确地模拟了一个来自浏览器的继上次之后的第二个请求。独立请求始于一个“干净”的会话，就像为任一请求执行PHP脚本。同时，要使$_SESSION[]在子过程中可更改，那么需要在父过程执行
*exec()*\ 之前关闭会话。

.. _zend.session.advanced_usage.testing.example:

.. rubric:: PHPUnit Testing Code Dependent on Zend_Session

.. code-block::
   :linenos:
   <?php
   // testing setExpirationSeconds()
   require_once 'tests/Zend/Session/SessionTestHelper.php'; // also see SessionTest.php
   $script = 'SessionTestHelper.php';
   $s = new Zend\Session\Namespace('space');
   $s->a = 'apple';
   $s->o = 'orange';
   $s->setExpirationSeconds(5);

   Zend\Session\Session::regenerateId();
   $id = Zend\Session\Session::getId();
   session_write_close(); // release session so process below can use it
   sleep(4); // not long enough for things to expire
   exec($script . "expireAll $id expireAll", $result);
   $result = $this->sortResult($result);
   $expect = ';a === apple;o === orange;p === pear';
   $this->assertTrue($result === $expect,
       "iteration over default Zend_Session namespace failed; expecting result === '$expect', but got '$result'");

   sleep(2); // long enough for things to expire (total of 6 seconds waiting, but expires in 5)
   exec($script . "expireAll $id expireAll", $result);
   $result = array_pop($result);
   $this->assertTrue($result === '',
       "iteration over default Zend_Session namespace failed; expecting result === '', but got '$result')");
   session_start(); // resume artificially suspended session

   // We could split this into a separate test, but actually, if anything leftover from above
   // contaminates the tests below, that is also a bug that we want to know about.
   $s = new Zend\Session\Namespace('expireGuava');
   $s->setExpirationSeconds(5, 'g'); // now try to expire only 1 of the keys in the namespace
   $s->g = 'guava';
   $s->p = 'peach';
   $s->p = 'plum';

   session_write_close(); // release session so process below can use it
   sleep(6); // not long enough for things to expire
   exec($script . "expireAll $id expireGuava", $result);
   $result = $this->sortResult($result);
   session_start(); // resume artificially suspended session
   $this->assertTrue($result === ';p === plum',
       "iteration over named Zend_Session namespace failed (result=$result)");



.. _`session.auto_startsetting`: http://www.php.net/manual/en/ref.session.php#ini.session.auto-start
.. _`session_start()`: http://www.php.net/session_start
.. _`HTTP headers`: http://www.php.net/headers_sent
.. _`PHP references`: http://www.php.net/references
.. _`registry`: http://www.martinfowler.com/eaaCatalog/registry.html
.. _`系列化`: http://www.php.net/manual/en/language.oop.serialization.php
