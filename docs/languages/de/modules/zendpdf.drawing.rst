.. EN-Revision: none
.. _zendpdf.drawing:

Zeichnen
========

.. _zendpdf.drawing.geometry:

Geometrie
---------

*PDF* verwendet die selbe Geometrie wie PostScript. Sie beginnt an der linken unteren Ecke der Seite und wird in
Punkten (1/72 Zoll) gemessen.

Die Seitengröße kann vom Seitenobjekt erhalten werden:

.. code-block:: php
   :linenos:

   $width  = $pdfPage->getWidth();
   $height = $pdfPage->getHeight();

.. _zendpdf.drawing.color:

Farben
------

*PDF* bietet leistungsfähige Möglichkeiten für die Farbdarstellung. Die ``ZendPdf`` Komponente unterstützt die
Grauskala sowie RGB und CYMK Farbräume. Jede kann überall verwendet werden, wo ein ``ZendPdf\Color`` Objekt
benötigt wird. Die ``ZendPdf\Color\GrayScale``, ``ZendPdf\Color\Rgb`` und ``ZendPdf\Color\Cmyk`` Klassen
stellen folgende Funktionalitäten bereit:

.. code-block:: php
   :linenos:

   // $grayLevel (Fließkommazahl)
   // 0.0 (schwarz) - 1.0 (weiß)
   $color1 = new ZendPdf\Color\GrayScale($grayLevel);

   // $r, $g, $b (Fließkommazahlen)
   // 0.0 (min Helligkeit) - 1.0 (max Helligkeit)
   $color2 = new ZendPdf\Color\Rgb($r, $g, $b);

   // $c, $m, $y, $k (Fließkommazahlen)
   // 0.0 (min Helligkeit) - 1.0 (max Helligkeit)
   $color3 = new ZendPdf\Color\Cmyk($c, $m, $y, $k);

Die *HTML* Farben werden auch durch die Klasse ``ZendPdf\Color\Html`` bereitgestellt:

.. code-block:: php
   :linenos:

   $color1 = new ZendPdf\Color\Html('#3366FF');
   $color2 = new ZendPdf\Color\Html('silver');
   $color3 = new ZendPdf\Color\Html('forestgreen');

.. _zendpdf.drawing.shape-drawing:

Zeichnen von Formen
-------------------

Alle Zeichenoperationen können im Kontext einer *PDF* Seite durchgeführt werden.

Die ``ZendPdf\Page`` Klass stellt einen Satz von einfachen Formen bereit:

.. code-block:: php
   :linenos:

   /**
    * Zeichne eine Linie von x1,y1 nach x2,y2.
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
    * Zeichne ein Rechteck.
    *
    * Füllarten:
    * ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE - fülle und strichliere
    *                                             das Rechteck (Standard)
    * ZendPdf\Page::SHAPE_DRAW_STROKE          - strichele das Rechteck
    * ZendPdf\Page::SHAPE_DRAW_FILL            - fülle das Rechteck
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
    * Zeichne ein gerundetes Rechteck.
    *
    * Füllarten:
    * ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE - fülle und strichliere
    *                                             das Rechteck (Standard)
    * ZendPdf\Page::SHAPE_DRAW_STROKE          - strichele das Rechteck
    * ZendPdf\Page::SHAPE_DRAW_FILL            - fülle das Rechteck
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
    * @return ZendPdf\Page
    */
   public function drawRoundedRectangle($x1, $y1, $x2, $y2, $radius,
                          $fillType = ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE);

.. code-block:: php
   :linenos:

   /**
    * Zeichne ein Polygon
    *
    * Wenn $fillType ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE oder
    * ZendPdf\Page::SHAPE_DRAW_FILL ist, wird das Polygon automatisch geschlossen.
    * Für eine detaillierte Beschreibung dieser Methode schaue in eine PDF
    * Dokumentation (Kapitel 4.4.2 Path painting Operators, Filling)
    *
    * @param array $x  - Array mit Floats (die X Koordinaten der Eckpunkte)
    * @param array $y  - Array mit Floats (the Y Koordinaten der Eckpunkte)
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
    * @throws ZendPdf\Exception
    * @return ZendPdf\Page
    */
   public function drawText($text, $x, $y, $charEncoding = '');

