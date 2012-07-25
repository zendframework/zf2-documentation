.. _zend.pdf.drawing:

Tekenen
=======

.. _zend.pdf.drawing.geometry:

Geometrie
---------

PDF gebruikt dezelfde geometrie als PostScript. Het begint van de beneden-linkse hoek van de pagina en is standaard
afgemeten in points (1/72 van een duim).

De grootte van een pagina kan worden verkregen van het pagina object:

.. code-block:: php
   :linenos:

   $width  = $pdfPage->getWidth();
   $height = $pdfPage->getHeight();

.. _zend.pdf.drawing.color:

Kleur
-----

PDF heeft geweldig goede kleurweergavemogelijkheden. Zend_Pdf ondersteunt grijsschalen, RGB en CMYK kleuren. Elk
van deze notaties kan worden gebruikt daar waar een *Zend_Pdf_Color* object nodig is. De
*Zend_Pdf_Color_GrayScale*, *Zend_Pdf_Color_RGB* en *Zend_Pdf_Color_CMYK* klassen verstrekken deze functionaliteit:

.. code-block:: php
   :linenos:

   // $grayLevel (float number). 0.0 (zwart) - 1.0 (wit)
   $color1 = new Zend_Pdf_Color_GrayScale($grayLevel);

   // $r, $g, $b (float numbers). 0.0 (minimum intensiteit) - 1.0 (maximum intensiteit)
   $color2 = new Zend_Pdf_Color_RGB($r, $g, $b);

   // $c, $m, $y, $k (float numbers). 0.0 (minimum intensiteit) - 1.0 (maximum intensiteit)
   $color3 = new Zend_Pdf_Color_CMYK($c, $m, $y, $k);

.. _zend.pdf.drawing.shape-drawing:

Vormen tekenen
--------------

Alle tekenoperaties kunnen worden uitgevoerd in de context van een PDF pagina.

De *Zend_Pdf_Page* klasse verstrekt een set van teken methodes:

.. code-block:: php
   :linenos:

   /**
    * Een lijn trekken van x1,y1 naar x2,y2.
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    */
   public function drawLine($x1, $y1, $x2, $y2);

.. code-block:: php
   :linenos:

   /**
    * Teken een rechthoek.
    *
    * Vultypes:
    * Zend_Pdf_Const::SHAPEDRAW_FILLNSTROKE - vul rechthoek en streep door (standaard)
    * Zend_Pdf_Const::SHAPEDRAW_STROKE      - streep rechthoek door
    * Zend_Pdf_Const::SHAPEDRAW_FILL        - vul rechthoek op
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param integer $fillType
    */
   public function drawRectangle($x1, $y1, $x2, $y2, $fillType = Zend_Pdf_Const::SHAPEDRAW_FILLNSTROKE);

.. code-block:: php
   :linenos:

   /**
    * Een polygoon tekenen.
    *
    * Als $fillType een Zend_Pdf_Const::SHAPEDRAW_FILLNSTROKE of Zend_Pdf_Const::SHAPEDRAW_FILL is,
    * zal de polygoon automatisch gesloten zijn.
    * Zie een gedetailleerde beschrijving van deze methodes in een PDF documentatie
    * (sectie 4.4.2 Path painting Operators, Opvulling)
    *
    * @param array $x  - array of float (de X coordinaten van de toppen)
    * @param array $y  - array of float (de Y coordinaten van de toppen)
    * @param integer $fillType
    * @param integer $fillMethod
    */
   public function drawPolygon($x, $y,
                               $fillType = Zend_Pdf_Const::SHAPEDRAW_FILLNSTROKE,
                               $fillMethod = Zend_Pdf_Const::FILLMETHOD_NONZEROWINDING);

