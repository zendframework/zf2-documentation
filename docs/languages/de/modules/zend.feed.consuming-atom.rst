.. EN-Revision: none
.. _zend.feed.consuming-atom:

Einen Atom Feed konsumieren
===========================

``Zend_Feed_Atom`` wird auf die ziemlich genau selbe Weise verwendet wie ``Zend_Feed_Rss``. Es stellt die gleichen
Zugriffsmöglichkeiten auf Eigenschaften auf Feed Ebene und bei der Iteration über Einträge des Feeds bereit. Der
Hauptunterschied ist die Struktur des Atom Protokolls selber. Atom ist ein Nachfolger von *RSS*; es ist ein mehr
verallgemeinertes Protokoll und es wurde gestaltet, um einfacher mit Feeds umzugehen, die ihren kompletten Inhalt
innerhalb des Feeds bereit stellen, indem für diesen Zweck der ``description`` Tag von *RSS* in die zwei Elemente
``summary`` und ``content`` aufgeteilt wird.

.. _zend.feed.consuming-atom.example.usage:

.. rubric:: Grundlegende Verwendung eines Atom Feeds

Lese einen Atom Feed und gebe ``title`` und ``summary`` jedes Eintrages aus:

.. code-block:: php
   :linenos:

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/');
   echo 'Der Feed enthält ' . $feed->count() . ' Einträge.' . "\n\n";
   foreach ($feed as $entry) {
       echo 'Überschrift: ' . $entry->title() . "\n";
       echo 'Zusammenfassung: ' . $entry->summary() . "\n\n";
   }

In einem Atom Feed kannst du die folgenden Feed-Eigenschaften erwarten:

- ``title``- Die Überschrift des Feeds, gleichbedeutend mit der Überschrift eines *RSS* Channels

- ``id``- Jeder Feed und Eintrag hat in Atom einen einzigartige Bezeichner

- ``link``- Feeds können mehrere Links enthalten, welche durch ein ``type`` Attribut ausgezeichnet werden

  In einem *RSS* Channel wäre dies gleichbedeutend mit ``type="text/html"``. Wenn der Link auf eine alternative
  Version des selben Inhalts verweist, der nicht im Feed enthalten ist, würde es ein ``rel="alternate"`` Attribut
  enthalten.

- ``subtitle``- Die Beschreibung des Feeds, gleichbedeutend mit der Beschreibung eines *RSS* Channels

  ``author->name()``- Der Name des Autoren des Feeds

  ``author->email()``- Die E-Mail Adresse des Autoren des Feeds

Atom Einträge haben normalerweise folgende Eigenschaften:

- ``id``- Der einzigartige Bezeichner des Eintrags

- ``title``- Die Überschrift des Eintrags, gleichbedeutend mit der Überschrift eines *RSS* Eintrags

- ``link``- Ein Link zu einem anderen Format oder einer alternativen Ansicht diesen Eintrags

- ``summary``- Eine Zusammenfassung des Inhalts dieses Eintrags

- ``content``- Der komplette Inhalt des Eintrags; kann übersprungen werden, wenn der Feed nur Zusammenfassungen
  enthält

- ``author``- Mit ``name`` und ``email`` Unter-Tags wie den Feeds

- ``published``- Das Datum, an dem der Eintrag veröffentlicht wurde, im *RFC* 3339 Format

- ``updated``- Das Datum, an dem der Eintrag das letzte Mal geändert wurde, im *RFC* 3339 Format

Für weitere Informationen über Atom und unzähligen anderen Quellen, besuche `http://www.atomenabled.org/`_.



.. _`http://www.atomenabled.org/`: http://www.atomenabled.org/
