.. EN-Revision: none
.. _zend.pdf.save:

Zapisywanie zmian w dokumencie PDF.
===================================

Dostępne są dwie metody, które zapewniają zapisywanie zmian w dokumencie PDF. Są to metody *ZendPdf\Pdf::save()*
oraz *ZendPdf\Pdf::render()*.

Metoda *ZendPdf\Pdf::save($filename, $updateOnly = false)* zapisuje dokument PDF do pliku. Jeśli zmienna $updateOnly
ma wartość true, wtedy tylko nowy segement pliku PDF jest dołączany do pliku. W przeciwnym razie plik jest
nadpisywany.

*ZendPdf\Pdf::render($newSegmentOnly = false)* zwraca dokument PDF jako łańcuch znaków. Jeśli zmienna
$newSegmentOnly ma wartość true, wtedy zwracany jest nowy segment pliku PDF.

.. _zend.pdf.save.example-1:

.. rubric:: Zapisywanie dokumentu PDF.

.. code-block:: php
   :linenos:

   ...
   // Załaduj dokument PDF.
   $pdf = ZendPdf\Pdf::load($fileName);
   ...
   // Uaktualnij dokument
   $pdf->save($fileName, true);
   // Zapisz dokument jako nowy plik
   $pdf->save($newFileName);

   // Zwróć dokument PDF jako łańcuch znaków.
   $pdfString = $pdf->render();

   ...