.. code-block:: php
   :linenos:

   /**
    * Teken een cirkel gecentreerd op x, y met een radius van radius.
    *
    * Hoeken zijn aangeduid in radianten
    *
    * Method signatures:
    * drawCircle($x, $y, $radius);
    * drawCircle($x, $y, $radius, $fillType);
    * drawCircle($x, $y, $radius, $startAngle, $endAngle);
    * drawCircle($x, $y, $radius, $startAngle, $endAngle, $fillType);
    *
    *
    * Het is niet echt een cirkel want PDF ondersteunt alleen Bezier krommen.
    * Maar het komt er héél dichtbij.
    * Het verschilt maximaal 0.00026 radianten van een cirkel
    * (op PI/8, 3*PI/8, 5*PI/8, 7*PI/8, 9*PI/8, 11*PI/8, 13*PI/8 and 15*PI/8 hoeken).
    * Op 0, PI/4, PI/2, 3*PI/4, PI, 5*PI/4, 3*PI/2 en 7*PI/4 zijn het exacte tangenten van cirkels.
    *
    * @param float $x
    * @param float $y
    * @param float $radius
    * @param mixed $param4
    * @param mixed $param5
    * @param mixed $param6
    */
   public function  drawCircle($x, $y, $radius, $param4 = null, $param5 = null, $param6 = null);

.. code-block:: php
   :linenos:

   /**
    * Teken een ellips in een bepaalde rechthoek.
    *
    * Method signatures:
    * drawEllipse($x1, $y1, $x2, $y2);
    * drawEllipse($x1, $y1, $x2, $y2, $fillType);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle, $fillType);
    *
    * Hoeken zijn aangeduid in radianten
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param mixed $param5
    * @param mixed $param6
    * @param mixed $param7
    */
   public function drawEllipse($x1, $y1, $x2, $y2, $param5 = null, $param6 = null, $param7 = null);

.. _zend.pdf.drawing.text-drawing:

Tekst schrijven
---------------

Ook tekst wordt geschreven in de paginacontext:

.. code-block:: php
   :linenos:

   /**
    * Teken een regel tekst op de bepaalde plaats.
    *
    * @param string $text
    * @param float $x
    * @param float $y
    * @throws Zend_Pdf_Exception
    */
   public function drawText($text, $x, $y );

Het huidige lettertype en de lettertypegrootte worden gebruikt om tekst te schrijven. Zie de gedetailleerde
beschrijving hieronder.

.. _zend.pdf.drawing.using-fonts:

Lettertypes gebruiken
---------------------

De *Zend_Pdf_Page::drawText()* methode gebruikt het actieve lettertype die kan gezet worden door de
*Zend_Pdf_Page::drawText()* methode:

.. code-block:: php
   :linenos:

   /**
    * Actief lettertype zetten.
    *
    * @param Zend_Pdf_Font $font
    * @param float $fontSize
    */
   public function setFont(Zend_Pdf_Font $font, $fontSize);

PDF ondersteunt Type1, TrueType, Type3 and composite lettertypes. Er zijn ook 14 standaard Type1 lettertypes
voorzien in PDF. De Zend_Pdf module verstrekt op dit moment alleen de 14 standaard lettertypes. Die kunnen
verkregen worden door de *Zend_Pdf_Font_Standard* klasse te gebruiken. Een bepaalde lettertype moet worden gebruikt
als argument:

.. rubric:: Een standaard lettertype maken

.. code-block:: php
   :linenos:

   <?php
   ...
   // Een nieuw lettertype maken
   $font = new Zend_Pdf_Font_Standard(Zend_Pdf_Const::FONT_HELVETICA);

   // lettertype actief maken
   $pdfPage->setFont($font, 36);
   ...
   ?>

