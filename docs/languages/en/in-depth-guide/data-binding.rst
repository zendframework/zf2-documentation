Editting and Deleting Data
==========================

In the previous chapter we've come to learn how we can use the ``Zend\Form``- and ``Zend\Db``-components to create the
functionality of creating new data-sets. This chapter will focus on finalizing the CRUD functionality by introducing
the concepts for editting and deleting data. We start by editting the data.


Binding Objects to Forms
========================

The one fundamental difference between an insert- and an edit-form is the fact that inside an edit-form there is
already data preset. This means we need to find a way to get data from our database into the form. Luckily ``Zend\Form``
provides us with a very handy way of doing so and it's called **data-binding**.

All you need to do when providing an edit-form is to get the object of interest from your service and ``bind`` it to the
form. This is done the following way inside your controller.

.. code-block:: php
   :linenos:
   :emphasize-lines: 50-53

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
                        die($e->getMessage());
                        // Some DB Error happened, log it and let the user know
                    }
                }
            }

            return new ViewModel(array(
                'form' => $this->blogForm
            ));
        }

        public function editAction()
        {
            $request = $this->getRequest();
            $blog   = $this->blogService->findBlog($this->params('id'));

            $this->blogForm->bind($blog);

            if ($request->isPost()) {
                $this->blogForm->setData($request->getPost());

                if ($this->blogForm->isValid()) {
                    try {
                        $this->blogService->saveBlog($blog);

                        return $this->redirect()->toRoute('blog');
                    } catch (\Exception $e) {
                        die($e->getMessage());
                        // Some DB Error happened, log it and let the user know
                    }
                }
            }

            return new ViewModel(array(
                'form' => $this->blogForm
            ));
        }
    }

Compared to the ``addAction()`` the ``editAction()`` has only three different lines. The first one is used to simply get the
relevant ``Blog``-object from the service identified by the ``id``-parameter of the route (which we'll be writing soon).

The second line then shows you how you can bind data to the ``Zend\Form``-Component. We're able to use an object here
because our ``BlogFieldset`` will use the hydrator to display the data coming from the object.

Lastly instead of actually doing ``$form->getData()`` we simply use the previous ``$blog``-variable since it will be
updated with the latest data from the form thanks to the data-binding. And that's all there is to it. The only things
we need to add now is the new edit-route and the view for it.


Adding the edit-route
=====================

The edit route is a normal segment route just like the route ``blog/detail``. Configure your route config to include the
new route:

.. code-block:: php
   :linenos:
   :emphasize-lines: 43-55

    <?php
    // Filename: /module/Blog/config/module.config.php
    return array(
        'db'              => array( /** Db Config */ ),
        'service_manager' => array( /** ServiceManager Config */ ),
        'view_manager'    => array( /** ViewManager Config */ ),
        'controllers'     => array( /** ControllerManager Config* */ ),
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
                        ),
                        'edit' => array(
                            'type' => 'segment',
                            'options' => array(
                                'route'    => '/edit/:id',
                                'defaults' => array(
                                    'controller' => 'Blog\Controller\Write',
                                    'action'     => 'edit'
                                ),
                                'constraints' => array(
                                    'id' => '\d+'
                                )
                            )
                        ),
                    )
                )
            )
        )
    );

Creating the edit-template
==========================

Next in line is the creation of the new template ``blog/write/edit``:

.. code-block:: php
   :linenos:
   :emphasize-lines: 6

    <!-- Filename: /module/Blog/view/blog/write/add.phtml -->
    <h1>WriteController::editAction()</h1>
    <?php
    $form = $this->form;
    $form->setAttribute('method', 'POST');
    $form->setAttribute('action', $this->url('blog/edit', array(), true));
    $form->prepare();

    echo $this->form()->openTag($form);

    echo $this->formCollection($form);

    echo $this->form()->closeTag();

All that is really changing on the view-end is that you need to pass the current ``id`` to the ``url()`` view helper. To
achieve this you have two options. The first one would be to pass the ID to the parameters array like

.. code-block:: php
   :linenos:

    $this->url('blog/edit', array('id' => $id));

