.. EN-Revision: none
.. _zend.feed.introduction:

導入
==

``Zend_Feed`` は、 *RSS* や Atom のフィードを扱う機能を提供します。
フィードの要素や属性、そしてエントリの属性に、自然な方法でアクセスできるようになります。
また、 ``Zend_Feed`` でフィードやエントリの構造を変更し、 その結果を *XML*
に書き戻すという拡張機能もあります。将来的には Atom Publishig Protocol (AtomPP)
にも対応させる予定です。

``Zend_Feed`` の構成は、基底クラス ``Zend_Feed``\ 、
フィードやエントリを扱うための基底抽象クラス ``Zend_Feed_Abstract`` および
``Zend_Feed_Entry_Abstract``\ 、 *RSS* や Atom 用のフィードクラスとエントリクラスの実装、
そして自然な方法でそれらを操作するためのヘルパーから成り立っています。

以下では、 *RSS* フィードの取得、 フィードデータの *PHP*
配列への変換、データの表示、
データベースへの保存などの簡単な使用例を示します。

.. note::

   **注意**

   *RSS* フィードによって、使用できるチャネルやアイテムのプロパティが違います。
   *RSS* の仕様ではオプションのプロパティが多く定義されているので、 *RSS*
   データを扱うコードを書く際にはこのことに注意しましょう。

.. _zend.feed.introduction.example.rss:

.. rubric:: Zend_Feed による RSS フィードデータの使用

.. code-block:: php
   :linenos:

   // 最新の Slashdot ヘッドラインを取得します
   try {
       $slashdotRss =
           Zend_Feed::import('http://rss.slashdot.org/Slashdot/slashdot');
   } catch (Zend_Feed_Exception $e) {
       // フィードの読み込みに失敗しました
       echo "フィードの読み込み中に例外が発生: {$e->getMessage()}\n";
       exit;
   }

   // チャネルデータの配列を初期化します
   $channel = array(
       'title'       => $slashdotRss->title(),
       'link'        => $slashdotRss->link(),
       'description' => $slashdotRss->description(),
       'items'       => array()
       );

   // チャネルの各項目をループし、関連するデータを保存します
   foreach ($slashdotRss as $item) {
       $channel['items'][] = array(
           'title'       => $item->title(),
           'link'        => $item->link(),
           'description' => $item->description()
           );
   }


