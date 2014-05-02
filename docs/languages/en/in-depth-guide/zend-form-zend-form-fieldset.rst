Making use of Forms and Fieldsets
=================================

So far all we did was read data from the database. In a real-life-application this won't get us very far as very often
the least we need to do is to support full ``Create``, ``Read``, ``Update`` and ``Delete`` operations (CRUD). Most often the
process of getting data into our database is that a user enters the data into a web ``<form>`` and the application then
uses the user input saves it into our backend.

We want to be able to do exactly this and Zend Framework provides us with all the tools we need to achieve our goal.
Before we jump into coding, we need to understand the two core components for this task first. So let's take a look at
what these components are and what they are used for.

Zend\\Form\\Fieldset
--------------------

The first component that you have to know about is ``Zend\Form\Fieldset``. A ``Fieldset`` is a component that contains a
reusable set of elements. You will use the ``Fieldset`` to create the frontend-input for your backend-models. It is
considered good practice to have one ``Fieldset`` for every ``Model`` of your application.

The ``Fieldset``-component however is no ``Form``, meaning you will not be able to use a ``Fieldset`` without attaching it
to the ``Form``-component. The advantage here is that you have one set of elements that you can re-use for as many
``Forms`` as you like without having to re-declare all the inputs for the ``Model`` that's represented by the ``Fieldset``.

Zend\\Form\\Form
----------------

The main component you'll need and that most probably you've heard about already is ``Zend\Form\Form``. The ``Form``-
component is the main container for all elements of your web ``<form>``. You are able to add single elements or a set of
elements in the form of a ``Fieldset``, too.


Creating your first Fieldset
============================

Explaining how the ``Zend\Form`` component works is best done by giving you real code to work with. So let's jump right
into it and create all the forms we need to finish our ``Blog`` module. We start by creating a ``Fieldset`` that contains
all the input elements that we need to work with our ``Blog``-data.

- You will need one hidden input for the ``id`` property, which is only needed for editting and deleting data.
- You will need one text input for the ``text`` property
- You will need one text input for the ``title`` property

Create the file ``/module/Blog/src/Blog/Form/BlogFieldset.php`` and add the following code:

.. code-block:: php
   :linenos:
   :emphasize-lines:

    <?php
    // Filename: /module/Blog/src/Blog/Form/BlogFieldset.php
    namespace Blog\Form;

    use Zend\Form\Fieldset;

    class BlogFieldset extends Fieldset
    {
        public function __construct()
        {
            $this->add(array(
                'type' => 'hidden',
                'name' => 'id'
            ));

            $this->add(array(
                'type' => 'text',
                'name' => 'text',
                'options' => array(
                    'label' => 'The Text'
                )
            ));

            $this->add(array(
                'type' => 'text',
                'name' => 'title',
                'options' => array(
                    'label' => 'Blog Title'
                )
            ));
        }
    }

As you can see this class is pretty handy. All we do is to have our class extend ``Zend\Form\Fieldset`` and then we
write a ``__construct()`` method and add all the elements we need to the fieldset. This ``Fieldset`` can now be used by
as many forms as we want. So let's go ahead and create our first ``Form``.


Creating the BlogForm
======================

Now that we have our ``BlogFieldset`` in place, we need to use it inside a ``Form``. We then need to add a Submit-Button
to the form so that the user will be able to submit the data and we're done. So create the ``InsertBlogForm`` within the
same directory under ``/module/Blog/src/Blog/Form/InsertBlogForm`` and add the ``BlogFieldset`` to it:

.. code-block:: php
   :linenos:
   :emphasize-lines: 12, 13

    <?php
    // Filename: /module/Blog/src/Blog/Form/InsertBlogForm.php
    namespace Blog\Form;

    use Zend\Form\Form;

    class InsertBlogForm extends Form
    {
        public function __construct()
        {
            $this->add(array(
                'name' => 'blog-fieldset',
                'type' => 'Blog\Form\BlogFieldset'
            ));

            $this->add(array(
                'type' => 'submit',
                'name' => 'submit',
                'attributes' => array(
                    'value' => 'Insert new Blog'
                )
            ));
        }
    }

