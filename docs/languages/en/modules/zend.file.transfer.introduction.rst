.. _zend.file.transfer.introduction:

Zend_File_Transfer
==================

``Zend_File_Transfer`` provides extensive support for file uploads and downloads. It comes with built-in validators
for files plus functionality to change files with filters. Protocol adapters allow ``Zend_File_Transfer`` to expose
the same *API* for transport protocols like *HTTP*, FTP, WEBDAV and more.

.. note:: Limitation

   The current implementation of ``Zend_File_Transfer`` is limited to *HTTP* Post Uploads. Other adapters
   supporting downloads and other protocols will be added in future releases. Unimplemented methods will throw an
   exception. For now, you should use ``Zend_File_Transfer_Adapter_Http`` directly. As soon as there are multiple
   adapters available you can use a common interface.

.. note:: Forms

   When you are using ``Zend_Form`` you should use the *API*\ s provided by ``Zend_Form`` and not
   ``Zend_File_Transfer`` directly. The file transfer support in ``Zend_Form`` is implemented with
   ``Zend_File_Transfer``, so the information in this chapter may be useful for advanced users of ``Zend_Form``.

The usage of ``Zend_File_Transfer`` is relatively simple. It consists of two parts. The *HTTP* form does the
upload, while the ``Zend_File_Transfer`` handles the uploaded files. See the following example:

.. _zend.file.transfer.introduction.example:

.. rubric:: Simple Form for Uploading Files

This example illustrates basic file uploading. The first part is the file form. In our example there is one file to
upload.

.. code-block:: xml
   :linenos:

   <form enctype="multipart/form-data" action="/file/upload" method="POST">
       <input type="hidden" name="MAX_FILE_SIZE" value="100000" />
           Choose a file to upload: <input name="uploadedfile" type="file" />
       <br />
       <input type="submit" value="Upload File" />
   </form>

For convenience, you can use :ref:`Zend_Form_Element_File <zend.form.standardElements.file>` instead of building
the *HTML* manually.

The next step is to create the receiver of the upload. In our example the receiver is located at ``/file/upload``.
So next we will create the 'file' controller and the ``upload()`` action.

.. code-block:: php
   :linenos:

   $adapter = new Zend_File_Transfer_Adapter_Http();

   $adapter->setDestination('C:\temp');

   if (!$adapter->receive()) {
       $messages = $adapter->getMessages();
       echo implode("\n", $messages);
   }

This code listing demonstrates the simplest usage of ``Zend_File_Transfer``. A local destination is set with the
``setDestination()`` method, then the ``receive()`` method is called. if there are any upload errors, an error will
be returned.

.. note:: Attention

   This example is suitable only for demonstrating the basic *API* of ``Zend_File_Transfer``. You should **never**
   use this code listing in a production environment, because severe security issues may be introduced. You should
   always use validators to increase security.

.. _zend.file.transfer.introduction.adapters:

Supported Adapters for Zend_File_Transfer
-----------------------------------------

``Zend_File_Transfer`` is designed to support a variety of adapters and transfer directions. With
``Zend_File_Transfer`` you can upload, download and even forward (upload one adapter and download with another
adapter at the same time) files.

.. _zend.file.transfer.introduction.options:

Options for Zend_File_Transfer
------------------------------

``Zend_File_Transfer`` and its adapters support different options. You can set all options either by passing them
to the constructor or by calling ``setOptions($options)``. ``getOptions()`` will return the options that are
currently set. The following is a list of all supported options.

- **ignoreNoFile**: If this option is set to ``TRUE``, all validators will ignore files that have not been uploaded
  by the form. The default value is ``FALSE`` which results in an error if no files were specified.

.. _zend.file.transfer.introduction.checking:

Checking Files
--------------

``Zend_File_Transfer`` has several methods that check for various states of the specified file. These are useful if
you must process files after they have been uploaded. These methods include:

- **isValid($files = null)**: This method will check if the given files are valid, based on the validators that are
  attached to the files. If no files are specified, all files will be checked. You can call ``isValid()`` before
  calling ``receive()``; in this case, ``receive()`` will not call ``isValid()`` internally again when receiving
  the file.

- **isUploaded($files = null)**: This method will check if the specified files have been uploaded by the user. This
  is useful when you have defined one or more optional files. When no files are specified, all files will be
  checked.

