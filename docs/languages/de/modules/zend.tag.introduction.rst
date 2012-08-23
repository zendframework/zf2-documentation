.. EN-Revision: none
.. _zend.tag.introduction:

Einführung
==========

``Zend_Tag`` ist eine Komponenten Suite welche zwei Klassen anbietet um mit Tags zu arbeiten, ``Zend_Tag_Item`` und
``Zend_Tag_ItemList``. Zusätzlich kommt sie mit dem Interface ``Zend_Tag_Taggable``, welches es erlaubt jedes
eigene Modell als markiertes Element, in Verbindung mit ``Zend_Tag``, zu verwenden.

``Zend_Tag_Item`` ist eine grundsätzliche Implementation eines markierten Elements, welche mit der essentiellen
Funktionalität kommt, die notwendig ist um mit der ``Zend_Tag`` Suite zu arbeiten. Ein markierbares Element
besteht immer aus einem Titel und einem relativen Gewicht (z.B. die Anzahl der Vorkommnisse). Es speichert auch
Parameter welche von den unterschiedlichen Sub-Komponenten von ``Zend_Tag`` verwendet werden.

Um mehrere Element miteinander zu gruppieren, existiert ``Zend_Tag_ItemList`` als Array Iterator und bietet
zusätzliche Funktionalitäten um die Werte des absoluten Gewichts, basierend auf dem angegebenen relativen Gewicht
jedes Elements in diesem, zu kalkulieren.

.. _zend.tag.example.using:

.. rubric:: Verwenden von Zend_Tag

Dieses Beispiel zeigt wie eine Liste von Tags erstellt, und Werte des absoluten Gewichts auf diesen verteilt werden
kann.

.. code-block:: php
   :linenos:

   // Erstellen des Elementliste
   $list = new Zend_Tag_ItemList();

   // Hinzufügen der Tags zur Elementliste
   $list[] = new Zend_Tag_Item(array('title' => 'Code', 'weight' => 50));
   $list[] = new Zend_Tag_Item(array('title' => 'Zend Framework', 'weight' => 1));
   $list[] = new Zend_Tag_Item(array('title' => 'PHP', 'weight' => 5));

   // Absolute Werte auf den Elementen verteilen
   $list->spreadWeightValues(array(1, 2, 3, 4, 5, 6, 7, 8, 9, 10));

   // Die Werte mit ihren absoluten Werten ausgeben
   foreach ($list as $item) {
       printf("%s: %d\n", $item->getTitle(), $item->getParam('weightValue'));
   }

Das wird die drei Elemente Code, Zend Framework und *PHP*, mit den absoluten Werten 10, 1 und 2, ausgeben.


