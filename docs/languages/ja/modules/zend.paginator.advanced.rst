.. EN-Revision: none
.. _zend.paginator.advanced:

高度な使用法
======

.. _zend.paginator.advanced.adapters:

独自のデータソースアダプタ
-------------

同梱のアダプタでは対応していないようなデータ形式を処理したくなることもあるでしょう。
そんな場合は自分でアダプタを書く必要があります。

そのためには ``Zend_Paginator_Adapter_Interface``
を実装しなければなりません。このインターフェイスでは 2
つのメソッドが必須となっています。

- count()

- getItems($offset, $itemCountPerPage)

さらに、コンストラクタを実装してそのパラメータでデータソースを受け取り、
protected あるいは private
なプロパティにそれを保存する処理も作りたくなることでしょう。
これをどのように実装するかはあなた次第です。

これまでに SPL の `Countable`_ インターフェイスを使ったことがある方なら ``count()``
はおなじみでしょう。 ``Zend_Paginator`` と組み合わせて使う場合、
これはデータコレクション内の項目総数を返します。 さらに、 ``Zend_Paginator``
のインスタンスには ``countAllItems()`` メソッドがあります。 これはアダプタの ``count()``
メソッドへのプロキシです。

``getItems()`` メソッドは、ほんの少しだけ複雑です。 これは、オフセットおよび 1
ページあたりの項目数を受け取ります。
それにあわせて適切なデータを返す必要があります。
配列の場合はこのようになるでしょう。



   .. code-block:: php
      :linenos:

      return array_slice($this->_array, $offset, $itemCountPerPage);



同梱のアダプタ (すべて ``Zend_Paginator_Adapter_Interface`` を実装しています) を見れば、
自分のアダプタでこれをどのように実装すればいいのか参考になるでしょう。

.. _zend.paginator.advanced.scrolling-styles:

独自のスクロール形式
----------

独自のスクロール形式を作成するには ``Zend_Paginator_ScrollingStyle_Interface``
を実装しなければなりません。このインターフェイスには ``getPages()``
メソッドが定義されています。



   .. code-block:: php
      :linenos:

      public function getPages(Zend_Paginator $paginator, $pageRange = null);



このメソッドは、いわゆる "ローカル" ページ (現在のページの周辺のページたち)
の範囲のページの最小値・ 最大値を計算しなければなりません。

他のスクロール形式を継承している (たとえば ``Zend_Paginator_ScrollingStyle_Elastic``)
のでない限り、自作のスクロール形式は必ずといっていいほど
次のようなコードで終わることになるでしょう。



   .. code-block:: php
      :linenos:

      return $paginator->getPagesInRange($lowerBound, $upperBound);



このコールには特別な意味はありません。
単に最小値と最大値の妥当性をチェックして、
その範囲の配列を返しているだけです。

新しいスクロール形式が用意できたら、どのディレクトリからそれを探すのかを
``Zend_Paginator`` に通知する必要があります。 そのためには、次のようにします。



   .. code-block:: php
      :linenos:

      $prefix = 'My_Paginator_ScrollingStyle';
      $path   = 'My/Paginator/ScrollingStyle/';
      Zend_Paginator::addScrollingStylePrefixPath($prefix, $path);



.. _zend.paginator.advanced.caching:

キャッシュ機能
-------

``Zend_Paginator`` は、渡されたデータをキャッシュする機能があります。
これを使用すると、アダプタが毎回データを取得することを回避できます。
アダプタのデータを自動的にキャッシュさせるよう設定するには、 ``setCache()``
メソッドに ``Zend_Cache_Core`` のインスタンスを渡します。



   .. code-block:: php
      :linenos:

      $paginator = Zend_Paginator::factory($someData);
      $fO = array('lifetime' => 3600, 'automatic_serialization' => true);
      $bO = array('cache_dir'=>'/tmp');
      $cache = Zend_cache::factory('Core', 'File', $fO, $bO);
      Zend_Paginator::setCache($cache);



