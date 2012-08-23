.. EN-Revision: none
.. _zend.pdf.drawing:

Zeichnen
========

.. _zend.pdf.drawing.geometry:

Geometrie
---------

*PDF* verwendet die selbe Geometrie wie PostScript. Sie beginnt an der linken unteren Ecke der Seite und wird in
Punkten (1/72 Zoll) gemessen.

Die Seitengröße kann vom Seitenobjekt erhalten werden:

.. code-block:: php
   :linenos:

   $width  = $pdfPage->getWidth();
   $height = $pdfPage->getHeight();

.. _zend.pdf.drawing.color:

Farben
------

*PDF* bietet leistungsfähige Möglichkeiten für die Farbdarstellung. Die ``Zend_Pdf`` Komponente unterstützt die
Grauskala sowie RGB und CYMK Farbräume. Jede kann überall verwendet werden, wo ein ``Zend_Pdf_Color`` Objekt
benötigt wird. Die ``Zend_Pdf_Color_GrayScale``, ``Zend_Pdf_Color_Rgb`` und ``Zend_Pdf_Color_Cmyk`` Klassen
stellen folgende Funktionalitäten bereit:

.. code-block:: php
   :linenos:

   // $grayLevel (Fließkommazahl)
   // 0.0 (schwarz) - 1.0 (weiß)
   $color1 = new Zend_Pdf_Color_GrayScale($grayLevel);

   // $r, $g, $b (Fließkommazahlen)
   // 0.0 (min Helligkeit) - 1.0 (max Helligkeit)
   $color2 = new Zend_Pdf_Color_Rgb($r, $g, $b);

   // $c, $m, $y, $k (Fließkommazahlen)
   // 0.0 (min Helligkeit) - 1.0 (max Helligkeit)
   $color3 = new Zend_Pdf_Color_Cmyk($c, $m, $y, $k);

Die *HTML* Farben werden auch durch die Klasse ``Zend_Pdf_Color_Html`` bereitgestellt:

.. code-block:: php
   :linenos:

   $color1 = new Zend_Pdf_Color_Html('#3366FF');
   $color2 = new Zend_Pdf_Color_Html('silver');
   $color3 = new Zend_Pdf_Color_Html('forestgreen');

.. _zend.pdf.drawing.shape-drawing:

Zeichnen von Formen
-------------------

Alle Zeichenoperationen können im Kontext einer *PDF* Seite durchgeführt werden.

Die ``Zend_Pdf_Page`` Klass stellt einen Satz von einfachen Formen bereit:

.. code-block:: php
   :linenos:

   /**
    * Zeichne eine Linie von x1,y1 nach x2,y2.
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @return Zend_Pdf_Page
    */
   public function drawLine($x1, $y1, $x2, $y2);

.. code-block:: php
   :linenos:

   /**
    * Zeichne ein Rechteck.
    *
    * Füllarten:
    * Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE - fülle und strichliere
    *                                             das Rechteck (Standard)
    * Zend_Pdf_Page::SHAPE_DRAW_STROKE          - strichele das Rechteck
    * Zend_Pdf_Page::SHAPE_DRAW_FILL            - fülle das Rechteck
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param integer $fillType
    * @return Zend_Pdf_Page
    */
   public function drawRectangle($x1, $y1, $x2, $y2,
                       $fillType = Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE);

.. code-block:: php
   :linenos:

   /**
    * Zeichne ein gerundetes Rechteck.
    *
    * Füllarten:
    * Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE - fülle und strichliere
    *                                             das Rechteck (Standard)
    * Zend_Pdf_Page::SHAPE_DRAW_STROKE          - strichele das Rechteck
    * Zend_Pdf_Page::SHAPE_DRAW_FILL            - fülle das Rechteck
    *
    * radius ist ein Integer der den Radius der vier Ecken repräsentiert, oder ein
    * Arraay von vier Integern welche den Radius beginnend mit Links oben
    * repräsentieren, und im Uhrzeigersinn weitergehen
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param integer|array $radius
    * @param integer $fillType
    * @return Zend_Pdf_Page
    */
   public function drawRoundedRectangle($x1, $y1, $x2, $y2, $radius,
                          $fillType = Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE);

.. code-block:: php
   :linenos:

   /**
    * Zeichne ein Polygon
    *
    * Wenn $fillType Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE oder
    * Zend_Pdf_Page::SHAPE_DRAW_FILL ist, wird das Polygon automatisch geschlossen.
    * Für eine detaillierte Beschreibung dieser Methode schaue in eine PDF
    * Dokumentation (Kapitel 4.4.2 Path painting Operators, Filling)
    *
    * @param array $x  - Array mit Floats (die X Koordinaten der Eckpunkte)
    * @param array $y  - Array mit Floats (the Y Koordinaten der Eckpunkte)
    * @param integer $fillType
    * @param integer $fillMethod
    * @return Zend_Pdf_Page
    */
   public function drawPolygon($x, $y,
                               $fillType =
                                   Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE,
                               $fillMethod =
                                   Zend_Pdf_Page::FILL_METHOD_NON_ZERO_WINDING);

