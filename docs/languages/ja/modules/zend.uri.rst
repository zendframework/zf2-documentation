.. _zend.uri.chapter:

Zend_Uri
========

.. _zend.uri.overview:

概要
--

``Zend_Uri`` は、 `Uniform Resource Identifiers`_ (*URI*\ s)
の操作および検証を行うためのコンポーネントです。 ``Zend_Uri`` の本来の目的は
``Zend_Http_Client`` のような他のコンポーネントを支援することですが、
単体で使用しても便利です。

*URI* の最初は常にスキームから始まり、その後にコロンが続きます。
スキームにはさまざまなものがあります。 ``Zend_Uri`` クラスは、
各スキームに特化した自身のサブクラスを返すファクトリメソッドを提供しています。
サブクラスの名前は ``Zend_Uri_<scheme>`` となり、 *<scheme>* の部分には
スキーム名の最初の文字だけを大文字にしたものがあてはまります。
この規則にはひとつ例外があり、 *HTTPS* スキームについては ``Zend_Uri_Http``
で扱われます。

.. _zend.uri.creation:

新しい URI の作成
-----------

スキームのみを ``Zend_Uri::factory()`` に渡すと、 ``Zend_Uri`` は新しい *URI*
をゼロから作成します。

.. _zend.uri.creation.example-1:

.. rubric:: Zend_Uri::factory() による新しい URI の作成

.. code-block:: php
   :linenos:

   // 何もないところから新しい URI を作成するには、スキームのみを渡します
   $uri = Zend_Uri::factory('http');

   // $uri は Zend_Uri_Http のインスタンスとなります

