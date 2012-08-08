.. EN-Revision: none
.. _zend.service.technorati:

Zend_Service_Technorati
=======================

.. _zend.service.technorati.introduction:

Einführung
----------

``Zend_Service_Technorati`` bietet ein einfaches, intuitives und objekt-orientiertes Interface für die Verwendung
der Technorati *API*. Es bietet Zugriff zu allen vorhandenen `Technorati API Abfragen`_ und gibt die originalen
*XML* Antworten als freundliches *PHP* Objekt zurück.

`Technorati`_ ist eine der populärsten Blog Suchmaschinen. Das *API* Interface ermöglicht es Entwicklern
Informationen über einen spezifischen Blog zu erhalten, Blogs zu suchen die einem einzelnen Tag oder einer Phrase
entsprechen und Informationen über einen spezifischen Author (Blogger) erhalten. Für eine komplette Liste von
vorhandenen Abfragen kann in die `Technorati API Dokumentation`_ oder die :ref:`vorhandenen Technorati Abfragen
<zend.service.technorati.queries>` Sektion dieses Dokuments gesehen werden.

.. _zend.service.technorati.getting-started:

Anfangen
--------

Technorati benötigt einen gültigen *API* Schlüssel zur Verwendung. Um einen eigenen *API* Schlüssel zu erhalten
muss `ein neuer Technorati Account erstellt werden`_, und anschließend die `API Schlüssel Sektion`_ besucht
werden.

.. note::

   **API Schlüssel Beschränkungen**

   Es können bis zu 500 Technirati *API* Aufrufe pro Tag durchgeführt werden ohne das Kosten anfallen. Andere
   Limitationen der Verwendung können vorhanden sein, abhängig von der aktuellen Technorati *API* Lizenz.

Sobald man einen gültigen *API* Schlüssel hat, kann man beginnen ``Zend_Service_Technorati`` zu verwenden.

.. _zend.service.technorati.making-first-query:

Die erste Abfrage durchführen
-----------------------------

Um eine Abfrage durchzuführen, benötigt man zuerst eine ``Zend_Service_Technorati`` Instanz mit einem gültigen
*API* Schlüssel. Dann kann eine der vorhandenen Abfragemethoden ausgewählt werden, und durch Angabe der
benötigen Argumente aufgerufen werden.

.. _zend.service.technorati.making-first-query.example-1:

.. rubric:: Die erste Abfragen senden

.. code-block:: php
   :linenos:

   // ein neues Zend_Service_Technorati mit einem gültigen API_KEY erstellen
   $technorati = new Zend_Service_Technorati('VALID_API_KEY');

   // Technorati nach dem Schlüsselwort PHP durchsuchen
   $resultSet = $technorati->search('PHP');

Jede Abfragemethode akzeptiert ein Array von optionalen Parametern die verwendet werden kann um die Abfrage zu
verfeinern.

.. _zend.service.technorati.making-first-query.example-2:

.. rubric:: Verfeinern der Abfrage

.. code-block:: php
   :linenos:

   // ein neues Zend_Service_Technorati mit einem gültigen API_KEY erstellen
   $technorati = new Zend_Service_Technorati('VALID_API_KEY');

   // Die Abfrage nach Ergebnissen mit etwas Authority filtern
   // (Ergebnisse von Blogs mit einer Handvoll Links)
   $options = array('authority' => 'a4');

   // Technorati nach dem Schlüsselwort PHP durchsuchen
   $resultSet = $technorati->search('PHP', $options);

Eine ``Zend_Service_Technorati`` Instanz ist kein einmal zu verwendendes Objekt. Deswegen muß keine neue Instanz
für jede Abfrage erstellt werden; es kann einfach das aktuelle ``Zend_Service_Technorati`` Objekt solange
verwendet werden wie es benötigt wird.

.. _zend.service.technorati.making-first-query.example-3:

.. rubric:: Mehrfache Abfragen mit der gleichen Zend_Service_Technorati Instanz senden

.. code-block:: php
   :linenos:

   // ein neues Zend_Service_Technorati mit einem gültigen API_KEY erstellen
   $technorati = new Zend_Service_Technorati('VALID_API_KEY');

   // Technorati nach dem Schlüsselwort PHP durchsuchen
   $search = $technorati->search('PHP');

   // Top Tags die von Technorati indiziert wurden erhalten
   $topTags = $technorati->topTags();