And that's our form. Nothing special here, we add our ``BlogFieldset`` to the Form, we add a submit button to the form
and nothing more. Let's now make use of the Form.


Adding a new Blog
==================

Now that we have the ``BlogForm`` written we want to use it. But there's a couple more tasks that you need to do.
The tasks that are standing right in front of you are:

- create a new controller ``WriteController``
- add ``BlogService`` as a dependency to the ``WriteController``
- add ``BlogForm`` as a dependency to the ``WriteController``
- create a new route ``blog/add`` that routes to the ``WriteController`` and its ``addAction()``
- create a new view that displays the form


Creating the WriteController
----------------------------

As you can see from the task-list we need a new controller and this controller is supposed to have two dependencies.
One dependency being the ``BlogService`` that's also being used within our ``ListController`` and the other dependency
being the ``BlogForm`` which is new. Since the ``BlogForm`` is a dependency that the ``ListController`` doesn't
need to display blog-data, we will create a new controller to keep things properly separated. First, register a
controller-factory within the configuration:

.. code-block:: php
   :linenos:
   :emphasize-lines: 10

    <?php
    // Filename: /module/Blog/config/module.config.php
    return array(
        'db'              => array( /** DB Config */ ),
        'service_manager' => array( /** ServiceManager Config */),
        'view_manager'    => array( /** ViewManager Config */ ),
        'controllers'     => array(
            'factories' => array(
                'Blog\Controller\List'  => 'Blog\Factory\ListControllerFactory',
                'Blog\Controller\Write' => 'Blog\Factory\WriteControllerFactory'
            )
        ),
        'router'          => array( /** Router Config */ )
    );

Nest step would be to write the ``WriteControllerFactory``. Have the factory return the ``WriteController`` and add the
required dependencies within the constructor.

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Blog/src/Blog/Factory/WriteControllerFactory.php
    namespace Blog\Factory;

    use Blog\Controller\WriteController;
    use Zend\ServiceManager\FactoryInterface;
    use Zend\ServiceManager\ServiceLocatorInterface;

    class WriteControllerFactory implements FactoryInterface
    {
        public function createService(ServiceLocatorInterface $serviceLocator)
        {
            $realServiceLocator = $serviceLocator->getServiceLocator();
            $blogService       = $realServiceLocator->get('Blog\Service\BlogServiceInterface');
            $blogInsertForm    = $realServiceLocator->get('FormElementManager')->get('Blog\Form\BlogForm');

            return new WriteController(
                $blogService,
                $blogInsertForm
            );
        }
    }

In this code-example there's a couple of things to be aware of. First, the ``WriteController`` doesn't exist yet, but we
will create this in the next step so we're just assuming that it will exist later on. Second we access the
``FormElementManager`` to get access to our ``BlogForm``. All forms should be accessed through the ``FormElementManager``.
Even though we haven't registered the ``BlogForm`` in our config files yet the ``FormElementManager`` automatically knows
about forms that act as ``invokables``. As long as you have no dependencies you don't need to register them explicitly.

Next up is the creation of our controller. Be sure to type hint the dependencies by their interfaces and to add the
``addAction()``!

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Blog/src/Blog/Controller/WriteController.php
    namespace Blog\Controller;

    use Blog\Service\BlogServiceInterface;
    use Zend\Form\FormInterface;
    use Zend\Mvc\Controller\AbstractActionController;

    class WriteController extends AbstractActionController
    {
        protected $blogService;

        protected $blogForm;

        public function __construct(
            BlogServiceInterface $blogService,
            FormInterface $blogForm
        ) {
            $this->blogService = $blogService;
            $this->blogForm    = $blogForm;
        }

        public function addAction()
        {
        }
    }

