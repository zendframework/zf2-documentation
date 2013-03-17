Using the Flash Messenger in your Album Module
==============================================

When our user edits, deletes or adds an album, how do they know they have been successful in their action?

In this tutorial we will use the ``FlashMessenger`` view helper to give the user feedback after they have
added, edited or deleted an album.

The Flash Messenger
-------------------

The flash messenger controller plugin is a tool you can use for passing messages from one request to another
(using the session), and is perfect to the job of handling user action responses. Because it uses
``Zend\Session\Namespace`` as it's session manager *by default), it "just works" if you use it's sane defaults.

The flash messenger will also delete the messages once they have been retrieved; messages only have a life of 1 hop
by default.

Adding Feedback to the Actions
------------------------------

Adding a successful message to the actions is actually really simple. Because the Flash Messenger is a controller
plugin, it's automatically available to classes that extend the ``AbstractActionController`` class. Let's add
feedback to the add, edit and delete actions:

``module/Album/src/Album/Controller/AlbumController.php``

.. code-block:: php

    ...
     public function addAction()
    {
        $form = new AlbumForm();
        $form->get('submit')->setValue('Add');

        $request = $this->getRequest();
        if ($request->isPost()) {
            $album = new Album();
            $form->setInputFilter($album->getInputFilter());
            $form->setData($request->getPost());

            if ($form->isValid()) {
                $album->exchangeArray($form->getData());
                $this->getAlbumTable()->saveAlbum($album);
                // Redirect to list of albums
                $this->flashMessenger()->addMessage('Added the album "' . $album->title . '"'); // <-- add this line
                return $this->redirect()->toRoute('album');
            }
        }
        return array('form' => $form);
    }

    public function editAction()
    {
        $id = (int)$this->params()->fromRoute('id', null);
        if (is_null($id)) {
            return $this->redirect()->toRoute('album', array(
                'action' => 'add'
            ));
        }
        $album = $this->getAlbumTable()->getAlbum($id);

        $form = new AlbumForm();
        $form->bind($album);
        $form->get('submit')->setAttribute('value', 'Edit');

        $request = $this->getRequest();
        if ($request->isPost()) {
            $form->setInputFilter($album->getInputFilter());
            $form->setData($request->getPost());

            if ($form->isValid()) {
                $this->getAlbumTable()->saveAlbum($form->getData());
                $this->flashMessenger()->addMessage('Edited the album "' . $album->title . '"'); // <-- add this line
                // Redirect to list of albums
                return $this->redirect()->toRoute('album');
            }
        }

        return array(
            'id' => $id,
            'form' => $form,
        );
    }

    public function deleteAction()
    {
        $id = (int)$this->params()->fromRoute('id', null);
        if (is_null($id)) {
            return $this->redirect()->toRoute('album');
        }

        $request = $this->getRequest();
        if ($request->isPost()) {
            $del = $request->getPost('del', 'No');
            if ($del == 'Yes') {
                $id = (int)$request->getPost('id');
                $this->getAlbumTable()->deleteAlbum($id);
                $this->flashMessenger()->addMessage('Deleted album number ' . $id); // <-- add this line
            }

            // Redirect to list of albums
            return $this->redirect()->toRoute('album');
        }

        return array(
            'id' => $id,
            'album' => $this->getAlbumTable()->getAlbum($id)
        );
    }
    ...

Displaying the Flash Messenger Messages
---------------------------------------

Now, that's all that's left to do is to retrieve the messages from the flash messenger (if they exist),
and display them in our view script. First, let's add the messages to a view variable:

``module/Album/src/Album/Controller/AlbumController.php``

.. code-block:: php

    ...
    public function indexAction()
    {
        $paginator = $this->getAlbumTable()->fetchAll(true);
        $paginator->setCurrentPageNumber($this->params()->fromQuery('page', 1));
        $paginator->setItemCountPerPage(10);
        return new ViewModel(array(
            'paginator' => $paginator,
            'messages' => $this->flashMessenger()->getMessages(), // <-- add this line
        ));
    }
    ...

Finally, all we need to do is to edit the view script so that we display any messages that are set. As usual,
because we are using Twitter Bootstrap, we only need to give the message the right classes and we'll get a pretty
alert for the message:

 ``module/Album/view/album/album/index.phtml``

.. code-block:: php

    <?php
    $title = 'My albums';
    $this->headTitle($title);
    ?>

    // add this block
    <?php foreach ($this->messages as $message): ?>
        <div class="alert alert-success">
            <?php echo $message; ?>
        </div>
    <?php endforeach; ?>

    <h1><?php echo $this->escapeHtml($title); ?></h1>
    ...

And that's it! Now, if you add, edit or delete an album, the application will tell you if the action
was successful.