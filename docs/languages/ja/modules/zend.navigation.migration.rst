.. _zend.navigation.migration:

前バージョンからの移行
===========

この章は、主に ``Zend_Navigation`` 及び ``Zend_View_Helper_Navigation``
でなされる下位互換性破壊を文書化して、
前バージョンからの移行を手伝う役目を果たさなければなりません。

.. _zend.view.navigation.zf7341:

バージョン 1.9以前からの移行
----------------

1.9のリリース以前は、 メニュー・ヘルパー(``Zend_View_Helper_Navigation_Menu``)は、
サブ・メニューを正しくレンダリングしませんでした。 *onlyActiveBranch*\ が ``TRUE``\
で、 オプションの *renderParents*\ が ``FALSE``\ のとき、
もし、もっとも深いアクティブなページが *minDepth*\
オプションよりも少ない深さの場合には、 何もレンダリングされませんでした。

簡単に言うと、もし *minDepth*\ が *1*\ に設定され、
アクティブなページが最初のレベルのページの一つだったら、
下記の例のように、何もレンダリングされませんでした。

下記のコンテナを設定したと考えてください。

.. code-block:: php
   :linenos:

   <?php
   $container = new Zend_Navigation(array(
       array(
           'label' => 'Home',
           'uri'   => '#'
       ),
       array(
           'label'  => 'Products',
           'uri'    => '#',
           'active' => true,
           'pages'  => array(
               array(
                   'label' => 'Server',
                   'uri'   => '#'
               ),
               array(
                   'label' => 'Studio',
                   'uri'   => '#'
               )
           )
       ),
       array(
           'label' => 'Solutions',
           'uri'   => '#'
       )
   ));

下記のコードがビュースクリプトとして使われます。

.. code-block:: php
   :linenos:

   <?php echo $this->navigation()->menu()->renderMenu($container, array(
       'minDepth'         => 1,
       'onlyActiveBranch' => true,
       'renderParents'    => false
   )); ?>

リリース 1.9 以前では、上記のコード・スニペットは何も出力しませんでした。

リリース1.9以降では、 ``Zend_View_Helper_Navigation_Menu``\ の ``_renderDeepestMenu()``\ メソッドが
*minDepth*\ 以下の一つの層のレベルのアクティブなページを、
そのページが子供を持つ限り、受け入れます。

今では、同じコード・スニペットは下記のように出力するようになります。

.. code-block:: html
   :linenos:

   <ul class="navigation">
       <li>
           <a href="#">Server</a>
       </li>
       <li>
           <a href="#">Studio</a>
       </li>
   </ul>