Right on to creating the new route:

.. code-block:: php
   :linenos:
   :emphasize-lines: 33-42

    <?php
    // Filename: /module/Blog/config/module.config.php
    return array(
        'db'              => array( /** Db Config */ ),
        'service_manager' => array( /** ServiceManager Config */ ),
        'view_manager'    => array( /** ViewManager Config */ ),
        'controllers'     => array( /** Controller Config */ ),
        'router'          => array(
            'routes' => array(
                'blog' => array(
                    'type' => 'literal',
                    'options' => array(
                        'route'    => '/blog',
                        'defaults' => array(
                            'controller' => 'Blog\Controller\List',
                            'action'     => 'index',
                        )
                    ),
                    'may_terminate' => true,
                    'child_routes'  => array(
                        'detail' => array(
                            'type' => 'segment',
                            'options' => array(
                                'route'    => '/:id',
                                'defaults' => array(
                                    'action' => 'detail'
                                ),
                                'constraints' => array(
                                    'id' => '\d+'
                                )
                            )
                        ),
                        'add' => array(
                            'type' => 'literal',
                            'options' => array(
                                'route'    => '/add',
                                'defaults' => array(
                                    'controller' => 'Blog\Controller\Write',
                                    'action'     => 'add'
                                )
                            )
                        )
                    )
                )
            )
        )
    );

And lastly let's create a dummy template:

.. code-block:: html
   :linenos:

    <!-- Filename: /module/Blog/view/blog/write/add.phtml -->
    <h1>WriteController::addAction()</h1>

**Checking the current status**

If you try to access the new route ``localhost:8080/blog/insert`` you're supposed to see the following error message:

.. code-block:: text
   :linenos:

    Fatal error: Call to a member function insert() on a non-object in
    {libraryPath}/Zend/Form/Fieldset.php on line {lineNumber}

If this is not the case, be sure to follow the tutorial correctly and carefully check all your files. Assuming you are
getting this error, let's find out what it means and fix it!


The above error message is very common and it's solution isn't that intuitive. It appears that there is an error within
the ``Zend/Form/Fieldset.php`` but that's not the case. The error message let's you know that something didn't go right
while you were creating your form. In fact, while creating both the ``BlogForm`` as well as the ``BlogFieldset`` we
have forgotten something very, very important.

.. note::

    When overwriting a ``__construct()`` method within the ``Zend\Form``-component, be sure to always call
    ``parent::__construct()``!

Without this, forms and fieldsets will not be able to get initiated correctly. Let's now fix
the problem by calling the parents constructor in both form and fieldset. To have more flexibility we will also
include the signature of the ``__construct()`` function which accepts a couple of parameters.

.. code-block:: php
   :linenos:
   :emphasize-lines: 9, 11

    <?php
    // Filename: /module/Blog/src/Blog/Form/InsertBlogForm.php
    namespace Blog\Form;

    use Zend\Form\Form;

    class BlogForm extends Form
    {
        public function __construct($name = null, $options = array())
        {
            parent::__construct($name, $options);

            $this->add(array(
                'name' => 'blog-fieldset',
                'type' => 'Blog\Form\BlogFieldset'
            ));

            $this->add(array(
                'type' => 'submit',
                'name' => 'submit',
                'attributes' => array(
                    'value' => 'Insert new Blog'
                )
            ));
        }
    }

As you can see our ``BlogForm`` now accepts two parameters to give our form a name and to set a couple of options. Both
parameters will be passed along to the parent. If you look closely at how we add the ``BlogFieldset`` to the form you'll
notice that we assign a name to the fieldset. Those options will be passed from the ``FormElementManager`` when the
``BlogFieldset`` is created. But for this to function we need to do the same step inside our fieldset, too:

