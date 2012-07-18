.. _zend.file.transfer.validators:

Validators for Zend_File_Transfer
=================================

``Zend_File_Transfer`` is delivered with several file-related validators which can be used to increase security and prevent possible attacks. Note that these validators are only as effective as how effectively you apply them. All validators provided with ``Zend_File_Transfer`` can be found in the ``Zend_Validator`` component and are named ``Zend_Validate_File_*``. The following validators are available:

- ``Count``: This validator checks for the number of files. A minimum and maximum range can be specified. An error will be thrown if either limit is crossed.

- ``Crc32``: This validator checks for the crc32 hash value of the content from a file. It is based on the ``Hash`` validator and provides a convenient and simple validator that only supports Crc32.

- ``ExcludeExtension``: This validator checks the extension of files. It will throw an error when an given file has a defined extension. With this validator, you can exclude defined extensions from being validated.

- ``ExcludeMimeType``: This validator validates the *MIME* type of files. It can also validate *MIME* types and will throw an error if the *MIME* type of specified file matches.

- ``Exists``: This validator checks for the existence of files. It will throw an error when a specified file does not exist.

- ``Extension``: This validator checks the extension of files. It will throw an error when a specified file has an undefined extension.

- ``FilesSize``: This validator checks the size of validated files. It remembers internally the size of all checked files and throws an error when the sum of all specified files exceed the defined size. It also provides minimum and maximum values.

- ``ImageSize``: This validator checks the size of image. It validates the width and height and enforces minimum and maximum dimensions.

- ``IsCompressed``: This validator checks whether the file is compressed. It is based on the ``MimeType`` validator and validates for compression archives like zip or arc. You can also limit it to other archives.

- ``IsImage``: This validator checks whether the file is an image. It is based on the ``MimeType`` validator and validates for image files like jpg or gif. You can also limit it to other image types.

- ``Hash``: This validator checks the hash value of the content from a file. It supports multiple algorithms.

- ``Md5``: This validator checks for the md5 hash value of the content from a file. It is based on the ``Hash`` validator and provides a convenient and simple validator that only supports Md5.

- ``MimeType``: This validator validates the *MIME* type of files. It can also validate *MIME* types and will throw an error if the *MIME* type of a specified file does not match.

- ``NotExists``: This validator checks for the existence of files. It will throw an error when an given file does exist.

- ``Sha1``: This validator checks for the sha1 hash value of the content from a file. It is based on the ``Hash`` validator and provides a convenient and simple validator that only supports sha1.

- ``Size``: This validator is able to check files for its file size. It provides a minimum and maximum size range and will throw an error when either of these thesholds are crossed.

- ``Upload``: This validator is internal. It checks if an upload has resulted in an error. You must not set it, as it's automatically set by ``Zend_File_Transfer`` itself. So you do not use this validator directly. You should only know that it exists.

- ``WordCount``: This validator is able to check the number of words within files. It provides a minimum and maximum count and will throw an error when either of these thresholds are crossed.

.. _zend.file.transfer.validators.usage:

Using Validators with Zend_File_Transfer
----------------------------------------

Putting validators to work is quite simple. There are several methods for adding and manipulating validators:

- ``isValid($files = null)``: Checks the specified files using all validators. ``$files`` may be either a real filename, the element's name or the name of the temporary file.

- ``addValidator($validator, $breakChainOnFailure, $options = null, $files = null)``: Adds the specified validator to the validator stack (optionally only to the file(s) specified). ``$validator`` may be either an actual validator instance or a short name specifying the validator type (e.g., 'Count').

- ``addValidators(array $validators, $files = null)``: Adds the specified validators to the stack of validators. Each entry may be either a validator type/options pair or an array with the key 'validator' specifying the validator. All other options will be considered validator options for instantiation.

- ``setValidators(array $validators, $files = null)``: Overwrites any existing validators with the validators specified. The validators should follow the syntax for ``addValidators()``.

- ``hasValidator($name)``: Indicates whether a validator has been registered.

- ``getValidator($name)``: Returns a previously registered validator.

- ``getValidators($files = null)``: Returns registered validators. If ``$files`` is specified, returns validators for that particular file or set of files.

