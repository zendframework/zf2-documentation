.. _zend.measure.introduction:

Einführung
==========

Die ``Zend_Measure_*`` Klassen bieten einen generischen und einfachen Weg um mit Maßeinheiten zu Arbeiten. Durch
Verwendung der ``Zend_Measure_*`` Klassen können Maßeinheiten in verschiedene andere Maßeinheiten des gleichen
Typs konvertiert werden. Diese können Addiert, Subtrahiert und miteinander verglichen werden. Von einer Eingabe in
der Muttersprache eines Benutzers können die Einheiten der Maßeinheiten automatische extrahiert werden. Eine
Vielzahl an Maßeinheiten wird unterstützt.

.. _zend.measure.introduction.example-1:

.. rubric:: Konvertieren von Maßeinheiten

Das folgende einführende Beispiel zeigt die automatische Konvertierung von Einheiten von Maßeinheiten. Um eine
Maßeinheit zu konvertieren muß dessen Wert und Typ bekannt sein. Der Wert kann ein Integer, ein Float oder sogar
eine Zeichenkette sein die eine Zahl enthält. Konvertierungen sind nur für Einheiten des gleichen Typs möglich
(Masse, Fläche, Temperatur, Beschleunigung, usw.), nicht zwischen verschiedenen Typen.

.. code-block:: php
   :linenos:

   $locale = new Zend_Locale('en');
   $unit = new Zend_Measure_Length(100, Zend_Measure_Length::METER, $locale);

   // Konvertiert Meter zu Yard
   echo $unit->convertTo(Zend_Measure_Length::YARD);

``Zend_Measure_*`` enthält Unterstützung für viele unterschiedliche Arten von Maßeinheiten. Die Arten der
Maßeinheiten haben die folgende einheitliche Schreibweise: ``Zend_Measure_<TYP>::NAME_DER_EINHEIT``, wobei <TYP>
identisch ist mit einer bekannten physikalischen oder nummerischen Einheit. Jede Maßeinheit besteht aus einem
Faktor für die Konvertierung und einer Darstellungseinheit. Eine detailierte Liste kann im Kapitel :ref:`Arten von
Maßeinheiten <zend.measure.types>` gefunden werden.

.. _zend.measure.introduction.example-2:

.. rubric:: Die Maßeinheit meter

Der **Meter** wird für das Abmessen von Längen verwendet und kann in der Klasse ``Length`` gefunden werden. Um
auf diese Maßeinheit zu verweisen muß die Schreibweise ``Length::METER`` verwendet werden. Die
Darstellungseinheit ist **m**.

.. code-block:: php
   :linenos:

   echo Zend_Measure_Length::STANDARD;  // Ausgabe 'Length::METER'
   echo Zend_Measure_Length::KILOMETER; // Ausgabe 'Length::KILOMETER'

   $unit = new Zend_Measure_Length(100,'METER');
   echo $unit;
   // Ausgabe '100 m'


