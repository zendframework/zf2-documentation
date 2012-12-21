.. _zend.navigation.view.helper.menu:

View Helper - Menu
==================

The Menu helper is used for rendering menus from navigation containers. By default, the menu will be rendered using
*HTML* *UL* and *LI* tags, but the helper also allows using a partial view script.

Methods in the Menu helper:

- *{get|set}UlClass()* gets/sets the *CSS* class used in ``renderMenu()``.

- *{get|set}OnlyActiveBranch()* gets/sets a flag specifying whether only the active branch of a container should be
  rendered.

- *{get|set}RenderParents()* gets/sets a flag specifying whether parents should be rendered when only rendering
  active branch of a container. If set to ``FALSE``, only the deepest active menu will be rendered.

- *{get|set}Partial()* gets/sets a partial view script that should be used for rendering menu. If a partial view
  script is set, the helper's ``render()`` method will use the ``renderPartial()`` method. If no partial is set,
  the ``renderMenu()`` method is used. The helper expects the partial to be a ``String`` or an ``Array`` with two
  elements. If the partial is a ``String``, it denotes the name of the partial script to use. If it is an
  ``Array``, the first element will be used as the name of the partial view script, and the second element is the
  module where the script is found.

- ``htmlify()`` overrides the method from the abstract class to return *span* elements if the page has no *href*.

- ``renderMenu($container = null, $options = array())`` is the default render method, and will render a container
  as a *HTML* *UL* list.

  If ``$container`` is not given, the container registered in the helper will be rendered.

  ``$options`` is used for overriding options specified temporarily without rsetting the values in the helper
  instance. It is an associative array where each key corresponds to an option in the helper.

  Recognized options:

  - *indent*; indentation. Expects a ``String`` or an *int* value.

  - *minDepth*; minimum depth. Expcects an *int* or ``NULL`` (no minimum depth).

  - *maxDepth*; maximum depth. Expcects an *int* or ``NULL`` (no maximum depth).

  - *ulClass*; *CSS* class for *ul* element. Expects a ``String``.

  - *onlyActiveBranch*; whether only active branch should be rendered. Expects a ``Boolean`` value.

  - *renderParents*; whether parents should be rendered if only rendering active branch. Expects a ``Boolean``
    value.

  If an option is not given, the value set in the helper will be used.

- ``renderPartial()`` is used for rendering the menu using a partial view script.

- ``renderSubMenu()`` renders the deepest menu level of a container's active branch.

.. _zend.navigation.view.helper.menu.example1:

.. rubric:: Rendering a menu

This example shows how to render a menu from a container registered/found in the view helper. Notice how pages are
filtered out based on visibility and *ACL*.

.. code-block:: php
   :linenos:

   In a view script or layout:
   <?php echo $this->navigation()->menu()->render() ?>

   Or simply:
   <?php echo $this->navigation()->menu() ?>

   Output:
   <ul class="navigation">
       <li>
           <a title="Go Home" href="/">Home</a>
       </li>
       <li class="active">
           <a href="/products">Products</a>
           <ul>
               <li class="active">
                   <a href="/products/server">Foo Server</a>
                   <ul>
                       <li class="active">
                           <a href="/products/server/faq">FAQ</a>
                       </li>
                       <li>
                           <a href="/products/server/editions">Editions</a>
                       </li>
                       <li>
                           <a href="/products/server/requirements">System Requirements</a>
                       </li>
                   </ul>
               </li>
               <li>
                   <a href="/products/studio">Foo Studio</a>
                   <ul>
                       <li>
                           <a href="/products/studio/customers">Customer Stories</a>
                       </li>
                       <li>
                           <a href="/products/studio/support">Support</a>
                       </li>
                   </ul>
               </li>
           </ul>
       </li>
       <li>
           <a title="About us" href="/company/about">Company</a>
           <ul>
               <li>
                   <a href="/company/about/investors">Investor Relations</a>
               </li>
               <li>
                   <a class="rss" href="/company/news">News</a>
                   <ul>
                       <li>
                           <a href="/company/news/press">Press Releases</a>
                       </li>
                       <li>
                           <a href="/archive">Archive</a>
                       </li>
                   </ul>
               </li>
           </ul>
       </li>
       <li>
           <a href="/community">Community</a>
           <ul>
               <li>
                   <a href="/community/account">My Account</a>
               </li>
               <li>
                   <a class="external" href="http://forums.example.com/">Forums</a>
               </li>
           </ul>
       </li>
   </ul>

