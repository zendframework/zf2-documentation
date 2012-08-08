.. EN-Revision: none
.. _zend.pdf.usage:

Een gebruiksvoorbeeld voor de Zend_Pdf module
=============================================

Deze sectie geeft een voorbeeld van het gebruik van de Zend_Pdf module.

Dit voorbeeld kan teruggevonden worden in een ``demos/Zend/Pdf/demo.php`` bestand.

Er is ook een ``test.pdf`` bestand dat met dit voorbeeld kan gebruikt worden om te testen.

.. rubric:: Zend_Pdf module voorbeeld

.. code-block:: php
   :linenos:

   <?php
   /**
    * @package Zend_Pdf
    * @subpackage demo
    */

   /** Zend_Pdf */
   require_once 'Zend/Pdf.php';

   if (!isset($argv[1])) {
       echo "USAGE: php demo.php <pdf_file> [<output_pdf_file>]\n";
       exit;
   }

   if (file_exists($argv[1])) {
       $pdf = Zend_Pdf::load($argv[1]);
   } else {
       $pdf = new Zend_Pdf();
   }

   //------------------------------------------------------------------------------------
   // Draai pagina orde om
   $pdf->pages = array_reverse($pdf->pages);

   // Maak een nieuwe stijl
   $style = new Zend_Pdf_Style();
   $style->setFillColor(new Zend_Pdf_Color_RGB(0, 0, 0.9));
   $style->setLineColor(new Zend_Pdf_Color_GrayScale(0.2));
   $style->setLineWidth(3);
   $style->setLineDashingPattern(array(3, 2, 3, 4), 1.6);
   $style->setFont(new Zend_Pdf_Font_Standard(Zend_Pdf_Const::FONT_HELVETICA_BOLD), 32);

   // Maak een nieuw beeldobject
   $stampImage = new Zend_Pdf_Image_JPEG(dirname(__FILE__) . '/stamp.jpg');

   // Markeer de pagina als gewijzigd
   foreach ($pdf->pages as $page){
       $page->saveGS();
       $page->setStyle($style);
       $page->rotate(0, 0, M_PI_2/3);

       $page->saveGS();
       $page->clipCircle(550, -10, 50);
       $page->drawImage($stampImage, 500, -60, 600, 40);
       $page->restoreGS();

       $page->drawText('Modified by Zend Framework!', 150, 0);
       $page->restoreGS();
   }

   // Voeg een door het Zend_Pdf object aangemaakte nieuwe pagina toe (de pagina wordt aan het
   // gespecificeerde document gelinkt)
   $pdf->pages[] = ($page1 = $pdf->newPage('A4'));

   // Voeg een door het Zend_Pdf_Page object aangemaakte pagina toe (de pagina is niet aan het
   // gespecificeerde document gelinkt)
   $pdf->pages[] = ($page2 = new Zend_Pdf_Page(Zend_Pdf_Const::PAGESIZE_LETTER_LANDSCAPE));

   // Maak een nieuw lettertype
   $font = new Zend_Pdf_Font_Standard(Zend_Pdf_Const::FONT_HELVETICA);

   // Maak het lettertype actief en schrijf tekst
   $page1->setFont($font, 36);
   $page1->drawText('Helvetica 36 text string', 60, 500);

   // Gebruik het lettertype object voor een andere pagina
   $page2->setFont($font, 24);
   $page2->drawText('Helvetica 24 text string', 60, 500);

   // Gebruik een ander lettertype
   $page2->setFont(new Zend_Pdf_Font_Standard(Zend_Pdf_Const::FONT_TIMES_ROMAN), 32);
   $page2->drawText('Times-Roman 32 text string', 60, 450);

   // Teken een rechthoek
   $page2->setFillColor(new Zend_Pdf_Color_GrayScale(0.8));
   $page2->setLineColor(new Zend_Pdf_Color_GrayScale(0.2));
   $page2->setLineDashingPattern(array(3, 2, 3, 4), 1.6);
   $page2->drawRectangle(60, 400, 400, 350);

   // Teken een cirkel
   $page2->setLineDashingPattern(Zend_Pdf_Const::LINEDASHING_SOLID);
   $page2->setFillColor(new Zend_Pdf_Color_RGB(1, 0, 0));
   $page2->drawCircle(85, 375, 25);

   // Teken sectoren
   $page2->drawCircle(200, 375, 25, 2*M_PI/3, -M_PI/6);
   $page2->setFillColor(new Zend_Pdf_Color_CMYK(1, 0, 0, 0));
   $page2->drawCircle(200, 375, 25, M_PI/6, 2*M_PI/3);
   $page2->setFillColor(new Zend_Pdf_Color_RGB(1, 1, 0));
   $page2->drawCircle(200, 375, 25, -M_PI/6, M_PI/6);

   // Teken een ellips
   $page2->setFillColor(new Zend_Pdf_Color_RGB(1, 0, 0));
   $page2->drawEllipse(250, 400, 400, 350);
   $page2->setFillColor(new Zend_Pdf_Color_CMYK(1, 0, 0, 0));
   $page2->drawEllipse(250, 400, 400, 350, M_PI/6, 2*M_PI/3);
   $page2->setFillColor(new Zend_Pdf_Color_RGB(1, 1, 0));
   $page2->drawEllipse(250, 400, 400, 350, -M_PI/6, M_PI/6);

   // Teken en vul een polygoon
   $page2->setFillColor(new Zend_Pdf_Color_RGB(1, 0, 1));
   $x = array();
   $y = array();
   for ($count = 0; $count < 8; $count++) {
       $x[] = 140 + 25*cos(3*M_PI_4*$count);
       $y[] = 375 + 25*sin(3*M_PI_4*$count);
   }
   $page2->drawPolygon($x, $y,
                       Zend_Pdf_Const::SHAPEDRAW_FILLNSTROKE,
                       Zend_Pdf_Const::FILLMETHOD_EVENODD);

   // Teken een lijn
   $page2->setLineWidth(0.5);
   $page2->drawLine(60, 375, 400, 375);
   //------------------------------------------------------------------------------------

   if (isset($argv[2])) {
       $pdf->save($argv[2]);
   } else {
       $pdf->save($argv[1], true /* update */);
   }


