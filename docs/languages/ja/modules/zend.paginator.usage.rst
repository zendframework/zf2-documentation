.. _zend.paginator.usage:

使用法
===

.. _zend.paginator.usage.paginating:

データコレクションのページ処理
---------------

ページ処理を行うには、 ``Zend_Paginator``
がデータにアクセスするための汎用的な方法が必要です。
そのため、データへのアクセスはすべてデータソースアダプタを用いて行います。
Zend Framework には、いくつかのアダプタが標準で同梱されています。

.. _zend.paginator.usage.paginating.adapters:

.. table:: Zend_Paginator 用のアダプタ

   +-------------+-----------------------------------------------------------------------------------------------------------------+
   |アダプタ         |説明                                                                                                               |
   +=============+=================================================================================================================+
   |Array        |PHP の配列を使用します。                                                                                                   |
   +-------------+-----------------------------------------------------------------------------------------------------------------+
   |DbSelect     |Zend_Db_Select のインスタンスを使用し、配列を返します。                                                                              |
   +-------------+-----------------------------------------------------------------------------------------------------------------+
   |DbTableSelect|Zend_Db_Table_Select のインスタンスを使用し、 Zend_Db_Table_Rowset_Abstract のインスタンスを返します。 これは、結果セットについての追加情報 (カラム名など) を提供します。|
   +-------------+-----------------------------------------------------------------------------------------------------------------+
   |Iterator     |Iterator のインスタンスを使用します。                                                                                          |
   +-------------+-----------------------------------------------------------------------------------------------------------------+
   |Null         |データのページ処理を管理する際に Zend_Paginator を使用しません。その場合でもページ処理コントロールの機能を使うことはできます。                                          |
   +-------------+-----------------------------------------------------------------------------------------------------------------+

.. note::

   指定したクエリにマッチするすべての行を取得するのではなく、 DbSelect アダプタや
   DbTableSelect アダプタは
   現在のページの表示のための必要最小限のデータのみを取得します。

   そのため、マッチする行の総数を得るための別のクエリが動的に生成されます。
   しかし、総数を直接指定したり、総数を求めるクエリを直接指定したりすることもできます。
   詳細な情報は、DbSelect アダプタの ``setRowCount()`` メソッドを参照ください。

``Zend_Paginator`` のインスタンスを作成するには、
コンストラクタでアダプタを指定しなければなりません。

.. code-block:: php
   :linenos:

   $paginator = new Zend_Paginator(new Zend_Paginator_Adapter_Array($array));

利便性を確保するために、Zend Framework に同梱されているアダプタ用の静的メソッド
``factory()`` も用意されています。

.. code-block:: php
   :linenos:

   $paginator = Zend_Paginator::factory($array);

.. note::

   ``Null`` アダプタの場合は、
   データコレクションのかわりに要素数をコンストラクタで指定します。

この状態でも技術的には既に使用可能ですが、
ユーザが要求したページ番号をコントローラのアクション内で教えてやる必要があります。
これにより、データを読み進めていくことが可能となります。

.. code-block:: php
   :linenos:

   $paginator->setCurrentPageNumber($page);

ページ番号は *URL* で指定するのがもっともシンプルな方法でしょう。
``Zend_Controller_Router_Interface`` 互換のルータを使うことを推奨しますが、
それが必須というわけではありません。

*INI* ファイルで定義するルートの例を次に示します。

.. code-block:: php
   :linenos:

   routes.example.route = articles/:articleName/:page
   routes.example.defaults.controller = articles
   routes.example.defaults.action = view
   routes.example.defaults.page = 1
   routes.example.reqs.articleName = \w+
   routes.example.reqs.page = \d+

この設定を使った (そして Zend Framework の *MVC* コンポーネントを使った)
場合、現在のページ番号を設定するコードはこのようになります。

.. code-block:: php
   :linenos:

   $paginator->setCurrentPageNumber($this->_getParam('page'));

それ以外にもオプションがあります。詳細は :ref:`設定 <zend.paginator.configuration>`
を参照ください。

最後に、paginator のインスタンスをビューに割り当てます。 ``Zend_View`` と ViewRenderer
アクションヘルパーを使っている場合は、 次のようになります。

.. code-block:: php
   :linenos:

   $this->view->paginator = $paginator;

