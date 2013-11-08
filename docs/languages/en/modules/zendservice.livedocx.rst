.. _zendservice.livedocx:

ZendService\LiveDocx\LiveDocx
=============================

.. _zendservice.livedocx.introduction:

Introduction to LiveDocx
------------------------

LiveDocx is a *SOAP* service that allows developers to generate word processing documents by combining structured
textual or image data from *PHP* with a template, created in a word processor. The resulting document can be
saved as a *PDF*, *DOCX*, *DOC*, *HTML* or *RTF* file. LiveDocx implements `mail-merge`_ in *PHP*.

The family of ``ZendService\LiveDocx\LiveDocx`` components provides a clean and simple interface to *LiveDocx Free*,
*LiveDocx Premium* and *LiveDocx Fully Licensed*, authored by *Text Control GmbH*, and additionally offers
functionality to improve network performance.

``ZendService\LiveDocx\LiveDocx`` is part of the official Zend Framework family, but has to be downloaded and installed
in addition to the core components of the Zend Framework, as do all other service components. Please refer to
`GitHub (ZendServiceLiveDocx)`_ for download and installation instructions.

In addition to this section of the manual, to learn more about ``ZendService\LiveDocx\LiveDocx`` and the backend *SOAP*
service LiveDocx, please take a look at the following resources:

- **Shipped demonstration applications**. There is a large number of demonstration applications in the
  directory ``/demos``. They illustrate all functionality offered by LiveDocx. Where appropriate this part of the
  user manual references the demonstration applications at the end of each section. It is **highly recommended**
  to read all the  code in the ``/demos`` directory. It is well commented and explains all you need to know about
  LiveDocx and ``ZendService\LiveDocx\LiveDocx``.

- `LiveDocx in PHP`_.

- `LiveDocx SOAP API documentation`_.

- `LiveDocx WSDL`_.

- `LiveDocx blog and web site`_.

.. _zendservice.livedocx.account:

Sign Up for an Account
^^^^^^^^^^^^^^^^^^^^^^

Before you can start using LiveDocx, you must first `sign up`_ for an account. The account is completely free of
charge and you only need to specify a **username**, **password** and **e-mail address**. Your login credentials
will be dispatched to the e-mail address you supply, so please type carefully. If, or when, your application
gets really popular and you require high performance, or additional features only supplied in the premium service,
you can upgrade from the *LiveDocx Free* to *LiveDocx Premium* for a minimal monthly charge. For details of the
various services, please refer to `LiveDocx pricing`_.

.. _zendservice.livedocx.templates-documents:

Templates and Documents
^^^^^^^^^^^^^^^^^^^^^^^

LiveDocx differentiates between the following terms: 1) **template** and 2) **document**. In order to fully
understand the documentation and indeed LiveDocx itself, it is important that any programmer deploying LiveDocx
understands the difference.

The term **template** is used to refer to the input file, created in a word processor, containing formatting and
text fields. You can download an `example template`_, stored as a *DOCX* file. The term **document** is used to
refer to the output file that contains the template file, populated with data - i.e. the finished document. You can
download an `example document`_, stored as a *PDF* file.

.. _zendservice.livedocx.formats:

Supported File Formats
^^^^^^^^^^^^^^^^^^^^^^

LiveDocx supports the following file formats:

.. _zendservice.livedocx.formats.template:

Template File Formats (input)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Templates can be saved in any of the following file formats:

- `DOCX`_- Office Open *XML* format

- `DOC`_- Microsoft Word *DOC* format

- `RTF`_- Rich text file format

- `TXD`_- TX Text Control format

.. _zendservice.livedocx.formats.document:

Document File Formats (output):
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The resulting document can be saved in any of the following file formats:

- `DOCX`_- Office Open *XML* format

- `DOC`_- Microsoft Word *DOC* format

- `HTML`_-*XHTML* 1.0 transitional format

- `RTF`_- Rich text file format

- `PDF`_- Acrobat Portable Document Format

- `PDF/A`_- Acrobat Portable Document Format (ISO-standardized version)

- `TXD`_- TX Text Control format

- `TXT`_-*ANSI* plain text

