.. EN-Revision: none
.. _zend.navigation.pages.custom:

カスタム・ページ・タイプの作成
===============

``Zend\Navigation\Page``\ を拡張するとき、 通常は、コンストラクタ、メソッド
``setOptions()``\ 、 または ``setConfig()``\ をオーバーライドする必要はありません。
ページ・コンストラクタは単一のパラメータ、 ``Array``\ 、 または ``Zend_Config``\
オブジェクトを受け取ります。 そして、それはそれぞれ ``setOptions()`` または
``setConfig()``\ に渡されます。 それらのメソッドは次に ``set()``\ メソッドを呼びます。
そして、オプションをネイティブまたはカスタムのプロパティにマップします。
もし、オプション *internal_id*\ が与えられたら、 メソッドは ``setInternalId()``\
というメソッドを最初に探して、
それが存在するならばこのメソッドにオプションを渡します。
メソッドが存在しなければ、オプションはページのカスタム・プロパティとしてセットされて、
*$internalId = $page->internal_id;*\ または *$internalId = $page->get('internal_id');*\
を通じてアクセスできます。

.. _zend.navigation.custom.example.simple:

.. rubric:: もっとも単純なカスタム・ページ

カスタム・ページ・クラスで実装する必要がある唯一のものは、 ``getHref()``\
メソッドです。

.. code-block:: php
   :linenos:

   class My_Simple_Page extends Zend\Navigation\Page
   {
       public function getHref()
       {
           return 'something-completely-different';
       }
   }

.. _zend.navigation.custom.example.properties:

.. rubric:: プロパティ付のカスタム・ページ

拡張したページにプロパティを追加するとき、 ``setOptions()``\ や ``setConfig()``
メソッドをオーバーライドしたり、修正する必要はありません。

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

   //これで、利用して構築できます
   $page = new My_Navigation_Page(array(
       'label'   => 'Property names are mapped to setters',
       'foo'     => 'bar',
       'foo_bar' => 'baz'
   ));

   //または
   $page = Zend\Navigation\Page::factory(array(
       'type'    => 'My_Navigation_Page',
       'label'   => 'Property names are mapped to setters',
       'foo'     => 'bar',
       'foo_bar' => 'baz'
   ));