.. _zend.navigation.view.helper.menu.example2:

.. rubric:: Calling renderMenu() directly

This example shows how to render a menu that is not registered in the view helper by calling the ``renderMenu()``
directly and specifying a few options.

.. code-block:: php
   :linenos:

   <?php
   // render only the 'Community' menu
   $community = $this->navigation()->findOneByLabel('Community');
   $options = array(
       'indent'  => 16,
       'ulClass' => 'community'
   );
   echo $this->navigation()
             ->menu()
             ->renderMenu($community, $options);
   ?>
   Output:
                   <ul class="community">
                       <li>
                           <a href="/community/account">My Account</a>
                       </li>
                       <li>
                           <a class="external" href="http://forums.example.com/">Forums</a>
                       </li>
                   </ul>

.. _zend.navigation.view.helper.menu.example3:

.. rubric:: Rendering the deepest active menu

This example shows how the ``renderSubMenu()`` will render the deepest sub menu of the active branch.

Calling ``renderSubMenu($container, $ulClass, $indent)`` is equivalent to calling ``renderMenu($container,
$options)`` with the following options:

.. code-block:: php
   :linenos:

   array(
       'ulClass'          => $ulClass,
       'indent'           => $indent,
       'minDepth'         => null,
       'maxDepth'         => null,
       'onlyActiveBranch' => true,
       'renderParents'    => false
   );

.. code-block:: php
   :linenos:

   <?php
   echo $this->navigation()
             ->menu()
             ->renderSubMenu(null, 'sidebar', 4);
   ?>

   The output will be the same if 'FAQ' or 'Foo Server' is active:
       <ul class="sidebar">
           <li class="active">
               <a href="/products/server/faq">FAQ</a>
           </li>
           <li>
               <a href="/products/server/editions">Editions</a>
           </li>
           <li>
               <a href="/products/server/requirements">System Requirements</a>
           </li>
       </ul>

.. _zend.navigation.view.helper.menu.example4:

.. rubric:: Rendering a menu with maximum depth

.. code-block:: php
   :linenos:

   <?php
   echo $this->navigation()
             ->menu()
             ->setMaxDepth(1);
   ?>

   Output:
   <ul class="navigation">
       <li>
           <a title="Go Home" href="/">Home</a>
       </li>
       <li class="active">
           <a href="/products">Products</a>
           <ul>
               <li class="active">
                   <a href="/products/server">Foo Server</a>
               </li>
               <li>
                   <a href="/products/studio">Foo Studio</a>
               </li>
           </ul>
       </li>
       <li>
           <a title="About us" href="/company/about">Company</a>
           <ul>
               <li>
                   <a href="/company/about/investors">Investor Relations</a>
               </li>
               <li>
                   <a class="rss" href="/company/news">News</a>
               </li>
           </ul>
       </li>
       <li>
           <a href="/community">Community</a>
           <ul>
               <li>
                   <a href="/community/account">My Account</a>
               </li>
               <li>
                   <a class="external" href="http://forums.example.com/">Forums</a>
               </li>
           </ul>
       </li>
   </ul>

.. _zend.navigation.view.helper.menu.example5:

.. rubric:: Rendering a menu with minimum depth

.. code-block:: php
   :linenos:

   <?php
   echo $this->navigation()
             ->menu()
             ->setMinDepth(1);
   ?>

   Output:
   <ul class="navigation">
       <li class="active">
           <a href="/products/server">Foo Server</a>
           <ul>
               <li class="active">
                   <a href="/products/server/faq">FAQ</a>
               </li>
               <li>
                   <a href="/products/server/editions">Editions</a>
               </li>
               <li>
                   <a href="/products/server/requirements">System Requirements</a>
               </li>
           </ul>
       </li>
       <li>
           <a href="/products/studio">Foo Studio</a>
           <ul>
               <li>
                   <a href="/products/studio/customers">Customer Stories</a>
               </li>
               <li>
                   <a href="/products/studio/support">Support</a>
               </li>
           </ul>
       </li>
       <li>
           <a href="/company/about/investors">Investor Relations</a>
       </li>
       <li>
           <a class="rss" href="/company/news">News</a>
           <ul>
               <li>
                   <a href="/company/news/press">Press Releases</a>
               </li>
               <li>
                   <a href="/archive">Archive</a>
               </li>
           </ul>
       </li>
       <li>
           <a href="/community/account">My Account</a>
       </li>
       <li>
           <a class="external" href="http://forums.example.com/">Forums</a>
       </li>
   </ul>

