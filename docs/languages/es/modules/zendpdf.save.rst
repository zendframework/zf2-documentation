.. EN-Revision: none
.. _zendpdf.save:

Guardar Cambios a Documentos PDF
================================

Hay dos métodos que guardan los cambios a los documentos *PDF*: los métodos son ``ZendPdf\PdfDocument::save()`` y
``ZendPdf\PdfDocument::render()``.

``ZendPdf\PdfDocument::save($filename, $updateOnly = false)`` guarda el documento *PDF* en un archivo. Si $updateOnly es
``TRUE``, sólo entonces el nuevo segmento del archivo *PDF* se agrega al archivo. De lo contrario, el archivo es
sobreescrito.

``ZendPdf\PdfDocument::render($newSegmentOnly = false)`` regresa el documento *PDF* como un string. Si $newSegmentOnly es
verdadero, entonces sólo el nuevo segmento del archivo *PDF* es devuelto.

.. _zendpdf.save.example-1:

.. rubric:: Guardando Documentos PDF

.. code-block:: php
   :linenos:

   ...
   // Cargar el documento PDF
   $pdf = ZendPdf\PdfDocument::load($fileName);
   ...
   // Actualizar el documento PDF
   $pdf->save($fileName, true);
   // Save document as a new file
   $pdf->save($newFileName);

   // Devolver el documento PDF como un string
   $pdfString = $pdf->render();

   ...


