.. _zendpdf.create:

Creating and Loading PDF Documents
==================================

The ``ZendPdf\Pdf`` class represents *PDF* documents and provides document-level operations.

To create a new document, a new ``ZendPdf\Pdf`` object should first be created.

``ZendPdf\Pdf`` class also provides two static methods to load an existing *PDF* document. These are the
``ZendPdf\Pdf::load()`` and ``ZendPdf\Pdf::parse()`` methods. Both of them return ``ZendPdf\Pdf`` objects as a result or
throw an exception if an error occurs.

.. _zendpdf.create.example-1:

.. rubric:: Create new or load existing PDF document

.. code-block:: php
   :linenos:

   ...
   // Create a new PDF document
   $pdf1 = new ZendPdf\Pdf();

   // Load a PDF document from a file
   $pdf2 = ZendPdf\Pdf::load($fileName);

   // Load a PDF document from a string
   $pdf3 = ZendPdf\Pdf::parse($pdfString);
   ...

The *PDF* file format supports incremental document update. Thus each time a document is updated, then a new
revision of the document is created. ``ZendPdf`` component supports the retrieval of a specified revision.

A revision can be specified as a second parameter to the ``ZendPdf\Pdf::load()`` and ``ZendPdf\Pdf::parse()`` methods or
requested by calling the ``ZendPdf\Pdf::rollback()`` method. [#]_ call.

.. _zendpdf.create.example-2:

.. rubric:: Requesting Specific Revisions of a PDF Document

.. code-block:: php
   :linenos:

   ...
   // Load the previous revision of the PDF document
   $pdf1 = ZendPdf\Pdf::load($fileName, 1);

   // Load the previous revision of the PDF document
   $pdf2 = ZendPdf\Pdf::parse($pdfString, 1);

   // Load the first revision of the PDF document
   $pdf3 = ZendPdf\Pdf::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...



.. [#] ``ZendPdf\Pdf::rollback()`` method must be invoked before any changes are applied to the document, otherwise
       the behavior is not defined.