.. _zendservice.livedocx.formats.image:

Image File Formats (output):
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The resulting document can be saved in any of the following graphical file formats:

- `BMP`_- Bitmap image format

- `GIF`_- Graphics Interchange Format

- `JPG`_- Joint Photographic Experts Group format

- `PNG`_- Portable Network Graphics format

- `TIFF`_- Tagged Image File Format

- `WMF`_- Windows Meta File format

.. _zendservice.livedocx.mailmerge:

ZendService\\LiveDocx\\MailMerge
--------------------------------

``MailMerge`` is the mail-merge object in the ``ZendService\LiveDocx\LiveDocx`` family.

.. _zendservice.livedocx.mailmerge.generation:

Document Generation Process
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The document generation process can be simplified with the following equation:

**Template + Data = Document**

Or expressed by the following diagram:

.. image:: ../images/zendservice.livedocx.mailmerge.generation-diabasic_zoom.png


Data is inserted into template to create a document.

A template, created in a word processing application, such as Microsoft Word, is loaded into LiveDocx. Data is then
inserted into the template and the resulting document is saved to any supported format.

.. _zendservice.livedocx.mailmerge.templates:

Creating Templates in Microsoft Word 2007
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Start off by launching Microsoft Word and creating a new document. Next, open up the **Field** dialog box. This
looks as follows:

.. image:: ../images/zendservice.livedocx.mailmerge.templates-msworddialog_zoom.png

Microsoft Word 2007 Field dialog box.

Using this dialog, you can insert the required merge fields into your document. Below is a screenshot of a license
agreement in Microsoft Word 2007. The merge fields are marked as ``{ MERGEFIELD FieldName }``:

.. image:: ../images/zendservice.livedocx.mailmerge.templates-mswordtemplatefull_zoom.png

Template in Microsoft Word 2007.

Now, save the template as **template.docx**.

In the next step, we are going to populate the merge fields with textual data from *PHP*.

.. image:: ../images/zendservice.livedocx.mailmerge.templates-mswordtemplatecropped_zoom.png

Cropped template in Microsoft Word 2007.

To populate the merge fields in the above cropped screenshot of the `template`_ in Microsoft Word, all we have to
code is as follows:

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;

    $locale    = Locale::getDefault();
    $timestamp = time();

    $intlTimeFormatter = new IntlDateFormatter($locale,
            IntlDateFormatter::NONE, IntlDateFormatter::SHORT);

    $intlDateFormatter = new IntlDateFormatter($locale,
            IntlDateFormatter::LONG, IntlDateFormatter::NONE);

    $mailMerge = new MailMerge();

    $mailMerge->setUsername('myUsername')
              ->setPassword('myPassword')
              ->setService (MailMerge::SERVICE_FREE);  // for LiveDocx Premium, use MailMerge::SERVICE_PREMIUM

    $mailMerge->setLocalTemplate('license-agreement-template.docx');

    $mailMerge->assign('software', 'Magic Graphical Compression Suite v1.9')
              ->assign('licensee', 'Henry Döner-Meyer')
              ->assign('company',  'Co-Operation')
              ->assign('date',     $intlDateFormatter->format($timestamp))
              ->assign('time',     $intlTimeFormatter->format($timestamp))
              ->assign('city',     'Lyon')
              ->assign('country',  'France');

    $mailMerge->createDocument();

    $document = $mailMerge->retrieveDocument('pdf');

    file_put_contents('license-agreement-document.pdf', $document);

    unset($mailMerge);

The resulting document is written to disk in the file **license-agreement-document.pdf**. This file can now be post-processed, sent
via e-mail or simply displayed, as is illustrated below in **Document Viewer 2.26.1** on **Ubuntu 9.04**:

.. image:: ../images/zendservice.livedocx.mailmerge.templates-msworddocument_zoom.png

Resulting document as *PDF* in Document Viewer 2.26.1.

.. _zendservice.livedocx.mailmerge.advanced:

For executable demo applications, which illustrate the above, please take a look at
``/demos/ZendService/LiveDocx/MailMerge/license-agreement``.

Advanced Mail-Merge
^^^^^^^^^^^^^^^^^^^

