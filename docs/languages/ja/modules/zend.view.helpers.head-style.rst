.. _zend.view.helpers.initial.headstyle:

HeadStyle ヘルパー
==============

*HTML* の **<style>** 要素を使用して、 *CSS* スタイルシートを *HTML* の **<head>**
要素に埋め込みます。

.. note::

   **HeadLink を使用した CSS ファイルへのリンク**

   外部スタイルシートの読み込み用の **<link>** 要素を作成する場合は :ref:`HeadLink
   <zend.view.helpers.initial.headlink>`
   を使用する必要があります。スタイルシートをインラインで定義したい場合に
   ``HeadStyle`` を使用します。

``HeadStyle`` ヘルパーがサポートするメソッドは次のとおりです。
これらによってスタイルシート宣言の設定や追加を行います。

- ``appendStyle($content, $attributes = array())``

- ``offsetSetStyle($index, $content, $attributes = array())``

- ``prependStyle($content, $attributes = array())``

- ``setStyle($content, $attributes = array())``

すべての場合において、 ``$content`` には実際の *CSS* 宣言を指定します。 ``$attributes``
には、 ``style`` タグに追加したい属性があれば指定します。 lang、title、media そして dir
のすべてが使用可能です。

.. note::

   **条件コメントの設定**

   ``HeadStyle`` では、script タグを条件コメントで囲むことができます。
   そうすれば、特定のブラウザでだけスクリプトを実行しないこともできます。
   これを使用するには conditional タグを設定し、条件をメソッドコール時の
   ``$attributes`` パラメータで渡します。

   .. _zend.view.helpers.initial.headstyle.conditional:

   .. rubric:: Headstyle で条件コメントを使う例

   .. code-block:: php
      :linenos:

      // スクリプトを追加します
      $this->headStyle()->appendStyle($styles, array('conditional' => 'lt IE 7'));

``HeadStyle`` はスタイル宣言のキャプチャも行います。
これは、宣言をプログラム上で作成してからどこか別の場所で使いたい場合に便利です。
使用法は、以下の例で示します。

``headStyle()`` メソッドを使うと、宣言の要素を手っ取り早く追加できます。
シグネチャは ``headStyle($content$placement = 'APPEND', $attributes = array())`` です。 ``$placement``
には 'APPEND'、'PREPEND' あるいは 'SET' のいずれかを指定します。

``HeadStyle`` は ``append()`` や ``offsetSet()``\ 、 ``prepend()``\ 、そして ``set()``
をそれぞれオーバーライドして、上にあげた特別なメソッドを使用させるようにします。
内部的には、各項目を ``stdClass`` のトークンとして保管し、 あとで ``itemToString()``
メソッドでシリアライズします。 これはスタック内の項目についてチェックを行い、
オプションでそれを修正したものを返します。

``HeadStyle`` ヘルパーは、 :ref:`Placeholder ヘルパー <zend.view.helpers.initial.placeholder>`
の具象実装です。

.. note::

   **UTF-8 encoding used by default**

   By default, Zend Framework uses *UTF-8* as its default encoding, and, specific to this case, ``Zend_View`` does
   as well. Character encoding can be set differently on the view object itself using the ``setEncoding()`` method
   (or the the ``encoding`` instantiation parameter). However, since ``Zend_View_Interface`` does not define
   accessors for encoding, it's possible that if you are using a custom view implementation with this view helper,
   you will not have a ``getEncoding()`` method, which is what the view helper uses internally for determining the
   character set in which to encode.

   If you do not want to utilize *UTF-8* in such a situation, you will need to implement a ``getEncoding()`` method
   in your custom view implementation.

.. _zend.view.helpers.initial.headstyle.basicusage:

.. rubric:: HeadStyle ヘルパーの基本的な使用法

新しい style タグを、好きなときに指定できます。

.. code-block:: php
   :linenos:

   // スタイルを追加します
   $this->headStyle()->appendStyle($styles);

*CSS* では並び順が重要となります。
指定した並び順で出力させる必要が出てくることでしょう。
そのために使用するのが、append、prepend そして offsetSet といったディレクティブです。

.. code-block:: php
   :linenos:

   // スタイルの順番を指定します

   // 特定の位置に置きます
   $this->headStyle()->offsetSetStyle(100, $customStyles);

   // 最後に置きます
   $this->headStyle()->appendStyle($finalStyles);

   // 先頭に置きます
   $this->headStyle()->prependStyle($firstStyles);

すべてのスタイル宣言を出力する準備が整ったら、
あとはレイアウトスクリプトでそれを出力するだけです。

.. code-block:: php
   :linenos:

   <?php echo $this->headStyle() ?>

.. _zend.view.helpers.initial.headstyle.capture:

.. rubric:: HeadStyle ヘルパーによるスタイル宣言のキャプチャ

時には *CSS*
のスタイル宣言をプログラムで生成しなければならないこともあるでしょう。
文字列の連結やヒアドキュメント等を使っても構いませんが、
ふつうにスタイルを作成してそれを *PHP* のタグに埋め込めればより簡単です。
``HeadStyle`` は、スタックにキャプチャすることでこれを実現します。

.. code-block:: php
   :linenos:

   <?php $this->headStyle()->captureStart() ?>
   body {
       background-color: <?php echo $this->bgColor ?>;
   }
   <?php $this->headStyle()->captureEnd() ?>

前提条件は次のとおりです。

- スタイル宣言は、スタックの末尾に追加されていきます。
  既存のスタックを上書きしたりスタックの先頭に追加したりしたい場合は、
  それぞれ 'SET' あるいは 'PREPEND' を ``captureStart()`` の最初の引数として渡します。

- **<style>** タグに追加の属性を指定したい場合は、 ``captureStart()`` の 2
  番目の引数に配列形式で渡します。


