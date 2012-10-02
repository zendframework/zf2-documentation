.. EN-Revision: none
.. _zend.view.helpers.initial.headlink:

HeadLink ヘルパー
=============

HTML の *<link>* 要素は複数使用することができ、
スタイルシートやフィード、favicon、トラックバック
などのさまざまなリソースへのリンクを表します。 *HeadLink* ヘルパーは、
シンプルなインターフェイスでこれらの要素を作成し、
後でそれを取得してレイアウトスクリプトで出力することができます。

*HeadLink* ヘルパーには、
スタイルシートへのリンクをスタックに追加するメソッドがあります。

- *appendStylesheet($href, $media, $conditionalStylesheet, $extras)*

- *offsetSetStylesheet($index, $href, $media, $conditionalStylesheet, $extras)*

- *prependStylesheet($href, $media, $conditionalStylesheet, $extras)*

- *setStylesheet($href, $media, $conditionalStylesheet, $extras)*

``$media`` のデフォルトは 'screen' ですが、 有効な media
形式なら何にでもすることができます。 ``$conditionalStylesheet`` は文字列あるいは false
で、 レンダリング時に使用します。
特定のプラットフォームでスタイルシートの読み込みをやめたい場合などに、
特別なコメントを使用できるようになります。 ``$extras``
は、そのタグに追加したい特別な値の配列です。

さらに、 *HeadLink* ヘルパーには、スタックに 'alternate'
リンクを追加するメソッドもあります。

- *appendAlternate($href, $type, $title, $extras)*

- *offsetSetAlternate($index, $href, $type, $title, $extras)*

- *prependAlternate($href, $type, $title, $extras)*

- *setAlternate($href, $type, $title, $extras)*

``headLink()`` ヘルパーメソッドは、 *<link>*
要素に必要なすべての属性を指定することができ、
その位置も指定することができます。
たとえば、新たな要素がこれまでのものを上書きする、
あるいはスタックの先頭に追加する、スタックの末尾に追加するなどを指定します。

*HeadLink* ヘルパーは、 :ref:`Placeholder ヘルパー <zend.view.helpers.initial.placeholder>`
の具象実装です。

.. _zend.view.helpers.initial.headlink.basicusage:

.. rubric:: HeadLink ヘルパーの基本的な使用法

*headLink* は、いつでも指定することができます。
一般的には、グローバルなリンクはレイアウトスクリプトで指定して、
アプリケーション固有のリンクはアプリケーションのビュースクリプトで指定することになります。
レイアウトスクリプトでは、<head>
セクションの中でヘルパーを出力することになります。

.. code-block:: php
   :linenos:

   <?php // ビュースクリプトのリンクを設定します
   $this->headLink(array(
       'rel'  => 'favicon',
       'href' => '/img/favicon.ico'
   ), 'PREPEND')
       ->appendStylesheet('/styles/basic.css')
       ->prependStylesheet(
           '/styles/moz.css',
           'screen',
           true,
           array('id' => 'my_stylesheet')
       );
   ?>
   <?php // リンクをレンダリングします ?>
   <?php echo $this->headLink() ?>


