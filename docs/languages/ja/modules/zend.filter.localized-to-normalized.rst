.. _zend.filter.set.localizedtonormalized:

LocalizedToNormalized
=====================

このフィルタは与えられたローカライズされた入力をその正規化された表現に変換します。
バックグラウンド ``Zend_Locale``\ でこの変換を行うために使います。

このおかげで、ユーザーがユーザー固有の言語表記で情報を入力でき、
さらに例えば正規化された値をデータベースに保存できるようになります。

.. note::

   正規化と翻訳とは同一ではないことに注意してください。
   このフィルタでは、月や日の名前で期待するような、
   ある言語から別のものへの文字列の翻訳は行えません。

下記の入力型が正規化されます。

- **integer**: ローカライズされた整数値。英語表記に正規化されます。

- **float**: ローカライズされたフロート値。英語表記に正規化されます。

- **numbers**: 実数のようなその他の数値。英語表記に正規化されます。

- **time**: 時刻値。連想配列に正規化されます。

- **date**: 日付値。連想配列に正規化されます。

その他の入力はいずれも変更無しにそのまま返されます。

.. note::

   正規化された出力が常に文字列として与えられることに注意するべきです。
   これ以外の場合には、 環境は正規化された出力から、
   環境で設定されたロケールで使われる表記法に 自動的に変換します。

.. _zend.filter.set.localizedtonormalized.numbers:

数値の正規化
------

整数、フロートまたは実数のようなあらゆる数が正規化されます。
指数表記の数値は、実はこのフィルタで扱えないので注意してください。

数値についての詳しい正規化方法

.. code-block:: php
   :linenos:

   //フィルタ初期化
   $filter = new Zend_Filter_LocalizedToNormalized();
   $filter->filter('123.456,78');
   //値 '123456.78' を返します。

アプリケーション全体のロケールとしてロケール 'de'
を設定したつもりになりましょう。 ``Zend_Filter_LocalizedToNormalized``\
は設定されたロケールを受け取って、
どの種類の入力をあなたが与えたか検出するために、それを使います。
われわれの例ではそれは精度を持つ値でした。
そこで、この値を文字列として正規化した表現をフィルタは返します。

正規化した数がどのようになるべきか、コントロールすることもできます。
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
   $filter = new Zend_Filter_LocalizedToNormalized(array('precision' => 2));

   $filter->filter('123.456');
   //値 '123456.00' を返します。

   $filter->filter('123.456,78901');
   //値 '123456.79' を返します。

.. _zend.filter.set.localizedtonormalized.dates:

日時の正規化
------

日付や時刻の値の入力もまた、正規化できます。
与えられた日付および時刻は全て、独自のキーの範囲内で日付の各部分が与えられた
配列として返されます。

.. code-block:: php
   :linenos:

   //フィルタ初期化
   $filter = new Zend_Filter_LocalizedToNormalized();
   $filter->filter('12.April.2009');
   // array('day' => '12', 'month' => '04', 'year' => '2009') を返します。

ふたたびロケール 'de' を設定したつもりになりましょう。
そこで、入力は自動的に日付として検出され、 返り値に連想配列を受け取ります。

もちろん、日付の入力値をどのようにするか **date_format**\ や **locale**\ オプションで
コントロールすることもできます。

.. code-block:: php
   :linenos:

   //日付フィルタ
   $filter = new Zend_Filter_LocalizedToNormalized(
       array('date_format' => 'ss:mm:HH')
   );

   $filter->filter('11:22:33');
   // array('hour' => '33', 'minute' => '22', 'second' => '11') を返します。


