.. EN-Revision: none
.. _zend.navigation.introduction:

導入
==

``Zend_Navigation``\ は、
ウェブ・ページへのポインターのツリーを管理するためのコンポーネントです。
簡単に言うと、
それはメニュー、パンくず、リンク及びサイトマップを作成するために使われたり、
他のナビゲーション関連の目的のひな型の役目を果たすことができます。

.. _zend.navigation.introduction.concepts:

ページとコンテナ
--------

``Zend_Navigation``\ には2つの主要な概念があります:

.. _zend.navigation.introduction.pages:

ページ
^^^

``Zend_Navigation``\ におけるページ (``Zend\Navigation\Page\AbstractPage``) は、 - その最も基本的な形式で -
ポインターをウェブ・ページに保持するオブジェクトです。
ポインターそのものに加えて、ページオブジェクトはナビゲーションのために
一般的に関連するいくつかのその他の性能、 例えば *label*\ や *title*\ 他を含みます。

ページについて詳しくは :ref:`ページ <zend.navigation.pages>` 節をさらにお読みください。

.. _zend.navigation.introduction.containers:

コンテナ
^^^^

ナビゲーション・コンテナ (``Zend\Navigation\Container``) は、
ページのためのコンテナ・クラスです。
ページを追加したり、取得したり、削除したり、反復したりするためのメソッドがあります。
それは `SPL`_ インターフェース ``RecursiveIterator`` 及び ``Countable`` を実装して、
そのため、 ``RecursiveIteratorIterator`` のようなSPLイテレータで反復できます。

コンテナについて詳しくは :ref:`コンテナ <zend.navigation.containers>`
節をさらにお読みください。

.. note::

   ``Zend\Navigation\Page\AbstractPage``\ は ``Zend\Navigation\Container``
   を拡張します。それはページがサブページを持てることを意味します。

.. _zend.navigation.introduction.separation:

データ（モデル）とレンダリング（ビュー）の分離
-----------------------

``Zend_Navigation`` 名前空間のクラスは、
ナビゲーション用の要素のレンダリングを処理しません。
レンダリングは、ナビゲーション用のビューヘルパーで行なわれます。
しかしながら、ページは サイトマップその他のための、ラベルや *CSS*\
クラス、タイトル、 そして *lastmod* 及び *priority* プロパティーのようなものを
レンダリングするときに、 ビューヘルパーによって使われる情報を含みます

:ref:`ナビゲーション・ヘルパー <zend.view.helpers.initial.navigation>`\ の
マニュアル部分でナビゲーション用の要素のレンダリングについてさらにお読みください。



.. _`SPL`: http://php.net/spl
