.. _zend.filter.set.normalizedtolocalized:

NormalizedToLocalized
=====================

このフィルタはフィルタ ``Zend_Filter_LocalizedToNormalized``\ の逆で、
与えられた正規化された入力をそのローカライズされた表現に変換します。
バックグラウンド ``Zend_Locale``\ でこの変換を行うために使います。

このおかげで、保管された正規化された値をローカルな流儀でユーザーに与えられるようになります。

.. note::

   ローカライズと翻訳とは同一ではないことに注意してください。
   このフィルタでは、月や日の名前で期待するような、
   ある言語から別のものへの文字列の翻訳は行えません。

下記の入力型がローカライズされます。

- **integer**:正規化された整数値。設定した表記方法にローカライズされます。

- **float**: 正規化されたフロート値。設定した表記方法にローカライズされます。

- **numbers**: 実数のようなその他の数値。設定した表記方法にローカライズされます。

- **time**: 時刻値。文字列にローカライズされます。

- **date**: 日付値。文字列に正規化されます。

その他の入力はいずれも変更無しにそのまま返されます。

.. _zend.filter.set.normalizedtolocalized.numbers:

数値のローカライズ
---------

整数、フロートまたは実数のようなあらゆる数がローカライズされます。
指数表記の数値は、実はこのフィルタで扱えないので注意してください。

数値についての詳しいローカライズ方法

.. code-block:: php
   :linenos:

   //フィルタを初期化
   $filter = new Zend_Filter_NormalizedToLocalized();
   $filter->filter(123456.78);
   //値 '123.456,78' を返します。

アプリケーション全体のロケールとしてロケール 'de'
を設定したつもりになりましょう。 ``Zend_Filter_NormalizedToLocalized``\
は設定されたロケールを受け取って、
どの種類の出力をあなたが受け取りたいのか検出するために、それを使います。
われわれの例ではそれは精度を持つ値でした。
そこで、この値を文字列としてローカライズした表現をフィルタは返します。

ローカライズした数がどのようになるべきか、コントロールすることもできます。
このために ``Zend_Locale_Format``\ でも使用されるオプションを 全て与えられます。
最も一般的なのは下記です。

- **date_format**

- **locale**

- **precision**

それらのオプションの利用法について詳しくは、 :ref:`Zend_Locale <zend.locale.parsing>`
をご覧下さい。

下記はオプションの動作方法が分かるように精度を定義した例です。

.. code-block:: php
   :linenos:

   //数値フィルタ
   $filter = new Zend_Filter_NormalizedToLocalized(array('precision' => 2));

   $filter->filter(123456);
   //値 '123.456,00' を返します。

   $filter->filter(123456.78901);
   //値 '123.456,79' を返します。

.. _zend.filter.set.normalizedtolocalized.dates:

日時のローカライズ
---------

日付や時刻の値を正規化したものもまた、ローカライズできます。
与えられた日付および時刻は全て、設定されたロケールで定義された形式で
文字列として返されます。

.. code-block:: php
   :linenos:

   //フィルタを初期化
   $filter = new Zend_Filter_NormalizedToLocalized();
   $filter->filter(array('day' => '12', 'month' => '04', 'year' => '2009');
   // '12.04.2009' を返します。

ふたたびロケール 'de' を設定したつもりになりましょう。
そこで、入力は自動的に日付として検出され、 ロケール 'de'
で定義された形式で返されます。

もちろん、日付の入力値をどのようにするか **date_format**\ や **locale**\ オプションで
コントロールすることもできます。

.. code-block:: php
   :linenos:

   //日付フィルタ
   $filter = new Zend_Filter_LocalizedToNormalized(
       array('date_format' => 'ss:mm:HH')
   );

   $filter->filter(array('hour' => '33', 'minute' => '22', 'second' => '11'));
   // '11:22:33' を返します。