.. code-block:: php
   :linenos:

   /**
    * Zeichne einen Kreis mit dem Mittelpunkt x, y dem Radius radius.
    *
    * Winkel werden im Bogenmaß angegeben
    *
    * Methoden Signaturen:
    * drawCircle($x, $y, $radius);
    * drawCircle($x, $y, $radius, $fillType);
    * drawCircle($x, $y, $radius, $startAngle, $endAngle);
    * drawCircle($x, $y, $radius, $startAngle, $endAngle, $fillType);
    *
    *
    * Es ist kein echter Kreis, weil PDF nur kubische Bezierkurven
    * unterstützt. Aber es ist eine sehr Annäherung.
    * Es unterscheidet sich von echten Kreisen maximal um 0.00026 Radien
    * (Bei PI/8, 3*PI/8, 5*PI/8, 7*PI/8, 9*PI/8, 11*PI/8, 13*PI/8 und
    * 15*PI/8 Winkeln). Bei 0, PI/4, PI/2, 3*PI/4, PI, 5*PI/4, 3*PI/2 und
    * 7*PI/4 ist es exakt eine Tangente zu einem Kreis.
    *
    * @param float $x
    * @param float $y
    * @param float $radius
    * @param mixed $param4
    * @param mixed $param5
    * @param mixed $param6
    * @return Zend_Pdf_Page
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
    * Zeichne eine Ellipse innerhalb des angegebenen Rechtecks.
    *
    * Methoden Signaturen:
    * drawEllipse($x1, $y1, $x2, $y2);
    * drawEllipse($x1, $y1, $x2, $y2, $fillType);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle, $fillType);
    *
    * Winkel werden im Bogenmaß angegeben
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param mixed $param5
    * @param mixed $param6
    * @param mixed $param7
    * @return Zend_Pdf_Page
    */
   public function drawEllipse($x1,
                               $y1,
                               $x2,
                               $y2,
                               $param5 = null,
                               $param6 = null,
                               $param7 = null);

.. _zend.pdf.drawing.text-drawing:

Zeichnen von Text
-----------------

Auch alle Textoperationen können im Kontext einer *PDF* Seite durchgeführt werden. Du kannst eine einzige
Textzeile an jeder Position auf der Seite durch Übergabe der X und Y Koordinaten für die Grundlinie zeichnen. Der
aktuelle Zeichensatz und die aktuelle Zeichengröße werden für die Textoperationen verwendet (beachte die
detaillierte Beschreibung unten).

.. code-block:: php
   :linenos:

   /**
    * Zeichne eine Textzeile an einer bestimmten Position.
    *
    * @param string $text
    * @param float $x
    * @param float $y
    * @param string $charEncoding (optional) Zeichencodierung des
    *               Quelltexts. Standard ist die aktuelle "locale".
    * @throws Zend_Pdf_Exception
    * @return Zend_Pdf_Page
    */
   public function drawText($text, $x, $y, $charEncoding = '');

.. _zend.pdf.drawing.text-drawing.example-1:

.. rubric:: Zeichne einen String auf der Seite

.. code-block:: php
   :linenos:

   ...
   $pdfPage->drawText('Hello world!', 72, 720);
   ...

Standardmäßig werden Textstrings unter Verwendung der Zeichenkodierungsmethode der aktuelle "locale"
interpretiert. Wenn du einen String hast, der eine andere Zeichenkodierungsmethode verwendet (wie zum Beispiel ein
UTF-8 String, der aus einer Datei auf der Platte gelesen wurde, oder ein MacRoman String, der aus einer älteren
Datenbank erhalten wurde), kannst du die Zeichenkodierung zum Zeitpunkt des Zeichnens angeben und ``Zend_Pdf`` wird
die Konvertierung für dich durchführen. Du kannst Quellstrings in jeder Kodierungsmethode übergeben, die von
*PHP*'s `iconv()`_ Funktion unterstützt wird.

.. _zend.pdf.drawing.text-drawing.example-2:

.. rubric:: Zeiche einen UTF-8 kodierten String auf der Seite

.. code-block:: php
   :linenos:

   ...
   // Lese einen UTF-8 kodierten String von der Platte
   $unicodeString = fread($fp, 1024);

   // Zeichne den String auf der Seite
   $pdfPage->drawText($unicodeString, 72, 720, 'UTF-8');
   ...

.. _zend.pdf.drawing.using-fonts:

Verwendung von Zeichensätzen
----------------------------

``Zend_Pdf_Page::drawText()`` verwendet den aktuellen Zeichensatz und die aktuelle Zeichengröße der Seite, die
mit der Methode ``Zend_Pdf_Page::setFont()`` festgelegt werden:

.. code-block:: php
   :linenos:

   /**
    * Lege den aktuellen Zeichensatz fest.
    *
    * @param Zend_Pdf_Resource_Font $font
    * @param float $fontSize
    * @return Zend_Pdf_Page
    */
   public function setFont(Zend_Pdf_Resource_Font $font, $fontSize);

*PDF* Dokumente unterstützt PostScript Type1 und TrueType Zeichensätze, sowie die zwei speziellen *PDF* Typen
Type3 und zusammengesetzte Zeichensätze (composite fonts). Es gibt zudem 14 Type1 Standardzeichensätze, die von
jedem *PDF* Viewer bereit gestellt werden: Courier (4 Stile), Helvetica (4 Stile), Times (4 Stile), Symbol und Zapf
Dingbats.

