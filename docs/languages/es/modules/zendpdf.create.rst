.. EN-Revision: none
.. _zendpdf.create:

Creando y Cargando Documentos PDF
=================================

La clase ``ZendPdf`` representa documentos *PDF* y proporciona operaciones a nivel de documento.

Para crear un nuevo documento, primero debe ser creado un nuevo objeto ``ZendPdf``.

La clase ``ZendPdf`` también ofrece dos métodos estáticos para cargar un documento *PDF*. Estos métodos son
``ZendPdf\PdfDocument::load()`` y ``ZendPdf\PdfDocument::parse()``. Ambos retornan objetos ``ZendPdf`` como resultado o arrojan una
excepción si ocurre un error.

.. _zendpdf.create.example-1:

.. rubric:: Crear un nuevo documento PDF o cargar uno ya existente

.. code-block:: php
   :linenos:

   ...
   // Crear un nuevo documento PDF
   $pdf1 = new ZendPdf\PdfDocument();

   // Cargar un documento PDF desde un archivo
   $pdf2 = ZendPdf\PdfDocument::load($fileName);

   // Cargar un documento PDF desde un string
   $pdf3 = ZendPdf\PdfDocument::parse($pdfString);
   ...

El formato de archivos *PDF* soporta la actualización incremental del documento. Así, cada vez que un documento
es actualizado, entonces se crea una nueva revisión del documento. El componente ``ZendPdf`` soporta la
recuperación de una revisión especificada.

Una revisión puede especificarse como un segundo parámetro a los métodos ``ZendPdf\PdfDocument::load()`` y
``ZendPdf\PdfDocument::parse()`` o requerirlo llamando al método ``ZendPdf\PdfDocument::rollback()``. [#]_ call.

.. _zendpdf.create.example-2:

.. rubric:: Requiriendo Revisiones Específicas de un documento PDF

.. code-block:: php
   :linenos:

   ...
   // Cargar la revisión anterior del documento PDF
   $pdf1 = ZendPdf\PdfDocument::load($fileName, 1);

   // Cargar la revisión anterior del documento PDF
   $pdf2 = ZendPdf\PdfDocument::parse($pdfString, 1);

   // Cargar la primera revisión del documento PDF
   $pdf3 = ZendPdf\PdfDocument::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...



.. [#] El método ``ZendPdf\PdfDocument::rollback()`` debe ser invocado antes de aplicar cualquier cambio al documento, de lo
       contrario el comportamiento no está definido.