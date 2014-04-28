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
    // Filename: /module/Album/src/Album/Controller/WriteController.php
    namespace Album\Controller;

    use Album\Service\AlbumServiceInterface;
    use Zend\Form\FormInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class WriteController extends AbstractActionController
    {
        protected $albumService;

        protected $albumForm;

        public function __construct(
            AlbumServiceInterface $albumService,
            FormInterface $albumForm
        ) {
            $this->albumService = $albumService;
            $this->albumForm    = $albumForm;
        }

        public function addAction()
        {
            $request = $this->getRequest();

            if ($request->isPost()) {
                $this->albumForm->setData($request->getPost());

                if ($this->albumForm->isValid()) {
                    try {
                        $this->albumService->saveAlbum($this->albumForm->getData());

                        return $this->redirect()->toRoute('album');
                    } catch (\Exception $e) {
                        die($e->getMessage());
                        // Some DB Error happened, log it and let the user know
                    }
                }
            }

            return new ViewModel(array(
                'form' => $this->albumForm
            ));
        }

        public function editAction()
        {
            $request = $this->getRequest();
            $album   = $this->albumService->findAlbum($this->params('id'));

            $this->albumForm->bind($album);

            if ($request->isPost()) {
                $this->albumForm->setData($request->getPost());

                if ($this->albumForm->isValid()) {
                    try {
                        $this->albumService->saveAlbum($album);

                        return $this->redirect()->toRoute('album');
                    } catch (\Exception $e) {
                        die($e->getMessage());
                        // Some DB Error happened, log it and let the user know
                    }
                }
            }

            return new ViewModel(array(
                'form' => $this->albumForm
            ));
        }
    }

