.. _zend.view.helpers.initial.object:

HTML オブジェクトヘルパー
===============

*HTML* の **<object>** 要素は、 Flash や QuickTime
といったメディアをウェブページに埋め込むために使用するものです。
オブジェクトビューヘルパーは、
最低限の労力でメディアを埋め込めるよう手助けします。

最初は、以下の 4 つのオブジェクトヘルパーを提供します。

- ``htmlFlash()`` は、Flash ファイルの埋め込み用のマークアップを生成します。

- ``htmlObject()`` は、カスタムオブジェクトの埋め込み用のマークアップを生成します。

- ``htmlPage()`` は、他の (X)HTML ページの埋め込み用のマークアップを生成します。

- ``htmlQuicktime()`` は、QuickTime ファイルの埋め込み用のマークアップを生成します。

これらのヘルパーはすべて、同じインターフェイスを共有しています。
そのため、このドキュメントでは、そのうちの 2
つのヘルパーの例だけを紹介します。

.. _zend.view.helpers.initial.object.flash:

.. rubric:: Flash ヘルパー

このヘルパーを使うと、Flash をページの中に簡単に埋め込めるようになります。
リソースの *URI* を引数として渡すだけの簡単な作業です。

.. code-block:: php
   :linenos:

   <?php echo $this->htmlFlash('/path/to/flash.swf'); ?>

この結果は、次のような *HTML* となります。

.. code-block:: html
   :linenos:

   <object data="/path/to/flash.swf"
           type="application/x-shockwave-flash"
           classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
           codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab">
   </object>

さらに、属性やパラメータ、コンテンツなど **<object>**
とともにレンダリングする内容も指定できます。その方法は ``htmlObject()``
ヘルパーで紹介します。

.. _zend.view.helpers.initial.object.object:

.. rubric:: 追加属性を渡すことによるオブジェクトのカスタマイズ

オブジェクトヘルパーの最初の引数は常に必須です。
これは、埋め込みたいリソースの *URI* となります。 2 番目の引数は ``htmlObject()``
ヘルパーの場合のみ必須となります。
それ以外のヘルパーはこの引数の正確な値を既に知っているからです。 3
番目の引数には、object 要素の属性を渡します。 キー/値
のペア形式の配列のみを受け付けます。 属性の例としては、たとえば ``classid`` や
``codebase`` などがあります。 4 番目の引数も同様に キー/値
のペア形式の配列のみを受け取り、 それを使用して **<param>**
要素を作成します。例を参照ください。
最後に、オプションでそのオブジェクトの追加コンテンツを指定できます。
これらすべての引数を使用した例をごらんください。

.. code-block:: php
   :linenos:

   echo $this->htmlObject(
       '/path/to/file.ext',
       'mime/type',
       array(
           'attr1' => 'aval1',
           'attr2' => 'aval2'
       ),
       array(
           'param1' => 'pval1',
           'param2' => 'pval2'
       ),
       'some content'
   );

   /*
   出力は次のようになります

   <object data="/path/to/file.ext" type="mime/type"
       attr1="aval1" attr2="aval2">
       <param name="param1" value="pval1" />
       <param name="param2" value="pval2" />
       some content
   </object>
   */


