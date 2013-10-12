.. EN-Revision: none
.. _zendservice.technorati:

ZendService\Technorati
=======================

.. _zendservice.technorati.introduction:

Einführung
----------

``ZendService\Technorati`` bietet ein einfaches, intuitives und objekt-orientiertes Interface für die Verwendung
der Technorati *API*. Es bietet Zugriff zu allen vorhandenen `Technorati API Abfragen`_ und gibt die originalen
*XML* Antworten als freundliches *PHP* Objekt zurück.

`Technorati`_ ist eine der populärsten Blog Suchmaschinen. Das *API* Interface ermöglicht es Entwicklern
Informationen über einen spezifischen Blog zu erhalten, Blogs zu suchen die einem einzelnen Tag oder einer Phrase
entsprechen und Informationen über einen spezifischen Author (Blogger) erhalten. Für eine komplette Liste von
vorhandenen Abfragen kann in die `Technorati API Dokumentation`_ oder die :ref:`vorhandenen Technorati Abfragen
<zendservice.technorati.queries>` Sektion dieses Dokuments gesehen werden.

.. _zendservice.technorati.getting-started:

Anfangen
--------

Technorati benötigt einen gültigen *API* Schlüssel zur Verwendung. Um einen eigenen *API* Schlüssel zu erhalten
muss `ein neuer Technorati Account erstellt werden`_, und anschließend die `API Schlüssel Sektion`_ besucht
werden.

.. note::

   **API Schlüssel Beschränkungen**

   Es können bis zu 500 Technirati *API* Aufrufe pro Tag durchgeführt werden ohne das Kosten anfallen. Andere
   Limitationen der Verwendung können vorhanden sein, abhängig von der aktuellen Technorati *API* Lizenz.

Sobald man einen gültigen *API* Schlüssel hat, kann man beginnen ``ZendService\Technorati`` zu verwenden.

.. _zendservice.technorati.making-first-query:

Die erste Abfrage durchführen
-----------------------------

Um eine Abfrage durchzuführen, benötigt man zuerst eine ``ZendService\Technorati`` Instanz mit einem gültigen
*API* Schlüssel. Dann kann eine der vorhandenen Abfragemethoden ausgewählt werden, und durch Angabe der
benötigen Argumente aufgerufen werden.

.. _zendservice.technorati.making-first-query.example-1:

.. rubric:: Die erste Abfragen senden

.. code-block:: php
   :linenos:

   // ein neues ZendService\Technorati mit einem gültigen API_KEY erstellen
   $technorati = new ZendService\Technorati('VALID_API_KEY');

   // Technorati nach dem Schlüsselwort PHP durchsuchen
   $resultSet = $technorati->search('PHP');

Jede Abfragemethode akzeptiert ein Array von optionalen Parametern die verwendet werden kann um die Abfrage zu
verfeinern.

.. _zendservice.technorati.making-first-query.example-2:

.. rubric:: Verfeinern der Abfrage

.. code-block:: php
   :linenos:

   // ein neues ZendService\Technorati mit einem gültigen API_KEY erstellen
   $technorati = new ZendService\Technorati('VALID_API_KEY');

   // Die Abfrage nach Ergebnissen mit etwas Authority filtern
   // (Ergebnisse von Blogs mit einer Handvoll Links)
   $options = array('authority' => 'a4');

   // Technorati nach dem Schlüsselwort PHP durchsuchen
   $resultSet = $technorati->search('PHP', $options);

Eine ``ZendService\Technorati`` Instanz ist kein einmal zu verwendendes Objekt. Deswegen muß keine neue Instanz
für jede Abfrage erstellt werden; es kann einfach das aktuelle ``ZendService\Technorati`` Objekt solange
verwendet werden wie es benötigt wird.

.. _zendservice.technorati.making-first-query.example-3:

.. rubric:: Mehrfache Abfragen mit der gleichen ZendService\Technorati Instanz senden

