.. EN-Revision: none
.. _zend.acl.introduction:

简介
==

Zend_Acl 为权限管理提供轻量并灵活的访问控制列表 (ACL,access control list)
的实现。一般地，应用软件可以利用这样的功能限制某些特定对象来访问特定保护的对象。

在本文档中，



   - **resource** （资源）是一个限制访问的对象。

   - **role** （角色）是一个可以发出请求去访问Resource的对象。

简单地说就是： **roles 请求访问 resources**\
。例如，如果停车服务员要进入汽车，那么，这个停车服务员就是发出请求的
role，而这辆汽车就是 resource，因为不是所有人都有权进入汽车。

通过规范和访问控制列表（ACL）的使用，应用软件可以控制角色（roles）如何来访问资源（resources）。

.. _zend.acl.introduction.resources:

关于资源(Resource)
--------------

在 Zend_Acl 中，创建一个 resource 非常简单。Zend_Acl 提供了 resource 接口
*Zend_Acl_Resource_Interface* 使开发者在程序中创建 resources 非常容易。
为了使Zend_Acl把某个对象当作一个resource，一个类只需要实现这个只包含了一个方法
*getResourceId()* 的接口。 另外， *Zend_Acl_Resource*\ 是一个包含在 Zend_Acl 里作为一个基本的
resource 实现的类，开发者可以任意扩展它。

