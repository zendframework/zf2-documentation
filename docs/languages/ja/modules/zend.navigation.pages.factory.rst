.. EN-Revision: none
.. _zend.navigation.pages.factory:

ページ・ファクトリを使ってページを作成
===================

すべてのページ（また、カスタマイズしたクラス）を、 ページ・ファクトリ
``Zend\Navigation\Page::factory()`` を用いて 作成できます。 ファクトリは任意の配列、
または ``Zend_Config``\ オブジェクトをとることができます。 :ref:`ページ
<zend.navigation.pages>`\ の節でご覧いただけるように、
配列または構成の各々のキーはページ・オプションと一致します。 *uri*\
が与えられ、 *MVC*\ オプション (*action, controller, module, route*) が与えられないなら、
*URI*\ ページが作成されます。 *MVC*\ オプションのいずれかが与えられると、 *MVC*\
ページが作成されます。

*type*\ が与えられると、
ファクトリは、その値が作成されるべきであるクラスの名前であると仮定します。  If
the value is *mvc* or *uri* and *MVC*/URI page will be created.

.. _zend.navigation.pages.factory.example.mvc:

.. rubric:: ページ・ファクトリを使ってMVCページを作成

.. code-block:: php
   :linenos:

   $page = Zend\Navigation\Page::factory(array(
       'label'  => 'My MVC page',
       'action' => 'index'
   ));

   $page = Zend\Navigation\Page::factory(array(
       'label'      => 'Search blog',
       'action'     => 'index',
       'controller' => 'search',
       'module'     => 'blog'
   ));

   $page = Zend\Navigation\Page::factory(array(
       'label'      => 'Home',
       'action'     => 'index',
       'controller' => 'index',
       'module'     => 'index',
       'route'      => 'home'
   ));

   $page = Zend\Navigation\Page::factory(array(
       'type'   => 'mvc',
       'label'  => 'My MVC page'
   ));

.. _zend.navigation.pages.factory.example.uri:

.. rubric:: ページ・ファクトリを使ってURIページを作成

.. code-block:: php
   :linenos:

   $page = Zend\Navigation\Page::factory(array(
       'label' => 'My URI page',
       'uri'   => 'http://www.example.com/'
   ));

   $page = Zend\Navigation\Page::factory(array(
       'label'  => 'Search',
       'uri'    => 'http://www.example.com/search',
       'active' => true
   ));

   $page = Zend\Navigation\Page::factory(array(
       'label' => 'My URI page',
       'uri'   => '#'
   ));

   $page = Zend\Navigation\Page::factory(array(
       'type'   => 'uri',
       'label'  => 'My URI page'
   ));

.. _zend.navigation.pages.factory.example.custom:

.. rubric:: ページ・ファクトリを使ってカスタムページ型を作成

ページ・ファクトリを使ってカスタムページ型を作成するには、
インスタンス化するクラス名を指定するために、 *type*\
オプションを使ってください。

.. code-block:: php
   :linenos:

   class My_Navigation_Page extends Zend\Navigation\Page
   {
       protected $_fooBar = 'ok';

       public function setFooBar($fooBar)
       {
           $this->_fooBar = $fooBar;
       }
   }

   $page = Zend\Navigation\Page::factory(array(
       'type'    => 'My_Navigation_Page',
       'label'   => 'My custom page',
       'foo_bar' => 'foo bar'
   ));


