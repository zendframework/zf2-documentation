.. EN-Revision: none
.. _zend.view.helpers.initial.partial:

Partial ヘルパー
============

``Partial`` ビューヘルパーは、
指定したテンプレートを自分自身のスコープ内でレンダリングします。
主な使い道は、
再利用可能な部分テンプレートを変数名の競合を気にせずに使うというものです。
さらに、特定のモジュールから部分ビュースクリプトを指定できるようになります。

``Partial`` と兄弟関係にある ``PartialLoop``
ビューヘルパーは、反復処理可能なデータを渡して
その各要素に対してレンダリングを行うものです。

.. note::

   **PartialLoop カウンタ**

   ``PartialLoop`` ビューヘルパーは、変数を **partialCounter** というビューに代入します。
   これは、配列の現在の位置をビュースクリプトに渡します。
   これを利用すると、たとえばテーブルの行の色を一行おきに入れ替えるなどが簡単にできます。

.. _zend.view.helpers.initial.partial.usage:

.. rubric:: Partial の基本的な使用法

partial の基本的な使用法は、
自分自身のビューのスコープで部分テンプレートをレンダリングすることです。
次のようなスクリプトを考えてみましょう。

.. code-block:: php
   :linenos:

   <?php // partial.phtml ?>
   <ul>
       <li>From: <?php echo $this->escape($this->from) ?></li>
       <li>Subject: <?php echo $this->escape($this->subject) ?></li>
   </ul>

これを、ビュースクリプトから次のようにコールします。

.. code-block:: php
   :linenos:

   <?php echo $this->partial('partial.phtml', array(
       'from' => 'Team Framework',
       'subject' => 'view partials')); ?>

レンダリングした結果は、このようになります。

.. code-block:: html
   :linenos:

   <ul>
       <li>From: Team Framework</li>
       <li>Subject: view partials</li>
   </ul>

.. note::

   **モデルは何?**

   ``Partial`` ビューヘルパーが使用するモデルは、 次のいずれかとなります。

   - **配列**\ 。 配列を渡す場合は、連想配列形式でなければなりません。
     そのキーと値のペアがビューに渡され、 キーが変数名となります。

   - **toArray() メソッドを実装したオブジェクト**\ 。 そのオブジェクトの ``toArray()``
     メソッドを実行した結果が、ビューオブジェクトに渡されます。

   - **標準のオブジェクト**\ 。 それ以外のオブジェクトについては、 ``object_get_vars()``
     の結果 (そのオブジェクトのすべての public プロパティ)
     がビューオブジェクトに渡されます。

   使用するモデルがオブジェクトである場合は、
   それを変数の配列などに変換するのではなく **オブジェクトのまま** 直接 partial
   スクリプトに渡したくなるものでしょう。
   そのためには、しかるべきヘルパーでプロパティ 'objectKey' を設定します。

   .. code-block:: php
      :linenos:

      // オブジェクトを、変数 'model' として渡すよう通知します
      $view->partial()->setObjectKey('model');

      // partialLoop のオブジェクトを、最終的なビュースクリプト内で
      // 変数 'model' として渡すよう通知します
      $view->partialLoop()->setObjectKey('model');

   このテクニックが特に役立つのは、 ``Zend_Db_Table_Rowset`` を ``partialLoop()``
   に渡すような場合です。 ビュースクリプト内で row
   オブジェクトに自由にアクセスでき、 そのメソッド
   (親の値を取得したり従属行を取得したりなど) を自在に使えるようになります。

.. _zend.view.helpers.initial.partial.partialloop:

.. rubric:: PartialLoop による反復処理可能なモデルのレンダリング

一般に、ループ内で partial
を使用して特定のコンテンツを繰り返しレンダリングしたくなることもあるでしょう。
こうすることで、繰り返し表示される大量のコンテンツや複雑な表示ロジックを
ひとつにまとめることができます。
しかし、この方法はパフォーマンスに影響を及ぼします。 というのも、partial
ヘルパーをループ内で毎回実行することになるからです。

``PartialLoop`` ビューヘルパーは、
この問題を解決します。これを使用すると、反復処理可能な内容 (配列、あるいは
**Iterator** を実装したオブジェクト) をモデルに渡せるようになります。
そしてその各要素が partial スクリプトへモデルとして渡されます。 各要素の内容は、
``Partial`` ビューヘルパーが受け付ける任意の形式のモデルとできます。

次のような部分ビュースクリプトを考えます。

.. code-block:: php
   :linenos:

   <?php // partialLoop.phtml ?>
       <dt><?php echo $this->key ?></dt>
       <dd><?php echo $this->value ?></dd>

そして "モデル" はこのようになります。

.. code-block:: php
   :linenos:

   $model = array(
       array('key' => 'Mammal', 'value' => 'Camel'),
       array('key' => 'Bird', 'value' => 'Penguin'),
       array('key' => 'Reptile', 'value' => 'Asp'),
       array('key' => 'Fish', 'value' => 'Flounder'),
   );

そして、ビュースクリプト内で ``PartialLoop`` ヘルパーを実行します。

.. code-block:: php
   :linenos:

   <dl>
   <?php echo $this->partialLoop('partialLoop.phtml', $model) ?>
   </dl>

.. code-block:: html
   :linenos:

   <dl>
       <dt>Mammal</dt>
       <dd>Camel</dd>

       <dt>Bird</dt>
       <dd>Penguin</dd>

       <dt>Reptile</dt>
       <dd>Asp</dd>

       <dt>Fish</dt>
       <dd>Flounder</dd>
   </dl>

.. _zend.view.helpers.initial.partial.modules:

.. rubric:: 他のモジュールの Partial のレンダリング

時には partial が別のモジュールに存在することもあるでしょう。
そのモジュールの名前がわかっていれば、モジュール名を ``partial()`` あるいは
``partialLoop()`` の 2 番目の引数として渡し、 ``$model`` を 3
番目の引数に移動させることができます。

たとえば、'list' モジュールにある pager というスクリプトを使用したい場合は、
次のようにします。

.. code-block:: php
   :linenos:

   <?php echo $this->partial('pager.phtml', 'list', $pagerData) ?>

こうすると、特定の partial を他のモジュールで再利用できるようになります。
再利用可能な partial
は、共有のビュースクリプトのパスに配置することをおすすめします。


