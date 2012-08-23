.. EN-Revision: none
.. _zend.barcode.creation:

Barcodes mit Hilfe der Zend_Barcode Klasse erstellen
====================================================

.. _zend.barcode.creation.configuration:

Verwendung von Zend_Barcode::factory
------------------------------------

``Zend_Barcode`` verwendet eine Factory Methode um die Instanz eines Renderers zu erstellen der
``Zend_Barcode_Renderer_RendererAbstract`` erweitert. Die Factory Methode akzeptiert fünf Argumente.

. Der Name des Barcode Formats (z.B., "code39") (benötigt)

. Der Name des Renderers (z.B., "image") (benötigt)

. Optionen die an das Barcode Objekt übergeben werden (ein Array oder ``Zend_Config`` Objekt) (optional)

. Optionen die an das Renderer Objekt übergeben werden (ein Array oder ``Zend_Config`` Object) (optional)

. Ein Boolean um anzuzeigen ob Fehler automatisch dargestellt werden sollen oder nicht. Wenn eine Exception
  stattfindet, wird das angegebene Barcode Objekt mit der Repräsentation des Fehlers ersetzt (optional der
  Standardwert ``TRUE``)

.. _zend.barcode.creation.configuration.example-1:

.. rubric:: Einen Renderer mit Zend_Barcode::factory() erhalten

``Zend_Barcode::factory()`` instanziert Barcode Objekte und Renderer und verbindet diese miteinander. In diesem
ersten Beispiel verwenden wir den **Code39** Barcode Typ zusammen mit dem **Image** Renderer.

.. code-block:: php
   :linenos:

   // Nur der darzustellende Text wird benötigt
   $barcodeOptions = array('text' => 'ZEND-FRAMEWORK');

   // Keine Optionen benötigt
   $rendererOptions = array();
   $renderer = Zend_Barcode::factory(
       'code39', 'image', $barcodeOptions, $rendererOptions
   );

.. _zend.barcode.creation.configuration.example-2:

.. rubric:: Zend_Barcode::factory() mit Zend_Config Objekten verwenden

Man kann ein ``Zend_Config`` Objekt an die Factory übergeben um die notwendigen Objekte zu erstellen. Das folgende
Beispiel ist funktionell identisch mit dem vorherigen.

.. code-block:: php
   :linenos:

   // Nur ein Zend_Config Objekt verwenden
   $config = new Zend_Config(array(
       'barcode'        => 'code39',
       'barcodeParams'  => array('text' => 'ZEND-FRAMEWORK'),
       'renderer'       => 'image',
       'rendererParams' => array('imageType' => 'gif'),
   ));

   $renderer = Zend_Barcode::factory($config);

.. _zend.barcode.creation.drawing:

Einen Barcode zeichnen
----------------------

Wenn der Barcode **gezeichnet** wird, empfängt man die Ressource in welcher der Barcode gezeichnet wird. Um einen
Barcode zu zeichnen kann man die ``draw()`` Methode des Renderers aufrufen, oder einfach die von ``Zend_Barcode``
angebotene Proxy Methode verwenden.

.. _zend.barcode.creation.drawing.example-1:

.. rubric:: Einen Barcode mit dem Renderer Objekt zeichnen

.. code-block:: php
   :linenos:

   // Nur der zu zeichnende Text wird benötigt
   $barcodeOptions = array('text' => 'ZEND-FRAMEWORK');

   // Keine Optionen benötigt
   $rendererOptions = array();

   // Zeichne den Barcode in einem neuen Bild
   $imageResource = Zend_Barcode::factory(
       'code39', 'image', $barcodeOptions, $rendererOptions
   )->draw();

.. _zend.barcode.creation.drawing.example-2:

.. rubric:: Einen Barcode mit Zend_Barcode::draw() zeichnen

.. code-block:: php
   :linenos:

   // Nur der zu zeichnende Text wird benötigt
   $barcodeOptions = array('text' => 'ZEND-FRAMEWORK');

   // Keine Optionen benötigt
   $rendererOptions = array();

   // Zeichne den Barcode in einem neuen Bild
   $imageResource = Zend_Barcode::draw(
       'code39', 'image', $barcodeOptions, $rendererOptions
   );

.. _zend.barcode.creation.renderering:

Einen Barcode darstellen
------------------------

Wenn man einen Barcode darstellt, zeichnet man den Barcode, man sendet die Header und man sendet die Ressource
(z.B. zu einem Browser). Um einen Barcode darzustellen muss man die ``render()`` Methode des Renderers aufrufen,
oder einfach die Proxy Methode verwenden die von ``Zend_Barcode`` angeboten wird.

.. _zend.barcode.creation.renderering.example-1:

.. rubric:: Einen Barcode mit dem Renderer Objekt darstellen

.. code-block:: php
   :linenos:

   // Nur der zu zeichnende Text wird benötigt
   $barcodeOptions = array('text' => 'ZEND-FRAMEWORK');

   // Keine Optionen benötigt
   $rendererOptions = array();

   // Zeichne den Barcode in einem neuen Bild
   // Sende die Header und das Bild
   Zend_Barcode::factory(
       'code39', 'image', $barcodeOptions, $rendererOptions
   )->render();

Das wird diesen Barcode erstellen:

.. image:: ../images/zend.barcode.introduction.example-1.png
   :width: 275
   :align: center

.. _zend.barcode.creation.renderering.example-2:

.. rubric:: Einen Barcode mit Zend_Barcode::render() darstellen

.. code-block:: php
   :linenos:

   // Nur der zu zeichnende Text wird benötigt
   $barcodeOptions = array('text' => 'ZEND-FRAMEWORK');

   // Keine Optionen benötigt
   $rendererOptions = array();

   // Zeichne den Barcode in einem neuen Bild
   // Sende die Header und das Bild
   Zend_Barcode::render(
       'code39', 'image', $barcodeOptions, $rendererOptions
   );

Das wird den selben Barcode erzeugen wie im vorherigen Beispiel.