``ZendService\LiveDocx\MailMerge`` allows designers to insert any number of text fields into a
template. These text fields are populated with data when **createDocument()** is called.

In addition to text fields, it is also possible specify regions of a document, which should be repeated.

For example, in a telephone bill it is necessary to print out a list of all connections, including the destination
number, duration and cost of each call. This repeating row functionality can be achieved with so called blocks.

**Blocks** are simply regions of a document, which are repeated when ``createDocument()`` is called. In a block any
number of **block fields** can be specified.

Blocks consist of two consecutive document targets with a unique name. The following screenshot illustrates these
targets and their names in red:

.. image:: ../images/zendservice.livedocx.mailmerge.advanced-mergefieldblockformat_zoom.png

The format of a block is as follows:

.. code-block:: text

   blockStart_ + unique name
   blockEnd_ + unique name

For example:

.. code-block:: text

   blockStart_block1
   blockEnd_block1

The content of a block is repeated, until all data assigned in the block fields has been injected into the
template. The data for block fields is specified in *PHP* as a multi-assoc array.

The following screenshot of a template in Microsoft Word 2007 shows how block fields are used:

.. image:: ../images/zendservice.livedocx.mailmerge.advanced-mswordblockstemplate_zoom.png

Template, illustrating blocks in Microsoft Word 2007.

The following code populates the above template with data.

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;

    $locale    = Locale::getDefault();
    $timestamp = time();

    $intlDateFormatter1 = new IntlDateFormatter($locale,
            IntlDateFormatter::LONG, IntlDateFormatter::NONE);

    $intlDateFormatter2 = new IntlDateFormatter($locale,
            null, null, null, null, 'LLLL yyyy');

    $mailMerge = new MailMerge();

    $mailMerge->setUsername('myUsername')
              ->setPassword('myPassword')
              ->setService (MailMerge::SERVICE_FREE);  // for LiveDocx Premium, use MailMerge::SERVICE_PREMIUM

    $mailMerge->setLocalTemplate('telephone-bill-template.doc');

    $mailMerge->assign('customer_number', sprintf("#%'10s", rand(0,1000000000)))
              ->assign('invoice_number',  sprintf("#%'10s", rand(0,1000000000)))
              ->assign('account_number',  sprintf("#%'10s", rand(0,1000000000)));

    $billData = array (
        'phone'         => '+22 (0)333 444 555',
        'date'          => $intlDateFormatter1->format($timestamp),
        'name'          => 'James Henry Brown',
        'service_phone' => '+22 (0)333 444 559',
        'service_fax'   => '+22 (0)333 444 558',
        'month'         => $intlDateFormatter2->format($timestamp),
        'monthly_fee'   => '15.00',
        'total_net'     => '19.60',
        'tax'           => '19.00',
        'tax_value'     =>  '3.72',
        'total'         => '23.32'
    );

    $mailMerge->assign($billData);

    $billConnections = array(
        array(
            'connection_number'   => '+11 (0)222 333 441',
            'connection_duration' => '00:01:01',
            'fee'                 => '1.15'
        ),
        array(
            'connection_number'   => '+11 (0)222 333 442',
            'connection_duration' => '00:01:02',
            'fee'                 => '1.15'
        ),
        array(
            'connection_number'   => '+11 (0)222 333 443',
            'connection_duration' => '00:01:03',
            'fee'                 => '1.15'
        ),
        array(
            'connection_number'   => '+11 (0)222 333 444',
            'connection_duration' => '00:01:04',
            'fee'                 => '1.15'
        )
    );

    $mailMerge->assign('connection', $billConnections);

    $mailMerge->createDocument();

    $document = $mailMerge->retrieveDocument('pdf');

    file_put_contents('telephone-bill-document.pdf', $document);

    unset($mailMerge);

The data, which is specified in the array ``$billConnections`` is repeated in the template in the block connection.
The keys of the array (``connection_number``, ``connection_duration`` and ``fee``) are the block field names -
their data is inserted, one row per iteration.