- ``removeValidator($name)``: Removes a previously registered validator.

- ``clearValidators()``: Clears all registered validators.

.. _zend.file.transfer.validators.usage.example:

.. rubric:: Add Validators to a File Transfer Object

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Set a file size with 20000 bytes
   $upload->addValidator('Size', false, 20000);

   // Set a file size with 20 bytes minimum and 20000 bytes maximum
   $upload->addValidator('Size', false, array('min' => 20, 'max' => 20000));

   // Set a file size with 20 bytes minimum and 20000 bytes maximum and
   // a file count in one step
   $upload->setValidators(array(
       'Size'  => array('min' => 20, 'max' => 20000),
       'Count' => array('min' => 1, 'max' => 3),
   ));

.. _zend.file.transfer.validators.usage.exampletwo:

.. rubric:: Limit Validators to Single Files

``addValidator()``, ``addValidators()``, and ``setValidators()`` each accept a final ``$files`` argument. This argument can be used to specify a particular file or array of files on which to set the given validator.

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Set a file size with 20000 bytes and limits it only to 'file2'
   $upload->addValidator('Size', false, 20000, 'file2');

Normally, you should use the ``addValidators()`` method, which can be called multiple times.

.. _zend.file.transfer.validators.usage.examplemultiple:

.. rubric:: Add Multiple Validators

Often it's simpler just to call ``addValidator()`` multiple times with one call for each validator. This also increases readability and makes your code more maintainable. All methods provide a fluent interface, so you can couple the calls as shown below:

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Set a file size with 20000 bytes
   $upload->addValidator('Size', false, 20000)
          ->addValidator('Count', false, 2)
          ->addValidator('Filessize', false, 25000);

.. note::

   Note that setting the same validator multiple times is allowed, but doing so can lead to issues when using different options for the same validator.

Last but not least, you can simply check the files using ``isValid()``.

.. _zend.file.transfer.validators.usage.exampleisvalid:

.. rubric:: Validate the Files

``isValid()`` accepts the file name of the uploaded or downloaded file, the temporary file name and or the name of the form element. If no parameter or null is given all files will be validated

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Set a file size with 20000 bytes
   $upload->addValidator('Size', false, 20000)
          ->addValidator('Count', false, 2)
          ->addValidator('Filessize', false, 25000);

   if (!$upload->isValid()) {
       print "Validation failure";
   }

.. note::

   Note that ``isValid()`` will be called automatically when you receive the files and have not called it previously.

When validation has failed it is a good idea to get information about the problems found. To get this information, you can use the methods ``getMessages()`` which returns all validation messages as array, ``getErrors()`` which returns all error codes, and ``hasErrors()`` which returns ``TRUE`` as soon as a validation error has been found.

.. _zend.file.transfer.validators.count:

Count Validator
---------------

The ``Count`` validator checks for the number of files which are provided. It supports the following option keys:

- ``min``: Sets the minimum number of files to transfer.

  .. note::

     When using this option you must give the minimum number of files when calling this validator the first time; otherwise you will get an error in return.

  With this option you can define the minimum number of files you expect to receive.

- ``max``: Sets the maximum number of files to transfer.

  With this option you can limit the number of files which are accepted but also detect a possible attack when more files are given than defined in your form.

If you initiate this validator with a string or integer, the value will be used as ``max``. Or you can also use the methods ``setMin()`` and ``setMax()`` to set both options afterwards and ``getMin()`` and ``getMax()`` to retrieve the actual set values.

.. _zend.file.transfer.validators.count.example:

.. rubric:: Using the Count Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Limit the amount of files to maximum 2
   $upload->addValidator('Count', false, 2);

   // Limit the amount of files to maximum 5 and minimum 1 file
   $upload->addValidator('Count', false, array('min' =>1, 'max' => 5));

.. note::

   Note that this validator stores the number of checked files internally. The file which exceeds the maximum will be returned as error.

.. _zend.file.transfer.validators.crc32:

Crc32 Validator
---------------

The ``Crc32`` validator checks the content of a transferred file by hashing it. This validator uses the hash extension from *PHP* with the crc32 algorithm. It supports the following options:

