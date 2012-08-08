.. EN-Revision: none
.. _zend.log.writers:

ライター
====

ライターは、 ``Zend_Log_Writer_Abstract``
を継承したオブジェクトです。ライターの役割は、
ログのデータをバックエンドのストレージに記録することです。

.. _zend.log.writers.stream:

ストリームへの書き出し
-----------

``Zend_Log_Writer_Stream`` は、ログデータを `PHP のストリーム`_ に書き出します。

ログのデータを *PHP* の出力バッファに書き出すには、URL ``php://output``
を使用します。一方、ログのデータを直接 ``STDERR``
のようなストリームに送ることもできます (``php://stderr``)。

.. code-block:: php
   :linenos:

   $writer = new Zend_Log_Writer_Stream('php://output');
   $logger = new Zend_Log($writer);

   $logger->info('Informational message');

データをファイルに書き出すには、 `ファイルシステム URL`_
のいずれかを使用します。

.. code-block:: php
   :linenos:

   $writer = new Zend_Log_Writer_Stream('/path/to/logfile');
   $logger = new Zend_Log($writer);

   $logger->info('Informational message');

デフォルトでは、ストリームを追記モード ("a") でオープンします。
別のモードでオープンするには、 ``Zend_Log_Writer_Stream``
のコンストラクタで二番目のオプション引数にモードを指定します。

``Zend_Log_Writer_Stream`` のコンストラクタには、
既存のストリームリソースを指定することもできます。

.. code-block:: php
   :linenos:

   $stream = @fopen('/path/to/logfile', 'a', false);
   if (! $stream) {
       throw new Exception('ストリームのオープンに失敗しました');
   }

   $writer = new Zend_Log_Writer_Stream($stream);
   $logger = new Zend_Log($writer);

   $logger->info('通知メッセージ');

既存のストリームリソースに対してモードを指定することはできません。
指定しようとすると ``Zend_Log_Exception`` をスローします。

.. _zend.log.writers.database:

データベースへの書き出し
------------

``Zend_Log_Writer_Db`` は、 ``Zend_Db`` を使用してログ情報をデータベースに書き出します。
``Zend_Log_Writer_Db`` のコンストラクタには ``Zend_Db_Adapter`` のインスタンス、テーブル名
およびデータベースのカラムとイベントデータ項目との対応を指定します。

.. code-block:: php
   :linenos:

   $params = array ('host'     => '127.0.0.1',
                    'username' => 'malory',
                    'password' => '******',
                    'dbname'   => 'camelot');
   $db = Zend_Db::factory('PDO_MYSQL', $params);

   $columnMapping = array('lvl' => 'priority', 'msg' => 'message');
   $writer = new Zend_Log_Writer_Db($db, 'log_table_name', $columnMapping);

   $logger = new Zend_Log($writer);

   $logger->info('通知メッセージ');

上の例は、一行ぶんのログデータを 'log_table_name'
という名前のテーブルに書き出します。データベースのカラム 'lvl'
には優先度の番号が格納され、'msg'
というカラムにログのメッセージが格納されます。

.. include:: zend.log.writers.firebug.rst
.. include:: zend.log.writers.mail.rst
.. include:: zend.log.writers.syslog.rst
.. include:: zend.log.writers.zend-monitor.rst
.. _zend.log.writers.null:

ライターのスタブ
--------

``Zend_Log_Writer_Null`` はスタブで、ログデータをどこにも書き出しません。
これは、ログ出力を無効にしたりテスト時などに便利です。

.. code-block:: php
   :linenos:

   $writer = new Zend_Log_Writer_Null;
   $logger = new Zend_Log($writer);

   // どこにも出力されません
   $logger->info('通知メッセージ');

.. _zend.log.writers.mock:

モックによるテスト
---------

``Zend_Log_Writer_Mock`` は非常にシンプルなライターです。
受け取った生のデータを配列に格納し、それを public プロパティとして公開します。

.. code-block:: php
   :linenos:

   $mock = new Zend_Log_Writer_Mock;
   $logger = new Zend_Log($mock);

   $logger->info('通知メッセージ');

   var_dump($mock->events[0]);

   // Array
   // (
   //    [timestamp] => 2007-04-06T07:16:37-07:00
   //    [message] => 通知メッセージ
   //    [priority] => 6
   //    [priorityName] => INFO
   // )

モックが記録したイベントを消去するには、単純に ``$mock->events = array()`` とします。

.. _zend.log.writers.compositing:

ライターを組み合わせる
-----------

合成ライターオブジェクトはありません。
しかし、ログのインスタンスは任意の数のライターに書き出すことができます。そのためには
``addWriter()`` メソッドを使用します。

.. code-block:: php
   :linenos:

   $writer1 = new Zend_Log_Writer_Stream('/path/to/first/logfile');
   $writer2 = new Zend_Log_Writer_Stream('/path/to/second/logfile');

   $logger = new Zend_Log();
   $logger->addWriter($writer1);
   $logger->addWriter($writer2);

   // 両方のライターに書き出されます
   $logger->info('通知メッセージ');



.. _`PHP のストリーム`: http://www.php.net/stream
.. _`ファイルシステム URL`: http://www.php.net/manual/ja/wrappers.php#wrappers.file
