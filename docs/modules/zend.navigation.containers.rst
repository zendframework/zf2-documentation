.. _zend.navigation.containers:

Containers
==========

Containers have methods for adding, retrieving, deleting and iterating pages. Containers implement the `SPL`_ interfaces ``RecursiveIterator`` and ``Countable``, meaning that a container can be iterated using the SPL ``RecursiveIteratorIterator`` class.

.. _zend.navigation.containers.creating:

Creating containers
-------------------

``Zend_Navigation_Container`` is abstract, and can not be instantiated directly. Use ``Zend_Navigation`` if you want to instantiate a container.

``Zend_Navigation`` can be constructed entirely empty, or take an array or a ``Zend_Config`` object with pages to put in the container. Each page in the given array/config will eventually be passed to the ``addPage()`` method of the container class, which means that each element in the array/config can be an array or a config object, or a ``Zend_Navigation_Page`` instance.

.. _zend.navigation.containers.creating.example.array:

.. rubric:: Creating a container using an array

.. code-block:: php
   :linenos:

   /*
    * Create a container from an array
    *
    * Each element in the array will be passed to
    * Zend_Navigation_Page::factory() when constructing.
    */
   $container = new Zend_Navigation(array(
       array(
           'label' => 'Page 1',
           'id' => 'home-link',
           'uri' => '/'
       ),
       array(
           'label' => 'Zend',
           'uri' => 'http://www.zend-project.com/',
           'order' => 100
       ),
       array(
           'label' => 'Page 2',
           'controller' => 'page2',
           'pages' => array(
               array(
                   'label' => 'Page 2.1',
                   'action' => 'page2_1',
                   'controller' => 'page2',
                   'class' => 'special-one',
                   'title' => 'This element has a special class',
                   'active' => true
               ),
               array(
                   'label' => 'Page 2.2',
                   'action' => 'page2_2',
                   'controller' => 'page2',
                   'class' => 'special-two',
                   'title' => 'This element has a special class too'
               )
           )
       ),
       array(
           'label' => 'Page 2 with params',
           'action' => 'index',
           'controller' => 'page2',
           // specify a param or two
           'params' => array(
               'format' => 'json',
               'foo' => 'bar'
           )
       ),
       array(
           'label' => 'Page 2 with params and a route',
           'action' => 'index',
           'controller' => 'page2',
           // specify a route name and a param for the route
           'route' => 'nav-route-example',
           'params' => array(
               'format' => 'json'
           )
       ),
       array(
           'label' => 'Page 3',
           'action' => 'index',
           'controller' => 'index',
           'module' => 'mymodule',
           'reset_params' => false
       ),
       array(
           'label' => 'Page 4',
           'uri' => '#',
           'pages' => array(
               array(
                   'label' => 'Page 4.1',
                   'uri' => '/page4',
                   'title' => 'Page 4 using uri',
                   'pages' => array(
                       array(
                           'label' => 'Page 4.1.1',
                           'title' => 'Page 4 using mvc params',
                           'action' => 'index',
                           'controller' => 'page4',
                           // let's say this page is active
                           'active' => '1'
                       )
                   )
               )
           )
       ),
       array(
           'label' => 'Page 0?',
           'uri' => '/setting/the/order/option',
           // setting order to -1 should make it appear first
           'order' => -1
       ),
       array(
           'label' => 'Page 5',
           'uri' => '/',
           // this page should not be visible
           'visible' => false,
           'pages' => array(
               array(
                   'label' => 'Page 5.1',
                   'uri' => '#',
                   'pages' => array(
                       array(
                           'label' => 'Page 5.1.1',
                           'uri' => '#',
                           'pages' => array(
                               array(
                                   'label' => 'Page 5.1.2',
                                   'uri' => '#',
                                   // let's say this page is active
                                   'active' => true
                               )
                           )
                       )
                   )
               )
           )
       ),
       array(
           'label' => 'ACL page 1 (guest)',
           'uri' => '#acl-guest',
           'resource' => 'nav-guest',
           'pages' => array(
               array(
                   'label' => 'ACL page 1.1 (foo)',
                   'uri' => '#acl-foo',
                   'resource' => 'nav-foo'
               ),
               array(
                   'label' => 'ACL page 1.2 (bar)',
                   'uri' => '#acl-bar',
                   'resource' => 'nav-bar'
               ),
               array(
                   'label' => 'ACL page 1.3 (baz)',
                   'uri' => '#acl-baz',
                   'resource' => 'nav-baz'
               ),
               array(
                   'label' => 'ACL page 1.4 (bat)',
                   'uri' => '#acl-bat',
                   'resource' => 'nav-bat'
               )
           )
       ),
       array(
           'label' => 'ACL page 2 (member)',
           'uri' => '#acl-member',
           'resource' => 'nav-member'
       ),
       array(
           'label' => 'ACL page 3 (admin',
           'uri' => '#acl-admin',
           'resource' => 'nav-admin',
           'pages' => array(
               array(
                   'label' => 'ACL page 3.1 (nothing)',
                   'uri' => '#acl-nada'
               )
           )
       ),
       array(
           'label' => 'Zend Framework',
           'route' => 'zf-route'
       )
   ));