- ``*``: Sets any key or use a numeric array. The values will be used as hash to validate against.

  You can set multiple hashes by using different keys. Each will be checked and the validation will fail only if all values fail.

.. _zend.file.transfer.validators.crc32.example:

.. rubric:: Using the Crc32 Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Checks whether the content of the uploaded file has the given hash
   $upload->addValidator('Crc32', false, '3b3652f');

   // Limits this validator to two different hashes
   $upload->addValidator('Crc32', false, array('3b3652f', 'e612b69'));

.. _zend.file.transfer.validators.excludeextension:

ExcludeExtension Validator
--------------------------

The ``ExcludeExtension`` validator checks the file extension of the specified files. It supports the following options:

- ``*``: Sets any key or use a numeric array. The values will be used to check whether the given file does not use this file extension.

- ``case``: Sets a boolean indicating whether validation should be case-sensitive. The default is not case sensitive. Note that this key can be applied to for all available extensions.

This validator accepts multiple extensions, either as a comma-delimited string, or as an array. You may also use the methods ``setExtension()``, ``addExtension()``, and ``getExtension()`` to set and retrieve extensions.

In some cases it is useful to match in a case-sensitive fashion. So the constructor allows a second parameter called ``$case`` which, if set to ``TRUE``, validates the extension by comparing it with the specified values in a case-sensitive fashion.

.. _zend.file.transfer.validators.excludeextension.example:

.. rubric:: Using the ExcludeExtension Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Do not allow files with extension php or exe
   $upload->addValidator('ExcludeExtension', false, 'php,exe');

   // Do not allow files with extension php or exe, but use array notation
   $upload->addValidator('ExcludeExtension', false, array('php', 'exe'));

   // Check in a case-sensitive fashion
   $upload->addValidator('ExcludeExtension',
                         false,
                         array('php', 'exe', 'case' => true));
   $upload->addValidator('ExcludeExtension',
                         false,
                         array('php', 'exe', 'case' => true));

.. note::

   Note that this validator only checks the file extension. It does not check the file's *MIME* type.

.. _zend.file.transfer.validators.excludemimetype:

ExcludeMimeType Validator
-------------------------

The ``ExcludeMimeType`` validator checks the *MIME* type of transferred files. It supports the following options:

- ``*``: Sets any key individually or use a numeric array. Sets the *MIME* type to validate against.

  With this option you can define the *MIME* type of files that are not to be accepted.

- ``headerCheck``: If set to ``TRUE`` this option will check the *HTTP* Information for the file type when the **fileInfo** or **mimeMagic** extensions can not be found. The default value for this option is ``FALSE``.

This validator accepts multiple *MIME* types, either as a comma-delimited string, or as an array. You may also use the methods ``setMimeType()``, ``addMimeType()``, and ``getMimeType()`` to set and retrieve the *MIME* types.

.. _zend.file.transfer.validators.excludemimetype.example:

