.. _learning.view.placeholders.intro:

Einführung
==========

Im :ref:`vorherigen Kapitel <learning.layout>` haben wir primär das Two Step Pattern betrachtet, welches es
erlaubt individuelle Anwendungsviews in einem Siteweitem Layout einzubetten. Am Ende dieses Kapitels diskutieren
wir trotzdem noch einige Limitationen:

- Wie verändert man den Titel der Seite?

- Wie könnte man konditionale Skripte oder Stylesheets in ein Siteweites Layout injizieren?

- Wie würde man eine optionale Sidebar erstellen und darstellen? Was wenn ein Teil des Inhalts nicht konditional,
  und anderer Inhalt für die Sidebar konditional war?

Diese Fragen werden im `Composite View`_ Design Pattern behandelt. Ein Weg zu diesem Pattern ist es "hints" oder
Inhalt für das Siteweite Layout anzubieten. Im Zend Framwork wird das durch spezialisierte View Helfer ermöglicht
welche "placeholders" (Platzhalter) heißen. Platzhalter erlauben es einem Inhalte zu erstellen, und diese
erstellten Inghalte anschließend an anderer Stelle darzustellen.



.. _`Composite View`: http://java.sun.com/blueprints/corej2eepatterns/Patterns/CompositeView.html
