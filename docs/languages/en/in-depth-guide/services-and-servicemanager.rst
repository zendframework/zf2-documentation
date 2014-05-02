Introducing Services and the ServiceManager
===========================================

In the previous chapter we've learned how to create a simple "Hello World" Application in Zend Framework 2. This is a
good start and easy to understand but the application itself doesn't really do anything. In this chapter we will
introduce you into the concept of Services and with this the introduction to ``Zend\ServiceManager\ServiceManager``.

What is a Service?
==================

//@todo someone who can define Service in a few sentences in easy to understand words

For what we're trying to accomplish with our ``Blog``-Module this means that we want to have a Service that will give
us the data that we want. The Service will get it's data from some source and when writing the Service we don't really
care about what the source actually is. The Service will be written against an ``Interface`` that we define and that
future Data-Providers have to implement.

Writing the BlogService
========================

When writing a Service it is a common best-practice to define an ``Interface`` first. ``Interfaces`` are a good way to
ensure that other programmers can easily build extensions for our Services using their own implementations. In other
words, they can write Services that have the same function names but internally do completely different things but have
a similar result.

In our case we want to create an ``BlogService`` so first we are going to define an ``BlogServiceInterface``. The task
of our Service is to provide us with data of our Blogs. For now we are going to focus on the read-only side of things.
We will define a function that will give us all Blogs and we will define a function that will give us a single Blog.

Let's start by creating the Interface at ``/module/Blog/src/Blog/Service/BlogServiceInterface.php``

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Blog/src/Blog/Service/BlogServiceInterface.php
    namespace Blog\Service;

    interface BlogServiceInterface
    {
        /**
         * Should return a set of all blogs that we can iterate over. Single entries of the array or \Traversable object
         * should be of type \Blog\Model\Blog
         *
         * @return array|\Traversable
         */
        public function findAllBlogs();

        /**
         * Should return a single blog
         *
         * @param  int $id Identifier of the Blog that should be returned
         * @return \Blog\Model\Blog
         */
        public function findBlog($id);
    }

As you can see we define two functions. The first being ``findAllBlogs()`` that is supposed to return all Blogs and the
second one being ``findBlog($id)`` that is supposed to return the Blog matching the given identifier ``$id``. What's new
in here is the fact that we actually define a return value that's not existing yet. We make the assumption that the
return value all in all are of type ``Blog\Model\Blog``. We will define this class at a later point and for now we can
just create the ``BlogService`` first.

Create the class ``BlogService`` at ``/module/Blog/src/Blog/Service/BlogService.php``, be sure to implement the
``BlogServiceInterface`` and it's required functions (we will fill in these functions later). You then should have a
class that looks like the following:

.. code-block:: php
   :linenos:
   :emphasize-lines: 5,10,18

    <?php
    // Filename: /module/Blog/src/Blog/Service/BlogService.php
    namespace Blog\Service;

    class BlogService implements BlogServiceInterface
    {
        /**
         * @inheritDoc
         */
        public function findAllBlogs()
        {
            // TODO: Implement findAllBlogs() method.
        }

        /**
         * @inheritDoc
         */
        public function findBlog($id)
        {
            // TODO: Implement findBlog() method.
        }
    }

Writing the required Model Files
================================

Since our ``BlogService`` will return Models, we should create them, too. Be sure to write an ``Interface`` for the Model,
too! Let's create ``/module/Blog/src/Blog/Model/BlogInterface.php`` and ``/module/Blog/src/Blog/Model/Blog.php``.
First we'll create the ``Interface``:

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Blog/src/Blog/Model/BlogInterface.php
    namespace Blog\Model;

    interface BlogInterface
    {
        /**
         * Will return the ID of the Blog
         *
         * @return int
         */
        public function getId();

        /**
         * Will return the TITLE of the Blog
         *
         * @return string
         */
        public function getTitle();

        /**
         * Will return the ARTIST of the Blog
         *
         * @return string
         */
        public function getText();
    }

