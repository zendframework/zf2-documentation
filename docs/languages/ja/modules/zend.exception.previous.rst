.. _zend.exception.previous:

Previous Exceptions (前の例外)
==========================

Zend Framework 1.10 から、 ``Zend_Exception`` は *PHP* 5.3 がサポートする previous exceptions
(前の例外)を実装しています。単に配置するだけで、 ``catch``
節に、元の例外を参照する新しい例外を投げることができ、デバッグの際の追加コンテキスト
の提供を助けます。 Zend Framework
にてこのサポートを提供することによって、あなたのコードは *PHP* 5.3
と互換性のあるものへと転換するでしょう。

Previous exceptions は例外のコンストラクタへの第 3 引数として示されます。

.. _zend.exception.previous.example:

.. rubric:: Previous exceptions (前の例外)

.. code-block:: php
   :linenos:

   try {
       $db->query($sql);
   } catch (Zend_Db_Statement_Exception $e) {
       if ($e->getPrevious()) {
           echo '[' . get_class($e)
               . '] has the previous exception of ['
               . get_class($e->getPrevious())
               . ']' . PHP_EOL;
       } else {
           echo '[' . get_class($e)
               . '] does not have a previous exception'
               . PHP_EOL;
       }

       echo $e;
       // 可能な場合、最初の例外で始まる例外を全て表示します。
   }


