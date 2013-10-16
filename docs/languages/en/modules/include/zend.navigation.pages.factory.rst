.. _zend.navigation.pages.factory:

Creating pages using the page factory
=====================================

All pages (also custom classes), can be created using the page factory,
``Zend\Navigation\Page\AbstractPage::factory()``. The
factory can take an array with options, or a ``Zend\Config`` object. Each key in the array/config corresponds to a
page option, as seen in the section on :ref:`Pages <zend.navigation.pages>`. If the option *uri* is given and no
*MVC* options are given (*action, controller, route*), an *URI* page will be created. If any of the *MVC*
options are given, an *MVC* page will be created.

If *type* is given, the factory will assume the value to be the name of the class that should be created. If the
value is *mvc* or *uri* and *MVC*/URI page will be created.

.. _zend.navigation.pages.factory.example.mvc:

.. rubric:: Creating an MVC page using the page factory

.. code-block:: php
   :linenos:

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'label'  => 'My MVC page',
       'action' => 'index',
   ));

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'label'      => 'Search blog',
       'action'     => 'index',
       'controller' => 'search',
   ));

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'label' => 'Home',
       'route' => 'home',
   ));

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'type'   => 'mvc',
       'label'  => 'My MVC page',
   ));

.. _zend.navigation.pages.factory.example.uri:

.. rubric:: Creating a URI page using the page factory

.. code-block:: php
   :linenos:

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'label' => 'My URI page',
       'uri'   => 'http://www.example.com/',
   ));

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'label'  => 'Search',
       'uri'    => 'http://www.example.com/search',
       'active' => true,
   ));

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'label' => 'My URI page',
       'uri'   => '#',
   ));

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'type'  => 'uri',
       'label' => 'My URI page',
   ));

.. _zend.navigation.pages.factory.example.custom:

.. rubric:: Creating a custom page type using the page factory

To create a custom page type using the factory, use the option *type* to specify a class name to instantiate.

.. code-block:: php
   :linenos:

   class My\Navigation\Page extends Zend\Navigation\Page\AbstractPage
   {
       protected $_fooBar = 'ok';

       public function setFooBar($fooBar)
       {
           $this->_fooBar = $fooBar;
       }
   }

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'type'    => 'My\Navigation\Page',
       'label'   => 'My custom page',
       'foo_bar' => 'foo bar',
   ));