.. rubric:: Using the ExcludeMimeType Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Does not allow MIME type of gif images for all files
   $upload->addValidator('ExcludeMimeType', false, 'image/gif');

   // Does not allow MIME type of gif and jpg images for all given files
   $upload->addValidator('ExcludeMimeType', false, array('image/gif',
                                                         'image/jpeg');

   // Does not allow MIME type of the group images for all given files
   $upload->addValidator('ExcludeMimeType', false, 'image');

The above example shows that it is also possible to disallow groups of *MIME* types. For example, to disallow all images, just use 'image' as the *MIME* type. This can be used for all groups of *MIME* types like 'image', 'audio', 'video', 'text', etc.

.. note::

   Note that disallowing groups of *MIME* types will disallow all members of this group even if this is not intentional. When you disallow 'image' you will disallow all types of images like 'image/jpeg' or 'image/vasa'. When you are not sure if you want to disallow all types, you should disallow only specific *MIME* types instead of complete groups.

.. _zend.file.transfer.validators.exists:

Exists Validator
----------------

The ``Exists`` validator checks for the existence of specified files. It supports the following options:

- ``*``: Sets any key or use a numeric array to check if the specific file exists in the given directory.

This validator accepts multiple directories, either as a comma-delimited string, or as an array. You may also use the methods ``setDirectory()``, ``addDirectory()``, and ``getDirectory()`` to set and retrieve directories.

.. _zend.file.transfer.validators.exists.example:

.. rubric:: Using the Exists Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Add the temp directory to check for
   $upload->addValidator('Exists', false, '\temp');

   // Add two directories using the array notation
   $upload->addValidator('Exists',
                         false,
                         array('\home\images', '\home\uploads'));

.. note::

   Note that this validator checks whether the specified file exists in all of the given directories. The validation will fail if the file does not exist in any of the given directories.

.. _zend.file.transfer.validators.extension:

Extension Validator
-------------------

The ``Extension`` validator checks the file extension of the specified files. It supports the following options:

- ``*``: Sets any key or use a numeric array to check whether the specified file has this file extension.

- ``case``: Sets whether validation should be done in a case-sensitive fashion. The default is no case sensitivity. Note the this key is used for all given extensions.

This validator accepts multiple extensions, either as a comma-delimited string, or as an array. You may also use the methods ``setExtension()``, ``addExtension()``, and ``getExtension()`` to set and retrieve extension values.

In some cases it is useful to test in a case-sensitive fashion. Therefore the constructor takes a second parameter ``$case``, which, if set to ``TRUE``, will validate the extension in a case-sensitive fashion.

.. _zend.file.transfer.validators.extension.example:

.. rubric:: Using the Extension Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Limit the extensions to jpg and png files
   $upload->addValidator('Extension', false, 'jpg,png');

   // Limit the extensions to jpg and png files but use array notation
   $upload->addValidator('Extension', false, array('jpg', 'png'));

   // Check case sensitive
   $upload->addValidator('Extension', false, array('mo', 'png', 'case' => true));
   if (!$upload->isValid('C:\temp\myfile.MO')) {
       print 'Not valid because MO and mo do not match with case sensitivity;
   }

.. note::

   Note that this validator only checks the file extension. It does not check the file's *MIME* type.

.. _zend.file.transfer.validators.filessize:

FilesSize Validator
-------------------

The ``FilesSize`` validator checks for the aggregate size of all transferred files. It supports the following options:

- ``min``: Sets the minimum aggregate file size. This option defines the minimum aggregate file size to be transferred.

- ``max``: Sets the maximum aggregate file size.

  This option limits the aggregate file size of all transferred files, but not the file size of individual files.

- ``bytestring``: Defines whether a failure is to return a user-friendly number or the plain file size.

  This option defines whether the user sees '10864' or '10MB'. The default value is ``TRUE``, so '10MB' is returned if you did not specify otherwise.

You can initialize this validator with a string, which will then be used to set the ``max`` option. You can also use the methods ``setMin()`` and ``setMax()`` to set both options after construction, along with ``getMin()`` and ``getMax()`` to retrieve the values that have been set previously.

The size itself is also accepted in SI notation as handled by most operating systems. That is, instead of specifying **20000 bytes**, **20kB** may be given. All file sizes are converted using 1024 as the base value. The following Units are accepted: **kB**, **MB**, **GB**, **TB**, **PB** and **EB**. Note that 1kB is equal to 1024 bytes, 1MB is equal to 1024kB, and so on.

.. _zend.file.transfer.validators.filessize.example:

.. rubric:: Using the FilesSize Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Limit the size of all files to be uploaded to 40000 bytes
   $upload->addValidator('FilesSize', false, 40000);

   // Limit the size of all files to be uploaded to maximum 4MB and mimimum 10kB
   $upload->addValidator('FilesSize',
                         false,
                         array('min' => '10kB', 'max' => '4MB'));

   // As before, but returns the plain file size instead of a user-friendly string
   $upload->addValidator('FilesSize',
                         false,
                         array('min' => '10kB',
                               'max' => '4MB',
                               'bytestring' => false));

.. note::

   Note that this validator internally stores the file size of checked files. The file which exceeds the size will be returned as an error.

.. _zend.file.transfer.validators.imagesize:

ImageSize Validator
-------------------

The ``ImageSize`` validator checks the size of image files. It supports the following options:

- ``minheight``: Sets the minimum image height.

- ``maxheight``: Sets the maximum image height.

- ``minwidth``: Sets the minimum image width.

- ``maxwidth``: Sets the maximum image width.

The methods ``setImageMin()`` and ``setImageMax()`` also set both minimum and maximum values, while the methods ``getMin()`` and ``getMax()`` return the currently set values.

For your convenience there are also the ``setImageWidth()`` and ``setImageHeight()`` methods, which set the minimum and maximum height and width of the image file. They, too, have corresponding ``getImageWidth()`` and ``getImageHeight()`` methods to retrieve the currently set values.

To bypass validation of a particular dimension, the relevent option simply should not be set.

.. _zend.file.transfer.validators.imagesize.example:

.. rubric:: Using the ImageSize Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Limit the size of a image to a height of 100-200 and a width of
   // 40-80 pixel
   $upload->addValidator('ImageSize', false,
                         array('minwidth' => 40,
                               'maxwidth' => 80,
                               'minheight' => 100,
                               'maxheight' => 200)
                         );

   // Reset the width for validation
   $upload->setImageWidth(array('minwidth' => 20, 'maxwidth' => 200));

.. _zend.file.transfer.validators.iscompressed:

IsCompressed Validator
----------------------

The ``IsCompressed`` validator checks if a transferred file is a compressed archive, such as zip or arc. This validator is based on the ``MimeType`` validator and supports the same methods and options. You may also limit this validator to particular compression types with the methods described there.

.. _zend.file.transfer.validators.iscompressed.example:

.. rubric:: Using the IsCompressed Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Checks is the uploaded file is a compressed archive
   $upload->addValidator('IsCompressed', false);

   // Limits this validator to zip files only
   $upload->addValidator('IsCompressed', false, array('application/zip'));

   // Limits this validator to zip files only using simpler notation
   $upload->addValidator('IsCompressed', false, 'zip');

.. note::

   Note that there is no check if you set a *MIME* type that is not a archive. For example, it would be possible to define gif files to be accepted by this validator. Using the 'MimeType' validator for files which are not archived will result in more readable code.

.. _zend.file.transfer.validators.isimage:

IsImage Validator
-----------------

The ``IsImage`` validator checks if a transferred file is a image file, such as gif or jpeg. This validator is based on the ``MimeType`` validator and supports the same methods and options. You can limit this validator to particular image types with the methods described there.

.. _zend.file.transfer.validators.isimage.example:

.. rubric:: Using the IsImage Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Checks whether the uploaded file is a image file
   $upload->addValidator('IsImage', false);

   // Limits this validator to gif files only
   $upload->addValidator('IsImage', false, array('application/gif'));

   // Limits this validator to jpeg files only using a simpler notation
   $upload->addValidator('IsImage', false, 'jpeg');

.. note::

   Note that there is no check if you set a *MIME* type that is not an image. For example, it would be possible to define zip files to be accepted by this validator. Using the 'MimeType' validator for files which are not images will result in more readable code.

.. _zend.file.transfer.validators.hash:

Hash Validator
--------------

The ``Hash`` validator checks the content of a transferred file by hashing it. This validator uses the hash extension from *PHP*. It supports the following options:

- ``*``: Takes any key or use a numeric array. Sets the hash to validate against.

  You can set multiple hashes by passing them as an array. Each file is checked, and the validation will fail only if all files fail validation.

- ``algorithm``: Sets the algorithm to use for hashing the content.

  You can set multiple algorithm by calling the ``addHash()`` method multiple times.

.. _zend.file.transfer.validators.hash.example:

.. rubric:: Using the Hash Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Checks if the content of the uploaded file contains the given hash
   $upload->addValidator('Hash', false, '3b3652f');

   // Limits this validator to two different hashes
   $upload->addValidator('Hash', false, array('3b3652f', 'e612b69'));

   // Sets a different algorithm to check against
   $upload->addValidator('Hash',
                         false,
                         array('315b3cd8273d44912a7',
                               'algorithm' => 'md5'));

.. note::

   This validator supports about 34 different hash algorithms. The most common include 'crc32', 'md5' and 'sha1'. A comprehesive list of supports hash algorithms can be found at the `hash_algos method`_ on the `php.net site`_.

.. _zend.file.transfer.validators.md5:

Md5 Validator
-------------

The ``Md5`` validator checks the content of a transferred file by hashing it. This validator uses the hash extension for *PHP* with the md5 algorithm. It supports the following options:

- ``*``: Takes any key or use a numeric array.

  You can set multiple hashes by passing them as an array. Each file is checked, and the validation will fail only if all files fail validation.

.. _zend.file.transfer.validators.md5.example:

.. rubric:: Using the Md5 Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Checks if the content of the uploaded file has the given hash
   $upload->addValidator('Md5', false, '3b3652f336522365223');

   // Limits this validator to two different hashes
   $upload->addValidator('Md5',
                         false,
                         array('3b3652f336522365223',
                               'eb3365f3365ddc65365'));

.. _zend.file.transfer.validators.mimetype:

MimeType Validator
------------------

The ``MimeType`` validator checks the *MIME* type of transferred files. It supports the following options:

- ``*``: Sets any key or use a numeric array. Sets the *MIME* type to validate against.

  Defines the *MIME* type of files to be accepted.

- ``headerCheck``: If set to ``TRUE`` this option will check the *HTTP* Information for the file type when the **fileInfo** or **mimeMagic** extensions can not be found. The default value for this option is ``FALSE``.

- ``magicfile``: The magicfile to be used.

  With this option you can define which magicfile to use. When it's not set or empty, the MAGIC constant will be used instead. This option is available since Zend Framework 1.7.1.

  When you omit this option or set it to ``NULL``, the environment variable 'magic' will be used to get the proper magicfile. When you set it to 'false', PHP will use the build it magic file. A 'string' will be seen as filename or path to the magicfile.

This validator accepts multiple *MIME* type, either as a comma-delimited string, or as an array. You may also use the methods ``setMimeType()``, ``addMimeType()``, and ``getMimeType()`` to set and retrieve *MIME* type.

You can also set the magicfile which shall be used by fileinfo with the 'magicfile' option. Additionally there are convenient ``setMagicFile()`` and ``getMagicFile()`` methods which allow later setting and retrieving of the magicfile parameter. This methods are available since Zend Framework 1.7.1.

.. _zend.file.transfer.validators.mimetype.example:

.. rubric:: Using the MimeType Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Limit the MIME type of all given files to gif images
   $upload->addValidator('MimeType', false, 'image/gif');

   // Limit the MIME type of all given files to gif and jpeg images
   $upload->addValidator('MimeType', false, array('image/gif', 'image/jpeg');

   // Limit the MIME type of all given files to the group images
   $upload->addValidator('MimeType', false, 'image');

   // Use a different magicfile
   $upload->addValidator('MimeType',
                         false,
                         array('image',
                               'magicfile' => '/path/to/magicfile.mgx'));

The above example shows that it is also possible to limit the accepted *MIME* type to a group of *MIME* types. To allow all images just use 'image' as *MIME* type. This can be used for all groups of *MIME* types like 'image', 'audio', 'video', 'text, and so on.

By using ``disableMagicFile(true)`` the MimeType validator will use PHP's build in magic file. You should use this method when you have PHP 5.3 or higher and want to use the magic file which is provided by PHP itself. By using ``isMagicFileDisabled()`` you can check if magicfile is actually disabled or not.

.. note::

   Note that allowing groups of *MIME* types will accept all members of this group even if your application does not support them. When you allow 'image' you will also get 'image/xpixmap' or 'image/vasa' which could be problematic. When you are not sure if your application supports all types you should better allow only defined *MIME* types instead of the complete group.

.. note::

   This component will use the ``FileInfo`` extension if it is available. If it's not, it will degrade to the ``mime_content_type()`` function. And if the function call fails it will use the *MIME* type which is given by *HTTP*.

   You should be aware of possible security problems when you have whether ``FileInfo`` nor ``mime_content_type()`` available. The *MIME* type given by *HTTP* is not secure and can be easily manipulated.

.. _zend.file.transfer.validators.notexists:

NotExists Validator
-------------------

The ``NotExists`` validator checks for the existence of the provided files. It supports the following options:

- ``*``: Set any key or use a numeric array. Checks whether the file exists in the given directory.

This validator accepts multiple directories either as a comma-delimited string, or as an array. You may also use the methods ``setDirectory()``, ``addDirectory()``, and ``getDirectory()`` to set and retrieve directories.

.. _zend.file.transfer.validators.notexists.example:

.. rubric:: Using the NotExists Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Add the temp directory to check
   $upload->addValidator('NotExists', false, '\temp');

   // Add two directories using the array notation
   $upload->addValidator('NotExists', false,
                         array('\home\images',
                               '\home\uploads')
                        );

.. note::

   Note that this validator checks if the file does not exist in all of the provided directories. The validation will fail if the file does exist in any of the given directories.

.. _zend.file.transfer.validators.sha1:

Sha1 Validator
--------------

The ``Sha1`` validator checks the content of a transferred file by hashing it. This validator uses the hash extension for *PHP* with the sha1 algorithm. It supports the following options:

- ``*``: Takes any key or use a numeric array.

  You can set multiple hashes by passing them as an array. Each file is checked, and the validation will fail only if all files fail validation.

.. _zend.file.transfer.validators.sha1.example:

.. rubric:: Using the sha1 Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Checks if the content of the uploaded file has the given hash
   $upload->addValidator('sha1', false, '3b3652f336522365223');

   // Limits this validator to two different hashes
   $upload->addValidator('Sha1',
                         false, array('3b3652f336522365223',
                                      'eb3365f3365ddc65365'));

.. _zend.file.transfer.validators.size:

Size Validator
--------------

The ``Size`` validator checks for the size of a single file. It supports the following options:

- ``min``: Sets the minimum file size.

- ``max``: Sets the maximum file size.

- ``bytestring``: Defines whether a failure is returned with a user-friendly number, or with the plain file size.

  With this option you can define if the user gets '10864' or '10MB'. Default value is ``TRUE`` which returns '10MB'.

You can initialize this validator with a string, which will then be used to set the ``max`` option. You can also use the methods ``setMin()`` and ``setMax()`` to set both options after construction, along with ``getMin()`` and ``getMax()`` to retrieve the values that have been set previously.

The size itself is also accepted in SI notation as handled by most operating systems. That is, instead of specifying **20000 bytes**, **20kB** may be given. All file sizes are converted using 1024 as the base value. The following Units are accepted: **kB**, **MB**, **GB**, **TB**, **PB** and **EB**. Note that 1kB is equal to 1024 bytes, 1MB is equal to 1024kB, and so on.

.. _zend.file.transfer.validators.size.example:

.. rubric:: Using the Size Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Limit the size of a file to 40000 bytes
   $upload->addValidator('Size', false, 40000);

   // Limit the size a given file to maximum 4MB and mimimum 10kB
   // Also returns the plain number in case of an error
   // instead of a user-friendly number
   $upload->addValidator('Size',
                         false,
                         array('min' => '10kB',
                               'max' => '4MB',
                               'bytestring' => false));

.. _zend.file.transfer.validators.wordcount:

WordCount Validator
-------------------

The ``WordCount`` validator checks for the number of words within provided files. It supports the following option keys:

- ``min``: Sets the minimum number of words to be found.

- ``max``: Sets the maximum number of words to be found.

If you initiate this validator with a string or integer, the value will be used as ``max``. Or you can also use the methods ``setMin()`` and ``setMax()`` to set both options afterwards and ``getMin()`` and ``getMax()`` to retrieve the actual set values.

.. _zend.file.transfer.validators.wordcount.example:

.. rubric:: Using the WordCount Validator

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Limit the amount of words within files to maximum 2000
   $upload->addValidator('WordCount', false, 2000);

   // Limit the amount of words within files to maximum 5000 and minimum 1000 words
   $upload->addValidator('WordCount', false, array('min' => 1000, 'max' => 5000));



.. _`hash_algos method`: http://php.net/hash_algos
.. _`php.net site`: http://php.net
