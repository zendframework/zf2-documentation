.. EN-Revision: none
.. _learning.lucene.queries:

Unterstützte Abfragen
=====================

``Zend_Search_Lucene`` und Java Lucene unterstützen eine mächtige Abfragesprache. Sie erlaubt das Suchen nach
individuellen Ausdrücken, Phrasen, Bereichen von Ausdrücken; verwendung von Wildcards und Undeutliche (Fuzzy)
Suchen; Kombination von Abfragen durch Verwendung boolscher Operatoren; und so weiter.

Eine detailierte Beschreibung der Abfragesprache kann in der :ref:`Dokumentation der Komponente Zend_Search_Lucene
<zend.search.lucene.query-language>` gefunden werden.

Nachfolgend sind einige Beispiel von üblichen Abfragetypen und Strategien.

.. _learning.lucene.queries.keyword:

.. rubric:: Abfragen nach einem einfachen Wort

.. code-block:: text
   :linenos:

   hello

Sucht nach dem Wort "hello" durch alle Dokumentfelder.

.. note::

   **Standardmäßige Suchfelder**

   Wichtige Notiz! Java Lucene sucht standardmäßig nur nach den "contents" Feldern, aber ``Zend_Search_Lucene``
   sucht durch **alle** Felder. Dieses Verhalten kann geändert werden indem die Methode
   ``Zend_Search_Lucene::setDefaultSearchField($fieldName)`` verwendet wird.

.. _learning.lucene.queries.multiple-words:

.. rubric:: Abfrage nach mehreren Worten

.. code-block:: text
   :linenos:

   hello dolly

Sucht nach zwei Worten. Beide Worte sind optional; zumindest eines von Ihnen muss im Ergebnis vorhanden sein.

.. _learning.lucene.queries.required-words:

.. rubric:: Worte in einer Abfrage erzwingen

.. code-block:: text
   :linenos:

   +hello dolly

Sucht nach zwei Worten; "hello" wird benötigt, "dolly" ist optional.

.. _learning.lucene.queries.prohibited-words:

.. rubric:: Wörter in abgefragten Dokumenten verhindern

.. code-block:: text
   :linenos:

   +hello -dolly

Sucht nach zwei Worten; "hello" wird benötigt, "dolly" ist verboten. Mit anderen Worten, wenn das Dokument auf
"hello" passt aber das Wort "dolly" enthält wird es nicht im gefundenen Set zurückgegeben.

.. _learning.lucene.queries.phrases:

.. rubric:: Abfrage nach Phrasen

.. code-block:: text
   :linenos:

   "hello dolly"

Suche nach der Phrase "hello dolly"; ein Dokument entspricht nur wenn der exakte String vorhanden ist.

.. _learning.lucene.queries.fields:

.. rubric:: Abfrage nach spezifischen Feldern

.. code-block:: text
   :linenos:

   title:"The Right Way" AND text:go

Sucht die Phrase "The Right Way" im ``title`` Feld und das Wort "go" im ``text`` Feld.

.. _learning.lucene.queries.fields-and-document:

.. rubric:: Abfrage nach speziellen Feldern sowie im kompletten Dokument

.. code-block:: text
   :linenos:

   title:"The Right Way" AND  go

Sucht die Phrase "The Right Way" im Feld ``title`` und das Word "go" welches in irgendeinem Feld des Dokuments
vorkommt.

.. _learning.lucene.queries.fields-and-document-alt:

.. rubric:: Abfrage nach speziellen Feldern sowie im kompletten Dokument (alternativ)

.. code-block:: text
   :linenos:

   title:Do it right

Sucht nach dem Wort "Do" im Feld ``title`` und die Wörter "it" und "right" über alle Felder; jeder einzelne der
entspricht führt zu einem passenden Dokument.

.. _learning.lucene.queries.wildcard-question:

.. rubric:: Abfrage mit der Wildcard "?"

.. code-block:: text
   :linenos:

   te?t

Sucht nach Worten die dem Pattern "te?t" entsprechen, wobei "?" jedes einzelne Zeichen ist.

.. _learning.lucene.queries.wildcard-asterisk:

.. rubric:: Abfrage mit dem Wildcard "\*"

.. code-block:: text
   :linenos:

   test*

Sucht nach Worten welche dem Pattern "test*" entsprechen wobei "\*" jede Sequenz von null oder mehr Zeichen
entspricht.

.. _learning.lucene.queries.range-inclusive:

.. rubric:: Abfrage nach einem inklusiven Bereich von Ausdrücken

.. code-block:: text
   :linenos:

   mod_date:[20020101 TO 20030101]

Sucht nach einem Bereich von Ausdrücken (inklusive).

.. _learning.lucene.queries.range-exclusive:

.. rubric:: Abfrage nach einem exklusiven Bereich von Ausdrücken

.. code-block:: text
   :linenos:

   title:{Aida to Carmen}

Sucht nach einem Bereich von Ausdrücken (exklusive).

.. _learning.lucene.queries.fuzzy:

.. rubric:: Undeutliche Suchen

.. code-block:: text
   :linenos:

   roam~

Sucht undeutlich nach dem Word "roam".

.. _learning.lucene.queries.boolean:

.. rubric:: Boolsche Suchen

.. code-block:: text
   :linenos:

   (framework OR library) AND php

Boolsche Abfrage.

Alle unterstützten Abfragen können durch ``Zend_Search_Lucene``'s :ref:`Abfrage Erstellungs API
<zend.search.lucene.query-api>` erstellt werden. Weiters können Parsen von Abfrage und Abfrage Erstellung
kombiniert werden:

.. _learning.lucene.queries.combining:

.. rubric:: Kombinieren von geparsted und erstellten Abfragen

.. code-block:: php
   :linenos:

   $userQuery = Zend_Search_Lucene_Search_QueryParser::parse($queryStr);

   $query = new Zend_Search_Lucene_Search_Query_Boolean();
   $query->addSubquery($userQuery, true  /* required */);
   $query->addSubquery($constructedQuery, true  /* required */);


