.. _zend.memory.memory-objects:

Memory Objekte
==============

.. _zend.memory.memory-objects.movable:

Verschiebbar
------------

Um verschiebbare Memory Objekte zu Erstellen kann die ``create([$data])`` Methode des Memory Managers verwendet
werden:

.. code-block:: php
   :linenos:

   $memObject = $memoryManager->create($data);

"Verschiebbar" bedeutet das solche Objekte verschoben und von Speicher entfernt werden können und wieder geladen
werden wenn der Code der Anwendung auf das Objekt wieder zugreift.

.. _zend.memory.memory-objects.locked:

Gesperrt
--------

Gesperrte Memory Objekte können erstellt werden mit Hilfe der ``createLocked([$data])`` Methode des Memory
Managers:

.. code-block:: php
   :linenos:

   $memObject = $memoryManager->createLocked($data);

"Gesperrt" bedeutet das solche Objekte niemals getauscht und vom Speicher entfernt werden.

Gesperrte Objekte haben das selbe Interface wie verschiebbare Objekte (``Zend_Memory_Container_Interface``).
Deswegen können gesperrte Objekte an jedem Platz statt verschiebbaren Objekten verwendet werden.

Es ist nützlich wenn eine Anwendung oder Entwickler entscheiden kann, das einige Objekte niemals getauscht werden
sollen, basierend auf Entscheidungen der Geschwindigkeit.

Der Zugriff auf gesperrte Objekte ist schneller, weil der Memory Manager die Änderungen für diese Objekte nicht
verfolgen muß.

Die Klasse der gelockten Objekte (``Zend_Memory_Container_Locked``) garantiert virtuell die selbe Performance wie
das Arbeiten mit einer Zeichenketten Variablen. Der Overhead ist ein einzelnes De-Referenzieren um die Eigenschaft
der Klasse zu erhalten.

.. _zend.memory.memory-objects.value:

Memory Container 'value' Eigenschaft
------------------------------------

Die '``value``' Eigenschaft des Memory Containers (gesperrt oder verschiebbar) kann verwendet werden um mit Memory
Objekt Daten zu arbeiten:

.. code-block:: php
   :linenos:

   $memObject = $memoryManager->create($data);

   echo $memObject->value;

   $memObject->value = $newValue;

   $memObject->value[$index] = '_';

   echo ord($memObject->value[$index1]);

   $memObject->value = substr($memObject->value, $start, $length);

Ein alternaviter Weg um auf die Daten des Memory Objektes zuzugreifen ist die Verwendung der :ref:`getRef()
<zend.memory.memory-objects.api.getRef>` Methode. Diese Methode **muß** verwendet werden für *PHP* Versionen vor
5.2. Sie könnte auch in einigen Fällen verwendet werden, wenn Gründe der Geschwindigkeit dafür sprechen.

.. _zend.memory.memory-objects.api:

Memory Container Interface
--------------------------

Der Memory Container stellt die folgenden Methoden zur Verfügung:

.. _zend.memory.memory-objects.api.getRef:

getRef() Methode
^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function &getRef();

Die ``getRef()`` Methode gibt eine Referenz auf den Wert des Objektes zurück.

Verschiebbare Objekte werden vom Cache geladen in dem Moment wenn das Objekt nicht bereits im Speicher vorhanden
ist. Wenn das Objekt vom Cache geladen wird, können das einen Tausch von anderen Objekten verursachen wenn das
Memory Limit überschritten werden würde wenn alle gemanageten Objekte im Speicher vorhanden sind.

Die ``getRef()`` Methode **muß** verwendet werden um auf die Daten des Memory Objektes zuzugreifen für *PHP*
Versionen vor 5.2.

Das Verfolgen von Änderungen an Daten benötigt zusätzliche Ressourcen. Die ``getRef()`` Methode gibt eine
Referenz zu der Zeichenkette zurück, welches direkt von der Benutzeranwendung verändert wird. Deswegen ist es
eine gute Idee die ``getRef()`` Methode für den Zugriff auf die Werte der Daten zu verwenden:

.. code-block:: php
   :linenos:

   $memObject = $memoryManager->create($data);

   $value = &$memObject->getRef();

   for ($count = 0; $count < strlen($value); $count++) {
       $char = $value[$count];
       ...
   }

.. _zend.memory.memory-objects.api.touch:

touch() Methode
^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function touch();

Die ``touch()`` Methode sollte in Verbindung mit ``getRef()`` verwendet werden. Das signalisiert das der Wert des
Objektes sich verändert hat:

.. code-block:: php
   :linenos:

   $memObject = $memoryManager->create($data);
   ...

   $value = &$memObject->getRef();

   for ($count = 0; $count < strlen($value); $count++) {
       ...
       if ($condition) {
           $value[$count] = $char;
       }
       ...
   }

   $memObject->touch();

.. _zend.memory.memory-objects.api.lock:

lock() Methode
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function lock();

Die ``lock()`` Methode versperrt Objekte im Speicher. Sie sollte verwendet werden um das tauschen von ausgewählten
Objekten zu verhindern. Normalerweise ist das nicht notwendig, da der Memory Manager einen intelligenten
Algorythmus verwendet um Kandidaten für den Tasuch zu eruieren. Aber wenn genau bekannt ist, das ein bestimmter
Teil des Codes nicht getauscht werden sollte, kann er gesperrt werden.

Gesperrte Objekte im Speicher garantieren auch das die Referent die durch die ``getRef()`` Methode zurückgegeben
wird gültig ist bis das Objekt entsperrt wird:

.. code-block:: php
   :linenos:

   $memObject1 = $memoryManager->create($data1);
   $memObject2 = $memoryManager->create($data2);
   ...

   $memObject1->lock();
   $memObject2->lock();

   $value1 = &$memObject1->getRef();
   $value2 = &$memObject2->getRef();

   for ($count = 0; $count < strlen($value2); $count++) {
       $value1 .= $value2[$count];
   }

   $memObject1->touch();
   $memObject1->unlock();
   $memObject2->unlock();

.. _zend.memory.memory-objects.api.unlock:

unlock() Methode
^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function unlock();

Die ``unlock()`` Methode entsperrt Objekte wenn es nicht mehr notwendig ist diese zu sperren. Siehe das obige
Beispiel.

.. _zend.memory.memory-objects.api.isLocked:

isLocked() Methode
^^^^^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   public function isLocked();

Die ``isLocked()`` Methode kann verwendet werden um zu Prüfen ob das Objekt gesperrt ist. Sie gibt ``TRUE``
zurück wenn das Objekt gesperrt ist, oder ``FALSE`` wenn es nicht gesperrt ist. Für "gesperrte" Objekte wird
immer ``TRUE`` zurückgegeben, und für "verschiebbare" Objekte kann entweder ``TRUE`` oder ``FALSE``
zurückgegeben werden.


