.. _learning.multiuser.authorization:

Building an Authorization System in Zend Framework
==================================================

.. _learning.multiuser.authorization.intro:

Introduction to Authorization
-----------------------------

After a user has been identified as being authentic, an application can go about its business of providing some
useful and desirable resources to a consumer. In many cases, applications might contain different resource types,
with some resources having stricter rules regarding access. This process of determining who has access to which
resources is the process of "authorization". Authorization in its simplest form is the composition of these
elements:

- the identity whom wishes to be granted access

- the resource the identity is asking permission to consume

- and optionally, what the identity is privileged to do with the resource

In Zend Framework, the ``Zend\Permissions\Acl`` component handles the task of building a tree of roles, resources and
privileges to manage and query authorization requests against.

.. _learning.multiuser.authorization.basic-usage:

Basic Usage of Zend\Permissions\Acl
-----------------------------------

When using ``Zend\Permissions\Acl``, any models can serve as roles or resources by simply implementing the proper interface. To
be used in a role capacity, the class must implement the ``Zend\Permissions\Acl\Role\RoleInterface``, which requires only
``getRoleId()``. To be used in a resource capacity, a class must implement the ``Zend\Permissions\Acl\Resource\ResourceInterface``
which similarly requires the class implements the ``getResourceId()`` method.

Demonstrated below is a simple user model. This model can take part in our *ACL* system simply by implementing the
``Zend\Permissions\Acl\Role\RoleInterface``. The method ``getRoleId()`` will return the id "guest" when an ID is not known, or it
will return the role ID that was assigned to this actual user object. This value can effectively come from
anywhere, a static definition or perhaps dynamically from the users database role itself.

.. code-block:: php
   :linenos:

   class Default_Model_User implements Zend\Permissions\Acl\Role\RoleInterface
   {
       protected $_aclRoleId = null;

       public function getRoleId()
       {
           if ($this->_aclRoleId == null) {
               return 'guest';
           }

           return $this->_aclRoleId;
       }
   }

While the concept of a user as a role is pretty straight forward, your application might choose to have any other
models in your system as a potential "resource" to be consumed in this *ACL* system. For simplicity, we'll use the
example of a blog post. Since the type of the resource is tied to the type of the object, this class will only
return 'blogPost' as the resource ID in this system. Naturally, this value can be dynamic if your system requires
it to be so.

.. code-block:: php
   :linenos:

   class Default_Model_BlogPost implements Zend\Permissions\Acl\Resource\ResourceInterface
   {
       public function getResourceId()
       {
           return 'blogPost';
       }
   }

Now that we have at least a role and a resource, we can go about defining the rules of the *ACL* system. These
rules will be consulted when the system receives a query about what is possible given a certain role, resources,
and optionally a privilege.

Lets assume the following rules:

.. code-block:: php
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();

   // setup the various roles in our system
   $acl->addRole('guest');
   // owner inherits all of the rules of guest
   $acl->addRole('owner', 'guest');

   // add the resources
   $acl->addResource('blogPost');

   // add privileges to roles and resource combinations
   $acl->allow('guest', 'blogPost', 'view');
   $acl->allow('owner', 'blogPost', 'post');
   $acl->allow('owner', 'blogPost', 'publish');

The above rules are quite simple: a guest role and an owner role exist; as does a blogPost type resource. Guests
are allowed to view blog posts, and owners are allowed to post and publish blog posts. To query this system one
might do any of the following:

.. code-block:: php
   :linenos:

   // assume the user model is of type guest resource
   $guestUser = new Default_Model_User();
   $ownerUser = new Default_Model_Owner('OwnersUsername');

   $post = new Default_Model_BlogPost();

   $acl->isAllowed($guestUser, $post, 'view'); // true
   $acl->isAllowed($ownerUser, $post, 'view'); // true
   $acl->isAllowed($guestUser, $post, 'post'); // false
   $acl->isAllowed($ownerUser, $post, 'post'); // true

As you can see, the above rules exercise whether owners and guests can view posts, which they can, or post new
posts, which owners can and guests cannot. But as you might expect this type of system might not be as dynamic as
we wish it to be. What if we want to ensure a specific owner actual owns a very specific blog post before allowing
him to publish it? In other words, we want to ensure that only post owners have the ability to publish their own
posts.

This is where assertions come in. Assertions are methods that will be called out to when the static rule checking
is simply not enough. When registering an assertion object this object will be consulted to determine, typically
dynamically, if some roles has access to some resource, with some optional privilege that can only be answered by
the logic within the assertion. For this example, we'll use the following assertion:

.. code-block:: php
   :linenos:

   class OwnerCanPublishBlogPostAssertion implements Zend\Permissions\Acl\Assert\AssertInterface
   {
       /**
        * This assertion should receive the actual User and BlogPost objects.
        *
        * @param Zend\Permissions\Acl $acl
        * @param Zend\Permissions\Acl\Role\RoleInterface $user
        * @param Zend\Permissions\Acl\Resource\ResourceInterface $blogPost
        * @param $privilege
        * @return bool
        */
       public function assert(Zend\Permissions\Acl $acl,
                              Zend\Permissions\Acl\Role\RoleInterface $user = null,
                              Zend\Permissions\Acl\Resource\ResourceInterface $blogPost = null,
                              $privilege = null)
       {
           if (!$user instanceof Default_Model_User) {
               throw new Exception(__CLASS__
                                 . '::'
                                 . __METHOD__
                                 . ' expects the role to be'
                                 . ' an instance of User');
           }

           if (!$blogPost instanceof Default_Model_BlogPost) {
               throw new Exception(__CLASS__
                                 . '::'
                                 . __METHOD__
                                 . ' expects the resource to be'
                                 . ' an instance of BlogPost');
           }

           // if role is publisher, he can always modify a post
           if ($user->getRoleId() == 'publisher') {
               return true;
           }

           // check to ensure that everyone else is only modifying their own post
           if ($user->id != null && $blogPost->ownerUserId == $user->id) {
               return true;
           } else {
               return false;
           }
       }
   }

To hook this into our *ACL* system, we would do the following:

.. code-block:: php
   :linenos:

   // replace this:
   //   $acl->allow('owner', 'blogPost', 'publish');
   // with this:
   $acl->allow('owner',
               'blogPost',
               'publish',
               new OwnerCanPublishBlogPostAssertion());

   // lets also add the role of a "publisher" who has access to everything
   $acl->allow('publisher', 'blogPost', 'publish');

Now, anytime the *ACL* is consulted about whether or not an owner can publish a specific blog post, this assertion
will be run. This assertion will ensure that unless the role type is 'publisher' the owner role must be logically
tied to the blog post in question. In this example, we check to see that the ``ownerUserId`` property of the blog
post matches the id of the owner passed in.


