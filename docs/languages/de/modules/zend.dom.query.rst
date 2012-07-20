.. _zend.dom.query:

Zend_Dom_Query
==============

``Zend_Dom_Query`` bietet einen Mechanismus für die Abfrage von *XML* und (X) *HTML* Dokumenten indem entweder
XPath oder *CSS* Selektoren verwendet werden. Sie wurde entwickelt um bei funktionalem Testen von *MVC* Anwendungen
zu helfen, könnte aber auch für schnelle Entwicklung von Screen Scraper verwendet werden.

Die *CSS* Selektor Schreibweise wird als einfacherer und für Web Entwickler bekannterer Weg angeboten um bei der
Anfrage von Dokumenten mit *XML* Strukturen zu helfen. Diese Schreibweise sollte jedem, der Cascading Style Sheets
entwickelt hat, bekannt sein, oder jedem, der Javascript Toolkits verwendet, die Funktionalität für das
Auswählen von Knoten bei der Anpassung von *CSS* Selektoren anbieten (`Prototype's $$()`_ und `Dojo's dojo.query`_
sind beides Inspirationen für diese Komponente).

.. _zend.dom.query.operation:

Theorie der Anwendung
---------------------

Um ``Zend_Dom_Query`` zu verwenden muß ein ``Zend_Dom_Query`` Objekt instanziert werden, optional kann ein zu
parsendes Dokument (ein String) übergeben werden. Sobald man ein Dokument hat, kann die ``query()`` oder die
``queryXpath()`` Methode verwendet werden; jede Methode gibt ein ``Zend_Dom_Query_Result`` Objekt mit allen
passenden Knoten zurück.

Der grundsätzliche Unterschied zwischen ``Zend_Dom_Query`` und der Verwendung von DOMDocument + DOMXPath ist die
Möglichkeit *CSS* Selektoren auszuwählen. Alle folgenden Elemente können in jeder Kombination verwendet werden:

- **Element Typen**: Bietet einen Elementtypen an, der zu den folgenden passt: 'div', 'a', 'span', 'h2', usw.

- **Stil Attribute**: *CSS* Stil Attribute passen zu folgenden: '``.error``', '``div.error``',
  '``label.required``', usw. Wenn ein Element mehr als einen Stil definiert, wird er entsprechen solange der
  benannte Stil irgendwo in der Stil Definition vorhanden ist.

- **Id Attribute**: ID Attribute von Elementen passen zu folgenden: '#content', 'div#nav', usw.

- **Andere Attribute**: Andere Attribute von Elementen die passen. Drei verschiedene Typen die passen werden
  angeboten:

  - **Exakte Entsprechung**: Das Attribute passt exakt zum String: 'div[bar="baz"]' würde zu einem Div Element mit
    einem "bar" Attribut passen das exakt den Wert "baz" enthält.

  - **Wort Entsprechung**: Das Attribut enthält ein Wort das dem String entspricht: 'div[bar~="baz"]' würde einem
    Div Element mit einem "bat" Attribut entsprechen, dass das Wort "baz" enthält. '<div bar="foo baz">' würde
    passen, aber '<div bar="foo bazbat">' würde nicht entsprechen.

  - **Substring Entsprechung**: Das Attribut enthält den String: 'div[bar*="baz"]' würde einem Div Element mit
    einem "bar" Attribut entsprechen, das den String "baz" irgendwo darin enthält.

- **Direkt abhängig**: Verwende '>' zwischen Selektoren um direkte Abhängigkeit auszudrücken. 'div > span'
  würde nur 'span' Elemente auswählen, die direkt von 'div' abhängig sind. Kann auch mit jedem Selektor darüber
  verwendet werden.

- **Abhängigkeit**: Verknüpfung mehrerer Selektoren, um eine Hierarchie zwischen Ihnen auszudrücken nach welcher
  gesucht werden soll. '``div .foo span #one``' würde ein Element mit der Id 'one' auswählen, das abhängig ist,
  in einer beliebigen Tiefe unter einem 'span' Element, welches seinerseits in einer beliebigen Tiefe darunter von
  einer Klasse von 'foo' abhängig ist, welche in einer beliebigen Tiefe von einem 'div' Element abhängig ist. Der
  Link zum Wort 'One' im Beispiel anbei würde passen:

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