Die ``Zend_Pdf`` Komponente unterstützt derzeit diese 14 *PDF* Standardzeichensätze sowie deine eigenen TrueType
Zeichensätze. Zeichensatzobjekte können über eine der zwei Fabrikmethoden (factory methods) erhalten werden:
``Zend_Pdf_Font::fontWithName($fontName)`` für die 14 *PDF* Standardzeichensätze oder
``Zend_Pdf_Font::fontWithPath($filePath)`` für eigene Zeichensätze.

.. _zend.pdf.drawing.using-fonts.example-1:

.. rubric:: Einen Standardzeichensatz erstellen

.. code-block:: php
   :linenos:

   ...
   // Erstelle einen neuen Zeichensatz
   $font = Zend_Pdf_Font::fontWithName(Zend_Pdf_Font::FONT_HELVETICA);

   // Wende Zeichensatz an
   $pdfPage->setFont($font, 36);
   ...

Die Zeichensatzkonstanten für die 14 *PDF* Standardzeichensätze sind innerhalb der ``Zend_Pdf_Font`` Klasse
definiert:



   - Zend_Pdf_Font::FONT_COURIER

   - Zend_Pdf_Font::FONT_COURIER_BOLD

   - Zend_Pdf_Font::FONT_COURIER_ITALIC

   - Zend_Pdf_Font::FONT_COURIER_BOLDITALIC

   - Zend_Pdf_Font::FONT_TIMES_ROMAN

   - Zend_Pdf_Font::FONT_TIMES_BOLD

   - Zend_Pdf_Font::FONT_TIMES_ITALIC

   - Zend_Pdf_Font::FONT_TIMES_BOLDITALIC

   - Zend_Pdf_Font::FONT_HELVETICA

   - Zend_Pdf_Font::FONT_HELVETICA_BOLD

   - Zend_Pdf_Font::FONT_HELVETICA_ITALIC

   - Zend_Pdf_Font::FONT_HELVETICA_BOLDITALIC

   - Zend_Pdf_Font::FONT_SYMBOL

   - Zend_Pdf_Font::FONT_ZAPFDINGBATS



Du kannst außerdem jeden individuellen TrueType Zeichensatz (welcher normalerweise eine '.ttf' Erweiterung hat)
oder einen OpenType Zeichensatz ('.otf' Erweiterung) verwenden, wenn er TrueType Konturen enthält. Bisher nicht
unterstützt, aber für zukünftige Versionen geplant, sind Mac OS X .dfont Dateien und Microsoft TrueType
Collection ('.ttc' Erweiterung) Dateien.

Um einen TrueType Zeichensatz zu verwenden, mußt du den kompletten Verzeichnispfad zum Zeichensatzprogramm
angeben. Wenn der Zeichensatz aus welchem Grund auch immer nicht gelesen werden kann oder wenn es kein TrueType
Zeichensatz ist, wird the Fabrikmethode eine Ausnahme werfen:

.. _zend.pdf.drawing.using-fonts.example-2:

.. rubric:: Einen TrueType Zeichensatz erstellen

.. code-block:: php
   :linenos:

   ...
   // Erstelle einen neuen Zeichensatz
   $goodDogCoolFont = Zend_Pdf_Font::fontWithPath('/path/to/GOODDC__.TTF');

   // Verwende den Zeichensatz
   $pdfPage->setFont($goodDogCoolFont, 36);
   ...

Standardmäßig werden eigene Zeichensätze in das erstellte *PDF* Dokument eingebettet. Dies ermöglicht den
Empfänger, die Seite wie beabsichtigt anzuschauen, sogar wenn sie den entsprechenden Zeichensatz auf ihrem System
gar nicht installiert haben. Wenn du dich über die Dateigröße sorgst, kannst du angeben, dass das
Zeichensatzprogramm nicht eingebettet wird, indem du eine 'nicht einbetten' Option an die Fabrikmethode übergibst:

.. _zend.pdf.drawing.using-fonts.example-3:

.. rubric:: Erstelle einen TrueType Zeichensatz, aber bette ihn nicht in das PDF Dokument ein

.. code-block:: php
   :linenos:

   ...
   // Erstelle einen neuen Zeichensatz
   $goodDogCoolFont = Zend_Pdf_Font::fontWithPath('/path/to/GOODDC__.TTF',
                                                  Zend_Pdf_Font::EMBED_DONT_EMBED);

   // Verwende den Zeichensatz
   $pdfPage->setFont($goodDogCoolFont, 36);
   ...

Wenn das Zeichensatzprogramm nicht eingebettet wurde, aber den Empfänger der *PDF* Datei diesen Zeichensatz auf
seinem System installiert hat, wird er das Dokument so sehen wie beabsichtigt. Wenn sie nicht den korrekten
Zeichensatz installiert haben, wird der *PDF* Viewer sich bemühen, um einen Ersatz herzustellen.

Einige Zeichensätze haben sehr spezielle Lizensierungsregeln, die das Einbetten in *PDF* Dokumente verhindern.
Damit du dadurch nicht überrascht wirst, wenn du versuchst einen Zeichensatz einzubetten, der nicht eingebettet
werden kann, wird die Fabrikmethode eine Ausnahme werfen.