The downside is that ``$id`` is not available as we have not assigned it to the view. The ``Zend\Mvc\Router``-component
however provides us with a nice functionality to re-use the currently matched parameters. This is done by setting the
last parameter of the view-helper to ``true``.

.. code-block:: php
   :linenos:

    $this->url('blog/edit', array(), true);


**Checking the status**

If you go to your browser and open up the edit form at ``localhost:8080/blog/edit/1`` you'll see that the form contains
the data from your selected blog. And when you submit the form you'll notice that the data has been changed
successfully. However sadly the submit-button still contains the text ``Insert new Blog``. This can be changed inside
the view, too.

.. code-block:: php
   :linenos:
   :emphasize-lines: 9

    <!-- Filename: /module/Blog/view/blog/write/add.phtml -->
    <h1>WriteController::editAction()</h1>
    <?php
    $form = $this->form;
    $form->setAttribute('method', 'POST');
    $form->setAttribute('action', $this->url('blog/edit', array(), true));
    $form->prepare();

    $form->get('submit')->setValue('Update Blog');

    echo $this->form()->openTag($form);

    echo $this->formCollection($form);

    echo $this->form()->closeTag();


Implementing the delete functionality
=====================================

Last but not least it's time to delete some data. We start this process by creating a new route and adding a new
controller:

.. code-block:: php
   :linenos:
   :emphasize-lines: 11, 62-74

    <?php
    // Filename: /module/Blog/config/module.config.php
    return array(
        'db'              => array( /** Db Config */ ),
        'service_manager' => array( /** ServiceManager Config */ ),
        'view_manager'    => array( /** ViewManager Config */ ),
        'controllers'     => array(
            'factories' => array(
                'Blog\Controller\List'   => 'Blog\Factory\ListControllerFactory',
                'Blog\Controller\Write'  => 'Blog\Factory\WriteControllerFactory',
                'Blog\Controller\Delete' => 'Blog\Factory\DeleteControllerFactory'
            )
        ),
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
                        ),
                        'edit' => array(
                            'type' => 'segment',
                            'options' => array(
                                'route'    => '/edit/:id',
                                'defaults' => array(
                                    'controller' => 'Blog\Controller\Write',
                                    'action'     => 'edit'
                                ),
                                'constraints' => array(
                                    'id' => '\d+'
                                )
                            )
                        ),
                        'delete' => array(
                            'type' => 'segment',
                            'options' => array(
                                'route'    => '/delete/:id',
                                'defaults' => array(
                                    'controller' => 'Blog\Controller\Delete',
                                    'action'     => 'delete'
                                ),
                                'constraints' => array(
                                    'id' => '\d+'
                                )
                            )
                        ),
                    )
                )
            )
        )
    );

Notice here that we have assigned yet another controller ``Blog\Controller\Delete``. This is due to the fact that this
controller will **not** require the ``BlogForm``. A ``DeleteForm`` is a perfect example for when you do not even need to
make use of the ``Zend\Form`` component. Let's go ahead and create our controller first:

**The Factory**

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Blog/src/Blog/Factory/ListControllerFactory.php
    namespace Blog\Factory;

    use Blog\Controller\DeleteController;
    use Zend\ServiceManager\FactoryInterface;
    use Zend\ServiceManager\ServiceLocatorInterface;

    class DeleteControllerFactory implements FactoryInterface
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

            return new DeleteController($blogService);
        }
    }

**The Controller**

.. code-block:: php
   :linenos:
   :emphasize-lines: 31-35

    <?php
    namespace Blog\Controller;

    use Blog\Service\BlogServiceInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class DeleteController extends AbstractActionController
    {
        /**
         * @var \Blog\Service\BlogServiceInterface
         */
        protected $blogService;

        public function __construct(BlogServiceInterface $blogService)
        {
            $this->blogService = $blogService;
        }

        public function deleteAction()
        {
            try {
                $blog = $this->blogService->findBlog($this->params('id'));
            } catch (\InvalidArgumentException $e) {
                return $this->redirect()->toRoute('blog');
            }

            $request = $this->getRequest();

            if ($request->isPost()) {
                $del = $request->getPost('delete_confirmation', 'no');

                if ($del === 'yes') {
                    $this->blogService->deleteBlog($blog);
                }

                return $this->redirect()->toRoute('blog');
            }

            return new ViewModel(array(
                'blog' => $blog
            ));
        }
    }