De *Zend_Pdf_Const* verstrekt constanten voor de 14 standaard lettertypes:

   - Zend_Pdf_Const::FONT_TIMES_ROMAN

   - Zend_Pdf_Const::FONT_TIMES_BOLD

   - Zend_Pdf_Const::FONT_TIMES_ITALIC

   - Zend_Pdf_Const::FONT_TIMES_BOLDITALIC

   - Zend_Pdf_Const::FONT_HELVETICA

   - Zend_Pdf_Const::FONT_HELVETICA_BOLD

   - Zend_Pdf_Const::FONT_HELVETICA_ITALIC

   - Zend_Pdf_Const::FONT_HELVETICA_BOLDITALIC

   - Zend_Pdf_Const::FONT_COURIER

   - Zend_Pdf_Const::FONT_COURIER_BOLD

   - Zend_Pdf_Const::FONT_COURIER_ITALIC

   - Zend_Pdf_Const::FONT_COURIER_BOLDITALIC

   - Zend_Pdf_Const::FONT_SYMBOL

   - Zend_Pdf_Const::FONT_ZAPFDINGBATS



.. _zend.pdf.drawing.image-drawing:

Beelden tekenen
---------------

De *Zend_Pdf_Page* klasse voorziet de *drawImage()* methode om beelden te tekenen:

.. code-block:: php
   :linenos:

   /**
    * Teken een beeld op de bepaalde positie.
    *
    * @param Zend_Pdf_Image $image
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    */
   public function drawImage(Zend_Pdf_Image $image, $x1, $y1, $x2, $y2);

Beeldobjecten worden door afstammelingen van de *Zend_Pdf_Image* klasse voorgesteld.

Alleen JPG beelden zijn momenteel ondersteund:

.. rubric:: Beelden tekenen

.. code-block:: php
   :linenos:

   <?php
   ...
   $image = new Zend_Pdf_Image_JPEG('my_image.jpg');
   $pdfPage->drawImage($image, 100, 100, 400, 300);;
   ...
   ?>

**Belangrijk! De Zend_Pdf_Image_JPEG klasse heeft de PHP GD extensie nodig.**

Zie de PHP documentatie voor meer informatie (`http://www.php.net/manual/nl/ref.image.php`_).

.. _zend.pdf.drawing.line-drawing-style:

Lijnstijl tekenen
-----------------

De lijnstijl wordt gedefinieerd door lijndikte, lijnkleur en lijnstippenpatroon. Al deze parameters kunnen door de
*Zend_Pdf_Page* klasse methodes worden aangegeven:

.. code-block:: php
   :linenos:

   /** Zet lijnkleur. */
   public function setLineColor(Zend_Pdf_Color $color);

   /** Zet lijndikte. */
   public function setLineWidth(float $width);

   /**
    * Zet lijnstippenpatroon.
    *
    * Het patroon ($pattern) is een Array van floats: array(on_length, off_length, on_length, off_length, ...)
    * Fase ($phase) is shift vanaf het begin van de lijn.
    *
    * @param array $pattern
    * @param array $phase
    */
   public function setLineDashingPattern($pattern, $phase = 0);

.. _zend.pdf.drawing.fill-style:

Vulstijl
--------

De *Zend_Pdf_Page::drawRectangle()*, *Zend_Pdf_Page::drawPoligon()*, *Zend_Pdf_Page::drawCircle()* en
*Zend_Pdf_Page::drawEllipse()* methodes aanvaarden het optionele argument *$fillType*. Dit kan het volgende zijn:

- Zend_Pdf_Const::SHAPEDRAW_STROKE - streep

- Zend_Pdf_Const::SHAPEDRAW_FILL - alleen opvullen

- Zend_Pdf_Const::SHAPEDRAW_FILLNSTROKE - opvullen en doorstrepen (standaard)

De *Zend_Pdf_Page::drawPoligon()* methode accepteert ook een optionele parameter *$fillMethod*:

