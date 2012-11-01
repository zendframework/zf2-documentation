.. EN-Revision: none
.. _zend.codegenerator.reference:

Zend_CodeGenerator リファレンス
=========================

.. _zend.codegenerator.reference.abstracts:

抽象クラスとインターフェース
--------------

.. _zend.codegenerator.reference.abstracts.abstract:

Zend\CodeGenerator\Abstract
^^^^^^^^^^^^^^^^^^^^^^^^^^^

すべての CodeGenerator クラスが継承する基底のクラスは、
必要な最小限の機能性を提供します。 その *API*\ は下記の通りです。:

.. code-block:: php
   :linenos:

   abstract class Zend\CodeGenerator\Abstract
   {
       final public function __construct(Array $options = array())
       public function setOptions(Array $options)
       public function setSourceContent($sourceContent)
       public function getSourceContent()
       protected function _init()
       protected function _prepare()
       abstract public function generate();
       final public function __toString()
   }

コンストラクタは最初に ``_init()`` を呼び出します。
（それは、具体的に拡張するクラスを実装するために空のままにされます） それから
``setOptions()`` に ``$options`` パラメータを渡し、 最後に ``_prepare()`` を呼び出します。
（\ again, クラスの拡張によって実装されます。）

Zend Framework のほとんどのクラスのように、 ``setOptions()``
ではクラスの既存のセッターへのオプション・キーを比較して、
見つかったら、メソッドに値を渡します。

``__toString()`` は最後に指定され、 ``generate()`` の代わりをします。

``setSourceContent()`` 及び ``getSourceContent()`` は
デフォルト・コンテンツを生成されたコードに設定するか、
一旦すべての生成作業が完了した前述のコンテンツと入れ替えることを目的とします。

.. _zend.codegenerator.reference.abstracts.php-abstract:

Zend\CodeGenerator_Php\Abstract
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\Abstract`` は ``Zend\CodeGenerator\Abstract`` を拡張し、
生成されたコンテンツの前に現れなければならないインデントの量だけでなく、
コンテンツが変わったかどうか追跡するための若干のプロパティも加えます。 その
*API* は下記の通りです。:

.. code-block:: php
   :linenos:

   abstract class Zend\CodeGenerator_Php\Abstract
       extends Zend\CodeGenerator\Abstract
   {
       public function setSourceDirty($isSourceDirty = true)
       public function isSourceDirty()
       public function setIndentation($indentation)
       public function getIndentation()
   }

.. _zend.codegenerator.reference.abstracts.php-member-abstract:

Zend\CodeGenerator\Php\Member\Abstract
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\Member\Abstract`` は クラスのメンバー - プロパティとメソッド -
を生成するための基底クラスで、
可視性を確立するためのアクセッサとミューテータを提供します;
メンバーやメンバー名が abstract 、 static または final のいずれにせよ。 その *API*
は下記の通りです。:

.. code-block:: php
   :linenos:

   abstract class Zend\CodeGenerator\Php\Member\Abstract
       extends Zend\CodeGenerator_Php\Abstract
   {
       public function setAbstract($isAbstract)
       public function isAbstract()
       public function setStatic($isStatic)
       public function isStatic()
       public function setVisibility($visibility)
       public function getVisibility()
       public function setName($name)
       public function getName()
   }

.. _zend.codegenerator.reference.concrete:

CodeGenerator クラスを確立
--------------------

.. _zend.codegenerator.reference.concrete.php-body:

Zend\CodeGenerator_Php\Body
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\Body`` は、
ファイルの中に含む任意の手続き的なコードを生成することを目的とします。
そのように、単にコンテンツをオブジェクトに設定し、 ``generate()``
を実施すると、それはそのコンテンツを返します。

