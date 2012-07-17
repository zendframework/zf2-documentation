
.. _zend.navigation.pages.mvc:

Zend_Navigation_Page_Mvc
========================

*MVC* pages are defined using *MVC* parameters known from the ``Zend_Controller`` component. An *MVC* page will use ``Zend_Controller_Action_Helper_Url`` internally in the ``getHref()`` method to generate hrefs, and the ``isActive()`` method will intersect the ``Zend_Controller_Request_Abstract`` params with the page's params to determine if the page is active.


.. _zend.navigation.pages.mvc.options:

.. table:: MVC page options

   +------------+------+-------+---------------------------------------------------------------------+
   |Key         |Type  |Default|Description                                                          |
   +============+======+=======+=====================================================================+
   |action      |String|NULL   |Action name to use when generating href to the page.                 |
   +------------+------+-------+---------------------------------------------------------------------+
   |controller  |String|NULL   |Controller name to use when generating href to the page.             |
   +------------+------+-------+---------------------------------------------------------------------+
   |module      |String|NULL   |Module name to use when generating href to the page.                 |
   +------------+------+-------+---------------------------------------------------------------------+
   |params      |Array |array()|User params to use when generating href to the page.                 |
   +------------+------+-------+---------------------------------------------------------------------+
   |route       |String|NULL   |Route name to use when generating href to the page.                  |
   +------------+------+-------+---------------------------------------------------------------------+
   |reset_params|bool  |TRUE   |Whether user params should be reset when generating href to the page.|
   +------------+------+-------+---------------------------------------------------------------------+


.. note::
   The three examples below assume a default *MVC* setup with the *default* route in place.


   The *URI* returned is relative to the *baseUrl* in ``Zend_Controller_Front``. In the examples, the baseUrl is '/' for simplicity.



.. _zend.navigation.pages.mvc.example.getHref:

.. rubric:: getHref() generates the page URI

This example show that *MVC* pages use ``Zend_Controller_Action_Helper_Url`` internally to generate *URI*\ s when calling *$page->getHref()*.

.. code-block:: php
   :linenos:

   // getHref() returns /
   $page = new Zend_Navigation_Page_Mvc(array(
       'action'     => 'index',
       'controller' => 'index'
   ));

   // getHref() returns /blog/post/view
   $page = new Zend_Navigation_Page_Mvc(array(
       'action'     => 'view',
       'controller' => 'post',
       'module'     => 'blog'
   ));

   // getHref() returns /blog/post/view/id/1337
   $page = new Zend_Navigation_Page_Mvc(array(
       'action'     => 'view',
       'controller' => 'post',
       'module'     => 'blog',
       'params'     => array('id' => 1337)
   ));


.. _zend.navigation.pages.mvc.example.isActive:

.. rubric:: isActive() determines if page is active

This example show that *MVC* pages determine whether they are active by using the params found in the request object.

.. code-block:: php
   :linenos:

   /*
    * Dispatched request:
    * - module:     default
    * - controller: index
    * - action:     index
    */
   $page1 = new Zend_Navigation_Page_Mvc(array(
       'action'     => 'index',
       'controller' => 'index'
   ));

   $page2 = new Zend_Navigation_Page_Mvc(array(
       'action'     => 'bar',
       'controller' => 'index'
   ));

   $page1->isActive(); // returns true
   $page2->isActive(); // returns false

   /*
    * Dispatched request:
    * - module:     blog
    * - controller: post
    * - action:     view
    * - id:         1337
    */
   $page = new Zend_Navigation_Page_Mvc(array(
       'action'     => 'view',
       'controller' => 'post',
       'module'     => 'blog'
   ));

   // returns true, because request has the same module, controller and action
   $page->isActive();

   /*
    * Dispatched request:
    * - module:     blog
    * - controller: post
    * - action:     view
    */
   $page = new Zend_Navigation_Page_Mvc(array(
       'action'     => 'view',
       'controller' => 'post',
       'module'     => 'blog',
       'params'     => array('id' => null)
   ));

   // returns false, because page requires the id param to be set in the request
   $page->isActive(); // returns false


.. _zend.navigation.pages.mvc.example.routes:

.. rubric:: Using routes

Routes can be used with *MVC* pages. If a page has a route, this route will be used in ``getHref()`` to generate the *URL* for the page.

.. note::
   Note that when using the *route* property in a page, you should also specify the default params that the route defines (module, controller, action, etc.), otherwise the ``isActive()`` method will not be able to determine if the page is active. The reason for this is that there is currently no way to get the default params from a ``Zend_Controller_Router_Route_Interface`` object, nor to retrieve the current route from a ``Zend_Controller_Router_Interface`` object.




.. code-block:: php
   :linenos:

   // the following route is added to the ZF router
   Zend_Controller_Front::getInstance()->getRouter()->addRoute(
       'article_view', // route name
       new Zend_Controller_Router_Route(
           'a/:id',
           array(
               'module'     => 'news',
               'controller' => 'article',
               'action'     => 'view',
               'id'         => null
           )
       )
   );

   // a page is created with a 'route' option
   $page = new Zend_Navigation_Page_Mvc(array(
       'label'      => 'A news article',
       'route'      => 'article_view',
       'module'     => 'news',    // required for isActive(), see note above
       'controller' => 'article', // required for isActive(), see note above
       'action'     => 'view',    // required for isActive(), see note above
       'params'     => array('id' => 42)
   ));

   // returns: /a/42
   $page->getHref();


