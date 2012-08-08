.. EN-Revision: none
.. _zend.permissions.acl.refining:

精细的访问控制
=======

.. _zend.permissions.acl.refining.precise:

精细的访问控制
-------

在 :ref:`前一章节 <zend.permissions.acl.introduction>`\ 中定义的基本的 ACL 显示如何在整个 ACL (所有的
resources
)允许各种各样的权限。然而在实践中，访问控制趋向于拥有例外和可变程度的复杂性。Zend\Permissions\Acl
允许你直截了当并灵活地完成这些精细准确的控制。

对于CMS范例，'staff' 组覆盖了绝大多数用户的需求，同时，一个新的 'marketing'
组要求在CMS中访问时事通讯和最近的新闻。这个组相当地自给自足并有能力发布和归档时事通讯和最近的新闻。

另外，还要求 'staff'
组被允许浏览新闻故事但不能修订最近的新闻。最后，不可能让每一个人（包括系统管理员）去归档任何'announcement'
新闻故事，因为它们只有1-2天的生命周期。

首先我们修订 role 注册表来反映这些变化。我们已经确定 'marketing' 组和 'staff'
组有着同样的基本许可，所以我们用从 'staff' 组继承许可的方法来定义 'marketing' 组

.. code-block:: php
   :linenos:

   // 新 marketing 组从 staff 组继承许可
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('marketing'), 'staff');


然后， 注意上面的访问控制涉及到特定的 resources ( 例如 "newsletter", "latest news",
"announcement news"). 现在我们来添加这些 resources：

.. code-block:: php
   :linenos:

   // Create Resources for the rules

   // newsletter
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('newsletter'));

   // news
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('news'));

   // latest news
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('latest'), 'news');

   // announcement news
   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('announcement'), 'news');


接着，这个是在 ACL 的目标区域定义更特定的规则的概况：

.. code-block:: php
   :linenos:

   // Marketing must be able to publish and archive newsletters and the
   // latest news
   $acl->allow('marketing',
               array('newsletter', 'latest'),
               array('publish', 'archive'));

   // Staff (和 marketing, 通过继承), 禁止修订 latest news
   $acl->deny('staff', 'latest', 'revise');

   // Everyone (包括 administrators) 禁止归档 news announcements
   $acl->deny(null, 'announcement', 'archive');


我们现在能够查询到 ACL 的最新变化：

.. code-block:: php
   :linenos:

   echo $acl->isAllowed('staff', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // denied

   echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // allowed

   echo $acl->isAllowed('staff', 'latest', 'publish') ?
        "allowed" : "denied";
   // denied

   echo $acl->isAllowed('marketing', 'latest', 'publish') ?
        "allowed" : "denied";
   // allowed

   echo $acl->isAllowed('marketing', 'latest', 'archive') ?
        "allowed" : "denied";
   // allowed

   echo $acl->isAllowed('marketing', 'latest', 'revise') ?
        "allowed" : "denied";
   // denied

   echo $acl->isAllowed('editor', 'announcement', 'archive') ?
        "allowed" : "denied";
   // denied

   echo $acl->isAllowed('administrator', 'announcement', 'archive') ?
        "allowed" : "denied";
   // denied


.. _zend.permissions.acl.refining.removing:

除去访问控制
------

要从 ACL 中除去一个或多个访问规则，只要简单地用 *removeAllow()* 或 *removeDeny()*
方法即可。如果提供一个 *null*\ 参数值给 *allow()* 和 *deny()*
方法，则访问规则将应用到所有的角色，资源和/或权限上。

.. code-block:: php
   :linenos:

   // 除去 “禁止 staff 修订最近的新闻”(和marketing, 由于继承的原因)
   //（等于允许staff修订最近的新闻 Jason注）
   $acl->removeDeny('staff', 'latest', 'revise');

   echo $acl->isAllowed('marketing', 'latest', 'revise') ?
        "allowed" : "denied";
   // allowed

   // Remove the allowance of publishing and archiving newsletters to
   // marketing
   $acl->removeAllow('marketing',
                     'newsletter',
                     array('publish', 'archive'));

   echo $acl->isAllowed('marketing', 'newsletter', 'publish') ?
        "allowed" : "denied";
   // denied

   echo $acl->isAllowed('marketing', 'newsletter', 'archive') ?
        "allowed" : "denied";
   // denied


如上所示，对于权限的修改可能是增量的，但使用 *null*
值（未指定权限项的参数值）超越了对权限的增量修改。（所谓的增量修改是指可以对
Resources 一个一个地添加权限或禁止，而如果未指定权限参数值，即使用 *null*
值，可以使得这些步骤简化，一次性地对某个Resource的所有权限进行允许或禁止。Jason注，Haohappy补）

.. code-block:: php
   :linenos:

   // 允许 marketing 对 latest news 有所有的许可
   $acl->allow('marketing', 'latest');

   echo $acl->isAllowed('marketing', 'latest', 'publish') ?
        "allowed" : "denied";
   // allowed

   echo $acl->isAllowed('marketing', 'latest', 'archive') ?
        "allowed" : "denied";
   // allowed

   echo $acl->isAllowed('marketing', 'latest', 'anything') ?
        "allowed" : "denied";
   // allowed