Notice that we only created getter-functions here. This is because right now we don't bother how the data gets inside
the Blog-class. All we care for is that we're able to access the properties through these getter-functions.

And now we'll create the appropriate Model file associated with the interface. Make sure to set the required class
properties and fill the getter functions defined by our ``BlogInterface`` with some useful content. Even if our interface
doesn't care about setter functions we will write them as we will fill our class with data through these. You then
should have a class that looks like the following:

.. code-block:: php
   :linenos:
   :emphasize-lines: 5

    <?php
    // Filename: /module/Blog/src/Blog/Model/Blog.php
    namespace Blog\Model;

    class Blog implements BlogInterface
    {
        /**
         * @var int
         */
        protected $id;

        /**
         * @var string
         */
        protected $title;

        /**
         * @var string
         */
        protected $text;

        /**
         * @inheritDoc
         */
        public function getId()
        {
            return $this->id;
        }

        /**
         * @inheritDoc
         */
        public function setId($id)
        {
            $this->id = $id;
        }

        /**
         * @inheritDoc
         */
        public function getTitle()
        {
            return $this->title;
        }

        /**
         * @inheritDoc
         */
        public function setTitle($title)
        {
            $this->title = $title;
        }

        /**
         * @inheritDoc
         */
        public function getText()
        {
            return $this->text;
        }

        /**
         * @inheritDoc
         */
        public function setText($text)
        {
            $this->text = $text;
        }
    }

Bringing Life into our BlogService
===================================

Now that we have our Model files in place we can actually bring life into our ``BlogService`` class. To keep the Service-
Layer easy to understand for now we will only return some static content from our ``BlogService`` class directly. Create
a property inside the ``BlogService`` called ``$data`` and make this an array of our Model type. Edit ``BlogService`` like
this:

.. code-block:: php
   :linenos:
   :emphasize-lines: 7-33

    <?php
    // Filename: /module/Blog/src/Blog/Service/BlogService.php
    namespace Blog\Service;

    class BlogService implements BlogServiceInterface
    {
        protected $data = array(
            array(
                'id'     => 1,
                'title'  => 'In  My  Dreams',
                'text' => 'The  Military  Wives'
            ),
            array(
                'id'     => 2,
                'title'  => '21',
                'text' => 'Adele'
            ),
            array(
                'id'     => 3,
                'title'  => 'Wrecking Ball (Deluxe)',
                'text' => 'Bruce  Springsteen'
            ),
            array(
                'id'     => 4,
                'title'  => 'Born  To  Die',
                'text' => 'Lana  Del  Rey'
            ),
            array(
                'id'     => 5,
                'title'  => 'Making  Mirrors',
                'text' => 'Gotye'
            )
        );

        /**
         * @inheritDoc
         */
        public function findAllBlogs()
        {
            // TODO: Implement findAllBlogs() method.
        }

        /**
         * @inheritDoc
         */
        public function findBlog($id)
        {
            // TODO: Implement findBlog() method.
        }
    }

After we now have some data, let's modify our ``findXY()`` functions to return the appropriate model files:

.. code-block:: php
   :linenos:
   :emphasize-lines: 42-48, 56-63

    <?php
    // Filename: /module/Blog/src/Blog/Service/BlogService.php
    namespace Blog\Service;

    use Blog\Model\Blog;

    class BlogService implements BlogServiceInterface
    {
        protected $data = array(
            array(
                'id'     => 1,
                'title'  => 'In  My  Dreams',
                'text' => 'The  Military  Wives'
            ),
            array(
                'id'     => 2,
                'title'  => '21',
                'text' => 'Adele'
            ),
            array(
                'id'     => 3,
                'title'  => 'Wrecking Ball (Deluxe)',
                'text' => 'Bruce  Springsteen'
            ),
            array(
                'id'     => 4,
                'title'  => 'Born  To  Die',
                'text' => 'Lana  Del  Rey'
            ),
            array(
                'id'     => 6,
                'title'  => 'Making  Mirrors',
                'text' => 'Gotye'
            )
        );

        /**
         * @inheritDoc
         */
        public function findAllBlogs()
        {
            $allBlogs = array();

            foreach ($this->data as $index => $blog) {
                $allBlogs[] = $this->findBlog($index);
            }

            return $allBlogs;
        }

        /**
         * @inheritDoc
         */
        public function findBlog($id)
        {
            $blogData = $this->data[$id];

            $model = new Blog();
            $model->setId($blogData['id']);
            $model->setTitle($blogData['title']);
            $model->setText($blogData['text']);

            return $model;
        }
    }

