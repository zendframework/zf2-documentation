.. EN-Revision: none
.. _migration.110:

Zend Framework 1.10
===================

以前のバージョンから Zend Framework 1.10 またはそれ以降に更新する際は、
下記の移行上の注意点に注意すべきです。

.. _migration.110.zend.controller.front:

Zend_Controller_Front
---------------------

A wrong behaviour was fixed, when there was no module route and no route matched the given request. Previously, the
router returned an unmodified request object, so the front controller just displayed the default controller and
action. Since Zend Framework 1.10, the router will correctly as noted in the router interface, throw an exception
if no route matches. The error plugin will then catch that exception and forward to the error controller. You can
then test for that specific error with the constant ``Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ROUTE``:

.. code-block:: php
   :linenos:

   /**
    * Before 1.10
    */
       public function errorAction()
       {
           $errors = $this->_getParam('error_handler');

           switch ($errors->type) {
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_CONTROLLER:
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ACTION:
       // ...

   /**
    * With 1.10
    */
       public function errorAction()
       {
           $errors = $this->_getParam('error_handler');

           switch ($errors->type) {
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ROUTE:
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_CONTROLLER:
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ACTION:
       // ...

.. _migration.110.zend.feed.reader:

Zend_Feed_Reader
----------------

With the introduction of Zend Framework 1.10, ``Zend_Feed_Reader``'s handling of retrieving Authors and
Contributors was changed, introducing a break in backwards compatibility. This change was an effort to harmonise
the treatment of such data across the RSS and Atom classes of the component and enable the return of Author and
Contributor data in more accessible, usable and detailed form. It also rectifies an error in that it was assumed
any author element referred to a name. In RSS this is incorrect as an author element is actually only required to
provide an email address. In addition, the original implementation applied its RSS limits to Atom feeds
significantly reducing the usefulness of the parser with that format.

The change means that methods like ``getAuthors()`` and ``getContributors`` no longer return a simple array of
strings parsed from the relevant RSS and Atom elements. Instead, the return value is an ``ArrayObject`` subclass
called ``Zend_Feed_Reader_Collection_Author`` which simulates an iterable multidimensional array of Authors. Each
member of this object will be a simple array with three potential keys (as the source data permits). These include:
name, email and uri.

The original behaviour of such methods would have returned a simple array of strings, each string attempting to
present a single name, but in reality this was unreliable since there is no rule governing the format of RSS Author
strings.

The simplest method of simulating the original behaviour of these methods is to use the
``Zend_Feed_Reader_Collection_Author``'s ``getValues()`` which also returns a simple array of strings representing
the "most relevant data", for authors presumed to be their name. Each value in the resulting array is derived from
the "name" value attached to each Author (if present). In most cases this simple change is easy to apply as
demonstrated below.

.. code-block:: php
   :linenos:

   /**
    * Before 1.10
    */
   $feed = Zend_Feed_Reader::import('http://example.com/feed');
   $authors = $feed->getAuthors();

   /**
    * With 1.10
    */
   $feed = Zend_Feed_Reader::import('http://example.com/feed');
   $authors = $feed->getAuthors()->getValues();

.. _migration.110.zend.file.transfer:

Zend_File_Transfer
------------------

.. _migration.110.zend.file.transfer.files:

Security change
^^^^^^^^^^^^^^^

For security reasons ``Zend_File_Transfer`` does no longer store the original mimetype and filesize which is given
from the requesting client into its internal storage. Instead the real values will be detected at initiation.

Additionally the original values within ``$_FILES`` will be overridden within the real values at initiation. This
makes also ``$_FILES`` secure.

When you are in need of the original values you can either store them before initiating ``Zend_File_Transfer`` or
use the ``disableInfos`` option at initiation. Note that this option is useless when its given after initiation.

.. _migration.110.zend.file.transfer.count:

Count 検証
^^^^^^^^

リリース 1.10 より前は ``MimeType`` バリデータが誤った命名を使っていました。
一貫性のために、下記の定数が変更されました。

.. _migration.110.zend.file.transfer.count.table:

.. table:: 変更された検証メッセージ

   +--------+--------+-------------------------------------------------------------------+
   |旧       |新       |値                                                                  |
   +========+========+===================================================================+
   |TOO_MUCH|TOO_MANY|Too many files, maximum '%max%' are allowed but '%count%' are given|
   +--------+--------+-------------------------------------------------------------------+
   |TOO_LESS|TOO_FEW |Too few files, minimum '%min%' are expected but '%count%' are given|
   +--------+--------+-------------------------------------------------------------------+

コード内でこれらのメッセージを翻訳している場合、新しい定数を使います。
利点として、正しいつづりを得るために、本来の文字列を翻訳する必要はもうありません。

.. _migration.110.zend.filter.html-entities:

Zend_Filter_HtmlEntities
------------------------

In order to default to a more secure character encoding, ``Zend_Filter_HtmlEntities`` now defaults to *UTF-8*
instead of *ISO-8859-1*.

Additionally, because the actual mechanism is dealing with character encodings and not character sets, two new
methods have been added, ``setEncoding()`` and ``getEncoding()``. The previous methods ``setCharSet()`` and
``setCharSet()`` are now deprecated and proxy to the new methods. Finally, instead of using the protected members
directly within the ``filter()`` method, these members are retrieved by their explicit accessors. If you were
extending the filter in the past, please check your code and unit tests to ensure everything still continues to
work.

.. _migration.110.zend.filter.strip-tags:

Zend_Filter_StripTags
---------------------

``Zend_Filter_StripTags`` contains a flag, ``commentsAllowed``, that, in previous versions, allowed you to
optionally whitelist *HTML* comments in *HTML* text filtered by the class. However, this opens code enabling the
flag to *XSS* attacks, particularly in Internet Explorer (which allows specifying conditional functionality via
*HTML* comments). Starting in version 1.9.7 (and backported to versions 1.8.5 and 1.7.9), the ``commentsAllowed``
flag no longer has any meaning, and all *HTML* comments, including those containing other *HTML* tags or nested
commments, will be stripped from the final output of the filter.

.. _migration.110.zend.translator:

Zend_Translator
---------------

.. _migration.110.zend.translator.xliff:

Xliff アダプタ
^^^^^^^^^^

過去には Xliff アダプタはソースの文字列をメッセージ Id として使いました。 Xliff
標準に沿って、翻訳単位 Id が使われるべきです。 この振る舞いは Zend Framework 1.10
で修正されました。 今では既定では翻訳単位 Id はメッセージId として使われます。

しかし、 ``useId`` オプションを ``FALSE`` に設定することにより、
正しくなくて古い振る舞いをまだ得られます。

.. code-block:: php
   :linenos:

   $trans = new Zend_Translator(
       'xliff', '/path/to/source', $locale, array('useId' => false)
   );

.. _migration.110.zend.validate:

Zend_Validate
-------------

.. _migration.110.zend.validate.selfwritten:

書かれたバリデータ自身
^^^^^^^^^^^

かかれたバリデータ自身の内部からエラーを返すよう設定するときは、 ``_error()``\
メソッドを呼ばなくてはいけません。 Zend Framework 1.10
以前では、パラメータを与えなくてもこのメソッドを呼び出せました。
そこで、最初に見つかったメッセージテンプレートを使いました。

この振る舞いには、一つ以上の異なるメッセージを返すバリデータを使うときに問題があります。
また、既存のバリデータを拡張すると、予期しない結果を得ることもあります。
このせいで、あなたが期待した通りではないメッセージにユーザーが遭遇することにもなりました。

.. code-block:: php
   :linenos:

   My_Validator extends Zend_Validate_Abstract
   {
       public isValid($value)
       {
           ...
           $this->_error(); // 異なるOS間での予期されない結果
           ...
       }
   }

この問題を防ぐために、 ``_error()``\
メソッドにパラメータを与えないで呼び出すことは、 もはやできなくなります。

.. code-block:: php
   :linenos:

   My_Validator extends Zend_Validate_Abstract
   {
       public isValid($value)
       {
           ...
           $this->_error(self::MY_ERROR); // 定義されたエラー、予期されない結果ではありません
           ...
       }
   }

.. _migration.110.zend.validate.datevalidator:

日付バリデータの簡略化
^^^^^^^^^^^

Zend Framework 1.10 以前では、同一の２つのメッセージが、
日付バリデータ内でスローされていました。 これらは、 ``NOT_YYYY_MM_DD``\ と
``FALSEFORMAT``\ でした。 Zend Framework 1.10 現在では、
与えられた日付が設定されたフォーマットに一致しない場合、 ``FALSEFORMAT``\
メッセージだけが返されます。

.. _migration.110.zend.validate.barcodevalidator:

Alpha、Alnum及びBarcodeバリデータの修正
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zend Framework 1.10 以前では、バーコード・アダプタ２種類と、 Alpha 及び Alnum
バリデータ内のメッセージが同一でした。 このため、カスタムのメッセージ、翻訳、
またはこれらのバリデータの複数のインスタンスを使うときに問題がありました。

Zend Framework 1.10 では、定数値は、一意であるように変更されました。
マニュアルで提案されたように定数を使ったときには、変更がありません。
しかし、コードで定数の内容を使ったときには、
それらを変更しなければなりません。 下記の表では変更された値を示します。

.. _migration.110.zend.validate.barcodevalidator.table:

.. table:: 利用可能なバリデータのメッセージ

   +---------------+--------------+------------------+
   |バリデータ          |定数            |値                 |
   +===============+==============+==================+
   |Alnum          |STRING_EMPTY  |alnumStringEmpty  |
   +---------------+--------------+------------------+
   |Alpha          |STRING_EMPTY  |alphaStringEmpty  |
   +---------------+--------------+------------------+
   |Barcode_Ean13  |INVALID       |ean13Invalid      |
   +---------------+--------------+------------------+
   |Barcode_Ean13  |INVALID_LENGTH|ean13InvalidLength|
   +---------------+--------------+------------------+
   |Barcode_UpcA   |INVALID       |upcaInvalid       |
   +---------------+--------------+------------------+
   |Barcode_UpcA   |INVALID_LENGTH|upcaInvalidLength |
   +---------------+--------------+------------------+
   |Digits         |STRING_EMPTY  |digitsStringEmpty |
   +---------------+--------------+------------------+


