.. _zend.search.lucene.searching:

Einen Index durchsuchen
=======================

.. _zend.search.lucene.searching.query_building:

Abfrage erstellen
-----------------

Es gibt zwei Arten, den Index zu durchsuchen. Die erste Methode verwendet den Query Parser, um eine Abfrage aus
einem String zu erstellen. Die zweite kann programmtechnisch eigene Abfragen über die ``Zend_Search_Lucene`` *API*
erstellen.

Vor der Verwendung des bereitgestellten Query Parsers, beachte bitte folgendes:



   . Wenn du deine Abfragestrings programmseitig erstellst und dann durch den Query Parser verarbeiten lässt,
     solltest du darüber nachdenken, deine Abfragen direkt mit der *API* für Abfragen zu erstellen. In anderen
     Worten, der Query Parser wurde für von Menschen eingegebene Texte und nicht für von Programmen erstellte
     Texte entwickelt.

   . Nicht in einzelne Tokens aufgeteilte Felder werden am besten direkt zu der Abfrage und nicht über den Query
     Parser hinzugefügt. Wenn die Feldwerte durch die Anwendung programmseitig erstellt werden, dann sollte dies
     für Abfrageklauseln dieses Felds ebenfalls geschehen. Ein Analysator, welche der Query Parser verwendet,
     wurde entwickelt, um von Menschen eingegebenen Text in Begriffe zu konvertieren. Durch Programme erstellte
     Werte wie Datumsangaben, Schlüsselwörter, usw. sollten mit der Abfrage *API* erstellt werden.

   . In einem Abfrageformular sollten generelle Textfelder den Query Parser verwenden. Alle anderen, wie z.B.
     Datumsbereiche, Schlüsselwörter, usw. werden besser direkt durch die *API* der Abfrage hinzugefügt. Ein
     Feld mit einem begrenzten Wertebereich, das durch ein Pulldown-Menü spezifiziert wird, sollte nicht einem
     Abfragestring hinzugefügt werden, der anschließend wieder geparst wird, sondern eher als eine TermQuery
     Klausel hinzugefügt werden.

   . Boolesche Abfragen erlauben es dem Programmierer zwei oder mehr Abfragen logisch in eine neue zu kombinieren.
     Deshalb ist dies der beste Weg, um zusätzliche Kriterien zu einer Benutzersuche hinzuzufügen, die durch den
     Abfragestring definiert wird.



Beide Arten verwenden die selbe Methode der *API*, um den Index zu durchsuchen:

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::open('/data/my_index');

   $index->find($query);

Die ``Zend_Search_Lucene::find()`` Methode ermittelt den Eingabetyp automatisch und verwendet den Query Parser, um
ein entsprechendes ``Zend_Search_Lucene_Search_Query`` Objekt aus einer Eingabe vom Typ String zu erstellen.

Es ist wichtig zu beachten, dass der Query Parser den Standard Analyzer verwendet, um verschiedene Teile des
Abfragestrings in Token aufzuteilen. Dadurch werden alle Umwandlungen, die auf einen indizierten Text ausgeführt
werden, auch für den Abfragestring ausgeführt.

Der Standardanalysator kann den Abfragestring, für die Unabhängigkeit von Groß- und Kleinschreibung, in
Kleinbuchstaben umwandeln, Stopwörter entfernen, und andere Umwandlungen durchführen.

Die *API* Methoden transformieren oder filtern Eingabebegriffe in keinem Fall. Das passt deshalb eher für
computergenerierte oder nicht geteilte Felder.

.. _zend.search.lucene.searching.query_building.parsing:

Parsen der Abfrage
^^^^^^^^^^^^^^^^^^

Die ``Zend_Search_Lucene_Search_QueryParser::parse()`` Methode kann verwendet werden um einen Abfrage String in ein
Abfrage Objekt zu parsen.

Dieses Abfrageobjekt kann in Abfrage erzeugenden *API* Methoden verwendet werden um von Benutzern eingegebene
Abfragen mit programmtechnisch erzeugten Abfragen zu kombinieren.

Aktuell ist das in einigen Fällen der einzige Weg um nach einem Wert innerhalb eines Feldes ohne Token zu suchen:

.. code-block:: php
   :linenos:

   $userQuery = Zend_Search_Lucene_Search_QueryParser::parse($queryStr);

   $pathTerm  = new Zend_Search_Lucene_Index_Term(
                        '/data/doc_dir/' . $filename, 'path'
                    );
   $pathQuery = new Zend_Search_Lucene_Search_Query_Term($pathTerm);

   $query = new Zend_Search_Lucene_Search_Query_Boolean();
   $query->addSubquery($userQuery, true /* required */);
   $query->addSubquery($pathQuery, true /* required */);

   $hits = $index->find($query);