As you can see, both our functions now have appropriate return values. Please note that from a technical point of view
the current implementation is far from perfect. We will improve this Service a lot in the future but for now we have
a working Service that is able to give us some data in a way that we have defined by our ``BlogServiceInterface``.


Bringing the Service into the Controller
========================================

Now that we have our ``BlogService`` written, we want to get access to this Service in our Controllers. For this task
we will step foot into a new topic called "Dependency Injection" short "DI".

// @todo Need someone to write a good 2-3 Sentences summary of what DI is in very easy to understand words

In our case we want to have our Blog-Modules ``ListController`` somehow interact with our ``BlogService``. This means
that the class ``BlogService`` is a dependency of the class ``ListController``. Without the ``BlogService`` our
``ListController`` will not be able to function properly. To make sure that our ``ListController`` will always get the
appropriate dependency, we will first define the dependency inside the ``ListControllers`` constructor function
``__construct()``. Go on and modify the ``ListController`` like this:

.. code-block:: php
   :linenos:
   :emphasize-lines: 5, 8, 13, 15-18

    <?php
    // Filename: /module/Blog/src/Blog/Controller/ListController.php
    namespace Blog\Controller;

    use Blog\Service\BlogServiceInterface;
    use Zend\Mvc\Controller\AbstractActionController;

    class ListController extends AbstractActionController
    {
        /**
         * @var \Blog\Service\BlogServiceInterface
         */
        protected $blogService;

        public function __construct(BlogServiceInterface $blogService)
        {
            $this->blogService = $blogService;
        }
    }

As you can see our ``__construct()`` function now has a required argument. We will not be able to call this class anymore
without passing it an instance of a class that matches our defined ``BlogServiceInterface``. If you were to go back to
your browser and reload your project with the url ``domain.loc/blog``, you'd see the following error message:

.. code-block:: text
   :linenos:

    ( ! ) Catchable fatal error: Argument 1 passed to Blog\Controller\ListController::__construct()
          must be an instance of Blog\Service\BlogServiceInterface, none given,
          called in {libraryPath}\Zend\ServiceManager\AbstractPluginManager.php on line {lineNumber}
          and defined in \module\Blog\src\Blog\Controller\ListController.php on line 15

And this error message is expected. It tells you exactly that our ``ListController`` expects to be passed an implementation
of the ``BlogServiceInterface``. So how do we make sure that our ``ListController`` will receive such an implementation?
To solve this, we need to tell the application how to create instances of the ``Blog\Controller\ListController``. If you
remember back to when we created the controller, we added an entry to the ``invokables`` array in the module config:

.. code-block:: php
   :linenos:
   :emphasize-lines: 6-8

    <?php
    // Filename: /module/Blog/config/module.config.php
    return array(
        'view_manager' => array( /** ViewManager Config */ ),
        'controllers'  => array(
            'invokables' => array(
                'Blog\Controller\List' => 'Blog\Controller\ListController'
            )
        ),
        'router' => array( /** Router Config */ )
    );

An ``invokable`` is a class that can be constructed without any arguments. Since our ``Blog\Controller\ListController``
now has a required argument, we need to change this. The ``ControllerManager``, who is in charge of instantiating the
controllers for us, also support using ``factories``. A ``factory`` is a class that creates instances of another class.
We'll create one for our ``ListController``. Let's modify our configuration like this:


