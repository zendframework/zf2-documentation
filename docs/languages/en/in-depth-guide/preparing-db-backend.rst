Preparing for different Database-Backends
=========================================

In the previous chapter we have created a ``PostService`` that returns some data from blog posts. While this served
an easy to understand learning purpose it is quite impractical for real world applications. No one would want to modify
the source files each time a new post is added. But luckily we all know about databases. All we need to learn is how
to interact with databases from our ZF2 application.

But there is a catch. There are many database backend systems, namely SQL and NoSQL databases. While in a real-world
you would probably jump right to the solution that fits you the most at the time being, it is a better practice to
create another layer in front of the actual database access that abstracts the database interaction. We call this the
**Mapper-Layer**.


What is database abstraction?
=============================

The term "database abstraction" may sound quite confusing but this is actually a very simple thing. Consider a SQL and
a NoSQL database. Both have methods for CRUD (Create, Read, Update, Delete) operations. For example to query the
database against a given row in MySQL you'd do a ``mysqli_query('SELECT foo FROM bar')``. But using an ORM for MongoDB
for example you'd do something like ``$mongoODM->getRepository('bar')->find('foo')``. Both engines would give you the
same result but the execution is different.

So if we start using a SQL database and write those codes directly into our ``PostService`` and a year later we decide
to switch to a NoSQL database, we would literally have to delete all previously coded lines and write new ones. And
in a few years later a new thing pops up and we have to delete and re-write codes again. This isn't really the best
approach and that's precisely where database abstraction or the Mapper-Layer comes in handy.

Basically what we do is to create a new Interface. This interface then defines **how** our database interaction should
function but the actual implementation is left out. But let's stop the theory and go over to code this thing.


Creating the PostMapperInterface
================================

Let's first think a bit about what possible database interactions we can think of. We need to be able to:

- find a single blog post
- find all blog posts
- insert new blog post
- update existing blog posts
- delete existing blog posts

Those are the most important ones I'd guess for now. Considering ``insert()`` and ``update()`` both write into the
database it'd be nice to have just a single ``save()``-function that calls the proper function internally.

Start by creating a new file inside a new namespace ``Blog\Mapper`` called ``PostMapperInterface.php`` and add the
following content to it.

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Blog/src/Blog/Mapper/PostMapperInterface.php
    namespace Blog\Mapper;

    use Blog\Model\PostInterface;

    interface PostMapperInterface
    {
        /**
         * @param int|string $id
         * @return PostInterface
         * @throws \InvalidArgumentException
         */
        public function find($id);

        /**
         * @return array|PostInterface[]
         */
        public function findAll();
    }

As you can see we define two different functions. We say that a mapper-implementation is supposed to have one
``find()``-function that returns a single object implementing the ``PostInterface``. Then we want to have one function
called ``findAll()`` that returns an array of objects implementing the ``PostInterface``. Definitions for a possible
``save()`` or ``delete()`` functionality will not be added to the interface yet since we'll only be looking at the
read-only side of things for now. They will be added at a later point though!


Refactoring the PostService
===========================

Now that we have defined how our mapper should act we can make use of it inside our ``PostService``. To start off the
refactoring process let's empty our class and delete all current content. Then implement the functions defined by the
``PostServiceInterface`` and you should have an empty ``PostService`` that looks like this:

.. code-block:: php
   :linenos:
   :emphasize-lines:

    <?php
    // Filename: /module/Blog/src/Blog/Service/PostService.php
    namespace Blog\Service;

    class PostService implements PostServiceInterface
    {
        /**
         * {@inheritDoc}
         */
        public function findAllPosts()
        {
        }

        /**
         * {@inheritDoc}
         */
        public function findPost($id)
        {
        }
    }

The first thing we need to keep in mind is that this interface isn't implemented in our ``PostService`` but is rather
used as a dependency. A required dependency, therefore we need to create a ``__construct()`` that takes any
implementation of this interface as a parameter. Also you should create a protected variable to store the parameter
into.

.. code-block:: php
   :linenos:
   :emphasize-lines: 5, 7, 12, 17-20

    <?php
    // Filename: /module/Blog/src/Blog/Service/PostService.php
    namespace Blog\Service;

    use Blog\Mapper\PostMapperInterface;

    class PostService implements PostServiceInterface
    {
        /**
         * @var \Blog\Mapper\PostMapperInterface
         */
        protected $postMapper;

        /**
         * @param PostMapperInterface $postMapper
         */
        public function __construct(PostMapperInterface $postMapper)
        {
            $this->postMapper = $postMapper;
        }

        /**
         * {@inheritDoc}
         */
        public function findAllPosts()
        {
        }

        /**
         * {@inheritDoc}
         */
        public function findPost($id)
        {
        }
    }

