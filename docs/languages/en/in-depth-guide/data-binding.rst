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
                        die($e->getMessage());
                        // Some DB Error happened, log it and let the user know
                    }
                }
            }

            return new ViewModel(array(
                'form' => $this->postForm
            ));
        }

        public function editAction()
        {
            $request = $this->getRequest();
            $post    = $this->postService->findPost($this->params('id'));

            $this->postForm->bind($post);

            if ($request->isPost()) {
                $this->postForm->setData($request->getPost());

                if ($this->postForm->isValid()) {
                    try {
                        $this->postService->savePost($post);

                        return $this->redirect()->toRoute('post');
                    } catch (\Exception $e) {
                        die($e->getMessage());
                        // Some DB Error happened, log it and let the user know
                    }
                }
            }

            return new ViewModel(array(
                'form' => $this->postForm
            ));
        }
    }

Compared to the ``addAction()`` the ``editAction()`` has only three different lines. The first one is used to simply
get the relevant ``Post``-object from the service identified by the ``id``-parameter of the route (which we'll be
writing soon).

The second line then shows you how you can bind data to the ``Zend\Form``-Component. We're able to use an object here
because our ``PostFieldset`` will use the hydrator to display the data coming from the object.

Lastly instead of actually doing ``$form->getData()`` we simply use the previous ``$post``-variable since it will be
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

    <!-- Filename: /module/Blog/view/blog/write/edit.phtml -->
    <h1>WriteController::editAction()</h1>
    <?php
    $form = $this->form;
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
successfully. However sadly the submit-button still contains the text ``Insert new Post``. This can be changed inside
the view, too.

.. code-block:: php
   :linenos:
   :emphasize-lines: 9

    <!-- Filename: /module/Blog/view/blog/write/add.phtml -->
    <h1>WriteController::editAction()</h1>
    <?php
    $form = $this->form;
    $form->setAttribute('action', $this->url('blog/edit', array(), true));
    $form->prepare();

    $form->get('submit')->setValue('Update Post');

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
                'post' => array(
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
controller will **not** require the ``PostForm``. A ``DeleteForm`` is a perfect example for when you do not even need to
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
            $postService        = $realServiceLocator->get('Blog\Service\PostServiceInterface');

            return new DeleteController($postService);
        }
    }

**The Controller**

.. code-block:: php
   :linenos:
   :emphasize-lines: 31-35

    <?php
    namespace Blog\Controller;

    use Blog\Service\PostServiceInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class DeleteController extends AbstractActionController
    {
        /**
         * @var \Blog\Service\PostServiceInterface
         */
        protected $postService;

        public function __construct(PostServiceInterface $postService)
        {
            $this->postService = $postService;
        }

        public function deleteAction()
        {
            try {
                $post = $this->postService->findPost($this->params('id'));
            } catch (\InvalidArgumentException $e) {
                return $this->redirect()->toRoute('post');
            }

            $request = $this->getRequest();

            if ($request->isPost()) {
                $del = $request->getPost('delete_confirmation', 'no');

                if ($del === 'yes') {
                    $this->postService->deletePost($post);
                }

                return $this->redirect()->toRoute('post');
            }

            return new ViewModel(array(
                'post' => $post
            ));
        }
    }

As you can see this is nothing new. We inject the ``PostService`` into the controller and inside the action we first
check if the blog exists. If so we check if it's a post request and inside there we check if a certain post parameter
called ``delete_confirmation`` is present. If the value of that then is ``yes`` we delete the blog through the
``PostService``'s ``deletePost()`` function.

When you're writing this code you'll notice that you don't get typehints for the ``deletePost()`` function because we
haven't added it to the service / interface yet. Go ahead and add the function to the interface and implement it inside
the service.

**The Interface**

.. code-block:: php
   :linenos:
   :emphasize-lines: 41

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

        /**
         * Should delete a given implementation of the PostInterface and return true if the deletion has been
         * successful or false if not.
         *
         * @param  PostInterface $blog
         * @return bool
         */
        public function deletePost(PostInterface $blog);
    }

**The Service**

.. code-block:: php
   :linenos:
   :emphasize-lines: 50-53

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

        /**
         * {@inheritDoc}
         */
        public function deletePost(PostInterface $post)
        {
            return $this->postMapper->delete($post);
        }
    }

Now we assume that the ``PostMapperInterface`` has a ``delete()``-function. We haven't yet implemented this one so go
ahead and add it to the ``PostMapperInterface``.

.. code-block:: php
   :linenos:
   :emphasize-lines: 36

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

        /**
         * @param PostInterface $postObject
         *
         * @return bool
         * @throws \Exception
         */
        public function delete(PostInterface $postObject);
    }

Now that we have declared the function inside the interface it's time to implement it inside our ``ZendDbSqlMapper``:

.. code-block:: php
   :linenos:
   :emphasize-lines: 118-128

    <?php
    // Filename: /module/Blog/src/Blog/Mapper/ZendDbSqlMapper.php
    namespace Blog\Mapper;

    use Blog\Model\PostInterface;
    use Zend\Db\Adapter\AdapterInterface;
    use Zend\Db\Adapter\Driver\ResultInterface;
    use Zend\Db\ResultSet\HydratingResultSet;
    use Zend\Db\Sql\Delete;
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

        protected $hydrator;

        protected $postPrototype;

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
         * {@inheritDoc}
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
         * {@inheritDoc}
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
         * {@inheritDoc}
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

        /**
         * {@inheritDoc}
         */
        public function delete(PostInterface $postObject)
        {
            $action = new Delete('post');
            $action->where(array('id = ?' => $postObject->getId()));

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
        <input type="submit" name="delete_confirmation" value="yes">
        <input type="submit" name="delete_confirmation" value="no">
    </form>

Summary
=======

In this chapter we've learned how data binding within the ``Zend\Form``-component works and through it we have finished
our update-routine. Then we have learned how we can use HTML-Forms and checking it's data without relying on
``Zend\Form``, which ultimately lead us to having a full CRUD-Routine for the Blog example.

In the next chapter we'll recapitulate everything we've done. We'll talk about the design-patterns we've used and we're
going to cover a couple of questions that highly likely arose during the course of this tutorial.
