.. _zend.validator.file.hash:

Hash
----

``Zend\Validator\File\Hash`` allows you to validate if a given file's hashed contents
matches the supplied hash(es) and algorithm(s).

.. note::

   This validator requires the `Hash extension`_ from PHP. A list of
   supported hash algorithms can be found with the `hash_algos() function`_.

.. _`Hash extension`: http://php.net/manual/en/book.hash.php
.. _`hash_algos() function`: http://php.net/manual/en/function.hash-algos.php


.. _zend.validator.file.hash.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following set of options are supported:

- **hash** ``(string)``
   Hash to test the file against.
- **algorithm** ``(string) default: "crc32"``
   Algorithm to use for the hashing validation.


.. _zend.validator.file.hash.usage:

Usage Examples
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // Does file have the given hash?
   $validator = new \Zend\Validator\File\Hash('3b3652f', 'crc32');

   // Or, check file against multiple hashes
   $validator = new \Zend\Validator\File\Hash(array('3b3652f', 'e612b69'), 'crc32');

   // Perform validation with file path
   if ($validator->isValid('./myfile.txt')) {
      // file is valid
   }


.. _zend.validator.file.hash.methods:

Public Methods
^^^^^^^^^^^^^^

.. function:: getHash()
   :noindex:

   Returns the current set of hashes.

   :rtype: ``array``

.. function:: addHash(string|array $options)
   :noindex:

   Adds a hash for one or multiple files to the internal set of hashes.

   :param $options: See :ref:`Supported Options <zend.validator.file.hash.options>` section for more information.

.. function:: setHash(string|array $options)
   :noindex:

   Sets a hash for one or multiple files. Removes any previously set hashes.

   :param $options: See :ref:`Supported Options <zend.validator.file.hash.options>` section for more information.

