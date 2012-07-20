.. _zend.navigation.pages.custom:

Erstellung eigener Seiten Typen
===============================

Wenn ``Zend_Navigation_Page`` erweiter wird, besteht normalerweise keine Notwendigkeit den Constructor oder die
Methoden ``setOptions()`` oder ``setConfig()`` zu überladen. Der Constructor der Seite nimmt einen einzelnen
Parameter, ein ``Array`` oder ein ``Zend_Config`` Objekt, welches an ``setOptions()`` oder an ``setConfig()``
übergeben wird. Diese Methoden rufen dann die ``set()`` Methode auf, welche Optionen in native oder eigene
Eigenschaften mappt. Wenn die Option ``internal_id`` angegeben wird, dann wird zuerst nach einer Methode geschaut
die ``setInternalId()`` heißt und die Option wird an diese Methode übergeben wenn Sie existiert. Wenn die Methode
nicht existiert, wird die Option als eigene Eigenschaft der Seite gesetzt, und ist über ``$internalId =
$page->internal_id;`` oder ``$internalId = $page->get('internal_id');`` erreichbar.

.. _zend.navigation.custom.example.simple:

.. rubric:: Die einfachste eigene Seite

Das einzige Ding das eine eigene Seite implementieren muß ist die ``getHref()`` Methode.

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

.. rubric:: Eine eigene Seite mit Eigenschaften

Wenn Eigenschaften an eine erweiterte Seite angefügt werden, gibt es keine Notwendigkeit ``setOptions()`` oder
``setConfig()`` zu Überladen/Modifizieren.

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

   // Kann jetzt Erstellt werden mit
   $page = new My_Navigation_Page(array(
       'label'   => 'Namen von Eigenschaften werden auf Setter gemappt',
       'foo'     => 'bar',
       'foo_bar' => 'baz'
   ));

   // ...oder
   $page = Zend_Navigation_Page::factory(array(
       'type'    => 'My_Navigation_Page',
       'label'   => 'Namen von Eigenschaften werden auf Setter gemappt',
       'foo'     => 'bar',
       'foo_bar' => 'baz'
   ));


