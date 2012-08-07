.. _zend.navigation.pages.custom:

Erstellung eigener Seitentypen
==============================

Wenn ``Zend\Navigation\Page`` erweitert wird, besteht normalerweise keine Notwendigkeit den Konstruktor oder die
Methoden ``setOptions()`` oder ``setConfig()`` zu überladen. Der Konstruktor der Seite nimmt einen einzelnen
Parameter (ein ``Array`` oder ein ``Zend\Config``-Objekt) entgegen, welches an ``setOptions()`` bzw. an ``setConfig()``
weitergeleitet wird. Diese Methoden rufen dann die ``set()`` Methode auf, welche die Optionen in native oder eigene
Eigenschaften mappt. Wenn beispielsweise die Option ``internal_id`` angegeben wird, dann wird zuerst nach einer 
Methode gesucht, die ``setInternalId()`` heißt. Existiert diese Methode, dann wird die Option entsprechend übergeben.
Wenn die Methode nicht existiert, wird die Option als eigene Eigenschaft der Seite gesetzt und ist über 
``$internalId = $page->internal_id;`` oder ``$internalId = $page->get('internal_id');`` abrufbar.

.. _zend.navigation.custom.example.simple:

.. rubric:: Die einfachste Variante einer eigenen Seite

Die einzige Methode, die eine eigene Seite enthalten muss, ist die ``getHref()`` Methode.

.. code-block:: php
   :linenos:

   class My\Simple\Page extends Zend\Navigation\Page\AbstractPage
   {
       public function getHref()
       {
           return 'something-completely-different';
       }
   }

.. _zend.navigation.custom.example.properties:

.. rubric:: Eine eigene Seite mit Eigenschaften

Wenn Eigenschaften in eine erweiterte Seite eingefügt werden, dann müssen die Methoden ``setOptions()`` oder
``setConfig()`` nicht überladen/modifizieren werden.

.. code-block:: php
   :linenos:

   class My\Navigation\Page extends Zend\Navigation\Page\AbstractPage
   {
       protected $foo;
       protected $fooBar;

       public function setFoo($foo)
       {
           $this->foo = $foo;
       }

       public function getFoo()
       {
           return $this->foo;
       }

       public function setFooBar($fooBar)
       {
           $this->fooBar = $fooBar;
       }

       public function getFooBar()
       {
           return $this->fooBar;
       }

       public function getHref()
       {
           return $this->foo . '/' . $this->fooBar;
       }
   }

   // Kann jetzt Erstellt werden mit
   $page = new My\Navigation\Page(array(
       'label'   => 'Namen von Eigenschaften werden auf Setter-Methoden gemappt',
       'foo'     => 'bar',
       'foo_bar' => 'baz'
   ));

   // ...oder
   $page = Zend\Navigation\Page::factory(array(
       'type'    => 'My\Navigation\Page',
       'label'   => 'Namen von Eigenschaften werden auf Setter-Methoden gemappt',
       'foo'     => 'bar',
       'foo_bar' => 'baz'
   ));


