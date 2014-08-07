.. EN-Revision: none
.. _zendpdf.create:

Создание и загрузка документов PDF
==================================

Класс *ZendPdf* представляет документ PDF и обеспечивает
функциональность для работы на уровне документа.

Для того, чтобы создать новый документ, нужно создать новый
объект *ZendPdf*.

Класс *ZendPdf* также предоставляет два статических метода для
загрузки существующих документов PDF. Это методы *ZendPdf\PdfDocument::load()* и
*ZendPdf\PdfDocument::parse()*. Оба метода возвращают объект *ZendPdf* в качестве
результата или генерируют исключение в случае ошибки.

.. rubric:: Создание нового или загрузка существующего документа PDF

.. code-block:: php
   :linenos:

   <?php
   ...
   // Создание нового документа PDF
   $pdf1 = new ZendPdf\PdfDocument();

   // Загрузка документа PDF из файла
   $pdf2 = ZendPdf\PdfDocument::load($fileName);

   // Загрузка документа PDF из строки
   $pdf3 = ZendPdf\PdfDocument::parse($pdfString);
   ...
   ?>
Формат файла PDF поддерживает постепенное обновление
документа. Таким образом, каждый раз, когда документ
обновляется, создается новая версия документа.

Версия может быть указана в качестве второго параметра для
методов *ZendPdf\PdfDocument::load()* и *ZendPdf\PdfDocument::parse()* или получается методом
*ZendPdf\PdfDocument::rollback()*. [#]_ call.

.. rubric:: Извлечение определенной версии документа PDF

.. code-block:: php
   :linenos:

   <?php
   ...
   // Загрузка предыдущей версии документа PDF
   $pdf1 = ZendPdf\PdfDocument::load($fileName, 1);

   // Загрузка предыдущей версии документа PDF
   $pdf2 = ZendPdf\PdfDocument::parse($pdfString, 1);

   // Загрузка первой версии документа
   $pdf3 = ZendPdf\PdfDocument::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...
   ?>


.. [#] Метод *ZendPdf\PdfDocument::rollback()* должен вызываться до того, как будут
       производиться любые изменения[накладываемые на документ].