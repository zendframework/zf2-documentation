.. _zend.filter.set.stringtolower:

StringToLower
=============

Tこのフィルタは、入力を全て小文字に変換します。

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_StringToLower();

   print $filter->filter('SAMPLE');
   // "sample" を返します

デフォルトでは、それはサーバの現時点のロケールで、文字を取り扱うだけです。
他のcharset由来の文字は、無視されます。
さらに、mbstring拡張が環境で利用できるとき、
それらを小文字にすることもできます。 ``StringToLower``\
フィルタを初期化するときは、 希望のエンコーディングを設定するだけです。
または、後でエンコーディングを変更するために、 ``setEncoding()``\
メソッドを使います。

.. code-block:: php
   :linenos:

   // UTF-8 を使用
   $filter = new Zend_Filter_StringToLower('UTF-8');

   //または、構成を使うときに、役に立つことがありえる配列を与えます
   $filter = new Zend_Filter_StringToLower(array('encoding' => 'UTF-8'));

   //または後でこのようにします
   $filter->setEncoding('ISO-8859-1');

.. note::

   **間違ったエンコーディングの設定**

   あるエンコーディングを設定したくて、mbstring拡張が環境で利用できないとき、
   例外を得ることに注意してください。

   また、mbstring拡張でサポートされないエンコーディングを設定しようとしているとき、
   例外を得ます。


