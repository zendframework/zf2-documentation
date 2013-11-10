.. _zend.validator.file.sha1:

Sha1
----

``Zend\Validator\File\Sha1`` allows you to validate if a given file's hashed contents
matches the supplied sha1 hash(es).
It is subclassed from the :ref:`Hash validator <zend.validator.file.hash>`
to provide a convenient validator that only supports the ``sha1`` algorithm.

.. note::

   This validator requires the `Hash extension`_ from PHP with the ``sha1`` algorithm.

.. _`Hash extension`: http://php.net/manual/en/book.hash.php


.. _zend.validator.file.sha1.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following set of options are supported:

- **hash** ``(string)``
   Hash to test the file against.


.. _zend.validator.file.sha1.usage:

Usage Examples
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // Does file have the given hash?
   $validator = new \Zend\Validator\File\Sha1('3b3652f336522365223');

   // Or, check file against multiple hashes
   $validator = new \Zend\Validator\File\Sha1(array(
       '3b3652f336522365223', 'eb3365f3365ddc65365'
   ));

   // Perform validation with file path
   if ($validator->isValid('./myfile.txt')) {
       // file is valid
   }


.. _zend.validator.file.sha1.methods:

Public Methods
^^^^^^^^^^^^^^

.. function:: getSha1()
   :noindex:

   Returns the current set of sha1 hashes.

   :rtype: ``array``

.. function:: addSha1(string|array $options)
   :noindex:

   Adds a sha1 hash for one or multiple files to the internal set of hashes.

   :param $options: See :ref:`Supported Options <zend.validator.file.sha1.options>` section for more information.

.. function:: setSha1(string|array $options)
   :noindex:

   Sets a sha1 hash for one or multiple files. Removes any previously set hashes.

   :param $options: See :ref:`Supported Options <zend.validator.file.sha1.options>` section for more information.

