.. EN-Revision: none
.. _zend.pdf.usage:

Exemple d'utilisation du module ZendPdf
========================================

Cette section propose un exemple d'utilisation du module ``ZendPdf``.

Le code source de l'exemple est disponible dans le fichier ``demos/Zend/Pdf/demo.php``.

Il y a aussi un fichier ``test.pdf``, qui peut être utilisé pour réaliser des tests.

.. _zend.pdf.usage.example-1:

.. rubric:: Exemple d'utilisation du module ZendPdf

.. code-block:: php
   :linenos:

   /**
    * @package ZendPdf
    * @subpackage demo
    */

   if (!isset($argv[1])) {
       echo "USAGE: php demo.php <pdf_file> [<output_pdf_file>]\n";
       exit;
   }

   try {
       $pdf = ZendPdf\Pdf::load($argv[1]);
   } catch (ZendPdf\Exception $e) {
       if ($e->getMessage() == 'Ouverture du fichier \''
                             . $argv[1]
                             . '\' impossible en lecture.') {
           // Create new PDF if file doesn't exist
           $pdf = new ZendPdf\Pdf();
           if (!isset($argv[2])) {
               // Force la ré-écriture complète du fichier
               // (plutôt qu'une mise à jour)
               $argv[2] = $argv[1];
           }
       } else {
           // Lève une exception si ce n'est pas l'exception
           // "Ouverture du fichier impossible"
           throw $e;
       }
   }

   //--------------------------------------------------------------------------
   // Inverse l'ordre des pages
   $pdf->pages = array_reverse($pdf->pages);

   // Crée un nouveau style
   $style = new ZendPdf\Style();
   $style->setFillColor(new ZendPdf_Color\RGB(0, 0, 0.9));
   $style->setLineColor(new ZendPdf_Color\GrayScale(0.2));
   $style->setLineWidth(3);
   $style->setLineDashingPattern(array(3, 2, 3, 4), 1.6);
   $style->setFont(ZendPdf\Font::fontWithName(
                       ZendPdf\Font::FONT_HELVETICA_BOLD), 32
                   );

   try {
       // Crée un nouvel objet image
       $stampImage = ZendPdf\Image::imageWithPath(dirname(__FILE__) .
                                                   '/stamp.jpg');
   } catch (ZendPdf\Exception $e) {
       // Exemple de gestion des exceptions lors du chargement d'image
       if ($e->getMessage() != 'Image extension is not installed.' &&
           $e->getMessage() != 'JPG support is not configured properly.') {
           throw $e;
       }
       $stampImage = null;
   }

   // Marque la page comme modifiée
   foreach ($pdf->pages as $page){
       $page->saveGS()
            ->setAlpha(0.25)
            ->setStyle($style)
            ->rotate(0, 0, M_PI_2/3);

       $page->saveGS();
       $page->setAlpha(0.25);
       $page->clipCircle(550, -10, 50);
       if ($stampImage != null) {
           $page->drawImage($stampImage, 500, -60, 600, 40);
       }
       $page->restoreGS();

       $page->drawText('Modified by Zend Framework!', 150, 0);
       $page->restoreGS();
   }

   // Ajoute une nouvelle page générée par l'objet ZendPdf
   // (la page est attachée au document)
   $pdf->pages[] = ($page1 = $pdf->newPage('A4'));

   // Ajoute une nouvelle page générée par l'objet ZendPdf
   // (la page n'est pas attachée au document)
   $pdf->pages[] =
       ($page2 = new ZendPdf\Page(ZendPdf\Page::SIZE_LETTER_LANDSCAPE));

   // Crée une nouvelle police
   $font = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_HELVETICA);

   // Applique la police et dessine du texte
   $page1->setFont($font, 36)
         ->setFillColor(ZendPdf_Color\Html::color('#9999cc')
         ->drawText('Helvetica 36 text string', 60, 500);

   // Utilise la police dans une autre page
   $page2->setFont($font, 24)
         ->drawText('Helvetica 24 text string', 60, 500);

   // Utilise une autre police
   $page2->setFont(ZendPdf\Font::fontWithName(
                           ZendPdf\Font::FONT_TIMES_ROMAN), 32)
         ->drawText('Times-Roman 32 text string', 60, 450);

   // Dessine un rectangle
   $page2->setFillColor(new ZendPdf_Color\GrayScale(0.8))
         ->setLineColor(new ZendPdf_Color\GrayScale(0.2))
         ->setLineDashingPattern(array(3, 2, 3, 4), 1.6)
         ->drawRectangle(60, 400, 400, 350);

   // Dessine un cercle
   $page2->setLineDashingPattern(ZendPdf\Page::LINE_DASHING_SOLID)
         ->setFillColor(new ZendPdf_Color\RGB(1, 0, 0))
         ->drawCircle(85, 375, 25);

   // Dessine des secteurs
   $page2->drawCircle(200, 375, 25, 2*M_PI/3, -M_PI/6)
         ->setFillColor(new ZendPdf_Color\CMYK(1, 0, 0, 0))
         ->drawCircle(200, 375, 25, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\RGB(1, 1, 0))
         ->drawCircle(200, 375, 25, -M_PI/6, M_PI/6);

   // Dessine des ellipses
   $page2->setFillColor(new ZendPdf_Color\RGB(1, 0, 0))
         ->drawEllipse(250, 400, 400, 350)
         ->setFillColor(new ZendPdf_Color\CMYK(1, 0, 0, 0))
         ->drawEllipse(250, 400, 400, 350, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\RGB(1, 1, 0))
         ->drawEllipse(250, 400, 400, 350, -M_PI/6, M_PI/6);

   // Dessine et remplit un polygone
   $page2->setFillColor(new ZendPdf_Color\RGB(1, 0, 1));
   $x = array();
   $y = array();
   for ($count = 0; $count < 8; $count++) {
       $x[] = 140 + 25*cos(3*M_PI_4*$count);
       $y[] = 375 + 25*sin(3*M_PI_4*$count);
   }
   $page2->drawPolygon($x, $y,
                       ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE,
                       ZendPdf\Page::FILL_METHOD_EVEN_ODD);

   // ----- Dessiner des figures dans un système de coordonnées modifiées -----

   // Mouvement du système de coordonnées
   $page2->saveGS();
   $page2->translate(60, 250); // Décalage du système de coordonnées

   // Dessine un rectangle
   $page2->setFillColor(new ZendPdf_Color\GrayScale(0.8))
         ->setLineColor(new ZendPdf_Color\GrayScale(0.2))
         ->setLineDashingPattern(array(3, 2, 3, 4), 1.6)
         ->drawRectangle(0, 50, 340, 0);

   // Dessine un cercle
   $page2->setLineDashingPattern(ZendPdf\Page::LINE_DASHING_SOLID)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawCircle(25, 25, 25);

   // Dessine des secteurs
   $page2->drawCircle(140, 25, 25, 2*M_PI/3, -M_PI/6)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawCircle(140, 25, 25, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawCircle(140, 25, 25, -M_PI/6, M_PI/6);

   // Dessine des ellipses
   $page2->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawEllipse(190, 50, 340, 0)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawEllipse(190, 50, 340, 0, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawEllipse(190, 50, 340, 0, -M_PI/6, M_PI/6);

   // Dessine et remplit un polygone
   $page2->setFillColor(new ZendPdf_Color\Rgb(1, 0, 1));
   $x = array();
   $y = array();
   for ($count = 0; $count < 8; $count++) {
       $x[] = 80 + 25*cos(3*M_PI_4*$count);
       $y[] = 25 + 25*sin(3*M_PI_4*$count);
   }
   $page2->drawPolygon($x, $y,
                       ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE,
                       ZendPdf\Page::FILL_METHOD_EVEN_ODD);

   // Dessine une ligne
   $page2->setLineWidth(0.5)
         ->drawLine(0, 25, 340, 25);

   $page2->restoreGS();

   // Mouvement du système de coordonnées, mise en biais et mise à l'échelle
   $page2->saveGS();
   $page2->translate(60, 150)     // Décalage du système de coordonnées
         ->skew(0, 0, 0, -M_PI/9) // Mise en biais du système de coordonnées
         ->scale(0.9, 0.9);       // Mise à l'échelle du système de coordonnées

   // Dessine un rectangle
   $page2->setFillColor(new ZendPdf_Color\GrayScale(0.8))
         ->setLineColor(new ZendPdf_Color\GrayScale(0.2))
         ->setLineDashingPattern(array(3, 2, 3, 4), 1.6)
         ->drawRectangle(0, 50, 340, 0);

   // Dessine un cercle
   $page2->setLineDashingPattern(ZendPdf\Page::LINE_DASHING_SOLID)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawCircle(25, 25, 25);

   // Dessine des secteurs
   $page2->drawCircle(140, 25, 25, 2*M_PI/3, -M_PI/6)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawCircle(140, 25, 25, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawCircle(140, 25, 25, -M_PI/6, M_PI/6);

   // Dessine des ellipses
   $page2->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawEllipse(190, 50, 340, 0)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawEllipse(190, 50, 340, 0, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawEllipse(190, 50, 340, 0, -M_PI/6, M_PI/6);

   // Dessine et remplit un polygone
   $page2->setFillColor(new ZendPdf_Color\Rgb(1, 0, 1));
   $x = array();
   $y = array();
   for ($count = 0; $count < 8; $count++) {
       $x[] = 80 + 25*cos(3*M_PI_4*$count);
       $y[] = 25 + 25*sin(3*M_PI_4*$count);
   }
   $page2->drawPolygon($x, $y,
                       ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE,
                       ZendPdf\Page::FILL_METHOD_EVEN_ODD);

   // Dessine une ligne
   $page2->setLineWidth(0.5)
         ->drawLine(0, 25, 340, 25);

   $page2->restoreGS();

   //--------------------------------------------------------------------------

   if (isset($argv[2])) {
       $pdf->save($argv[2]);
   } else {
       $pdf->save($argv[1], true ); /* met à jour */
   }


