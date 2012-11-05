.. EN-Revision: none
.. _zend.feed.consuming-atom:

Atom フィードの使用
============

``Zend\Feed\Atom`` の使用法は ``Zend\Feed\Rss``
と似ていで、フィードのプロパティへのアクセス、
フィード内のエントリの順次処理などができるようになります。大きな違いは Atom
プロトコルの構造自体によるものです。Atom は *RSS* の後継として作成されたもので、
より一般的なプロトコルです。
フィード内に全コンテンツを含めるような形式をより簡単に扱うように設計されており、
*RSS* の *description* タグに該当するものが *summary* と *content* の 2
つの要素に分割されています。

.. _zend.feed.consuming-atom.example.usage:

.. rubric:: Atom フィードの基本的な使用法

Atom フィードを読み込み、各エントリの *title* と *summary* を表示します。

.. code-block:: php
   :linenos:

   $feed = new Zend\Feed\Atom('http://atom.example.com/feed/');
   echo 'このフィードには ' . $feed->count() . ' 件のエントリが含まれます。' . "\n\n";
   foreach ($feed as $entry) {
       echo 'タイトル: ' . $entry->title() . "\n";
       echo '概要: ' . $entry->summary() . "\n\n";
   }

Atom フィードでは、フィードのプロパティとして以下のようなものが使用できます。



   - *title*- フィードのタイトル。 *RSS* チャネルの title と同じです

   - *id*- Atom では、すべてのフィードやエントリが ID を持っています

   - *link*- フィードには複数のリンクを含めることができ、 それらは *type*
     属性によって識別されます

     *type="text/html"* とすると、 *RSS* チャネルの link
     と同等になります。リンク先がこのフィードのコンテンツの別バージョンである場合は、
     *rel="alternate"* 属性を使用します。

   - *subtitle*- フィードの説明。 *RSS* チャネルの description と同じです

     *author->name()*- フィードの著者の名前

     *author->email()*- フィードの著者のメールアドレス



Atom エントリでよく使用されるプロパティは以下のようになります。



   - *id*- エントリの ID

   - *title*- エントリのタイトル。 *RSS* アイテムの title と同じです

   - *link*- このエントリの別フォーマットの文書へのリンク

   - *summary*- エントリの概要

   - *content*- エントリの完全なテキスト。
     概要のみを提供するフィードの場合は省略可能です

   - *author*- フィードと同様に *name* および *email* を配下に保持します

   - *published*- エントリの公開日 (*RFC* 3339 形式)

   - *updated*- エントリの最終更新日 (*RFC* 3339 形式)



Atom についての詳細な情報やリソースについては `http://www.atomenabled.org/`_
を参照ください。



.. _`http://www.atomenabled.org/`: http://www.atomenabled.org/