.. code-block:: php
   :linenos:
   :emphasize-lines: 9, 11

    <?php
    // Filename: /module/Blog/src/Blog/Form/BlogFieldset.php
    namespace Blog\Form;

    use Zend\Form\Fieldset;

    class BlogFieldset extends Fieldset
    {
        public function __construct($name = null, $options = array())
        {
            parent::__construct($name, $options);

            $this->add(array(
                'type' => 'hidden',
                'name' => 'id'
            ));

            $this->add(array(
                'type' => 'text',
                'name' => 'text',
                'options' => array(
                    'label' => 'The Text'
                )
            ));

            $this->add(array(
                'type' => 'text',
                'name' => 'title',
                'options' => array(
                    'label' => 'Blog Title'
                )
            ));
        }
    }

Reloading your application now will yield you the desired result.


Displaying the form
===================

Now that we have our ``BlogForm`` within our ``WriteController`` it's time to pass this form to the view and have
it rendered using the provided ``ViewHelpers`` from the ``Zend\Form`` component. First change your controller so that the
form is passed to the view.

.. code-block:: php
   :linenos:
   :emphasize-lines: 8, 26-28

    <?php
    // Filename: /module/Blog/src/Blog/Controller/WriteController.php
    namespace Blog\Controller;

    use Blog\Service\BlogServiceInterface;
    use Zend\Form\FormInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class WriteController extends AbstractActionController
    {
        protected $blogService;

        protected $blogForm;

        public function __construct(
            BlogServiceInterface $blogService,
            FormInterface $blogForm
        ) {
            $this->blogService = $blogService;
            $this->blogForm    = $blogForm;
        }

        public function addAction()
        {
            return new ViewModel(array(
                'form' => $this->blogForm
            ));
        }
    }

And then we need to modify our view to have the form rendered.


.. code-block:: php
   :linenos:
   :emphasize-lines: 3-13

    <!-- Filename: /module/Blog/view/blog/write/add.phtml -->
    <h1>WriteController::addAction()</h1>
    <?php
    $form = $this->form;
    $form->setAttribute('method', 'POST');
    $form->setAttribute('action', $this->url());
    $form->prepare();

    echo $this->form()->openTag($form);

    echo $this->formCollection($form);

    echo $this->form()->closeTag();

We do a couple of different things in here. Firstly, we tell the form that it is supposed to use the ``POST`` method
rather than ``GET``. Then we tell the form that it should send it's data to the current URL and then we tell the form to
``prepare()`` itself which triggers a couple of internal things.

Next we're using a couple of ``ViewHelpers`` which take care of rendering the form for us. There's many different ways to
render a form within Zend Framework but using ``formCollection()`` is probably the fastest one.

Refreshing the browser you will now see your form properly displayed. However if we're submitting the form all we see
is our form being displayed again. And this is due to the simple fact that we didn't add any logic to the controller
yet.


Controller Logic for basically all Forms
========================================

Writing a Controller that handles a form workflow is pretty simple and it's basically identical for each and every
form you have within your application.

1. You want to check if the current request is a POST-Request, meaning if the form has been sent
2. If the form has been sent, you want to:
    - store the POST-Data within the Form
    - check if the form passes validation
3. If the form passes validation, you want to:
    - pass the form data to your service to have it stored
    - redirect the user to either the detail page of the entered data or to some overview page
4. In all other cases, you want the form displayed, sometimes alongside given error messages

And all of this is really not that much code. Modify your ``WriteController`` to the following code:

.. code-block:: php
   :linenos:
   :emphasize-lines: 26-40

    <?php
    // Filename: /module/Blog/src/Blog/Controller/WriteController.php
    namespace Blog\Controller;

    use Blog\Service\BlogServiceInterface;
    use Zend\Form\FormInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class WriteController extends AbstractActionController
    {
        protected $blogService;

        protected $blogForm;

        public function __construct(
            BlogServiceInterface $blogService,
            FormInterface $blogForm
        ) {
            $this->blogService = $blogService;
            $this->blogForm    = $blogForm;
        }

        public function addAction()
        {
            $request = $this->getRequest();

            if ($request->isPost()) {
                $this->blogForm->setData($request->getPost());

                if ($this->blogForm->isValid()) {
                    try {
                        $this->blogService->saveBlog($this->blogForm->getData());

                        return $this->redirect()->toRoute('blog');
                    } catch (\Exception $e) {
                        // Some DB Error happened, log it and let the user know
                    }
                }
            }

            return new ViewModel(array(
                'form' => $this->blogForm
            ));
        }
    }