.. _zendpdf.drawing.text-drawing.example-1:

.. rubric:: Zeichne einen String auf der Seite

.. code-block:: php
   :linenos:

   ...
   $pdfPage->drawText('Hello world!', 72, 720);
   ...

Standardmäßig werden Textstrings unter Verwendung der Zeichenkodierungsmethode der aktuelle "locale"
interpretiert. Wenn du einen String hast, der eine andere Zeichenkodierungsmethode verwendet (wie zum Beispiel ein
UTF-8 String, der aus einer Datei auf der Platte gelesen wurde, oder ein MacRoman String, der aus einer älteren
Datenbank erhalten wurde), kannst du die Zeichenkodierung zum Zeitpunkt des Zeichnens angeben und ``ZendPdf`` wird
die Konvertierung für dich durchführen. Du kannst Quellstrings in jeder Kodierungsmethode übergeben, die von
*PHP*'s `iconv()`_ Funktion unterstützt wird.

.. _zendpdf.drawing.text-drawing.example-2:

.. rubric:: Zeiche einen UTF-8 kodierten String auf der Seite

.. code-block:: php
   :linenos:

   ...
   // Lese einen UTF-8 kodierten String von der Platte
   $unicodeString = fread($fp, 1024);

   // Zeichne den String auf der Seite
   $pdfPage->drawText($unicodeString, 72, 720, 'UTF-8');
   ...

.. _zendpdf.drawing.using-fonts:

Verwendung von Zeichensätzen
----------------------------

``ZendPdf\Page::drawText()`` verwendet den aktuellen Zeichensatz und die aktuelle Zeichengröße der Seite, die
mit der Methode ``ZendPdf\Page::setFont()`` festgelegt werden:

.. code-block:: php
   :linenos:

   /**
    * Lege den aktuellen Zeichensatz fest.
    *
    * @param ZendPdf\Resource\Font $font
    * @param float $fontSize
    * @return ZendPdf\Page
    */
   public function setFont(ZendPdf\Resource\Font $font, $fontSize);

*PDF* Dokumente unterstützt PostScript Type1 und TrueType Zeichensätze, sowie die zwei speziellen *PDF* Typen
Type3 und zusammengesetzte Zeichensätze (composite fonts). Es gibt zudem 14 Type1 Standardzeichensätze, die von
jedem *PDF* Viewer bereit gestellt werden: Courier (4 Stile), Helvetica (4 Stile), Times (4 Stile), Symbol und Zapf
Dingbats.

Die ``ZendPdf`` Komponente unterstützt derzeit diese 14 *PDF* Standardzeichensätze sowie deine eigenen TrueType
Zeichensätze. Zeichensatzobjekte können über eine der zwei Fabrikmethoden (factory methods) erhalten werden:
``ZendPdf\Font::fontWithName($fontName)`` für die 14 *PDF* Standardzeichensätze oder
``ZendPdf\Font::fontWithPath($filePath)`` für eigene Zeichensätze.

.. _zendpdf.drawing.using-fonts.example-1:

.. rubric:: Einen Standardzeichensatz erstellen

.. code-block:: php
   :linenos:

   ...
   // Erstelle einen neuen Zeichensatz
   $font = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_HELVETICA);

   // Wende Zeichensatz an
   $pdfPage->setFont($font, 36);
   ...