.. _zend.navigation.view.helper.menu.example6:

.. rubric:: Rendering only the active branch of a menu

.. code-block:: php
   :linenos:

   <?php
   echo $this->navigation()
             ->menu()
             ->setOnlyActiveBranch(true);
   ?>

   Output:
   <ul class="navigation">
       <li class="active">
           <a href="/products">Products</a>
           <ul>
               <li class="active">
                   <a href="/products/server">Foo Server</a>
                   <ul>
                       <li class="active">
                           <a href="/products/server/faq">FAQ</a>
                       </li>
                       <li>
                           <a href="/products/server/editions">Editions</a>
                       </li>
                       <li>
                           <a href="/products/server/requirements">System Requirements</a>
                       </li>
                   </ul>
               </li>
           </ul>
       </li>
   </ul>

.. _zend.navigation.view.helper.menu.example7:

.. rubric:: Rendering only the active branch of a menu with minimum depth

.. code-block:: php
   :linenos:

   <?php
   echo $this->navigation()
             ->menu()
             ->setOnlyActiveBranch(true)
             ->setMinDepth(1);
   ?>

   Output:
   <ul class="navigation">
       <li class="active">
           <a href="/products/server">Foo Server</a>
           <ul>
               <li class="active">
                   <a href="/products/server/faq">FAQ</a>
               </li>
               <li>
                   <a href="/products/server/editions">Editions</a>
               </li>
               <li>
                   <a href="/products/server/requirements">System Requirements</a>
               </li>
           </ul>
       </li>
   </ul>

.. _zend.navigation.view.helper.menu.example8:

.. rubric:: Rendering only the active branch of a menu with maximum depth

.. code-block:: php
   :linenos:

   <?php
   echo $this->navigation()
             ->menu()
             ->setOnlyActiveBranch(true)
             ->setMaxDepth(1);
   ?>

   Output:
   <ul class="navigation">
       <li class="active">
           <a href="/products">Products</a>
           <ul>
               <li class="active">
                   <a href="/products/server">Foo Server</a>
               </li>
               <li>
                   <a href="/products/studio">Foo Studio</a>
               </li>
           </ul>
       </li>
   </ul>

.. _zend.navigation.view.helper.menu.example9:

.. rubric:: Rendering only the active branch of a menu with maximum depth and no parents

.. code-block:: php
   :linenos:

   <?php
   echo $this->navigation()
             ->menu()
             ->setOnlyActiveBranch(true)
             ->setRenderParents(false)
             ->setMaxDepth(1);
   ?>

   Output:
   <ul class="navigation">
       <li class="active">
           <a href="/products/server">Foo Server</a>
       </li>
       <li>
           <a href="/products/studio">Foo Studio</a>
       </li>
   </ul>

.. _zend.navigation.view.helper.menu.example10:

.. rubric:: Rendering a custom menu using a partial view script

This example shows how to render a custom menu using a partial vew script. By calling ``setPartial()``, you can
specify a partial view script that will be used when calling ``render()``. When a partial is specified, the
``renderPartial()`` method will be called. This method will assign the container to the view with the key
*container*.

In a layout:

.. code-block:: php
   :linenos:

   $partial = array('menu.phtml', 'default');
   $this->navigation()->menu()->setPartial($partial);
   echo $this->navigation()->menu()->render();

In application/modules/default/views/menu.phtml:

.. code-block:: php
   :linenos:

   foreach ($this->container as $page) {
       echo $this->navigation()->menu()->htmlify($page), PHP_EOL;
   }

Output:

.. code-block:: php
   :linenos:

   <a title="Go Home" href="/">Home</a>
   <a href="/products">Products</a>
   <a title="About us" href="/company/about">Company</a>
   <a href="/community">Community</a>