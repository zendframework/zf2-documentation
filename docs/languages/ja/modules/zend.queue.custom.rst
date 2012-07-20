.. _zend.queue.custom:

Zend_Queueのカスタマイズ
=================

.. _zend.queue.custom.adapter:

独自のアダプタ作成
---------

``Zend_Queue``\ は、 ``Zend_Queue_Adapter_AdapterAbstract``\
を実装するどんなアダプタも扱います。 既存のアダプタ、 または抽象クラス
``Zend_Queue_Adapter_AdapterAbstract``\ のうちの1つを拡張することにより、
独自のアダプタを作成できます。 このアダプタとして ``Zend_Queue_Adapter_Array``\
を検討することが、 最も簡単に概念化できると提案します。

.. code-block:: php
   :linenos:

   class Custom_DbForUpdate extends Zend_Queue_Adapter_Db
   {
       /**
        * @see tests/Zend/Queue/Custom/DbForUpdate.php のコード
        *
        * Custom_DbForUpdate はその行を見つけるために、SELECT ... FOR UPDATE を使います。
        * 既存のコードよりも求められる列をもたらす可能性がよりあります。
        *
        * しかしながら、データベース全てに SELECT ... FOR UPDATE フィーチャがあるとは限りません。
        *
        * 注意: これは後でZend_Queue_Adapter_Dbのオプションに変換されました。
        *
        * このコードは良い例をまだ提供します。
        */
   }

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

   $adapter = new Custom_DbForUpdate($options);
   $queue = new Zend_Queue($adapter, $options);

同様に即座にアダプタを変えることもできます。

.. code-block:: php
   :linenos:

   $adapter = new MyCustom_Adapter($options);
   $queue   = new Zend_Queue($options);
   $queue->setAdapter($adapter);
   echo "Adapter: ", get_class($queue->getAdapter()), "\n";

or

.. code-block:: php
   :linenos:

   $options = array(
       'name'           => 'queue1',
       'namespace'      => 'Custom',
       'driverOptions'  => array(
           'host'       => '127.0.0.1',
           'port'       => '3306',
           'username'   => 'queue',
           'password'   => 'queue',
           'dbname'     => 'queue',
           'type'       => 'pdo_mysql'
       )
   );
   $queue = new Zend_Queue('DbForUpdate', $config); // Custom_DbForUpdate をロード

.. _zend.queue.custom.message:

独自のメッセージクラスを作成
--------------

``Zend_Queue``\ は、独自のメッセージクラスも扱います。
変数はアンダーラインで始めます。 例えば:

.. code-block:: php
   :linenos:

   class Zend_Queue_Message
   {
       protected $_data = array();
   }

既存のメッセージクラスを拡張できます。 ``tests/Zend/Queue/Custom/Message.php``\
でコード例をご覧下さい。

.. _zend.queue.custom-iterator:

独自のメッセージ・イテレータクラスを作成
--------------------

``Zend_Queue``\ は、独自のメッセージ・イテレータ・クラスも扱います。
メッセージ・イテレータ・クラスは、 ``Zend_Queue_Adapter_Abstract::recieve()``\
からメッセージを返すために使われます。 たとえメッセージが１つだけだとしても、
``Zend_Queue_Abstract::receive()``\ は、 ``Zend_Queue_Message_Iterator``\
のようなコンテナ・クラスを常に返さなければなりません。

``tests/Zend/Queue/Custom/Messages.php``\ でファイル名の例をご覧ください。

.. _zend.queue.custom.queue:

独自の待ち行列クラスを作成
-------------

``Zend_Queue``\ は上書きすることも簡単にできます。

``tests/Zend/Queue/Custom/Queue.php``\ でファイル名の例をご覧ください。


