.. EN-Revision: none
.. _zend.pdf.usage:

ZendPdf モジュールの使用例
==================

この節では、モジュールの使用例を示します。

この例は、 ``demos/Zend/Pdf/demo.php`` にあります。

また ``test.pdf`` というファイルも含まれており、 このデモのテスト用に使用します。

.. _zend.pdf.usage.example-1:

.. rubric:: ZendPdf モジュールの使用例

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
           // ファイルが存在しない場合は新しい PDF を作成します
           $pdf = new ZendPdf\Pdf();

           if (!isset($argv[2])) {
               // ファイルを完全新規に作成しなおします (更新ではありません)
               $argv[2] = $argv[1];
           }
       } else {
           // "Can't open file" 以外の例外の場合はそのままスローします
           throw $e;
       }
   }

   //------------------------------------------------------------------------
   // ページの並び順を反転します
   $pdf->pages = array_reverse($pdf->pages);

   // 新しいスタイルを作成します
   $style = new ZendPdf\Style();
   $style->setFillColor(new ZendPdf_Color\Rgb(0, 0, 0.9));
   $style->setLineColor(new ZendPdf_Color\GrayScale(0.2));
   $style->setLineWidth(3);
   $style->setLineDashingPattern(array(3, 2, 3, 4), 1.6);
   $fontH = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_HELVETICA_BOLD);
   $style->setFont($fontH, 32);

   try {
       // 新しい画像オブジェクトを作成します。
       $imageFile = dirname(__FILE__) . '/stamp.jpg';
       $stampImage = ZendPdf\Image::imageWithPath($imageFile);
   } catch (ZendPdf\Exception $e) {
       // 画像読み込み時の例外処理の例
       if ($e->getMessage() != 'Image extension is not installed.' &&
           $e->getMessage() != 'JPG support is not configured properly.') {
           throw $e;
       }
       $stampImage = null;
   }

   // ページに修正マークをつけます
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

       $page->drawText('Modified by Zend Framework!', 150, 0)
            ->restoreGS();
   }

   // ZendPdf オブジェクトが作成した新しいページを追加します
   // (ページは、指定したドキュメントにアタッチされます)
   $pdf->pages[] = ($page1 = $pdf->newPage('A4'));

   // ZendPdf\Page オブジェクトが作成した新しいページを追加します
   // (ページは、ドキュメントにアタッチされません)
   $page2 = new ZendPdf\Page(ZendPdf\Page::SIZE_LETTER_LANDSCAPE);
   $pdf->pages[] = $page2;

   // 新しいフォントを作成します
   $font = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_HELVETICA);

   // フォントを適用してテキストを描画します
   $page1->setFont($font, 36)
         ->setFillColor(ZendPdf_Color\Html::color('#9999cc'))
         ->drawText('Helvetica 36 text string', 60, 500);

   // 別のページでフォントオブジェクトを使用します
   $page2->setFont($font, 24)
         ->drawText('Helvetica 24 text string', 60, 500);

   // 別のフォントを使用します
   $fontT = ZendPdf\Font::fontWithName(ZendPdf\Font::FONT_TIMES);
   $page2->setFont($fontT, 32)
         ->drawText('Times-Roman 32 text string', 60, 450);

   // 矩形を描画します
   $page2->setFillColor(new ZendPdf_Color\GrayScale(0.8))
         ->setLineColor(new ZendPdf_Color\GrayScale(0.2))
         ->setLineDashingPattern(array(3, 2, 3, 4), 1.6)
         ->drawRectangle(60, 400, 400, 350);

   // 円を描画します
   $page2->setLineDashingPattern(ZendPdf\Page::LINE_DASHING_SOLID)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawCircle(85, 375, 25);

   // 扇形を描画します
   $page2->drawCircle(200, 375, 25, 2*M_PI/3, -M_PI/6)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawCircle(200, 375, 25, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawCircle(200, 375, 25, -M_PI/6, M_PI/6);

   // 楕円を描画します
   $page2->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawEllipse(250, 400, 400, 350)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawEllipse(250, 400, 400, 350, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawEllipse(250, 400, 400, 350, -M_PI/6, M_PI/6);

   // 多角形を描画して塗りつぶします
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

   // ----------- 座標系を変更して図形を描画します --------------

   // 座標系を移動します
   $page2->saveGS();
   $page2->translate(60, 250); // 座標系の移動

   // 矩形を描画します
   $page2->setFillColor(new ZendPdf_Color\GrayScale(0.8))
         ->setLineColor(new ZendPdf_Color\GrayScale(0.2))
         ->setLineDashingPattern(array(3, 2, 3, 4), 1.6)
         ->drawRectangle(0, 50, 340, 0);

   // 円を描画します
   $page2->setLineDashingPattern(ZendPdf\Page::LINE_DASHING_SOLID)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawCircle(25, 25, 25);

   // 扇形を描画します
   $page2->drawCircle(140, 25, 25, 2*M_PI/3, -M_PI/6)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawCircle(140, 25, 25, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawCircle(140, 25, 25, -M_PI/6, M_PI/6);

   // 楕円を描画します
   $page2->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawEllipse(190, 50, 340, 0)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawEllipse(190, 50, 340, 0, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawEllipse(190, 50, 340, 0, -M_PI/6, M_PI/6);

   // 多角形を描画して塗りつぶします
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

   // 直線を描画します
   $page2->setLineWidth(0.5)
         ->drawLine(0, 25, 340, 25);

   $page2->restoreGS();

   // 座標系を移動し、傾け、倍率を変えます
   $page2->saveGS();
   $page2->translate(60, 150)     // 座標系を移動します
         ->skew(0, 0, 0, -M_PI/9) // 座標系を傾けます
         ->scale(0.9, 0.9);       // 座標系の倍率を変えます

   // 矩形を描画します
   $page2->setFillColor(new ZendPdf_Color\GrayScale(0.8))
         ->setLineColor(new ZendPdf_Color\GrayScale(0.2))
         ->setLineDashingPattern(array(3, 2, 3, 4), 1.6)
         ->drawRectangle(0, 50, 340, 0);

   // 円を描画します
   $page2->setLineDashingPattern(ZendPdf\Page::LINE_DASHING_SOLID)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawCircle(25, 25, 25);

   // 扇形を描画します
   $page2->drawCircle(140, 25, 25, 2*M_PI/3, -M_PI/6)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawCircle(140, 25, 25, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawCircle(140, 25, 25, -M_PI/6, M_PI/6);

   // 楕円を描画します
   $page2->setFillColor(new ZendPdf_Color\Rgb(1, 0, 0))
         ->drawEllipse(190, 50, 340, 0)
         ->setFillColor(new ZendPdf_Color\Cmyk(1, 0, 0, 0))
         ->drawEllipse(190, 50, 340, 0, M_PI/6, 2*M_PI/3)
         ->setFillColor(new ZendPdf_Color\Rgb(1, 1, 0))
         ->drawEllipse(190, 50, 340, 0, -M_PI/6, M_PI/6);

   // 多角形を描画して塗りつぶします
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

   // 直線を描画します
   $page2->setLineWidth(0.5)
         ->drawLine(0, 25, 340, 25);

   $page2->restoreGS();

   //------------------------------------------------------------------------

   if (isset($argv[2])) {
       $pdf->save($argv[2]);
   } else {
       $pdf->save($argv[1], true /* 更新 */);
   }


