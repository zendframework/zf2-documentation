.. _zend.search.lucene.query-api:

Abfrage Erzeugungs API
======================

Zusätzlich zum automatischen Analysieren vom Abfragen ist es auch möglich diese durch eine *API* zu erzeugen.

Benutzerabfragen können mit Abfragen die durch die *API* erstellte wurden kombiniert werden. Einfach den
Abfrageparser verwenden um eine Abfrage von einem String zu erstellen:

.. code-block:: php
   :linenos:

   $query = Zend_Search_Lucene_Search_QueryParser::parse($queryString);

.. _zend.search.lucene.queries.exceptions:

Abfrageparser Ausnahmen
-----------------------

Der Abfrageparser kann zwei Typen von Ausnahmen erstellen.



   - ``Zend_Search_Lucene_Exception`` wird geworfen wenn irgendwas im Abfrageparser selbst falsch läuft.

   - ``Zend_Search_Lucene_Search_QueryParserException`` wird geworfen wenn ein Fehler im Syntax der Abfrage ist.

Es ist eine gute Idee die ``Zend_Search_Lucene_Search_QueryParserException``\ s abzufangen und richtig
abzuarbeiten:

.. code-block:: php
   :linenos:

   try {
       $query = Zend_Search_Lucene_Search_QueryParser::parse($queryString);
   } catch (Zend_Search_Lucene_Search_QueryParserException $e) {
       echo "Abfrage Syntax Fehler: " . $e->getMessage() . "\n";
   }

Die selbe Technik sollte für die find() Methode des ``Zend_Search_Lucene`` Objektes verwendet werden.

Beginnend mit 1.5 werden Abfrageparser Exceptions standardmäßig unterdrückt. Wenn eine Abfrage nicht konform mit
der Abfragesprache ist, dann wird Sie mithilfe des aktuellen Standardanalysators gestückelt und alle
Begriffsstücke werden für die Suche verwendet. Die
``Zend_Search_Lucene_Search_QueryParser::dontSuppressQueryParsingExceptions()`` Methode kann verwendet werden um
Exceptions einzuschalten. Die ``Zend_Search_Lucene_Search_QueryParser::suppressQueryParsingExceptions()`` und
``Zend_Search_Lucene_Search_QueryParser::queryParsingExceptionsSuppressed()`` Methoden sind auch dazu gedacht das
Verhalten der Exceptionsbehandlung zu verwalten.

.. _zend.search.lucene.queries.term-query:

Begriffsabfrage
---------------

Begriffsabfragen können für das Suchen mit einem einzelnen Begriff verwendet werden.

Abfragestring:

.. code-block:: text
   :linenos:

   word1

oder

Aufbau der Abfrage mit der *API*:

.. code-block:: php
   :linenos:

   $term  = new Zend_Search_Lucene_Index_Term('word1', 'field1');
   $query = new Zend_Search_Lucene_Search_Query_Term($term);
   $hits  = $index->find($query);

Das Term Feld ist optional. ``Zend_Search_Lucene`` durchsucht alle indizierten Felder in jedem Dokument wenn das
Feld nicht spezifiziert wurde:

.. code-block:: php
   :linenos:

   // Sucht nach 'word1' in allen indizierten Feldern
   $term  = new Zend_Search_Lucene_Index_Term('wort1');
   $query = new Zend_Search_Lucene_Search_Query_Term($term);
   $hits  = $index->find($query);

.. _zend.search.lucene.queries.multiterm-query:

Mehrfache Begriffsabfrage
-------------------------

Mehrfache Begriffsabfragen sind für Suchen mit einem Satz von Begriffen gedacht.

Jeder Begriff dieses Satzes kann als **required** (notwendig), **prohibited** (verboten) oder **neither** (weder
noch) definiert werden.



   - **required** bedeutet, dass Dokumente, die diesen Begriff nicht enthalten, nicht der Abfrage entsprechen;

   - **prohibited** bedeutet, dass Dokumente, die diesen Begriff enthalten, nicht der Abfrage entsprechen;

   - **neither**, in welchem Fall Dokumenten den Begriff weder nicht enthalten dürfen, noch den Begriff enthalten
     müssen. Nichtsdestrotrotz muß ein Dokument mindestens einem Begriff entsprechen, um der Abfrage zu
     entsprechen.



Wenn einer Abfrage mit notwendigen Begriffen optionale Betriffe hinzugefügt werden, werden beide Abfragen das
gleiche Set an Ergebnissen haben, aber der optionale Begriff kann die Bewertung der passenden Dokumente
beeinflussen.

