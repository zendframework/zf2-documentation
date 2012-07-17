
.. _zend.file.transfer.filters:

Filters for Zend_File_Transfer
==============================

``Zend_File_Transfer`` is delivered with several file related filters which can be used to automate several tasks which are often done on files. Note that file filters are applied after validation. Also file filters behave slightly different that other filters. They will always return the file name and not the changed content (which would be a bad idea when working on 1GB files). All filters which are provided with ``Zend_File_Transfer`` can be found in the ``Zend_Filter`` component and are named ``Zend_Filter_File_*``. The following filters are actually available:

- ``Decrypt``: This filter can decrypt a encrypted file.

- ``Encrypt``: This filter can encrypt a file.

- ``LowerCase``: This filter can lowercase the content of a textfile.

- ``Rename``: This filter can rename files, change the location and even force overwriting of existing files.

- ``UpperCase``: This filter can uppercase the content of a textfile.


.. _zend.file.transfer.filters.usage:

Using filters with Zend_File_Transfer
-------------------------------------

The usage of filters is quite simple. There are several methods for adding and manipulating filters.

- ``addFilter($filter, $options = null, $files = null)``: Adds the given filter to the filter stack (optionally only to the file(s) specified). ``$filter`` may be either an actual filter instance, or a short name specifying the filter type (e.g., 'Rename').

- ``addFilters(array $filters, $files = null)``: Adds the given filters to the stack of filters. Each entry may be either a filter type/options pair, or an array with the key 'filter' specifying the filter (all other options will be considered filter options for instantiation).

- ``setFilters(array $filters, $files = null)``: Overwrites any existing filters with the filters specified. The filters should follow the syntax for ``addFilters()``.

- ``hasFilter($name)``: Indicates if a filter has been registered.

- ``getFilter($name)``: Returns a previously registered filter.

- ``getFilters($files = null)``: Returns registered filters; if ``$files`` is passed, returns filters for that particular file or set of files.

- ``removeFilter($name)``: Removes a previously registered filter.

- ``clearFilters()``: Clears all registered filters.


.. _zend.file.transfer.filters.usage.example:

.. rubric:: Add filters to a file transfer

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Set a new destination path
   $upload->addFilter('Rename', 'C:\picture\uploads');

   // Set a new destination path and overwrites existing files
   $upload->addFilter('Rename',
                      array('target' => 'C:\picture\uploads',
                            'overwrite' => true));


.. _zend.file.transfer.filters.usage.exampletwo:

.. rubric:: Limit filters to single files

``addFilter()``, ``addFilters()``, and ``setFilters()`` each accept a final ``$files`` argument. This argument can be used to specify a particular file or array of files on which to set the given filter.

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Set a new destination path and limits it only to 'file2'
   $upload->addFilter('Rename', 'C:\picture\uploads', 'file2');

Generally you should simply use the ``addFilters()`` method, which can be called multiple times.


.. _zend.file.transfer.filters.usage.examplemultiple:

.. rubric:: Add multiple filters

Often it's simpler just to call ``addFilter()`` multiple times. One call for each filter. This also increases the readability and makes your code more maintainable. As all methods provide a fluent interface you can couple the calls as shown below:

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Set a filesize with 20000 bytes
   $upload->addFilter('Rename', 'C:\picture\newjpg', 'file1')
          ->addFilter('Rename', 'C:\picture\newgif', 'file2');

.. note::
   Note that even though setting the same filter multiple times is allowed, doing so can lead to issues when using different options for the same filter.



.. _zend.file.transfer.filters.decrypt:

Decrypt filter
--------------

The ``Decrypt`` filter allows to decrypt a encrypted file.

This filter makes use of ``Zend_Filter_Decrypt``. It supports the ``Mcrypt`` and ``OpenSSL`` extensions from *PHP*. Please read the related section for details about how to set the options for decryption and which options are supported.

This filter supports one additional option which can be used to save the decrypted file with another filename. Set the ``filename`` option to change the filename where the decrypted file will be stored. If you suppress this option, the decrypted file will overwrite the original encrypted file.


.. _zend.file.transfer.filters.decrypt.example1:

.. rubric:: Using the Decrypt filter with Mcrypt

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer_Adapter_Http();

   // Adds a filter to decrypt the uploaded encrypted file
   // with mcrypt and the key mykey
   $upload->addFilter('Decrypt',
       array('adapter' => 'mcrypt', 'key' => 'mykey'));


.. _zend.file.transfer.filters.decrypt.example2:

.. rubric:: Using the Decrypt filter with OpenSSL

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer_Adapter_Http();

   // Adds a filter to decrypt the uploaded encrypted file
   // with openssl and the provided keys
   $upload->addFilter('Decrypt',
       array('adapter' => 'openssl',
             'private' => '/path/to/privatekey.pem',
             'envelope' => '/path/to/envelopekey.pem'));


.. _zend.file.transfer.filters.encrypt:

Encrypt filter
--------------

The ``Encrypt`` filter allows to encrypt a file.

This filter makes use of ``Zend_Filter_Encrypt``. It supports the ``Mcrypt`` and ``OpenSSL`` extensions from *PHP*. Please read the related section for details about how to set the options for encryption and which options are supported.

This filter supports one additional option which can be used to save the encrypted file with another filename. Set the ``filename`` option to change the filename where the encrypted file will be stored. If you suppress this option, the encrypted file will overwrite the original file.


