Making use of Forms and Fieldsets
=================================

So far all we did was read data from the database. In a real-life-application this won't get us very far as very often
the least we need to do is to support full ``Create``, ``Read``, ``Update`` and ``Delete`` operations (CRUD). Most
often the process of getting data into our database is that a user enters the data into a web ``<form>`` and the
application then uses the user input saves it into our backend.

We want to be able to do exactly this and Zend Framework provides us with all the tools we need to achieve our goal.
Before we jump into coding, we need to understand the two core components for this task first. So let's take a look at
what these components are and what they are used for.

Zend\\Form\\Fieldset
--------------------

The first component that you have to know about is ``Zend\Form\Fieldset``. A ``Fieldset`` is a component that contains a
reusable set of elements. You will use the ``Fieldset`` to create the frontend-input for your backend-models. It is
considered good practice to have one ``Fieldset`` for every ``Model`` of your application.

The ``Fieldset``-component, however, is no ``Form``, meaning you will not be able to use a ``Fieldset`` without attaching it
to the ``Form``-component. The advantage here is that you have one set of elements that you can re-use for as many
``Forms`` as you like without having to re-declare all the inputs for the ``Model`` that's represented by the ``Fieldset``.

Zend\\Form\\Form
----------------

The main component you'll need and that most probably you've heard about already is ``Zend\Form\Form``. The
``Form``-component is the main container for all elements of your web ``<form>``. You are able to add single
elements or a set of elements in the form of a ``Fieldset``, too.


Creating your first Fieldset
============================

Explaining how the ``Zend\Form`` component works is best done by giving you real code to work with. So let's jump right
into it and create all the forms we need to finish our ``Blog`` module. We start by creating a ``Fieldset`` that contains
all the input elements that we need to work with our ``Blog``-data.

- You will need one hidden input for the ``id`` property, which is only needed for editting and deleting data.
- You will need one text input for the ``text`` property
- You will need one text input for the ``title`` property

Create the file ``/module/Blog/src/Blog/Form/PostFieldset.php`` and add the following code:

.. code-block:: php
   :linenos:
   :emphasize-lines:

    <?php
    // Filename: /module/Blog/src/Blog/Form/PostFieldset.php
    namespace Blog\Form;

    use Zend\Form\Fieldset;

    class PostFieldset extends Fieldset
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


Creating the PostForm
=====================

Now that we have our ``PostFieldset`` in place, we need to use it inside a ``Form``. We then need to add a Submit-Button
to the form so that the user will be able to submit the data and we're done. So create the ``PostForm`` within the
same directory under ``/module/Blog/src/Blog/Form/PostForm`` and add the ``PostFieldset`` to it:

.. code-block:: php
   :linenos:
   :emphasize-lines: 12, 13

    <?php
    // Filename: /module/Blog/src/Blog/Form/PostForm.php
    namespace Blog\Form;

    use Zend\Form\Form;

    class PostForm extends Form
    {
        public function __construct()
        {
            $this->add(array(
                'name' => 'post-fieldset',
                'type' => 'Blog\Form\PostFieldset'
            ));

            $this->add(array(
                'type' => 'submit',
                'name' => 'submit',
                'attributes' => array(
                    'value' => 'Insert new Post'
                )
            ));
        }
    }

And that's our form. Nothing special here, we add our ``PostFieldset`` to the Form, we add a submit button to the form
and nothing more. Let's now make use of the Form.


Adding a new Post
=================

Now that we have the ``PostForm`` written we want to use it. But there are a couple more tasks that you need to do.
The tasks that are standing right in front of you are:

- create a new controller ``WriteController``
- add ``PostService`` as a dependency to the ``WriteController``
- add ``PostForm`` as a dependency to the ``WriteController``
- create a new route ``blog/add`` that routes to the ``WriteController`` and its ``addAction()``
- create a new view that displays the form


Creating the WriteController
----------------------------

As you can see from the task-list we need a new controller and this controller is supposed to have two dependencies.
One dependency being the ``PostService`` that's also being used within our ``ListController`` and the other dependency
being the ``PostForm`` which is new. Since the ``PostForm`` is a dependency that the ``ListController`` doesn't
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
            $postService        = $realServiceLocator->get('Blog\Service\PostServiceInterface');
            $postInsertForm     = $realServiceLocator->get('FormElementManager')->get('Blog\Form\PostForm');

            return new WriteController(
                $postService,
                $postInsertForm
            );
        }
    }