Zend_Acl 提供了一个树结构，它可以添加多个 resources
(或者叫“访问控制下的区域”）。因为 resources 被存储在这样一个树结构，
所以它们可以被组织成从一般（树根）到特殊（树叶）。基于特殊resource的查询将自动从resource的等级结构中搜索分配给祖先rResources的规则，
它允许简单的规则继承。例如，要把一个缺省的规则应用到一个城市的每个建筑物，就简单地把这个规则分配给这个城市，
而不是把规则分配给每个建筑物。然而，有些建筑物也许要求例外的规则，在Zend_Acl里，很容易地通过分配例外规则给每个有这样要求的建筑物来实现。
一个 resource 可以从唯一的一个父 resource 继承，而这个父 resource 也有它自己的父
resource，等等。

Zend_Acl 也支持基于 resources 的权限（例如："create", "read", "update", "delete"），
所以开发者可以根据 resource 分配影响全部或者特殊权限的规则到一个或多个资源。

.. _zend.acl.introduction.roles:

关于角色(Role)
----------

象 Resources 一样，创建一个 role 也非常简单。 Zend_Acl 提供了 *Zend_Acl_Role_Interface*
使开发者创建 roles 非常容易。 为了使Zend_Acl把某个对象当作一个
role，一个类只需要实现这个只包含了一个方法 *getRoleId()* 的接口。 另外， *Zend_Acl_Role*\
是一个包含在Zend_Acl里作为一个基本的 role 实现的类，开发者可以任意扩展它。

在 Zend_Acl, 一个 role 可以从一个或多个 role 继承，这就是在 role
中支持规则的继承。例如，一个用户 role，如 “sally”， 可以属于一个或多个
role，如：“editor”和“administrator”。开发者可以分别给“editor”和“administrator”分配规则，
而“sally”将从它们俩继承规则，不需要直接给“sally”分配规则。

虽然从多重角色继承的能力非常有用，但是多重继承也带来了一定程度的复杂性。下面的例子来示例含糊情形和Zend_Acl如何解决它。

.. _zend.acl.introduction.roles.example.multiple_inheritance:

.. rubric:: 角色之间的多重继承

下面的代码定义了三个基本角色 - "*guest*", "*member*", 和 "*admin*" -
其它角色可以从它们继承。接着，创建一个"*someUser*" 角色并从其它三个基本角色继承。
在 *$parents* 数组里这些角色出现的顺序很重要。 必要时，Zend_Acl
不但搜索为被查询的角色 （这里指
"*someUser*"）定义的访问规则，而且搜索为被查询的角色所继承的角色 （这里指 "*guest*",
"*member*", and "*admin*"）定义的访问规则：

.. code-block::
   :linenos:

   $acl = new Zend_Acl();

   $acl->addRole(new Zend_Acl_Role('guest'))
       ->addRole(new Zend_Acl_Role('member'))
       ->addRole(new Zend_Acl_Role('admin'));

   $parents = array('guest', 'member', 'admin');
   $acl->addRole(new Zend_Acl_Role('someUser'), $parents);

   $acl->add(new Zend_Acl_Resource('someResource'));

   $acl->deny('guest', 'someResource');
   $acl->allow('member', 'someResource');

   echo $acl->isAllowed('someUser', 'someResource') ? 'allowed' : 'denied';


因为没有明确地为 "*someUser*"和"*someResource*" 定义规则， 所以Zend_Acl
必须搜索可能为"*someUser*"所继承的角色定义的规则。
首先，"*admin*"角色被访问，没有给它定义访问规则。
接着，"*member*"角色被访问，Zend_Acl发现有个规则允许"*member*" 访问"*someResource*"。

如果Zend_Acl打算继续检查为父角色所定义的规则，然而， 它将发现"*guest*"
被拒绝访问"*someResource*" 。 这带来了模棱两可的情形，
"*someUser*"即被允许又被禁止访问"*someResource*"，因为它从不同的父角色继承了冲突的规则。

Zend_Acl 解决了这个模棱两可的问题，当它发现第一个可用的规则时，就完成了查询。
对于这个案例，因为"*member*"角色先于"*guest*" 角色被检查，这个例子将打印"*allowed*"。

.. note::

   当为一个角色指定多重父（角色）时，请记住，对于一个授权查询的可用规则，最后列出的父（角色）是首先被搜索的。

.. _zend.acl.introduction.creating:

创建访问控制列表(ACL)
-------------

ACL
可以表示任何一组物理或虚拟对象，然而，作为示范，我们将创建一个基本的内容管理系统的（CMS）ACL，
在一个范围很宽的多样化区域里，它将维护若干个等级的组。为创建一个新的 ACL
对象，我们不带参数地实例化这个 ACL：

.. code-block::
   :linenos:

   $acl = new Zend_Acl();


.. note::

   除非开发者指明一个"allow" 规则，Zend_Acl 禁止任何 role 对任何 resource
   的任何访问权限。

.. _zend.acl.introduction.role_registry:

注册角色(Role)
----------

CMS 通常需要一个分级的权限系统来决定它的用户的授权能力。
作为示范，“Guest”组允许有限的访问，“Staff”适合大多数的执行日常操作的CMS用户，“Editor”组适合于发布、复核、存档和删除内容，
最后“Administrator”组的任务包括所有其它组的内容并包括敏感的信息、用户管理、后台配置数据和备份/导出。
这组许可可以被表示为一个 role
注册表，允许每个组从“”组继承权限，也可以为单一的组提供独特的权限。这些许可可以表示如下：

.. _zend.acl.introduction.role_registry.table.example_cms_access_controls:

.. table:: 一个CMS范例的访问控制

   +-------------+------------------------+---------+
   |名称           |独特的许可                   |从...继承的许可|
   +=============+========================+=========+
   |Guest        |View                    |N/A      |
   +-------------+------------------------+---------+
   |Staff        |Edit, Submit, Revise    |Guest    |
   +-------------+------------------------+---------+
   |Editor       |Publish, Archive, Delete|Staff    |
   +-------------+------------------------+---------+
   |Administrator|(Granted all access)    |N/A      |
   +-------------+------------------------+---------+

对于这个范例， *Zend_Acl_Role* 被使用，但任何实现 *Zend_Acl_Role_Interface*
的对象是可接受的。这些组可以被添加到 role 注册表如下：

.. code-block::
   :linenos:

   $acl = new Zend_Acl();

   // 用 Zend_Acl_Role 把组添加到 Role 注册表
   // Guest 不继承访问控制
   $roleGuest = new Zend_Acl_Role('guest');
   $acl->addRole($roleGuest);

   // Staff 从 guest 继承
   $acl->addRole(new Zend_Acl_Role('staff'), $roleGuest);

   /*
   另外, 上面的也可这样来写：
   $acl->addRole(new Zend_Acl_Role('staff'), 'guest');
   */

   // Editor 从 staff 继承
   $acl->addRole(new Zend_Acl_Role('editor'), 'staff');

   // Administrator 不继承访问控制
   $acl->addRole(new Zend_Acl_Role('administrator'));


.. _zend.acl.introduction.defining:

定义访问控制
------

现在 ACL 包含了相关的 roles，可以建立规则来定义 roles 如何访问 resources。
你也许注意到我们在这个范例里没有定义任何特定的 resources，
这简单地表示这些规则适用于所有 resources。 Zend_Acl
提供一个实现，籍此，规则只需要被分配从一般到特殊，最小化规则的需求，因为
resources 和 roles 继承由它们祖先定义的规则。

.. note::

   一般来说，当且仅当更具体的规则没有使用， Zend_Acl 就服从已给定的规则。

因此，我们可以用最少量的代码来定义适度复杂的规则。应用上面定义的基本许可：

.. code-block::
   :linenos:

   $acl = new Zend_Acl();

   $roleGuest = new Zend_Acl_Role('guest');
   $acl->addRole($roleGuest);
   $acl->addRole(new Zend_Acl_Role('staff'), $roleGuest);
   $acl->addRole(new Zend_Acl_Role('editor'), 'staff');
   $acl->addRole(new Zend_Acl_Role('administrator'));

   // Guest 只可以浏览内容
   $acl->allow($roleGuest, null, 'view');

   /*
   另外, 上面也可写为：
   $acl->allow('guest', null, 'view');
   */

   // Staff 从 guest 继承浏览权限，但也要另外的权限
   $acl->allow('staff', null, array('edit', 'submit', 'revise'));

   // Editor 从 Staff 继承 view, edit, submit 和 revise 权限
   // 但也要另外的权限
   $acl->allow('editor', null, array('publish', 'archive', 'delete'));

   // Administrator 不需要继承任何权限，它拥有所有的权限
   $acl->allow('administrator');


在上面 *allow()* 中调用中 *null* 的值用来表明 allow 规则适用于所有的 resources。

.. _zend.acl.introduction.querying:

查询 ACL
------

我们现在有一个灵活的 ACL 可以用来决定请求者在整个 web
应用里是否拥有执行功能的许可。用 *isAllowed()*\ 方法来执行查询相当简单：

.. code-block::
   :linenos:

   echo $acl->isAllowed('guest', null, 'view') ?
        "allowed" : "denied";
   // allowed

   echo $acl->isAllowed('staff', null, 'publish') ?
        "allowed" : "denied";
   // denied

   echo $acl->isAllowed('staff', null, 'revise') ?
        "allowed" : "denied";
   // allowed

   echo $acl->isAllowed('editor', null, 'view') ?
        "allowed" : "denied";
   // allowed because of inheritance from guest

   echo $acl->isAllowed('editor', null, 'update') ?
        "allowed" : "denied";
   // denied because no allow rule for 'update'

   echo $acl->isAllowed('administrator', null, 'view') ?
        "allowed" : "denied";
   // allowed because administrator is allowed all privileges

   echo $acl->isAllowed('administrator') ?
        "allowed" : "denied";
   // allowed because administrator is allowed all privileges

   echo $acl->isAllowed('administrator', null, 'update') ?
        "allowed" : "denied";
   // allowed because administrator is allowed all privileges