.. _zend.paginator.usage.dbselect:

DbSelect および DbTableSelect アダプタ
-------------------------------

大半のアダプタの使用法は非常にわかりやすいものです。
しかし、データベースアダプタについては、
データベースからのデータの取得方法や件数の数え方についてのより詳細な説明が必要です。

DbSelect アダプタや DbTableSelect アダプタを使う際には、
事前にデータベースからデータを取得する必要はありません。
どちらのアダプタも、自動的にデータを取得して総ページ数を計算します。
もしデータベースからのデータに対して何らかの処理が必要となるのなら、
アダプタの ``getItems()`` メソッドをアプリケーション内で継承します。

さらに、これらのアダプタは、
数を数える際にデータベースの全レコードを取得するわけでは **ありません**\
。そのかわりに、アダプタが元のクエリを修正し、 それに対応する COUNT
クエリを作成します。 Paginator は、その COUNT
クエリを実行して行数を取得するのです。
そのぶんデータベースとの余分なやりとりが必要となりますが、結果セット全体を取得して
``count()`` を使うよりは何倍も高速になります。
大量のデータを扱う場合などは特にそうです。

データベースアダプタは、すべてのモダンなデータベース上で実行できる
もっとも効率的なクエリを作成しようとします。
しかし、使用するデータベースやスキーマ設定によっては
行数を取得するのにもっと効率的な方法があるかもしれません。
そのような場合のために、データベースアダプタでは独自の COUNT
クエリを設定できるようにもなっています。たとえば、 別々のテーブルにある blog
の投稿の数を調べるには、 次の用に設定すればより高速な count
クエリが使用できるでしょう。

.. code-block:: php
   :linenos:

   $adapter = new Zend_Paginator_Adapter_DbSelect($db->select()->from('posts'));
   $adapter->setRowCount(
       $db->select()
          ->from(
               'item_counts',
               array(
                  Zend_Paginator_Adapter_DbSelect::ROW_COUNT_COLUMN => 'post_count'
               )
            )
   );

   $paginator = new Zend_Paginator($adapter);

この方法は、小規模なデータや単純な select
クエリの場合にはあまり劇的な効果を得られません。
しかし、複雑なクエリや大規模なデータを扱う場合は
かなりパフォーマンスが向上することでしょう。

.. _zend.paginator.rendering:

ビュースクリプトによるページのレンダリング
---------------------

ビュースクリプトを使用してページ項目のレンダリング (``Zend_Paginator``
を使うよう設定している場合) とページ処理コントロールの表示を行います。

``Zend_Paginator`` は *SPL* の `IteratorAggregate`_ インターフェイスを実装しているので、
項目を順次処理したり表示したりするのは簡単です。

.. code-block:: php
   :linenos:

   <html>
   <body>
   <h1>Example</h1>
   <?php if (count($this->paginator)): ?>
   <ul>
   <?php foreach ($this->paginator as $item): ?>
     <li><?php echo $item; ?></li>
   <?php endforeach; ?>
   </ul>
   <?php endif; ?>

   <?php echo $this->paginationControl($this->paginator,
                                'Sliding',
                                'my_pagination_control.phtml'); ?>
   </body>
   </html>

最後のほうでビューヘルパーをコールしているところに注目しましょう。
PaginationControl 4 つまでのパラメータを受け取ります。 paginator
のインスタンス、スクロール形式、 そして追加パラメータの配列です。

2 番目と 3 番目のパラメータは重要です。 ビュー partial はページ処理コントロールの
**見た目**\ を決めるために用いられ、 一方スクロール形式はその **振る舞い**
を決めるために用いられます。ビュー partial
が、次のようなページ処理コントロール形式だっととしましょう。

.. image:: ../images/zend.paginator.usage.rendering.control.png
   :align: center

ここで "next" リンクを数回クリックしたときに、いったい何が起こるでしょう?
そう、いろんなことが起こりえます。
クリックし続けても現在のページがずっと中央に表示される (Yahoo! 形式)
かもしれませんし、
表示される範囲はそのままで現在のページの位置がどんどん右にずれていき、
表示範囲の最後をページでさらに "next"
をクリックしたときに一番左に戻るかもしれません。
ページを進めるたびにページ数そのものが増加 ("scroll") していく (Google 形式)
も考えられます。

