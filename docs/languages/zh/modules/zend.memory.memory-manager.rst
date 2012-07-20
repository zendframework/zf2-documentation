.. _zend.memory.memory-manager:

内存管理器
=====

.. _zend.memory.memory-manager.creation:

创建一个内存管理器
---------

你可以使用 *Zend_Memory::factory($backendName [, $backendOprions])*
方法创建一个新的内存管理器(*Zend_Memory_Manager* 对象).

第一个参数 *$backendName*\ 是一个字符串,他的名字是ZendCache提供的后端实现之一.

第二个参数 *$backendOptions*\ 是一个可选的后端选项参数.

.. code-block::
   :linenos:

   $backendOptions = array(
       'cache_dir' => './tmp/' // Directory where to put the swapped memory blocks
   );

   $memoryManager = Zend_Memory::factory('File', $backendOptions);


Zend_Memory使用 :ref:`Zend_Cache backends <zend.cache.backends>`\ 作为存储提供者.

除了标准的Zend_Cache后端之外,你可以使用特殊名称'*None*'作为后端名称.

   .. code-block::
      :linenos:

      $memoryManager = Zend_Memory::factory('None');




如你是使用'*None*'作为后端名称,内城管理绝不会交换数据块.这在你知道内存没有做限制,
或则对象的总体大小绝不会超过内存限制的情况下非常有用.

'*None*' 后端不需要任何特定的后端选项.

.. _zend.memory.memory-manager.objects-management:

管理内存对象
------

这一节描述了在受管理的内存中创建和销毁对象,和控制内存管理的行为的设置.

.. _zend.memory.memory-manager.objects-management.movable:

创建可移动的对象
^^^^^^^^

使用 *Zend_Memory_Manager::create([$data])* 方法创建可移动的对象 (对象可以被交换):

   .. code-block::
      :linenos:

      $memObject = $memoryManager->create($data);




*$data*\ 是可选的并且用于初始化对象的值.如果 *$data*\ 参数被省略,默认值为空字符串.

.. _zend.memory.memory-manager.objects-management.locked:

创建锁定的对象
^^^^^^^

使用 *Zend_Memory_Manager::createLocked([$data])*\ 方法创建锁定的(对象不能被交换)对象:

   .. code-block::
      :linenos:

      $memObject = $memoryManager->createLocked($data);




*$data*\ 是可选的并且用于初始化对象的值.如果 *$data*\ 参数被省略,默认值为空字符串.

.. _zend.memory.memory-manager.objects-management.destruction:

销毁对象
^^^^

当内存对象超出作用域它们被从内存管理器中自动销毁和删除:

   .. code-block::
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

          unset($memObject2); // $memObject2 is destroyed here

          ...
          // $memObject1 is destroyed here
          // but $memObject3 object is still referenced by $memList and is not destroyed
      }




应用和可移动对象和锁定对象.

.. _zend.memory.memory-manager.settings:

内存管理器设置
-------

.. _zend.memory.memory-manager.settings.memory-limit:

内存限制
^^^^

内存限制是可以被加载的可移动对象使用的一个字节数量.

如果加载和创建导致内存使用量超出了限制,内存管理将交换其他对象.

你可以使用 *getMemoryLimit()* and *setMemoryLimit($newLimit)*\ 方法 检索和设置内存限制:

   .. code-block::
      :linenos:

      $oldLimit = $memoryManager->getMemoryLimit();  // Get memory limit in bytes
      $memoryManager->setMemoryLimit($newLimit);     // Set memory limit in bytes




负值表示'没有限制'.

默认值是在php.ini配置文件中'*memory_limit*'选项的2/3大小,
否则如果'*memory_limit*'没有在php.ini中设置则为'没有限制'(-1)

.. _zend.memory.memory-manager.settings.min-size:

MinSize
^^^^^^^

可以被内存管理器交换的最小对象大小.内存管理器不会交换小于此设置的对象.这是为了减少交换/加载操作的数量.

你可以分别使用 *getMinSize()* 和 *setMinSize($newSize)*\ 方法 检索和设置对象的最小大小:

   .. code-block::
      :linenos:

      $oldMinSize = $memoryManager->getMinSize();  // Get MinSize in bytes
      $memoryManager->setMinSize($newSize);        // Set MinSize limit in bytes




默认的最小大小是16KB(16384字节).