This example code should be pretty straight forward. First we save the current request into a local variable. Then we
check if the current request ist a POST-Request and if so, we store the requests POST-data into the form. If the form
turns out to be valid we try to save the form data through our service and then redirect the user to the route ``blog``.
If any error occurred at any point we simply display the form again.

Submitting the form right now will return into the following error

.. code-block:: text
   :linenos:

    Fatal error: Call to undefined method Blog\Service\BlogService::saveBlog() in
    /module/Blog/src/Blog/Controller/WriteController.php on line 33

Let's fix this by extending our ``BlogService``. Be sure to also change the signature of the ``BlogServiceInterface``!

.. code-block:: php
   :linenos:
   :emphasize-lines: 32

    <?php
    // Filename: /module/Blog/src/Blog/Service/BlogServiceInterface.php
    namespace Blog\Service;

    use Blog\Model\BlogInterface;

    interface BlogServiceInterface
    {
        /**
         * Should return a set of all blogs that we can iterate over. Single entries of the array or \Traversable object
         * should be of type \Blog\Model\Blog
         *
         * @return array|BlogInterface[]
         */
        public function findAllBlogs();

        /**
         * Should return a single blog
         *
         * @param  int $id Identifier of the Blog that should be returned
         * @return BlogInterface
         */
        public function findBlog($id);

        /**
         * Should save a given implementation of the BlogInterface and return it. If it is an existing Blog the Blog
         * should be updated, if it's a new Blog it should be created.
         *
         * @param  BlogInterface $blog
         * @return BlogInterface
         */
        public function saveBlog(BlogInterface $blog);
    }

We changed our interface slightly to typehint against the ``BlogInterface`` rather than against it's implementation. The
``saveBlog()`` function has been added and needs to be implemented within the ``BlogService`` now.

.. code-block:: php
   :linenos:
   :emphasize-lines: 42-45

    <?php
    // Filename: /module/Blog/src/Blog/Service/BlogService.php
    namespace Blog\Service;

    use Blog\Mapper\BlogMapperInterface;
    use Blog\Model\BlogInterface;

    class BlogService implements BlogServiceInterface
    {
        /**
         * @var \Blog\Mapper\BlogMapperInterface
         */
        protected $blogMapper;

        /**
         * @param BlogMapperInterface $blogMapper
         */
        public function __construct(BlogMapperInterface $blogMapper)
        {
            $this->blogMapper = $blogMapper;
        }

        /**
         * @inheritDoc
         */
        public function findAllBlogs()
        {
            return $this->blogMapper->findAll();
        }

        /**
         * @inheritDoc
         */
        public function findBlog($id)
        {
            return $this->blogMapper->find($id);
        }

        /**
         * @inheritDoc
         */
        public function saveBlog(BlogInterface $blog)
        {
            return $this->blogMapper->save($blog);
        }
    }

And now that we're making an assumption against our ``blogMapper`` we need to extend the ``BlogMapperInterface`` and its
implementation, too. Start by extending the interface:

.. code-block:: php
   :linenos:
   :emphasize-lines: 28

    <?php
    // Filename: /module/Blog/src/Blog/Mapper/BlogMapperInterface.php
    namespace Blog\Mapper;

    use Blog\Model\BlogInterface;

    interface BlogMapperInterface
    {
        /**
         * @param int|string $id
         * @return BlogInterface
         * @throws \InvalidArgumentException
         */
        public function find($id);

        /**
         * @return array|BlogInterface[]
         */
        public function findAll();

        /**
         * @param BlogInterface $blogObject
         *
         * @param BlogInterface $blogObject
         * @return BlogInterface
         * @throws \Exception
         */
        public function save(BlogInterface $blogObject);
    }