Du kannst diese Zeichensätze weiterhin verwenden, aber du mußt entweder die 'nicht einbetten' Option übergeben
wie oben beschrieben oder du kannst einfach die Ausnahme unterdrücken:

.. _zend.pdf.drawing.using-fonts.example-4:

.. rubric:: Werfe keine Ausnahme für Zeichensätze, die nicht eingebettet werden können

.. code-block:: php
   :linenos:

   ...
   $font = Zend_Pdf_Font::fontWithPath(
              '/path/to/unEmbeddableFont.ttf',
              Zend_Pdf_Font::EMBED_SUPPRESS_EMBED_EXCEPTION
           );
   ...

Diese Unterdrückungstechnik wird bevorzugt, wenn du einen Endnutzer erlaubst, seine eigenen Zeichensätze
auszuwählen. Zeichensätze, die in ein *PDF* Dokument eingebettet werden können, werden eingebettet, andere
nicht.

Zeichensatzprogramme können sehr groß sein, manche erreichen Dutzende von Megabytes. Standardmäßig werden alle
eingebetteten Zeichensätze unter Verwendung des Flate Kompressionsschemas komprimiert, woraus im Schnitt 50% an
Speicherplatz gespart werden kann. Wenn du aus welchem Grund auch immer nicht möchtest, dass das
Zeichensatzprogramm kompimiert wird, kannst du dies mit einer Option abschalten:

.. _zend.pdf.drawing.using-fonts.example-5:

.. rubric:: Komprimiere einen eingebetten Zeichensatz nicht

.. code-block:: php
   :linenos:

   ...
   $font = Zend_Pdf_Font::fontWithPath('/path/to/someReallyBigFont.ttf',
                                       Zend_Pdf_Font::EMBED_DONT_COMPRESS);
   ...

Zuguterletzt, kannst du die Einbettungsoptionen mit Hilfe des OR Operators kombinieren, wenn notwendig:

.. _zend.pdf.drawing.using-fonts.example-6:

.. rubric:: Kombiniere die Zeichensatz Einbettungsoptionen

.. code-block:: php
   :linenos:

   ...
   $font = Zend_Pdf_Font::fontWithPath(
               $someUserSelectedFontPath,
               (Zend_Pdf_Font::EMBED_SUPPRESS_EMBED_EXCEPTION |
               Zend_Pdf_Font::EMBED_DONT_COMPRESS));
   ...

.. _zend.pdf.drawing.standard-fonts-limitations:

Limits der Standard PDF Schriften
---------------------------------

Die Standard *PDF* Schriften verwendetn intern verschiedene Single-Byte Encodings (siehe `PDF Reference, Sixth
Edition, version 1.7`_ Anhang D für Details). Diese sind generell gleich wie beim Latin1 Zeichensatz (ausser den
Symbol und ZapfDingbats Schriften).

``Zend_Pdf`` verwendet CP1252 (WinLatin1) für das Zeichnen von Text mit Standardschriften.

Text kann trotzdem in jedem anderen Encoding angegeben werden, welches spezifiziert werden muß wenn es sich vom
aktuellen Gebietsschema unterscheidet. Nur WinLatin1 Zeichen werden aktuell gezeichnet.

.. _zend.pdf.drawing.using-fonts.example-7:

.. rubric:: Kombinieren mit in Schriften enthaltenen Optionen

.. code-block:: php
   :linenos:

   ...
   $font = Zend_Pdf_Font::fontWithName(Zend_Pdf_Font::FONT_COURIER);
   $pdfPage->setFont($font, 36)
           ->drawText('Euro sign - €', 72, 720, 'UTF-8')
           ->drawText('Text with umlauts - à è ì', 72, 650, 'UTF-8');
   ...

.. _zend.pdf.drawing.extracting-fonts:

Schriften extrahieren
---------------------

Das ``Zend_Pdf`` Modul bietet die Möglichkeit Schriften von geladenen Dokumenten zu extrahieren.

Das kann für aufsteigende Dokumenten Updates nützlich sein. Ohne diese Funktionalität müssen Schriften jedes
Mal in ein Dokument hinzugefügt und möglicherweise eingebetten werden, wenn es aktualisiert werden soll.

Die ``Zend_Pdf`` und ``Zend_Pdf_Page`` Objekte bieten spezielle Methoden um alle genannten Schriften innerhalb
eines Dokuments oder einer Seite zu extrahieren:

.. _zend.pdf.drawing.extracting-fonts.example-1:

.. rubric:: Schriften von einem geladenen Dokument extrahieren

.. code-block:: php
   :linenos:

   ...
   $pdf = Zend_Pdf::load($documentPath);
   ...
   // Alle Schriften des Dokuments bekommen
   $fontList = $pdf->extractFonts();
   $pdf->pages[] = ($page = $pdf->newPage(Zend_Pdf_Page::SIZE_A4));
   $yPosition = 700;
   foreach ($fontList as $font) {
       $page->setFont($font, 15);
       $fontName = $font->getFontName(Zend_Pdf_Font::NAME_POSTSCRIPT,
                                      'en',
                                      'UTF-8');
       $page->drawText($fontName . ': Der schnelle braune Fuchs springt '
                                 . 'über den lahmen Hund',
                       100,
                       $yPosition,
                       'UTF-8');
       $yPosition -= 30;
   }
   ...
   // Alle Schriften, die in der ersten Seite des Dokuments
   // referenziert sind erhalten
   $firstPage = reset($pdf->pages);
   $firstPageFonts = $firstPage->extractFonts();
   ...