Beide Suchmethoden können für Mehrfache Begriffsabfragen verwendet werden.

Abfragestring:

.. code-block:: text
   :linenos:

   +word1 author:word2 -word3

- '+' wird für notwendige Begriffe verwendet.

- '-' wird für verbotene Begriffe verwendet.

- Der 'field:' Präfix wird für die Angabe des Dokumentenfelds für die Suche verwendet. Wenn er weggelassen wird,
  werden alle Felder durchsucht.

oder

Aufbau der Abfrage mit der *API*:

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_MultiTerm();

   $query->addTerm(new Zend_Search_Lucene_Index_Term('word1'), true);
   $query->addTerm(new Zend_Search_Lucene_Index_Term('word2', 'author'),
                   null);
   $query->addTerm(new Zend_Search_Lucene_Index_Term('word3'), false);

   $hits  = $index->find($query);

Es ist auch möglich Begriffslisten in einem MultiTerm Anfrage Konstruktor zu spezifizieren:

.. code-block:: php
   :linenos:

   $terms = array(new Zend_Search_Lucene_Index_Term('word1'),
                  new Zend_Search_Lucene_Index_Term('word2', 'author'),
                  new Zend_Search_Lucene_Index_Term('word3'));
   $signs = array(true, null, false);

   $query = new Zend_Search_Lucene_Search_Query_MultiTerm($terms, $signs);

   $hits  = $index->find($query);

Das ``$signs`` Array enthält Informationen über den Begriffstyp:



   - ``TRUE`` wird für notwendige Begriffe verwendet.

   - ``FALSE`` wird für verbotene Begriffe verwendet.

   - ``NULL`` wird für weder notwendige noch verbotene Begriffe verwendet.



.. _zend.search.lucene.queries.boolean-query:

Boolsche Abfragen
-----------------

Boolsche Abfragen erlauben die Erstellung von Abfragen die andere Abfragen und boolsche Operatoren verwenden.

Jede Subabfrage in einem Set kann als **required**, **prohibited**, oder **optional** definiert werden.



   - **required** bedeutet das Dokumente die dieser Unterabfrage nicht entsprechen auch der Gesamtabfrage nicht
     entsprechen;

   - **prohibited** bedeutet das Dokumente die dieser Unterabfrage entsprechen auch der Gesamtabfrage nicht
     entsprechen;

   - **optional**, in dem Fall das entsprechende Dokumente in der Unterabfrage weder verboten noch benötigt
     werden. Ein Dokument muß trotzdem zumindest in 1 Unterabfrage entsprechen damit es der in der Gesamtabfrage
     entspricht.



Wenn optionale Unterabfragen einer Abfrage mit benötigen Unterabfragen hinzugefügt werden, werden beide Abfragen
das gleiche Ergebnisset haben, aber die optionale Unterabfrage kann die Wertung der passenden Dokumente
beeinflussen.

Beide Suchmethoden können für boolsche Abfragen verwendet werden.

Abfrage String:

.. code-block:: text
   :linenos:

   +(word1 word2 word3) (author:word4 author:word5) -(word6)

- '+' wird verwendet um eine benötigte Unterabfrage zu definieren.

- '-' wird verwendet um eine verbotene Unterabfrage zu definieren.

- 'field:' Der Prefix wird verwendet um ein Feld des Dokuments für eine Suche zu markieren. Wenn es nicht
  angegeben wird, werden alle Felder durchsucht.

oder

Aufbau der Abfrage durch die *API*:

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Boolean();

   $subquery1 = new Zend_Search_Lucene_Search_Query_MultiTerm();
   $subquery1->addTerm(new Zend_Search_Lucene_Index_Term('word1'));
   $subquery1->addTerm(new Zend_Search_Lucene_Index_Term('word2'));
   $subquery1->addTerm(new Zend_Search_Lucene_Index_Term('word3'));

   $subquery2 = new Zend_Search_Lucene_Search_Query_MultiTerm();
   $subquery2->addTerm(new Zend_Search_Lucene_Index_Term('word4', 'author'));
   $subquery2->addTerm(new Zend_Search_Lucene_Index_Term('word5', 'author'));

   $term6 = new Zend_Search_Lucene_Index_Term('word6');
   $subquery3 = new Zend_Search_Lucene_Search_Query_Term($term6);

   $query->addSubquery($subquery1, true  /* benötigt (required) */);
   $query->addSubquery($subquery2, null  /* optional */);
   $query->addSubquery($subquery3, false /* verboten (prohibited) */);

   $hits  = $index->find($query);