With this we now require an implementation of the ``PostMapperInterface`` for our ``PostService`` to function. Since
none exists yet we can not get our application to work and we'll be seeing the following PHP error:

.. code-block:: text
   :linenos:

    Catchable fatal error: Argument 1 passed to Blog\Service\PostService::__construct()
    must implement interface Blog\Mapper\PostMapperInterface, none given,
    called in {path}\module\Blog\src\Blog\Service\PostServiceFactory.php on line 19
    and defined in {path}\module\Blog\src\Blog\Service\PostService.php on line 17

But the power of what we're doing lies within assumptions that we **can** make. This ``PostService`` will always have
a mapper passed as an argument. So in our ``find*()``-functions we **can** assume that it is there. Recall that the
``PostMapperInterface`` defines a ``find($id)`` and a ``findAll()`` function. Let's use those within our
Service-functions:

.. code-block:: php
   :linenos:
   :emphasize-lines: 27, 35

    <?php
    // Filename: /module/Blog/src/Blog/Service/PostService.php
    namespace Blog\Service;

    use Blog\Mapper\PostMapperInterface;

    class PostService implements PostServiceInterface
    {
        /**
         * @var \Blog\Mapper\PostMapperInterface
         */
        protected $postMapper;

        /**
         * @param PostMapperInterface $postMapper
         */
        public function __construct(PostMapperInterface $postMapper)
        {
            $this->postMapper = $postMapper;
        }

        /**
         * {@inheritDoc}
         */
        public function findAllPosts()
        {
            return $this->postMapper->findAll();
        }

        /**
         * {@inheritDoc}
         */
        public function findPost($id)
        {
            return $this->postMapper->find($id);
        }
    }

Looking at this code you'll see that we use the ``postMapper`` to get access to the data we want. How this is happening
isn't the business of the ``PostService`` anymore. But the ``PostService`` does know what data it will receive and
that's the only important thing.


The PostService has a dependency
================================

Now that we have introduced the ``PostMapperInterface`` as a dependency for the ``PostService`` we are no longer able to
define this service as an ``invokable`` because it has a dependency. So we need to create a factory for the service. Do
this by creating a factory the same way we have done for the ``ListController``. First change the configuration from an
``invokables``-entry to a ``factories``-entry and assign the proper factory class:

.. code-block:: php
   :linenos:
   :emphasize-lines: 4-8

    <?php
    // Filename: /module/Blog/config/module.config.php
    return array(
        'service_manager' => array(
            'factories' => array(
                'Blog\Service\PostServiceInterface' => 'Blog\Factory\PostServiceFactory'
            )
        ),
        'view_manager' => array( /** ViewManager Config */ ),
        'controllers'  => array( /** ControllerManager Config */ ),
        'router'       => array( /** Router Config */ )
    );

Going by the above configuration we now need to create the class ``Blog\Factory\PostServiceFactory`` so let's go ahead
and create it:

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Blog/src/Blog/Factory/PostServiceFactory.php
    namespace Blog\Factory;

    use Blog\Service\PostService;
    use Zend\ServiceManager\FactoryInterface;
    use Zend\ServiceManager\ServiceLocatorInterface;

    class PostServiceFactory implements FactoryInterface
    {
        /**
         * Create service
         *
         * @param ServiceLocatorInterface $serviceLocator
         * @return mixed
         */
        public function createService(ServiceLocatorInterface $serviceLocator)
        {
            return new PostService(
                $serviceLocator->get('Blog\Mapper\PostMapperInterface')
            );
        }
    }

With this in place you should now be able to see the ``ServiceNotFoundException``, thrown by the ``ServiceManager``,
saying that the requested service cannot be found.

.. code-block:: text
   :linenos:

    Additional information:
    Zend\ServiceManager\Exception\ServiceNotFoundException
    File:
    {libraryPath}\Zend\ServiceManager\ServiceManager.php:529
    Message:
    Zend\ServiceManager\ServiceManager::get was unable to fetch or create an instance for Blog\Mapper\PostMapperInterface

Conclusion
==========

We finalize this chapter with the fact that we successfully managed to keep the database-logic outside of our service.
Now we are able to implement different database solution depending on our need and change them easily when the time
requires it.

In the next chapter we will create the actual implementation of our ``PostMapperInterface`` using ``Zend\Db\Sql``.