The resulting document is written to disk in the file **telephone-bill-document.pdf**. This file can now be
post-processed, sent via e-mail or simply displayed, as is illustrated below in **Document Viewer 2.26.1**
on **Ubuntu 9.04**:

.. image:: ../images/zendservice.livedocx.mailmerge.advanced-mswordblocksdocument_zoom.png

Resulting document as *PDF* in Document Viewer 2.26.1.

You can download the *DOC* `template file`_ and the resulting `PDF document`_.

.. note::

   Blocks may not be nested.

For executable demo applications, which illustrate the above, please take a look at
``/demos/ZendService/LiveDocx/MailMerge/telephone-bill``.

.. _zendservice.livedocx.mailmerge.images:

Merging Image Data into a Template
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In addition to assigning textual data, it is also possible to merge image data into a template. The following code
populates a conference badge template with the photo ``dailemaitre.jpg``, in addition to some textual data.

The first step is to upload the image to the backend service. Once you have done this, you can assign the filename
of the image to the template just as you would any other textual data. Note the syntax of the field name containing
an image - it must start with ``image:``

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;

    $locale    = Locale::getDefault();
    $timestamp = time();

    $intlDateFormatter = new IntlDateFormatter($locale,
            IntlDateFormatter::LONG, IntlDateFormatter::NONE);

    $mailMerge = new MailMerge();

    $mailMerge->setUsername('myUsername')
              ->setPassword('myPassword')
              ->setService (MailMerge::SERVICE_FREE);  // for LiveDocx Premium, use MailMerge::SERVICE_PREMIUM

    $photoFilename = __DIR__ . '/dailemaitre.jpg';
    $photoFile     = basename($photoFilename);

    if (!$mailMerge->imageExists($photoFile)) {         // pass image file *without* path
        $mailMerge->uploadImage($photoFilename);        // pass image file *with* path
    }

    $mailMerge->setLocalTemplate('conference-pass-template.docx');

    $mailMerge->assign('name',        'Daï Lemaitre')
              ->assign('company',     'Megasoft Co-operation')
              ->assign('date',        $intlDateFormatter->format($timestamp))
              ->assign('image:photo', $photoFile);      // pass image file *without* path

    $mailMerge->createDocument();

    $document = $mailMerge->retrieveDocument('pdf');

    file_put_contents('conference-pass-document.pdf', $document);

    $mailMerge->deleteImage($photoFilename);

    unset($mailMerge);

For executable demo applications, which illustrate the above, please take a look at
``/demos/ZendService/LiveDocx/MailMerge/conference-pass``.

.. _zendservice.livedocx.mailmerge.bitmaps:

Generating Bitmaps Image Files
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In addition to document file formats, ``MailMerge`` also allows documents to be saved to a
number of image file formats (*BMP*, *GIF*, *JPG*, *PNG* and *TIFF*). Each page of the document is saved to one
file.

The following sample illustrates the use of ``getBitmaps($fromPage, $toPage, $zoomFactor, $format)`` and
``getAllBitmaps($zoomFactor, $format)``.

``$fromPage`` is the lower-bound page number of the page range that should be returned as an image and ``$toPage``
the upper-bound page number. ``$zoomFactor`` is the size of the images, as a percent, relative to the original page
size. The range of this parameter is 10 to 400. ``$format`` is the format of the images returned by this method.
The supported formats can be obtained by calling ``getImageExportFormats()``.

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;

    $locale    = Locale::getDefault();
    $timestamp = time();

    $intlTimeFormatter = new IntlDateFormatter($locale,
            IntlDateFormatter::NONE, IntlDateFormatter::SHORT);

    $intlDateFormatter = new IntlDateFormatter($locale,
            IntlDateFormatter::LONG, IntlDateFormatter::NONE);

    $mailMerge = new MailMerge();

    $mailMerge->setUsername('myUsername')
              ->setPassword('myPassword')
              ->setService (MailMerge::SERVICE_FREE);  // for LiveDocx Premium, use MailMerge::SERVICE_PREMIUM

    $mailMerge->setLocalTemplate('license-agreement-template.docx');

    $mailMerge->assign('software', 'Magic Graphical Compression Suite v1.9')
              ->assign('licensee', 'Henry Döner-Meyer')
              ->assign('company',  'Co-Operation')
              ->assign('date',     $intlDateFormatter->format($timestamp))
              ->assign('time',     $intlTimeFormatter->format($timestamp))
              ->assign('city',     'Lyon')
              ->assign('country',  'France');

    $mailMerge->createDocument();

    // Get all bitmaps
    // (zoomFactor, format)
    $bitmaps = $mailMerge->getAllBitmaps(100, 'png');

    // Get just bitmaps in specified range
    // (fromPage, toPage, zoomFactor, format)
    //$bitmaps = $mailMerge->getBitmaps(2, 2, 100, 'png');

    foreach ($bitmaps as $pageNumber => $bitmapData) {
        $filename = sprintf('license-agreement-page-%d.png', $pageNumber);
        file_put_contents($filename, $bitmapData);
    }

    unset($mailMerge);