Es ist auch möglich Listen von Unterabfragen im Konstruktor der Boolschen Abfrage zu definieren:

.. code-block:: php
   :linenos:

   ...
   $subqueries = array($subquery1, $subquery2, $subquery3);
   $signs = array(true, null, false);

   $query = new Zend_Search_Lucene_Search_Query_Boolean($subqueries, $signs);

   $hits  = $index->find($query);

Das ``$signs`` Array enthält Informationen über den Typ der Unterabfrage:



   - ``TRUE`` wird verwendet um eine benötigte Unterabfrage zu definieren.

   - ``FALSE`` wird verwendet um eine verbotene Unterabfrage zu definieren.

   - ``NULL`` wird verwendet um eine Unterabfrage zu definieren die weder benötigt noch verboten ist.



Jede Abfrage die boolsche Operatoren verwendet kann, kann auch auch umgeschrieben werden damit Sie die
Vorzeichen-Schreibweise verwendet und mit Hilfe der *API* erstellt wird. Zum Beispiel:

.. code-block:: text
   :linenos:

   word1 AND (word2 AND word3 AND NOT word4) OR word5

ist identisch mit

.. code-block:: text
   :linenos:

   (+(word1) +(+word2 +word3 -word4)) (word5)

.. _zend.search.lucene.queries.wildcard:

Wildcard Abfragen
-----------------

Wildcard Abfragen können dazu verwendet werden um nach Dokumenten zu suchen die Strings enthalten welche den
spezifizierten Patterns entsprechen.

Das '?' Symbol wird als Wildcard für ein einzelnes Zeichen verwendet.

Das '\*' Symbol wird als Woldcard für mehrere Zeichen verwendet.

Abfragestring:

.. code-block:: text
   :linenos:

   field1:test*

oder

Abfrageerstellung durch die *API*:

.. code-block:: php
   :linenos:

   $pattern = new Zend_Search_Lucene_Index_Term('test*', 'field1');
   $query = new Zend_Search_Lucene_Search_Query_Wildcard($pattern);
   $hits  = $index->find($query);

Die Ausdrucksfelder sind optional. ``Zend_Search_Lucene`` durchsucht alle Felder in jedem Dokument wenn kein Feld
spezifiziert wurde:

.. code-block:: php
   :linenos:

   $pattern = new Zend_Search_Lucene_Index_Term('test*');
   $query = new Zend_Search_Lucene_Search_Query_Wildcard($pattern);
   $hits  = $index->find($query);

.. _zend.search.lucene.queries.fuzzy:

Fuzzy Abfragen
--------------

Fuzzy Abfragen können verwendet werden um nach Dokumenten zu Suchen die Strings enthalten welche Ausdrücken
entsprechen die den spezifizierten Ausdrücken ähnlich sind.

Abfrage String:

.. code-block:: text
   :linenos:

   field1:test~

Diese Abfrage trifft Dokumente welche die Wörter 'test' 'text' 'best' und andere enthalten.

oder

Abfrageerstellung durch die *API*:

.. code-block:: php
   :linenos:

   $term = new Zend_Search_Lucene_Index_Term('test', 'field1');
   $query = new Zend_Search_Lucene_Search_Query_Fuzzy($term);
   $hits  = $index->find($query);

Optional kann die Ähnlichkeit nach dem "~" Zeichen spezifiziert werden.

Abfrage String:

.. code-block:: text
   :linenos:

   field1:test~0.4

oder

Abfrageerstellung durch die *API*:

.. code-block:: php
   :linenos:

   $term = new Zend_Search_Lucene_Index_Term('test', 'field1');
   $query = new Zend_Search_Lucene_Search_Query_Fuzzy($term, 0.4);
   $hits  = $index->find($query);

Das Term Feld ist optional. ``Zend_Search_Lucene`` durchsucht alle Felder in jedem Dokument ob ein Feld nicht
spezifiziert ist:

.. code-block:: php
   :linenos:

   $term = new Zend_Search_Lucene_Index_Term('test');
   $query = new Zend_Search_Lucene_Search_Query_Fuzzy($term);
   $hits  = $index->find($query);

.. _zend.search.lucene.queries.phrase-query:

Phrasenabfrage
--------------

Phrasenabfragen können für das Suchen einer Phrase innerhalb von Dokumenten verwendet werden.

