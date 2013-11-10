.. _zend.validator.file.mime-type:

MimeType
--------

``Zend\Validator\File\MimeType`` checks the MIME type of files.
It will assert ``true`` when a given file has one the a defined MIME types.

This validator is inversely related to the :ref:`ExcludeMimeType validator <zend.validator.file.exclude-mime-type>`.

.. note::

   This component will use the ``FileInfo`` extension if it is available. If it's not,
   it will degrade to the ``mime_content_type()`` function. And if the function call
   fails it will use the MIME type which is given by HTTP.
   You should be aware of possible security problems when you do not have
   ``FileInfo`` or ``mime_content_type()`` available.
   The MIME type given by HTTP is not secure and can be easily manipulated.

.. _zend.validator.file.mime-type.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following set of options are supported:

- **mimeType** ``(string|array)``
   Comma-delimited string (or array) of MIME types to test against.
- **magicFile** ``(string|null) default: "MAGIC" constant``
   Specify the location of the magicfile to use.
   By default the ``MAGIC`` constant value will be used.
- **enableHeaderCheck** ``(boolean) default: "false"``
   Check the HTTP Information for the file type when the fileInfo or
   mimeMagic extensions can not be found.

.. _zend.validator.file.mime-type.usage:

Usage Examples
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // Only allow 'gif' or 'jpg' files
   $validator = new \Zend\Validator\File\MimeType('image/gif,image/jpg');

   // ...or with array notation
   $validator = new \Zend\Validator\File\MimeType(array('image/gif', 'image/jpg'));

   // ...or restrict an entire group of types
   $validator = new \Zend\Validator\File\MimeType(array('image', 'audio'));

   // Use a different magicFile
   $validator = new \Zend\Validator\File\MimeType(array(
       'image/gif', 'image/jpg',
       'magicFile' => '/path/to/magicfile.mgx'
   ));

   // Use the HTTP information for the file type
   $validator = new \Zend\Validator\File\MimeType(array(
       'image/gif', 'image/jpg',
       'enableHeaderCheck' => true
   ));

   // Perform validation
   if ($validator->isValid('./myfile.jpg')) {
       // file is valid
   }

.. warning::

   Allowing "groups" of MIME types will accept **all** members of this group even
   if your application does not support them. When you allow 'image' you also
   allow 'image/xpixmap' and 'image/vasa' which could be problematic.


