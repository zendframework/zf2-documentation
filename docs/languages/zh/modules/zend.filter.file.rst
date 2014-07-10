.. _zend.filter.file:

File Filter Classes
===================

Zend Framework comes with a set of classes for filtering file contents as well as performing other actions, such
as file renaming.

.. note::

   All of the File Filter Classes' ``filter()`` methods support both a file path string *or*
   a ``$_FILES`` array as the supplied argument.
   When a ``$_FILES`` array is passed in, the ``tmp_name`` is used for the file path.

.. include:: zend.filter.file.decrypt.rst
.. include:: zend.filter.file.encrypt.rst
.. include:: zend.filter.file.lowercase.rst
.. include:: zend.filter.file.rename.rst
.. include:: zend.filter.file.rename-upload.rst
.. include:: zend.filter.file.uppercase.rst


