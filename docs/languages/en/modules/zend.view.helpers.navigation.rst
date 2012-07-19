.. _zend.view.helpers.initial.navigation:

Navigation Helpers
==================

The navigation helpers are used for rendering navigational elements from :ref:`Zend_Navigation_Container
<zend.navigation.containers>` instances.

There are 5 built-in helpers:

- :ref:`Breadcrumbs <zend.view.helpers.initial.navigation.breadcrumbs>`, used for rendering the path to the
  currently active page.

- :ref:`Links <zend.view.helpers.initial.navigation.links>`, used for rendering navigational head links (e.g.
  ``<link rel="next" href="..." />``)

- :ref:`Menu <zend.view.helpers.initial.navigation.menu>`, used for rendering menus.

- :ref:`Sitemap <zend.view.helpers.initial.navigation.sitemap>`, used for rendering sitemaps conforming to the
  `Sitemaps XML format`_.

- :ref:`Navigation <zend.view.helpers.initial.navigation.navigation>`, used for proxying calls to other
  navigational helpers.

All built-in helpers extend ``Zend_View_Helper_Navigation_HelperAbstract``, which adds integration with :ref:`ACL
<zend.acl>` and :ref:`translation <zend.i18n.translating>`. The abstract class implements the interface
``Zend_View_Helper_Navigation_Helper``, which defines the following methods:

- ``getContainer()`` and ``setContainer()`` gets and sets the navigation container the helper should operate on by
  default, and ``hasContainer()`` checks if the helper has container registered.

- ``getTranslator()`` and ``setTranslator()`` gets and sets the translator used for translating labels and titles.
  ``getUseTranslator()`` and ``setUseTranslator()`` controls whether the translator should be enabled. The method
  ``hasTranslator()`` checks if the helper has a translator registered.

- ``getAcl()``, ``setAcl()``, ``getRole()`` and ``setRole()``, gets and sets *ACL* (``Zend_Acl``) instance and role
  (``String`` or ``Zend_Acl_Role_Interface``) used for filtering out pages when rendering. ``getUseAcl()`` and
  ``setUseAcl()`` controls whether *ACL* should be enabled. The methods ``hasAcl()`` and ``hasRole()`` checks if
  the helper has an *ACL* instance or a role registered.

- ``__toString()``, magic method to ensure that helpers can be rendered by echoing the helper instance directly.

- ``render()``, must be implemented by concrete helpers to do the actual rendering.

In addition to the method stubs from the interface, the abstract class also implements the following methods:

- ``getIndent()`` and ``setIndent()`` gets and sets indentation. The setter accepts a ``String`` or an ``Integer``.
  In the case of an ``Integer``, the helper will use the given number of spaces for indentation. I.e.,
  ``setIndent(4)`` means 4 initial spaces of indentation. Indentation can be specified for all helpers except the
  Sitemap helper.

- ``getMinDepth()`` and ``setMinDepth()`` gets and sets the minimum depth a page must have to be included by the
  helper. Setting ``NULL`` means no minimum depth.

- ``getMaxDepth()`` and ``setMaxDepth()`` gets and sets the maximum depth a page can have to be included by the
  helper. Setting ``NULL`` means no maximum depth.

- ``getRenderInvisible()`` and ``setRenderInvisible()`` gets and sets whether to render items that have been marked
  as invisible or not.

- ``__call()`` is used for proxying calls to the container registered in the helper, which means you can call
  methods on a helper as if it was a container. See :ref:`example
  <zend.view.helpers.initial.navigation.proxy.example>` below.

- ``findActive($container, $minDepth, $maxDepth)`` is used for finding the deepest active page in the given
  container. If depths are not given, the method will use the values retrieved from ``getMinDepth()`` and
  ``getMaxDepth()``. The deepest active page must be between ``$minDepth`` and ``$maxDepth`` inclusively. Returns
  an array containing a reference to the found page instance and the depth at which the page was found.

- ``htmlify()`` renders an **'a'** *HTML* element from a ``Zend_Navigation_Page`` instance.

- ``accept()`` is used for determining if a page should be accepted when iterating containers. This method checks
  for page visibility and verifies that the helper's role is allowed access to the page's resource and privilege.

- The static method ``setDefaultAcl()`` is used for setting a default *ACL* object that will be used by helpers.

- The static method ``setDefaultRole()`` is used for setting a default *ACL* that will be used by helpers

If a navigation container is not explicitly set in a helper using ``$helper->setContainer($nav)``, the helper will
look for a container instance with the key ``Zend_Navigation`` in :ref:`the registry <zend.registry>`. If a
container is not explicitly set or found in the registry, the helper will create an empty ``Zend_Navigation``
container when calling ``$helper->getContainer()``.

.. _zend.view.helpers.initial.navigation.proxy.example:

