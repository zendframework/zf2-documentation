.. EN-Revision: none
.. _zend.pdf.usage:

Пример использования модуля ZendPdf
====================================

Этот раздел дает пример использования модуля.

Этот пример может быть найден в файле ``demos/Zend/Pdf/demo.php``.

Там же есть файл ``test.pdf``, который может использоваться с этим
примером для тестирования.

.. rubric:: Демонстрация использования модуля ZendPdf

.. code-block:: php
   :linenos:

   <?php

   if (!isset($argv[1])) {
       echo "USAGE: php demo.php <pdf_file> [<output_pdf_file>]\n";
       exit;
   }

   try {
       $pdf = ZendPdf\Pdf::load($argv[1]);
   } catch (ZendPdf\Exception $e) {
       if ($e->getMessage() == 'Can not open \'' . $argv[1] . '\' file for reading.') {
           // Создается новый PDF, если файл не существует
           $pdf = new ZendPdf\Pdf();

           if (!isset($argv[2])) {
               // Полная перезапись файла вместо обновления
               $argv[2] = $argv[1];
           }
       } else {
           // Бросок исключения, если это не исключение "Can't open file"
           throw $e;
       }
   }

   //------------------------------------------------------------------------------------
   // Изменить порядок страниц на обратный
   $pdf->pages = array_reverse($pdf->pages);

   // Создание нового стиля
   $style = new ZendPdf\Style();
   $style->setFillColor(new ZendPdf_Color\RGB(0, 0, 0.9));
   $style->setLineColor(new ZendPdf_Color\GrayScale(0.2));
   $style->setLineWidth(3);
   $style->setLineDashingPattern(array(3, 2, 3, 4), 1.6);
   $style->setFont(new ZendPdf_Font\Standard(ZendPdf\Const::FONT_HELVETICA_BOLD), 32);

   // Создание нового объекта изображения
   $stampImage = ZendPdf\ImageFactory::factory(dirname(__FILE__) . '/stamp.jpg');

   // Обозначение страницы как измененной
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

   // Добавление новой страницы, сгенерированной объектом ZendPdf
   // (страница прикреплена к определенному документу)
   $pdf->pages[] = ($page1 = $pdf->newPage('A4'));

   // Добавление новой страницы, сгенерированной объектом ZendPdf\Page
   // (страница не прикреплена к документу)
   $pdf->pages[] = ($page2 = new ZendPdf\Page(ZendPdf\Const::PAGESIZE_LETTER_LANDSCAPE));

   // Создание нового шрифта
   $font = new ZendPdf_Font\Standard(ZendPdf\Const::FONT_HELVETICA);

   // Применение шрифта и написание текста
   $page1->setFont($font, 36);
   $page1->drawText('Helvetica 36 text string', 60, 500);

   // Использование объекта шрифта для других страниц
   $page2->setFont($font, 24);
   $page2->drawText('Helvetica 24 text string', 60, 500);

   // Использование другого шрифта
   $page2->setFont(new ZendPdf_Font\Standard(ZendPdf\Const::FONT_TIMES_ROMAN), 32);
   $page2->drawText('Times-Roman 32 text string', 60, 450);

   // Рисование прямоугольника
   $page2->setFillColor(new ZendPdf_Color\GrayScale(0.8));
   $page2->setLineColor(new ZendPdf_Color\GrayScale(0.2));
   $page2->setLineDashingPattern(array(3, 2, 3, 4), 1.6);
   $page2->drawRectangle(60, 400, 400, 350);

   // Рисование круга
   $page2->setLineDashingPattern(ZendPdf\Const::LINEDASHING_SOLID);
   $page2->setFillColor(new ZendPdf_Color\RGB(1, 0, 0));
   $page2->drawCircle(85, 375, 25);

   // Рисование секторов
   $page2->drawCircle(200, 375, 25, 2*M_PI/3, -M_PI/6);
   $page2->setFillColor(new ZendPdf_Color\CMYK(1, 0, 0, 0));
   $page2->drawCircle(200, 375, 25, M_PI/6, 2*M_PI/3);
   $page2->setFillColor(new ZendPdf_Color\RGB(1, 1, 0));
   $page2->drawCircle(200, 375, 25, -M_PI/6, M_PI/6);

   // Рисование элипса
   $page2->setFillColor(new ZendPdf_Color\RGB(1, 0, 0));
   $page2->drawEllipse(250, 400, 400, 350);
   $page2->setFillColor(new ZendPdf_Color\CMYK(1, 0, 0, 0));
   $page2->drawEllipse(250, 400, 400, 350, M_PI/6, 2*M_PI/3);
   $page2->setFillColor(new ZendPdf_Color\RGB(1, 1, 0));
   $page2->drawEllipse(250, 400, 400, 350, -M_PI/6, M_PI/6);

   // Рисование и заполнение многоугольника
   $page2->setFillColor(new ZendPdf_Color\RGB(1, 0, 1));
   $x = array();
   $y = array();
   for ($count = 0; $count < 8; $count++) {
       $x[] = 140 + 25*cos(3*M_PI_4*$count);
       $y[] = 375 + 25*sin(3*M_PI_4*$count);
   }
   $page2->drawPolygon($x, $y,
                       ZendPdf\Const::SHAPEDRAW_FILLNSTROKE,
                       ZendPdf\Const::FILLMETHOD_EVENODD);

   // Рисование линии
   $page2->setLineWidth(0.5);
   $page2->drawLine(60, 375, 400, 375);
   //------------------------------------------------------------------------------------

   if (isset($argv[2])) {
       $pdf->save($argv[2]);
   } else {
       $pdf->save($argv[1], true /* update */);
   }


