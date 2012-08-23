.. EN-Revision: none
.. _zend.feed.modifying-feed:

フィードおよびエントリの構造の変更
=================

フィードやエントリを読み込むだけでなく、それらを作成したり変更したりする場合にも
``Zend_Feed`` の自然な構文が使用できます。
作成したり変更したりしたオブジェクトを、 妥当な形式の *XML*
でファイルに保存したりサーバに送信したりといったことが簡単にできます。

.. _zend.feed.modifying-feed.example.modifying:

.. rubric:: 既存のフィードエントリの変更

.. code-block:: php
   :linenos:

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/1');
   $entry = $feed->current();

   $entry->title = '新しいタイトルです';
   $entry->author->email = 'my_email@example.com';

   echo $entry->saveXML();

これは、必要な *XML* 名前空間も含めた完全な (最初の ``<?xml ... >`` も含めた) *XML*
表記で新しいエントリを出力します。

既存のエントリが author タグを保持していない場合にも、
上の例は正しく動作することに注意しましょう。
代入する場所を指定するために、いくらでも ``->``
をつなげることができます。その途中の段階の要素は、
必要に応じて自動的に作成されます。

``atom:``\ 、 ``rss:``\ 、 ``osrss:`` 以外の名前空間をエントリで使用したい場合は、
``Zend_Feed::registerNamespace()`` を使用して ``Zend_Feed``
で名前空間を登録する必要があります。
既存の要素を書き換えた場合は、常にもとの名前空間が維持されます。
新しい要素を追加する場合には、
明示的に名前空間を指定しない限りデフォルトの名前空間に配置されます。

.. _zend.feed.modifying-feed.example.creating:

.. rubric:: 独自の名前空間の要素としての Atom エントリの作成

.. code-block:: php
   :linenos:

   $entry = new Zend_Feed_Entry_Atom();
   // Atom では id は常にサーバから割り当てられます
   $entry->title = 'カスタムエントリ';
   $entry->author->name = '著者名';
   $entry->author->email = 'me@example.com';

   // 独自の部分です
   Zend_Feed::registerNamespace('myns', 'http://www.example.com/myns/1.0');

   $entry->{'myns:myelement_one'} = 'はじめての独自の値';
   $entry->{'myns:container_elt'}->part1 = '入れ子になった独自部分、その1';
   $entry->{'myns:container_elt'}->part2 = '入れ子になった独自部分、その2';

   echo $entry->saveXML();