.. code-block:: php
   :linenos:

   // ein neues ZendService\Technorati mit einem gültigen API_KEY erstellen
   $technorati = new ZendService\Technorati('VALID_API_KEY');

   // Technorati nach dem Schlüsselwort PHP durchsuchen
   $search = $technorati->search('PHP');

   // Top Tags die von Technorati indiziert wurden erhalten
   $topTags = $technorati->topTags();

.. _zendservice.technorati.consuming-results:

Ergebnisse verarbeiten
----------------------

Es kann einer von zwei Typen von Ergebnisobjekten als Antwort auf eine Abfrage empfangen werden.

Die erste Gruppe wird durch ``ZendService\Technorati\*ResultSet`` Objekte repräsentiert. Ein Ergebnisset Objekt
ist grundsätzlich eine Kollektion von Ergebnisobjekten. Es erweitert die grundsätzliche
``ZendService\Technorati\ResultSet`` Klasse und implementiert das *PHP* Interface ``SeekableIterator``. Der beste
Weg um ein Ergebnisset Objekt zu verarbeiten ist dieses mit einem *PHP* ``foreach()`` Statement zu durchlaufen.

.. _zendservice.technorati.consuming-results.example-1:

.. rubric:: Ein Ergebnisset Objekt verarbeiten

.. code-block:: php
   :linenos:

   // ein neues ZendService\Technorati mit einem gültigen API_KEY erstellen
   $technorati = new ZendService\Technorati('VALID_API_KEY');

   // Technorati nach dem PHP Schlüsselwort durchsuchen
   // $resultSet ist eine Instanz von ZendService\Technorati\SearchResultSet
   $resultSet = $technorati->search('PHP');

   // Alle Ergebnisobjekte durchlaufen
   foreach ($resultSet as $result) {
       // $result ist eine Instanz von ZendService\Technorati\SearchResult
   }

Weil ``ZendService\Technorati\ResultSet`` das ``SeekableIterator`` Interface implementiert, kann ein spezifisches
Ergebnisobjekt gesucht werden indem dessen Position in der Ergebnissammlung verwendet wird.

.. _zendservice.technorati.consuming-results.example-2:

.. rubric:: Ein spezifisches Ergebnisset Objekt suchen

.. code-block:: php
   :linenos:

   // ein neues ZendService\Technorati mit einem gültigen API_KEY erstellen
   $technorati = new ZendService\Technorati('VALID_API_KEY');

   // Technorati nach dem PHP Schlüsselwort durchsuchen
   // $resultSet ist eine Instanz von ZendService\Technorati\SearchResultSet
   $resultSet = $technorati->search('PHP');

   // $result ist eine Instanz von ZendService\Technorati\SearchResult
   $resultSet->seek(1);
   $result = $resultSet->current();

.. note::

   ``SeekableIterator`` arbeitet als Array und zählt Positionen beginnend vom Index 0. Das Holen der Position 1
   bedeutet das man das zweite Ergebnis der Kollektion erhält.

Die zweite Gruppe wird durch spezielle alleinstehende Ergebnisobjekte repräsentiert.
``ZendService\Technorati\GetInfoResult``, ``ZendService\Technorati\BlogInfoResult`` und
``ZendService\Technorati\KeyInfoResult`` funktionieren als Wrapper für zusätzliche Objekte, wie
``ZendService\Technorati\Author`` und ``ZendService\Technorati\Weblog``.

.. _zendservice.technorati.consuming-results.example-3:

.. rubric:: Ein alleinstehendes Ergebnisobjekt verarbeiten

.. code-block:: php
   :linenos:

   // ein neues ZendService\Technorati mit einem gültigen API_KEY erstellen
   $technorati = new ZendService\Technorati('VALID_API_KEY');

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

Bitte lesen Sie das :ref:`ZendService\Technorati Klassen <zendservice.technorati.classes>` Kapitel für weitere
Details über Antwortklassen.

