.. _zend.db.profiler.profilers.firebug:

Firebug によるプロファイリング
===================

``Zend_Db_Profiler_Firebug`` は、プロファイリング情報を `Firebug`_ `コンソール`_
に送信します。

すべてのデータの送信には ``Zend_Wildfire_Channel_HttpHeaders``
コンポーネントを使用します。これは *HTTP* ヘッダを使用するので、
ページのコンテンツには何も影響を及ぼしません。 この方式なら、 *AJAX*
リクエストのようにクリーンな *JSON* および *XML*
レスポンスを要求するリクエストのデバッグも行えます。

要件:

- Firefox ブラウザ。バージョン 3 が最適ですがバージョン 2 にも対応しています。

- Firebug 拡張。 `https://addons.mozilla.org/ja/firefox/addon/1843`_ からダウンロードできます。

- FirePHP 拡張。 `https://addons.mozilla.org/ja/firefox/addon/6149`_ からダウンロードできます。

.. _zend.db.profiler.profilers.firebug.example.with_front_controller:

.. rubric:: Zend_Controller_Front を使った DB のプロファイリング

.. code-block:: php
   :linenos:

   // 起動ファイル

   $profiler = new Zend_Db_Profiler_Firebug('All DB Queries');
   $profiler->setEnabled(true);

   // プロファイラを db アダプタにアタッチします
   $db->setProfiler($profiler)

   // フロントコントローラをディスパッチします

   // モデル、ビューそしてコントローラファイル内で発行されたすべての
   // DB クエリのプロファイル結果が Firebug に送信されます

.. _zend.db.profiler.profilers.firebug.example.without_front_controller:

.. rubric:: Zend_Controller_Front を使わない DB のプロファイリング

.. code-block:: php
   :linenos:

   $profiler = new Zend_Db_Profiler_Firebug('All DB Queries');
   $profiler->setEnabled(true);

   // プロファイラを DB アダプタにアタッチします
   $db->setProfiler($profiler)

   $request  = new Zend_Controller_Request_Http();
   $response = new Zend_Controller_Response_Http();
   $channel  = Zend_Wildfire_Channel_HttpHeaders::getInstance();
   $channel->setRequest($request);
   $channel->setResponse($response);

   // 出力バッファリングを開始します
   ob_start();

   // DB クエリを発行すると、それがプロファイリングされます

   // データをブラウザに送信します
   $channel->flush();
   $response->sendHeaders();



.. _`Firebug`: http://www.getfirebug.com/
.. _`コンソール`: http://getfirebug.com/logging.html
.. _`https://addons.mozilla.org/ja/firefox/addon/1843`: https://addons.mozilla.org/ja/firefox/addon/1843
.. _`https://addons.mozilla.org/ja/firefox/addon/6149`: https://addons.mozilla.org/ja/firefox/addon/6149