.. _zend.pdf.drawing.extracting-fonts.example-2:

.. rubric:: Eine Schrift von einem geladenen Dokument extrahieren durch die Angabe des Schriftnamens

.. code-block:: php
   :linenos:

   ...
   $pdf = new Zend_Pdf();
   ...
   $pdf->pages[] = ($page = $pdf->newPage(Zend_Pdf_Page::SIZE_A4));

   $font = Zend_Pdf_Font::fontWithPath($fontPath);
   $page->setFont($font, $fontSize);
   $page->drawText($text, $x, $y);
   ...
   // Diese Schrift sollte woanders gespeichert werden...
   $fontName = $font->getFontName(Zend_Pdf_Font::NAME_POSTSCRIPT,
                                  'en',
                                  'UTF-8');
   ...
   $pdf->save($docPath);
   ...

.. code-block:: php
   :linenos:

   ...
   $pdf = Zend_Pdf::load($docPath);
   ...
   $pdf->pages[] = ($page = $pdf->newPage(Zend_Pdf_Page::SIZE_A4));

   /* $srcPage->extractFont($fontName) kann auch hier verwendet werden */
   $font = $pdf->extractFont($fontName);
   $page->setFont($font, $fontSize);
   $page->drawText($text, $x, $y);
   ...
   $pdf->save($docPath, true /* aufsteigender Update Modus */);
   ...

Extrahierte Schriften können statt jeder anderen Schrift mit den folgenden Einschränkungen verwendet werden:



   - Eine extrahierte Schrift kann nur im Kontext des Dokuments verwendet werden von dem es extrahiert wurde.

   - Ein möglicherweise eingebettetes Schriftprogramm wird aktuell nicht extrahiert. Deswegen können extrahierte
     Schriften keine richtigen Schriftmaße bieten und die originale Schrift wird für die Berechnung der Breite
     verwendet:

     .. code-block:: php
        :linenos:

        ...
        $font = $pdf->extractFont($fontName);
        $originalFont = Zend_Pdf_Font::fontWithPath($fontPath);

        $page->setFont($font, /* Die extrahierte Schrift für das Zeichnen verwenden */
                       $fontSize);
        $xPosition = $x;
        for ($charIndex = 0; $charIndex < strlen($text); $charIndex++) {
            $page->drawText($text[$charIndex], xPosition, $y);

            // Die originale Schrift für die Berechnung der Breite des Textes verwenden
            $width += $originalFont->widthForGlyph(
                          $originalFont->glyphNumberForCharacter($text[$charIndex])
                      );
            $xPosition += $width/$originalFont->getUnitsPerEm()*$fontSize;
        }
        ...



.. _zend.pdf.drawing.image-drawing:

Zeichnen von Grafiken
---------------------

Die ``Zend_Pdf_Page`` Klasse stellt die drawImage() Methode für das Zeichnen von Grafiken bereit:

.. code-block:: php
   :linenos:

   /**
    * Zeichne eine Grafik an der angegebenen Position der Seite.
    *
    * @param Zend_Pdf_Ressource_Image $image
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @return Zend_Pdf_Page
    */
   public function drawImage(Zend_Pdf_Ressource_Image $image, $x1, $y1, $x2, $y2);

Grafikobjekte sollten mit der Methode ``Zend_Pdf_Image::imageWithPath($filePath)`` erzeugt werden. (Es werden zur
Zeit JPG, PNG und TIFF Grafiken unterstützt):

.. _zend.pdf.drawing.image-drawing.example-1:

.. rubric:: Zeichnen von Grafiken

.. code-block:: php
   :linenos:

   ...
   // Lade die Grafik
   $image = Zend_Pdf_Image::imageWithPath('my_image.jpg');

   $pdfPage->drawImage($image, 100, 100, 400, 300);
   ...

**Wichtig! JPG Support setzt voraus, dass die GD Erweiterung für PHP konfiguriert wurde.** **Wichtig! PNG Support
setzt voraus, dass die ZLIB Erweiterung konfiguriert wurde, um mit Grafiken mit Alphakanal zu arbeiten.**

Wende dich an die *PHP* Dokumentation für weitere Informationen (`http://www.php.net/manual/de/ref.image.php`_).
(`http://www.php.net/manual/de/ref.zlib.php`_).

.. _zend.pdf.drawing.line-drawing-style:

Stil der Strichzeichnungen
--------------------------

Der Stil der Strichzeichnungen wurd durch die Linienbreite, die Linienfarbe und das Strichmuster definiert. Alle
diese Parameter können an die Klassenmethoden von ``Zend_Pdf_Page`` übergeben werden:

.. code-block:: php
   :linenos:

   /** Setze die Linienfarbe. */
   public function setLineColor(Zend_Pdf_Color $color);

   /** Setze die Linienbreite. */
   public function setLineWidth(float $width);

   /**
    * Setze das Strichmuster.
    *
    * Pattern ist ein Array mit Fließkommazahlen:
    *     array(on_length, off_length, on_length, off_length, ...)
    * Phase is shift from the beginning of line.
    *
    * @param array $pattern
    * @param array $phase
    * @return Zend_Pdf_Page
    */
   public function setLineDashingPattern($pattern, $phase = 0);