.. _zend.service.technorati.consuming-results:

Ergebnisse verarbeiten
----------------------

Es kann einer von zwei Typen von Ergebnisobjekten als Antwort auf eine Abfrage empfangen werden.

Die erste Gruppe wird durch ``Zend_Service_Technorati_*ResultSet`` Objekte repräsentiert. Ein Ergebnisset Objekt
ist grundsätzlich eine Kollektion von Ergebnisobjekten. Es erweitert die grundsätzliche
``Zend_Service_Technorati_ResultSet`` Klasse und implementiert das *PHP* Interface ``SeekableIterator``. Der beste
Weg um ein Ergebnisset Objekt zu verarbeiten ist dieses mit einem *PHP* ``foreach()`` Statement zu durchlaufen.

.. _zend.service.technorati.consuming-results.example-1:

.. rubric:: Ein Ergebnisset Objekt verarbeiten

.. code-block:: php
   :linenos:

   // ein neues Zend_Service_Technorati mit einem gültigen API_KEY erstellen
   $technorati = new Zend_Service_Technorati('VALID_API_KEY');

   // Technorati nach dem PHP Schlüsselwort durchsuchen
   // $resultSet ist eine Instanz von Zend_Service_Technorati_SearchResultSet
   $resultSet = $technorati->search('PHP');

   // Alle Ergebnisobjekte durchlaufen
   foreach ($resultSet as $result) {
       // $result ist eine Instanz von Zend_Service_Technorati_SearchResult
   }

Weil ``Zend_Service_Technorati_ResultSet`` das ``SeekableIterator`` Interface implementiert, kann ein spezifisches
Ergebnisobjekt gesucht werden indem dessen Position in der Ergebnissammlung verwendet wird.

.. _zend.service.technorati.consuming-results.example-2:

.. rubric:: Ein spezifisches Ergebnisset Objekt suchen

.. code-block:: php
   :linenos:

   // ein neues Zend_Service_Technorati mit einem gültigen API_KEY erstellen
   $technorati = new Zend_Service_Technorati('VALID_API_KEY');

   // Technorati nach dem PHP Schlüsselwort durchsuchen
   // $resultSet ist eine Instanz von Zend_Service_Technorati_SearchResultSet
   $resultSet = $technorati->search('PHP');

   // $result ist eine Instanz von Zend_Service_Technorati_SearchResult
   $resultSet->seek(1);
   $result = $resultSet->current();

.. note::

   ``SeekableIterator`` arbeitet als Array und zählt Positionen beginnend vom Index 0. Das Holen der Position 1
   bedeutet das man das zweite Ergebnis der Kollektion erhält.

Die zweite Gruppe wird durch spezielle alleinstehende Ergebnisobjekte repräsentiert.
``Zend_Service_Technorati_GetInfoResult``, ``Zend_Service_Technorati_BlogInfoResult`` und
``Zend_Service_Technorati_KeyInfoResult`` funktionieren als Wrapper für zusätzliche Objekte, wie
``Zend_Service_Technorati_Author`` und ``Zend_Service_Technorati_Weblog``.

.. _zend.service.technorati.consuming-results.example-3:

.. rubric:: Ein alleinstehendes Ergebnisobjekt verarbeiten

.. code-block:: php
   :linenos:

   // ein neues Zend_Service_Technorati mit einem gültigen API_KEY erstellen
   $technorati = new Zend_Service_Technorati('VALID_API_KEY');

   // Infos über weppos Author erhalten
   $result = $technorati->getInfo('weppos');

   $author = $result->getAuthor();
   echo '<h2>Blogs authorisiert von ' . $author->getFirstName() . " " .
             $author->getLastName() . '</h2>';
   echo '<ol>';
   foreach ($result->getWeblogs() as $weblog) {
       echo '<li>' . $weblog->getName() . '</li>';
   }
   echo "</ol>";

Bitte lesen Sie das :ref:`Zend_Service_Technorati Klassen <zend.service.technorati.classes>` Kapitel für weitere
Details über Antwortklassen.

.. _zend.service.technorati.handling-errors:

Fehler behandeln
----------------

