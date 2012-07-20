.. _zend.measure.creation:

計測値の作成
======

計測値を表すオブジェクトを作成する際には、 ``Zend_Measure_*``
のメソッドの最初のパラメータに 入力値あるいは元の値を指定します。これは、
:ref:`数値の引数 <zend.measure.creation.number>` あるいは単位を含まない :ref:`文字列
<zend.measure.creation.string>`\ 、 あるいは単位を指定した :ref:`各国固有の文字列
<zend.measure.creation.localized>` のいずれかとなります。
二番目の引数には、計測値の型を指定します。どちらのパラメータも必須です。
言語は、任意で三番目のパラメータとして指定します。

.. _zend.measure.creation.number:

整数および浮動小数点数からの計測値の作成
--------------------

整数に加えて、浮動小数点数を使用することもできます。しかし、 `"0.1 や 0.7
のようなシンプルな小数であっても、
それを内部的な二進数表現に変換する際には、どうしても多少精度が落ちてしまいます。"`_
そのため、予期せぬ結果を引き起こすことがあります。 また、ふたつの
"浮動小数点数" が等しいかどうかを調べないようにしましょう。

.. _zend.measure.creation.number.example-1:

.. rubric:: 整数および浮動小数点数を使用しての作成

.. code-block:: php
   :linenos:

   $measurement = 1234.7;
   $unit = new Zend_Measure_Length((integer)$measurement,
                                   Zend_Measure_Length::STANDARD);
   echo $unit;
   // 出力は '1234 m' (メートル) となります

   $unit = new Zend_Measure_Length($measurement, Zend_Measure_Length::STANDARD);
   echo $unit;
   // 出力は '1234.7 m' (メートル) となります

.. _zend.measure.creation.string:

文字列からの計測値の作成
------------

Zend Framework アプリケーションが入力として受け取って ``Zend_Measure_*``
クラスに渡す値の多くは、文字列としてしか渡せません。 たとえば `ローマ数字`_
の値は、 *PHP* の整数型・浮動小数点型の制限を越える値などがこれにあたります。
整数値は文字列として表すことも可能です。 *PHP*
の数値処理用関数の制限によって値の精度が損なわれる可能性がある場合は、
代わりに文字列を使用するようにしましょう。 ``Zend_Measure_Number`` は、BCMath
拡張モジュールを使用して
任意の精度をサポートしています。以下の例に示すとおり、 `bin2dec()`_
のような多くの *PHP* 関数の制限を避けるようになっています。

.. _zend.measure.creation.string.example-1:

.. rubric:: 文字列を使用しての作成

.. code-block:: php
   :linenos:

   $mystring = "10010100111010111010100001011011101010001";
   $unit = new Zend_Measure_Number($mystring, Zend_Measure_Number::BINARY);

   echo $unit;

.. _zend.measure.creation.localized:

ローカライズされた文字列をもとにした計測値
---------------------

各国固有の記法で文字列を入力した場合は、
正しいロケールを知らない限りそれを正確に解釈できません。 小数点に "."
を用い、三桁ごとの桁区切り文字に ","
を用いるのは英語では一般的です。しかし、その他の言語でもそうだとは限りません。
例えば、英語の "1,234.50" は、ドイツ語では "1.2345" という意味になります。
このような問題に対処するために、ロケールを考慮した ``Zend_Measure_*``
系のクラスが用意されています。
これは、言語や地域を指定することによって入力内容の曖昧さをなくし、
意図した値として適切に解釈されるようにします。

.. _zend.measure.creation.localized.example-1:

.. rubric:: ローカライズされた文字列

.. code-block:: php
   :linenos:

   $locale = new Zend_Locale('de');
   $mystring = "1,234.50";
   $unit = new Zend_Measure_Length($mystring,
                                   Zend_Measure_Length::STANDARD,
                                   $locale);
   echo $unit; // 出力は "1.234 m" となります

   $mystring = "1,234.50";
   $unit = new Zend_Measure_Length($mystring,
                                   Zend_Measure_Length::STANDARD,
                                   'en_US');
   echo $unit; // 出力は "1234.50 m" となります

Zend Framework 1.7.0 以降では、 ``Zend_Measure``
はアプリケーション単位でのロケールの使用にも対応します。 そのためには、
``Zend_Locale`` のインスタンスを以下のようにレジストリに登録します。
このようにすれば、同じロケールを何度も使用したいときに
各インスタンスで毎回ロケールを設定する手間を省けます。

.. code-block:: php
   :linenos:

   // 起動ファイルで
   $locale = new Zend_Locale('de_AT');
   Zend_Registry::set('Zend_Locale', $locale);

   // アプリケーションのどこかで
   $length = new Zend_Measure_Length(Zend_Measure_Length::METER();



.. _`"0.1 や 0.7 のようなシンプルな小数であっても、 それを内部的な二進数表現に変換する際には、どうしても多少精度が落ちてしまいます。"`: http://www.php.net/float
.. _`ローマ数字`: http://en.wikipedia.org/wiki/Roman_numerals
.. _`bin2dec()`: http://php.net/bin2dec