Compared to the ``addAction()`` the ``editAction()`` has only three different lines. The first one is used to simply get the
relevant ``Album``-object from the service identified by the ``id``-parameter of the route (which we'll be writing soon).

The second line then shows you how you can bind data to the ``Zend\Form``-Component. We're able to use an object here
because our ``AlbumFieldset`` will use the hydrator to display the data coming from the object.

Lastly instead of actually doing ``$form->getData()`` we simply use the previous ``$album``-variable since it will be
updated with the latest data from the form thanks to the data-binding. And that's all there is to it. The only things
we need to add now is the new edit-route and the view for it.


Adding the edit-route
=====================

The edit route is a normal segment route just like the route ``album/detail``. Configure your route config to include the
new route:

.. code-block:: php
   :linenos:
   :emphasize-lines: 43-55

    <?php
    // Filename: /module/Album/config/module.config.php
    return array(
        'db'              => array( /** Db Config */ ),
        'service_manager' => array( /** ServiceManager Config */ ),
        'view_manager'    => array( /** ViewManager Config */ ),
        'controllers'     => array( /** ControllerManager Config* */ ),
        'router'          => array(
            'routes' => array(
                'album' => array(
                    'type' => 'literal',
                    'options' => array(
                        'route'    => '/album',
                        'defaults' => array(
                            'controller' => 'Album\Controller\List',
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
                                    'controller' => 'Album\Controller\Write',
                                    'action'     => 'add'
                                )
                            )
                        ),
                        'edit' => array(
                            'type' => 'segment',
                            'options' => array(
                                'route'    => '/edit/:id',
                                'defaults' => array(
                                    'controller' => 'Album\Controller\Write',
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

Next in line is the creation of the new template ``album/write/edit``:

.. code-block:: php
   :linenos:
   :emphasize-lines: 6

    <!-- Filename: /module/Album/view/album/write/add.phtml -->
    <h1>WriteController::editAction()</h1>
    <?php
    $form = $this->form;
    $form->setAttribute('method', 'POST');
    $form->setAttribute('action', $this->url('album/edit', array(), true));
    $form->prepare();

    echo $this->form()->openTag($form);

    echo $this->formCollection($form);

    echo $this->form()->closeTag();

All that is really changing on the view-end is that you need to pass the current ``id`` to the ``url()`` view helper. To
achieve this you have two options. The first one would be to pass the ID to the parameters array like

.. code-block:: php
   :linenos:

    $this->url('album/edit', array('id' => $id));

The downside is that ``$id`` is not available as we have not assigned it to the view. The ``Zend\Mvc\Router``-component
however provides us with a nice functionality to re-use the currently matched parameters. This is done by setting the
last parameter of the view-helper to ``true``.

.. code-block:: php
   :linenos:

    $this->url('album/edit', array(), true);


**Checking the status**

If you go to your browser and open up the edit form at ``localhost:8080/album/edit/1`` you'll see that the form contains
the data from your selected album. And when you submit the form you'll notice that the data has been changed
successfully. However sadly the submit-button still contains the text ``Insert new Album``. This can be changed inside
the view, too.

.. code-block:: php
   :linenos:
   :emphasize-lines: 9

    <!-- Filename: /module/Album/view/album/write/add.phtml -->
    <h1>WriteController::editAction()</h1>
    <?php
    $form = $this->form;
    $form->setAttribute('method', 'POST');
    $form->setAttribute('action', $this->url('album/edit', array(), true));
    $form->prepare();

    $form->get('submit')->setValue('Update Album');

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
    // Filename: /module/Album/config/module.config.php
    return array(
        'db'              => array( /** Db Config */ ),
        'service_manager' => array( /** ServiceManager Config */ ),
        'view_manager'    => array( /** ViewManager Config */ ),
        'controllers'     => array(
            'factories' => array(
                'Album\Controller\List'   => 'Album\Factory\ListControllerFactory',
                'Album\Controller\Write'  => 'Album\Factory\WriteControllerFactory',
                'Album\Controller\Delete' => 'Album\Factory\DeleteControllerFactory'
            )
        ),
        'router'          => array(
            'routes' => array(
                'album' => array(
                    'type' => 'literal',
                    'options' => array(
                        'route'    => '/album',
                        'defaults' => array(
                            'controller' => 'Album\Controller\List',
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
                                    'controller' => 'Album\Controller\Write',
                                    'action'     => 'add'
                                )
                            )
                        ),
                        'edit' => array(
                            'type' => 'segment',
                            'options' => array(
                                'route'    => '/edit/:id',
                                'defaults' => array(
                                    'controller' => 'Album\Controller\Write',
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
                                    'controller' => 'Album\Controller\Delete',
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

Notice here that we have assigned yet another controller ``Album\Controller\Delete``. This is due to the fact that this
controller will **not** require the ``AlbumForm``. A ``DeleteForm`` is a perfect example for when you do not even need to
make use of the ``Zend\Form`` component. Let's go ahead and create our controller first:

**The Factory**

.. code-block:: php
   :linenos:

    <?php
    // Filename: /module/Album/src/Album/Factory/ListControllerFactory.php
    namespace Album\Factory;

    use Album\Controller\DeleteController;
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
            $albumService       = $realServiceLocator->get('Album\Service\AlbumServiceInterface');

            return new DeleteController($albumService);
        }
    }

**The Controller**

.. code-block:: php
   :linenos:
   :emphasize-lines: 31-35

    <?php
    namespace Album\Controller;

    use Album\Service\AlbumServiceInterface;
    use Zend\Mvc\Controller\AbstractActionController;
    use Zend\View\Model\ViewModel;

    class DeleteController extends AbstractActionController
    {
        /**
         * @var \Album\Service\AlbumServiceInterface
         */
        protected $albumService;

        public function __construct(AlbumServiceInterface $albumService)
        {
            $this->albumService = $albumService;
        }

        public function deleteAction()
        {
            try {
                $album = $this->albumService->findAlbum($this->params('id'));
            } catch (\InvalidArgumentException $e) {
                return $this->redirect()->toRoute('album');
            }

            $request = $this->getRequest();

            if ($request->isPost()) {
                $del = $request->getPost('delete_confirmation', 'no');

                if ($del === 'yes') {
                    $this->albumService->deleteAlbum($album);
                }

                return $this->redirect()->toRoute('album');
            }

            return new ViewModel(array(
                'album' => $album
            ));
        }
    }

As you can see this is nothing new. We inject the ``AlbumService`` into the controller and inside the action we first
check if the album exists. If so we check if it's a post request and inside there we check if a certain post parameter
called ``delete_confirmation`` is present. If the value of that then is ``yes`` we delete the album through the
``AlbumService``s ``deleteAlbum()`` function.

When you're writing this code you'll notice that you don't get typehints for the ``deleteAlbum()`` function because we
haven't added it to the service / interface yet. Go ahead and add the function to the interface and implement it inside
the service.

**The Interface**

.. code-block:: php
   :linenos:
   :emphasize-lines: 41

    <?php
    // Filename: /module/Album/src/Album/Service/AlbumServiceInterface.php
    namespace Album\Service;

    use Album\Model\AlbumInterface;

    interface AlbumServiceInterface
    {
        /**
         * Should return a set of all albums that we can iterate over. Single entries of the array or \Traversable object
         * should be of type \Album\Model\Album
         *
         * @return array|AlbumInterface[]
         */
        public function findAllAlbums();

        /**
         * Should return a single album
         *
         * @param  int $id Identifier of the Album that should be returned
         * @return AlbumInterface
         */
        public function findAlbum($id);

        /**
         * Should save a given implementation of the AlbumInterface and return it. If it is an existing Album the Album
         * should be updated, if it's a new Album it should be created.
         *
         * @param  AlbumInterface $album
         * @return AlbumInterface
         */
        public function saveAlbum(AlbumInterface $album);

        /**
         * Should delete a given implementation of the AlbumInterface and return true if the deletion has been
         * successful or false if not.
         *
         * @param  AlbumInterface $album
         * @return bool
         */
        public function deleteAlbum(AlbumInterface $album);
    }

**The Service**

.. code-block:: php
   :linenos:
   :emphasize-lines: 50-53

    <?php
    // Filename: /module/Album/src/Album/Service/AlbumService.php
    namespace Album\Service;

    use Album\Mapper\AlbumMapperInterface;
    use Album\Model\AlbumInterface;

    class AlbumService implements AlbumServiceInterface
    {
        /**
         * @var \Album\Mapper\AlbumMapperInterface
         */
        protected $albumMapper;

        /**
         * @param AlbumMapperInterface $albumMapper
         */
        public function __construct(AlbumMapperInterface $albumMapper)
        {
            $this->albumMapper = $albumMapper;
        }

        /**
         * @inheritDoc
         */
        public function findAllAlbums()
        {
            return $this->albumMapper->findAll();
        }

        /**
         * @inheritDoc
         */
        public function findAlbum($id)
        {
            return $this->albumMapper->find($id);
        }

        /**
         * @inheritDoc
         */
        public function saveAlbum(AlbumInterface $album)
        {
            return $this->albumMapper->save($album);
        }

        /**
         * @inheritDoc
         */
        public function deleteAlbum(AlbumInterface $album)
        {
            return $this->albumMapper->delete($album);
        }
    }

Now we assume that the ``AlbumMapperInterface`` has a ``delete()``-function. We haven't yet implemented this one so go
ahead and add it to the ``AlbumMapperInterface``.

.. code-block:: php
   :linenos:
   :emphasize-lines: 36

    <?php
    // Filename: /module/Album/src/Album/Mapper/AlbumMapperInterface.php
    namespace Album\Mapper;

    use Album\Model\AlbumInterface;

    interface AlbumMapperInterface
    {
        /**
         * @param int|string $id
         * @return AlbumInterface
         * @throws \InvalidArgumentException
         */
        public function find($id);

        /**
         * @return array|AlbumInterface[]
         */
        public function findAll();

        /**
         * @param AlbumInterface $albumObject
         *
         * @param AlbumInterface $albumObject
         * @return AlbumInterface
         * @throws \Exception
         */
        public function save(AlbumInterface $albumObject);

        /**
         * @param AlbumInterface $albumObject
         *
         * @return bool
         * @throws \Exception
         */
        public function delete(AlbumInterface $albumObject);
    }

Now that we have declared the function inside the interface it's time to implement it inside our ``ZendDbSqlMapper``:

.. code-block:: php
   :linenos:
   :emphasize-lines: 118-128

    <?php
    // Filename: /module/Album/src/Album/Mapper/ZendDbSqlMapper.php
    namespace Album\Mapper;

    use Album\Model\AlbumInterface;
    use Zend\Db\Adapter\AdapterInterface;
    use Zend\Db\Adapter\Driver\ResultInterface;
    use Zend\Db\ResultSet\HydratingResultSet;
    use Zend\Db\Sql\Delete;
    use Zend\Db\Sql\Insert;
    use Zend\Db\Sql\Sql;
    use Zend\Db\Sql\Update;
    use Zend\Stdlib\Hydrator\HydratorInterface;

    class ZendDbSqlMapper implements AlbumMapperInterface
    {
        /**
         * @var \Zend\Db\Adapter\AdapterInterface
         */
        protected $dbAdapter;

        protected $hydrator;

        protected $albumPrototype;

        /**
         * @param AdapterInterface  $dbAdapter
         * @param HydratorInterface $hydrator
         * @param AlbumInterface    $albumPrototype
         */
        public function __construct(
            AdapterInterface $dbAdapter,
            HydratorInterface $hydrator,
            AlbumInterface $albumPrototype
        ) {
            $this->dbAdapter      = $dbAdapter;
            $this->hydrator       = $hydrator;
            $this->albumPrototype = $albumPrototype;
        }

        /**
         * @inheritDoc
         */
        public function find($id)
        {
            $sql    = new Sql($this->dbAdapter);
            $select = $sql->select('album');
            $select->where(array('id = ?' => $id));

            $stmt   = $sql->prepareStatementForSqlObject($select);
            $result = $stmt->execute();

            if ($result instanceof ResultInterface && $result->isQueryResult() && $result->getAffectedRows()) {
                return $this->hydrator->hydrate($result->current(), $this->albumPrototype);
            }

            throw new \InvalidArgumentException("Album with given ID:{$id} not found.");
        }

        /**
         * @inheritDoc
         */
        public function findAll()
        {
            $sql    = new Sql($this->dbAdapter);
            $select = $sql->select('album');

            $stmt   = $sql->prepareStatementForSqlObject($select);
            $result = $stmt->execute();

            if ($result instanceof ResultInterface && $result->isQueryResult()) {
                $resultSet = new HydratingResultSet($this->hydrator, $this->albumPrototype);

                return $resultSet->initialize($result);
            }

            return array();
        }

        /**
         * @inheritDoc
         */
        public function save(AlbumInterface $albumObject)
        {
            $albumData = $this->hydrator->extract($albumObject);
            unset($albumData['id']); // Neither Insert nor Update needs the ID in the array

            if ($albumObject->getId()) {
                // ID present, it's an Update
                $action = new Update('album');
                $action->set($albumData);
                $action->where(array('id = ?' => $albumObject->getId()));
            } else {
                // ID NOT present, it's an Insert
                $action = new Insert('album');
                $action->values($albumData);
            }

            $sql    = new Sql($this->dbAdapter);
            $stmt   = $sql->prepareStatementForSqlObject($action);
            $result = $stmt->execute();

            if ($result instanceof ResultInterface) {
                if ($newId = $result->getGeneratedValue()) {
                    // When a value has been generated, set it on the object
                    $albumObject->setId($newId);
                }

                return $albumObject;
            }

            throw new \Exception("Database error");
        }

        /**
         * @inheritDoc
         */
        public function delete(AlbumInterface $albumObject)
        {
            $action = new Delete('album');
            $action->where(array('id = ?' => $albumObject->getId()));

            $sql    = new Sql($this->dbAdapter);
            $stmt   = $sql->prepareStatementForSqlObject($action);
            $result = $stmt->execute();

            return (bool)$result->getAffectedRows();
        }
    }

The ``Delete`` statement should look fairly similar to you as this is basically the same deal as all other queries we've
created so far. With all of this set up now we're good to go ahead and write our view file so we can delete albums.

.. code-block:: php
   :linenos:

    <!-- Filename: /module/Album/view/album/delete/delete.phtml -->
    <h1>DeleteController::deleteAction()</h1>
    <p>
        Are you sure that you want to delete
        '<?php echo $this->escapeHtml($this->album->getTitle()); ?>' by
        '<?php echo $this->escapeHtml($this->album->getArtist()); ?>'?
    </p>
    <form action="<?php echo $this->url('album/delete', array(), true) ?>" method="post">
        <input type="submit" name="delete_confirmation" value="yes" />
        <input type="submit" name="delete_confirmation" value="no" />
    </form>

Summary
=======

In this chapter we've learned how data binding within the ``Zend\Form``-component works and through it we have finished
our update-routine. Then we have learned how we can use HTML-Forms and checking it's data without relying on
``Zend\Form``, which ultimately lead us to having a full CRUD-Routine for the Album example.

In the next chapter we'll recapitulate everything we've done. We'll talk about the design-patterns we've used and we're
going to cover a couple of questions that highly likely arose during the course of this tutorial.