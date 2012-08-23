.. EN-Revision: none
.. _zend.filter.writing_filters:

フィルタの書き方
========

``Zend_Filter`` には、よく使うフィルタ群が付属しています。
しかし、特定の目的のために使用する独自のフィルタを書かなければならないこともよくあるでしょう。
独自のフィルタを作成するには、 ``Zend_Filter_Interface`` を実装します。

``Zend_Filter_Interface`` で定義しているメソッドは ``filter()``
ひとつだけです。これを皆さんのクラスで実装します。
このインターフェイスを実装したクラスは、 ``Zend_Filter::addFilter()``
でフィルタチェインに追加できます。

以下の例で、独自のフィルタを作成する方法を説明します。

.. code-block:: php
   :linenos:

   class MyFilter implements Zend_Filter_Interface
   {
       public function filter($value)
       {
           // $value に対して何らかの変換を行った結果として $valueFiltered を返します

           return $valueFiltered;
       }
   }

このフィルタのインスタンスをフィルタチェインに追加するには、次のようにします。

.. code-block:: php
   :linenos:

   $filterChain = new Zend_Filter();
   $filterChain->addFilter(new MyFilter());


