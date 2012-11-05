.. EN-Revision: none
.. _zend.dom.query:

Zend\Dom\Query
==============

``Zend\Dom\Query`` を使用すると、 *XML* や (X) *HTML* ドキュメントに対して XPath あるいは
*CSS* セレクタを用いた問い合わせができるようになります。 *MVC*
アプリケーションの機能テストを支援するために作られたものですが、
スクリーンスクレイパーを手早く作成するためにも使うことができます。

*CSS* セレクタ記法は、ウェブ開発者にとってはシンプルでなじみのある記法です。
*XML* 構造のドキュメントに対する問い合わせに使用できます。
この記法は、スタイルシートを扱ったことのある人ならきっとおなじみでしょうし、
Javascript のツールキットの中にも *CSS*
セレクタを使用してノードを選択できる機能を持つものがあります (`Prototype の $$()`_
や `Dojo の dojo.query`_ をヒントにしてこのコンポーネントを作成しました)。

.. _zend.dom.query.operation:

動作原理
----

``Zend\Dom\Query`` を使用するには、 ``Zend\Dom\Query``
オブジェクトのインスタンスを作成します。 その際に、問い合わせたいドキュメント
(文字列) をオプションで渡すことができます。 ドキュメントを用意すれば、 ``query()``
メソッドあるいは ``queryXpath()`` メソッドを使用できます。どちらのメソッドも、
マッチしたノードを含む ``Zend\Dom_Query\Result`` オブジェクトを返します。

``Zend\Dom\Query`` を使うことと DOMDocument + DOMXPath を使うことの最大の違いは、 *CSS*
セレクタによる選択が可能かどうかということです。
以下の内容を、任意の組み合わせで使用できます。

- **要素型**: マッチさせたい要素の型を指定します。 'div', 'a', 'span', 'h2' などです。

- **style 属性**: マッチさせたい *CSS* style 属性を指定します。'``.error``', '``div.error``',
  '``label.required``' などです。ひとつの要素に複数のスタイルが定義されている場合は
  指定したスタイルがスタイル宣言のどこかに存在すればマッチします。

- **id 属性**: マッチさせたい要素 ID 属性を指定します。 '#content', 'div#nav' などです。

- **任意の属性**: マッチさせたい任意の要素属性を指定します。 以下の 3
  種類のマッチ形式を用意しています。

  - **完全マッチ**: その文字列に完全にマッチする属性。 'div[bar="baz"]' は、"bar"
    属性の値が正確に "baz" と一致する div 要素にマッチします。

  - **単語マッチ**: 指定した文字列に一致する単語を含む属性。 'div[bar~="baz"]' は、"bar"
    属性の値に単語 "baz" を含む div 要素にマッチします。 '<div bar="foo baz">'
    はマッチしますが、 '<div bar="foo bazbat">' はマッチしません。

  - **部分文字列マッチ**: その文字列を含む属性。'div[bar*="baz"]' は、 "bar"
    属性の値のどこかに文字列 "baz" を含む div 要素にマッチします。

- **直接の子孫**: セレクタの間で '>' を使用すると、
  直接の子要素であることを表します。'div > span' は、'span' 要素のうち 'div'
  の直接の子であるものだけを選択します。
  上のセレクタのどれとでも共用できます。

- **子孫**: 複数のセレクタをひとつの文字列にまとめると、
  探す階層を指定できます。 '``div .foo span #one``' が探すのは id が 'one'
  である要素です。その要素は、'span' 要素の子孫 (その間の階層の数は問わない)
  であり、 さらにその 'span' 要素はクラス 'foo' の要素の子孫
  (その間の階層の数は問わない) です。 同様に、そのクラス 'foo' の要素は 'div'
  要素の子孫 (その間の階層の数は問わない) となります。
  これは、たとえば以下のリストにおける単語 'One' へのリンクにマッチします。

  .. code-block:: html
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

問い合わせを実行したら、その結果のオブジェクトを用いてノードの情報を取得したり、
そのノード (あるいはノードの内容) を取り出して操作したりできます。
``Zend\Dom_Query\Result`` は ``Countable`` と ``Iterator`` を実装しており、内部では結果を DOMNodes
および DOMElements で保持しています。 たとえば、次のようなコードを上の *HTML*
に対して実行することを考えてみましょう。

.. code-block:: php
   :linenos:

   $dom = new Zend\Dom\Query($html);
   $results = $dom->query('.foo .bar a');

   $count = count($results); // マッチした数: 4
   foreach ($results as $result) {
       // $result は DOMElement です
   }

``Zend\Dom\Query`` では、 ``queryXpath()`` メソッドで XPath
クエリを直接使用することもできます。 XPath
クエリとして正しいものならなんでもこのメソッドに渡すことができ、 結果は
``Zend\Dom_Query\Result`` オブジェクトで返されます。

.. _zend.dom.query.methods:

使用可能なメソッド
---------

``Zend\Dom\Query`` 系のクラスでは、次のメソッドが使用できます。

.. _zend.dom.query.methods.zenddomquery:

Zend\Dom\Query
^^^^^^^^^^^^^^

次のメソッドが ``Zend\Dom\Query`` で使用できます。

- ``setDocumentXml($document)``: 対象となる *XML* 文字列を指定します。

- ``setDocumentXhtml($document)``: 対象となる *XHTML* 文字列を指定します。

- ``setDocumentHtml($document)``: 対象となる *HTML* 文字列を指定します。

- ``setDocument($document)``: 対象となる文字列を指定します。 ``Zend\Dom\Query``
  がドキュメントの形式を自動判定します。

- ``getDocument()``: オブジェクトに渡した元の文字列を取得します。

- ``getDocumentType()``: オブジェクトに渡したドキュメントの形式を取得します。
  クラス定数 ``DOC_XML``\ 、 ``DOC_XHTML`` あるいは ``DOC_HTML`` のいずれかとなります。

- ``query($query)``: *CSS* セレクタ記法でドキュメントへの問い合わせを行います。

- ``queryXpath($xPathQuery)``: XPath 記法でドキュメントへの問い合わせを行います。

.. _zend.dom.query.methods.zenddomqueryresult:

Zend\Dom_Query\Result
^^^^^^^^^^^^^^^^^^^^^

先ほど説明したように、 ``Zend\Dom_Query\Result`` は ``Iterator`` と ``Countable``
を実装しており、 ``foreach`` ループで使用したり ``count()``
関数を利用したりできます。 さらに、次のメソッドを公開しています。

- ``getCssQuery()``: その結果を得る元となった *CSS* セレクタクエリを (もし存在すれば)
  返します。

- ``getXpathQuery()``: その結果を得る元となった XPath クエリを返します。 内部的には、
  ``Zend\Dom\Query`` は *CSS* セレクタクエリを XPath に変換しています。
  そのため、このメソッドは常に結果を返します。

- ``getDocument()``: 問い合わせ対象となった DOMDocument を取得します。



.. _`Prototype の $$()`: http://prototypejs.org/api/utility/dollar-dollar
.. _`Dojo の dojo.query`: http://api.dojotoolkit.org/jsdoc/dojo/HEAD/dojo.query
