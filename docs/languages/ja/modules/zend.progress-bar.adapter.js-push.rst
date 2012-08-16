.. EN-Revision: none
.. _zend.progressbar.adapter.jspush:

Zend_ProgressBar_Adapter_JsPush
===============================

``Zend_ProgressBar_Adapter_JsPush`` は、 ブラウザ内のプログレスバーを Javascript の Push
で更新するアダプタです。
つまり、実行中のプロセスの情報を取得するために改めて接続を行う必要がなく、
そのプロセス自身が状況を直接ブラウザに送信するということです。

アダプタのオプションを設定するには、 *set**
メソッドを使用するか、あるいはコンストラクタの最初のパラメータで 配列か
``Zend_Config`` インスタンスを渡します。 使用できるオプションは次のとおりです。

- *updateMethodName*: 毎回の更新時にコールされる javascript のメソッド。 デフォルト値は
  ``Zend_ProgressBar_Update`` です。

- *finishMethodName*: 状態を設定した後にコールされる javascript のメソッド。
  デフォルト値は ``NULL`` で、この場合は何も行われません。

このアダプタの使い方はきわめて単純です。まず、ブラウザ上にプログレスバーを作成します。
これは JavaScript を用いたものでもかまいませんしプレーンな *HTML*
によるものでもかまいません。それから、更新時のメソッドと 終了時のメソッド
(オプション) を JavaScript で定義します。
これらのメソッドは、どちらも唯一の引数として json
オブジェクトを受け取るようにします。
そして、処理時間が長くかかるウェブページを *iframe* タグあるいは *object*
タグの中で呼び出します。処理の実行中に、
更新が行われるたびにアダプタのメソッドがコールされます。 引数として渡される
json オブジェクトには次のパラメータが含まれています。

- *current*: 現在の値。

- *max*: 最大値。

- *percent*: 算出したパーセンテージ。

- *timeTaken*: これまでの経過時間。

- *timeRemaining*: プロセスが終了するまでの予想残り時間。

- *text*: オプションのメッセージ (指定した場合のみ)。

.. _zend.progressbar-adapter.jspush.example:

.. rubric:: クライアント側の基本例

この例では、JsPush アダプタ用の *HTML* および *CSS*\ 、JavaScript
の基本的な設定方法を示します。

.. code-block:: html
   :linenos:

   <div id="zend-progressbar-container">
       <div id="zend-progressbar-done"></div>
   </div>

   <iframe src="long-running-process.php" id="long-running-process"></iframe>

.. code-block:: css
   :linenos:

   #long-running-process {
       position: absolute;
       left: -100px;
       top: -100px;

       width: 1px;
       height: 1px;
   }

   #zend-progressbar-container {
       width: 100px;
       height: 30px;

       border: 1px solid #000000;
       background-color: #ffffff;
   }

   #zend-progressbar-done {
       width: 0;
       height: 30px;

       background-color: #000000;
   }

.. code-block:: javascript
   :linenos:

   function Zend_ProgressBar_Update(data)
   {
       document.getElementById('zend-progressbar-done').style.width =
            data.percent + '%';
   }

これは、黒の枠線と進捗状況表示用ブロックからなるシンプルなコンテナを作成します。
*iframe* や *object* を *display: none;* で隠してしまってはいけません。Safari 2 などでは、
そうすると実際のコンテンツを読み込まなくなってしまします。

プログレスバーを自作するのではなく、Dojo や jQuery などの既存の JavaScript
ライブラリのものを利用したいこともあるでしょう。
たとえば次のようなものがあります。

- Dojo: `http://dojotoolkit.org/reference-guide/dijit/ProgressBar.html`_

- jQuery: `http://t.wits.sg/2008/06/20/jquery-progress-bar-11/`_

- MooTools: `http://davidwalsh.name/dw-content/progress-bar.php`_

- Prototype: `http://livepipe.net/control/progressbar`_

.. note::

   **更新間隔**

   あまり頻繁に更新しすぎないようにしましょう。 毎回の更新は、少なくとも 1kb
   の大きさとなるからです。 これは、Safari
   が実際にレンダリングを行って関数をコールするのに必要なサイズです。 Internet
   Explorer の場合はこれは 256 バイトとなります。



.. _`http://dojotoolkit.org/reference-guide/dijit/ProgressBar.html`: http://dojotoolkit.org/reference-guide/dijit/ProgressBar.html
.. _`http://t.wits.sg/2008/06/20/jquery-progress-bar-11/`: http://t.wits.sg/2008/06/20/jquery-progress-bar-11/
.. _`http://davidwalsh.name/dw-content/progress-bar.php`: http://davidwalsh.name/dw-content/progress-bar.php
.. _`http://livepipe.net/control/progressbar`: http://livepipe.net/control/progressbar
