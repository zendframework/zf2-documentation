.. _zend.validator.file.size:

Size
----

``Zend\Validator\File\Size`` checks for the size of a file.

.. _zend.validator.file.size.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following set of options are supported:

- **min** ``(integer|string) default: null``
- **max** ``(integer|string) default: null``
   The `integer` number of bytes, or a `string` in SI notation (ie. 1kB, 2MB, 0.2GB).

   The accepted SI notation units are: kB, MB, GB, TB, PB, and EB. All sizes are converted
   using 1024 as the base value (ie. 1kB == 1024 bytes, 1MB == 1024kB).
- **useByteString** ``(boolean) default: true``
   Display error messages with size in user-friendly number or with the plain byte size.


.. _zend.validator.file.size.usage:

Usage Examples
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // Limit the file size to 40000 bytes
   $validator = new \Zend\Validator\File\Size(40000);

   // Limit the file size to between 10kB and 4MB
   $validator = new \Zend\Validator\File\Size(array(
       'min' => '10kB', 'max' => '4MB'
   ));

   // Perform validation with file path
   if ($validator->isValid('./myfile.txt')) {
       // file is valid
   }