As you can see this is nothing new. We inject the ``BlogService`` into the controller and inside the action we first
check if the blog exists. If so we check if it's a post request and inside there we check if a certain post parameter
called ``delete_confirmation`` is present. If the value of that then is ``yes`` we delete the blog through the
``BlogService``s ``deleteBlog()`` function.

When you're writing this code you'll notice that you don't get typehints for the ``deleteBlog()`` function because we
haven't added it to the service / interface yet. Go ahead and add the function to the interface and implement it inside
the service.

**The Interface**

.. code-block:: php
   :linenos:
   :emphasize-lines: 41

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

        /**
         * Should delete a given implementation of the BlogInterface and return true if the deletion has been
         * successful or false if not.
         *
         * @param  BlogInterface $blog
         * @return bool
         */
        public function deleteBlog(BlogInterface $blog);
    }

**The Service**

.. code-block:: php
   :linenos:
   :emphasize-lines: 50-53

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

        /**
         * @inheritDoc
         */
        public function deleteBlog(BlogInterface $blog)
        {
            return $this->blogMapper->delete($blog);
        }
    }

Now we assume that the ``BlogMapperInterface`` has a ``delete()``-function. We haven't yet implemented this one so go
ahead and add it to the ``BlogMapperInterface``.

.. code-block:: php
   :linenos:
   :emphasize-lines: 36

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

        /**
         * @param BlogInterface $blogObject
         *
         * @return bool
         * @throws \Exception
         */
        public function delete(BlogInterface $blogObject);
    }

Now that we have declared the function inside the interface it's time to implement it inside our ``ZendDbSqlMapper``:

.. code-block:: php
   :linenos:
   :emphasize-lines: 118-128

    <?php
    // Filename: /module/Blog/src/Blog/Mapper/ZendDbSqlMapper.php
    namespace Blog\Mapper;

    use Blog\Model\BlogInterface;
    use Zend\Db\Adapter\AdapterInterface;
    use Zend\Db\Adapter\Driver\ResultInterface;
    use Zend\Db\ResultSet\HydratingResultSet;
    use Zend\Db\Sql\Delete;
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
         * @inheritDoc
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
         * @inheritDoc
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
         * @inheritDoc
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

        /**
         * @inheritDoc
         */
        public function delete(BlogInterface $blogObject)
        {
            $action = new Delete('blog');
            $action->where(array('id = ?' => $blogObject->getId()));

            $sql    = new Sql($this->dbAdapter);
            $stmt   = $sql->prepareStatementForSqlObject($action);
            $result = $stmt->execute();

            return (bool)$result->getAffectedRows();
        }
    }

The ``Delete`` statement should look fairly similar to you as this is basically the same deal as all other queries we've
created so far. With all of this set up now we're good to go ahead and write our view file so we can delete blogs.

.. code-block:: php
   :linenos:

    <!-- Filename: /module/Blog/view/blog/delete/delete.phtml -->
    <h1>DeleteController::deleteAction()</h1>
    <p>
        Are you sure that you want to delete
        '<?php echo $this->escapeHtml($this->blog->getTitle()); ?>' by
        '<?php echo $this->escapeHtml($this->blog->getText()); ?>'?
    </p>
    <form action="<?php echo $this->url('blog/delete', array(), true) ?>" method="post">
        <input type="submit" name="delete_confirmation" value="yes" />
        <input type="submit" name="delete_confirmation" value="no" />
    </form>

Summary
=======

In this chapter we've learned how data binding within the ``Zend\Form``-component works and through it we have finished
our update-routine. Then we have learned how we can use HTML-Forms and checking it's data without relying on
``Zend\Form``, which ultimately lead us to having a full CRUD-Routine for the Blog example.

In the next chapter we'll recapitulate everything we've done. We'll talk about the design-patterns we've used and we're
going to cover a couple of questions that highly likely arose during the course of this tutorial.