.. _zendpdf.drawing:

Drawing
=======

.. _zendpdf.drawing.geometry:

Geometry
--------

*PDF* uses the same geometry as PostScript. It starts from bottom-left corner of page and by default is measured in
points (1/72 of an inch).

Page size can be retrieved from a page object:

.. code-block:: php
   :linenos:

   $width  = $pdfPage->getWidth();
   $height = $pdfPage->getHeight();

.. _zendpdf.drawing.color:

Colors
------

*PDF* has a powerful capabilities for colors representation. ``ZendPdf`` module supports Gray Scale, RGB and CMYK
color spaces. Any of them can be used in any place, where ``ZendPdf\Color`` object is required.
``ZendPdf\Color\GrayScale``, ``ZendPdf\Color\Rgb`` and ``ZendPdf\Color\Cmyk`` classes provide this
functionality:

.. code-block:: php
   :linenos:

   // $grayLevel (float number). 0.0 (black) - 1.0 (white)
   $color1 = new ZendPdf\Color\GrayScale($grayLevel);

   // $r, $g, $b (float numbers). 0.0 (min intensity) - 1.0 (max intensity)
   $color2 = new ZendPdf\Color\Rgb($r, $g, $b);

   // $c, $m, $y, $k (float numbers). 0.0 (min intensity) - 1.0 (max intensity)
   $color3 = new ZendPdf\Color\Cmyk($c, $m, $y, $k);

*HTML* style colors are also provided with ``ZendPdf\Color\Html`` class:

.. code-block:: php
   :linenos:

   $color1 = new ZendPdf\Color\Html('#3366FF');
   $color2 = new ZendPdf\Color\Html('silver');
   $color3 = new ZendPdf\Color\Html('forestgreen');

.. _zendpdf.drawing.shape-drawing:

Shape Drawing
-------------

All drawing operations can be done in a context of *PDF* page.

``ZendPdf\Page`` class provides a set of drawing primitives:

.. code-block:: php
   :linenos:

   /**
    * Draw a line from x1,y1 to x2,y2.
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @return ZendPdf\Page
    */
   public function drawLine($x1, $y1, $x2, $y2);

.. code-block:: php
   :linenos:

   /**
    * Draw a rectangle.
    *
    * Fill types:
    * ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE - fill rectangle
    *                                             and stroke (default)
    * ZendPdf\Page::SHAPE_DRAW_STROKE          - stroke rectangle
    * ZendPdf\Page::SHAPE_DRAW_FILL            - fill rectangle
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param integer $fillType
    * @return ZendPdf\Page
    */
   public function drawRectangle($x1, $y1, $x2, $y2,
                       $fillType = ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE);

.. code-block:: php
   :linenos:

   /**
    * Draw a rounded rectangle.
    *
    * Fill types:
    * ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE - fill rectangle
    *                                             and stroke (default)
    * ZendPdf\Page::SHAPE_DRAW_STROKE      - stroke rectangle
    * ZendPdf\Page::SHAPE_DRAW_FILL        - fill rectangle
    *
    * radius is an integer representing radius of the four corners, or an array
    * of four integers representing the radius starting at top left, going
    * clockwise
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param integer|array $radius
    * @param integer $fillType
    * @return ZendPdf\Page
    */
   public function drawRoundedRectangle($x1, $y1, $x2, $y2, $radius,
                          $fillType = ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE);

.. code-block:: php
   :linenos:

   /**
    * Draw a polygon.
    *
    * If $fillType is ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE or
    * ZendPdf\Page::SHAPE_DRAW_FILL, then polygon is automatically closed.
    * See detailed description of these methods in a PDF documentation
    * (section 4.4.2 Path painting Operators, Filling)
    *
    * @param array $x  - array of float (the X co-ordinates of the vertices)
    * @param array $y  - array of float (the Y co-ordinates of the vertices)
    * @param integer $fillType
    * @param integer $fillMethod
    * @return ZendPdf\Page
    */
   public function drawPolygon($x, $y,
                               $fillType =
                                   ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE,
                               $fillMethod =
                                   ZendPdf\Page::FILL_METHOD_NON_ZERO_WINDING);

