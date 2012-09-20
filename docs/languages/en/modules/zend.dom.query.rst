.. _zend.dom.query:

Zend\\Dom\\Query
================

``Zend\Dom\Query`` provides mechanisms for querying *XML* and (X) *HTML* documents utilizing either XPath or *CSS*
selectors. It was developed to aid with functional testing of *MVC* applications, but could also be used for rapid
development of screen scrapers.

*CSS* selector notation is provided as a simpler and more familiar notation for web developers to utilize when
querying documents with *XML* structures. The notation should be familiar to anybody who has developed Cascading
Style Sheets or who utilizes Javascript toolkits that provide functionality for selecting nodes utilizing *CSS*
selectors (`Prototype's $$()`_ and `Dojo's dojo.query`_ were both inspirations for the component).

.. _zend.dom.query.operation:

Theory of Operation
-------------------

To use ``Zend\Dom\Query``, you instantiate a ``Zend\Dom\Query`` object, optionally passing a document to query (a
string). Once you have a document, you can use either the ``query()`` or ``queryXpath()`` methods; each method will
return a ``Zend\Dom\NodeList`` object with any matching nodes.

The primary difference between ``Zend\Dom\Query`` and using `DOMDocument`_ + `DOMXPath`_ is the ability to select
against *CSS* selectors. You can utilize any of the following, in any combination:

- **element types**: provide an element type to match: 'div', 'a', 'span', 'h2', etc.

- **style attributes**: *CSS* style attributes to match: '``.error``', '``div.error``', '``label.required``', etc.
  If an element defines more than one style, this will match as long as the named style is present anywhere in the
  style declaration.

- **id attributes**: element ID attributes to match: '#content', 'div#nav', etc.

- **arbitrary attributes**: arbitrary element attributes to match. Three different types of matching are provided:

  - **exact match**: the attribute exactly matches the string: 'div[bar="baz"]' would match a div element with a
    "bar" attribute that exactly matches the value "baz".

  - **word match**: the attribute contains a word matching the string: 'div[bar~="baz"]' would match a div element
    with a "bar" attribute that contains the word "baz". '<div bar="foo baz">' would match, but '<div bar="foo
    bazbat">' would not.

  - **substring match**: the attribute contains the string: 'div[bar*="baz"]' would match a div element with a
    "bar" attribute that contains the string "baz" anywhere within it.

- **direct descendents**: utilize '>' between selectors to denote direct descendents. 'div > span' would select
  only 'span' elements that are direct descendents of a 'div'. Can also be used with any of the selectors above.

- **descendents**: string together multiple selectors to indicate a hierarchy along which to search. '``div .foo
  span #one``' would select an element of id 'one' that is a descendent of arbitrary depth beneath a 'span'
  element, which is in turn a descendent of arbitrary depth beneath an element with a class of 'foo', that is an
  descendent of arbitrary depth beneath a 'div' element. For example, it would match the link to the word 'One' in
  the listing below:

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

Once you've performed your query, you can then work with the result object to determine information about the
nodes, as well as to pull them and/or their content directly for examination and manipulation.
``Zend\Dom\NodeList`` implements ``Countable`` and ``Iterator``, and stores the results internally as a
`DOMDocument`_ and `DOMNodeList`_. As an example, consider the following call, that selects against the *HTML*
above:

.. code-block:: php
   :linenos:

   use Zend\Dom\Query;

   $dom = new Query($html);
   $results = $dom->execute('.foo .bar a');

   $count = count($results); // get number of matches: 4
   foreach ($results as $result) {
       // $result is a DOMElement
   }

``Zend\Dom\Query`` also allows straight XPath queries utilizing the ``queryXpath()`` method; you can pass any valid
XPath query to this method, and it will return a ``Zend\Dom\NodeList`` object.

.. _zend.dom.query.methods:

Methods Available
-----------------

The ``Zend\Dom\Query`` family of classes have the following methods available.

.. _zend.dom.query.methods.zenddomquery:

Zend\\Dom\\Query
^^^^^^^^^^^^^^^^

The following methods are available to ``Zend\Dom\Query``:

- ``setDocumentXml($document, $encoding = null)``: specify an *XML* string to query against.

- ``setDocumentXhtml($document, $encoding = null)``: specify an *XHTML* string to query against.

- ``setDocumentHtml($document, $encoding = null)``: specify an *HTML* string to query against.

- ``setDocument($document, $encoding = null)``: specify a string to query against; ``Zend\Dom\Query`` will then
  attempt to autodetect the document type.

- ``setEncoding($encoding)``: specify an encoding string to use. This encoding will be passed to `DOMDocument's
  constructor`_ if specified.

- ``getDocument()``: retrieve the original document string provided to the object.

- ``getDocumentType()``: retrieve the document type of the document provided to the object; will be one of the
  ``DOC_XML``, ``DOC_XHTML``, or ``DOC_HTML`` class constants.

- ``getEncoding()``: retrieves the specified encoding.

- ``execute($query)``: query the document using *CSS* selector notation.

- ``queryXpath($xPathQuery)``: query the document using XPath notation.

.. _zend.dom.query.methods.zenddomnodelist:

Zend\\Dom\\NodeList
^^^^^^^^^^^^^^^^^^^

As mentioned previously, ``Zend\Dom\NodeList`` implements both ``Iterator`` and ``Countable``, and as such can be
used in a ``foreach()`` loop as well as with the ``count()`` function. Additionally, it exposes the following
methods:

- ``getCssQuery()``: return the *CSS* selector query used to produce the result (if any).

- ``getXpathQuery()``: return the XPath query used to produce the result. Internally, ``Zend\Dom\Query`` converts
  *CSS* selector queries to XPath, so this value will always be populated.

- ``getDocument()``: retrieve the DOMDocument the selection was made against.



.. _`Prototype's $$()`: http://prototypejs.org/api/utility/dollar-dollar
.. _`Dojo's dojo.query`: http://api.dojotoolkit.org/jsdoc/dojo/HEAD/dojo.query
.. _`DOMDocument`: http://php.net/domdocument
.. _`DOMXPath`: http://php.net/domxpath
.. _`DOMNodeList`: http://php.net/domnodelist
.. _`DOMDocument's constructor`: http://php.net/domdocument.construct
