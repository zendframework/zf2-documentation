.. _zend.layout.introduction:

Einführung
==========

``Zend_Layout`` implementiert ein plassisches Zwei Schritt View Pattern, welches Entwicklern erlaubt Anwendungs
Inhalte innerhalb von anderen Views einzupacken, die normalerweise Site Templates repräsentieren. Solche Templates
werden oft von anderen Projekten als **Layouts** bezeichnet, und Zend Framework hat diesen Begriff der Konsistenz
halber übernommen.

Die Hauptziele von ``Zend_Layout`` sind wie folgt:

- Automatische Auswahl und Darstellung von Layouts wenn diese mit den Zend Framework *MVC* Komponenten verwendet
  werden.

- Bietet einen seperierten Bereich für Layouts die auf Variablen und Inhalte bezogen sind.

- Erlaubt Konfiguration, inklusive Layout Name, Layout Skript Auflösung (Beugung), und Layout Skript Pfad.

- Erlaubt das Ausschalten von Layouts, die Änderung von Layout Skripts, und andere Stati; erlaubt diese Aktionen
  von innerhalb des Aktions Controllers und von View Skripten.

- Folgt den selben Skript Auflösungs Regeln (Beugung) wie der :ref:`ViewRenderer
  <zend.controller.actionhelpers.viewrenderer>`, aber erlaubt auch die Verwendung von anderen Regeln.

- Erlaubt die Verwendung auch ohne Zend Framework *MVC* Komponenten.