.. code-block:: php
   :linenos:

   /**
    * Draw a circle centered on x, y with a radius of radius.
    *
    * Angles are specified in radians
    *
    * Method signatures:
    * drawCircle($x, $y, $radius);
    * drawCircle($x, $y, $radius, $fillType);
    * drawCircle($x, $y, $radius, $startAngle, $endAngle);
    * drawCircle($x, $y, $radius, $startAngle, $endAngle, $fillType);
    *
    *
    * It's not a really circle, because PDF supports only cubic Bezier
    * curves. But very good approximation.
    * It differs from a real circle on a maximum 0.00026 radiuses (at PI/8,
    * 3*PI/8, 5*PI/8, 7*PI/8, 9*PI/8, 11*PI/8, 13*PI/8 and 15*PI/8 angles).
    * At 0, PI/4, PI/2, 3*PI/4, PI, 5*PI/4, 3*PI/2 and 7*PI/4 it's exactly
    * a tangent to a circle.
    *
    * @param float $x
    * @param float $y
    * @param float $radius
    * @param mixed $param4
    * @param mixed $param5
    * @param mixed $param6
    * @return ZendPdf\Page
    */
   public function  drawCircle($x,
                               $y,
                               $radius,
                               $param4 = null,
                               $param5 = null,
                               $param6 = null);

.. code-block:: php
   :linenos:

   /**
    * Draw an ellipse inside the specified rectangle.
    *
    * Method signatures:
    * drawEllipse($x1, $y1, $x2, $y2);
    * drawEllipse($x1, $y1, $x2, $y2, $fillType);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle, $fillType);
    *
    * Angles are specified in radians
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param mixed $param5
    * @param mixed $param6
    * @param mixed $param7
    * @return ZendPdf\Page
    */
   public function drawEllipse($x1,
                               $y1,
                               $x2,
                               $y2,
                               $param5 = null,
                               $param6 = null,
                               $param7 = null);

.. _zendpdf.drawing.text-drawing:

Text Drawing
------------

Text drawing operations also exist in the context of a *PDF* page. You can draw a single line of text at any
position on the page by supplying the x and y coordinates of the baseline. Current font and current font size are
used for text drawing operations (see detailed description below).

.. code-block:: php
   :linenos:

   /**
    * Draw a line of text at the specified position.
    *
    * @param string $text
    * @param float $x
    * @param float $y
    * @param string $charEncoding (optional) Character encoding of source
    *               text.Defaults to current locale.
    * @throws ZendPdf\Exception
    * @return ZendPdf\Page
    */
   public function drawText($text, $x, $y, $charEncoding = '');

.. _zendpdf.drawing.text-drawing.example-1:

.. rubric:: Draw a string on the page

.. code-block:: php
   :linenos:

   ...
   $pdfPage->drawText('Hello world!', 72, 720);
   ...

By default, text strings are interpreted using the character encoding method of the current locale. if you have a
string that uses a different encoding method (such as a UTF-8 string read from a file on disk, or a MacRoman string
obtained from a legacy database), you can indicate the character encoding at draw time and ``ZendPdf`` will handle
the conversion for you. You can supply source strings in any encoding method supported by *PHP*'s `iconv()`_
function:

.. _zendpdf.drawing.text-drawing.example-2:

.. rubric:: Draw a UTF-8-encoded string on the page

.. code-block:: php
   :linenos:

   ...
   // Read a UTF-8-encoded string from disk
   $unicodeString = fread($fp, 1024);

   // Draw the string on the page
   $pdfPage->drawText($unicodeString, 72, 720, 'UTF-8');
   ...

.. _zendpdf.drawing.using-fonts:

Using fonts
-----------

``ZendPdf\Page::drawText()`` uses the page's current font and font size, which is set with the
``ZendPdf\Page::setFont()`` method:

.. code-block:: php
   :linenos:

   /**
    * Set current font.
    *
    * @param ZendPdf\Resource\Font $font
    * @param float $fontSize
    * @return ZendPdf\Page
    */
   public function setFont(ZendPdf\Resource\Font $font, $fontSize);

*PDF* documents support PostScript Type 1 and TrueType fonts, as well as two specialized *PDF* types, Type 3 and
composite fonts. There are also 14 standard Type 1 fonts built-in to every *PDF* viewer: Courier (4 styles),
Helvetica (4 styles), Times (4 styles), Symbol, and Zapf Dingbats.

``ZendPdf`` currently supports the standard 14 *PDF* fonts as well as your own custom TrueType fonts. Font objects
are obtained via one of two factory methods: ``ZendPdf\Font::fontWithName($fontName)`` for the standard 14 *PDF*
fonts or ``ZendPdf\Font::fontWithPath($filePath)`` for custom fonts.

.. _zendpdf.drawing.using-fonts.example-1:

.. rubric:: Create a standard font

.. code-block:: php
   :linenos:

   ...
   // Create new font
   $font = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_HELVETICA);

   // Apply font
   $pdfPage->setFont($font, 36);
   ...

Constants for the standard 14 *PDF* font names are defined in the ``ZendPdf\Font`` class:

   - ZendPdf\Font::FONT_COURIER

   - ZendPdf\Font::FONT_COURIER_BOLD

   - ZendPdf\Font::FONT_COURIER_ITALIC

   - ZendPdf\Font::FONT_COURIER_BOLD_ITALIC

   - ZendPdf\Font::FONT_TIMES

   - ZendPdf\Font::FONT_TIMES_BOLD

   - ZendPdf\Font::FONT_TIMES_ITALIC

   - ZendPdf\Font::FONT_TIMES_BOLD_ITALIC

   - ZendPdf\Font::FONT_HELVETICA

   - ZendPdf\Font::FONT_HELVETICA_BOLD

   - ZendPdf\Font::FONT_HELVETICA_ITALIC

   - ZendPdf\Font::FONT_HELVETICA_BOLD_ITALIC

   - ZendPdf\Font::FONT_SYMBOL

   - ZendPdf\Font::FONT_ZAPFDINGBATS



You can also use any individual TrueType font (which usually has a '.ttf' extension) or an OpenType font ('.otf'
extension) if it contains TrueType outlines. Currently unsupported, but planned for a future release are Mac OS X
.dfont files and Microsoft TrueType Collection ('.ttc' extension) files.

To use a TrueType font, you must provide the full file path to the font program. If the font cannot be read for
some reason, or if it is not a TrueType font, the factory method will throw an exception:

.. _zendpdf.drawing.using-fonts.example-2:

.. rubric:: Create a TrueType font

.. code-block:: php
   :linenos:

   ...
   // Create new font
   $goodDogCoolFont = ZendPdf\Font::fontWithPath('/path/to/GOODDC__.TTF');

   // Apply font
   $pdfPage->setFont($goodDogCoolFont, 36);
   ...

By default, custom fonts will be embedded in the resulting *PDF* document. This allows recipients to view the page
as intended, even if they don't have the proper fonts installed on their system. If you are concerned about file
size, you can request that the font program not be embedded by passing a 'do not embed' option to the factory
method:

.. _zendpdf.drawing.using-fonts.example-3:

.. rubric:: Create a TrueType font, but do not embed it in the PDF document

.. code-block:: php
   :linenos:

   ...
   // Create new font
   $goodDogCoolFont = ZendPdf\Font::fontWithPath('/path/to/GOODDC__.TTF',
                                                  ZendPdf\Font::EMBED_DONT_EMBED);

   // Apply font
   $pdfPage->setFont($goodDogCoolFont, 36);
   ...

If the font program is not embedded but the recipient of the *PDF* file has the font installed on their system,
they will see the document as intended. If they do not have the correct font installed, the *PDF* viewer
application will do its best to synthesize a replacement.

Some fonts have very specific licensing rules which prevent them from being embedded in *PDF* documents. So you are
not caught off-guard by this, if you try to use a font that cannot be embedded, the factory method will throw an
exception.