.. _zend.pdf.drawing.fill-style:

Füllstil
--------

Die Methoden ``Zend_Pdf_Page::drawRectangle()``, ``Zend_Pdf_Page::drawPolygon()``, ``Zend_Pdf_Page::drawCircle()``
und ``Zend_Pdf_Page::drawEllipse()`` akzeptieren das ``$fillType`` Argument als optionalen Parameter. Es kann
lauten:

- Zend_Pdf_Page::SHAPE_DRAW_STROKE - strichele die Form

- Zend_Pdf_Page::SHAPE_DRAW_FILL - fülle die Form

- Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE - fülle und strichele die Form (Standardverhalten)

Die ``Zend_Pdf_Page::drawPolygon()`` Methode akzeptiert ``$fillMethod`` als zusätzlichen Parameter:

- Zend_Pdf_Page::FILL_METHOD_NON_ZERO_WINDING (Standardverhalten)

  :t:`Die PDF Referenz`  beschreibt diese Regel wie folgt:
  | Die Regel der nicht-Null Fensternummer erkennt ob ein gegebener Punkt in einem Pfad liegt, indem konzeptuell
  ein
  Strahl von diesem Punkt in die Unendlichkeit in jede Richtung gezeichnet wird und dann die Plätze betrachtet
  werden an denen der Pfad den Strahl kreuzt. Beginnend mit der Anzahl 0, fügt die Regel jedesmal 1 hinzu wenn ein
  Pfadsegment den Strahl von links nach rechts kreuzt, und substrahiert jedesmal 1 wenn ein Segment von rechts nach
  links kreuzt. Wenn nach dem Zählen aller Kreuzungen das Ergebnis ß ist, dann ist der Punkt ausserhalb des
  Pfades; andernfalls ist er innerhalb. Beachte: Die gerade beschriebene Methode spezifiziert nicht was zu tun ist
  wenn ein Pfadsegment mit dem gewählten Strahl übereinstimmt oder ihn tangiert. Da die Richtung des Strahls
  beliebig ist wählt die Regel einen Strahl der solche problematischen Schnittpunkte nicht verursacht. Für
  einfache konvexe Pfade, definierte die Regel der nicht-Null Fensternummer das Innen und Aussen wie man es
  intuitiv erwarten würde. Die interessanteren Fälle sind jene die komplexe oder selbst-schneidenden Pfade wie
  jene in Figur 4.10 gezeigt (in der *PDF* Referenz). Für einen Pfad der aus einem fünf-punktigen Stern besteht,
  und mit fünf verbundenen geraden Linien besteht die sich gegenseitig schneiden, nimmt die Regel an dass das
  Innen die komplette Fläche ist, welche vom Stern eingeschlossen wird, inklusive dem Pentagon in der Mitte. Für
  einen Pfad der aus zwei konzentrischen Kreisen besteht, wird angenommen das die Fläche welche von beiden Kreisen
  eingeschlossen wird innen ist, wobei beide in der selben Richtung gezeichnet sein müssen. Wenn die Kreise in
  entgegengesetzten Richtungen gezeichnet werden, wird nur die "Donut" Form zwischen Ihnen als Innen angenommen,
  entsprechend der Regel; das "Donut Loch" ist Aussen.



- Zend_Pdf_Page::FILL_METHOD_EVEN_ODD

  :t:`Die PDF Referenz`  beschreibt diese Regel wie folgt:
  | Eine alternative zur Regel der nicht-Null Fensternummer ist die gerade-ungerade Regel. Diese Regel erkennt die
  "Innenhaftigkeit" eines Punktes indem ein Strahl von diesem Punkt in jede Richtung gezeichnet wird und einfach
  die Anzahl der Pfadsegmente gezählt wird, welche den Strahl kreuzen, unabhängig von der Richtung. Wenn die
  Anzahl ungerade ist, dann ist der Punkt innerhalb; ist Sie gerade ist der Punkt ausserhalb. Das verursacht die
  gleichen Resultate wie die Regel der nicht-Null Fensternummer für Pfade mit einfachen Formen, produziert aber
  unterschiedliche Resultate für komplexere Formen. Figur 4.11 (in der *PDF* Referenz) zeigt die Effekte wenn die
  gerade-ungerade Regel auf komplexe Pfade angewendet wird. Für den Fünf-punktigen Stern nimmt die Regel an dass
  die Triangularpunkte innerhalb des Pfades liegen, aber nicht das Pentagon im Zentrum. Für die zwei
  konzentrischen Kreise, wird nur von der "Donut" Form angenommen das Sie innerhalb liegt, unabhängig von der
  Richtung in welcher die Kreise gezeichnet werden.



.. _zend.pdf.drawing.linear-transformations:

Lineare Transformationen
------------------------

.. _zend.pdf.drawing.linear-transformations.rotations:

Drehungen
^^^^^^^^^

Bevor eine Zeichenoperation angewendet wird, können *PDF* Seiten gedreht werden. Dies kann mit Hilfe der
``Zend_Pdf_Page::rotate()`` Methode durchgeführt werden:

