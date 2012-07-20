.. _zend.service.simpy:

Zend_Service_Simpy
==================

.. _zend.service.simpy.introduction:

Einführung
----------

``Zend_Service_Simpy`` ist ein schlanker Wrapper für das freie REST *API* des Simpy Lesezeichen-Services.

Um ``Zend_Service_Simpy`` zu nutzen, solltest du bereits ein Simpy-Konto besitzen. Falls dies nicht der Fall ist,
kannst du dies auf der `Simpy Webseite`_ tun. Für weitere Informationen über das Simpy REST *API*, kannst du in
der `Simpy REST API Dokumentation`_ nachlesen.

Das Simpy REST *API* erlaubt es dem Entwickler, mit verschiedenen Aspekten des Services, welche die Simpy Webseite
bietet, zu interagieren. Diese Sektionen zeigen dir, wie man ``Zend_Service_Simpy`` in jedem dieser Bereiche nutzen
kann.



   - Links: Erstellen, Laden, Aktualisieren, Löschen

   - Tags: Laden, Löschen, Umbenennen, Zusammenfassen, Splitten

   - Notes: Erstellen, Laden, Aktualisieren, Löschen

   - Watchlists: Holen, Alle holen



.. _zend.service.simpy.links:

Links
-----

Beim Anfragen von Links, werden diese absteigend nach deren Datum - wann es hinzugefügt wurde - sortiert. Es kann
nach Links anhand des Titels, des Spitznamens, der Tags, der Notizen oder sogar des Inhalts der verknüpften
Webseite gesucht werden. Simpy erlaubt es, jegliche oder alle dieser Felder mit Phrasen, booleschen Operatoren und
Wildcards zu durchsuchen. Siehe in den `Suchsyntax`_- und `Suchfelder`_-Sektionen der Simipy FAQ für weitere
Informationen.

.. _zend.service.simpy.links.querying:

.. rubric:: Abfragen von Links

.. code-block:: php
   :linenos:

   $simpy = new Zend_Service_Simpy('yourusername', 'yourpassword');

   /* Suche nach den 10 letzten hinzugefügten Links */
   $linkQuery = new Zend_Service_Simpy_LinkQuery();
   $linkQuery->setLimit(10);

   /* Holen und darstellen */
   $linkSet = $simpy->getLinks($linkQuery);
   foreach ($linkSet as $link) {
       echo '<a href="';
       echo $link->getUrl();
       echo '">';
       echo $link->getTitle();
       echo '</a><br />';
   }

   /* Suche nach den 5 letzten hinzugefügten Links mit 'PHP'
   im Titel */
   $linkQuery->setQueryString('title:PHP');
   $linkQuery->setLimit(5);

   /* Suche nach allen Links mit 'French' im Titel und
   'lanuage' in den Tags */
   $linkQuery->setQueryString('+title:French +tags:language');

   /* Suche nach allen Links mit 'French' im Titel und ohne
   'travel' in den Tags */
   $linkQuery->setQueryString('+title:French -tags:travel');

   /* Suche nach allen Links, die am 9.12.2006 hinzugefügt wurden */
   $linkQuery->setDate('2006-12-09');

   /* Suche nach allen Links, die nach dem 9.12.2006 hinzugefügt wurden (
   das Datum ist nicht eingeschlossen) */
   $linkQuery->setAfterDate('2006-12-09');

   /* Suche nach allen Links, die vom dem 9.12.2006 hinzugefügt wurden (
   das angegebene Datum ist ausgeschlossen) */
   $linkQuery->setBeforeDate('2006-12-09');

   /* Suche nach allen Links, die zwischen dem 1.12.2006 und dem 9.12.2006
   hinzugefügt wurden (die beiden Daten sind dabei ausgeschlossen) */
   $linkQuery->setBeforeDate('2006-12-01');
   $linkQuery->setAfterDate('2006-12-09');

Links werden eindeutig durch ihren *URL* angezeigt. In anderen Worten, falls ein Versuch gemacht wird, einen Link
zu speichern, der denselben *URL* hat wie ein bereits existierender Link, werden die Daten des alten Links mit den
neuen Daten überschrieben.

.. _zend.service.simpy.links.modifying:

.. rubric:: Modifizieren von Links

.. code-block:: php
   :linenos:

   $simpy = new Zend_Service_Simpy('yourusername', 'yourpassword');

   /* Speichern eines link */
   $simpy->saveLink(
       'Zend Framework' // Titel
       'http://framework.zend.com', // URL
       Zend_Service_Simpy_Link::ACCESSTYPE_PUBLIC, // Zugriffstyp
       'zend, framework, php' // Tags
       'Zend Framework home page' // Alternativer Titel
       'This site rocks!' // Notiz
   );

   /* Überschreibe den existierenden Link mit neuen Daten */
   $simpy->saveLink(
       'Zend Framework'
       'http://framework.zend.com',
       // der Zugriffstyp wurde geändert
       Zend_Service_Simpy_Link::ACCESSTYPE_PRIVATE,
       // Die Reihenfolge der Tags hat sich geändert
       'php, zend, framework'
       // Alternativer Titel wurde geändert
       'Zend Framework'
       // Notiz hat sich geändert
       'This site REALLY rocks!'
   );

   /* Den Link löschen */
   $simpy->deleteLink('http://framework.zend.com');

   /* Ein wirklich einfacher Weg den Frühjahrsputz
      bei deinen Links zu machen ;-) */
   $linkSet = $this->_simpy->getLinks();
   foreach ($linkSet as $link) {
       $this->_simpy->deleteLink($link->getUrl());
   }