.. rubric:: Proxying calls to the navigation container

Navigation view helpers use the magic method ``__call()`` to proxy method calls to the navigation container that is
registered in the view helper.

.. code-block:: php
   :linenos:

   $this->navigation()->addPage(array(
       'type' => 'uri',
       'label' => 'New page'));

The call above will add a page to the container in the ``Navigation`` helper.

.. _zend.view.helpers.initial.navigation.i18n:

Translation of labels and titles
--------------------------------

The navigation helpers support translation of page labels and titles. You can set a translator of type
``Zend\I18n\Translator`` in the helper using ``$helper->setTranslator($translator)``.

If you want to disable translation, use ``$helper->setUseTranslator(false)``.

The :ref:`proxy helper <zend.view.helpers.initial.navigation.navigation>` will inject its own translator to the
helper it proxies to if the proxied helper doesn't already have a translator.

.. note::

   There is no translation in the sitemap helper, since there are no page labels or titles involved in an *XML*
   sitemap.

.. _zend.view.helpers.initial.navigation.acl:

Integration with ACL
--------------------

All navigational view helpers support *ACL* inherently from the class
``Zend_View_Helper_Navigation_HelperAbstract``. A ``Zend_Acl`` object can be assigned to a helper instance with
*$helper->setAcl($acl)*, and role with *$helper->setRole('member')* or *$helper->setRole(new
Zend_Acl_Role('member'))*. If *ACL* is used in the helper, the role in the helper must be allowed by the *ACL* to
access a page's *resource* and/or have the page's *privilege* for the page to be included when rendering.

If a page is not accepted by *ACL*, any descendant page will also be excluded from rendering.

The :ref:`proxy helper <zend.view.helpers.initial.navigation.navigation>` will inject its own *ACL* and role to the
helper it proxies to if the proxied helper doesn't already have any.

The examples below all show how *ACL* affects rendering.

.. _zend.view.helpers.initial.navigation.setup:

Navigation setup used in examples
---------------------------------

This example shows the setup of a navigation container for a fictional software company.

Notes on the setup:

- The domain for the site is *www.example.com*.

- Interesting page properties are marked with a comment.

- Unless otherwise is stated in other examples, the user is requesting the *URL*
  *http://www.example.com/products/server/faq/*, which translates to the page labeled ``FAQ`` under *Foo Server*.

- The assumed *ACL* and router setup is shown below the container setup.

.. code-block:: php
   :linenos:

   /*
    * Navigation container (config/array)

    * Each element in the array will be passed to
    * Zend_Navigation_Page::factory() when constructing
    * the navigation container below.
    */
   $pages = array(
       array(
           'label'      => 'Home',
           'title'      => 'Go Home',
           'module'     => 'default',
           'controller' => 'index',
           'action'     => 'index',
           'order'      => -100 // make sure home is the first page
       ),
       array(
           'label'      => 'Special offer this week only!',
           'module'     => 'store',
           'controller' => 'offer',
           'action'     => 'amazing',
           'visible'    => false // not visible
       ),
       array(
           'label'      => 'Products',
           'module'     => 'products',
           'controller' => 'index',
           'action'     => 'index',
           'pages'      => array(
               array(
                   'label'      => 'Foo Server',
                   'module'     => 'products',
                   'controller' => 'server',
                   'action'     => 'index',
                   'pages'      => array(
                       array(
                           'label'      => 'FAQ',
                           'module'     => 'products',
                           'controller' => 'server',
                           'action'     => 'faq',
                           'rel'        => array(
                               'canonical' => 'http://www.example.com/?page=faq',
                               'alternate' => array(
                                   'module'     => 'products',
                                   'controller' => 'server',
                                   'action'     => 'faq',
                                   'params'     => array('format' => 'xml')
                               )
                           )
                       ),
                       array(
                           'label'      => 'Editions',
                           'module'     => 'products',
                           'controller' => 'server',
                           'action'     => 'editions'
                       ),
                       array(
                           'label'      => 'System Requirements',
                           'module'     => 'products',
                           'controller' => 'server',
                           'action'     => 'requirements'
                       )
                   )
               ),
               array(
                   'label'      => 'Foo Studio',
                   'module'     => 'products',
                   'controller' => 'studio',
                   'action'     => 'index',
                   'pages'      => array(
                       array(
                           'label'      => 'Customer Stories',
                           'module'     => 'products',
                           'controller' => 'studio',
                           'action'     => 'customers'
                       ),
                       array(
                           'label'      => 'Support',
                           'module'     => 'prodcts',
                           'controller' => 'studio',
                           'action'     => 'support'
                       )
                   )
               )
           )
       ),
       array(
           'label'      => 'Company',
           'title'      => 'About us',
           'module'     => 'company',
           'controller' => 'about',
           'action'     => 'index',
           'pages'      => array(
               array(
                   'label'      => 'Investor Relations',
                   'module'     => 'company',
                   'controller' => 'about',
                   'action'     => 'investors'
               ),
               array(
                   'label'      => 'News',
                   'class'      => 'rss', // class
                   'module'     => 'company',
                   'controller' => 'news',
                   'action'     => 'index',
                   'pages'      => array(
                       array(
                           'label'      => 'Press Releases',
                           'module'     => 'company',
                           'controller' => 'news',
                           'action'     => 'press'
                       ),
                       array(
                           'label'      => 'Archive',
                           'route'      => 'archive', // route
                           'module'     => 'company',
                           'controller' => 'news',
                           'action'     => 'archive'
                       )
                   )
               )
           )
       ),
       array(
           'label'      => 'Community',
           'module'     => 'community',
           'controller' => 'index',
           'action'     => 'index',
           'pages'      => array(
               array(
                   'label'      => 'My Account',
                   'module'     => 'community',
                   'controller' => 'account',
                   'action'     => 'index',
                   'resource'   => 'mvc:community.account' // resource
               ),
               array(
                   'label' => 'Forums',
                   'uri'   => 'http://forums.example.com/',
                   'class' => 'external' // class
               )
           )
       ),
       array(
           'label'      => 'Administration',
           'module'     => 'admin',
           'controller' => 'index',
           'action'     => 'index',
           'resource'   => 'mvc:admin', // resource
           'pages'      => array(
               array(
                   'label'      => 'Write new article',
                   'module'     => 'admin',
                   'controller' => 'post',
                   'aciton'     => 'write'
               )
           )
       )
   );

   // Create container from array
   $container = new Zend_Navigation($pages);

   // Store the container in the proxy helper:
   $view->getHelper('navigation')->setContainer($container);

   // ...or simply:
   $view->navigation($container);

   // ...or store it in the reigstry:
   Zend_Registry::set('Zend_Navigation', $container);

