.. _zend.reflection.reference:

Zend_Reflectionリファレンス
=====================

``Zend_Reflection``\ の様々なクラスは、 *PHP*\ の `Reflection API`_\ の *API*\
に良く似ています。 しかし、一つ重要な違いがあります。 *PHP*\ のReflection *API*\
はdocblock注釈タグの内部、パラメータ変数の型も返す型も、
参照することができません。

``Zend_Reflection``\ は、 パラメーター変数の型や返す型を判断するために、
メソッドのdocblock注釈を解析します。 特に *@param*\ 及び *@return*\ 注釈が使われます。
しかしながら、"短い"説明や"長い"説明ばかりではなく、
その他の注釈タグも検査できます。

``Zend_Reflection``\ のそれぞれのReflectionオブジェクトは、 ``Zend_Reflection_Docblock``\
のインスタンスを返すように、 *getDocblock()*\ を上書きします。
このクラスはdocblock及び注釈タグを参照できるようにします。

``Zend_Reflection_File``\ は *PHP*\ ファイルの内部を参照できる新しいReflectionクラスです。
それを使って、 *PHP*\ ファイルに含まれるクラスや関数、グローバルな *PHP*\
コードを取得できます。

最後に、その他のReflectionオブジェクトを返す様々なメソッドにおいて、
２番目の引数としてクラス名を、 返されたReflectionオブジェクトで使用できます。

.. _zend.reflection.reference.docblock:

Zend_Reflection_Docblock
------------------------

``Zend_Reflection_Docblock``\ は *PHP*\ のReflection *API*\ 以上に ``Zend_Reflection``\
に価値を付与する心臓部です。 それには下記のメソッドがあります:

- *getContents()*: docblockの完全な内容を返します

- *getStartLine()*: 定義されたファイル内での docblock開始位置を返します

- *getEndLine()*: 定義されたファイル内での docblock終了行を返します

- *getShortDescription()*: 短い、一行の説明を取得します (たいていはdocblockの最初の行)

- *getLongDescription()*: docblockの長い説明を取得します

- *hasTag($name)*: 与えられた注釈タグが docblockにあるかどうか判断します

- *getTag($name)*: 与えられた注釈タグのReflectionオブジェクト、 または存在しない場合
  ``FALSE``\ を返します

- *getTags($filter)*: 全てのタグ、 または与えられた ``$filter``\
  文字列に一致する全てのタグを取得します。 タグは ``Zend_Reflection_Docblock_Tag``\
  オブジェクトの配列として返されます。

.. _zend.reflection.reference.docblock-tag:

Zend_Reflection_Docblock_Tag
----------------------------

``Zend_Reflection_Docblock_Tag``\ は個別の注釈タグのためのReflectionを提供します。
ほとんどのタグは名前と説明から構成されています。
いくつかの特別なタグの場合には、 適切なクラスのインスタンスを取得するための、
ファクトリーメソッドをクラスで提供します。

下記のメソッドは ``Zend_Reflection_Docblock_Tag``\ のために定義されています:

- *factory($tagDocblockLine)*: 注釈タグReflectionクラスをインスタンス化して返します。

- *getName()*: 注釈タグの名前を返します

- *getDescription()*: 注釈の説明を返します

.. _zend.reflection.reference.docblock-tag-param:

Zend_Reflection_Docblock_Tag_Param
----------------------------------

``Zend_Reflection_Docblock_Tag_Param``\ は ``Zend_Reflection_Docblock_Tag``\
の特化したバージョンです。 *@param*\
注釈タグの説明はパラメータの型及び変数名、変数の説明から構成されています。
このクラスにより下記のメソッドが ``Zend_Reflection_Docblock_Tag``\ に追加されます:

- *getType()*: パラメータ変数の型を返します

- *getVariableName()*: パラメータ変数の名前を返します

.. _zend.reflection.reference.docblock-tag-return:

Zend_Reflection_Docblock_Tag_Return
-----------------------------------

``Zend_Reflection_Docblock_Tag_Param``\ のように、 ``Zend_Reflection_Docblock_Tag_Return``\ は
``Zend_Reflection_Docblock_Tag``\ の特化したバージョンです。 *@return*\
注釈タグの説明は返す型及び変数の説明から構成されています。
このクラスにより下記のメソッドが ``Zend_Reflection_Docblock_Tag``\ に追加されます:

- *getType()*: 戻す型を返します

.. _zend.reflection.reference.file:

Zend_Reflection_File
--------------------

``Zend_Reflection_File``\ により *PHP*\ ファイル内部を参照できます。
それを使って、ファイルで定義されたクラスや関数、生の *PHP*\
コードを参照できます。 下記の関数が定義されています:

- *getFileName()*: Reflectionを使用したファイルの名前を取得します

- *getStartLine()*: ファイルの開始行を返します（常に１）

- *getEndLine()* 最終行、ファイル中の行数を取得します