This produces two files (``license-agreement-page-1.png`` and ``license-agreement-page-2.png``)
and writes them to disk in the same directory as the executable *PHP* file.

.. image:: ../images/zendservice.livedocx.mailmerge.bitmaps-documentpage1_zoom.png

license-agreement-page-1.png.

.. image:: ../images/zendservice.livedocx.mailmerge.bitmaps-documentpage2_zoom.png

license-agreement-page-2.png.

.. _zendservice.livedocx.mailmerge.templates-types:

For executable demo applications, which illustrate the above, please take a look at
``/demos/ZendService/LiveDocx/MailMerge/bitmaps``.

Local vs. Remote Templates
^^^^^^^^^^^^^^^^^^^^^^^^^^

Templates can be stored **locally**, on the client machine, or **remotely**, by LiveDocx. There are advantages
and disadvantages to each approach.

In the case that a template is stored locally, it must be transferred from the client to LiveDocx on every
request. If the content of the template rarely changes, this approach is inefficient. Similarly, if the template is
several megabytes in size, it may take considerable time to transfer it to LiveDocx. Local template are useful in
situations in which the content of the template is constantly changing.

The following code illustrates how to use a local template.

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;

    $mailMerge = new MailMerge();

    $mailMerge->setUsername('myUsername')
              ->setPassword('myPassword')
              ->setService (MailMerge::SERVICE_FREE);  // for LiveDocx Premium, use MailMerge::SERVICE_PREMIUM

    $mailMerge->setLocalTemplate('template.docx');

    // assign data and create document

    unset($mailMerge);

In the case that a template is stored remotely, it is uploaded once to LiveDocx and then simply referenced on all
subsequent requests. Obviously, this is much quicker than using a local template, as the template does not have to
be transferred on every request. For speed critical applications, it is recommended to use the remote template
method.

The following code illustrates how to upload a template to the server:

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;

    $mailMerge = new MailMerge();

    $mailMerge->setUsername('myUsername')
              ->setPassword('myPassword')
              ->setService (MailMerge::SERVICE_FREE);  // for LiveDocx Premium, use MailMerge::SERVICE_PREMIUM

    $mailMerge->uploadTemplate('template.docx');

    unset($mailMerge);

The following code illustrates how to reference the remotely stored template on all subsequent requests:

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;

    $mailMerge = new MailMerge();

    $mailMerge->setUsername('myUsername')
              ->setPassword('myPassword')
              ->setService (MailMerge::SERVICE_FREE);  // for LiveDocx Premium, use MailMerge::SERVICE_PREMIUM

    $mailMerge->setRemoteTemplate('template.docx');

    // assign data and create document

    unset($mailMerge);

For executable demo applications, which illustrate the above, please take a look at
``/demos/ZendService/LiveDocx/MailMerge/templates``.

.. _zendservice.livedocx.mailmerge.information:

Getting Information
^^^^^^^^^^^^^^^^^^^

``ZendService\LiveDocx\MailMerge`` provides a number of methods to get information on field names,
available fonts and supported formats.

.. _zendservice.livedocx.mailmerge.information.getfieldname:

.. rubric:: Get Array of Field Names in Template