4 種類のスクロール形式が Zend Framework に組み込まれています。

.. _zend.paginator.usage.rendering.scrolling-styles:

.. table:: Zend_Paginator のスクロール形式

   +-------+-----------------------------------------------------------------------------------------------------------+
   |スクロール形式|説明                                                                                                         |
   +=======+===========================================================================================================+
   |All    |すべてのページを返します。 総ページ数が比較的少なめのときなど、 ドロップダウンメニュー形式でページ選択をさせる際に便利です。 そのような場合は、利用できるすべてのページを 一度にユーザに見せることになるでしょう。|
   +-------+-----------------------------------------------------------------------------------------------------------+
   |Elastic|Google 風のスクロール形式で、 ユーザがページを移動するのにあわせて拡大・縮小します。                                                             |
   +-------+-----------------------------------------------------------------------------------------------------------+
   |Jumping|ユーザがページを進めるにつれて、 ページ番号が表示範囲の最後に向けて進んでいきます。 表示範囲を超えると、新しい範囲の最初の位置に移動します。                                    |
   +-------+-----------------------------------------------------------------------------------------------------------+
   |Sliding|Yahoo! 風のスクロール形式で、 現在表示されているページが常にページ範囲の中央 (あるいは可能な限りそれに近い場所) にあるようにします。これがデフォルトの形式です。                     |
   +-------+-----------------------------------------------------------------------------------------------------------+

4 番目、そして最後のパラメータはオプションの連想配列です。
ここで、ビューパーシャルから (``$this`` を用いて)
使用したい追加変数を指定します。
たとえば、ページ移動用のリンクに使用する追加の *URL*
パラメータなどを含めることができます。

デフォルトのビュー partial とスクロール形式、
そしてビューのインスタンスを設定してしまえば、 PaginationControl
のコールを完全に除去できます。

.. code-block:: php
   :linenos:

   Zend_Paginator::setDefaultScrollingStyle('Sliding');
   Zend_View_Helper_PaginationControl::setDefaultViewPartial(
       'my_pagination_control.phtml'
   );
   $paginator->setView($view);

これらの値をすべて設定すると、 ビュースクリプト内で単純な echo
文を使用するだけでページ処理コントロールをレンダリングできるようになります。

.. code-block:: php
   :linenos:

   <?php echo $this->paginator; ?>

.. note::

   もちろん、 ``Zend_Paginator``
   を別のテンプレートエンジンで使用することもできます。 たとえば、Smarty
   を使用する場合は次のようになります。

   .. code-block:: php
      :linenos:

      $smarty->assign('pages', $paginator->getPages());

   そして、テンプレートからは次のようにして paginator の値にアクセスします。

   .. code-block:: php
      :linenos:

      {$pages->pageCount}

.. _zend.paginator.usage.rendering.example-controls:

ページ処理コントロールの例
^^^^^^^^^^^^^

次のページ処理コントロールの例が、
とりあえず使い始めるにあたっての参考となることでしょう。

検索のページ処理

.. code-block:: php
   :linenos:

   <!--
   See http://developer.yahoo.com/ypatterns/pattern.php?pattern=searchpagination
   -->

   <?php if ($this->pageCount): ?>
   <div class="paginationControl">
   <!-- 前のページへのリンク -->
   <?php if (isset($this->previous)): ?>
     <a href="<?php echo $this->url(array('page' => $this->previous)); ?>">
       < Previous
     </a> |
   <?php else: ?>
     <span class="disabled">< Previous</span> |
   <?php endif; ?>

   <!-- ページ番号へのリンク -->
   <?php foreach ($this->pagesInRange as $page): ?>
     <?php if ($page != $this->current): ?>
       <a href="<?php echo $this->url(array('page' => $page)); ?>">
           <?php echo $page; ?>
       </a> |
     <?php else: ?>
       <?php echo $page; ?> |
     <?php endif; ?>
   <?php endforeach; ?>

   <!-- 次のページへのリンク -->
   <?php if (isset($this->next)): ?>
     <a href="<?php echo $this->url(array('page' => $this->next)); ?>">
       Next >
     </a>
   <?php else: ?>
     <span class="disabled">Next ></span>
   <?php endif; ?>
   </div>
   <?php endif; ?>

項目のページ処理