- Zend_Pdf_Const::FILLMETHOD_NONZEROWINDING (standaard)

  :t:`De PDF referentie`  beschrijft deze regel als volgt (originele tekst):
  | The nonzero winding number rule determines whether a given point is inside a path by conceptually drawing a ray
  from that point to infinity in any direction and then examining the places where a segment of the path crosses
  the ray. Starting with a count of 0, the rule adds 1 each time a path segment crosses the ray from left to right
  and subtracts 1 each time a segment crosses from right to left. After counting all the crossings, if the result
  is 0 then the point is outside the path; otherwise it is inside.

  Note: The method just described does not specify what to do if a path segment coincides with or is tangent to the
  chosen ray. Since the direction of the ray is arbitrary, the rule simply chooses a ray that does not encounter
  such problem intersections. For simple convex paths, the nonzero winding number rule defines the inside and
  outside as one would intuitively expect. The more interesting cases are those involving complex or
  self-intersecting paths like the ones shown in Figure 4.10 (in a PDF Reference).

  For a path consisting of a five-pointed star, drawn with five connected straight line segments intersecting each
  other, the rule considers the inside to be the entire area enclosed by the star, including the pentagon in the
  center. For a path composed of two concentric circles, the areas enclosed by both circles are considered to be
  inside, provided that both are drawn in the same direction. If the circles are drawn in opposite directions, only
  the "doughnut" shape between them is inside, according to the rule; the "doughnut hole" is outside.



- Zend_Pdf_Const::FILLMETHOD_EVENODD

  :t:`De PDF referentie`  beschrijft deze regel als volgt (originele tekst):
  | An alternative to the nonzero winding number rule is the even-odd rule. This rule determines the "insideness"
  of
  a point by drawing a ray from that point in any direction and simply counting the number of path segments that
  cross the ray, regardless of direction. If this number is odd, the point is inside; if even, the point is
  outside. This yields the same results as the nonzero winding number rule for paths with simple shapes, but
  produces different results for more complex shapes. Figure 4.11 (in a PDF Reference) shows the effects of
  applying the even-odd rule to complex paths. For the five-pointed star, the rule considers the triangular points
  to be inside the path, but not the pentagon in the center. For the two concentric circles, only the "doughnut"
  shape between the two circles is considered inside, regardless of the directions in which the circles are drawn.



.. _zend.pdf.drawing.rotations:

Rotaties
--------

Een PDF pagina kan geroteerd worden zo lang er nog niets op werd geschreven of getekend. Het wordt gedaan door de
*Zend_Pdf_Page::rotate()* methode:

.. code-block:: php
   :linenos:

   /**
    * De pagina rond het punt ($x, $y) roteren met de aangeduide hoek (in radianten).
    *
    * @param float $angle
    */
   public function rotate($x, $y, $angle);

.. _zend.pdf.drawing.save-restore:

Opslaan/herstellen van een grafische staat
------------------------------------------

Op eender welk moment kan een grafische staat van een pagina (huidig lettertype, lettertype grootte, lijnkleur,
vulkleur, lijnstijl, paginarotatie, clip area) worden opgeslagen en worden hersteld. De opsla-operatie slaat de
data in een grafische staatstapel op, de hersteloperatie haalt ze er weer uit.

Dit zijn de *Zend_Pdf_Page* klassemethodes om deze operaties uit te voeren:

.. code-block:: php
   :linenos:

   /**
    * De grafische staat van deze pagina opslaan.
    * Dit neemt een "foto" van de huidige stijl, positie en clipping area en
    * enige aangebrachte rotatie/vertaling/schaling.
    */
   public function saveGS();

   /**
    * De laatst opgeslagen grafische staat herstellen.
    */
   public function restoreGS();

.. _zend.pdf.drawing.clipping:

Clipping draw area
------------------

PDF en de Zend_Pdf module ondersteunen clippen van een teken area. De actieve clip area begrenst de regios van de
pagina die door tekenoperaties worden beïnvloed. Initieel is het de volledige pagina.

De *Zend_Pdf_Page* klasse verstrekt een set methodes voor clipoperaties.

.. code-block:: php
   :linenos:

   /**
    * Rechthoekig clippen.
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    */
   public function clipRectangle($x1, $y1, $x2, $y2);

.. code-block:: php
   :linenos:

   /**
    * Polygoon clippen.
    *
    * @param array $x  - array of float (the X co-ordinates of the vertices)
    * @param array $y  - array of float (the Y co-ordinates of the vertices)
    * @param integer $fillMethod
    */
   public function clipPolygon($x, $y, $fillMethod = Zend_Pdf_Const::FILLMETHOD_NONZEROWINDING);