.. _zend.service.simpy.tags:

Tags
----

Wenn die Tags zurückgegeben werden, werden sie in absteigender Reihenfolge (d.h. der größte zuerst) nach der
Häufigkeit der Benutzung durch die Links sortiert.

.. _zend.service.simpy.tags.working:

.. rubric:: Arbeiten mit Tags

.. code-block:: php
   :linenos:

   $simpy = new Zend_Service_Simpy('yourusername', 'yourpassword');

   /* Speicher einen Link mit Tags */
   $simpy->saveLink(
       'Zend Framework' // Titel
       'http://framework.zend.com', // URL
       Zend_Service_Simpy_Link::ACCESSTYPE_PUBLIC, // Zugriffstyp
       'zend, framework, php' // Tags
   );

   /* Hole eine Liste mit allen Tags, die von Links und
   Notizen genutzt werden */
   $tagSet = $simpy->getTags();

   /* Stelle jeden Tag mit der Anzahl der Links, die ihn nutzen, dar */
   foreach ($tagSet as $tag) {
       echo $tag->getTag();
       echo ' - ';
       echo $tag->getCount();
       echo '<br />';
   }

   /* Entferne das 'zend'-Tag von allen Links, die es benutzen */
   $simpy->removeTag('zend');

   /* Nenne das 'framework'-Tag zu 'frameworks' um */
   $simpy->renameTag('framework', 'frameworks');

   /* Splitte das 'frameworks'-Tag in 'framework' und
   'development' auf. D.h. dass alle Links, die 'frameworks'
   als Tag besitzen, nunmehr stattdessen 'framework' und 'development'
   besitzen */
   $simpy->splitTag('frameworks', 'framework', 'development');

   /* Fasse 'framework' und 'development' wieder zu 'frameworks'
   zusammen; vereinfacht ist es das Gegenteil, ein Tag zu splitten */
   $simpy->mergeTags('framework', 'development', 'frameworks');

.. _zend.service.simpy.notes:

Notizen
-------

Notizen können gespeichert, geladen und gelöscht werden. Sie sind eindeutig durch eine numerische ID definiert.

.. _zend.service.simpy.notes.working:

.. rubric:: Arbeiten mit Notizen

.. code-block:: php
   :linenos:

   $simpy = new Zend_Service_Simpy('yourusername', 'yourpassword');

   /* Eine Notiz speichern */
   $simpy->saveNote(
       'Test Note', // Titel
       'test,note', // Tags
       'This is a test note.' // Beschreibung
   );

   /* Eine bereits existierende Notiz überschreiben */
   $simpy->saveNote(
       'Updated Test Note', // Titel
       'test,note,updated', // Tags
       'This is an updated test note.', // Beschreibung
       $note->getId() // Eindeutige ID
   );

   /* Suche nach den 10 letzten hinzugefügten Notizen */
   $noteSet = $simpy->getNotes(null, 10);

   /* Zeige diese Notizen an */
   foreach ($noteSet as $note) {
       echo '<p>';
       echo $note->getTitle();
       echo '<br />';
       echo $note->getDescription();
       echo '<br >';
       echo $note->getTags();
       echo '</p>';
   }

   /* Suche nach allen Notizen mit 'PHP' im Titel */
   $noteSet = $simpy->getNotes('title:PHP');

   /* Suche nach allen Notizen mit 'PHP' im Titel und ohne
   'framework' in der Beschreibung */
   $noteSet = $simpy->getNotes('+title:PHP -description:framework');

   /* Löschen einer Notiz */
   $simpy->deleteNote($note->getId());

.. _zend.service.simpy.watchlists:

Watchlists
----------

Watchlisten können durch das *API* nicht erstellt oder entfernt werden, sondern lediglich zurückgegeben. Folglich
musst du eine Watchlist über die Simpy Webseite erstellen, bevor du diese über das *API* nutzt.

.. _zend.service.simpy.watchlists.retrieving:

.. rubric:: Zurückgeben von Watchlisten

.. code-block:: php
   :linenos:

   $simpy = new Zend_Service_Simpy('yourusername', 'yourpassword');

   /* Hole eine Liste von allen Watchlisten */
   $watchlistSet = $simpy->getWatchlists();

   /* Zeige die Daten jeder Watchlist an */
   foreach ($watchlistSet as $watchlist) {
       echo $watchlist->getId();
       echo '<br />';
       echo $watchlist->getName();
       echo '<br />';
       echo $watchlist->getDescription();
       echo '<br />';
       echo $watchlist->getAddDate();
       echo '<br />';
       echo $watchlist->getNewLinks();
       echo '<br />';

       foreach ($watchlist->getUsers() as $user) {
           echo $user;
           echo '<br />';
       }

       foreach ($watchlist->getFilters() as $filter) {
           echo $filter->getName();
           echo '<br />';
           echo $filter->getQuery();
           echo '<br />';
       }
   }

   /* Hole eine spezielle Watchlist anhand einer ID */
   $watchlist = $simpy->getWatchlist($watchlist->getId());
   $watchlist = $simpy->getWatchlist(1);



.. _`Simpy Webseite`: http://simpy.com
.. _`Simpy REST API Dokumentation`: http://www.simpy.com/doc/api/rest
.. _`Suchsyntax`: http://www.simpy.com/faq#searchSyntax
.. _`Suchfelder`: http://www.simpy.com/faq#searchFieldsLinks
