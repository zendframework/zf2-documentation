.. _zend.progress-bar.upload.upload-progress:

Upload Progress Handler
^^^^^^^^^^^^^^^^^^^^^^^

The ``Zend\ProgressBar\Upload\UploadProgress`` handler uses the `PECL Uploadprogress extension`_
for tracking upload progress.

.. note::

   The `PECL Uploadprogress extension`_ is required.


This handler is best used with the :ref:`FormFileUploadProgress <zend.form.view.helper.form-file-upload-progress>`
view helper, to provide a hidden element with the upload progress identifier.


.. _`PECL Uploadprogress extension`: http://pecl.php.net/package/uploadprogress
