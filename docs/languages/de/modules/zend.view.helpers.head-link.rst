.. EN-Revision: none
.. _zend.view.helpers.initial.headlink:

HeadLink Helfer
===============

Das *HTML* **<link>** Element wird immer mehr für das Verlinken einer Vielzahl von Ressourcen der eigenen Site
verwendet: Stylesheets, Feeds, FavIcons, Trackbacks, und andere. Der ``HeadLink`` Helfer bietet ein einfaches
Interface für die Erstellung und das Anhäufen dieser Elemente für das spätere Empfangen und deren Ausgabe im
eigenen Layout Skript.

Der ``HeadLink`` Helfer hat spezielle Methode für das hinzufügen von Stylesheet Links zu seinem Stack:

- ``appendStylesheet($href, $media, $conditionalStylesheet, $extras)``

- ``offsetSetStylesheet($index, $href, $media, $conditionalStylesheet, $extras)``

- ``prependStylesheet($href, $media, $conditionalStylesheet, $extras)``

- ``setStylesheet($href, $media, $conditionalStylesheet, $extras)``

Der ``$media`` Wert ist standardmäßig 'screen', kann aber jeder gültige Media Wert sein.
``$conditionalStylesheet`` ist ein String oder boolsches ``FALSE`` und wird verwendet um wärend der Darstellung zu
erkennen ob spezielle Kommentare inkludiert werden sollen um das Laden dieser Stylesheets auf diversen Plattformen
zu verhindern. ``$extras`` ist ein Array von extra Werten die man dem Tag hinzufügen will.

Zusätzlich hat der ``HeadLink`` Helfer eine spezielle Methode für das Hinzufügen von 'alternativen' (alternate)
Links zu seinem Stack:

- ``appendAlternate($href, $type, $title, $extras)``

- ``offsetSetAlternate($index, $href, $type, $title, $extras)``

- ``prependAlternate($href, $type, $title, $extras)``

- ``setAlternate($href, $type, $title, $extras)``

Die ``headLink()`` Helfer Methode erlaubt das Spezifizieren aller Attribute die für ein **<link>** Element
notwendig sind, und erlaubt auch die Spezifizfikation der Platzierung --- entweder ersetzt das neue Element alle
anderen, wird vorangestellt (an den Beginn des Stacks) , oder angefügt (an das Ende des Stacks).

Der ``HeadLink`` Helfer ist eine konkrete Implementation des :ref:`Platzhalter Helfers
<zend.view.helpers.initial.placeholder>`.

.. _zend.view.helpers.initial.headlink.basicusage:

.. rubric:: Grundsätzliche Verwendung des HeadLink Helfers

**headLink** kann jederzeit spezifiziert werden. Typischerweise wird ein globaler Link im eigenen Layout Skript
spezifiziert, und anwendungsspezifische Links in den View Skripten der Anwendung. Im Layoutskript, in der <head>
Sektion, muß das der Helfer ausgegeben werden.

.. code-block:: php
   :linenos:

   <?php // Links in einem View Skript setzen:
   $this->headLink(array(
       'rel'  => 'favicon',
       'href' => '/img/favicon.ico'
   ), 'PREPEND')
       ->appendStylesheet('/styles/basic.css')
       ->prependStylesheet(
           '/styles/moz.css',
           'screen',
           true,
           array('id' => 'my_stylesheet')
       );
   ?>
   <?php // Darstellen der Links: ?>
   <?php echo $this->headLink() ?>