Phrasenabfragen sind sehr flexibel und erlauben dem Benutzer oder Entwickler nach exakten Phrasen zu suchen wie
auch nach 'ungenauen' Phrasen.

Phrasen können auch Lücken oder mehrere Begriffe an der selben Stelle enthalten; diese können mit Hilfe das
Analysators für verschiedene Zwecke generiert werden, z.B. kann ein Begriff verdoppelt werden, um das Gewicht des
Begriffs zu erhöhen oder verschiedene Synonyme können an einer Stelle platziert werden.

.. code-block:: php
   :linenos:

   $query1 = new Zend_Search_Lucene_Search_Query_Phrase();

   // Füge 'word1' an der relativen Position 0 hinzu.
   $query1->addTerm(new Zend_Search_Lucene_Index_Term('word1'));

   // Füge 'word2' an der relativen Position 1 hinzu.
   $query1->addTerm(new Zend_Search_Lucene_Index_Term('word2'));

   // Füge 'word3' an der relativen Position 3 hinzu.
   $query1->addTerm(new Zend_Search_Lucene_Index_Term('word3'), 3);

   ...

   $query2 = new Zend_Search_Lucene_Search_Query_Phrase(
                   array('word1', 'word2', 'word3'), array(0,1,3));

   ...

   // Abfrage ohne eine Lücke.
   $query3 = new Zend_Search_Lucene_Search_Query_Phrase(
                   array('word1', 'word2', 'word3'));

   ...

   $query4 = new Zend_Search_Lucene_Search_Query_Phrase(
                   array('word1', 'word2'), array(0,1), 'annotation');

Eine Phrasenabfrage kann in einem Schritt mit einem Klassenkonstruktor erstellt werden oder Schritt für Schritt
mit der ``Zend_Search_Lucene_Search_Query_Phrase::addTerm()`` Methode.

Der ``Zend_Search_Lucene_Search_Query_Phrase`` Klassenkonstruktor nimmt drei optionale Argumente entgegen:

.. code-block:: php
   :linenos:

   Zend_Search_Lucene_Search_Query_Phrase(
       [array $terms[, array $offsets[, string $field]]]
   );

Der ``$terms`` Parameter ist ein Array von Strings die ein Set von Phrasen Strings enthalten. Wenn er ausgelassen
wird oder ``NULL`` ist, wird eine leere Abfrage erstellt.

Der ``$offsets`` Parameter ist von ganzen Zahlen, welche den Offset von Begriffen in einer Phrase enthalten. Wenn
er ausgelassen wird oder ``TRUE`` ist, werden die Positionen der Begriffe als sequentiell, ohne Zwischenräume,
angenommen.

Der ``$field`` Parameter ist ein String, der das zu durchsuchende Dokumentenfeld angibt. Wenn dies ausgelassen wird
oder ``TRUE`` entspricht, wird das Standardfeld durchsucht.

.. code-block:: php
   :linenos:

   $query =
       new Zend_Search_Lucene_Search_Query_Phrase(array('zend', 'framework'));

Wird nach der Phrase 'zend framework' in allen Feldern suchen.

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Phrase(
                    array('zend', 'download'), array(0, 2)
                );

Es wird nach der Phrase 'zend ????? download' gesucht und die Phrasen 'zend platform download', 'zend studio
download', 'zend core download', 'zend framework download' und so weiter werden gefunden.

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Phrase(
                    array('zend', 'framework'), null, 'title'
                );

Wird nach der Phrase 'zend framework' im 'title' Feld suchen.

Die ``Zend_Search_Lucene_Search_Query_Phrase::addTerm()`` Methode nimmt zwei Argumente entgeben. Ein
``Zend_Search_Lucene_Index_Term`` Objekt ist erforderlich und die Position optional:

.. code-block:: php
   :linenos:

   Zend_Search_Lucene_Search_Query_Phrase::addTerm(
       Zend_Search_Lucene_Index_Term $term[, integer $position]
   );

``$term`` enthält den nächsten Begriff in der Phrase. Er muss das selbe Feld ansprechen wie der vorherige
Begriff. Andernfalls wird eine Ausnahme geworfen.

``$position`` gibt die Position des Begriffes an.

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Phrase();
   $query->addTerm(new Zend_Search_Lucene_Index_Term('zend'));
   $query->addTerm(new Zend_Search_Lucene_Index_Term('framework'));

