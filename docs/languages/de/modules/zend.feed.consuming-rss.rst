.. EN-Revision: none
.. _zend.feed.consuming-rss:

Einen RSS Feed konsumieren
==========================

Einen *RSS* Feed zu lesen, ist so einfach wie das Instanziieren eines ``Zend_Feed_Rss`` Objekts mit der *URL* eines
Feeds:

.. code-block:: php
   :linenos:

   $channel = new Zend_Feed_Rss('http://rss.example.com/channelName');

Wenn beim Abrufen des Feeds Fehler auftreten, wird eine ``Zend_Feed_Exception`` geworfen.

Sobald du ein Feed Objekt hast, kannst du auf jeden Channel-Eigenschaften eines Standard *RSS* Feeds direkt über
das Objekt zugreifen:

.. code-block:: php
   :linenos:

   echo $channel->title();

Beachte die Syntax der Funktion. ``Zend_Feed`` verwendet die Konvention, die Eigenschaften als *XML* Objekt zu
behandeln, wenn sie durch die "Getter" Syntax für Variablen (``$obj->property``) angefordert werden, und als
String zu behandeln, wenn sie durch die Methodensyntax (``$obj->property()``) angefordert werden. Dies ermöglicht
den Zugriff auf den kompletten Text jedes individuellen Knotens, während weiterhin der komplette Zugriff auf alle
Kindelemente erlaubt ist.

Wenn Channel-Eigenschaften Attribute beinhalten, sind diese durch die *PHP* Array Syntax ansprechbar:

.. code-block:: php
   :linenos:

   echo $channel->category['domain'];

Da *XML* Attribute keine Kindelemente haben können, ist die Methodensyntax für den Zugriff auf Attributwerte
nicht notwendig.

Meistens möchtest Du einen Feed durchlaufen und etwas mit seinen Einträgen machen. ``Zend_Feed_Abstract``
implementiert das ``Iterator`` Interface von *PHP*, so dass die Ausgabe aller Artikelüberschriften eines Channels
nur dies erfordert:

.. code-block:: php
   :linenos:

   foreach ($channel as $item) {
       echo $item->title() . "\n";
   }

Wenn du mit *RSS* nicht vertraut bist, kommt hier eine Übersicht über die Standardelemente, die du in einem *RSS*
Channel und in einzelnen *RSS* Elementen (Einträgen) als verfügbar erwarten kannst.

Erforderliche Elemente eines Channels:

- ``title``- Der Name des Channels

- ``link``- Die *URL* einer Website, die dem Channel entspricht

- ``description``- Ein oder mehr Sätze, die den Channel beschreiben

Allgemeine optionale Elemente eines Channels:

- ``pubDate``- Das Erscheinungsdatum dieses Informationssatzes, im *RFC* 822 Datumsformat

- ``language``- Die Sprache, in der dieser Channel verfasst ist

- ``category``- Eine oder mehrere Kategorien (durch mehrfache Tags spezifiziert), zu denen der Channel gehört

*RSS* **<item>** Elemente haben keine strikt erforderlichen Elemente. Dennoch müssen entweder ``title`` oder
``description`` vorhanden sein.

Allgemeine Elements eines Eintrags:

- ``title``- Die Überschrift des Eintrags

- ``link``- Die *URL* des Eintrags

- ``description``- Eine Zusammenfassung des Eintrags

- ``author``- Die E-Mail Adresse des Autoren

- ``category``- Eine oder mehrere Kategorien, zu denen der Eintrag gehört

- ``comments``-*URL* der Kommentare zu diesem Eintrag

- ``pubDate``- Das Datum, an dem der Eintrag veröffentlicht wurde, im *RFC* 822 Datumsformat

In deinem Code kannst du hiermit immer überprüfen, ob ein Element nicht leer ist:

.. code-block:: php
   :linenos:

   if ($item->propname()) {
       // ... fahre fort.
   }

Wenn du stattdessen ``$item->propname`` verwendest, wirst du immer ein leeres Objekt erhalten, das mit ``TRUE``
evaluiert, so dass deine Prüfung fehlschlagen würde.

Für weitere Informationen ist die offizielle *RSS* 2.0 Specification hier verfügbar:
`http://blogs.law.harvard.edu/tech/rss`_



.. _`http://blogs.law.harvard.edu/tech/rss`: http://blogs.law.harvard.edu/tech/rss
