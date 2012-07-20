.. _zend.queue.adapters:

アダプタ
====

``Zend_Queue``\ は、 インターフェース ``Zend_Queue_Adapter_AdapterInterface``\ を実装する
すべての待ち行列をサポートします。
以下のメッセージ待ち行列サービスがサポートされます:

- `Apache ActiveMQ`_.

- ``Zend_Db``\ を経たデータベースによる待ち行列

- ``Memcache``\ による `MemcacheQ`_\ 待ち行列

- `Zend Platform`_ のジョブキュー。

- 内部配列。ユニットテストに役立ちます。

.. note::

   **限定事項**

   メッセージ・トランザクション処理は、サポートされません。

.. _zend.queue.adapters.configuration:

固有のアダプタ - 設定の構成
---------------

デフォルトの設定が示される場合は、パラメータは任意です。
デフォルトの設定が指定されない場合は、パラメータが必要です。

.. _zend.queue.adapters.configuration.activemq:

Apache ActiveMQ - Zend_Queue_Adapter_Activemq
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

ここでリストされたオプションは、既知の必須条件です。
すべてのメッセージ発信サーバが、
ユーザー名またはパスワードを必要とするというわけではありません。

- **$options['name'] = '/temp/queue1';**

  これは、使い始めたい待ち行列の名前です。（必須）

- **$options['driverOptions']['host'] = 'host.domain.tld';**

  **$options['driverOptions']['host'] = '127.0.0.1';**

  ホストをIPアドレスまたはホスト名にセットするかもしれません。

  ホストのデフォルトの設定は '127.0.0.1' です。

- **$options['driverOptions']['port'] = 61613;**

  ポートのデフォルトの設定は 61613 です。

- **$options['driverOptions']['username'] = 'username';**

  一部のメッセージ発信サーバのために選択できます。
  メッセージ発信サーバのためのマニュアルを読んでください。

- **$options['driverOptions']['password'] = 'password';**

  一部のメッセージ発信サーバのために選択できます。
  メッセージ発信サーバのためのマニュアルを読んでください。

- **$options['driverOptions']['timeout_sec'] = 2;**

  **$options['driverOptions']['timeout_usec'] = 0;**

  これは、 ``Zend_Queue_Adapter_Activemq``\ がメッセージを返さない前に
  ソケットで読み取り活動を待つ時間です。

.. _zend.queue.adapters.configuration.Db:

Db - Zend_Queue_Adapter_Db
^^^^^^^^^^^^^^^^^^^^^^^^^^

ドライバオプションは、多少の必須のオプションのためにチェックされます。
（例えば **type**\ 、 **host**\ 、 **username**\ 、 **password**\ と **dbname**\ ）
``$options['driverOptions']``\ でパラメータとして、 ``Zend_DB::factory()``\
のために付加パラメータに沿って渡すかもしれません。
ここでは一覧に示されていませんが、 渡すことができる付加的なオプションは
**port**\ でしょう。

.. code-block:: php
   :linenos:

   $options = array(
       'driverOptions' => array(
           'host'      => 'db1.domain.tld',
           'username'  => 'my_username',
           'password'  => 'my_password',
           'dbname'    => 'messaging',
           'type'      => 'pdo_mysql',
           'port'      => 3306, // optional parameter.
       ),
       'options' => array(
           // 更新のためにZend_Db_Selectを使います。
           // 全てのデータベースがこのフィーチャをサポートできるわけではありません。
           Zend_Db_Select::FOR_UPDATE => true
       )
   );

   // データベース待ち行列を作成
   $queue = new Zend_Queue('Db', $options);



- **$options['name'] = 'queue1';**

  これは、使い始めたい待ち行列の名前です。（必須）

- **$options['driverOptions']['type'] = 'Pdo';**

  **type**\ は、 ``Zend_Db::factory()``\ を 使ってもらいたいアダプタです。 これは、
  ``Zend_Db::factory()`` クラス・メソッド呼び出しの最初のパラメータです。

- **$options['driverOptions']['host'] = 'host.domain.tld';**

  **$options['driverOptions']['host'] = '127.0.0.1';**

  ホストをIPアドレスまたはホスト名にセットするかもしれません。

  ホストのデフォルトの設定は '127.0.0.1' です。

- **$options['driverOptions']['username'] = 'username';**

- **$options['driverOptions']['password'] = 'password';**

