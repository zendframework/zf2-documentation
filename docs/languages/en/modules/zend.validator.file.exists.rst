.. _zend.validator.file.exists:

Exists
------

``Zend\Validator\File\Exists`` checks for the existence of files in specified directories.

This validator is inversely related to the :ref:`NotExists validator <zend.validator.file.not-exists>`.

.. _zend.validator.file.exists.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following set of options are supported:

- **directory** ``(string|array)``
   Comma-delimited string (or array) of directories.

.. _zend.validator.file.exists.usage:

Usage Examples
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // Only allow files that exist in ~both~ directories
   $validator = new \Zend\Validator\File\Exists('/tmp,/var/tmp');

   // ...or with array notation
   $validator = new \Zend\Validator\File\Exists(array('/tmp', '/var/tmp'));

   // Perform validation
   if ($validator->isValid('/tmp/myfile.txt')) {
       // file is valid
   }


.. note::

   This validator checks whether the specified file exists in **all** of the given
   directories. The validation will fail if the file does not exist in one (or more)
   of the given directories.