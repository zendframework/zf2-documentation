.. _zend.pdf.create:

Creating and Loading PDF Documents
==================================

The ``Zend_Pdf`` class represents *PDF* documents and provides document-level operations.

To create a new document, a new ``Zend_Pdf`` object should first be created.

``Zend_Pdf`` class also provides two static methods to load an existing *PDF* document. These are the
``Zend_Pdf::load()`` and ``Zend_Pdf::parse()`` methods. Both of them return ``Zend_Pdf`` objects as a result or
throw an exception if an error occurs.

.. _zend.pdf.create.example-1:

.. rubric:: Create new or load existing PDF document

.. code-block:: php
   :linenos:

   ...
   // Create a new PDF document
   $pdf1 = new Zend_Pdf();

   // Load a PDF document from a file
   $pdf2 = Zend_Pdf::load($fileName);

   // Load a PDF document from a string
   $pdf3 = Zend_Pdf::parse($pdfString);
   ...

The *PDF* file format supports incremental document update. Thus each time a document is updated, then a new
revision of the document is created. ``Zend_Pdf`` component supports the retrieval of a specified revision.

A revision can be specified as a second parameter to the ``Zend_Pdf::load()`` and ``Zend_Pdf::parse()`` methods or
requested by calling the ``Zend_Pdf::rollback()`` method. [#]_ call.

.. _zend.pdf.create.example-2:

.. rubric:: Requesting Specific Revisions of a PDF Document

.. code-block:: php
   :linenos:

   ...
   // Load the previous revision of the PDF document
   $pdf1 = Zend_Pdf::load($fileName, 1);

   // Load the previous revision of the PDF document
   $pdf2 = Zend_Pdf::parse($pdfString, 1);

   // Load the first revision of the PDF document
   $pdf3 = Zend_Pdf::load($fileName);
   $revisions = $pdf3->revisions();
   $pdf3->rollback($revisions - 1);
   ...



.. [#] ``Zend_Pdf::rollback()`` method must be invoked before any changes are applied to the document, otherwise
       the behavior is not defined.