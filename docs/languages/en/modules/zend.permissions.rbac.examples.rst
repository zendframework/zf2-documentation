.. _zend.permissions.rbac.examples:

Examples
========

The following is a list of common use-case examples for ``Zend\Permission\Rbac``.

.. _zend.permissions.rbac.examples.roles:

Roles
-----

Extending and adding roles via instantation.

.. code-block:: php
   :linenos:

    <?php
    use Zend\Permissions\Rbac\Rbac;
    use Zend\Permissions\Rbac\AbstractRole;

    class MyRole extends AbstractRole
    {
        // .. implementation
    }

    // Creating roles manually
    $foo  = new MyRole('foo');

    $rbac = new Rbac();
    $rbac->addRole($foo);

    var_dump($rbac->hasRole('foo')); // true

Adding roles directly to RBAC with the default ``Zend\Permission\Rbac\Role``.

.. code-block:: php
   :linenos:

    <?php
    use Zend\Permissions\Rbac\Rbac;

    $rbac = new Rbac();
    $rbac->addRole('foo');

    var_dump($rbac->hasRole('foo')); // true

Handling roles with children.

.. code-block:: php
   :linenos:

    <?php
    use Zend\Permissions\Rbac\Rbac;
    use Zend\Permissions\Rbac\Role;

    $rbac = new Rbac();
    $foo  = new Role('foo');
    $bar  = new Role('bar');

    // 1 - Add a role with child role directly with instantiated classes.
    $foo->addChild($bar);
    $rbac->addRole($foo);

    // 2 - Same as one, only via rbac container.
    $rbac->addRole('boo', 'baz'); // baz is a parent of boo
    $rbac->addRole('baz', array('out', 'of', 'roles')); // create several parents of baz

.. _zend.permissions.rbac.examples.permissions:

Permissions
-----------

.. code-block:: php
   :linenos:

    <?php
    use Zend\Permissions\Rbac\Rbac;
    use Zend\Permissions\Rbac\Role;

    $rbac = new Rbac();
    $foo  = new Role('foo');
    $foo->addPermission('bar');

    var_dump($foo->hasPermission('bar')); // true

    $rbac->addRole($foo);
    $rbac->isGranted('foo', 'bar'); // true
    $rbac->isGranted('foo', 'baz'); // false

    $rbac->getRole('foo')->addPermission('baz');
    $rbac->isGranted('foo', 'baz'); // true

.. _zend.permissions.rbac.examples.dynamic-assertions:

Dynamic Assertions
------------------

Checking permission using ``isGranted()`` with a class implementing ``Zend\Permissions\Rbac\AssertionInterface``.

.. code-block:: php
   :linenos:

    <?php
    use Zend\Permissions\Rbac\AssertionInterface;
    use Zend\Permissions\Rbac\Rbac;

    class AssertUserIdMatches implements AssertionInterface
    {
        protected $userId;
        protected $article;

        public function __construct($userId)
        {
            $this->userId = $userId;
        }

        public function setArticle($article)
        {
            $this->article = $article;
        }

        public function assert(Rbac $rbac)
        {
            if (!$this->article) {
                return false;
            }
            return $this->userId == $article->getUserId();
        }
    }

    // User is assigned the foo role with id 5
    // News article belongs to userId 5
    // Jazz article belongs to userId 6

    $rbac = new Rbac();
    $user = $mySessionObject->getUser();
    $news = $articleService->getArticle(5);
    $jazz = $articleService->getArticle(6);

    $rbac->addRole($user->getRole());
    $rbac->getRole($user->getRole())->addPermission('edit.article');

    $assertion = new AssertUserIdMatches($user->getId());
    $assertion->setArticle($news);

    // true always - bad!
    if ($rbac->isGranted($user->getRole(), 'edit.article')) {
        // hacks another user's article
    }

    // true for user id 5, because he belongs to write group and user id matches
    if ($rbac->isGranted($user->getRole(), 'edit.article', $assertion)) {
        // edits his own article
    }

    $assertion->setArticle($jazz);

    // false for user id 5
    if ($rbac->isGranted($user->getRole(), 'edit.article', $assertion)) {
        // can not edit another user's article
    }

Performing the same as above with a Closure.

.. code-block:: php
    :linenos:

    <?php
    // assume same variables from previous example

    $assertion = function($rbac) use ($user, $news) {
        return $user->getId() == $news->getUserId();
    };

    // true
    if ($rbac->isGranted($user->getRole(), 'edit.article', $assertion)) {
        // edits his own article
    }
