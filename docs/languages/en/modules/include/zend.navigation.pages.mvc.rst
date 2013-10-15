.. _zend.navigation.pages.mvc:

Zend\\Navigation\\Page\\Mvc
===========================

*MVC* pages are defined using *MVC* parameters known from the ``Zend\Mvc`` component. An *MVC* page will use
``Zend\Mvc\Router\RouteStackInterface`` internally in the ``getHref()`` method to generate hrefs, and the
``isActive()`` method will compare the ``Zend\Mvc\Router\RouteMatch`` params with the page's params to
determine if the page is active.

.. note::

    Starting in version 2.2.0, if you want to re-use any matched route
    parameters when generating a link, you can do so via the "useRouteMatch"
    flag. This is particularly useful when creating segment routes that include
    the currently selected language or locale as an initial segment, as it
    ensures the links generated all include the matched value.

.. _zend.navigation.pages.mvc.options:

.. table:: MVC page options

   +-------------+---------------------------------------+-------+--------------------------------------------------------+
   |Key          |Type                                   |Default|Description                                             |
   +=============+=======================================+=======+========================================================+
   |action       |String                                 |NULL   |Action name to use when generating href to the page.    |
   +-------------+---------------------------------------+-------+--------------------------------------------------------+
   |controller   |String                                 |NULL   |Controller name to use when generating href to the page.|
   +-------------+---------------------------------------+-------+--------------------------------------------------------+
   |params       |Array                                  |array()|User params to use when generating href to the page.    |
   +-------------+---------------------------------------+-------+--------------------------------------------------------+
   |route        |String                                 |NULL   |Route name to use when generating href to the page.     |
   +-------------+---------------------------------------+-------+--------------------------------------------------------+
   |routeMatch   |``Zend\Mvc\Router\RouteMatch``         |NULL   |RouteInterface matches used for routing parameters and  |
   |             |                                       |       |testing validity.                                       |
   +-------------+---------------------------------------+-------+--------------------------------------------------------+
   |useRouteMatch|Boolean                                |FALSE  |If true, then getHref method will use the               |
   |             |                                       |       |routeMatch parameters to assemble the URI               |
   +-------------+---------------------------------------+-------+--------------------------------------------------------+
   |router       |``Zend\Mvc\Router\RouteStackInterface``|NULL   |Router for assembling URLs                              |
   +-------------+---------------------------------------+-------+--------------------------------------------------------+

.. note::

   The *URI* returned is relative to the *baseUrl* in ``Zend\Mvc\Router\Http\TreeRouteStack``. In the examples,
   the baseUrl is '/' for simplicity.

.. _zend.navigation.pages.mvc.example.getHref:

.. rubric:: getHref() generates the page URI

This example show that *MVC* pages use ``Zend\Mvc\Router\RouteStackInterface`` internally to generate *URI*\ s when
calling *$page->getHref()*.

.. code-block:: php
   :linenos:

   // Create route
   $route = Zend\Mvc\Router\Http\Segment::factory(array(
      'route'       => '/[:controller[/:action][/:id]]',
      'constraints' => array(
         'controller' => '[a-zA-Z][a-zA-Z0-9_-]+',
         'action'     => '[a-zA-Z][a-zA-Z0-9_-]+',
         'id'         => '[0-9]+',
      ),
      array(
         'controller' => 'Album\Controller\Album',
         'action'     => 'index',
      )
   ));
   $router = new Zend\Mvc\Router\Http\TreeRouteStack();
   $router->addRoute('default', $route);

   // getHref() returns /album/add
   $page = new Zend\Navigation\Page\Mvc(array(
       'action'     => 'add',
       'controller' => 'album',
   ));

   // getHref() returns /album/edit/1337
   $page = new Zend\Navigation\Page\Mvc(array(
       'action'     => 'edit',
       'controller' => 'album',
       'params'     => array('id' => 1337),
   ));

.. _zend.navigation.pages.mvc.example.isActive:

.. rubric:: isActive() determines if page is active

This example show that *MVC* pages determine whether they are active by using the params found in the route
match object.

.. code-block:: php
   :linenos:

   /**
    * Dispatched request:
    * - controller: album
    * - action:     index
    */
   $page1 = new Zend\Navigation\Page\Mvc(array(
       'action'     => 'index',
       'controller' => 'album',
   ));

   $page2 = new Zend\Navigation\Page\Mvc(array(
       'action'     => 'edit',
       'controller' => 'album',
   ));

   $page1->isActive(); // returns true
   $page2->isActive(); // returns false

   /**
    * Dispatched request:
    * - controller: album
    * - action:     edit
    * - id:         1337
    */
   $page = new Zend\Navigation\Page\Mvc(array(
       'action'     => 'edit',
       'controller' => 'album',
       'params'     => array('id' => 1337),
   ));

   // returns true, because request has the same controller and action
   $page->isActive();

   /**
    * Dispatched request:
    * - controller: album
    * - action:     edit
    */
   $page = new Zend\Navigation\Page\Mvc(array(
       'action'     => 'edit',
       'controller' => 'album',
       'params'     => array('id' => null),
   ));

   // returns false, because page requires the id param to be set in the request
   $page->isActive(); // returns false

.. _zend.navigation.pages.mvc.example.routes:

.. rubric:: Using routes

Routes can be used with *MVC* pages. If a page has a route, this route will be used in ``getHref()`` to generate
the *URL* for the page.

.. note::

   Note that when using the *route* property in a page, you do not need to specify the default params that the route
   defines (controller, action, etc.).

.. code-block:: php
   :linenos:

   // the following route is added to the ZF router
   $route = Zend\Mvc\Router\Http\Segment::factory(array(
      'route'       => '/a/:id',
      'constraints' => array(
         'id' => '[0-9]+',
      ),
      array(
         'controller' => 'Album\Controller\Album',
         'action'     => 'show',
      )
   ));
   $router = new Zend\Mvc\Router\Http\TreeRouteStack();
   $router->addRoute('albumShow', $route);

   // a page is created with a 'route' option
   $page = new Zend\Navigation\Page\Mvc(array(
       'label'      => 'Show album',
       'route'      => 'albumShow',
       'params'     => array('id' => 42)
   ));

   // returns: /a/42
   $page->getHref();
