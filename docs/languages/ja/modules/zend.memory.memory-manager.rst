.. EN-Revision: none
.. _zend.memory.memory-manager:

メモリマネージャ
========

.. _zend.memory.memory-manager.creation:

メモリマネージャの作成
-----------

新しいメモリマネージャ (``Zend\Memory\Manager`` オブジェクト) を作成するには、
``Zend\Memory\Memory::factory($backendName [, $backendOprions])`` メソッドを使用します。

最初の引数 *$backendName* は文字列で、 ``Zend_Cache``
がサポートするバックエンド実装のいずれかの名前を指定します。

二番目の引数 *$backendOptions* は省略可能で、
バックエンドに渡すオプションの配列を指定します。

.. code-block:: php
   :linenos:

   $backendOptions = array(
       'cache_dir' => './tmp/' // スワップしたメモリブロックを配置するディレクトリ
   );

   $memoryManager = Zend\Memory\Memory::factory('File', $backendOptions);

``Zend_Memory`` は :ref:`Zend_Cache のバックエンド <zend.cache.backends>`
を使用してデータを保存します。

標準の ``Zend_Cache`` のバックエンドに加え、特別な名前 '*None*'
をバックエンド名として使用することもできます。

   .. code-block:: php
      :linenos:

      $memoryManager = Zend\Memory\Memory::factory('None');



バックエンド名に '*None*' を使用すると、
メモリマネージャは決してメモリブロックをスワップしなくなります。
メモリの制限がない場合、あるいはオブジェクトのサイズが
決してメモリの制限に達しない場合などに有用です。

'*None*' バックエンドには何もオプションを指定する必要がありません。

.. _zend.memory.memory-manager.objects-management:

メモリオブジェクトの管理
------------

この節では、管理しているメモリ内でのオブジェクトの作成や破棄の方法、
そしてメモリマネージャの挙動を設定する方法を説明します。

.. _zend.memory.memory-manager.objects-management.movable:

移動可能なオブジェクトの作成
^^^^^^^^^^^^^^

移動可能なオブジェクト (スワップされる可能性のあるオブジェクト)
を作成するには、 ``Zend\Memory\Manager::create([$data])`` メソッドを使用します。

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->create($data);



引数 *$data* は省略可能で、 オブジェクトの値を初期化するために使用します。 引数
*$data* を省略した場合は、値は空の文字列となります。

.. _zend.memory.memory-manager.objects-management.locked:

ロックされたオブジェクトの作成
^^^^^^^^^^^^^^^

ロックされたオブジェクト (スワップされないオブジェクト) を作成するには、
``Zend\Memory\Manager::createLocked([$data])`` メソッドを使用します。

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->createLocked($data);



引数 *$data* は省略可能で、 オブジェクトの値を初期化するために使用します。 引数
*$data* を省略した場合は、値は空の文字列となります。

.. _zend.memory.memory-manager.objects-management.destruction:

オブジェクトの破棄
^^^^^^^^^

メモリオブジェクトは、それがスコープの外に出た際に
自動的に破棄され、メモリから削除されます。

   .. code-block:: php
      :linenos:

      function foo()
      {
          global $memoryManager, $memList;

          ...

          $memObject1 = $memoryManager->create($data1);
          $memObject2 = $memoryManager->create($data2);
          $memObject3 = $memoryManager->create($data3);

          ...

          $memList[] = $memObject3;

          ...

          unset($memObject2); // $memObject2 はここで破棄されます

          ...
          // $memObject1 はここで破棄されますが、
          // $memObject3 オブジェクトはまだ $memList に参照されており、
          // 破棄されていません
      }



これは、移動可能なオブジェクトとロックされたオブジェクトの
どちらにもあてはまります。

.. _zend.memory.memory-manager.settings:

メモリオブジェクトの設定
------------

.. _zend.memory.memory-manager.settings.memory-limit:

メモリの制限
^^^^^^

メモリの制限とは、移動可能なオブジェクトを読み込む際に
使用できるバイト数のことです。

オブジェクトを読み込んだり作成したりすることで この制限をこえてしまう場合は、
メモリマネージャは他のオブジェクトのどれかをスワップします。

メモリの制限を取得あるいは設定するには、 ``getMemoryLimit()`` メソッドおよび
``setMemoryLimit($newLimit)`` メソッドを使用します。

   .. code-block:: php
      :linenos:

      $oldLimit = $memoryManager->getMemoryLimit();  // メモリの制限バイト数を取得します
      $memoryManager->setMemoryLimit($newLimit);     // メモリの制限バイト数を設定します



メモリの制限に負の値を設定すると、'制限なし' を意味します。

デフォルト値は、php.ini の '*memory_limit*' の値の三分の二となります。もし php.ini で
'*memory_limit*' が設定されていない場合は、デフォルト値は '制限なし' (-1)
となります。

.. _zend.memory.memory-manager.settings.min-size:

MinSize
^^^^^^^

MinSize
は、メモリマネージャがスワップの対象とするメモリオブジェクトの最小サイズです。
メモリマネージャは、この値より小さなサイズのオブジェクトはスワップしません。
これにより、スワップや読み込みの回数が莫大なものになることを防ぎます。

最小サイズを取得あるいは設定するには、 ``getMinSize()`` メソッドおよび
``setMinSize($newSize)`` メソッドを使用します。

   .. code-block:: php
      :linenos:

      $oldMinSize = $memoryManager->getMinSize();  // MinSize をバイト数で取得します
      $memoryManager->setMinSize($newSize);        // MinSize をバイト数で設定します



デフォルト値は 16KB (16384 バイト) です。