.. _zend.navigation.containers.creating.example.config:

.. rubric:: Creating a container using a config object

.. code-block:: php
   :linenos:

   /* CONTENTS OF /path/to/navigation.xml:
   <?xml version="1.0" encoding="UTF-8"?>
   <config>
       <nav>

           <zend>
               <label>Zend</label>
               <uri>http://www.zend-project.com/</uri>
               <order>100</order>
           </zend>

           <page1>
               <label>Page 1</label>
               <uri>page1</uri>
               <pages>

                   <page1_1>
                       <label>Page 1.1</label>
                       <uri>page1/page1_1</uri>
                   </page1_1>

               </pages>
           </page1>

           <page2>
               <label>Page 2</label>
               <uri>page2</uri>
               <pages>

                   <page2_1>
                       <label>Page 2.1</label>
                       <uri>page2/page2_1</uri>
                   </page2_1>

                   <page2_2>
                       <label>Page 2.2</label>
                       <uri>page2/page2_2</uri>
                       <pages>

                           <page2_2_1>
                               <label>Page 2.2.1</label>
                               <uri>page2/page2_2/page2_2_1</uri>
                           </page2_2_1>

                           <page2_2_2>
                               <label>Page 2.2.2</label>
                               <uri>page2/page2_2/page2_2_2</uri>
                               <active>1</active>
                           </page2_2_2>

                       </pages>
                   </page2_2>

                   <page2_3>
                       <label>Page 2.3</label>
                       <uri>page2/page2_3</uri>
                       <pages>

                           <page2_3_1>
                               <label>Page 2.3.1</label>
                               <uri>page2/page2_3/page2_3_1</uri>
                           </page2_3_1>

                           <page2_3_2>
                               <label>Page 2.3.2</label>
                               <uri>page2/page2_3/page2_3_2</uri>
                               <visible>0</visible>
                               <pages>

                                       <page2_3_2_1>
                                           <label>Page 2.3.2.1</label>
                                           <uri>page2/page2_3/page2_3_2/1</uri>
                                           <active>1</active>
                                       </page2_3_2_1>

                                       <page2_3_2_2>
                                           <label>Page 2.3.2.2</label>
                                           <uri>page2/page2_3/page2_3_2/2</uri>
                                           <active>1</active>

                                           <pages>
                                               <page_2_3_2_2_1>
                                                   <label>Ignore</label>
                                                   <uri>#</uri>
                                                   <active>1</active>
                                               </page_2_3_2_2_1>
                                           </pages>
                                       </page2_3_2_2>

                               </pages>
                           </page2_3_2>

                           <page2_3_3>
                               <label>Page 2.3.3</label>
                               <uri>page2/page2_3/page2_3_3</uri>
                               <resource>admin</resource>
                               <pages>

                                       <page2_3_3_1>
                                           <label>Page 2.3.3.1</label>
                                           <uri>page2/page2_3/page2_3_3/1</uri>
                                           <active>1</active>
                                       </page2_3_3_1>

                                       <page2_3_3_2>
                                           <label>Page 2.3.3.2</label>
                                           <uri>page2/page2_3/page2_3_3/2</uri>
                                           <resource>guest</resource>
                                           <active>1</active>
                                       </page2_3_3_2>

                               </pages>
                           </page2_3_3>

                       </pages>
                   </page2_3>

               </pages>
           </page2>

           <page3>
               <label>Page 3</label>
               <uri>page3</uri>
               <pages>

                   <page3_1>
                       <label>Page 3.1</label>
                       <uri>page3/page3_1</uri>
                       <resource>guest</resource>
                   </page3_1>

                   <page3_2>
                       <label>Page 3.2</label>
                       <uri>page3/page3_2</uri>
                       <resource>member</resource>
                       <pages>

                           <page3_2_1>
                               <label>Page 3.2.1</label>
                               <uri>page3/page3_2/page3_2_1</uri>
                           </page3_2_1>

                           <page3_2_2>
                               <label>Page 3.2.2</label>
                               <uri>page3/page3_2/page3_2_2</uri>
                               <resource>admin</resource>
                           </page3_2_2>

                       </pages>
                   </page3_2>

                   <page3_3>
                       <label>Page 3.3</label>
                       <uri>page3/page3_3</uri>
                       <resource>special</resource>
                       <pages>

                           <page3_3_1>
                               <label>Page 3.3.1</label>
                               <uri>page3/page3_3/page3_3_1</uri>
                               <visible>0</visible>
                           </page3_3_1>

                           <page3_3_2>
                               <label>Page 3.3.2</label>
                               <uri>page3/page3_3/page3_3_2</uri>
                               <resource>admin</resource>
                           </page3_3_2>

                       </pages>
                   </page3_3>

               </pages>
           </page3>

           <home>
               <label>Home</label>
               <order>-100</order>
               <module>default</module>
               <controller>index</controller>
               <action>index</action>
           </home>

       </nav>
   </config>
    */

   $config = new Zend_Config_Xml('/path/to/navigation.xml', 'nav');
   $container = new Zend_Navigation($config);

