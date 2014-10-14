Using Zend\\Navigation in your Album Module
===========================================

In this tutorial we will use the :ref:`Zend\\Navigation component <zend.navigation.introduction>`
to add a navigation menu to the black bar at the top of the screen, and add
breadcrumbs above the main site content.

Preparation
-----------

In a real world application, the album browser would be only a portion of a working website. Usually the user 
would land on a homepage first, and be able to view albums by using a standard navigation menu. So that we 
have a site that is more realistic than just the albums feature, lets make the standard skeleton welcome page 
our homepage, with the `/album` route still showing our album module. In order to make this change, we need to
undo some work we did earlier. Currently, navigating to the root of your app (/) routes you to the 
``AlbumController``'s default action. Let's undo this route change so we have two discrete entry points to the 
app, a home page, and an albums area.

**module/Application/config/module.config.php:**

.. code-block:: php
   :linenos:

   'home' => array(
      'type' => 'Zend\Mvc\Router\Http\Literal',
       'options' => array(
           'route'    => '/',
           'defaults' => array(
               'controller' => 'Application\Controller\Index', // <-- change back here
               'action'     => 'index',
           ),
       ),
   ),

This change means that if you go to the home page of your application
(``http://zf2-tutorial.localhost/``), you see the default skeleton
application introduction. Your list of albums is still available at the
/album route.

Setting Up Zend\\Navigation
---------------------------

Firstly, we need to tell our application which ``NavigationFactory`` to
use when using the bundled navigation view helpers. Thankfully, ZF2
comes with a default factory that will suit our needs just fine. To tell
ZF2 to use this default factory, we simply add a ``navigation`` key to
the service manager. Its best to do this in the ``Application`` module,
because, like the translation data, this is specific to the entire
application, and not just to our album pages:

**module/Application/config/module.config.php:**

.. code-block:: php
   :linenos:

   'service_manager' => array(
       'factories' => array(
           'navigation' => 'Zend\Navigation\Service\DefaultNavigationFactory', // <-- add this
       ),
   ),

Configuring our Site Map
------------------------

Next up, we need ``Zend\Navigation`` to understand the hierarchy of our
site. Thankfully, if we add a ``navigation`` key to our merged config,
the navigation factory will automagically create the container and pages
needed to use the view helpers. Let's do this in the ``Application``
module:

**module/Application/config/module.config.php:**

.. code-block:: php
   :linenos:

   return array(
   ...
   'navigation' => array(
       'default' => array(
           array(
               'label' => 'Home',
               'route' => 'home',
           ),
           array(
               'label' => 'Album',
               'route' => 'album',
               'pages' => array(
                   array(
                       'label' => 'Add',
                       'route' => 'album',
                       'action' => 'add',
                   ),
                   array(
                       'label' => 'Edit',
                       'route' => 'album',
                       'action' => 'edit',
                   ),
                   array(
                       'label' => 'Delete',
                       'route' => 'album',
                       'action' => 'delete',
                   ),
               ),
           ),
       ),
   ),
   ...
   );

This configuration maps out the pages we've defined in our controller,
with labels linking to the given route names. You can define highly
complex hierarchical sites here with pages and sub-pages linking to route
names, controller/action pairs or external uris. For more information
see the docs
`here <http://framework.zend.com/manual/2.2/en/modules/zend.navigation.quick-start.html>`__.

Adding the Menu View Helper
---------------------------

Now that we have the navigation helper configured by our service manager
and merged config, we can easily add the menu to the title bar to our
layout by using the :ref:`menu view helper <zend.navigation.view.helper.menu>`:

**module/Application/view/layout/layout.phtml:**

.. code-block:: html+php
   :linenos:

   ...
   <div class="collapse navbar-collapse">
       <?php // <-- Add this !!
       echo $this->navigation('navigation')->menu();
       ?>
   </div>
   ...

The navigation helper is built in to Zend Framework 2, and uses the
service manager configuration we've already defined to configure itself
automatically. Refreshing your application you will see a working menu, with
just a few tweaks however, we can make it look awesome:

**module/Application/view/layout/layout.phtml:**

.. code-block:: html+php
   :linenos:

   <div class="collapse navbar-collapse">
       <?php // <-- Update this !!
       echo $this->navigation('navigation')
                 ->menu()
                 ->setMinDepth(0)
                 ->setMaxDepth(0)
                 ->setUlClass('nav navbar-nav');
       ?>
   </div>

Here we tell the renderer to give the root UL the class of 'nav' so that
Twitter Bootstrap styles the menu correctly, and only render the first
level of any given page. If you view your application in your browser,
you will now see a nicely styled menu appear in the title bar. The great
thing about ``Zend\Navigation`` is that it integrates with ZF2's route
so can tell which page you are currently viewing. Because of this, it
sets the active page to have a class of ``active`` in the menu. Twitter
Bootstrap uses this to highlight your current page accordingly.

Adding Breadcrumbs
------------------

Adding breadcrumbs is initially just as simple. In our ``layout.phtml``
we want to add breadcrumbs above the main content pane, so our foolish
user knows exactly where they are in our complex website. Inside the
container div, before we output the content from the view, let's add a
simple breadcrumb by using the
:ref:`breadcrumbs view helper <zend.navigation.view.helper.breadcrumbs>`:

**module/Application/view/layout/layout.phtml:**

.. code-block:: html+php
   :linenos:

   ...
   <div class="container">
       <?php echo $this->navigation('navigation')->breadcrumbs()->setMinDepth(0); // <-- Add this!! ?>
       <?php echo $this->content; ?>
   </div>
   ...

This adds a simple but functional breadcrumb to every page (we simply
tell it to render from a depth of 0 so we see all level of pages) but we
can do better than that! Because Bootstrap has a styled breadcrumb as
part of it's base CSS, so let's add a partial that outputs the UL in
bootstrap happy CSS. We'll create it in the ``view`` directory of the
``Application`` module (this partial is application wide, rather than
album specific):

**module/Application/view/partial/breadcrumb.phtml:**

.. code-block:: html+php
   :linenos:

   <ul class="breadcrumb">
       <?php
       // iterate through the pages
       foreach ($this->pages as $key => $page):
           ?>
           <li>
               <?php
               // if this isn't the last page, add a link and the separator
               if ($key < count($this->pages) - 1):
                   ?>
                   <a href="<?php echo $page->getHref(); ?>"><?php echo $page->getLabel(); ?></a>
               <?php
               // otherwise, just output the name
               else:
               ?>
                   <?php echo $page->getLabel(); ?>
               <?php endif; ?>
           </li>
       <?php endforeach; ?>
   </ul>

Notice how the partial is passed a ``Zend\View\Model\ViewModel`` instance with the ``pages``
property set to an array of pages to render. Now all we have to do is
tell the breadcrumb helper to use the partial we have just written:

**module/Application/view/layout/layout.phtml:**

.. code-block:: html+php
   :linenos:

   ...
   <div class="container">
       <?php
       echo $this->navigation('navigation') // <-- Update this!!
                 ->breadcrumbs()
                 ->setMinDepth(0)
                 ->setPartial('partial/breadcrumb.phtml');
       ?>
       <?php echo $this->content; ?>
   </div>
   ...

Refreshing the page now gives us a lovely styled set of breadcrumbs on
each page.