You can still use these fonts, but you must either pass the do not embed flag as described above, or you can simply
suppress the exception:

.. _zendpdf.drawing.using-fonts.example-4:

.. rubric:: Do not throw an exception for fonts that cannot be embedded

.. code-block:: php
   :linenos:

   ...
   $font = ZendPdf\Font::fontWithPath(
              '/path/to/unEmbeddableFont.ttf',
              ZendPdf\Font::EMBED_SUPPRESS_EMBED_EXCEPTION
           );
   ...

This suppression technique is preferred if you allow an end-user to choose their own fonts. Fonts which can be
embedded in the *PDF* document will be; those that cannot, won't.

Font programs can be rather large, some reaching into the tens of megabytes. By default, all embedded fonts are
compressed using the Flate compression scheme, resulting in a space savings of 50% on average. If, for some reason,
you do not want to compress the font program, you can disable it with an option:

.. _zendpdf.drawing.using-fonts.example-5:

.. rubric:: Do not compress an embedded font

.. code-block:: php
   :linenos:

   ...
   $font = ZendPdf\Font::fontWithPath('/path/to/someReallyBigFont.ttf',
                                       ZendPdf\Font::EMBED_DONT_COMPRESS);
   ...

Finally, when necessary, you can combine the embedding options by using the bitwise OR operator:

.. _zendpdf.drawing.using-fonts.example-6:

.. rubric:: Combining font embedding options

.. code-block:: php
   :linenos:

   ...
   $font = ZendPdf\Font::fontWithPath(
               $someUserSelectedFontPath,
               (ZendPdf\Font::EMBED_SUPPRESS_EMBED_EXCEPTION |
               ZendPdf\Font::EMBED_DONT_COMPRESS));
   ...

.. _zendpdf.drawing.standard-fonts-limitations:

Standard PDF fonts limitations
------------------------------

Standard *PDF* fonts use several single byte encodings internally (see `PDF Reference, Sixth Edition, version 1.7`_
Appendix D for details). They are generally equal to Latin1 character set (except Symbol and ZapfDingbats fonts).

``ZendPdf`` uses CP1252 (WinLatin1) for drawing text with standard fonts.

Text still can be provided in any other encoding, which must be specified if it differs from a current locale. Only
WinLatin1 characters will be actually drawn.

.. _zendpdf.drawing.using-fonts.example-7:

.. rubric:: Combining font embedding options

.. code-block:: php
   :linenos:

   ...
   $font = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_COURIER);
   $pdfPage->setFont($font, 36)
           ->drawText('Euro sign - €', 72, 720, 'UTF-8')
           ->drawText('Text with umlauts - à è ì', 72, 650, 'UTF-8');
   ...

.. _zendpdf.drawing.extracting-fonts:

Extracting fonts
----------------

``ZendPdf`` module provides a possibility to extract fonts from loaded documents.

It may be useful for incremental document updates. Without this functionality you have to attach and possibly embed
font into a document each time you want to update it.

``ZendPdf`` and ``ZendPdf\Page`` objects provide special methods to extract all fonts mentioned within a document
or a page:

.. _zendpdf.drawing.extracting-fonts.example-1:

.. rubric:: Extracting fonts from a loaded document

.. code-block:: php
   :linenos:

   ...
   $pdf = ZendPdf\PdfDocument::load($documentPath);
   ...
   // Get all document fonts
   $fontList = $pdf->extractFonts();
   $pdf->pages[] = ($page = $pdf->newPage(ZendPdf\Page::SIZE_A4));
   $yPosition = 700;
   foreach ($fontList as $font) {
       $page->setFont($font, 15);
       $fontName = $font->getFontName(ZendPdf\Font::NAME_POSTSCRIPT,
                                      'en',
                                      'UTF-8');
       $page->drawText($fontName . ': The quick brown fox jumps over the lazy dog',
                       100,
                       $yPosition,
                       'UTF-8');
       $yPosition -= 30;
   }
   ...
   // Get fonts referenced within the first document page
   $firstPage = reset($pdf->pages);
   $firstPageFonts = $firstPage->extractFonts();
   ...