.. code-block:: php
   :linenos:

   /**
    * Drehe die Seite
    *
    * @param float $x - die X Koordinate des Rotationspunktes
    * @param float $y - die Y Koordinate des Rotationspunktes
    * @param float $angle - der Rotationswinkel
    * @return Zend_Pdf_Page
    */
   public function rotate($x, $y, $angle);

.. _zend.pdf.drawing.linear-transformations.scale:

Beginnend mit ZF 1.8, Skalierung
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Skalenänderungen werden durch die ``Zend_Pdf_Page::scale()`` Methode angeboten:

.. code-block:: php
   :linenos:

   /**
    * Koordinationssystem für die Skala
    *
    * @param float $xScale - Skalierungsfaktor für die X Dimension
    * @param float $yScale - Skalierungsfaktor für die Y Dimension
    * @return Zend_Pdf_Page
    */
   public function scale($xScale, $yScale);

.. _zend.pdf.drawing.linear-transformations.translate:

Beginnend mit ZF 1.8, Bewegungen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Das bewegen des Koordinationssystem wird von der ``Zend_Pdf_Page::translate()`` Methode durchgeführt:

.. code-block:: php
   :linenos:

   /**
    * Bewegen des Koordinationssystems
    *
    * @param float $xShift - X Koordinate für die Bewegung
    * @param float $yShift - Y Koordinate für die Bewegung
    * @return Zend_Pdf_Page
    */
   public function translate($xShift, $yShift);

.. _zend.pdf.drawing.linear-transformations.skew:

Beginnend mit ZF 1.8, Drehungen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Das Drehen der Seite kann durch Verwendung der ``Zend_Pdf_Page::skew()`` Methode durchgeführt werden:

.. code-block:: php
   :linenos:

   /**
    * Bewegen des Koordinationssystems
    *
    * @param float $x  - Die X Koordinate des Achsen-Drehpunktes
    * @param float $y  - Die Y Koordinate des Achsen-Drehpunktes
    * @param float $xAngle - X Winkel der Achse
    * @param float $yAngle - Y Winkel der Achse
    * @return Zend_Pdf_Page
    */
   public function skew($x, $y, $xAngle, $yAngle);

.. _zend.pdf.drawing.save-restore:

Speichern/Wiederherstellen des Grafikzustand
--------------------------------------------

Jederzeit kann der Grafikzustand der Seite (aktueller Zeichensatz, Schriftgröße, Linienfarbe, Füllfarbe,
Linienstil, Seitendrehung, Zeichenbereich) gespeichert und wiederhergestellt werden. Speicheroperationen legen die
Daten auf einen Grafikzustand Stapel, Wiederherstelloperationen holen Sie daher zurück.

In der ``Zend_Pdf_Page`` Klasse gibt es für diese Operationen zwei Methoden:

.. code-block:: php
   :linenos:

   /**
    * Speichere den Grafikzustand dieser Seite.
    * Es wir ein Schnappschuss vom aktuell festgelegten Stil, Position,
    * Zeichenbereich und jeder festgelegten Drehung/Umrechnung/Skalierung
    * erstellt.
    *
    * @return Zend_Pdf_Page
    */
   public function saveGS();

   /**
    * Stelle den Grafikzustand wieder her, der mit dem letzten Aufruf von
    * saveGS() gespeichert wurde
    *
    * @return Zend_Pdf_Page
    */
   public function restoreGS();

.. _zend.pdf.drawing.clipping:

Zeichenbereich
--------------

*PDF* und die ``Zend_Pdf`` Komponente unterstützen die Begrenzung des Zeichenbereichs. Der aktuelle Zeichenbereich
begrenzt den Seitenbereich, der von Zeichenoperationen beeinflusst werden kann. Zu Beginn ist dies die gesamte
Seite.

Die ``Zend_Pdf_Page`` Klasse stellt einen Satz von Methoden für die Begrenzung bereit.

.. code-block:: php
   :linenos:

   /**
    * Durchschneide den aktuellen Zeichenbereich mit einem Rechteck.
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @return Zend_Pdf_Page
    */
   public function clipRectangle($x1, $y1, $x2, $y2);

.. code-block:: php
   :linenos:

   /**
    * Durchschneide den aktuellen Zeichenbereich mit einem Polygon.
    *
    * @param array $x  - Array mit Floats (die X Koordinaten der Eckpunkte)
    * @param array $y  - Array mit Floats (die Y Koordinaten der Eckpunkte)
    * @param integer $fillMethod
    * @return Zend_Pdf_Page
    */
   public function clipPolygon($x,
                               $y,
                               $fillMethod =
                                   Zend_Pdf_Page::FILL_METHOD_NON_ZERO_WINDING);

.. code-block:: php
   :linenos:

   /**
    * Durchschneide den aktuellen Zeichenbereich mit einem Kreis.
    *
    * @param float $x
    * @param float $y
    * @param float $radius
    * @param float $startAngle
    * @param float $endAngle
    * @return Zend_Pdf_Page
    */
   public function clipCircle($x,
                              $y,
                              $radius,
                              $startAngle = null,
                              $endAngle = null);

