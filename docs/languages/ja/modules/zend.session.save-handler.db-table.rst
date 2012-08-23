.. EN-Revision: none
.. _zend.session.savehandler.dbtable:

Zend_Session_SaveHandler_DbTable
================================

``Zend_Session_SaveHandler_DbTable`` の基本セットアップには、少なくとも
設定配列/``Zend_Config`` オブジェクトの各設定を意味する 4 つのカラムが必要です。
primary は主キーで、デフォルトは単なるセッション ID となります。 デフォルトでは 32
桁の文字列です。 modified は、最終更新日付を表す Unix タイムスタンプです。 lifetime
は、セッションの有効期間です (``modified + lifetime > time()``)。 そして data
が、セッションに保存されているデータをシリアライズしたものです。

.. _zend.session.savehandler.dbtable.basic:

.. rubric:: 基本的な設定

.. code-block:: sql
   :linenos:

   CREATE TABLE `session` (
     `id` char(32),
     `modified` int,
     `lifetime` int,
     `data` text,
     PRIMARY KEY (`id`)
   );

.. code-block:: php
   :linenos:

   // データベース接続を準備します
   $db = Zend_Db::factory('Pdo_Mysql', array(
       'host'        =>'example.com',
       'username'    => 'dbuser',
       'password'    => '******',
       'dbname'    => 'dbname'
   ));

   // Zend_Db_Table のデフォルトアダプタを設定するか、DB 接続オブジェクトを
   // 保存ハンドラの $config に直接私増す
   Zend_Db_Table_Abstract::setDefaultAdapter($db);
   $config = array(
       'name'           => 'session',
       'primary'        => 'id',
       'modifiedColumn' => 'modified',
       'dataColumn'     => 'data',
       'lifetimeColumn' => 'lifetime'
   );

   // Zend_Session_SaveHandler_DbTable を作成し、それを
   // Zend_Session の保存ハンドラとして設定します
   Zend_Session::setSaveHandler(new Zend_Session_SaveHandler_DbTable($config));

   // セッション開始!
   Zend_Session::start();

   // これで、ふつうに Zend_Session を使えるようになります

``Zend_Session_SaveHandler_DbTable`` で、 複数カラムの主キーを使用することもできます。

.. _zend.session.savehandler.dbtable.multi-column-key:

.. rubric:: 複数カラムの主キーの使用

.. code-block:: sql
   :linenos:

   CREATE TABLE `session` (
       `session_id` char(32) NOT NULL,
       `save_path` varchar(32) NOT NULL,
       `name` varchar(32) NOT NULL DEFAULT '',
       `modified` int,
       `lifetime` int,
       `session_data` text,
       PRIMARY KEY (`Session_ID`, `save_path`, `name`)
   );

.. code-block:: php
   :linenos:

   // 先ほど同様にまず DB 接続を設定します
   // 注意: この設定は Zend_Db_Table にも渡されることに注意しましょう
   // テーブル固有の内容についてもここで設定できます
   $config = array(
       'name'              => 'session', // Zend_Db_Table のテーブル名
       'primary'           => array(
           'session_id',   // PHP のセッション ID
           'save_path',    // session.save_path
           'name',         // セッション名
       ),
       'primaryAssignment' => array(
           // 保存ハンドラに、どのカラムが主キーとなるのかを
           // 教えなければなりません。その順番が重要です。
           'sessionId', // 主キーの最初のカラムはセッション ID
           'sessionSavePath', // 主キーの 2 番目のカラムは保存パス
           'sessionName', // 主キーの 3 番目のカラムはセッション名
       ),
       'modifiedColumn'    => 'modified',     // セッションの有効期間
       'dataColumn'        => 'session_data', // シリアライズしたデータ
       'lifetimeColumn'    => 'lifetime',     // 指定したレコードの生存期間
   );

   // Zend_Session に、この保存ハンドラを使うように通知します
   Zend_Session::setSaveHandler(new Zend_Session_SaveHandler_DbTable($config));

   // セッションを開始します
   Zend_Session::start();

   // ふつうに Zend_Session を使用します


