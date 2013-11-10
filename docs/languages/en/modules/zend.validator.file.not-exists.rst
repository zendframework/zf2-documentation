.. _zend.validator.file.not-exists:

NotExists
---------

``Zend\Validator\File\NotExists`` checks for the existence of files in specified directories.

This validator is inversely related to the :ref:`Exists validator <zend.validator.file.exists>`.

.. _zend.validator.file.not-exists.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following set of options are supported:

- **directory** ``(string|array)``
   Comma-delimited string (or array) of directories.

.. _zend.validator.file.not-exists.usage:

Usage Examples
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // Only allow files that do not exist in ~either~ directories
   $validator = new \Zend\Validator\File\NotExists('/tmp,/var/tmp');

   // ...or with array notation
   $validator = new \Zend\Validator\File\NotExists(array('/tmp', '/var/tmp'));

   // Perform validation
   if ($validator->isValid('/home/myfile.txt')) {
       // file is valid
   }


.. note::

   This validator checks whether the specified file does not exist in **any** of the given
   directories. The validation will fail if the file exists in one (or more)
   of the given directories.