.. _zend.navigation.containers.adding:

Adding pages
------------

Adding pages to a container can be done with the methods ``addPage()``, ``addPages()``, or ``setPages()``. See examples below for explanation.

.. _zend.navigation.containers.adding.example:

.. rubric:: Adding pages to a container

.. code-block:: php
   :linenos:

   // create container
   $container = new Zend_Navigation();

   // add page by giving a page instance
   $container->addPage(Zend_Navigation_Page::factory(array(
       'uri' => 'http://www.example.com/'
   )))

   // add page by giving an array
   $container->addPage(array(
       'uri' => 'http://www.example.com/'
   )))

   // add page by giving a config object
   $container->addPage(new Zend_Config(array(
       'uri' => 'http://www.example.com/'
   )))

   $pages = array(
       array(
           'label'  => 'Save'
           'action' => 'save',
       ),
       array(
           'label' =>  'Delete',
           'action' => 'delete'
       )
   );

   // add two pages
   $container->addPages($pages);

   // remove existing pages and add the given pages
   $container->setPages($pages);

.. _zend.navigation.containers.removing:

Removing pages
--------------

Removing pages can be done with ``removePage()`` or ``removePages()``. The first method accepts a an instance of a page, or an integer. The integer corresponds to the ``order`` a page has. The latter method will remove all pages in the container.

.. _zend.navigation.containers.removing.example:

.. rubric:: Removing pages from a container

.. code-block:: php
   :linenos:

   $container = new Zend_Navigation(array(
       array(
           'label'  => 'Page 1',
           'action' => 'page1'
       ),
       array(
           'label'  => 'Page 2',
           'action' => 'page2',
           'order'  => 200
       ),
       array(
           'label'  => 'Page 3',
           'action' => 'page3'
       )
   ));

   // remove page by implicit page order
   $container->removePage(0);      // removes Page 1

   // remove page by instance
   $page3 = $container->findOneByAction('page3');
   $container->removePage($page3); // removes Page 3

   // remove page by explicit page order
   $container->removePage(200);    // removes Page 2

   // remove all pages
   $container->removePages();      // removes all pages

.. _zend.navigation.containers.finding:

Finding pages
-------------

