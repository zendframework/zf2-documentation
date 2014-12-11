.. _zend.barcode.creation:

Barcode creation using Zend\\Barcode\\Barcode class
===================================================

.. _zend.barcode.creation.configuration:

Using Zend\\Barcode\\Barcode::factory
-------------------------------------

``Zend\Barcode\Barcode`` uses a factory method to create an instance of a renderer that extends
``Zend\Barcode\Renderer\AbstractRenderer``. The factory method accepts five arguments.

- The name of the barcode format (e.g., "code39") or a `Traversable`_ object (required)

- The name of the renderer (e.g., "image") (required)

- Options to pass to the barcode object (an array or a `Traversable`_ object) (optional)

- Options to pass to the renderer object (an array or a `Traversable`_ object) (optional)

- Boolean to indicate whether or not to automatically render errors. If an exception occurs, the provided barcode
  object will be replaced with an Error representation (optional default ``TRUE``)

.. _zend.barcode.creation.configuration.example-1:

.. rubric:: Getting a Renderer with Zend\\Barcode\\Barcode::factory()

``Zend\Barcode\Barcode::factory()`` instantiates barcode classes and renderers and ties them together. In this
first example, we will use the **Code39** barcode type together with the **Image** renderer.

.. code-block:: php
   :linenos:

   use Zend\Barcode\Barcode;

   // Only the text to draw is required
   $barcodeOptions = array('text' => 'ZEND-FRAMEWORK');

   // No required options
   $rendererOptions = array();
   $renderer = Barcode::factory(
       'code39', 'image', $barcodeOptions, $rendererOptions
   );

.. _zend.barcode.creation.configuration.example-2:

.. rubric:: Using Zend\\Barcode\\Barcode::factory() with Zend\\Config\\Config objects

You may pass a ``Zend\Config\Config`` object to the factory in order to create the necessary objects. The following
example is functionally equivalent to the previous.

.. code-block:: php
   :linenos:

   use Zend\Config\Config;
   use Zend\Barcode\Barcode;

   // Using only one Zend\Config\Config object
   $config = new Config(array(
       'barcode'        => 'code39',
       'barcodeParams'  => array('text' => 'ZEND-FRAMEWORK'),
       'renderer'       => 'image',
       'rendererParams' => array('imageType' => 'gif'),
   ));

   $renderer = Barcode::factory($config);

.. _zend.barcode.creation.drawing:

Drawing a barcode
-----------------

When you **draw** the barcode, you retrieve the resource in which the barcode is drawn. To draw a barcode, you can
call the ``draw()`` of the renderer, or simply use the proxy method provided by ``Zend\Barcode\Barcode``.

.. _zend.barcode.creation.drawing.example-1:

.. rubric:: Drawing a barcode with the renderer object

.. code-block:: php
   :linenos:

   use Zend\Barcode\Barcode;

   // Only the text to draw is required
   $barcodeOptions = array('text' => 'ZEND-FRAMEWORK');

   // No required options
   $rendererOptions = array();

   // Draw the barcode in a new image,
   $imageResource = Barcode::factory(
       'code39', 'image', $barcodeOptions, $rendererOptions
   )->draw();

.. _zend.barcode.creation.drawing.example-2:

.. rubric:: Drawing a barcode with Zend\\Barcode\\Barcode::draw()

.. code-block:: php
   :linenos:

   use Zend\Barcode\Barcode;

   // Only the text to draw is required
   $barcodeOptions = array('text' => 'ZEND-FRAMEWORK');

   // No required options
   $rendererOptions = array();

   // Draw the barcode in a new image,
   $imageResource = Barcode::draw(
       'code39', 'image', $barcodeOptions, $rendererOptions
   );

.. _zend.barcode.creation.rendering:

Rendering a barcode
-------------------

When you render a barcode, you draw the barcode, you send the headers and you send the resource (e.g. to a
browser). To render a barcode, you can call the ``render()`` method of the renderer or simply use the proxy method
provided by ``Zend\Barcode\Barcode``.

.. _zend.barcode.creation.rendering.example-1:

.. rubric:: Rendering a barcode with the renderer object

.. code-block:: php
   :linenos:

   use Zend\Barcode\Barcode;

   // Only the text to draw is required
   $barcodeOptions = array('text' => 'ZEND-FRAMEWORK');

   // No required options
   $rendererOptions = array();

   // Draw the barcode in a new image,
   // send the headers and the image
   Barcode::factory(
       'code39', 'image', $barcodeOptions, $rendererOptions
   )->render();

This will generate this barcode:

.. image:: ../images/zend.barcode.introduction.example-1.png
   :width: 275
   :align: center

.. _zend.barcode.creation.rendering.example-2:

.. rubric:: Rendering a barcode with Zend\\Barcode\\Barcode::render()

.. code-block:: php
   :linenos:

   use Zend\Barcode\Barcode;

   // Only the text to draw is required
   $barcodeOptions = array('text' => 'ZEND-FRAMEWORK');

   // No required options
   $rendererOptions = array();

   // Draw the barcode in a new image,
   // send the headers and the image
   Barcode::render(
       'code39', 'image', $barcodeOptions, $rendererOptions
   );

This will generate the same barcode as the previous example.



.. _`Traversable`: http://php.net/traversable
