.. _zend.progress-bar.upload.apc-progress:

APC Progress Handler
^^^^^^^^^^^^^^^^^^^^

The ``Zend\ProgressBar\Upload\ApcProgress`` handler uses the `APC extension`_
for tracking upload progress.

.. note::

   The `APC extension`_ is required.

This handler is best used with the :ref:`FormFileApcProgress <zend.form.view.helper.form-file-apc-progress>`
view helper, to provide a hidden element with the upload progress identifier.


.. _`APC extension`: http://php.net/manual/en/book.apc.php