Containers have finder methods for retrieving pages. They are ``findOneBy($property, $value)``, ``findAllBy($property, $value)``, and ``findBy($property, $value, $all = false)``. Those methods will recursively search the container for pages matching the given ``$page->$property == $value``. The first method, ``findOneBy()``, will return a single page matching the property with the given value, or ``NULL`` if it cannot be found. The second method will return all pages with a property matching the given value. The third method will call one of the two former methods depending on the ``$all`` flag.

The finder methods can also be used magically by appending the property name to ``findBy``, ``findOneBy``, or ``findAllBy``, e.g. ``findOneByLabel('Home')`` to return the first matching page with label 'Home'. Other combinations are ``findByLabel(...)``, ``findOnyByTitle(...)``, ``findAllByController(...)``, etc. Finder methods also work on custom properties, such as ``findByFoo('bar')``.

.. _zend.navigation.containers.finding.example:

.. rubric:: Finding pages in a container

.. code-block:: php
   :linenos:

   $container = new Zend_Navigation(array(
       array(
           'label' => 'Page 1',
           'uri'   => 'page-1',
           'foo'   => 'bar',
           'pages' => array(
               array(
                   'label' => 'Page 1.1',
                   'uri'   => 'page-1.1',
                   'foo'   => 'bar',
               ),
               array(
                   'label' => 'Page 1.2',
                   'uri'   => 'page-1.2',
                   'class' => 'my-class',
               ),
               array(
                   'type'   => 'uri',
                   'label'  => 'Page 1.3',
                   'uri'    => 'page-1.3',
                   'action' => 'about'
               )
           )
       ),
       array(
           'label'      => 'Page 2',
           'id'         => 'page_2_and_3',
           'class'      => 'my-class',
           'module'     => 'page2',
           'controller' => 'index',
           'action'     => 'page1'
       ),
       array(
           'label'      => 'Page 3',
           'id'         => 'page_2_and_3',
           'module'     => 'page3',
           'controller' => 'index'
       )
   ));

   // The 'id' is not required to be unique, but be aware that
   // having two pages with the same id will render the same id attribute
   // in menus and breadcrumbs.
   $found = $container->findBy('id',
                               'page_2_and_3');      // returns Page 2
   $found = $container->findOneBy('id',
                                  'page_2_and_3');   // returns Page 2
   $found = $container->findBy('id',
                               'page_2_and_3',
                               true);                // returns Page 2 and Page 3
   $found = $container->findById('page_2_and_3');    // returns Page 2
   $found = $container->findOneById('page_2_and_3'); // returns Page 2
   $found = $container->findAllById('page_2_and_3'); // returns Page 2 and Page 3

   // Find all matching CSS class my-class
   $found = $container->findAllBy('class',
                                  'my-class');       // returns Page 1.2 and Page 2
   $found = $container->findAllByClass('my-class');  // returns Page 1.2 and Page 2

   // Find first matching CSS class my-class
   $found = $container->findOneByClass('my-class');  // returns Page 1.2

   // Find all matching CSS class non-existant
   $found = $container->findAllByClass('non-existant'); // returns array()

   // Find first matching CSS class non-existant
   $found = $container->findOneByClass('non-existant'); // returns null

   // Find all pages with custom property 'foo' = 'bar'
   $found = $container->findAllBy('foo', 'bar'); // returns Page 1 and Page 1.1

   // To achieve the same magically, 'foo' must be in lowercase.
   // This is because 'foo' is a custom property, and thus the
   // property name is not normalized to 'Foo'
   $found = $container->findAllByfoo('bar');

   // Find all with controller = 'index'
   $found = $container->findAllByController('index'); // returns Page 2 and Page 3

.. _zend.navigation.containers.iterating:

Iterating containers
--------------------

``Zend_Navigation_Container`` implements ``RecursiveIteratorIterator``, and can be iterated using any ``Iterator`` class. To iterate a container recursively, use the ``RecursiveIteratorIterator`` class.

.. _zend.navigation.containers.iterating.example:

.. rubric:: Iterating a container

