.. EN-Revision: none
.. _zend.feed.consuming-rss:

RSS フィードの使用
===========

*RSS* フィードの読み込みは、フィードの *URL* を指定して ``Zend\Feed\Rss``
のインスタンスを作成するのと同じくらい簡単です。

.. code-block:: php
   :linenos:

   $channel = new Zend\Feed\Rss('http://rss.example.com/channelName');

フィードの取得時にエラーが発生した場合は ``Zend\Feed\Exception`` がスローされます。

フィードオブジェクトを取得すると、標準的な *RSS* の "channel"
プロパティに対して直接アクセスできるようになります。

.. code-block:: php
   :linenos:

   echo $channel->title();

関数の構文に注意しましょう。"getter" 方式の構文 (*$obj->property*) をした場合は、
``Zend_Feed`` はプロパティを *XML* オブジェクトとして扱います。 一方、メソッドの構文
(*$obj->property()*) を使用した場合は文字列として扱います。
これにより、特定のノードを取得したあとで、さらにその子要素にもアクセスできるようになります。

チャネルのプロパティが属性を保持している場合、 *PHP*
の配列構文を使用してそれらにアクセスできます。

.. code-block:: php
   :linenos:

   echo $channel->category['domain'];

*XML* の属性は子を持つことができないので、
属性値へアクセスする際にメソッド構文を使用する必要はありません。

たいていの場合は、フィードをループさせたうえで、
個々のエントリに対して何かをすることになるでしょう。 ``Zend\Feed\Abstract`` は *PHP* の
*Iterator* インターフェイスを実装しているので、
例えばチャネル内の全記事のタイトルを表示するには単にこのようにするだけです。

.. code-block:: php
   :linenos:

   <?php
   foreach ($channel as $item) {
       echo $item->title() . "\n";
   }

*RSS* にあまり詳しくない方のために、 *RSS* チャネルおよび個々の *RSS* アイテム
(エントリ) で利用できる標準的な要素をまとめます。

必須のチャネル要素



   - *title*- チャネルの名前

   - *link*- チャネルに対応するウェブサイトの *URL*

   - *description*- チャネルについての説明



よく使用されるオプションのチャネル要素



   - *pubDate*- コンテンツの発行日を *RFC* 822 の日付書式で表したもの

   - *language*- チャネルで使用している言語

   - *category*- チャネルの所属するカテゴリ (複数の場合は複数のタグで指定)



*RSS* の *<item>* 要素には必須要素はありません。 しかし *title* あるいは *description*
が存在しなければなりません。

よく使用されるアイテム要素



   - *title*- アイテムのタイトル

   - *link*- アイテムの *URL*

   - *description*- アイテムの概要

   - *author*- 著者のメールアドレス

   - *category*- アイテムが所属するカテゴリ

   - *comments*- このアイテムに関連するコメントの *URL*

   - *pubDate*- アイテムの発行日を *RFC* 822 の日付書式で表したもの



要素が空要素であるかどうかは、以下のようにして調べられます。

.. code-block:: php
   :linenos:

   if ($item->propname()) {
       // ... 続行できます
   }

*$item->propname* 形式を使用した場合は、 空のオブジェクトについても ``TRUE``
と評価されてしまうので、 このように調べることはできません。

詳細な情報は、 `http://blogs.law.harvard.edu/tech/rss`_ にある *RSS* 2.0
の公式仕様を参照ください。



.. _`http://blogs.law.harvard.edu/tech/rss`: http://blogs.law.harvard.edu/tech/rss