In addition to the container above, the following setup is assumed:

.. code-block:: php
   :linenos:

   // Setup router (default routes and 'archive' route):
   $front = Zend_Controller_Front::getInstance();
   $router = $front->getRouter();
   $router->addDefaultRoutes();
   $router->addRoute(
       'archive',
       new Zend_Controller_Router_Route(
           '/archive/:year',
           array(
               'module'     => 'company',
               'controller' => 'news',
               'action'     => 'archive',
               'year'       => (int) date('Y') - 1
           ),
           array('year' => '\d+')
       )
   );

   // Setup ACL:
   $acl = new Zend_Acl();
   $acl->addRole(new Zend_Acl_Role('member'));
   $acl->addRole(new Zend_Acl_Role('admin'));
   $acl->add(new Zend_Acl_Resource('mvc:admin'));
   $acl->add(new Zend_Acl_Resource('mvc:community.account'));
   $acl->allow('member', 'mvc:community.account');
   $acl->allow('admin', null);

   // Store ACL and role in the proxy helper:
   $view->navigation()->setAcl($acl)->setRole('member');

   // ...or set default ACL and role statically:
   Zend_View_Helper_Navigation_HelperAbstract::setDefaultAcl($acl);
   Zend_View_Helper_Navigation_HelperAbstract::setDefaultRole('member');

.. _zend.view.helpers.initial.navigation.breadcrumbs:

Breadcrumbs Helper
------------------

Breadcrumbs are used for indicating where in a sitemap a user is currently browsing, and are typically rendered
like this: "You are here: Home > Products > FantasticProduct 1.0". The breadcrumbs helper follows the guidelines
from `Breadcrumbs Pattern - Yahoo! Design Pattern Library`_, and allows simple customization (minimum/maximum
depth, indentation, separator, and whether the last element should be linked), or rendering using a partial view
script.

The Breadcrumbs helper works like this; it finds the deepest active page in a navigation container, and renders an
upwards path to the root. For *MVC* pages, the "activeness" of a page is determined by inspecting the request
object, as stated in the section on :ref:`Zend_Navigation_Page_Mvc <zend.navigation.pages.mvc>`.

The helper sets the *minDepth* property to 1 by default, meaning breadcrumbs will not be rendered if the deepest
active page is a root page. If *maxDepth* is specified, the helper will stop rendering when at the specified depth
(e.g. stop at level 2 even if the deepest active page is on level 3).

Methods in the breadcrumbs helper:

- *{get|set}Separator()* gets/sets separator string that is used between breadcrumbs. Defualt is *' &gt; '*.

- *{get|set}LinkLast()* gets/sets whether the last breadcrumb should be rendered as an anchor or not. Default is
  ``FALSE``.