``Zend_Paginator`` が ``Zend_Cache_Core`` のインスタンスを受け取ると、
データがキャッシュされるようになります。キャッシュインスタンスを渡した後でも、
場合によってはデータをキャッシュしたくないこともあるでしょう。そんな場合は
``setCacheEnable()`` を使用します。



   .. code-block:: php
      :linenos:

      $paginator = Zend_Paginator::factory($someData);
      // $cache は Zend_Cache_Core のインスタンスです
      Zend_Paginator::setCache($cache);
      // ... スクリプトの後半で次のようにすると
      $paginator->setCacheEnable(false);
      // キャッシュが無効になります



キャッシュが設定されると、データは自動的に格納され、必要に応じて取り出されるようになります。
キャッシュを手動で空にできると便利でしょう。そうするには
``clearPageItemCache($pageNumber)`` をコールします。
何もパラメータを渡さなければ、キャッシュ全体が空になります。
ページ番号をパラメータとして渡すと、そのページのキャッシュを空にします。



   .. code-block:: php
      :linenos:

      $paginator = Zend_Paginator::factory($someData);
      Zend_Paginator::setCache($cache);
      $items = $paginator->getCurrentItems();
      // これで 1 ページ目がキャッシュに入りました
      $page3Items = $paginator->getItemsByPage(3);
      // これで 3 ページ目がキャッシュに入りました

      // 3 ページ目のキャッシュをクリアします
      $paginator->clearPageItemCache(3);

      // すべてのキャッシュをクリアします
      $paginator->clearPageItemCache();



1 ページあたりのアイテム数を変更すると、キャッシュ全体が空になります。
キャッシュの内容が無効になるからです。



   .. code-block:: php
      :linenos:

      $paginator = Zend_Paginator::factory($someData);
      Zend_Paginator::setCache($cache);
      // アイテムを取得します
      $items = $paginator->getCurrentItems();

      // すべてのキャッシュデータが消去されます
      $paginator->setItemCountPerPage(2);



キャッシュ内のデータを見たり、直接アクセスしたりすることもできます。その場合には
``getPageItemCache()`` を使用します。



   .. code-block:: php
      :linenos:

      $paginator = Zend_Paginator::factory($someData);
      $paginator->setItemCountPerPage(3);
      Zend_Paginator::setCache($cache);

      // アイテムを取得します
      $items = $paginator->getCurrentItems();
      $otherItems = $paginator->getItemsPerPage(4);

      // キャッシュされたアイテムを二次元配列で取得します
      var_dump($paginator->getPageItemCache());



.. _zend.paginator.advanced.aggregator:

Zend_Paginator_AdapterAggregate インターフェイス
----------------------------------------

作成するアプリケーションによっては、「内部のデータ構造は既存のアダプタと同じだけれども
そのデータにアクセスするためにカプセル化を崩したくない」ということもあるでしょう。
あるいは、 ``Zend_Paginator_Adapter_Abstract`` が提供するような「オブジェクト "is-a"
アダプタ」形式ではなく 「オブジェクト "has-a"
アダプタ」形式であることもあるでしょう。 そんな場合は ``Zend_Paginator_AdapterAggregate``
インターフェイスを使用します。これは、 *PHP* の SPL 拡張モジュールにある
``IteratorAggregate`` と同じ動きをします。



   .. code-block:: php
      :linenos:

      interface Zend_Paginator_AdapterAggregate
      {
          /**
           * Return a fully configured Paginator Adapter from this method.
           *
           * @return Zend_Paginator_Adapter_Abstract
           */
          public function getPaginatorAdapter();
      }



このインターフェイスは小さく、ただ ``Zend_Paginator_Adapter_Abstract``
のインスタンスを返すだけのものです。このインスタンスは *Zend_Paginator::factory*
および Zend_Paginator コンストラクタの両方で使用可能で、適切に処理されます。



.. _`Countable`: http://www.php.net/~helly/php/ext/spl/interfaceCountable.html
