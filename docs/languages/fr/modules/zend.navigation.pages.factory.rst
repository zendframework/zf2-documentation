.. EN-Revision: none
.. _zend.navigation.pages.factory:

Créer des pages avec la fabrique
================================

Toute les pages (même les personnalisées) peuvent petre créer via la fabrique
``Zend\Navigation\Page\AbstractPage::factory()``. Celle-ci peut prendre un tableau d'options ou un objet ``Zend_Config``. Chaque
clé correspondant à une option de l'obet page à créer comme l'indique la section concernant les :ref:`Pages
<zend.navigation.pages>`. Si le paramètre *uri* est passé et qu'aucun paramètre concernant *MVC* ne sont
présents (*action, controller, module, route*), une page de type *URI* sera créee. Si un ou plusieurs paramètres
concernant *MVC* sont passés, une page de type *MVC* sera retournée.

Si le paramètre *type* est passé, la fabrique l'utilisera pour déterminer le nom de la classe à utiliser. Les
valeurs *mvc* ou *uri* créeront des pages de types *MVC*/URI.

.. _zend.navigation.pages.factory.example.mvc:

.. rubric:: Créer une page MVC avec la fabrique

.. code-block:: php
   :linenos:

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'label'  => 'My MVC page',
       'action' => 'index'
   ));

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'label'      => 'Search blog',
       'action'     => 'index',
       'controller' => 'search',
       'module'     => 'blog'
   ));

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'label'      => 'Home',
       'action'     => 'index',
       'controller' => 'index',
       'module'     => 'index',
       'route'      => 'home'
   ));

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'type'   => 'mvc',
       'label'  => 'My MVC page'
   ));

.. _zend.navigation.pages.factory.example.uri:

.. rubric:: Créer une page URI avec la fabrique

.. code-block:: php
   :linenos:

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'label' => 'My URI page',
       'uri'   => 'http://www.example.com/'
   ));

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'label'  => 'Search',
       'uri'    => 'http://www.example.com/search',
       'active' => true
   ));

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'label' => 'My URI page',
       'uri'   => '#'
   ));

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'type'   => 'uri',
       'label'  => 'My URI page'
   ));

.. _zend.navigation.pages.factory.example.custom:

.. rubric:: Créer une page personnalisée avec la fabrique

Utilisez l'option *type* afin de nommer la classe à utiliser.

.. code-block:: php
   :linenos:

   class My_Navigation_Page extends Zend\Navigation\Page\AbstractPage
   {
       protected $_fooBar = 'ok';

       public function setFooBar($fooBar)
       {
           $this->_fooBar = $fooBar;
       }
   }

   $page = Zend\Navigation\Page\AbstractPage::factory(array(
       'type'    => 'My_Navigation_Page',
       'label'   => 'My custom page',
       'foo_bar' => 'foo bar'
   ));