In this code-example there are a couple of things to be aware of. First, the ``WriteController`` doesn't exist yet, but we
will create this in the next step so we're just assuming that it will exist later on. Second, we access the
``FormElementManager`` to get access to our ``PostForm``. All forms should be accessed through the ``FormElementManager``.
Even though we haven't registered the ``PostForm`` in our config files yet the ``FormElementManager`` automatically knows
about forms that act as ``invokables``. As long as you have no dependencies you don't need to register them explicitly.

Next up is the creation of our controller. Be sure to type hint the dependencies by their interfaces and to add the
``addAction()``!

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Blog/src/Blog/Controller/WriteController.php
    namespace Blog\Controller;

    use Blog\Service\PostServiceInterface;
    use Zend\Form\FormInterface;
    use Zend\Mvc\Controller\AbstractActionController;

    class WriteController extends AbstractActionController
    {
        protected $postService;

        protected $postForm;

        public function __construct(
            PostServiceInterface $postService,
            FormInterface $postForm
        ) {
            $this->postService = $postService;
            $this->postForm    = $postForm;
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

If you try to access the new route ``localhost:8080/blog/add`` you're supposed to see the following error message:

.. code-block:: text
   :linenos:

    Fatal error: Call to a member function insert() on a non-object in
    {libraryPath}/Zend/Form/Fieldset.php on line {lineNumber}

If this is not the case, be sure to follow the tutorial correctly and carefully check all your files. Assuming you are
getting this error, let's find out what it means and fix it!


The above error message is very common and its solution isn't that intuitive. It appears that there is an error within
the ``Zend/Form/Fieldset.php`` but that's not the case. The error message let's you know that something didn't go right
while you were creating your form. In fact, while creating both the ``PostForm`` as well as the ``PostFieldset`` we
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
    // Filename: /module/Blog/src/Blog/Form/PostForm.php
    namespace Blog\Form;

    use Zend\Form\Form;

    class PostForm extends Form
    {
        public function __construct($name = null, $options = array())
        {
            parent::__construct($name, $options);

            $this->add(array(
                'name' => 'post-fieldset',
                'type' => 'Blog\Form\PostFieldset'
            ));

            $this->add(array(
                'type' => 'submit',
                'name' => 'submit',
                'attributes' => array(
                    'value' => 'Insert new Post'
                )
            ));
        }
    }

As you can see our ``PostForm`` now accepts two parameters to give our form a name and to set a couple of options. Both
parameters will be passed along to the parent. If you look closely at how we add the ``PostFieldset`` to the form you'll
notice that we assign a name to the fieldset. Those options will be passed from the ``FormElementManager`` when the
``PostFieldset`` is created. But for this to function we need to do the same step inside our fieldset, too:

.. code-block:: php
   :linenos:
   :emphasize-lines: 9, 11

    <?php
    // Filename: /module/Blog/src/Blog/Form/PostFieldset.php
    namespace Blog\Form;

    use Zend\Form\Fieldset;

    class PostFieldset extends Fieldset
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

Now that we have our ``PostForm`` within our ``WriteController`` it's time to pass this form to the view and have
it rendered using the provided ``ViewHelpers`` from the ``Zend\Form`` component. First change your controller so that the
form is passed to the view.

.. code-block:: php
   :linenos:
   :emphasize-lines: 8, 26-28

    <?php
    // Filename: /module/Blog/src/Blog/Controller/WriteController.php
    namespace Blog\Controller;

    use Blog\Service\PostServiceInterface;
    use Zend\Form\FormInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class WriteController extends AbstractActionController
    {
        protected $postService;

        protected $postForm;

        public function __construct(
            PostServiceInterface $postService,
            FormInterface $postForm
        ) {
            $this->postService = $postService;
            $this->postForm    = $postForm;
        }

        public function addAction()
        {
            return new ViewModel(array(
                'form' => $this->postForm
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
    $form->setAttribute('action', $this->url());
    $form->prepare();

    echo $this->form()->openTag($form);

    echo $this->formCollection($form);

    echo $this->form()->closeTag();

Firstly, we tell the form that it should send its data to the current URL and then we tell the form to ``prepare()``
itself which triggers a couple of internal things.

.. note::

    HTML-Forms can be sent using ``POST`` and ``GET``. ZF2s default is ``POST``, therefore you don't have to be
    explicit in setting this options. If you want to change it to ``GET`` though, all you have to do is to set the
    specific attribute prior to the ``prepare()`` call.

    ``$form->setAttribute('method', 'GET');``

Next we're using a couple of ``ViewHelpers`` which take care of rendering the form for us. There are many different ways
to render a form within Zend Framework but using ``formCollection()`` is probably the fastest one.

Refreshing the browser you will now see your form properly displayed. However, if we're submitting the form all we see
is our form being displayed again. And this is due to the simple fact that we didn't add any logic to the controller
yet.

.. note::

    Keep in mind that this tutorial focuses solely on the OOP aspect of things. Rendering the form like this, without
    any stylesheets added doesn't really reflect most designers' idea of a beautiful form. You'll find out more about
    the rendering of forms in the chapter of :ref:`Zend\\Form\\View\\Helper <zend.form.view.helpers>`.


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

    use Blog\Service\PostServiceInterface;
    use Zend\Form\FormInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class WriteController extends AbstractActionController
    {
        protected $postService;

        protected $postForm;

        public function __construct(
            PostServiceInterface $postService,
            FormInterface $postForm
        ) {
            $this->postService = $postService;
            $this->postForm    = $postForm;
        }

        public function addAction()
        {
            $request = $this->getRequest();

            if ($request->isPost()) {
                $this->postForm->setData($request->getPost());

                if ($this->postForm->isValid()) {
                    try {
                        $this->postService->savePost($this->postForm->getData());

                        return $this->redirect()->toRoute('post');
                    } catch (\Exception $e) {
                        // Some DB Error happened, log it and let the user know
                    }
                }
            }

            return new ViewModel(array(
                'form' => $this->postForm
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

    Fatal error: Call to undefined method Blog\Service\PostService::savePost() in
    /module/Blog/src/Blog/Controller/WriteController.php on line 33

Let's fix this by extending our ``PostService``. Be sure to also change the signature of the ``PostServiceInterface``!

.. code-block:: php
   :linenos:
   :emphasize-lines: 32

    <?php
    // Filename: /module/Blog/src/Blog/Service/PostServiceInterface.php
    namespace Blog\Service;

    use Blog\Model\PostInterface;

    interface PostServiceInterface
    {
        /**
         * Should return a set of all blog posts that we can iterate over. Single entries of the array are supposed to be
         * implementing \Blog\Model\PostInterface
         *
         * @return array|PostInterface[]
         */
        public function findAllPosts();

        /**
         * Should return a single blog post
         *
         * @param  int $id Identifier of the Post that should be returned
         * @return PostInterface
         */
        public function findPost($id);

        /**
         * Should save a given implementation of the PostInterface and return it. If it is an existing Post the Post
         * should be updated, if it's a new Post it should be created.
         *
         * @param  PostInterface $blog
         * @return PostInterface
         */
        public function savePost(PostInterface $blog);
    }

As you can see the ``savePost()`` function has been added and needs to be implemented within the ``PostService`` now.

.. code-block:: php
   :linenos:
   :emphasize-lines: 42-45

    <?php
    // Filename: /module/Blog/src/Blog/Service/PostService.php
    namespace Blog\Service;

    use Blog\Mapper\PostMapperInterface;
    use Blog\Model\PostInterface;

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

        /**
         * {@inheritDoc}
         */
        public function savePost(PostInterface $post)
        {
            return $this->postMapper->save($post);
        }
    }

And now that we're making an assumption against our ``postMapper`` we need to extend the ``PostMapperInterface`` and its
implementation, too. Start by extending the interface:

.. code-block:: php
   :linenos:
   :emphasize-lines: 28

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

        /**
         * @param PostInterface $postObject
         *
         * @param PostInterface $postObject
         * @return PostInterface
         * @throws \Exception
         */
        public function save(PostInterface $postObject);
    }

And now the implementation of the save function.

.. code-block:: php
   :linenos:
   :emphasize-lines: 88-118

    <?php
    // Filename: /module/Blog/src/Blog/Mapper/ZendDbSqlMapper.php
    namespace Blog\Mapper;

    use Blog\Model\PostInterface;
    use Zend\Db\Adapter\AdapterInterface;
    use Zend\Db\Adapter\Driver\ResultInterface;
    use Zend\Db\ResultSet\HydratingResultSet;
    use Zend\Db\Sql\Insert;
    use Zend\Db\Sql\Sql;
    use Zend\Db\Sql\Update;
    use Zend\Stdlib\Hydrator\HydratorInterface;

    class ZendDbSqlMapper implements PostMapperInterface
    {
        /**
         * @var \Zend\Db\Adapter\AdapterInterface
         */
        protected $dbAdapter;

        /**
         * @var \Zend\Stdlib\Hydrator\HydratorInterface
         */
        protected $hydrator;

        /**
         * @var \Blog\Model\PostInterface
         */
        protected $blogPrototype;

        /**
         * @param AdapterInterface  $dbAdapter
         * @param HydratorInterface $hydrator
         * @param PostInterface    $postPrototype
         */
        public function __construct(
            AdapterInterface $dbAdapter,
            HydratorInterface $hydrator,
            PostInterface $postPrototype
        ) {
            $this->dbAdapter      = $dbAdapter;
            $this->hydrator       = $hydrator;
            $this->postPrototype  = $postPrototype;
        }

        /**
         * @param int|string $id
         *
         * @return PostInterface
         * @throws \InvalidArgumentException
         */
        public function find($id)
        {
            $sql    = new Sql($this->dbAdapter);
            $select = $sql->select('posts');
            $select->where(array('id = ?' => $id));

            $stmt   = $sql->prepareStatementForSqlObject($select);
            $result = $stmt->execute();

            if ($result instanceof ResultInterface && $result->isQueryResult() && $result->getAffectedRows()) {
                return $this->hydrator->hydrate($result->current(), $this->postPrototype);
            }

            throw new \InvalidArgumentException("Blog with given ID:{$id} not found.");
        }

        /**
         * @return array|PostInterface[]
         */
        public function findAll()
        {
            $sql    = new Sql($this->dbAdapter);
            $select = $sql->select('posts');

            $stmt   = $sql->prepareStatementForSqlObject($select);
            $result = $stmt->execute();

            if ($result instanceof ResultInterface && $result->isQueryResult()) {
                $resultSet = new HydratingResultSet($this->hydrator, $this->postPrototype);

                return $resultSet->initialize($result);
            }

            return array();
        }

         /**
          * @param PostInterface $postObject
          *
          * @return PostInterface
          * @throws \Exception
          */
         public function save(PostInterface $postObject)
         {
             $postData = $this->hydrator->extract($postObject);
             unset($postData['id']); // Neither Insert nor Update needs the ID in the array

             if ($postObject->getId()) {
                 // ID present, it's an Update
                 $action = new Update('post');
                 $action->set($postData);
                 $action->where(array('id = ?' => $postObject->getId()));
             } else {
                 // ID NOT present, it's an Insert
                 $action = new Insert('post');
                 $action->values($postData);
             }

             $sql    = new Sql($this->dbAdapter);
             $stmt   = $sql->prepareStatementForSqlObject($action);
             $result = $stmt->execute();

             if ($result instanceof ResultInterface) {
                 if ($newId = $result->getGeneratedValue()) {
                     // When a value has been generated, set it on the object
                     $postObject->setId($newId);
                 }

                 return $postObject;
             }

             throw new \Exception("Database error");
         }
    }

The ``save()`` function handles two cases. The ``insert`` and ``update`` routine. Firstly we extract the ``Post``-Object
since we need array data to work with ``Insert`` and ``Update``. Then we remove the ``id`` from the array since this
field is not wanted. When we do an update of a row, we don't update the ``id`` property itself and therefore it isn't
needed. On the insert routine we don't need an ``id`` either so we can simply strip it away.

After the ``id`` field has been removed we check what action is supposed to be called. If the ``Post``-Object has an ``id``
set we create a new ``Update``-Object and if not we create a new ``Insert``-Object. We set the data for both actions
accordingly and after that the data is passed over to the ``Sql``-Object for the actual query into the database.

At last we check if we receive a valid result and if there has been an ``id`` generated. If it's the case we call the
``setId()``-function of our blog and return the object in the end.

Let's submit our form again and see what we get.

.. code-block:: text
   :linenos:

    Catchable fatal error: Argument 1 passed to Blog\Service\PostService::savePost()
    must implement interface Blog\Model\PostInterface, array given,
    called in /module/Blog/src/Blog/Controller/InsertController.php on line 33
    and defined in /module/Blog/src/Blog/Service/PostService.php on line 49

Forms, per default, give you data in an array format. But our ``PostService`` expects the format to be an implementation
of the ``PostInterface``. This means we need to find a way to have this array data become object data. If you recall the
previous chapter, this is done through the use of hydrators.

.. note::

    On the Update-Query you'll notice that we have assigned a condition to only update the row matching a given id

    ``$action->where(array('id = ?' => $postObject->getId()));``

    You'll see here that the condition is: **id equals ?**. With the question-mark being the id of the post-object. In
    the same way you could assign a condition to update (or select) rows with all entries higher than a given id:

    ``$action->where(array('id > ?' => $postObject->getId()));``

    This works for all conditions. ``=``, ``>``, ``<``, ``>=`` and ``<=``


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

    use Blog\Service\PostServiceInterface;
    use Zend\Form\FormInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class WriteController extends AbstractActionController
    {
        protected $postService;

        protected $postForm;

        public function __construct(
            PostServiceInterface $postService,
            FormInterface $postForm
        ) {
            $this->postService = $postService;
            $this->postForm    = $postForm;
        }

        public function addAction()
        {
            $request = $this->getRequest();

            if ($request->isPost()) {
                $this->postForm->setData($request->getPost());

                if ($this->postForm->isValid()) {
                    try {
                        \Zend\Debug\Debug::dump($this->postForm->getData());die();
                        $this->postService->savePost($this->postForm->getData());

                        return $this->redirect()->toRoute('post');
                    } catch (\Exception $e) {
                        // Some DB Error happened, log it and let the user know
                    }
                }
            }

            return new ViewModel(array(
                'form' => $this->postForm
            ));
        }
    }

With this set up go ahead and submit the form once again. You should now see a data dump like the following:

.. code-block:: text
   :linenos:

    array(2) {
      ["submit"] => string(16) "Insert new Post"
      ["post-fieldset"] => array(3) {
        ["id"] => string(0) ""
        ["text"] => string(3) "foo"
        ["title"] => string(3) "bar"
      }
    }

Now telling your fieldset to hydrate its data into an ``Post``-object is very simple. All you need to do is to assign
the hydrator and the object prototype like this:

.. code-block:: php
   :linenos:
   :emphasize-lines: 5, 7, 15, 16

    <?php
    // Filename: /module/Blog/src/Blog/Form/PostFieldset.php
    namespace Blog\Form;

    use Blog\Model\Post;
    use Zend\Form\Fieldset;
    use Zend\Stdlib\Hydrator\ClassMethods;

    class PostFieldset extends Fieldset
    {
        public function __construct($name = null, $options = array())
        {
            parent::__construct($name, $options);

            $this->setHydrator(new ClassMethods(false));
            $this->setObject(new Post());

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
fieldset that the default object to be returned is our ``Blog``-Model. However, when you're re-submitting the form now
you'll notice that nothing has changed. We're still only getting array data returned and no object.

This is due to the fact that the form itself doesn't know that it has to return an object. When the form doesn't know
that it's supposed to return an object it uses the ``ArraySeriazable`` hydrator recursively. To change this, all we need
to do is to make our ``PostFieldset`` a so-called ``base_fieldset``.

A ``base_fieldset`` basically tells the form "this form is all about me, don't worry about other data, just worry about
me". And when the form knows that this fieldset is the real deal, then the form will use the hydrator presented by the
fieldset and return the object that we desire. Modify your ``PostForm`` and assign the ``PostFieldset`` as
``base_fieldset``:

.. code-block:: php
   :linenos:
   :emphasize-lines: 16-18

    <?php
    // Filename: /module/Blog/src/Blog/Form/PostForm.php
    namespace Blog\Form;

    use Zend\Form\Form;

    class PostForm extends Form
    {
        public function __construct($name = null, $options = array())
        {
            parent::__construct($name, $options);

            $this->add(array(
                'name' => 'post-fieldset',
                'type' => 'Blog\Form\PostFieldset',
                'options' => array(
                    'use_as_base_fieldset' => true
                )
            ));

            $this->add(array(
                'type' => 'submit',
                'name' => 'submit',
                'attributes' => array(
                    'value' => 'Insert new Post'
                )
            ));
        }
    }

Now submit your form again. You should see the following output:

.. code-block:: text
   :linenos:

    object(Blog\Model\Post)#294 (3) {
      ["id":protected] => string(0) ""
      ["title":protected] => string(3) "foo"
      ["text":protected] => string(3) "bar"
    }

You can now revert back your ``WriteController`` to its previous form to have the form-data passed through the
``PostService``.

.. code-block:: php
   :linenos:
   :emphasize-lines: 33

    <?php
    // Filename: /module/Blog/src/Blog/Controller/WriteController.php
    namespace Blog\Controller;

    use Blog\Service\PostServiceInterface;
    use Zend\Form\FormInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class WriteController extends AbstractActionController
    {
        protected $postService;

        protected $postForm;

        public function __construct(
            PostServiceInterface $postService,
            FormInterface $postForm
        ) {
            $this->postService = $postService;
            $this->postForm    = $postForm;
        }

        public function addAction()
        {
            $request = $this->getRequest();

            if ($request->isPost()) {
                $this->postForm->setData($request->getPost());

                if ($this->postForm->isValid()) {
                    try {
                        $this->postService->savePost($this->postForm->getData());

                        return $this->redirect()->toRoute('post');
                    } catch (\Exception $e) {
                        // Some DB Error happened, log it and let the user know
                    }
                }
            }

            return new ViewModel(array(
                'form' => $this->postForm
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
