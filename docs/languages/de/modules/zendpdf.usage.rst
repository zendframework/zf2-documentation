.. EN-Revision: none
.. _zendpdf.usage:

Anwendungsbeispiel für die ZendPdf Komponente
==============================================

Dieser Abschnitt stellt ein Beispiel für die Anwendung der Komponente bereit.

Das Beispiel kann in der Datei ``demos/Zend/Pdf/demo.php`` gefunden werden.

Dort gibt es auch die Datei ``test.pdf``, die für diese Demo zu Testzwecken verwendet werden kann.

.. _zendpdf.usage.example-1:

.. rubric:: Anwendungsbeispiel für die ZendPdf Komponente

.. code-block:: php
   :linenos:

   if (!isset($argv[1])) {
       echo "VERWENDUNG: php demo.php <pdf_file> [<output_pdf_file>]\n";
       exit;
   }

   try {
       $pdf = ZendPdf\PdfDocument::load($argv[1]);
   } catch (ZendPdf\Exception $e) {
       if ($e->getMessage() == 'Datei \'' . $argv[1] .
                               '\' konnte nicht zum Lesen geöffnet werden.') {
           // Erstelle neues PDF, wenn Datei nicht existiert
           $pdf = new ZendPdf\PdfDocument();

           if (!isset($argv[2])) {
               // Erzwinge komplettes neu schreiben der Datei (statt nur updaten)
               $argv[2] = $argv[1];
           }
       } else {
           // Werfe eine Ausnahme, wenn es nicht die "Can't open file"
           // Exception ist
           throw $e;
       }
   }

   //------------------------------------------------------------------------
   // Kehre die Seitenreihenfolge um
   $pdf->pages = array_reverse($pdf->pages);

   // Erstelle einen neuen Stil
   $style = new ZendPdf\Style();
   $style->setFillColor(new ZendPdf\Color\Rgb(0, 0, 0.9));
   $style->setLineColor(new ZendPdf\Color\GrayScale(0.2));
   $style->setLineWidth(3);
   $style->setLineDashingPattern(array(3, 2, 3, 4), 1.6);
   $fontH = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_HELVETICA_BOLD);
   $style->setFont($fontH, 32);

   try {
       // Erstelle ein neues Grafikobjekt
       $imageFile = dirname(__FILE__) . '/stamp.jpg';
       $stampImage = ZendPdf\Image::imageWithPath($imageFile);
   } catch (ZendPdf\Exception $e) {
       // Beispiel wie man mit Ladefehlern bei Grafiken umgeht.
       if ($e->getMessage() != 'Image Erweiterung nicht installiert.' &&
           $e->getMessage() != 'JPG Unterstützung ist nicht richtig ' .
                               'konfiguriert.') {
           throw $e;
       }
       $stampImage = null;
   }

   // Kennzeichne Seiten als verändert
   foreach ($pdf->pages as $page){
       $page->saveGS()
            ->setAlpha(0,25)
            ->setStyle($style)
            ->rotate(0, 0, M_PI_2/3);

       $page->saveGS();
       $page->clipCircle(550, -10, 50);
       if ($stampImage != null) {
           $page->drawImage($stampImage, 500, -60, 600, 40);
       }
       $page->restoreGS();

       $page->drawText('Modified by Zend Framework!', 150, 0)
            ->restoreGS();
   }

   // Erstelle eine neue Seite mit Hilfe des ZendPdf Objekts
   // (die Seite wird an das angegebene Dokument angehängt)
   $pdf->pages[] = ($page1 = $pdf->newPage('A4'));

   // Erstelle eine neue Seite mit Hilfe des ZendPdf\Page Objekts
   // (die Seite wird nicht an das angegebene Dokument angehängt)
   $page2 = new ZendPdf\Page(ZendPdf\Page::SIZE_LETTER_LANDSCAPE);
   $pdf->pages[] = $page2;

   // Erstelle einen neuen Zeichensatz
   $font = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_HELVETICA);

   // Lege Zeichensatz fest und zeichnen einen text
   $page1->setFont($font, 36)
         ->setFillColor(ZendPdf\Color\Html::color('#9999cc'))
         ->drawText('Helvetica 36 text string', 60, 500);

   // Verwende das Zeichensatz Objekt für eine andere Seite
   $page2->setFont($font, 24)
         ->drawText('Helvetica 24 text string', 60, 500);

   // Verwenden einen anderen Zeichensatz
   $fontT = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_TIMES);
   $page2->setFont($fontT, 32)
         ->drawText('Times-Roman 32 text string', 60, 450);

   // Zeichne ein Rechteck
   $page2->setFillColor(new ZendPdf\Color\GrayScale(0.8))
         ->setLineColor(new ZendPdf\Color\GrayScale(0.2))
         ->setLineDashingPattern(array(3, 2, 3, 4), 1.6)
         ->drawRectangle(60, 400, 400, 350);

   // Zeichne einen Kreis
   $page2->setLineDashingPattern(ZendPdf\Page::LINE_DASHING_SOLID)
         ->setFillColor(new ZendPdf\Color\Rgb(1, 0, 0))
         ->drawCircle(85, 375, 25);

   // Zeichne Kreisausschnitte
   $page2->drawCircle(200, 375, 25, 2*M_PI/3, -M_PI/6)
         ->setFillColor(new ZendPdf\Color\Cmyk(1, 0, 0, 0))
         ->drawCircle(200, 375, 25, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf\Color\Rgb(1, 1, 0))
         ->drawCircle(200, 375, 25, -M_PI/6, M_PI/6);

   // Zeichne Ellipsen
   $page2->setFillColor(new ZendPdf\Color\Rgb(1, 0, 0))
         ->drawEllipse(250, 400, 400, 350)
         ->setFillColor(new ZendPdf\Color\Cmyk(1, 0, 0, 0))
         ->drawEllipse(250, 400, 400, 350, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf\Color\Rgb(1, 1, 0))
         ->drawEllipse(250, 400, 400, 350, -M_PI/6, M_PI/6);

   // Zeichne und fülle ein Polygon
   $page2->setFillColor(new ZendPdf\Color\Rgb(1, 0, 1));
   $x = array();
   $y = array();
   for ($count = 0; $count < 8; $count++) {
       $x[] = 140 + 25*cos(3*M_PI_4*$count);
       $y[] = 375 + 25*sin(3*M_PI_4*$count);
   }
   $page2->drawPolygon($x, $y,
                       ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE,
                       ZendPdf\Page::FILL_METHOD_EVEN_ODD);

   // ----------- Zeichne Figuren in einem modifizierten Koordinatensystem --

   // Bewegung des Koordinatensystems
   $page2->saveGS();
   $page2->translate(60, 250); // Wechle das Koordinatensystem

   // Ein Rechteck zeichnen
   $page2->setFillColor(new ZendPdf\Color\GrayScale(0.8))
         ->setLineColor(new ZendPdf\Color\GrayScale(0.2))
         ->setLineDashingPattern(array(3, 2, 3, 4), 1.6)
         ->drawRectangle(0, 50, 340, 0);

   // Einen Kreis zeichnen
   $page2->setLineDashingPattern(ZendPdf\Page::LINE_DASHING_SOLID)
         ->setFillColor(new ZendPdf\Color\Rgb(1, 0, 0))
         ->drawCircle(25, 25, 25);

   // Einen Kreisausschnitt zeichnen
   $page2->drawCircle(140, 25, 25, 2*M_PI/3, -M_PI/6)
         ->setFillColor(new ZendPdf\Color\Cmyk(1, 0, 0, 0))
         ->drawCircle(140, 25, 25, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf\Color\Rgb(1, 1, 0))
         ->drawCircle(140, 25, 25, -M_PI/6, M_PI/6);

   // Eine Ellipse zeichnen
   $page2->setFillColor(new ZendPdf\Color\Rgb(1, 0, 0))
         ->drawEllipse(190, 50, 340, 0)
         ->setFillColor(new ZendPdf\Color\Cmyk(1, 0, 0, 0))
         ->drawEllipse(190, 50, 340, 0, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf\Color\Rgb(1, 1, 0))
         ->drawEllipse(190, 50, 340, 0, -M_PI/6, M_PI/6);

   // Ein Poligon zeichnen und füllen
   $page2->setFillColor(new ZendPdf\Color\Rgb(1, 0, 1));
   $x = array();
   $y = array();
   for ($count = 0; $count < 8; $count++) {
       $x[] = 80 + 25*cos(3*M_PI_4*$count);
       $y[] = 25 + 25*sin(3*M_PI_4*$count);
   }
   $page2->drawPolygon($x, $y,
                       ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE,
                       ZendPdf\Page::FILL_METHOD_EVEN_ODD);

   // Zeichne eine Linie
   $page2->setLineWidth(0.5)
         ->drawLine(60, 375, 400, 375);

   $page2->restoreGS();

   // Wechsel des Koordinationssystems, drehen und skalieren
   $page2->saveGS();
   $page2->translate(60, 150)     // Wechseln des Koordinationssystems
         ->skew(0, 0, 0, -M_PI/9) // Drehen des Koordinationssystems
         ->scale(0.9, 0.9);       // Skalieren des Koordinationssystems

   // Rechteck zeichnen
   $page2->setFillColor(new ZendPdf\Color\GrayScale(0.8))
         ->setLineColor(new ZendPdf\Color\GrayScale(0.2))
         ->setLineDashingPattern(array(3, 2, 3, 4), 1.6)
         ->drawRectangle(0, 50, 340, 0);

   // Kreis zeichnen
   $page2->setLineDashingPattern(ZendPdf\Page::LINE_DASHING_SOLID)
         ->setFillColor(new ZendPdf\Color\Rgb(1, 0, 0))
         ->drawCircle(25, 25, 25);

   // Kreisausschnitt zeichnen
   $page2->drawCircle(140, 25, 25, 2*M_PI/3, -M_PI/6)
         ->setFillColor(new ZendPdf\Color\Cmyk(1, 0, 0, 0))
         ->drawCircle(140, 25, 25, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf\Color\Rgb(1, 1, 0))
         ->drawCircle(140, 25, 25, -M_PI/6, M_PI/6);

   // Ellipse zeichnen
   $page2->setFillColor(new ZendPdf\Color\Rgb(1, 0, 0))
         ->drawEllipse(190, 50, 340, 0)
         ->setFillColor(new ZendPdf\Color\Cmyk(1, 0, 0, 0))
         ->drawEllipse(190, 50, 340, 0, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf\Color\Rgb(1, 1, 0))
         ->drawEllipse(190, 50, 340, 0, -M_PI/6, M_PI/6);

   // Poligon zeichnen und ausfüllen
   $page2->setFillColor(new ZendPdf\Color\Rgb(1, 0, 1));
   $x = array();
   $y = array();
   for ($count = 0; $count < 8; $count++) {
       $x[] = 80 + 25*cos(3*M_PI_4*$count);
       $y[] = 25 + 25*sin(3*M_PI_4*$count);
   }
   $page2->drawPolygon($x, $y,
                       ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE,
                       ZendPdf\Page::FILL_METHOD_EVEN_ODD);

   // Linie zeichnen
   $page2->setLineWidth(0.5)
         ->drawLine(0, 25, 340, 25);

   $page2->restoreGS();

   //------------------------------------------------------------------------

   if (isset($argv[2])) {
       $pdf->save($argv[2]);
   } else {
       $pdf->save($argv[1], true /* Aktualisierung */);
   }


