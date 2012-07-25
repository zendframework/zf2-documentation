.. _zend.pdf.usage:

Przykład użycia modułu Zend_Pdf
===============================

Ta sekcja pokazuje przykład użycia modułu Zend_Pdf

Ten przykład można znaleźć w pliku ``demos/Zend/Pdf/demo.php``.

Jest tam także plik ``test.pdf``, który może być użyty z tym przykładem .

.. _zend.pdf.usage.example-1:

.. rubric:: Przykład użycia modułu Zend_Pdf

.. code-block:: php
   :linenos:

   /**
    * @package Zend_Pdf
    * @subpackage demo
    */

   if (!isset($argv[1])) {
       echo "UŻYCIE: php demo.php <pdf_file> [<output_pdf_file>]\n";
       exit;
   }

   try {
       $pdf = Zend_Pdf::load($argv[1]);
   } catch (Zend_Pdf_Exception $e) {
       if ($e->getMessage() == 'Can not open \'' . $argv[1] .
                               '\' file for reading.') {
           // Utworzenie nowego pliku PDF jeśli plik nie istnieje
           $pdf = new Zend_Pdf();

           if (!isset($argv[2])) {
               // Całkowicie nadpisujemy plik (zamiast aktualizować)
               $argv[2] = $argv[1];
           }
       } else {
           // Wyrzucenie wyjątku jeśli nie był to wyjątek
           // "Can't open file"
           throw $e;
       }
   }

   //--------------------------------------------------------------------
   // Odwrócenie kolejności stron
   $pdf->pages = array_reverse($pdf->pages);

   // Utworzenie nowego stylu
   $style = new Zend_Pdf_Style();
   $style->setFillColor(new Zend_Pdf_Color_Rgb(0, 0, 0.9));
   $style->setLineColor(new Zend_Pdf_Color_GrayScale(0.2));
   $style->setLineWidth(3);
   $style->setLineDashingPattern(array(3, 2, 3, 4), 1.6);
   $style->setFont(Zend_Pdf_Font::fontWithName(
                       Zend_Pdf_Font::FONT_HELVETICA_BOLD), 32
                   );

   try {
       // Utworzenie obiektu obrazka
       $stampImage = Zend_Pdf_Image::imageWithPath(dirname(__FILE__) .
                                                   '/stamp.jpg');
   } catch (Zend_Pdf_Exception $e) {
       // Przykład obsłużenia wyjątków podczas ładowania obrazków
       if ($e->getMessage() != 'Image extension is not installed.' &&
           $e->getMessage() != 'JPG support is not configured properly.') {
           throw $e;
       }
       $stampImage = null;
   }

   // Oznaczenie stron jako zmodyfikowanych
   foreach ($pdf->pages as $page){
       $page->saveGS();
       $page->setAlpha(0.25);
       $page->setStyle($style);
       $page->rotate(0, 0, M_PI_2/3);

       $page->saveGS();
       $page->clipCircle(550, -10, 50);
       if ($stampImage != null) {
           $page->drawImage($stampImage, 500, -60, 600, 40);
       }
       $page->restoreGS();

       $page->drawText('Zmodyfikowane przez Zend Framework!', 150, 0);
       $page->restoreGS();
   }

   // Dodanie nowej strony wygenerowanej przez obiekt
   // Zend_Pdf (strona jest dołączona do dokumentu)
   $pdf->pages[] = ($page1 = $pdf->newPage('A4'));

   // Dodanie nowej strony wygenerowanej przez obiekt
   // Zend_Pdf_Page (strona nie jest dołączona do dokumentu)
   $pdf->pages[] =
       ($page2 = new Zend_Pdf_Page(Zend_Pdf_Page::SIZE_LETTER_LANDSCAPE));

   // Utworzenie nowej czcionki
   $font = Zend_Pdf_Font::fontWithName(Zend_Pdf_Font::FONT_HELVETICA);

   // Ustawienie czcionki i wypisanie tekstu
   $page1->setFont($font, 36);
   $page1->drawText('Helvetica 36 text string', 60, 500);

   // Użycie obiektu czcionki dla innej strony
   $page2->setFont($font, 24);
   $page2->drawText('Helvetica 24 text string', 60, 500);

   // Użycie innej czcionki
   $page2->setFont(
       Zend_Pdf_Font::fontWithName(Zend_Pdf_Font::FONT_TIMES_ROMAN), 32
   );
   $page2->drawText('Times-Roman 32 text string', 60, 450);

   // Narysowanie prostokąta
   $page2->setFillColor(new Zend_Pdf_Color_GrayScale(0.8));
   $page2->setLineColor(new Zend_Pdf_Color_GrayScale(0.2));
   $page2->setLineDashingPattern(array(3, 2, 3, 4), 1.6);
   $page2->drawRectangle(60, 400, 400, 350);

   // Narysowanie okręgu
   $page2->setLineDashingPattern(Zend_Pdf_Page::LINE_DASHING_SOLID);
   $page2->setFillColor(new Zend_Pdf_Color_Rgb(1, 0, 0));
   $page2->drawCircle(85, 375, 25);

   // Narysowanie sektorów
   $page2->drawCircle(200, 375, 25, 2*M_PI/3, -M_PI/6);
   $page2->setFillColor(new Zend_Pdf_Color_Cmyk(1, 0, 0, 0));
   $page2->drawCircle(200, 375, 25, M_PI/6, 2*M_PI/3);
   $page2->setFillColor(new Zend_Pdf_Color_Rgb(1, 1, 0));
   $page2->drawCircle(200, 375, 25, -M_PI/6, M_PI/6);

   // Narysowanie elipsy
   $page2->setFillColor(new Zend_Pdf_Color_Rgb(1, 0, 0));
   $page2->drawEllipse(250, 400, 400, 350);
   $page2->setFillColor(new Zend_Pdf_Color_Cmyk(1, 0, 0, 0));
   $page2->drawEllipse(250, 400, 400, 350, M_PI/6, 2*M_PI/3);
   $page2->setFillColor(new Zend_Pdf_Color_Rgb(1, 1, 0));
   $page2->drawEllipse(250, 400, 400, 350, -M_PI/6, M_PI/6);

   // Narysowanie i wypełnienie wielokąta
   $page2->setFillColor(new Zend_Pdf_Color_Rgb(1, 0, 1));
   $x = array();
   $y = array();
   for ($count = 0; $count < 8; $count++) {
       $x[] = 140 + 25*cos(3*M_PI_4*$count);
       $y[] = 375 + 25*sin(3*M_PI_4*$count);
   }
   $page2->drawPolygon($x, $y,
                       Zend_Pdf_Page::SHAPE_DRAW_FILL_AND_STROKE,
                       Zend_Pdf_Page::FILL_METHOD_EVEN_ODD);

   // Narysowanie linii
   $page2->setLineWidth(0.5);
   $page2->drawLine(60, 375, 400, 375);
   //--------------------------------------------------------------------

   if (isset($argv[2])) {
       $pdf->save($argv[2]);
   } else {
       $pdf->save($argv[1], true /* uaktualniamy */);
   }