.. _zendpdf.drawing.extracting-fonts.example-2:

.. rubric:: Extracting font from a loaded document by specifying font name

.. code-block:: php
   :linenos:

   ...
   $pdf = new ZendPdf\PdfDocument();
   ...
   $pdf->pages[] = ($page = $pdf->newPage(ZendPdf\Page::SIZE_A4));

   $font = ZendPdf\Font::fontWithPath($fontPath);
   $page->setFont($font, $fontSize);
   $page->drawText($text, $x, $y);
   ...
   // This font name should be stored somewhere...
   $fontName = $font->getFontName(ZendPdf\Font::NAME_POSTSCRIPT,
                                  'en',
                                  'UTF-8');
   ...
   $pdf->save($docPath);
   ...

.. code-block:: php
   :linenos:

   ...
   $pdf = ZendPdf\PdfDocument::load($docPath);
   ...
   $pdf->pages[] = ($page = $pdf->newPage(ZendPdf\Page::SIZE_A4));

   /* $srcPage->extractFont($fontName) can also be used here */
   $font = $pdf->extractFont($fontName);

   $page->setFont($font, $fontSize);
   $page->drawText($text, $x, $y);
   ...
   $pdf->save($docPath, true /* incremental update mode */);
   ...

Extracted fonts can be used in the place of any other font with the following limitations:



   - Extracted font can be used only in the context of the document from which it was extracted.

   - Possibly embedded font program is actually not extracted. So extracted font can't provide correct font metrics
     and original font has to be used for text width calculations:

     .. code-block:: php
        :linenos:

        ...
        $font = $pdf->extractFont($fontName);
        $originalFont = ZendPdf\Font::fontWithPath($fontPath);

        $page->setFont($font /* use extracted font for drawing */, $fontSize);
        $xPosition = $x;
        for ($charIndex = 0; $charIndex < strlen($text); $charIndex++) {
            $page->drawText($text[$charIndex], xPosition, $y);

            // Use original font for text width calculation
            $width = $originalFont->widthForGlyph(
                         $originalFont->glyphNumberForCharacter($text[$charIndex])
                     );
            $xPosition += $width/$originalFont->getUnitsPerEm()*$fontSize;
        }
        ...



.. _zendpdf.drawing.image-drawing:

Image Drawing
-------------

``ZendPdf\Page`` class provides drawImage() method to draw image:

.. code-block:: php
   :linenos:

   /**
    * Draw an image at the specified position on the page.
    *
    * @param ZendPdf\Resource\Image $image
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @return ZendPdf\Page
    */
   public function drawImage(ZendPdf\Resource\Image $image, $x1, $y1, $x2, $y2);

Image objects should be created with ``ZendPdf\Image::imageWithPath($filePath)`` method (JPG, PNG and TIFF images
are supported now):

.. _zendpdf.drawing.image-drawing.example-1:

.. rubric:: Image drawing

.. code-block:: php
   :linenos:

   ...
   // load image
   $image = ZendPdf\Image::imageWithPath('my_image.jpg');

   $pdfPage->drawImage($image, 100, 100, 400, 300);
   ...

**Important! JPEG support requires PHP GD extension to be configured.** **Important! PNG support requires ZLIB
extension to be configured to work with Alpha channel images.**

