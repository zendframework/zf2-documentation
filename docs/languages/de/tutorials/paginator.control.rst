.. EN-Revision: none
.. _learning.paginator.control:

Seitenkontrolle und ScrollingStyles
===================================

Die Darstellung von Elementen für eine Bildschirmseite ist ein guter Start. In den Code Abschnitten der
vorhergehenden Sektion haben wir die ``setCurrentPageNumber()`` Methode gesehen um die aktive Seitenzahl zu setzen.
Der nächste Schritt ist die Navigation durch die Seiten. Um das zu tun bietet Paginator zwei wichtige Tools: die
Möglichkeit den Paginator mit Hilfe eines View Partials darzustellen und Unterstützung von sogenannten
ScrollingStyles.

Der View Partial ist ein kleines View Skript welches die Seitenkontrollen darstellt, wie Buttons um zur nächsten
oder vorigen Seite zu gehen. Welche Seitenkontrollen dargestellt werden hängt vom Inhalt des View Partials ab. Die
Arbeit mit View Partials benötigt deren Einrichtung in ``Zend_View``. Um mit den Seitenkontrollen anzufangen muss
irgendwo in eigenen View Skript Pfad ein neues View Skript erstellt werden. Man kann es benennen wie man will, aber
wir nennen es in diesem Text "controls.phtml". Das Referenz Handbuch enthält verschiedene Beispiele darüber was
im View Skript möglich ist. Hier ist ein Beispiel:

.. code-block:: php
   :linenos:

   <?php if ($this->pageCount): ?>
   <!-- Link zur ersten Seite -->
   <?php if (isset($this->previous)): ?>
     <a href="<?php echo $this->url(array('page' => $this->first)); ?>">
       Erste
     </a> |
   <?php else: ?>
     <span class="disabled">Erste</span> |
   <?php endif; ?>

   <!-- Link zur vorherigen Seite -->
   <?php if (isset($this->previous)): ?>
     <a href="<?php echo $this->url(array('page' => $this->previous)); ?>">
       < Vorherige
     </a> |
   <?php else: ?>
     <span class="disabled">< Vorherige</span> |
   <?php endif; ?>

   <!-- Link zur nächsten Seite -->
   <?php if (isset($this->next)): ?>
     <a href="<?php echo $this->url(array('page' => $this->next)); ?>">
       Nächste >
     </a> |
   <?php else: ?>
     <span class="disabled">Nächste ></span> |
   <?php endif; ?>

   <!-- Link zur letzten Seite -->
   <?php if (isset($this->next)): ?>
     <a href="<?php echo $this->url(array('page' => $this->last)); ?>">
       Letzte
     </a>
   <?php else: ?>
     <span class="disabled">Letzte</span>
   <?php endif; ?>

   </div>
   <?php endif; ?>

Der nächste Schritt ist es ``Zend_Paginator`` zu sagen welche View Partials verwendet werden können um die
Navigationskontrollen darzustellen. Die folgende Zeile ist in die Bootstrap Datei der Anwendung zu geben.

.. code-block:: php
   :linenos:

   Zend\View\Helper\PaginationControl::setDefaultViewPartial('controls.phtml');

Der letzte Schritt ist möglicherweise der einfachste. Man muss sicherstellen dass das Paginator Objekt dem Skript
zugeordnet ist (NICHT dem 'controls.phtml' Skript!). Das einige was noch zu tun ist, ist es den Paginator im View
Skript auszugeben. Das stellt automatisch den Paginator dar und verwendet den PaginationControl View Helfer. Im
nächsten Beispiel wird das Paginator Objekt der 'paginator' View Variable zugeordnet. Keine Angst, man muss jetzt
nicht vollständig verstehen wie alles funktioniert. Das nächste Kapitel zeigt ein komplettes Beispiel.

.. code-block:: php
   :linenos:

   <?php echo $this->paginator; ?>

``Zend_Paginator``, stellt zusammen mit dem View Skript 'controls.phtml' das geschrieben wurde, sicher das die
Seitenkontrollen richtig dargestellt werden. Um auszuwählen welche Seitenzahlen am Schirm angezeigt werden
müssen, verwendet Paginator sogenannte ScrollingStyles. Der Standardstil wird "Sliding" genannt, was so ähnlich
ist wie die Navigation für Yahoo's Suchergebnisse arbeitet. Um Googl's ScrollingStyle zu mimen, muss der Elastic
Style verwendet werden. Man kann einen standardmäßigen ScrollingStyle mit der statischen
``setDefaultScrollingStyle()`` Methode setzen, oder man kann einen ScrollingStyle dynamisch spezifizieren wenn der
Paginator im View Skript dargestellt wird. Das benötigt den manuellen Aufruf des View Helfers im View Skript.

.. code-block:: php
   :linenos:

   // $this->paginator ist ein Paginator Objekt
   <?php echo $this->paginationControl($this->paginator, 'Elastic', 'controls.phtml'); ?>

Für eine Liste aller vorhandenen ScrollingStyles, kann in das Referenz Handbuch gesehen werden.