.. _zendservice.technorati.handling-errors:

Fehler behandeln
----------------

Jede ``ZendService\Technorati`` Abfragemethode wirft bei einem Fehler eine ``ZendService\Technorati\Exception``
Ausnahme mit einer bedeutungsvollen Fehlermeldung.

Es gibt verschiedene Gründe die Verursachen können das eine ``ZendService\Technorati`` Abfrage fehlschlägt.
``ZendService\Technorati`` prüft alle Parameter für jegliche Abfrageanfragen. Wenn ein Parameter ungültig ist
oder er einen ungültigen Wert enthält, wird eine neue ``ZendService\Technorati\Exception`` Ausnahme geworfen.
Zusätzlich kann das Technorati *API* Interface temporär unerreichbar sein, oder es kann eine Antwort zurückgeben
die nicht gültig ist.

Eine Technorati Abfrage sollte immer mit einem ``try ... catch`` Block umhüllt werden.

.. _zendservice.technorati.handling-errors.example-1:

.. rubric:: Eine Abfrageausnahme behandeln

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati('VALID_API_KEY');
   try {
       $resultSet = $technorati->search('PHP');
   } catch(ZendService\Technorati\Exception $e) {
       echo "Ein Fehler ist aufgetreten: " $e->getMessage();
   }

.. _zendservice.technorati.checking-api-daily-usage:

Prüfen der täglichen Verwendung des eigenen API Schlüssels
----------------------------------------------------------

Von Zeit zu Zeit wird man die tägliche Verwendung des *API* Schlüssels prüfen wollen. Standardmäßig limitiert
Technorati die *API* Verwendung auf 500 Aufrufe pro Tag, und eine Ausnahme wird durch ``ZendService\Technorati``
zurückgegeben wenn versucht wird dieses Limit zu überschreiten. Man kann diese Information über die Verwendung
des eigenen *API* Schlüssels erhalten indem die ``ZendService\Technorati::keyInfo()`` Methode verwendet wird.

``ZendService\Technorati::keyInfo()`` gibt ein ``ZendService\Technorati\KeyInfoResult`` Object zurück. Für
vollständige Details kann im `API Referenz Guide`_ nachgesehen werden.

.. _zendservice.technorati.checking-api-daily-usage.example-1:

.. rubric:: Die Information über die tägliche Verwendung des API Schlüssels erhalten

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati('VALID_API_KEY');
   $key = $technorati->keyInfo();

   echo "API Schlüssel: " . $key->getApiKey() . "<br />";
   echo "Tägliche Verwendung: " . $key->getApiQueries() . "/" .
        $key->getMaxQueries() . "<br />";

.. _zendservice.technorati.queries:

Vorhandene Technorati Abfragen
------------------------------

``ZendService\Technorati`` bietet Unterstützung für die folgenden Abfragen:



   - :ref:`Cosmos <zendservice.technorati.queries.cosmos>`

   - :ref:`Search <zendservice.technorati.queries.search>`

   - :ref:`Tag <zendservice.technorati.queries.tag>`

   - :ref:`DailyCounts <zendservice.technorati.queries.dailycounts>`

   - :ref:`TopTags <zendservice.technorati.queries.toptags>`

   - :ref:`BlogInfo <zendservice.technorati.queries.bloginfo>`

   - :ref:`BlogPostTags <zendservice.technorati.queries.blogposttags>`

   - :ref:`GetInfo <zendservice.technorati.queries.getinfo>`



.. _zendservice.technorati.queries.cosmos:

Technorati Cosmos
^^^^^^^^^^^^^^^^^

Eine `Cosmos`_ Abfrage lässt einen Sehen welche Blog zu einer gegebenen *URL* verknüpft sind. Sie gibt ein
:ref:`ZendService\Technorati\CosmosResultSet <zendservice.technorati.classes.cosmosresultset>` Objekt zurück.
Für vollständige Details kann nach ``ZendService\Technorati::cosmos()`` im `API Referenz Guide`_ nachgesehen
werden.