Jede ``Zend_Service_Technorati`` Abfragemethode wirft bei einem Fehler eine ``Zend_Service_Technorati_Exception``
Ausnahme mit einer bedeutungsvollen Fehlermeldung.

Es gibt verschiedene Gründe die Verursachen können das eine ``Zend_Service_Technorati`` Abfrage fehlschlägt.
``Zend_Service_Technorati`` prüft alle Parameter für jegliche Abfrageanfragen. Wenn ein Parameter ungültig ist
oder er einen ungültigen Wert enthält, wird eine neue ``Zend_Service_Technorati_Exception`` Ausnahme geworfen.
Zusätzlich kann das Technorati *API* Interface temporär unerreichbar sein, oder es kann eine Antwort zurückgeben
die nicht gültig ist.

Eine Technorati Abfrage sollte immer mit einem ``try ... catch`` Block umhüllt werden.

.. _zend.service.technorati.handling-errors.example-1:

.. rubric:: Eine Abfrageausnahme behandeln

.. code-block:: php
   :linenos:

   $technorati = new Zend_Service_Technorati('VALID_API_KEY');
   try {
       $resultSet = $technorati->search('PHP');
   } catch(Zend_Service_Technorati_Exception $e) {
       echo "Ein Fehler ist aufgetreten: " $e->getMessage();
   }

.. _zend.service.technorati.checking-api-daily-usage:

Prüfen der täglichen Verwendung des eigenen API Schlüssels
----------------------------------------------------------

Von Zeit zu Zeit wird man die tägliche Verwendung des *API* Schlüssels prüfen wollen. Standardmäßig limitiert
Technorati die *API* Verwendung auf 500 Aufrufe pro Tag, und eine Ausnahme wird durch ``Zend_Service_Technorati``
zurückgegeben wenn versucht wird dieses Limit zu überschreiten. Man kann diese Information über die Verwendung
des eigenen *API* Schlüssels erhalten indem die ``Zend_Service_Technorati::keyInfo()`` Methode verwendet wird.

``Zend_Service_Technorati::keyInfo()`` gibt ein ``Zend_Service_Technorati_KeyInfoResult`` Object zurück. Für
vollständige Details kann im `API Referenz Guide`_ nachgesehen werden.

.. _zend.service.technorati.checking-api-daily-usage.example-1:

.. rubric:: Die Information über die tägliche Verwendung des API Schlüssels erhalten

.. code-block:: php
   :linenos:

   $technorati = new Zend_Service_Technorati('VALID_API_KEY');
   $key = $technorati->keyInfo();

   echo "API Schlüssel: " . $key->getApiKey() . "<br />";
   echo "Tägliche Verwendung: " . $key->getApiQueries() . "/" .
        $key->getMaxQueries() . "<br />";

.. _zend.service.technorati.queries:

Vorhandene Technorati Abfragen
------------------------------

``Zend_Service_Technorati`` bietet Unterstützung für die folgenden Abfragen:



   - :ref:`Cosmos <zend.service.technorati.queries.cosmos>`

   - :ref:`Search <zend.service.technorati.queries.search>`

   - :ref:`Tag <zend.service.technorati.queries.tag>`

   - :ref:`DailyCounts <zend.service.technorati.queries.dailycounts>`

   - :ref:`TopTags <zend.service.technorati.queries.toptags>`

   - :ref:`BlogInfo <zend.service.technorati.queries.bloginfo>`

   - :ref:`BlogPostTags <zend.service.technorati.queries.blogposttags>`

   - :ref:`GetInfo <zend.service.technorati.queries.getinfo>`



.. _zend.service.technorati.queries.cosmos:

Technorati Cosmos
^^^^^^^^^^^^^^^^^

Eine `Cosmos`_ Abfrage lässt einen Sehen welche Blog zu einer gegebenen *URL* verknüpft sind. Sie gibt ein
:ref:`Zend_Service_Technorati_CosmosResultSet <zend.service.technorati.classes.cosmosresultset>` Objekt zurück.
Für vollständige Details kann nach ``Zend_Service_Technorati::cosmos()`` im `API Referenz Guide`_ nachgesehen
werden.

.. _zend.service.technorati.queries.cosmos.example-1:

.. rubric:: Cosmos Abfrage