.. _zend.file.transfer.filters.encrypt.example1:

.. rubric:: Using the Encrypt filter with Mcrypt

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer_Adapter_Http();

   // Adds a filter to encrypt the uploaded file
   // with mcrypt and the key mykey
   $upload->addFilter('Encrypt',
       array('adapter' => 'mcrypt', 'key' => 'mykey'));


.. _zend.file.transfer.filters.encrypt.example2:

.. rubric:: Using the Encrypt filter with OpenSSL

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer_Adapter_Http();

   // Adds a filter to encrypt the uploaded file
   // with openssl and the provided keys
   $upload->addFilter('Encrypt',
       array('adapter' => 'openssl',
             'public' => '/path/to/publickey.pem'));


.. _zend.file.transfer.filters.lowercase:

LowerCase filter
----------------

The ``LowerCase`` filter allows to change the content of a file to lowercase. You should use this filter only on textfiles.

At initiation you can give a string which will then be used as encoding. Or you can use the ``setEncoding()`` method to set it afterwards.


.. _zend.file.transfer.filters.lowercase.example:

.. rubric:: Using the LowerCase filter

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('MimeType', 'text');

   // Adds a filter to lowercase the uploaded textfile
   $upload->addFilter('LowerCase');

   // Adds a filter to lowercase the uploaded file but only for uploadfile1
   $upload->addFilter('LowerCase', null, 'uploadfile1');

   // Adds a filter to lowercase with encoding set to ISO-8859-1
   $upload->addFilter('LowerCase', 'ISO-8859-1');

.. note::
   Note that due to the fact that the options for the LowerCase filter are optional, you must give a ``NULL`` as second parameter (the options) when you want to limit it to a single file element.



.. _zend.file.transfer.filters.rename:

Rename filter
-------------

The ``Rename`` filter allows to change the destination of the upload, the filename and also to overwrite existing files. It supports the following options:

- ``source``: The name and destination of the old file which shall be renamed.

- ``target``: The new directory, or filename of the file.

- ``overwrite``: Sets if the old file overwrites the new one if it already exists. The default value is ``FALSE``.

Additionally you can also use the method ``setFile()`` to set files, which erases all previous set, ``addFile()`` to add a new file to existing ones, and ``getFile()`` to get all actually set files. To simplify things, this filter understands several notations and that methods and constructor understand the same notations.


.. _zend.file.transfer.filters.rename.example:

.. rubric:: Using the Rename filter

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer_Adapter_Http();

   // Set a new destination path for all files
   $upload->addFilter('Rename', 'C:\mypics\new');

   // Set a new destination path only for uploadfile1
   $upload->addFilter('Rename', 'C:\mypics\newgifs', 'uploadfile1');

You can use different notations. Below is a table where you will find a description and the intention for the supported notations. Note that when you use the Adapter or the Form Element you will not be able to use all described notations.


.. _zend.file.transfer.filters.rename.notations:

.. table:: Different notations of the rename filter and their meaning

   +-----------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |notation                                                                                       |description                                                                                                                                                                                                                                 |
   +===============================================================================================+============================================================================================================================================================================================================================================+
   |addFile('C:\\uploads')                                                                         |Specifies a new location for all files when the given string is a directory. Note that you will get an exception when the file already exists, see the overwriting parameter.                                                               |
   +-----------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addFile('C:\\uploads\\file.ext')                                                               |Specifies a new location and filename for all files when the given string is not detected as directory. Note that you will get an exception when the file already exists, see the overwriting parameter.                                    |
   +-----------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addFile(array('C:\\uploads\\file.ext', 'overwrite' => true))                                   |Specifies a new location and filename for all files when the given string is not detected as directory and overwrites an existing file with the same target name. Note, that you will get no notification that a file was overwritten.      |
   +-----------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addFile(array('source' => 'C:\\temp\\uploads', 'target' => 'C:\\uploads'))                     |Specifies a new location for all files in the old location when the given strings are detected as directory. Note that you will get an exception when the file already exists, see the overwriting parameter.                               |
   +-----------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addFile(array('source' => 'C:\\temp\\uploads', 'target' => 'C:\\uploads', 'overwrite' => true))|Specifies a new location for all files in the old location when the given strings are detected as directory and overwrites and existing file with the same target name. Note, that you will get no notification that a file was overwritten.|
   +-----------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _zend.file.transfer.filters.uppercase:

UpperCase filter
----------------

The ``UpperCase`` filter allows to change the content of a file to uppercase. You should use this filter only on textfiles.

At initiation you can give a string which will then be used as encoding. Or you can use the ``setEncoding()`` method to set it afterwards.


.. _zend.file.transfer.filters.uppercase.example:

.. rubric:: Using the UpperCase filter

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('MimeType', 'text');

   // Adds a filter to uppercase the uploaded textfile
   $upload->addFilter('UpperCase');

   // Adds a filter to uppercase the uploaded file but only for uploadfile1
   $upload->addFilter('UpperCase', null, 'uploadfile1');

   // Adds a filter to uppercase with encoding set to ISO-8859-1
   $upload->addFilter('UpperCase', 'ISO-8859-1');

.. note::
   Note that due to the fact that the options for the UpperCase filter are optional, you must give a ``NULL`` as second parameter (the options) when you want to limit it to a single file element.