Refer to the *PHP* documentation for detailed information (http://www.php.net/manual/en/ref.image.php).
(http://www.php.net/manual/en/ref.zlib.php).

.. _zendpdf.drawing.line-drawing-style:

Line drawing style
------------------

Line drawing style is defined by line width, line color and line dashing pattern. All of this parameters can be
assigned by ``ZendPdf\Page`` class methods:

.. code-block:: php
   :linenos:

   /** Set line color. */
   public function setLineColor(ZendPdf\Color $color);

   /** Set line width. */
   public function setLineWidth(float $width);

   /**
    * Set line dashing pattern.
    *
    * Pattern is an array of floats:
    *     array(on_length, off_length, on_length, off_length, ...)
    * Phase is shift from the beginning of line.
    *
    * @param array $pattern
    * @param array $phase
    * @return ZendPdf\Page
    */
   public function setLineDashingPattern($pattern, $phase = 0);

.. _zendpdf.drawing.fill-style:

Fill style
----------

``ZendPdf\Page::drawRectangle()``, ``ZendPdf\Page::drawPolygon()``, ``ZendPdf\Page::drawCircle()`` and
``ZendPdf\Page::drawEllipse()`` methods take ``$fillType`` argument as an optional parameter. It can be:

- ZendPdf\Page::SHAPE_DRAW_STROKE - stroke shape

- ZendPdf\Page::SHAPE_DRAW_FILL - only fill shape

- ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE - fill and stroke (default behavior)

``ZendPdf\Page::drawPolygon()`` methods also takes an additional parameter ``$fillMethod``:

- ZendPdf\Page::FILL_METHOD_NON_ZERO_WINDING (default behavior)

  :t:`PDF reference`  describes this rule as follows:
  | The nonzero winding number rule determines whether a given point is inside a path by conceptually drawing a ray
  from that point to infinity in any direction and then examining the places where a segment of the path crosses
  the ray. Starting with a count of 0, the rule adds 1 each time a path segment crosses the ray from left to right
  and subtracts 1 each time a segment crosses from right to left. After counting all the crossings, if the result
  is 0 then the point is outside the path; otherwise it is inside. Note: The method just described does not specify
  what to do if a path segment coincides with or is tangent to the chosen ray. Since the direction of the ray is
  arbitrary, the rule simply chooses a ray that does not encounter such problem intersections. For simple convex
  paths, the nonzero winding number rule defines the inside and outside as one would intuitively expect. The more
  interesting cases are those involving complex or self-intersecting paths like the ones shown in Figure 4.10 (in a
  *PDF* Reference). For a path consisting of a five-pointed star, drawn with five connected straight line segments
  intersecting each other, the rule considers the inside to be the entire area enclosed by the star, including the
  pentagon in the center. For a path composed of two concentric circles, the areas enclosed by both circles are
  considered to be inside, provided that both are drawn in the same direction. If the circles are drawn in opposite
  directions, only the "doughnut" shape between them is inside, according to the rule; the "doughnut hole" is
  outside.



- ZendPdf\Page::FILL_METHOD_EVEN_ODD

  :t:`PDF reference`  describes this rule as follows:
  | An alternative to the nonzero winding number rule is the even-odd rule. This rule determines the "insideness"
  of
  a point by drawing a ray from that point in any direction and simply counting the number of path segments that
  cross the ray, regardless of direction. If this number is odd, the point is inside; if even, the point is
  outside. This yields the same results as the nonzero winding number rule for paths with simple shapes, but
  produces different results for more complex shapes. Figure 4.11 (in a *PDF* Reference) shows the effects of
  applying the even-odd rule to complex paths. For the five-pointed star, the rule considers the triangular points
  to be inside the path, but not the pentagon in the center. For the two concentric circles, only the "doughnut"
  shape between the two circles is considered inside, regardless of the directions in which the circles are drawn.



.. _zendpdf.drawing.linear-transformations:

Linear Transformations
----------------------

.. _zendpdf.drawing.linear-transformations.rotations:

Rotations
^^^^^^^^^

*PDF* page can be rotated before applying any draw operation. It can be done by ``ZendPdf\Page::rotate()`` method:

.. code-block:: php
   :linenos:

   /**
    * Rotate the page.
    *
    * @param float $x  - the X co-ordinate of rotation point
    * @param float $y  - the Y co-ordinate of rotation point
    * @param float $angle - rotation angle
    * @return ZendPdf\Page
    */
   public function rotate($x, $y, $angle);

.. _zendpdf.drawing.linear-transformations.scale:

Starting from ZF 1.8, scaling
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Scaling transformation is provided by ``ZendPdf\Page::scale()`` method:

.. code-block:: php
   :linenos:

   /**
    * Scale coordination system.
    *
    * @param float $xScale - X dimension scale factor
    * @param float $yScale - Y dimension scale factor
    * @return ZendPdf\Page
    */
   public function scale($xScale, $yScale);

.. _zendpdf.drawing.linear-transformations.translate:

Starting from ZF 1.8, translating
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Coordinate system shifting is performed by ``ZendPdf\Page::translate()`` method:

.. code-block:: php
   :linenos:

   /**
    * Translate coordination system.
    *
    * @param float $xShift - X coordinate shift
    * @param float $yShift - Y coordinate shift
    * @return ZendPdf\Page
    */
   public function translate($xShift, $yShift);

.. _zendpdf.drawing.linear-transformations.skew:

Starting from ZF 1.8, skewing
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Page skewing can be done using ``ZendPdf\Page::skew()`` method:

.. code-block:: php
   :linenos:

   /**
    * Translate coordination system.
    *
    * @param float $x  - the X co-ordinate of axis skew point
    * @param float $y  - the Y co-ordinate of axis skew point
    * @param float $xAngle - X axis skew angle
    * @param float $yAngle - Y axis skew angle
    * @return ZendPdf\Page
    */
   public function skew($x, $y, $xAngle, $yAngle);

.. _zendpdf.drawing.save-restore:

Save/restore graphics state
---------------------------

At any time page graphics state (current font, font size, line color, fill color, line style, page rotation, clip
area) can be saved and then restored. Save operation puts data to a graphics state stack, restore operation
retrieves it from there.

There are two methods in ``ZendPdf\Page`` class for these operations:

.. code-block:: php
   :linenos:

   /**
    * Save the graphics state of this page.
    * This takes a snapshot of the currently applied style, position,
    * clipping area and any rotation/translation/scaling that has been
    * applied.
    *
    * @return ZendPdf\Page
    */
   public function saveGS();

   /**
    * Restore the graphics state that was saved with the last call to
    * saveGS().
    *
    * @return ZendPdf\Page
    */
   public function restoreGS();

.. _zendpdf.drawing.clipping:

Clipping draw area
------------------

*PDF* and ``ZendPdf`` module support clipping of draw area. Current clip area limits the regions of the page
affected by painting operators. It's a whole page initially.

``ZendPdf\Page`` class provides a set of methods for clipping operations.

.. code-block:: php
   :linenos:

   /**
    * Intersect current clipping area with a rectangle.
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @return ZendPdf\Page
    */
   public function clipRectangle($x1, $y1, $x2, $y2);

.. code-block:: php
   :linenos:

   /**
    * Intersect current clipping area with a polygon.
    *
    * @param array $x  - array of float (the X co-ordinates of the vertices)
    * @param array $y  - array of float (the Y co-ordinates of the vertices)
    * @param integer $fillMethod
    * @return ZendPdf\Page
    */
   public function clipPolygon($x,
                               $y,
                               $fillMethod =
                                   ZendPdf\Page::FILL_METHOD_NON_ZERO_WINDING);

.. code-block:: php
   :linenos:

   /**
    * Intersect current clipping area with a circle.
    *
    * @param float $x
    * @param float $y
    * @param float $radius
    * @param float $startAngle
    * @param float $endAngle
    * @return ZendPdf\Page
    */
   public function clipCircle($x,
                              $y,
                              $radius,
                              $startAngle = null,
                              $endAngle = null);

.. code-block:: php
   :linenos:

   /**
    * Intersect current clipping area with an ellipse.
    *
    * Method signatures:
    * drawEllipse($x1, $y1, $x2, $y2);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle);
    *
    * @todo process special cases with $x2-$x1 == 0 or $y2-$y1 == 0
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param float $startAngle
    * @param float $endAngle
    * @return ZendPdf\Page
    */
   public function clipEllipse($x1,
                               $y1,
                               $x2,
                               $y2,
                               $startAngle = null,
                               $endAngle = null);

.. _zendpdf.drawing.styles:

Styles
------

``ZendPdf\Style`` class provides styles functionality.

Styles can be used to store a set of graphic state parameters and apply it to a *PDF* page by one operation:

.. code-block:: php
   :linenos:

   /**
    * Set the style to use for future drawing operations on this page
    *
    * @param ZendPdf\Style $style
    * @return ZendPdf\Page
    */
   public function setStyle(ZendPdf\Style $style);

   /**
    * Return the style, applied to the page.
    *
    * @return ZendPdf\Style|null
    */
   public function getStyle();

``ZendPdf\Style`` class provides a set of methods to set or get different graphics state parameters:

.. code-block:: php
   :linenos:

   /**
    * Set line color.
    *
    * @param ZendPdf\Color $color
    * @return ZendPdf\Page
    */
   public function setLineColor(ZendPdf\Color $color);

.. code-block:: php
   :linenos:

   /**
    * Get line color.
    *
    * @return ZendPdf\Color|null
    */
   public function getLineColor();

.. code-block:: php
   :linenos:

   /**
    * Set line width.
    *
    * @param float $width
    * @return ZendPdf\Page
    */
   public function setLineWidth($width);

.. code-block:: php
   :linenos:

   /**
    * Get line width.
    *
    * @return float
    */
   public function getLineWidth();

.. code-block:: php
   :linenos:

   /**
    * Set line dashing pattern
    *
    * @param array $pattern
    * @param float $phase
    * @return ZendPdf\Page
    */
   public function setLineDashingPattern($pattern, $phase = 0);

.. code-block:: php
   :linenos:

   /**
    * Get line dashing pattern
    *
    * @return array
    */
   public function getLineDashingPattern();

.. code-block:: php
   :linenos:

   /**
    * Get line dashing phase
    *
    * @return float
    */
   public function getLineDashingPhase();

.. code-block:: php
   :linenos:

   /**
    * Set fill color.
    *
    * @param ZendPdf\Color $color
    * @return ZendPdf\Page
    */
   public function setFillColor(ZendPdf\Color $color);

.. code-block:: php
   :linenos:

   /**
    * Get fill color.
    *
    * @return ZendPdf\Color|null
    */
   public function getFillColor();

.. code-block:: php
   :linenos:

   /**
    * Set current font.
    *
    * @param ZendPdf\Resource\Font $font
    * @param float $fontSize
    * @return ZendPdf\Page
    */
   public function setFont(ZendPdf\Resource\Font $font, $fontSize);

.. code-block:: php
   :linenos:

   /**
    * Modify current font size
    *
    * @param float $fontSize
    * @return ZendPdf\Page
    */
   public function setFontSize($fontSize);

.. code-block:: php
   :linenos:

   /**
    * Get current font.
    *
    * @return ZendPdf\Resource\Font $font
    */
   public function getFont();

.. code-block:: php
   :linenos:

   /**
    * Get current font size
    *
    * @return float $fontSize
    */
   public function getFontSize();

.. _zendpdf.drawing.alpha:

Transparency
------------

``ZendPdf`` module supports transparency handling.

Transparency may be set using ``ZendPdf\Page::setAlpha()`` method:

.. code-block:: php
   :linenos:

   /**
    * Set the transparency
    *
    * $alpha == 0  - transparent
    * $alpha == 1  - opaque
    *
    * Transparency modes, supported by PDF:
    * Normal (default), Multiply, Screen, Overlay, Darken, Lighten,
    * ColorDodge, ColorBurn, HardLight, SoftLight, Difference, Exclusion
    *
    * @param float $alpha
    * @param string $mode
    * @throws ZendPdf\Exception
    * @return ZendPdf\Page
    */
   public function setAlpha($alpha, $mode = 'Normal');



.. _`iconv()`: http://www.php.net/manual/function.iconv.php
.. _`PDF Reference, Sixth Edition, version 1.7`: http://www.adobe.com/devnet/acrobat/pdfs/pdf_reference_1-7.pdf
