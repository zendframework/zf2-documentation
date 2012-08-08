.. EN-Revision: none
.. _zend.view.helpers.initial.headscript:

HeadScript ヘルパー
===============

HTML の *<script>* 要素を使用して、
クライアントサイトのスクリプトをインラインで指定したり
外部のリソースからスクリプトのコードを読み込んだりします。 *HeadScript*
ヘルパーは、この両方の方式に対応しています。

*HeadScript* ヘルパーは、
以下のメソッド群によってスクリプトの設定や追加をサポートします。

- *appendFile($src, $type = 'text/javascript', $attrs = array())*

- *offsetSetFile($index, $src, $type = 'text/javascript', $attrs = array())*

- *prependFile($src, $type = 'text/javascript', $attrs = array())*

- *setFile($src, $type = 'text/javascript', $attrs = array())*

- *appendScript($script, $type = 'text/javascript', $attrs = array())*

- *offsetSetScript($index, $script, $type = 'text/javascript', $attrs = array())*

- *prependScript($script, $type = 'text/javascript', $attrs = array())*

- *setScript($script, $type = 'text/javascript', $attrs = array())*

**File()* 系のメソッドでは、 ``$src``
は読み込みたいリモートスクリプトの場所となります。 通常は、 *URL*
あるいはパスの形式となります。 **Script()* 系のメソッドでは、 ``$script``
はその要素に使用したいクライアント側のスクリプトとなります。

.. note::

   **条件コメントの設定**

   *HeadScript* では、script タグを条件コメントで囲むことができます。
   そうすれば、特定のブラウザでだけスクリプトを実行しないこともできます。
   これを使用するには conditional タグを設定し、条件をメソッドコール時の ``$attrs``
   パラメータで渡します。

   .. _zend.view.helpers.initial.headscript.conditional:

   .. rubric:: Headscript で条件コメントを使う例

   .. code-block:: php
      :linenos:

      // スクリプトを追加します
      $this->headScript()->appendFile(
          '/js/prototype.js',
          'text/javascript',
          array('conditional' => 'lt IE 7')
      );

*HeadScript* はスクリプトのキャプチャも行います。
これは、クライアント側スクリプトをプログラム上で作成してから
どこか別の場所で使いたい場合に便利です。 使用法は、以下の例で示します。

``headScript()`` メソッドを使うと、 スクリプト要素を手っ取り早く追加できます。
シグネチャは ``headScript($mode = 'FILE', $spec, $placement = 'APPEND')`` です。 ``$mode`` は 'FILE'
あるいは 'SCRIPT' のいずれかで、
スクリプトへのリンクを指定するのかスクリプト自体を定義するのかによって切り替えます。
``$spec`` は、リンクするスクリプトファイルあるいはスクリプトのソースとなります。
``$placement`` は 'APPEND'、'PREPEND' あるいは 'SET' のいずれかでなければなりません。

*HeadScript* は ``append()`` や ``offsetSet()``\ 、 ``prepend()``\ 、そして ``set()``
をそれぞれオーバーライドして、上にあげた特別なメソッドを使用させるようにします。
内部的には、各項目を *stdClass* のトークンとして保管し、 あとで ``itemToString()``
メソッドでシリアライズします。 これはスタック内の項目についてチェックを行い、
オプションでそれを修正したものを返します。

*HeadScript* ヘルパーは、 :ref:`Placeholder ヘルパー <zend.view.helpers.initial.placeholder>`
の具象実装です。

.. note::

   **HTML Body スクリプトでの InlineScript の使用**

   HTML の *body* 部にスクリプトを埋め込みたい場合は、 *HeadScript* の姉妹版である
   :ref:`InlineScript <zend.view.helpers.initial.inlinescript>` を使わなければなりません。
   スクリプトをドキュメントの最後のほうに配置するようにすると、
   ページの表示速度が向上します。特に、
   サードパーティのアクセス解析用スクリプトを使用する場合などにこの効果が顕著にあらわれます。

.. note::

   **すべての属性はデフォルトで無効**

   デフォルトでは、 *HeadScript* がレンダリングする *<script>* の属性は W3C
   に認められているものだけです。 'type' や 'charset'、'defer'、'language' そして 'src'
   が該当します。 しかし、Javascript のフレームワーク (`Dojo`_ など)
   では独自の属性を用いることでその挙動を変更しています。
   このような属性を許可するには、 ``setAllowArbitraryAttributes()``
   メソッドを使用します。

   .. code-block:: php
      :linenos:

      $this->headScript()->setAllowArbitraryAttributes(true);

.. _zend.view.helpers.initial.headscript.basicusage:

.. rubric:: HeadScript ヘルパーの基本的な使用法

上で説明したように、新しい script タグを、好きなときに指定できます。
外部のリソースへのリンクも可能ですし、
スクリプト自体を指定することも可能です。

.. code-block:: php
   :linenos:

   // スクリプトを追加します
   $this->headScript()->appendFile('/js/prototype.js')
                      ->appendScript($onloadScript);

クライアント側のスクリプトでは並び順が重要となります。
指定した並び順で出力させる必要が出てくることでしょう。
そのために使用するのが、append、prepend そして offsetSet といったディレクティブです。

.. code-block:: php
   :linenos:

   // スクリプトの順番を指定します

   // 特定の位置を指定し、確実に最後に読み込まれるようにします
   $this->headScript()->offsetSetFile(100, '/js/myfuncs.js');

   // scriptaculous のエフェクトを使用します (次のインデックスである 101 に追加されます)
   $this->headScript()->appendFile('/js/scriptaculous.js');

   // でも、もととなる prototype スクリプトは常に最初に読み込まれるようにします
   $this->headScript()->prependFile('/js/prototype.js');

すべてのスクリプトを出力する準備が整ったら、
あとはレイアウトスクリプトでそれを出力するだけです。

.. code-block:: php
   :linenos:

   <?php echo $this->headScript() ?>

.. _zend.view.helpers.initial.headscript.capture:

.. rubric:: HeadScript ヘルパーによるスクリプトのキャプチャ

時にはクライアント側のスクリプトをプログラムで生成しなければならないこともあるでしょう。
文字列の連結やヒアドキュメント等を使っても構いませんが、
ふつうにスクリプトを作成してそれを *PHP* のタグに埋め込めればより簡単です。
*HeadScript* は、スタックにキャプチャすることでこれを実現します。

.. code-block:: php
   :linenos:

   <?php $this->headScript()->captureStart() ?>
   var action = '<?php echo $this->baseUrl ?>';
   $('foo_form').action = action;
   <?php $this->headScript()->captureEnd() ?>

前提条件は次のとおりです。

- スクリプトは、スタックの末尾に追加されていきます。
  既存のスタックを上書きしたりスタックの先頭に追加したりしたい場合は、
  それぞれ 'SET' あるいは 'PREPEND' を ``captureStart()`` の最初の引数として渡します。

- スクリプトの *MIME* タイプは 'text/javascript' を想定しています。
  別のものを指定したい場合は、それを ``captureStart()`` の 2
  番目の引数として渡します。

- *<script>* タグに追加の属性を指定したい場合は、 ``captureStart()`` の 3
  番目の引数に配列形式で渡します。



.. _`Dojo`: http://www.dojotoolkit.org/