- *{get|set}Partial()* gets/sets a partial view script that should be used for rendering breadcrumbs. If a partial
  view script is set, the helper's ``render()`` method will use the ``renderPartial()`` method. If no partial is
  set, the ``renderStraight()`` method is used. The helper expects the partial to be a ``String`` or an ``Array``
  with two elements. If the partial is a ``String``, it denotes the name of the partial script to use. If it is an
  ``Array``, the first element will be used as the name of the partial view script, and the second element is the
  module where the script is found.

- ``renderStraight()`` is the default render method.

- ``renderPartial()`` is used for rendering using a partial view script.

.. _zend.view.helpers.initial.navigation.breadcrumbs.example1:

.. rubric:: Rendering breadcrumbs

This example shows how to render breadcrumbs with default settings.

.. code-block:: php
   :linenos:

   In a view script or layout:
   <?php echo $this->navigation()->breadcrumbs(); ?>

   The two calls above take advantage of the magic __toString() method,
   and are equivalent to:
   <?php echo $this->navigation()->breadcrumbs()->render(); ?>

   Output:
   <a href="/products">Products</a> > <a href="/products/server">Foo Server</a> > FAQ

.. _zend.view.helpers.initial.navigation.breadcrumbs.example2:

.. rubric:: Specifying indentation

This example shows how to render breadcrumbs with initial indentation.

.. code-block:: php
   :linenos:

   Rendering with 8 spaces indentation:
   <?php echo $this->navigation()->breadcrumbs()->setIndent(8);?>

   Output:
           <a href="/products">Products</a> > <a href="/products/server">Foo Server</a> > FAQ

.. _zend.view.helpers.initial.navigation.breadcrumbs.example3:

.. rubric:: Customize breadcrumbs output

This example shows how to customze breadcrumbs output by specifying various options.

.. code-block:: php
   :linenos:

   In a view script or layout:

   <?php
   echo $this->navigation()
             ->breadcrumbs()
             ->setLinkLast(true)                   // link last page
             ->setMaxDepth(1)                      // stop at level 1
             ->setSeparator(' ▶' . PHP_EOL); // cool separator with newline
   ?>

   Output:
   <a href="/products">Products</a> ▶
   <a href="/products/server">Foo Server</a>

   /////////////////////////////////////////////////////

   Setting minimum depth required to render breadcrumbs:

   <?php
   $this->navigation()->breadcrumbs()->setMinDepth(10);
   echo $this->navigation()->breadcrumbs();
   ?>

   Output:
   Nothing, because the deepest active page is not at level 10 or deeper.

.. _zend.view.helpers.initial.navigation.breadcrumbs.example4:

.. rubric:: Rendering breadcrumbs using a partial view script

This example shows how to render customized breadcrumbs using a partial vew script. By calling ``setPartial()``,
you can specify a partial view script that will be used when calling ``render()``. When a partial is specified, the
``renderPartial()`` method will be called. This method will find the deepest active page and pass an array of pages
that leads to the active page to the partial view script.

In a layout:

.. code-block:: php
   :linenos:

   $partial = ;
   echo $this->navigation()->breadcrumbs()
                           ->setPartial(array('breadcrumbs.phtml', 'default'));

Contents of *application/modules/default/views/breadcrumbs.phtml*:

.. code-block:: php
   :linenos:

   echo implode(', ', array_map(
           create_function('$a', 'return $a->getLabel();'),
           $this->pages));

Output:

.. code-block:: php
   :linenos:

   Products, Foo Server, FAQ

.. _zend.view.helpers.initial.navigation.links:

Links Helper
------------

The links helper is used for rendering *HTML* ``LINK`` elements. Links are used for describing document
relationships of the currently active page. Read more about links and link types at `Document relationships: the
LINK element (HTML4 W3C Rec.)`_ and `Link types (HTML4 W3C Rec.)`_ in the *HTML*\ 4 W3C Recommendation.

There are two types of relations; forward and reverse, indicated by the keyords *'rel'* and *'rev'*. Most methods
in the helper will take a ``$rel`` param, which must be either *'rel'* or *'rev'*. Most methods also take a
``$type`` param, which is used for specifying the link type (e.g. alternate, start, next, prev, chapter, etc).

Relationships can be added to page objects manually, or found by traversing the container registered in the helper.
The method ``findRelation($page, $rel, $type)`` will first try to find the given ``$rel`` of ``$type`` from the
``$page`` by calling *$page->findRel($type)* or *$page->findRel($type)*. If the ``$page`` has a relation that can
be converted to a page instance, that relation will be used. If the ``$page`` instance doesn't have the specified
``$type``, the helper will look for a method in the helper named *search$rel$type* (e.g. ``searchRelNext()`` or
``searchRevAlternate()``). If such a method exists, it will be used for determining the ``$page``'s relation by
traversing the container.

