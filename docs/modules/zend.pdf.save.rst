.. _zend.pdf.save:

Save Changes to PDF Documents
=============================

There are two methods that save changes to *PDF* documents: the ``Zend_Pdf::save()`` and ``Zend_Pdf::render()``
methods.

``Zend_Pdf::save($filename, $updateOnly = false)`` saves the *PDF* document to a file. If $updateOnly is ``TRUE``,
then only the new *PDF* file segment is appended to a file. Otherwise, the file is overwritten.

``Zend_Pdf::render($newSegmentOnly = false)`` returns the *PDF* document as a string. If $newSegmentOnly is
``TRUE``, then only the new *PDF* file segment is returned.

.. _zend.pdf.save.example-1:

.. rubric:: Saving PDF Documents

.. code-block:: php
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


