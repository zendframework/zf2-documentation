.. _zend.dom.query:

Zend_Dom_Query
==============

*Zend_Dom_Query* 为利用 XPath 或 CSS 选择器来查询 XML 和 (X)HTML 文档提供了机制。 它为帮助
MVC 应用的功能测试而开发，但也用于 screen scrapers 的快速开发。

当用 XML 结构查询文档时，对于 web 开发者来说，CSS 选择器符号简单而熟悉。 对开发过
Cascading Style Sheets 或用过提供使用 CSS 选择器 （ `Prototype's $$()`_ 和 `Dojo's dojo.query`_
都是组件的灵魂）选择节点的功能的 Javascript 工具箱的开发者来说，符号应当很熟悉。

.. _zend.dom.query.operation:

操作理论
----

要使用 *Zend_Dom_Query*\ ，你需要初始化一个 *Zend_Dom_Query*
对象，并可选地传递一个文档到查询（一字符串）。 一旦你有一个文档，可以使用
*query()* 或 *queryXpath()* 方法； 每个方法将返回带有任何匹配节点的 *Zend_Dom_Query_Result*
对象。

*Zend_Dom_Query* 和使用 DOMDocument + DOMXPath 的主要不同之处是可以依靠 CSS 选择器来选择。
你可以使用下列的任何组合：

- **element types**: 提供一个元素类型来匹配： 'div'、 'a'、 'span'、 'h2' 等。

- **style attributes**: 匹配 '.error'、 'div.error'、 'label.required' 等的 CSS 风格属性。
  如果任何元素定义了超过一个风格，只要命名的风格出现在风格声明的任何地方，它将匹配。

- **id attributes**: 匹配 '#content'、 'div#nav' 等的元素 ID 属性。

- **arbitrary attributes**: 用于匹配的属性元素的属性。 有三个不同的匹配类型：

  - **exact match**: 属性和字符串精确地匹配： 'div[bar="baz"]' 表示带有 "bar" 属性的 div
    元素精确地匹配值 "baz"。

  - **word match**: 包含匹配字符串 'div[bar~="baz"]' 的字符的 属性将匹配一个带有包含
    "baz"字符的 "bar"属性的 div 元素。 '<div bar="foo baz">' 匹配，而'<div bar="foo
    bazbat">'不匹配。

  - **substring match**: 包含 'div[bar*="baz"]' 字符串的属性将匹配一个带有在它内部
    任何地方包含字符串 "baz" 的 "bar" 属性的 div 元素。

- **direct descendents**: 利用在选择器之间的 '>'表示直接的子孙。'div > span'将只选择
  'div'直接的子孙 'span' 元素。 它可用于任何上述的选择器。

- **descendents**: 把多个选择器集中成一字符串来表示一个搜索的层次。 'div .foo span #one'
  选择一个 id 'one' 的元素，它是在 'span' 元素下任意深度的子孙， 它也是 'foo'
  类下面任意深度的子孙，而 'foo' 元素是 'div' 元素下任意深度的子孙。
  例如，在下面列表中，它将匹配带有 'One' 字符的链接：

  .. code-block::
     :linenos:

     <div>
         <table>
             <tr>
                 <td class="foo">
                     <div>
                         Lorem ipsum <span class="bar">
                             <a href="/foo/bar" id="one">One</a>
                             <a href="/foo/baz" id="two">Two</a>
                             <a href="/foo/bat" id="three">Three</a>
                             <a href="/foo/bla" id="four">Four</a>
                         </span>
                     </div>
                 </td>
             </tr>
         </table>
     </div>


一旦你执行了查询，你可以使用结果对象来确定节点的信息，同时，你也可以
把它们和/或它们的内容拿出来检查和处理。 *Zend_Dom_Query_Result* 实现 *Countable* 和
*Iterator* 并在内部存储结果为 DOMNodes/DOMElements。
作为例子，考虑下列的调用，它依靠上述的 HTML 来选择：

.. code-block::
   :linenos:

   $dom = new Zend_Dom_Query($html);
   $results = $dom->query('.foo .bar a');

   $count = count($results); // get number of matches: 4
   foreach ($results as $result) {
       // $result is a DOMElement
   }


*Zend_Dom_Query* 也允许利用 *queryXpath()* method 直接 XPath 查询； 你可以传递任何有效的 XPath
查询给这个方法，它将返回一个 *Zend_Dom_Query_Result* 对象。

.. _zend.dom.query.methods:

可用方法
----

*Zend_Dom_Query* 类家族有下列方法可用。

.. _zend.dom.query.methods.zenddomquery:

Zend_Dom_Query
^^^^^^^^^^^^^^

下列方法对 *Zend_Dom_Query* 可用:

- *setDocumentXml($document)*: 指定一个查询使用的 XML 字符串。

- *setDocumentXhtml($document)*: 指定一个查询使用的 XHTML 字符串。

- *setDocumentHtml($document)*: 指定一个查询使用的 HTML 字符串。

- *setDocument($document)*: 指定一个查询使用的字符串； *Zend_Dom_Query*
  将尝试自动检查文档类型。

- *getDocument()*: 获取提供给对象的原始文档字符串。

- *getDocumentType()*: 获取提供给对象的文档的类型；是 *DOC_XML*\ 、 *DOC_XHTML* 或 *DOC_HTML*
  类常量其中之一。

- *query($query)*: 使用 CSS 选择器符号查询文档。

- *queryXpath($xPathQuery)*: 使用 XPath 符号查询文档。

.. _zend.dom.query.methods.zenddomqueryresult:

Zend_Dom_Query_Result
^^^^^^^^^^^^^^^^^^^^^

如前所述， *Zend_Dom_Query_Result* 实现 *Iterator* 和 *Countable*\ ， 可用于 *foreach* 循环和
*count()* 函数。 另外，它有下列方法：

- *getCssQuery()*: 返回用于处理结果（如果有的话）的 CSS 选择器查询。

- *getXpathQuery()*: 返回用于处理结果的 XPath 查询。 在内部， *Zend_Dom_Query* 转换 CSS
  选择器查选为 XPath，所以这个值将永远被组装。

- *getDocument()*: 获取选择使用的文档。



.. _`Prototype's $$()`: http://prototypejs.org/api/utility/dollar-dollar
.. _`Dojo's dojo.query`: http://api.dojotoolkit.org/jsdoc/dojo/HEAD/dojo.query