Not all relations can be determined by traversing the container. These are the relations that will be found by
searching:

- ``searchRelStart()``, forward 'start' relation: the first page in the container.

- ``searchRelNext()``, forward 'next' relation; finds the next page in the container, i.e. the page after the
  active page.

- ``searchRelPrev()``, forward 'prev' relation; finds the previous page, i.e. the page before the active page.

- ``searchRelChapter()``, forward 'chapter' relations; finds all pages on level 0 except the 'start' relation or
  the active page if it's on level 0.

- ``searchRelSection()``, forward 'section' relations; finds all child pages of the active page if the active page
  is on level 0 (a 'chapter').

- ``searchRelSubsection()``, forward 'subsection' relations; finds all child pages of the active page if the active
  pages is on level 1 (a 'section').

- ``searchRevSection()``, reverse 'section' relation; finds the parent of the active page if the active page is on
  level 1 (a 'section').

- ``searchRevSubsection()``, reverse 'subsection' relation; finds the parent of the active page if the active page
  is on level 2 (a 'subsection').

.. note::

   When looking for relations in the page instance (*$page->getRel($type)* or *$page->getRev($type)*), the helper
   accepts the values of type ``String``, ``Array``, ``Zend_Config``, or ``Zend_Navigation_Page``. If a string is
   found, it will be converted to a ``Zend_Navigation_Page_Uri``. If an array or a config is found, it will be
   converted to one or several page instances. If the first key of the array/config is numeric, it will be
   considered to contain several pages, and each element will be passed to the :ref:`page factory
   <zend.navigation.pages.factory>`. If the first key is not numeric, the array/config will be passed to the page
   factory directly, and a single page will be returned.

The helper also supports magic methods for finding relations. E.g. to find forward alternate relations, call
*$helper->findRelAlternate($page)*, and to find reverse section relations, call *$helper->findRevSection($page)*.
Those calls correspond to *$helper->findRelation($page, 'rel', 'alternate');* and *$helper->findRelation($page,
'rev', 'section');* respectively.

To customize which relations should be rendered, the helper uses a render flag. The render flag is an integer
value, and will be used in a `bitwse and (&) operation`_ against the helper's render constants to determine if the
relation that belongs to the render constant should be rendered.

See the :ref:`example below <zend.view.helpers.initial.navigation.links.example3>` for more information.

- ``Zend_View_Helper_Navigation_Link::RENDER_ALTERNATE``

- ``Zend_View_Helper_Navigation_Link::RENDER_STYLESHEET``

- ``Zend_View_Helper_Navigation_Link::RENDER_START``

- ``Zend_View_Helper_Navigation_Link::RENDER_NEXT``

- ``Zend_View_Helper_Navigation_Link::RENDER_PREV``

- ``Zend_View_Helper_Navigation_Link::RENDER_CONTENTS``

- ``Zend_View_Helper_Navigation_Link::RENDER_INDEX``

- ``Zend_View_Helper_Navigation_Link::RENDER_GLOSSARY``

- ``Zend_View_Helper_Navigation_Link::RENDER_COPYRIGHT``

- ``Zend_View_Helper_Navigation_Link::RENDER_CHAPTER``

- ``Zend_View_Helper_Navigation_Link::RENDER_SECTION``

- ``Zend_View_Helper_Navigation_Link::RENDER_SUBSECTION``

- ``Zend_View_Helper_Navigation_Link::RENDER_APPENDIX``

- ``Zend_View_Helper_Navigation_Link::RENDER_HELP``

- ``Zend_View_Helper_Navigation_Link::RENDER_BOOKMARK``

- ``Zend_View_Helper_Navigation_Link::RENDER_CUSTOM``

- ``Zend_View_Helper_Navigation_Link::RENDER_ALL``

The constants from ``RENDER_ALTERNATE`` to ``RENDER_BOOKMARK`` denote standard *HTML* link types. ``RENDER_CUSTOM``
denotes non-standard relations that specified in pages. ``RENDER_ALL`` denotes standard and non-standard relations.

Methods in the links helper:

- *{get|set}RenderFlag()* gets/sets the render flag. Default is ``RENDER_ALL``. See examples below on how to set
  the render flag.

- ``findAllRelations()`` finds all relations of all types for a given page.

- ``findRelation()`` finds all relations of a given type from a given page.

- *searchRel{Start|Next|Prev|Chapter|Section|Subsection}()* traverses a container to find forward relations to the
  start page, the next page, the previous page, chapters, sections, and subsections.

- *searchRev{Section|Subsection}()* traverses a container to find reverse relations to sections or subsections.

- ``renderLink()`` renders a single *link* element.

.. _zend.view.helpers.initial.navigation.links.example1:

