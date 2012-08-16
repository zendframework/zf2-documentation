.. EN-Revision: none
.. _zend.view.helpers.initial.object:

HTML Objekt Helfer
==================

Das *HTML* **<object>** Element wird für das Einbetten von Medien wie Flash oder Quicktime in Webseiten verwendet.
Der Object View Helfer übernimmt die Einbettung von Medien mit einem minimalen Aufwand.

Es gibt initial view Objekt Helfer:

- ``htmlFlash()`` Erzeugt Markup für die Einbettung von Flash Dateien.

- ``htmlObject()`` Erzeugt Markup für die Einbettung von eigenen Objekten.

- ``htmlPage()`` Erzeugt Markup für die Einbettung anderer (X)HTML Seiten.

- ``htmlQuicktime()`` Erzeugt Markup für die Einbettung von QuickTime Dateien.

Alle diese Helfer teilen sich das gleiche Interface. Aus diesem Grund enthält diese Dokumentation nur Beispiele
für zwei dieser Helfer.

.. _zend.view.helpers.initial.object.flash:

.. rubric:: Flash Helfer

Die Einbettung von Flash in die eigene Seite mit Hilfe des Helfers ist recht direkt. Das einzige benötigte
Argument ist die Ressource *URI*.

.. code-block:: php
   :linenos:

   <?php echo $this->htmlFlash('/path/to/flash.swf'); ?>

Das gibt das folgende *HTML* aus:

.. code-block:: html
   :linenos:

   <object data="/path/to/flash.swf"
           type="application/x-shockwave-flash"
           classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
           codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab">
   </object>

Zusätzlich können Attribute, Parameter und Inhalte definiert werden die mit dem **<object>** dargestellt werden.
Das wird durch Verwendung des ``htmlObject()`` Helfers demonstriert.

.. _zend.view.helpers.initial.object.object:

.. rubric:: Anpassen des Objekts durch die Übergabe von zusätzlichen Argumenten

Das erste Argument des Objekt Helfers wird immer benötigt. Es ist die *URI* zu der Ressource die man einbetten
will. Das zweite Argument wird nur im ``htmlObject()`` Helfer benötigt. Die anderen Helfer enthalten bereits den
wichtigen Wert für dieses Argument. Der dritte Parameter wird für die Übergabe von Argumenten an das Objekt
Element verwendet. Es akzeptiert nur ein Array mit Schlüssel-Wert Paaren. Die ``classid`` und ``codebase`` sind
Beispiel für solche Attribute. Das vierte Argument nimmt auch Schlüssel-Wert Paare und verwendet diese für die
Erstellung von **<param>** Elementen. Sie sehen in Kürze ein Beispiel hierfür. Letztendlich, gibt es eine Option
für das zur Verfügungstellen von zusätzlichen Inhalten beim Objekt. Jetzt folgt ein Beispiel welches alle
Argumente verwendet.

.. code-block:: php
   :linenos:

   echo $this->htmlObject(
       '/path/to/file.ext',
       'mime/type',
       array(
           'attr1' => 'aval1',
           'attr2' => 'aval2'
       ),
       array(
           'param1' => 'pval1',
           'param2' => 'pval2'
       ),
       'some content'
   );

   /*
   Das würde folgendes ausgeben:

   <object data="/path/to/file.ext" type="mime/type"
       attr1="aval1" attr2="aval2">
       <param name="param1" value="pval1" />
       <param name="param2" value="pval2" />
       some content
   </object>
   */


