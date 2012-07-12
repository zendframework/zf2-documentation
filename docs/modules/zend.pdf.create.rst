
Creating and Loading PDF Documents
==================================

The ``Zend_Pdf`` class represents *PDF* documents and provides document-level operations.

To create a new document, a new ``Zend_Pdf`` object should first be created.

``Zend_Pdf`` class also provides two static methods to load an existing *PDF* document. These are the ``Zend_Pdf::load()`` and ``Zend_Pdf::parse()`` methods. Both of them return ``Zend_Pdf`` objects as a result or throw an exception if an error occurs.

The *PDF* file format supports incremental document update. Thus each time a document is updated, then a new revision of the document is created. ``Zend_Pdf`` component supports the retrieval of a specified revision.

A revision can be specified as a second parameter to the ``Zend_Pdf::load()`` and ``Zend_Pdf::parse()`` methods or requested by calling the ``Zend_Pdf::rollback()`` method.
``Zend_Pdf::rollback()`` method must be invoked before any changes are applied to the document, otherwise the behavior is not defined.
call.