.. code-block:: php
   :linenos:

   $technorati = new Zend_Service_Technorati('VALID_API_KEY');
   $resultSet = $technorati->cosmos('http://devzone.zend.com/');

   echo "<p>Liest " . $resultSet->totalResults() .
        " von " . $resultSet->totalResultsAvailable() .
        " vorhandenen Ergebnissen</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getWeblog()->getName() . "</li>";
   }
   echo "</ol>";

.. _zend.service.technorati.queries.search:

Technorati Search
^^^^^^^^^^^^^^^^^

Die `Search`_ Abfrage lässt einen Sehen welche Blogs einen gegebenen Suchstring enthalten. Sie gibt ein
:ref:`Zend_Service_Technorati_SearchResultSet <zend.service.technorati.classes.searchresultset>` Objekt zurück.
Für vollständige Details kann nach ``Zend_Service_Technorati::search()`` im `API Referenz Guide`_ nachgesehen
werden.

.. _zend.service.technorati.queries.search.example-1:

.. rubric:: Suchabfrage

.. code-block:: php
   :linenos:

   $technorati = new Zend_Service_Technorati('VALID_API_KEY');
   $resultSet = $technorati->search('zend framework');

   echo "<p>Liest " . $resultSet->totalResults() .
        " von " . $resultSet->totalResultsAvailable() .
        " vorhandenen Ergebnissen</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getWeblog()->getName() . "</li>";
   }
   echo "</ol>";

.. _zend.service.technorati.queries.tag:

Technorati Tag
^^^^^^^^^^^^^^

Die `Tag`_ Abfrage lässt einen Sehen welche Antworten mit einem gegebenen Tag assoziiert sind. Sie gibt ein
:ref:`Zend_Service_Technorati_TagResultSet <zend.service.technorati.classes.tagresultset>` Objekt zurück. Für
vollständige Details kann nach ``Zend_Service_Technorati::tag()`` im `API Referenz Guide`_ nachgesehen werden.

.. _zend.service.technorati.queries.tag.example-1:

.. rubric:: Tag Abfrage

.. code-block:: php
   :linenos:

   $technorati = new Zend_Service_Technorati('VALID_API_KEY');
   $resultSet = $technorati->tag('php');

   echo "<p>Liest " . $resultSet->totalResults() .
        " von " . $resultSet->totalResultsAvailable() .
        " vorhandenen Ergebnissen</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getWeblog()->getName() . "</li>";
   }
   echo "</ol>";

.. _zend.service.technorati.queries.dailycounts:

Technorati DailyCounts
^^^^^^^^^^^^^^^^^^^^^^

Die `DailyCounts`_ Abfrage bietet tägliche Anzahlen von Antworten die ein abgefragtes Schlüsselwort enthalten.
Sie gibt ein :ref:`Zend_Service_Technorati_DailyCountsResultSet
<zend.service.technorati.classes.dailycountsresultset>` Objekt zurück. Für vollständige Details kann nach
``Zend_Service_Technorati::dailyCounts()`` im `API Referenz Guide`_ nachgesehen werden.

.. _zend.service.technorati.queries.dailycounts.example-1:

.. rubric:: DailyCounts Abfrage

.. code-block:: php
   :linenos:

   $technorati = new Zend_Service_Technorati('VALID_API_KEY');
   $resultSet = $technorati->dailyCounts('php');

   foreach ($resultSet as $result) {
       echo "<li>" . $result->getDate() .
            "(" . $result->getCount() . ")</li>";
   }
   echo "</ol>";

.. _zend.service.technorati.queries.toptags:

Technorati TopTags
^^^^^^^^^^^^^^^^^^

Die `TopTags`_ Abfrage bietet Informationen über Top Tags die durch Technorati indiziert sind. Sie gibt ein
:ref:`Zend_Service_Technorati_TagsResultSet <zend.service.technorati.classes.tagsresultset>` Objekt zurück. Für
vollständige Details kann nach ``Zend_Service_Technorati::topTags()`` im `API Referenz Guide`_ nachgesehen werden.

.. _zend.service.technorati.queries.toptags.example-1:

.. rubric:: TopTags Abfrage