.. _zendservice.technorati.queries.cosmos.example-1:

.. rubric:: Cosmos Abfrage

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati('VALID_API_KEY');
   $resultSet = $technorati->cosmos('http://devzone.zend.com/');

   echo "<p>Liest " . $resultSet->totalResults() .
        " von " . $resultSet->totalResultsAvailable() .
        " vorhandenen Ergebnissen</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getWeblog()->getName() . "</li>";
   }
   echo "</ol>";

.. _zendservice.technorati.queries.search:

Technorati Search
^^^^^^^^^^^^^^^^^

Die `Search`_ Abfrage lässt einen Sehen welche Blogs einen gegebenen Suchstring enthalten. Sie gibt ein
:ref:`ZendService\Technorati\SearchResultSet <zendservice.technorati.classes.searchresultset>` Objekt zurück.
Für vollständige Details kann nach ``ZendService\Technorati::search()`` im `API Referenz Guide`_ nachgesehen
werden.

.. _zendservice.technorati.queries.search.example-1:

.. rubric:: Suchabfrage

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati('VALID_API_KEY');
   $resultSet = $technorati->search('zend framework');

   echo "<p>Liest " . $resultSet->totalResults() .
        " von " . $resultSet->totalResultsAvailable() .
        " vorhandenen Ergebnissen</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getWeblog()->getName() . "</li>";
   }
   echo "</ol>";

.. _zendservice.technorati.queries.tag:

Technorati Tag
^^^^^^^^^^^^^^

Die `Tag`_ Abfrage lässt einen Sehen welche Antworten mit einem gegebenen Tag assoziiert sind. Sie gibt ein
:ref:`ZendService\Technorati\TagResultSet <zendservice.technorati.classes.tagresultset>` Objekt zurück. Für
vollständige Details kann nach ``ZendService\Technorati::tag()`` im `API Referenz Guide`_ nachgesehen werden.

.. _zendservice.technorati.queries.tag.example-1:

.. rubric:: Tag Abfrage

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati('VALID_API_KEY');
   $resultSet = $technorati->tag('php');

   echo "<p>Liest " . $resultSet->totalResults() .
        " von " . $resultSet->totalResultsAvailable() .
        " vorhandenen Ergebnissen</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getWeblog()->getName() . "</li>";
   }
   echo "</ol>";

.. _zendservice.technorati.queries.dailycounts:

Technorati DailyCounts
^^^^^^^^^^^^^^^^^^^^^^

Die `DailyCounts`_ Abfrage bietet tägliche Anzahlen von Antworten die ein abgefragtes Schlüsselwort enthalten.
Sie gibt ein :ref:`ZendService\Technorati\DailyCountsResultSet
<zendservice.technorati.classes.dailycountsresultset>` Objekt zurück. Für vollständige Details kann nach
``ZendService\Technorati::dailyCounts()`` im `API Referenz Guide`_ nachgesehen werden.

.. _zendservice.technorati.queries.dailycounts.example-1:

.. rubric:: DailyCounts Abfrage

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati('VALID_API_KEY');
   $resultSet = $technorati->dailyCounts('php');

   foreach ($resultSet as $result) {
       echo "<li>" . $result->getDate() .
            "(" . $result->getCount() . ")</li>";
   }
   echo "</ol>";

.. _zendservice.technorati.queries.toptags:

Technorati TopTags
^^^^^^^^^^^^^^^^^^

Die `TopTags`_ Abfrage bietet Informationen über Top Tags die durch Technorati indiziert sind. Sie gibt ein
:ref:`ZendService\Technorati\TagsResultSet <zendservice.technorati.classes.tagsresultset>` Objekt zurück. Für
vollständige Details kann nach ``ZendService\Technorati::topTags()`` im `API Referenz Guide`_ nachgesehen werden.

