.. _zend.gdata.docs:

Using Google Documents List Data API
====================================

The Google Documents List Data *API* allows client applications to upload documents to Google Documents and list them in the form of Google Data *API* ("GData") feeds. Your client application can request a list of a user's documents, and query the content in an existing document.

See `http://code.google.com/apis/documents/overview.html`_ for more information about the Google Documents List *API*.

.. _zend.gdata.docs.listdocuments:

Get a List of Documents
-----------------------

You can get a list of the Google Documents for a particular user by using the ``getDocumentListFeed()`` method of the docs service. The service will return a ``Zend_Gdata_Docs_DocumentListFeed`` object containing a list of documents associated with the authenticated user.

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Docs::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $docs = new Zend_Gdata_Docs($client);
   $feed = $docs->getDocumentListFeed();

The resulting ``Zend_Gdata_Docs_DocumentListFeed`` object represents the response from the server. This feed contains a list of ``Zend_Gdata_Docs_DocumentListEntry`` objects (``$feed->entries``), each of which represents a single Google Document.

.. _zend.gdata.docs.creating:

Upload a Document
-----------------

You can create a new Google Document by uploading a word processing document, spreadsheet, or presentation. This example is from the interactive Docs.php sample which comes with the library. It demonstrates uploading a file and printing information about the result from the server.

.. code-block:: php
   :linenos:

   /**
    * Upload the specified document
    *
    * @param Zend_Gdata_Docs $docs The service object to use for communicating
    *     with the Google Documents server.
    * @param boolean $html True if output should be formatted for display in a
    *     web browser.
    * @param string $originalFileName The name of the file to be uploaded. The
    *     MIME type of the file is determined from the extension on this file
    *     name. For example, test.csv is uploaded as a comma separated volume
    *     and converted into a spreadsheet.
    * @param string $temporaryFileLocation (optional) The file in which the
    *     data for the document is stored. This is used when the file has been
    *     uploaded from the client's machine to the server and is stored in
    *     a temporary file which does not have an extension. If this parameter
    *     is null, the file is read from the originalFileName.
    */
   function uploadDocument($docs, $html, $originalFileName,
                           $temporaryFileLocation) {
     $fileToUpload = $originalFileName;
     if ($temporaryFileLocation) {
       $fileToUpload = $temporaryFileLocation;
     }

     // Upload the file and convert it into a Google Document. The original
     // file name is used as the title of the document and the MIME type
     // is determined based on the extension on the original file name.
     $newDocumentEntry = $docs->uploadFile($fileToUpload, $originalFileName,
         null, Zend_Gdata_Docs::DOCUMENTS_LIST_FEED_URI);

     echo "New Document Title: ";

     if ($html) {
         // Find the URL of the HTML view of this document.
         $alternateLink = '';
         foreach ($newDocumentEntry->link as $link) {
             if ($link->getRel() === 'alternate') {
                 $alternateLink = $link->getHref();
             }
         }
         // Make the title link to the document on docs.google.com.
         echo "<a href=\"$alternateLink\">\n";
     }
     echo $newDocumentEntry->title."\n";
     if ($html) {echo "</a>\n";}
   }

.. _zend.gdata.docs.queries:

Searching the documents feed
----------------------------

You can search the Document List using some of the `standard Google Data API query parameters`_. Categories are used to restrict the type of document (word processor document, spreadsheet) returned. The full-text query string is used to search the content of all the documents. More detailed information on parameters specific to the Documents List can be found in the `Documents List Data API Reference Guide`_.

.. _zend.gdata.docs.listwpdocuments:

Get a List of Word Processing Documents
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can also request a feed containing all of your documents of a specific type. For example, to see a list of your work processing documents, you would perform a category query as follows.

.. code-block:: php
   :linenos:

   $feed = $docs->getDocumentListFeed(
       'http://docs.google.com/feeds/documents/private/full/-/document');

.. _zend.gdata.docs.listspreadsheets:

Get a List of Spreadsheets
^^^^^^^^^^^^^^^^^^^^^^^^^^

To request a list of your Google Spreadsheets, use the following category query:

.. code-block:: php
   :linenos:

   $feed = $docs->getDocumentListFeed(
       'http://docs.google.com/feeds/documents/private/full/-/spreadsheet');

.. _zend.gdata.docs.textquery:

Performing a text query
^^^^^^^^^^^^^^^^^^^^^^^

You can search the content of documents by using a ``Zend_Gdata_Docs_Query`` in your request. A Query object can be used to construct the query *URI*, with the search term being passed in as a parameter. Here is an example method which queries the documents list for documents which contain the search string:

.. code-block:: php
   :linenos:

   $docsQuery = new Zend_Gdata_Docs_Query();
   $docsQuery->setQuery($query);
   $feed = $client->getDocumentListFeed($docsQuery);



.. _`http://code.google.com/apis/documents/overview.html`: http://code.google.com/apis/documents/overview.html
.. _`standard Google Data API query parameters`: http://code.google.com/apis/gdata/reference.html#Queries
.. _`Documents List Data API Reference Guide`: http://code.google.com/apis/documents/reference.html#Parameters
