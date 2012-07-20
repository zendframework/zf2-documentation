.. _zend.log.writers.firebug:

Firebug への書き込み
==============

``Zend_Log_Writer_Firebug`` は、ログデータを `Firebug`_ `コンソール`_ に送信します。

.. image:: ../images/zend.wildfire.firebug.console.png
   :width: 310


すべてのデータの送信には ``Zend_Wildfire_Channel_HttpHeaders``
コンポーネントを使用します。これは *HTTP* ヘッダを使用するので、
ページのコンテンツには何も影響を及ぼしません。 この方式なら、 *AJAX*
リクエストのようにクリーンな *JSON* および *XML*
レスポンスを要求するリクエストのデバッグも行えます。

要件:

- Firefox ブラウザ。バージョン 3 が最適ですがバージョン 2 にも対応しています。

- Firebug 拡張。 `https://addons.mozilla.org/ja/firefox/addon/1843`_ からダウンロードできます。

- FirePHP 拡張。 `https://addons.mozilla.org/ja/firefox/addon/6149`_ からダウンロードできます。

.. _zend.log.writers.firebug.example.with_front_controller:

.. rubric:: Zend_Controller_Front を使ったログ記録

.. code-block:: php
   :linenos:

   // 起動ファイルで、フロントコントローラのディスパッチの前に記述します
   $writer = new Zend_Log_Writer_Firebug();
   $logger = new Zend_Log($writer);

   // モデル、ビューおよびコントローラのファイル内でこれを使用します
   $logger->log('This is a log message!', Zend_Log::INFO);

.. _zend.log.writers.firebug.example.without_front_controller:

.. rubric:: Zend_Controller_Front を使わないログ記録

.. code-block:: php
   :linenos:

   $writer = new Zend_Log_Writer_Firebug();
   $logger = new Zend_Log($writer);

   $request = new Zend_Controller_Request_Http();
   $response = new Zend_Controller_Response_Http();
   $channel = Zend_Wildfire_Channel_HttpHeaders::getInstance();
   $channel->setRequest($request);
   $channel->setResponse($response);

   // 出力バッファリングを開始します
   ob_start();

   // ロガーをコールします

   $logger->log('This is a log message!', Zend_Log::INFO);

   // ログデータをブラウザに送ります
   $channel->flush();
   $response->sendHeaders();

.. _zend.log.writers.firebug.priority-styles:

優先度のスタイルの設定
-----------

組み込みの優先度やユーザ定義の優先度を使うには ``setPriorityStyle()``
メソッドを使用します。

.. code-block:: php
   :linenos:

   $logger->addPriority('FOO', 8);
   $writer->setPriorityStyle(8, 'TRACE');
   $logger->foo('Foo Message');

ユーザ定義の優先度用のデフォルトのスタイルを設定するには ``setDefaultPriorityStyle()``
メソッドを使用します。

.. code-block:: php
   :linenos:

   $writer->setDefaultPriorityStyle('TRACE');

サポートしているスタイルは次のとおりです。



      .. _zend.log.writers.firebug.priority-styles.table:

      .. table:: Firebug Logging Styles

         +------------+--------------------------------------------------------------------------------------------------------+
         |スタイル        |説明                                                                                                      |
         +============+========================================================================================================+
         |LOG         |通常のログメッセージを表示します                                                                                        |
         +------------+--------------------------------------------------------------------------------------------------------+
         |INFO        |情報ログメッセージを表示します                                                                                         |
         +------------+--------------------------------------------------------------------------------------------------------+
         |WARN        |警告ログメッセージを表示します                                                                                         |
         +------------+--------------------------------------------------------------------------------------------------------+
         |ERROR       |エラーログメッセージを表示し、Firebug のエラーカウントをひとつ増やします                                                                |
         +------------+--------------------------------------------------------------------------------------------------------+
         |TRACE       |拡張スタックトレースつきのログメッセージを表示します                                                                              |
         +------------+--------------------------------------------------------------------------------------------------------+
         |EXCEPTION   |拡張スタックトレースつきのエラーログメッセージを表示します                                                                           |
         +------------+--------------------------------------------------------------------------------------------------------+
         |TABLE       |拡張テーブルつきのログメッセージを表示します                                                                                  |
         +------------+--------------------------------------------------------------------------------------------------------+



.. _zend.log.writers.firebug.preparing-data:

ログ記録用のデータの準備
------------

任意の *PHP* の変数を組み込みの優先度でログに記録できますが、
特殊なログ形式を使う場合は、何らかの書式変換が必要となります。

``LOG``\ 、 ``INFO``\ 、 ``WARN``\ 、 ``ERROR`` そして ``TRACE``
については特別な書式変換は不要です。

.. _zend.log.writers.firebug.preparing-data.exception:

例外のログ記録
-------

``Zend_Exception`` のログを記録するには、
単にその例外オブジェクトをロガーに渡すだけです。
設定している優先度やスタイルにかかわらず、 例外は自動的に例外と判断されます。

.. code-block:: php
   :linenos:

   $exception = new Zend_Exception('Test exception');
   $logger->err($exception);

.. _zend.log.writers.firebug.preparing-data.table:

表形式のログ
------

ログを表形式で記録できます。カラムは自動検出され、
データの最初の行がヘッダと見なされます。

.. code-block:: php
   :linenos:

   $writer->setPriorityStyle(8, 'TABLE');
   $logger->addPriority('TABLE', 8);

   $table = array('Summary line for the table',
                array(
                    array('Column 1', 'Column 2'),
                    array('Row 1 c 1',' Row 1 c 2'),
                    array('Row 2 c 1',' Row 2 c 2')
                )
               );
   $logger->table($table);



.. _`Firebug`: http://www.getfirebug.com/
.. _`コンソール`: http://getfirebug.com/logging.html
.. _`https://addons.mozilla.org/ja/firefox/addon/1843`: https://addons.mozilla.org/ja/firefox/addon/1843
.. _`https://addons.mozilla.org/ja/firefox/addon/6149`: https://addons.mozilla.org/ja/firefox/addon/6149
