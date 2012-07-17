
.. _zend.acl.introduction:

Introduction
============

The ``Zend\Acl`` component provides a lightweight and flexible access control list (*ACL*) implementation for privileges management. In general, an application may utilize such *ACL*'s to control access to certain protected objects by other requesting objects.

For the purposes of this documentation:

- a **resource** is an object to which access is controlled.

- a **role** is an object that may request access to a Resource.

Put simply, **roles request access to resources**. For example, if a parking attendant requests access to a car, then the parking attendant is the requesting role, and the car is the resource, since access to the car may not be granted to everyone.

Through the specification and use of an *ACL*, an application may control how roles are granted access to resources.


.. _zend.acl.introduction.resources:

Resources
---------

Creating a resource using ``Zend\Acl\Acl`` is very simple. A resource interface ``Zend\Acl\Resource\ResourceInterface`` is provided to facilitate creating resources in an application. A class need only implement this interface, which consists of a single method, ``getResourceId()``, for ``Zend\Acl\Acl`` to recognize the object as a resource. Additionally, ``Zend\Acl\Resource\GenericResource`` is provided as a basic resource implementation for developers to extend as needed.

``Zend\Acl\Acl`` provides a tree structure to which multiple resources can be added. Since resources are stored in such a tree structure, they can be organized from the general (toward the tree root) to the specific (toward the tree leaves). Queries on a specific resource will automatically search the resource's hierarchy for rules assigned to ancestor resources, allowing for simple inheritance of rules. For example, if a default rule is to be applied to each building in a city, one would simply assign the rule to the city, instead of assigning the same rule to each building. Some buildings may require exceptions to such a rule, however, and this can be achieved in ``Zend\Acl\Acl`` by assigning such exception rules to each building that requires such an exception. A resource may inherit from only one parent resource, though this parent resource can have its own parent resource, etc.

``Zend\Acl\Acl`` also supports privileges on resources (e.g., "create", "read", "update", "delete"), so the developer can assign rules that affect all privileges or specific privileges on one or more resources.


.. _zend.acl.introduction.roles:

Roles
-----

As with resources, creating a role is also very simple. All roles must implement ``Zend\Acl\Role\RoleInterface``. This interface consists of a single method, ``getRoleId()``, Additionally, ``Zend\Acl\Role\GenericRole`` is provided by the ``Zend\Acl`` component as a basic role implementation for developers to extend as needed.

In ``Zend\Acl\Acl``, a role may inherit from one or more roles. This is to support inheritance of rules among roles. For example, a user role, such as "sally", may belong to one or more parent roles, such as "editor" and "administrator". The developer can assign rules to "editor" and "administrator" separately, and "sally" would inherit such rules from both, without having to assign rules directly to "sally".

Though the ability to inherit from multiple roles is very useful, multiple inheritance also introduces some degree of complexity. The following example illustrates the ambiguity condition and how ``Zend\Acl\Acl`` solves it.


.. _zend.acl.introduction.roles.example.multiple_inheritance:

.. rubric:: Multiple Inheritance among Roles

The following code defines three base roles - "guest", "member", and "admin" - from which other roles may inherit. Then, a role identified by "someUser" is established and inherits from the three other roles. The order in which these roles appear in the ``$parents`` array is important. When necessary, ``Zend\Acl\Acl`` searches for access rules defined not only for the queried role (herein, "someUser"), but also upon the roles from which the queried role inherits (herein, "guest", "member", and "admin"):

.. code-block:: php
   :linenos:

   use Zend\Acl\Acl;
   use Zend\Acl\Role\GenericRole as Role;
   use Zend\Acl\Resource\GenericResource as Resource;

   $acl = new Acl();

   $acl->addRole(new Role('guest'))
       ->addRole(new Role('member'))
       ->addRole(new Role('admin'));

   $parents = array('guest', 'member', 'admin');
   $acl->addRole(new Role('someUser'), $parents);

   $acl->add(new Resource('someResource'));

   $acl->deny('guest', 'someResource');
   $acl->allow('member', 'someResource');

   echo $acl->isAllowed('someUser', 'someResource') ? 'allowed' : 'denied';

Since there is no rule specifically defined for the "someUser" role and "someResource", ``Zend\Acl\Acl`` must search for rules that may be defined for roles that "someUser" inherits. First, the "admin" role is visited, and there is no access rule defined for it. Next, the "member" role is visited, and ``Zend\Acl\Acl`` finds that there is a rule specifying that "member" is allowed access to "someResource".

If ``Zend\Acl\Acl`` were to continue examining the rules defined for other parent roles, however, it would find that "guest" is denied access to "someResource". This fact introduces an ambiguity because now "someUser" is both denied and allowed access to "someResource", by reason of having inherited conflicting rules from different parent roles.

``Zend\Acl\Acl`` resolves this ambiguity by completing a query when it finds the first rule that is directly applicable to the query. In this case, since the "member" role is examined before the "guest" role, the example code would print "allowed".

.. note::
   When specifying multiple parents for a role, keep in mind that the last parent listed is the first one searched for rules applicable to an authorization query.



