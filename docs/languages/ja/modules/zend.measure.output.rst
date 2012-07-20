.. _zend.measure.output:

計測値の出力
======

計測値は、さまざまな方法で出力できます。

:ref:`自動的な出力 <zend.measure.output.auto>`

:ref:`値の出力 <zend.measure.output.value>`

:ref:`単位つきの出力 <zend.measure.output.unit>`

:ref:`ローカライズされた文字列での出力 <zend.measure.output.unit>`

.. _zend.measure.output.auto:

自動的な出力
------

``Zend_Measure`` は、文字列の自動的な出力をサポートしています。



      .. _zend.measure.output.auto.example-1:

      .. rubric:: 自動的な出力

      .. code-block:: php
         :linenos:

         $locale = new Zend_Locale('de');
         $mystring = "1.234.567,89";
         $unit = new Zend_Measure_Length($mystring,
                                         Zend_Measure_Length::STANDARD,
                                         $locale);

         echo $unit;



.. note::

   **計測値の出力**

   出力を行うには、単に `echo`_ あるいは `print`_ を使用するだけです。

.. _zend.measure.output.value:

値の出力
----

計測値の値だけを出力するには ``getValue()`` を使用します。



      .. _zend.measure.output.value.example-1:

      .. rubric:: 値の出力

      .. code-block:: php
         :linenos:

         $locale = new Zend_Locale('de');
         $mystring = "1.234.567,89";
         $unit = new Zend_Measure_Length($mystring,
                                         Zend_Measure_Length::STANDARD,
                                         $locale);

         echo $unit->getValue();



``getValue()`` メソッドには、オプションのパラメータ '*round*' を指定できます。
これは、出力結果の精度を設定するものです。標準の精度は '*2*' です。

.. _zend.measure.output.unit:

単位つきの出力
-------

関数 ``getType()`` は、現在の単位を返します。



      .. _zend.measure.output.unit.example-1:

      .. rubric:: 単位の出力

      .. code-block:: php
         :linenos:

         $locale = new Zend_Locale('de');
         $mystring = "1.234.567,89";
         $unit = new Zend_Measure_Weight($mystring,
                                         Zend_Measure_Weight::POUND,
                                         $locale);

         echo $unit->getType();



.. _zend.measure.output.localized:

ローカライズされた文字列での出力
----------------

文字列を出力する際は、通常はユーザの国にあわせた書式にしたくなることでしょう。
たとえば、"1234567.8" という値はドイツでは "1.234.567,8" と表します。
この機能は、将来のリリースでサポートされる予定です。



.. _`echo`: http://php.net/echo
.. _`print`: http://php.net/print
