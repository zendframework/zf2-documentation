.. _learning.view.placeholders.basics:

Basic Placeholder Usage
=======================

Zend Framework defines a generic ``placeholder()`` view helper that you may use for as many custom placeholders you
need. It also provides a variety of specific placeholder implementations for often-needed functionality, such as
specifying the **DocType** declaration, document title, and more.

All placeholders operate in roughly the same way. They are containers, and thus allow you to operate on them as
collections. With them you can:

- **Append** or **prepend** items to the collection.

- **Replace** the entire collection with a single value.

- Specify a string with which to **prepend output** of the collection when rendering.

- Specify a string with which to **append output** of the collection when rendering.

- Specify a string with which to **separate items** of the collection when rendering.

- **Capture content** into the collection.

- **Render** the aggregated content.

Typically, you will call the helper with no arguments, which will return a container on which you may operate. You
will then either echo this container to render it, or call methods on it to configure or populate it. If the
container is empty, rendering it will simply return an empty string; otherwise, the content will be aggregated
according to the rules by which you configure it.

As an example, let's create a sidebar that consists of a number of "blocks" of content. You'll likely know up-front
the structure of each block; let's assume for this example that it might look like this:

.. code-block:: html
   :linenos:

   <div class="sidebar">
       <div class="block">
           <p>
               Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus
               consectetur aliquet odio ac consectetur. Nulla quis eleifend
               tortor. Pellentesque varius, odio quis bibendum consequat, diam
               lectus porttitor quam, et aliquet mauris orci eu augue.
           </p>
       </div>
       <div class="block">
           <ul>
               <li><a href="/some/target">Link</a></li>
               <li><a href="/some/target">Link</a></li>
           </ul>
       </div>
   </div>

The content will vary based on the controller and action, but the structure will be the same. Let's first setup the
sidebar in a resource method of our bootstrap:

.. code-block:: php
   :linenos:

   class Bootstrap extends Zend\Application\Bootstrap\Bootstrap
   {
       // ...

       protected function _initSidebar()
       {
           $this->bootstrap('View');
           $view = $this->getResource('View');

           $view->placeholder('sidebar')
                // "prefix" -> markup to emit once before all items in collection
                ->setPrefix("<div class=\"sidebar\">\n    <div class=\"block\">\n")
                // "separator" -> markup to emit between items in a collection
                ->setSeparator("</div>\n    <div class=\"block\">\n")
                // "postfix" -> markup to emit once after all items in a collection
                ->setPostfix("</div>\n</div>");
       }

       // ...
   }

The above defines a placeholder, "sidebar", that has no items. It configures the basic markup structure of that
placeholder, however, per our requirements.

Now, let's assume for the "user" controller that for all actions we'll want a block at the top containing some
information. We could accomplish this in two ways: (a) we could add the content to the placeholder directly in the
controller's ``preDispatch()`` method, or (b) we could render a view script from within the ``preDispatch()``
method. We'll use (b), as it follows a more proper separation of concerns (leaving view-related logic and
functionality within a view script).

We'll name the view script "``user/_sidebar.phtml``", and populate it as follows:

.. code-block:: php
   :linenos:

   <?php $this->placeholder('sidebar')->captureStart() ?>
   <h4>User Administration</h4>
   <ul>
       <li><a href="<?php $this->url(array('action' => 'list')) ?>">
           List</a></li>
       <li><a href="<?php $this->url(array('action' => 'create')) ?>">
           Create</a></a></li>
   </ul>
   <?php $this->placeholder('sidebar')->captureEnd() ?>

The above example makes use of the content capturing feature of placeholders. By default, content is appended as a
new item in the container, allowing us to aggregate content. This example makes use of view helpers and static
*HTML* in order to generate markup, and the content is then captured and appended into the placeholder itself.

To invoke the above view script, we would write the following in our ``preDispatch()`` method:

.. code-block:: php
   :linenos:

   class UserController extends Zend\Controller\Action
   {
       // ...

       public function preDispatch()
       {
           // ...

           $this->view->render('user/_sidebar.phtml');

           // ...
       }

       // ...
   }

Note that we're not capturing the rendered value; there's no need, as the entirety of that view is being captured
into a placeholder.

Now, let's assume our "view" action in that same controller needs to present some information. Within the
"``user/view.phtml``" view script, we might have the following snippet of content:

.. code-block:: php
   :linenos:

   $this->placeholder('sidebar')
        ->append('<p>User: ' . $this->escape($this->username) .  '</p>');

This example makes use of the ``append()`` method, and passes it some simple markup to aggregate.

Finally, let's modify our layout view script, and have it render the placeholder.

.. code-block:: php
   :linenos:

   <html>
   <head>
       <title>My Site</title>
   </head>
   <body>
       <div class="content">
           <?php echo $this->layout()->content ?>
       </div>
       <?php echo $this->placeholder('sidebar') ?>
   </body>
   </html>

For controllers and actions that do not populate the "sidebar" placeholder, no content will be rendered; for those
that do, however, echoing the placeholder will render the content according to the rules we created in our
bootstrap, and the content we aggregated throughout the application. In the case of the "``/user/view``" action,
and assuming a username of "matthew", we would get content for the sidebar as follows (formatted for readability):

.. code-block:: html
   :linenos:

   <div class="sidebar">
       <div class="block">
           <h4>User Administration</h4>
           <ul>
               <li><a href="/user/list">List</a></li>
               <li><a href="/user/create">Create</a></a></li>
           </ul>
       </div>
       <div class="block">
           <p>User: matthew</p>
       </div>
   </div>

There are a large number of things you can do by combining placeholders and layout scripts; experiment with them,
and read the :ref:`relevant manual sections <zend.view.helpers.initial.placeholder>` for more information.


