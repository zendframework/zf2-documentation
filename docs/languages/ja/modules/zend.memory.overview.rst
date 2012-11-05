.. EN-Revision: none
.. _zend.memory.overview:

概要
==

.. _zend.memory.introduction:

導入
--

``Zend_Memory`` コンポーネントは、
限られたメモリ環境でデータを管理するためのものです。

メモリマネージャが要求に応じて メモリオブジェクト (メモリコンテナ)
を作成し、必要に応じて透過的にスワップ/読み込みを行います。

たとえば、あるオブジェクトを作成あるいは読み込むことによって
メモリの使用量が制限値を超えてしまう場合に、
管理しているオブジェクトのいくつかをメモリの外部の キャッシュにコピーします。
このようにして、管理しているオブジェクトのメモリ使用量が
制限値を超えないようにします。

メモリマネージャの保存機能は、 :ref:`Zend_Cache バックエンド <zend.cache.backends>`
を使用しています。

.. _zend.memory.introduction.example-1:

.. rubric:: Zend_Memory コンポーネントの使用法

``Zend\Memory\Memory::factory()`` は、
指定したバックエンドオプションでメモリマネージャオブジェクトの
インスタンスを作成します。

.. code-block:: php
   :linenos:

   $backendOptions = array(
       'cache_dir' => './tmp/' // スワップしたメモリブロックを配置するディレクトリ
   );

   $memoryManager = Zend\Memory\Memory::factory('File', $backendOptions);

   $loadedFiles = array();

   for ($count = 0; $count < 10000; $count++) {
       $f = fopen($fileNames[$count], 'rb');
       $data = fread($f, filesize($fileNames[$count]));
       $fclose($f);

       $loadedFiles[] = $memoryManager->create($data);
   }

   echo $loadedFiles[$index1]->value;

   $loadedFiles[$index2]->value = $newValue;

   $loadedFiles[$index3]->value[$charIndex] = '_';

.. _zend.memory.theory-of-operation:

動作原理
----

``Zend_Memory`` コンポーネントは、以下の概念で構成されています。



   - メモリマネージャ

   - メモリコンテナ

   - ロックされたメモリオブジェクト

   - 移動可能なメモリオブジェクト



.. _zend.memory.theory-of-operation.manager:

メモリマネージャ
^^^^^^^^

メモリマネージャは、アプリケーションからの要求に応じて
(ロックされた、あるいは移動可能な) メモリオブジェクトを作成し、
それをメモリコンテナオブジェクトにラッピングしたものを返します。

.. _zend.memory.theory-of-operation.container:

メモリコンテナ
^^^^^^^

メモリコンテナは、文字列型の属性 *value* を (仮想的に、あるいは実際に)
保持します。
この属性には、メモリオブジェクトの作成時に指定された値が含まれます。

この属性 *value* は、オブジェクトのプロパティとして扱うことができます。

.. code-block:: php
   :linenos:

   $memObject = $memoryManager->create($data);

   echo $memObject->value;

   $memObject->value = $newValue;

   $memObject->value[$index] = '_';

   echo ord($memObject->value[$index1]);

   $memObject->value = substr($memObject->value, $start, $length);

.. note::

   5.2 より前のバージョンの *PHP* を使用している場合は、 value
   プロパティに直接アクセスするのではなく :ref:`getRef()
   <zend.memory.memory-objects.api.getRef>` メソッドを使用します。

.. _zend.memory.theory-of-operation.locked:

ロックされたメモリ
^^^^^^^^^

ロックされたメモリオブジェクトは、常にメモリ内に保持されます。
ロックされたメモリに保存されたデータは、
決してキャッシュにスワップされることはありません。

.. _zend.memory.theory-of-operation.movable:

移動可能なメモリ
^^^^^^^^

移動可能なメモリオブジェクトは、 必要に応じて ``Zend_Memory``
がキャッシュにスワップしたり
キャッシュから読み戻したりします。この処理は透過的に行われます。

メモリマネージャは、指定した最小値より小さいサイズのオブジェクトはスワップしません。
これは、パフォーマンスを考慮した判断です。詳細は :ref:`
<zend.memory.memory-manager.settings.min-size>` を参照ください。