- **$options['driverOptions']['dbname'] = 'dbname';**

  必須のテーブルを作成したデータベース名。 下記の注意部分を見てください。

.. _zend.queue.adapters.configuration.memcacheq:

MemcacheQ - Zend_Queue_Adapter_Memcacheq
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **$options['name'] = 'queue1';**

  これは、使い始めたい待ち行列の名前です。（必須）

- **$options['driverOptions']['host'] = 'host.domain.tld';**

  **$options['driverOptions']['host'] = '127.0.0.1;'**

  ホストをIPアドレスまたはホスト名にセットするかもしれません。

  ホストのデフォルトの設定は '127.0.0.1' です。

- **$options['driverOptions']['port'] = 22201;**

  ポートのデフォルトの設定は 22201 です。

.. _zend.queue.adapters.configuration.platformjq:

Zend Platform ジョブキュー - Zend_Queue_Adapter_PlatformJobQueue
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **$options['daemonOptions']['host'] = '127.0.0.1:10003';**

  利用したい Zend Platform
  ジョブキューデーモンに対応するホスト名とポート。（必須）

- **$options['daemonOptions']['password'] = '1234';**

  Zend Platform ジョブキューデーモンにアクセスするために必要なパスワード。（必須）

.. _zend.queue.adapters.configuration.array:

配列 - Zend_Queue_Adapter_Array
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- **$options['name'] = 'queue1';**

  これは、使い始めたい待ち行列の名前です。（必須）

.. _zend.queue.adapters.notes:

アダプタ固有の注意
---------

下記のアダプタには注意があります:

.. _zend.queue.adapters.notes.activemq:

Apache ActiveMQ
^^^^^^^^^^^^^^^

``Zend_Queue_Adapter_Activemq``\ のための可視性期間は利用できません。

ApacheのActiveMQが複数のサブスクリプションをサポートするのに対して、 ``Zend_Queue``\
はそうしません。 それぞれのサブスクリプションのために 新しい ``Zend_Queue``\
オブジェクトを作成しなければなりません。

ActiveMQの待ち行列または項目の名前は下記のうちの一つで始めなくてはいけません:

- ``/queue/``

- ``/topic/``

- ``/temp-queue/``

- ``/temp-topic/``

例えば: ``/queue/testing``

下記の関数はサポートされません:

- ``create()``- 待ち行列の作成。 この関数を呼ぶと例外を発生します。

- ``delete()``- 待ち行列の削除。 この関数を呼ぶと例外を発生します。

- ``getQueues()``- 待ち行列の一覧。 この関数を呼ぶと例外を発生します。

.. _zend.queue.adapters.notes.zend_db:

Zend_Db
^^^^^^^

データベース **CREATE TABLE ( ... )** *SQL* 文が ``Zend/Queue/Adapter/Db/mysql.sql``\ にあります。

.. _zend.queue.adapters.notes.memcacheQ:

MemcacheQ
^^^^^^^^^

Memcacheは `http://www.danga.com/memcached/`_ からダウンロードできます。

MemcacheQは `http://memcachedb.org/memcacheq/`_ からダウンロードできます。

- ``deleteMessage()``- メッセージは、待ち行列から受信と同時に削除されます。
  この関数を呼んでも効果がありません。 この関数を呼ぶとエラーを発生します。

- ``count()``\ または ``count($adapter)``-
  MemcacheQは、待ち行列で件数を数えるためのメソッドをサポートしません。
  この関数を呼ぶとエラーを発生します。

.. _zend.queue.adapters.notes.platformjq:

Zend Platform ジョブキュー
^^^^^^^^^^^^^^^^^^^^

ジョブキューは、企業ソリューション商品 Zend Platform のフィーチャーです。
それは伝統的なメッセージキューではなく、その代わりに渡したいパラメータと一緒に、
実行するスクリプトを待ち行列に入れることができます。 `zend.co.jpウェブサイト`_
でジョブ・キューについてもっと知ることができます。

以下は、このアダプターの動作が標準的な提供物と相違するメソッドの一覧です:

- ``create()``- Zend Platformには、 個別のキューの概念がありません。
  その代わりに、管理者が実行段階ジョブにスクリプトを与えることができます。
  新しいスクリプトを加えることは管理画面に制限されるので、
  このメソッドは、単にアクションが禁じられていることを示す例外を投げます。

- ``isExists()``-``create()``
  と同様に、ジョブキューには命名されたキューの概念がないので、
  このメソッドは呼び出されると例外を投げます。

