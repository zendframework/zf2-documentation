.. EN-Revision: none
.. _zend.barcode.renderers:

Zend_Barcode Renderer
=====================

Renderer haben einige gemeinsame Optionen. Diese Optionen können auf vier Wegen gesetzt werden:

- Als Array oder ``Zend_Config`` Objekt das dem Constructor übergeben wird.

- Als Array das der ``setOptions()`` Methode übergeben wird.

- Als ``Zend_Config`` Objekt das der ``setConfig()`` Methode übergeben wird.

- Als diskreter Wert der an individuelle Setter übergeben wird.

.. _zend.barcode.renderers.configuration:

.. rubric:: Unterschiedliche Wegen ein Renderer Objekt zu parametrisieren

.. code-block:: php
   :linenos:

   $options = array('topOffset' => 10);

   // Fall 1
   $renderer = new Zend_Barcode_Renderer_Pdf($options);

   // Fall 2
   $renderer = new Zend_Barcode_Renderer_Pdf();
   $renderer->setOptions($options);

   // Fall 3
   $config   = new Zend_Config($options);
   $renderer = new Zend_Barcode_Renderer_Pdf();
   $renderer->setConfig($config);

   // Fall 4
   $renderer = new Zend_Barcode_Renderer_Pdf();
   $renderer->setTopOffset(10);

.. _zend.barcode.renderers.common.options:

Gemeinsame Optionen
-------------------

In der folgenden Liste haben die Werte keine Einheit; wir werden den Ausdruck "Einheit" verwenden. Zum Beispiel,
ist der Standardwert "dünner Balken" genau "1 Einheit". Die echte Einheit hängt von der Unterstützung beim
Darstellen ab. Die individuellen Setter werden erkannt indem der erste Buchstabe der Option großgeschrieben und
dem Namen "set" vorangestellt wird (z.B. "barHeight" => "setBarHeight"). Alle Optionen haben einen entsprechenden
Getter dem "get" vorangestellt ist (z.B. "getBarHeight"). Die vorhandenen Optionen sind:

.. _zend.barcode.renderers.common.options.table:

.. table:: Gemeinsame Optionen

   +--------------------+-------------------+---------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Option              |Daten Typ          |Standardwert         |Beschreibung                                                                                                                                                                                                                                                         |
   +====================+===================+=====================+=====================================================================================================================================================================================================================================================================+
   |rendererNamespace   |String             |Zend_Barcode_Renderer|Namespace des Renderers; zum Beispiel wenn man den Renderer erweitern muss                                                                                                                                                                                           |
   +--------------------+-------------------+---------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |horizontalPosition  |String             |"left"               |Kann "left", "center" oder "right" sein. Das kann bei PDF nützlich sein, oder wenn die setWidth() Methode mit einem Image Renderer verwendet wird.                                                                                                                   |
   +--------------------+-------------------+---------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |verticalPosition    |String             |"top"                |Kann "top", "middle" oder "bottom" sein. Das kann bei PDF nützlich sein, oder wenn die setHeight() Methode mit einem Image Renderer verwendet wird.                                                                                                                  |
   +--------------------+-------------------+---------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |leftOffset          |Integer            |0                    |Oberste Position des Barcodes innerhalb des Renderers. Wenn er verwendet wird, überschreibt dieser Wert die Option "horizontalPosition".                                                                                                                             |
   +--------------------+-------------------+---------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |topOffset           |Integer            |0                    |Oberste Position des Barcodes innerhalb des Renderers. Wenn er verwendet wird, überschreibt dieser Wert die Option "verticalPosition".                                                                                                                               |
   +--------------------+-------------------+---------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automaticRenderError|Boolean            |TRUE                 |Ob Fehler automatisch dargestellt werden sollen oder nicht. Wenn eine Exception stattfindet, wird das angegebene Barcode Objekt mit einer Repräsentation des Fehlers ersetzt. Es ist zu beachten das einige Fehler (oder Exceptions) nicht dargestellt werden können.|
   +--------------------+-------------------+---------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |moduleSize          |Float              |1                    |Größe eines darstellenden Moduls im Support.                                                                                                                                                                                                                         |
   +--------------------+-------------------+---------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |barcode             |Zend_Barcode_Object|NULL                 |Das Barcode Objekt welches dargestellt werden soll.                                                                                                                                                                                                                  |
   +--------------------+-------------------+---------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

Es existiert ein zusätzlicher Getter: ``getType()``. Er gibt den Namen der Renderer Klasse ohne den Namespace
zurück (z.B. gibt ``Zend_Barcode_Renderer_Image``"image" zurück.

.. _zend.barcode.renderers.image:

Zend_Barcode_Renderer_Image
---------------------------

Der Image Renderer zeichnet die Anweisungsliste des Barcode Obejekts in eine Bild Ressource. Die Komponente
benötigt die GD Erweiterung. Die Standardbreite eines Moduls ist 1 Pixel.

Vorhandene Optionen sind:

.. _zend.barcode.renderers.image.table:

.. table:: Zend_Barcode_Renderer_Image Optionen

   +---------+---------+------------+-------------------------------------------------------------------------------------------------------------------------------+
   |Option   |Daten Typ|Standardwert|Beschreibung                                                                                                                   |
   +=========+=========+============+===============================================================================================================================+
   |height   |Integer  |0           |Erlaubt es die Höhe des ergebenen Bildes zu spezifizieren. Wenn diese "0" ist wird die Höhe vom Barcode Objekt kalkuliert.     |
   +---------+---------+------------+-------------------------------------------------------------------------------------------------------------------------------+
   |width    |Integer  |0           |Erlaubt es die Breite des ergebenden Bildes zu spezifizieren. Wenn diese "0" ist wird die Breite vom Barcode Objekt kalkuliert.|
   +---------+---------+------------+-------------------------------------------------------------------------------------------------------------------------------+
   |imageType|String   |"png"       |Spezifiziert das Bildformat. Kann "png", "jpeg", "jpg" oder "gif" sein.                                                        |
   +---------+---------+------------+-------------------------------------------------------------------------------------------------------------------------------+

.. _zend.barcode.renderers.pdf:

Zend_Barcode_Renderer_Pdf
-------------------------

Der *PDF* Renderer zeichnet die Anweisungsliste des Barcode Objekts in ein *PDF* Dokument. Die Standardbreite eines
Moduls ist 0.5 Punkt.

Es gibt keine speziellen Optionen für diesen Renderer.