.. rubric:: Specify relations in pages

This example shows how to specify relations in pages.

.. code-block:: php
   :linenos:

   $container = new Zend_Navigation(array(
       array(
           'label' => 'Relations using strings',
           'rel'   => array(
               'alternate' => 'http://www.example.org/'
           ),
           'rev'   => array(
               'alternate' => 'http://www.example.net/'
           )
       ),
       array(
           'label' => 'Relations using arrays',
           'rel'   => array(
               'alternate' => array(
                   'label' => 'Example.org',
                   'uri'   => 'http://www.example.org/'
               )
           )
       ),
       array(
           'label' => 'Relations using configs',
           'rel'   => array(
               'alternate' => new Zend_Config(array(
                   'label' => 'Example.org',
                   'uri'   => 'http://www.example.org/'
               ))
           )
       ),
       array(
           'label' => 'Relations using pages instance',
           'rel'   => array(
               'alternate' => Zend_Navigation_Page::factory(array(
                   'label' => 'Example.org',
                   'uri'   => 'http://www.example.org/'
               ))
           )
       )
   ));

.. _zend.view.helpers.initial.navigation.links.example2:

.. rubric:: Default rendering of links

This example shows how to render a menu from a container registered/found in the view helper.

.. code-block:: php
   :linenos:

   In a view script or layout:
   <?php echo $this->view->navigation()->links(); ?>

   Output:
   <link rel="alternate" href="/products/server/faq/format/xml">
   <link rel="start" href="/" title="Home">
   <link rel="next" href="/products/server/editions" title="Editions">
   <link rel="prev" href="/products/server" title="Foo Server">
   <link rel="chapter" href="/products" title="Products">
   <link rel="chapter" href="/company/about" title="Company">
   <link rel="chapter" href="/community" title="Community">
   <link rel="canonical" href="http://www.example.com/?page=server-faq">
   <link rev="subsection" href="/products/server" title="Foo Server">

.. _zend.view.helpers.initial.navigation.links.example3:

.. rubric:: Specify which relations to render

This example shows how to specify which relations to find and render.

.. code-block:: php
   :linenos:

   Render only start, next, and prev:
   $helper->setRenderFlag(Zend_View_Helper_Navigation_Links::RENDER_START |
                          Zend_View_Helper_Navigation_Links::RENDER_NEXT |
                          Zend_View_Helper_Navigation_Links::RENDER_PREV);

   Output:
   <link rel="start" href="/" title="Home">
   <link rel="next" href="/products/server/editions" title="Editions">
   <link rel="prev" href="/products/server" title="Foo Server">

.. code-block:: php
   :linenos:

   Render only native link types:
   $helper->setRenderFlag(Zend_View_Helper_Navigation_Links::RENDER_ALL ^
                          Zend_View_Helper_Navigation_Links::RENDER_CUSTOM);

   Output:
   <link rel="alternate" href="/products/server/faq/format/xml">
   <link rel="start" href="/" title="Home">
   <link rel="next" href="/products/server/editions" title="Editions">
   <link rel="prev" href="/products/server" title="Foo Server">
   <link rel="chapter" href="/products" title="Products">
   <link rel="chapter" href="/company/about" title="Company">
   <link rel="chapter" href="/community" title="Community">
   <link rev="subsection" href="/products/server" title="Foo Server">

.. code-block:: php
   :linenos:

   Render all but chapter:
   $helper->setRenderFlag(Zend_View_Helper_Navigation_Links::RENDER_ALL ^
                          Zend_View_Helper_Navigation_Links::RENDER_CHAPTER);

   Output:
   <link rel="alternate" href="/products/server/faq/format/xml">
   <link rel="start" href="/" title="Home">
   <link rel="next" href="/products/server/editions" title="Editions">
   <link rel="prev" href="/products/server" title="Foo Server">
   <link rel="canonical" href="http://www.example.com/?page=server-faq">
   <link rev="subsection" href="/products/server" title="Foo Server">

.. _zend.view.helpers.initial.navigation.menu:

Menu Helper
-----------

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

.. _zend.view.helpers.initial.navigation.menu.example1:

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
                           <a href="/prodcts/studio/support">Support</a>
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

.. _zend.view.helpers.initial.navigation.menu.example2:

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

.. _zend.view.helpers.initial.navigation.menu.example3:

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

.. _zend.view.helpers.initial.navigation.menu.example4:

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

.. _zend.view.helpers.initial.navigation.menu.example5:

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
                   <a href="/prodcts/studio/support">Support</a>
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

.. _zend.view.helpers.initial.navigation.menu.example6:

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

.. _zend.view.helpers.initial.navigation.menu.example7:

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

.. _zend.view.helpers.initial.navigation.menu.example8:

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

.. _zend.view.helpers.initial.navigation.menu.example9:

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

