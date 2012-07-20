.. _zend.queue.example:

使用例
===

下記の ``Zend_Queue``\ の例で
待ち行列の作成や待ち行列の取得、メッセージ取得、メッセージ削除及びメッセージ送信を含む
様々なフィーチャーを示します。

.. code-block:: php
   :linenos:

   // 構成オプションのために
   // @see Zend_Queue_Adapater::__construct()
   $options = array(
       'name' => 'queue1',
   );

   // 配列待ち行列の作成
   $queue = new Zend_Queue('Array', $options);

   // 待ち行列一覧の取得
   foreach ($queue->getQueues() as $name) {
       echo $name, "\n";
   }

   // 新規待ち行列の作成
   $queue2 = $queue->createQueue('queue2');

   // 待ち行列のメッセージ数の取得 (SPL由来の Countable インターフェイスをサポート)
   echo count($queue);

   // 待ち行列からメッセージを５件取り出す
   $messages = $queue->receive(5);

   foreach ($messages as $i => $message) {
       echo $message->body, "\n";

       //メッセージを処理しました。今待ち行列から除去します。
       $queue->deleteMessage($message);
   }

   // 現在アクティブな待ち行列にメッセージを送信
   $queue->send('My Test Message');

   // 作成した待ち行列と、そのすべてのメッセージを削除
   $queue->deleteQueue('queue2');


