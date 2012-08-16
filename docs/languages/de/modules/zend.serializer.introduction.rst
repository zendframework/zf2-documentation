.. EN-Revision: none
.. _zend.serializer.introduction:

Einführung
==========

``Zend_Serializer`` bietet ein Adapter-basierendes Interface um eine speicherbare Repräsentation von *PHP* Typen
durch unterschiedliche Arten zu bieten und diese wiederherzustellen.

.. _zend.serializer.introduction.example.dynamic:

.. rubric:: Verwenden des dynamischen Interfaces von Zend_Serializer

Um einen Serializer zu instanzieren sollte man die Factory Methode mit dem Namen des Adapters verwenden:

.. code-block:: php
   :linenos:

   $serializer = Zend_Serializer::factory('PhpSerialize');
   // Jetzt ist $serializer eine Instanz von
   // Zend_Serializer_Adapter_AdapterInterface, im speziellen
   // Zend_Serializer_Adapter_PhpSerialize

   try {
       $serialized = $serializer->serialize($data);
       // jetzt ist $serialized ein String

       $unserialized = $serializer->unserialize($serialized);
       // Jetzt ist $data == $unserialized
   } catch (Zend_Serializer_Exception $e) {
       echo $e;
   }

Die Methode ``serialize()`` erzeugt einen speicherbaren String. Um diese serialisierten Daten wiederherzustellen
kann einfach die Methode ``unserialize()`` aufgerufen werden.

Jedesmal wenn ein Fehler bei der Serialisierung oder Deserialisierung festgestellt wird wirft ``Zend_Serializer``
eine ``Zend_Serializer_Exception``.

Um einen gegebenen Serialisierungs-Adapter zu konfigurieren kann optional ein Array oder eine Instanz von
``Zend_Config`` an die ``factory()`` oder die Methoden ``serialize()`` und ``unserialize()`` übergeben werden:

.. code-block:: php
   :linenos:

   $serializer = Zend_Serializer::factory('Wddx', array(
       'comment' => 'serialized by Zend_Serializer',
   ));

   try {
       $serialized = $serializer->serialize(
           $data,
           array('comment' => 'change comment')
       );

       $unserialized = $serializer->unserialize(
           $serialized,
           array(/* Optionen für die Deserialisierung */)
       );
   } catch (Zend_Serializer_Exception $e) {
       echo $e;
   }

Optionen welche an ``factory()`` übergeben werden sind für das instanzierte Objekt gültig. Man kann diese
Optionen verändern indem die ``setOption(s)`` Methoden verwendet werden. Um ein oder mehrere Optionen für einen
einzelnen Aufruf zu verändern, können diese als zweites Argument an die Methoden ``serialize()`` oder
``unserialize()`` übergeben werden.

.. _zend.serializer.introduction.example.static.php:

.. rubric:: Das statische Interface von Zend_Serializer verwenden

Man kann einen spezifischen Serialisierungs-Adapter als standardmäßigen Serialisierungs-Adapter für die
Verwendung mit ``Zend_Serializer`` registrieren. Standardmäßig wird der Adapter ``PhpSerialize`` registriert.
Aber man kann das verändern indem die statische Methode ``setDefaultAdapter()`` verwendet wird.

.. code-block:: php
   :linenos:

   Zend_Serializer::setDefaultAdapter('PhpSerialize', $options);
   // oder
   $serializer = Zend_Serializer::factory('PhpSerialize', $options);
   Zend_Serializer::setDefaultAdapter($serializer);

   try {
       $serialized   = Zend_Serializer::serialize($data, $options);
       $unserialized = Zend_Serializer::unserialize($serialized, $options);
   } catch (Zend_Serializer_Exception $e) {
       echo $e;
   }