.. code-block:: php
   :linenos:

   <!--
   See http://developer.yahoo.com/ypatterns/pattern.php?pattern=itempagination
   -->

   <?php if ($this->pageCount): ?>
   <div class="paginationControl">
   <?php echo $this->firstItemNumber; ?> - <?php echo $this->lastItemNumber; ?>
   of <?php echo $this->totalItemCount; ?>

   <!-- 最初のページへのリンク -->
   <?php if (isset($this->previous)): ?>
     <a href="<?php echo $this->url(array('page' => $this->first)); ?>">
       First
     </a> |
   <?php else: ?>
     <span class="disabled">First</span> |
   <?php endif; ?>

   <!-- 前のページへのリンク -->
   <?php if (isset($this->previous)): ?>
     <a href="<?php echo $this->url(array('page' => $this->previous)); ?>">
       < Previous
     </a> |
   <?php else: ?>
     <span class="disabled">< Previous</span> |
   <?php endif; ?>

   <!-- 次のページへのリンク -->
   <?php if (isset($this->next)): ?>
     <a href="<?php echo $this->url(array('page' => $this->next)); ?>">
       Next >
     </a> |
   <?php else: ?>
     <span class="disabled">Next ></span> |
   <?php endif; ?>

   <!-- 最後のページへのリンク -->
   <?php if (isset($this->next)): ?>
     <a href="<?php echo $this->url(array('page' => $this->last)); ?>">
       Last
     </a>
   <?php else: ?>
     <span class="disabled">Last</span>
   <?php endif; ?>

   </div>
   <?php endif; ?>

ドロップダウンのページ処理

.. code-block:: php
   :linenos:

   <?php if ($this->pageCount): ?>
   <select id="paginationControl" size="1">
   <?php foreach ($this->pagesInRange as $page): ?>
     <?php $selected = ($page == $this->current) ? ' selected="selected"' : ''; ?>
     <option value="<?php
           echo $this->url(array('page' => $page));?>"<?php echo $selected ?>>
       <?php echo $page; ?>
     </option>
   <?php endforeach; ?>
   </select>
   <?php endif; ?>

   <script type="text/javascript"
        src="http://ajax.googleapis.com/ajax/libs/prototype/1.6.0.2/prototype.js">
   </script>
   <script type="text/javascript">
   $('paginationControl').observe('change', function() {
       window.location = this.options[this.selectedIndex].value;
   })
   </script>

.. _zend.paginator.usage.rendering.properties:

プロパティの一覧
^^^^^^^^

次のオプションが、ページ処理コントロールのビュー partial で使用可能です。

.. _zend.paginator.usage.rendering.properties.table:

.. table:: ビュー partial のプロパティ

   +----------------+-------+----------------------+
   |プロパティ           |型      |説明                    |
   +================+=======+======================+
   |first           |integer|最初のページ番号 (つまり 1)      |
   +----------------+-------+----------------------+
   |firstItemNumber |integer|このページの最初の項目の番号        |
   +----------------+-------+----------------------+
   |firstPageInRange|integer|スクロール形式で返された範囲内の最初のページ|
   +----------------+-------+----------------------+
   |current         |integer|現在のページ番号              |
   +----------------+-------+----------------------+
   |currentItemCount|integer|このページの項目の数            |
   +----------------+-------+----------------------+
   |itemCountPerPage|integer|各ページに表示できる項目の最大数      |
   +----------------+-------+----------------------+
   |last            |integer|最後のページ番号              |
   +----------------+-------+----------------------+
   |lastItemNumber  |integer|このページの最後の項目の番号        |
   +----------------+-------+----------------------+
   |lastPageInRange |integer|スクロール形式で返された範囲内の最後のページ|
   +----------------+-------+----------------------+
   |next            |integer|次のページ番号               |
   +----------------+-------+----------------------+
   |pageCount       |integer|ページ数                  |
   +----------------+-------+----------------------+
   |pagesInRange    |array  |スクロール形式で返されたページの配列    |
   +----------------+-------+----------------------+
   |previous        |integer|前のページ番号               |
   +----------------+-------+----------------------+
   |totalItemCount  |integer|項目の総数                 |
   +----------------+-------+----------------------+



.. _`IteratorAggregate`: http://www.php.net/~helly/php/ext/spl/interfaceIteratorAggregate.html
