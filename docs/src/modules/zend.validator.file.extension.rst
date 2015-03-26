.. _zend.validator.file.extension:

Extension
---------

``Zend\Validator\File\Extension`` checks the extension of files.
It will assert ``true`` when a given file has one the a defined extensions.

This validator is inversely related to the :ref:`ExcludeExtension validator <zend.validator.file.exclude-extension>`.

.. _zend.validator.file.extension.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following set of options are supported:

- **extension** ``(string|array)``
   Comma-delimited string (or array) of extensions to test against.
- **case** ``(boolean) default: "false"``
   Should comparison of extensions be case-sensitive?

.. _zend.validator.file.extension.usage:

Usage Examples
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // Allow files with 'php' or 'exe' extensions
   $validator = new \Zend\Validator\File\Extension('php,exe');

   // ...or with array notation
   $validator = new \Zend\Validator\File\Extension(array('php', 'exe'));

   // Test with case-sensitivity on
   $validator = new \Zend\Validator\File\Extension(array('php', 'exe'), true);

   // Perform validation
   if ($validator->isValid('./myfile.php')) {
       // file is valid
   }


.. _zend.validator.file.extension.methods:

Public Methods
^^^^^^^^^^^^^^

.. function:: addExtension(string|array $options)
   :noindex:

   Adds extension(s) via a comma-delimited string or an array.

