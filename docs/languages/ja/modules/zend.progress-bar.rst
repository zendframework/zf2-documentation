.. _zend.progressbar.introduction:

Zend_ProgressBar
================

.. _zend.progressbar.whatisit:

導入
--

``Zend_ProgressBar`` は、
さまざまな環境上でプログレスバーの作成や更新を行うコンポーネントです。
単一のバックエンドが、複数のアダプタの中のいずれかを用いて進捗状況を出力します。
更新のたびに現在値とオプションのメッセージを受け取り、
進捗率や残り時間などを計算してアダプタを呼び出します。

.. _zend.progressbar.basic:

Zend_Progressbar の基本的な使用法
-------------------------

``Zend_ProgressBar`` の使い方はきわめて簡単です。 単純に ``Zend_Progressbar``
の新しいインスタンスを作成し、
最小値と最大値を指定した上でデータ出力用のアダプタを選択するだけです。
何かのファイルの処理を行いたい場合は、たとえば次のようになります。

.. code-block:: php
   :linenos:

   $progressBar = new Zend_ProgressBar($adapter, 0, $fileSize);

   while (!feof($fp)) {
       // なにかの処理

       $progressBar->update($currentByteCount);
   }

   $progressBar->finish();

まず第一段階として、 ``Zend_ProgressBar`` のインスタンスを作成してアダプタを指定し、
最小値を 0、最大値をファイルのサイズに指定します。
ループ内でファイルが処理されるたびに、
現在のバイト数でプログレスバーを更新します。
ループを抜けた後で、プログレスバーを処理完了状態に設定します。

``Zend_ProgressBar`` の ``update()`` メソッドを引数なしでコールすることもできます。
その場合は、単に残り時間を再計算してアダプタに通知します。
これは、データが何も更新されていないけれども
プログレスバーを更新したいという場合に有用です。

.. _zend.progressbar.persistent:

進捗の永続化
------

複数のリクエストにまたがってプログレスバーを持続させたい場合は、
コンストラクタの 4 番目の引数でセッション名前空間名を指定します。
そうすると、プログレスバーのコンストラクタ内ではアダプタへの通知が行われず
``update()`` あるいは ``finish()``
をコールしたときにのみ通知が行われるようになります。
また、現在の値や状況表示用テキスト、
そして残り時間計算用の開始時刻などは次のリクエストにも引き継がれるようになります。

.. _zend.progressbar.adapters:

標準のアダプタ
-------

``Zend_ProgressBar`` には次の 3 つのアダプタが同梱されています。



   - :ref:` <zend.progressbar.adapter.console>`

   - :ref:` <zend.progressbar.adapter.jspush>`

   - :ref:` <zend.progressbar.adapter.jspull>`



.. include:: zend.progress-bar.adapter.console.rst
.. include:: zend.progress-bar.adapter.js-push.rst
.. include:: zend.progress-bar.adapter.js-pull.rst

