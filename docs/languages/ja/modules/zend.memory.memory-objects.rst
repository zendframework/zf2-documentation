.. EN-Revision: none
.. _zend.memory.memory-objects:

メモリオブジェクト
=========

.. _zend.memory.memory-objects.movable:

移動可能なオブジェクト
-----------

移動可能なメモリオブジェクトを作成するには、メモリマネージャの ``create([$data])``
メソッドを使用します。

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->create($data);



"移動可能" とは、このオブジェクトがスワップされ、
メモリから削除される可能性があるということです。
アプリケーションがこのオブジェクトにアクセスする際に、
再度メモリに読み込まれます。

.. _zend.memory.memory-objects.locked:

ロックされたオブジェクト
------------

ロックされたメモリオブジェクトを作成するには、メモリマネージャの
``createLocked([$data])`` メソッドを使用します。

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->createLocked($data);



"ロックされた" とは、このオブジェクトは決してスワップされず、
メモリから削除されないということです。

ロックされたオブジェクトは、移動可能なオブジェクトと同じインターフェイス
(``Zend\Memory_Container\Interface``) を提供します。
したがって、ロックされたオブジェクトは
どんな場面でも、移動可能なオブジェクトのかわりに使用できます。

パフォーマンスを考慮し、一部のオブジェクトは
スワップさせないようにしたいなどといった場合に、これは有用です。

ロックされたオブジェクトへのアクセスはより高速になります。
というのも、メモリマネージャがそのオブジェクトの変更内容を追いかける必要がないからです。

ロックされたオブジェクトのクラス (``Zend\Memory_Container\Locked``)
は、通常の文字列変数と事実上同程度のパフォーマンスを保証します。
オーバーヘッドとなるのは、クラスのプロパティを取得する際の参照の解決のみです。

.. _zend.memory.memory-objects.value:

メモリコンテナの 'value' プロパティ
----------------------

(移動可能な、あるいはロックされた) メモリコンテナの '*value*'
プロパティを使用して、メモリオブジェクトのデータを扱います。

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->create($data);

      echo $memObject->value;

      $memObject->value = $newValue;

      $memObject->value[$index] = '_';

      echo ord($memObject->value[$index1]);

      $memObject->value = substr($memObject->value, $start, $length);



メモリオブジェクトのデータにアクセスするもうひとつの方法として、 :ref:`getRef()
<zend.memory.memory-objects.api.getRef>` メソッドを使うものがあります。 *PHP* のバージョンが
5.2 より古い場合は、 **必ず** このメソッドを使用しなければなりません。
パフォーマンスの問題から、その他の場合にもこれを使わなければならないことがあるかもしれません。

.. _zend.memory.memory-objects.api:

メモリコンテナのインターフェイス
----------------

メモリコンテナは、以下のメソッドを提供します。

.. _zend.memory.memory-objects.api.getRef:

getRef() メソッド
^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function &getRef();

``getRef()`` メソッドは、オブジェクトの値への参照を返します。

移動可能なオブジェクトは、もしメモリ内になければ
この時点でキャッシュから読み込まれます。
オブジェクトをキャッシュから読み込んだ場合に、
メモリ内で管理しているオブジェクトのサイズが制限に達すると、
他のオブジェクトのスワップが発生します。

*PHP* のバージョンが 5.2
より古い場合、メモリオブジェクトのデータにアクセスするには **必ず** ``getRef()``
メソッドを使用する必要があります。

データの変更内容を追いかけるには、余分なリソースが必要となります。 ``getRef()``
メソッドは文字列への参照を返し、
これはアプリケーションから直接変更することになります。
つまり、データの内容を処理する際には ``getRef()``
メソッドを使用するのがうまいやり方となります。

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->create($data);

      $value = &$memObject->getRef();

      for ($count = 0; $count < strlen($value); $count++) {
          $char = $value[$count];
          ...
      }



.. _zend.memory.memory-objects.api.touch:

touch() メソッド
^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function touch();

``touch()`` メソッドは ``getRef()`` と同じように使用しなければなりません。
これは、オブジェクトの値が変更されたことを通知します。

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->create($data);
      ...

      $value = &$memObject->getRef();

      for ($count = 0; $count < strlen($value); $count++) {
          ...
          if ($condition) {
              $value[$count] = $char;
          }
          ...
      }

      $memObject->touch();



.. _zend.memory.memory-objects.api.lock:

lock() メソッド
^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function lock();

``lock()`` メソッドは、オブジェクトをメモリ内にロックします。
これを使用して、スワップしたくないオブジェクトを選択します。
通常はこれは不要です。なぜなら、メモリマネージャが
うまい具合にスワップする候補を選ぶようにできているからです。
しかし、どうしてもスワップしてはならないオブジェクトがあることがわかっている場合は、
それをロックするとよいでしょう。

オブジェクトをメモリ内にロックすることで、ロックを解除するまでは ``getRef()``
メソッドの返す参照が有効であることが保証されます。

   .. code-block:: php
      :linenos:

      $memObject1 = $memoryManager->create($data1);
      $memObject2 = $memoryManager->create($data2);
      ...

      $memObject1->lock();
      $memObject2->lock();

      $value1 = &$memObject1->getRef();
      $value2 = &$memObject2->getRef();

      for ($count = 0; $count < strlen($value2); $count++) {
          $value1 .= $value2[$count];
      }

      $memObject1->touch();
      $memObject1->unlock();
      $memObject2->unlock();



.. _zend.memory.memory-objects.api.unlock:

unlock() メソッド
^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function unlock();

``unlock()`` メソッドは、 ロックが不要となったオブジェクトのロックを解除します。
上の例を参照ください。

.. _zend.memory.memory-objects.api.isLocked:

isLocked() メソッド
^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function isLocked();

``isLocked()`` メソッドを使用して、
オブジェクトがロックされているかどうかを調べます。
オブジェクトがロックされている場合は ``TRUE``\ 、 ロックされていない場合は ``FALSE``
を返します。 "ロックされている" オブジェクトについては、これは常に ``TRUE``
を返します。また "移動可能な" オブジェクトの場合は ``TRUE`` あるいは ``FALSE``
のいずれかを返します。


