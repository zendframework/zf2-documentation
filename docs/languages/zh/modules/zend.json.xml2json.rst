.. _zend.json.xml2json:

XML 到 JSON 转换
===================

提供了方便的方法来转换数据格式从 XML 到 JSON。这个功能从一篇 `IBM developerWorks 文章`_
的到启发。

*Zend_Json* 包括一个叫做 *Zend_Json::fromXml()* 的静态方法，它将从给定的 XML 的输入生成
JSON。它用任何任意的 XML
字符串作为输入参数；它也带有一个可选的布尔输入参数来指示转换逻辑在转换过程中是否忽略
XML 属性，如果没有给出这个参数，那么缺省的行为就是忽略 XML
属性。本函数的调用示范如下：

.. code-block::
   :linenos:

           // fromXml function simply takes a String containing XML contents as input.
           $jsonContents = Zend_Json::fromXml($xmlStringContents, true);?>

*Zend_Json::fromXml()* 函数执行 XML 格式的字符串输入和返回等同的 JSON
格式字符串的输出的转换，如果有任何 XML
输入格式错误或者转换逻辑错误，它将抛出一个异常。转换逻辑也使用递归技术来遍历
XML 树，它支持 25 级递归，如果递归超过这个深度，它将抛出一个 *Zend_Json_Exception* 。在
Zend Framework 的测试目录里有若干不同复杂度的 XML 文件，可用来测试 xml2json 功能。

下面一个简单的例子来示例被传递的 XML 输入字符串和从 *Zend_Json::fromXml()* 函数返回的
JSON 字符串。本例使用可选的参数控制在转换过程中不忽略 XML
属性，因此，你会注意到在 JSON 结果字符串中包含了在 XML 输入字符串中的 XML
属性的表达。

XML 输入字符串传递给 *Zend_Json::fromXml()* 函数：

.. code-block::
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
   </books> ?>

从 *Zend_Json::fromXml()* 函数返回的 JSON 输出字符串:

.. code-block::
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
   }  ?>

关于 xml2json 特性的更多信息和以从它自己原始的提案中找到： `Zend_xml2json 提案`_\ 。



.. _`IBM developerWorks 文章`: http://www.ibm.com/developerworks/xml/library/x-xml2jsonphp/
.. _`Zend_xml2json 提案`: http://tinyurl.com/2tfa8z
