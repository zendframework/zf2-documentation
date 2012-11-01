.. _zendpdf.save:

Save Changes to PDF Documents
=============================

There are two methods that save changes to *PDF* documents: the ``ZendPdf\Pdf::save()`` and ``ZendPdf\Pdf::render()``
methods.

``ZendPdf\Pdf::save($filename, $updateOnly = false)`` saves the *PDF* document to a file. If $updateOnly is ``TRUE``,
then only the new *PDF* file segment is appended to a file. Otherwise, the file is overwritten.

``ZendPdf\Pdf::render($newSegmentOnly = false)`` returns the *PDF* document as a string. If $newSegmentOnly is
``TRUE``, then only the new *PDF* file segment is returned.

.. _zendpdf.save.example-1:

.. rubric:: Saving PDF Documents

.. code-block:: php
   :linenos:

   ...
   // Load the PDF document
   $pdf = ZendPdf\Pdf::load($fileName);
   ...
   // Update the PDF document
   $pdf->save($fileName, true);
   // Save document as a new file
   $pdf->save($newFileName);

   // Return the PDF document as a string
   $pdfString = $pdf->render();

   ...