.. _zend.acl.introduction.creating:

Creating the Access Control List
--------------------------------

An Access Control List (*ACL*) can represent any set of physical or virtual objects that you wish. For the purposes of demonstration, however, we will create a basic Content Management System (*CMS*) *ACL* that maintains several tiers of groups over a wide variety of areas. To create a new *ACL* object, we instantiate the *ACL* with no parameters:

.. code-block:: php
   :linenos:

   use Zend\Acl\Acl;
   $acl = new Acl();

.. note::
   Until a developer specifies an "allow" rule, ``Zend\Acl\Acl`` denies access to every privilege upon every resource by every role.



.. _zend.acl.introduction.role_registry:

Registering Roles
-----------------

*CMS*'s will nearly always require a hierarchy of permissions to determine the authoring capabilities of its users. There may be a 'Guest' group to allow limited access for demonstrations, a 'Staff' group for the majority of *CMS* users who perform most of the day-to-day operations, an 'Editor' group for those responsible for publishing, reviewing, archiving and deleting content, and finally an 'Administrator' group whose tasks may include all of those of the other groups as well as maintenance of sensitive information, user management, back-end configuration data, backup and export. This set of permissions can be represented in a role registry, allowing each group to inherit privileges from 'parent' groups, as well as providing distinct privileges for their unique group only. The permissions may be expressed as follows:


.. _zend.acl.introduction.role_registry.table.example_cms_access_controls:

.. table:: Access Controls for an Example CMS

   +-------------+------------------------+------------------------+
   |Name         |Unique Permissions      |Inherit Permissions From|
   +=============+========================+========================+
   |Guest        |View                    |N/A                     |
   +-------------+------------------------+------------------------+
   |Staff        |Edit, Submit, Revise    |Guest                   |
   +-------------+------------------------+------------------------+
   |Editor       |Publish, Archive, Delete|Staff                   |
   +-------------+------------------------+------------------------+
   |Administrator|(Granted all access)    |N/A                     |
   +-------------+------------------------+------------------------+


For this example, ``Zend\Acl\Role\GenericRole`` is used, but any object that implements ``Zend\Acl\Role\RoleInterface`` is acceptable. These groups can be added to the role registry as follows:

.. code-block:: php
   :linenos:

   use Zend\Acl\Acl;
   use Zend\Acl\Role\GenericRole as Role;
   use Zend\Acl\Resource\GenericResource as Resource;

   $acl = new Acl();

   // Add groups to the Role registry using Zend\Acl\Role\GenericRole
   // Guest does not inherit access controls
   $roleGuest = new Role('guest');
   $acl->addRole($roleGuest);

   // Staff inherits from guest
   $acl->addRole(new Role('staff'), $roleGuest);

   /*
   Alternatively, the above could be written:
   $acl->addRole(new Role('staff'), 'guest');
   */

   // Editor inherits from staff
   $acl->addRole(new Role('editor'), 'staff');

   // Administrator does not inherit access controls
   $acl->addRole(new Role('administrator'));


.. _zend.acl.introduction.defining:

Defining Access Controls
------------------------

Now that the *ACL* contains the relevant roles, rules can be established that define how resources may be accessed by roles. You may have noticed that we have not defined any particular resources for this example, which is simplified to illustrate that the rules apply to all resources. ``Zend\Acl\Acl`` provides an implementation whereby rules need only be assigned from general to specific, minimizing the number of rules needed, because resources and roles inherit rules that are defined upon their ancestors.

.. note::
   In general, ``Zend\Acl\Acl`` obeys a given rule if and only if a more specific rule does not apply.


Consequently, we can define a reasonably complex set of rules with a minimum amount of code. To apply the base permissions as defined above:

.. code-block:: php
   :linenos:

   use Zend\Acl\Acl;
   use Zend\Acl\Role\GenericRole as Role;

   $acl = new Acl();

   $roleGuest = new Role('guest');
   $acl->addRole($roleGuest);
   $acl->addRole(new Role('staff'), $roleGuest);
   $acl->addRole(new Role('editor'), 'staff');
   $acl->addRole(new Role('administrator'));

   // Guest may only view content
   $acl->allow($roleGuest, null, 'view');

   /*
   Alternatively, the above could be written:
   $acl->allow('guest', null, 'view');
   //*/

   // Staff inherits view privilege from guest, but also needs additional
   // privileges
   $acl->allow('staff', null, array('edit', 'submit', 'revise'));

   // Editor inherits view, edit, submit, and revise privileges from
   // staff, but also needs additional privileges
   $acl->allow('editor', null, array('publish', 'archive', 'delete'));

   // Administrator inherits nothing, but is allowed all privileges
   $acl->allow('administrator');

The ``NULL`` values in the above ``allow()`` calls are used to indicate that the allow rules apply to all resources.


.. _zend.acl.introduction.querying:

Querying an ACL
---------------

We now have a flexible *ACL* that can be used to determine whether requesters have permission to perform functions throughout the web application. Performing queries is quite simple using the ``isAllowed()`` method:

.. code-block:: php
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


