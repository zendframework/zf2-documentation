.. _zend.form.view.helper.form-file-upload-progress:

FormFileUploadProgress
^^^^^^^^^^^^^^^^^^^^^^

The ``FormFileUploadProgress`` view helper can be used to render a ``<input type="hidden" ...>`` which can be used by
the PECL uploadprogress extension. Unlike other Form view helpers, the ``FormFileUploadProgress`` helper does not
accept a Form Element as a parameter.

An ``id`` attribute with a value of ``"progress_key"`` will automatically be added.

.. warning::

   The view helper **must** be rendered *before* the file input in the form,
   or upload progress will not work correctly.

Best used with the :ref:`Zend\\ProgressBar\\Upload\\UploadProgress <zend.progress-bar.upload.upload-progress>` handler.

See the `PECL uploadprogress extension`_ for more information.

``FormFileUploadProgress`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input>`.

.. _zend.form.view.helper.form-file-upload-progress.usage:

Basic usage:

.. code-block:: php
   :linenos:

   // Within your view...

   echo $this->formFileSessionProgress();
   // <input type="hidden" id="progress_key" name="UPLOAD_IDENTIFIER" value="12345abcde">


.. _`PECL uploadprogress extension`: http://pecl.php.net/package/uploadprogress