- **isReceived($files = null)**: This method will check if the given files have already been received. When no
  files are specified, all files will be checked.

.. _zend.file.transfer.introduction.checking.example:

.. rubric:: Checking Files

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Returns all known internal file information
   $files = $upload->getFileInfo();

   foreach ($files as $file => $info) {
       // file uploaded ?
       if (!$upload->isUploaded($file)) {
           print "Why havn't you uploaded the file ?";
           continue;
       }

       // validators are ok ?
       if (!$upload->isValid($file)) {
           print "Sorry but $file is not what we wanted";
           continue;
       }
   }

   $upload->receive();

.. _zend.file.transfer.introduction.informations:

Additional File Informations
----------------------------

``Zend_File_Transfer`` can return additional information on files. The following methods are available:

- **getFileName($file = null, $path = true)**: This method will return the real file name of a transferred file.

- **getFileInfo($file = null)**: This method will return all internal information for the given file.

- **getFileSize($file = null)**: This method will return the real filesize for the given file.

- **getHash($hash = 'crc32', $files = null)**: This method returns a hash of the content of a given transferred
  file.

- **getMimeType($files = null)**: This method returns the mimetype of a given transferred file.

``getFileName()`` accepts the name of the element as first parameter. If no name is given, all known filenames will
be returned in an array. If the file is a multifile, you will also get an array. If there is only a single file a
string will be returned.

By default file names will be returned with the complete path. If you only need the file name without path, you can
set the second parameter, ``$path``, which will truncate the file path when set to ``FALSE``.

.. _zend.file.transfer.introduction.informations.example1:

.. rubric:: Getting the Filename

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();
   $upload->receive();

   // Returns the file names from all files
   $names = $upload->getFileName();

   // Returns the file names from the 'foo' form element
   $names = $upload->getFileName('foo');

.. note::

   Note that the file name can change after you receive the file, because all filters will be applied once the file
   is received. So you should always call ``getFileName()`` after the files have been received.

``getFileSize()`` returns per default the real filesize in SI notation which means you will get **2kB** instead of
**2048**. If you need only the plain size set the ``useByteString`` option to ``FALSE``.

.. _zend.file.transfer.introduction.informations.example.getfilesize:

.. rubric:: Getting the size of a file

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();
   $upload->receive();

   // Returns the sizes from all files as array if more than one file was uploaded
   $size = $upload->getFileSize();

   // Switches of the SI notation to return plain numbers
   $upload->setOption(array('useByteString' => false));
   $size = $upload->getFileSize();

.. note:: Client given filesize

   Note that the filesize which is given by the client is not seen as save input. Therefor the real size of the
   file will be detected and returned instead of the filesize sent by the client.

``getHash()`` accepts the name of a hash algorithm as first parameter. For a list of known algorithms refer to
`PHP's hash_algos method`_. If you don't specify an algorithm, the **crc32** algorithm will be used by default.

.. _zend.file.transfer.introduction.informations.example2:

.. rubric:: Getting the hash of a file

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();
   $upload->receive();

   // Returns the hashes from all files as array if more than one file was uploaded
   $hash = $upload->getHash('md5');

   // Returns the hash for the 'foo' form element
   $names = $upload->getHash('crc32', 'foo');

.. note:: Return value

   Note that if the given file or form name contains more than one file, the returned value will be an array.

``getMimeType()`` returns the mimetype of a file. If more than one file was uploaded it returns an array, otherwise
a string.

.. _zend.file.transfer.introduction.informations.getmimetype:

.. rubric:: Getting the mimetype of a file

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();
   $upload->receive();

   $mime = $upload->getMimeType();

   // Returns the mimetype for the 'foo' form element
   $names = $upload->getMimeType('foo');

.. note:: Client given mimetype

   Note that the mimetype which is given by the client is not seen as save input. Therefor the real mimetype of the
   file will be detected and returned instead of the mimetype sent by the client.

.. warning:: Possible exception

   Note that this method uses the fileinfo extension if it is available. If this extension can not be found, it
   uses the mimemagic extension. When no extension was found it raises an exception.

.. warning:: Original data within $_FILES

   Due to security reasons also the original data within $_FILES will be overridden as soon as
   ``Zend_File_Transfer`` is initiated. When you want to omit this behaviour and have the original data simply set
   the ``detectInfos`` option to ``FALSE`` at initiation.

   This option will have no effect after you initiated ``Zend_File_Transfer``.

