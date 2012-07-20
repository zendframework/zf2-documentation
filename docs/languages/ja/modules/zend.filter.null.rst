.. _zend.filter.set.null:

Null
====

もし指定の基準を満たす場合、 このフィルタは与えられた入力を ``NULL``\
に変更します。 データベースとともに作業するとき、これはしばしば必要です
そして、ブールや他のあらゆるタイプの代わりに ``NULL``\ 値を持つことを望みます。

.. _zend.filter.set.null.default:

Zend_Filter_Null の既定の振る舞い
-------------------------

デフォルトではこのフィルタは *PHP*\ の ``empty()``\ メソッドのように動作します。
言い換えると、もし ``empty()``\ がブールの ``TRUE`` を返す場合、 ``NULL``\
値が返されます。

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_Null();
   $value  = '';
   $result = $filter->filter($value);
   // 空文字列の代わりに null を返します

これは、何の設定もなしに、 ``Zend_Filter_Null``\ は全ての入力を受け付けて、 ``empty()``\
と同じ場合に ``NULL``\ を返すことを意味します。

他の値ではいずれも変更無しにそのまま返されます。

.. _zend.filter.set.null.types:

Zend_Filter_Null の振る舞いの変更
-------------------------

しばしば、 ``empty()``\ に基づくフィルタでは十分ではありません。 そのため、
``Zend_Filter_Null``\ では、 いずれのタイプが変換されるか否か設定できます。

下記のタイプが操作できます。

- **boolean**: ブールの **FALSE** 値を ``NULL`` に変換します。

- **integer**: 整数値の **0** を ``NULL``.に変換します。

- **empty_array**: 空の **array** を ``NULL``.に変換します。

- **string**: 空文字列 **''** を ``NULL``.に変換します。

- **zero**: 単一の文字、ゼロ (**'0'**) を含む文字列を ``NULL``.に変換します。

- **all**: 上記のタイプ全てを ``NULL``.に変換します。 （これが既定の振る舞いです）

上記のタイプのうちのいずれをフィルタするかを選択する方法が、いくつかあります。
１つまたは複数のタイプを与えて、それに追加できます。
配列を与えたり、定数を使えます。 または、原文の文字列を与えられます。
下記の例をご覧ください。

.. code-block:: php
   :linenos:

   // false を null に変換
   $filter = new Zend_Filter_Null(Zend_Filter_Null::BOOLEAN);

   // false 及び 0 を null に変換
   $filter = new Zend_Filter_Null(
       Zend_Filter_Null::BOOLEAN + Zend_Filter_Null::INTEGER
   );

   // false 及び 0 を null に変換
   $filter = new Zend_Filter_Null( array(
       Zend_Filter_Null::BOOLEAN,
       Zend_Filter_Null::INTEGER
   ));

   // false 及び 0 を null に変換
   $filter = new Zend_Filter_Null(array(
       'boolean',
       'integer',
   ));

希望のタイプをセットするために、 ``Zend_Config``
のインスタンスを与えることもできます。 タイプをセットするには、後で ``setType()``
を使います。


