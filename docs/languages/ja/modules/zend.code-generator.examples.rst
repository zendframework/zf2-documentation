.. EN-Revision: none
.. _zend.codegenerator.examples:

Zend_CodeGeneratorサンプル
======================

.. _zend.codegenerator.examples.class:

.. rubric:: PHPクラスを生成

下記の例ではクラスレベルのDocBlock付きで空のクラスを生成します。

.. code-block:: php
   :linenos:

   $foo      = new Zend\CodeGenerator_Php\Class();
   $docblock = new Zend\CodeGenerator_Php\Docblock(array(
       'shortDescription' => '生成されたクラスサンプル',
       'longDescription'  => 'これはZend_CodeGeneratorで生成されたクラスです。',
       'tags'             => array(
           array(
               'name'        => 'version',
               'description' => '$Rev:$',
           ),
           array(
               'name'        => 'license',
               'description' => 'New BSD',
           ),
       ),
   ));
   $foo->setName('Foo')
       ->setDocblock($docblock);
   echo $foo->generate();

上記のコードは下記の結果になります。:

.. code-block:: php
   :linenos:

   /**
    * 生成されたクラスサンプル
    *
    * これはZend_CodeGeneratorで生成されたクラスです。
    *
    * @version $Rev:$
    * @license New BSD
    *
    */
   class Foo
   {

   }

.. _zend.codegenerator.examples.class-properties:

.. rubric:: クラスのプロパティ付でPHPクラスを生成

では、前の例を基にして、生成したクラスにプロパティを加えます。

.. code-block:: php
   :linenos:

   $foo      = new Zend\CodeGenerator_Php\Class();
   $docblock = new Zend\CodeGenerator_Php\Docblock(array(
       'shortDescription' => '生成されたクラスサンプル',
       'longDescription'  => 'これはZend_CodeGeneratorで生成されたクラスです。',
       'tags'             => array(
           array(
               'name'        => 'version',
               'description' => '$Rev:$',
           ),
           array(
               'name'        => 'license',
               'description' => 'New BSD',
           ),
       ),
   ));
   $foo->setName('Foo')
       ->setDocblock($docblock)
       ->setProperties(array(
           array(
               'name'         => '_bar',
               'visibility'   => 'protected',
               'defaultValue' => 'baz',
           ),
           array(
               'name'         => 'baz',
               'visibility'   => 'public',
               'defaultValue' => 'bat',
           ),
           array(
               'name'         => 'bat',
               'const'        => true,
               'defaultValue' => 'foobarbazbat',
           ),
       ));
   echo $foo->generate();

上記の結果は下記のクラス定義になります。:

.. code-block:: php
   :linenos:

   /**
    * 生成されたクラスサンプル
    *
    * これはZend_CodeGeneratorで生成されたクラスです。
    *
    * @version $Rev:$
    * @license New BSD
    *
    */
   class Foo
   {

       protected $_bar = 'baz';

       public $baz = 'bat';

       const bat = 'foobarbazbat';

   }

.. _zend.codegenerator.examples.class-methods:

.. rubric:: クラスのメソッド付でPHPクラスを生成

``Zend\CodeGenerator_Php\Class``\ のおかげで、
クラスにオプションのコンテンツと一緒にメソッドを付与できます。
メソッドは、配列かまたは具体的な ``Zend\CodeGenerator_Php\Method``\
インスタンスとして付与されるかもしれません。

.. code-block:: php
   :linenos:

   $foo      = new Zend\CodeGenerator_Php\Class();
   $docblock = new Zend\CodeGenerator_Php\Docblock(array(
       'shortDescription' => '生成されたクラスサンプル',
       'longDescription'  => 'これはZend_CodeGeneratorで生成されたクラスです。',
       'tags'             => array(
           array(
               'name'        => 'version',
               'description' => '$Rev:$',
           ),
           array(
               'name'        => 'license',
               'description' => 'New BSD',
           ),
       ),
   ));
   $foo->setName('Foo')
       ->setDocblock($docblock)
       ->setProperties(array(
           array(
               'name'         => '_bar',
               'visibility'   => 'protected',
               'defaultValue' => 'baz',
           ),
           array(
               'name'         => 'baz',
               'visibility'   => 'public',
               'defaultValue' => 'bat',
           ),
           array(
               'name'         => 'bat',
               'const'        => true,
               'defaultValue' => 'foobarbazbat',
           ),
       ))
       ->setMethods(array(
           // メソッドは配列として渡されます
           array(
               'name'       => 'setBar',
               'parameters' => array(
                   array('name' => 'bar'),
               ),
               'body'       => '$this->_bar = $bar;' . "\n" . 'return $this;',
               'docblock'   => new Zend\CodeGenerator_Php\Docblock(array(
                   'shortDescription' => 'barプロパティーを設定',
                   'tags'             => array(
                       new Zend\CodeGenerator\Php\Docblock\Tag\Param(array(
                           'paramName' => 'bar',
                           'datatype'  => 'string'
                       )),
                       new Zend\CodeGenerator\Php\Docblock\Tag\Return(array(
                           'datatype'  => 'string',
                       )),
                   ),
               )),
           ),
           // メソッドは具体的なインスタンスとして渡されます
           new Zend\CodeGenerator_Php\Method(array(
               'name' => 'getBar',
               'body'       => 'return $this->_bar;',
               'docblock'   => new Zend\CodeGenerator_Php\Docblock(array(
                   'shortDescription' => 'barプロパティーを取得',
                   'tags'             => array(
                       new Zend\CodeGenerator\Php\Docblock\Tag\Return(array(
                           'datatype'  => 'string|null',
                       )),
                   ),
               )),
           )),
       ));

   echo $foo->generate();

