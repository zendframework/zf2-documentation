.. _zend.tool.project.introduction:

Einführung
==========

``Zend_Tool_Project`` baut auf die Möglichkeiten von ``Zend_Tool_Framework`` und erweitert Sie darum ein "Projekt"
zu managen. Generell, ist ein "Projekt" eine geplante Arbeit oder eine Initiative. In der Welt der Computer sind
Projekte generell eine Sammlung von Ressourcen. Diese Ressourcen können Dateien, Verzeichnisse, Datenbanken,
Schemas, Bilder, Stile, und anderes sein.

Das selbe Konzept trifft auf Zend Framework Projekte zu. In Zend Framework Projekten, hat man Controller, Aktionen,
Views, Modelle, Datenbanken und so weiter. In den Ausdrücken von ``Zend_Tool``, benötigen wir einen Weg um diese
Typen von Ressourcen handzuhaben - deshalb ``Zend_Tool_Project``.

``Zend_Tool_Project`` ist dazu in der Lage Projekt Ressourcen durch die Entwicklung eines Projektes handzuhaben.
Wenn man also, als Beispiel, mit einem Kommando einen Controller erstellt, und im nächsten Kommando eine Aktion in
diesem Controller erstellen will, muss ``Zend_Tool_Project`` von der Controller Datei **wissen** die erstellt
wurde, damit man (in der nächsten Aktion) dazu in der Lage ist diese der Aktion hinzu zu fügen. Das ist es was
das Projekt aktuell hält und **bequem**.

Ein anderer Punkt den man über Projekte verstehen muss ist das Ressourcen typischerweise in einer Hirarchischen
Art und Weise organisiert sind. Damit ist ``Zend_Tool_Project`` in der Lage das aktuelle Projekt in einer interne
Repräsentation zu serialisieren, was es erlaubt nicht nur jederzeit zu wissen **welche** Ressourcen Teil eines
Projektes sind, sonder auch **wie** diese in Relation zu einander stehen.