.. _zend.view.helpers.initial.navigation.menu.example10:

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

.. _zend.view.helpers.initial.navigation.sitemap:

Sitemap Helper
--------------

The Sitemap helper is used for generating *XML* sitemaps, as defined by the `Sitemaps XML format`_. Read more about
`Sitemaps on Wikpedia`_.

By default, the sitemap helper uses :ref:`sitemap validators <zend.validator.sitemap>` to validate each element
that is rendered. This can be disabled by calling *$helper->setUseSitemapValidators(false)*.

.. note::

   If you disable sitemap validators, the custom properties (see table) are not validated at all.

The sitemap helper also supports `Sitemap XSD Schema`_ validation of the generated sitemap. This is disabled by
default, since it will require a request to the Schema file. It can be enabled with
*$helper->setUseSchemaValidation(true)*.

.. _zend.view.helpers.initial.navigation.sitemap.elements:

.. table:: Sitemap XML elements

   +----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Element   |Description                                                                                                                                                                                                                                                                                                                                                                                           |
   +==========+======================================================================================================================================================================================================================================================================================================================================================================================================+
   |loc       |Absolute URL to page. An absolute URL will be generated by the helper.                                                                                                                                                                                                                                                                                                                                |
   +----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |lastmod   |The date of last modification of the file, in W3C Datetime format. This time portion can be omitted if desired, and only use YYYY-MM-DD. The helper will try to retrieve the lastmod value from the page's custom property lastmod if it is set in the page. If the value is not a valid date, it is ignored.                                                                                         |
   +----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |changefreq|How frequently the page is likely to change. This value provides general information to search engines and may not correlate exactly to how often they crawl the page. Valid values are: alwayshourlydailyweeklymonthlyyearlynever The helper will try to retrieve the changefreq value from the page's custom property changefreq if it is set in the page. If the value is not valid, it is ignored.|
   +----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |priority  |The priority of this URL relative to other URLs on your site. Valid values range from 0.0 to 1.0. The helper will try to retrieve the priority value from the page's custom property priority if it is set in the page. If the value is not valid, it is ignored.                                                                                                                                     |
   +----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Methods in the sitemap helper:

- *{get|set}FormatOutput()* gets/sets a flag indicating whether *XML* output should be formatted. This corresponds
  to the *formatOutput* property of the native ``DOMDocument`` class. Read more at `PHP: DOMDocument - Manual`_.
  Default is ``FALSE``.

- *{get|set}UseXmlDeclaration()* gets/sets a flag indicating whether the *XML* declaration should be included when
  rendering. Default is ``TRUE``.

- *{get|set}UseSitemapValidators()* gets/sets a flag indicating whether sitemap validators should be used when
  generating the DOM sitemap. Default is ``TRUE``.

- *{get|set}UseSchemaValidation()* gets/sets a flag indicating whether the helper should use *XML* Schema
  validation when generating the DOM sitemap. Default is ``FALSE``. If ``TRUE``.

- *{get|set}ServerUrl()* gets/sets server *URL* that will be prepended to non-absolute *URL*\ s in the ``url()``
  method. If no server *URL* is specified, it will be determined by the helper.

- ``url()`` is used to generate absolute *URL*\ s to pages.

- ``getDomSitemap()`` generates a DOMDocument from a given container.

.. _zend.view.helpers.initial.navigation.sitemap.example:

.. rubric:: Rendering an XML sitemap

This example shows how to render an *XML* sitemap based on the setup we did further up.

.. code-block:: php
   :linenos:

   // In a view script or layout:

   // format output
   $this->navigation()
         ->sitemap()
         ->setFormatOutput(true); // default is false

   // other possible methods:
   // ->setUseXmlDeclaration(false); // default is true
   // ->setServerUrl('http://my.otherhost.com');
   // default is to detect automatically

   // print sitemap
   echo $this->navigation()->sitemap();

Notice how pages that are invisible or pages with *ACL* roles incompatible with the view helper are filtered out:

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
     <url>
       <loc>http://www.example.com/</loc>
     </url>
     <url>
       <loc>http://www.example.com/products</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server/faq</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server/editions</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server/requirements</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/studio</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/studio/customers</loc>
     </url>
     <url>
       <loc>http://www.example.com/prodcts/studio/support</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/about</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/about/investors</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/news</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/news/press</loc>
     </url>
     <url>
       <loc>http://www.example.com/archive</loc>
     </url>
     <url>
       <loc>http://www.example.com/community</loc>
     </url>
     <url>
       <loc>http://www.example.com/community/account</loc>
     </url>
     <url>
       <loc>http://forums.example.com/</loc>
     </url>
   </urlset>

Render the sitemap using no *ACL* role (should filter out /community/account):

