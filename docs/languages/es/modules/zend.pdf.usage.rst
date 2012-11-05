.. EN-Revision: none
.. _zend.pdf.usage:

Ejemplo de Uso del módulo ZendPdf
==================================

Esta sección proporciona un ejemplo de uso del módulo.

Este ejemplo se puede encontrar en el archivo ``demos/Zend/Pdf/demo.php``.

También está el archivo ``test.pdf``, que puede ser usado con esta demo con fines de prueba.

.. _zend.pdf.usage.example-1:

.. rubric:: Demo de uso del módulo ZendPdf

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
       if ($e->getMessage() == 'Can not open \'' . $argv[1] .
                               '\' file for reading.') {
           // Crear un nuevo archivo PDF si no existe
           $pdf = new ZendPdf\Pdf();

           if (!isset($argv[2])) {
               // forzar una reescritura completa del archivo (en vez de actualizar)
               $argv[2] = $argv[1];
           }
       } else {
           // Arrojar una excepción si no es la excepción "Can't open file"
           throw $e;
       }
   }

   //------------------------------------------------------------------------
   // Invertir el orden de las páginas
   $pdf->pages = array_reverse($pdf->pages);

   // Crear un estilo(Style) nuevo
   $style = new ZendPdf\Style();
   $style->setFillColor(new ZendPdf_Color\Rgb(0, 0, 0.9));
   $style->setLineColor(new ZendPdf_Color\GrayScale(0.2));
   $style->setLineWidth(3);
   $style->setLineDashingPattern(array(3, 2, 3, 4), 1.6);
   $fontH = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_HELVETICA_BOLD);
   $style->setFont($fontH, 32);

   try {
       // Crear un nuevo objeto imagen
       $imageFile = dirname(__FILE__) . '/stamp.jpg';
       $stampImage = ZendPdf\Image::imageWithPath($imageFile);
   } catch (ZendPdf\Exception $e) {
       // Ejemplo de operación con excepciones de carga de imágenes.
       if ($e->getMessage() != 'Extensión de imagen no está instalada.' &&
           $e->getMessage() != 'El soporte a JPG no está configurado correctamente.') {
           throw $e;
       }
       $stampImage = null;
   }

   // Marcar la página como modificada
   foreach ($pdf->pages as $page){
       $page->saveGS()
            ->setAlpha(0.25)
            ->setStyle($style)
            ->rotate(0, 0, M_PI_2/3);

       $page->saveGS();
       $page->clipCircle(550, -10, 50);
       if ($stampImage != null) {
           $page->drawImage($stampImage, 500, -60, 600, 40);
       }
       $page->restoreGS();

       $page->drawText('Modificado por Zend Framework!', 150, 0)
            ->restoreGS();
   }

   // Agregar una nueva página generada por el objeto ZendPdf
   // (la página es agregada al documento especificado)
   $pdf->pages[] = ($page1 = $pdf->newPage('A4'));

   // Agregar una nueva página generada por el objeto ZendPdf\Page
   // (la página no es agregada al documento)
   $page2 = new ZendPdf\Page(ZendPdf\Page::SIZE_LETTER_LANDSCAPE);
   $pdf->pages[] = $page2;

   // Crear una fuente nueva
   $font = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_HELVETICA);

   // Aplicar la fuente y dibujar el texto
   $page1->setFont($font, 36)
         ->setFillColor(ZendPdf_Color\Html::color('#9999cc'))
         ->drawText('Helvetica 36 text string', 60, 500);

   // Usar el objeto fuente para otra página
   $page2->setFont($font, 24)
         ->drawText('Helvetica 24 text string', 60, 500);

   // Usar otra fuente
   $fontT = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_TIMES);
   $page2->setFont($fontT, 32)
         ->drawText('Times-Roman 32 text string', 60, 450);

   // Dibujar un rectángulo
   $page2->setFillColor(new ZendPdf_Color\GrayScale(0.8))
         ->setLineColor(new ZendPdf_Color\GrayScale(0.2))
         ->setLineDashingPattern(array(3, 2, 3, 4), 1.6)
         ->drawRectangle(60, 400, 400, 350);

   // Dibujar un círculo
   $page2->setLineDashingPattern(ZendPdf\Page::LINE_DASHING_SOLID)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawCircle(85, 375, 25);

   // Dibujar sectores
   $page2->drawCircle(200, 375, 25, 2*M_PI/3, -M_PI/6)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawCircle(200, 375, 25, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawCircle(200, 375, 25, -M_PI/6, M_PI/6);

   // Dibujar una elipse
   $page2->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawEllipse(250, 400, 400, 350)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawEllipse(250, 400, 400, 350, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawEllipse(250, 400, 400, 350, -M_PI/6, M_PI/6);

   // Dibujar y rellenar un polígono
   $page2->setFillColor(new ZendPdf_Color\Rgb(1, 0, 1));
   $x = array();
   $y = array();
   for ($count = 0; $count < 8; $count++) {
       $x[] = 140 + 25*cos(3*M_PI_4*$count);
       $y[] = 375 + 25*sin(3*M_PI_4*$count);
   }
   $page2->drawPolygon($x, $y,
                       ZendPdf\Page::SHAPE_DRAW_FILL_AND_STROKE,
                       ZendPdf\Page::FILL_METHOD_EVEN_ODD);

   // ----------- Draw figures in modified coordination system --------------

   // Movimineto del sistema de coordenadas
   $page2->saveGS();
   $page2->translate(60, 250); // Despalazamiento del sistema de coordenadas

   // Dibujar un rectángulo
   $page2->setFillColor(new ZendPdf_Color\GrayScale(0.8))
         ->setLineColor(new ZendPdf_Color\GrayScale(0.2))
         ->setLineDashingPattern(array(3, 2, 3, 4), 1.6)
         ->drawRectangle(0, 50, 340, 0);

   // Dibujar un círculo
   $page2->setLineDashingPattern(ZendPdf\Page::LINE_DASHING_SOLID)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawCircle(25, 25, 25);

   // Dibujar sectores
   $page2->drawCircle(140, 25, 25, 2*M_PI/3, -M_PI/6)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawCircle(140, 25, 25, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawCircle(140, 25, 25, -M_PI/6, M_PI/6);

   // Dibujar una elipse
   $page2->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawEllipse(190, 50, 340, 0)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawEllipse(190, 50, 340, 0, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawEllipse(190, 50, 340, 0, -M_PI/6, M_PI/6);

   // Dibujar y rellenar un polígono
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

   // Dibujar una línea
   $page2->setLineWidth(0.5)
         ->drawLine(0, 25, 340, 25);

   $page2->restoreGS();

   // Movimineto del sistema de coordenadas, sesgado y escalado
   $page2->saveGS();
   $page2->translate(60, 150)     // Despalazamiento del sistema de coordenadas
         ->skew(0, 0, 0, -M_PI/9) // Sesgar el sistema de coordenadas
         ->scale(0.9, 0.9);       // Escalar el sistema de coordenadas

   // Dibujar un rectángulo
   $page2->setFillColor(new ZendPdf_Color\GrayScale(0.8))
         ->setLineColor(new ZendPdf_Color\GrayScale(0.2))
         ->setLineDashingPattern(array(3, 2, 3, 4), 1.6)
         ->drawRectangle(0, 50, 340, 0);

   // Dibujar un círculo
   $page2->setLineDashingPattern(ZendPdf\Page::LINE_DASHING_SOLID)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawCircle(25, 25, 25);

   // Dibujar sectores
   $page2->drawCircle(140, 25, 25, 2*M_PI/3, -M_PI/6)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawCircle(140, 25, 25, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawCircle(140, 25, 25, -M_PI/6, M_PI/6);

   // Dibujar una elipse
   $page2->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawEllipse(190, 50, 340, 0)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawEllipse(190, 50, 340, 0, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawEllipse(190, 50, 340, 0, -M_PI/6, M_PI/6);

   // Dibujar y rellenar un polígono
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

   // Dibujar una línea
   $page2->setLineWidth(0.5)
         ->drawLine(0, 25, 340, 25);

   $page2->restoreGS();

   //------------------------------------------------------------------------

   if (isset($argv[2])) {
       $pdf->save($argv[2]);
   } else {
       $pdf->save($argv[1], true /* update */);
   }


