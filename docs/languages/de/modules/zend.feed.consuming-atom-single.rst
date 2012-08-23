.. EN-Revision: none
.. _zend.feed.consuming-atom-single-entry:

Einen einzelnen Atom Eintrag konsumieren
========================================

Einzelne Atom ``<entry>`` Elemente sind auch für sich selber gültig. Normalerweise ist die *URL* für einen
Eintrag die *URL* des Feeds gefolgt von ``/<entryId>``, wie bei ``http://atom.example.com/feed/1``, um die obige
Beispiel *URL* zu verwenden.

Wenn Du einen einzelnen Eintrag liest, wirst du dennoch ein ``Zend_Feed_Atom`` Objekt erhalten, aber es wird
automatisch ein "anonymer" Feed erstellt, welcher den Eintrag enthält.

.. _zend.feed.consuming-atom-single-entry.example.atom:

.. rubric:: Lesen eines Atom Feeds mit einem Eintrag

.. code-block:: php
   :linenos:

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/1');
   echo 'Der Feed hat: ' . $feed->count() . ' Eintrag.';

   $entry = $feed->current();

Alternativ kannst du das Objekt für den Eintrag auch direkt instanziieren, wenn du weist, dass du ein Dokument mit
nur einem ``<entry>`` Eintrag abrufst:

.. _zend.feed.consuming-atom-single-entry.example.entryatom:

.. rubric:: Direkte Verwendung des Eintragsobjekts für einen Atom Feed mit nur einem Eintrag

.. code-block:: php
   :linenos:

   $entry = new Zend_Feed_Entry_Atom('http://atom.example.com/feed/1');
   echo $entry->title();


