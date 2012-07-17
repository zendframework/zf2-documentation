
.. _zend.pdf.pages:

Working with Pages
==================


.. _zend.pdf.pages.creation:

Page Creation
-------------

The pages in a *PDF* document are represented as ``\Zend\Pdf\Page`` instances in *Zend\Pdf*.

*PDF* pages either are loaded from an existing *PDF* or created using the *Zend\Pdf* *API*.

New pages can be created by instantiating new ``\Zend\Pdf\Page`` objects directly or by calling the ``\Zend\Pdf\PdfDocument::newPage()`` method, which returns a ``\Zend\Pdf\Page`` object. ``\Zend\Pdf\PdfDocument::newPage()`` creates a page that is already attached to a document. Attached pages can't be used with another *PDF* documents until it's not cloned. See :ref:`Page cloning <zend.pdf.pages.cloning>` section for the details.

The ``\Zend\Pdf\PdfDocument::newPage()`` method and the ``\Zend\Pdf\Page`` constructor take the same parameters specifying page size. They can take either the size of page ($x, $y) in points (1/72 inch) or a predefined constant representing a page type:

- \\Zend\\Pdf\\Page::SIZE_A4

- \\Zend\\Pdf\\Page::SIZE_A4_LANDSCAPE

- \\Zend\\Pdf\\Page::SIZE_LETTER

- \\Zend\\Pdf\\Page::SIZE_LETTER_LANDSCAPE



Document pages are stored in the ``$pages`` public attribute of the ``\Zend\Pdf\PdfDocument`` class. The attribute holds an array of ``\Zend\Pdf\Page`` objects and completely defines the instances and order of pages. This array can be manipulated like any other *PHP* array:


.. _zend.pdf.pages.example-1:

.. rubric:: PDF document pages management

.. code-block:: php
   :linenos:

   ...
   // Reverse page order
   $pdf->pages = array_reverse($pdf->pages);
   ...
   // Add new page
   $pdf->pages[] = new \Zend\Pdf\Page(\Zend\Pdf\Page::SIZE_A4);
   // Add new page
   $pdf->pages[] = $pdf->newPage(\Zend\Pdf\Page::SIZE_A4);

   // Remove specified page.
   unset($pdf->pages[$id]);

   ...


.. _zend.pdf.pages.cloning:

Page cloning
------------

Existing *PDF* page can be duplicated by creating new ``\Zend\Pdf\Page`` object with existing page as a parameter:


.. _zend.pdf.pages.example-2:

.. rubric:: Duplicating existing page

.. code-block:: php
   :linenos:

   ...
   // Store template page in a separate variable
   $template = $pdf->pages[$templatePageIndex];
   ...
   // Add new page
   $page1 = new \Zend\Pdf\Page($template);
   $page1->drawText('Some text...', $x, $y);
   $pdf->pages[] = $page1;
   ...

   // Add another page
   $page2 = new \Zend\Pdf\Page($template);
   $page2->drawText('Another text...', $x, $y);
   $pdf->pages[] = $page2;
   ...

   // Remove source template page from the documents.
   unset($pdf->pages[$templatePageIndex]);

   ...

It's useful if you need several pages to be created using one template.

.. caution::
   Important! Duplicated page shares some *PDF* resources with a template page, so it can be used only within the same document as a template page. Modified document can be saved as new one.


*clone* operator may be used to create page which is not attached to any document. It takes more time than duplicating page since it needs to copy all dependent objects (used fonts, images and other resources), but it allows to use pages from different source documents to create new one:


.. _zend.pdf.pages.example-3:

.. rubric:: Cloning existing page

.. code-block:: php
   :linenos:

   $page1 = clone $pdf1->pages[$templatePageIndex1];
   $page2 = clone $pdf2->pages[$templatePageIndex2];
   $page1->drawText('Some text...', $x, $y);
   $page2->drawText('Another text...', $x, $y);
   ...
   $pdf = new \Zend\Pdf\PdfDocument();
   $pdf->pages[] = $page1;
   $pdf->pages[] = $page2;

If several template pages are planned to be used as templates then it could be more efficient to utilize ``\Zend\Pdf\Resource\Extractor`` class which gives an ability to share resources between cloned pages - fonts, images, etc. (otherwise new resource copy will be created for each cloned page):


.. _zend.pdf.pages.example-4:

.. rubric:: Cloning existing page using ``\Zend\Pdf\Resource\Extractor`` class

.. code-block:: php
   :linenos:

   $extractor = new \Zend\Pdf\Resource\Extractor();
   ....
   $page1 = $extractor->clonePage($pdf->pages[$templatePageIndex1]);
   $page2 = $extractor->clonePage($pdf->pages[$templatePageIndex2]);
   $page1->drawText('Some text...', $x, $y);
   $page2->drawText('Another text...', $x, $y);
   ...
   $pdf = new Zend_Pdf();
   $pdf->pages[] = $page1;
   $pdf->pages[] = $page2;