.. code-block:: php
   :linenos:

   $technorati = new Zend_Service_Technorati('VALID_API_KEY');
   $resultSet = $technorati->topTags();

   echo "<p>Liest " . $resultSet->totalResults() .
        " von " . $resultSet->totalResultsAvailable() .
        "  vorhandenen Ergebnissen</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getTag() . "</li>";
   }
   echo "</ol>";

.. _zend.service.technorati.queries.bloginfo:

Technorati BlogInfo
^^^^^^^^^^^^^^^^^^^

Eine `BlogInfo`_ Abfrage bietet Informationen darüber welcher Blog, wenn überhaupt, mit einer gegebenen *URL*
assoziiert ist. Sie gibt ein :ref:`Zend_Service_Technorati_BlogInfoResult
<zend.service.technorati.classes.bloginforesult>` Objekt zurück. Für vollständige Details kann nach
``Zend_Service_Technorati::blogInfo()`` im `API Referenz Guide`_ nachgesehen werden.

.. _zend.service.technorati.queries.bloginfo.example-1:

.. rubric:: BlogInfo Abfrage

.. code-block:: php
   :linenos:

   $technorati = new Zend_Service_Technorati('VALID_API_KEY');
   $result = $technorati->blogInfo('http://devzone.zend.com/');

   echo '<h2><a href="' . (string) $result->getWeblog()->getUrl() . '">' .
        $result->getWeblog()->getName() . '</a></h2>';

.. _zend.service.technorati.queries.blogposttags:

Technorati BlogPostTags
^^^^^^^^^^^^^^^^^^^^^^^

Eine `BlogPostTags`_ Abfrage bietet Informationen über Top Tags die von einem spezifischen Blog verwendet werden.
Sie gibt ein :ref:`Zend_Service_Technorati_TagsResultSet <zend.service.technorati.classes.tagsresultset>` Objekt
zurück. Für vollständige Details kann nach ``Zend_Service_Technorati::blogPostTags()`` im `API Referenz Guide`_
nachgesehen werden.

.. _zend.service.technorati.queries.blogposttags.example-1:

.. rubric:: BlogPostTags Abfrage

.. code-block:: php
   :linenos:

   $technorati = new Zend_Service_Technorati('VALID_API_KEY');
   $resultSet = $technorati->blogPostTags('http://devzone.zend.com/');

   echo "<p>Liest " . $resultSet->totalResults() .
        " von " . $resultSet->totalResultsAvailable() .
        " vorhandenen Ergebnissen</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getTag() . "</li>";
   }
   echo "</ol>";

.. _zend.service.technorati.queries.getinfo:

Technorati GetInfo
^^^^^^^^^^^^^^^^^^

Eine `GetInfo`_ Abfrage teilt mit was Technorati über ein Mitglied weiß. Sie gibt ein
:ref:`Zend_Service_Technorati_GetInfoResult <zend.service.technorati.classes.getinforesult>` Objekt zurück. Für
vollständige Details kann nach ``Zend_Service_Technorati::getInfo()`` im `API Referenz Guide`_ nachgesehen werden.

.. _zend.service.technorati.queries.getinfo.example-1:

.. rubric:: GetInfo Abfrage

.. code-block:: php
   :linenos:

   $technorati = new Zend_Service_Technorati('VALID_API_KEY');
   $result = $technorati->getInfo('weppos');

   $author = $result->getAuthor();
   echo "<h2>Blogs authorisiert von " . $author->getFirstName() . " " .
        $author->getLastName() . "</h2>";
   echo "<ol>";
   foreach ($result->getWeblogs() as $weblog) {
       echo "<li>" . $weblog->getName() . "</li>";
   }
   echo "</ol>";

.. _zend.service.technorati.queries.keyinfo:

Technorati KeyInfo
^^^^^^^^^^^^^^^^^^

Die KeyInfo Abfrage bietet Informationen über die tägliche Verwendung eines *API* Schlüssels. Sie gibt ein
:ref:`Zend_Service_Technorati_KeyInfoResult <zend.service.technorati.classes.keyinforesult>` Objekt zurück. Für
vollständige Details kann nach ``Zend_Service_Technorati::keyInfo()`` im `API Referenz Guide`_ nachgesehen werden.

.. _zend.service.technorati.classes:

Zend_Service_Technorati Klassen
-------------------------------

