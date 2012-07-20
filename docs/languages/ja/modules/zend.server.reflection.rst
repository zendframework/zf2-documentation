.. _zend.server.reflection:

Zend_Server_Reflection
======================

.. _zend.server.reflection.introduction:

導入
--

``Zend_Server_Reflection`` は、サーバクラス群で
関数やクラスの内容を知るための標準的な仕組みを提供します。 *PHP* 5
のリフレクション *API* をもとにして拡張したものです。
パラメータや返り値の型と説明の取得、関数やメソッドのプロトタイプの一覧
(つまり、すべての呼び出し可能な方法) の取得、関数またはメソッド
の説明の取得なども可能です。

この機能は、フレームワーク用のサーバクラス群の開発者のみが使用します。

.. _zend.server.reflection.usage:

使用法
---

基本的な使用法は簡単です。

.. code-block:: php
   :linenos:

   $class    = Zend_Server_Reflection::reflectClass('My_Class');
   $function = Zend_Server_Reflection::reflectFunction('my_function');

   // プロトタイプを取得します
   $prototypes = $reflection->getPrototypes();

   // 各プロトタイプを処理します
   foreach ($prototypes as $prototype) {

       // 返り値の型を取得します
       echo "返り値の型: ", $prototype->getReturnType(), "\n";

       // パラメータを取得します
       $parameters = $prototype->getParameters();

       echo "パラメータ: \n";
       foreach ($parameters as $parameter) {
           // パラメータの型を取得します
           echo "    ", $parameter->getType(), "\n";
       }
   }

   // クラス、関数あるいはメソッドの名前空間を取得します。
   // 名前空間は、インスタンス作成時 (二番目の引数) あるいは
   // setNamespace() で設定します。
   $reflection->getNamespace();

``reflectFunction()`` は ``Zend_Server_Reflection_Function`` オブジェクトを返します。 ``reflectClass``
は ``Zend_Server_Reflection_Class`` オブジェクトを返します。
これらのオブジェクトで使用できるメソッドについては *API*
ドキュメントを参照ください。