The following code returns and displays an array of all field names in the specified template. This functionality
is useful, in the case that you create an application, in which an end-user can update a template.

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;

    $mailMerge = new MailMerge();

    $mailMerge->setUsername('myUsername')
              ->setPassword('myPassword')
              ->setService (MailMerge::SERVICE_FREE);  // for LiveDocx Premium, use MailMerge::SERVICE_PREMIUM

    $templateName = 'template-1-text-field.docx';
    $mailMerge->setLocalTemplate($templateName);

    $fieldNames = $mailMerge->getFieldNames();
    foreach ($fieldNames as $fieldName) {
        printf('- %s%s', $fieldName, PHP_EOL);
    }

    unset($mailMerge);

For executable demo applications, which illustrate the above, please take a look at
``/demos/ZendService/LiveDocx/MailMerge/template-info``.

.. _zendservice.livedocx.mailmerge.information.getblockfieldname:

.. rubric:: Get Array of Block Field Names in Template

The following code returns and displays an array of all block field names in the specified template. This
functionality is useful, in the case that you create an application, in which an end-user can update a template.
Before such templates can be populated, it is necessary to find out the names of the contained block fields.

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;

    $mailMerge = new MailMerge();

    $mailMerge->setUsername('myUsername')
              ->setPassword('myPassword')
              ->setService (MailMerge::SERVICE_FREE);  // for LiveDocx Premium, use MailMerge::SERVICE_PREMIUM

    $templateName = 'template-block-fields.doc';
    $mailMerge->setLocalTemplate($templateName);

    $blockNames = $mailMerge->getBlockNames();
    foreach ($blockNames as $blockName) {
        $blockFieldNames = $mailMerge->getBlockFieldNames($blockName);
        foreach ($blockFieldNames as $blockFieldName) {
            printf('- %s::%s%s', $blockName, $blockFieldName, PHP_EOL);
        }
    }

    unset($mailMerge);

For executable demo applications, which illustrate the above, please take a look at
``/demos/ZendService/LiveDocx/MailMerge/template-info``.

.. _zendservice.livedocx.mailmerge.information.getfontnames:

.. rubric:: Get Array of Fonts Installed on Server

The following code returns and displays an array of all fonts installed on the server. You can use this method to
present a list of fonts which may be used in a template. It is important to inform the end-user about the fonts
installed on the server, as only these fonts may be used in a template. In the case that a template contains fonts,
which are not available on the server, font-substitution will take place. This may lead to undesirable results.

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;
    use Zend\Debug\Debug;

    $mailMerge = new MailMerge();

    $mailMerge->setUsername('myUsername')
              ->setPassword('myPassword')
              ->setService (MailMerge::SERVICE_FREE);  // for LiveDocx Premium, use MailMerge::SERVICE_PREMIUM

    Debug::dump($mailMerge->getFontNames());

    unset($mailMerge);

.. note::

   As the return value of this method changes very infrequently, it is highly recommended to use a cache,
   such as ``Zend\Cache\Cache``- this will considerably speed up your application.

For executable demo applications, which illustrate the above, please take a look at
``/demos/ZendService/LiveDocx/MailMerge/supported-fonts``.

.. _zendservice.livedocx.mailmerge.information.gettemplateformats:

.. rubric:: Get Array of Supported Template File Formats

The following code returns and displays an array of all supported template file formats. This method is
particularly useful in the case that a combo list should be displayed that allows the end-user to select the input
format of the documentation generation process.

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;
    use Zend\Debug\Debug;

    $mailMerge = new MailMerge()

    $mailMerge->setUsername('myUsername')
              ->setPassword('myPassword')
              ->setService (MailMerge::SERVICE_FREE);  // for LiveDocx Premium, use MailMerge::SERVICE_PREMIUM

    Debug::dump($mailMerge->getTemplateFormats());

    unset($mailMerge);

.. note::

   As the return value of this method changes very infrequently, it is highly recommended to use a cache,
   such as ``Zend\Cache\Cache``- this will considerably speed up your application.

For executable demo applications, which illustrate the above, please take a look at
``/demos/ZendService/LiveDocx/MailMerge/supported-formats``.

.. _zendservice.livedocx.mailmerge.information.getdocumentformats:

.. rubric:: Get Array of Supported Document File Formats

The following code returns and displays an array of all supported document file formats. This method is
particularly useful in the case that a combo list should be displayed that allows the end-user to select the output
format of the documentation generation process.

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;
    use Zend\Debug\Debug;

    $mailMerge = new MailMerge();

    $mailMerge->setUsername('myUsername')
              ->setPassword('myPassword')
              ->setService (MailMerge::SERVICE_FREE);  // for LiveDocx Premium, use MailMerge::SERVICE_PREMIUM

    Debug::dump($mailMerge->getDocumentFormats());

    unset($mailMerge);

For executable demo applications, which illustrate the above, please take a look at
``/demos/ZendService/LiveDocx/MailMerge/supported-formats``.

.. _zendservice.livedocx.mailmerge.information.getimageexportformats:

.. rubric:: Get Array of Supported Image File Formats

The following code returns and displays an array of all supported image file formats. This method is particularly
useful in the case that a combo list should be displayed that allows the end-user to select the output format of
the documentation generation process.

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;
    use Zend\Debug\Debug;

    $mailMerge = new MailMerge();

    $mailMerge->setUsername('myUsername')
              ->setPassword('myPassword')
              ->setService (MailMerge::SERVICE_FREE);  // for LiveDocx Premium, use MailMerge::SERVICE_PREMIUM

    Debug::dump($mailMerge->getImageExportFormats());

    unset($mailMerge);

.. note::

   As the return value of this method changes very infrequently, it is highly recommended to use a cache,
   such as ``Zend\Cache\Cache``- this will considerably speed up your application.

For executable demo applications, which illustrate the above, please take a look at
``/demos/ZendService/LiveDocx/MailMerge/supported-formats``.

Upgrading From LiveDocx Free to LiveDocx Premium
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

LiveDocx Free is provided by *Text Control GmbH* completely free for charge. It is free for all to use in an
unlimited number of applications. However, there are times when you may like to update to LiveDocx Premium. For
example, you need to generate a very large number of documents concurrently, or your application requires
documents to be created faster than LiveDocx Free permits. For such scenarios, *Text Control GmbH* offers LiveDocx
Premium, a paid service with a number of benefits. For an overview of the benefits, please take a look at
`LiveDocx pricing`_.

This section of the manual offers a technical overview of how to upgrade from LiveDocx Free to LiveDocx Premium.

All you have to do, is make a very small change to the code that runs with LiveDocx Free. Your instantiation and
initialization of LiveDocx Free probably looks as follows:

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;

    $mailMerge = new MailMerge()

    $mailMerge->setUsername('myUsername')
              ->setPassword('myPassword')
              ->setService (MailMerge::SERVICE_FREE);

    // rest of your application here

    unset($mailMerge);

To use LiveDocx Premium, you simply need to change the service value from ``MailMerge::SERVICE_FREE`` to
``MailMerge::SERVICE_PREMIUM``, and set the username and password assigned to you for Livedocx Premium. This may,
or may not be the same as the credentials for LiveDocx Free. For example:

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;

    $mailMerge = new MailMerge()

    $mailMerge->setUsername('myPremiumUsername')
              ->setPassword('myPremiumPassword')
              ->setService (MailMerge::SERVICE_PREMIUM);

    // rest of your application here

    unset($mailMerge);

And that is all there is to it. The assignment of the premium WSDL to the component is handled internally and
automatically. You are now using LiveDocx Premium.

For executable demo applications, which illustrate the above, please take a look at
``/demos/ZendService/LiveDocx/MailMerge/instantiation``.

Upgrading From LiveDocx Free or LiveDocx Premium to LiveDocx Fully Licensed
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

LiveDocx Free and Livedocx Premium are provided by *Text Control GmbH* as a service. They are addressed over the
Internet. However, for certain applications, for example, ones that process very sensitive data (banking, health
or financial), you may not want to send your data across the Internet to a third party service, regardless of the
SSL encryption that both LiveDocx Free and Livedocx Premium offer as standard. For such scenarios, you can license
LiveDocx and install an entire LiveDocx server in your own network. As such, you completely control the flow of
data between your application and the backend LiveDocx server. For an overview of the benefits of LiveDocx Fully
Licensed, please take a look at `LiveDocx pricing`_.

