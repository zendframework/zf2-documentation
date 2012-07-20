.. _zend.view.helpers.initial.headtitle:

HeadTitle Helfer
================

Das *HTML* **<title>** Element wird verwendet um einen Titel für ein *HTML* Dokument anzubieten. Der ``HeadTitle``
Helfer erlaubt es Titel für späteren Empfang und Ausgabe programmtechnisch zu Erstellen und zu Speichern.

Der ``HeadTitle`` Helfer ist eine konkrete Implementation des :ref:`Plaltzhalter Helfer
<zend.view.helpers.initial.placeholder>`. Er überschreibt die ``toString()`` Methode um die Erstellung des
**<title>** Elements zu erzwingen, und fügt eine ``headTitle()`` Methode für das schnelle und einfache Einstellen
und Ändern von Titel Elementen hinzu. Die Signatur dieser Methode ist ``headTitle($title, $setType = null)``;
standardmäßig, wird der Wert dem Stack angefügt (Anhäufen von Title Segmenten) wenn er auf null belassen wird,
aber es kann auch 'PREPEND' (Platzierung am Anfang des Stacks) oder 'SET' (Stack überschreiben) spezifiziert
werden.

Da das Setzen der weiteren (angehängten) Reihenfolge bei jedem Aufruf von ``headTitle`` nervend sein kann, kann
man eine standardmäßige weitere Reihenfolge setzen indem ``setDefaultAttachOrder()`` aufgerufen wird, welche bei
allen Aufrufen von ``headTitle()`` angewendet wird solange man nicht eine andere Reihenfolge explizit als zweiten
Parameter übergibt.

.. _zend.view.helpers.initial.headtitle.basicusage:

.. rubric:: Grundsätzliche Verwendung des HeadTitle Helfers

Es kann jederzeit ein Titel Tag spezifiziert werden. Die typische Verwendung besteht darin das Titel Segment bei
jedem Level an Tiefe in der Anwendung: Site, Controller, Aktion und potentiell Ressourcen.

.. code-block:: php
   :linenos:

   // Setzen des Controller und Aktion Namens als Titel Segment:
   $request = Zend_Controller_Front::getInstance()->getRequest();
   $this->headTitle($request->getActionName())
        ->headTitle($request->getControllerName());

   // Setzen der Site im Titel; möglicherweise das Layout Skript:
   $this->headTitle('Zend Framework');

   // Setzen eines Separator Strings für Segmente:
   $this->headTitle()->setSeparator(' / ');

Wenn man letztendlich damit fertig ist den Titel im Layoutskript darzustellen, muß dieser einfach ausgegeben
werden:

.. code-block:: php
   :linenos:

   <!-- Darstellung <action> / <controller> / Zend Framework -->
   <?php echo $this->headTitle() ?>


