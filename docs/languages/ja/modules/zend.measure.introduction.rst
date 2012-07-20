.. _zend.measure.introduction:

導入
==

``Zend_Measure_*`` クラスは、 さまざまな計測を行うためのパッケージです。
汎用的で非常に簡単な方法を提供しています。 ``Zend_Measure_*`` クラスを使用すると、
計測値の単位変換ができるようになります。
異なる単位どうしでの足し算や引き算、そして比較も可能です。
ユーザが自国語で入力した内容から、単位を自動的に抽出します。
多くの計測単位をサポートしています。

.. _zend.measure.introduction.example-1:

.. rubric:: 計測値の変換

以下の簡単な例で、計測値の型の自動変換の様子を説明します。
計測値を変換するには、その値と型を知っている必要があります。
値としては、整数や浮動小数点数だけでなく数値文字列も使用できます。
変換は、同じ型 (重さ、面積、温度、速度など) の単位間でのみ行うことができます。
型が違う場合は変換できません。

.. code-block:: php
   :linenos:

   $locale = new Zend_Locale('en');
   $unit = new Zend_Measure_Length(100, Zend_Measure_Length::METER, $locale);

   // メートルをヤードに変換します
   echo $unit->convertTo(Zend_Measure_Length::YARD);

``Zend_Measure_*`` は、さまざまな計測単位をサポートしています。
これらの単位は、すべて統一された記法で表され、 ``Zend_Measure_<TYPE>::NAME_OF_UNIT``
のようになります。ここで <TYPE>
はその単位の物理的あるいは数値的な特性を表します。
すべての計測単位は、変換用の係数と表示単位を含んでいます。 詳細は
:ref:`計測値の型 <zend.measure.types>` を参照ください。

.. _zend.measure.introduction.example-2:

.. rubric:: メートルの計測

*メートル* は長さの単位です。したがって、対応する定数は *Length*
クラス内にあります。この単位を使用するには、 ``Length::METER``
という記法を使用する必要があります。 表示単位は *m* です。

.. code-block:: php
   :linenos:

   echo Zend_Measure_Length::STANDARD;  // 出力は 'Length::METER' となります
   echo Zend_Measure_Length::KILOMETER; // 出力は 'Length::KILOMETER' となります

   $unit = new Zend_Measure_Length(100,'METER');
   echo $unit;
   // 出力は '100 m' となります


