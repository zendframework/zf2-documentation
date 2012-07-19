.. _zend.navigation.pages.custom:

Creating custom page types
==========================

When extending ``Zend_Navigation_Page``, there is usually no need to override the constructor or the methods
``setOptions()`` or ``setConfig()``. The page constructor takes a single parameter, an ``Array`` or a
``Zend_Config`` object, which is passed to ``setOptions()`` or ``setConfig()`` respectively. Those methods will in
turn call ``set()`` method, which will map options to native or custom properties. If the option ``internal_id`` is
given, the method will first look for a method named ``setInternalId()``, and pass the option to this method if it
exists. If the method does not exist, the option will be set as a custom property of the page, and be accessible
via ``$internalId = $page->internal_id;`` or ``$internalId = $page->get('internal_id');``.

.. _zend.navigation.custom.example.simple:

.. rubric:: The most simple custom page

The only thing a custom page class needs to implement is the ``getHref()`` method.

.. code-block:: php
   :linenos:

   class My_Simple_Page extends Zend_Navigation_Page
   {
       public function getHref()
       {
           return 'something-completely-different';
       }
   }

.. _zend.navigation.custom.example.properties:

.. rubric:: A custom page with properties

When adding properties to an extended page, there is no need to override/modify ``setOptions()`` or
``setConfig()``.

.. code-block:: php
   :linenos:

   class My_Navigation_Page extends Zend_Navigation_Page
   {
       private $_foo;
       private $_fooBar;

       public function setFoo($foo)
       {
           $this->_foo = $foo;
       }

       public function getFoo()
       {
           return $this->_foo;
       }

       public function setFooBar($fooBar)
       {
           $this->_fooBar = $fooBar;
       }

       public function getFooBar()
       {
           return $this->_fooBar;
       }

       public function getHref()
       {
           return $this->foo . '/' . $this->fooBar;
       }
   }

   // can now construct using
   $page = new My_Navigation_Page(array(
       'label'   => 'Property names are mapped to setters',
       'foo'     => 'bar',
       'foo_bar' => 'baz'
   ));

   // ...or
   $page = Zend_Navigation_Page::factory(array(
       'type'    => 'My_Navigation_Page',
       'label'   => 'Property names are mapped to setters',
       'foo'     => 'bar',
       'foo_bar' => 'baz'
   ));