This section of the manual offers a technical overview of how to upgrade from LiveDocx Free or LiveDocx Premium to
LiveDocx Fully Licensed.

All you have to do, is make a very small change to the code that runs with LiveDocx Free or LiveDocx Premium. Your
instantiation and initialization of LiveDocx Free or LiveDocx Premium probably looks as follows:

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;

    $mailMerge = new MailMerge()

    $mailMerge->setUsername('myUsername')
              ->setPassword('myPassword')
              ->setService (MailMerge::SERVICE_FREE);
           // or
           // ->setService (MailMerge::SERVICE_PREMIUM);

    // rest of your application here

    unset($mailMerge);

To use LiveDocx Fully Licensed, you simply need to set the WSDL of the backend LiveDocx server in your own
network. You can do this as follows:

.. code-block:: php
   :linenos:

    use ZendService\LiveDocx\MailMerge;

    $mailMerge = new MailMerge()

    $mailMerge->setUsername('myFullyLicensedUsername')
              ->setPassword('myFullyLicensedPassword')
              ->setWsdl    ('http://api.example.com/2.1/mailmerge.asmx?wsdl');

    // rest of your application here

    unset($mailMerge);

And that is all there is to it. You are now using LiveDocx Fully Licensed.

For executable demo applications, which illustrate the above, please take a look at
``/demos/ZendService/LiveDocx/MailMerge/instantiation``.

.. _`GitHub (ZendServiceLiveDocx)`: https://github.com/zendframework/ZendService\LiveDocx\LiveDocx
.. _`LiveDocx pricing`: http://www.livedocx.com/pub/pricing
.. _`mail-merge`: http://en.wikipedia.org/wiki/Mail_merge
.. _`LiveDocx API`: http://www.livedocx.com
.. _`LiveDocx in PHP`: http://www.phplivedocx.org/
.. _`LiveDocx SOAP API documentation`: http://www.livedocx.com/pub/documentation/api.aspx
.. _`LiveDocx WSDL`: https://api.livedocx.com/2.1/mailmerge.asmx?wsdl
.. _`LiveDocx blog and web site`: https://www.livedocx.com/
.. _`sign up`: https://www.livedocx.com/user/account_registration.aspx
.. _`example template`: http://www.phplivedocx.org/wp-content/uploads/2009/01/license-agreement-template.docx
.. _`example document`: http://www.phplivedocx.org/wp-content/uploads/2009/01/license-agreement-document.pdf
.. _`DOCX`: http://en.wikipedia.org/wiki/Office_Open_XML
.. _`DOC`: http://en.wikipedia.org/wiki/DOC_(computing)
.. _`RTF`: http://en.wikipedia.org/wiki/Rich_Text_Format
.. _`TXD`: http://www.textcontrol.com/
.. _`HTML`: http://en.wikipedia.org/wiki/Xhtml
.. _`PDF`: http://en.wikipedia.org/wiki/Portable_Document_Format
.. _`PDF/A`: http://en.wikipedia.org/wiki/PDF/A
.. _`TXT`: http://en.wikipedia.org/wiki/Text_file
.. _`BMP`: http://en.wikipedia.org/wiki/BMP_file_format
.. _`GIF`: http://en.wikipedia.org/wiki/GIF
.. _`JPG`: http://en.wikipedia.org/wiki/Jpg
.. _`PNG`: http://en.wikipedia.org/wiki/Portable_Network_Graphics
.. _`TIFF`: http://en.wikipedia.org/wiki/Tagged_Image_File_Format
.. _`WMF`: http://en.wikipedia.org/wiki/Windows_Metafile
.. _`template`: http://www.phplivedocx.org/wp-content/uploads/2009/01/license-agreement-template.docx
.. _`template file`: http://www.phplivedocx.org/wp-content/uploads/2009/01/telephone-bill-template.doc
.. _`PDF document`: http://www.phplivedocx.org/wp-content/uploads/2009/01/telephone-bill-document.pdf