Die ``Zend_Search_Lucene_Search_QueryParser::parse()`` Methode nimmt auch einen optionalen Encoding Parameter,
welche die Codierung des Abfrage Strings definieren kann:

.. code-block:: php
   :linenos:

   $userQuery = Zend_Search_Lucene_Search_QueryParser::parse($queryStr,
                                                             'iso-8859-5');

Wenn der Codierungs Parameter unterdrückt wurde, wird das aktuelle Gebietsschema verwendet.

Es ist auch möglich eine Standard Codierung für den Abfragestring mit der
``Zend_Search_Lucene_Search_QueryParser::setDefaultEncoding()`` Methode zu definieren:

.. code-block:: php
   :linenos:

   Zend_Search_Lucene_Search_QueryParser::setDefaultEncoding('iso-8859-5');
   ...
   $userQuery = Zend_Search_Lucene_Search_QueryParser::parse($queryStr);

``Zend_Search_Lucene_Search_QueryParser::getDefaultEncoding()`` gibt die aktuelle Standard Codierung des Abfrage
Strings zurück (leerer String bedeutet "aktuelles Gebietsschema").

.. _zend.search.lucene.searching.results:

Suchergebnisse
--------------

Das Suchergebnis ist ein Array mit ``Zend_Search_Lucene_Search_QueryHit`` Objekten. Jedes davon hat zwei
Eigenschaften: *$hit->id* ist eine Dokumentnummer innerhalb des Index und *$hit->score* ist ein Punktwert für den
Treffer im Suchergebnis. Das Ergebnis wird anhand der Punktwerte sortiert (absteigend von der besten Wertung).

Das ``Zend_Search_Lucene_Search_QueryHit`` Objekt beinhaltet zudem jedes Feld des ``Zend_Search_Lucene_Document``,
das bei der Suche gefunden wurde, als Eigenschaft des Treffers. Im folgenden Beispiel, wird ein Treffer mit zwei
Feldern des entsprechenden Dokuments zurückgegeben: Titel und Autor.

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::open('/data/my_index');

   $hits = $index->find($query);

   foreach ($hits as $hit) {
       echo $hit->score;
       echo $hit->title;
       echo $hit->author;
   }

Gespeicherte Felder werden immer in UTF-8 Kodierung zurückgegeben.

Optional kann das originale ``Zend_Search_Lucene_Document`` Objekt vom ``Zend_Search_Lucene_Search_QueryHit``
Objekt zurückgegeben werden. Du kannst gespeicherte Teile des Dokuments durch Verwendung der ``getDocument()``
Methode des Indexobjektes zurückerhalten und diese dann durch die ``getFieldValue()`` Methode abfragen:

.. code-block:: php
   :linenos:

   $index = Zend_Search_Lucene::open('/data/my_index');

   $hits = $index->find($query);
   foreach ($hits as $hit) {
       // Gibt Zend_Search_Lucene_Document Objekte für diesen Treffer zurück
       echo $document = $hit->getDocument();

       // Gibt ein Zend_Search_Lucene_Field Objekt von
       // Zend_Search_Lucene_Document zurück
       echo $document->getField('title');

       // Gibt den String Wert des Zend_Search_Lucene_Field Objektes zurück
       echo $document->getFieldValue('title');

       // Gleich wie getFieldValue()
       echo $document->title;
   }

Die Felder, die in einem ``Zend_Search_Lucene_Document`` Objekt verfügbar sind, werden beim Indizieren festgelegt.
Die Dokumentenfelder werden durch die Indizieranwendung (z.B. LuceneIndexCreation.jar) im Dokument entweder nur
indiziert oder indiziert und gespeichert.

Beachte, dass die Dokumentidentität ('path' in unserem Beispiel) auch im Index gespeichert wird und von ihm
zurückgewonnen werden muß.

.. _zend.search.lucene.searching.results-limiting:

Begrenzen des Ergebnissets
--------------------------

Der berechnungsintensivste Teil des Suchens ist die Berechnung der Treffer. Das kann für große Ergebnisse einige
Sekunden dauern (Zehntausende von Treffern)

``Zend_Search_Lucene`` bietet die Möglichkeit die Ergebnisse mit den ``getResultSetLimit()`` und
``setResultSetLimit()`` Methoden zu begrenzen:

.. code-block:: php
   :linenos:

   $currentResultSetLimit = Zend_Search_Lucene::getResultSetLimit();

   Zend_Search_Lucene::setResultSetLimit($newLimit);

Der Standardwert von 0 bedeutet 'keine Grenze'.