And now the implementation of the save function.

.. code-block:: php
   :linenos:
   :emphasize-lines: 88-118

    <?php
    // Filename: /module/Blog/src/Blog/Mapper/ZendDbSqlMapper.php
    namespace Blog\Mapper;

    use Blog\Model\BlogInterface;
    use Zend\Db\Adapter\AdapterInterface;
    use Zend\Db\Adapter\Driver\ResultInterface;
    use Zend\Db\ResultSet\HydratingResultSet;
    use Zend\Db\Sql\Insert;
    use Zend\Db\Sql\Sql;
    use Zend\Db\Sql\Update;
    use Zend\Stdlib\Hydrator\HydratorInterface;

    class ZendDbSqlMapper implements BlogMapperInterface
    {
        /**
         * @var \Zend\Db\Adapter\AdapterInterface
         */
        protected $dbAdapter;

        protected $hydrator;

        protected $blogPrototype;

        /**
         * @param AdapterInterface  $dbAdapter
         * @param HydratorInterface $hydrator
         * @param BlogInterface    $blogPrototype
         */
        public function __construct(
            AdapterInterface $dbAdapter,
            HydratorInterface $hydrator,
            BlogInterface $blogPrototype
        ) {
            $this->dbAdapter      = $dbAdapter;
            $this->hydrator       = $hydrator;
            $this->blogPrototype = $blogPrototype;
        }

        /**
         * @param int|string $id
         *
         * @return BlogInterface
         * @throws \InvalidArgumentException
         */
        public function find($id)
        {
            $sql    = new Sql($this->dbAdapter);
            $select = $sql->select('blog');
            $select->where(array('id = ?' => $id));

            $stmt   = $sql->prepareStatementForSqlObject($select);
            $result = $stmt->execute();

            if ($result instanceof ResultInterface && $result->isQueryResult() && $result->getAffectedRows()) {
                return $this->hydrator->hydrate($result->current(), $this->blogPrototype);
            }

            throw new \InvalidArgumentException("Blog with given ID:{$id} not found.");
        }

        /**
         * @return array|BlogInterface[]
         */
        public function findAll()
        {
            $sql    = new Sql($this->dbAdapter);
            $select = $sql->select('blog');

            $stmt   = $sql->prepareStatementForSqlObject($select);
            $result = $stmt->execute();

            if ($result instanceof ResultInterface && $result->isQueryResult()) {
                $resultSet = new HydratingResultSet($this->hydrator, $this->blogPrototype);

                return $resultSet->initialize($result);
            }

            return array();
        }

         /**
          * @param BlogInterface $blogObject
          *
          * @return BlogInterface
          * @throws \Exception
          */
         public function save(BlogInterface $blogObject)
         {
             $blogData = $this->hydrator->extract($blogObject);
             unset($blogData['id']); // Neither Insert nor Update needs the ID in the array

             if ($blogObject->getId()) {
                 // ID present, it's an Update
                 $action = new Update('blog');
                 $action->set($blogData);
                 $action->where(array('id = ?' => $blogObject->getId()));
             } else {
                 // ID NOT present, it's an Insert
                 $action = new Insert('blog');
                 $action->values($blogData);
             }

             $sql    = new Sql($this->dbAdapter);
             $stmt   = $sql->prepareStatementForSqlObject($action);
             $result = $stmt->execute();

             if ($result instanceof ResultInterface) {
                 if ($newId = $result->getGeneratedValue()) {
                     // When a value has been generated, set it on the object
                     $blogObject->setId($newId);
                 }

                 return $blogObject;
             }

             throw new \Exception("Database error");
         }
    }