.. code-block:: php
   :linenos:
   :emphasize-lines: 6-8

    <?php
    // Filename: /module/Blog/config/module.config.php
    return array(
        'view_manager' => array( /** ViewManager Config */ ),
        'controllers'  => array(
            'factories' => array(
                'Blog\Controller\List' => 'Blog\Factory\ListControllerFactory'
            )
        ),
        'router' => array( /** Router Config */ )
    );

As you can see we no longer have the key ``invokables``, instead we now have the key ``factories``. Furthermore the value
of our controller name ``Blog\Controller\List`` has been changed to not match the class ``Blog\Controller\ListController``
directly but to rather call a class called ``Blog\Factory\ListControllerFactory``. If you refresh your browser
you'll see a different error message:

.. code-block:: html
   :linenos:

    An error occurred
    An error occurred during execution; please try again later.

    Additional information:
    Zend\ServiceManager\Exception\ServiceNotCreatedException

    File:
    {libraryPath}\Zend\ServiceManager\AbstractPluginManager.php:{lineNumber}

    Message:
    While attempting to create blogcontrollerlist(alias: Blog\Controller\List) an invalid factory was registered for this instance type.

This message should be quite easy to understand. The ``Zend\Mvc\Controller\ControllerManager``
is accessing ``Blog\Controller\List``, which internally is saved as ``blogcontrollerlist``. While it does so it notices
that a factory class is supposed to be called for this controller name. However it doesn't find this factory class so
to the Manager it is an invalid factory. Using easy words: the Manager doesn't find the Factory class so that's probably
where our error lies. And of course, we have yet to write the factory, so let's go ahead and do this.


Writing a Factory Class
=======================

Factory classes within Zend Framework 2 always need to implement the `Zend\ServiceManager\FactoryInterface``.
Implementing this class let's the ServiceManager know that the function ``createService()`` is supposed to be called. And
``createService()`` actually expects to be passed an instance of the `ServiceLocatorInterface` so the `ServiceManager` will
always inject this using Dependency Injection as we have learned above. Let's implement our factory class:

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Blog/src/Blog/Factory/ListControllerFactory.php
    namespace Blog\Factory;

    use Blog\Controller\ListController;
    use Zend\ServiceManager\FactoryInterface;
    use Zend\ServiceManager\ServiceLocatorInterface;

    class ListControllerFactory implements FactoryInterface
    {
        /**
         * Create service
         *
         * @param ServiceLocatorInterface $serviceLocator
         *
         * @return mixed
         */
        public function createService(ServiceLocatorInterface $serviceLocator)
        {
            $realServiceLocator = $serviceLocator->getServiceLocator();
            $blogService       = $realServiceLocator->get('Blog\Service\BlogServiceInterface');

            return new ListController($blogService);
        }
    }

Now this looks complicated! Let's start to look at the ``$realServiceLocator``. When using a Factory-Class that will be
called from the ``ControllerManager`` it will actually inject **itself** as the ``$serviceLocator``. However we need the real
``ServiceManager`` to get to our Service-Classes. This is why we call the function ``getServiceLocator()` who will give us
the real ``ServiceManager``.

After we have the ``$realServiceLocator`` set up we try to get a Service called ``Blog\Service\BlogServiceInterface``.
This name that we're accessing is supposed to return a Service that matches the ``BlogServiceInterface``. This Service
is then passed along to the ``ListController`` which will directly be returned.

Note though that we have yet to register a Service called ``Blog\Service\BlogServiceInterface``. There's no magic
happening that does this for us just because we give the Service the name of an Interface. Refresh your browser and you
will see this error message:

.. code-block:: text
   :linenos:

    An error occurred
    An error occurred during execution; please try again later.

    Additional information:
    Zend\ServiceManager\Exception\ServiceNotFoundException

    File:
    {libraryPath}\Zend\ServiceManager\ServiceManager.php:{lineNumber}

    Message:
    Zend\ServiceManager\ServiceManager::get was unable to fetch or create an instance for Blog\Service\BlogServiceInterface

Exactly what we expected. Somewhere in our application - currently our factory class - a service called
``Blog\Service\BlogServiceInterface`` is requested but the ServiceManager doesn't know about this Service yet.
Therefore it isn't able to create an instance for the requested name.


