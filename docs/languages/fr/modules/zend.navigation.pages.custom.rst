.. EN-Revision: none
.. _zend.navigation.pages.custom:

Créer des pages de type personnalisé
====================================

Etendre ``Zend\Navigation\Page`` ne nécessite pas forcément de réécrire le constructeur ou les méthodes
``setOptions()`` ou ``setConfig()``. Le constructeur prend un seul paramètre de type ``Array`` ou ``Zend_Config``
et il est passé à ``setOptions()`` ou ``setConfig()`` respectivement. Ces méthodes appellerons par la suite les
setters ``set()`` qui distribueront leurs options. Si l'option *internal_id* est présente, alors la méthode
``setInternalId()`` sera évaluée si présente, et l'option en question lui sera passée. Si une telle méthode
n'existe pas, l'option sera alors vue comme une propriété de la page et sera accessible sous *$internalId =
$page->internal_id;* ou *$internalId = $page->get('internal_id');*.

.. _zend.navigation.custom.example.simple:

.. rubric:: La page personnalisée la plus simple possible

La seule chose à définir dans une page personnalisée est la méthode ``getHref()``.

.. code-block:: php
   :linenos:

   class My_Simple_Page extends Zend\Navigation\Page
   {
       public function getHref()
       {
           return 'Quelquechose-ici--ce-que-je-veux';
       }
   }

.. _zend.navigation.custom.example.properties:

.. rubric:: Une page personnalisée avec des propriétés

Ajouter des propriétés à vos pages étendues ne nécessite pas de réécrire ``setOptions()`` ou
``setConfig()``.

.. code-block:: php
   :linenos:

   class My_Navigation_Page extends Zend\Navigation\Page
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
       'label'   => 'Les noms des propriétés sont dirigés vers les setters',
       'foo'     => 'bar',
       'foo_bar' => 'baz'
   ));

   // ...or
   $page = Zend\Navigation\Page::factory(array(
       'type'    => 'My_Navigation_Page',
       'label'   => 'Les noms des propriétés sont dirigés vers les setters',
       'foo'     => 'bar',
       'foo_bar' => 'baz'
   ));