The ``save()`` function handles two cases. The ``insert`` and ``update`` routine. Firstly we extract the ``Blog``-Object since
we need array data to work with ``Insert`` and ``Update``. Then we remove the ``id`` from the array since this field is not
wanted. When we do an update of a row, we don't update the ``id`` property itself and therefore she isn't needed. On the
insert routine we don't need an ``id`` either so we can simply strip it away.

After the ``id`` field has been removed we check what action is supposed to be called. If the ``Blog``-Object has an ``id``
set we create a new ``Update``-Object and if not we create a new ``Insert``-Object. We set the data for both actions
accordingly and after that the data is passed over to the ``Sql``-Object for the actual query into the database.

At last we check if we receive a valid result and if there has been an ``id`` generated. If it's the case we call the
``setId()``-function of our blog and return the object in the end.

Let's submit our form again and see what we get.

.. code-block:: text
   :linenos:

    Catchable fatal error: Argument 1 passed to Blog\Service\BlogService::saveBlog()
    must implement interface Blog\Model\BlogInterface, array given,
    called in /module/Blog/src/Blog/Controller/InsertController.php on line 33
    and defined in /module/Blog/src/Blog/Service/BlogService.php on line 49

Forms, per default, give you data in an array format. But our ``BlogService`` expects the format to be an implementation
of the ``BlogInterface``. This means we need to find a way to have this array data become object data. If you recall the
previous chapter, this is done through the use of hydrators.


Zend\\Form and Zend\\Stdlib\\Hydrator working together
======================================================

Before we go ahead and put the hydrator into the form, let's first do a data-dump of the data coming from the form. That
way we can easily notice all changes that the hydrator does. Modify your ``WriteController`` to the following:

.. code-block:: php
   :linenos:
   :emphasize-lines: 33

    <?php
    // Filename: /module/Blog/src/Blog/Controller/WriteController.php
    namespace Blog\Controller;

    use Blog\Service\BlogServiceInterface;
    use Zend\Form\FormInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class WriteController extends AbstractActionController
    {
        protected $blogService;

        protected $blogForm;

        public function __construct(
            BlogServiceInterface $blogService,
            FormInterface $blogForm
        ) {
            $this->blogService = $blogService;
            $this->blogForm    = $blogForm;
        }

        public function addAction()
        {
            $request = $this->getRequest();

            if ($request->isPost()) {
                $this->blogForm->setData($request->getPost());

                if ($this->blogForm->isValid()) {
                    try {
                        \Zend\Debug\Debug::dump($this->blogForm->getData());die();
                        $this->blogService->saveBlog($this->blogForm->getData());

                        return $this->redirect()->toRoute('blog');
                    } catch (\Exception $e) {
                        // Some DB Error happened, log it and let the user know
                    }
                }
            }

            return new ViewModel(array(
                'form' => $this->blogForm
            ));
        }
    }

With this set up go ahead and submit the form once again. You should now see a data dump like the following:

.. code-block:: text
   :linenos:

    array(2) {
      ["submit"] => string(16) "Insert new Blog"
      ["blog-fieldset"] => array(3) {
        ["id"] => string(0) ""
        ["text"] => string(3) "foo"
        ["title"] => string(3) "bar"
      }
    }

Now telling your fieldset to hydrate it's data into an ``Blog``-object is very simple. All you need to do is to assign
the hydrator and the object prototype like this:

.. code-block:: php
   :linenos:
   :emphasize-lines: 5, 7, 15, 16

    <?php
    // Filename: /module/Blog/src/Blog/Form/BlogFieldset.php
    namespace Blog\Form;

    use Blog\Model\Blog;
    use Zend\Form\Fieldset;
    use Zend\Stdlib\Hydrator\ClassMethods;

    class BlogFieldset extends Fieldset
    {
        public function __construct($name = null, $options = array())
        {
            parent::__construct($name, $options);

            $this->setHydrator(new ClassMethods(false));
            $this->setObject(new Blog());

            $this->add(array(
                'type' => 'hidden',
                'name' => 'id'
            ));

            $this->add(array(
                'type' => 'text',
                'name' => 'text',
                'options' => array(
                    'label' => 'The Text'
                )
            ));

            $this->add(array(
                'type' => 'text',
                'name' => 'title',
                'options' => array(
                    'label' => 'Blog Title'
                )
            ));
        }
    }

