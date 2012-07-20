.. _zend.pdf.save:

שמירת שינויים בטפסי PDF
=======================

ישנם שני מתודות אשר שומרות שינויים לטפסי PDF: *Zend_Pdf::save()* ו
*Zend_Pdf::render()*.

*Zend_Pdf::save($filename, $updateOnly = false)* שומר את טופס ה PDF לקובץ. אם $updateOnly
מוגדר ל true, אז רק השינויים החדשים מצורפים לקובץ. אחרת הקובץ
משוכתב מחדש.

*Zend_Pdf::render($newSegmentOnly = false)* מחזיר את הטופס PDF כסטרינג. אם $newSegmentOnly
מוגדר ל true, אז רק השינויים החדשים מוחזרים.

.. _zend.pdf.save.example-1:

.. rubric:: שמירת קבצי PDF

.. code-block::
   :linenos:

   ...
   // Load the PDF document
   $pdf = Zend_Pdf::load($fileName);
   ...
   // Update the PDF document
   $pdf->save($fileName, true);
   // Save document as a new file
   $pdf->save($newFileName);

   // Return the PDF document as a string
   $pdfString = $pdf->render();

   ...



