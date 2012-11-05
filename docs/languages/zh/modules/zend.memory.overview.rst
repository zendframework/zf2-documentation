.. EN-Revision: none
.. _zend.memory.overview:

概述
==

.. _zend.memory.introduction:

简介
--

Zend_Memory组件用于在一个受限制的内存环境下管理数据.

内存对象(内存容器)是由内存管理器按照请求生成并在需要的时候透明地交换/加载的.

例如,如果由于受管理对象的创建或加载导致内存使用量超过你所指定的限制,一些管理对象将被复制到内存以外的缓存存储中.
用这种方法,受管理对象的总内存使用量不会超过强制的限制.

内存管理器使用 :ref:`Zend_Cache backends <zend.cache.backends>`\ 作为存储提供者

.. _zend.memory.introduction.example-1:

.. rubric:: 使用 Zend_Memory 组件

*Zend\Memory\Memory::factory()* 用指定的后端选项实例化内存管理器对象.

.. code-block:: php
   :linenos:

   require_once 'Zend/Memory.php';

   $backendOptions = array(
       'cache_dir' => './tmp/' // Directory where to put the swapped memory blocks
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

操作原理
----

Zend_Memory 组件操作有如下的概念:

   - 内存管理器

   - 内存容器

   - 锁定的内存对象

   - 可移动的内存对象



.. _zend.memory.theory-of-operation.manager:

内存管理器
^^^^^

内存管理器按照用户应用程序的请求生成内存对象(锁定的或可移动的)并返回已交换到内存容器对象中的那些.

.. _zend.memory.theory-of-operation.container:

内存容器
^^^^

内存容器有一个虚拟的或者实际的字符串类型的 *值*.
这个属性包含了在内存对象创建时指定的数据值.

你可以作为对象属性操作这个 *值*\ 属性:

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->create($data);

      echo $memObject->value;

      $memObject->value = $newValue;

      $memObject->value[$index] = '_';

      echo ord($memObject->value[$index1]);

      $memObject->value = substr($memObject->value, $start, $length);




.. note::

   如果你使用的PHP版本小于5.2,使用 :ref:`getRef() <zend.memory.memory-objects.api.getRef>`
   方法而不是直接访问属性值.

.. _zend.memory.theory-of-operation.locked:

锁定的内存
^^^^^

锁定的内存对象总是存储在内存中.存储在锁定内存对象中的数据绝不会被交换到缓存后端中去.

.. _zend.memory.theory-of-operation.movable:

可移动内存
^^^^^

当需要时,可移动内存对象由Zend_Memory透明的交换到缓存后端或则从缓存后端加载.

由于性能的考虑,内存管理器不会交换小于指定大小的内存对象.细节请查看 :ref:`
<zend.memory.memory-manager.settings.min-size>`