Die Zeichensatzkonstanten für die 14 *PDF* Standardzeichensätze sind innerhalb der ``ZendPdf\Font`` Klasse
definiert:



   - ZendPdf\Font::FONT_COURIER

   - ZendPdf\Font::FONT_COURIER_BOLD

   - ZendPdf\Font::FONT_COURIER_ITALIC

   - ZendPdf\Font::FONT_COURIER_BOLDITALIC

   - ZendPdf\Font::FONT_TIMES_ROMAN

   - ZendPdf\Font::FONT_TIMES_BOLD

   - ZendPdf\Font::FONT_TIMES_ITALIC

   - ZendPdf\Font::FONT_TIMES_BOLDITALIC

   - ZendPdf\Font::FONT_HELVETICA

   - ZendPdf\Font::FONT_HELVETICA_BOLD

   - ZendPdf\Font::FONT_HELVETICA_ITALIC

   - ZendPdf\Font::FONT_HELVETICA_BOLDITALIC

   - ZendPdf\Font::FONT_SYMBOL

   - ZendPdf\Font::FONT_ZAPFDINGBATS



Du kannst außerdem jeden individuellen TrueType Zeichensatz (welcher normalerweise eine '.ttf' Erweiterung hat)
oder einen OpenType Zeichensatz ('.otf' Erweiterung) verwenden, wenn er TrueType Konturen enthält. Bisher nicht
unterstützt, aber für zukünftige Versionen geplant, sind Mac OS X .dfont Dateien und Microsoft TrueType
Collection ('.ttc' Erweiterung) Dateien.

Um einen TrueType Zeichensatz zu verwenden, mußt du den kompletten Verzeichnispfad zum Zeichensatzprogramm
angeben. Wenn der Zeichensatz aus welchem Grund auch immer nicht gelesen werden kann oder wenn es kein TrueType
Zeichensatz ist, wird the Fabrikmethode eine Ausnahme werfen:

.. _zendpdf.drawing.using-fonts.example-2:

.. rubric:: Einen TrueType Zeichensatz erstellen

.. code-block:: php
   :linenos:

   ...
   // Erstelle einen neuen Zeichensatz
   $goodDogCoolFont = ZendPdf\Font::fontWithPath('/path/to/GOODDC__.TTF');

   // Verwende den Zeichensatz
   $pdfPage->setFont($goodDogCoolFont, 36);
   ...

Standardmäßig werden eigene Zeichensätze in das erstellte *PDF* Dokument eingebettet. Dies ermöglicht den
Empfänger, die Seite wie beabsichtigt anzuschauen, sogar wenn sie den entsprechenden Zeichensatz auf ihrem System
gar nicht installiert haben. Wenn du dich über die Dateigröße sorgst, kannst du angeben, dass das
Zeichensatzprogramm nicht eingebettet wird, indem du eine 'nicht einbetten' Option an die Fabrikmethode übergibst:

.. _zendpdf.drawing.using-fonts.example-3:

.. rubric:: Erstelle einen TrueType Zeichensatz, aber bette ihn nicht in das PDF Dokument ein

.. code-block:: php
   :linenos:

   ...
   // Erstelle einen neuen Zeichensatz
   $goodDogCoolFont = ZendPdf\Font::fontWithPath('/path/to/GOODDC__.TTF',
                                                  ZendPdf\Font::EMBED_DONT_EMBED);

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

.. _zendpdf.drawing.using-fonts.example-4:

.. rubric:: Werfe keine Ausnahme für Zeichensätze, die nicht eingebettet werden können

.. code-block:: php
   :linenos:

   ...
   $font = ZendPdf\Font::fontWithPath(
              '/path/to/unEmbeddableFont.ttf',
              ZendPdf\Font::EMBED_SUPPRESS_EMBED_EXCEPTION
           );
   ...

Diese Unterdrückungstechnik wird bevorzugt, wenn du einen Endnutzer erlaubst, seine eigenen Zeichensätze
auszuwählen. Zeichensätze, die in ein *PDF* Dokument eingebettet werden können, werden eingebettet, andere
nicht.

Zeichensatzprogramme können sehr groß sein, manche erreichen Dutzende von Megabytes. Standardmäßig werden alle
eingebetteten Zeichensätze unter Verwendung des Flate Kompressionsschemas komprimiert, woraus im Schnitt 50% an
Speicherplatz gespart werden kann. Wenn du aus welchem Grund auch immer nicht möchtest, dass das
Zeichensatzprogramm kompimiert wird, kannst du dies mit einer Option abschalten:

.. _zendpdf.drawing.using-fonts.example-5:

.. rubric:: Komprimiere einen eingebetten Zeichensatz nicht

.. code-block:: php
   :linenos:

   ...
   $font = ZendPdf\Font::fontWithPath('/path/to/someReallyBigFont.ttf',
                                       ZendPdf\Font::EMBED_DONT_COMPRESS);
   ...

Zuguterletzt, kannst du die Einbettungsoptionen mit Hilfe des OR Operators kombinieren, wenn notwendig:

.. _zendpdf.drawing.using-fonts.example-6:

.. rubric:: Kombiniere die Zeichensatz Einbettungsoptionen

.. code-block:: php
   :linenos:

   ...
   $font = ZendPdf\Font::fontWithPath(
               $someUserSelectedFontPath,
               (ZendPdf\Font::EMBED_SUPPRESS_EMBED_EXCEPTION |
               ZendPdf\Font::EMBED_DONT_COMPRESS));
   ...

.. _zendpdf.drawing.standard-fonts-limitations:

Limits der Standard PDF Schriften
---------------------------------

Die Standard *PDF* Schriften verwendetn intern verschiedene Single-Byte Encodings (siehe `PDF Reference, Sixth
Edition, version 1.7`_ Anhang D für Details). Diese sind generell gleich wie beim Latin1 Zeichensatz (ausser den
Symbol und ZapfDingbats Schriften).

``ZendPdf`` verwendet CP1252 (WinLatin1) für das Zeichnen von Text mit Standardschriften.

Text kann trotzdem in jedem anderen Encoding angegeben werden, welches spezifiziert werden muß wenn es sich vom
aktuellen Gebietsschema unterscheidet. Nur WinLatin1 Zeichen werden aktuell gezeichnet.

.. _zendpdf.drawing.using-fonts.example-7:

.. rubric:: Kombinieren mit in Schriften enthaltenen Optionen

.. code-block:: php
   :linenos:

   ...
   $font = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_COURIER);
   $pdfPage->setFont($font, 36)
           ->drawText('Euro sign - €', 72, 720, 'UTF-8')
           ->drawText('Text with umlauts - à è ì', 72, 650, 'UTF-8');
   ...

.. _zendpdf.drawing.extracting-fonts:

Schriften extrahieren
---------------------

Das ``ZendPdf`` Modul bietet die Möglichkeit Schriften von geladenen Dokumenten zu extrahieren.

Das kann für aufsteigende Dokumenten Updates nützlich sein. Ohne diese Funktionalität müssen Schriften jedes
Mal in ein Dokument hinzugefügt und möglicherweise eingebetten werden, wenn es aktualisiert werden soll.

Die ``ZendPdf`` und ``ZendPdf\Page`` Objekte bieten spezielle Methoden um alle genannten Schriften innerhalb
eines Dokuments oder einer Seite zu extrahieren:

.. _zendpdf.drawing.extracting-fonts.example-1:

.. rubric:: Schriften von einem geladenen Dokument extrahieren