Die folgenden Klassen werden von den verschiedenen Technorati Anfragen zurückgegeben. Jede
``Zend_Service_Technorati_*ResultSet`` Klasse enthält ein typ-spezifisches Ergebnisset welches einfach, mit jedem
Ergebnis das in einem Typ Ergebnisobjekt enthalten ist, iteriert werden kann. Alle Ergebnisset Klassen erweitern
die ``Zend_Service_Technorati_ResultSet`` Klasse und implementieren das ``SeekableIterator`` Interface, welches
eine einfache Iteration und Suche nach einem spezifischen Ergebnis erlaubt.



   - :ref:`Zend_Service_Technorati_ResultSet <zend.service.technorati.classes.resultset>`

   - :ref:`Zend_Service_Technorati_CosmosResultSet <zend.service.technorati.classes.cosmosresultset>`

   - :ref:`Zend_Service_Technorati_SearchResultSet <zend.service.technorati.classes.searchresultset>`

   - :ref:`Zend_Service_Technorati_TagResultSet <zend.service.technorati.classes.tagresultset>`

   - :ref:`Zend_Service_Technorati_DailyCountsResultSet <zend.service.technorati.classes.dailycountsresultset>`

   - :ref:`Zend_Service_Technorati_TagsResultSet <zend.service.technorati.classes.tagsresultset>`

   - :ref:`Zend_Service_Technorati_Result <zend.service.technorati.classes.result>`

   - :ref:`Zend_Service_Technorati_CosmosResult <zend.service.technorati.classes.cosmosresult>`

   - :ref:`Zend_Service_Technorati_SearchResult <zend.service.technorati.classes.searchresult>`

   - :ref:`Zend_Service_Technorati_TagResult <zend.service.technorati.classes.tagresult>`

   - :ref:`Zend_Service_Technorati_DailyCountsResult <zend.service.technorati.classes.dailycountsresult>`

   - :ref:`Zend_Service_Technorati_TagsResult <zend.service.technorati.classes.tagsresult>`

   - :ref:`Zend_Service_Technorati_GetInfoResult <zend.service.technorati.classes.getinforesult>`

   - :ref:`Zend_Service_Technorati_BlogInfoResult <zend.service.technorati.classes.bloginforesult>`

   - :ref:`Zend_Service_Technorati_KeyInfoResult <zend.service.technorati.classes.keyinforesult>`



.. note::

   ``Zend_Service_Technorati_GetInfoResult``, ``Zend_Service_Technorati_BlogInfoResult`` und
   ``Zend_Service_Technorati_KeyInfoResult`` repräsentieren Ausnahmen zu den obigen weil Sie nicht zu einem
   ergebnisset gehören und sie kein Interface implementieren. Sie repräsentieren ein einzelnes Antwortobjekt und
   sie funktionieren als Wrapper für zusätzliche ``Zend_Service_Technorati`` Objekte, wie
   ``Zend_Service_Technorati_Author`` und ``Zend_Service_Technorati_Weblog``.

Die ``Zend_Service_Technorati`` Bibliothek beinhaltet zusätzliche bequeme Klassen die spezifische Antwortobjekte
repräsentieren. ``Zend_Service_Technorati_Author`` repräsentiert einen einzelnen Technorati Account, welcher auch
als Blog Author oder Blogger bekannt ist. ``Zend_Service_Technorati_Weblog`` repräsentiert ein einzelnes Weblog
Objekt, zusätzlich mit allen spezifischen Weblog Eigenschaften die Feed *URL*\ s oder Blog Namen. Für komplette
Details kann nach ``Zend_Service_Technorati`` im `API Referenz Guide`_ nachgesehen werden.

.. _zend.service.technorati.classes.resultset:

Zend_Service_Technorati_ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Technorati_ResultSet`` ist das am meisten essentielle Ergebnisset. Der Zweck dieser Klasse ist es
von einer abfrage-spezifischen Kind-Ergebnisset-Klasse erweitert zu werden, und sie sollte niemals verwendet werden
um ein alleinstehendes Objekt zu initialisieren. Jedes der spezifischen Ergebnissets repräsentiert eine Kollektion
von abfrage-spezifischen :ref:`Zend_Service_Technorati_Result <zend.service.technorati.classes.result>` Objekte.