.. _zendservice.technorati.queries.toptags.example-1:

.. rubric:: TopTags Abfrage

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati('VALID_API_KEY');
   $resultSet = $technorati->topTags();

   echo "<p>Liest " . $resultSet->totalResults() .
        " von " . $resultSet->totalResultsAvailable() .
        "  vorhandenen Ergebnissen</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getTag() . "</li>";
   }
   echo "</ol>";

.. _zendservice.technorati.queries.bloginfo:

Technorati BlogInfo
^^^^^^^^^^^^^^^^^^^

Eine `BlogInfo`_ Abfrage bietet Informationen darüber welcher Blog, wenn überhaupt, mit einer gegebenen *URL*
assoziiert ist. Sie gibt ein :ref:`ZendService\Technorati\BlogInfoResult
<zendservice.technorati.classes.bloginforesult>` Objekt zurück. Für vollständige Details kann nach
``ZendService\Technorati::blogInfo()`` im `API Referenz Guide`_ nachgesehen werden.

.. _zendservice.technorati.queries.bloginfo.example-1:

.. rubric:: BlogInfo Abfrage

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati('VALID_API_KEY');
   $result = $technorati->blogInfo('http://devzone.zend.com/');

   echo '<h2><a href="' . (string) $result->getWeblog()->getUrl() . '">' .
        $result->getWeblog()->getName() . '</a></h2>';

.. _zendservice.technorati.queries.blogposttags:

Technorati BlogPostTags
^^^^^^^^^^^^^^^^^^^^^^^

Eine `BlogPostTags`_ Abfrage bietet Informationen über Top Tags die von einem spezifischen Blog verwendet werden.
Sie gibt ein :ref:`ZendService\Technorati\TagsResultSet <zendservice.technorati.classes.tagsresultset>` Objekt
zurück. Für vollständige Details kann nach ``ZendService\Technorati::blogPostTags()`` im `API Referenz Guide`_
nachgesehen werden.

.. _zendservice.technorati.queries.blogposttags.example-1:

.. rubric:: BlogPostTags Abfrage

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati('VALID_API_KEY');
   $resultSet = $technorati->blogPostTags('http://devzone.zend.com/');

   echo "<p>Liest " . $resultSet->totalResults() .
        " von " . $resultSet->totalResultsAvailable() .
        " vorhandenen Ergebnissen</p>";
   echo "<ol>";
   foreach ($resultSet as $result) {
       echo "<li>" . $result->getTag() . "</li>";
   }
   echo "</ol>";

.. _zendservice.technorati.queries.getinfo:

Technorati GetInfo
^^^^^^^^^^^^^^^^^^

Eine `GetInfo`_ Abfrage teilt mit was Technorati über ein Mitglied weiß. Sie gibt ein
:ref:`ZendService\Technorati\GetInfoResult <zendservice.technorati.classes.getinforesult>` Objekt zurück. Für
vollständige Details kann nach ``ZendService\Technorati::getInfo()`` im `API Referenz Guide`_ nachgesehen werden.

.. _zendservice.technorati.queries.getinfo.example-1:

.. rubric:: GetInfo Abfrage

.. code-block:: php
   :linenos:

   $technorati = new ZendService\Technorati('VALID_API_KEY');
   $result = $technorati->getInfo('weppos');

   $author = $result->getAuthor();
   echo "<h2>Blogs authorisiert von " . $author->getFirstName() . " " .
        $author->getLastName() . "</h2>";
   echo "<ol>";
   foreach ($result->getWeblogs() as $weblog) {
       echo "<li>" . $weblog->getName() . "</li>";
   }
   echo "</ol>";

.. _zendservice.technorati.queries.keyinfo:

Technorati KeyInfo
^^^^^^^^^^^^^^^^^^