上記のコードは下記の出力になります。:

.. code-block:: php
   :linenos:

   /**
    * 生成されたクラスサンプル
    *
    * これはZend_CodeGeneratorで生成されたクラスです。
    *
    * @version $Rev:$
    * @license New BSD
    */
   class Foo
   {

       protected $_bar = 'baz';

       public $baz = 'bat';

       const bat = 'foobarbazbat';

       /**
        * barプロパティーを設定
        *
        * @param string bar
        * @return string
        */
       public function setBar($bar)
       {
           $this->_bar = $bar;
           return $this;
       }

       /**
        * barプロパティーを取得
        *
        * @return string|null
        */
       public function getBar()
       {
           return $this->_bar;
       }

   }

.. _zend.codegenerator.examples.file:

.. rubric:: PHPファイルの生成

``Zend\CodeGenerator_Php\File``\ は *PHP*\ ファイルのコンテンツ生成でも使えます。
あなたは、任意のコンテンツ本体だけでなくクラスを含めることができます。
クラスを付与するとき、具体的な ``Zend\CodeGenerator_Php\Class``\ インスタンスか、
またはクラスを定めている配列を添付しなければなりません。

下記の例では、前述の例のクラス定義の１つにつき ``$foo``\
を定義したと仮定します。

.. code-block:: php
   :linenos:

   $file = new Zend\CodeGenerator_Php\File(array(
       'classes'  => array($foo);
       'docblock' => new Zend\CodeGenerator_Php\Docblock(array(
           'shortDescription' => 'Fooクラスファイル',
           'tags'             => array(
               array(
                   'name'        => 'license',
                   'description' => 'New BSD',
               ),
           ),
       )),
       'body'     => 'define(\'APPLICATION_ENV\', \'testing\');',
   ));

``generate()``\ を呼び出すとコードを生成します。
しかし、ファイルに書き出しません。
コンテンツを捕まえて、自分自身で書き出す必要があります。 その例です。:

.. code-block:: php
   :linenos:

   $code = $file->generate();
   file_put_contents('Foo.php', $code);

上記は下記のファイルを生成します:

.. code-block:: php
   :linenos:

   <?php
   /**
    * Fooクラスファイル
    *
    * @license New BSD
    */

   /**
    * 生成されたクラスサンプル
    *
    * これはZend_CodeGeneratorで生成されたクラスです。
    *
    * @version $Rev:$
    * @license New BSD
    */
   class Foo
   {

       protected $_bar = 'baz';

       public $baz = 'bat';

       const bat = 'foobarbazbat';

       /**
        * barプロパティーを設定
        *
        * @param string bar
        * @return string
        */
       public function setBar($bar)
       {
           $this->_bar = $bar;
           return $this;
       }

       /**
        * barプロパティーを取得
        *
        * @return string|null
        */
       public function getBar()
       {
           return $this->_bar;
       }

   }

   define('APPLICATION_ENV', 'testing');

.. _zend.codegenerator.examples.reflection-file:

.. rubric:: reflection経由のPHPファイルのコード生成の種まき

コード・ジェネレーターを使って、 既存の *PHP*\ ファイルに *PHP*\
コードを加えることができます。
そうするためには、まずそれにたいしてreflectionを実行する必要があります。
静的メソッド ``fromReflectedFileName()``\ によりこれを実行できます。

.. code-block:: php
   :linenos:

   $generator = Zend\CodeGenerator_Php\File::fromReflectedFileName($path);
   $body = $generator->getBody();
   $body .= "\n\$foo->bar();";
   file_put_contents($path, $generator->generate());

.. _zend.codegenerator.examples.reflection-class:

.. rubric:: reflection経由のPHPクラス生成の種まき

コード・ジェネレーターを使って、既存のPHPファイルにPHPコードを加えることができます。
そうするために、最初にクラスをジェネレーター・オブジェクトにマップするために、
静的メソッド ``fromReflection()``\ を使ってください。
そこから追加のプロパティまたはメソッドを加えて、そしてクラスを再生成するでしょう。

.. code-block:: php
   :linenos:

   $generator = Zend\CodeGenerator_Php\Class::fromReflection(
       new Zend\Reflection\Class($class)
   );
   $generator->setMethod(array(
       'name'       => 'setBaz',
       'parameters' => array(
           array('name' => 'baz'),
       ),
       'body'       => '$this->_baz = $baz;' . "\n" . 'return $this;',
       'docblock'   => new Zend\CodeGenerator_Php\Docblock(array(
           'shortDescription' => 'bazプロパティーを設定',
           'tags'             => array(
               new Zend\CodeGenerator\Php\Docblock\Tag\Param(array(
                   'paramName' => 'baz',
                   'datatype'  => 'string'
               )),
               new Zend\CodeGenerator\Php\Docblock\Tag\Return(array(
                   'datatype'  => 'string',
               )),
           ),
       )),
   ));
   $code = $generator->generate();