``Zend_Service_Technorati_ResultSet`` Implementiert das *PHP* ``SeekableIterator`` Interface, und man kann durch
alle Ergebnisobjekte mit dem *PHP* Statement ``foreach()`` iterieren.

.. _zend.service.technorati.classes.resultset.example-1:

.. rubric:: Über Ergebnisobjekte von einer Ergebnisset Kollektion iterieren

.. code-block:: php
   :linenos:

   // eine einfache Abfrage durchlaufen
   $technorati = new Zend_Service_Technorati('VALID_API_KEY');
   $resultSet = $technorati->search('php');

   // $resultSet ist jetzt eine Instanz von
   // Zend_Service_Technorati_SearchResultSet
   // sie erweitert Zend_Service_Technorati_ResultSet
   foreach ($resultSet as $result) {
       // irgendwas mit dem Zend_Service_Technorati_SearchResult Objekt anfangen
   }

.. _zend.service.technorati.classes.cosmosresultset:

Zend_Service_Technorati_CosmosResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Technorati_CosmosResultSet`` repräsentiert ein Technorati Cosmos Abfrage Ergebnisset.

.. note::

   ``Zend_Service_Technorati_CosmosResultSet`` erweitert :ref:`Zend_Service_Technorati_ResultSet
   <zend.service.technorati.classes.resultset>`.

.. _zend.service.technorati.classes.searchresultset:

Zend_Service_Technorati_SearchResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Technorati_SearchResultSet`` repräsentiert ein Technorati Search Abfrage Ergebnisset.

.. note::

   ``Zend_Service_Technorati_SearchResultSet`` erweitert :ref:`Zend_Service_Technorati_ResultSet
   <zend.service.technorati.classes.resultset>`.

.. _zend.service.technorati.classes.tagresultset:

Zend_Service_Technorati_TagResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Technorati_TagResultSet`` repräsentiert ein Technorati Tag Abfrage Ergebnisset.

.. note::

   ``Zend_Service_Technorati_TagResultSet`` erweitert :ref:`Zend_Service_Technorati_ResultSet
   <zend.service.technorati.classes.resultset>`.

.. _zend.service.technorati.classes.dailycountsresultset:

Zend_Service_Technorati_DailyCountsResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Technorati_DailyCountsResultSet`` repräsentiert ein Technorati DailyCounts Abfrage Ergebnisset.

.. note::

   ``Zend_Service_Technorati_DailyCountsResultSet`` erweitert :ref:`Zend_Service_Technorati_ResultSet
   <zend.service.technorati.classes.resultset>`.

.. _zend.service.technorati.classes.tagsresultset:

Zend_Service_Technorati_TagsResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Technorati_TagsResultSet`` repräsentiert ein Technorati TopTags oder BlogPostTags Abfrage
Ergebnisset.

.. note::

   ``Zend_Service_Technorati_TagsResultSet`` erweitert :ref:`Zend_Service_Technorati_ResultSet
   <zend.service.technorati.classes.resultset>`.

.. _zend.service.technorati.classes.result:

Zend_Service_Technorati_Result
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Technorati_Result`` ist das wichtigste Ergebnisobjekt. Der Zweck dieser Klasse ist es, durch eine
abfrage-spezifische Kind-Ergebnisklasse erweitert zu werden, und Sie sollte nie verwendet werden um ein
alleinstehendes Objekt zu initiieren.

.. _zend.service.technorati.classes.cosmosresult:

Zend_Service_Technorati_CosmosResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Technorati_CosmosResult`` repräsentiert ein einzelnes Technorati Cosmos Abfrageobjekt. Es wird nie
als alleinstehendes Objekt zurückgegeben, aber es gehört immer einem gültigen
:ref:`Zend_Service_Technorati_CosmosResultSet <zend.service.technorati.classes.cosmosresultset>` Objekt an.

.. note::

   ``Zend_Service_Technorati_CosmosResult`` erweitert :ref:`Zend_Service_Technorati_Result
   <zend.service.technorati.classes.result>`.

.. _zend.service.technorati.classes.searchresult:

Zend_Service_Technorati_SearchResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Technorati_SearchResult`` repräsentiert ein einzelnes Technorati Search Abfrage Ergebnisobjekt. Es
wird nie als alleinstehendes Objekt zurückgegeben, aber es gehört immer einem gültigen
:ref:`Zend_Service_Technorati_SearchResultSet <zend.service.technorati.classes.searchresultset>` Objekt an.

