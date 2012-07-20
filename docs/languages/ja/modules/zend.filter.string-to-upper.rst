.. _zend.filter.set.stringtoupper:

StringToUpper
=============

このフィルタは、入力を全て大文字に変換します。

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_StringToUpper();

   print $filter->filter('Sample');
   // "SAMPLE" を返します

``StringToLower``\ フィルタの様に、
このフィルタは、サーバの現時点のロケール由来の文字だけを処理します。
``StringToLower``\ と同様に、 異なる文字セットを使っても動作します。

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_StringToUpper(array('encoding' => 'UTF-8'));

   //または後でこのようにします
   $filter->setEncoding('ISO-8859-1');


