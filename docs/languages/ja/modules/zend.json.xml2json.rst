.. _zend.json.xml2json:

XML から JSON への変換
================

``Zend_Json`` には、 *XML* 形式のデータを *JSON*
形式に変換するための便利なメソッドがあります。 この機能は `IBM developerWorks
の記事`_ に触発されて追加したものです。

``Zend_Json`` には、静的関数 ``Zend_Json::fromXml()`` が搭載されています。この関数は、 *XML*
を受け取って *JSON* を作成します。 入力パラメータには、任意の *XML*
文字列を渡すことができます。 また、オプションのパラメータで論理値を渡し、
変換処理中に *XML* の属性を無視するかどうかを指定できます。
このパラメータを省略した場合のデフォルトの挙動は、 *XML*
の属性を無視します。この関数の使用法は、以下のようになります。

.. code-block:: php
   :linenos:

   // fromXml 関数の入力には、XML を含む文字列を渡します
   $jsonContents = Zend_Json::fromXml($xmlStringContents, true);

``Zend_Json::fromXml()`` 関数は、 入力として渡された *XML* 形式の文字列を、 それと同等な
*JSON* 形式の文字列に変換して返します。 *XML*
の書式にエラーがあったり変換中にエラーが発生した場合は、
この関数は例外をスローします。 変換ロジックは、 *XML*
ツリーを再帰的に走査します。 最大で 25 段階までの再帰を行います。
それ以上の深さに達した場合は ``Zend_Json_Exception`` をスローします。Zend Framework の tests
ディレクトリ内には *XML* ファイルがいくつか入っているので、 それらを用いると
xml2json の機能を確かめることができます。

*XML* 入力文字列の例と、 ``Zend_Json::fromXml()`` 関数が返す *JSON*
文字列の例を次に示します。 この例では、オプションのパラメータで *XML*
の属性を無視しないように設定しています。 そのため、 *JSON* 文字列の中に *XML*
の属性の情報が含まれていることがわかるでしょう。

``Zend_Json::fromXml()`` 関数に渡す *XML* 入力文字列です。

.. code-block:: php
   :linenos:

   <?xml version="1.0" encoding="UTF-8"?>
   <books>
       <book id="1">
           <title>Code Generation in Action</title>
           <author><first>Jack</first><last>Herrington</last></author>
           <publisher>Manning</publisher>
       </book>

       <book id="2">
           <title>PHP Hacks</title>
           <author><first>Jack</first><last>Herrington</last></author>
           <publisher>O'Reilly</publisher>
       </book>

       <book id="3">
           <title>Podcasting Hacks</title>
           <author><first>Jack</first><last>Herrington</last></author>
           <publisher>O'Reilly</publisher>
       </book>
   </books>

``Zend_Json::fromXml()`` 関数が返す *JSON* 文字列です。

.. code-block:: php
   :linenos:

   {
      "books" : {
         "book" : [ {
            "@attributes" : {
               "id" : "1"
            },
            "title" : "Code Generation in Action",
            "author" : {
               "first" : "Jack", "last" : "Herrington"
            },
            "publisher" : "Manning"
         }, {
            "@attributes" : {
               "id" : "2"
            },
            "title" : "PHP Hacks", "author" : {
               "first" : "Jack", "last" : "Herrington"
            },
            "publisher" : "O'Reilly"
         }, {
            "@attributes" : {
               "id" : "3"
            },
            "title" : "Podcasting Hacks", "author" : {
               "first" : "Jack", "last" : "Herrington"
            },
            "publisher" : "O'Reilly"
         }
      ]}
   }

xml2json の機能についての詳細は、 `Zend_xml2json のプロポーザル`_ を参照ください。



.. _`IBM developerWorks の記事`: http://www.ibm.com/developerworks/xml/library/x-xml2jsonphp/
.. _`Zend_xml2json のプロポーザル`: http://tinyurl.com/2tfa8z