.. code-block:: php
   :linenos:

   /*
    * Create a container from an array
    */
   $container = new Zend_Navigation(array(
       array(
           'label' => 'Page 1',
           'uri'   => '#'
       ),
       array(
           'label' => 'Page 2',
           'uri'   => '#',
           'pages' => array(
               array(
                   'label' => 'Page 2.1',
                   'uri'   => '#'
               ),
               array(
                   'label' => 'Page 2.2',
                   'uri'   => '#'
               )
           )
       )
       array(
           'label' => 'Page 3',
           'uri'   => '#'
       )
   ));

   // Iterate flat using regular foreach:
   // Output: Page 1, Page 2, Page 3
   foreach ($container as $page) {
       echo $page->label;
   }

   // Iterate recursively using RecursiveIteratorIterator
   $it = new RecursiveIteratorIterator(
           $container, RecursiveIteratorIterator::SELF_FIRST);

   // Output: Page 1, Page 2, Page 2.1, Page 2.2, Page 3
   foreach ($it as $page) {
       echo $page->label;
   }

.. _zend.navigation.containers.other:

Other operations
----------------

The method ``hasPage(Zend_Navigation_Page $page)`` checks if the container has the given page. The method ``hasPages()`` checks if there are any pages in the container, and is equivalent to ``count($container) > 1``.

The ``toArray()`` method converts the container and the pages in it to an array. This can be useful for serializing and debugging.

.. _zend.navigation.containers.other.example.toarray:

.. rubric:: Converting a container to an array

.. code-block:: php
   :linenos:

   $container = new Zend_Navigation(array(
       array(
           'label' => 'Page 1',
           'uri'   => '#'
       ),
       array(
           'label' => 'Page 2',
           'uri'   => '#',
           'pages' => array(
               array(
                   'label' => 'Page 2.1',
                   'uri'   => '#'
               ),
               array(
                   'label' => 'Page 2.2',
                  'uri'   => '#'
               )
           )
       )
   ));

   var_dump($container->toArray());

   /* Output:
   array(2) {
     [0]=> array(15) {
       ["label"]=> string(6) "Page 1"
       ["id"]=> NULL
       ["class"]=> NULL
       ["title"]=> NULL
       ["target"]=> NULL
       ["rel"]=> array(0) {
       }
       ["rev"]=> array(0) {
       }
       ["order"]=> NULL
       ["resource"]=> NULL
       ["privilege"]=> NULL
       ["active"]=> bool(false)
       ["visible"]=> bool(true)
       ["type"]=> string(23) "Zend_Navigation_Page_Uri"
       ["pages"]=> array(0) {
       }
       ["uri"]=> string(1) "#"
     }
     [1]=> array(15) {
       ["label"]=> string(6) "Page 2"
       ["id"]=> NULL
       ["class"]=> NULL
       ["title"]=> NULL
       ["target"]=> NULL
       ["rel"]=> array(0) {
       }
       ["rev"]=> array(0) {
       }
       ["order"]=> NULL
       ["resource"]=> NULL
       ["privilege"]=> NULL
       ["active"]=> bool(false)
       ["visible"]=> bool(true)
       ["type"]=> string(23) "Zend_Navigation_Page_Uri"
       ["pages"]=> array(2) {
         [0]=> array(15) {
           ["label"]=> string(8) "Page 2.1"
           ["id"]=> NULL
           ["class"]=> NULL
           ["title"]=> NULL
           ["target"]=> NULL
           ["rel"]=> array(0) {
           }
           ["rev"]=> array(0) {
           }
           ["order"]=> NULL
           ["resource"]=> NULL
           ["privilege"]=> NULL
           ["active"]=> bool(false)
           ["visible"]=> bool(true)
           ["type"]=> string(23) "Zend_Navigation_Page_Uri"
           ["pages"]=> array(0) {
           }
           ["uri"]=> string(1) "#"
         }
         [1]=>
         array(15) {
           ["label"]=> string(8) "Page 2.2"
           ["id"]=> NULL
           ["class"]=> NULL
           ["title"]=> NULL
           ["target"]=> NULL
           ["rel"]=> array(0) {
           }
           ["rev"]=> array(0) {
           }
           ["order"]=> NULL
           ["resource"]=> NULL
           ["privilege"]=> NULL
           ["active"]=> bool(false)
           ["visible"]=> bool(true)
           ["type"]=> string(23) "Zend_Navigation_Page_Uri"
           ["pages"]=> array(0) {
           }
           ["uri"]=> string(1) "#"
         }
       }
       ["uri"]=> string(1) "#"
     }
   }
   */



.. _`SPL`: http://php.net/spl
