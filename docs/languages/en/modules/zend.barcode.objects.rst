.. _zend.barcode.objects:

Zend\\Barcode Objects
=====================

Barcode objects allow you to generate barcodes independently of the rendering support. After generation, you can
retrieve the barcode as an array of drawing instructions that you can provide to a renderer.

Objects have a large number of options. Most of them are common to all objects. These options can be set in three
ways:

- As an array or a `Traversable`_ object passed to the constructor.

- As an array passed to the ``setOptions()`` method.

- Via individual setters for each configuration type.

.. _zend.barcode.objects.configuration:

.. rubric:: Different ways to parameterize a barcode object

.. code-block:: php
   :linenos:

   use Zend\Barcode\Object;

   $options = array('text' => 'ZEND-FRAMEWORK', 'barHeight' => 40);

   // Case 1: constructor
   $barcode = new Object\Code39($options);

   // Case 2: setOptions()
   $barcode = new Object\Code39();
   $barcode->setOptions($options);

   // Case 3: individual setters
   $barcode = new Object\Code39();
   $barcode->setText('ZEND-FRAMEWORK')
           ->setBarHeight(40);

.. _zend.barcode.objects.common.options:

Common Options
--------------

In the following list, the values have no units; we will use the term "unit." For example, the default value of the
"thin bar" is "1 unit". The real units depend on the rendering support (see :ref:`the renderers documentation
<zend.barcode.renderers>` for more information). Setters are each named by uppercasing the initial letter of the
option and prefixing the name with "set" (e.g. "barHeight" becomes "setBarHeight"). All options have a
corresponding getter prefixed with "get" (e.g. "getBarHeight"). Available options are:

.. _zend.barcode.objects.common.options.table:

.. table:: Common Options

   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |Option            |Data Type        |Default Value        |Description                                                                                                |
   +==================+=================+=====================+===========================================================================================================+
   |barcodeNamespace  |String           |Zend\\Barcode\\Object|Namespace of the barcode; for example, if you need to extend the embedding objects                         |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |barHeight         |Integer          |50                   |Height of the bars                                                                                         |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |barThickWidth     |Integer          |3                    |Width of the thick bar                                                                                     |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |barThinWidth      |Integer          |1                    |Width of the thin bar                                                                                      |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |factor            |Integer          |1                    |Factor by which to multiply bar widths and font sizes (barHeight, barThinWidth, barThickWidth and fontSize)|
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |foreColor         |Integer          |0x000000 (black)     |Color of the bar and the text. Could be provided as an integer or as a HTML value (e.g. "#333333")         |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |backgroundColor   |Integer or String|0xFFFFFF (white)     |Color of the background. Could be provided as an integer or as a HTML value (e.g. "#333333")               |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |orientation       |Float            |0                    |Orientation of the barcode                                                                                 |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |font              |String or Integer|NULL                 |Font path to a TTF font or a number between 1 and 5 if using image generation with GD (internal fonts)     |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |fontSize          |Float            |10                   |Size of the font (not applicable with numeric fonts)                                                       |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |withBorder        |Boolean          |FALSE                |Draw a border around the barcode and the quiet zones                                                       |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |withQuietZones    |Boolean          |TRUE                 |Leave a quiet zone before and after the barcode                                                            |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |drawText          |Boolean          |TRUE                 |Set if the text is displayed below the barcode                                                             |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |stretchText       |Boolean          |FALSE                |Specify if the text is stretched all along the barcode                                                     |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |withChecksum      |Boolean          |FALSE                |Indicate whether or not the checksum is automatically added to the barcode                                 |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |withChecksumInText|Boolean          |FALSE                |Indicate whether or not the checksum is displayed in the textual representation                            |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+
   |text              |String           |NULL                 |The text to represent as a barcode                                                                         |
   +------------------+-----------------+---------------------+-----------------------------------------------------------------------------------------------------------+

.. _zend.barcode.barcode.common.options.barcodefont:

Particular case of static setBarcodeFont()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can set a common font for all your objects by using the static method
``Zend\Barcode\Barcode::setBarcodeFont()``. This value can be always be overridden for individual objects by using
the ``setFont()`` method.

.. code-block:: php
   :linenos:

   use Zend\Barcode\Barcode;

   // In your bootstrap:
   Barcode::setBarcodeFont('my_font.ttf');

   // Later in your code:
   Barcode::render(
       'code39',
       'pdf',
       array('text' => 'ZEND-FRAMEWORK')
   ); // will use 'my_font.ttf'

   // or:
   Barcode::render(
       'code39',
       'image',
       array(
           'text' => 'ZEND-FRAMEWORK',
           'font' => 3
       )
   ); // will use the 3rd GD internal font

.. _zend.barcode.objects.common.getters:

Common Additional Getters
-------------------------



.. _zend.barcode.objects.common.getters.table:

.. table:: Common Getters

   +-----------------------------------+---------+-----------------------------------------------------------------------------------------------------------------------+
   |Getter                             |Data Type|Description                                                                                                            |
   +===================================+=========+=======================================================================================================================+
   |getType()                          |String   |Return the name of the barcode class without the namespace (e.g. Zend\\Barcode\\Object\\Code39 returns simply "code39")|
   +-----------------------------------+---------+-----------------------------------------------------------------------------------------------------------------------+
   |getRawText()                       |String   |Return the original text provided to the object                                                                        |
   +-----------------------------------+---------+-----------------------------------------------------------------------------------------------------------------------+
   |getTextToDisplay()                 |String   |Return the text to display, including, if activated, the checksum value                                                |
   +-----------------------------------+---------+-----------------------------------------------------------------------------------------------------------------------+
   |getQuietZone()                     |Integer  |Return the size of the space needed before and after the barcode without any drawing                                   |
   +-----------------------------------+---------+-----------------------------------------------------------------------------------------------------------------------+
   |getInstructions()                  |Array    |Return drawing instructions as an array.                                                                               |
   +-----------------------------------+---------+-----------------------------------------------------------------------------------------------------------------------+
   |getHeight($recalculate = false)    |Integer  |Return the height of the barcode calculated after possible rotation                                                    |
   +-----------------------------------+---------+-----------------------------------------------------------------------------------------------------------------------+
   |getWidth($recalculate = false)     |Integer  |Return the width of the barcode calculated after possible rotation                                                     |
   +-----------------------------------+---------+-----------------------------------------------------------------------------------------------------------------------+
   |getOffsetTop($recalculate = false) |Integer  |Return the position of the top of the barcode calculated after possible rotation                                       |
   +-----------------------------------+---------+-----------------------------------------------------------------------------------------------------------------------+
   |getOffsetLeft($recalculate = false)|Integer  |Return the position of the left of the barcode calculated after possible rotation                                      |
   +-----------------------------------+---------+-----------------------------------------------------------------------------------------------------------------------+

.. include:: zend.barcode.objects.details.rst


.. _`Traversable`: http://php.net/traversable