Es gibt nicht die 'besten N' Ergebnisse, sonder nur die 'ersten N'[#]_.

.. _zend.search.lucene.searching.results-scoring:

Ergebnisgewichtung
------------------

``Zend_Search_Lucene`` verwendet die selben Gewichtungsalgorithmen wie Java Lucene. Alle Treffer in den
Suchergebnisse werden standardmäßig nach einem Punktwert sortiert. Treffer mit höherem Punktwert kommen zuerst,
und Dokumente mit höherem Punktwert passen präziser auf die Abfrage als solche mit niedrigerem Punktwert.

Grob gesagt, haben die Suchergebnisse einen höheren Punktwert, welche den gesuchten Begriff oder die gesuchte
Phrase häufiger enthalten.

Der Punktwert kann über die *score* Eigenschaft des Treffers ermittelt werden:

.. code-block:: php
   :linenos:

   $hits = $index->find($query);

   foreach ($hits as $hit) {
       echo $hit->id;
       echo $hit->score;
   }

Die ``Zend_Search_Lucene_Search_Similarity`` Klasse wird verwendet, um den Punktwert für jeden Treffer zu
berechnen. Beachte den :ref:`Erweiterbarkeit. Algorithmen für Punktwertermittlung
<zend.search.lucene.extending.scoring>` Abschnitt für weitere Details.

.. _zend.search.lucene.searching.sorting:

Sortierung der Suchergebnisse
-----------------------------

Standardmäßig werden die Suchergebnisse nach dem Punktwert sortiert. Der Programmierer kann dieses Verhalten
durch das Setzen eines Sortierfeldes und der Parameter für die Sortierreihenfolge geändert werden.

*$index->find()* Aufruf kann verschiedene optionale Parameter entgegen nehmen:

.. code-block:: php
   :linenos:

   $index->find($query [, $sortField [, $sortType [, $sortOrder]]]
                       [, $sortField2 [, $sortType [, $sortOrder]]]
                ...);

Ein Name von gespeicherten Feldern nach denen Ergebnisse sortiert werden sollen sollte als ``$sortField`` Parameter
übergeben werden.

``$sortType`` kann ausgelassen werden oder die nachfolgenden Werte annehmen: ``SORT_REGULAR`` (vergleiche Items
normal - Standardwert), ``SORT_NUMERIC`` (vergleiche Items numerisch), ``SORT_STRING`` (vergleiche items als
Strings).

``$sortOrder`` kann ausgelassen werden oder die nachfolgenden Werte annehmen: ``SORT_ASC`` (sortiere in
aufsteigender Folge - Standardwert), ``SORT_DESC`` (sortiere in absteigender Folge).

Beispiele:

.. code-block:: php
   :linenos:

   $index->find($query, 'quantity', SORT_NUMERIC, SORT_DESC);

.. code-block:: php
   :linenos:

   $index->find($query, 'fname', SORT_STRING, 'lname', SORT_STRING);

.. code-block:: php
   :linenos:

   $index->find($query, 'name', SORT_STRING, 'quantity', SORT_NUMERIC, SORT_DESC);

Beim Verwenden von nicht standardmäßigen Sortierreihenfolgen sollte man vorsichtig sein; die Abfrage muß
Dokumente komplett vom Index empfangen werden, was die Geschwindigkeit der Suche dramatisch reduziert.

.. _zend.search.lucene.searching.highlighting:

Such Resultate hervorheben
--------------------------

``Zend_Search_Lucene`` bietet zwei Optionen für das Highlightinh von Suchergebnissen.

Die erste ist die Verwendung der *Zend_Search_Lucene_Document_Html* Klasse (siehe :ref:`das Kapitel über HTML
Dokumente <zend.search.lucene.index-creation.html-documents>` für Details) mit den folgenden Methoden:

.. code-block:: php
   :linenos:

   /**
    * Highlight text with specified color
    *
    * @param string|array $words
    * @param string $colour
    * @return string
    */
   public function highlight($words, $colour = '#66ffff');

.. code-block:: php
   :linenos:

   /**
    * Highlight text using specified View helper or callback function.
    *
    * @param string|array $words  Words to highlight. Words could be organized
                                  using the array or string.
    * @param callback $callback   Callback method, used to transform
                                  (highlighting) text.
    * @param array    $params     Array of additionall callback parameters passed
                                  through into it (first non-optional parameter
                                  is an HTML fragment for highlighting)
    * @return string
    * @throws Zend_Search_Lucene_Exception
    */
   public function highlightExtended($words, $callback, $params = array())

Um das Verhalten beim Highlighting zu verändern kann die ``highlightExtended()`` Methode mit einem spezifizierten
Callback verwendet werden, welche einen oder mehreren Parametern entgegennimmt [#]_, oder durch Erweiterung der
*Zend_Search_Lucene_Document_Html* Klasse und dem Anpassen der ``applyColour($stringToHighlight, $colour)`` Methode
die als Standardmäßiger Callback für das Highlighten verwendet wird. [#]_

:ref:`View Helfer <zend.view.helpers>` können auch als Callbacks im Kontext von View Skripten verwendet werden:

.. code-block:: php
   :linenos:

   $doc->highlightExtended('word1 word2 word3...', array($this, 'myViewHelper'));

Das Ergebnis der Highlighting Operation wird von der *Zend_Search_Lucene_Document_Html->getHTML()* Methode
empfangen.

.. note::

   Highlighting wird in den Ausdrücken des aktuellen Analysators durchgeführt. So werden alle Formen des
   Wortes/der Wörter vom Analysator erkannt und highgelighted.

   Z.B. wenn der aktuelle Analysator unabhängig von der Groß- oder Kleinschreibung ist und wir das Highlighten
   des Wortes 'text' anfragen, dann werden 'text', 'Text', 'TEXT' und alle anderen Kombinationen von Schreibweisen
   geHighlightet.

   Auf dem gleichen Weg wird, wenn der aktuelle Analysator Abstammung unterstützt und wir das Highlighten von
   'indexed' anfragen, dann werden 'index', 'indexing', 'indices' und andere Formen dieser Wörter geHighlighted.

   Wenn andererseits das Wort vom aktuellen Analysator übersprungen wird (z.B. wenn ein Filter für kurze Wörter
   dem Analysator angehängt ist), dann wird nichts geHighlighted.

Die zweite Option ist die Verwendung der *Zend_Search_Lucene_Search_Query->highlightMatches(string $inputHTML[,
$defaultEncoding = 'UTF-8'[, Zend_Search_Lucene_Search_Highlighter_Interface $highlighter]])* Methode:

.. code-block:: php
   :linenos:

   query = Zend_Search_Lucene_Search_QueryParser::parse($queryStr);
   highlightedHTML = $query->highlightMatches($sourceHTML);

Der optionale zweite Parameter ist die standardmäßige Kodierung des *HTML* Dokuments. Er wird verwendet wenn die
Kodierung nicht, durch die Verwendung des Content-type MetaTags HTTP-EQUIV, spezifiziert ist.

Der optionale dritte Parameter ist ein Highlighter Objekt welches das
``Zend_Search_Lucene_Search_Highlighter_Interface`` Interface implementiert:

.. code-block:: php
   :linenos:

   interface Zend_Search_Lucene_Search_Highlighter_Interface
   {
       /**
        * Set document for highlighting.
        *
        * @param Zend_Search_Lucene_Document_Html $document
        */
       public function setDocument(Zend_Search_Lucene_Document_Html $document);

       /**
        * Get document for highlighting.
        *
        * @return Zend_Search_Lucene_Document_Html $document
        */
       public function getDocument();

       /**
        * Highlight specified words (method is invoked once per subquery)
        *
        * @param string|array $words  Words to highlight. They could be
                                      organized using the array or string.
        */
       public function highlight($words);
   }

Wobei das *Zend_Search_Lucene_Document_Html* Objekt ein Objekt ist welches von der HMTL Quelle erzeugt wird, die
wiederum von der *Zend_Search_Lucene_Search_Query->highlightMatches()* Methode geliefert wird.

Wenn der ``$highlighter`` Parameter nicht angegeben wird, dann wird das
*Zend_Search_Lucene_Search_Highlighter_Default* Objekt initiiert und verwendet.

Die Highlighter Methode ``highlight()`` ist einmal pro SubQuery enthalten, deshalb hat sie für diese auch die
Möglichkeit das Highlightig zu unterscheiden.

Aktuell, macht der standardmäßige Highlighter das indem eine vordefinierte Farbtabelle durchlaufen wird. Man kann
also seinen eigenen Highlighter implementieren, oder den standardmäßigen nur erweitern und die Farbtabelle
umdefinieren.

*Zend_Search_Lucene_Search_Query->htmlFragmentHighlightMatches()* hat ein ähnliches Verhalten. Der einzige
Unterschied besteht darin das er eine Eingabe entgegen nimmt, und *HTML* Fragmente ohne die <>HTML>, <HEAD>, <BODY>
Tags zurückgibt. Trotzdem werden Fragmente automatisch in gültiges *XHTML* transformiert.



.. [#] Zurückgegebenen Ergebnisse werden trotzdem nach dem Treffer geordnet oder anhand der spezifizierten
       Reihenfolge, wenn diese angegeben wurde.
.. [#] Der erste ist ein *HTML* Fragment für das Highlighting und die anderen sind abhängig vom Verhalten des
       Callbacks. Der Rückgabewert ist ein highlighted *HTML* Fragment.
.. [#] In beiden Fällen wird das zurückgegebene *HTML* automatisch in gültiges *XHTML* transformiert.