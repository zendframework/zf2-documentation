.. EN-Revision: none
.. _zend.tag.introduction:

導入
==

``Zend_Tag``\ は、タグ付けできる項目で動作するための機能を与える
コンポーネント・スイートです。 その基盤として、タグで動作するクラスを２つ、
``Zend\Tag\Item``\ 及び ``Zend\Tag\ItemList``\ を 提供します。 さらに、それにインタフェース
``Zend\Tag\Taggable``\ がついてきます。 そして、それは ``Zend_Tag``\ と連携した、
タグ付けできる項目としてどのモデルでも利用できます。

``Zend\Tag\Item``\ は、 ``Zend_Tag``\ スイートで動作する必要のある重要な機能に付属する、
基本的なタグ付けできる項目の実装です。
タグ付けできる項目は、常にタイトルと相対荷重（例えば反復回数）から成ります。
それも、 ``Zend_Tag``\ の異なるサブコンポーネントによって使われる
パラメータを格納します。

複数の項目をまとめるために、 ``Zend\Tag\ItemList``\ は配列イテレータとして存在して、
その中で各項目の与えられた相対荷重に基づく絶対重み付け値を計算するために、
更なる機能を与えます。

.. _zend.tag.example.using:

.. rubric:: Zend_Tagの利用

この例は、タグの一覧を作成して、
絶対の重み付け値をそれらに行き渡らせる方法を例示します。

.. code-block:: php
   :linenos:

   //項目一覧を作成
   $list = new Zend\Tag\ItemList();

   //タグをそれに割り当て
   $list[] = new Zend\Tag\Item(array('title' => 'Code', 'weight' => 50));
   $list[] = new Zend\Tag\Item(array('title' => 'Zend Framework', 'weight' => 1));
   $list[] = new Zend\Tag\Item(array('title' => 'PHP', 'weight' => 5));

   //絶対値をそれらに行き渡らせる
   $list->spreadWeightValues(array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));

   //それらの絶対値とともに項目を出力
   foreach ($list as $item) {
       printf("%s: %d\n", $item->getTitle(), $item->getParam('weightValue'));
   }

これはCodeとZend Framework及び *PHP*\ を 絶対値の10、１及び２で出力します。