- ``delete()``-``create()``
  と同様に、管理画面以外ではジョブキューのスクリプトの削除はできません。
  このメソッドは、例外を発生します。

- ``getQueues()``- Zend Platformは、 *API*
  によってスクリプトを取り扱う、タスク生成されたジョブを参照できません。
  このメソッドは、例外を投げます。

- ``count()``- ジョブキューで現在アクティブなジョブの 数を返します。

- ``send()``- このメソッドは、恐らく最も他のアダプターと
  異なるメソッドの一つです。 ``$message``\ 引数は３種類のどれか１つで、
  渡された値によって異なる動作をします。

  - *string*- 実行するジョブキューに登録されるスクリプト名
    このように渡されると、引数はスクリプトに与えられません。

  - *array*-``ZendApi_Job``\ オブジェクトを
    設定する配列。これらは、以下を含むかもしれません。

    - ``script``- 実行するジョブキュースクリプト名 （必須）

    - ``priority``- キューに名前を登録するときに使う ジョブ優先順位

    - ``name``- ジョブを記述する短い文字列

    - ``predecessor``- これが始まるであろう前に
      実行されなければいけない、これがそれによって左右される ジョブのID

    - ``preserved``- ジョブ・キュー・ヒストリの
      内部でジョブを保持するべきかどうか。デフォルトはoff。 保持するためには、
      ``TRUE`` を渡します。

    - ``user_variables``- ジョブの実行中に、
      （命名された引数と同様に）保持したい変数すべての連想配列

    - ``interval``- ジョブは、しばしば数秒単位で、
      実行しなければならないでしょう。デフォルトは0で、
      一度だけ実行されることを示します。

    - ``end_time``- 期限満了時刻。それを過ぎると
      ジョブは動作しません。もしジョブが一回だけ実行するよう設定
      されているか、または ``end_time``\ を過ぎると、
      ジョブは実行されません。ジョブが一定間隔ごとに実行するように
      設定されている場合、 ``end_time``\ を過ぎると 実行されません。

    - ``schedule_time``- いつジョブを実行させるべきかを 示す *UNIX*\
      タイムスタンプ。デフォルトは0で、
      ジョブはできるだけ早く実行しなければならないことを示します。

    - ``application_id``- ジョブのアプリケーション識別子。 デフォルトは ``NULL``
      で、キューがアプリケーションIDを割り当てられたら、
      アプリケーションIDがキューによって自動的に割り当てられることを 示します。

    前述のように、 ``script``\ 引数のみ必須です。他のすべては、
    どのように、そして、いつジョブを走らせるべきかというような、
    よりきめ細かい詳細を渡すために利用します。

  - ``ZendApi_Job``- 結局、 単に ``ZendApi_Job``\ のインスタンスを渡すかもしれません。
    そして、それはPlatformのジョブキューに一緒に渡されます。

  ``send()``\ は、インスタンスの全てで ``Zend_Queue_Message_PlatformJob``\
  オブジェクトを返します。 そして、ジョブキューと通信するために使う ``ZendApi_Job``
  オブジェクトへのアクセスを提供します。

- ``receive()``- ジョブキューから実行中のジョブのリストを
  取得します。返されたセットの各々のジョブは、 ``Zend_Queue_Message_PlatformJob``\
  のインスタンスです。

- ``deleteMessage()``- このアダプターはジョブキューだけで
  機能するので、このメソッドは、与えられた ``$message``\ が
  ``Zend_Queue_Message_PlatformJob``\ のインスタンスであること を期待します。
  さもなければ例外を発生します。

.. _zend.queue.adapters.notes.array:

配列 (内部)
^^^^^^^

配列待ち行列はローカルメモリ上の *PHP* ``array()``\ です。 ``Zend_Queue_Adapter_Array``\
はユニットテスト用に適しています。



.. _`Apache ActiveMQ`: http://activemq.apache.org/
.. _`MemcacheQ`: http://memcachedb.org/memcacheq/
.. _`Zend Platform`: http://www.zend.co.jp/product/zendplatform.html
.. _`http://www.danga.com/memcached/`: http://www.danga.com/memcached/
.. _`http://memcachedb.org/memcacheq/`: http://memcachedb.org/memcacheq/
.. _`zend.co.jpウェブサイト`: http://www.zend.co.jp/product/zendplatform.html