- *getDocComment($reflectionClass = 'Zend_Reflection_Docblock')*: ファイルレベルのdocblock
  Reflectionオブジェクトを取得します

- *getClasses($reflectionClass = 'Zend_Reflection_Class')*:
  Reflectionオブジェクトの配列を取得します。
  ファイルに定義されているそれぞれのクラスです。

- *getFunctions($reflectionClass = 'Zend_Reflection_Function')*:
  Reflectionオブジェクトの配列を取得します。
  ファイルに定義されているそれぞれの関数です。

- *getClass($name = null, $reflectionClass = 'Zend_Reflection_Class')*:
  一つのクラスのReflectionオブジェクトの配列を取得します

- *getContents()*: ファイルの全てのコンテンツを取得します。

.. _zend.reflection.reference.class:

Zend_Reflection_Class
---------------------

``Zend_Reflection_Class``\ は ``ReflectionClass``\ を拡張して、 その *API*\ に追随します。
ひとつ追加のメソッド、 *getDeclaringFile()*\ を追加します。
それは定義されたファイルでの ``Zend_Reflection_File`` Reflectionオブジェクトを
取得するために使われるでしょう。

さらに、下記のメソッドはReflectionオブジェクトを取り出すときに使う
Reflectionクラスを指定する際に追加の変数を加えます。:

- *getDeclaringFile($reflectionClass = 'Zend_Reflection_File')*

- *getDocblock($reflectionClass = 'Zend_Reflection_Docblock')*

- *getInterfaces($reflectionClass = 'Zend_Reflection_Class')*

- *getMethod($reflectionClass = 'Zend_Reflection_Method')*

- *getMethods($filter = -1, $reflectionClass = 'Zend_Reflection_Method')*

- *getParentClass($reflectionClass = 'Zend_Reflection_Class')*

- *getProperty($name, $reflectionClass = 'Zend_Reflection_Property')*

- *getProperties($filter = -1, $reflectionClass = 'Zend_Reflection_Property')*

.. _zend.reflection.reference.extension:

Zend_Reflection_Extension
-------------------------

``Zend_Reflection_Extension``\ は ``ReflectionExtension``\ を拡張して、 その *API*\ に追随します。
それはReflectionオブジェクトを取り出すときに使う
Reflectionクラスを指定する際に追加の変数を加えて、
下記のメソッドを上書きします。

- *getFunctions($reflectionClass = 'Zend_Reflection_Function')*:
  エクステンションで定義された関数を 示す配列を取得します。

- *getClasses($reflectionClass = 'Zend_Reflection_Class')*: エクステンションで定義されたクラスを
  示す配列を取得します。

.. _zend.reflection.reference.function:

Zend_Reflection_Function
------------------------

``Zend_Reflection_Function``\ は、
返されたReflectionを使ってReflectionクラスを指定できるように、
いくつかのメソッドを上書きするばかりではなく、
関数の返り値を取得するメソッドを追加します。

- *getDocblock($reflectionClass = 'Zend_Reflection_Docblock')*: 関数docblockの
  Reflectionオブジェクトを取得します

- *getParameters($reflectionClass = 'Zend_Reflection_Parameter')*: 関数のパラメータ
  Reflectionオブジェクト全ての配列を取得します

- *getReturn()*: 戻す型のReflectionオブジェクトを取得します

.. _zend.reflection.reference.method:

Zend_Reflection_Method
----------------------

``Zend_Reflection_Method``\ は ``Zend_Reflection_Function``\ を継承して、
追加のメソッドを１つだけ上書きします:

- *getParentClass($reflectionClass = 'Zend_Reflection_Class')*:
  親クラスのReflectionオブジェクトを取得します

.. _zend.reflection.reference.parameter:

Zend_Reflection_Parameter
-------------------------

``Zend_Reflection_Parameter``\ は 戻されたReflectionオブジェクトで
Reflectionを使えるようにする上書きメソッドばかりではなく、
パラメータの型を取得するメソッドを追加します。

- *getDeclaringClass($reflectionClass = 'Zend_Reflection_Class')*: もし可能ならば、
  Reflectionオブジェクトとしてパラメータの宣言クラスを取得します。

- *getClass($reflectionClass = 'Zend_Reflection_Class')*: もし可能ならば、
  Reflectionオブジェクトとしてパラメータのクラスを取得します。

- *getDeclaringFunction($reflectionClass = 'Zend_Reflection_Function')*: もし可能ならば、
  Reflectionオブジェクトとしてパラメータの関数を取得します。

- *getType()*: パラメータの型を取得します

.. _zend.reflection.reference.property:

Zend_Reflection_Property
------------------------

``Zend_Reflection_Property``\ は、 戻されたReflectionオブジェクトクラスを指定するための、
メソッドを１つ上書きします。:

- *getDeclaringClass($reflectionClass = 'Zend_Reflection_Class')*: Reflectionオブジェクトとして
  プロパティーの宣言クラスを取得します



.. _`Reflection API`: http://php.net/reflection
