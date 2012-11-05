.. EN-Revision: none
.. _zend.memory.overview:

Übersicht
=========

.. _zend.memory.introduction:

Einführung
----------

Die ``Zend_Memory`` Komponente ist dafür gedacht Daten in Systemen mit limitiertem Speicher zu Verwalten.

Memory Objekte (Memory Container) werden durch den Memory Manager bei Anfrage erzeugt und transparent
geswappt/geladen wenn dies notwendig wird.

Wenn, zum Beispiel, ein gemanagtes Objekt erzeugt oder geladen wird, das den gesamten Speicherverbrauch
überschreiten würde, der vorher definiert wurde, werden einige gemanagte Objekte in den Cache Speicher ausserhalb
des Speichers kopiert. Auf diesen Weg wird der Gesamtspeicher der von den gemanagten Objekten verwendet wird nicht
das benötigte Limit überschreiten.

Der Memory Manager verwendet :ref:`Zend_Cache backends <zend.cache.backends>` als Speicheranbieter.

.. _zend.memory.introduction.example-1:

.. rubric:: Verwenden der Zend_Memory Komponente

``Zend\Memory\Memory::factory()`` instantiiert das Speichermanager Objekt mit den definierten Backend Optionen.

.. code-block:: php
   :linenos:

   // Verzeichnis in welches die getauschten Speicherblöcke geschrieben werden
   $backendOptions = array(
       'cache_dir' => './tmp/'
   );

   $memoryManager = Zend\Memory\Memory::factory('File', $backendOptions);

   $loadedFiles = array();

   for ($count = 0; $count < 10000; $count++) {
       $f = fopen($fileNames[$count], 'rb');
       $data = fread($f, filesize($fileNames[$count]));
       $fclose($f);

       $loadedFiles[] = $memoryManager->create($data);
   }

   echo $loadedFiles[$index1]->value;

   $loadedFiles[$index2]->value = $newValue;

   $loadedFiles[$index3]->value[$charIndex] = '_';

.. _zend.memory.theory-of-operation:

Theorie der Verwendung
----------------------

Die ``Zend_Memory`` Komponente arbeitet mit den folgenden Konzepten:



   - Memory Manager

   - Memory Container

   - Verschlüsseltes Memory Objekt

   - Verschiebbares Memory Objekt



.. _zend.memory.theory-of-operation.manager:

Memory Manager
^^^^^^^^^^^^^^

Der Memory Manager erzeugt Memory Objekte (gesperrt oder verschiebbar) durch Anfrage der Anwendung des Benutzers
und gibt diese in einem Memory Container Objekt zurück.

.. _zend.memory.theory-of-operation.container:

Memory Container
^^^^^^^^^^^^^^^^

Der Memory Container hat ein virtuelles oder aktuelles Attribut ``value`` vom Typ String. Dieses Attribut enthält
Datenwerte die bei der Erstellung des Memory Objektes definiert werden.

Es kann mit ``value`` Attributen wie auch mit Objekt Eigenschaften gearbeitet werden.

.. code-block:: php
   :linenos:

   $memObject = $memoryManager->create($data);

   echo $memObject->value;

   $memObject->value = $newValue;

   $memObject->value[$index] = '_';

   echo ord($memObject->value[$index1]);

   $memObject->value = substr($memObject->value, $start, $length);

.. note::

   Wenn eine *PHP* Version vor 5.2 verwendet wird, sollte stattdessen die :ref:`getRef()
   <zend.memory.memory-objects.api.getRef>` Methode verwendet werden statt direkt auf die Wert Eigenschaften
   zuzugreifen.

.. _zend.memory.theory-of-operation.locked:

Verschlüsselter Memory
^^^^^^^^^^^^^^^^^^^^^^

Verschlüsselte Speicher Objekte werden immer im Speicher gespeichert. Daten welche im verschlüsselten Speicher
gespeichert sind, werden niemals in das Cache Backend getauscht.

.. _zend.memory.theory-of-operation.movable:

Verschiebbarer Memory
^^^^^^^^^^^^^^^^^^^^^

Verschiebbare Memory Objekte werden transparent geswappt und geladen von und in das Cache Backend durch
``Zend_Memory`` wenn das notwendig wird.

Der Memory Manager swappt keine Objekte die eine kleinere Größe als das definierte Minimum besitzen, und zwar aus
Gründen der Geschwindigkeit. Siehe :ref:`diesen Abschnitt <zend.memory.memory-manager.settings.min-size>` für
mehr Details.


