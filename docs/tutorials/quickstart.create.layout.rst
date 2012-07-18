.. _learning.quickstart.create-layout:

Create A Layout
===============

You may have noticed that the view scripts in the previous sections were *HTML* fragments- not complete pages. This is by design; we want our actions to return content only related to the action itself, not the application as a whole.

Now we must compose that generated content into a full *HTML* page. We'd also like to have a consistent look and feel for the application. We will use a global site layout to accomplish both of these tasks.

There are two design patterns that Zend Framework uses to implement layouts: `Two Step View`_ and `Composite View`_. **Two Step View** is usually associated with the `Transform View`_ pattern; the basic idea is that your application view creates a representation that is then injected into the master view for final transformation. The **Composite View** pattern deals with a view made of one or more atomic, application views.

In Zend Framework, :ref:`Zend_Layout <zend.layout>` combines the ideas behind these patterns. Instead of each action view script needing to include site-wide artifacts, they can simply focus on their own responsibilities.

Occasionally, however, you may need application-specific information in your site-wide view script. Fortunately, Zend Framework provides a variety of view **placeholders** to allow you to provide such information from your action view scripts.

To get started using ``Zend_Layout``, first we need to inform our bootstrap to use the ``Layout`` resource. This can be done using the ``zf enable layout`` command:

.. code-block:: console
   :linenos:

   % zf enable layout
   Layouts have been enabled, and a default layout created at
   application/layouts/scripts/layout.phtml
   A layout entry has been added to the application config file.

As noted by the command, ``application/configs/application.ini`` is updated, and now contains the following within the ``production`` section:

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   ; Add to [production] section:
   resources.layout.layoutPath = APPLICATION_PATH "/layouts/scripts"

The final *INI* file should look as follows:

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   [production]
   ; PHP settings we want to initialize
   phpSettings.display_startup_errors = 0
   phpSettings.display_errors = 0
   includePaths.library = APPLICATION_PATH "/../library"
   bootstrap.path = APPLICATION_PATH "/Bootstrap.php"
   bootstrap.class = "Bootstrap"
   appnamespace = "Application"
   resources.frontController.controllerDirectory = APPLICATION_PATH "/controllers"
   resources.frontController.params.displayExceptions = 0
   resources.layout.layoutPath = APPLICATION_PATH "/layouts/scripts"

   [staging : production]

   [testing : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

   [development : production]
   phpSettings.display_startup_errors = 1
   phpSettings.display_errors = 1

This directive tells your application to look for layout view scripts in ``application/layouts/scripts``. If you examine your directory tree, you'll see that this directory has been created for you now, with the file ``layout.phtml``.

We also want to ensure we have an XHTML DocType declaration for our application. To enable this, we need to add a resource to our bootstrap.

The simplest way to add a bootstrap resource is to simply create a protected method beginning with the phrase ``_init``. In this case, we want to initialize the doctype, so we'll create an ``_initDoctype()`` method within our bootstrap class:

.. code-block:: php
   :linenos:

   // application/Bootstrap.php

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       protected function _initDoctype()
       {
       }
   }

Within that method, we need to hint to the view to use the appropriate doctype. But where will the view object come from? The easy solution is to initialize the ``View`` resource; once we have, we can pull the view object from the bootstrap and use it.

To initialize the view resource, add the following line to your ``application/configs/application.ini`` file, in the section marked ``production``:

.. code-block:: ini
   :linenos:

   ; application/configs/application.ini

   ; Add to [production] section:
   resources.view[] =

This tells us to initialize the view with no options (the '[]' indicates that the "view" key is an array, and we pass nothing to it).

Now that we have a view, let's flesh out our ``_initDoctype()`` method. In it, we will first ensure the ``View`` resource has run, fetch the view object, and then configure it:

.. code-block:: php
   :linenos:

   // application/Bootstrap.php

   class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
   {
       protected function _initDoctype()
       {
           $this->bootstrap('view');
           $view = $this->getResource('view');
           $view->doctype('XHTML1_STRICT');
       }
   }

Now that we've initialized ``Zend_Layout`` and set the Doctype, let's create our site-wide layout:

.. code-block:: php
   :linenos:

   <!-- application/layouts/scripts/layout.phtml -->
   <?php echo $this->doctype() ?>
   <html xmlns="http://www.w3.org/1999/xhtml">
   <head>
     <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
     <title>Zend Framework Quickstart Application</title>
     <?php echo $this->headLink()->appendStylesheet('/css/global.css') ?>
   </head>
   <body>
   <div id="header" style="background-color: #EEEEEE; height: 30px;">
       <div id="header-logo" style="float: left">
           <b>ZF Quickstart Application</b>
       </div>
       <div id="header-navigation" style="float: right">
           <a href="<?php echo $this->url(
               array('controller'=>'guestbook'),
               'default',
               true) ?>">Guestbook</a>
       </div>
   </div>

   <?php echo $this->layout()->content ?>

   </body>
   </html>

We grab our application content using the ``layout()`` view helper, and accessing the "content" key. You may render to other response segments if you wish to, but in most cases, this is all that's necessary.

Note also the use of the ``headLink()`` placeholder. This is an easy way to generate the *HTML* for <link> elements, as well as to keep track of them throughout your application. If you need to add additional CSS sheets to support a single action, you can do so, and be assured it will be present in the final rendered page.

.. note::

   **Checkpoint**

   Now go to "http://localhost" and check out the source. You should see your XHTML header, head, title, and body sections.



.. _`Two Step View`: http://martinfowler.com/eaaCatalog/twoStepView.html
.. _`Composite View`: http://java.sun.com/blueprints/corej2eepatterns/Patterns/CompositeView.html
.. _`Transform View`: http://www.martinfowler.com/eaaCatalog/transformView.html