Registering Services
====================

Registering a Service is as simple as registering a Controller. All we need to do is modify our ``module.config.php`` and
add a new key called ``service_manager`` that then has ``invokables`` and ``factories``, too, the same way like we have it
inside our ``controllers`` array. Check out the new configuration file:

.. code-block:: php
   :linenos:
   :emphasize-lines: 4-8

    <?php
    // Filename: /module/Blog/config/module.config.php
    return array(
        'service_manager' => array(
            'invokables' => array(
                'Blog\Service\BlogServiceInterface' => 'Blog\Service\BlogService'
            )
        ),
        'view_manager' => array( /** View Manager Config */ ),
        'controllers'  => array( /** Controller Config */ ),
        'router'       => array( /** Router Config */ )
    );

As you can see we now have added a new Service that listens to the name ``Blog\Service\BlogServiceInterface`` and
points to our own implementation which is ``Blog\Service\BlogService``. Since our Service has no dependencies we are
able to add this Service under the ``invokables`` array. Try refreshing your browser. You should see no more error
messages but rather exactly the page that we have created in the previous chapter of the Tutorial.

Using the Service at our Controller
===================================

Let's now use the ``BlogService`` within our ``ListController``. For this we will need to overwrite the default
``indexAction()`` and return the values of our ``BlogService`` into the view. Modify the ``ListController`` like this:

.. code-block:: php
   :linenos:
   :emphasize-lines: 6, 23-25

    <?php
    // Filename: /module/Blog/src/Blog/Controller/ListController.php
    namespace Blog\Controller;

    use Blog\Service\BlogServiceInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class ListController extends AbstractActionController
    {
        /**
         * @var \Blog\Service\BlogServiceInterface
         */
        protected $blogService;

        public function __construct(BlogServiceInterface $blogService)
        {
            $this->blogService = $blogService;
        }

        public function indexAction()
        {
            return new ViewModel(array(
                'blogs' => $this->blogService->findAllBlogs()
            ));
        }
    }

First please note the our controller imported another class. We need to import ``Zend\View\Model\ViewModel``, which
usually is what your Controllers will return. When returning an instance of a ``ViewModel`` you're able to always
assign so called View-Variables. In this case we have assigned a variable called ``$blogs`` with the value of whatever
the function ``findAllBlogs()`` of our ``BlogService`` returns. In our case it is an array of `Blog\Model\Blog` classes.
Refreshing the browser won't change anything yet because we obviously need to modify our view-file to be able to display
the data we want to.


Accessing View Variables
========================

When pushing variables to the view they are accessible through two ways. Either directly like ``$this->blogs`` or
implicitly like ``$blogs``. Both are the same however calling ``$blogs`` implicitly will result in a little round-trip
through the ``__call()`` function which theoretically is a little slower. You won't ever notice this though.

Let's modify our view to display a table of all Blogs we that our ``BlogService`` returns.

.. code-block:: php
   :linenos:
   :emphasize-lines: 13, 15-17, 19

    <!-- Filename: /module/Blog/view/blog/list/index.phtml -->
    <h1>Blogs</h1>

    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Text</th>
                <th>Title</th>
            </tr>
        </thead>
        <tbody>
            <?php foreach($this->blogs as $a) : ?>
            <tr>
                <td><?php echo $a->getId();?></td>
                <td><?php echo $a->getText();?></td>
                <td><?php echo $a->getTitle();?></td>
            </tr>
            <?php endforeach; ?>
        </tbody>
    </table>

In here we simply define a little HTML-Table and then run a ``foreach`` over array ``$this->blogs``. Since every single
entry of our array is of type ``Blog\Model\Blog`` we can use the respective getter functions to receive the data we
want to get.

Summary
=======

And with this the current chapter is finished. We now have learned how to interact with the ServiceManager and we also
know what dependency injection is all about. We are now able to pass variables from our services into the view through
a controller and we know how to iterate over arrays inside a view-script.

In the next chapter we will take a first look at the things we should do when we want to get data from a database.