Die KeyInfo Abfrage bietet Informationen über die tägliche Verwendung eines *API* Schlüssels. Sie gibt ein
:ref:`ZendService\Technorati\KeyInfoResult <zendservice.technorati.classes.keyinforesult>` Objekt zurück. Für
vollständige Details kann nach ``ZendService\Technorati::keyInfo()`` im `API Referenz Guide`_ nachgesehen werden.

.. _zendservice.technorati.classes:

ZendService\Technorati Klassen
-------------------------------

Die folgenden Klassen werden von den verschiedenen Technorati Anfragen zurückgegeben. Jede
``ZendService\Technorati\*ResultSet`` Klasse enthält ein typ-spezifisches Ergebnisset welches einfach, mit jedem
Ergebnis das in einem Typ Ergebnisobjekt enthalten ist, iteriert werden kann. Alle Ergebnisset Klassen erweitern
die ``ZendService\Technorati\ResultSet`` Klasse und implementieren das ``SeekableIterator`` Interface, welches
eine einfache Iteration und Suche nach einem spezifischen Ergebnis erlaubt.



   - :ref:`ZendService\Technorati\ResultSet <zendservice.technorati.classes.resultset>`

   - :ref:`ZendService\Technorati\CosmosResultSet <zendservice.technorati.classes.cosmosresultset>`

   - :ref:`ZendService\Technorati\SearchResultSet <zendservice.technorati.classes.searchresultset>`

   - :ref:`ZendService\Technorati\TagResultSet <zendservice.technorati.classes.tagresultset>`

   - :ref:`ZendService\Technorati\DailyCountsResultSet <zendservice.technorati.classes.dailycountsresultset>`

   - :ref:`ZendService\Technorati\TagsResultSet <zendservice.technorati.classes.tagsresultset>`

   - :ref:`ZendService\Technorati\Result <zendservice.technorati.classes.result>`

   - :ref:`ZendService\Technorati\CosmosResult <zendservice.technorati.classes.cosmosresult>`

   - :ref:`ZendService\Technorati\SearchResult <zendservice.technorati.classes.searchresult>`

   - :ref:`ZendService\Technorati\TagResult <zendservice.technorati.classes.tagresult>`

   - :ref:`ZendService\Technorati\DailyCountsResult <zendservice.technorati.classes.dailycountsresult>`

   - :ref:`ZendService\Technorati\TagsResult <zendservice.technorati.classes.tagsresult>`

   - :ref:`ZendService\Technorati\GetInfoResult <zendservice.technorati.classes.getinforesult>`

   - :ref:`ZendService\Technorati\BlogInfoResult <zendservice.technorati.classes.bloginforesult>`

   - :ref:`ZendService\Technorati\KeyInfoResult <zendservice.technorati.classes.keyinforesult>`



.. note::

   ``ZendService\Technorati\GetInfoResult``, ``ZendService\Technorati\BlogInfoResult`` und
   ``ZendService\Technorati\KeyInfoResult`` repräsentieren Ausnahmen zu den obigen weil Sie nicht zu einem
   ergebnisset gehören und sie kein Interface implementieren. Sie repräsentieren ein einzelnes Antwortobjekt und
   sie funktionieren als Wrapper für zusätzliche ``ZendService\Technorati`` Objekte, wie
   ``ZendService\Technorati\Author`` und ``ZendService\Technorati\Weblog``.

Die ``ZendService\Technorati`` Bibliothek beinhaltet zusätzliche bequeme Klassen die spezifische Antwortobjekte
repräsentieren. ``ZendService\Technorati\Author`` repräsentiert einen einzelnen Technorati Account, welcher auch
als Blog Author oder Blogger bekannt ist. ``ZendService\Technorati\Weblog`` repräsentiert ein einzelnes Weblog
Objekt, zusätzlich mit allen spezifischen Weblog Eigenschaften die Feed *URL*\ s oder Blog Namen. Für komplette
Details kann nach ``ZendService\Technorati`` im `API Referenz Guide`_ nachgesehen werden.

