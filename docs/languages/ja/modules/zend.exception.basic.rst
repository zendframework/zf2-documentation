.. _zend.exception.basic:

基本的な使用法
=======

``Zend_Exception`` はZend Framework でスローされる例外全ての基底クラスです。
このクラスは、 *PHP* の基本的な ``Exception`` クラスを拡張します。

.. _zend.exception.catchall.example:

.. rubric:: Zend Framework の例外全てを捕捉する

.. code-block:: php
   :linenos:

   try {
       // あなたのコード
   } catch (Zend_Exception $e) {
       // 何らかの処理
   }

.. _zend.exception.catchcomponent.example:

.. rubric:: Zend Framework の特定のコンポーネントでスローされた例外を捕捉する

.. code-block:: php
   :linenos:

   try {
       // あなたのコード
   } catch (Zend_Db_Exception $e) {
       // 何らかの処理
   }


