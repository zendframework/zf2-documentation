.. _zend.validator.file.crc32:

Crc32
-----

``Zend\Validator\File\Crc32`` allows you to validate if a given file's hashed contents
matches the supplied crc32 hash(es).
It is subclassed from the :ref:`Hash validator <zend.validator.file.hash>`
to provide a convenient validator that only supports the ``crc32`` algorithm.

.. note::

   This validator requires the `Hash extension`_ from PHP with the ``crc32`` algorithm.

.. _`Hash extension`: http://php.net/manual/en/book.hash.php


.. _zend.validator.file.crc32.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following set of options are supported:

- **hash** ``(string)``
   Hash to test the file against.


.. _zend.validator.file.crc32.usage:

Usage Examples
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // Does file have the given hash?
   $validator = new \Zend\Validator\File\Crc32('3b3652f');

   // Or, check file against multiple hashes
   $validator = new \Zend\Validator\File\Crc32(array('3b3652f', 'e612b69'));

   // Perform validation with file path
   if ($validator->isValid('./myfile.txt')) {
       // file is valid
   }


.. _zend.validator.file.crc32.methods:

Public Methods
^^^^^^^^^^^^^^

.. function:: getCrc32()
   :noindex:

   Returns the current set of crc32 hashes.

   :rtype: ``array``

.. function:: addCrc32(string|array $options)
   :noindex:

   Adds a crc32 hash for one or multiple files to the internal set of hashes.

   :param $options: See :ref:`Supported Options <zend.validator.file.crc32.options>` section for more information.

.. function:: setCrc32(string|array $options)
   :noindex:

   Sets a crc32 hash for one or multiple files. Removes any previously set hashes.

   :param $options: See :ref:`Supported Options <zend.validator.file.crc32.options>` section for more information.