.. code-block:: php
   :linenos:

   echo $this->navigation()
             ->sitemap()
             ->setFormatOutput(true)
             ->setRole();

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
     <url>
       <loc>http://www.example.com/</loc>
     </url>
     <url>
       <loc>http://www.example.com/products</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server/faq</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server/editions</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server/requirements</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/studio</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/studio/customers</loc>
     </url>
     <url>
       <loc>http://www.example.com/prodcts/studio/support</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/about</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/about/investors</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/news</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/news/press</loc>
     </url>
     <url>
       <loc>http://www.example.com/archive</loc>
     </url>
     <url>
       <loc>http://www.example.com/community</loc>
     </url>
     <url>
       <loc>http://forums.example.com/</loc>
     </url>
   </urlset>

Render the sitemap using a maximum depth of 1.

.. code-block:: php
   :linenos:

   echo $this->navigation()
             ->sitemap()
             ->setFormatOutput(true)
             ->setMaxDepth(1);

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
     <url>
       <loc>http://www.example.com/</loc>
     </url>
     <url>
       <loc>http://www.example.com/products</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/server</loc>
     </url>
     <url>
       <loc>http://www.example.com/products/studio</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/about</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/about/investors</loc>
     </url>
     <url>
       <loc>http://www.example.com/company/news</loc>
     </url>
     <url>
       <loc>http://www.example.com/community</loc>
     </url>
     <url>
       <loc>http://www.example.com/community/account</loc>
     </url>
     <url>
       <loc>http://forums.example.com/</loc>
     </url>
   </urlset>

.. note::

   **UTF-8 encoding used by default**

   By default, Zend Framework uses *UTF-8* as its default encoding, and, specific to this case, ``Zend_View`` does
   as well. Character encoding can be set differently on the view object itself using the ``setEncoding()`` method
   (or the the ``encoding`` instantiation parameter). However, since ``Zend_View_Interface`` does not define
   accessors for encoding, it's possible that if you are using a custom view implementation with the Dojo view
   helper, you will not have a ``getEncoding()`` method, which is what the view helper uses internally for
   determining the character set in which to encode.

   If you do not want to utilize *UTF-8* in such a situation, you will need to implement a ``getEncoding()`` method
   in your custom view implementation.

.. _zend.view.helpers.initial.navigation.navigation:

Navigation Helper
-----------------

The Navigation helper is a proxy helper that relays calls to other navigational helpers. It can be considered an
entry point to all navigation-related view tasks. The aforementioned navigational helpers are in the namespace
``Zend_View_Helper_Navigation``, and would thus require the path *Zend/View/Helper/Navigation* to be added as a
helper path to the view. With the proxy helper residing in the ``Zend_View_Helper`` namespace, it will always be
available, without the need to add any helper paths to the view.

The Navigation helper finds other helpers that implement the ``Zend_View_Helper_Navigation_Helper`` interface,
which means custom view helpers can also be proxied. This would, however, require that the custom helper path is
added to the view.

When proxying to other helpers, the Navigation helper can inject its container, *ACL*/role, and translator. This
means that you won't have to explicitly set all three in all navigational helpers, nor resort to injecting by means
of ``Zend_Registry`` or static methods.

- ``findHelper()`` finds the given helper, verifies that it is a navigational helper, and injects container,
  *ACL*/role and translator.

- *{get|set}InjectContainer()* gets/sets a flag indicating whether the container should be injected to proxied
  helpers. Default is ``TRUE``.

- *{get|set}InjectAcl()* gets/sets a flag indicating whether the *ACL*/role should be injected to proxied helpers.
  Default is ``TRUE``.

- *{get|set}InjectTranslator()* gets/sets a flag indicating whether the translator should be injected to proxied
  helpers. Default is ``TRUE``.

- *{get|set}DefaultProxy()* gets/sets the default proxy. Default is *'menu'*.

- ``render()`` proxies to the render method of the default proxy.



.. _`Sitemaps XML format`: http://www.sitemaps.org/protocol.php
.. _`Breadcrumbs Pattern - Yahoo! Design Pattern Library`: http://developer.yahoo.com/ypatterns/pattern.php?pattern=breadcrumbs
.. _`Document relationships: the LINK element (HTML4 W3C Rec.)`: http://www.w3.org/TR/html4/struct/links.html#h-12.3
.. _`Link types (HTML4 W3C Rec.)`: http://www.w3.org/TR/html4/types.html#h-6.12
.. _`bitwse and (&) operation`: http://php.net/manual/en/language.operators.bitwise.php
.. _`Sitemaps on Wikpedia`: http://en.wikipedia.org/wiki/Sitemaps
.. _`Sitemap XSD Schema`: http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd
.. _`PHP: DOMDocument - Manual`: http://php.net/domdocument
