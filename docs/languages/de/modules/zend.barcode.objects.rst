.. EN-Revision: none
.. _zend.barcode.objects:

Zend_Barcode Objekte
====================

Barcode Objekte erlauben es Barcodes unabhängig von der Unterstützung eines Renderers zu erstellen. Nach der
Erstellung kann der Barcode als Array von Zeichen Anweisungen empfangen werden die an einen Renderer übergeben
werden können.

Objekte haben eine große Anzahl an Optionen. Die meisten von Ihnen sind allen Objekten gemein. Diese Optionen
können auf vier Wegen gesetzt werden:

- Als Array oder ``Zend_Config`` Objekt welches dem Constructor übergeben wird.

- Als Array das der ``setOptions()`` Methode übergeben wird.

- Als ``Zend_Config`` Objekt welches der ``setConfig()`` Methode übergeben wird.

- Über individuelle Setter für jeden Konfigurations Typ.

.. _zend.barcode.objects.configuration:

.. rubric:: Unterschiedliche Wege ein Barcode Objekt zu parametrisieren

.. code-block:: php
   :linenos:

   $options = array('text' => 'ZEND-FRAMEWORK', 'barHeight' => 40);

   // Fall 1: Constructor
   $barcode = new Zend\Barcode_Object\Code39($options);

   // Fall 2: setOptions()
   $barcode = new Zend\Barcode_Object\Code39();
   $barcode->setOptions($options);

   // Fall 3: setConfig()
   $config  = new Zend\Config\Config($options);
   $barcode = new Zend\Barcode_Object\Code39();
   $barcode->setConfig($config);

   // Fall 4: individuelle Setter
   $barcode = new Zend\Barcode_Object\Code39();
   $barcode->setText('ZEND-FRAMEWORK')
           ->setBarHeight(40);

.. _zend.barcode.objects.common.options:

Gemeinsame Optionen
-------------------

In der folgenden Liste haben die Werte keine Einheit; wir werden den Ausdruck "Einheit" verwenden. Zum Beispiel,
ist der Standardwert "dünner Balken" genau "1 Einheit". Die echte Einheit hängt von der Unterstützung beim
Darstellen ab (siehe :ref:`die Renderer Dokumentation <zend.barcode.renderers>` für mehr Informationen). Setter
werden benannt indem der erste Buchstabe der Option großgeschrieben und dem Namen "set" vorangestellt wird (z.B.
"barHeight" => "setBarHeight"). Alle Optionen haben einen entsprechenden Getter dem "get" vorangestellt ist (z.B.
"getBarHeight"). Die vorhandenen Optionen sind:

.. _zend.barcode.objects.common.options.table:

.. table:: Gemeinsame Optionen

   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |Option            |Daten Typ          |Standardwert       |Beschreibung                                                                                                                     |
   +==================+===================+===================+=================================================================================================================================+
   |barcodeNamespace  |String             |Zend\Barcode\Object|Namespace des Renderers; zum Beispiel wenn man den Renderer erweitern muss                                                       |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |barHeight         |Integer            |50                 |Höhe der Balken                                                                                                                  |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |barThickWidth     |Integer            |3                  |Breite des dicken Balken                                                                                                         |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |barThinWidth      |Integer            |1                  |Breite des dünnen Balkens                                                                                                        |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |factor            |Integer            |1                  |Faktor mit dem die Balkenbreiten und Schriftgrößen multipliziert werden                                                          |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |foreColor         |Integer            |0 (schwarz)        |Farbe des Balken und des Textes. Könnte als Integer oder als HTML Wert übergeben werden (z.B. "#333333")                         |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |backgroundColor   |Integer oder String|16777125 (white)   |Farbe des Hintergrundes. Könnte als Integer oder als HTML Wert übergeben werden (z.B. "#333333")                                 |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |reverseColor      |Boolean            |FALSE              |Erlaubt die Änderung der Farbe des Balken und des Hintergrunds                                                                   |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |orientation       |Integer            |0                  |Orientierung des Barcodes                                                                                                        |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |font              |String oder Integer|NULL               |Pfad zu einer TTF Schriftart oder eine Zahl zwischen 1 und 5 wenn die Bilderstellung mit GD verwendet wird (interne Schriftarten)|
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |fontSize          |Integer            |10                 |Größe der Schriftart (nicht anwendbar bei nummerischen Schriftarten)                                                             |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |withBorder        |Boolean            |FALSE              |Zeichnet einen Rahmen um den Barcode und die Randzonen                                                                           |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |withQuietZones    |Boolean            |TRUE               |Lässt die Leerzone vor und nach dem Barcode weg                                                                                  |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |drawText          |Boolean            |TRUE               |Setzt ob der Text unter dem Barcode angezeigt wird                                                                               |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |stretchText       |Boolean            |FALSE              |Spezifiziert ob der Text entlang des kompletten Barcodes gestreckt werden soll                                                   |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |withChecksum      |Boolean            |FALSE              |Zeigt ob die Checksumme dem Barcode automatisch hinzugefügt wird oder nicht                                                      |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |withChecksumInText|Boolean            |FALSE              |Zeigt ob die Checksumme in der textuellen Repräsentation angezeigt wird oder nicht                                               |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+
   |text              |String             |NULL               |Der Text der repräsentiert wird, als Barcode                                                                                     |
   +------------------+-------------------+-------------------+---------------------------------------------------------------------------------------------------------------------------------+