.. _zend.file.transfer.introduction.uploadprogress:

Progress for file uploads
-------------------------

``Zend_File_Transfer`` can give you the actual state of a fileupload in progress. To use this feature you need
either the *APC* extension which is provided with most default *PHP* installations, or the ``UploadProgress``
extension. Both extensions are detected and used automatically. To be able to get the progress you need to meet
some prerequisites.

First, you need to have either *APC* or ``UploadProgress`` to be enabled. Note that you can disable this feature of
*APC* within your ``php.ini``.

Second, you need to have the proper hidden fields added in the form which sends the files. When you use
``Zend_Form_Element_File`` this hidden fields are automatically added by ``Zend_Form``.

When the above two points are provided then you are able to get the actual progress of the file upload by using the
``getProgress()`` method. Actually there are 2 official ways to handle this.

.. _zend.file.transfer.introduction.uploadprogress.progressadapter:

Using a progressbar adapter
^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can use the convinient **Zend_ProgressBar** to get the actual progress and can display it in a simple manner to
your user.

To archive this, you have to add the wished **Zend_ProgressBar_Adapter** to ``getProgress()`` when you are calling
it the first time. For details about the right adapter to use, look into the chapter :ref:`Zend_ProgressBar
Standard Adapters <zend.progressbar.adapters>`.

.. _zend.file.transfer.introduction.uploadprogress.progressadapter.example1:

.. rubric:: Using the progressbar adapter to retrieve the actual state

.. code-block:: php
   :linenos:

   $adapter = new Zend_ProgressBar_Adapter_Console();
   $upload  = Zend_File_Transfer_Adapter_Http::getProgress($adapter);

   $upload = null;
   while (!$upload['done']) {
       $upload = Zend_File_Transfer_Adapter_Http:getProgress($upload);
   }

The complete handling is done by ``getProgress()`` for you in the background.

.. _zend.file.transfer.introduction.uploadprogress.manually:

Using getProgress() manually
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can also work manually with ``getProgress()`` without the usage of ``Zend_ProgressBar``.

Call ``getProgress()`` without settings. It will return you an array with several keys. They differ according to
the used *PHP* extension. But the following keys are given independently of the extension:

- **id**: The ID of this upload. This ID identifies the upload within the extension. You can set it to the value of
  the hidden key which identified the upload when initially calling ``getProgress()``. Per default it is set to
  **progress_key**. You must not change the ID afterwards.

- **total**: The total filesize of the uploaded files in bytes as integer.

- **current**: The current uploaded filesize in bytes as integer.

- **rate**: The average upload speed in bytes per second as integer.

- **done**: Returns ``TRUE`` when the upload is finished and ``FALSE`` otherwise.

- **message**: The actual message. Either the progress as text in the form **10kB / 200kB**, or a helpful message
  in the case of a problem. Problems could be, that there is no upload in progress, that there was a failure while
  retrieving the data for the progress, or that the upload has been canceled.

- **progress**: This optional key takes a instance of ``Zend_ProgressBar_Adapter`` or ``Zend_ProgressBar`` and
  allows to get the actual upload state within a progressbar.

- **session**: This optional key takes the name of a session namespace which will be used within
  ``Zend_ProgressBar``. When this key is not given it defaults to ``Zend_File_Transfer_Adapter_Http_ProgressBar``.

All other returned keys are provided directly from the extensions and will not be checked.

The following example shows a possible manual usage:

.. _zend.file.transfer.introduction.uploadprogress.manually.example1:

.. rubric:: Manual usage of the file progress

.. code-block:: php
   :linenos:

   $upload  = Zend_File_Transfer_Adapter_Http::getProgress();

   while (!$upload['done']) {
       $upload = Zend_File_Transfer_Adapter_Http:getProgress($upload);
       print "\nActual progress:".$upload['message'];
       // do whatever you need
   }

.. note:: Knowing the file to get the progress from

   The above example works when your upload identified is set to 'progress_key'. When you are using another
   identifier within your form you must give the used identifier as first parameter to ``getProgress()`` on the
   initial call.



.. _`PHP's hash_algos method`: http://php.net/hash_algos