そのクラスの *API* は下記の通りです。:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator_Php\Body extends Zend\CodeGenerator_Php\Abstract
   {
       public function setContent($content)
       public function getContent()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-class:

Zend\CodeGenerator_Php\Class
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\Class`` は、 *PHP* クラスを生成することを目的とします。
基本的機能では *PHP* クラスそのものを生成し、 また、任意で関連した *PHP*
DocBlockも生成します。
クラスは他のクラスを実装するかもしれませんし、継承するかもしれません。
またはabstractと指定されるかもしれません。
他のコード・ジェネレーター・クラスを利用して、
クラスの定数やプロパティ、メソッドを付与することもできます。

その *API* は下記の通りです。:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator_Php\Class extends Zend\CodeGenerator_Php\Abstract
   {
       public static function fromReflection(
           Zend\Reflection\Class $reflectionClass
       )
       public function setDocblock(Zend\CodeGenerator_Php\Docblock $docblock)
       public function getDocblock()
       public function setName($name)
       public function getName()
       public function setAbstract($isAbstract)
       public function isAbstract()
       public function setExtendedClass($extendedClass)
       public function getExtendedClass()
       public function setImplementedInterfaces(Array $implementedInterfaces)
       public function getImplementedInterfaces()
       public function setProperties(Array $properties)
       public function setProperty($property)
       public function getProperties()
       public function getProperty($propertyName)
       public function setMethods(Array $methods)
       public function setMethod($method)
       public function getMethods()
       public function getMethod($methodName)
       public function hasMethod($methodName)
       public function isSourceDirty()
       public function generate()
   }

``setProperty()`` メソッドは、 ``Zend\CodeGenerator_Php\Property`` インスタンスを生成するために
用いられるかもしれない情報の配列、 またはただ単に ``Zend\CodeGenerator_Php\Property``
インスタンス、 を受け入れます。 同様に ``setMethod()`` は、 ``Zend\CodeGenerator_Php\Method``
インスタンスを生成するための、
情報の配列またはそのクラスの具体化したインスタンスを受け入れます。

``setDocBlock()`` が ``Zend\CodeGenerator_Php\DocBlock`` の
インスタンスを期待することも注意してください。

.. _zend.codegenerator.reference.concrete.php-docblock:

Zend\CodeGenerator_Php\Docblock
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\Docblock`` は、 すべての標準的な docblock 機能を含む任意の *PHP*
docblock を生成することで使用できます: 短い、または長い説明や注釈タグ。

注釈タグは ``setTag()`` や ``setTags()`` メソッドを用いてセットされるかもしれません;
これらは ``Zend\CodeGenerator\Php\Docblock\Tag``
コンストラクタに渡されるかもしれないタグを記述している配列、
またはそのクラスのインスタンスどちらもそれぞれ\ take

その *API* は下記の通りです。:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator_Php\Docblock extends Zend\CodeGenerator_Php\Abstract
   {
       public static function fromReflection(
           Zend\Reflection\Docblock $reflectionDocblock
       )
       public function setShortDescription($shortDescription)
       public function getShortDescription()
       public function setLongDescription($longDescription)
       public function getLongDescription()
       public function setTags(Array $tags)
       public function setTag($tag)
       public function getTags()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-docblock-tag:

Zend\CodeGenerator\Php\Docblock\Tag
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\Docblock\Tag`` は、 *PHP* docblock
に含む任意の注釈タグを作成することを目的とします。
タグは、名前（＠記号にすぐ続く部分）と説明（タグ名に続いているすべて）を含むことになっています。

そのクラスの *API* は下記の通りです。:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Docblock\Tag
       extends Zend\CodeGenerator_Php\Abstract
   {
       public static function fromReflection(
           Zend\Reflection_Docblock\Tag $reflectionTag
       )
       public function setName($name)
       public function getName()
       public function setDescription($description)
       public function getDescription()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-docblock-tag-param:

Zend\CodeGenerator\Php\DocBlock\Tag\Param
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\DocBlock\Tag\Param`` は ``Zend\CodeGenerator\Php\DocBlock\Tag``
の分化したバージョンで、 メソッド・パラメータを表します。 そこで、タグ名は(
"param" )として知られています、
しかし、この注釈タグを構成するパラメータ名とデータ型を生成するために、
追加の情報が必要とされます。

そのクラスの *API* は下記の通りです。:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Docblock\Tag\Param
       extends Zend\CodeGenerator\Php\Docblock\Tag
   {
       public static function fromReflection(
           Zend\Reflection_Docblock\Tag $reflectionTagParam
       )
       public function setDatatype($datatype)
       public function getDatatype()
       public function setParamName($paramName)
       public function getParamName()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-docblock-tag-return:

Zend\CodeGenerator\Php\DocBlock\Tag\Return
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

param docblock tag variant のように、 ``Zend\CodeGenerator\Php\Docblock\Tab\Return`` は
メソッドの戻り値を表すための注釈\ tag variantです。 この場合、注釈タグ名は( "return"
)として知られていますが、戻す型を必要とします。

そのクラスの *API* は下記の通りです。:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Docblock\Tag\Param
       extends Zend\CodeGenerator\Php\Docblock\Tag
   {
       public static function fromReflection(
           Zend\Reflection_Docblock\Tag $reflectionTagReturn
       )
       public function setDatatype($datatype)
       public function getDatatype()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-file:

Zend\CodeGenerator_Php\File
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\File`` は、 *PHP*
コードを含むファイルの完全なコンテンツを生成することに使われます。
ファイル・レベルの docblock と同様に必要に応じて、 ファイルはクラスまたは任意の
*PHP* コードを含むかもしれません。

クラスをファイルに加えるとき、 ``Zend\CodeGenerator_Php\Class``
コンストラクタに渡す情報の配列か、
そのクラスのインスタンスのどちらかを渡す必要があります。 同様に docblock で、
``Zend\CodeGenerator_Php\Docblock`` コンストラクタが消費する情報、
またはクラスのインスタンスを渡す必要があります。

そのクラスの *API* は下記の通りです。:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator_Php\File extends Zend\CodeGenerator_Php\Abstract
   {
       public static function fromReflectedFilePath(
           $filePath,
           $usePreviousCodeGeneratorIfItExists = true,
           $includeIfNotAlreadyIncluded = true)
       public static function fromReflection(Zend\Reflection\File $reflectionFile)
       public function setDocblock(Zend\CodeGenerator_Php\Docblock $docblock)
       public function getDocblock()
       public function setRequiredFiles($requiredFiles)
       public function getRequiredFiles()
       public function setClasses(Array $classes)
       public function getClass($name = null)
       public function setClass($class)
       public function setFilename($filename)
       public function getFilename()
       public function getClasses()
       public function setBody($body)
       public function getBody()
       public function isSourceDirty()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-member-container:

Zend\CodeGenerator\Php\Member\Container
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator\Php\Member\Container`` は、 ``Zend\CodeGenerator_Php\Class`` によって、
内部的にクラスのメンバー - プロパティやメソッドなど -
の経過を追う目的に使われます。

そのクラスの *API* は下記の通りです。:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator\Php\Member\Container extends ArrayObject
   {
       public function __construct($type = self::TYPE_PROPERTY)
   }

.. _zend.codegenerator.reference.concrete.php-method:

Zend\CodeGenerator_Php\Method
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\Method`` は、 クラス・メソッドを記述して、
メソッドのためにコードと docblock を生成できます。 その親クラス、
``Zend\CodeGenerator\Php\Member\Abstract`` の通りに、 static 、 abstract または final
としての可視性と状態が指示されるかもしれません。
最後に、メソッドのパラメータと戻り値は、指定されるかもしれません。

パラメータは ``setParameter()`` または ``setParameters()``
を用いて設定されるかもしれません。 それぞれの場合、パラメータは
``Zend\CodeGenerator_Php\Parameter`` コンストラクタに渡す情報の配列か、
またはそのクラスのインスタンスでなければいけません。

そのクラスの *API* は下記の通りです。:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator_Php\Method
       extends Zend\CodeGenerator\Php\Member\Abstract
   {
       public static function fromReflection(
           Zend\Reflection\Method $reflectionMethod
       )
       public function setDocblock(Zend\CodeGenerator_Php\Docblock $docblock)
       public function getDocblock()
       public function setFinal($isFinal)
       public function setParameters(Array $parameters)
       public function setParameter($parameter)
       public function getParameters()
       public function setBody($body)
       public function getBody()
       public function generate()
   }

.. _zend.codegenerator.reference.concrete.php-parameter:

Zend\CodeGenerator_Php\Parameter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\Parameter`` は、
メソッドのパラメータを指定することに使われるかもしれません。
各々のパラメータは、位置やデフォルト値、データ型を持つかもしれません;
パラメータ名は必須です。
位置がもし明確でなければ、それらがメソッドで記載された順序が使われます。

そのクラスの *API* は下記の通りです。:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator_Php\Parameter extends Zend\CodeGenerator_Php\Abstract
   {
       public static function fromReflection(
           Zend\Reflection\Parameter $reflectionParameter
       )
       public function setType($type)
       public function getType()
       public function setName($name)
       public function getName()
       public function setDefaultValue($defaultValue)
       public function getDefaultValue()
       public function setPosition($position)
       public function getPosition()
       public function getPassedByReference()
       public function setPassedByReference($passedByReference)
       public function generate()
   }

既定値として ``NULL`` 、ブーリアンまたは配列を設定しようとすると、
いくつかの問題が起きるかもしれません。
このために、バリューホルダー・オブジェクト ``Zend\CodeGenerator_Php\ParameterDefaultValue``
を利用できます。例えば:

.. code-block:: php
   :linenos:

   $parameter = new Zend\CodeGenerator_Php\Parameter();
   $parameter->setDefaultValue(
       new Zend\CodeGenerator\Php\Parameter\DefaultValue("null")
   );
   $parameter->setDefaultValue(
       new Zend\CodeGenerator\Php\Parameter\DefaultValue("array('foo', 'bar')")
   );

内部的には ``setDefaultValue()`` も *PHP*
で表現できない値をバリューホルダーに変換します。

.. _zend.codegenerator.reference.concrete.php-property:

Zend\CodeGenerator_Php\Property
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend\CodeGenerator_Php\Property`` はクラスのプロパティを記述します。
それは定数か変数であるかもしれません。
どちらの場合も、プロパティには関連するデフォルト値をオプションで持つかもしれません。
さらに、親クラス（ ``Zend\CodeGenerator\Php\Member\Abstract`` ）を通じて
変数のプロパティの可視性が設定されるかもしれません。

そのクラスの *API* は下記の通りです。:

.. code-block:: php
   :linenos:

   class Zend\CodeGenerator_Php\Property
       extends Zend\CodeGenerator\Php\Member\Abstract
   {
       public static function fromReflection(
           Zend\Reflection\Property $reflectionProperty
       )
       public function setConst($const)
       public function isConst()
       public function setDefaultValue($defaultValue)
       public function getDefaultValue()
       public function generate()
   }


