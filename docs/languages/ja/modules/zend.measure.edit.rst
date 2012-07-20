.. _zend.measure.edit:

計測値の操作
======

入力のパースと正規化、そしてローカライズされた表記での出力により、
さまざまなロケールのユーザがデータにアクセスできるようになります。
``Zend_Measure_*`` コンポーネントには それ以外にもさまざまなメソッドがあり、
正規化されたデータを操作できます。

- :ref:`変換 <zend.measure.edit.convert>`

- :ref:`加減算 <zend.measure.edit.add>`

- :ref:`真偽の比較 <zend.measure.edit.equal>`

- :ref:`大小の比較 <zend.measure.edit.compare>`

- :ref:`値の変更 <zend.measure.edit.changevalue>`

- :ref:`型の変更 <zend.measure.edit.changetype>`

.. _zend.measure.edit.convert:

変換
--

おそらく最も重要な機能は、異なる単位の変換でしょう。 単位の変換は、
``convertTo()`` メソッドを使用していつでも何度でも行えます。
単位の変換は、同じ型の単位間に限られます。したがって、
たとえば長さの単位を重さの単位に変換することなどはできません。
もしそんなことができたらプログラムがめちゃくちゃになってしまい、
エラーだらけになってしまうでしょう。

``convertTo`` メソッドには、オプションのパラメータ '*round*' を指定できます。
これは、出力結果の精度を設定するものです。標準の精度は '*2*' です。

.. _zend.measure.edit.convert.example-1:

.. rubric:: 変換

.. code-block:: php
   :linenos:

   $locale = new Zend_Locale('de');
   $mystring = "1.234.567,89";
   $unit = new Zend_Measure_Weight($mystring,'POND', $locale);

   print "Kilo:".$unit->convertTo('KILOGRAM');

   // 文字列を使うより定数で指定するほうが "よりよい方法" です
   print "Ton:".$unit->convertTo(Zend_Measure_Weight::TON);

   // 出力の精度を定義します
   print "Ton:".$unit->convertTo(Zend_Measure_Weight::TON, 3);

.. _zend.measure.edit.add:

加減算
---

複数の計測値の加算には ``add()``\ 、そして減算には ``sub()`` を使用します。
その結果は、もとのオブジェクトと同じ型を使うでしょう。 Dynamic objects support a fluid
style of programming, where complex sequences of operations can be nested without risk of side-effects altering the
input objects.





      .. _zend.measure.edit.add.example-1:

      .. rubric:: 単位の加算

      .. code-block:: php
         :linenos:

         // オブジェクトを定義します
         $unit = new Zend_Measure_Length(200, Zend_Measure_Length::CENTIMETER);
         $unit2 = new Zend_Measure_Length(1, Zend_Measure_Length::METER);

         // $unit2 を $unit に足します
         $sum = $unit->add($unit2);

         echo $sum; // "300 cm" と出力します



.. note::

   **自動的な変換**

   あるオブジェクトを別のオブジェクトに足す際には、
   適切な単位に自動的に変換されます。異なる単位の値を足す前に :ref:`convertTo()
   <zend.measure.edit.convert>` をコールする必要はありません。





      .. _zend.measure.edit.add.example-2:

      .. rubric:: 減算

      減算も、加算と同じように動作します。

      .. code-block:: php
         :linenos:

         // オブジェクトを定義します
         $unit = new Zend_Measure_Length(200, Zend_Measure_Length::CENTIMETER);
         $unit2 = new Zend_Measure_Length(1, Zend_Measure_Length::METER);

         // $unit2 を $unit から引きます
         $sum = $unit->sub($unit2);

         echo $sum;



.. _zend.measure.edit.equal:

比較
--

計測値を比較することもできますが、自動的な単位変換は行われません。
したがって、 ``equals()`` が ``TRUE``
を返すのは、値と単位の両方が等しい場合のみです。





      .. _zend.measure.edit.equal.example-1:

      .. rubric:: 異なる計測値

      .. code-block:: php
         :linenos:

         // 値を定義します
         $unit = new Zend_Measure_Length(100, Zend_Measure_Length::CENTIMETER);
         $unit2 = new Zend_Measure_Length(1, Zend_Measure_Length::METER);

         if ($unit->equals($unit2)) {
             print "これらは同じです";
         } else {
             print "これらは異なります";
         }





      .. _zend.measure.edit.equal.example-2:

      .. rubric:: 同一の計測値

      .. code-block:: php
         :linenos:

         // 値を定義します
         $unit = new Zend_Measure_Length(100, Zend_Measure_Length::CENTIMETER);
         $unit2 = new Zend_Measure_Length(1, Zend_Measure_Length::METER);

         $unit2->setType(Zend_Measure_Length::CENTIMETER);

         if ($unit->equals($unit2)) {
             print "これらは同じです";
         } else {
             print "これらは異なります";
         }



.. _zend.measure.edit.compare:

比較
--

ある計測値が別の計測値より小さいか大きいかを調べるには ``compare()``
を使用します。これは、 ふたつのオブジェクトの差によって 0、1 あるいは -1
を返します。 ふたつが同一の場合は 0、小さい場合は負の数、
そして大きい場合は正の数を返します。





      .. _zend.measure.edit.compare.example-1:

      .. rubric:: 差

      .. code-block:: php
         :linenos:

         $unit = new Zend_Measure_Length(100, Zend_Measure_Length::CENTIMETER);
         $unit2 = new Zend_Measure_Length(1, Zend_Measure_Length::METER);
         $unit3 = new Zend_Measure_Length(1.2, Zend_Measure_Length::METER);

         print "Equal:".$unit2->compare($unit);
         print "Lesser:".$unit2->compare($unit3);
         print "Greater:".$unit3->compare($unit2);



.. _zend.measure.edit.changevalue:

値の変更
----

値を明示的に変更するには ``setValue()`` を使用します。
これは現在の値を上書きします。パラメータは、コンストラクタと同じです。





      .. _zend.measure.edit.changevalue.example-1:

      .. rubric:: 値の変更

      .. code-block:: php
         :linenos:

         $locale = new Zend_Locale('de_AT');
         $unit = new Zend_Measure_Length(1,Zend_Measure_Length::METER);

         $unit->setValue(1.2);
         echo $unit;

         $unit->setValue(1.2, Zend_Measure_Length::KILOMETER);
         echo $unit;

         $unit->setValue("1.234,56", Zend_Measure_Length::MILLIMETER,$locale);
         echo $unit;



.. _zend.measure.edit.changetype:

型の変更
----

値はそのままで型だけを変更するには ``setType()`` を使用します。

.. _zend.measure.edit.changetype.example-1:

.. rubric:: 型の変更

.. code-block:: php
   :linenos:

   $unit = new Zend_Measure_Length(1,Zend_Measure_Length::METER);
   echo $unit; // "1 m" と出力します

   $unit->setType(Zend_Measure_Length::KILOMETER);
   echo $unit; // "1000 km" と出力します


