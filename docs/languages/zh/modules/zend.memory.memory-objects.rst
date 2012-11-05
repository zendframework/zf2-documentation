.. EN-Revision: none
.. _zend.memory.memory-objects:

内存对象
====

.. _zend.memory.memory-objects.movable:

可移动的
----

使用内存管理器的 *create([$data])*\ 方法创建可移动的内存对象:

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->create($data);




"可移动"意思是这样的对象可以被交换并从内存中卸载,然后当应用程序代码访问该对象时再加载它.

.. _zend.memory.memory-objects.locked:

锁定的
---

使用内存管理器的 *createLocked([$data])*\ 方法创建锁定的内存对象:

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->createLocked($data);




"锁定的"意思是这样的对象绝不会被交换和从内存中卸载.

锁定的对象和可移动的对象提供相同的接口(*Zend\Memory_Container\Interface*).
因此锁定的对象可以用于任何地方代替可移动对象.

基于性能的考虑,应用程序或则开发者能决定一些对象应该决不会被交换是非常有用的.

访问锁定的对象更快,应为内存管理器不需要追踪这些对象的变化.

The locked objects class (*Zend\Memory_Container\Locked*) guarantees virtually the same performance as working with
a string variable. The overhead is a single dereference to get the class property.
锁定的对象类(*Zend\Memory_Container\Locked*)保证了和处理字符串变量差不多的性能.

.. _zend.memory.memory-objects.value:

内存容器 '值' 属性.
------------

使用内存容器(可移动或者锁定)'*值*'属性操作内存对象数据:

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->create($data);

      echo $memObject->value;

      $memObject->value = $newValue;

      $memObject->value[$index] = '_';

      echo ord($memObject->value[$index1]);

      $memObject->value = substr($memObject->value, $start, $length);




访问内存对象数据的一个替代的方法是使用 :ref:`getRef() <zend.memory.memory-objects.api.getRef>`
方法.该方法在 **必须**\ 用于PHP5.2之前的版本.它还不得不用于其他由于性能原因情况

.. _zend.memory.memory-objects.api:

内存容器接口
------

内存容器提供下面的方法:

.. _zend.memory.memory-objects.api.getRef:

getRef() 方法
^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function &getRef();


*getRef()* 方法返回对象值的引用.

如果此时对象不在内存中,可移动对象从缓存中加载.
如果对象从缓存中加载,并且受管理对象的内存使用量总和超过内存限制,将导致交换.

*getRef()* 方法 **必须** 用于访问PHP5.2版本以前的内存对象数据.

追踪数据的变化需要额外的资源. *getRef()*\
返回字符串的引用,它直接由用户应用程序改变. 因此好的办法是使用 *getRef()*\
方法进行值数据处理:

   .. code-block:: php
      :linenos:

      $memObject = $memoryManager->create($data);

      $value = &$memObject->getRef();

      for ($count = 0; $count < strlen($value); $count++) {
          $char = $value[$count];
          ...
      }




.. _zend.memory.memory-objects.api.touch:

touch() 方法
^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function touch();


*touch()* 方法应该和 *getRef()*\ 一起使用.当对象值改变时它会发出信号.

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

lock() 方法
^^^^^^^^^

.. code-block:: php
   :linenos:

   public function lock();


它用于阻止一些你选择的对象被交换.正常情况,这是不需要的,因为内存管理器使用智能的算法决定候选的交换数据.
但是你明确地知道,在代码的这一部分对象不应该被交换,你可以锁定它们.

在内存中锁定的对象还保证了在解锁对象前 *getRef()*\ 方法返回的引用是有效的:

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

unlock() 方法
^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function unlock();


当不再需要锁定是 *unlock()* 方法解锁一个内存对象.查看上面的例子.

.. _zend.memory.memory-objects.api.isLocked:

isLocked() 方法
^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function isLocked();


*isLocked()*\ 方法用于检测是否一个对象被锁定了.如果对象被锁定她返回
*true*,否则如果没有被锁定返回 *false*. 对于"锁定的"对象这总是
*true*,对于"可移动"对象可以使 *true* 或则 *false*.


