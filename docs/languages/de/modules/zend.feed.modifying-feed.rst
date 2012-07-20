.. _zend.feed.modifying-feed:

Verändern der Feed- und Eintragsstruktur
========================================

Die natürliche Syntax von ``Zend_Feed`` wurde für das Erstellen und Verändern von Feeds und Einträgen sowie das
Lesen dieser erweitert. Du kannst die neuen oder veränderten Objekte einfach in wohlgeformtes *XML* umsetzen, um
es als Datei zu speichern oder an einen Server zu senden.

.. _zend.feed.modifying-feed.example.modifying:

.. rubric:: Verändern eines bestehenden Feed Eintrags

.. code-block:: php
   :linenos:

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/1');
   $entry = $feed->current();

   $entry->title = 'Dies ist ein neuer Titel';
   $entry->author->email = 'my_email@example.com';

   echo $entry->saveXML();

Dies gibt eine vollständige (enthält den ``<?xml ... >`` Prolog) *XML* Darstellung des neuen Eintrags aus,
inklusive jedes notwendige *XML* Namensraumes.

Beachte, dass das Obige auch funktioniert, wenn der existierende Eintrag noch keinen Autoren Tag beinhaltet. Du
kannst soviele Ebenen von ``->`` Verweisen verwenden, wie Du möchtest, um auf eine Zuordnung zugreifen zu können;
alle dieser zwischengeschalteten Stufen werden automatisch für dich erstellt wenn notwendig.

Wenn du einen anderen Namensraum als ``atom:``, ``rss:``, oder ``osrss:`` in deinem Eintrag verwenden möchtest,
musst du den Namensraum mit ``Zend_Feed`` durch die Verwendung von ``Zend_Feed::registerNamespace()`` registrieren.
Wenn du ein bestehendes Element veränderst, wird es immer den ursprünglichen Namensraum beibehalten. Wenn du ein
neues Element hinzufügst, wird es den standardmäßigen Namensraum verwenden, wenn du nicht explizit einen anderen
Namensraum festgelegt hast.

.. _zend.feed.modifying-feed.example.creating:

.. rubric:: Erstellen eines Atom Eintrags mit Elementen eines eigenen Namensraumes

.. code-block:: php
   :linenos:

   $entry = new Zend_Feed_Entry_Atom();
   // Die ID wird immer vom Server in Atom zugewiesen
   $entry->title = 'mein eigener Eintrag';
   $entry->author->name = 'Beispiel Autor';
   $entry->author->email = 'me@example.com';

   // Nun erledige den eigenen Teil
   Zend_Feed::registerNamespace('myns', 'http://www.example.com/myns/1.0');

   $entry->{'myns:myelement_one'} = 'mein erster eigener Wert ';
   $entry->{'myns:container_elt'}->part1 = 'Erster verschachtelter Teil';
   $entry->{'myns:container_elt'}->part2 = 'Zweiter verschachtelter Teil';

   echo $entry->saveXML();


