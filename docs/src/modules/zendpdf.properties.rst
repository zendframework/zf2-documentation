.. _zendpdf.info:

Document Info and Metadata
==========================

A *PDF* document may include general information such as the document's title, author, and creation and
modification dates.

Historically this information is stored using special Info structure. This structure is available for read and
writing as an associative array using ``properties`` public property of ``ZendPdf\PdfDocument`` objects:

.. code-block:: php
   :linenos:

   $pdf = ZendPdf\PdfDocument::load($pdfPath);

   echo $pdf->properties['Title'] . "\n";
   echo $pdf->properties['Author'] . "\n";

   $pdf->properties['Title'] = 'New Title.';
   $pdf->save($pdfPath);

The following keys are defined by *PDF* v1.4 (Acrobat 5) standard:



   - **Title**- string, optional, the document's title.

   - **Author**- string, optional, the name of the person who created the document.

   - **Subject**- string, optional, the subject of the document.

   - **Keywords**- string, optional, keywords associated with the document.

   - **Creator**- string, optional, if the document was converted to *PDF* from another format, the name of the
     application (for example, Adobe FrameMaker®) that created the original document from which it was converted.

   - **Producer**- string, optional, if the document was converted to *PDF* from another format, the name of the
     application (for example, Acrobat Distiller) that converted it to *PDF*..

   - **CreationDate**- string, optional, the date and time the document was created, in the following form:
     "D:YYYYMMDDHHmmSSOHH'mm'", where:



        - **YYYY** is the year.

        - **MM** is the month.

        - **DD** is the day (01–31).

        - **HH** is the hour (00–23).

        - **mm**\ is the minute (00–59).

        - **SS** is the second (00–59).

        - **O** is the relationship of local time to Universal Time (UT), denoted by one of the characters +, −,
          or Z (see below).

        - **HH** followed by ' is the absolute value of the offset from UT in hours (00–23).

        - **mm** followed by ' is the absolute value of the offset from UT in minutes (00–59).

     The apostrophe character (') after HH and mm is part of the syntax. All fields after the year are optional.
     (The prefix D:, although also optional, is strongly recommended.) The default values for MM and DD are both
     01; all other numerical fields default to zero values. A plus sign (+) as the value of the O field signifies
     that local time is later than UT, a minus sign (−) that local time is earlier than UT, and the letter Z that
     local time is equal to UT. If no UT information is specified, the relationship of the specified time to UT is
     considered to be unknown. Whether or not the time zone is known, the rest of the date should be specified in
     local time.

     For example, December 23, 1998, at 7:52 PM, U.S. Pacific Standard Time, is represented by the string
     "D:199812231952−08'00'".

   - **ModDate**- string, optional, the date and time the document was most recently modified, in the same form as
     **CreationDate**.

   - **Trapped**- boolean, optional, indicates whether the document has been modified to include trapping
     information.



        - **TRUE**- The document has been fully trapped; no further trapping is needed.

        - **FALSE**- The document has not yet been trapped; any desired trapping must still be done.

        - **NULL**- Either it is unknown whether the document has been trapped or it has been partly but not yet
          fully trapped; some additional trapping may still be needed.





Since *PDF* v 1.6 metadata can be stored in the special *XML* document attached to the *PDF* (XMP -`Extensible
Metadata Platform`_).

This *XML* document can be retrieved and attached to the PDF with ``ZendPdf\PdfDocument::getMetadata()`` and
``ZendPdf\PdfDocument::setMetadata($metadata)`` methods:

.. code-block:: php
   :linenos:

   $pdf = ZendPdf\PdfDocument::load($pdfPath);
   $metadata = $pdf->getMetadata();
   $metadataDOM = new DOMDocument();
   $metadataDOM->loadXML($metadata);

   $xpath = new DOMXPath($metadataDOM);
   $pdfPreffixNamespaceURI = $xpath->query('/rdf:RDF/rdf:Description')
                                   ->item(0)
                                   ->lookupNamespaceURI('pdf');
   $xpath->registerNamespace('pdf', $pdfPreffixNamespaceURI);

   $titleNode = $xpath->query('/rdf:RDF/rdf:Description/pdf:Title')->item(0);
   $title = $titleNode->nodeValue;
   ...

   $titleNode->nodeValue = 'New title';
   $pdf->setMetadata($metadataDOM->saveXML());
   $pdf->save($pdfPath);

Common document properties are duplicated in the Info structure and Metadata document (if presented). It's user
application responsibility now to keep them synchronized.



.. _`Extensible Metadata Platform`: http://www.adobe.com/products/xmp/