Demnach wird hier nach der Phrase 'zend framework' gesucht.

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Phrase();
   $query->addTerm(new Zend_Search_Lucene_Index_Term('zend'), 0);
   $query->addTerm(new Zend_Search_Lucene_Index_Term('framework'), 2);

Es wird nach der Phrase 'zend ????? download' gesucht und die Phrasen 'zend platform download', 'zend studio
download', 'zend core download', 'zend framework download' und so weiter werden gefunden.

.. code-block:: php
   :linenos:

   $query = new Zend_Search_Lucene_Search_Query_Phrase();
   $query->addTerm(new Zend_Search_Lucene_Index_Term('zend', 'title'));
   $query->addTerm(new Zend_Search_Lucene_Index_Term('framework', 'title'));

Es wird nach der Phrase 'zend framework' im 'title' Feld gesucht.

Der Ungenauigkeitsfaktor (slop factor) legt die Anzahl der anderen Wörter fest die zwischen den spezifizierten
Phrasenabfragen erlaubt sind. Wenn der Wert 0 ist, ist die entsprechende Abfrage eine exakte Suche nach der Phrase.
Für größere Werte funktioniert das ähnlich dem WITHIN (innerhalb) oder NEAR (nahe) Operator.

Der Ungenauigkeitsfaktor ist tatsächlich eine veränderbare Distanz, wobei die Veränderung dem Verschieben von
Begriffen in der Phrasenabfrage entspricht. Um zum Beispiel die Reihenfolge von zwei Wörtern zu wechseln, werden
zwei Verschiebungen benötigt (die erste Verschiebung plaziert die Wörter übereinander). Um also die
Neusortierung der Phrasen zu erlauben, muß der Ungenauigkeitsfaktor mindestens zwei sein.

Exaktere Treffer werden höher bewertet als ungenauere Treffer, so dass die Suchergebnisse nach der Genauigkeit
sortiert werden. Die Ungenauigkeit liegt standardmäßig bei 0, was exakte Treffer erfordert.

Der Ungenauigkeitsfaktor kannnach der Erstellung der Abfrage zugeordnet werden:

.. code-block:: php
   :linenos:

   // Query without a gap.
   $query =
       new Zend_Search_Lucene_Search_Query_Phrase(array('word1', 'word2'));

   // Search for 'word1 word2', 'word1 ... word2'
   $query->setSlop(1);
   $hits1 = $index->find($query);

   // Search for 'word1 word2', 'word1 ... word2',
   // 'word1 ... ... word2', 'word2 word1'
   $query->setSlop(2);
   $hits2 = $index->find($query);

.. _zend.search.lucene.queries.range:

Bereichsabfragen
----------------

:ref:`Bereichsabfragen <zend.search.lucene.query-language.range>` sind dazu gedacht Terme innerhalb eines
spezifizierten Intervalls zu suchen.

Abfragestring:

.. code-block:: text
   :linenos:

   mod_date:[20020101 TO 20030101]
   title:{Aida TO Carmen}

oder

Abfrageerstellung durch die *API*:

.. code-block:: php
   :linenos:

   $from = new Zend_Search_Lucene_Index_Term('20020101', 'mod_date');
   $to   = new Zend_Search_Lucene_Index_Term('20030101', 'mod_date');
   $query = new Zend_Search_Lucene_Search_Query_Range(
                    $from, $to, true // inclusive
                );
   $hits  = $index->find($query);

Begriffsfelder sind optional. ``Zend_Search_Lucene`` durchsucht alle Felder wenn das Feld nicht spezifiziert wurde:

.. code-block:: php
   :linenos:

   $from = new Zend_Search_Lucene_Index_Term('Aida');
   $to   = new Zend_Search_Lucene_Index_Term('Carmen');
   $query = new Zend_Search_Lucene_Search_Query_Range(
                    $from, $to, false // non-inclusive
                );
   $hits  = $index->find($query);

Jede (aber nicht beide) der Begrenzungsausdrücke kann auf ``TRUE`` gesetzt werden. ``Zend_Search_Lucene`` sucht
vom Anfang oder bis zum Ende des Verzeichnisses für die spezifizierten Feld(er) für diesen Fall:

.. code-block:: php
   :linenos:

   // Sucht nach ['20020101' TO ...]
   $from = new Zend_Search_Lucene_Index_Term('20020101', 'mod_date');
   $query = new Zend_Search_Lucene_Search_Query_Range(
                    $from, null, true // inclusive
                );
   $hits  = $index->find($query);