.. code-block:: php
   :linenos:

   /**
    * Cirkel clippen.
    *
    * @param float $x
    * @param float $y
    * @param float $radius
    * @param float $startAngle
    * @param float $endAngle
    */
   public function clipCircle($x, $y, $radius, $startAngle = null, $endAngle = null);

.. code-block:: php
   :linenos:

   /**
    * Ellips clippen.
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
    */
   public function clipEllipse($x1, $y1, $x2, $y2, $startAngle = null, $endAngle = null);

.. _zend.pdf.drawing.styles:

Stijlen
-------

De *Zend_Pdf_Style* klasse voorziet in stijlen

Stijlen kunnen gebruikt worden om een set grafische parameters op te slaan en ze toe te brengen op een PDF pagina
in één operatie:

.. code-block:: php
   :linenos:

   /**
    * Zet de stijl voor de komende tekenoperaties voor deze pagina
    *
    * @param Zend_Pdf_Style $style
    */
   public function setStyle(Zend_Pdf_Style $style);

   /**
    * Geef de stijl terug en breng ze op de pagina aan.
    *
    * @return Zend_Pdf_Style|null
    */
   public function getStyle();

De *Zend_Pdf_Style* klasse voorziet in een set methodes om verschillende grafische staat parameters te zetten of te
verkrijgen:

.. code-block:: php
   :linenos:

   /**
    * Zet de lijnkleur.
    *
    * @param Zend_Pdf_Color $color
    */
   public function setLineColor(Zend_Pdf_Color $color);

.. code-block:: php
   :linenos:

   /**
    * verkrijg de lijnkleur.
    *
    * @return Zend_Pdf_Color|null
    */
   public function getLineColor();

.. code-block:: php
   :linenos:

   /**
    * Zet de lijndikte.
    *
    * @param float $width
    */
   public function setLineWidth($width);

.. code-block:: php
   :linenos:

   /**
    * Verkrijg de lijndikte.
    *
    * @return float
    */
   public function getLineWidth($width);

.. code-block:: php
   :linenos:

   /**
    * Zet het lijnstippenpatroon
    *
    * @param array $pattern
    * @param float $phase
    */
   public function setLineDashingPattern($pattern, $phase = 0);

.. code-block:: php
   :linenos:

   /**
    * Verkrijg het lijnstippenpatroon
    *
    * @return array
    */
   public function getLineDashingPattern();

.. code-block:: php
   :linenos:

   /**
    * Verkrijg de lijnstippenfase
    *
    * @return float
    */
   public function getLineDashingPhase();

.. code-block:: php
   :linenos:

   /**
    * Zet de vulkleur
    *
    * @param Zend_Pdf_Color $color
    */
   public function setFillColor(Zend_Pdf_Color $color);

.. code-block:: php
   :linenos:

   /**
    * Verkrijg de vulkleur
    *
    * @return Zend_Pdf_Color|null
    */
   public function getFillColor();

.. code-block:: php
   :linenos:

   /**
    * Zet actief lettertype
    *
    * @param Zend_Pdf_Font $font
    * @param float $fontSize
    */
   public function setFont(Zend_Pdf_Font $font, $fontSize);

.. code-block:: php
   :linenos:

   /**
    * Wijzig huidige lettertype grootte
    *
    * @param float $fontSize
    */
   public function setFontSize($fontSize);

.. code-block:: php
   :linenos:

   /**
    * Verkrijg huidig lettertype
    *
    * @return Zend_Pdf_Font $font
    */
   public function getFont();

.. code-block:: php
   :linenos:

   /**
    * Verkrijg huidige lettertype grootte
    *
    * @return float $fontSize
    */
   public function getFontSize();



.. _`http://www.php.net/manual/nl/ref.image.php`: http://www.php.net/manual/nl/ref.image.php
