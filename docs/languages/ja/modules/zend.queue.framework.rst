.. _zend.queue.framework:

フレームワーク
=======

``Zend_Queue``\ は、 待ち行列サービスの詳細を隠す代理です。 待ち行列サービスは、
``Zend_Queue_Adapter_<service>``\ によって表現されます。 たとえば、 ``Zend_Queue_Adapter_Db``\
は、
メッセージを格納・読み出しするためにデータベーステーブルを使う待ち行列です。

下記は、待ち行列システムのためにデータベーステーブルを利用する例です:

.. code-block:: php
   :linenos:

   $options = array(
       'name'          => 'queue1',
       'driverOptions' => array(
           'host'      => '127.0.0.1',
           'port'      => '3306',
           'username'  => 'queue',
           'password'  => 'queue',
           'dbname'    => 'queue',
           'type'      => 'pdo_mysql'
       )
   );

   // データベース待ち行列を作成します。
   // Zend_Queue はクラス名として Zend_Queue_Adapter_ の後に 'Db' を付加します。
   $queue = new Zend_Queue('Db', $options);

``Zend_Queue``\ コンストラクタは ``Zend_Queue_Adapter_Db``\ を作成して、
構成設定値でアダプタを初期化します。

各々のアダプタに認められた構成設定値は、 :ref:`アダプタの注意 <zend.queue.adapters>`\
で示されます

``Zend_Queue``\ は クラス ``Zend_Queue_Message_Iterator``\ を用いてメッセージを返します。
そして、それは *SPL* ``Iterator``\ 及び ``Countable``\ の実装です。 ``Zend_Queue_Message_Iterator``\
は、 ``Zend_Queue_Message``\ オブジェクトの配列を含みます。

.. code-block:: php
   :linenos:

   $messages = $queue->receive(5);
   foreach ($messages as $i => $message) {
       echo "$i) Message => ", $message->body, "\n";
   }

投げられるどんな例外も、クラス ``Zend_Queue_Exception``\ です。

.. _zend.queue.framework.basics:

導入
--

``Zend_Queue``\ は、 アダプタを表現する代理クラスです。

``send()``\ や ``count($queue)``\ 、そして ``receive()``\ メソッドは、
待ち行列と相互に作用するために、それぞれのアダプタによって使用されます。

``createQueue()``\ 及び ``deleteQueue()``\ メソッドは待ち行列を管理するために使われます。

.. _zend.queue.framework.support:

アダプタの間の互換性
----------

``Zend_Queue``\ によってサポートされる待ち行列サービスは、
同じ関数をサポートするとは限りません。 例えば、 ``Zend_Queue_Adapter_Array``\ 及び
``Zend_Queue_Adapter_Db``\ は全ての関数をサポートしますが、 一方、
``Zend_Queue_Adapter_Activemq``\ は
待ち行列の一覧や削除、そしてメッセージのカウントをサポートしません。

``Zend_Queue::isSupported()``\ または ``Zend_Queue::getCapabilities()``\ を使って
どんな関数がサポートされるか判定できます。

- **createQueue()**- 待ち行列を作成

- **deleteQueue()**- 待ち行列を削除

- **send()**- メッセージを送信

  ``send()``\ はアダプタ全てで利用可能なわけではありません; ``Zend_Queue_Adapter_Null``\ は
  ``send()``\ をサポートしません。

- **receive()**- メッセージを受信

  ``receive()``\ はアダプタ全てで利用可能なわけではありません; ``Zend_Queue_Adapter_Null``\
  は ``receive()``\ をサポートしません。

- **deleteMessage()**- メッセージを削除

- **count()**- 待ち行列内のメッセージ数をカウント

- **isExists()**- 待ち行列が存在するかチェック

``receive()``\ メソッドは、
待ち行列と相互に作用するために、それぞれのアダプタによって使用されます。

``createQueue()``\ 及び ``deleteQueue()``\ メソッドは待ち行列を管理するために使われます。


