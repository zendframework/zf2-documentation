.. _zend.permissions.acl.advanced:

高级用法
====

.. _zend.permissions.acl.advanced.storing:

保存 ACL 数据确保持久性
--------------

Zend\Permissions\Acl 就是这样设计的，它不需要为 ACL
数据的存储而要求任何特别的后台技术如数据库或者缓冲服务器。它的完全的 PHP
实现使得在Zend\Permissions\Acl之上构建定制的管理工具相当地容易和灵活。许多情形需要一些 ACL
的交互式维护，并且 Zend\Permissions\Acl 为设定、查询、应用软件的访问控制提供了方法。

因为期望应用案例有多种变化来适应不同的情形，ACL
数据的存储因此留给开发者来完成。因为 Zend\Permissions\Acl 是可序列化的，所以 ACL 的对象可以用
PHP 中的 `serialize()`_
函数来序列化，并且结果可以存在开发者所期望的任何地方，例如文件、数据库、或缓存机构。

.. _zend.permissions.acl.advanced.assertions:

使用声明(Assert)来编写条件性的 ACL 规则
--------------------------

有时候允许或禁止一个 Role 访问一个 Resource
的规则不是绝对的而是依靠不同的标准。例如，只有在 8：00am 和 5:00pm
之间，特定的访问才被允许。另外一个禁止访问的例子是因为一个请求来自于被标记为不良的
IP 地址。Zend\Permissions\Acl 对基于无论开发者有什么需要的条件的规则实现有个内置的支持。

Zend\Permissions\Acl 用 *Zend\Permissions\Acl\Assert\AssertInterface*
提供支持有条件的规则。为了使用规则声明接口，开发者写了一个实现接口中 *assert()*
方法的类。

.. code-block::
   :linenos:

   class CleanIPAssertion implements Zend\Permissions\Acl\Assert\AssertInterface
   {
       public function assert(Zend\Permissions\Acl $acl,
                              Zend\Permissions\Acl\Role\RoleInterface $role = null,
                              Zend\Permissions\Acl\Resource\ResourceInterface $resource = null,
                              $privilege = null)
       {
           return $this->_isCleanIP($_SERVER['REMOTE_ADDR']);
       }

       protected function _isCleanIP($ip)
       {
           // ...
       }
   }}


一旦声明类可用，当分配有条件的规则时，开发者必需提供声明类的一个实例。用声明建立的规则只适用于当声明方法返回
true。

.. code-block::
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();
   $acl->allow(null, null, null, new CleanIPAssertion());


上面的代码创建了一个有条件的 allow
规则，它允许所有人对所有资源有所有的访问权限，除非请求的 IP
列在“黑名单”上。如果一个请求来自于一个不是“清白”的 IP, 这个 allow
规则就不适用。因此这个规则适用于所有的 Roles、所有的 Resources
和所有的权限，一个“不清白”的 IP
将导致一个禁止访问。这是一个特例，对于其它所有案例（例如，一个特定的
Role、Resource、或者被指定规则的权限），一个失败的声明将导致规则不适用，并且其它规则将被用于决定访问是被允许或禁止。

为了给声明类提供一个上下文环境(Context)来决定所需的条件，Assert对象的 *assert()*
方法将以ACL、 Role、 Resource 和适用于授权查询（例如 *isAllowed()*\ ）的权限作为参数。



.. _`serialize()`: http://php.net/serialize
