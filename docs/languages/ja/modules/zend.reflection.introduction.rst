.. _zend.reflection.introduction:

導入
==

``Zend_Reflection``\ はPHP自身の `Reflection API`_\ に対応する\ drop-in 拡張です。
いくつかの追加の機能を提供します。

- 戻り値の型を取得可能

- メソッドや関数のパラメータの型を取得可能

- クラスのプロパティの型を取得可能

- DocBlockはReflectionクラスでdocblock内部を参照できる利益を得ます。
  これにより、それらの値を取得するだけでなく、定義された注釈タグが何か判断でき、
  短い説明と長い説明を取得できます。

- ファイルはReflectionクラスで *PHP*\ ファイル内部を参照できる利益を得ます。
  これにより、それらの内部を参照するだけでなく、与えられたファイルで定義された関数やクラスが何か判断できます。

- あなた自身の変数とともに、作成した全てのRreflectionツリーのために、
  どんなReflectionクラスも上書き可能

一般的に、 ``Zend_Reflection``\ ではちょうど標準的なReflection *API*\ のように働きますが、
Reflection *API*\ で定義されていない人工物を参照する追加のメソッドを提供します。



.. _`Reflection API`: http://php.net/reflection
