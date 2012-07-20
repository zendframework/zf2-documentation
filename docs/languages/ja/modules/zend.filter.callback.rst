.. _zend.filter.set.callback:

Callback
========

このフィルタにより、 ``Zend_Filter`` とともに自分自身のメソッドを使えます。
機能を果たすメソッドすでにあるとき、新しいフィルタを生成する必要はありません。

文字列を逆にするフィルタを生成したいとしましょう。

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Callback('strrev');

   print $filter->filter('Hello!');
   // "!olleH"を返します

おわかりのように、自分自身のフィルタを定義するために本当に簡単にコールバックを使えます。
メソッド（それはクラス内で定義されます）をコールバックとして配列を与えることによって使うこともできます。

.. code-block:: php
   :linenos:

   // クラスの定義
   class MyClass
   {
       public function Reverse($param);
   }

   // フィルター定義
   $filter = new Zend_Filter_Callback(array('MyClass', 'Reverse'));
   print $filter->filter('Hello!');

実際に設定されているコールバックを取得するには ``getCallback()`` を使い、
他のコールバックを設定するには ``setCallback()`` を使います。

フィルタが実行されるとき、
呼ばれるメソッドに配列として与えられるデフォルト・パラメータを定義できます。
この配列は、フィルターされた値で結合されます。

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Callback(
       array(
           'callback' => 'MyMethod',
           'options'  => array('key' => 'param1', 'key2' => 'param2')
       )
   );
   $filter->filter(array('value' => 'Hello'));

手動で上記のメソッド定義を呼ぶと、それはこのように見えます:

.. code-block:: php
   :linenos:

   $value = MyMethod('Hello', 'param1', 'param2');

.. note::

   呼ばれることができないコールバック・メソッドを定義すると、
   例外が発生する点に注意しなければなりません。