.. code-block:: php
   :linenos:

   /**
    * Durchschneide den aktuellen Zeichenbereich mit einer Ellipse.
    *
    * Methoden Signaturen:
    * drawEllipse($x1, $y1, $x2, $y2);
    * drawEllipse($x1, $y1, $x2, $y2, $startAngle, $endAngle);
    *
    * @todo verarbeite die Sonderfälle mit $x2-$x1 == 0 oder $y2-$y1 == 0
    *
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @param float $startAngle
    * @param float $endAngle
    * @return Zend_Pdf_Page
    */
   public function clipEllipse($x1,
                               $y1,
                               $x2,
                               $y2,
                               $startAngle = null,
                               $endAngle = null);

.. _zend.pdf.drawing.styles:

Stile
-----

Die ``Zend_Pdf_Style`` Klasse stellt Stilfunktionalitäten bereit.

Stile können verwendet werden, um mit einer Operation die Parameter für den Grafikzustand zu speichern und auf
eine *PDF* Seite anzuwenden:

.. code-block:: php
   :linenos:

   /**
    * Lege den Stil für zukünftige Zeichenoperationen auf dieser Seite fest
    *
    * @param Zend_Pdf_Style $style
    * @return Zend_Pdf_Page
    */
   public function setStyle(Zend_Pdf_Style $style);

   /**
    * Gebe den Stil der Seite zurück.
    *
    * @return Zend_Pdf_Style|null
    */
   public function getStyle();

Die ``Zend_Pdf_Style`` Klasse stellt einen Satz von Methoden bereit, um verschiedene Parameter des Grafikstadiums
zu setzen und zu holen:

.. code-block:: php
   :linenos:

   /**
    * Setze die Linienfarbe.
    *
    * @param Zend_Pdf_Color $color
    * @return Zend_Pdf_Page
    */
   public function setLineColor(Zend_Pdf_Color $color);

.. code-block:: php
   :linenos:

   /**
    * Hole die Linienfarbe.
    *
    * @return Zend_Pdf_Color|null
    */
   public function getLineColor();

.. code-block:: php
   :linenos:

   /**
    * Setze die Linienbreite.
    *
    * @param float $width
    * @return Zend_Pdf_Page
    */
   public function setLineWidth($width);

.. code-block:: php
   :linenos:

   /**
    * Hole die Linienbreite.
    *
    * @return float
    */
   public function getLineWidth();

.. code-block:: php
   :linenos:

   /**
    * Setze das Strichmuster
    *
    * @param array $pattern
    * @param float $phase
    * @return Zend_Pdf_Page
    */
   public function setLineDashingPattern($pattern, $phase = 0);

.. code-block:: php
   :linenos:

   /**
    * Hole das Strichmuster
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
    * Setze die Füllfarbe
    *
    * @param Zend_Pdf_Color $color
    * @return Zend_Pdf_Page
    */
   public function setFillColor(Zend_Pdf_Color $color);

.. code-block:: php
   :linenos:

   /**
    * Hole die Füllfarbe.
    *
    * @return Zend_Pdf_Color|null
    */
   public function getFillColor();

.. code-block:: php
   :linenos:

   /**
    * Ändere den Zeichensatz.
    *
    * @param Zend_Pdf_Resource_Font $font
    * @param float $fontSize
    * @return Zend_Pdf_Page
    */
   public function setFont(Zend_Pdf_Resource_Font $font, $fontSize);

.. code-block:: php
   :linenos:

   /**
    * Ändere die Schriftgröße
    *
    * @param float $fontSize
    * @return Zend_Pdf_Page
    */
   public function setFontSize($fontSize);

.. code-block:: php
   :linenos:

   /**
    * Hole den Zeichensatz.
    *
    * @return Zend_Pdf_Resource_Font $font
    */
   public function getFont();

.. code-block:: php
   :linenos:

   /**
    * Hole die Schriftgröße
    *
    * @return float $fontSize
    */
   public function getFontSize();

.. _zend.pdf.drawing.alpha:

Transparenz
-----------

Das ``Zend_Pdf`` Modul unterstützt die Handhabung von Transparenz.

Transparenz kann durch Verwendung der ``Zend_Pdf_Page::setAlpha()`` Methode gesetzt werden:

.. code-block:: php
   :linenos:

   /**
    * Setzt die Transparenz
    *
    * $alpha == 0  - Transparent
    * $alpha == 1  - Opaque
    *
    * Von PDF unterstützte Transparent-Modi:
    * Normal (standard), Multiply, Screen, Overlay, Darken, Lighten,
    * ColorDodge, ColorBurn, HardLight, SoftLight, Difference, Exclusion
    *
    * @param float $alpha
    * @param string $mode
    * @throws Zend_Pdf_Exception
    * @return Zend_Pdf_Page
    */
   public function setAlpha($alpha, $mode = 'Normal');



.. _`iconv()`: http://www.php.net/manual/function.iconv.php
.. _`PDF Reference, Sixth Edition, version 1.7`: http://www.adobe.com/devnet/acrobat/pdfs/pdf_reference_1-7.pdf
.. _`http://www.php.net/manual/de/ref.image.php`: http://www.php.net/manual/de/ref.image.php
.. _`http://www.php.net/manual/de/ref.zlib.php`: http://www.php.net/manual/de/ref.zlib.php