.. _zend.barcode.objects.common.options.barcodefont:

Spezieller Fall der statischen setBarcodeFont()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Man kann eine gemeinsame Schriftart für alle eigenen Objekte setzen indem die statische Methode
``Zend\Barcode\Object::setBarcodeFont()`` verwendet wird. Dieser Wert wird von individuellen Objekten immer
überschrieben wenn die ``setFont()`` Methode verwendet wird.

.. code-block:: php
   :linenos:

   // In der eigenen Bootstrap Datei:
   Zend\Barcode\Object::setBarcodeFont('my_font.ttf');

   // Später im eigenen Code:
   Zend\Barcode\Barcode::render(
       'code39',
       'pdf',
       array('text' => 'ZEND-FRAMEWORK')
   ); // will use 'my_font.ttf'

   // oder:
   Zend\Barcode\Barcode::render(
       'code39',
       'image',
       array(
           'text' => 'ZEND-FRAMEWORK',
           'font' => 3
       )
   ); // will use the 3rd GD internal font

.. _zend.barcode.objects.common.getters:

Gemeinsame zusätzliche Getter
-----------------------------



.. _zend.barcode.objects.common.getters.table:

.. table:: Gemeinsame Getter

   +-----------------------------------+---------+--------------------------------------------------------------------------------------------------------------------------+
   |Getter                             |Daten Typ|Beschreibung                                                                                                              |
   +===================================+=========+==========================================================================================================================+
   |getType()                          |String   |Gibt den Namen der Barcode Klasse ohne den Namespace zurück (z.B. gibt Zend\Barcode_Object\Code39 einfach "code39" zurück)|
   +-----------------------------------+---------+--------------------------------------------------------------------------------------------------------------------------+
   |getRawText()                       |String   |Gibt den originalen Text zurück der beim Objekt angegeben wurde                                                           |
   +-----------------------------------+---------+--------------------------------------------------------------------------------------------------------------------------+
   |getTextToDisplay()                 |String   |Gibt den Text zurück welche angezeigt wird, inklusive, wenn aktiviert, den Wert der Checksumme                            |
   +-----------------------------------+---------+--------------------------------------------------------------------------------------------------------------------------+
   |getQuietZone()                     |Integer  |Gibt die Größe des Raumes an der vor und nach dem Barcode benötigt wird und keine Zeichnung enthält                       |
   +-----------------------------------+---------+--------------------------------------------------------------------------------------------------------------------------+
   |getInstructions()                  |Array    |Gibt die Zeichenanweisungen als Array zurück.                                                                             |
   +-----------------------------------+---------+--------------------------------------------------------------------------------------------------------------------------+
   |getHeight($recalculate = false)    |Integer  |Gibt die Höhe des Barcodes berechnet nach einer möglichen Rotation zurück                                                 |
   +-----------------------------------+---------+--------------------------------------------------------------------------------------------------------------------------+
   |getWidth($recalculate = false)     |Integer  |Gibt den Wert des Barcodes berechnet nach einer möglichen Rotation zurück                                                 |
   +-----------------------------------+---------+--------------------------------------------------------------------------------------------------------------------------+
   |getOffsetTop($recalculate = false) |Integer  |Gibt die oberste Position des Barcodes berechnet nach einer möglichen Rotation zurück                                     |
   +-----------------------------------+---------+--------------------------------------------------------------------------------------------------------------------------+
   |getOffsetLeft($recalculate = false)|Integer  |Gibt die linke Position des Barcodes berechnet nach einer möglichen Rotation zurück                                       |
   +-----------------------------------+---------+--------------------------------------------------------------------------------------------------------------------------+

.. include:: zend.barcode.objects.details.rst