As you can see we're doing two things. We tell the fieldset to be using the ``ClassMethods`` hydrator and then we tell the
fieldset that the default object to be returned is our ``Blog``-Model. However when you're re-submitting the form now
you'll notice that nothing has changed. We're still only getting array data returned and no object.

This is due to the fact that the form itself doesn't know that it has to return an object. When the form doesn't know
that it's supposed to return an object it uses the ``ArraySeriazable`` hydrator recursively. To change this, all we need
to do is to make our ``BlogFieldset`` a so-called ``base_fieldset``.

A ``base_fieldset`` basically tells the form "this form is all about me, don't worry about other data, just worry about
me". And when the form knows that this fieldset is the real deal, then the form will use the hydrator presented by the
fieldset and return the object that we desire. Modify your ``BlogForm`` and assign the ``BlogFieldset`` as
``base_fieldset``:

.. code-block:: php
   :linenos:
   :emphasize-lines: 16-18

    <?php
    // Filename: /module/Blog/src/Blog/Form/InsertBlogForm.php
    namespace Blog\Form;

    use Zend\Form\Form;

    class BlogForm extends Form
    {
        public function __construct($name = null, $options = array())
        {
            parent::__construct($name, $options);

            $this->add(array(
                'name' => 'blog-fieldset',
                'type' => 'Blog\Form\BlogFieldset',
                'options' => array(
                    'use_as_base_fieldset' => true
                )
            ));

            $this->add(array(
                'type' => 'submit',
                'name' => 'submit',
                'attributes' => array(
                    'value' => 'Insert new Blog'
                )
            ));
        }
    }

Now submit your form again. You should see the following output:

.. code-block:: text
   :linenos:

    object(Blog\Model\Blog)#294 (3) {
      ["id":protected] => string(0) ""
      ["title":protected] => string(3) "foo"
      ["text":protected] => string(3) "bar"
    }

You can now revert back your ``WriteController`` to it's previous form to have the form-data passed through the
``BlogService``.

.. code-block:: php
   :linenos:
   :emphasize-lines: 33

    <?php
    // Filename: /module/Blog/src/Blog/Controller/WriteController.php
    namespace Blog\Controller;

    use Blog\Service\BlogServiceInterface;
    use Zend\Form\FormInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class WriteController extends AbstractActionController
    {
        protected $blogService;

        protected $blogForm;

        public function __construct(
            BlogServiceInterface $blogService,
            FormInterface $blogForm
        ) {
            $this->blogService = $blogService;
            $this->blogForm    = $blogForm;
        }

        public function addAction()
        {
            $request = $this->getRequest();

            if ($request->isPost()) {
                $this->blogForm->setData($request->getPost());

                if ($this->blogForm->isValid()) {
                    try {
                        $this->blogService->saveBlog($this->blogForm->getData());

                        return $this->redirect()->toRoute('blog');
                    } catch (\Exception $e) {
                        // Some DB Error happened, log it and let the user know
                    }
                }
            }

            return new ViewModel(array(
                'form' => $this->blogForm
            ));
        }
    }

If you send the form now you'll now be able to add as many new blogs as you want. Great!


Conclusion
==========

In this chapter you've learned a great deal about the ``Zend\Form`` component. You've learned that ``Zend\Stdlib\Hydrator``
takes a big part within the ``Zend\Form`` component and by making use of both components you've been able to create an
insert form for the blog module.

In the next chapter we will finalize the CRUD functionality by creating the update and delete routines for the blog
module.