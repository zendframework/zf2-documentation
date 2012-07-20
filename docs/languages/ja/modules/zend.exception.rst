.. _zend.exception.using:

例外の使用法
======

``Zend_Exception`` は、 Zend Framework
のクラスがスローするすべての例外の基底クラスとなります。

.. _zend.exception.using.example:

.. rubric:: 例外のキャッチ

次のコードは、Zend Framework
のクラスからスローされた例外をキャッチする方法を示すものです。

.. code-block:: php
   :linenos:

   try {
       // Zend_Loader::loadClass() で、存在しないクラスを指定してコールすると
       // Zend_Loader で例外がスローされます
       Zend_Loader::loadClass('nonexistantclass');
   } catch (Zend_Exception $e) {
       echo "キャッチした例外: " . get_class($e) . "\n";
       echo "メッセージ: " . $e->getMessage() . "\n";
       // その他、エラーから復帰するためのコード
   }

``Zend_Exception`` を使用すると、 Zend Framework のクラスがスローするすべての例外を catch
ブロックで捕捉できるようになります。
個々の例外をすべて個別に捕捉できないような場合に便利です。

Zend Framework の各コンポーネントのドキュメントには、
どのメソッドでどんな場合に例外をスローするのかや、
どのような例外クラスがスローされるのかが記載されています。