.. code-block:: php
   :linenos:

   ...
   $pdf = ZendPdf\Pdf::load($documentPath);
   ...
   // Alle Schriften des Dokuments bekommen
   $fontList = $pdf->extractFonts();
   $pdf->pages[] = ($page = $pdf->newPage(ZendPdf\Page::SIZE_A4));
   $yPosition = 700;
   foreach ($fontList as $font) {
       $page->setFont($font, 15);
       $fontName = $font->getFontName(ZendPdf\Font::NAME_POSTSCRIPT,
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

.. _zendpdf.drawing.extracting-fonts.example-2:

.. rubric:: Eine Schrift von einem geladenen Dokument extrahieren durch die Angabe des Schriftnamens

.. code-block:: php
   :linenos:

   ...
   $pdf = new ZendPdf\Pdf();
   ...
   $pdf->pages[] = ($page = $pdf->newPage(ZendPdf\Page::SIZE_A4));

   $font = ZendPdf\Font::fontWithPath($fontPath);
   $page->setFont($font, $fontSize);
   $page->drawText($text, $x, $y);
   ...
   // Diese Schrift sollte woanders gespeichert werden...
   $fontName = $font->getFontName(ZendPdf\Font::NAME_POSTSCRIPT,
                                  'en',
                                  'UTF-8');
   ...
   $pdf->save($docPath);
   ...

.. code-block:: php
   :linenos:

   ...
   $pdf = ZendPdf\Pdf::load($docPath);
   ...
   $pdf->pages[] = ($page = $pdf->newPage(ZendPdf\Page::SIZE_A4));

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
        $originalFont = ZendPdf\Font::fontWithPath($fontPath);

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



.. _zendpdf.drawing.image-drawing:

Zeichnen von Grafiken
---------------------

Die ``ZendPdf\Page`` Klasse stellt die drawImage() Methode für das Zeichnen von Grafiken bereit:

.. code-block:: php
   :linenos:

   /**
    * Zeichne eine Grafik an der angegebenen Position der Seite.
    *
    * @param ZendPdf\Ressource\Image $image
    * @param float $x1
    * @param float $y1
    * @param float $x2
    * @param float $y2
    * @return ZendPdf\Page
    */
   public function drawImage(ZendPdf\Ressource\Image $image, $x1, $y1, $x2, $y2);

Grafikobjekte sollten mit der Methode ``ZendPdf\Image::imageWithPath($filePath)`` erzeugt werden. (Es werden zur
Zeit JPG, PNG und TIFF Grafiken unterstützt):

.. _zendpdf.drawing.image-drawing.example-1:

.. rubric:: Zeichnen von Grafiken

.. code-block:: php
   :linenos:

   ...
   // Lade die Grafik
   $image = ZendPdf\Image::imageWithPath('my_image.jpg');

   $pdfPage->drawImage($image, 100, 100, 400, 300);
   ...

**Wichtig! JPG Support setzt voraus, dass die GD Erweiterung für PHP konfiguriert wurde.** **Wichtig! PNG Support
setzt voraus, dass die ZLIB Erweiterung konfiguriert wurde, um mit Grafiken mit Alphakanal zu arbeiten.**

Wende dich an die *PHP* Dokumentation für weitere Informationen (`http://www.php.net/manual/de/ref.image.php`_).
(`http://www.php.net/manual/de/ref.zlib.php`_).

.. _zendpdf.drawing.line-drawing-style:

Stil der Strichzeichnungen
--------------------------

Der Stil der Strichzeichnungen wurd durch die Linienbreite, die Linienfarbe und das Strichmuster definiert. Alle
diese Parameter können an die Klassenmethoden von ``ZendPdf\Page`` übergeben werden:

.. code-block:: php
   :linenos:

   /** Setze die Linienfarbe. */
   public function setLineColor(ZendPdf\Color $color);

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
    * @return ZendPdf\Page
    */
   public function setLineDashingPattern($pattern, $phase = 0);

.. _zendpdf.drawing.fill-style:

Füllstil
--------

Die Methoden ``ZendPdf\Page::drawRectangle()``, ``ZendPdf\Page::drawPolygon()``, ``ZendPdf\Page::drawCircle()``
und ``ZendPdf\Page::drawEllipse()`` akzeptieren das ``$fillType`` Argument als optionalen Parameter. Es kann
lauten:

- ZendPdf\Page::SHAPE_DRAW_STROKE - strichele die Form

- ZendPdf\Page::SHAPE_DRAW_FILL - fülle die Form

- ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE - fülle und strichele die Form (Standardverhalten)

Die ``ZendPdf\Page::drawPolygon()`` Methode akzeptiert ``$fillMethod`` als zusätzlichen Parameter:

- ZendPdf\Page::FILL_METHOD_NON_ZERO_WINDING (Standardverhalten)

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



- ZendPdf\Page::FILL_METHOD_EVEN_ODD

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



.. _zendpdf.drawing.linear-transformations:

Lineare Transformationen
------------------------

.. _zendpdf.drawing.linear-transformations.rotations:

Drehungen
^^^^^^^^^

Bevor eine Zeichenoperation angewendet wird, können *PDF* Seiten gedreht werden. Dies kann mit Hilfe der
``ZendPdf\Page::rotate()`` Methode durchgeführt werden:

.. code-block:: php
   :linenos:

   /**
    * Drehe die Seite
    *
    * @param float $x - die X Koordinate des Rotationspunktes
    * @param float $y - die Y Koordinate des Rotationspunktes
    * @param float $angle - der Rotationswinkel
    * @return ZendPdf\Page
    */
   public function rotate($x, $y, $angle);

.. _zendpdf.drawing.linear-transformations.scale:

Beginnend mit ZF 1.8, Skalierung
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Skalenänderungen werden durch die ``ZendPdf\Page::scale()`` Methode angeboten:

.. code-block:: php
   :linenos:

   /**
    * Koordinationssystem für die Skala
    *
    * @param float $xScale - Skalierungsfaktor für die X Dimension
    * @param float $yScale - Skalierungsfaktor für die Y Dimension
    * @return ZendPdf\Page
    */
   public function scale($xScale, $yScale);

.. _zendpdf.drawing.linear-transformations.translate:

Beginnend mit ZF 1.8, Bewegungen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Das bewegen des Koordinationssystem wird von der ``ZendPdf\Page::translate()`` Methode durchgeführt:

.. code-block:: php
   :linenos:

   /**
    * Bewegen des Koordinationssystems
    *
    * @param float $xShift - X Koordinate für die Bewegung
    * @param float $yShift - Y Koordinate für die Bewegung
    * @return ZendPdf\Page
    */
   public function translate($xShift, $yShift);

.. _zendpdf.drawing.linear-transformations.skew:

Beginnend mit ZF 1.8, Drehungen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Das Drehen der Seite kann durch Verwendung der ``ZendPdf\Page::skew()`` Methode durchgeführt werden:

.. code-block:: php
   :linenos:

   /**
    * Bewegen des Koordinationssystems
    *
    * @param float $x  - Die X Koordinate des Achsen-Drehpunktes
    * @param float $y  - Die Y Koordinate des Achsen-Drehpunktes
    * @param float $xAngle - X Winkel der Achse
    * @param float $yAngle - Y Winkel der Achse
    * @return ZendPdf\Page
    */
   public function skew($x, $y, $xAngle, $yAngle);

.. _zendpdf.drawing.save-restore:

Speichern/Wiederherstellen des Grafikzustand
--------------------------------------------

Jederzeit kann der Grafikzustand der Seite (aktueller Zeichensatz, Schriftgröße, Linienfarbe, Füllfarbe,
Linienstil, Seitendrehung, Zeichenbereich) gespeichert und wiederhergestellt werden. Speicheroperationen legen die
Daten auf einen Grafikzustand Stapel, Wiederherstelloperationen holen Sie daher zurück.

In der ``ZendPdf\Page`` Klasse gibt es für diese Operationen zwei Methoden:

.. code-block:: php
   :linenos:

   /**
    * Speichere den Grafikzustand dieser Seite.
    * Es wir ein Schnappschuss vom aktuell festgelegten Stil, Position,
    * Zeichenbereich und jeder festgelegten Drehung/Umrechnung/Skalierung
    * erstellt.
    *
    * @return ZendPdf\Page
    */
   public function saveGS();

   /**
    * Stelle den Grafikzustand wieder her, der mit dem letzten Aufruf von
    * saveGS() gespeichert wurde
    *
    * @return ZendPdf\Page
    */
   public function restoreGS();

.. _zendpdf.drawing.clipping:

Zeichenbereich
--------------

*PDF* und die ``ZendPdf`` Komponente unterstützen die Begrenzung des Zeichenbereichs. Der aktuelle Zeichenbereich
begrenzt den Seitenbereich, der von Zeichenoperationen beeinflusst werden kann. Zu Beginn ist dies die gesamte
Seite.

Die ``ZendPdf\Page`` Klasse stellt einen Satz von Methoden für die Begrenzung bereit.

.. code-block:: php
   :linenos:

   /**
    * Durchschneide den aktuellen Zeichenbereich mit einem Rechteck.
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
    * Durchschneide den aktuellen Zeichenbereich mit einem Polygon.
    *
    * @param array $x  - Array mit Floats (die X Koordinaten der Eckpunkte)
    * @param array $y  - Array mit Floats (die Y Koordinaten der Eckpunkte)
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
    * Durchschneide den aktuellen Zeichenbereich mit einem Kreis.
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
    * @return ZendPdf\Page
    */
   public function clipEllipse($x1,
                               $y1,
                               $x2,
                               $y2,
                               $startAngle = null,
                               $endAngle = null);

.. _zendpdf.drawing.styles:

Stile
-----

Die ``ZendPdf\Style`` Klasse stellt Stilfunktionalitäten bereit.

Stile können verwendet werden, um mit einer Operation die Parameter für den Grafikzustand zu speichern und auf
eine *PDF* Seite anzuwenden:

.. code-block:: php
   :linenos:

   /**
    * Lege den Stil für zukünftige Zeichenoperationen auf dieser Seite fest
    *
    * @param ZendPdf\Style $style
    * @return ZendPdf\Page
    */
   public function setStyle(ZendPdf\Style $style);

   /**
    * Gebe den Stil der Seite zurück.
    *
    * @return ZendPdf\Style|null
    */
   public function getStyle();

Die ``ZendPdf\Style`` Klasse stellt einen Satz von Methoden bereit, um verschiedene Parameter des Grafikstadiums
zu setzen und zu holen:

.. code-block:: php
   :linenos:

   /**
    * Setze die Linienfarbe.
    *
    * @param ZendPdf\Color $color
    * @return ZendPdf\Page
    */
   public function setLineColor(ZendPdf\Color $color);

.. code-block:: php
   :linenos:

   /**
    * Hole die Linienfarbe.
    *
    * @return ZendPdf\Color|null
    */
   public function getLineColor();

.. code-block:: php
   :linenos:

   /**
    * Setze die Linienbreite.
    *
    * @param float $width
    * @return ZendPdf\Page
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
    * @return ZendPdf\Page
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
    * @param ZendPdf\Color $color
    * @return ZendPdf\Page
    */
   public function setFillColor(ZendPdf\Color $color);

.. code-block:: php
   :linenos:

   /**
    * Hole die Füllfarbe.
    *
    * @return ZendPdf\Color|null
    */
   public function getFillColor();

.. code-block:: php
   :linenos:

   /**
    * Ändere den Zeichensatz.
    *
    * @param ZendPdf\Resource\Font $font
    * @param float $fontSize
    * @return ZendPdf\Page
    */
   public function setFont(ZendPdf\Resource\Font $font, $fontSize);

.. code-block:: php
   :linenos:

   /**
    * Ändere die Schriftgröße
    *
    * @param float $fontSize
    * @return ZendPdf\Page
    */
   public function setFontSize($fontSize);

.. code-block:: php
   :linenos:

   /**
    * Hole den Zeichensatz.
    *
    * @return ZendPdf\Resource\Font $font
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

.. _zendpdf.drawing.alpha:

Transparenz
-----------

Das ``ZendPdf`` Modul unterstützt die Handhabung von Transparenz.

Transparenz kann durch Verwendung der ``ZendPdf\Page::setAlpha()`` Methode gesetzt werden:

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
    * @throws ZendPdf\Exception
    * @return ZendPdf\Page
    */
   public function setAlpha($alpha, $mode = 'Normal');



.. _`iconv()`: http://www.php.net/manual/function.iconv.php
.. _`PDF Reference, Sixth Edition, version 1.7`: http://www.adobe.com/devnet/acrobat/pdfs/pdf_reference_1-7.pdf
.. _`http://www.php.net/manual/de/ref.image.php`: http://www.php.net/manual/de/ref.image.php
.. _`http://www.php.net/manual/de/ref.zlib.php`: http://www.php.net/manual/de/ref.zlib.php
