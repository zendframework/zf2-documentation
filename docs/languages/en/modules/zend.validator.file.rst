.. _zend.validator.file:

File Validation Classes
=======================

Zend Framework comes with a set of classes for validating files,
such as file size validation and CRC checking.

.. note::

   All of the File validators' ``filter()`` methods support both a file path ``string`` *or*
   a ``$_FILES`` array as the supplied argument.
   When a ``$_FILES`` array is passed in, the ``tmp_name`` is used for the file path.

.. include:: zend.validator.file.crc32.rst
.. include:: zend.validator.file.exclude-extension.rst
.. include:: zend.validator.file.exclude-mime-type.rst
.. include:: zend.validator.file.exists.rst
.. include:: zend.validator.file.extension.rst
.. include:: zend.validator.file.hash.rst
.. include:: zend.validator.file.image-size.rst
.. include:: zend.validator.file.is-compressed.rst
.. include:: zend.validator.file.is-image.rst
.. include:: zend.validator.file.md5.rst
.. include:: zend.validator.file.mime-type.rst
.. include:: zend.validator.file.not-exists.rst
.. include:: zend.validator.file.sha1.rst
.. include:: zend.validator.file.size.rst
.. include:: zend.validator.file.upload-file.rst
.. include:: zend.validator.file.word-count.rst


