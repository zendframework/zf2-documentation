.. EN-Revision: none
.. _zendpdf.save:

Сохранение изменений в документе PDF
====================================

Есть два метода, с помощью которых производится сохранение
изменений в документе PDF. Это методы *ZendPdf\Pdf::save()* и *ZendPdf\Pdf::render()*.

Метод *ZendPdf\Pdf::save($filename, $updateOnly = false)* сохраняет документ в файл.
Если ``$updateOnly`` равен ``TRUE``, то к файлу PDF будет только добавлен
новый сегмент, иначе файл будет перезаписан.

*ZendPdf\Pdf::render($filename, $updateOnly = false)* возвращает документ PDF в виде
строки. Если ``$updateOnly`` равен ``TRUE``, то будет возвращен только
новый сегмент файла PDF.

.. rubric:: Сохранение документа PDF

.. code-block:: php
   :linenos:

   <?php
   ...
   // Загрузка документа PDF
   $pdf = ZendPdf\Pdf::load($fileName);
   ...
   // Обновление документа
   $pdf->save($fileName, true);
   // Сохранение документа в новом файле
   $pdf->save($newFileName, true);

   // Возвращение документа в виде строки
   $pdfString = $pdf->render();

   ...
   ?>

