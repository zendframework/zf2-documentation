.. _zend.validator.file.md5:

Md5
---

``Zend\Validator\File\Md5`` allows you to validate if a given file's hashed contents
matches the supplied md5 hash(es).
It is subclassed from the :ref:`Hash validator <zend.validator.file.hash>`
to provide a convenient validator that only supports the ``md5`` algorithm.

.. note::

   This validator requires the `Hash extension`_ from PHP with the ``md5`` algorithm.

.. _`Hash extension`: http://php.net/manual/en/book.hash.php


.. _zend.validator.file.md5.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following set of options are supported:

- **hash** ``(string)``
   Hash to test the file against.


.. _zend.validator.file.md5.usage:

Usage Examples
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // Does file have the given hash?
   $validator = new \Zend\Validator\File\Md5('3b3652f336522365223');

   // Or, check file against multiple hashes
   $validator = new \Zend\Validator\File\Md5(array(
       '3b3652f336522365223', 'eb3365f3365ddc65365'
   ));

   // Perform validation with file path
   if ($validator->isValid('./myfile.txt')) {
       // file is valid
   }


.. _zend.validator.file.md5.methods:

Public Methods
^^^^^^^^^^^^^^

.. function:: getMd5()
   :noindex:

   Returns the current set of md5 hashes.

   :rtype: ``array``

.. function:: addMd5(string|array $options)
   :noindex:

   Adds a md5 hash for one or multiple files to the internal set of hashes.

   :param $options: See :ref:`Supported Options <zend.validator.file.md5.options>` section for more information.

.. function:: setMd5(string|array $options)
   :noindex:

   Sets a md5 hash for one or multiple files. Removes any previously set hashes.

   :param $options: See :ref:`Supported Options <zend.validator.file.md5.options>` section for more information.

