.. _zend.permissions.rbac.introduction:

Introduction
============

The ``Zend\Permissions\Rbac`` component provides a lightweight role-based access control implementation based around
PHP 5.3's SPL RecursiveIterator and RecursiveIteratorIterator. RBAC differs from access control lists (ACL) by putting
the emphasis on roles and their permissions rather than objects (resources).

For the purposes of this documentation:

- an **identity** has one or more roles.
- a **role** requests access to a permission.
- a **permission** is given to a role.

Thus, RBAC has the following model:

- many to many relationship between **identities** and **roles**.
- many to many relationship between **roles** and **permissions**.
- **roles** can have a parent role.

.. _zend.permissions.rbac.introduction.roles:

Roles
-----

The easiest way to create a role is by extending the abstract class ``Zend\Permission\Rbac\AbstractRole`` or
simply using the default class provided in ``Zend\Permission\Rbac\Role``. You can instantiate a role and
add it to the RBAC container or add a role directly using the RBAC container ``addRole()`` method.

Permissions
-----------

Each role can have zero or more permissions and can be set directly to the role or by first retrieving the role from
the RBAC container. Any child role will inherit the permissions of their parent.

Dynamic Assertions
------------------

In certain situations simply checking a permission key for access may not be enough. For example, assume two users,
Foo and Bar, both have *article.edit* permission. What's to stop Bar from editing Foo's articles? The answer is
dynamic assertions which all you to specify extra runtime credentials that must pass for access to be granted.