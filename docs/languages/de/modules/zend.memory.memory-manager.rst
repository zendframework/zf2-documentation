.. EN-Revision: none
.. _zend.memory.memory-manager:

Memory Manager
==============

.. _zend.memory.memory-manager.creation:

Erstellen eines Memory Manager
------------------------------

Ein neuer Memory Manager (``Zend_Memory_Manager`` object) kann erstellt werden durch Verwendung der
``Zend_Memory::factory($backendName [, $backendOprions])`` Methode.

Das erste Argument ``$backendName`` ist eine Zeichenkette die eine der Backend Implementationen benennt welche
durch ``Zend_Cache`` unterstützt werden.

Das zweite Argument ``$backendOptions`` ist ein optionales Array für die Optionen des Backends.

.. code-block:: php
   :linenos:

   $backendOptions = array(
       // Verzeichnis in dem die geswappten Memory Blöcke abgelegt werden
       'cache_dir' => './tmp/'
   );

   $memoryManager = Zend_Memory::factory('File', $backendOptions);

``Zend_Memory`` verwendet :ref:`Zend_Cache Backends <zend.cache.backends>` als Speicheranbieter.

Der spezielle Name 'None' kann als Backend Name verwendet werden, zusätzlich zu den Standard ``Zend_Cache``
Backends.

.. code-block:: php
   :linenos:

   $memoryManager = Zend_Memory::factory('None');

Wenn 'None' als Backend Name verwendet wird, dann tauscht der Memory Manager niemals die Memory Blöcke. Das ist
nützlich wenn man weiß das Speicher nicht limitiert ist oder die Gesamtgröße der Objekte nie das Speicherlimit
erreicht.

Das 'None' Backend benötigt keine Definition von Optionen.

.. _zend.memory.memory-manager.objects-management:

Memory Objekte verwalten
------------------------

Diese Sektion beschreibt die Erstellung und Vernichtung von Objekten im Memory Manager, und die Einstellungen um
das Verhalten des Memory Managers zu kontrollieren.

.. _zend.memory.memory-manager.objects-management.movable:

Erstellung verschiebbarer Objekte
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Verschiebbare Objekte (Objekte, welche verschoben werden können) können erstellt werden mit Hilfe der
``Zend_Memory_Manager::create([$data])`` Methode:

.. code-block:: php
   :linenos:

   $memObject = $memoryManager->create($data);

Das ``$data`` Argument ist optional und wird verwendet um die Objekt Werte zu initialisieren. Wenn das ``$data``
unterdrückt wird, ist der Wert eine leere Zeichenkette.

.. _zend.memory.memory-manager.objects-management.locked:

Erstellen verschlüsselter Objekte
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Verschlüsselte Objekte (Objekte, welche niemals getauscht werden) können erstellt werden mit Hilfe der
``Zend_Memory_Manager::createLocked([$data])`` Methode:

.. code-block:: php
   :linenos:

   $memObject = $memoryManager->createLocked($data);

Das ``$data`` Argument ist optional und wird verwendet um die Objekt Werte zu initialisieren. Wenn das ``$data``
Argument unterdrückt wird, ist der Wert eine leere Zeichenkette.

.. _zend.memory.memory-manager.objects-management.destruction:

Objekte vernichten
^^^^^^^^^^^^^^^^^^

Memory Objekte werden automatische vernichtet und vom Speicher entfernt wenn sie ausserhalb des Bereichs sind:

.. code-block:: php
   :linenos:

   function foo()
   {
       global $memoryManager, $memList;

       ...

       $memObject1 = $memoryManager->create($data1);
       $memObject2 = $memoryManager->create($data2);
       $memObject3 = $memoryManager->create($data3);

       ...

       $memList[] = $memObject3;

       ...

       unset($memObject2); // $memObject2 wird hier zerstört

       ...
       // $memObject1 wird hier zerstört
       // Aber das $memObject3 Objekt ist noch immer referenziert
       // durch $memList und ist nicht zerstört
   }

Das gilt für beide, verschiebbare und verschlüsselte Objekte.

.. _zend.memory.memory-manager.settings:

Memory Manager Einstellungen
----------------------------

.. _zend.memory.memory-manager.settings.memory-limit:

Memory Limit
^^^^^^^^^^^^

Das Memory Limit ist eine Zahl von Bytes die zur Verwendung durch geladene verschiebbare Objekte erlaubt ist.

Wenn das Laden oder Erstellen eines Objekts ein Überschreiten des Limits der Verwendung des Speichers verursachen
würde, tauscht der Memory Manager einige andere Objekte.

Das Memory Limit kann empfangen oder gesetzt werden durch Verwendung der ``getMemoryLimit()`` und
``setMemoryLimit($newLimit)`` Methoden:

.. code-block:: php
   :linenos:

   $oldLimit = $memoryManager->getMemoryLimit(); // Memorylimit in Bytes empfangen
   $memoryManager->setMemoryLimit($newLimit);    // Memorylimit in Bytes setzen

Ein negativer Wert für das Memory Limit bedeutet 'kein Limit'.

Der Standardwert ist zweidrittel des Wertes von 'memory_limit' in php.ini oder 'kein Limit' (-1) wenn
'memory_limit' in der php.ini nicht gesetzt ist.

.. _zend.memory.memory-manager.settings.min-size:

MinSize
^^^^^^^

MinSize ist die minimalste Größe von Memory Objekten, welche vom Memory Manager getauscht werden können. Der
Memory Manager tauscht keine Objekte welche kleiner als dieser Wert sind. Das vermindert die Anzahl von
Tausch-/Lade- Operationen.

Man kann die minimale Größe empfangen oder setzen durch Verwendung der ``getMinSize()`` und
``setMinSize($newSize)`` Methoden:

.. code-block:: php
   :linenos:

   $oldMinSize = $memoryManager->getMinSize();  // MinSize in Bytes empfangen
   $memoryManager->setMinSize($newSize);        // MinSize Limit in Bytes setzen

Die standardmäßige Wert für die minimale Größe ist 16KB (16384 bytes).