Wenn man eine Abfrage ausgeführt hat, kann man mit dem Ergebnis Objekt arbeiten um Informationen über die Knoten
zu bekommen, sowie um Sie und/oder Ihren Inhalt direkt für die Extrahierung und Manipulation herauszuholen.
``Zend_Dom_Query_Result`` implementiert ``Countable`` und ``Iterator`` und speichert die Ergebnisse intern als
DOMNodes und DOMElements. Als Beispiel nehmen wir erstmal den folgenden Aufruf an der das obige *HTML* auswählt:

.. code-block:: php
   :linenos:

   $dom = new Zend_Dom_Query($html);
   $results = $dom->query('.foo .bar a');

   $count = count($results); // Gib die Anzahl an Gefundenen Nodes zurück: 4
   foreach ($results as $result) {
       // $result ist ein DOMElement
   }

``Zend_Dom_Query`` erlaubt auch strenge XPath Abfragen durch Verwendung der ``queryXpath()`` Methode; man kann eine
gültige XPath Abfrage an diese Methode übergeben, und Sie wird ein ``Zend_Dom_Query_Result`` Objekt zurückgeben.

.. _zend.dom.query.methods:

Vorhandene Methoden
-------------------

Die ``Zend_Dom_Query`` Familie an Klassen enthält die folgenden Methoden.

.. _zend.dom.query.methods.zenddomquery:

Zend_Dom_Query
^^^^^^^^^^^^^^

Die folgenden Methoden sind in ``Zend_Dom_Query`` vorhanden:

- ``setDocumentXml($document)``: Spezifiziert einen *XML* String der abgefragt werden soll.

- ``setDocumentXhtml($document)``: Spezifiziert einen *XHTML* String der abgefragt werden soll.

- ``setDocumentHtml($document)``: Spezifiziert einen *HTML* String der abgefragt werden soll.

- ``setDocument($document)``: Spezifiziert einen String der abgefragt werden soll; ``Zend_Dom_Query`` wird
  anschließend versuchen den Typ des Dokument automatisch herauszufinden.

- ``getDocument()``: Empfängt den String des Original Dokuments welches an das Objekt übergeben wurde.

- ``getDocumentType()``: Empfängt den Typ des Dokuments das dem Objekt übergeben wurde; das wird eine der
  Klassenkonstanten ``DOC_XML``, ``DOC_XHTML``, oder ``DOC_HTML`` sein.

- ``query($query)``: Abfrage des Dokuments bei Verwendung der *CSS* Selektor Schreibweise.

- ``queryXpath($xPathQuery)``: Abfrage des Dokuments bei Verwendung der XPath Schreibweise.

.. _zend.dom.query.methods.zenddomqueryresult:

Zend_Dom_Query_Result
^^^^^^^^^^^^^^^^^^^^^

Wie vorher erwähnt, implementiert ``Zend_Dom_Query_Result`` beide, ``Iterator`` und ``Countable``, und kann
deswegen in einer ``foreach()`` Schleife verwendet werden wie auch mit der ``count()`` Funktion. Zusätzlich bietet
es die folgenden Methoden an:

- ``getCssQuery()``: Gibt die *CSS* Selektor Abfrage zurück, die für die Erstellung des Ergebnisses verwendet
  wurde (wenn vorhanden).

- ``getXpathQuery()``: Gibt die XPath Abfrage zurück die für die Erstellung des Ergebnisses verwendet wurde.
  Intern konvertiert ``Zend_Dom_Query`` *CSS* Selektor Abfragen zu XPath, so das dieser Wert immer angeboten wird.

- ``getDocument()``: Empfängt das DOMDocument auf das die Abfrage ausgeführt wurde.



.. _`Prototype's $$()`: http://prototypejs.org/api/utility/dollar-dollar
.. _`Dojo's dojo.query`: http://api.dojotoolkit.org/jsdoc/dojo/HEAD/dojo.query