新しい *URI* を作成するには、スキームのみを ``Zend_Uri::factory()`` に渡します [#]_\ 。
サポートしていないスキームが渡された場合は、 ``Zend_Uri_Exception``
がスローされます。

渡されたスキームあるいは *URI* をサポートしている場合は、 ``Zend_Uri::factory()``
は自分自身のサブクラスを返します。
これは、指定したスキームに特化したものとなります。

Creating a New Custom-Class URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Starting from Zend Framework 1.10.5, you can specify a custom class to be used when creating the Zend_Uri instance,
as a second parameter to the ``Zend_Uri::factory()`` method. This enables you to subclass Zend_Uri and create your
own custom URI classes, and instantiate new URI objects based on your own custom classes.

The 2nd parameter passed to ``Zend_Uri::factory()`` must be a string with the name of a class extending
``Zend_Uri``. The class must either be alredy-loaded, or loadable using ``Zend_Loader::loadClass()``- that is, it
must follow the Zend Framework class and file naming conventions, and must be in your include_path.

.. _zend.uri.creation.custom.example-1:

.. rubric:: Creating a URI using a custom class

.. code-block:: php
   :linenos:

   // Create a new 'ftp' URI based on a custom class
   $ftpUri = Zend_Uri::factory(
       'ftp://user@ftp.example.com/path/file',
       'MyLibrary_Uri_Ftp'
   );

   // $ftpUri is an instance of MyLibrary_Uri_Ftp, which is a subclass of Zend_Uri

.. _zend.uri.manipulation:

既存の URI の操作
-----------

既存の *URI* を操作するには、完全な *URI* を ``Zend_Uri::factory()`` に渡します。

.. _zend.uri.manipulation.example-1:

.. rubric:: Zend_Uri::factory() による既存の URI の操作

.. code-block:: php
   :linenos:

   // 既存の URI を操作するには、それを渡します
   $uri = Zend_Uri::factory('http://www.zend.com');

   // $uri は Zend_Uri_Http のインスタンスです

このとき、 *URI* のパースと検証が行われます。
もし妥当な形式でなかった場合は、そこで ``Zend_Uri_Exception``
がスローされます。それ以外の場合は ``Zend_Uri::factory()``
は自分自身のサブクラスを返します。
これは、操作するスキームに特化したものとなります。

.. _zend.uri.validation:

URI の検証
-------

``Zend_Uri::check()`` 関数を使用すると、 既存の *URI* の検証のみを行うことができます。

.. _zend.uri.validation.example-1:

.. rubric:: Zend_Uri::check() による URI の検証

.. code-block:: php
   :linenos:

   // 指定した URI が正しい形式かどうかを調べます
   $valid = Zend_Uri::check('http://uri.in.question');

   // $valid は、正しければ TRUE、そうでなければ FALSE となります

``Zend_Uri::check()`` は boolean 値を返します。 これは ``Zend_Uri::factory()``
を使用して例外を処理するよりも便利です。

.. _zend.uri.validation.allowunwise:

URL 内での "Unwise" 文字の許可
^^^^^^^^^^^^^^^^^^^^^^

デフォルトでは、 ``Zend_Uri`` は次の文字を許可しません。 *"{", "}", "|", "\", "^", "`"*
これらは *RFC* で "unwise" と定義されており無効なものです。
しかし、多くの実装ではこれらの文字を妥当なものとして扱います。

``Zend_Uri`` でもこれらの "unwise" 文字を許可することができます。 そのためには、
``Zend_Uri::setConfig()`` メソッドで 'allow_unwise' オプションを ``TRUE`` に設定します。

.. _zend.uri.validation.allowunwise.example-1:

.. rubric:: URI における特殊文字の許可

.. code-block:: php
   :linenos:

   // '|' 記号を含んでいます
   // 通常は、これは false を返します
   $valid = Zend_Uri::check('http://example.com/?q=this|that');

   // しかし、"unwise" 文字を許可することもできます
   Zend_Uri::setConfig(array('allow_unwise' => true));
   // これは 'true' を返します
   $valid = Zend_Uri::check('http://example.com/?q=this|that');

   // 'allow_unwise' の値をデフォルトの FALSE に戻します
   Zend_Uri::setConfig(array('allow_unwise' => false));

.. note::

   ``Zend_Uri::setConfig()`` は、全体の設定オプションを変更します。
   そのため、上の例のように最後は 'allow_unwise' を '``FALSE``'
   に戻すことを推奨します。unwise な文字を常に許可したいという場合は別です。

.. _zend.uri.instance-methods:

共通のインスタンスメソッド
-------------

すべての ``Zend_Uri`` のサブクラス (例 ``Zend_Uri_Http``) のインスタンスには、 *URI*
操作のために便利なインスタンスメソッドがいくつか提供されています。

.. _zend.uri.instance-methods.getscheme:

URI のスキームの取得
^^^^^^^^^^^^

*URI* のスキームとは、 *URI* でカンマの前にくる部分のことです。 たとえば
*http://www.zend.com* のスキームは *http* となります。

.. _zend.uri.instance-methods.getscheme.example-1:

.. rubric:: Zend_Uri_* オブジェクトからのスキームの取得

.. code-block:: php
   :linenos:

   $uri = Zend_Uri::factory('http://www.zend.com');

   $scheme = $uri->getScheme();  // "http"

インスタンスメソッド ``getScheme()`` は、 *URI*
オブジェクトからスキームの部分のみを返します。

.. _zend.uri.instance-methods.geturi:

URI 全体の取得
^^^^^^^^^

.. _zend.uri.instance-methods.geturi.example-1:

.. rubric:: Zend_Uri_* オブジェクトからの URI 全体の取得

.. code-block:: php
   :linenos:

   $uri = Zend_Uri::factory('http://www.zend.com');

   echo $uri->getUri();  // "http://www.zend.com"

``getUri()`` メソッドは、 *URI* 全体を文字列として返します。

.. _zend.uri.instance-methods.valid:

URI の検証
^^^^^^^

``Zend_Uri::factory()`` は渡された *URI* を常に検証しており、 渡された *URI*
が無効な場合は ``Zend_Uri``
のサブクラスのインスタンスを作成しません。しかし、いったん ``Zend_Uri``
のサブクラスのインスタンスを (新規に、あるいは既存のものから) 作成し、
それを操作した後でもまだ妥当な形式であるかどうかを調べることもできます。

.. _zend.uri.instance-methods.valid.example-1:

.. rubric:: Zend_Uri_* オブジェクトの検証

.. code-block:: php
   :linenos:

   $uri = Zend_Uri::factory('http://www.zend.com');

   $isValid = $uri->valid();  // TRUE

インスタンスメソッド ``valid()`` により、 *URI*
オブジェクトが妥当なものかどうかを調べることができます。



.. _`Uniform Resource Identifiers`: http://www.w3.org/Addressing/

.. [#] 現時点では、 *HTTP* および *HTTPS* に対する組み込みサポートだけを ``Zend_Uri``
       では提供しています。