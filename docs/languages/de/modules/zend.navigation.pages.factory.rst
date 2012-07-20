.. _zend.navigation.pages.factory:

Erstellen von Seiten durch Verwendung der Page Factory
======================================================

Alle Seiten (also auch eigene Klassen), können durch Verwendung der Page Factory
``Zend_Navigation_Page::factory()`` erstellt werden. Die Factory kann ein Array mit Optionen oder ein
``Zend_Config`` Objekt annehmen. Jeder Schlüssel im Array/Config entspricht einer Seiten Option, wie im Kapitel
:ref:`Seiten <zend.navigation.pages>` gezeigt. Wenn die Option *uri* angegeben wird und keine *MVC* Optionen
angegeben werden (*action, controller, module, route*) wird eine *URI* Seite erstellt. Wenn eine der *MVC* Optionen
angegeben wird, dann wird eine *MVC* Seite erstellt.

Wenn *type* angegeben wird, nimmt die Factory an das der Wert der Name der Klasse ist die erstellt werden soll.
Wenn der Wert *mvc* oder *uri* ist wird eine MVC/URI Seite erstellt.

.. _zend.navigation.pages.factory.example.mvc:

.. rubric:: Erstellen einer MVC Seite durch Verwenden der Page Factory

.. code-block:: php
   :linenos:

   $page = Zend_Navigation_Page::factory(array(
       'label'  => 'My MVC page',
       'action' => 'index'
   ));

   $page = Zend_Navigation_Page::factory(array(
       'label'      => 'Search blog',
       'action'     => 'index',
       'controller' => 'search',
       'module'     => 'blog'
   ));

   $page = Zend_Navigation_Page::factory(array(
       'label'      => 'Home',
       'action'     => 'index',
       'controller' => 'index',
       'module'     => 'index',
       'route'      => 'home'
   ));

   $page = Zend_Navigation_Page::factory(array(
       'type'   => 'mvc',
       'label'  => 'My MVC page'
   ));

.. _zend.navigation.pages.factory.example.uri:

.. rubric:: Erstellen einer URI Seite durch Verwendung der Page Factory

.. code-block:: php
   :linenos:

   $page = Zend_Navigation_Page::factory(array(
       'label' => 'My URI page',
       'uri'   => 'http://www.example.com/'
   ));

   $page = Zend_Navigation_Page::factory(array(
       'label'  => 'Search',
       'uri'    => 'http://www.example.com/search',
       'active' => true
   ));

   $page = Zend_Navigation_Page::factory(array(
       'label' => 'My URI page',
       'uri'   => '#'
   ));

   $page = Zend_Navigation_Page::factory(array(
       'type'   => 'uri',
       'label'  => 'My URI page'
   ));

.. _zend.navigation.pages.factory.example.custom:

.. rubric:: Erstellung eines eigenen Seiten Typs durch Verwendung der Page Factory

Um einen eigenen Seitentyp zu erstellen mit Hilfe der Verwendung der Factory, muß die Option *type* verwendet
werden um den Klassennamen zu spezifizieren der instanziiert werden muß.

.. code-block:: php
   :linenos:

   class My_Navigation_Page extends Zend_Navigation_Page
   {
       protected $_fooBar = 'ok';

       public function setFooBar($fooBar)
       {
           $this->_fooBar = $fooBar;
       }
   }

   $page = Zend_Navigation_Page::factory(array(
       'type'    => 'My_Navigation_Page',
       'label'   => 'My custom page',
       'foo_bar' => 'foo bar'
   ));


