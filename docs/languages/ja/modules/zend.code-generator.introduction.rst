.. EN-Revision: none
.. _zend.codegenerator.introduction:

導入
==

``Zend_CodeGenerator``\ は、
新しいコードを作成するばかりではなく、既存のコードを更新するためにも、
オブジェクト指向インターフェースを用いた任意のコードを生成する機能を提供します。
現在の実装は *PHP*\ コードを生成することに限られますが、
他の仕事のためのコード生成をさせるために基底クラスを簡単に拡張することができます：
JavaScript、設定ファイル、apache vhosts、その他。

.. _zend.codegenerator.introduction.theory:

Theory of Operation
-------------------

最も代表的な使用例では、単にコード・ジェネレーター・クラスのインスタンスを生成して、
それに適切な設定を渡すか、またはインスタンス化のあと設定します。
コードを生成するために、単にオブジェクトをechoするか、 その ``generate()``\
メソッドを呼びます。

.. code-block:: php
   :linenos:

   //構成をコンストラクタに渡す
   $file = new Zend_CodeGenerator_Php_File(array(
       'classes' => array(
           new Zend_CodeGenerator_Php_Class(array(
               'name'    => 'World',
               'methods' => array(
                   new Zend_CodeGenerator_Php_Method(array(
                       'name' => 'hello',
                       'body' => 'echo \'Hello world!\';',
                   )),
               ),
           )),
       )
   ));

   //インスタンス化のあと設定
   $method = new Zend_CodeGenerator_Php_Method();
   $method->setName('hello')
          ->setBody('echo \'Hello world!\';');

   $class = new Zend_CodeGenerator_Php_Class();
   $class->setName('World')
         ->setMethod($method);

   $file = new Zend_CodeGenerator_Php_File();
   $file->setClass($class);

   //生成されたファイルのレンダリング
   echo $file;

   //またはファイルへの書き出し:
   file_put_contents('World.php', $file->generate());

上記のサンプルは両方とも同じ結果でレンダリングされます:

.. code-block:: php
   :linenos:

   <?php

   class World
   {

       public function hello()
       {
           echo 'Hello world!';
       }

   }

もう一つの一般的な使用例は、既存のコードを更新することです。
たとえばメソッドをクラスに加えるために。
この場合には、最初にreflectionを用いて既存のコードを調べて、
次に新しいメソッドを加えなければいけません。 :ref:`Zend_Reflection <zend.reflection>`\
を導入することによって、 ``Zend_CodeGenerator``\ はつまらないほどこれを単純にします。

例えば、上記をファイル"``World.php``"に保存して、すでにincludeしたとしましょう。
それから下記のようにできます。

.. code-block:: php
   :linenos:

   $class = Zend_CodeGenerator_Php_Class::fromReflection(
       new Zend_Reflection_Class('World')
   );

   $method = new Zend_CodeGenerator_Php_Method();
   $method->setName('mrMcFeeley')
          ->setBody('echo \'Hello, Mr. McFeeley!\';');
   $class->setMethod($method);

   $file = new Zend_CodeGenerator_Php_File();
   $file->setClass($class);

   //生成されたファイルのレンダリング
   echo $file;

   //または、より良いですが、元のファイルに書き戻します。:
   file_put_contents('World.php', $file->generate());

クラスファイルの結果はこのようになります:

.. code-block:: php
   :linenos:

   <?php

   class World
   {

       public function hello()
       {
           echo 'Hello world!';
       }

       public function mrMcFeeley()
       {
           echo 'Hellow Mr. McFeeley!';
       }

   }