.. _zendservice.technorati.classes.resultset:

ZendService\Technorati\ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\ResultSet`` ist das am meisten essentielle Ergebnisset. Der Zweck dieser Klasse ist es
von einer abfrage-spezifischen Kind-Ergebnisset-Klasse erweitert zu werden, und sie sollte niemals verwendet werden
um ein alleinstehendes Objekt zu initialisieren. Jedes der spezifischen Ergebnissets repräsentiert eine Kollektion
von abfrage-spezifischen :ref:`ZendService\Technorati\Result <zendservice.technorati.classes.result>` Objekte.

``ZendService\Technorati\ResultSet`` Implementiert das *PHP* ``SeekableIterator`` Interface, und man kann durch
alle Ergebnisobjekte mit dem *PHP* Statement ``foreach()`` iterieren.

.. _zendservice.technorati.classes.resultset.example-1:

.. rubric:: Über Ergebnisobjekte von einer Ergebnisset Kollektion iterieren

.. code-block:: php
   :linenos:

   // eine einfache Abfrage durchlaufen
   $technorati = new ZendService\Technorati('VALID_API_KEY');
   $resultSet = $technorati->search('php');

   // $resultSet ist jetzt eine Instanz von
   // ZendService\Technorati\SearchResultSet
   // sie erweitert ZendService\Technorati\ResultSet
   foreach ($resultSet as $result) {
       // irgendwas mit dem ZendService\Technorati\SearchResult Objekt anfangen
   }

.. _zendservice.technorati.classes.cosmosresultset:

ZendService\Technorati\CosmosResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\CosmosResultSet`` repräsentiert ein Technorati Cosmos Abfrage Ergebnisset.

.. note::

   ``ZendService\Technorati\CosmosResultSet`` erweitert :ref:`ZendService\Technorati\ResultSet
   <zendservice.technorati.classes.resultset>`.

.. _zendservice.technorati.classes.searchresultset:

ZendService\Technorati\SearchResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\SearchResultSet`` repräsentiert ein Technorati Search Abfrage Ergebnisset.

.. note::

   ``ZendService\Technorati\SearchResultSet`` erweitert :ref:`ZendService\Technorati\ResultSet
   <zendservice.technorati.classes.resultset>`.

.. _zendservice.technorati.classes.tagresultset:

ZendService\Technorati\TagResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\TagResultSet`` repräsentiert ein Technorati Tag Abfrage Ergebnisset.

.. note::

   ``ZendService\Technorati\TagResultSet`` erweitert :ref:`ZendService\Technorati\ResultSet
   <zendservice.technorati.classes.resultset>`.

.. _zendservice.technorati.classes.dailycountsresultset:

ZendService\Technorati\DailyCountsResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\DailyCountsResultSet`` repräsentiert ein Technorati DailyCounts Abfrage Ergebnisset.

.. note::

   ``ZendService\Technorati\DailyCountsResultSet`` erweitert :ref:`ZendService\Technorati\ResultSet
   <zendservice.technorati.classes.resultset>`.

.. _zendservice.technorati.classes.tagsresultset:

ZendService\Technorati\TagsResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\TagsResultSet`` repräsentiert ein Technorati TopTags oder BlogPostTags Abfrage
Ergebnisset.

.. note::

   ``ZendService\Technorati\TagsResultSet`` erweitert :ref:`ZendService\Technorati\ResultSet
   <zendservice.technorati.classes.resultset>`.

.. _zendservice.technorati.classes.result:

ZendService\Technorati\Result
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\Result`` ist das wichtigste Ergebnisobjekt. Der Zweck dieser Klasse ist es, durch eine
abfrage-spezifische Kind-Ergebnisklasse erweitert zu werden, und Sie sollte nie verwendet werden um ein
alleinstehendes Objekt zu initiieren.

.. _zendservice.technorati.classes.cosmosresult:

ZendService\Technorati\CosmosResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\CosmosResult`` repräsentiert ein einzelnes Technorati Cosmos Abfrageobjekt. Es wird nie
als alleinstehendes Objekt zurückgegeben, aber es gehört immer einem gültigen
:ref:`ZendService\Technorati\CosmosResultSet <zendservice.technorati.classes.cosmosresultset>` Objekt an.

.. note::

   ``ZendService\Technorati\CosmosResult`` erweitert :ref:`ZendService\Technorati\Result
   <zendservice.technorati.classes.result>`.

.. _zendservice.technorati.classes.searchresult:

ZendService\Technorati\SearchResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\SearchResult`` repräsentiert ein einzelnes Technorati Search Abfrage Ergebnisobjekt. Es
wird nie als alleinstehendes Objekt zurückgegeben, aber es gehört immer einem gültigen
:ref:`ZendService\Technorati\SearchResultSet <zendservice.technorati.classes.searchresultset>` Objekt an.

.. note::

   ``ZendService\Technorati\SearchResult`` erweitert :ref:`ZendService\Technorati\Result
   <zendservice.technorati.classes.result>`.

.. _zendservice.technorati.classes.tagresult:

ZendService\Technorati\TagResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\TagResult`` repräsentiert ein einzelnes Technorati Tag Abfrage Ergebnisobjekt. Es wird
nie als alleinstehendes Objekt zurückgegeben, aber es gehört immer einem gültigen
:ref:`ZendService\Technorati\TagResultSet <zendservice.technorati.classes.tagresultset>` Objekt an.

.. note::

   ``ZendService\Technorati\TagResult`` erweitert :ref:`ZendService\Technorati\Result
   <zendservice.technorati.classes.result>`.

.. _zendservice.technorati.classes.dailycountsresult:

ZendService\Technorati\DailyCountsResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\DailyCountsResult`` repräsentiert ein einzelnes Technorati DailyCounts Abfrage
Ergebnisobjekt. Es wird nie als alleinstehendes Objekt zurückgegeben, aber es gehört immer einem gültigen
:ref:`ZendService\Technorati\DailyCountsResultSet <zendservice.technorati.classes.dailycountsresultset>` Objekt
an.

.. note::

   ``ZendService\Technorati\DailyCountsResult`` erweitert :ref:`ZendService\Technorati\Result
   <zendservice.technorati.classes.result>`.

.. _zendservice.technorati.classes.tagsresult:

ZendService\Technorati\TagsResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\TagsResult`` repräsentiert ein einzelnes Technorati TopTags oder BlogPostTags Abfrage
Ergebnisobjekt. Es wird nie als alleinstehendes Objekt zurückgegeben, aber es gehört immer einem gültigen
:ref:`ZendService\Technorati\TagsResultSet <zendservice.technorati.classes.tagsresultset>` Objekt an.

.. note::

   ``ZendService\Technorati\TagsResult`` erweitert :ref:`ZendService\Technorati\Result
   <zendservice.technorati.classes.result>`.

.. _zendservice.technorati.classes.getinforesult:

ZendService\Technorati\GetInfoResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\GetInfoResult`` repräsentiert ein einzelnes Technorati GetInfo Abfrage Ergebnisobjekt.

.. _zendservice.technorati.classes.bloginforesult:

ZendService\Technorati\BlogInfoResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\BlogInfoResult`` repräsentiert ein einzelnes Technorati BlogInfo Abfrage Ergebnisobjekt.

.. _zendservice.technorati.classes.keyinforesult:

ZendService\Technorati\KeyInfoResult
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``ZendService\Technorati\KeyInfoResult`` repräsentiert ein einzelnes Technorati KeyInfo Abfrage Ergebnisobjekt.
Es bietet Informationen über die eigene :ref:`tägliche Verwendung des Technorati API Schlüssels
<zendservice.technorati.checking-api-daily-usage>`.



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