.. note::

   ``Zend_Service_Technorati_SearchResult`` erweitert :ref:`Zend_Service_Technorati_Result
   <zend.service.technorati.classes.result>`.

.. _zend.service.technorati.classes.tagresult:

Zend_Service_Technorati_TagResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Technorati_TagResult`` repräsentiert ein einzelnes Technorati Tag Abfrage Ergebnisobjekt. Es wird
nie als alleinstehendes Objekt zurückgegeben, aber es gehört immer einem gültigen
:ref:`Zend_Service_Technorati_TagResultSet <zend.service.technorati.classes.tagresultset>` Objekt an.

.. note::

   ``Zend_Service_Technorati_TagResult`` erweitert :ref:`Zend_Service_Technorati_Result
   <zend.service.technorati.classes.result>`.

.. _zend.service.technorati.classes.dailycountsresult:

Zend_Service_Technorati_DailyCountsResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Technorati_DailyCountsResult`` repräsentiert ein einzelnes Technorati DailyCounts Abfrage
Ergebnisobjekt. Es wird nie als alleinstehendes Objekt zurückgegeben, aber es gehört immer einem gültigen
:ref:`Zend_Service_Technorati_DailyCountsResultSet <zend.service.technorati.classes.dailycountsresultset>` Objekt
an.

.. note::

   ``Zend_Service_Technorati_DailyCountsResult`` erweitert :ref:`Zend_Service_Technorati_Result
   <zend.service.technorati.classes.result>`.

.. _zend.service.technorati.classes.tagsresult:

Zend_Service_Technorati_TagsResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Technorati_TagsResult`` repräsentiert ein einzelnes Technorati TopTags oder BlogPostTags Abfrage
Ergebnisobjekt. Es wird nie als alleinstehendes Objekt zurückgegeben, aber es gehört immer einem gültigen
:ref:`Zend_Service_Technorati_TagsResultSet <zend.service.technorati.classes.tagsresultset>` Objekt an.

.. note::

   ``Zend_Service_Technorati_TagsResult`` erweitert :ref:`Zend_Service_Technorati_Result
   <zend.service.technorati.classes.result>`.

.. _zend.service.technorati.classes.getinforesult:

Zend_Service_Technorati_GetInfoResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Technorati_GetInfoResult`` repräsentiert ein einzelnes Technorati GetInfo Abfrage Ergebnisobjekt.

.. _zend.service.technorati.classes.bloginforesult:

Zend_Service_Technorati_BlogInfoResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Technorati_BlogInfoResult`` repräsentiert ein einzelnes Technorati BlogInfo Abfrage Ergebnisobjekt.

.. _zend.service.technorati.classes.keyinforesult:

Zend_Service_Technorati_KeyInfoResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Technorati_KeyInfoResult`` repräsentiert ein einzelnes Technorati KeyInfo Abfrage Ergebnisobjekt.
Es bietet Informationen über die eigene :ref:`tägliche Verwendung des Technorati API Schlüssels
<zend.service.technorati.checking-api-daily-usage>`.



.. _`Technorati API Abfragen`: http://technorati.com/developers/api/
.. _`Technorati`: http://technorati.com/
.. _`Technorati API Dokumentation`: http://technorati.com/developers/api/
.. _`ein neuer Technorati Account erstellt werden`: http://technorati.com/signup/
.. _`API Schlüssel Sektion`: http://technorati.com/developers/apikey.html
.. _`API Referenz Guide`: http://framework.zend.com/apidoc/core/
.. _`Cosmos`: http://technorati.com/developers/api/cosmos.html
.. _`Search`: http://technorati.com/developers/api/search.html
.. _`Tag`: http://technorati.com/developers/api/tag.html
.. _`DailyCounts`: http://technorati.com/developers/api/dailycounts.html
.. _`TopTags`: http://technorati.com/developers/api/toptags.html
.. _`BlogInfo`: http://technorati.com/developers/api/bloginfo.html
.. _`BlogPostTags`: http://technorati.com/developers/api/blogposttags.html
.. _`GetInfo`: http://technorati.com/developers/api/getinfo.html
